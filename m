From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] How to fix an async scan - 'rmmod --wait' race?
Date: Tue, 22 May 2012 11:05:33 +0100
Message-ID: <1337681133.2932.4.camel@dabdike.int.hansenpartnership.com>
References: <4F7DA4F8.90104@redhat.com> <4F86CF34.2000906@redhat.com>
	   <4F8EF05F.8080307@redhat.com>
	  <1337244177.2926.21.camel@dabdike.int.hansenpartnership.com>
	  <4FB4BCEB.60506@acm.org>
	 <1337245278.30498.2.camel@dabdike.int.hansenpartnership.com>
	 <4FB51086.3060406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47899 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570Ab2EVKFh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2012 06:05:37 -0400
In-Reply-To: <4FB51086.3060406@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Mike Christie <mchristi@redhat.com>, stefanr@s5r6.in-berlin.de

On Thu, 2012-05-17 at 16:51 +0200, Tomas Henzl wrote:
> >>> diff --git a/drivers/base/driver.c b/drivers/base/driver.c
> >>> index 3ec3896..246e652 100644
> >>> --- a/drivers/base/driver.c
> >>> +++ b/drivers/base/driver.c
> >>> @@ -10,6 +10,7 @@
> >>>   *
> >>>   */
> >>>  
> >>> +#include <linux/async.h>
> >>>  #include <linux/device.h>
> >>>  #include <linux/module.h>
> >>>  #include <linux/errno.h>
> >>> @@ -199,6 +200,13 @@ EXPORT_SYMBOL_GPL(driver_register);
> >>>   */
> >>>  void driver_unregister(struct device_driver *drv)
> >>>  {
> >>> +	/*
> >>> +	 * make sure all async bits that may be running have completed the way
> >>> +	 * this works is that try_module_get() now fails, so new async work
> >>> +	 * should take a reference to the module which now fails, so it should
> >>> +	 * be safe to remove the driver.
> >>> +	 */
> >>> +	async_synchronize_full();
> >>>  	if (!drv || !drv->p) {
> >>>  		WARN(1, "Unexpected driver unregister!\n");
> >>>  		return;
> Is this safe? I mean, is it possible that a new scan starts after the
> async_synchronize_full() ends?

Not really, because the module is now removing, so the try module get
guard fails

> I wish this were fixed by fixing the real root of this problem which lies
> in scssi_device_get:
> int scsi_device_get(struct scsi_device *sdev)
> {
>         if (sdev->sdev_state == SDEV_DEL)
>                 return -ENXIO;
>         if (!get_device(&sdev->sdev_gendev))
>                 return -ENXIO;
>         /* We can fail this if we're doing SCSI operations
>          * from module exit (like cache flush) */
>         try_module_get(sdev->host->hostt->module);
> here  ^ by ignoring the return value. This is why rmmod --wait causes the problem
> and likely every other process which calls scsi_device_get would show the same bug.

I'm not sure how ... this has to be usable in the teardown path by which
point try_module_get will fail (as the comment says).  What do you
propose?

James



