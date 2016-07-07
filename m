From: "Jan Beulich" <JBeulich@suse.com>
Subject: [PATCH] xen-scsifront: correct return value checks on
 xenbus_scanf()
Date: Thu, 07 Jul 2016 02:01:49 -0600
Message-ID: <577E288D02000078000FBF10@prv-mh.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv-mh.provo.novell.com ([137.65.248.74]:32898 "EHLO
	prv-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbcGGICL convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:3:1>);
	Thu, 7 Jul 2016 04:02:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <JGross@suse.com>
Cc: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org

Only a positive return value indicates success.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 drivers/scsi/xen-scsifront.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 4.7-rc6-xenbus_scanf.orig/drivers/scsi/xen-scsifront.c
+++ 4.7-rc6-xenbus_scanf/drivers/scsi/xen-scsifront.c
@@ -1000,14 +1000,14 @@ static void scsifront_do_lun_hotplug(str
 		snprintf(str, sizeof(str), "vscsi-devs/%s/state", dir[i]);
 		err = xenbus_scanf(XBT_NIL, dev->otherend, str, "%u",
 				   &device_state);
-		if (XENBUS_EXIST_ERR(err))
+		if (err <= 0)
 			continue;
 
 		/* virtual SCSI device */
 		snprintf(str, sizeof(str), "vscsi-devs/%s/v-dev", dir[i]);
 		err = xenbus_scanf(XBT_NIL, dev->otherend, str,
 				   "%u:%u:%u:%u", &hst, &chn, &tgt, &lun);
-		if (XENBUS_EXIST_ERR(err))
+		if (err != 4)
 			continue;
 
 		/*



