From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4] sd: Check for unaligned partial completion
Date: Wed, 15 Feb 2017 22:36:30 -0500
Message-ID: <yq1d1eibydd.fsf@oracle.com>
References: <20170215021230.11181-1-damien.lemoal@wdc.com>
        <1487176942.2666.1.camel@sandisk.com>
        <6f142c01-dc11-e86b-9100-d1e11c13f507@wdc.com>
        <1487207394.2666.14.camel@sandisk.com>
        <90719d08-4d03-d05f-7c4f-f08e1052e6b2@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37474 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752464AbdBPDgu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2017 22:36:50 -0500
In-Reply-To: <90719d08-4d03-d05f-7c4f-f08e1052e6b2@wdc.com> (Damien Le Moal's
        message of "Thu, 16 Feb 2017 11:52:34 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linuxram@us.ibm.com" <linuxram@us.ibm.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "hare@suse.de" <hare@suse.de>, "hch@lst.de" <hch@lst.de>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>

>>>>> "Damien" == Damien Le Moal <damien.lemoal@wdc.com> writes:

Damien,

Damien> So the conclusion may be that we need to drop everything ? The
Damien> mpt3sas patch breaks ZBC now, so that must be removed too.

Nah.

But it's important that we restrict the rounding to TYPE_FS requests
(i.e. I/Os issued by the kernel where we control what's going on). Your
patch already does this by virtue of changing sd_done(). So for that
reason I'm OK with relocating the rounding from mpt3sas to sd.c.

However, I still think it's a fundamental problem that mpt3sas reports
completion in terms of "SAS frame bytes (successfully?) transferred"
instead of "blocks acknowledged by the target". The drive can obviously
not write a partial sector. So that approach to completion reporting
seems completely bogus to me.

Anyway. My main comment is that it seems like the rounding logic would
be better contained in sd_completed_bytes() since that is already doing
sanity checking on what's reported.

Also, I am no fan of perpetuating the arcane SCSI logging stuff now that
we have tracing. So just make it a regular sd_printk().

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
