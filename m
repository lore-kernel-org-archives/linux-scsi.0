Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3661C54E8D
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96D512082E
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:58:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hLm1AjDo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgEJV6D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 17:58:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26282 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729426AbgEJV6D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2020 17:58:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589147881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rvoZGSRWBEXYEtlMWTnXJDJmfm1hmNo6v+xGFxXvqPo=;
        b=hLm1AjDopXh1U233cB+ozN6/+g/0Ue9ZBlpqf98eoZIMZS9Bt92IvFQM+73mXuOqqaTVb4
        NRqeKY4Bnsygdgo/aSh0AfV5xOctdAxHFfW0NWfm2sbEmd/dXj3Aw5OAQxfN5OVu0JPF1t
        gKCRa3EgobgjcDjevo0jUjmtpltae6s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-XIOpnXElP2GNph8mO1ilvw-1; Sun, 10 May 2020 17:57:59 -0400
X-MC-Unique: XIOpnXElP2GNph8mO1ilvw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 352761005510;
        Sun, 10 May 2020 21:57:58 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-113-0.rdu2.redhat.com [10.10.113.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C57111002382;
        Sun, 10 May 2020 21:57:55 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 03/15] target: add helper to parse acl and transport name
Date:   Sun, 10 May 2020 16:57:32 -0500
Message-Id: <20200510215744.21999-4-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-1-mchristi@redhat.com>
References: <20200510215744.21999-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The drivers that emulate the initiator port id (loop, scsi vhost, xen scsiback)
do almost the extact same parsing when making their I_T_nexus. This adds a
helper that parses out the acl name and port name from the user buffer, so
these types of drivers drop prefixes like "naa." when they need to for the
SCSI SPC4 TransportID SAS address, but then keep it for the LIO ACL name.

The next patches will then convert those drivers.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_fabric_lib.c | 73 +++++++++++++++++++++++++++++++++
 include/target/target_core_fabric.h     |  2 +
 2 files changed, 75 insertions(+)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index e89b3d8..81ed7d5 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -423,6 +423,79 @@ const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
 	return buf + offset;
 }
 
+/**
+ * target_parse_emulated_name - parse TransportID and acl name from user buffer
+ * @proto_id: SCSI protocol identifier
+ * @user_buf: buffer with emualted name to extract acl and TransportID from
+ * @acl_name: buffer to store se_node_acl name in
+ * @max_name_len: len of acl_name buffer
+ * @tpt_id_name: Pointer to the TransportID name will be stored here.
+ */
+int target_parse_emulated_name(u8 proto_id, const char *user_buf,
+			       unsigned char *acl_name, int max_name_len,
+			       unsigned char **tpt_id_name)
+{
+	int user_len = strlen(user_buf);
+	char *proto_prefix, *name_start;
+
+	if (user_len >= max_name_len) {
+		pr_err("Emulated name: %s, exceeds max: %d\n", user_buf,
+		       max_name_len);
+		return -EINVAL;
+	}
+
+	switch (proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		proto_prefix = "naa.";
+		break;
+	case SCSI_PROTOCOL_FCP:
+		proto_prefix = "fc.";
+		break;
+	case SCSI_PROTOCOL_ISCSI:
+		proto_prefix = "iqn.";
+		break;
+	default:
+		pr_err("Unsupported proto_id: 0x%02x\n", proto_id);
+		return -EINVAL;
+	}
+
+	name_start = strstr(user_buf, proto_prefix);
+	if (!name_start) {
+		pr_err("Invalid emulated name %s. Must start with %s\n",
+		       user_buf, proto_prefix);
+		return -EINVAL;
+	}
+
+	switch (proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		sprintf(acl_name, name_start);
+		break;
+	case SCSI_PROTOCOL_FCP:
+		sprintf(acl_name, &name_start[3]); /* Skip over "fc." */
+		break;
+	case SCSI_PROTOCOL_ISCSI:
+		sprintf(acl_name, name_start);
+		break;
+	}
+
+	if (acl_name[user_len - 1] == '\n')
+		acl_name[user_len - 1] = '\0';
+
+	if (proto_id == SCSI_PROTOCOL_SAS) {
+		/*
+		 * target_setup_session will want the naa. prefix to match
+		 * the ACL name, but the t10 transport id only wants the
+		 * address.
+		 */
+		*tpt_id_name = acl_name + 4;
+	} else {
+		*tpt_id_name = acl_name;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(target_parse_emulated_name);
+
 struct t10_transport_id *target_create_transport_id(u8 proto, const char *name,
 						    const char *session_id)
 {
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index af1dd81..0113e1c 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -125,6 +125,8 @@ struct target_core_fabric_ops {
 int target_depend_item(struct config_item *item);
 void target_undepend_item(struct config_item *item);
 
+int target_parse_emulated_name(u8, const char *, unsigned char *, int,
+			       unsigned char **);
 struct t10_transport_id *target_create_transport_id(u8, const char *,
 						    const char *);
 void target_free_transport_id(struct t10_transport_id *);
-- 
1.8.3.1

