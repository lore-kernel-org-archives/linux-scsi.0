From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [RFC][PATCH] limit state change to SDEV_BLOCK devices in	scsi_internal_device_unblock
Date: Mon, 27 Apr 2009 19:52:57 -0400
Message-ID: <49F64559.5020802@redhat.com>
References: <49F5E6E5.20904@redhat.com> <1240862889.3387.37.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36004 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbZD0Xwo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2009 19:52:44 -0400
In-Reply-To: <1240862889.3387.37.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, mchristi@redhat.com, mbarrow@redhat.com

James Bottomley wrote:
>> +	if (sdev->sdev_state != SDEV_BLOCK)
> 
> This isn't quite correct.  There are two blocked states in the model
> currently:  SDEV_BLOCK and SDEV_CREATED_BLOCK ... you'd need to check
> for both of them
> 
>> +		return 0;
> 
> Traditionally the return for an attempted invalid state transition is
> -EINVAL.
> 
> I suppose for lower down, if you check the state, now we know we go 
> 
> SDEV_CREATED_BLOCK -> SDEV_CREATED
> 
> or
> 
> SDEV_BLOCK -> SDEV_RUNNING
> 
> so there's no need for the dual scsi_device_set_state.

Thank you for the comments. If I understand your comments correctly, 
the state transition is better to be defined in scsi_device_set_state(),
and both transitions, "SDEV_CREATED_BLOCK -> SDEV_CREATED" and
"SDEV_BLOCK -> SDEV_RUNNING" need to be covered. I updated the patch
so that the transition of "SDEV_OFFLINE -> SDEV_RUNNING" is prohibited.

A note in this change is all transitions of "SDEV_OFFLINE -> SDEV_RUNNING"
is prohibited, and the following state change for devices in SDEV_OFFLINE
state fails.

  # echo running > /sys/block/sdX/device/state

Therefore, users need to delete the device once and then those devices
need to be scanned as follows.

  # echo yes > /sys/block/sdX/device/delete
  # echo "- - -" > /sys/class/scsi_host/hostX/scan

I appreciate your reviews on it.

Regards,
---
Takahiro Yasui
Hitachi Computer Products (America), Inc.


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/scsi/scsi_lib.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.29/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6.29/drivers/scsi/scsi_lib.c
@@ -2258,7 +2258,6 @@ scsi_device_set_state(struct scsi_device
 	case SDEV_RUNNING:
 		switch (oldstate) {
 		case SDEV_CREATED:
-		case SDEV_OFFLINE:
 		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
 			break;



