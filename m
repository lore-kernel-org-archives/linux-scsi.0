From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: Re: [PATCH] lpfc: fix the max value of lpfc_log_verbose
Date: Wed, 03 Feb 2010 13:09:52 +0900
Message-ID: <4B68F710.7070509@jp.fujitsu.com>
References: <4B666AC4.10109@jp.fujitsu.com> <4B66D89D.8060505@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45795 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab0BCEKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2010 23:10:21 -0500
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o134AJO7010085
	for <linux-scsi@vger.kernel.org> (envelope-from tokunaga.keiich@jp.fujitsu.com);
	Wed, 3 Feb 2010 13:10:20 +0900
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id BF7E445DE4D
	for <linux-scsi@vger.kernel.org>; Wed,  3 Feb 2010 13:10:19 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 954A245DE50
	for <linux-scsi@vger.kernel.org>; Wed,  3 Feb 2010 13:10:19 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 777451DB803B
	for <linux-scsi@vger.kernel.org>; Wed,  3 Feb 2010 13:10:19 +0900 (JST)
Received: from m024.s.css.fujitsu.com (m024.s.css.fujitsu.com [10.0.81.64])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 13A371DB8037
	for <linux-scsi@vger.kernel.org>; Wed,  3 Feb 2010 13:10:19 +0900 (JST)
In-Reply-To: <4B66D89D.8060505@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

James Smart wrote:
> Nack...   I'd rather move it to an unsigned int.  In any case, Emulex
> will take care of this issue in its next patch series.

Sure.  That's totally fine with me.  Thanks for taking care of this!

Kei


> -- james s
> 
> 
> Kei Tokunaga wrote:
>> Hi,
>>
>> The max value of lpfc_log_verbose is intended to be 0xffffffff, but since
>> it was treated as int, 0xffffffff was not actually accepted.  Correcting
>> it to the actual max value (0x7fffffff)  (Bits up to 18th are defined and
>> bits up to 15th are actually used today.)
>>
>> This is the message when tried to store 0xffffffff to lpfc_log_verbose.
>>
>>   kernel: lpfc 0000:02:03.0: 0:(0):0424 lpfc_log_verbose attribute
>> cannot be set to -1, allowed range is [0x0, 0xffffffff]
>>
>> Changing its type from 'int' to 'unsigned int' might be another option.
>>
>> Signed-off-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
>>
>>
>> ---
>>
>>  linux-2.6.33-rc5-v-kei/drivers/scsi/lpfc/lpfc_attr.c   |    2 +-
>>  linux-2.6.33-rc5-v-kei/drivers/scsi/lpfc/lpfc_logmsg.h |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff -puN drivers/scsi/lpfc/lpfc_attr.c~fix_max_of_log_verbose
>> drivers/scsi/lpfc/lpfc_attr.c
>> ---
>> linux-2.6.33-rc5-v/drivers/scsi/lpfc/lpfc_attr.c~fix_max_of_log_verbose   
>> 2010-01-25 20:23:43.000000000 +0900
>> +++ linux-2.6.33-rc5-v-kei/drivers/scsi/lpfc/lpfc_attr.c    2010-01-25
>> 20:24:06.000000000 +0900
>> @@ -2086,7 +2086,7 @@ static DEVICE_ATTR(lpfc_devloss_tmo, S_I
>>  # You can set a bit mask to record specific types of verbose messages:
>>  # See lpfc_logmsh.h for definitions.
>>  */
>> -LPFC_VPORT_ATTR_HEX_RW(log_verbose, 0x0, 0x0, 0xffffffff,
>> +LPFC_VPORT_ATTR_HEX_RW(log_verbose, 0x0, 0x0, 0x7fffffff,
>>                 "Verbose logging bit-mask");
>>  
>>  /*
>> diff -puN drivers/scsi/lpfc/lpfc_logmsg.h~fix_max_of_log_verbose
>> drivers/scsi/lpfc/lpfc_logmsg.h
>> ---
>> linux-2.6.33-rc5-v/drivers/scsi/lpfc/lpfc_logmsg.h~fix_max_of_log_verbose   
>> 2010-01-25 20:24:24.000000000 +0900
>> +++ linux-2.6.33-rc5-v-kei/drivers/scsi/lpfc/lpfc_logmsg.h   
>> 2010-01-25 20:24:55.000000000 +0900
>> @@ -35,7 +35,7 @@
>>  #define LOG_VPORT    0x00004000    /* NPIV events */
>>  #define LOF_SECURITY    0x00008000    /* Security events */
>>  #define LOG_EVENT    0x00010000    /* CT,TEMP,DUMP, logging */
>> -#define LOG_ALL_MSG    0xffffffff    /* LOG all messages */
>> +#define LOG_ALL_MSG    0x7fffffff    /* LOG all messages */
>>  
>>  #define lpfc_printf_vlog(vport, level, mask, fmt, arg...) \
>>  do { \
>>
>> _
>>
>>
>>
>>
> 
> 

