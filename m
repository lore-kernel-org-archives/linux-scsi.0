Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7B1C678D4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 08:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjCGIKS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 03:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjCGIJ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 03:09:56 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9654A509A8;
        Tue,  7 Mar 2023 00:09:17 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 2BE74341ED5;
        Tue,  7 Mar 2023 11:07:56 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=w/qGDtVpKabfMTaPy+
        4tYZgeIzkFDkkdV7ewNE1D7SA=; b=us9N3OyCI6GE7N1MlTmxuxcN1aB0wwp+m7
        B3CDA6FZX4gUFmkqafP+WghKKtJKPmZBvONSAMQhtYf/5lCnRaozZxA3UfOL1Ctm
        kdRnQwL/eBaDh84Fer0GF+Z6BeKo1jpqhGJBcu3AorXZEYJRgea+r840J58WHMz5
        vCshx+TJQ=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 20A41341E00;
        Tue,  7 Mar 2023 11:07:56 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.20.11) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 7 Mar 2023 11:07:54 +0300
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
Subject: [PATCH v2 09/12] xen-scsiback: remove default fabric ops callouts
Date:   Tue, 7 Mar 2023 11:07:39 +0300
Message-ID: <20230307080742.24631-10-d.bogdanov@yadro.com>
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
 drivers/xen/xen-scsiback.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 6106ed93817d..d267d2689dc7 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1408,11 +1408,6 @@ static void scsiback_drop_tport(struct se_wwn *wwn)
 	kfree(tport);
 }
 
-static u32 scsiback_tpg_get_inst_index(struct se_portal_group *se_tpg)
-{
-	return 1;
-}
-
 static int scsiback_check_stop_free(struct se_cmd *se_cmd)
 {
 	return transport_generic_free_cmd(se_cmd, 0);
@@ -1423,11 +1418,6 @@ static void scsiback_release_cmd(struct se_cmd *se_cmd)
 	target_free_tag(se_cmd->se_sess, se_cmd);
 }
 
-static u32 scsiback_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int scsiback_write_pending(struct se_cmd *se_cmd)
 {
 	/* Go ahead and process the write immediately */
@@ -1436,15 +1426,6 @@ static int scsiback_write_pending(struct se_cmd *se_cmd)
 	return 0;
 }
 
-static void scsiback_set_default_node_attrs(struct se_node_acl *nacl)
-{
-}
-
-static int scsiback_get_cmd_state(struct se_cmd *se_cmd)
-{
-	return 0;
-}
-
 static int scsiback_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct vscsibk_pend *pending_req = container_of(se_cmd,
@@ -1824,11 +1805,6 @@ static int scsiback_check_true(struct se_portal_group *se_tpg)
 	return 1;
 }
 
-static int scsiback_check_false(struct se_portal_group *se_tpg)
-{
-	return 0;
-}
-
 static const struct target_core_fabric_ops scsiback_ops = {
 	.module				= THIS_MODULE,
 	.fabric_name			= "xen-pvscsi",
@@ -1836,16 +1812,10 @@ static const struct target_core_fabric_ops scsiback_ops = {
 	.tpg_get_tag			= scsiback_get_tag,
 	.tpg_check_demo_mode		= scsiback_check_true,
 	.tpg_check_demo_mode_cache	= scsiback_check_true,
-	.tpg_check_demo_mode_write_protect = scsiback_check_false,
-	.tpg_check_prod_mode_write_protect = scsiback_check_false,
-	.tpg_get_inst_index		= scsiback_tpg_get_inst_index,
 	.check_stop_free		= scsiback_check_stop_free,
 	.release_cmd			= scsiback_release_cmd,
-	.sess_get_index			= scsiback_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= scsiback_write_pending,
-	.set_default_node_attributes	= scsiback_set_default_node_attrs,
-	.get_cmd_state			= scsiback_get_cmd_state,
 	.queue_data_in			= scsiback_queue_data_in,
 	.queue_status			= scsiback_queue_status,
 	.queue_tm_rsp			= scsiback_queue_tm_rsp,
-- 
2.25.1


