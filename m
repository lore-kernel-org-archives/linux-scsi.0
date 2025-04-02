Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1446219E826;
	Wed,  2 Apr 2025 20:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743626793; cv=none; b=Ln6pNlshLTiM6+iiG/+FgnF1OiSoMQDCjpByVu07Xz9yb98LNb6Gp6EdMMh5VjTY8aXA2PkI17XnUM95ACTSkwWlg7fIV7FB9d7r4rxjUrYCiD3qUEDxA4kUwY1nR2OVPZHolrrcCpWjLngCQLZQVJ5VTh6hbNU6oh8AEI8eCrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743626793; c=relaxed/simple;
	bh=TM/cjw8nSDv8ihYQl/9y04h6oXeIK8tcY6ShdqhfNEo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EaOfNUtK7Wf2gd6DXZ0LUSyjkKA+8PJdtj5m8Q8A5JzF5oFpr8SpJFuiGrJ2pxqMUOGIjto6Dx5MY2yUCJW7s+zZ9obpnlZefTCsv+Iy+SIsuyD18+ylbYCzKuMzgms1EzWUpAZTe5qKofpeaF6Etkqwdrw7TAujeIUTczKatvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KkO/Jw2J; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KkO/Jw2J"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43cf848528aso1150285e9.2;
        Wed, 02 Apr 2025 13:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743626790; x=1744231590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3DTwK5q9mc4wz5gH+Pp3KkIddp0zv+fxCMOX/651n4c=;
        b=KkO/Jw2JIE7c3dQIfPszfUZ5v8eKHkVqqhZ4LZU3SzYfbz3MydTkZnRdAykXwOBI1h
         y3RpcXturH60ZEtl1MZIKvFF/OWjh193PXY3j9npZbLdxh5UcEq4mhdSPqBxokzQR9b3
         hwYKjitWp2jNXVrQFXixAHjBJnvk1gn5pDKKa5HvgnyCOsm9br4/5YThvB2CdMyVlvfh
         OY+daJ9cgv6wbwz/cz4JVkXFNIV0y9y3mCBG0ke3AcrPxypT+ECNHDlz5FsVdLGp036X
         8lOpvUxvq1MXGGxXt8huAPv7xQXM36Y51Cw/x0UjUDdBPRsU1UcrGSRUqyCyTP8iqptL
         2UOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743626790; x=1744231590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3DTwK5q9mc4wz5gH+Pp3KkIddp0zv+fxCMOX/651n4c=;
        b=BQVcyCDj4KLaSZLSfBW3Qmy1b63QGnAjUqemCGDWGMTmqJwK0rCWch6BnCm2TXAyd0
         OBUZGUWhKneDcCZt9b6vC5RUbUWyouQ+GZ80MvxWu+CTVUStbIPx4dfwgGgJdFjzLwc3
         umQw6IEbjZis08NQfr84hqWeiUJEdSWZ77LwS4eZBGRbNWtjhBlgDlX5ChzVRGXh9TTn
         bKk2kbKHK17e4PEMZRhkNY2yX1pA6c//jbjfugSzjYjGvm8MiurvTdzN1oerSEUhH5As
         qE3vWHf/Ouh98G1sQW009gyQmc9redyEOGqOvycqS6vSdQvdOUAV0chlRvzuwNFAp5sF
         CTng==
X-Forwarded-Encrypted: i=1; AJvYcCUqacvA+extQ3vfHgmm07S4NMyrY5VbytBpA/p45viwOKTj3TiA9cmQCAQetdviXJMrmx/Gy3fPexip3Qfu@vger.kernel.org, AJvYcCWcjkawSkdbwELaDqQXiLLJ6YKcP4ovo0fcHUeeHyd8N93YOOzuueQaL3fUfuZlKvnRJxxqHKK4UTJaodU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzpFeJ3B/LJTklxRhUj83PWH96AtIiReKjVCQctbySHCnBYy5n
	x+o+daWDLuAI8Dh7WJrCGO7Qv+25cWZhRvOGL5F/sEJGE/+50DnH
X-Gm-Gg: ASbGncu3271cGpzVl7y6U78wxPhQ/DgeQY3PV21yHJYzbn0C5QSJ8F8Sj/kppcSaYLt
	L+tlLtUE/TNygElfj7y0a/God2e8BYMteSlLxwk/B6yb47B6wEQswADkIMn/pLLrDP/dyqO5lsU
	p8c5khtyNxBjWRPpgcgBLf2kPlHjhr/ZD97U0TvXJ9DFzZJg+VQ4deddTYjW+i5U4Cv6IK6pUAY
	MGFk9EHwSkdo1CzWw4hN2XgTb0e6MgtJT3Ji3LkTIc/4gbo8EyjOVjRAxNw/2h3t6VoEVDgI7YJ
	QULZlDMEDql0Ud2rm/riEA2SEtgenRkjpa0fAdB362/Pk+3euOHXVjkS02Y=
X-Google-Smtp-Source: AGHT+IGc5EgnYI0nU9SzcptgdoJNo7uglRlaGotleG5vWRU1VAiUz7nCM+VvX8q4LjzKe+XhIGKzaw==
X-Received: by 2002:a05:6000:186e:b0:39c:1404:3748 with SMTP id ffacd0b85a97d-39c29752ddcmr3791945f8f.16.1743626790306;
        Wed, 02 Apr 2025 13:46:30 -0700 (PDT)
Received: from localhost.localdomain ([78.170.183.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b79e097sm17649906f8f.80.2025.04.02.13.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 13:46:29 -0700 (PDT)
From: Baris Can Goral <goralbaris@gmail.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	Baris Can Goral <goralbaris@gmail.com>
Subject: [PATCH v3] transform strncpy into strscpy
Date: Wed,  2 Apr 2025 23:45:55 +0300
Message-Id: <20250402204554.205560-1-goralbaris@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250402201106.199362-1-goralbaris@gmail.com>
References: <20250402201106.199362-1-goralbaris@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Description:
The strncpy() function is actively dangerous to use since it may not 
NULL-terminate the destination string,resulting in potential memory 
content exposures, unbounded reads, or crashes.

Link:https://github.com/KSPP/linux/issues/90
Signed-off-by: Baris Can Goral <goralbaris@gmail.com>
---
Changes from v3:
	-Description added
	-User name corrected
	-formatting issues.
 drivers/target/target_core_configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c40217f44b1b..5c0b74e76be2 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -143,7 +143,7 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 	}
 	filp_close(fp, NULL);
 
-	strncpy(db_root, db_root_stage, read_bytes);
+	strscpy(db_root, db_root_stage, read_bytes);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 
 	r = read_bytes;
@@ -3664,7 +3664,7 @@ static void target_init_dbroot(void)
 	}
 	filp_close(fp, NULL);
 
-	strncpy(db_root, db_root_stage, DB_ROOT_LEN);
+	strscpy(db_root, db_root_stage, DB_ROOT_LEN);
 	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
 }
 
-- 
2.34.1

