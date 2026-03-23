Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0083B3BC675;
	Mon, 23 Mar 2026 17:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774285999; cv=none; b=AWVp2dMq7rnJaM+yXxxWT1Viv4z/qoFHW7RXz/7vIa1gFkqOYgfABlfBjGx43Kvocv7pOqAUMV1J1jtfOMC3UNBUaibjuXq+ZSgUrRANi/wm/qDoiLkpasWEFX1jb8GaxEQKH/yF+glKXPwVvT7nfhTHV8BEYRnLGeyywRgDwJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774285999; c=relaxed/simple;
	bh=1JjfQIefbX2x/ba5+AeqfI25QXPGtXLx4C3d3g3JSiE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RahBXSsBLIqh8aOalWCHey5LUa7qbeJSOdr3jPOLbVCkCSg2UILHP+qQY4FwXdg+AVNJGkz/jdxgfdMgdtaBMYR0/BJcyfynwIV9kwxW4md9g7MkjsyX2A8kZW+xZvmQjFKPVPS5BzIRuVETlBHIO+xXYzXtbmFJ2DEsHrwPJRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rGQHNF63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rGQHNF63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B503C4CEF7;
	Mon, 23 Mar 2026 17:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774285998;
	bh=1JjfQIefbX2x/ba5+AeqfI25QXPGtXLx4C3d3g3JSiE=;
	h=From:To:Cc:Subject:Date:From;
	b=rGQHNF63n7kvAEvkpxqJk8Wc5RpYvxFj9IXtfv2K9I/4kezqokyX1gKnqfXYYjysz
	 ijpA+07Cyh6NHX55z7MRHLBUEaOMxDEe6AERaKLzy4nlzuGzyJF/8S9418GBAf8LdB
	 K3TUxenhzO98TNxs1Wg89bBmpD3LCkQHRXXF8aT+ZWWc8gb5ZFZUXwhqkEvUzPixPP
	 0O+aXUkv0+qawWVJMQwfWa+GdFhrAsVEieYa7kt3qkkMTK2QFPHTlgU3s9mlB0FKI0
	 P4Uuhrr+02+j5FSO5Pd7PmETjMPL6vRwk9EnVRMLVfgGAOAPZM5Z/qROFsptgZAPdk
	 bOfftaj7+cdVw==
From: Kees Cook <kees@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: target: Replace strncpy() with strscpy() in VPD dump functions
Date: Mon, 23 Mar 2026 10:13:15 -0700
Message-Id: <20260323171311.work.101-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2203; i=kees@kernel.org; h=from:subject:message-id; bh=1JjfQIefbX2x/ba5+AeqfI25QXPGtXLx4C3d3g3JSiE=; b=owGbwMvMwCVmps19z/KJym7G02pJDJkHS1b/7d+ZHXA/YeWT3ZOlqj2lPS8XR+WeDxBJl/S7c XdTk6lURykLgxgXg6yYIkuQnXuci8fb9nD3uYowc1iZQIYwcHEKwETuX2L4K1zu3PB+tYfNd9lC uVm/rc5dcA/YYDbtXpJz9ZI7x3+Fr2X4XxXP2Cv6e+Xj9uTAvlNTTp/Zuy7z3qlDYZ1KzzLjH22 6ygwA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] strncpy() with strscpy() in
transport_dump_vpd_proto_id(), transport_dump_vpd_assoc(),
transport_dump_vpd_ident_type(), and transport_dump_vpd_ident().

All four functions follow the same pattern: a local
buf[VPD_TMP_BUF_SIZE] (254 bytes) is zeroed with memset(), populated
via sprintf()/snprintf() (always NUL-terminated), then conditionally
copied to p_buf with strncpy(). The p_buf destination is used as a
C string by all callers in target_core_configfs.c: strlen(buf) and
sprintf(page+len, "%s", buf) to build sysfs output.

NUL-padding is not required: callers in target_core_configfs.c
pre-zero p_buf with memset() or initializer before calling these
functions, and consume p_buf only as a NUL-terminated C string via
strlen() and "%s", never exposing trailing bytes.

No behavioral change: the source buf is always NUL-terminated and
shorter than VPD_TMP_BUF_SIZE, so strscpy() produces identical output.

Link: https://github.com/KSPP/linux/issues/90 [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
 drivers/target/target_core_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a7330c4fedde..a1b8f581185e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1112,7 +1112,7 @@ void transport_dump_vpd_proto_id(
 	}
 
 	if (p_buf)
-		strncpy(p_buf, buf, p_buf_len);
+		strscpy(p_buf, buf, p_buf_len);
 	else
 		pr_debug("%s", buf);
 }
@@ -1162,7 +1162,7 @@ int transport_dump_vpd_assoc(
 	}
 
 	if (p_buf)
-		strncpy(p_buf, buf, p_buf_len);
+		strscpy(p_buf, buf, p_buf_len);
 	else
 		pr_debug("%s", buf);
 
@@ -1222,7 +1222,7 @@ int transport_dump_vpd_ident_type(
 	if (p_buf) {
 		if (p_buf_len < strlen(buf)+1)
 			return -EINVAL;
-		strncpy(p_buf, buf, p_buf_len);
+		strscpy(p_buf, buf, p_buf_len);
 	} else {
 		pr_debug("%s", buf);
 	}
@@ -1276,7 +1276,7 @@ int transport_dump_vpd_ident(
 	}
 
 	if (p_buf)
-		strncpy(p_buf, buf, p_buf_len);
+		strscpy(p_buf, buf, p_buf_len);
 	else
 		pr_debug("%s", buf);
 
-- 
2.34.1

