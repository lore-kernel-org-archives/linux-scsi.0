From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH] mpt3sas - remove unused fw_event_work delayed_work
Date: Fri, 1 Apr 2016 15:13:40 -0400
Message-ID: <56FEC864.5050008@stratus.com>
References: <1459533389-19648-1-git-send-email-joe.lawrence@stratus.com>
 <1459536717.30035.113.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:62628
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752722AbcDATrZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 15:47:25 -0400
In-Reply-To: <1459536717.30035.113.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Calvin Owens <calvinowens@fb.com>

On 04/01/2016 02:51 PM, Ewan D. Milne wrote:
> On Fri, 2016-04-01 at 13:56 -0400, Joe Lawrence wrote:
>> @@ -2804,12 +2803,12 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
>>  		/*
>>  		 * Wait on the fw_event to complete. If this returns 1, then
>>  		 * the event was never executed, and we need a put for the
>> -		 * reference the delayed_work had on the fw_event.
>> +		 * reference the work had on the fw_event.
>>  		 *
>>  		 * If it did execute, we wait for it to finish, and the put will
>>  		 * happen from _firmware_event_work()
>>  		 */
>> -		if (cancel_delayed_work_sync(&fw_event->delayed_work))
>> +		if (cancel_work_sync(&fw_event->work))
>>  			fw_event_work_put(fw_event);
>>  
>>  		fw_event_work_put(fw_event);
> 
> Hmm... Fixes: 146b16c8 (mpt3sas: Refcount fw_events and fix unsafe list usage)

This could technically go back to f92363d12359 (mpt3sas: add new driver
supporting 12GB SAS) ...  but will probably only apply cleanly to
_scsih_fw_event_cleanup_queue after 146b16c8 (mpt3sas: Refcount
fw_events and fix unsafe list usage), so you're right.

> Since mpt3sas uses ->work instead of _delayed_work this would seem to be
> correct, however the deprecated mpt2sas driver had a commit that changed
> the firmware event work mechanism to use ->delayed_work instead of ->work:
> 
> commit f1c35e6aea579d5bdb6dc02dfa99c67c7c3b3f67
> Author: Kashyap, Desai <kashyap.desai@lsi.com>
> Date:   Tue Mar 9 16:31:43 2010 +0530

Okay, so this is pre-mpt3sas split.

>     [SCSI] mpt2sas: RESCAN Barrier work is added in case of HBA reset.
>     
>     Add the cancel_pending_work flag from the fw_event_work structure, and then to
>     set the flag during host reset, check the flag later from work threads
>     context and if cancel_pending_work_flag is set ingore those events.

More unused mpt2 vestiges in the mpt3 version?

% cd drivers/scsi/mpt3sas/
% grep 'cancel_pending_work' *.{c,h}
mpt3sas_scsih.c: * @cancel_pending_work: flag set during reset handling
mpt3sas_scsih.c:        u8                      cancel_pending_work;

>     Now Rescan after host reset is changed.
>     Added special task MPT2SAS_RESCAN_AFTER_HOST_RESET. This task will be queued
>     at the time of HBA reset. this task is treated as barrier. All work after
>     MPT2SAS_RESCAN_AFTER_HOST_RESET will be treated as new work and will be
>     server by callback handle. If host_recovery is going on while running RESCAN
>     task, it will wait for shos_recovery_done completion which will be called
>     from HBA reset DONE context.

FWIW, I don't see anything like this in today's mpt3sas driver.

Regards,

-- Joe
