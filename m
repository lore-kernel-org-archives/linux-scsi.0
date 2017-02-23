From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH v5] sd: Check for unaligned partial completion
Date: Thu, 23 Feb 2017 13:44:45 +0900
Message-ID: <6af14d02-a591-1069-3c2f-b573cda26b46@wdc.com>
References: <20170217000130.22471-1-damien.lemoal@wdc.com>
 <yq11sus5l0j.fsf@oracle.com>
 <1D08B61A9CF0974AA09887BE32D889DA0AB16B@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
 <aa814adb-b31a-432a-5128-86dcd53162e6@wdc.com> <yq1ino226p7.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:47742 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdBWFXP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2017 00:23:15 -0500
In-Reply-To: <yq1ino226p7.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>

Martin,

On 2/22/17 13:24, Martin K. Petersen wrote:
>>>>>> "Damien" == Damien Le Moal <damien.lemoal@wdc.com> writes:
> 
> Damien,
> 
> Damien> I think we would still need the check for REQ_TYPE_FS to avoid
> Damien> interfering with SG_IO commands. As for the "medium access
> Damien> command" test, I am not sure if the block layer is the right
> Damien> place to define that since a request operation may map to
> Damien> different commands depending on the device type
> 
> Yeah, we should put that logic in sd.c since that's the entity preparing
> the commands.
> 
> Damien> Which approach do you prefer ? Keeping everything contained to
> Damien> mpt3sas (so basically just fixing the problematic patch), or
> Damien> cleaning up everything with sd_completed_bytes rewrite ?
> 
> I was originally in favor of just patching mpt3sas since it's clearly
> broken (a disk can't write a partial sector). But I don't think a device
> driver should know how to special case REPORT ZONES or similar. That's
> clearly SBC/ZBC territory, so I prefer the sd_completed_bytes()
> approach.

I do not see the problematic resid correction code in the mpt3sas driver
in 4.11/scsi-queue branch. Is this expected ? Did the mpt3sas driver
updates removed it ?

It looks like that branch is based on 4.10.0-rc2. The mpt3sas was
applied in rc7. Which branch should I use for basing the patches ?

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
