Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CCBC678D4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 08:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCGIIf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 03:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjCGIIa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 03:08:30 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880ED23DB5;
        Tue,  7 Mar 2023 00:08:02 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 2A94D341EB5;
        Tue,  7 Mar 2023 11:07:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=t6YmvwSRe7WGVlVA6i
        xDRMSG7+0Bihd9czouuiOCJH0=; b=Lmx8uVmvsCESJi+3lQ/V+08BTTLd1FlR0/
        41Rmc/XAKEWXXH7CaUH4S/5Qk+pvtlCYUKYk9YWpSR6FllWnUR5FOhtcPVRYHxc3
        fN+7zR6twU4MPMuyXdH8zLKLw8rclPUrQcgY9ALjOaEXPG7or5A+5ykegfKMiA4t
        usqb4IXkg=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 1F494341E00;
        Tue,  7 Mar 2023 11:07:51 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.20.11) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 7 Mar 2023 11:07:50 +0300
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
Subject: [PATCH v2 02/12] infiniband: srpt: remove default fabric ops callouts
Date:   Tue, 7 Mar 2023 11:07:32 +0300
Message-ID: <20230307080742.24631-3-d.bogdanov@yadro.com>
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
 drivers/infiniband/ulp/srpt/ib_srpt.c | 33 ---------------------------
 1 file changed, 33 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 3c3fae738c3e..3e9343fd2d8e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3300,11 +3300,6 @@ static int srpt_check_true(struct se_portal_group *se_tpg)
 	return 1;
 }
 
-static int srpt_check_false(struct se_portal_group *se_tpg)
-{
-	return 0;
-}
-
 static struct srpt_port *srpt_tpg_to_sport(struct se_portal_group *tpg)
 {
 	return tpg->se_tpg_wwn->priv;
@@ -3334,11 +3329,6 @@ static u16 srpt_get_tag(struct se_portal_group *tpg)
 	return 1;
 }
 
-static u32 srpt_tpg_get_inst_index(struct se_portal_group *se_tpg)
-{
-	return 1;
-}
-
 static void srpt_release_cmd(struct se_cmd *se_cmd)
 {
 	struct srpt_send_ioctx *ioctx = container_of(se_cmd,
@@ -3378,24 +3368,6 @@ static void srpt_close_session(struct se_session *se_sess)
 	srpt_disconnect_ch_sync(ch);
 }
 
-/**
- * srpt_sess_get_index - return the value of scsiAttIntrPortIndex (SCSI-MIB)
- * @se_sess: SCSI target session.
- *
- * A quote from RFC 4455 (SCSI-MIB) about this MIB object:
- * This object represents an arbitrary integer used to uniquely identify a
- * particular attached remote initiator port to a particular SCSI target port
- * within a particular SCSI target device within a particular SCSI instance.
- */
-static u32 srpt_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
-static void srpt_set_default_node_attrs(struct se_node_acl *nacl)
-{
-}
-
 /* Note: only used from inside debug printk's by the TCM core. */
 static int srpt_get_tcm_cmd_state(struct se_cmd *se_cmd)
 {
@@ -3866,18 +3838,13 @@ static const struct target_core_fabric_ops srpt_template = {
 	.fabric_name			= "srpt",
 	.tpg_get_wwn			= srpt_get_fabric_wwn,
 	.tpg_get_tag			= srpt_get_tag,
-	.tpg_check_demo_mode		= srpt_check_false,
 	.tpg_check_demo_mode_cache	= srpt_check_true,
 	.tpg_check_demo_mode_write_protect = srpt_check_true,
-	.tpg_check_prod_mode_write_protect = srpt_check_false,
-	.tpg_get_inst_index		= srpt_tpg_get_inst_index,
 	.release_cmd			= srpt_release_cmd,
 	.check_stop_free		= srpt_check_stop_free,
 	.close_session			= srpt_close_session,
-	.sess_get_index			= srpt_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= srpt_write_pending,
-	.set_default_node_attributes	= srpt_set_default_node_attrs,
 	.get_cmd_state			= srpt_get_tcm_cmd_state,
 	.queue_data_in			= srpt_queue_data_in,
 	.queue_status			= srpt_queue_status,
-- 
2.25.1


