From: "Jan Beulich" <JBeulich@suse.com>
Subject: [PATCH] xen-scsiback: correct return value checks on
 xenbus_scanf()
Date: Thu, 07 Jul 2016 02:01:12 -0600
Message-ID: <577E286802000078000FBECF@prv-mh.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv-mh.provo.novell.com ([137.65.248.74]:36695 "EHLO
	prv-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbcGGIBN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:3:1>);
	Thu, 7 Jul 2016 04:01:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <JGross@suse.com>
Cc: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org

Only a positive return value indicates success.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 drivers/xen/xen-scsiback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 4.7-rc6-xenbus_scanf.orig/drivers/xen/xen-scsiback.c
+++ 4.7-rc6-xenbus_scanf/drivers/xen/xen-scsiback.c
@@ -1071,7 +1071,7 @@ static void scsiback_do_1lun_hotplug(str
 	/* read status */
 	snprintf(state, sizeof(state), "vscsi-devs/%s/state", ent);
 	err = xenbus_scanf(XBT_NIL, dev->nodename, state, "%u", &device_state);
-	if (XENBUS_EXIST_ERR(err))
+	if (err <= 0)
 		return;
 
 	/* physical SCSI device */
@@ -1089,7 +1089,7 @@ static void scsiback_do_1lun_hotplug(str
 	snprintf(str, sizeof(str), "vscsi-devs/%s/v-dev", ent);
 	err = xenbus_scanf(XBT_NIL, dev->nodename, str, "%u:%u:%u:%u",
 			   &vir.hst, &vir.chn, &vir.tgt, &vir.lun);
-	if (XENBUS_EXIST_ERR(err)) {
+	if (err != 4) {
 		xenbus_printf(XBT_NIL, dev->nodename, state,
 			      "%d", XenbusStateClosed);
 		return;



