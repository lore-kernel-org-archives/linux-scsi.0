From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 01/12] scsi_debug: cleanup naming and bit crunching
Date: Wed, 27 Apr 2016 01:25:04 -0400
Message-ID: <57204D30.7020707@interlog.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
 <1461600999-28893-2-git-send-email-dgilbert@interlog.com>
 <571FAFD2.3030902@sandisk.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:35867 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbcD0FZM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 01:25:12 -0400
In-Reply-To: <571FAFD2.3030902@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 2016-04-26 02:13 PM, Bart Van Assche wrote:
> On 04/25/2016 09:16 AM, Douglas Gilbert wrote:
>> @@ -580,8 +580,8 @@ static int sdebug_sectors_per;        /* sectors per
>> cylinder */
>>
>>   static unsigned int scsi_debug_lbp(void)
>>   {
>> -    return ((0 == scsi_debug_fake_rw) &&
>> -        (scsi_debug_lbpu | scsi_debug_lbpws | scsi_debug_lbpws10));
>> +    return ((0 == sdebug_fake_rw) &&
>> +        (sdebug_lbpu | sdebug_lbpws | sdebug_lbpws10));
>>   }
>
> Since you are changing this code, please remove the superfluous parentheses,
> place the constant at the right side of the comparison and change "|" into "||"
> since the intention of the above code is to perform a logical or and this code
> is not in a performance-critical path.

Hmmm. I hadn't even noticed the bitwise ORs. Not sure why
Martin did that. Anyway I can change it.

BTW I had no intention of changing Martin's LB provisioning logic.
Those lines appear in the patch due to the name shortening.

>> +    sdebug_verbose = !!(SDEBUG_OPT_NOISE & sdebug_opts);
>> +    sdebug_any_injecting_opt = !!(SDEBUG_OPT_ALL_INJECTING & sdebug_opts);
>
> Same comment here: please put constants at the right side. I think the latest
> version of checkpatch requests to do so.

The whole patch series went through checkpatch.pl without
errors or warnings on linux-stable.git .

Doug Gilbert


