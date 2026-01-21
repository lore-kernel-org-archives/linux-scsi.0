Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4EF364E9F
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2026 11:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768995953; cv=none; b=N6Rj1bULw/0r8KqNvUEhUTXCAk8tm3g3wc8uCeUdB555xuioLFit+pyjTppMr7i3h3QxXqX+xeax/tWZ5u3wTPNzV7ZuCVVh7qWvwzwJADY+ZNbegr1ECOxowzs12DyqeLbqTmFXy5BfB8udXBsjPxGkas1dbFTKJS6/6c8CQ0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768995953; c=relaxed/simple;
	bh=q0nXYUTVHL7oTpqvqvnHVC0mTJIX7qTvjAnt9fZmCbM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Br69t9UmoNCSiz1HoTtC73osNtvbp8cINdJHz0A/WSSRDwTSRnw/oiSobTeGvCYSTnRdjLunpuPBDAUyv+ZwzC7/pzjT8BZVo+sJwiRrmUTtYUXKqmc+/Qq9LWPw9VY/tGw1fw5h5nee0E4ZV6lEEQYfeq9UrOHxRrbgo6RYIYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b3g7+MjT; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b3g7+MjT"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a75a4a140eso10531085ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2026 03:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768995951; x=1769600751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BWo+ADtM0PepfwlVMNfkHCoJb3HNoaWfK0fd0LWDbx0=;
        b=b3g7+MjTT0r7X7FV1SjzBQjJzeUnFEtCzPcGem1QNh9qU9pVRM9fXtyzA1oj2/A5Xa
         q8NMzHsFQHjLs2jJjhOaD9eM6MJbO+zg+87r8e76L9hJpjrRKJuWn5IHKCEnE93kPHjH
         wGI3ZIXy5+M15s5WLVKRDdWv6wjbNBa4PYivJ0kC0mrwXkN+sldYPoukhgj/wBnFW5Kg
         cNqRo2XdIyzezoVCVm8kcSpLSX/DO01kiv+B3N4xGML8Tu/nR1DgARpAZ+OaElnOpt+x
         8JuaDntkdMwizzlnww5TdklCqPiJR9MRzQwOMZtSG7P3Ry8NzZplJUp6ktZ67gomFrW8
         3ZtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768995951; x=1769600751;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWo+ADtM0PepfwlVMNfkHCoJb3HNoaWfK0fd0LWDbx0=;
        b=SxR/X/GWBBgqZAOB5xPdRJFz+4e582oKG5OLsafpcTp6MAQe9hWrXrvXqNUQQbrAn0
         mqSKOAx5Ekk8+R2DtOQNmqEJMNZy8kUaDxk18E+1BcpEnnKO5AfSvOXs2QjtS+Ow8cOZ
         oEdRPr+u/al6GjlIRdN6aVhWokGGTxTFWMfUTqCp/V5zkl2vrvsK24nmaQ8xHDUCyPxH
         zCI134QMtdzZ1mzafy1IMxoSEq+sUOqJSOGyqhpUFV2DIMn/By7drUZ2XNK3GswPdhSE
         hoG2wk0RvhY5E9W2xkEBR3H6CdQ4q87DIb/xcT7/cIWmxUkV/22Kpi8c0pgdbWBLm9t5
         b1dQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJm5VCmoa67umvQ+RlOVRu/Tr+NKc2xibtGeZkhuragfdB8bihgjBNUvXmOu+44bLuhjPOwTlNMPLC@vger.kernel.org
X-Gm-Message-State: AOJu0YwQbC23ETbkZc8xtnSBhWGDG/V5mMmHFsLUox+9989JaygpWYk2
	RRWP3Tn3GTZAwK0ybBPDzCgBLg5S8WJ1M9VLf2Q3R0yrnx8G1O3GLVs=
X-Gm-Gg: AZuq6aKtMlXPh3RJOB6L0+USUfu/aNTUO0TF3+EimYDST5tHLUPIYivJiWzz0NkCXi3
	H+sgPr0rt/yTOGpjZg6vWzIxNo2LnQJYzAyF1lzmzatNRlJyYK2ZBHpvo+4/yFTLOWnfpX4t+DB
	c3zvj6EQ2Zi0btto98VpthFX67CvjKDFdph1RACBXGllBbD7xTA4qBYgaYpEGFEBnlVG0U17Esp
	QmbtX0KekWtooxV34ppBcX6RfzyFQMQgI6PzSWsS1WjZccNkcyFxFzUSgXue/laLmSVVxH04m8k
	iflsuGpgJi3BqlCRvPueWa6hjIZoSGCQF8xnyrNzWS8h6wr+JfFE5iGwY2+YurXTKQ8m2l3iA0c
	66RrhHHP1yUeJa85TRtYIkatG9MnzvhmeI+Z9KJFG2eU1UZ2lkUu8LXKlCyl3Ipt0QB0jFWzEyo
	No+mobeDZXwWUt5ko=
X-Received: by 2002:a17:902:f689:b0:2a0:a92c:2cb6 with SMTP id d9443c01a7336-2a76ad6bb37mr48689235ad.36.1768995951314;
        Wed, 21 Jan 2026 03:45:51 -0800 (PST)
Received: from DESKTOP-BKIPFGN ([38.76.140.13])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a76c5f4fb0sm47054085ad.45.2026.01.21.03.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 03:45:50 -0800 (PST)
From: Kery Qi <qikeyu2017@gmail.com>
To: bootc@bootc.net,
	martin.petersen@oracle.com
Cc: nab@linux-iscsi.org,
	stefanr@s5r6.in-berlin.de,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Kery Qi <qikeyu2017@gmail.com>
Subject: [PATCH] firewire: sbp-target: fix integer type overflow in sbp_make_tpg()
Date: Wed, 21 Jan 2026 19:45:15 +0800
Message-ID: <20260121114515.1829-2-qikeyu2017@gmail.com>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The code in sbp_make_tpg() limits "tpgt" to UINT_MAX but the data type
of "tpg->tport_tpgt" is u16. This causes a type truncation issue.

When a user creates a TPG via configfs mkdir, for example:

    mkdir /sys/kernel/config/target/sbp/<wwn>/tpgt_70000

The value 70000 passes the "tpgt > UINT_MAX" check since 70000 is far
less than 4294967295. However, when assigned to the u16 field
tpg->tport_tpgt, the value is silently truncated to 4464 (70000 &
0xFFFF). This causes the value the user specified to differ from what
is actually stored, leading to confusion and potential unexpected
behavior.

Fix this by changing the type of "tpgt" to u16 and using kstrtou16()
which will properly reject values outside the u16 range.

Fixes: a511ce3397803 ("sbp-target: Initial merge of firewire/ieee-1394 target mode support")
Signed-off-by: Kery Qi <qikeyu2017@gmail.com>
---
 drivers/target/sbp/sbp_target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 9f167ff8da7b..09120a538a40 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1960,12 +1960,12 @@ static struct se_portal_group *sbp_make_tpg(struct se_wwn *wwn,
 		container_of(wwn, struct sbp_tport, tport_wwn);
 
 	struct sbp_tpg *tpg;
-	unsigned long tpgt;
+	u16 tpgt;
 	int ret;
 
 	if (strstr(name, "tpgt_") != name)
 		return ERR_PTR(-EINVAL);
-	if (kstrtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)
+	if (kstrtou16(name + 5, 10, &tpgt))
 		return ERR_PTR(-EINVAL);
 
 	if (tport->tpg) {
-- 
2.34.1

