From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 6/6] scsi_scan: Fixup scsilun_to_int()
Date: Tue, 10 Jun 2014 09:41:11 -0400
Message-ID: <53970AF7.40304@interlog.com>
References: <1401785937-43581-1-git-send-email-hare@suse.de> <1401785937-43581-7-git-send-email-hare@suse.de> <5396EE0C.3070108@acm.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53182 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbaFJNlS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2014 09:41:18 -0400
In-Reply-To: <5396EE0C.3070108@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 14-06-10 07:37 AM, Bart Van Assche wrote:
> On 06/03/14 10:58, Hannes Reinecke wrote:
>> + *     Given a struct scsi_lun of: d2 04 0b 03 00 00 00 00, this function
>> + *     returns the integer: 0x0b03d204
>> + *
>> + *     This encoding will return a standard integer LUN for LUNs smaller
>> + *     than 256, which typically use a single level LUN structure with
>> + *     addressing method 0.
>>    **/
>>   u64 scsilun_to_int(struct scsi_lun *scsilun)
>>   {
>> @@ -1279,7 +1280,7 @@ u64 scsilun_to_int(struct scsi_lun *scsilun)
>>
>>   	lun = 0;
>>   	for (i = 0; i < sizeof(lun); i += 2)
>> -		lun = lun | (((scsilun->scsi_lun[i] << 8) |
>> +		lun = lun | (((scsilun->scsi_lun[i] << ((i + 1) *8)) |
>>   			      scsilun->scsi_lun[i + 1]) << (i * 8));
>>   	return lun;
>>   }
>
> The above code doesn't match the comment header. Parentheses have been
> placed such that each byte with an even index is shifted left (2*i+1)*8
> bits instead of (i+1)*8. I assume this means the parentheses have been
> misplaced ? Another bug in this code is that a cast from
> scsilun->scsi_lun[i] from u8 to u64 is missing. I think the shift
> operations in the above code trigger what is called undefined behavior
> in the C standard if i >= 4.

Hmm, we have been over this ground before. In sg_luns,
to support translating between the T10 and Linux
representation of 64 bit LUNs, there are these two
versions:


static uint64_t
t10_2linux_lun(const unsigned char t10_lun[])
{
     const unsigned char * cp;
     uint64_t res;

      res = (t10_lun[6] << 8) + t10_lun[7];
      for (cp = t10_lun + 4; cp >= t10_lun; cp -= 2) {
         res <<= 16;
         res += (*cp << 8) + *(cp + 1);
     }
     return res;
}

/* Copy of t10_lun --> Linux unsigned int (i.e. 32 bit ) present in Linux
  * kernel, up to least lk 3.8.0, extended to 64 bits.
  * BEWARE: for sizeof(int==4) this function is BROKEN and is left here as
  * as example and may soon be removed. */
static uint64_t
t10_2linux_lun64bitBR(const unsigned char t10_lun[])
{
     int i;
     uint64_t lun;

     lun = 0;
     for (i = 0; i < (int)sizeof(lun); i += 2)
         lun = lun | (((t10_lun[i] << 8) | t10_lun[i + 1]) << (i * 8));
     return lun;
}

The second one (with "BR" (for broken) appended) is for testing.
And that second one looks very similar to the code you are
objecting to.

Doug Gilbert

