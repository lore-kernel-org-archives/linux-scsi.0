From: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Subject: Re: [PATCH] scsi: fix upper bounds check of sense key in
 scsi_sense_key_string()
Date: Thu, 11 Aug 2016 14:21:47 -0700
Message-ID: <57ACEC6B.7090301@gmail.com>
References: <1470346337-20034-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <998bca14-1871-0b9e-a748-68dd39a0b634@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:32830 "EHLO
	mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbcHKVVv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 17:21:51 -0400
Received: by mail-qt0-f196.google.com with SMTP id j37so313355qta.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 14:21:51 -0700 (PDT)
In-Reply-To: <998bca14-1871-0b9e-a748-68dd39a0b634@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On 08/09/2016 01:08 PM, Bart Van Assche wrote:
> On 08/04/2016 02:32 PM, Tyrel Datwyler wrote:
>> Commit 655ee63cf371 added a "Completed" sense string with key 0xF to
>> snstext[], but failed to updated the upper bounds check of the sense key in
>> scsi_sense_key_string().
>>
>> Fixes: 655ee63cf371 ("[SCSI] scsi constants: command, sense key + additional sense strings")
>> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
>> ---
>>  drivers/scsi/constants.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> index 83458f7..70d8dc4 100644
>> --- a/drivers/scsi/constants.c
>> +++ b/drivers/scsi/constants.c
>> @@ -362,7 +362,7 @@ static const char * const snstext[] = {
>>  /* Get sense key string or NULL if not available */
>>  const char *
>>  scsi_sense_key_string(unsigned char key) {
>> -	if (key <= 0xE)
>> +	if (key <= 0xF)
>>  		return snstext[key];
>>  	return NULL;
>>  }
> 
> Hello Tyrel,
> 
> Please move the opening brace ("{") to a line of its own.
> 
> If you change "<= 0xF" into "< ARRAY_SIZE(snstext)" then you are welcome

This actually occurred to me as a better long term solution after I had
already posted the patch.

> to add:
> 
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

Thanks for your comments. I'll address and spin a version 2.

-Tyrel

> 
> Thanks,
> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

