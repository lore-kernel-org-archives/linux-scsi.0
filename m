Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795429441;
	b=qftCEdXFmFoxMzh9OQ2pEK2wmlR6EnanpVab6GhJqAiZ+XG4yhpnXc7nZ6MvdmUKC91V
	 G6rodwGohpPW7w+qLMJXuRJiWfj7vHY9+SwGix7vsJn2XS14nVAC+epaeZl/F9TkjD4/W
	 FAd0Ps0TBlbOUQZDdZ1eZNtpTZU7XdE0oU8Zd8xEJYyl/oF/rHE63MblgsUFRyaYXts/D
	 +fsFIW5IcW28PoaVvlzFUJoKSGQlxmRCBoisjIN8Hwh92I4pcM1KZggOwBySr8L0Kjwog
	 Y/JThQM9ija72q2X2S+on3Ih1j/6x8vDx0tfGLQEFyLQhYCaoP7BKURIJdk2UO6MlBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795429441;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=xgdl5iT4rjRql/T0yly1xc7NN6NRkZoCr5drGDPOf9I=;
	b=ocNBWZJ2kKJEEMYUGIjgH8Tc6+veiGpfrw3txLtTrKKQMWkl8Ov/YtnpHLwlhgSPMKaO
	 G00CYgrv1uqmUJ0LUd+PbeBKW322HD0Gg1PhO9M58Z7VoLsOcZe93KWrm8SisOE8dIMvw
	 MLrd4+RQutRntJsHhcL3/SOIUOEtZV6wocgBH9q7/R3NWzCXiqBGoTSbYDOD0uJiK8cI4
	 r8FBDpdNiGRMhUvT884OjbujNM4JGBZZCmnR7fQKxSEc3zSikDZqbLUJiql7QyeBF4Nqs
	 lYrnx21cBiFHuL/nbM7muE+t7x8wHuaWvO5Ae6IH0Pthpkd+kVjaq/65qpmthAe0PLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=No13YbAe;
	arc=none smtp.remote-ip=220.197.31.2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757F8606A330;
	Mon, 23 Nov 2026 10:23:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 757F8606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=No13YbAe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=xg
	dl5iT4rjRql/T0yly1xc7NN6NRkZoCr5drGDPOf9I=; b=No13YbAePkykBIeV4j
	oNIJ5IQ4IAcsZHsYRCSBs3YI6c5s7UOQFuC4288LGEBzQCdVQw29lsYZCUE3pH6v
	gay6TCiP9znrdIArwYwUYOqspXvwElRIU1lhCAlFh+NtH1WY7EpsP0Go34ExNc2I
	G3Pin2zGSNoRT/NFwl5LU8Uok=
Received: from user-VMware-Virtual-Platform.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3n7cYFARrJ4RhJQ--.49247S2;
	Mon, 23 Nov 2026 18:23:21 +0800 (CST)
From: Ziheng Wei <zihengw03@163.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: bvme6000: fix request_irq failure cleanup
Date: Mon, 23 Nov 2026 18:23:20 +0800
Message-ID: <20261123102320.8590-1-zihengw03@163.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n7cYFARrJ4RhJQ--.49247S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFW5ArWxKryrAw1fKFy3urg_yoWkXrbE9a
	n0gw1xXrWkGrn3tr18JrnxZrs0yF45Xr95Zw4YqFZ3Cr13Zwnak3Wkurs5A3yUXw4kJa45
	Aw1DZan5uw17WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUn6wZ3UUUUU==
X-CM-SenderInfo: p2lkv0ljzqjqqrwthudrp/xtbC7hnmN2sEFBn9vQAA3E

NCR_700_detect() registers the SCSI host and allocates the script DMA
memory. If request_irq() fails, bvme6000_probe() only drops the host
reference, leaving the host registered and the DMA memory allocated.

Unregister the host and release the NCR_700 resources before dropping the
reference.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/linux-scsi/sashiko-outbox-228089@kernel.org/
Fixes: 8276b58af4dd ("[SCSI] 53c700: m68k BVME6000 NCR53C710 SCSI")
Cc: stable@vger.kernel.org
Signed-off-by: Ziheng Wei <zihengw03@163.com>
---
 drivers/scsi/bvme6000_scsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scsi.c
--- a/drivers/scsi/bvme6000_scsi.c
+++ b/drivers/scsi/bvme6000_scsi.c
@@ -86,6 +86,8 @@ bvme6000_probe(struct platform_device *dev)
 	return 0;
 
  out_put_host:
+	scsi_remove_host(host);
+	NCR_700_release(host);
 	scsi_host_put(host);
  out_free:
 	kfree(hostdata);

base-commit: 97d73c8251226cf27cc6656b4c542869bb8c69fa
-- 
2.43.0

