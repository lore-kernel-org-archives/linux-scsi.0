From: Alexander Sabourenkov <screwdriver@lxnt.info>
Subject: Re: Short INQUIRY return
Date: Thu, 25 Oct 2007 22:54:08 +0400
Message-ID: <4720E650.9070304@lxnt.info>
References: <4720940C.9040802@lxnt.info> <4720AB30.5080003@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lxnt.info ([217.23.143.142]:64697 "EHLO mail.lxnt.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbXJYTDm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 15:03:42 -0400
In-Reply-To: <4720AB30.5080003@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> 
> Just at the top of my head without looking at the code at all. I would
> say the bigest change would be the use of use_sg != 0 for all commands
> in Later kernels. (k>=2.6.17)
>
> Look for and around the scsi_cmnd->request_buffer usage. It used to be
> that for commands like INQUIRY it points to a linear char pointer.
> Today it will always point to a scatterlist array and use_sg is the sg count
> of that array. (Usually ==1 in the INQUIRY case)

That was it. Driver blindly wrote whatever number of bytes it felt like
straight to the pointer.

I lifted some code from scsi_debug.c:

sgpnt = (struct scatterlist *)SCpnt->request_buffer;
kaddr = (unsigned char *)kmap_atomic(sgpnt->page, KM_USER0);
buff = kaddr + sgpnt->offset;
bufflen = sgpnt->length;

buf[...] = ...

kunmap_atomic(kaddr, KM_USER0);

which seemed to do the trick.
(is this the proper way or it works by some miracle only?)

I tried
dd if=/dev/sdc1 of=/dev/null bs=1048576 count=1024
and the kernel crashed. Not surprising.

Now up-hacking MODE_SENSE support based on drivers/usb/storage/datafab.c

> Just a shot in the dark

Thank you very much.

> (Where is the code for that driver?)

I found it at promise.com:
http://www.promise.com/support/download/download2_eng.asp?productId=139&category=driver&os=100&go=GO


My current version is at http://lxnt.info/tx4/023/
(modified files only)

The code in cam subdirectory is quite clean - I suspect it is some
OS-independent part that is used in Windows and BIOS too. I did not
touch it.


-- 

./lxnt
