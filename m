Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47323C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 23:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C86660243
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 23:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238883AbhH3XMB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Aug 2021 19:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbhH3XMA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2021 19:12:00 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B001C061575
        for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2021 16:11:05 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id k24so14915561pgh.8
        for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2021 16:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7sIHviyoS6F1BIBfTOuORVzPESXA3cSHRvUu7/zRa4w=;
        b=euUWDotjYheqqf7fmhx/hHqJI9+JcYrRiBUTBnJjANUixNrKUA7ZTd3UoSMFcSkDKX
         noA2Nx/tJBxQqcq9IJytekdm/zoA+lpTQlptNb+CDMr9PXmsMD444dONIckBPTghabSj
         bRcaPq+Vq/koIxN4n/NSVrUB63OR52Dj5gYB/zTyF3oSklea9rFv2TdPj27gUha4x0l3
         lC3GAUUlO9G4r0cdEBSfy+MzRTksmLy0FMr/xPGVLIIpPdX+y0alfqjqzxjWBA7rtoPP
         MSsFO3fZ0t7l2EfxUNv9LLAFvxA16LkzaAZigUOHv3PX8CXP43fqmeg/zQ74woBBOxLJ
         OjrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7sIHviyoS6F1BIBfTOuORVzPESXA3cSHRvUu7/zRa4w=;
        b=jSaoLguaZzl0zMmJfDECJVgS9mjSCvLFD2pQoqSEbaeCYY9FRzA+3cK1juRwmu3irC
         2p+0E6EOSgNo/o9CLcEJh2BlKYuIyRdGBqUfHoGMAH2Gf6/QSxH31iApjd/Rmqcyx4uh
         w5sEOHlpC3YtcmPrT1fKs5CIKv8sFmpTrwgBevXVeeP+8jV2mY9gfoIhoA52v7r/i+1b
         w3IfzJWdInAR/F34XX1SoUui5WdIyw2I69TyV7VecMLgn4Ml/xiYMNjOkJtyuYr4O7sE
         8fHcqEXfCK7GgQj+5h6pSn8OWcWtkWhOCmfa3igVnJOHh+MxLGn8FWP+aeyzaWDFc5vT
         zw8A==
X-Gm-Message-State: AOAM5326i8FRqsXvlKcuRoSYJg0O+yK8w3lAf6Xe0xaaDyDHMWS/VHIN
        8O30MbEUweHAx59tTq4/Vd6kFdSQOAp+Sg==
X-Google-Smtp-Source: ABdhPJzBpBSF68ZgXMtb3RIItX/RvyR5G2uapZqeyQiSG1dvmwaV+TQuQVctZhUdani78OU+IQeYeQ==
X-Received: by 2002:a65:6392:: with SMTP id h18mr24015097pgv.397.1630365064995;
        Mon, 30 Aug 2021 16:11:04 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 81sm15656113pfw.47.2021.08.30.16.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 16:11:04 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH] elx: efct: Fix void-pointer-to-enum-cast warning for efc_nport_topology
Date:   Mon, 30 Aug 2021 16:10:50 -0700
Message-Id: <20210830231050.5951-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

the kernel test robot flagged an warning for ".../efc_device.c:932:6:
warning: cast to smaller integer type 'enum efc_nport_topology' from
'void *'"

For the topology events, the "arg" field is generically defined as a
void * and is used to pass different arguments. Most of the arguments
are pointers to data structures. But for the
EFC_EVT_NPORT_TOPOLOGY_NOTIFY event, the argument is an enum value, and
the code is typecasting the void * to an enum generating the warning.

Fix by converting the EFC_EVT_NPORT_TOPOLOGY_NOTIFY event to pass a
pointer to the enum, thus it's a straight-forward pointer dereference
in the event handler.

Fixes: 202bfdffae27 ("scsi: elx: libefc: FC node ELS and state handling")
Reported-by: kernel test robot <lkp@intel.com>
Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/libefc/efc_device.c | 7 +++----
 drivers/scsi/elx/libefc/efc_fabric.c | 3 +--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/elx/libefc/efc_device.c b/drivers/scsi/elx/libefc/efc_device.c
index 725ca2a23fb2..52be01333c6e 100644
--- a/drivers/scsi/elx/libefc/efc_device.c
+++ b/drivers/scsi/elx/libefc/efc_device.c
@@ -928,22 +928,21 @@ __efc_d_wait_topology_notify(struct efc_sm_ctx *ctx,
 		break;
 
 	case EFC_EVT_NPORT_TOPOLOGY_NOTIFY: {
-		enum efc_nport_topology topology =
-					(enum efc_nport_topology)arg;
+		enum efc_nport_topology *topology = arg;
 
 		WARN_ON(node->nport->domain->attached);
 
 		WARN_ON(node->send_ls_acc != EFC_NODE_SEND_LS_ACC_PLOGI);
 
 		node_printf(node, "topology notification, topology=%d\n",
-			    topology);
+			    *topology);
 
 		/* At the time the PLOGI was received, the topology was unknown,
 		 * so we didn't know which node would perform the domain attach:
 		 * 1. The node from which the PLOGI was sent (p2p) or
 		 * 2. The node to which the FLOGI was sent (fabric).
 		 */
-		if (topology == EFC_NPORT_TOPO_P2P) {
+		if (*topology == EFC_NPORT_TOPO_P2P) {
 			/* if this is p2p, need to attach to the domain using
 			 * the d_id from the PLOGI received
 			 */
diff --git a/drivers/scsi/elx/libefc/efc_fabric.c b/drivers/scsi/elx/libefc/efc_fabric.c
index d397220d9e54..3270ce40196c 100644
--- a/drivers/scsi/elx/libefc/efc_fabric.c
+++ b/drivers/scsi/elx/libefc/efc_fabric.c
@@ -107,7 +107,6 @@ void
 efc_fabric_notify_topology(struct efc_node *node)
 {
 	struct efc_node *tmp_node;
-	enum efc_nport_topology topology = node->nport->topology;
 	unsigned long index;
 
 	/*
@@ -118,7 +117,7 @@ efc_fabric_notify_topology(struct efc_node *node)
 		if (tmp_node != node) {
 			efc_node_post_event(tmp_node,
 					    EFC_EVT_NPORT_TOPOLOGY_NOTIFY,
-					    (void *)topology);
+					    &node->nport->topology);
 		}
 	}
 }
-- 
2.26.2

