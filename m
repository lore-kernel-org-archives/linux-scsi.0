From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] scsi_debug: Fix memory leak if LBP enabled and module is unloaded
Date: Wed, 26 Oct 2016 11:22:53 -0400
Message-ID: <1477495373-1179-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752282AbcJZPWz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Oct 2016 11:22:55 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C84E9C057FAD
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2016 15:22:54 +0000 (UTC)
Received: from emilne.csb (dhcp-25-104.bos.redhat.com [10.18.25.104])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u9QFMsfN013835
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2016 11:22:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

map_storep was not being vfree()'d in the module_exit call.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c905709..cf04a36 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5134,6 +5134,7 @@ static void __exit scsi_debug_exit(void)
 	bus_unregister(&pseudo_lld_bus);
 	root_device_unregister(pseudo_primary);
 
+	vfree(map_storep);
 	vfree(dif_storep);
 	vfree(fake_storep);
 	kfree(sdebug_q_arr);
-- 
2.1.0

