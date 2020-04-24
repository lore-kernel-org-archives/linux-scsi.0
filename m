Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD4EC54FD0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 11:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 987C320767
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 11:39:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IIWQoebz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgDXLjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 07:39:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45445 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726247AbgDXLjT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 07:39:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587728358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xxxLi1TfzeYigzHm669zYEJS2CbEA2mBx6261qZIdqE=;
        b=IIWQoebzFuuECrAK8b7BGI8YfcvVhezSluusIeSeewdFEJ8LHYQu11IuS8N9Dm5RPtxuaR
        3F0kSsbGFXa41eqf6MY4bYAM4sRh3ruxhbwhLBHknHrRZAcI65dVfkJkS8GkKjCEsZtvx1
        knZK5wS/GS8J28SLufUT9IyXac89qqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-0lCv8dA9MfeVZnUkf7QdLw-1; Fri, 24 Apr 2020 07:39:16 -0400
X-MC-Unique: 0lCv8dA9MfeVZnUkf7QdLw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BC8C100AA23;
        Fri, 24 Apr 2020 11:39:15 +0000 (UTC)
Received: from nangaparbat.redhat.com (unknown [10.40.194.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31E3E605CF;
        Fri, 24 Apr 2020 11:39:13 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH] target: iscsi: remove the iscsi_data_count structure
Date:   Fri, 24 Apr 2020 13:39:13 +0200
Message-Id: <20200424113913.17237-1-mlombard@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch removes the iscsi_data_count structure and the
iscsit_do_rx_data() function because they are used only by rx_data()

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_util.c | 30 +++++-------------------
 include/target/iscsi/iscsi_target_core.h | 10 --------
 2 files changed, 6 insertions(+), 34 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/is=
csi/iscsi_target_util.c
index fae85bfd790e..25677e2865be 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1236,18 +1236,20 @@ void iscsit_print_session_params(struct iscsi_ses=
sion *sess)
 	iscsi_dump_sess_ops(sess->sess_ops);
 }
=20
-static int iscsit_do_rx_data(
+int rx_data(
 	struct iscsi_conn *conn,
-	struct iscsi_data_count *count)
+	struct kvec *iov,
+	int iov_count,
+	int data)
 {
-	int data =3D count->data_length, rx_loop =3D 0, total_rx =3D 0;
+	int rx_loop =3D 0, total_rx =3D 0;
 	struct msghdr msg;
=20
 	if (!conn || !conn->sock || !conn->conn_ops)
 		return -1;
=20
 	memset(&msg, 0, sizeof(struct msghdr));
-	iov_iter_kvec(&msg.msg_iter, READ, count->iov, count->iov_count, data);
+	iov_iter_kvec(&msg.msg_iter, READ, iov, iov_count, data);
=20
 	while (msg_data_left(&msg)) {
 		rx_loop =3D sock_recvmsg(conn->sock, &msg, MSG_WAITALL);
@@ -1264,26 +1266,6 @@ static int iscsit_do_rx_data(
 	return total_rx;
 }
=20
-int rx_data(
-	struct iscsi_conn *conn,
-	struct kvec *iov,
-	int iov_count,
-	int data)
-{
-	struct iscsi_data_count c;
-
-	if (!conn || !conn->sock || !conn->conn_ops)
-		return -1;
-
-	memset(&c, 0, sizeof(struct iscsi_data_count));
-	c.iov =3D iov;
-	c.iov_count =3D iov_count;
-	c.data_length =3D data;
-	c.type =3D ISCSI_RX_DATA;
-
-	return iscsit_do_rx_data(conn, &c);
-}
-
 int tx_data(
 	struct iscsi_conn *conn,
 	struct kvec *iov,
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/is=
csi/iscsi_target_core.h
index a49d37140a64..c2de9274c57a 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -301,16 +301,6 @@ struct iscsi_queue_req {
 	struct list_head	qr_list;
 };
=20
-struct iscsi_data_count {
-	int			data_length;
-	int			sync_and_steering;
-	enum data_count_type	type;
-	u32			iov_count;
-	u32			ss_iov_count;
-	u32			ss_marker_count;
-	struct kvec		*iov;
-};
-
 struct iscsi_param_list {
 	bool			iser;
 	struct list_head	param_list;
--=20
2.25.3

