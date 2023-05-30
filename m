Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993ABC7EE2C
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 15:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbjE3P6m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 11:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbjE3P6f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 11:58:35 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705F6106;
        Tue, 30 May 2023 08:58:22 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-776fdba68ecso131599439f.1;
        Tue, 30 May 2023 08:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685462301; x=1688054301;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0W1ZMJcFCP9WzzPAXOyz5x6oO4Ir7TdajV4+qJUvDFw=;
        b=f0YG9MFO2a3+WhBY4erUhouLjfQGEreHM8y8IhX1YRkAz3+mxfoQTySIVyJs3ZIKjS
         Niz8A+WLgToUy8DUbV52Z7casCFtu37uIsBvj6+BjPpmdyNYqU1GzcDnDJJ1asnjeQ+/
         dvjLuABSIjHQA+9f6gwRQnVNkM7ri5ET/GlbeSv7nvz4wJ8lToYZA82rkbC6akJ9YiLy
         5u/hxX6biDAlfb6jVqrMVOKbJN7uUkW1QChsQqUv2IvcwMin9tAwC7YmAu0PURRiY7hg
         +M9W25LBsGgnTVA3FCeXPw157/CX/oP4ukWYnnEHiV2pNBAAH5fqcGKLh0fRLKo5Wug7
         THDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685462301; x=1688054301;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0W1ZMJcFCP9WzzPAXOyz5x6oO4Ir7TdajV4+qJUvDFw=;
        b=gbgejqd53Rb7LF2ia9UytEmyhH2Xk4HK9aOPfKp5MFr9fHYVtdngsHCf6PvJnlcNZW
         vnrJ+Igu7YE952g9X7AZsXBsFYXIV1J8aSYBd+ewp6PmHsQWf3WT6Vx+Klgy3dLlOGoE
         t5T9N5JxYtDL+yWneEECQOjxoYxR+JRe5oH1Q2Ot0yoXVZxTlsR0Ie33xqeeQwMQTcCR
         xJ2cCtBNRTuyt3/Edn8AtfF18WdBXRasncSXay+g+HXejPdCAF/WLqIfmpsE7DyLFzDB
         Z6/xGe1XyHEVWKYvS3RCAJsN9waGGXpNxD+MRYdZAlPHZ3c14/Xk0rh7GeS494hPZT9q
         e6lQ==
X-Gm-Message-State: AC+VfDzMQmRKux0q8hqJB+2FolnIdpVvF2lVxbXycvYiGLEIqWATfTsv
        RLh35BdZBkxcQCZ49+JfVqo=
X-Google-Smtp-Source: ACHHUZ7rTLYJyMJyACjRDHZgSepoJ6498WjYqFdhHsnCRGlYrMurJe+oMJhPKCnVsNiUf6wmtWxATA==
X-Received: by 2002:a92:d405:0:b0:338:b9a1:5d06 with SMTP id q5-20020a92d405000000b00338b9a15d06mr47798ilm.2.1685462301630;
        Tue, 30 May 2023 08:58:21 -0700 (PDT)
Received: from azeems-kspp.c.googlers.com.com (54.70.188.35.bc.googleusercontent.com. [35.188.70.54])
        by smtp.gmail.com with ESMTPSA id p31-20020a056638191f00b0041650ca49casm818570jal.83.2023.05.30.08.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 08:58:21 -0700 (PDT)
From:   Azeem Shaikh <azeemshaikh38@gmail.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-hardening@vger.kernel.org,
        Azeem Shaikh <azeemshaikh38@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: libfcoe: Replace all non-returning strlcpy with strscpy
Date:   Tue, 30 May 2023 15:58:18 +0000
Message-ID: <20230530155818.368562-1-azeemshaikh38@gmail.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

strlcpy() reads the entire source buffer first.
This read may exceed the destination size limit.
This is both inefficient and can lead to linear read
overflows if a source string is not NUL-terminated [1].
In an effort to remove strlcpy() completely [2], replace
strlcpy() here with strscpy().
No return values were used, so direct replacement is safe.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89

Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
---
 drivers/scsi/fcoe/fcoe_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 46b0bf237be1..a48d24af9ac3 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -711,7 +711,7 @@ static struct net_device *fcoe_if_to_netdev(const char *buffer)
 	char ifname[IFNAMSIZ + 2];
 
 	if (buffer) {
-		strlcpy(ifname, buffer, IFNAMSIZ);
+		strscpy(ifname, buffer, IFNAMSIZ);
 		cp = ifname + strlen(ifname);
 		while (--cp >= ifname && *cp == '\n')
 			*cp = '\0';

