From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH v4] sd: Check for unaligned partial completion
Date: Thu, 16 Feb 2017 12:00:01 +0900
Message-ID: <e9b37a18-d9ac-1cf1-7843-fe2d14b0fba8@wdc.com>
References: <20170215021230.11181-1-damien.lemoal@wdc.com>
 <1487176942.2666.1.camel@sandisk.com>
 <6f142c01-dc11-e86b-9100-d1e11c13f507@wdc.com>
 <1487207394.2666.14.camel@sandisk.com>
 <90719d08-4d03-d05f-7c4f-f08e1052e6b2@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:48240 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbdBPDAP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2017 22:00:15 -0500
In-Reply-To: <90719d08-4d03-d05f-7c4f-f08e1052e6b2@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linuxram@us.ibm.com" <linuxram@us.ibm.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "hare@suse.de" <hare@suse.de>, "hch@lst.de" <hch@lst.de>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>

Bart,

On 2/16/17 11:52, Damien Le Moal wrote:
> Bart,
> 
> On 2/16/17 10:10, Bart Van Assche wrote:
>> On Thu, 2017-02-16 at 09:54 +0900, Damien Le Moal wrote:
>>> On 2/16/17 01:42, Bart Van Assche wrote:
>>>> An additional concern: what if the size of the Data-Out buffer is not a
>>>> multiple of the logical block size? Shouldn't we round down (good_bytes -
>>>> resid) instead of rounding up resid?
>>>
>>> The only REQ_TYPE_FS request that may not operate on LBA size aligned
>>> payloads is REQ_OP_ZONE_REPORT which is handles in a different case of
>>> the switch statement. So I think it is safe.
>>
>> Hello Damien,
>>
>> Are you aware that it is the software that submits a request that controls
>> the buffer length and not the device that processes a request? Submitting
>> Data-Out buffers with odd sizes is one of the tests in the libiscsi test
>> suite. See e.g. the source file test-tool/test_write10_residuals.c in that
>> test suite. The request submitted by the libiscsi test suite reach the
>> kernel of the target system either through SG IO or through the iSCSI
>> target driver. When using iSCSI, both the LIO and SCST SCSI target
>> frameworks translate these requests into REQ_TYPE_FS requests. I think we
>> should aim not to affect the outcome of libiscsi tests when the underlying
>> device is a SCSI disk.
> 
> Thanks for the pointers. I checked libiscsi tests. And from what is done
> there, it seems to me that it is basically impossible to distinguished
> between a buggy hardware response and an in-purpose (or buggy) not
> aligned data-out buffer size.
> E.g. the test in test_write10_residuals.c which issues a 1 block write
> with a buf size of 10000 and checks that residual is 10000 - block size.
> For that case, with both this patch and the original mpt3sas patch, the
> rounding up of resid to the block size will break the test.
> 
> Yet, it is very surprising that LIO and SCST_SCSI issue the "buggy"
> request as is without checking and eventually correcting things first.
> So unless LIO and SCST_SCSI are fixed to do that on the request they
> send to the device, both patches should be dropped.
> Users with buggy mpt3 HBAs will need to update the HBA FW...
> 
> So the conclusion may be that we need to drop everything ? The mpt3sas
> patch breaks ZBC now, so that must be removed too.
> 
> Thoughts ?

Or we rewrite to this:

if (!(good_bytes & (sector_size - 1)) &&
    resid & (sector_size - 1)) {
        resid = min(good_bytes, round_up(resid, sector_size));
        good_bytes -= resid;
        scsi_set_resid(SCpnt, resid);
}

That is, do the resid correction only and only if the command buffer
size is aligned. But still not sure that is safe in all possible cases.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
