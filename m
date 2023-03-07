Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579EEC678DB
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 08:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjCGIIx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 03:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjCGIIc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 03:08:32 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1BB2CFEA;
        Tue,  7 Mar 2023 00:08:07 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id CAF30341EB6;
        Tue,  7 Mar 2023 11:07:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=y3vb4pAUffWzuoh9I2
        ChX6phjhxw2mBq3/VY5m3Oavw=; b=ivBVESAvgR7ShEtkPM/7xZePJHq8qZNh8s
        6zUEUHkBSPYAq0lQDSD3r0pVCDS9C5wydcB3ue4YEuk3eiIYnkaSfhZmdJRAZn97
        KrPI0PBAjBP730jLJ/snMll7TPgXY65OGyCoeNbxX3e1PtVED+HifHBTwHPLQjSw
        InxnaOqSg=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id C20C0341E00;
        Tue,  7 Mar 2023 11:07:51 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.20.11) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 7 Mar 2023 11:07:51 +0300
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
Subject: [PATCH v2 03/12] scsi: ibmvscsit: remove default fabric ops callouts
Date:   Tue, 7 Mar 2023 11:07:33 +0300
Message-ID: <20230307080742.24631-4-d.bogdanov@yadro.com>
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
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 30 ------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index e8770310a64b..385f812b8793 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3698,16 +3698,6 @@ static int ibmvscsis_check_true(struct se_portal_group *se_tpg)
 	return 1;
 }
 
-static int ibmvscsis_check_false(struct se_portal_group *se_tpg)
-{
-	return 0;
-}
-
-static u32 ibmvscsis_tpg_get_inst_index(struct se_portal_group *se_tpg)
-{
-	return 1;
-}
-
 static int ibmvscsis_check_stop_free(struct se_cmd *se_cmd)
 {
 	return target_put_sess_cmd(se_cmd);
@@ -3726,11 +3716,6 @@ static void ibmvscsis_release_cmd(struct se_cmd *se_cmd)
 	spin_unlock_bh(&vscsi->intr_lock);
 }
 
-static u32 ibmvscsis_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
 {
 	struct ibmvscsis_cmd *cmd = container_of(se_cmd, struct ibmvscsis_cmd,
@@ -3765,15 +3750,6 @@ static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static void ibmvscsis_set_default_node_attrs(struct se_node_acl *nacl)
-{
-}
-
-static int ibmvscsis_get_cmd_state(struct se_cmd *se_cmd)
-{
-	return 0;
-}
-
 static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct ibmvscsis_cmd *cmd = container_of(se_cmd, struct ibmvscsis_cmd,
@@ -3982,15 +3958,9 @@ static const struct target_core_fabric_ops ibmvscsis_ops = {
 	.tpg_get_default_depth		= ibmvscsis_get_default_depth,
 	.tpg_check_demo_mode		= ibmvscsis_check_true,
 	.tpg_check_demo_mode_cache	= ibmvscsis_check_true,
-	.tpg_check_demo_mode_write_protect = ibmvscsis_check_false,
-	.tpg_check_prod_mode_write_protect = ibmvscsis_check_false,
-	.tpg_get_inst_index		= ibmvscsis_tpg_get_inst_index,
 	.check_stop_free		= ibmvscsis_check_stop_free,
 	.release_cmd			= ibmvscsis_release_cmd,
-	.sess_get_index			= ibmvscsis_sess_get_index,
 	.write_pending			= ibmvscsis_write_pending,
-	.set_default_node_attributes	= ibmvscsis_set_default_node_attrs,
-	.get_cmd_state			= ibmvscsis_get_cmd_state,
 	.queue_data_in			= ibmvscsis_queue_data_in,
 	.queue_status			= ibmvscsis_queue_status,
 	.queue_tm_rsp			= ibmvscsis_queue_tm_rsp,
-- 
2.25.1


