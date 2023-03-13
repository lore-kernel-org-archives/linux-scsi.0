Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2BEC74A4B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Mar 2023 18:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjCMSLt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 14:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjCMSL3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 14:11:29 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38C77B11E;
        Mon, 13 Mar 2023 11:11:26 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 1D69F342153;
        Mon, 13 Mar 2023 21:11:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=oGibupR+sZc22ooavB
        /8d8MPV+6Gf5WmQV9Akrx9HfM=; b=n/LVPMgqK1PNB+zl+4oF05PlKQroajT4iR
        BTHYASI0+TczarDFfH58fM97fKLA/LZxo9MVxUMXb+9dwwEXR7A1GmsN+khT/mGy
        XhVgm/qivmj08VHKJKbPA76wLWNX6cgCxOfrQNQIAqiJgECTXxmo2d7Gc8wupqYD
        aYT3hST5c=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 14936342145;
        Mon, 13 Mar 2023 21:11:22 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.20.11) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 13 Mar 2023 21:11:21 +0300
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
Subject: [PATCH v3 08/12] vhost-scsi: remove default fabric ops callouts
Date:   Mon, 13 Mar 2023 21:11:06 +0300
Message-ID: <20230313181110.20566-9-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230313181110.20566-1-d.bogdanov@yadro.com>
References: <20230313181110.20566-1-d.bogdanov@yadro.com>
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
 drivers/vhost/scsi.c | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index b244e7c0f514..b9b9a5f349a9 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -294,11 +294,6 @@ static int vhost_scsi_check_true(struct se_portal_group *se_tpg)
 	return 1;
 }
 
-static int vhost_scsi_check_false(struct se_portal_group *se_tpg)
-{
-	return 0;
-}
-
 static char *vhost_scsi_get_fabric_wwn(struct se_portal_group *se_tpg)
 {
 	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
@@ -323,11 +318,6 @@ static int vhost_scsi_check_prot_fabric_only(struct se_portal_group *se_tpg)
 	return tpg->tv_fabric_prot_type;
 }
 
-static u32 vhost_scsi_tpg_get_inst_index(struct se_portal_group *se_tpg)
-{
-	return 1;
-}
-
 static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 {
 	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
@@ -378,11 +368,6 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 	}
 }
 
-static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int vhost_scsi_write_pending(struct se_cmd *se_cmd)
 {
 	/* Go ahead and process the write immediately */
@@ -390,16 +375,6 @@ static int vhost_scsi_write_pending(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static void vhost_scsi_set_default_node_attrs(struct se_node_acl *nacl)
-{
-	return;
-}
-
-static int vhost_scsi_get_cmd_state(struct se_cmd *se_cmd)
-{
-	return 0;
-}
-
 static int vhost_scsi_queue_data_in(struct se_cmd *se_cmd)
 {
 	transport_generic_free_cmd(se_cmd, 0);
@@ -2460,17 +2435,11 @@ static const struct target_core_fabric_ops vhost_scsi_ops = {
 	.tpg_get_tag			= vhost_scsi_get_tpgt,
 	.tpg_check_demo_mode		= vhost_scsi_check_true,
 	.tpg_check_demo_mode_cache	= vhost_scsi_check_true,
-	.tpg_check_demo_mode_write_protect = vhost_scsi_check_false,
-	.tpg_check_prod_mode_write_protect = vhost_scsi_check_false,
 	.tpg_check_prot_fabric_only	= vhost_scsi_check_prot_fabric_only,
-	.tpg_get_inst_index		= vhost_scsi_tpg_get_inst_index,
 	.release_cmd			= vhost_scsi_release_cmd,
 	.check_stop_free		= vhost_scsi_check_stop_free,
-	.sess_get_index			= vhost_scsi_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= vhost_scsi_write_pending,
-	.set_default_node_attributes	= vhost_scsi_set_default_node_attrs,
-	.get_cmd_state			= vhost_scsi_get_cmd_state,
 	.queue_data_in			= vhost_scsi_queue_data_in,
 	.queue_status			= vhost_scsi_queue_status,
 	.queue_tm_rsp			= vhost_scsi_queue_tm_rsp,
-- 
2.25.1


