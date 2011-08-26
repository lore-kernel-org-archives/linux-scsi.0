From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [PATCH] [SCSI] fusion: ensure NUL-termination of MptCallbacksName elements
Date: Fri, 26 Aug 2011 19:01:33 +0200
Message-ID: <87k4a0gl8y.fsf@tac.ki.iif.hu>
References: <cd21dfb714e3a89aadd8eda1fda1748dec9ed7aa.1314276422.git.wferi@niif.hu>
	<20110825145915.abde72e2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:43320 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab1HZRBn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2011 13:01:43 -0400
In-Reply-To: <20110825145915.abde72e2.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 25 Aug 2011 14:59:15 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kashyap,  Desai" <kashyap.desai@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 25 Aug 2011 14:44:57 +0200
> Ferenc Wagner <wferi@niif.hu> wrote:
>
>> Signed-off-by: Ferenc Wagner <wferi@niif.hu>
>
> The lack of a changelog is a hint that the patch needed a changelog!

Sorry, I thought repeating the subject wasn't useful.  I could also talk
a little about removing a magic number, but that's about it...

Concerning the checkpatch fixup patch, I decided that mptbase.c
contained overfull lines already, so I'd better keep these on a single
line.  Of course I don't argue for this the least.

>> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
>> index 7956a10..eb906e2 100644
>> --- a/drivers/message/fusion/mptbase.c
>> +++ b/drivers/message/fusion/mptbase.c
>> @@ -113,7 +113,7 @@ module_param(mpt_fwfault_debug, int, 0600);
>>  MODULE_PARM_DESC(mpt_fwfault_debug,
>>  		 "Enable detection of Firmware fault and halt Firmware on fault - (default=0)");
>>  
>> -static char	MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][50];
>> +static char	MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][MPT_MAX_CALLBACKNAME_LEN+1];
>>  
>>  #ifdef MFCNT
>>  static int mfcounter = 0;
>> @@ -656,8 +656,7 @@ mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass, char *func_name)
>>  			MptDriverClass[cb_idx] = dclass;
>>  			MptEvHandlers[cb_idx] = NULL;
>>  			last_drv_idx = cb_idx;
>> -			memcpy(MptCallbacksName[cb_idx], func_name,
>> -			    strlen(func_name) > 50 ? 50 : strlen(func_name));
>> +			strlcpy(MptCallbacksName[cb_idx], func_name, MPT_MAX_CALLBACKNAME_LEN+1);
>>  			break;
>>  		}
>>  	}
>> diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
>> index fe90233..c10416d 100644
>> --- a/drivers/message/fusion/mptbase.h
>> +++ b/drivers/message/fusion/mptbase.h
>> @@ -89,6 +89,7 @@
>>   */
>>  #define MPT_MAX_ADAPTERS		18
>>  #define MPT_MAX_PROTOCOL_DRIVERS	16
>> +#define MPT_MAX_CALLBACKNAME_LEN	49
>>  #define MPT_MAX_BUS			1	/* Do not change */
>>  #define MPT_MAX_FC_DEVICES		255
>>  #define MPT_MAX_SCSI_DEVICES		16
>
> Does the patch fix some real-world observed problem?  If so, please
> fully describe it.

Not at all, I just stumbled upon this while pondering over
https://bugzilla.kernel.org/show_bug.cgi?id=26692 and thought this could
be made better.  Actually, I can't see why copying the callback name is
necessary instead of simply storing a pointer to it (just like to the
callback function itself), but that goes beyond my scope, I'm afraid.

I'll send a v2 of this patch in a couple of days with shorter lines and
longer description.  Please all feel free to express opinions about the
name of the constant, the +1s and/or the spaces around the binop, etc. :)
-- 
Thanks,
Feri.
