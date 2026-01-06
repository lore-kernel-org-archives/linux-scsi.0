Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC9327C162
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 20:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767732832; cv=none; b=s7Q8VSS7T7OsG73vWuA5NHv3wj/FdyqWSxytp/2GiKeXO3l8iXHD+dn5CMkq/ABRBTmEQ0S77Ks/celQuBIxGKcfbPGOcuq0KTU+8Ag6TTzEAuxPA4/iV8UbYeMuz7+YJqFVPuIhcbCSEwcbFWf7CS5gwcddp0BvNKFa/377ShY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767732832; c=relaxed/simple;
	bh=dbQZWZ6djGesZyoyGZQ7YrW0hIP7fv2ICVb0g2gVjBo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DUiWAZE/LH0Cv5Rbf453f4QTylnPwh1rHEZNCOokSZKe+cvs1Ipw07t6F1T4e2lx35f5dihGUr/EJzUqUZiyjwylApV0U+ydnRTyB95sLB8ZnmihroCJHTsQlhvjF7P4YTu6rW+pCwJxq426ERipgM2qNar+ortNEFu6f76Gd3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dRAo7jzR; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dRAo7jzR"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7c75b829eb6so899135a34.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 12:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767732828; x=1768337628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C37GUE4jCe8eFCg/55C2xhu6ydcXSckS06PD0UKDC/A=;
        b=dRAo7jzRt/hpOzQrdh4Ngn1+WiMMarMskzruXa80kC7pplRcroXw+16VL8crNaKRlu
         2js1/+h0b/4balTlT/6LCiML3kVLH/ohBbfBLVKZ0Dhf3HyD+DAieyf8/iia/SAGv/UA
         qknOJTVDfUSbmjLoPP2fiVq4nhAwSyfuR9a84kvFT7v9NVlF+ugLspqpkRrU/VFuigwj
         aOlQhhQ/mHsF8YTl2UDS27G+8kS8/Bs9h4AW0cctO5C8FvpeKnvo6QenrIYEpuxHc5gV
         hzg5BMltAHkd0oAmNRO9O0FrI4bPOXRZ0AHv6FCZ8kxMXhNulyiNMQSi820YumQFkzsf
         hDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767732828; x=1768337628;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C37GUE4jCe8eFCg/55C2xhu6ydcXSckS06PD0UKDC/A=;
        b=gr4KCylln4swVKdp+HV4roRipZvES/nV3j2sWpErkTpDp0ewOvCvm7Wix9BN+dX0Dg
         3CqSj4SM/f5WPwDTdzvlQ2d58aaORrMxPd/L3gZmbOg0U1wgkBT2+oyBafdoparKRVJk
         HTO6WgJrO7dVvK/gXoMmPE0Y6DCBC3eDeT5IA/MqBkwYX9PJ0qrQrplrsWIVKJZLqeQN
         HUgJSTuaWBOtMNxD0sOgqi+h7WKEDYAU0bPgqyYMQPfGn31g0wkD++pAujM/9hXg/pc2
         k6BWspGJCJk2z0+pQ7SG7ZPeAWrbcfETYKAEHPxuUlFRq7jS3nQ+Q4AM33ZOgCOb/5Dt
         o2hw==
X-Forwarded-Encrypted: i=1; AJvYcCXiz6TVPq4+YwNPcWbbcBF8QBHP0GLag3NOih8EMxAnV4R9E2WWUuPcVT9Q70yJQw9k9llScUKbzpWj@vger.kernel.org
X-Gm-Message-State: AOJu0YyUa5yJu85Ym3dT2Sfym/x+FBKiWQSTr0jjnFm1+vG+B/gIRn26
	PoWw4NF8XkBoxSm2Djw30OdyjinN13Uj1OJWP6wwvEe01/PyvTihOfuq
X-Gm-Gg: AY/fxX7mhY16xGTaq36mD3PsyhRZpx2/J4xzEvcTIk1g7XkJPRzzQZjRkqOkCml6tky
	N++weJ6C4rwC7T1fMrvAFlfXBAKmg0/anCg+bQxdYfxvJh7NnvhNcvT/zauuXZpvTbeYJ2TBm+f
	iSFBGve4kvjCQE+yykRqH8ySSGGfpF/ENskvoh0Sw6xpT9nlMNLzl3/ILhFMknEZTTfMMOnJl7i
	+lMciMWZAEEQSqwhcv2+RpeKYOZEkCZYOzbGDCPKL39PUDtYClUrI934vSHQoVOcO7cOuUOrbtg
	O1RHhsAmdmzT7kClgokoilzJqxugOzphWs/5qYv1JQdKboR9JRo/xrvBZb0DV2Q/uwG2QwZnWNh
	ID4LmeKM/1TK1VWTQfunEdXKA0Fy84eum/OMKac46m0XssPXUdcLtmuTE3li2pXzl3ODhwhhknZ
	PpM0UNBy5iHEfG3yrCB0fjCONjink7r5zr
X-Google-Smtp-Source: AGHT+IFBhdEustKWoHi64qrC1V/En3a79yESg/gNp5iJ2nASZtF+k7/swYxDkjmWYtcZnfS1qxM1Jw==
X-Received: by 2002:a05:6830:718c:b0:743:8af2:1af7 with SMTP id 46e09a7af769-7ce50a02054mr300216a34.23.1767732827757;
        Tue, 06 Jan 2026 12:53:47 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce4781c286sm2182707a34.8.2026.01.06.12.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 12:53:47 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] scsi: qla2xxx: sanitize payload size to prevent member overflow
Date: Tue,  6 Jan 2026 20:53:44 +0000
Message-Id: <20260106205344.18031-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In qla27xx_copy_fpin_pkt() and qla27xx_copy_multiple_pkt(), the
frame_size reported by firmware is used to calculate the copy length
into item->iocb. However, the iocb member is defined as a fixed-size
64-byte array within struct purex_item.

If the reported frame_size exceeds 64 bytes, subsequent memcpy calls
will overflow the iocb member boundary. While extra memory might be
allocated, this cross-member write is unsafe and triggers warnings
under CONFIG_FORTIFY_SOURCE.

Fix this by capping total_bytes to the size of the iocb member (64 bytes)
before allocation and copying. This ensures all copies remain within
the bounds of the destination structure member.

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a3971afc2dd1..a04a5aa0d005 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -878,6 +878,9 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
 		payload_size = sizeof(purex->els_frame_payload);
 	}
 
+	if (total_bytes > sizeof(item->iocb.iocb))
+		total_bytes = sizeof(item->iocb.iocb);
+
 	pending_bytes = total_bytes;
 	no_bytes = (pending_bytes > payload_size) ? payload_size :
 		   pending_bytes;
@@ -1163,6 +1166,10 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 
 	total_bytes = (le16_to_cpu(purex->frame_size) & 0x0FFF)
 	    - PURX_ELS_HEADER_SIZE;
+
+	if (total_bytes > sizeof(item->iocb.iocb))
+		total_bytes = sizeof(item->iocb.iocb);
+
 	pending_bytes = total_bytes;
 	entry_count = entry_count_remaining = purex->entry_count;
 	no_bytes = (pending_bytes > sizeof(purex->els_frame_payload))  ?
-- 
2.25.1

