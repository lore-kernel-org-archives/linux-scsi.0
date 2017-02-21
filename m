From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH v5] sd: Check for unaligned partial completion
Date: Tue, 21 Feb 2017 16:47:58 +0900
Message-ID: <aa814adb-b31a-432a-5128-86dcd53162e6@wdc.com>
References: <20170217000130.22471-1-damien.lemoal@wdc.com>
 <yq11sus5l0j.fsf@oracle.com>
 <1D08B61A9CF0974AA09887BE32D889DA0AB16B@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:25236 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdBUHxk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2017 02:53:40 -0500
In-Reply-To: <1D08B61A9CF0974AA09887BE32D889DA0AB16B@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

Bart,

On 2/21/17 13:21, Bart Van Assche wrote:
> On 02/20/2017 06:35 PM, Martin K. Petersen wrote:
>> I'm still not keen on having two orthogonal sanity checks wrt. figuring
>> out how much of a request has been completed.
>>
>> Also, I find your approach hard to follow in the case where
>> sd_completed_bytes() is called after the resid has been adjusted. It
>> works, but it's not immediately obvious that that's the case. Which to
>> me is an indication that this entire thing needs a thorough cleanup.
> 
> Hello Martin and Damien,
> 
> How about the following:
> * Add a function to the block layer that reports whether or not the
>   request is a medium access request. The number of transferred bytes
>   for a medium access request is a multiple of the logical block size.
>   (The terminology "medium access command" comes from the SCSI specs.)
> * Use that function instead of "scmd->request->cmd_type == REQ_TYPE_FS"
>   in the mpt3sas driver.
> * Do not modify sd_done().
> 
> This approach has the advantage that the mpt3sas firmware bug workaround
> does not slow down the hot path of the sd driver when another LLD than
> mpt3sas is used.

I think we would still need the check for REQ_TYPE_FS to avoid
interfering with SG_IO commands. As for the "medium access command"
test, I am not sure if the block layer is the right place to define that
since a request operation may map to different commands depending on the
device type (e.g. REQ_OP_DISCARD which can become unmap or write same in
SCSI).

Martin,

Which approach do you prefer ? Keeping everything contained to mpt3sas
(so basically just fixing the problematic patch), or cleaning up
everything with sd_completed_bytes rewrite ?

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
