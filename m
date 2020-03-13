Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464E4C2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 17:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A9752076C
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 17:07:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FDQT6jL0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgCMRHH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 13:07:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24676 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726406AbgCMRHH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Mar 2020 13:07:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584119226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXmOBN3bY/s/4oig2u5w63YuRiyUC6cSPUrcJcU8V2Q=;
        b=FDQT6jL00HfN+BqbbUvvNWiSiQ0zjpAN6cHF5hPXNC2yUY9SposjBJfwWaWaZTvij+48YC
        SI3N6mSicGAOdoQWLZotavGAg35K/njITacPSyiCr+kAxiKmAPdcOOSoH5KICMpZ/DwI06
        +LejjOGC3JnbCnfpr7iEuvBf/8k0tTk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-zdoi12mGPB2wtIkNZUHWxA-1; Fri, 13 Mar 2020 13:07:04 -0400
X-MC-Unique: zdoi12mGPB2wtIkNZUHWxA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BDA4184D288;
        Fri, 13 Mar 2020 17:07:03 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-206-24.brq.redhat.com [10.40.206.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4ABD473862;
        Fri, 13 Mar 2020 17:07:01 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org, ddiss@suse.de,
        mcoleman@datto.com, linux-scsi@vger.kernel.org
Subject: [PATCH RESEND 1/3] target: remove boilerplate code
Date:   Fri, 13 Mar 2020 18:06:54 +0100
Message-Id: <20200313170656.9716-2-mlombard@redhat.com>
In-Reply-To: <20200313170656.9716-1-mlombard@redhat.com>
References: <20200313170656.9716-1-mlombard@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iscsit_free_session() is equivalent to iscsit_stop_session()
followed by a call to iscsit_close_session()

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c | 46 ++---------------------------
 drivers/target/iscsi/iscsi_target.h |  1 -
 2 files changed, 2 insertions(+), 45 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
index 59d32453b891..a955ab73eaae 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4577,49 +4577,6 @@ void iscsit_fail_session(struct iscsi_session *ses=
s)
 	sess->session_state =3D TARG_SESS_STATE_FAILED;
 }
=20
-int iscsit_free_session(struct iscsi_session *sess)
-{
-	u16 conn_count =3D atomic_read(&sess->nconn);
-	struct iscsi_conn *conn, *conn_tmp =3D NULL;
-	int is_last;
-
-	spin_lock_bh(&sess->conn_lock);
-	atomic_set(&sess->sleep_on_sess_wait_comp, 1);
-
-	list_for_each_entry_safe(conn, conn_tmp, &sess->sess_conn_list,
-			conn_list) {
-		if (conn_count =3D=3D 0)
-			break;
-
-		if (list_is_last(&conn->conn_list, &sess->sess_conn_list)) {
-			is_last =3D 1;
-		} else {
-			iscsit_inc_conn_usage_count(conn_tmp);
-			is_last =3D 0;
-		}
-		iscsit_inc_conn_usage_count(conn);
-
-		spin_unlock_bh(&sess->conn_lock);
-		iscsit_cause_connection_reinstatement(conn, 1);
-		spin_lock_bh(&sess->conn_lock);
-
-		iscsit_dec_conn_usage_count(conn);
-		if (is_last =3D=3D 0)
-			iscsit_dec_conn_usage_count(conn_tmp);
-
-		conn_count--;
-	}
-
-	if (atomic_read(&sess->nconn)) {
-		spin_unlock_bh(&sess->conn_lock);
-		wait_for_completion(&sess->session_wait_comp);
-	} else
-		spin_unlock_bh(&sess->conn_lock);
-
-	iscsit_close_session(sess);
-	return 0;
-}
-
 void iscsit_stop_session(
 	struct iscsi_session *sess,
 	int session_sleep,
@@ -4704,7 +4661,8 @@ int iscsit_release_sessions_for_tpg(struct iscsi_po=
rtal_group *tpg, int force)
 	list_for_each_entry_safe(se_sess, se_sess_tmp, &free_list, sess_list) {
 		sess =3D (struct iscsi_session *)se_sess->fabric_sess_ptr;
=20
-		iscsit_free_session(sess);
+		iscsit_stop_session(sess, 1, 1);
+		iscsit_close_session(sess);
 		session_count++;
 	}
=20
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/i=
scsi_target.h
index c95f56a3ce31..7409ce2a6607 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -43,7 +43,6 @@ extern int iscsi_target_rx_thread(void *);
 extern int iscsit_close_connection(struct iscsi_conn *);
 extern int iscsit_close_session(struct iscsi_session *);
 extern void iscsit_fail_session(struct iscsi_session *);
-extern int iscsit_free_session(struct iscsi_session *);
 extern void iscsit_stop_session(struct iscsi_session *, int, int);
 extern int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *, =
int);
=20
--=20
2.21.0

