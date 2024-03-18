Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B27D56776
	for <linux-scsi@vger.kernel.org>; Mon, 18 Mar 2024 19:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710791405; cv=none; b=fRrMJUCK2+ct9oIoAa4TKe1huOHP/5KDevotjxvwbZx2zldMsfRckGtyTr4QFI6iJ0pZb5MZJGH9sbN3kgpayZw0YZvB4JsYi7UGjQmVPC9mcTT58UPxj6TmZ22TNl1Y7ylrIJcnqWl+7LMBRIdSJfpcjFzxs3HAuh1/80d5A+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710791405; c=relaxed/simple;
	bh=nbS5LGN2ouWURiMV3g1XD5IvjDaRV44oVY5u9CjawzI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EdZWeo6Yxn8z28yVI8R4YAaHSNbS42KLIc+jXtoiiEa653ow5M/pZ2ZdLIBzQDeEBNe3AHv7abMU2kvWoaM52Hv5oJ5Sev89AhxPfQT3zoLtJoN/KkS7371bo+glkuU10UD0HZ1yqVzx323kF/kfQBfqlodnid2a45U11DF6DVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=I2QrNSjt; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="I2QrNSjt"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dddad37712so45222365ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 Mar 2024 12:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1710791404; x=1711396204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zn9nLMkX+9ot7mpB5JfFnXrn3aoEdcb9jRXTQzDWKlU=;
        b=I2QrNSjtQm+xVQ8RihOlJZ2xu3A7seG3YeOIRwS6FGVo2F2s5QS9l8CWic+An39gn5
         ov+6mC8CBDMC7XJ2RoWDmcXghaI2IEtqbt2vpTOVOjllTHGcydZ9cqLSZ1wn3BK3358U
         +l/RACjrb8T4UIBd1rTCk2a7Z95eSQyt51EV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710791404; x=1711396204;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zn9nLMkX+9ot7mpB5JfFnXrn3aoEdcb9jRXTQzDWKlU=;
        b=RtmGEBEv39JRhQxCk6NGFhhGJGMrEzkzHoxWtGNILJUv64UGGI/Y7xAHtlRAPx20rb
         7XNvcW6R99ellZE7/12uS+JgJM+JpUezTxVN7jgOix2R+hQZja3NCOS4cHtQ+gHsDLca
         AKzrdZ7Z+ULfTi0Ld9nTaXhz+Qci1QqS77+IOvBrnWuupiI2PLL2F6v9cdEGkh9Tbo8M
         eDd7TOOJcf1vjPcNIlit8kHuBd/njZXvIhS3JIsn6euiKmuoOGtJU4q5N0cR6GHdqm3u
         D8qHsHhXd7r4rYrEiify2TvwGMWSaD5q1MBhm/WBUgkTaQY+05+OIkwm7lk72UbI3Nfr
         02uA==
X-Forwarded-Encrypted: i=1; AJvYcCW58lIMGu/TN4McO/6bk/qX0aXWcG4767DNuAY2TFLkYwHgffQUR1J5E77Dzt2j9slNLZ6++ID/qKGc74gmgwKEA/I2ZMeRUHwcPQ==
X-Gm-Message-State: AOJu0YzVkXeWxsro6plov0xAguQX4W7SHeKLJG2lJbo7zL0mAZ65EGbY
	upn3Env1bwzRGbUDGJXDkKunduESROT2q3J8ZlV8Uzi9pTF1kLo5aocZqOo0JA==
X-Google-Smtp-Source: AGHT+IF6xxiCD+ojCiaab8EsajiPNJF8kZdxDEny7QVum2isRCnYR16O3y3eSNdTzVFM3sEWOuBncg==
X-Received: by 2002:a17:902:ecc9:b0:1de:f3bf:a47a with SMTP id a9-20020a170902ecc900b001def3bfa47amr13050726plh.9.1710791403740;
        Mon, 18 Mar 2024 12:50:03 -0700 (PDT)
Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2a3:200:5620:6f64:dfac:61dc])
        by smtp.gmail.com with ESMTPSA id k4-20020a170902c40400b001defa98b03fsm6476916plk.101.2024.03.18.12.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 12:50:02 -0700 (PDT)
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
Subject: [PATCH 1/2] iscsi_tcp: do not bind sockets that already have extra callbacks
Date: Mon, 18 Mar 2024 12:49:01 -0700
Message-ID: <20240318194902.3290795-1-khazhy@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
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
index 8e14cea15f98..e8ed60b777c6 100644
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
2.44.0.291.gc1ea87d7ee-goog

