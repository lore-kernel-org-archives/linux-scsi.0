From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 1/1] mpt3sas: Ignore unaligned completion length for
 ZBC_IN
Date: Tue, 14 Feb 2017 14:21:37 +0900
Message-ID: <6cabab36-3865-1465-fae8-69c437602b80@wdc.com>
References: <20170213051152.27741-1-damien.lemoal@wdc.com>
 <1487012224.2719.3.camel@sandisk.com>
 <1f98b2ef-89d6-65e4-6424-c3b4b4cf1b82@wdc.com>
 <1487044768.6475.1.camel@sandisk.com>
 <bb2092fe-4368-2a7f-3e67-6e8369fb4d56@wdc.com>
 <1487049066.6475.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:48372 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbdBNFVs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2017 00:21:48 -0500
In-Reply-To: <1487049066.6475.3.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>

Bart,

On 2/14/17 14:11, Bart Van Assche wrote:
> On Tue, 2017-02-14 at 13:42 +0900, Damien Le Moal wrote:
>> I think so. But my understanding of REQ_TYPE_BLOCK_PC is that it is the
>> type for requests issued internally (scsi_execute) of from things like
>> the SG driver, so in essence, all requests not derived from a BIO... Is
>> this correct ? If yes, then setting the BLOCK_TYPE_PC for
>> REQ_OP_ZONE_REPORT (and REQ_OP_ZONE_RESET while at it) would break this
>> model, wouldn't it ?
> 
> Hello Damien,
> 
> I think we want to keep the knowledge of which requests have a request size
> that should be a multiple of the logical block size in the block layer core
> or in the SCSI core but not in the mpt3sas driver. But I'm not sure what the
> best approach is to do that. Should we use the request type, should we add a
> new request attribute or should we add a new function?

I agree. But the mpt3sas patch that introduced the problem is to solve
problems with a buggy hardware in the first place... A quirck of some
sort. So do we really need such a big change just the report zones
exception ? (all other REQ_TYPE_FS commands either have no payload or
the payload size is LBA aligned)

Martin, James, Hannes,

Please advise ! 4.10 is introducing zoned block device support, and from
the first release that will be broken with mpt3sas HBAs if we do not
patch this. Any preferred approach ?

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
