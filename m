From: Brett Dennis <brettldennis@gmail.com>
Subject: linux-scsi@vger.kernel.org
Date: Tue, 29 Jun 2010 14:11:44 -0700
Message-ID: <AANLkTimuGSzRaVh8GCTTYQ6xKk69rlx5jwAmRygyyQgW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58618 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab0F2VLq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jun 2010 17:11:46 -0400
Received: by fxm14 with SMTP id 14so38179fxm.19
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2010 14:11:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

In kernel 2.6.26, the implementation of __blk_rq_map_user changed and
now includes a call to bio_copy_user:

uaddr = (unsigned long) ubuf;
alignment = queue_dma_alignment(q) | q->dma_pad_mask;
if (!(uaddr & alignment) && !(len & alignment))

bio = bio_map_user(q, NULL, uaddr, len, reading);

else

bio = bio_copy_user(q, uaddr, len, reading);


bio_copy_user uses the HBA's scatter-gather pages for the copy.  The
problem I face is that if the data size is not aligned properly, or
the len parameter does not divide properly, and the transfer is
greater than the number of scatter-gather pages, the IO operation will
fail.  I am considering increasing the size of my data buffer to meet
the length-alignment requirement and changing the 'len' parameter
passed into blk_rq_map_user to include a larger size than my CDB
transfer length.  The tape device should still honor the CDB write
length, so unless there are other limitations imposed by the Linux
kernel or SCSI subsystem, I think this is a workable solution.  Does
anyone in this list know if there is are requirements against sending
a larger buffer length than CDB transfer length?

Thanks in advance.

Brett Dennis
IBM tape device driver developer
