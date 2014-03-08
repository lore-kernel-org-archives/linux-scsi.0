From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 3/3] scsi: async sd resume
Date: Fri, 7 Mar 2014 16:41:22 -0800
Message-ID: <CAPcyv4hKrjQUuRHQCB9S5q3kVwVSKwG6n_Pi6NCeGmh3O4tn6A@mail.gmail.com>
References: <20140305201740.20088.85890.stgit@viggo.jf.intel.com>
	<Pine.LNX.4.44L0.1403071028440.1246-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1403071028440.1246-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>, Len Brown <len.brown@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Phillip Susi <psusi@ubuntu.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, Todd Brandt <todd.e.brandt@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 7, 2014 at 7:42 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 5 Mar 2014, Dan Williams wrote:
>
>> async_schedule() sd resume work to allow disks and other devices to
>> resume in parallel.
>>
>> This moves the entirety of scsi_device resume to an async context to
>> ensure that scsi_device_resume() remains ordered with respect to the
>> completion of the start/stop command.  For the duration of the resume,
>> new command submissions (that do not originate from the scsi-core) will
>> be deferred (BLKPREP_DEFER).
>>
>> It adds a new ASYNC_DOMAIN_EXCLUSIVE(scsi_sd_pm_domain) as a container
>> of these operations.  Like scsi_sd_probe_domain it is flushed at
>> sd_remove() time to ensure async ops do not continue past the
>> end-of-life of the sdev.  The implementation explicitly refrains from
>> reusing scsi_sd_probe_domain directly for this purpose as it is flushed
>> at the end of dpm_resume(), potentially defeating some of the benefit.
>> Given sdevs are quiesced it is permissible for these resume operations
>> to bleed past the async_synchronize_full() calls made by the driver
>> core.
>>
>> We defer the resolution of which pm callback to call until
>> scsi_dev_type_{suspend|resume} time and guarantee that the 'int
>> (*cb)(struct device *)' parameter is never NULL.  With this in place the
>> type of resume operation is encoded in the async function identifier.
>>
>> Inspired by Todd's analysis and initial proposal [2]:
>> https://01.org/suspendresume/blogs/tebrandt/2013/hard-disk-resume-optimization-simpler-approach
>>
>> Cc: Len Brown <len.brown@intel.com>
>> Cc: Phillip Susi <psusi@ubuntu.com>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Suggested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
>> [djbw: kick all resume work to the async queue]
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>
>> --- a/drivers/scsi/scsi_pm.c
>> +++ b/drivers/scsi/scsi_pm.c
>> @@ -18,17 +18,52 @@
>>
>>  #ifdef CONFIG_PM_SLEEP
>>
>> +#define do_pm_op(dev, op) \
>> +     dev->driver ? dev->driver->pm ? \
>> +     dev->driver->pm->op(dev) : 0 : 0
>
> This will crash if dev->driver->pm->op is NULL.  How about making it
> easier to read, too?
>
> #define RETURN_PM_OP(dev, op)                                           \
>         if (dev->driver && dev->driver->pm && dev->driver->pm->op)      \
>                 return dev->driver->pm->op(dev);                        \
>         else                                                            \
>                 return 0
>
> static int do_scsi_suspend(struct device *dev)
> {
>         RETURM_PM_OP(dev, suspend);
> }
>
> etc.
>
> Alternatively, you could put the "dev->driver && dev->driver->pm" part
> of the test directly into scsi_dev_type_suspend and
> scsi_dev_type_resume, to save a little code space.  Then the original
> macro formulation would become sufficiently simple: one test and one
> function call.

I like that better than hiding too much (especially bugs) in the macro.

>
>> +static int do_scsi_suspend(struct device *dev)
>> +{
>> +     return do_pm_op(dev, suspend);
>> +}
>> +
>> +static int do_scsi_freeze(struct device *dev)
>> +{
>> +     return do_pm_op(dev, freeze);
>> +}
>> +
>> +static int do_scsi_poweroff(struct device *dev)
>> +{
>> +     return do_pm_op(dev, poweroff);
>> +}
>> +
>> +static int do_scsi_resume(struct device *dev)
>> +{
>> +     return do_pm_op(dev, resume);
>> +}
>> +
>> +static int do_scsi_thaw(struct device *dev)
>> +{
>> +     return do_pm_op(dev, thaw);
>> +}
>> +
>> +static int do_scsi_restore(struct device *dev)
>> +{
>> +     return do_pm_op(dev, restore);
>> +}
>> +
>>  static int scsi_dev_type_suspend(struct device *dev, int (*cb)(struct device *))
>>  {
>>       int err;
>>
>> +     /* flush pending in-flight resume operations, suspend is synchronous */
>> +     async_synchronize_full_domain(&scsi_sd_pm_domain);
>> +
>>       err = scsi_device_quiesce(to_scsi_device(dev));
>>       if (err == 0) {
>> -             if (cb) {
>> -                     err = cb(dev);
>> -                     if (err)
>> -                             scsi_device_resume(to_scsi_device(dev));
>> -             }
>> +             err = cb(dev);
>> +             if (err)
>> +                     scsi_device_resume(to_scsi_device(dev));
>>       }
>>       dev_dbg(dev, "scsi suspend: %d\n", err);
>>       return err;
>> @@ -38,10 +73,16 @@ static int scsi_dev_type_resume(struct device *dev, int (*cb)(struct device *))
>>  {
>>       int err = 0;
>>
>> -     if (cb)
>> -             err = cb(dev);
>> +     err = cb(dev);
>>       scsi_device_resume(to_scsi_device(dev));
>>       dev_dbg(dev, "scsi resume: %d\n", err);
>> +
>> +     if (err == 0) {
>> +             pm_runtime_disable(dev);
>> +             pm_runtime_set_active(dev);
>> +             pm_runtime_enable(dev);
>> +     }
>> +
>>       return err;
>>  }
>>
>> @@ -66,20 +107,50 @@ scsi_bus_suspend_common(struct device *dev, int (*cb)(struct device *))
>>       return err;
>>  }
>>
>> +static void async_sdev_resume(void *dev, async_cookie_t cookie)
>> +{
>> +     scsi_dev_type_resume(dev, do_scsi_resume);
>> +}
>> +
>> +static void async_sdev_thaw(void *dev, async_cookie_t cookie)
>> +{
>> +     scsi_dev_type_resume(dev, do_scsi_thaw);
>> +}
>> +
>> +static void async_sdev_restore(void *dev, async_cookie_t cookie)
>> +{
>> +     scsi_dev_type_resume(dev, do_scsi_restore);
>> +}
>> +
>> +static async_func_t to_async_sdev_resume_fn(struct device *dev,
>> +             int (*cb)(struct device *))
>> +{
>> +     if (!scsi_is_sdev_device(dev))
>> +             return NULL;
>> +
>> +     if (cb == do_scsi_resume)
>> +             return async_sdev_resume;
>> +     else if (cb == do_scsi_thaw)
>> +             return async_sdev_thaw;
>> +     else if (cb == do_scsi_restore)
>> +             return async_sdev_restore;
>> +     else
>> +             return NULL;
>> +}
>
> Given that this function is used in only one place; I would put it
> inline.

Personal preference, but since you mention it, sure.
