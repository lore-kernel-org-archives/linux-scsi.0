Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A8DC43334
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jun 2022 12:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbiFLMUu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jun 2022 08:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiFLMUt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jun 2022 08:20:49 -0400
X-Greylist: delayed 327 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Jun 2022 05:20:49 PDT
Received: from stargate.chelsio.com (stargate.chelsio.com [12.32.117.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8D52C662
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jun 2022 05:20:48 -0700 (PDT)
Received: from lanta.blr.asicdesigners.com (lanta.blr.asicdesigners.com [10.193.186.249])
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 25CCKaIt018047;
        Sun, 12 Jun 2022 05:20:37 -0700
From:   Varun Prakash <varun@chelsio.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        cleech@redhat.com, lduncan@suse.com, varun@chelsio.com,
        vinoth.r@chelsio.com
Subject: [PATCH] scsi: iscsi: start endpoint ID allocation from 1
Date:   Sun, 12 Jun 2022 17:49:01 +0530
Message-Id: <20220612121901.6897-1-varun@chelsio.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ktransport_ep_connect() (defined in open-iscsi/usr/netlink.c)
returns -EIO if endpoint ID is 0.

int
ktransport_ep_connect(iscsi_conn_t *conn, int non_blocking)
{
	...
	rc = __kipc_call(iov, 2);
	if (rc < 0)
		return rc;

	if (!ev->r.ep_connect_ret.handle)
		return -EIO;

	conn->transport_ep_handle = ev->r.ep_connect_ret.handle;
	...
}

Fixes: 3c6ae371b8a1 ("scsi: iscsi: Release endpoint ID when its freed")
Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2c0dd64159b0..5ad69c65cbe0 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -212,7 +212,7 @@ iscsi_create_endpoint(int dd_size)
 		return NULL;
 
 	mutex_lock(&iscsi_ep_idr_mutex);
-	id = idr_alloc(&iscsi_ep_idr, ep, 0, -1, GFP_NOIO);
+	id = idr_alloc(&iscsi_ep_idr, ep, 1, -1, GFP_NOIO);
 	if (id < 0) {
 		mutex_unlock(&iscsi_ep_idr_mutex);
 		printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",
-- 
2.27.0

