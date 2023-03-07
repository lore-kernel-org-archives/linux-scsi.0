Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF45C678DB
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 08:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjCGIJw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 03:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjCGIJj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 03:09:39 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CC65099B;
        Tue,  7 Mar 2023 00:09:05 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 0D483341EBB;
        Tue,  7 Mar 2023 11:07:53 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=2W+4LtZZa24FHSOs4t
        4NaHZOeSWzlTVXaQitGnl4kns=; b=SoQWUivkFEuXHPFaZNO/xLYyX9g9DS1TrL
        5jWJay60hLGrhoxokAvtUtsQfXKxANZeEIs0hVMpYlC1CHzTrSwEI43qEjWWEaTl
        1S3bLgL/zOfl+r2MiKMqG2CKPuue37ImvumChadJkzZToBjZVOtiF23AMmoGBc+e
        UJUTU3QuI=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 02336341E00;
        Tue,  7 Mar 2023 11:07:53 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.20.11) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 7 Mar 2023 11:07:52 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Juergen Gross <jgross@suse.com>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 05/12] scsi: target: sbp: remove default fabric ops callouts
Date:   Tue, 7 Mar 2023 11:07:35 +0300
Message-ID: <20230307080742.24631-6-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230307080742.24631-1-d.bogdanov@yadro.com>
References: <20230307080742.24631-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.20.11]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove callouts that have the implementation like a
default implementation in TCM Core.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/sbp/sbp_target.c | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 504670994fb4..2a761bc09193 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1673,11 +1673,6 @@ static int sbp_check_true(struct se_portal_group *se_tpg)
 	return 1;
 }
 
-static int sbp_check_false(struct se_portal_group *se_tpg)
-{
-	return 0;
-}
-
 static char *sbp_get_fabric_wwn(struct se_portal_group *se_tpg)
 {
 	struct sbp_tpg *tpg = container_of(se_tpg, struct sbp_tpg, se_tpg);
@@ -1692,11 +1687,6 @@ static u16 sbp_get_tag(struct se_portal_group *se_tpg)
 	return tpg->tport_tpgt;
 }
 
-static u32 sbp_tpg_get_inst_index(struct se_portal_group *se_tpg)
-{
-	return 1;
-}
-
 static void sbp_release_cmd(struct se_cmd *se_cmd)
 {
 	struct sbp_target_request *req = container_of(se_cmd,
@@ -1705,11 +1695,6 @@ static void sbp_release_cmd(struct se_cmd *se_cmd)
 	sbp_free_request(req);
 }
 
-static u32 sbp_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int sbp_write_pending(struct se_cmd *se_cmd)
 {
 	struct sbp_target_request *req = container_of(se_cmd,
@@ -1733,16 +1718,6 @@ static int sbp_write_pending(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static void sbp_set_default_node_attrs(struct se_node_acl *nacl)
-{
-	return;
-}
-
-static int sbp_get_cmd_state(struct se_cmd *se_cmd)
-{
-	return 0;
-}
-
 static int sbp_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct sbp_target_request *req = container_of(se_cmd,
@@ -2281,14 +2256,8 @@ static const struct target_core_fabric_ops sbp_ops = {
 	.tpg_get_tag			= sbp_get_tag,
 	.tpg_check_demo_mode		= sbp_check_true,
 	.tpg_check_demo_mode_cache	= sbp_check_true,
-	.tpg_check_demo_mode_write_protect = sbp_check_false,
-	.tpg_check_prod_mode_write_protect = sbp_check_false,
-	.tpg_get_inst_index		= sbp_tpg_get_inst_index,
 	.release_cmd			= sbp_release_cmd,
-	.sess_get_index			= sbp_sess_get_index,
 	.write_pending			= sbp_write_pending,
-	.set_default_node_attributes	= sbp_set_default_node_attrs,
-	.get_cmd_state			= sbp_get_cmd_state,
 	.queue_data_in			= sbp_queue_data_in,
 	.queue_status			= sbp_queue_status,
 	.queue_tm_rsp			= sbp_queue_tm_rsp,
-- 
2.25.1


