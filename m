Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BD358AC3
	for <linux-scsi@vger.kernel.org>; Mon, 18 Mar 2024 21:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710797527; cv=none; b=cXvZAFGyUZpl/NYleyUEasZzJlIwpUMtKDOYvSlssz4MBuOYiABvAvAOqfUY001A4hyQyHkQrtzXkWzPLA9EcJSarv4qHCkI0InTY+3SGIZrQ/CsLqYrLW+J6dmpWnci3GnFDLIioDllSY1VYCvYM24XWSfiqHVxT/ACXrcIPB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710797527; c=relaxed/simple;
	bh=ucCmelMyvR8B8A4YhhLHaWy73dAoGtvG0I0P2JPd3j0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=q7cSR2j4HtJVyJmVXBhKIMte2zhDqFP/ChKoSvzAquMpHQEBQ+eGLSCqqefPpMZ5FUVmd2+pS+qaP8LiPYnhs/0PsxcUsi1U3w482Xq/idR2QF1ENCpwX9k9lkOj8FdhhOVyPWwLP9SnCHd0Vzs8zMuPlcltsVYHqBYkNkFtJao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y9hibkYd; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y9hibkYd"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc693399655so8697141276.1
        for <linux-scsi@vger.kernel.org>; Mon, 18 Mar 2024 14:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710797523; x=1711402323; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QGU+lR1DQdP6tUDzCuW1XO/1wByAXmJNEyDZZfUNtA8=;
        b=Y9hibkYdRK/UkswX6Q5t1ynlhtWNtojpaKP99LJHvzrrdccri4DRMydVrYARhlBZt4
         V+e/RfpfEsnYMeFBepA3n/M3SR+dNcCl3LybSM7jY0TgqmBwJqjXamteczdF0nJ04BrM
         +Di/5/f5V2JEIto0M0uUDXhJMUmDwDJO+Ui6OtZefRQohRhBQv1AQowur2OrC7BzeHGo
         +bo01MNw8P4GQzxPg6cjl+vT9LmMRDLYK77FBzW0LZjCoeMJAPS0ZVypnIluAgJIePLQ
         pRd/qPk0Vt69L1dHEGjR8XkNqdQpZhB60J62Ue1oCTqmXdMOKgYjZfjcg9ylUq3oSerO
         tvUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710797523; x=1711402323;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QGU+lR1DQdP6tUDzCuW1XO/1wByAXmJNEyDZZfUNtA8=;
        b=BvxGeo0AeIS2KXPZKhM+OEgC3CrQFYpsyhZkgLD85gtpTUQG+QVMQg8jUwQxafs2LS
         BFsmzTuHoVvR88Nm162E2it+HaxlYk6SxZKT3oPHrCIsOkLDv+efxwrOtrz0yGILBBMr
         CXIJqI1PXcgDuzDW7nkdVs8bE1AGHryOCOtdV4ZJbcc72x9kS6u0t1KHoZB07gr/73hl
         NcCehoPy26gryJl+JywG798Y9kaYdRpDfqg5NneBqJO22kK/waQszhxaSjL5GE5uTSeT
         b7gwr2F2iUmvKaFHFrMFi57lJieMRgjuErl+tmp+QbQyxI3IAuqRO2MnbIVIkQoRwOd6
         uM6A==
X-Gm-Message-State: AOJu0Yz+fAxUzv1E7v/ysTfctrTX0h5JPFMp9Obo2CLVHJoFutrGHkvf
	bG3dZ2tegGompWcHW5JyxRC3PkrrnvFUoqJMBxk8yLGzUz7qQ+VpogyIy9RUQsyryvlTf+yyKbi
	imsV+lmAQ7aa0B9zMXNk0zA==
X-Google-Smtp-Source: AGHT+IFF9ZVPbTZJCRAJN5ywjUYOtG5Avz/nf0ggwdYTo8nfoHH0biyCithjlhBYk7bRu5uYV2r/Gc+4wD5vJ8d5eQ==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6902:100a:b0:dd9:3143:577a with
 SMTP id w10-20020a056902100a00b00dd93143577amr86321ybt.0.1710797523740; Mon,
 18 Mar 2024 14:32:03 -0700 (PDT)
Date: Mon, 18 Mar 2024 21:32:01 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIANCy+GUC/y2NQQqDMBBFryKzdiCmtVSvIqXEOJPOJspMkBbx7
 g2lm/d5m/8OMFIhg7E5QGkXkzVX6doG4ivkRChLdfDOX92l69GK5rh9cFHZSQ1L0ETlP8+4KlV klsSGEXmm+83PPPQuQP3clFjev970OM8v/0hmjX8AAAA=
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1710797522; l=3305;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=ucCmelMyvR8B8A4YhhLHaWy73dAoGtvG0I0P2JPd3j0=; b=cxBzFAJknOPLMzKwp30JtiedqAp/exwKy/UHOrHkzoxhsyu7imVK6mW94Y8EnNjK9NUt7E/5+
 PMgMlQwNNcCBXXkS+Zelm+YA6MXLrjirE2R7Xap16oClMSlDcX7fJSq
X-Mailer: b4 0.12.3
Message-ID: <20240318-strncpy-drivers-target-target_core_configfs-c-v1-1-dc319e85fe45@google.com>
Subject: [PATCH] scsi: target: replace deprecated strncpy with strscpy
From: Justin Stitt <justinstitt@google.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

strncpy() is deprecated for use on NUL-terminated destination strings
[1] and as such we should prefer more robust and less ambiguous string
interfaces.

We expect db_root and db_root_stage to be NUL-terminated based on its
immediate use with pr_debug which expects a C-string argument (%s).
Moreover, it seems NUL-padding is not required.

Considering the above, a suitable replacement is `strscpy` [2] due to
the fact that it guarantees NUL-termination on the destination buffer
without unnecessarily NUL-padding.

Additionally, we should also change snprintf() to scnprintf().
`read_bytes` may be improperly assigned as snprintf() does NOT return
the number of bytes written into the destination buffer, rather it
returns the number of bytes that COULD have been written to that buffer
if it had ample space. Conversely, scnprintf() returns the actual number
of bytes written into the destination buffer (except the NUL-byte). This
essentially means the ``if (!read_bytes)`` was probably never a possible
branch.

After these changes, this code is more self-describing since it uses
string APIs that more accurately match the desired behavior.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: build-tested only.

Found with: $ rg "strncpy\("
---
 drivers/target/target_core_configfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c1fbcdd16182..d78647e4f6c5 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -123,7 +123,7 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 		goto unlock;
 	}
 
-	read_bytes = snprintf(db_root_stage, DB_ROOT_LEN, "%s", page);
+	read_bytes = scnprintf(db_root_stage, DB_ROOT_LEN, "%s", page);
 	if (!read_bytes)
 		goto unlock;
 
@@ -143,7 +143,7 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 	}
 	filp_close(fp, NULL);
 
-	strncpy(db_root, db_root_stage, read_bytes);
+	strscpy(db_root, db_root_stage, sizeof(db_root));
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 
 	r = read_bytes;
@@ -3651,7 +3651,7 @@ static void target_init_dbroot(void)
 {
 	struct file *fp;
 
-	snprintf(db_root_stage, DB_ROOT_LEN, DB_ROOT_PREFERRED);
+	scnprintf(db_root_stage, DB_ROOT_LEN, DB_ROOT_PREFERRED);
 	fp = filp_open(db_root_stage, O_RDONLY, 0);
 	if (IS_ERR(fp)) {
 		pr_err("db_root: cannot open: %s\n", db_root_stage);
@@ -3664,7 +3664,7 @@ static void target_init_dbroot(void)
 	}
 	filp_close(fp, NULL);
 
-	strncpy(db_root, db_root_stage, DB_ROOT_LEN);
+	strscpy(db_root, db_root_stage, sizeof(db_root));
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 }
 

---
base-commit: bf3a69c6861ff4dc7892d895c87074af7bc1c400
change-id: 20240315-strncpy-drivers-target-target_core_configfs-c-fbe862bf950a

Best regards,
--
Justin Stitt <justinstitt@google.com>

