Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5DD2C11DF
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 01:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789434139; cv=none; b=AzpaXn+XR1W/ATtvB2eWH/Bw11ZDNoXi68dj8wqo7Rvh4MmWnkeYDUYzK+vRibq+BLfbs1e2DkKdvJguF5HEYhNeeecoxiszJn2sftS7jZYe/8nBsJcMM81PB8nEgbt2YOVUKDB/3l3RaPGXtXsAhbuUG+KifRtrgKwtJToAyTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789434139; c=relaxed/simple;
	bh=cEPjvYmUpZzkbb1qaVYv5rKfnVTnkZ4bUmEcd21UiGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L8hshILO1brUpSCXr8yymIn1jMD5BAuUElxqvac2/A1wbYHkZHIfeq5lJL8NDWe+MbG9/ONwVj3wUxUnvZvPAWIce5N7cO2BUmMy0z/L7uGOavwNw+luLmuWpXfh5W9AGEXKn6roIfazObpuY50NsXQIBFU4/7pZiQnRDAKXBCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kZFe0V41; arc=none smtp.client-ip=74.125.230.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kZFe0V41"
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-9104e54b1abso31374276d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 18:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789434136; x=1790038936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=t1LNCA2rVzMsb3MvU5q313bU41WDHWDxRU5eL4UYHU0=;
        b=kZFe0V41S6X1LEVc4McSBjHP3wpzUjXEL07O9l27zbrDk69kwc0yOEctUmgN44ZvE3
         Pqolor1qG5f6crA15wZ6vlNcYYIxnMEate1T54ab1Z2k2XMZoINdD7z2uKqMMDh0q1EC
         qDep3QGhUvOniuJgvW4i1HgFm5r9z8dqXHTq+Jv5MznXHhWVq3jj8nX4noP3rYBY1QOe
         ttl80keYxgRhFGK652oIdPcbe3yBsSaWsUR1GuI1+vMcXGygEH1zBEMdn67u8DqJMRFR
         wI06g7XnPjwS3fgrn6rHzNoy4TsIDfS4BbrbKi9uU2zdNcUx6Q2XQDuvC5sw5Pn81Xv8
         Q6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789434136; x=1790038936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t1LNCA2rVzMsb3MvU5q313bU41WDHWDxRU5eL4UYHU0=;
        b=lw7jfGidubOx4VfSrMMVPmrpACoFnOZ2np2GGVHT2tDsbnrP0w4qifV9VFKQIslmT2
         Yib/XUJcmIT/L35VxGll4p1W/BRrk1e45uQIVH7l4FtniY39Dhbg56mR5Tkk1BYZjO/N
         +cR/296TcrbR6vMToXnSCnSstxEQRmBYcIBmLyuP7Zl2Nc972LQtR06liP9V9NfwsXIu
         PQ/1m/NovNcQPWyKYncLn4gFi1d6uUG1BTvLH0D6rRwo5CppNVKVdhhSLpIjx/5+msLx
         b0qWBY+7fLJVvRl9Z2gt7YF2t18roymUUpBHrXoSu/to3oJtDgN9FBoKkPkEjiB0weo5
         5kkw==
X-Gm-Message-State: AFuF++mjia/mcN0ug/e7RDb5bQcBrt/Y9P6taGMRmBOHn+ns4hmBIXYP
	5xAhHrbB6UC/2rXOhw8HEsCpxhQ2UJah+blvOY+TOMOwwkHKM0vjqqpiNWmt0kFFcQ==
X-Gm-Gg: AYBFou1MOS7LhcTUjwIsABnz+LtqrFvAwNkjK4mKsKNieF2wYMhtnruBUplt3J1JkUU
	+s+5iEzeamdrulJcLi7k/Rf3nUbOeKi7MQCR/wQQsgfNNJUm46kWEcZ5kbE7rmdr649kVR6uPZe
	vS3Sjrpk1dfqrj4KUw3X3WBpM2JF/JhrdBq2rKlQKawMSjfgWU1UontlDrtrjabip7I3jCtqELz
	Jl4/sOJ3YpF3jg5FJs93tAjKzXnXoxI2/eOsfveuYQL5EWw9gj+exMdJ2IOs4a8C36JflF9yD7h
	rgFuJjjyoNh5jvnXiJw/0s8sXwh+zTul5wNQMr3BWgrdM0dPF8vhbZ+0EGPa0/Hp3g4u5RobtqF
	SCWDuIE/ow2MHxjBR2urA+ousg4bW+g6hr827tH7iyOEz6p1W53RM6v5RvviV3q65j1KfYQDe0g
	PViFh4m9wM7ZHdGHWH5NIwe7/l6LF5XdEmv72b7Z+zqq92HGhMLN4CPbvKCZnG1UrZ/2IwYxBf9
	hMTSPeQ+upBMXJzTLQvVj6m2dKYBEW+PtxmXMi5r7HKNA/gyOFNjJ9JzlZ0o5dOXBqfxs+OSrzt
	rfKcZutK2NKgzCrp4rCghNBY9N4jLhCBMZ1CSX57SRKBrGJXMt9rxti+DO7MDhzurSKcHQ==
X-Received: by 2002:a05:6214:1942:b0:910:48eb:605c with SMTP id 6a1803df08f44-9122e676001mr87569056d6.28.1789434135881;
        Mon, 14 Sep 2026 18:02:15 -0700 (PDT)
Received: from 6e-wmo5420-02.ad.psu.edu.net (6e-wmo5420-02.ad.psu.edu. [104.39.213.233])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d51ffsm110574986d6.45.2026.09.14.18.02.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 14 Sep 2026 18:02:15 -0700 (PDT)
From: Myeonghun Pak <mhun512@gmail.com>
To: Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] scsi: aic79xx: Disable the PCI device on removal
Date: Mon, 14 Sep 2026 21:02:08 -0400
Message-ID: <20260915010209.53250-1-mhun512@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ahd_linux_pci_dev_probe() enables the PCI device, but removal leaves
its enable reference outstanding. Disable it after ahd_free() has
finished shutting down the controller and releasing its resources.

The imbalance is already present in the initial Git import.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -113,6 +113,7 @@ ahd_linux_pci_dev_remove(struct pci_dev *pdev)
 	ahd_intr_enable(ahd, FALSE);
 	ahd_unlock(ahd, &s);
 	ahd_free(ahd);
+	pci_disable_device(pdev);
 }
 
 static void
