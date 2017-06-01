From: "Milan P. Gandhi" <mgandhi@redhat.com>
Subject: [PATCH] Remove an extra out label in _fcoe_create function
Date: Thu, 1 Jun 2017 17:38:55 +0530
Message-ID: <0d0539e8-ec2e-eac3-a91b-bfda55e83eca@redhat.com>
Reply-To: mgandhi@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34558 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdFAMJA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 08:09:00 -0400
Received: by mail-io0-f173.google.com with SMTP id k91so33812263ioi.1
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2017 05:09:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, Johannes Thumshirn <jth@kernel.org>

This patch removes an extra out label in _fcoe_create function
where we return if creation of FCOE interface is failed.

Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
 drivers/scsi/fcoe/fcoe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 7b960d3..ea21e7b 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2258,7 +2258,7 @@ static int _fcoe_create(struct net_device *netdev, enum fip_mode fip_mode,
 		fcoe_interface_cleanup(fcoe);
 		mutex_unlock(&fcoe_config_mutex);
 		fcoe_ctlr_device_delete(ctlr_dev);
-		goto out;
+		return rc;
 	}
 
 	/* Make this the "master" N_Port */
@@ -2299,7 +2299,7 @@ static int _fcoe_create(struct net_device *netdev, enum fip_mode fip_mode,
 out_nodev:
 	rtnl_unlock();
 	mutex_unlock(&fcoe_config_mutex);
-out:
+
 	return rc;
 }
 
