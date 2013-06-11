From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH RESEND] scsi: Introduce a help function local_time_seconds()
 to simplify the getting time stamp operation
Date: Tue, 11 Jun 2013 09:39:48 +0800
Message-ID: <51B67FE4.4060103@cn.fujitsu.com>
References: <51B53293.7090100@cn.fujitsu.com> <1370886422.1936.27.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1370886422.1936.27.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/11/2013 01:47 AM, James Bottomley wrote:

> On Mon, 2013-06-10 at 09:57 +0800, Gu Zheng wrote:
>> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
>> index 66216c1..f3377ca 100644
>> --- a/include/scsi/scsi.h
>> +++ b/include/scsi/scsi.h
>> @@ -574,4 +574,13 @@ static inline __u32 scsi_to_u32(__u8 *ptr)
>>         return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
>>  }
>>  
>> +/*
>> + * Convert system time in UTC to local time seconds.
>> + */
>> +static inline u32 local_time_seconds(void)
>> +{
>> +       struct timeval utc;
>> +       do_gettimeofday(&utc);
>> +       return (u32)(utc.tv_sec - (sys_tz.tz_minuteswest * 60));
>> +}
>>  #endif /* _SCSI_SCSI_H */
> 
> This doesn't belong in SCSI.
> 
> It's not a common pattern, so just leave it open coded in the 3ware
> drivers.  If there's a need for it to be a common pattern, John Stultz
> will add it to the timer code, but at the moment, he doesn't seem to see
> the need.

Hi James,
OK...Thanks for your reminder.
As you mentioned in an old thread, what about using "jiffies to seconds" to replace
the existed timestamps?

Best regards,
Gu



> 
> James
> 
> 
> 
