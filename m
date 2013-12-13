From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [usb-storage] UAS hangs khubd on USB disconnect
Date: Fri, 13 Dec 2013 22:24:33 +0100
Message-ID: <52AB7B11.7020900@redhat.com>
References: <20131213180907.GB10727@xanatos>	 <Pine.LNX.4.44L0.1312131316470.1185-100000@iolanthe.rowland.org>	 <20131213183343.GC27070@htj.dyndns.org>	 <1386962327.2055.54.camel@dabdike.int.hansenpartnership.com> <1386964999.2055.59.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab3LMVYn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 16:24:43 -0500
In-Reply-To: <1386964999.2055.59.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Hi,

On 12/13/2013 09:03 PM, James Bottomley wrote:

<snip>

> Actually, I think I have this figured out.  There's a thinko in one of
> the scsi_target_reap() cases.  The original (and still existing) problem
> with targets is that nothing creates them and nothing destroys them, so,
> while we could rely on the refcounting of the device model to preserve
> the actual target object, we had no idea when to remove it from
> visibility.  That was the job of the reap reference, to track
> visibility.  It looks like the reap on device last put is occurring too
> late.  I think we should reap immediately after doing the sdev
> device_del, so does this fix the warn on? (I'm not sure because no-one
> has actually posted a backtrace, but it sounds like this is the
> problem).
>
> James
>
> ---
>
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 8ff62c2..98d4eb3 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -399,8 +399,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>   	/* NULL queue means the device can't be used */
>   	sdev->request_queue = NULL;
>
> -	scsi_target_reap(scsi_target(sdev));
> -
>   	kfree(sdev->inquiry);
>   	kfree(sdev);
>
> @@ -1044,6 +1042,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
>   	} else
>   		put_device(&sdev->sdev_dev);
>
> +	scsi_target_reap(scsi_target(sdev));
> +
>   	/*
>   	 * Stop accepting new requests and wait until all queuecommand() and
>   	 * scsi_run_queue() invocations have finished before tearing down the

I've given this patch a try and it fixes the blk-tag.c: 89 BUG() I was seeing.

As for the other patch you (James) have send for that problem:

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 8ff62c2..98d4eb3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -399,8 +399,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
  	/* NULL queue means the device can't be used */
  	sdev->request_queue = NULL;

-	scsi_target_reap(scsi_target(sdev));
-
  	kfree(sdev->inquiry);
  	kfree(sdev);

@@ -1044,6 +1042,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
  	} else
  		put_device(&sdev->sdev_dev);

+	scsi_target_reap(scsi_target(sdev));
+
  	/*
  	 * Stop accepting new requests and wait until all queuecommand() and
  	 * scsi_run_queue() invocations have finished before tearing down the

That too fixes the blk-tag.c: 89 BUG() I was seeing. Either patch by itself
seems to be enough to fix this issue for me.

Thanks & Regards,

Hans
