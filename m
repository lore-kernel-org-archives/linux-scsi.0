From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH V2 1/4]  be2iscsi : Fix the retry count for boot targets
Date: Mon, 22 Dec 2014 17:54:54 -0600
Message-ID: <5498AF4E.1030903@cs.wisc.edu>
References: <9c2f23ac-73ce-4b8a-aa91-a64f01d345fd@CMEXHTCAS2.ad.emulex.com> <5498ADA9.7080104@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57944 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbaLVXzC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Dec 2014 18:55:02 -0500
In-Reply-To: <5498ADA9.7080104@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@Emulex.Com>, linux-scsi@vger.kernel.org
Cc: Minh Tran <minhduc.tran@Emulex.Com>, Jayamohan Kallickal <jayamohan.kallickal@Emulex.Com>

On 12/22/2014 05:47 PM, Mike Christie wrote:
> On 12/19/2014 06:51 PM, John Soni Jose wrote:
>> @@ -5376,8 +5387,14 @@ beiscsi_hw_health_check(struct work_struct *work)
>>  	be_eqd_update(phba);
>>  
>>  	if (phba->state & BE_ADAPTER_CHECK_BOOT) {
>> -		phba->state &= ~BE_ADAPTER_CHECK_BOOT;
>> -		be_check_boot_session(phba);
>> +		if ((phba->get_boot > 0) && (!phba->boot_kset)) {
>> +			phba->get_boot--;
>> +			if (!(phba->get_boot % BE_GET_BOOT_TO))
>> +				be_check_boot_session(phba);
>> +		} else {
>> +			phba->state &= ~BE_ADAPTER_CHECK_BOOT;
>> +			phba->get_boot = 0;
>> +		}
>>  	}
> 
> Hey, I just want to make sure I am reading this patch correctly. If the
> user had the network up, but the target was not able to handle the login
> for longer than the timeout we are adding in this patch, then we will
> not be able to get any notification (the iscsi boot info would not show
> up in sysfs) later when we can login.
> 

Actually, I think I am wrong. If we hit the above scenario, then
eventually the fw would log in and we would then get a
ASYNC_EVENT_NEW_ISCSI_CONN event right?

