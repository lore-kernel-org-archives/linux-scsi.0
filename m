From: Brett Dennis <brettldennis@gmail.com>
Subject: Length and alignment in scsi_execute_async and blk_rq_map_user
Date: Tue, 29 Jun 2010 14:23:11 -0700
Message-ID: <AANLkTim3BamYYWtoVAhSvJDmD9-37BPcpthZIbI-FJ8y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53958 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab0F2VXN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jun 2010 17:23:13 -0400
Received: by fxm14 with SMTP id 14so43105fxm.19
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2010 14:23:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

Apologies for posting twice (messed up on the subject line of the first post...)

In kernel 2.6.26, the implementation of __blk_rq_map_user changed and
now includes a call to bio_copy_user:

uaddr = (unsigned long) ubuf;
alignment = queue_dma_alignment(q) | q->dma_pad_mask;
if (!(uaddr & alignment) && !(len & alignment))

     bio = bio_map_user(q, NULL, uaddr, len, reading);

else

     bio = bio_copy_user(q, uaddr, len, reading);


bio_copy_user uses the HBA's scatter-gather pages for the copy.  The
problem I face is that if the data is not aligned properly, or the len
parameter does not divide properly, and the transfer is greater than
the number of scatter-gather pages, the IO operation will fail.  I am
considering increasing the size of my data buffer to meet the
length-alignment requirement and changing the 'len' parameter passed
into blk_rq_map_user to include a larger size than my CDB transfer
length.  This way it will hit the bio_map_user branch instead of the
bio_copy_user branch and I won't have to worry about insufficient
sg-pages.  The tape device should still honor the CDB write length, so
unless there are other limitations imposed by the Linux kernel or SCSI
subsystem, I think this is a workable solution.  Does anyone in this
list know if there are requirements against sending a larger buffer
length than CDB transfer length?

Thanks in advance.

Brett Dennis
IBM tape device driver developer
