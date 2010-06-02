From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fix scsi_get_lba helper function for pc command
Date: Wed, 02 Jun 2010 09:13:51 -0400
Message-ID: <yq1bpbtbmr4.fsf@sermon.lab.mkp.net>
References: <4C0612CC.6050602@panasas.com>
	<20100602173925H.fujita.tomonori@lab.ntt.co.jp>
	<4C061C41.2010104@panasas.com>
	<20100602180515J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:22230 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab0FBNOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2010 09:14:47 -0400
In-Reply-To: <20100602180515J.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Wed, 2 Jun 2010 18:05:35 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, James.Bottomley@suse.de, jaxboe@fusionio.com, linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com

>>>>> "Tomo" == FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:

>> scsi LLDs can be pass-through for disks, as well as lots of other
>> type of devices. They should not assume the role of a disk. The use
>> of blk_rq_pos() at LLDs is probably wrong in the first place. Unless
>> it is some kind of scsi emulation driver like scsi_debug.

Tomo> Not only scsi_debug. Have you seen how scsi_get_lba() is used?
Tomo> LLDs sometime needs to know lba in scsi commands.

scsi_get_lba() is used by DIX/DIF-aware HBA drivers to get the first LBA
for use in reference tag verification/preparation.

This code path is only executed by the drivers if the command protection
mode is > SCSI_PROT_NORMAL which can only be true for a READ/WRITE
command.  I don't see any drivers using it for other purposes.

I have some changes in the pipeline to better support protection
interleaving in DIF Type 2.  I was contemplating renaming scsi_get_lba()
to scsi_get_reference_tag() or something to that effect.

As as for the reason scsi_get_lba() looks at the start sector directly:
I was simply trying to avoid growing struct scsi_cmnd.  The "correct"
thing would have been to add an initial reference tag field to scsi_cmnd
and have that be filled out by sd_prot_op().

-- 
Martin K. Petersen	Oracle Linux Engineering
