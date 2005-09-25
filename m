From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/7] aacraid: handle AIF hotplug events
Date: Sun, 25 Sep 2005 09:56:35 -0500
Message-ID: <1127660195.4839.5.camel@mulgrave>
References: <1127246183.1891.34.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:44419 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751493AbVIYO4o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Sep 2005 10:56:44 -0400
In-Reply-To: <1127246183.1891.34.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Tue, 2005-09-20 at 12:56 -0700, Mark Haverkamp wrote:
> +       shost_for_each_device(device, dev->scsi_host_ptr)
> +       {
> +               if ((device->channel == CONTAINER_TO_CHANNEL
> (container))
> +                && (device->id == CONTAINER_TO_ID(container))
> +                && (device->lun == CONTAINER_TO_LUN(container))) {
> +                       switch (device_config_needed) {
> +                       case DELETE:
> +                               scsi_remove_device(device);
> +                               break;
> +                       case CHANGE:
> +                               if (!dev->fsa_dev[container].valid) {
> +                                       scsi_remove_device(device);
> +                                       break;
> +                               }
> +                               scsi_rescan_device(&device-
> >sdev_gendev);
> +
> +                       default:
> +                               break;
> +                       }
> +                       scsi_device_put(device);
> +                       break;
> +               }
> +       }

This is open coding scsi_lookup_device(); why not simply use that API?
It returns a device that also has to have scsi_device_put() called on it
when you're finished.  I suppose it won't necessarily matter for
aacraid, but if we have to make the lookup more efficient for large lun
configurations, you'll benefit.

James


