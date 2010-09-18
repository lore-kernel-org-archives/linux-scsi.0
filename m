From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] SCSI: fix the return value of scsi_target_queue_read()
Date: Sat, 18 Sep 2010 08:59:52 +0800
Message-ID: <AANLkTikyCZEo0=agTyVsiCy8cjXKsJH2y7=7gtCfG2mx@mail.gmail.com>
References: <AANLkTin38p4ZfYmkU+ijkky_nwkBBgr=-u9ay37MgZ+W@mail.gmail.com>
	<4C8FC9EA.4080501@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62488 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab0IRA7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2010 20:59:54 -0400
Received: by wwb39 with SMTP id 39so1528133wwb.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2010 17:59:53 -0700 (PDT)
In-Reply-To: <4C8FC9EA.4080501@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <James.Bottomley@suse.de>

the recommended version in plain text
---

--- o/linux-2.6.36-rc1/drivers/scsi/scsi_lib.c	2010-08-16
08:41:38.000000000 +0800
+++ m/linux-2.6.36-rc1/drivers/scsi/scsi_lib.c	2010-09-18
08:59:50.000000000 +0800
@@ -1276,11 +1276,10 @@ static inline int scsi_target_queue_read
 	}

 	if (scsi_target_is_busy(starget)) {
-		if (list_empty(&sdev->starved_entry)) {
+		if (list_empty(&sdev->starved_entry))
 			list_add_tail(&sdev->starved_entry,
 				      &shost->starved_list);
-			return 0;
-		}
+		return 0;
 	}

 	/* We're OK to process the command, so we can't be starved */




On Wed, Sep 15, 2010 at 3:15 AM, Mike Christie <michaelc@cs.wisc.edu> w=
rote:
> On 09/14/2010 08:35 AM, Hillf Danton wrote:
>>
>> It seems that zero should be returned if scsi_target_is_busy(starget=
) is
>> true, no matter if sdev is on the starved list.
>>
>> Signed-off-by: Hillf Danton<dhillf@gmail.com>
>> ---
>>
>> --- o/linux-2.6.36-rc1/drivers/scsi/scsi_lib.c 2010-08-16
>> 08:41:38.000000000
>> +0800
>> +++ m/linux-2.6.36-rc1/drivers/scsi/scsi_lib.c 2010-09-14
>> 21:04:50.000000000
>> +0800
>> @@ -1279,8 +1279,8 @@ static inline int scsi_target_queue_read
>> =C2=A0 if (list_empty(&sdev->starved_entry)) {
>> =C2=A0 list_add_tail(&sdev->starved_entry,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0&shost->starved_list);
>> - return 0;
>> =C2=A0 }
>
> I think the formatting in the patch got messed up by your mailer. Whe=
n you
> resend the patch, you can remove the brackets since you removed the r=
eturn 0
> there is no need for them.
>
>> + return 0;
>> =C2=A0 }
>>
>> =C2=A0 /* We're OK to process the command, so we can't be starved */
>>
>
> Patch is right. I do not know what I was thinking when I did that.
>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
