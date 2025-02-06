Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF3E214231;
	Thu,  6 Feb 2025 08:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738831753; cv=none; b=tRJdea6Te61v77Agw+yQM9oo0Gxs2FbMKSOjwej9NykEZZPsSqFK798jIm+K/VWO+XbMDGIsjbR+YTfWE1lXZgx2OeGeObrsZUuo0As9tlmE6sAUWpeMFdCb6D37C2itrv/msTZjhBgvApT/nAJQgLmU6PYGwJ7AC4LHrqiYp3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738831753; c=relaxed/simple;
	bh=djokZNGmgtaz0vzTbL/aVswcGa90JyNblLfQ9EqhcSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qZOhOHA0XTzw1OJYXgQf/ch7CA8mqSmUbX3C2iYPgmgEC1A6aNAO3UbDivrOmEwU8ck1C4DSUwugOvk3Vebn5V+EOgvPgNd5GHrsTLuE39UlhR58abNfm7QHVv0tEt7tC8bWos3A3GqiMF0JRUFm9E8u+dO0RtduRpbCJiSSCtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ghkMI+Gz; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ghkMI+Gz"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aa67ac42819so109686466b.0;
        Thu, 06 Feb 2025 00:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738831750; x=1739436550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SKAx3jydy4wjMbI2a4R9TlCTNosKD1QK8YL3qB51DRk=;
        b=ghkMI+GzeYiUP7TTU3B4t0xe2EsbWJdyyGwgZXqXmIfMd4nuznAIX3GsukBvXYynVS
         8dNogQn+o1XCdA/O+Xj6ZidQ/UCurF1PjyWJJ0Ts8efnswdM7AE0t36Pmzl+sjE338p4
         2Bj8sGH3rBCY60D+/0BGZp6HtmzAQ8vk1Ip2cx2OuOv40PF8q+2VdMOWocWAonmep62U
         7lhiL3IOqLdgGnH7WWL+u7b1HZnDeTXEO187L0OY/4LtMqbylG8N8s+XM34vRSKH/a/P
         grVpWbG8pVGQor95bFSdNf+7Zaj9nHPdlR2YqGD0PVgdxPSwH/o8+ZWE1mjgqXIoCx67
         7l5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738831750; x=1739436550;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SKAx3jydy4wjMbI2a4R9TlCTNosKD1QK8YL3qB51DRk=;
        b=p3hZqI0ECLd1D5MusVaz1sIQDV5BOX/+tz1KVSo4FcCqM4xbQ0CZZM0xAixQw6e/nd
         0cmIkTdIklb0mdQw3gAZmGrhOSBQt3XtXXWvovUaHTDmdd3v5BfqHk9CvPzappixkCwz
         OsjDus1i0FUM9/uE3o7R8Rb4PJN3jjQPdyPLoeIENMvbwRaJh0sHq6Cig3I3OblkNQik
         oU4FcrzwW8vB02+OAL71OGyrTkXD+/6f+vA/yEFQKTff2ZRLo9lGcdIIeH04dKNG3R8c
         tdKQLkJcANZnJJtsVNuo0kFo4D515YAlDW3I4nA3yQoa1ptg7sGVpm7ZzHOvWCdO9vna
         o0Xw==
X-Forwarded-Encrypted: i=1; AJvYcCUIOUbNPbYUZM7GgDUekslj+sc+lfzTvdXRVjQ2MPF0biq9q1T39IvsHkmgn1GyAANiGkIDTMsdkxLrXvP6VOA=@vger.kernel.org, AJvYcCWrWH2U6Z/gtQZ4OiZbl8i9HFzgaowoYrjqu+2GGr57qAWFdbLRbI3yH2aPNrkbLqlYRRBHHGS0lP+OmwqV@vger.kernel.org, AJvYcCXbSUZv2LXjG3+xCB/QZTB34jPxXgMQxHVHTDG1ux0IwpXp2/qF/4NiEjARQMG6qc4/1OkSVr4c1VBlFdD9@vger.kernel.org
X-Gm-Message-State: AOJu0YyXYMoWsfXPQ5Sp/QkW8fozVxaNDrqkLeAGMGJ8dRJXmwD4ybCL
	YdGN4Y4nyeOOCModbiF3N2Lt06PSroPr6E6YM2K6VYzbIWXh0Pw7
X-Gm-Gg: ASbGnct9EDa8y6pN1RUBvuIalm33o+abZs4tq8aNvN0tVzD94vfwS/cg3RfDfBpPpft
	lIrdAMmP4UtGdEjkVAsnkm80ltTsjrlXP/9jKj3kuiLY/2711t5CEWk8st4ntYX15vVI7wxVzDk
	F7Qdp+WFJc2soqRmE/ECNnOioODHoQOXztIlGIyxwniOamdmsxaJCkyiWlZv//GG603zEJ4+4P3
	p9498IZQCGHgPFkCC7qgne9pznQZ0xvzxNa32mqa7s6/CFsd2QG7hJfjpQz2KmNCwc0w7Jaz03B
	IhpVQgNPt064/zyk
X-Google-Smtp-Source: AGHT+IHCL0zJ4Hhe4qIoL2dTmRs+3VCBXGoVXtOtsBgfMa7rYlx7UwqoDmkIrR+uRl7F+mMffmUvqA==
X-Received: by 2002:a17:907:d88:b0:aa6:9176:61ed with SMTP id a640c23a62f3a-ab75e33cea1mr687924166b.48.1738831749750;
        Thu, 06 Feb 2025 00:49:09 -0800 (PST)
Received: from void.cudy.net ([46.210.137.151])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab772f49034sm65065766b.37.2025.02.06.00.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 00:49:09 -0800 (PST)
From: Andrew Kreimer <algonell@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Eric Biggers <ebiggers@google.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Andrew Kreimer <algonell@gmail.com>
Subject: [PATCH] scsi: target: iscsi: Fix typos
Date: Thu,  6 Feb 2025 10:47:03 +0200
Message-ID: <20250206084905.11327-1-algonell@gmail.com>
X-Mailer: git-send-email 2.48.1.220.gbc204b7427
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are some typos in comments/messages:
 - Nin -> Min
 - occuring -> occurring

Fix them via codespell.

Signed-off-by: Andrew Kreimer <algonell@gmail.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 16e3ded98c32..832588f21f91 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -212,7 +212,7 @@ int iscsi_target_check_login_request(
 
 	if ((login_req->max_version != login->version_max) ||
 	    (login_req->min_version != login->version_min)) {
-		pr_err("Login request changed Version Max/Nin"
+		pr_err("Login request changed Version Max/Min"
 			" unexpectedly to 0x%02x/0x%02x, protocol error\n",
 			login_req->max_version, login_req->min_version);
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
@@ -557,7 +557,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
 	 * before initial PDU processing in iscsi_target_start_negotiation()
 	 * has completed, go ahead and retry until it's cleared.
 	 *
-	 * Otherwise if the TCP connection drops while this is occuring,
+	 * Otherwise if the TCP connection drops while this is occurring,
 	 * iscsi_target_start_negotiation() will detect the failure, call
 	 * cancel_delayed_work_sync(&conn->login_work), and cleanup the
 	 * remaining iscsi connection resources from iscsi_np process context.
@@ -1050,7 +1050,7 @@ static int iscsi_target_do_login(struct iscsit_conn *conn, struct iscsi_login *l
 				/*
 				 * Check to make sure the TCP connection has not
 				 * dropped asynchronously while session reinstatement
-				 * was occuring in this kthread context, before
+				 * was occurring in this kthread context, before
 				 * transitioning to full feature phase operation.
 				 */
 				if (iscsi_target_sk_check_close(conn))
-- 
2.48.1.220.gbc204b7427

