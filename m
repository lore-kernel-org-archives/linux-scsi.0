Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ADC7C678D5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 08:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjCGITB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 03:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjCGISu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 03:18:50 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7E54FF2B;
        Tue,  7 Mar 2023 00:18:20 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 7538F341EC5;
        Tue,  7 Mar 2023 11:07:54 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :from:from:in-reply-to:message-id:mime-version:references
        :reply-to:subject:subject:to:to; s=mta-01; bh=Nc0koPtsKLrnzRvVes
        Wg4rclWj5D/Nb4ap3SWkSCm4c=; b=PIIs044lkVFy+D0uHKgCmiWD3/K/0dxGjM
        2SmY8rhorl7q7MtsXfaeEdElkzS6kKogBWsoRScNVtz9WfHdkrghJ7ur44TTDNNN
        dNy9jd8wjwuUl8c2mw+E3KA6R1RAz49gKsxmCRUkSH6KSkYHPsk2l+yHsmG0oLx2
        aNB2FUJQo=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 6BC34341E00;
        Tue,  7 Mar 2023 11:07:54 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.199.20.11) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Tue, 7 Mar 2023 11:07:53 +0300
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
Subject: [PATCH v2 07/12] usb: gadjet: f_tcm: remove default fabric ops callouts
Date:   Tue, 7 Mar 2023 11:07:37 +0300
Message-ID: <20230307080742.24631-8-d.bogdanov@yadro.com>
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
 drivers/usb/gadget/function/f_tcm.c | 31 -----------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 658e2e21fdd0..d9d2ac28da66 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1253,11 +1253,6 @@ static int usbg_check_true(struct se_portal_group *se_tpg)
 	return 1;
 }
 
-static int usbg_check_false(struct se_portal_group *se_tpg)
-{
-	return 0;
-}
-
 static char *usbg_get_fabric_wwn(struct se_portal_group *se_tpg)
 {
 	struct usbg_tpg *tpg = container_of(se_tpg,
@@ -1274,11 +1269,6 @@ static u16 usbg_get_tag(struct se_portal_group *se_tpg)
 	return tpg->tport_tpgt;
 }
 
-static u32 usbg_tpg_get_inst_index(struct se_portal_group *se_tpg)
-{
-	return 1;
-}
-
 static void usbg_release_cmd(struct se_cmd *se_cmd)
 {
 	struct usbg_cmd *cmd = container_of(se_cmd, struct usbg_cmd,
@@ -1289,20 +1279,6 @@ static void usbg_release_cmd(struct se_cmd *se_cmd)
 	target_free_tag(se_sess, se_cmd);
 }
 
-static u32 usbg_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
-static void usbg_set_default_node_attrs(struct se_node_acl *nacl)
-{
-}
-
-static int usbg_get_cmd_state(struct se_cmd *se_cmd)
-{
-	return 0;
-}
-
 static void usbg_queue_tm_rsp(struct se_cmd *se_cmd)
 {
 }
@@ -1691,16 +1667,9 @@ static const struct target_core_fabric_ops usbg_ops = {
 	.tpg_get_wwn			= usbg_get_fabric_wwn,
 	.tpg_get_tag			= usbg_get_tag,
 	.tpg_check_demo_mode		= usbg_check_true,
-	.tpg_check_demo_mode_cache	= usbg_check_false,
-	.tpg_check_demo_mode_write_protect = usbg_check_false,
-	.tpg_check_prod_mode_write_protect = usbg_check_false,
-	.tpg_get_inst_index		= usbg_tpg_get_inst_index,
 	.release_cmd			= usbg_release_cmd,
-	.sess_get_index			= usbg_sess_get_index,
 	.sess_get_initiator_sid		= NULL,
 	.write_pending			= usbg_send_write_request,
-	.set_default_node_attributes	= usbg_set_default_node_attrs,
-	.get_cmd_state			= usbg_get_cmd_state,
 	.queue_data_in			= usbg_send_read_response,
 	.queue_status			= usbg_send_status_response,
 	.queue_tm_rsp			= usbg_queue_tm_rsp,
-- 
2.25.1


