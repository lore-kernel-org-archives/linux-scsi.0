From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5] sd: Check for unaligned partial completion
Date: Mon, 20 Feb 2017 21:35:08 -0500
Message-ID: <yq11sus5l0j.fsf@oracle.com>
References: <20170217000130.22471-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38401 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750977AbdBUCf3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2017 21:35:29 -0500
In-Reply-To: <20170217000130.22471-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Fri, 17 Feb 2017 09:01:30 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

>>>>> "Damien" == Damien Le Moal <damien.lemoal@wdc.com> writes:

Hi Damien,

Damien> Move the partial completion alignement check of mpt3sas to a
Damien> generic implementation in sd_done so that the check ignores
Damien> REQ_TYPE_FS requests with special payload size handling
Damien> (REQ_OP_DISCARD, REQ_OP_WRITE_SAME, REQ_OP_ZONE_REPORT and
Damien> REQ_OP_ZONE_RESET). For the remaining REQ_OP_FLUSH, REQ_OP_READ
Damien> and REQ_OP_WRITE, we only need to check the resid alignment,
Damien> correct it if necessary and then correct good_bytes. Note that
Damien> in this case, good_bytes will always initially be 0 or aligned
Damien> on the device logical block size, so correcting resid alignment
Damien> will always result in good_bytes also being properly aligned.

I'm still not keen on having two orthogonal sanity checks wrt. figuring
out how much of a request has been completed.

Also, I find your approach hard to follow in the case where
sd_completed_bytes() is called after the resid has been adjusted. It
works, but it's not immediately obvious that that's the case. Which to
me is an indication that this entire thing needs a thorough cleanup.

If you don't feel like mucking more with this, I understand. In that
case might pick up your patch and attempt to clean things up later.

-- 
Martin K. Petersen	Oracle Linux Engineering
