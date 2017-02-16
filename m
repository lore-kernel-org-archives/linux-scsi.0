From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH v4] sd: Check for unaligned partial completion
Date: Thu, 16 Feb 2017 14:17:14 +0900
Message-ID: <9d9442df-df17-741b-346c-2707423eb695@wdc.com>
References: <20170215021230.11181-1-damien.lemoal@wdc.com>
 <1487176942.2666.1.camel@sandisk.com>
 <6f142c01-dc11-e86b-9100-d1e11c13f507@wdc.com>
 <1487207394.2666.14.camel@sandisk.com>
 <90719d08-4d03-d05f-7c4f-f08e1052e6b2@wdc.com>
 <1487215718.2664.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61551 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbdBPFRa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2017 00:17:30 -0500
In-Reply-To: <1487215718.2664.1.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linuxram@us.ibm.com" <linuxram@us.ibm.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, "hch@lst.de" <hch@lst.de>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "hare@suse.de" <hare@suse.de>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>

Bart,

On 2/16/17 12:28, Bart Van Assche wrote:
> On Thu, 2017-02-16 at 11:52 +0900, Damien Le Moal wrote:
>> Thanks for the pointers. I checked libiscsi tests. And from what is done
>> there, it seems to me that it is basically impossible to distinguished
>> between a buggy hardware response and an in-purpose (or buggy) not
>> aligned data-out buffer size.
>> E.g. the test in test_write10_residuals.c which issues a 1 block write
>> with a buf size of 10000 and checks that residual is 10000 - block size.
>> For that case, with both this patch and the original mpt3sas patch, the
>> rounding up of resid to the block size will break the test.
>>
>> Yet, it is very surprising that LIO and SCST_SCSI issue the "buggy"
>> request as is without checking and eventually correcting things first.
>> So unless LIO and SCST_SCSI are fixed to do that on the request they
>> send to the device, both patches should be dropped.
>> Users with buggy mpt3 HBAs will need to update the HBA FW...
>>
>> So the conclusion may be that we need to drop everything ? The mpt3sas
>> patch breaks ZBC now, so that must be removed too.
> 
> Hello Damien,
> 
> For the example you cited (bufflen - residual) = block size. This is
> why I proposed to round (bufflen - residual) instead of residual. Whether
> bufflen or (bufflen - residual) is rounded doesn't matter if bufflen is a
> multiple of the logical block size. But it matters if bufflen is not a
> multiple of the logical block size.

To be sure, I went through the scsi submission and completion path of
REQ_TYPE_FS again.

For REQ_OP_DISCARD, REQ_OP_WRITE_SAME, REQ_OP_ZONE_REPORT and
REQ_OP_ZONE_RESET, the resid check in sd_done is skipped thanks to the
special handling for these commands in the switch-case statement. So we
do not need to worry about scsi_buflen() alignment.

For REQ_OP_FLUSH, scsi_buflen() == 0. So no problem either.

All that remains of REQ_TYPE_FS are REQ_OP_READ and REQ_OP_WRITE. For
these, cmd->sdb.length (that is scsi_buflen) is set to count *
sector_size in sd_setup_read_write_cmnd. So scsi_buflen() will always be
aligned. This also means that things like the libiscsi tests with
incorrect data buffer size will actually not be seen as is by sd_done.
For the example of the test_write10_residuals.c of 1 block write using a
10000B buffer, sd_done will see scsi_buflen() of 1 block.

So it seems to me that for the buggy mpt3sas hardware, we really only
need to check resid alignment and correct it if necessary. The code you
proposed

if (resid & (sector_size - 1)) {
        resid = min(good_bytes, round_up(resid, sector_size));
        good_bytes -= resid;
        scsi_set_resid(SCpnt, resid);
}

looks just perfect for this.

Let me know if I missed something.

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
