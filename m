Received: from mail-pz2-f24.google.com (mail-pz2-f24.google.com [74.125.228.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F09351AEE7
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 17:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789752361; cv=none; b=bzK6UOez6sGr0z/TMQNlIASK4y6dLD9hL/lEWdZ29LsADvQRXg8eU+I4tWIpzFJavVhtE2Fs8azJxmU68SqIXCaXk3LahWkWFf11wvkINlpmoKpIC+ZW6qllefnio1Njqe7PhzvQeU0OybNUIy89k+tWJOmczZ5+FeM8sLQ6RUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789752361; c=relaxed/simple;
	bh=cZKn69nF+ltHhO2GnIWhmR8Ldl8qwapZb+XHEzvz4/g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OZV9Od6C2ApKYhLJRF/TFQYn/ESv4zCkRekJ3PW+/sV5NY8dnUq/9Nd4wThMYow9EhjfZ61LHGkk77QXbn2EAFzwL/oNcs2Lrnm1K2rlEg630HeZGUnyZKcoyDoi907qphHqkLmCHL6SRqD0rLs7Q7gGVrlwGmrGncaHuqJs6K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nA7MHShR; arc=none smtp.client-ip=74.125.228.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nA7MHShR"
Received: by mail-pz2-f24.google.com with SMTP id 41be03b00d2f7-cc4ab4fe290so277166a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 10:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789752351; x=1790357151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7w41cGtnpU1fKAfJJK8XLWeOJGEaeMvKYoPj2+vL5e8=;
        b=nA7MHShREbJeQLkNa6zVyADyKV4Ml/X87W5j71Hi6xnXjmBNrME+Rd54rWgt+MADca
         UTHxfCPjAE08EAzLxYjo0R1m3VW/DBnyDP/uIKbrMz0SClqqxXHSpBQh4TUXuRCnspnd
         Fpbhix9XYFjuZ/8/1EmcTgpY4idHjxrji6Cvi6ALTlztH25j1j59u64vFu/0AQhY0wV4
         q5HZsSmGYkS8jKrytDRIBOwjQmmJashQzISHs5tP7i4KqG7mlNIlS4zNdtfTU3TYuqPT
         fR5V1itwB/0bEAUf7WvRaglINbFbskS+RRjv+FFED0SLIvBDh/72whxGvgxKfbmQx0HL
         k0vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789752351; x=1790357151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7w41cGtnpU1fKAfJJK8XLWeOJGEaeMvKYoPj2+vL5e8=;
        b=TXcM5dVIu+0rmEH3xjTB5hPDk62nj3/wVrqoooqhaX0rZUXdm1+D6Ophq0I9GDFDOA
         XTda3Kyp9JgNVfDJyS3CjzoG97xMNQGwBhrRfSLb98Rq5gGXTkRx2/LnsV7MGb4u39n2
         ZY/cRp1bJ/DaQEBSK5zfyV3YM3nmnk8a3rNzNgxZaQnwVnxc06ybNcjaz1BMyowVuH5U
         hutoQeXpICWwArLJsKKbXnWWXf0jx3JEjVCPRNJoqT0T+S1VdQ8mPd3zAtCmV3GvtG4I
         4cfDW7v+Mqi44yadaSi1N8sGMQzLLvcgntXZ6L9ulbFe/MOyjO56bqdhKgpEBCi/dmQz
         AsUg==
X-Forwarded-Encrypted: i=1; AKwUvBwiPF1dL3KQ5DBPSQz3mUwXAIBzdsRDimir2yiNQQ4DZiFcD/cGT30Fh7QQwrCQp6+agwsNWDZDZD7H@vger.kernel.org
X-Gm-Message-State: AFuF++kTHHX8+Owk3FLmP8RJeGS2Xwo0Rk7axkOPv8qUdsTgmXu7yvHT
	Hf76OBYoTJZBbEbWWoCvRkbbjx5AM8MViVobQOuEfSA4EeIYxAXdex0+
X-Gm-Gg: AYBFou3u9ypIQQNnWnAmdwGjbD/fngEGdqYvLb03FRaUQ9sECQaYuHcZGasTRqEKZYC
	T38FrH+ZJ60IbJpIOAOymJ4ybyvIgdukEZNNwE+J32IJty8VaybK/EQZFVFyxUnSbfn6ecqZkPX
	T+ZpXb/r8U4EIaaXAeuAKGrQf96VvarDL2p7K/ggwHcz04b3KiPJy5pjObHYdNRMkRwuKc3MFWj
	il7HXzx4CB1f5V72BZfwI0i9Hnd/D7MzpPijUmcFFKzfQ0GlaHmcFQ17IK4aeism4YzUMXYCf02
	/x/EAJCrqku+u/2XCDtZyDXiwOKBhWbnZEKSaa3TDQ5vkpgSRbTMQI4Pyjz2nI92nozFpz3g5+h
	lRcASEv41ZBjwMQ9KWh5dr1D+b837dqz01r7iBGGp06BUu3mPgk/zCJBqT7FpZFDHoTtzTPmxgy
	fi2lAKaABNjm9ipeIH1Zhnc2VnGZmuhKf4scYtAJAPs9BDCvnWRSpvKw==
X-Received: by 2002:a17:90b:51c1:b0:39e:6c68:fd92 with SMTP id 98e67ed59e1d1-39e6c68fee8mr313201a91.39.1789752350791;
        Fri, 18 Sep 2026 10:25:50 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6cae997csm395136a91.11.2026.09.18.10.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 10:25:50 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
	James Bottomley <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: pmcraid: decrement adapter count on remove
Date: Sat, 19 Sep 2026 01:25:41 +0800
Message-ID: <20260918172541.3599902-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pmcraid_probe() increments pmcraid_adapter_count when an adapter is
being initialized. All probe failure paths decrement the count again,
but the normal remove path does not perform the corresponding cleanup.

As a result, the adapter count remains incremented after a device is
removed. Repeated bind and unbind cycles can eventually make the count
reach PMCRAID_MAX_ADAPTERS and prevent otherwise valid adapters from
being probed.

Decrement pmcraid_adapter_count in pmcraid_remove(), matching the probe
error path.

This issue was found by manual code inspection.

Fixes: 89a368104150 ("[SCSI] pmcraid: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID controller")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/pmcraid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 942a99393204..da80f1d39ec4 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4778,6 +4778,7 @@ static void pmcraid_remove(struct pci_dev *pdev)
 	iounmap(pinstance->mapped_dma_addr);
 	pci_release_regions(pdev);
 	scsi_host_put(pinstance->host);
+	atomic_dec(&pmcraid_adapter_count);
 	pci_disable_device(pdev);
 
 	return;
-- 
2.43.0

