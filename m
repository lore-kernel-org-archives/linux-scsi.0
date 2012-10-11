From: James Hogan <james.hogan@imgtec.com>
Subject: Re: [RESEND PATCH] scsi: make struct scsi_varlen_cdb_hdr packed
Date: Thu, 11 Oct 2012 15:10:40 +0100
Message-ID: <5076D360.2010804@imgtec.com>
References: <1349946933-30314-1-git-send-email-james.hogan@imgtec.com>  <1349951069.2425.44.camel@dabdike.int.hansenpartnership.com>  <5076AE3B.5040509@imgtec.com> <1349960296.2425.53.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349960296.2425.53.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/10/12 13:58, James Bottomley wrote:
> On Thu, 2012-10-11 at 12:32 +0100, James Hogan wrote:
>> On 11/10/12 11:24, James Bottomley wrote:
>>> On Thu, 2012-10-11 at 10:15 +0100, James Hogan wrote:
>>>> The struct scsi_varlen_cdb_hdr is expected to be exactly 10 bytes when
>>>> used in struct osd_cdb_head, but it isn't marked as packed. Some
>>>> architectures will round the struct size up which triggers BUILD_BUG_ON
>>>> compile errors in osd_initiator.c when the outer structs are unexpected
>>>> sizes. This is fixed by marking struct scsi_varlen_cdb_hdr as __packed.
>>>
>>> What actual problem have you encountered? The structure is {u8[8], u16}
>>> which is naturally packed on every architecture I know about.  I've even
>>> built osd_initiator without problem on parisc, which has some of the
>>> most rigid alignment rules I've seen.
>>
>> Hi James,
>>
>> The alignment is fine (the offset of the u16 is 8 bytes), but
>> unfortunately with the metag port of gcc, sizeof(struct
>> scsi_varlen_cdb_hdr) is rounded up to a 4 byte boundary (even though the
>> largest data member alignment is only 2 bytes), which is 12 bytes
>> instead of 10.
> 
> That sounds to be a bug in your compiler ... it shouldn't be rounding up
> structure sizes if the structure can fit in 10 bytes.  This isn't
> happening in any other architecture that I know of (otherwise we'd have
> had a reported build break).

This was my initial thought, and I share your feeling that this isn't
ideal compiler behaviour, however it's pretty much set in stone as part
of our ABI now. Having talked to one of our compiler folk about it
here's what he had to say:
> In GCC 4.2 the following backends have STRUCTURE_SIZE_BOUNDARY set to >=32 which will trigger this behaviour:
> 
> Alpha+unicos
> Arm prior to AAPCS
> Mt
> 
> This is within standards to my knowledge.

Cheers
James
