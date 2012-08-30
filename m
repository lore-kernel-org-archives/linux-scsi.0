From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 1/3] scsi: pm: add may_power_off flag
Date: Thu, 30 Aug 2012 14:43:58 +0800
Message-ID: <1346309040-27112-2-git-send-email-aaron.lu@intel.com>
References: <1346309040-27112-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:58762 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab2H3Gog (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Aug 2012 02:44:36 -0400
In-Reply-To: <1346309040-27112-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

Add a new flag may_power_off for scsi device, it gives the user a chance
to control when the device is runtime suspended, can we remove its power
if possible.

I'm planning using this flag for sr and sd.

For sr, if user set 0 to may_power_off, we will disable runtime suspend
for ODD, since runtime suspend for ODD is wholly for zero power ODD, if
we can't power off the ODD, there is no meaning to do runtime PM on it.

For sd, if user set 0 to may_power_off, we will not power off the device
when it is runtime suspended.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 include/scsi/scsi_device.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 4bc4ac4..0bfc17f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -157,6 +157,7 @@ struct scsi_device {
 	unsigned can_power_off:1; /* Device supports runtime power off */
 	unsigned wakeup_by_user:1;	/* User wakes up the ODD */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
+	unsigned may_power_off:1;	/* power off is allowed by user */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.11.5

