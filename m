From: James Hogan <james.hogan@imgtec.com>
Subject: Re: [RESEND PATCH] scsi: make struct scsi_varlen_cdb_hdr packed
Date: Thu, 11 Oct 2012 12:32:11 +0100
Message-ID: <5076AE3B.5040509@imgtec.com>
References: <1349946933-30314-1-git-send-email-james.hogan@imgtec.com> <1349951069.2425.44.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349951069.2425.44.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/10/12 11:24, James Bottomley wrote:
> On Thu, 2012-10-11 at 10:15 +0100, James Hogan wrote:
>> The struct scsi_varlen_cdb_hdr is expected to be exactly 10 bytes when
>> used in struct osd_cdb_head, but it isn't marked as packed. Some
>> architectures will round the struct size up which triggers BUILD_BUG_ON
>> compile errors in osd_initiator.c when the outer structs are unexpected
>> sizes. This is fixed by marking struct scsi_varlen_cdb_hdr as __packed.
> 
> What actual problem have you encountered? The structure is {u8[8], u16}
> which is naturally packed on every architecture I know about.  I've even
> built osd_initiator without problem on parisc, which has some of the
> most rigid alignment rules I've seen.

Hi James,

The alignment is fine (the offset of the u16 is 8 bytes), but
unfortunately with the metag port of gcc, sizeof(struct
scsi_varlen_cdb_hdr) is rounded up to a 4 byte boundary (even though the
largest data member alignment is only 2 bytes), which is 12 bytes
instead of 10.

Cheers
James
