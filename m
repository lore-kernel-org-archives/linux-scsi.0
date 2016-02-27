From: "dbasehore ." <dbasehore@chromium.org>
Subject: Re: [PATCH v2 3/3] scsi: allow scsi devices to use direct complete
Date: Sat, 27 Feb 2016 00:10:03 -0800
Message-ID: <CAGAzgsoAiL0Xmqi3gzNyuQ6kf47UiEsO3V6-WMgkd5-Wu2y42Q@mail.gmail.com>
References: <1456359748-22838-1-git-send-email-dbasehore@chromium.org>
	<1456359748-22838-3-git-send-email-dbasehore@chromium.org>
	<20160227072641.GX1770@lahna.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20160227072641.GX1770@lahna.fi.intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

A device is not able to use direct complete if its children do not
also use direct complete. Even though the SCSI layer leaves devices
runtime suspended, the way it does it still prevents its parent from
using direct complete.

On Fri, Feb 26, 2016 at 11:26 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Wed, Feb 24, 2016 at 04:22:28PM -0800, Derek Basehore wrote:
>> This allows scsi devices to remain runtime suspended for system
>> suspend. Since runtime suspend is stricter than system suspend
>> callbacks, this is just returning a positive number for the prepare
>> callback.
>
> AFAICT SCSI layer already leaves devices runtime suspended during system
> suspend (see scsi_bus_suspend_common()). What's the benefit using
> direct_complete over the current implementation?
>
>> Signed-off-by: Derek Basehore <dbasehore@chromium.org>
>> Reviewed-by: Eric Caruso <ejcaruso@chromium.org>
>> ---
>>  drivers/scsi/scsi_pm.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
>> index b44c1bb..7af76ad 100644
>> --- a/drivers/scsi/scsi_pm.c
>> +++ b/drivers/scsi/scsi_pm.c
>> @@ -178,7 +178,7 @@ static int scsi_bus_prepare(struct device *dev)
>>               /* Wait until async scanning is finished */
>>               scsi_complete_async_scans();
>>       }
>> -     return 0;
>> +     return 1;
>>  }
>>
>>  static int scsi_bus_suspend(struct device *dev)
>> --
>> 2.7.0.rc3.207.g0ac5344
