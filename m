Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419F8C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 15:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 184A720578
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 15:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfH2P7k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 11:59:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52398 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfH2P7k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Aug 2019 11:59:40 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4BD6B18AF959;
        Thu, 29 Aug 2019 15:59:40 +0000 (UTC)
Received: from manaslu.redhat.com (unknown [10.35.206.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 289B15D772;
        Thu, 29 Aug 2019 15:59:37 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     cleech@redhat.com
Cc:     mchristi@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 2/4] target-iscsi: remove unneeded function
Date:   Thu, 29 Aug 2019 17:59:27 +0200
Message-Id: <20190829155929.27701-3-mlombard@redhat.com>
In-Reply-To: <20190829155929.27701-1-mlombard@redhat.com>
References: <20190829155929.27701-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Thu, 29 Aug 2019 15:59:40 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The digest type validy is already checked by chap_server_open(), therefore
we can remove the chap_got_response() function.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_auth.c | 26 +-----------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 3d1e94333835..77dac8086927 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -473,30 +473,6 @@ static int chap_server_compute_hash(
 	return auth_ret;
 }
 
-static int chap_got_response(
-	struct iscsi_conn *conn,
-	struct iscsi_node_auth *auth,
-	char *nr_in_ptr,
-	char *nr_out_ptr,
-	unsigned int *nr_out_len)
-{
-	struct iscsi_chap *chap = conn->auth_protocol;
-
-	switch (chap->digest_type) {
-	case CHAP_DIGEST_MD5:
-	case CHAP_DIGEST_SHA:
-	case CHAP_DIGEST_SHA3_256:
-		if (chap_server_compute_hash(conn, auth, nr_in_ptr,
-				nr_out_ptr, nr_out_len) < 0)
-			return -1;
-		return 0;
-	default:
-		pr_err("Unknown CHAP digest type %d!\n",
-				chap->digest_type);
-		return -1;
-	}
-}
-
 u32 chap_main_loop(
 	struct iscsi_conn *conn,
 	struct iscsi_node_auth *auth,
@@ -515,7 +491,7 @@ u32 chap_main_loop(
 		return 0;
 	} else if (chap->chap_state == CHAP_STAGE_SERVER_AIC) {
 		convert_null_to_semi(in_text, *in_len);
-		if (chap_got_response(conn, auth, in_text, out_text,
+		if (chap_server_compute_hash(conn, auth, in_text, out_text,
 				out_len) < 0) {
 			chap_close(conn);
 			return 2;
-- 
Maurizio Lombardi

