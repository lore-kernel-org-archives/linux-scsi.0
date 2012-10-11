From: James Hogan <james.hogan@imgtec.com>
Subject: Re: [RESEND PATCH] scsi: make struct scsi_varlen_cdb_hdr packed
Date: Thu, 11 Oct 2012 12:13:55 +0100
Message-ID: <5076A9F3.7070403@imgtec.com>
References: <1349946933-30314-1-git-send-email-james.hogan@imgtec.com> <5076990C.4080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5076990C.4080406@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/10/12 11:01, Bart Van Assche wrote:
> On 10/11/12 11:15, James Hogan wrote:
>> The struct scsi_varlen_cdb_hdr is expected to be exactly 10 bytes when
>> used in struct osd_cdb_head, but it isn't marked as packed. Some
>> architectures will round the struct size up which triggers BUILD_BUG_ON
>> compile errors in osd_initiator.c when the outer structs are unexpected
>> sizes. This is fixed by marking struct scsi_varlen_cdb_hdr as __packed.
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> ---
>>   include/scsi/scsi.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
>> index 66216c1..3beaef3 100644
>> --- a/include/scsi/scsi.h
>> +++ b/include/scsi/scsi.h
>> @@ -198,7 +198,7 @@ struct scsi_varlen_cdb_hdr {
>>       __u8 additional_cdb_length;         /* total cdb length - 8 */
>>       __be16 service_action;
>>       /* service specific data follows */
>> -};
>> +} __packed;
>>
>>   static inline unsigned
>>   scsi_varlen_cdb_length(const void *hdr)
> 
> Hello James,
> 
> Are you aware that __packed can also be used on individual struct
> members and that doing so has a lower performance penalty than using the
> __packed attribute on an entire struct ? See e.g. <linux/sysv_fs.h> for
> an example.

Hi Bart,

Thanks, I wasn't aware of that, however the problem is the size of the
struct as a whole rather than the alignment or offsets of any individual
data members. E.g. adding __attribute__((packed,aligned(2))) to the
16bit member doesn't reduce the struct to 10 bytes, or change the offset
from 8 bytes.

Cheers
James
