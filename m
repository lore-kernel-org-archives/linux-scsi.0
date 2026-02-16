Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF363115A2
	for <linux-scsi@vger.kernel.org>; Mon, 16 Feb 2026 14:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771251936; cv=none; b=twOaCtvdQrD1c5an5enq/jAePv4WNTMEY994mL4BHnS/JyuJpumf4uWDsJj5g7K8KIHVlX0UmhfwEbIxuznp0uX4QMg6UhwfrQeaJJVilWhh2lrkH3085RiP0HCmdnCdw5uI6Q5Kd03mliBYJGtOu7hXFv2xF9IP/bHIT1g9qlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771251936; c=relaxed/simple;
	bh=rZ1cI02ZyGsF5YC4P0LfQX97Kl0v9+FZ0eOX8dFmAtk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bCHSjgyFR1L2Zt6sg30XVB9TVT86czkUn7agCR6foTaVLVfCuCxY1rtIK1Hq8lrCWm+KYW/zpwSb5LggOTBt3Y3e2FtBSi74zboWzz3H+TnN7NBtirNPhSvqyoNLikg7Zz317ojAnfqtOCfj2G3YKoLlh9OHxO1979bciAA/tL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lEBiKWIe; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lEBiKWIe"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4806b88d8c9so4154455e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 16 Feb 2026 06:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771251934; x=1771856734; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XaRMBbsVUDPXG0cpvkwkXzPiYYVpsnTMm43yQAxsAgY=;
        b=lEBiKWIeuO4gYZCAYmclIi5F3ikaZylno8cIeeVEMSeIV/t++SoldQA25wZCDnopIg
         j9gMBbIQFJIz4ZD5QyssJHi+zD88a17rjfTXbTp3SgkfK9XAsUIJSRf4FMEVQOWgXrnp
         Hb8xqh3lZ7MX3O+/m0v9Q3B2T3nLdpIUIEgg8NATNMBOPcgmvHhb4Q6BF6W8OmtmGVWS
         9GshuDiJbiFBvhldEaLxLjG5jMP7Z6JdTlIHQp0lK1dyHj1w8TYuDnhqAM4JSvqzJ/Wd
         oXMe+xWfnI3RTk6kgA3U/l2GmMohmJ9Xbf/wPm9TEKFF6/EjCnyZhAZdK5ug2uRVIWoV
         r49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771251934; x=1771856734;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XaRMBbsVUDPXG0cpvkwkXzPiYYVpsnTMm43yQAxsAgY=;
        b=Kl4M+EVElkghH9kbwT9D3w9M5b9VFjp5LilFmkRHzmx9jpdGeJO/6nOu4PY+mds73M
         x49i03rDeC7sFjJec05EBCkVXtuX7CJtZOQYHR8ITHkkjjwvcop2Jywj8a+F5jhEjAhm
         /qr5qVHnRpzrQ0xjBRwObXDS2HmT3kPqqIDL8vMsCLd2jq6PwJEre5Wu6OP0w1EJMW0O
         DDC/m3rDR/V3FNErOtOyXQBpoSM02IiGDUl5zmLmHakdzdMTz+Up5CacRdZSu7SNZ9Dq
         fHw0RMqxBoPoGHJVM3MkJzlv6pVu8b/Bj5YzbHYGtgE3Cx42ykJmUJaDPOx02uJJJ7tD
         6qdg==
X-Forwarded-Encrypted: i=1; AJvYcCVAGvpiInP4hLelBoKgjDPNi3MzDteAdAmdUgKLXWjOGMBhJRR8KNFKbcyN+BE0EoZAkqlw2U28yQQV@vger.kernel.org
X-Gm-Message-State: AOJu0YxSLD8jTLNmAjyMNW0pcJ50081okUyPdmX+ZocE89Cq3o8KjOOL
	2X2Y3Bey1OBz+8sDgxCs5C0x3M036GXl+gkqGpYhgr1lEiL3LIVb0rHX
X-Gm-Gg: AZuq6aILVSg7wEXwn0BMraGqNTGrfStATYR9RvZ1MO1oOIFeZp4YUcWKmXV1UcfmoQh
	Pi5GdbkanGqoTBbA1ZdGDFW3gGFoKjTQ3C3D4vuIwU1TQoDafjuF+ySL+6ge/fHY/VS6Gj+3gR9
	WDRxKBuywKjlMNAAOnf3DOx0Hse6GpyDvWSSM44IHNamcPA4/DL3ShfKPKWW1QGFKUc7Ti7f5wS
	aGQMlQDbyfnoYe0StkJwN2yIyAiYkNsTZ+EAdSq+A0RpIsfgOEou6VKjSXWkOJYrafOaSAtMtgk
	kzc/NIfbJDsux3STx85R+cWBux1peGJY1BrRajNOvhJ9lzmrsAJSsaToYWNTH1mDPiOpr9zrtuK
	3uhTPr4SSMsyQTQNZvb5CiIurVLUmSAYqn2hCluQw++8w4HCgvbJxrXDe0qaoAr3vBqZYsdRevq
	eqKF0iRLsJWDbZlkN8t3edadaWI1K1cvtIn2iN+zJ4aDNpuDRcA67E7uhlfHgFchq27K3rcJCSL
	9EvEJmCokghIEmrf1xHiyY38hUVAQs=
X-Received: by 2002:a05:600c:190c:b0:47e:e20e:bbbc with SMTP id 5b1f17b1804b1-48370e2b589mr122893065e9.1.1771251933297;
        Mon, 16 Feb 2026 06:25:33 -0800 (PST)
Received: from thomas-precision3591.paris.inria.fr (wifi-pro-82-204.paris.inria.fr. [128.93.82.204])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4835dd0e327sm434486105e9.14.2026.02.16.06.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 06:25:32 -0800 (PST)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: snic: Remove unused linkstatus
Date: Mon, 16 Feb 2026 15:10:55 +0100
Message-ID: <20260216141056.59429-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The (struct vnic_dev).linkstatus buffer is freed in
svnic_dev_unregister() and referenced in svnic_dev_link_status() but
never alloc'd. This means (struct vnic_dev).linkstatus is always null
and the dealloc the reference in svnic_dev_link_status() is dead code.

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/scsi/snic/vnic_dev.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/scsi/snic/vnic_dev.c b/drivers/scsi/snic/vnic_dev.c
index 760f3f22095c..c4df0b17c86c 100644
--- a/drivers/scsi/snic/vnic_dev.c
+++ b/drivers/scsi/snic/vnic_dev.c
@@ -42,8 +42,6 @@ struct vnic_dev {
 	struct vnic_devcmd_notify *notify;
 	struct vnic_devcmd_notify notify_copy;
 	dma_addr_t notify_pa;
-	u32 *linkstatus;
-	dma_addr_t linkstatus_pa;
 	struct vnic_stats *stats;
 	dma_addr_t stats_pa;
 	struct vnic_devcmd_fw_info *fw_info;
@@ -650,8 +648,6 @@ int svnic_dev_init(struct vnic_dev *vdev, int arg)
 
 int svnic_dev_link_status(struct vnic_dev *vdev)
 {
-	if (vdev->linkstatus)
-		return *vdev->linkstatus;
 
 	if (!vnic_dev_notify_ready(vdev))
 		return 0;
@@ -686,11 +682,6 @@ void svnic_dev_unregister(struct vnic_dev *vdev)
 				sizeof(struct vnic_devcmd_notify),
 				vdev->notify,
 				vdev->notify_pa);
-		if (vdev->linkstatus)
-			dma_free_coherent(&vdev->pdev->dev,
-				sizeof(u32),
-				vdev->linkstatus,
-				vdev->linkstatus_pa);
 		if (vdev->stats)
 			dma_free_coherent(&vdev->pdev->dev,
 				sizeof(struct vnic_stats),
-- 
2.43.0

