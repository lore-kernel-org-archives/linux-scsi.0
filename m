From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH RESEND] scsi: Fix sense information setting in fixed sized
 format
Date: Thu, 17 Sep 2015 15:42:36 +0300
Message-ID: <55FAB53C.3080102@dev.mellanox.co.il>
References: <1441298973-27735-1-git-send-email-sagig@mellanox.com>
 <1441306948.23183.328.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37290 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbbIQMmT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2015 08:42:19 -0400
Received: by wicfx3 with SMTP id fx3so25601720wic.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2015 05:42:18 -0700 (PDT)
In-Reply-To: <1441306948.23183.328.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: emilne@redhat.com, linux-scsi@vger.kernel.org

On 9/3/2015 10:02 PM, Ewan Milne wrote:
> On Thu, 2015-09-03 at 19:49 +0300, Sagi Grimberg wrote:
>> In fixed size sense format the information field is a four byte
>> field.
>>
>> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
>> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
>> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   drivers/scsi/scsi_common.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
>> index 41432c10dda2..8cfb7eeb5bbc 100644
>> --- a/drivers/scsi/scsi_common.c
>> +++ b/drivers/scsi/scsi_common.c
>> @@ -270,7 +270,7 @@ void scsi_set_sense_information(u8 *buf, u64 info)
>>   		put_unaligned_be64(info, &ucp[4]);
>>   	} else if ((buf[0] & 0x7f) == 0x70) {
>>   		buf[0] |= 0x80;
>> -		put_unaligned_be64(info, &buf[3]);
>> +		put_unaligned_be32(info, &buf[3]);
>>   	}
>>   }
>>   EXPORT_SYMBOL(scsi_set_sense_information);
>
> Looks correct per SPC-4 4.5.3
>
> And you did post a patch to target for the case where the sector
> did not fit in 32 bits, which requires descriptor format sense, so...
>
> Reviewed-by: Ewan D. Milne <emilne@redhat.com>

James, can you pick this up please?

Thanks,
Sagi.
