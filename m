Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F189C35257
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 19:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 233A021789
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 19:28:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="q2SoCNwN";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="mkLHtMCB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388456AbgJBT2O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 15:28:14 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38496 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388321AbgJBT2K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 15:28:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 3541B8EE18B;
        Fri,  2 Oct 2020 12:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1601666889;
        bh=3pL9EYAVcTAbBFDIrqOl8kEYMnykySS3oUFcjqGIHlY=;
        h=Subject:From:To:Cc:Date:From;
        b=q2SoCNwNORD/hj4ZDO5aKWp1qkaQZ62yaCyu703I6KtRaHB9T7v5OQQeVjxhZAeiT
         9u+DQ2iuBhp/KVXOHj78jMYmRLs4iJS8XpcylpijeyjGvMoqiU1l5BnH19PijuA7iO
         wYK1CidqbOHeIAQnCeMFfg+LgkNz6wPfh52qaEsk=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id B8kwV0lblIKq; Fri,  2 Oct 2020 12:28:08 -0700 (PDT)
Received: from jarvis (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C7EDF8EE012;
        Fri,  2 Oct 2020 12:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1601666888;
        bh=3pL9EYAVcTAbBFDIrqOl8kEYMnykySS3oUFcjqGIHlY=;
        h=Subject:From:To:Cc:Date:From;
        b=mkLHtMCBYYSBlY3NteBr+Z8kSEw2WvEfgiVmwMDsXcATatrvJIJtpoZVBrQuu0uMU
         nKsJ5TMMxl2sSiAVyKK/nvREPLg136cI9FwcsNwiM15v9/dhsrVUa38q6QOms1ivKV
         vHAfsBtN6GnNZNOdLbCJnua3EPhTMUvFIkgPPYLU=
Message-ID: <32aab084a6bf83b48b7e609c35e3822ee0f778df.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.9-rc7
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 02 Oct 2020 12:28:04 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

   Two patches in driver frameworks.  The iscsi one corrects a bug
   induced by a BPF change to network locking and the other is a
   regression we introduced.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Mark Mielke (1):
      scsi: iscsi: iscsi_tcp: Avoid holding spinlock while calling getpeername()

Sudhakar Panneerselvam (1):
      scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case

And the diffstat:

 drivers/scsi/iscsi_tcp.c               | 22 +++++++++++++++-------
 drivers/target/target_core_transport.c |  3 ++-
 2 files changed, 17 insertions(+), 8 deletions(-)

With full diffs below.

James

---

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index b5dd1caae5e9..d10efb66cf19 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -736,6 +736,7 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	struct sockaddr_in6 addr;
+	struct socket *sock;
 	int rc;
 
 	switch(param) {
@@ -747,13 +748,17 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 			spin_unlock_bh(&conn->session->frwd_lock);
 			return -ENOTCONN;
 		}
+		sock = tcp_sw_conn->sock;
+		sock_hold(sock->sk);
+		spin_unlock_bh(&conn->session->frwd_lock);
+
 		if (param == ISCSI_PARAM_LOCAL_PORT)
-			rc = kernel_getsockname(tcp_sw_conn->sock,
+			rc = kernel_getsockname(sock,
 						(struct sockaddr *)&addr);
 		else
-			rc = kernel_getpeername(tcp_sw_conn->sock,
+			rc = kernel_getpeername(sock,
 						(struct sockaddr *)&addr);
-		spin_unlock_bh(&conn->session->frwd_lock);
+		sock_put(sock->sk);
 		if (rc < 0)
 			return rc;
 
@@ -775,6 +780,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 	struct iscsi_tcp_conn *tcp_conn;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn;
 	struct sockaddr_in6 addr;
+	struct socket *sock;
 	int rc;
 
 	switch (param) {
@@ -789,16 +795,18 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 			return -ENOTCONN;
 		}
 		tcp_conn = conn->dd_data;
-
 		tcp_sw_conn = tcp_conn->dd_data;
-		if (!tcp_sw_conn->sock) {
+		sock = tcp_sw_conn->sock;
+		if (!sock) {
 			spin_unlock_bh(&session->frwd_lock);
 			return -ENOTCONN;
 		}
+		sock_hold(sock->sk);
+		spin_unlock_bh(&session->frwd_lock);
 
-		rc = kernel_getsockname(tcp_sw_conn->sock,
+		rc = kernel_getsockname(sock,
 					(struct sockaddr *)&addr);
-		spin_unlock_bh(&session->frwd_lock);
+		sock_put(sock->sk);
 		if (rc < 0)
 			return rc;
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9fb0be0aa620..8dd289214dd8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1840,7 +1840,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * out unpacked_lun for the original se_cmd.
 	 */
 	if (tm_type == TMR_ABORT_TASK && (flags & TARGET_SCF_LOOKUP_LUN_FROM_TAG)) {
-		if (!target_lookup_lun_from_tag(se_sess, tag, &unpacked_lun))
+		if (!target_lookup_lun_from_tag(se_sess, tag,
+						&se_cmd->orig_fe_lun))
 			goto failure;
 	}
 

