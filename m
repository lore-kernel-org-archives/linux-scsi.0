Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE27915350B;
	Thu,  5 Sep 2024 17:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725557987; cv=none; b=DZdB7sfrcAFp6ZqWLGMLt6GkIJIiCaAKSPsIWxjYVWgsjDBqa4i9iPSZ4/5RkDE2aHbr/znqlgQpvvQT5uGJiRyATu97xZ/Nc5ul5x0RLf/v5qcNxamqnDg//nfGsNsCSkleT1Wm1I5bvs7HkhT+V953rTwgl39neLtsis8Msi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725557987; c=relaxed/simple;
	bh=37oiG3AbwyNHwcHrBMnvG35mb56dT541pCwusFJfyMg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=n81Gzlj5JicCgnt5w8mAqrky/RU3wmnFiQUt9Y0+ThtosCZhmiqF2pgIxWtJEpCdeKn5s3wp357Fu7WdHTDQIww36bgjggfgE6C4j7748lI0XLNLJzB8UJrwot5irX84qhrCK3h7eAJCxCAtYaegEm9ZnapyXMn7ATGKZX8H9Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bH2KbSIx; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bH2KbSIx"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7a8130906faso75642485a.0;
        Thu, 05 Sep 2024 10:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725557985; x=1726162785; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sPod5tsM4FBK0w4NizYACzcGUEXMxJcxjIBWmyw5Z38=;
        b=bH2KbSIxnxcQNCjHHAZvMGEQDFLHtJz9alsYXexclqVzjqjl9iNUrptKB5OrQ/gH2M
         2Pz9Atz09vu6ZcVWzmjSK8Jcu2OurRBJPDdhujtAmcKfxF8gdvsNNJcBgrsl+xYjLzmA
         /xiSRufBcuUbtenq1BgGeuZslQMvs1u6C0/3258jWObuLojLV2nfQx62w6PQd7mYpEeK
         124z2KjitzjH+U26cSRCzq/f1ZKXczNgTk9JZpVzadc3ZK7JQolDJx01ytD5oc5/7IiY
         9cYjlKFJ8jpkgSXFdHf/6LtZfgdsY1sfmBxTgXugaE/sH5JyXgdWjUiAX76opzCczA9Y
         k/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725557985; x=1726162785;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sPod5tsM4FBK0w4NizYACzcGUEXMxJcxjIBWmyw5Z38=;
        b=uMbPFOtxc5zJtk9ocDM3yjFKKxa3+JY2tBE7SJ0oH71wnfVGQ6oibsSyCLtoTCUqXZ
         1JjqiVzuNUG0F92vgOI4IaBS+Go5Va1ed8h/dMtZEm6JguTwsLd6dYagLHYy+bw+hbOD
         KOT1Jg8FoFEpqUhdo+UORiY8dDq+LRCE+oKv8lwhyyJXXemTtbVfYZWVKq5D77JlbvjV
         dNFcVG3y92sy+QUadyWdSgjmHqh1AdSD/cloqvQ9AFuy04zPRflMVM9Sd+cduAuoE4GX
         3u0muCsjjFFtgWAweYSWj4VzWqtf/9cGpmLjchIgYRzjbgG+YAztLN/tGAxvx0WjGjsk
         boFQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2KqARKbOu6N5rC3YllTOc1cs5qhWr0PaXIwWwktxQIslV+vbPbdM8K+PeAyb9hMWbEobl/2OJfTOhNvI=@vger.kernel.org, AJvYcCXOH6EHobo/Kk6ZNoMBSH0V6fnnEQnPJKt2udEjcuKIMNpKqV2tGjTqAOB0m6E/6y3AFGC6Q2AaoAYWEw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5zSdxAD+TewoyYkT444LFRuAMJ2r9zFYjzXN+PvQL9Wn4eETl
	MrgBtkEHpobz5+Z5f5Hmmuf36bPexpz4HlsddqukkNjALXV/JJFh
X-Google-Smtp-Source: AGHT+IH5Ve569+blJ4MKxxKSJZBn4INlOwRxM0yAxVWjVr1/8vJ7Prk/6DqYNf5jof8DqL2pA0dOZg==
X-Received: by 2002:a05:620a:2981:b0:79f:fe8:5fce with SMTP id af79cd13be357-7a8a3dfd6b5mr2050421785a.3.1725557984616;
        Thu, 05 Sep 2024 10:39:44 -0700 (PDT)
Received: from MAC-146400.dhcp.fnal.gov (mac-146400.dhcp.fnal.gov. [131.225.76.73])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a98ef25263sm93089185a.20.2024.09.05.10.39.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 05 Sep 2024 10:39:44 -0700 (PDT)
From: Rafael Rocha <vidurri@gmail.com>
X-Google-Original-From: Rafael Rocha <rrochavi@fnal.gov>
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rrochavi@fnal.gov
Subject: [PATCH] scsi: st: Fix input/output error on empty drive reset
Date: Thu,  5 Sep 2024 12:39:21 -0500
Message-Id: <20240905173921.10944-1-rrochavi@fnal.gov>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A previous change was introduced to prevent data loss during a power-on reset
when a tape is present inside the drive. This change set the "pos_unknown" flag
to true to avoid operations that could compromise data by performing actions
from an untracked position. The relevant commit is:

Commit: 9604eea5bd3ae1fa3c098294f4fc29ad687141ea
Subject: scsi: st: Add third-party power-on reset handling

As a consequence of this change, a new issue has surfaced: the driver now
returns an "Input/output error" even for empty drives when the drive, host, or
bus is reset. This issue stems from the "flush_buffer" function, which first
checks whether the "pos_unknown" flag is set. If the flag is set, the user will
encounter an "Input/output error" until the tape position is known again. This
behavior differs from the previous implementation, where empty drives were not
affected at system start up time, allowing tape software to send commands to
the driver to retrieve the drive's status and other information.

The current behavior prioritizes the "pos_unknown" flag over the "ST_NO_TAPE"
status, leading to issues for software that detects drives during system
startup. This software will receive an "Input/output error" until a tape is
loaded and its position is known.

To resolve this, the "ST_NO_TAPE" status should take priority when the drive is
empty, allowing communication with the drive following a power-on reset. At the
same time, the change should continue to protect data by maintaining the
"pos_unknown" flag when the drive contains a tape and its position is unknown.

Signed-off-by: Rafael Rocha <rrochavi@fnal.gov>
---
 drivers/scsi/st.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 0d8ce1a92168..be881d5bac05 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -834,6 +834,9 @@ static int flush_buffer(struct scsi_tape *STp, int seek_next)
 	int backspace, result;
 	struct st_partstat *STps;
 
+        if (STp->ready != ST_READY)
+                return 0;
+
 	/*
 	 * If there was a bus reset, block further access
 	 * to this device.
@@ -841,8 +844,6 @@ static int flush_buffer(struct scsi_tape *STp, int seek_next)
 	if (STp->pos_unknown)
 		return (-EIO);
 
-	if (STp->ready != ST_READY)
-		return 0;
 	STps = &(STp->ps[STp->partition]);
 	if (STps->rw == ST_WRITING)	/* Writing */
 		return st_flush_write_buffer(STp);
-- 
2.39.3 (Apple Git-146)

