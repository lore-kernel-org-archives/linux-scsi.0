Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D5EC63777
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 22:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9565222470
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 22:15:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="WbwFRNfV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgKTWOn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 17:14:43 -0500
Received: from alln-iport-8.cisco.com ([173.37.142.95]:59266 "EHLO
        alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbgKTWOm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2020 17:14:42 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2020 17:14:42 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2220; q=dns/txt; s=iport;
  t=1605910482; x=1607120082;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=d/ZOzNowRDL/1pTn09ojrsWHzSzpmXPnHTH02clFZ8g=;
  b=WbwFRNfVfaSXgLlQK9HHoEm/oNyHFYMMtbGlrgzCmRmPUA6oHGVGJTzt
   dKHlZl4M+LO1PQxbHk8o9+AT87acHhg4waxsGDOAV2wAQ3iED9xY2MRFB
   rFRKRzIqzXBbT0hCVX75nyl5kf/9TkQZ/cEYwwzD7zZB7BspBbngW+BqS
   I=;
X-IronPort-AV: E=Sophos;i="5.78,357,1599523200"; 
   d="scan'208";a="614556846"
Received: from alln-core-7.cisco.com ([173.36.13.140])
  by alln-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 20 Nov 2020 22:07:36 +0000
Received: from localhost.cisco.com ([10.193.101.253])
        (authenticated bits=0)
        by alln-core-7.cisco.com (8.15.2/8.15.2) with ESMTPSA id 0AKM7S8q017209
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 20 Nov 2020 22:07:36 GMT
From:   Karan Tilak Kumar <kartilak@cisco.com>
To:     satishkh@cisco.com
Cc:     sebaddel@cisco.com, arulponn@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH] scsi: fnic: Change shost_printk with FNIC_FCS_DBG
Date:   Fri, 20 Nov 2020 14:07:12 -0800
Message-Id: <20201120220712.16708-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: alln-core-7.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replacing shost_printk with FNIC_FCS_DBG so that
these log messages are controlled by fnic_log_level
flag in fnic_fip_handler_timer.

Bumping up version number from 47 to 49 to
maintain same level as internal version.

Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Satish Kharat <satishkh@cisco.com>
---
 drivers/scsi/fnic/fnic.h     | 2 +-
 drivers/scsi/fnic/fnic_fcs.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 477513dc23b7..ed00b6061e0c 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.47"
+#define DRV_VERSION		"1.6.0.49"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index e3384afb7cbd..3fc3a7271dc1 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -1349,7 +1349,7 @@ void fnic_handle_fip_timer(struct fnic *fnic)
 	}
 
 	vlan = list_first_entry(&fnic->vlans, struct fcoe_vlan, list);
-	shost_printk(KERN_DEBUG, fnic->lport->host,
+	FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
 		  "fip_timer: vlan %d state %d sol_count %d\n",
 		  vlan->vid, vlan->state, vlan->sol_count);
 	switch (vlan->state) {
@@ -1372,7 +1372,7 @@ void fnic_handle_fip_timer(struct fnic *fnic)
 			 * no response on this vlan, remove  from the list.
 			 * Try the next vlan
 			 */
-			shost_printk(KERN_INFO, fnic->lport->host,
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
 				  "Dequeue this VLAN ID %d from list\n",
 				  vlan->vid);
 			list_del(&vlan->list);
@@ -1382,7 +1382,7 @@ void fnic_handle_fip_timer(struct fnic *fnic)
 				/* we exhausted all vlans, restart vlan disc */
 				spin_unlock_irqrestore(&fnic->vlans_lock,
 							flags);
-				shost_printk(KERN_INFO, fnic->lport->host,
+				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
 					  "fip_timer: vlan list empty, "
 					  "trigger vlan disc\n");
 				fnic_event_enq(fnic, FNIC_EVT_START_VLAN_DISC);
-- 
2.29.2

