From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/21] uas: replace WARN_ON_ONCE() with lockdep_assert_held()
Date: Wed, 10 Sep 2014 17:02:34 +0200
Message-ID: <5410680A.8020107@redhat.com>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com> <1410349611-17573-2-git-send-email-hdegoede@redhat.com> <54106271.5090909@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54106271.5090909-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sanjeev Sharma <Sanjeev_Sharma-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On 09/10/2014 04:38 PM, Peter Hurley wrote:
> [ +cc Peter Zijlstra, Ingo Molnar ]
> 
> On 09/10/2014 07:46 AM, Hans de Goede wrote:
>> From: Sanjeev Sharma <Sanjeev_Sharma-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
>>
>> On some architecture spin_is_locked() always return false in
>> uniprocessor configuration and therefore it would be advise to replace
>> with lockdep_assert_held().
>>
>> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/usb/storage/uas.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
>> index 3f42785..05b2d8e 100644
>> --- a/drivers/usb/storage/uas.c
>> +++ b/drivers/usb/storage/uas.c
>> @@ -154,7 +154,7 @@ static void uas_mark_cmd_dead(struct uas_dev_info *devinfo,
>>  	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
>>  
>>  	uas_log_cmd_state(cmnd, caller);
>> -	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
>> +	lockdep_assert_held(&devinfo->lock);
> 
> This change isn't equivalent.
> 
> lockdep_assert_held() will continue to emit warnings; ie., there is no
> "once" functionality. Same for the other changes below.

Given that these should really never ever happen, that is not really a problem
IMHO. The idea ws to replace the wrong use of spin_is_locked with some
other sanity check, preferably a light weight one, the once behavior is not
that important.

Regards,

Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
