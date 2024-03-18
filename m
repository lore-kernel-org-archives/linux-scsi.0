Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FF357865
	for <linux-scsi@vger.kernel.org>; Mon, 18 Mar 2024 19:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710791420; cv=none; b=sKHlhSwZqMnuUFndRN/m7MCLrPWm8A2aNYnAj7cHT2uDmcGuodPV51ulwgNnZp4bjXBfcORrb3OuVoTYSYPWJh2XHylPfFnKXcBaZwtl3lKeU8gmY00h0VCouvSkk0ads8Zvp6bgF16oKWphz5t/B5jN09sYJATxTbgmrFIl/wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710791420; c=relaxed/simple;
	bh=KZ3rIV5HMKqyM/bNYA6ICEqFK4FA1/+/ftfgAoqZXqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUfinkxQf5EjAI+Ec6f9cFurgNOJOLMb+XcDVDoHRye2UI8vKfasRalgkW6SDfjWyC30oXgbu7/No4PmG7XAiIQan0NRKHj5Jt+pirBwzVJLQ+BL2TpFjK9vLURL71/5GHWnSLD4VM6Ss5W+ZEUzSvs6JidsGR7TaLO4XzBUUPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=kCCzlCrM; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kCCzlCrM"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dee5ef2a7bso31272055ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 18 Mar 2024 12:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1710791418; x=1711396218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zC1qwydc9xH+y2vdl2+XzzOC/d+jLN+PsRUWImtjlRY=;
        b=kCCzlCrMkngQZmLTnbmxT1k3erbm3ZoRwY7dgZGHhF/thIF12hyhj0jZgGLf5Pi174
         p2yUFodtX9LTr1u4cDNolJk2H/PkLXBh7/ULIRWBgJu/5EYn8NemJT00NJR8kT7Idd+C
         LU4jLJcVeIo125iPz1Kj7BrD/9hzuejZslDlE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710791418; x=1711396218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zC1qwydc9xH+y2vdl2+XzzOC/d+jLN+PsRUWImtjlRY=;
        b=oE2Ea4pM9V6TptPg7B4vgmDziYm+BXyy4M7ipgr6QZF3Lktu+ApMIEekNsguP3CO5A
         RlTOauUX1C4rkLDZA7cE6lXFyLV0redFlCNYd4P94+Vm2b9YnLSwf5kfCMSnRLWUtvBP
         ArGZ3L0veL2nVdxIxF2RETLiB2ceojtC5JbrOV6NKR9yjI+HluVLx6/6uzkfoiZzrLU8
         Dg+mOj37kjXEJOuuNL1v+z0Yx2I1pcmgU4jHY6E7kcgz7o4+JLIQHeuzWD1BjJ9Tb/mp
         chV6FpmbB7lA5bzEt40ZQN8Jsmi9+MwtXLBJXJMdI4s0c0PvHAhcRoLZAFs8OwCHBfx2
         Bt5Q==
X-Forwarded-Encrypted: i=1; AJvYcCV629ke4ruitwp9cOTyEpDQjoQuKRXv2+Ut7lubVHI63ZLgTLrSLAZoLE5VKoDT2EzxCMN8x2LXfKvFhfeNqE+QHykYyMOr0+22Lg==
X-Gm-Message-State: AOJu0YxJeug3LehuGHFLu+m9nSEVna43Z+wCmCfJMyl4U7Q6FFq4vvs4
	Vd3pz+ydXPR9WphhvVKMU5E95FjHIGlKFKSDv8F5yeuJKrNxXPLA7HA4zw+c7Q==
X-Google-Smtp-Source: AGHT+IG8+lPsfxHZ+zVWOGguTuaZgsiUp2vtqHikGI8aqsjtFgNyHq71mM9ZLiwKKhCawCorAmOYww==
X-Received: by 2002:a17:902:e5c2:b0:1de:e026:1b8e with SMTP id u2-20020a170902e5c200b001dee0261b8emr16615202plf.41.1710791418685;
        Mon, 18 Mar 2024 12:50:18 -0700 (PDT)
Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2a3:200:5620:6f64:dfac:61dc])
        by smtp.gmail.com with ESMTPSA id k4-20020a170902c40400b001defa98b03fsm6476916plk.101.2024.03.18.12.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 12:50:18 -0700 (PDT)
From: Khazhismel Kumykov <khazhy@chromium.org>
X-Google-Original-From: Khazhismel Kumykov <khazhy@google.com>
To: Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"James E . J . Bottomley" <jejb@linux.ibm.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH 2/2] iscsi_tcp: disallow binding the same connection twice
Date: Mon, 18 Mar 2024 12:49:02 -0700
Message-ID: <20240318194902.3290795-2-khazhy@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
In-Reply-To: <20240318194902.3290795-1-khazhy@google.com>
References: <20240318194902.3290795-1-khazhy@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iscsi_sw_tcp_conn_bind does not check or cleanup previously bound
sockets, nor should we allow binding the same connection twice.

Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
---
 drivers/scsi/iscsi_tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index e8ed60b777c6..8cf5dc203a82 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -716,6 +716,9 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	struct socket *sock;
 	int err;
 
+	if (tcp_sw_conn->sock)
+		return -EINVAL;
+
 	/* lookup for existing socket */
 	sock = sockfd_lookup((int)transport_eph, &err);
 	if (!sock) {
-- 
2.44.0.291.gc1ea87d7ee-goog

