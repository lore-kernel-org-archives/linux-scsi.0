From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [isci PATCH v3 3/4] libsas: suspend / resume support
Date: Wed, 14 Mar 2012 14:33:05 -0700
Message-ID: <1331760786.17334.18.camel@ultramagnus.opencreations.com>
References: <Pine.LNX.4.44L0.1203141654460.1644-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:14075 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757051Ab2CNVdK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 17:33:10 -0400
Received: by iage36 with SMTP id e36so3187138iag.25
        for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 14:33:07 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.1203141654460.1644-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>

On Wed, 2012-03-14 at 17:11 -0400, Alan Stern wrote:
> I see.  It's a nasty situation; I guess the best way to describe it is 
> a conflict between the requirements of the PM and SCSI subsystems:
> 
> 	The PM core runs suspend and resume operations in async 
> 	threads, and these threads need to acquire the device lock;
> 
> 	The sd driver needs to insure that async probing is finished
> 	when starting its remove routine, and it is called with the
> 	device lock held.
> 
> The best solution might be to use a workqueue for sd's async probing 
> instead of the "async" threads.  Then the work routine could be 
> cancelled without doing async_synchronize_full().

Hmm... I was wondering why we needed a kernel global sync.  If this is
just for probe work what about just doing something like the following?
Keep the sync operation local to probe-work and not entangle with the
resume-work?  I'll give this a shot when I get back to my test system.

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bd17cf8..ec69e35 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2629,6 +2629,8 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	put_device(&sdkp->dev);
 }
 
+static LIST_HEAD(sd_probe_domain);
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -2717,7 +2719,7 @@ static int sd_probe(struct device *dev)
 	dev_set_drvdata(dev, sdkp);
 
 	get_device(&sdkp->dev);	/* prevent release before async_schedule */
-	async_schedule(sd_probe_async, sdkp);
+	async_schedule_domain(sd_probe_async, sdkp, &sd_probe_domain);
 
 	return 0;
 
@@ -2751,7 +2753,7 @@ static int sd_remove(struct device *dev)
 	sdkp = dev_get_drvdata(dev);
 	scsi_autopm_get_device(sdkp->device);
 
-	async_synchronize_full();
+	async_synchronize_full_domain(&sd_probe_domain);
 	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
 	blk_queue_unprep_rq(sdkp->device->request_queue, NULL);
 	device_del(&sdkp->dev);




