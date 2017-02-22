From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5] sd: Check for unaligned partial completion
Date: Tue, 21 Feb 2017 23:24:52 -0500
Message-ID: <yq1ino226p7.fsf@oracle.com>
References: <20170217000130.22471-1-damien.lemoal@wdc.com>
        <yq11sus5l0j.fsf@oracle.com>
        <1D08B61A9CF0974AA09887BE32D889DA0AB16B@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
        <aa814adb-b31a-432a-5128-86dcd53162e6@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43075 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752717AbdBVEZP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2017 23:25:15 -0500
In-Reply-To: <aa814adb-b31a-432a-5128-86dcd53162e6@wdc.com> (Damien Le Moal's
        message of "Tue, 21 Feb 2017 16:47:58 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

>>>>> "Damien" == Damien Le Moal <damien.lemoal@wdc.com> writes:

Damien,

Damien> I think we would still need the check for REQ_TYPE_FS to avoid
Damien> interfering with SG_IO commands. As for the "medium access
Damien> command" test, I am not sure if the block layer is the right
Damien> place to define that since a request operation may map to
Damien> different commands depending on the device type

Yeah, we should put that logic in sd.c since that's the entity preparing
the commands.

Damien> Which approach do you prefer ? Keeping everything contained to
Damien> mpt3sas (so basically just fixing the problematic patch), or
Damien> cleaning up everything with sd_completed_bytes rewrite ?

I was originally in favor of just patching mpt3sas since it's clearly
broken (a disk can't write a partial sector). But I don't think a device
driver should know how to special case REPORT ZONES or similar. That's
clearly SBC/ZBC territory, so I prefer the sd_completed_bytes()
approach.

-- 
Martin K. Petersen	Oracle Linux Engineering
