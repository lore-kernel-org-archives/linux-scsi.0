Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91266EED619
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 17:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbjIORLb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 13:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235466AbjIORLV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 13:11:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A5A19BC
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 10:11:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-cf4cb742715so2826929276.2
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 10:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694797874; x=1695402674; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bOqFz4mwu4R8vVhIHYO47D/MyrIS2uBdDRxhIpCvwuY=;
        b=JwG+DbNsDLV9VBySrOCi5UcX1b+LS9Fwx3tlhXxoP8wrVMUFqFAwOMejtEb2gnVkhh
         d4ShbJCa06o/n1ggzQ/CQQJxq+ejRVKK6k0sX0LPfwcAMiEK5Y+Rx668AlEldyo2vGmP
         cRxKD4u3FMNiMQj6seoRTGyQa3dAXr++DZiiJEGrBfZXfkjcamOIhtBdZ8Rj3HQINyvy
         LjGi0T5bySYIJZY4kmMzR3qGl91DR+ZgR8AtVVt0UZbXgoZDzWyogNN13Vbo1FSX7CxD
         QGiOB/LXNv6ZPGwkx5y89+wXYETRyBNcBt1jS6VymByrj4DLXTcfroic3NF28O9705zB
         6seg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694797874; x=1695402674;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bOqFz4mwu4R8vVhIHYO47D/MyrIS2uBdDRxhIpCvwuY=;
        b=UjSuNApuDWiJ+bobvjD/3latl2WMxNP6RyylB72ThuZ/sFqR46cHXaNTszU005B8m/
         WAzIe/cNxfQK6fV0tqG9LxOdZbVvGNIIZOcSi5hWqgwzSuOswJgoBcVbfe3XAIowAdbf
         jVGX0tU14/GlNdT03pdqRFaNeFxcwrgnvNcA3Jcdjr9UwdZTYslifEEZVnXkpAy+WXiu
         /c4jdRtJ9KtuGYpQju3f8JDgoRndSer4RdwsqsAlKOwUcA9QXHgNykRvL74yAgVmFcRv
         FuqiwF6gYiu+Q48Zb9KLkc8VGmQmOJcJqM7t2vnsyXovOIOezWLr0fBBFZEAuB7I8AbB
         tUnQ==
X-Gm-Message-State: AOJu0Yy7VDOyK5HD2a6VG+wdR/1kFxtz7fuUeoSyAU2icG8VXC9Wsnfj
        1KYyKOMTxb8aQ6BppghTjeSH204FjvbDvw==
X-Google-Smtp-Source: AGHT+IG7rGE3Ztuz1Grnmkp8w2vtWInjs5QzEYeJJbfCf6lDpmA/8jA7FGucjoqfvQlgDMwKTaP3deHGl0CsJQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:118a:b0:d80:183c:92b9 with SMTP
 id m10-20020a056902118a00b00d80183c92b9mr60345ybu.4.1694797874299; Fri, 15
 Sep 2023 10:11:14 -0700 (PDT)
Date:   Fri, 15 Sep 2023 17:11:11 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230915171111.4057930-1-edumazet@google.com>
Subject: [PATCH] scsi: iscsi_tcp: restrict to TCP sockets
From:   Eric Dumazet <edumazet@google.com>
To:     Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        Chris Leech <cleech@redhat.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Nothing prevents iscsi_sw_tcp_conn_bind() to receive file descriptor
pointing to non TCP socket (af_unix for example).

Return -EINVAL if this is attempted, instead of crashing the kernel.

Fixes: 7ba247138907 ("[SCSI] open-iscsi/linux-iscsi-5 Initiator: Initiator code")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/iscsi_tcp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9ab8555180a3a0bd159b621a57c99bcb8f0413ae..8e14cea15f980829e99afa2c43bf6872fcfd965c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -724,6 +724,10 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 		return -EEXIST;
 	}
 
+	err = -EINVAL;
+	if (!sk_is_tcp(sock->sk))
+		goto free_socket;
+
 	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
 	if (err)
 		goto free_socket;
-- 
2.42.0.459.ge4e396fd5e-goog

