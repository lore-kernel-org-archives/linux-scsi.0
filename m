From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v11 6/9] Make scsi_remove_host() wait until error handling
 finished
Date: Mon, 24 Jun 2013 08:49:09 +0200
Message-ID: <51C7EBE5.4090503@acm.org>
References: <51B86E26.6030108@acm.org> <51B86FC1.6000103@acm.org> <51C79DA8.4030006@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:49343 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3FXGtM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jun 2013 02:49:12 -0400
In-Reply-To: <51C79DA8.4030006@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>

On 06/24/13 03:15, Mike Christie wrote:
> On 6/12/13 7:55 AM, Bart Van Assche wrote:
>> A SCSI LLD may start cleaning up host resources as soon as
>> scsi_remove_host() returns. These host resources may be needed by
>> the LLD in an implementation of one of the eh_* functions. So if
>> one of the eh_* functions is in progress when scsi_remove_host()
>> is invoked, wait until the eh_* function has finished. Also, do
>> not invoke any of the eh_* functions after scsi_remove_host() has
>> started. Remove Scsi_Host.tmf_in_progress because it is now
>> superfluous.
> 
> I think the patch looks ok for drivers that do not implement their own
> eh_strategy_handler, but what about SAS? If you added a scsi_begin_eh in 
> scsi_error_handler before the eh_strategy_handler is called and then add 
> a scsi_end_eh after it is called, I think it would cover them too.

I will start testing the modification below for the patch at the start of
this thread:

--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1950,10 +1950,14 @@ int scsi_error_handler(void *data)
                        continue;
                }
 
-               if (shost->transportt->eh_strategy_handler)
-                       shost->transportt->eh_strategy_handler(shost);
-               else
+               if (shost->transportt->eh_strategy_handler) {
+                       if (scsi_begin_eh(shost) == 0) {
+                               shost->transportt->eh_strategy_handler(shost);
+                               scsi_end_eh(shost);
+                       }
+               } else {
                        scsi_unjam_host(shost);
+               }
 
                /*
                 * Note - if the above fails completely, the action is to take


>> @@ -1894,6 +1962,9 @@ int scsi_error_handler(void *data)
>>       }
>>       __set_current_state(TASK_RUNNING);
>>
>> +    WARN_ONCE(shost->eh_active, "scsi_eh_%d: eh_active = %d\n",
>> +          shost->host_no, shost->eh_active);
>> +
>>       SCSI_LOG_ERROR_RECOVERY(1,
>>           printk("Error handler scsi_eh_%d exiting\n", shost->host_no));
>>       shost->ehandler = NULL;
> 
> What is the warn for? Is there a chance this can happen with some non 
> upstream driver or are you just adding it just in case?

This is code that helped me to test this patch. I can leave it out if
you prefer so.

Bart.

