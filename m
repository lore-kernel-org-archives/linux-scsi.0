From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: configurable discard parameters
Date: Tue, 23 Jun 2015 11:36:15 -0400
Message-ID: <yq1bng65te8.fsf@sermon.lab.mkp.net>
References: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
	<yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
	<CAGnHSEk+=r1CwQaGd9n4nUm3_e3O7GOL_iFDeJTuNyaSq9WFYg@mail.gmail.com>
	<CAGnHSEnevg=advtq=CW2FvV5b93GX3kNwrFu587O2V7hf1J8hA@mail.gmail.com>
	<CAGnHSEnBvgWKw6g=c4vpCNEfpdh_45orz5JcSmfM7jadxjpxzQ@mail.gmail.com>
	<CAGnHSEnLACL6XisaFn3axRETAD3CjOa7fGrHKR7s6GOroQXkew@mail.gmail.com>
	<yq1616f796w.fsf@sermon.lab.mkp.net>
	<CAGnHSEn4EPC_RHTJXtvFC8dj8L+aDd_pRvSsDWNaqHz3Tdxj5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44119 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbbFWPgS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2015 11:36:18 -0400
In-Reply-To: <CAGnHSEn4EPC_RHTJXtvFC8dj8L+aDd_pRvSsDWNaqHz3Tdxj5w@mail.gmail.com>
	(Tom Yan's message of "Tue, 23 Jun 2015 22:16:22 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom> I don't know whether the USB bridging or the way hdparm does TRIM
Tom> matters, but it seems that some devices can't really handle limit
Tom> like 0x3fffc0 blocks.

The 0x3fffc0 limit is for SATA devices connected through Linux' libata
SCSI ATA translation. This number corresponds to the biggest range we
can discard while maintaining a 1:1 mapping between the SCSI command and
the ATA ditto.

If you connect the SATA drive to a USB/UAS bridge you are entirely at
the bridge's whim when it comes to translation of WRITE SAME(10/16) w/
UNMAP or the UNMAP command to DSM TRIM. libata is not involved and
neither is the 0x3fffc0 limit (although chances are that the drive has
the same limit internally). Even when using hdparm the bridge device
still needs to correctly translate the ATA PASSTHROUGH commands.

Tom> So I still think that the kernel should allow users to configure
Tom> limits that can make libata send reliable ATA TRIM commands.

You haven't given us any reason to. We are not aware of any ATA drives
that put constraints on the range block count.

Again, if you want to help please focus on your bridge devices and what,
if anything, can be done to uniquely identify them and override any
incorrect values they might report to the SCSI stack. Up to and
including us disabling discard entirely on these devices if their
translation isn't verifiable and bullet proof.

-- 
Martin K. Petersen	Oracle Linux Engineering
