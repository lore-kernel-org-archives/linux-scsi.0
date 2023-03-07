Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6089C678D5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 08:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjCGIKT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 03:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjCGIJ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 03:09:58 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A39509BD;
        Tue,  7 Mar 2023 00:09:18 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 56347341ED7;
        Tue,  7 Mar 2023 11:07:57 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=eQgqL6yVVBzAHgeHIZ
        e8DeLzHeAWs9GeaoL1cYm7QuI=; b=BuRRUbxYtOtGjDazflipjWnGNecVC2Oi2V
        plza866AufSmi+NneOynC8Ad871tEmL81lNPNeNkR1eU62lE4gixsEg0b1MNV9He
        4zXWiNf9SrlhqrW7WxNkkShAw1unguSL8KTGlhubNkFdKtyINmpZJHxQT9UIh/B0
        h1YVp7SmM=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 4CC71341E00;
        Tue,  7 Mar 2023 11:07:57 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.20.11) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 7 Mar 2023 11:07:56 +0300
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
Subject: [PATCH v2 10/12] scsi: qla2xxx: remove default fabric ops callouts
Date:   Tue, 7 Mar 2023 11:07:40 +0300
Message-ID: <20230307080742.24631-11-d.bogdanov@yadro.com>
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
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 8024322c9c5a..3b5ba4b47b3b 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -377,11 +377,6 @@ static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 	tcm_qla2xxx_put_sess(sess);
 }
 
-static u32 tcm_qla2xxx_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
@@ -421,11 +416,6 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 	return qlt_rdy_to_xfer(cmd);
 }
 
-static void tcm_qla2xxx_set_default_node_attrs(struct se_node_acl *nacl)
-{
-	return;
-}
-
 static int tcm_qla2xxx_get_cmd_state(struct se_cmd *se_cmd)
 {
 	if (!(se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)) {
@@ -1811,10 +1801,8 @@ static const struct target_core_fabric_ops tcm_qla2xxx_ops = {
 	.check_stop_free		= tcm_qla2xxx_check_stop_free,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.close_session			= tcm_qla2xxx_close_session,
-	.sess_get_index			= tcm_qla2xxx_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= tcm_qla2xxx_write_pending,
-	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
 	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
 	.queue_data_in			= tcm_qla2xxx_queue_data_in,
 	.queue_status			= tcm_qla2xxx_queue_status,
@@ -1852,10 +1840,8 @@ static const struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
 	.check_stop_free                = tcm_qla2xxx_check_stop_free,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.close_session			= tcm_qla2xxx_close_session,
-	.sess_get_index			= tcm_qla2xxx_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= tcm_qla2xxx_write_pending,
-	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
 	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
 	.queue_data_in			= tcm_qla2xxx_queue_data_in,
 	.queue_status			= tcm_qla2xxx_queue_status,
-- 
2.25.1


