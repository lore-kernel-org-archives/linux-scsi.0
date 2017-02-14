From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 1/1] mpt3sas: Ignore unaligned completion length for
 ZBC_IN
Date: Tue, 14 Feb 2017 13:42:31 +0900
Message-ID: <bb2092fe-4368-2a7f-3e67-6e8369fb4d56@wdc.com>
References: <20170213051152.27741-1-damien.lemoal@wdc.com>
 <1487012224.2719.3.camel@sandisk.com>
 <1f98b2ef-89d6-65e4-6424-c3b4b4cf1b82@wdc.com>
 <1487044768.6475.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:13740 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751390AbdBNEmo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2017 23:42:44 -0500
In-Reply-To: <1487044768.6475.1.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>

Bart,

On 2/14/17 12:59, Bart Van Assche wrote:
>>> What software generated a ZBC_IN request with type REQ_TYPE_FS? Shouldn't
>>> all ZBC_IN requests be assigned type REQ_TYPE_BLOCK_PC?
>>
>> Any application that issues a BLKREPORTZONE ioctl (e.g. mkfs.f2fs or
>> libzbc tools) or kernel component calling blkdev_report_zones (e.g.
>> f2fs) will generate one or more REQ_OP_ZONE_REPORT BIO which translate
>> into a REQ_TYPE_FS requests for the command ZBC_IN. That command does
>> not operate on LBAs. The transfer length of the request can be any
>> length larger than 64B and the reply length will be at least 64B and
>> aligned on a multiple of 64.
>>
>> The patch "mpt3sas: Force request partial completion alignment" applied
>> last week forgot this case, and frankly, I did too despite having looked
>> at it.
> 
> Hello Damien,
> 
> How about modifying the block layer core such that it sets REQ_TYPE_BLOCK_PC
> for REQ_OP_ZONE_REPORT requests? Would that be a valid alternative to the
> above patch?

I think so. But my understanding of REQ_TYPE_BLOCK_PC is that it is the
type for requests issued internally (scsi_execute) of from things like
the SG driver, so in essence, all requests not derived from a BIO... Is
this correct ? If yes, then setting the BLOCK_TYPE_PC for
REQ_OP_ZONE_REPORT (and REQ_OP_ZONE_RESET while at it) would break this
model, wouldn't it ?

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
