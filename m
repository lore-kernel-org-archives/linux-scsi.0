From: Sony John-N <Sony.John-N@Emulex.Com>
Subject: RE: [PATCH V2 1/4]  be2iscsi : Fix the retry count for boot targets
Date: Wed, 24 Dec 2014 07:38:32 +0000
Message-ID: <5a5584cb-5950-4f80-8c74-c53faf714cb6@CMEXHTCAS2.ad.emulex.com>
References: <9c2f23ac-73ce-4b8a-aa91-a64f01d345fd@CMEXHTCAS2.ad.emulex.com>
 <5498ADA9.7080104@cs.wisc.edu>,<5498AF4E.1030903@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:32630 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaLXHi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Dec 2014 02:38:59 -0500
In-Reply-To: <5498AF4E.1030903@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Minh Duc Tran <MinhDuc.Tran@Emulex.Com>, Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>


________________________________________
From: Mike Christie [michaelc@cs.wisc.edu]
Sent: Monday, December 22, 2014 3:54 PM
To: Sony John-N; linux-scsi@vger.kernel.org
Cc: Minh Duc Tran; Jayamohan Kallickal
Subject: Re: [PATCH V2 1/4]  be2iscsi : Fix the retry count for boot targets

On 12/22/2014 05:47 PM, Mike Christie wrote:
> On 12/19/2014 06:51 PM, John Soni Jose wrote:
>> @@ -5376,8 +5387,14 @@ beiscsi_hw_health_check(struct work_struct *work)
>>      be_eqd_update(phba);
>>
>>      if (phba->state & BE_ADAPTER_CHECK_BOOT) {
>> -            phba->state &= ~BE_ADAPTER_CHECK_BOOT;
>> -            be_check_boot_session(phba);
>> +            if ((phba->get_boot > 0) && (!phba->boot_kset)) {
>> +                    phba->get_boot--;
>> +                    if (!(phba->get_boot % BE_GET_BOOT_TO))
>> +                            be_check_boot_session(phba);
>> +            } else {
>> +                    phba->state &= ~BE_ADAPTER_CHECK_BOOT;
>> +                    phba->get_boot = 0;
>> +            }
>>      }
>
> Hey, I just want to make sure I am reading this patch correctly. If the
> user had the network up, but the target was not able to handle the login
> for longer than the timeout we are adding in this patch, then we will
> not be able to get any notification (the iscsi boot info would not show
> up in sysfs) later when we can login.
>

> Actually, I think I am wrong. If we hit the above scenario, then
> eventually the fw would log in and we would then get a
> ASYNC_EVENT_NEW_ISCSI_CONN event right?

Yeah you are right Mike.
When FW logs to any persistent target on the adapter, an ASYNC_EVENT is sent to the driver. In this case when login to boot-target happens driver gets the ASYNC_EVENT and iscsi-boot info will be populated in the sysfs.