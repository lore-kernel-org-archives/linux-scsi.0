From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/8] aacraid: handle AIF hotplug events
Date: Sat, 10 Sep 2005 11:38:15 -0500
Message-ID: <1126370295.4813.49.camel@mulgrave>
References: <1126212613.7479.20.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:18099 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750789AbVIJQi1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 12:38:27 -0400
In-Reply-To: <1126212613.7479.20.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Thu, 2005-09-08 at 13:50 -0700, Mark Haverkamp wrote:
> 					device_config_needed = CHANGE;
> +					scsi_add_device(dev->scsi_host_ptr,
> +					  device->channel, device->id,
> +					  device->lun);

Well ... this is actually wrong: scsi_add_device() returns an sdev on
success with the refcount bumped up for you.  If you don't do a put,
you'll be stuck with a device you can't get rid of.

However, all other users of scsi_add_device() make the same mistake ...
I'll apply this patch and fix the API to return zero or error and not
bump the sdev refcount.

James


