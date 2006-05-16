From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [REPOST][PATCH] update max sdev block limit
Date: Tue, 16 May 2006 12:05:19 -0400
Message-ID: <4469F83F.4030407@emulex.com>
References: <1147358563.3507.4.camel@localhost.localdomain> <4469EB45.7070104@sgi.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:4844 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1751828AbWEPQC7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 12:02:59 -0400
In-Reply-To: <4469EB45.7070104@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi@vger.kernel.org

I don't mind making it bigger, especially as this is just a max, not the
default value. I tried to keep it low, as I believe even 2 mins is a long
time from the system's perspective. 10 minutes is forever (and remember
the scan deadlock that we just worked through).

-- james


Michael Reed wrote:
> I disagree with this patch.
> 
> My personal opinion is that the previous value of 6000 (assume HZ==100),
> or around 1 hour 40 minutes, was probably too long.  But, 120 seconds is too
> short.  I would suggest a MAX value of maybe 10 minutes, or 600 seconds.
> It appears that introducing an upper bound which is now more than an order
> of magnitude smaller than the previous value could have some impact at
> customer sites.
> 
> There are raid devices which require around 200+ seconds to crash, dump,
> reboot, and return on line.  (Yes, I've timed it!)
> 
> Mike
> 
> 
> James Smart wrote:
>> Updated patch to address comments from Andreas Herrman, who noted that
>> the initialization, with the HZ, was inconsistent with its use in the
>> FC transport.
>> --
>> This patch ups the maximum limit for how long an sdev is allowed to
>> be blocked. Originally, the value was 60 seconds. However, we are aware
>> of array failover and switch reboot times that can be as high
>> as 90 seconds. We're proposing to change the max to 120 seconds.
>>
>> -- james s
>>
>>
>> Signed-off-by: James Smart <James.Smart@emulex.com>
>>
>> diff -upNr a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
>> --- a/drivers/scsi/scsi_priv.h	2006-05-10 11:36:25.000000000 -0400
>> +++ b/drivers/scsi/scsi_priv.h	2006-05-11 10:37:57.000000000 -0400
>> @@ -127,7 +127,7 @@ extern struct bus_type scsi_bus_type;
>>   * classes.
>>   */
>>  
>> -#define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	(HZ*60)
>> +#define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	120	/* units in seconds */
>>  extern int scsi_internal_device_block(struct scsi_device *sdev);
>>  extern int scsi_internal_device_unblock(struct scsi_device *sdev);
>>  
>>
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> 
