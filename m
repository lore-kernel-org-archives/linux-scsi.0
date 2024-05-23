Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FA012838D
	for <linux-scsi@vger.kernel.org>; Thu, 23 May 2024 22:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716502987; cv=none; b=MzTy7t0WTVcx5LemNNDidUN/5xNPUZ+YPOSxdhxNoku5QDl40jL6aKG46/vjpFrrs7hMGsOLM/iX5E8DbDnbK6moZiJ51XDpDBe4OEsIhnsS213A9WWFGpeAD+/THe2bJecWpebsArwtuA6rn1Vy/T9Wt4+mh48W/A8kpalxXwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716502987; c=relaxed/simple;
	bh=Yw893T+VjD34w4x4yV0pVt0ig1FaascDQOJmlsUUHNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAT2hIMVL7R9Jf1LvyhMkpbhYg98+WAKDj9cgcAVkH+/3eTo4L5yvON3vSpOMh9mVkhIti+KMUj1m4j79l9y4eq8dB2B0+aDd43tfx0qmBswIaTmx6exKlOUf8YG4+FrJU1WiMV7wTKYYyU5QoqvYoCF8MoMbDb5+n6eMesJIY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=aPZhhoXs; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aPZhhoXs"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1f44b45d6abso1708645ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 May 2024 15:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1716502985; x=1717107785; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7hlo/0USYgm45RKgbQV7mEAT0VdxfPiKQOpjReznKyw=;
        b=aPZhhoXsm0SxwtGla0KDtTur4S6A2NK90ijrFgZkvz3iafftzIyCxlUt+A9k/z/oSs
         NaDMSx+MJVE4zs7x5KAt5bj1BQE1Hz2WoPiCMa05Tw0/4k69LXeMwIsUUd/QkSG6i6s2
         jcoRHWjnZWAectaHvKKggBFQmfIwNpDgpGy1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716502985; x=1717107785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7hlo/0USYgm45RKgbQV7mEAT0VdxfPiKQOpjReznKyw=;
        b=vkgp6IPJng2FkuDcLcCyHS2LAwk26sdNVXOtcleScVnOaGIFmbBT5UD1nkmSmAZbCd
         CYdjulS7dODYKrJqIQdqsr32a9n33b2see1kWzXO5TwQjytFLv8CYHYLFf3hATBk1K5S
         JV93BYj3M4lb5HY4mPzIkFoxyCbHRG1jXXQGveOuF3NPvjD2NpboeM0B2fhZdsQlKNrC
         x34tc4hGhEAfNRsSg9utOz2E44aq1VukBsjsRWprZfpltlKWyNSLDqq/upkB+GVfZU3P
         QBuGJWmpCFbhI6oBokU+/Xemy5jZkb7FF+GIuimttxT/qGtVhvZjONyj7gPMRGvob+v6
         ooiA==
X-Forwarded-Encrypted: i=1; AJvYcCVrEmLU+XhN1tpuOibSb7Cm6sY6Nvp7zvF/OJPqVpe16EwtThS29SJebbrrPQQoBRq4ueY6W/4mpFng//CqjiBIf8WiMNDHoLqyxQ==
X-Gm-Message-State: AOJu0YzTyLdwciCiv6MRJXr871yDzYuKb88kMOxiuCcG/eRe47/y8T24
	jRIhduCpvNEO6+a4RbzvOwQLN12Sl9rUEGbdeMUoRv8YbHtdyah+g9wJevS3Zw==
X-Google-Smtp-Source: AGHT+IGgIlNycjUsworvnOTSYRhzHICvSHqnm+Q8HMxMdqvYn9kNEPLpT7lzSpNUJI8vxu3lm8gSKQ==
X-Received: by 2002:a17:902:ea11:b0:1f3:4d44:7000 with SMTP id d9443c01a7336-1f448a36c0amr6257655ad.41.1716502985499;
        Thu, 23 May 2024 15:23:05 -0700 (PDT)
Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2a3:200:6f10:db2c:e2ea:44ad])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c7c59ebsm819125ad.105.2024.05.23.15.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 15:23:05 -0700 (PDT)
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
Subject: [PATCH v2 2/2] libiscsi: disallow binding an already-bound connection
Date: Thu, 23 May 2024 15:21:28 -0700
Message-ID: <20240523222128.786137-2-khazhy@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
In-Reply-To: <20240523222128.786137-1-khazhy@google.com>
References: <20240523222128.786137-1-khazhy@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This fixes issue where misbehaving userspace initiator could bind the
same connection multiple times, which would leak the old connection
socket without cleaning it up.

For iscsi_tcp, it calls iscsi_suspend_tx directly in stop_conn. Update
this to iscsi_conn_unbind, which matches the lifecycle of other drivers,
and clears the CONN_FLAG_BOUND.

Suggested-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
 drivers/scsi/iscsi_tcp.c | 2 +-
 drivers/scsi/libiscsi.c  | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index deb9252e02e6..1d93404515ae 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -696,7 +696,7 @@ static void iscsi_sw_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	wake_up_interruptible(sk_sleep(sock->sk));
 
 	/* stop xmit side */
-	iscsi_suspend_tx(conn);
+	iscsi_conn_unbind(cls_conn, true);
 
 	/* stop recv side and release socket */
 	iscsi_sw_tcp_release_conn(conn);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0fda8905eabd..0fb98eb53584 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3453,6 +3453,12 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct iscsi_conn *conn = cls_conn->dd_data;
 
 	spin_lock_bh(&session->frwd_lock);
+	if (test_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags)) {
+		spin_unlock_bh(&session->frwd_lock);
+		return -EBUSY;
+	}
+
+
 	if (is_leading)
 		session->leadconn = conn;
 
-- 
2.45.1.288.g0e0cd299f1-goog

