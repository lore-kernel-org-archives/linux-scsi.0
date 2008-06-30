From: "Zhao Forrest" <forrest.zhao@gmail.com>
Subject: Re: Should a block device enforce block atomicity?
Date: Mon, 30 Jun 2008 16:47:23 +0800
Message-ID: <ac8af0be0806300147i1970a6f7mb705c0ce590326@mail.gmail.com>
References: <ce513bcc0806292351t7f4ad933l920112381f4ebb4@mail.gmail.com>
	 <20080630065525.GI20826@kernel.dk>
	 <ce513bcc0806300058mbe0f15eya07fafbb9ba4a56@mail.gmail.com>
	 <48689857.1050908@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:36297 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYF3IrY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2008 04:47:24 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1562413rvb.1
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jun 2008 01:47:23 -0700 (PDT)
In-Reply-To: <48689857.1050908@panasas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Erez Zilber <erezzi.list@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>
> Don't forget that all IO requests are queued on the device. With a
> modern HW and disk you usually have NCQ and most drives will throw
> away write request to the same sector if they see a later write to
> the same sector in the queue.
>
> That said. There is nothing wrong with writing again and again to
> the same sector on disk. File/record locking is done at the FileSystem
> level. An application that wants exclusive write need to open the file
> that way. Other wise it could even be written from another machine not
> even another thread.
>
> What is it you are concerned with?
>
I happen to read the email and have a question, that may not be Erez's
real question :)
Let's suppose the following example:
1 pdflush find a dirty inode and decides to flush a set of dirty pages
to harddrive
2 while this set of dirty pages is being committed to
harddrive(dma_mapping is done, but dirty pages are not really written
to disk media), application/FS is trying to update some pages in this
set of dirty pages.

Then what happens? Will application be put into sleep until page
flushing to disk media is done?

Thanks,
Forrest
