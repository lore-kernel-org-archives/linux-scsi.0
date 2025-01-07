Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51507083F;
	Tue,  7 Jan 2025 02:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736216695; cv=none; b=b1YQT3QbgpeYQU9bIK/Vr8K/02QtrM/hs5Za7nZ21mNmYKH4SnGRGL3qp3gBQdjHoidJhcFE84YX15h8zejKOk81FeoijW0y10c5c6tDKij4TDgOfClRpDdojfMzcXn5HnegI34qGAKddA41IgJ6Uf0qE0VAR8g42qH+t0SeeUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736216695; c=relaxed/simple;
	bh=7F58Vl8TjHNx8B99tq9Hltto5rwLMq3Jh+WEJK90txA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sU67z8LfBKiH7nCuGGWRnjnAhtSaKJvqho19JVgEbwlfhJVmSHp3JsPmLccn3AQUwmXUzsLlOHFWFJEmWNni3H08hFkCNR1r0xQbRA4WYxXP2dqvLJt2PuQuMMi19jQ04iDaSZdcVKGaxxirYTyXeL0x8cisV9P3nLfUBM9Tj/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UOoghbhC; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UOoghbhC"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-21670dce0a7so38869955ad.1;
        Mon, 06 Jan 2025 18:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736216693; x=1736821493; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U2594Hu6hEqRcHlKyw6lRZmC8FeJXoytHNqn1YvR/vY=;
        b=UOoghbhCFjyQ8LUXR1ss5uKS+hlsWP0Sx6ft1LjvXWIrFlTF7TBVCgtLosEHqocdSO
         9rv54YsCc89G77LJn1H9Wrb7Mh70eaq9wz0Jl+yJ5pW1ZQ29uVlAOlbaPTFDAhW2RpZA
         zdQUzx8PAfO2QS5Vt7ERzUxgsJ0uby8i9dz3lpA2yUJgW4rG4A3m0XYEBTdBQ4xsZv8A
         SC/uPf7iPsunSwuBVMyjOYqsi9mmBvO7q3Txl9OYNc/Z33E9r7ab/OkrL6QRBqo2f0VN
         YuzLaRi+xBOo8xh6ctKFO0RavHlPdz7ucOkDSVjdxXncW49jET7mNEmBz7U2K08kaxoH
         aXNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736216693; x=1736821493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U2594Hu6hEqRcHlKyw6lRZmC8FeJXoytHNqn1YvR/vY=;
        b=ZcJeioxqwHv6dfeM0Umc+DXkMCgQdfijW8LTm/o5ZlmJ0Kj/V/vlk9RApZMaP+/Pcb
         Ck697FIN5A+wlWPAndTJqySQ0bl0iWiKB9im23N0+FzTPtPy42M19SHVf2SP7//DYDQK
         L6wynpfyU46X507ud71NSyJfB++xHmxHP9TNr6AipZh69jCLnAMJkGm2SojqjRQ1P7Zt
         Ue+Ckp8z+9/HTtIt43oTvTvKkYZTUm9czL0wH8j043Ema1tFuu7yafqWkFtymwrFhRMW
         DJlggBbHEZz4JsX+tRZdYraEcbEhxLAJ7cI1y+cT1ckJttqReJM5iTnUIIcrlnS2sdjb
         8F5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVvCz7TfJ3OjlDv3nWOlC2NKPJMicm9PAB1+v+bFGSc5ygFa4iVRl2eLeuHaWYefT6Yr7GxoWceSXa9XeM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7Va8SrznBLymu4+yq89NaRY+Iqg//ZtR2LOzVXXoP1BNNdkLw
	a0arW5KDEsX9MVwvUyz7pAMDhXpInEwmlx99djtvUIMcm+Quod0z
X-Gm-Gg: ASbGncuGWuZjyzRLbL03ae89YBASHIHRsfYsHLta1rJQfHdQct4jNCNf7R/y70g/J8D
	KUK/9BGfP5mOK0+8f6E+P5eEulEPJ82k0DFpYuTsj7/ARKLl+IT3G30L+6f5OpQDnmCwicenJVV
	3m1WR1CgsODJ62YRLi5QUqEBaX2+WsUAXU75cebOPfcYhHm2+f54uhdPUv7cwFAUTNU94sUxgPs
	76ziZiAbkrEDvEchYXTTgQIL8zuHfOq90UkjW96JkMuWmbJihWckiTHsxGLCFmxZAtxg30zHyl2
	UFF48f+Mtw==
X-Google-Smtp-Source: AGHT+IEUVAovTOeEHgXqYaKk9fwAX7Kt/DrwEQQ8loXXKZPmWHmkXbei8hX5wrJqpH4t4Latdh6QXg==
X-Received: by 2002:a17:902:e844:b0:216:3083:d03d with SMTP id d9443c01a7336-219e6f13c50mr883089265ad.44.1736216693011;
        Mon, 06 Jan 2025 18:24:53 -0800 (PST)
Received: from localhost.localdomain ([103.150.184.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9cdeecsm292883645ad.123.2025.01.06.18.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 18:24:52 -0800 (PST)
From: Xiang Zhang <hawkxiang.cpp@gmail.com>
To: michael.christie@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Zhang <hawkxiang.cpp@gmail.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	open-iscsi@googlegroups.com
Subject: [PATCH v3] scsi: iscsi: Fix redundant response for ISCSI_UEVENT_GET_HOST_STATS request
Date: Tue,  7 Jan 2025 10:24:31 +0800
Message-ID: <20250107022432.65390-1-hawkxiang.cpp@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <d9be3663-f6f2-4a1c-bd88-2a3978f92bb1@oracle.com>
References: <d9be3663-f6f2-4a1c-bd88-2a3978f92bb1@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ISCSI_UEVENT_GET_HOST_STATS request is already replied to
iscsid in iscsi_get_host_stats. This fix ensures
that redundant responses are skipped in iscsi_if_rx.
- On success: send reply and stats from iscsi_get_host_stats()
  within if_recv_msg().
- On error: fall through.

Signed-off-by: Xiang Zhang <hawkxiang.cpp@gmail.com>
---
V2 -> V3: Update code comments
V1 -> V2: Update commit message
---
 drivers/scsi/scsi_transport_iscsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index fde7de3b1e55..9b47f91c5b97 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4104,7 +4104,7 @@ iscsi_if_rx(struct sk_buff *skb)
 		}
 		do {
 			/*
-			 * special case for GET_STATS:
+			 * special case for GET_STATS, GET_CHAP and GET_HOST_STATS:
 			 * on success - sending reply and stats from
 			 * inside of if_recv_msg(),
 			 * on error - fall through.
@@ -4113,6 +4113,8 @@ iscsi_if_rx(struct sk_buff *skb)
 				break;
 			if (ev->type == ISCSI_UEVENT_GET_CHAP && !err)
 				break;
+			if (ev->type == ISCSI_UEVENT_GET_HOST_STATS && !err)
+				break;
 			err = iscsi_if_send_reply(portid, nlh->nlmsg_type,
 						  ev, sizeof(*ev));
 			if (err == -EAGAIN && --retries < 0) {
-- 
2.44.0

