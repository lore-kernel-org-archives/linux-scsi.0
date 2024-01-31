Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6B817BD3
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726265; cv=none; b=SLsa2upMMEwltjySAwgMT5LC4kV+iYkCyzfHUHa3F6v8DlAxJ0z0L1V1iToodsTI20F3KXUKFOzTQN1lU5rl3Pw869n6GIs69s/Aje3VsvHAvWwXUqZJnD11Fjy3jrFTVDl4hyHphQEdisWMh5qFr8pKabGWJOr/Ht34bhz6DVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726265; c=relaxed/simple;
	bh=PEBRgy3U8le0rU1YUtzuqdU4UbSrGVwJNBwWY9qNTQc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wr7a4nT5YlbdtbjP30TZkDa81QXOGknEOwq8H3qgZCpOG+PmQ25+70h3Xvst1BVEKRVvxGS0b8wpQKGS/5dQojkBAea8lUMsrslQ59Q3xxmAZzoufSVgD/Fyn4bAhgEsfh6YrtHHjRLw4tV9JSZ9n87VZDu1JjsMxMpASvbfaMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jq9veaJH; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jq9veaJH"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-68155fca099so206416d6.1
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726263; x=1707331063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LAqUwWvKuTXPsVxKyqp8DHVvLG+80LqrXU5iD5oilK0=;
        b=Jq9veaJHDU65RYZePqZC3JxTOvm2zEOZw9JINns78JxlON+7Cv4cNYDUSZm2YycTW1
         BJ057qpbm0MaRkMrQQ+eLANvVuHdNOmvz2tWWJCgpAstSRSGQl9C/Gz2st4dV07MGjKz
         cf1uVWVLugSYdWvv2DFhEM0JoRCsZB1q4HNs9Gub8a4W5Y/uyijNTwvz5O9yXVkDyznt
         1B4KFVA3ay+WJr1FjjCNPPywQ8Xz7FUSHn+kdGs0KvFWTPUvNWXORoAbg33b8oL12pSi
         pdY7qSJHf+ty1iLCj0XOENJpOg/o80gRLs9Z2AGD3dpisBBrJnswIC6W7cnv/VUzFwxK
         sh2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726263; x=1707331063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LAqUwWvKuTXPsVxKyqp8DHVvLG+80LqrXU5iD5oilK0=;
        b=bhutqHJiPxO8BfgBbK2sI9v6mLJZCv94FXRZAi+ILzepDhhUn6XFz4ekjmdaE4lNKd
         NGRdleDZOMhCy//ozR1FDKFW17AaZp2sWAozAoZD9zHMDTU+8FjhaNnWNL89BpfFIpLg
         dWGjp7Es8ETMNykX9Lefty1iqrZh+OPwEe6qFMquzOo7FxGwwXHgy8lIhkHbFwaM7WUj
         2jUqku8bphj+XDUeW33C//dGZqdLoRU/KlhwFYuw0RIGjcMt6clzYycnDAmU6Ywq1vJZ
         QfxjIo3/KGHTc4O4OP4vJqc+GbHVnnceV2oWT3MFErdOnBylGI7Tyb56a1TRsLiLcuLP
         +xwQ==
X-Gm-Message-State: AOJu0Yz6EH4jaJpaiDQwsEryxIW5lajiV2ZP/xqq0HPZUHyt+phvJKEw
	Nk26Ou3l3diUOrvUHRofvXm4hfFG6DuQqIy9nFbfsxcjrrrkswwpFI7eHYWf
X-Google-Smtp-Source: AGHT+IG9/Za9Q8/ce6OKJMT0TC0RBgcXYsfEEJgPCfxM2z2htai35HN2oQEwAka0RaSApzvlb/J5Yg==
X-Received: by 2002:ad4:58aa:0:b0:68c:4db6:3423 with SMTP id ea10-20020ad458aa000000b0068c4db63423mr197215qvb.3.1706726262853;
        Wed, 31 Jan 2024 10:37:42 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:42 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 16/17] lpfc: Update lpfc version to 14.4.0.0
Date: Wed, 31 Jan 2024 10:51:11 -0800
Message-Id: <20240131185112.149731-17-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131185112.149731-1-justintee8345@gmail.com>
References: <20240131185112.149731-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.0

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index aba1c1cee8c4..573c9721ea0a 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.17"
+#define LPFC_DRIVER_VERSION "14.4.0.0"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

