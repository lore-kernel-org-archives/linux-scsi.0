Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC63CC433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83D2864E51
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhB1GA3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 01:00:29 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:23195 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbhB1GAV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 01:00:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492021; x=1646028021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=feaqJwNnP7EHgX/qxcCklxVwpQTYvYQWDP0TbE2wIfs=;
  b=UD1GRdMhTTaEIsrXB7y4wh2ne4n7LATZSbDm/qGuc5r9JQikEKjvothR
   ylIC9b4xTUD7ppdu/hTXxWjcrbkU/ZEidFZvg0JZsz6LiJRtUO0asKuQR
   6BdV+2YCXxshbna6MEv7IARYuFo0y827k8QtPfLnNp9G1f4C0jgD4qgn4
   3NIda1TjProGjUNBSxVNbcDTTHQrI5svhoK1UUKkTNAjDDX0OFWMh4c20
   iz5NIaGCB3JTezhYkcjWQn1Iq8K4C8TVunpxpHCqiFIo4ZzqadHFp0Y9g
   L1JT35kwRclM4lSNQ0rYuJb5JQvemRRrVAjs/Ov3pJx7mQ1iw+t+CpClC
   Q==;
IronPort-SDR: AUKOrtjMIyjkP/Wa3LCIKEM4b9Pvf4xGFrPX23Y/1ubnTWegv2ZZfGkNLqE5W+aMqWoNYpyFFd
 a6xJbbkaUVUVhqxO8ZU/YwoISgOrdvolyEYkPVuA/FnE40aEjdNjC/qFv7pPyAM2vHiL7+SKId
 GWTJ2ACQcNqciVF2Ng/A7gTLpB90i1211T0Xp9Fbs5X6RTJt1/Ef52tjkcVOehB9tsLvUs0cAX
 Lb2Eh3+AmV47yYQTZEypqYJE5YciTgJYMTdNvXR8oYX32ewmsh5pIQmQ/hn9afbMOkpD/0ufsQ
 4WQ=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="271564110"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:59:15 +0800
IronPort-SDR: YHtLpvbc+v6eAkNOjfJ0yAT5TzjuDy1dRcfUHl/1yWR/cYaZqUB2rtx6h2/ZP20Dfl9jnEfvrP
 R2f8gGOxb45/syIJn4EDJuuLJ8xLG4ifDLLZVVuycFg7ctgfmWhXrRDjNrRmOo1ovk2EYR86w/
 ieDkKcBJqK/VveONnd7bUoA0kjH4DyQM5ciFGL9WG6XRPlCD8s/nI8kMR/LCAC+aOz/v1ZGj98
 p8M5T61yB0MtrSmVXof05hjZuG//nfZkg6PT3lh902BiwozXjbDLCnyoSqX3/d/bVYIZ1UaxGU
 7jguONO0uMpZ3MdcJEYhXEcS
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:40:34 -0800
IronPort-SDR: g5jzM4czVp4/qdlRh1bY5i51iufh5JD1TtqrMfVIGHyLV4npe/6N7vlR0qHfpimmmjwvHkBOZW
 ji4u1XnjAg0zky5GUL+E/IYCVeLarAtXG98ju5Le/NPmhXwkisT30rCf8EV8RjaieVWZOQILPv
 6nAA0l3q3ocAcNl5G3XowVpKLObjAFeMyyHZ2a5nIf2CrQ02jGqgQOCV52nfEsBLfsZ5Pnsif1
 kIBi7mUnvIN0C+2dzhMQkE66zYJ8IomOx2uH2U6XqbBLtSO0Pp6ODkzKFdJGbCL5EKikJC9mhO
 6Ig=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:59:15 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 16/23] target/configfs: remove the memset with declare-init
Date:   Sat, 27 Feb 2021 21:56:38 -0800
Message-Id: <20210228055645.22253-17-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of initializing the array with memset, use declare init pattern
that is present under the kernel tree in other drivers so we can remove
the memset call.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_configfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 315791b5554a..ca5b083d2958 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1660,9 +1660,7 @@ static ssize_t target_core_dev_pr_show_spc3_res(struct se_device *dev,
 {
 	struct se_node_acl *se_nacl;
 	struct t10_pr_registration *pr_reg;
-	char i_buf[PR_REG_ISID_ID_LEN];
-
-	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
 	pr_reg = dev->dev_pr_res_holder;
 	if (!pr_reg)
-- 
2.22.1

