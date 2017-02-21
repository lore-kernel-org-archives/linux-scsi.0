From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH v5] sd: Check for unaligned partial completion
Date: Tue, 21 Feb 2017 12:45:07 +0900
Message-ID: <6789928a-08c5-0b0e-ac45-de2225a2e0e0@wdc.com>
References: <20170217000130.22471-1-damien.lemoal@wdc.com>
 <yq11sus5l0j.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:35629 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdBUDpU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2017 22:45:20 -0500
In-Reply-To: <yq11sus5l0j.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

Martin,

On 2/21/17 11:35, Martin K. Petersen wrote:
>>>>>> "Damien" == Damien Le Moal <damien.lemoal@wdc.com> writes:
> 
> Hi Damien,
> 
> Damien> Move the partial completion alignement check of mpt3sas to a
> Damien> generic implementation in sd_done so that the check ignores
> Damien> REQ_TYPE_FS requests with special payload size handling
> Damien> (REQ_OP_DISCARD, REQ_OP_WRITE_SAME, REQ_OP_ZONE_REPORT and
> Damien> REQ_OP_ZONE_RESET). For the remaining REQ_OP_FLUSH, REQ_OP_READ
> Damien> and REQ_OP_WRITE, we only need to check the resid alignment,
> Damien> correct it if necessary and then correct good_bytes. Note that
> Damien> in this case, good_bytes will always initially be 0 or aligned
> Damien> on the device logical block size, so correcting resid alignment
> Damien> will always result in good_bytes also being properly aligned.
> 
> I'm still not keen on having two orthogonal sanity checks wrt. figuring
> out how much of a request has been completed.
> 
> Also, I find your approach hard to follow in the case where
> sd_completed_bytes() is called after the resid has been adjusted. It
> works, but it's not immediately obvious that that's the case. Which to
> me is an indication that this entire thing needs a thorough cleanup.
> 
> If you don't feel like mucking more with this, I understand. In that
> case might pick up your patch and attempt to clean things up later.

Initially, I didn't want to change more than I did so that the patch
quickly make it to 4.10 and we get ZBC working with LSI HBAs. Since this
did not happen and we have more time ahead, I can respin everything into
sd_completed_bytes to clean things up.

I will resend a patch.

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
