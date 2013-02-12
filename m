From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Incorrect LBA Returned from scsi_get_lba() and blk_rq_pos() (Possible DIF Impact)
Date: Tue, 12 Feb 2013 13:09:28 -0500
Message-ID: <yq1halhmmjr.fsf@sermon.lab.mkp.net>
References: <340C71CD25A7EB49BFA81AE8C83926671B2EFFD6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40755 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320Ab3BLSJT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2013 13:09:19 -0500
In-Reply-To: <340C71CD25A7EB49BFA81AE8C83926671B2EFFD6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
	(Sami Waheed's message of "Tue, 12 Feb 2013 09:31:17 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sami Waheed <Sami.Waheed@pmcs.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Sami" == Sami Waheed <Sami.Waheed@pmcs.com> writes:

Sami> I am testing a SCSI/SAS target with a block size of 4K.  I noticed
Sami> that scsi_get_lba which calls blk_rq_pos is returning an incorrect
Sami> LBA.  The returned LBA value is 8x the actual LBA specified in the
Sami> CDB:

The block layer always uses 512-byte sectors internally, regardless of
the logical block size of the actual disk.


Sami> I, also, noticed that several drivers use the scsi_get_lba inline
Sami> in scsi_cmnd.h to set/check ref tag for DIF.  On a 4K device, this
Sami> is resulting in an incorrect ref tag.

I have some patches in the pipeline that fixes this. They also add
support for protection intervals different from the logical block size.

-- 
Martin K. Petersen	Oracle Linux Engineering
