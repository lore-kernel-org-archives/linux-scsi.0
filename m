Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B6682897
	for <linux-scsi@vger.kernel.org>; Thu, 23 May 2024 22:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716502984; cv=none; b=DMmtgNy3YmM3WWIUGlShWYt8eqKzS3dEipPM6TI6MXEcX34EjR9rOIFEBc2PgZUtPHDkCUBftMwoWTbSRtTo3RyBEGHlsa0I+OQZGNHuIJRwk+tz/Zt6IH7on0dDP9a6uO7e/aqSyzCu6cl2Jp7nQ4pfiSkB5aB3EVpGJPoNlVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716502984; c=relaxed/simple;
	bh=Wz8KW3duQ4WBU6Er1SlH2sT7ipbBWfk/6Oc1CpmLOvc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TkztrUXUSCyH7qFoeKCpF3zmZrpEd/DCTfs0olEv+XTieID60rjBPDxDnKekfK5V3ABcsF2mFTEqnr9pYSIOCqgnbVsXQJbMz0dDgxxf1NAjpyIXE83DWssCaKSciTh6tiS+yWi96Qgt4WpTrVDeDfUL+f3B5yITillryr4qFF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=kCpJLD82; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kCpJLD82"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-68194ee2174so218141a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 23 May 2024 15:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1716502982; x=1717107782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NtQY0C2jnJJ8Poo2ZtD6lzIbsrEueMnclolCRbYe6sk=;
        b=kCpJLD82RdB5SQonctFRy+wCUQDa8IbkWFYNB5vjHZ2K+KZwBdDB9mbSkxui5haIgx
         a/OLYoIpEsSDcEGUZ/TVnRlX+3ibQcik6e1eMlsPMHVQI0PZCoQ4RiM1+WIBPKjwQ7oo
         95hvIkRqzLbIfmU3/g1S2zQIn4G9OwGpBrRkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716502982; x=1717107782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NtQY0C2jnJJ8Poo2ZtD6lzIbsrEueMnclolCRbYe6sk=;
        b=H1RvGwcsNp+RZlvg2UzTq7mUpl4gCKOQLRXB17NL8JzQGQSr9GWgDnvK8qqdfVd3GH
         8aMHs8hx86r/c7yhmJRjI3x9IQ7YAkzrqvwd0koppiQ9nobBb0onpFQgzwEL5p/nR0rS
         1WOYSqhH9es+i6n0ka/DPOlE4dkpMMS3sXYYMl+FSHZF7OAzYzIIfqS/3Sgm00PtWNUB
         J3HKUFbV0zPkH7Ik8sBYXJubtYY0iywH7Mhm3zbnKlilReIbMjXCzZPR7akxoNO7mPQU
         b2oGRdC2jispJHHEfayPE0lYsVYwrtRe1Hq30oT1eygyGXe7aCGsv/lAOY5eWTGK2imp
         QyrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmCe0qnEnCJ/6LGyXhs8hAvkyrmJ+mg+b1OPaXh+i+0hq9hHh5aSB0JvFKh6hwwg+UW5O6WCFPRxhvik2BdCzqMKfkDK6VmgMP1g==
X-Gm-Message-State: AOJu0Yx1/q3IRff5HjTHLIU9domMCxjJ9e4JX4a72FvxiAguLVPacnkJ
	efjTM6lr/8e1ZR98TRhcGGlbJU+4PG2Z4mvwV9viVWXV5oN1sisOLlIfXYv+lA==
X-Google-Smtp-Source: AGHT+IG9ROSwxnRhMnDBmI3dXR69CZhRLTfVfArFvBBcmmx+TLAD6gYG9PUjVbrfZXXUkbU3zvziPw==
X-Received: by 2002:a17:902:da87:b0:1ea:d979:d778 with SMTP id d9443c01a7336-1f4486bc798mr7645785ad.5.1716502982105;
        Thu, 23 May 2024 15:23:02 -0700 (PDT)
Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2a3:200:6f10:db2c:e2ea:44ad])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c7c59ebsm819125ad.105.2024.05.23.15.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 15:23:01 -0700 (PDT)
From: Khazhismel Kumykov <khazhy@chromium.org>
X-Google-Original-From: Khazhismel Kumykov <khazhy@google.com>
To: Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH v2 1/2] iscsi_tcp: do not bind sockets that already have extra callbacks
Date: Thu, 23 May 2024 15:21:27 -0700
Message-ID: <20240523222128.786137-1-khazhy@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This attempts to avoid a situation where a misbehaving iscsi daemon
passes a socket for a different iSCSI connection to BIND_CONN - which
would result in infinite recursion and stack overflow. This will
also prevent passing *other* sockets which had sk_user_data overridden,
but that wouldn't have been safe anyways - since we throw away that
pointer anyways. This does not cover all hypothetical scenarios where we
pass bad sockets to BIND_CONN.

This also papers over a different bug - we allow a daemon to call
BIND_CONN twice for the same connection - which would result in, at the
least, failing to uninitialize/teardown the previous socket, which will
be addressed separately.

Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
 drivers/scsi/iscsi_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 60688f18fac6..deb9252e02e6 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -725,7 +725,7 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	}
 
 	err = -EINVAL;
-	if (!sk_is_tcp(sock->sk))
+	if (!sk_is_tcp(sock->sk) || sock->sk->sk_user_data)
 		goto free_socket;
 
 	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
-- 
2.45.1.288.g0e0cd299f1-goog

