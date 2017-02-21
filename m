From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH v5] sd: Check for unaligned partial completion
Date: Tue, 21 Feb 2017 10:44:19 +0900
Message-ID: <a1edbe86-0dd9-e823-9728-5c62deae6f99@wdc.com>
References: <20170217000130.22471-1-damien.lemoal@wdc.com>
 <1D08B61A9CF0974AA09887BE32D889DA0A9972@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:60620 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbdBUBoa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2017 20:44:30 -0500
In-Reply-To: <1D08B61A9CF0974AA09887BE32D889DA0A9972@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

Bart,

On 2/21/17 02:34, Bart Van Assche wrote:
> On 02/16/2017 04:20 PM, Damien Le Moal wrote:
>> Move the partial completion alignement check of mpt3sas to a generic
>> implementation in sd_done so that the check ignores REQ_TYPE_FS
>> requests with special payload size handling (REQ_OP_DISCARD,
>> REQ_OP_WRITE_SAME, REQ_OP_ZONE_REPORT and REQ_OP_ZONE_RESET).
> 
> Hello Damien,
> 
> Since the resid adjustment code is skipped for REQ_OP_DISCARD and
> REQ_OP_WRITE_SAME: does the mpt3sas firmware ensure that 'resid' is
> properly aligned for these request types? Did I perhaps miss something?

No, I do not think anything special is done for these commands in the
driver (I did not see any code to that effect).

But for discard, since the payload is one sector, it always should be
aligned (or 0). So the actual value from the driver is ignored and
overwritten in the switch-case code with the actual request size on
success (not the payload size) and 0 on error. If anything, if the HW
returned a non-0 resid, we should mark the command as failed.

For write-same, it is basically the same. The payload is one page
containing the sector range to discard (soon multiple ranges actually).
If the commands succeeded, then clearly resid should be 0 and the value
returned by the HW ignored. In case of a failed command, no matter what
resid is, the discard is marked as entirely failed. Similarly to
write-same, a success with a non-0 resid is non-sensical. So we could
force the request as failed here in this case.

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
