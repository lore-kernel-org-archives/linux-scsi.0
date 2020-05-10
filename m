Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3B4C54E8F
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FDC22080C
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZYgY4Cfq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgEJV6G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 17:58:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60414 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727771AbgEJV6F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 May 2020 17:58:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589147884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jUi/69iaDVbNPqCoWyiNX9mn40b+dGSpMRQdJMaf+O0=;
        b=ZYgY4CfqJLTZ6uUhFsTjHbF387gWODL56QHSUVDNizsFk1Twtohqlir4gCNS5OzH1Jw62U
        2dwW2sW21JMeuMm615nM7NYc3Bb28nntkSX9Cj0AfCFrNDefN/UfBA29epw/8JPmlcVzec
        EsS1yuSh748uuZdd/a2q2kIHNjXvsF8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-M3GIETe_Pcmd60WKHVItrg-1; Sun, 10 May 2020 17:58:02 -0400
X-MC-Unique: M3GIETe_Pcmd60WKHVItrg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB6C41899520;
        Sun, 10 May 2020 21:58:00 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-113-0.rdu2.redhat.com [10.10.113.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4D251002382;
        Sun, 10 May 2020 21:57:59 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 06/15] xen scsiback: use target_parse_emulated_name
Date:   Sun, 10 May 2020 16:57:35 -0500
Message-Id: <20200510215744.21999-7-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-1-mchristi@redhat.com>
References: <20200510215744.21999-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use target_parse_emulated_name so the acl and SCSI names are
properly formatted.

Cc: Juergen Gross <jgross@suse.com>
Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/xen/xen-scsiback.c | 66 ++++++++--------------------------------------
 1 file changed, 11 insertions(+), 55 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 93cb386..f70b6da 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1509,7 +1509,8 @@ static int scsiback_alloc_sess_cb(struct se_portal_group *se_tpg,
 }
 
 static int scsiback_make_nexus(struct scsiback_tpg *tpg,
-				const char *name)
+				const char *tpt_id_name,
+				const char *acl_name)
 {
 	struct scsiback_nexus *tv_nexus;
 	int ret = 0;
@@ -1530,8 +1531,9 @@ static int scsiback_make_nexus(struct scsiback_tpg *tpg,
 	tv_nexus->tvn_se_sess = target_setup_session(&tpg->se_tpg,
 						     VSCSI_DEFAULT_SESSION_TAGS,
 						     sizeof(struct vscsibk_pend),
-						     TARGET_PROT_NORMAL, name,
-						     name, tv_nexus,
+						     TARGET_PROT_NORMAL,
+						     tpt_id_name, acl_name,
+						     tv_nexus,
 						     scsiback_alloc_sess_cb);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		kfree(tv_nexus);
@@ -1619,7 +1621,7 @@ static ssize_t scsiback_tpg_nexus_store(struct config_item *item,
 	struct scsiback_tpg *tpg = container_of(se_tpg,
 				struct scsiback_tpg, se_tpg);
 	struct scsiback_tport *tport_wwn = tpg->tport;
-	unsigned char i_port[VSCSI_NAMELEN], *ptr, *port_ptr;
+	unsigned char i_port[VSCSI_NAMELEN], *tpt_id_name;
 	int ret;
 	/*
 	 * Shutdown the active I_T nexus if 'NULL' is passed.
@@ -1628,59 +1630,13 @@ static ssize_t scsiback_tpg_nexus_store(struct config_item *item,
 		ret = scsiback_drop_nexus(tpg);
 		return (!ret) ? count : ret;
 	}
-	/*
-	 * Otherwise make sure the passed virtual Initiator port WWN matches
-	 * the fabric protocol_id set in scsiback_make_tport(), and call
-	 * scsiback_make_nexus().
-	 */
-	if (strlen(page) >= VSCSI_NAMELEN) {
-		pr_err("Emulated NAA Sas Address: %s, exceeds max: %d\n",
-			page, VSCSI_NAMELEN);
-		return -EINVAL;
-	}
-	snprintf(&i_port[0], VSCSI_NAMELEN, "%s", page);
 
-	ptr = strstr(i_port, "naa.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_SAS) {
-			pr_err("Passed SAS Initiator Port %s does not match target port protoid: %s\n",
-				i_port, scsiback_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[0];
-		goto check_newline;
-	}
-	ptr = strstr(i_port, "fc.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_FCP) {
-			pr_err("Passed FCP Initiator Port %s does not match target port protoid: %s\n",
-				i_port, scsiback_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[3]; /* Skip over "fc." */
-		goto check_newline;
-	}
-	ptr = strstr(i_port, "iqn.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_ISCSI) {
-			pr_err("Passed iSCSI Initiator Port %s does not match target port protoid: %s\n",
-				i_port, scsiback_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[0];
-		goto check_newline;
-	}
-	pr_err("Unable to locate prefix for emulated Initiator Port: %s\n",
-		i_port);
-	return -EINVAL;
-	/*
-	 * Clear any trailing newline for the NAA WWN
-	 */
-check_newline:
-	if (i_port[strlen(i_port) - 1] == '\n')
-		i_port[strlen(i_port) - 1] = '\0';
+	ret = target_parse_emulated_name(tport_wwn->tport_proto_id, page,
+					 i_port, VSCSI_NAMELEN, &tpt_id_name);
+	if (ret)
+		return ret;
 
-	ret = scsiback_make_nexus(tpg, port_ptr);
+	ret = scsiback_make_nexus(tpg, tpt_id_name, i_port);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.3.1

