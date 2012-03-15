From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [isci PATCH v3 3/4] libsas: suspend / resume support
Date: Thu, 15 Mar 2012 12:28:52 -0700
Message-ID: <CABE8wwvmCnVEhW8yKVua9Zt+jPCK6kzyjm7poE_7D4ihDhZrHg@mail.gmail.com>
References: <Pine.LNX.4.44L0.1203141654460.1644-100000@iolanthe.rowland.org>
	<1331760786.17334.18.camel@ultramagnus.opencreations.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1331760786.17334.18.camel@ultramagnus.opencreations.com>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 14, 2012 at 2:33 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> On Wed, 2012-03-14 at 17:11 -0400, Alan Stern wrote:
>> I see. =A0It's a nasty situation; I guess the best way to describe i=
t is
>> a conflict between the requirements of the PM and SCSI subsystems:
>>
>> =A0 =A0 =A0 The PM core runs suspend and resume operations in async
>> =A0 =A0 =A0 threads, and these threads need to acquire the device lo=
ck;
>>
>> =A0 =A0 =A0 The sd driver needs to insure that async probing is fini=
shed
>> =A0 =A0 =A0 when starting its remove routine, and it is called with =
the
>> =A0 =A0 =A0 device lock held.
>>
>> The best solution might be to use a workqueue for sd's async probing
>> instead of the "async" threads. =A0Then the work routine could be
>> cancelled without doing async_synchronize_full().
>
> Hmm... I was wondering why we needed a kernel global sync. =A0If this=
 is
> just for probe work what about just doing something like the followin=
g?
> Keep the sync operation local to probe-work and not entangle with the
> resume-work? =A0I'll give this a shot when I get back to my test syst=
em.
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index bd17cf8..ec69e35 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2629,6 +2629,8 @@ static void sd_probe_async(void *data, async_co=
okie_t cookie)
> =A0 =A0 =A0 =A0put_device(&sdkp->dev);
> =A0}
>
> +static LIST_HEAD(sd_probe_domain);
> +
> =A0/**
> =A0* =A0 =A0 sd_probe - called during driver initialization and whene=
ver a
> =A0* =A0 =A0 new scsi device is attached to the system. It is called =
once
> @@ -2717,7 +2719,7 @@ static int sd_probe(struct device *dev)
> =A0 =A0 =A0 =A0dev_set_drvdata(dev, sdkp);
>
> =A0 =A0 =A0 =A0get_device(&sdkp->dev); /* prevent release before asyn=
c_schedule */
> - =A0 =A0 =A0 async_schedule(sd_probe_async, sdkp);
> + =A0 =A0 =A0 async_schedule_domain(sd_probe_async, sdkp, &sd_probe_d=
omain);
>
> =A0 =A0 =A0 =A0return 0;
>
> @@ -2751,7 +2753,7 @@ static int sd_remove(struct device *dev)
> =A0 =A0 =A0 =A0sdkp =3D dev_get_drvdata(dev);
> =A0 =A0 =A0 =A0scsi_autopm_get_device(sdkp->device);
>
> - =A0 =A0 =A0 async_synchronize_full();
> + =A0 =A0 =A0 async_synchronize_full_domain(&sd_probe_domain);
> =A0 =A0 =A0 =A0blk_queue_prep_rq(sdkp->device->request_queue, scsi_pr=
ep_fn);
> =A0 =A0 =A0 =A0blk_queue_unprep_rq(sdkp->device->request_queue, NULL)=
;
> =A0 =A0 =A0 =A0device_del(&sdkp->dev);

This works fine for me for resolving the deadlock, but I found I also
needed the following to fix a spurious:

   scsi 6:0:1:0: Illegal state transition deleted->running

=2E..in the resume path.

@@ -2348,10 +2349,11 @@ EXPORT_SYMBOL(scsi_device_quiesce);
  *
  *     Must be called with user context, may sleep.
  */
-void
-scsi_device_resume(struct scsi_device *sdev)
+void scsi_device_resume(struct scsi_device *sdev)
 {
-       if(scsi_device_set_state(sdev, SDEV_RUNNING))
+       /* check if the device was deleted during suspend */
+       if (sdev->sdev_state =3D=3D SDEV_DEL ||
+           scsi_device_set_state(sdev, SDEV_RUNNING))
                return;
        scsi_run_queue(sdev->request_queue);
 }

Unless someone can point out something I'm missing I'll go ahead and
roll this into it's own patch and rebase/drop the hack out of the
libsas resume code.

--
Dan
