From: "dbasehore ." <dbasehore@chromium.org>
Subject: Re: [PATCH v2 2/3] PM / sleep: try to runtime suspend for direct complete
Date: Tue, 1 Mar 2016 13:48:06 -0800
Message-ID: <CAGAzgsrO6k0L8zeKhhWF+A6uFsWfW2bbb5poLOzy_NGinvs3hQ@mail.gmail.com>
References: <1456359748-22838-1-git-send-email-dbasehore@chromium.org>
	<1456359748-22838-2-git-send-email-dbasehore@chromium.org>
	<3183435.BG93qPHVgS@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3183435.BG93qPHVgS@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux-pm mailing list <linux-pm@vger.kernel.org>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 27, 2016 at 5:31 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Wednesday, February 24, 2016 04:22:27 PM Derek Basehore wrote:
>> This tries to runtime suspend devices that are still active for direct
>> complete. This is for cases such as autosuspend delays which leaves
>> devices able to runtime suspend but still active. It's beneficial in
>> this case to runtime suspend the device to take advantage of direct
>> complete when possible.
>>
>> Signed-off-by: Derek Basehore <dbasehore@chromium.org>
>> Reviewed-by: Eric Caruso <ejcaruso@chromium.org>
>> ---
>>  drivers/base/power/main.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
>> index e0017d9..9693032 100644
>> --- a/drivers/base/power/main.c
>> +++ b/drivers/base/power/main.c
>> @@ -1380,7 +1380,12 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>>               goto Complete;
>>
>>       if (dev->power.direct_complete) {
>> -             if (pm_runtime_status_suspended(dev)) {
>> +             /*
>> +              * Check if we're runtime suspended. If not, try to runtime
>> +              * suspend for autosuspend cases.
>> +              */
>> +             if (pm_runtime_status_suspended(dev) ||
>> +                 !pm_runtime_suspend(dev)) {
>>                       pm_runtime_disable(dev);
>>                       if (pm_runtime_status_suspended(dev))
>>                               goto Complete;
>>
>
> This can be done somewhat simpler, because pm_runtime_suspend() will check
> if the device has already been suspended:
>
>         ret = pm_runtime_suspend(dev);
>         if (ret >= 0) {
>
> and you don't need the extra pm_runtime_status_suspended(dev) check.
>
> Thanks,
> Rafael
>

I'll look into simplifying it for the next patch set.
