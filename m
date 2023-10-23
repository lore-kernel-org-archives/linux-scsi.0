Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F299FC25B46
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 20:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjJWUUV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 16:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjJWUUS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 16:20:18 -0400
Received: from mail-oo1-xc4a.google.com (mail-oo1-xc4a.google.com [IPv6:2607:f8b0:4864:20::c4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250FBB3
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 13:20:16 -0700 (PDT)
Received: by mail-oo1-xc4a.google.com with SMTP id 006d021491bc7-581dc6915b5so5894406eaf.1
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 13:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698092415; x=1698697215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HC2YENnbBf3idqNUjad+LLWvlI/rBfsrY/3c0Jg2xIA=;
        b=IsgfIm2mc9Q+Tt9DydoqQ0cdfhOX9jeku/ZRH69WHJBzKa4KY6kyuhwihDbTXYbAJ/
         UkJkP5L4obeZQJVEAG9BVtK8JUs1uh6APJP3bjEwLktkhCkq45j+AyXzXYbVsN8+muYP
         J+EaVd+zYsRE+jWmYDQjJ5PA53eCGvQMUBUvgXjilkkr++2/CNHjdoltZY6YQU5kstn5
         ks92vNdzmToSdUhtDpGzNfyxlkfq1UPaqVUYJtuxM1Qlk9+kYgcnBdGLGgu59EDnsA2r
         MMxAIy3C0r+MPiexD02omEMVi0O9EzVAm2OxCjEj6w91Erm5cOW1DURALWdSHdye7tSb
         Qwww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698092415; x=1698697215;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HC2YENnbBf3idqNUjad+LLWvlI/rBfsrY/3c0Jg2xIA=;
        b=eJzj1nlj1XwkBYc6xsNEU6JPT7aov2oTAUbvn1BeD6Ij2QH85Ar2UWmBnbs/R60bkV
         xu5zKkV91sxDIm3ZJjyHjRZWW0dpHTaO8pkvbKoJTb7WVFnEm+/FX7UnWwqItLfWzKMd
         4x1W+EDHTkA3tSS1B8xsgF3QruEz3t4LcxQjXCmph5/hw9i2hYkvLghyv8xdDeu7oyet
         73n2yXtgT6x5n8ngqj1si2JTdFJ02dl1gemm7w211sVy/9S3om368o5EbDq9qRlR88Xc
         IfMXA0fC8UW6BWVb2x7fk0bJCjwOMPHHRPMLqrezgy23tNvL/FREAwmxESW4DGX8FXEc
         cXfw==
X-Gm-Message-State: AOJu0YzIzjTPrEv4y8xe0y7tZjwgN6qry7rDUZcBd0nSsCzGXcw+8iy9
        OcmIWwE5fwqtEPNUeeZv6DxehbN4ymrjtco8KA==
X-Google-Smtp-Source: AGHT+IH5IFKp3etRfm/SAzbR9yOQsUDxs6BH985hBKm3ShLIcpsgqParlvRl7HqmFgFcz+ULZw/IB2wls49btAYaVA==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6870:171d:b0:1e9:9202:20c2 with
 SMTP id h29-20020a056870171d00b001e9920220c2mr4686466oae.0.1698092415210;
 Mon, 23 Oct 2023 13:20:15 -0700 (PDT)
Date:   Mon, 23 Oct 2023 20:20:14 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAH3VNmUC/x2MsQ6DMAwFfwV5riWSMPErqEP64oKXENkVaoX4d
 6ION9xwd5KLqTjNw0kmh7rutUt4DIQt11VYS3eKY0yhw/6xivbjYnqIOTtcGRuDY3oFlIwpAdT 7ZvLW7/+9PK/rBviHA6drAAAA
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1698092414; l=2576;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=u26UkFA2pIT/4F5ARGnp0D+oEDN12dlRus5r6WZtCT8=; b=Ct6Uk8Ut9tGzpS3O6U9vzqDZRCJthZZmKeW5UgOFzxoK3M24GkZxicWT3gFJsfPzm9KZNClPv
 mwwAPCHwo5nCv/HfOtU+WtuThMSa6XqR6GQRXu4XZZcWh/6mHKr/yNm
X-Mailer: b4 0.12.3
Message-ID: <20231023-strncpy-drivers-scsi-ch-c-v1-1-dc67ba8075a3@google.com>
Subject: [PATCH] scsi: ch: replace deprecated strncpy with strscpy
From:   Justin Stitt <justinstitt@google.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
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

These labels get copied out to the user so lets make sure they are
NUL-terminated and NUL-padded.

vparams is already memset to 0 so we don't need to do any NUL-padding
(like what strncpy() is doing).

Considering the above, a suitable replacement is `strscpy` [2] due to
the fact that it guarantees NUL-termination on the destination buffer
without unnecessarily NUL-padding.

Let's also opt to use the more idiomatic strscpy() usage of:
(dest, src, sizeof(dest)) as this more closely ties the destination
buffer to the length.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: build-tested only.

Found with: $ rg "strncpy\("
---
 drivers/scsi/ch.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index cb0a399be1cc..2b864061e073 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -659,19 +659,23 @@ static long ch_ioctl(struct file *file,
 		memset(&vparams,0,sizeof(vparams));
 		if (ch->counts[CHET_V1]) {
 			vparams.cvp_n1  = ch->counts[CHET_V1];
-			strncpy(vparams.cvp_label1,vendor_labels[0],16);
+			strscpy(vparams.cvp_label1, vendor_labels[0],
+				sizeof(vparams.cvp_label1));
 		}
 		if (ch->counts[CHET_V2]) {
 			vparams.cvp_n2  = ch->counts[CHET_V2];
-			strncpy(vparams.cvp_label2,vendor_labels[1],16);
+			strscpy(vparams.cvp_label2, vendor_labels[1],
+				sizeof(vparams.cvp_label2));
 		}
 		if (ch->counts[CHET_V3]) {
 			vparams.cvp_n3  = ch->counts[CHET_V3];
-			strncpy(vparams.cvp_label3,vendor_labels[2],16);
+			strscpy(vparams.cvp_label3, vendor_labels[2],
+				sizeof(vparams.cvp_label3));
 		}
 		if (ch->counts[CHET_V4]) {
 			vparams.cvp_n4  = ch->counts[CHET_V4];
-			strncpy(vparams.cvp_label4,vendor_labels[3],16);
+			strscpy(vparams.cvp_label4, vendor_labels[3],
+				sizeof(vparams.cvp_label4));
 		}
 		if (copy_to_user(argp, &vparams, sizeof(vparams)))
 			return -EFAULT;

---
base-commit: 9c5d00cb7b6bbc5a7965d9ab7d223b5402d1f02c
change-id: 20231023-strncpy-drivers-scsi-ch-c-23b1cdac43cc

Best regards,
--
Justin Stitt <justinstitt@google.com>

