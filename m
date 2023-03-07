Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBA0C6FD1E
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 08:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjCGIKE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 03:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjCGIJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 03:09:50 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41903509B8;
        Tue,  7 Mar 2023 00:09:14 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 71C6F341ED9;
        Tue,  7 Mar 2023 11:07:58 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=KXowzq+5SRlg6NDOC/
        ky1YlYmzef8uXGfH1ghtnXdUI=; b=cddaBnAVWjDwN7GF6rjcAcvmb6bCEwzS3h
        iF6JisWPtSbeHf2ByBSWwpL9JDfVm87NJkC3CuqtySZPfeoJmG4NyROEebMuvDZZ
        xuE/bYNugHdKS8RsKIbOcf8GDg5Ky3F1tw47tu61Eiy+D+ZUoRxNkPWtRibgYnYR
        txGaGoBTU=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 68290341E00;
        Tue,  7 Mar 2023 11:07:58 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.20.11) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 7 Mar 2023 11:07:57 +0300
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
Subject: [PATCH v2 11/12] scsi: efct: remove default fabric ops callouts
Date:   Tue, 7 Mar 2023 11:07:41 +0300
Message-ID: <20230307080742.24631-12-d.bogdanov@yadro.com>
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
 drivers/scsi/elx/efct/efct_lio.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index be4b5c1ee32d..a982b9cf9870 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -285,11 +285,6 @@ efct_lio_npiv_check_prod_write_protect(struct se_portal_group *se_tpg)
 	return tpg->tpg_attrib.prod_mode_write_protect;
 }
 
-static u32 efct_lio_tpg_get_inst_index(struct se_portal_group *se_tpg)
-{
-	return 1;
-}
-
 static int efct_lio_check_stop_free(struct se_cmd *se_cmd)
 {
 	struct efct_scsi_tgt_io *ocp =
@@ -355,15 +350,6 @@ static void efct_lio_close_session(struct se_session *se_sess)
 	efc_node_post_shutdown(node, NULL);
 }
 
-static u32 efct_lio_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
-static void efct_lio_set_default_node_attrs(struct se_node_acl *nacl)
-{
-}
-
 static int efct_lio_get_cmd_state(struct se_cmd *cmd)
 {
 	struct efct_scsi_tgt_io *ocp =
@@ -1607,14 +1593,11 @@ static const struct target_core_fabric_ops efct_lio_ops = {
 	.tpg_check_demo_mode_cache      = efct_lio_check_demo_mode_cache,
 	.tpg_check_demo_mode_write_protect = efct_lio_check_demo_write_protect,
 	.tpg_check_prod_mode_write_protect = efct_lio_check_prod_write_protect,
-	.tpg_get_inst_index		= efct_lio_tpg_get_inst_index,
 	.check_stop_free		= efct_lio_check_stop_free,
 	.aborted_task			= efct_lio_aborted_task,
 	.release_cmd			= efct_lio_release_cmd,
 	.close_session			= efct_lio_close_session,
-	.sess_get_index			= efct_lio_sess_get_index,
 	.write_pending			= efct_lio_write_pending,
-	.set_default_node_attributes	= efct_lio_set_default_node_attrs,
 	.get_cmd_state			= efct_lio_get_cmd_state,
 	.queue_data_in			= efct_lio_queue_data_in,
 	.queue_status			= efct_lio_queue_status,
@@ -1644,14 +1627,11 @@ static const struct target_core_fabric_ops efct_lio_npiv_ops = {
 					efct_lio_npiv_check_demo_write_protect,
 	.tpg_check_prod_mode_write_protect =
 					efct_lio_npiv_check_prod_write_protect,
-	.tpg_get_inst_index		= efct_lio_tpg_get_inst_index,
 	.check_stop_free		= efct_lio_check_stop_free,
 	.aborted_task			= efct_lio_aborted_task,
 	.release_cmd			= efct_lio_release_cmd,
 	.close_session			= efct_lio_close_session,
-	.sess_get_index			= efct_lio_sess_get_index,
 	.write_pending			= efct_lio_write_pending,
-	.set_default_node_attributes	= efct_lio_set_default_node_attrs,
 	.get_cmd_state			= efct_lio_get_cmd_state,
 	.queue_data_in			= efct_lio_queue_data_in,
 	.queue_status			= efct_lio_queue_status,
-- 
2.25.1


