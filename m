From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: [PATCH] scsi: fix scsi_get_lba helper function for pc command
Date: Thu, 3 Jun 2010 16:33:56 +0530
Message-ID: <94500BE52867E04AB51827CFE16FC752028F715303@inbmail02.lsi.com>
References: <4C061C41.2010104@panasas.com>
	<20100602180515J.fujita.tomonori@lab.ntt.co.jp>
	<yq1bpbtbmr4.fsf@sermon.lab.mkp.net>
 <20100603195838F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:59844 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618Ab0FCLEJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jun 2010 07:04:09 -0400
In-Reply-To: <20100603195838F.fujita.tomonori@lab.ntt.co.jp>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "bharrosh@panasas.com" <bharrosh@panasas.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "jaxboe@fusionio.com" <jaxboe@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Actually the name scsi_get_lba is misleading that the LLDs can use this function to get the lba from a scsi_cmnd, irrespective of whether it is FS request or not. And I did use it for getting lba in my development driver and faced the problem with non-fs requests and raised the flag.

So IMHO it would be better either to fix the function to return proper value or name it to a different and restrict the usage only for DIF purpose.

Thanks
Sathya

-----Original Message-----
From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp] 
Sent: Thursday, June 03, 2010 4:29 PM
To: martin.petersen@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp; bharrosh@panasas.com; James.Bottomley@suse.de; jaxboe@fusionio.com; linux-scsi@vger.kernel.org; Prakash, Sathya
Subject: Re: [PATCH] scsi: fix scsi_get_lba helper function for pc command

On Wed, 02 Jun 2010 09:13:51 -0400
"Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> >>>>> "Tomo" == FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
> 
> >> scsi LLDs can be pass-through for disks, as well as lots of other
> >> type of devices. They should not assume the role of a disk. The use
> >> of blk_rq_pos() at LLDs is probably wrong in the first place. Unless
> >> it is some kind of scsi emulation driver like scsi_debug.
> 
> Tomo> Not only scsi_debug. Have you seen how scsi_get_lba() is used?
> Tomo> LLDs sometime needs to know lba in scsi commands.
> 
> scsi_get_lba() is used by DIX/DIF-aware HBA drivers to get the first LBA
> for use in reference tag verification/preparation.
> 
> This code path is only executed by the drivers if the command protection
> mode is > SCSI_PROT_NORMAL which can only be true for a READ/WRITE
> command.  I don't see any drivers using it for other purposes.

Yeah, however, seems that there are several drivers that get lba and
sector info from cdb.

Some does it for something like statistics, debug printk, etc.

Some does it to build hardware descriptor (e.g. 3w, megaraid, several
drivers in usb/storage/, etc).

So it would be useful to have scsi_get_lba() that always works, I think.
