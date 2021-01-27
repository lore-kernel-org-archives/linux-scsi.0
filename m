Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4472CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F346A2070C
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343664AbhA0EVy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:21:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:39066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404732AbhA0BoQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Jan 2021 20:44:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BE3E6AD0B;
        Wed, 27 Jan 2021 01:21:25 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 366415BD6DE; Tue, 26 Jan 2021 17:21:24 -0800 (PST)
From:   Lee Duncan <leeman.duncan@gmail.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org,
        Lee Duncan <lduncan@suse.com>
Subject: [PATCH] fnic: fixup patch to resolve stack frame issues
Date:   Tue, 26 Jan 2021 17:21:24 -0800
Message-Id: <20210127012124.22241-1-leeman.duncan@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Commit 42ec15ceaea7 fixed a gcc issue with unused variables, but
introduced errors since it allocated an array of two u64-s but
then used more than that. Set the arrays to the proper size.

Fixes: 42ec15ceaea74b5f7a621fc6686cbf69ca66c4cf
Cc: stable@vger.kernel.org
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/fnic/vnic_dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index 5988c300cc82..d29999064b89 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -697,7 +697,7 @@ int vnic_dev_hang_notify(struct vnic_dev *vdev)
 
 int vnic_dev_mac_addr(struct vnic_dev *vdev, u8 *mac_addr)
 {
-	u64 a[2] = {};
+	u64 a[ETH_ALEN] = {};
 	int wait = 1000;
 	int err, i;
 
@@ -734,7 +734,7 @@ void vnic_dev_packet_filter(struct vnic_dev *vdev, int directed, int multicast,
 
 void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
 {
-	u64 a[2] = {};
+	u64 a[ETH_ALEN] = {};
 	int wait = 1000;
 	int err;
 	int i;
@@ -749,7 +749,7 @@ void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
 
 void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
 {
-	u64 a[2] = {};
+	u64 a[ETH_ALEN] = {};
 	int wait = 1000;
 	int err;
 	int i;
-- 
2.26.2

