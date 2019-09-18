Return-Path: <SRS0=DHhn=XN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05B4C4CEC4
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Sep 2019 16:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE0D021907
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Sep 2019 16:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730808AbfIRQaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Sep 2019 12:30:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53732 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727109AbfIRQaS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Sep 2019 12:30:18 -0400
Received: (qmail 5907 invoked by uid 2102); 18 Sep 2019 12:30:17 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 18 Sep 2019 12:30:17 -0400
Date:   Wed, 18 Sep 2019 12:30:17 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Andrea Vai <andrea.vai@unipv.it>
cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Slow I/O on USB media after commit f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
In-Reply-To: <2196cc828e6d0651e6502a6dedeaeb14444cfe19.camel@unipv.it>
Message-ID: <Pine.LNX.4.44L0.1909181213141.1507-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 18 Sep 2019, Andrea Vai wrote:

> > Also, I wonder if the changing the size of the data transfers would
> > make any difference.  This is easy to try; just write "64" to
> > /sys/block/sd?/queue/max_sectors_kb (where the ? is the appropriate
> > drive letter) after the drive is plugged in but before the test
> > starts.
> 
> ok, so I duplicated the tests above for the "64" case (it was
> initially set as "120", if it is relevant to know), leading to 40 tests named as
> 
> bad.mon.out_50000000_64_TIMESTAMP
> bad.mon.out_50000000_non64_TIMESTAMP
> good.mon.out_50000000_64_TIMESTAMP
> good.mon.out_50000000_non64_TIMESTAMP
> 
> where "64" denotes the ones done with that value in max_sectors_kb,
> and "not64" the ones without it (as far as I can tell, it has been
> always "120").
> 
> So, we have 40 traces total. Each set of 10 trials is identified by
> a text file, which contains the output log of the test script (and the
> timestamps), also available in the download zipfile.
> 
> Just to summarize here the times, they are respectively (number
> expressed  in seconds):
> 
> BAD:
>   Logs: log_10trials_50MB_BAD_NonCanc_64.txt,
> log_10trials_50MB_BAD_NonCanc_non64.txt
>   64: 34, 34, 35, 39, 37, 32, 42, 44, 43, 40
>   not64: 61, 71, 59, 71, 62, 75, 62, 70, 62, 68
> GOOD:
>   Logs: log_10trials_50MB_GOOD_NonCanc_64.txt,
> log_10trials_50MB_GOOD_NonCanc_non64.txt
>   64: 34, 32, 35, 34, 35, 33, 34, 33, 33, 33
>   not64: 32, 30, 32, 31, 31, 30, 32, 30, 32, 31

The improvement from using "64" with the bad kernel is quite large.  
That alone would be a big help for you.

However, I did see what appears to be a very significant difference 
between the bad and good kernel traces.  It has to do with the order in 
which the blocks are accessed.

Here is an extract from one of the bad traces.  I have erased all the 
information except for the columns containing the block numbers to be 
written:

00019628 00
00019667 00
00019628 80
00019667 80
00019629 00
00019668 00
00019629 80
00019668 80

Here is the equivalent portion from one of the good traces:

00019628 00
00019628 80
00019629 00
00019629 80
0001962a 00
0001962a 80
0001962b 00
0001962b 80

Notice that under the good kernel, the block numbers increase
monotonically in a single sequence.  But under the bad kernel, the
block numbers are not monotonic -- it looks like there are two separate
threads each with its own strictly increasing sequence.

This is exactly the sort of difference one might expect to see from
the commit f664a3cc17b7 ("scsi: kill off the legacy IO path") you
identified as the cause of the problem.  With multiqueue I/O, it's not 
surprising to see multiple sequences of block numbers.

Add it's not at all surprising that a consumer-grade USB storage device 
might do a much worse job of handling non-sequential writes than 
sequential ones.

Which leads to a simple question for the SCSI or block-layer 
maintainers:  Is there a sysfs setting Andrea can tweak which will 
effectively restrict a particular disk device down to a single I/O
queue, forcing sequential access?

Alan Stern

