Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 062DDC00A8F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 19:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344237AbjJXTwc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 15:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbjJXTwb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 15:52:31 -0400
Received: from mail-oa1-x49.google.com (mail-oa1-x49.google.com [IPv6:2001:4860:4864:20::49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F799F
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 12:52:29 -0700 (PDT)
Received: by mail-oa1-x49.google.com with SMTP id 586e51a60fabf-1d5f4d5d848so6793041fac.0
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 12:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698177148; x=1698781948; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e8aQgWjy+g6rrzKEDI21tp5NK7yplRQyyhfNiiPxWK0=;
        b=mo5et0EQNBbjn0YYf02+tHNMi5Qt8QpTnjDmOuLVZYB0UbKp9TfDe3btq2w2wPliL7
         EeraHHLcoG/hLzSbFfqh6+y3OTE9FdUbjn6LaKGcLSYK5JR5aYI+DrmWvoOXiPoF1d1a
         KpnlQggqhHvgEHG1SFukRaZGxughB1L1oCYupjw94amlcVhwA/waaUw/kPL7SpdIeUnF
         jb1RRcnzItOmxt2sTAiYNcdAdFQV7/HtHJOLgV3Zssx5M4LEryZ3edxorQMK+cr+ab5r
         +laiovkXixdEMnEv02VlmDnBq1JHhxHrdyrvVOjR1VqN65fPfCpwsQviQQBCzzy2OcsC
         qWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698177148; x=1698781948;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e8aQgWjy+g6rrzKEDI21tp5NK7yplRQyyhfNiiPxWK0=;
        b=v5MhLlDdXegu3UkDOCO7By4N2vP3br1wyUqsb5mrjuyT7IvGfgagte02q9FVoPW1JD
         j6oFc+OprkqqIjR7UH+JAzRzRux6+9eQ2KakOfNqMIk3/iwZPSTK6d48wVaibYYmgM33
         RAv9NzUlFYxhFbn9jbRWAAk8l4QTHYONV+8tlUZ5rPynoF5dWBVVhnJePmcy2+Bchke/
         OgMV7RjDwq4B67QLcvoNuq38gDTsW9UciH5CsXJm5VW9aLtX8KwrckYjouxZ/KqWTZbW
         bhh2e042nVg4pgTw/hmRO7TXggk26/4J6kT71gIL4/Ra5brOEHX2dnLC8XW4scQT88Q2
         W8rg==
X-Gm-Message-State: AOJu0YzeZxveAP1r965DtdqCUlF/IVaABjCNuu6tC27zzNT4iAxDlM2l
        DvWTeOXIDARx60F8ci2fQSgTsY/a3jd07BKK5g==
X-Google-Smtp-Source: AGHT+IGGhfv6HHv8vXiL6PZflYVg3AGRykgoK0m9EB5iPd5E7rZQ1ga5+DHB0xzvTTrUTEMzpkPIvFiJFLGLMgeCwg==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6870:148d:b0:1d6:5e45:3bc7 with
 SMTP id k13-20020a056870148d00b001d65e453bc7mr6259319oab.5.1698177148786;
 Tue, 24 Oct 2023 12:52:28 -0700 (PDT)
Date:   Tue, 24 Oct 2023 19:52:27 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAHogOGUC/x2NwQqDMBAFf0X23IUkrSD+SilFkt26lyj7ilTEf
 2/wMjCXmYMgbgIau4NcNoMttUm8dZTnqX6ErTSnFNI9hvRgfL3mdefitomDkWGseZELb+xQcOY gsajKkIa+pxZbXdR+1+j5Os8/ZQjSqngAAAA=
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1698177147; l=2135;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=x4lXZ/M2v+LVXy5eVUWTnpdEr6YXqOCKy8sodhN2WbQ=; b=kNvSxaD6+DzKoEiD6sLJnAjh94iZPbZ1UevGx+Ev4FErVJiOdmvYoPiz8xLD17iSe3bcC4IOa
 Hd8masltLb4DdvVMlYaADHPOuC3Dpr7PWEcQ4FlU+zfiGwohD+QaLT2
X-Mailer: b4 0.12.3
Message-ID: <20231024-strncpy-drivers-scsi-fcoe-fcoe_sysfs-c-v1-1-1e0026ee032d@google.com>
Subject: [PATCH] scsi: fcoe: replace deprecated strncpy with strscpy
From:   Justin Stitt <justinstitt@google.com>
To:     Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

strncpy() is deprecated for use on NUL-terminated destination strings
[1] and as such we should prefer more robust and less ambiguous string
interfaces.

We expect `mode` to be NUL-terminated based on its usage with
strcasecmp():

|       ctlr->mode = fcoe_parse_mode(mode);
...
|       static enum fip_conn_type fcoe_parse_mode(const char *buf)
|       {
|       	int i;
|
|       	for (i = 0; i < ARRAY_SIZE(fip_conn_type_names); i++) {
|       		if (strcasecmp(buf, fip_conn_type_names[i]) == 0)
|       			return i;
|       	}
|
|       	return FIP_CONN_TYPE_UNKNOWN;
|       }

Considering the above, a suitable replacement is `strscpy` [2] due to
the fact that it guarantees NUL-termination on the destination buffer
without unnecessarily NUL-padding.

We can drop the manual NUL-byte assignment but should keep the newline
removal so newlines don't creep into the string.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: build-tested only.

Found with: $ rg "strncpy\("
---
 drivers/scsi/fcoe/fcoe_sysfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index e17957f8085c..7a3ca6cd3030 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -279,12 +279,10 @@ static ssize_t store_ctlr_mode(struct device *dev,
 	if (count > FCOE_MAX_MODENAME_LEN)
 		return -EINVAL;
 
-	strncpy(mode, buf, count);
+	strscpy(mode, buf, count);
 
 	if (mode[count - 1] == '\n')
 		mode[count - 1] = '\0';
-	else
-		mode[count] = '\0';
 
 	switch (ctlr->enabled) {
 	case FCOE_CTLR_ENABLED:

---
base-commit: d88520ad73b79e71e3ddf08de335b8520ae41c5c
change-id: 20231024-strncpy-drivers-scsi-fcoe-fcoe_sysfs-c-0e1dffe82855

Best regards,
--
Justin Stitt <justinstitt@google.com>

