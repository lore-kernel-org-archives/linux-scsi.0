From: Alireza Haghdoost <alireza@cs.umn.edu>
Subject: [SCSI] qla2xxx: Question about out-of-order SCSI command processing
Date: Mon, 2 Dec 2013 16:12:22 -0600
Message-ID: <CAB-428kfuWWGDhciGTAy6OCZr8ACBh52_iebBd8U4gwN0S7GPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.34.201]:55950 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab3LBXI4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Dec 2013 18:08:56 -0500
Received: from mail-vb0-f43.google.com (mail-vb0-f43.google.com [209.85.212.43])
	by mail.cs.umn.edu (Postfix) with ESMTPSA id C29F928B16B
	for <linux-scsi@vger.kernel.org>; Mon,  2 Dec 2013 16:13:03 -0600 (CST)
Received: by mail-vb0-f43.google.com with SMTP id q12so9037611vbe.16
        for <linux-scsi@vger.kernel.org>; Mon, 02 Dec 2013 14:13:03 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, Jerry Fredin <jerry.fredin@netapp.com>

Hi,

   We are working on a very high I/O throughput application and facing
with a challenge to send the I/O request to a SAN drive in-order. I
would appreciate if you can help us with an explanation about this
unexpected behavior of SCSI layer or qla2xxx driver.

The problem is that I/O requests arrive out-of-order to the SAN
controller if we submit those request with about 1us gap. In other
words, we observed if we issue I/O request very fast they arrive to
the SAN controller out-of-order. For example we observe I/O requests
dispatched from block layer request_queue with the ordering in the
lefts column and then arrive to the SAN controller with right column
order:

Dispatched                   Arrived to
>From Block Layer       SAN Controller
===========           ===========
LBA1                                LBA2
LBA2                                LBA3
LBA3                                LBA1
LBA4                                LBA4


We track the requests ordering from application layer down to the
block layer and it seems the block layer pull requests off the block
layer request_queue in-order. These requests also handed to the
low-level scsi driver (qla2xxx) in order. However, the ordering
changes when those requests arrive to the SAN controller.

There could be potentially multiple reasons for such a undesirable
behavior. Since the scsi commands are entered in the qla2xxx TCQ queue
in-order, I think the low-level scsi driver are not able to pull these
scsi commands off the TCQ in-order.

I was wondering if there is any way to tune the qla2xxx to perform
like a FIFO and does not change the ordering of the scsi commands ?

Note that we are using kernel 3.11 and libaio to perform async IO.
Moreover I don't see any out-of-order request arrives to the SAN
controller initially when the limited load on the host. However, I
start to saw out-of-order pattern when the /sys/block/sdX/inflight is
above 500. I don't think the qla2xxx is overloaded yet since it can
accommodate up to 2048 in_flight scsi command. Moreover, I don't see
out-of-order requests arrive to SAN if I submit the requests with 5us
gap. In this case, the number of in_flight scsi commands also can
shoot up to 2048 but the ordering is maintained.

I would appreciate if you can provide an explanation for such
undesirable behavior of scsi subsystem.


Thanks,
Alireza
