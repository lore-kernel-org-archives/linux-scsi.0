From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH v4] sd: Check for unaligned partial completion
Date: Thu, 16 Feb 2017 13:16:32 +0900
Message-ID: <66d41575-4b5e-400b-587f-6d7a94eb7899@wdc.com>
References: <20170215021230.11181-1-damien.lemoal@wdc.com>
 <1487176942.2666.1.camel@sandisk.com>
 <6f142c01-dc11-e86b-9100-d1e11c13f507@wdc.com>
 <1487207394.2666.14.camel@sandisk.com>
 <90719d08-4d03-d05f-7c4f-f08e1052e6b2@wdc.com> <yq1d1eibydd.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:3562 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751635AbdBPESn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2017 23:18:43 -0500
In-Reply-To: <yq1d1eibydd.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linuxram@us.ibm.com" <linuxram@us.ibm.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "hare@suse.de" <hare@suse.de>, "hch@lst.de" <hch@lst.de>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>

Martin,

On 2/16/17 12:36, Martin K. Petersen wrote:
> Damien,
> 
> Damien> So the conclusion may be that we need to drop everything ? The
> Damien> mpt3sas patch breaks ZBC now, so that must be removed too.
> 
> Nah.
> 
> But it's important that we restrict the rounding to TYPE_FS requests
> (i.e. I/Os issued by the kernel where we control what's going on). Your
> patch already does this by virtue of changing sd_done(). So for that
> reason I'm OK with relocating the rounding from mpt3sas to sd.c.
> 
> However, I still think it's a fundamental problem that mpt3sas reports
> completion in terms of "SAS frame bytes (successfully?) transferred"
> instead of "blocks acknowledged by the target". The drive can obviously
> not write a partial sector. So that approach to completion reporting
> seems completely bogus to me.
> 
> Anyway. My main comment is that it seems like the rounding logic would
> be better contained in sd_completed_bytes() since that is already doing
> sanity checking on what's reported.

Indeed, that would be nicer. But sd_completed_bytes is only called when
sense data (a sense key) was also returned with the command. It is not
clear to me if that is always the case when an unaligned resid is
reported by the bogus mpt3sas HBA.

Handling all possible (bogus) cases may require a more extensive rewrite
of sd_completed_bytes, which may not be the best of choice this late in
the RC cycle.

Should I keep the fix in its current place and defer the move to
sd_completed_bytes to a later patch for 4.11 ?

> Also, I am no fan of perpetuating the arcane SCSI logging stuff now that
> we have tracing. So just make it a regular sd_printk().

Sure, will do.

Thank you.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
