From: "Kamaljit Singh" <Kamaljit.Singh@pmcs.com>
Subject: RE: Incorrect LBA Returned from scsi_get_lba() and blk_rq_pos() (Possible DIF Impact)
Date: Tue, 13 Aug 2013 14:43:36 -0700
Message-ID: <405BE55790F03349A85344435F25B01C07A85C02@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
References: <340C71CD25A7EB49BFA81AE8C83926671B2EFFD6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <yq1halhmmjr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:41180 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759160Ab3HMVnj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Aug 2013 17:43:39 -0400
Content-class: urn:content-classes:message
In-Reply-To: <yq1halhmmjr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Sami Waheed <Sami.Waheed@pmcs.com>
Cc: linux-scsi@vger.kernel.org

Hi Martin,

Did you get a chance to merge your changes into mainline?  I'm using
3.10.4 and am still seeing this issue.

Thanks,

Kamaljit


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Martin K.
Petersen
Sent: Tuesday, February 12, 2013 10:09 AM
To: Sami Waheed
Cc: linux-scsi@vger.kernel.org
Subject: Re: Incorrect LBA Returned from scsi_get_lba() and blk_rq_pos()
(Possible DIF Impact)

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
