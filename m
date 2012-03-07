From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] scsi_lib: rate-limit the error message from failing commands
Date: Wed, 07 Mar 2012 14:17:17 +0100
Message-ID: <4F575FDD.5050406@redhat.com>
References: <20120305204242.6245.69668.stgit@localhost6.localdomain6> <4F562FD8.6040504@redhat.com> <138EA028228D124A900F5E6746F3C21605C5973A@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab2CGNRX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Mar 2012 08:17:23 -0500
In-Reply-To: <138EA028228D124A900F5E6746F3C21605C5973A@ORSMSX102.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zou, Yi" <yi.zou@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>

On 03/06/2012 06:10 PM, Zou, Yi wrote:
>> On 03/05/2012 09:42 PM, Yi Zou wrote:
>>> When performing a cable pull test w/ active stress I/O using fio over
>>> a dual port Intel 82599 FCoE CNA, w/ 256LUNs on one port and about
>> 32LUNs
>>> on the other, it is observed that the system becomes not usable due to
>>> scsi-ml being busy printing the error messages for all the failing
>> commands.
>>> I don't believe this problem is specific to FCoE and these commands are
>>> anyway failing due to link being down (DID_NO_CONNECT), just rate-limit
>>> the messages here to solve this issue.
>>>
>>> Signed-off-by: Yi Zou <yi.zou@intel.com>
>>> Cc: www.Open-FCoE.org <devel@open-fcoe.org>
>> Hi Zou,
>> you shouldn't use printk_ratelimit .
>> checkpatch says:  WARNING: Prefer printk_ratelimited or
>> pr_<level>_ratelimited to printk_ratelimit
>> Tomas
> Yes, I saw that when I did the checkpatch, but pratek_ratelimit() actually
> serves the purpose better, as it guards the block of the several scsi related
> prints that follow, and this works well particularly for this bug. For the worst
> case, the shared ratelimit surpresses everything here, blk i/o error report
> would still be able pick up printing something.
>
> If it is desired, which I doubt, I could change all scmd_printk, scsi_print_xxxx
> calls to use printk_ratelimited(), seems an overkill for this to me. I am open
> for a better solution.
For a whole block of commands you can use __ratelimit, so something like this
were possible:

@@ -20,6 +20,7 @@
 #include <linux/delay.h>
 #include <linux/hardirq.h>
 #include <linux/scatterlist.h>
+#include <linux/ratelimit.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -745,6 +746,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
        enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
              ACTION_DELAYED_RETRY} action;
        char *description = NULL;
+       static DEFINE_RATELIMIT_STATE(rs,  DEFAULT_RATELIMIT_INTERVAL,
+                                               DEFAULT_RATELIMIT_BURST);
 
        if (result) {
                sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
@@ -935,7 +938,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
        case ACTION_FAIL:
                /* Give up and fail the remainder of the request */
                scsi_release_buffers(cmd);
-               if (!(req->cmd_flags & REQ_QUIET)) {
+               if (!(req->cmd_flags & REQ_QUIET) &&  __ratelimit(&rs)) {
                        if (description)
                                scmd_printk(KERN_INFO, cmd, "%s\n",
                                            description);yi


>>> ---
>>>
>>>  drivers/scsi/scsi_lib.c |    3 ++-
>>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index b2c95db..e2128d9 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -934,7 +934,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
>> unsigned int good_bytes)
>>>  	case ACTION_FAIL:
>>>  		/* Give up and fail the remainder of the request */
>>>  		scsi_release_buffers(cmd);
>>> -		if (!(req->cmd_flags & REQ_QUIET)) {
>>> +		if (!(req->cmd_flags & REQ_QUIET) &&
>>> +		    printk_ratelimit()) {
>>>  			if (description)
>>>  				scmd_printk(KERN_INFO, cmd, "%s\n",
>>>  					    description);
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

