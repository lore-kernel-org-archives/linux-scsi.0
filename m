From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH v3 4/4] [SCSI] sd: change to auto suspend mode
Date: Thu, 24 May 2012 00:46:42 +0800
Message-ID: <CAF1ivSbUHpo-ia+xZY0EZ9vQ41f6NTN-Y-+FaO=AMom0t+Xkjw@mail.gmail.com>
References: <1337671292-15583-5-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1205231029520.1566-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1205231029520.1566-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 23, 2012 at 10:43 PM, Alan Stern <stern@rowland.harvard.edu=
> wrote:
> On Tue, 22 May 2012, Lin Ming wrote:
>
>> Uses block layer runtime pm helper functions in scsi_runtime_suspend=
/resume.
>> Remove scsi_autopm_* from sd open/release/remove path.
>
> Sorry I didn't have time to get to this yesterday...
>
>> --- a/drivers/scsi/scsi_pm.c
>> +++ b/drivers/scsi/scsi_pm.c
>
>> @@ -171,9 +183,10 @@ static int scsi_runtime_idle(struct device *dev=
)
>>
>> =A0 =A0 =A0 /* Insert hooks here for targets, hosts, and transport c=
lasses */
>>
>> - =A0 =A0 if (scsi_is_sdev_device(dev))
>> - =A0 =A0 =A0 =A0 =A0 =A0 err =3D pm_schedule_suspend(dev, 100);
>> - =A0 =A0 else
>> + =A0 =A0 if (scsi_is_sdev_device(dev)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 pm_runtime_mark_last_busy(dev);
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D pm_request_autosuspend(dev);
>
> This really should be pm_runtime_autosuspend(dev). =A0In practice the=
re's
> very little difference; it's mostly a matter of style.
>
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>
>> @@ -2631,7 +2624,7 @@ static void sd_probe_async(void *data, async_c=
ookie_t cookie)
>>
>> =A0 =A0 =A0 sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sdp->removable ? "removable " : "");
>> - =A0 =A0 scsi_autopm_put_device(sdp);
>> + =A0 =A0 pm_runtime_put_sync_autosuspend(&sdp->sdev_gendev);
>
> This should be left the way it was. =A0scsi_autopm_put_device() does
> pm_runtime_put_sync(), which will call scsi_runtime_idle(), which wil=
l
> now call pm_runtime_autosuspend().
>
>> =A0 =A0 =A0 put_device(&sdkp->dev);
>> =A0}
>>
>> @@ -2755,7 +2748,6 @@ static int sd_remove(struct device *dev)
>> =A0 =A0 =A0 struct scsi_disk *sdkp;
>>
>> =A0 =A0 =A0 sdkp =3D dev_get_drvdata(dev);
>> - =A0 =A0 scsi_autopm_get_device(sdkp->device);
>
> This line should be kept as is. =A0The SCSI core uses the incremented
> usage count to prevent driverless devices from being runtime-suspende=
d.

Will update.

Thanks a lot, Alan!

>
> Alan Stern
