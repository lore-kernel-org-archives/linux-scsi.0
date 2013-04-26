From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND^2] sd: fix infinite kernel/udev loop on
 non-removable Medium Not Present
Date: Fri, 26 Apr 2013 10:30:59 -0700
Message-ID: <1366997459.16829.4.camel@dabdike>
References: <1366994373-13324-1-git-send-email-steve@digidescorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1366994373-13324-1-git-send-email-steve@digidescorp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-04-26 at 11:39 -0500, Steven J. Magnani wrote:
> Commit eface65c336eff420d70beb0fb6787a732e05ffb (2.6.38) altered
> set_media_not_present() in a way that prevents the sd driver from
> remembering that a non-removable device has reported "Medium Not Present".
> This condition can occur on hotplug of a (i.e.) USB Mass Storage device
> whose medium is offline due to an unrecoverable controller error,
> but which is otherwise capable of SCSI communication (to download new 
> microcode, etc.).

This actually sounds to be a bug somewhere in the device.  Only
removable devices are supposed to signal medium not present.

> Under these conditions, the changed code results in an infinite loop
> between the kernel and udevd. When udevd attempts to open the device
> in response to a change notification, a SCSI "Medium Not Present" error
> occurs which causes the kernel to signal another change. The cycle
> repeats until the device is unplugged, resulting in udevd consuming ever-
> increasing amounts of CPU and virtual memory.
> 
> Resolve this by remembering "media not present" whether the device has
> declared itself "removable" or not.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> --- a/drivers/scsi/sd.c	2013-04-12 14:16:12.252531097 -0500
> +++ b/drivers/scsi/sd.c	2013-04-12 14:21:55.197216521 -0500
> @@ -1298,10 +1298,8 @@ out:
>  
>  static void set_media_not_present(struct scsi_disk *sdkp)
>  {
> -	if (sdkp->media_present)
> +	if (sdkp->media_present) {
>  		sdkp->device->changed = 1;
> -
> -	if (sdkp->device->removable) {
>  		sdkp->media_present = 0;
>  		sdkp->capacity = 0;

I don't really like this change because it will affect TUR failure as
well, which looks like it would then zero the capacity of a
non-removable device which we aren't expecting.  Can we dig into what's
going wrong with the device first.  It sounds like it really is a
removable device and it just needs to be flagged that way (either that
or the USB SAT is so screwed up that we might need to apply other
blacklists)

James
