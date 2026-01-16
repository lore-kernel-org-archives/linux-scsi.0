Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AB1346FAD
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 18:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588036; cv=none; b=EUNUyJdr/3njMGMJP4PBN0l7mPuph/8BTGBTeNyOu3oME7gFAT72Kl9TKFmsDadgICYICmVYHjtkIVUElzQbp+5lm+BHTEFHBbEe+23LXn2DYTWZYKPQ3YpM+K7oeJJplaoM9aDCc9TsTPhz5u3oi7HCzlBKOKX/lbZH6pJddhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588036; c=relaxed/simple;
	bh=Wa62+D3j1cIyNpAlAE7aVjE+cU0neL2Mug3DlpY/YUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKi8QFwjxjYvS5ptNKklbur1OOgfd/LKS6/fP5OSUc90Syurn8ekKf86pAEehYP4mD8E71Yh7Xe4HQbUv0YeqfN2u7apqk13wmALQ4NYbGHZg7AL9qukB7ZVD4m0XNaYaskjwnFtoJ7cxvvX0X4T0tUmGzmKallwQzJ0sUnWg/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=207g3QbK; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="207g3QbK"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dt7cM0HfGzlfl7l;
	Fri, 16 Jan 2026 18:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768588032; x=1771180033; bh=W7VYE
	HI36NrcWrDBMDX7ht3Ocqc0ErBpOYbHwLTiq3o=; b=207g3QbKapBjZzSOMXYre
	fepWyhSer6wCHYg9bfQOZ3+Jvy/nUho3eW8PX6Y+nnVN4Iy2AWB8AIcfGvEPh1m2
	C7lxKlWr4mUDJMnQO+8pSoFMsgQlTECg2PqNPD5//4HMAV5qHJJsZNYNVrAnAoDd
	bfZyo4qjtgJJuZNqNOPF3GxiPtP/RoABw0HLNq3XFcJIZDKMeG3WMbgAQ77dIJNi
	q7Qbgm+p+3cqBNWB4pq3bSlXPiKDX4h9CEAYMjpz91yV5v+SE6dxeQs9i9RYvXC0
	LSDveEDUr9+UhU6uyzouqbT0O+FJL7e2r0C1nzNb+DDGJepndv92wIgZRoyfIYJC
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jGImRsdR0nMM; Fri, 16 Jan 2026 18:27:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dt7cF4mnlzlgwMq;
	Fri, 16 Jan 2026 18:27:09 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Huan Tang <tanghuan@vivo.com>,
	Avri Altman <avri.altman@wdc.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Daniel Lee <chullee@google.com>,
	Liu Song <liu.song13@zte.com.cn>,
	Bean Huo <huobean@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 6/7] ufs: core: Remove superfluous ufshcd_{hold,release}() calls
Date: Fri, 16 Jan 2026 10:26:08 -0800
Message-ID: <20260116182628.3255116-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260116182628.3255116-1-bvanassche@acm.org>
References: <20260116182628.3255116-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

ufshcd_hold() and ufshcd_release() have been modified such that these
call runtime power management functions on the WLUN. Hence,
ufshcd_hold() calls that follow a ufshcd_rpm_get_sync() call and also
ufshcd_release() calls that precede ufshcd_rpm_put_sync() can be left
out.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-sysfs.c | 2 --
 drivers/ufs/core/ufshcd.c    | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index b33f8656edb5..2cc7f5063286 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -256,9 +256,7 @@ static int ufshcd_read_hci_reg(struct ufs_hba *hba, u=
32 *val, unsigned int reg)
 	}
=20
 	ufshcd_rpm_get_sync(hba);
-	ufshcd_hold(hba);
 	*val =3D ufshcd_readl(hba, reg);
-	ufshcd_release(hba);
 	ufshcd_rpm_put_sync(hba);
=20
 	up(&hba->host_sem);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1189a9fd39ff..8c388275308f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1809,7 +1809,6 @@ static ssize_t ufshcd_clkscale_enable_store(struct =
device *dev,
 		goto out;
=20
 	ufshcd_rpm_get_sync(hba);
-	ufshcd_hold(hba);
=20
 	hba->clk_scaling.is_enabled =3D value;
=20
@@ -1834,7 +1833,6 @@ static ssize_t ufshcd_clkscale_enable_store(struct =
device *dev,
 		hba->clk_scaling.target_freq =3D freq;
=20
 out_rel:
-	ufshcd_release(hba);
 	ufshcd_rpm_put_sync(hba);
 out:
 	up(&hba->host_sem);
@@ -4368,9 +4366,7 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba=
, u32 ahit)
 	WRITE_ONCE(hba->ahit, ahit);
 	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
-		ufshcd_hold(hba);
 		ufshcd_configure_auto_hibern8(hba);
-		ufshcd_release(hba);
 		ufshcd_rpm_put_sync(hba);
 	}
 }
