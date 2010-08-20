From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Conversion of LIO-Target to use include/scsi/iscsi_proto.h defs
Date: Fri, 20 Aug 2010 16:41:18 -0500
Message-ID: <4C6EF67E.2060908@cs.wisc.edu>
References: <1282257947.30453.296.camel@haakon2.linux-iscsi.org> <20100820163058P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100820163058P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On 08/20/2010 02:32 AM, FUJITA Tomonori wrote:
> On Thu, 19 Aug 2010 15:45:47 -0700
> "Nicholas A. Bellinger"<nab@linux-iscsi.org>  wrote:
>
>> So, assuming that the conversion of all struct iscsi_init_* and struct
>> iscsi_target* to use include/scsi/iscsi_proto.h defs just involves
>> checking structure size and renaming the member use in
>> drivers/target/lio-target, would it be acceptable to do something like:
>>
>> /* iSCSI PDU Header */
>> struct iscsi_cmd {
>>          uint8_t opcode;
>>          uint8_t flags;
>>          __be16 rsvd2;
>>          uint8_t hlength;
>>          uint8_t dlength[3];
>>          uint8_t lun[8];
>>          itt_t    itt;   /* Initiator Task Tag */
>>          __be32 data_length;
>>          __be32 cmdsn;
>>          __be32 exp_statsn;
>>          uint8_t cdb[ISCSI_CDB_SIZE];    /* SCSI Command Block */
>>          /* Additional Data (Command Dependent) */
>> #ifdef ISCSI_TARGET_MODE
>>          __be32 header_digest;
>> #endif
>> };
>
> It's up to Mike but it looks hacky to me. struct iscsi_pdu is defined
> in the exact way as the spec does.
>
> I don't think that iscsi_proto.h conversion is a must for the mainline
> inclusion. I prefer to let it alone for now.

For the iscsi target, I think it is. For iscsi initiator drivers like 
bnx2i and be2iscsi we have made them convert from their headers to 
common linux ones including switching from driver specific defs to 
iscsi_proto.h.

For the merging of any target core stuff though, I do not think it is 
critical. The core target stuff does not need to be merged with a 
software iscsi target. They can do in at different times.
