Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E755C19F21
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 21:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbiG0Vlm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jul 2022 17:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiG0Vlj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2022 17:41:39 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB764D4E5;
        Wed, 27 Jul 2022 14:41:38 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E5ECB412D8;
        Wed, 27 Jul 2022 21:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1658958095; x=1660772496; bh=1Ib3MbnV4zvRhNpS8qJYzDbAa
        Mk5HG+rJQ8cBb8hDek=; b=gKeeFu1xcAiprIpN117XbLHmzD8rPcLR1CLJOXJ8u
        bpvGklhJx0dxurRcEqwyJWANh4MGfG8orLIxMkyKmFEPyvnvkynAAJW5n5TCBykb
        BOCNKGSEPCJfYIJHeXJ8n1b3ElylaiLdEb0iQWBj5NXzwlRnTKJv+bpqWZ1VQvGV
        Ms=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4mx_9h9GOJdB; Thu, 28 Jul 2022 00:41:35 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C3D0F412DF;
        Thu, 28 Jul 2022 00:41:34 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 28 Jul 2022 00:41:34 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Thu, 28 Jul 2022 00:41:33 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 1/2] target: core: fix race during ACL removal
Date:   Thu, 28 Jul 2022 00:41:24 +0300
Message-ID: <20220727214125.19647-2-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220727214125.19647-1-d.bogdanov@yadro.com>
References: <20220727214125.19647-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Under huge load there is a possibility of race condition in updating
se_dev_entry object in ACL removal procedure.

 NIP [c0080000154093d0] transport_lookup_cmd_lun+0x1f8/0x3d0 [target_core_mod]
 LR [c00800001542ab34] target_submit_cmd_map_sgls+0x11c/0x300 [target_core_mod]
 Call Trace:
   target_submit_cmd_map_sgls+0x11c/0x300 [target_core_mod]
   target_submit_cmd+0x44/0x60 [target_core_mod]
   tcm_qla2xxx_handle_cmd+0x88/0xe0 [tcm_qla2xxx]
   qlt_do_work+0x2e4/0x3d0 [qla2xxx]
   process_one_work+0x298/0x5c

Despite usage of RCU primitives with deve->se_lun pointer, it has not
became dereference-safe. Because deve->se_lun is updated not
synchronized with a reader. That change might be in a realease function
called by synchronize_rcu(). But, in fact, there is no sence to NULL
that pointer for deleting deve. All access to deve->se_lun is already
under rcu_read_lock. And either deve->se_lun is always valid or deve
is not valid itself and will not be found in the list_for_*.
The same applicable for deve->se_lun_acl too.
So a better solution is to remove that NULLing.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
v2:
   add more details in teh commit message
---
 drivers/target/target_core_device.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 086ac9c9343c..88a844ae1fd0 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -434,9 +434,6 @@ void core_disable_device_list_for_node(
 	kref_put(&orig->pr_kref, target_pr_kref_release);
 	wait_for_completion(&orig->pr_comp);
 
-	rcu_assign_pointer(orig->se_lun, NULL);
-	rcu_assign_pointer(orig->se_lun_acl, NULL);
-
 	kfree_rcu(orig, rcu_head);
 
 	core_scsi3_free_pr_reg_from_nacl(dev, nacl);
-- 
2.25.1

