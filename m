From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: configurable discard parameters
Date: Mon, 22 Jun 2015 16:57:27 -0400
Message-ID: <yq1616f796w.fsf@sermon.lab.mkp.net>
References: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
	<yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
	<CAGnHSEk+=r1CwQaGd9n4nUm3_e3O7GOL_iFDeJTuNyaSq9WFYg@mail.gmail.com>
	<CAGnHSEnevg=advtq=CW2FvV5b93GX3kNwrFu587O2V7hf1J8hA@mail.gmail.com>
	<CAGnHSEnBvgWKw6g=c4vpCNEfpdh_45orz5JcSmfM7jadxjpxzQ@mail.gmail.com>
	<CAGnHSEnLACL6XisaFn3axRETAD3CjOa7fGrHKR7s6GOroQXkew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20607 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbbFVU5b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2015 16:57:31 -0400
In-Reply-To: <CAGnHSEnLACL6XisaFn3axRETAD3CjOa7fGrHKR7s6GOroQXkew@mail.gmail.com>
	(Tom Yan's message of "Mon, 22 Jun 2015 04:30:00 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom> However, I am curious what is the meaning of "Our current TRIM
Tom> payload is a single sector that can accommodate 64 * 65535 blocks
Tom> being unmapped. Report this value in the Block Limits Maximum Unmap
Tom> LBA count field." in the commit message. What does the value
Tom> actually mean/affect? Could it cause trouble to certain drives?

DSM Trim takes a payload of <block nr, block count> ranges. The block
count is constrained to 65535 by virtue of being 16 bits. We can fit 64
8-byte range descriptors in a single 512-byte sector payload. That's why
we set the limit for a single, contiguous discard request to
0x3fffc0. That results in 2GB minus change for a single command.

Tom> By the way I think I got the answer for my USB TRIM question.
Tom> Basically for USB->SATA drives the SATL is implemented in the
Tom> bridges, so it must be able to "SAT" one of the three SCSI unmap
Tom> methods to ATA TRIM, just like libata does,

Yep. I have set to see one that gets that right, though. There are even
many enterprise SAS/RAID controllers that don't support UNMAP-TRIM
translation.

Linux' libata was one of the first implementations of SCSI-ATA
translation for TRIM. Initially we bent the rules for UNMAP a bit. When
the standards caught up we switched to WRITE SAME.

Tom> So it actually tells. And I hope that the kernel wouldn't "falsify"
Tom> anything for devices which do provide some VPD(s). : \

SATA doesn't have VPDs.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
