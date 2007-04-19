From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC][PATCH] fix for async scsi scan sysfs problem (resend)
Date: Thu, 19 Apr 2007 10:02:36 -0400
Message-ID: <1176991356.31764.3.camel@mulgrave.il.steeleye.com>
References: <20070419132459.GB1481@korben.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:40634 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766697AbXDSOCt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Apr 2007 10:02:49 -0400
In-Reply-To: <20070419132459.GB1481@korben.rdu.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Josef Bacik <jwhiter@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 09:25 -0400, Josef Bacik wrote:
> Looking through everything I came to the conclusion that we don't really need
> the scsi_sysfs_add_devices in scsi_finish_async_scan, which gets run everytime
> we do a do_scan_async.  In doing the scanning, if we come upon anything we will
> already be registering the device with sysfs so the scsi_sysfs_add_devices step
> is kind of useless.

Unfortunately, it isn't.  The registration step while scanning is at the
end of scsi_add_lun():


	if (!async && scsi_sysfs_add_sdev(sdev) != 0)
		return SCSI_SCAN_NO_RESPONSE;

	return SCSI_SCAN_LUN_PRESENT;

The !async should mean that the addition *only* occurs for the non async
scan case ... if you remove the post async scan add, we'll lose devices.

>   I tested this and it worked fine on my UP box (where the
> problem was happening) and my SMP box (where the problem wasn't happening).  Now
> I'm not entirely sure if this is correct, but I'm attaching the patch that I
> used to fix it for me, please point out if I've done something wrong or if there
> is a different way this needs to be fixed.  Thank you,

Could you add some debugging first to see if we're actually adding the
device twice (and also, if we are, what the value of the async is).

James


