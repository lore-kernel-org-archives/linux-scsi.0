From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] scsi: fix scsi_get_lba helper function for pc command
Date: Thu, 3 Jun 2010 19:59:06 +0900
Message-ID: <20100603195838F.fujita.tomonori@lab.ntt.co.jp>
References: <4C061C41.2010104@panasas.com>
	<20100602180515J.fujita.tomonori@lab.ntt.co.jp>
	<yq1bpbtbmr4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:37061 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0FCK7b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jun 2010 06:59:31 -0400
In-Reply-To: <yq1bpbtbmr4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, James.Bottomley@suse.de, jaxboe@fusionio.com, linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com

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
