Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7637D35948;
	Thu, 21 Aug 2025 16:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755794998; cv=none; b=uOCRonFXOFWNhmR8LEF02QM+MGVFToYrAxantLcehZ3IUrCGjHsstoJrHL9gIuiGsjsXd7Z4tT14OAcVq5FUnye5UD/QeioAq+g/mfXjbOWBw4JHrRjnRIiEOTByxEP8HT3pTiewTzM39onU/WR0tq8PAQDyXOFLc9FO5YmmLac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755794998; c=relaxed/simple;
	bh=j1HPu+xf82+sSceY4BTW4wlDho9OJP75SC6covMR4QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bI7qJUmTX/vsPWg5U9/Gc5VSWB7NLxkeuO6VY3gKOK3JRqdIwnHyyskUhMJMWh9M/1RtT/jBzUJuXYc8+J7VwQcqGE4pV9r4Kx8LziOzXC+/mLeboJ9579cjrosTTNMJTMxnFRun0ntQavB6bsqNEHs5HbetmLV2k2jBrLVmfUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jlFkCIyJ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jlFkCIyJ"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45a1b05a59dso579545e9.1;
        Thu, 21 Aug 2025 09:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755794994; x=1756399794; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f7t2f88agrRS1B1iAJwzfiSnfOHeW10+a3UdQ2eynTw=;
        b=jlFkCIyJdPpZp9cv+wThVfw5O3orf1muAxV2u0PVlNil7seqL05MYWkIEBTa5EFjkx
         uV7AVMBx0QlkCy4EbzpMv3efd6/cg3FV3IH3527/sBSLgGqzhYKa+YRWXHUsFYyrBDLl
         BzQcew4upZu1zdMygKRHvRAm+fIrFwLFbzTNKpMcgnnbkwobasmomV8PjhpiOIEDLdwB
         jCBewRos8cBCfprZbjixzuy+X4F+esGnzXcjKNEqKlPHWRAVglCj9MQhGXx3fqVG/hwr
         ZP+yXrQPZEhpb6NVtOq+INnLbFsXtnwZSvKQL3f1FLCvfGQNfjHSlbuXdM0iPF/pWP7B
         jDZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755794994; x=1756399794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f7t2f88agrRS1B1iAJwzfiSnfOHeW10+a3UdQ2eynTw=;
        b=FpE5p9cI4fSUWEzsqi2xdybi7ksQPBBqalWZg7bXJyNnz5/C+5QhvL8e6nM8xLx4f4
         zIo7rOyJ57R3FtPx+8AzTAcrqtLw4BJ+DxsCx0O1eFqcCRlxaxfHLNqSkxe8doYOl0px
         zfMJd43yNmsjqhNRve3vh8+Rl29HWdYKDQ5E8mBQyNJKHmP+23Ii4c+CDlqnbnDTnGoI
         o3wobDner8aBwxreMOEY6DFHaUA44OQVZd7hUBibU11t8aHm31EBOUJzsa277773tlUa
         a4Zj9f+3I94TbjPzp2BtPX7czVCRfdQ/JpHERAjABXhcq5pDmXREj32Va4vDMn0u4xQs
         JOfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgTh+38llosaYvM85oT9QcwSb0BcsXkIpqPit/++ZZ8IgZu6IQcZgjtMe2RA6IeSrdkkAIriSWGh78xQ==@vger.kernel.org, AJvYcCW0h0Rn0erMGEh7sJc42PjL2kGxq0FkDnDCJtIFo5bcAOAq2W+NkyOzyNubmxoVtwNvZvlGTfsw6XqfCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwmnwRslLd4TJXZPDiFrU4XW9YSPuhlkW40xGlg166fCj92VU/Z
	KupWrEqyoxAXAOQ6heoCzm51Hx0d28n1OR6IX1du8x29OMOYW2w5yL0=
X-Gm-Gg: ASbGncsZzaEJhP6geWcD/2ml3/J3V5+dktrzio+ib4ivQZZjXawH8pTPCbiv52Klnyd
	RFcMBZ0ZCu3nQ5ESIrLNPvsFH3znlux39uqWnZHcBdncrQ4cgYGwIp2eZupmZ5fC0VsXeXZHEtF
	WjRNY14AHoqv1Oo6qaAAjyI9nZGYItjlEbEoOL5HutJs5QUsz85WJDWd6KUW0fmL+0DLlqFbcI8
	PuuNE8EU0ntivhS2fST0BF/A1UUQYj+I2cnCLHQIJ3K8tTTA408erjLHxLjPqKxaGhz5L7oe84z
	/eMPX8C4Kz3Kdsk3Va0H56418gxsEf5qPCB6Vh8kgAiLVdeHh9hTGUYEl9XogYLZdvybek/25iC
	qZXx/oQ7hn+mYZdTJqNtuvA/gvLXdDDx2o3QVv+I43/+yoqkHT3rbDXoVvZdE
X-Google-Smtp-Source: AGHT+IEFCzGcsgNZSCK8jgQNmnNP6XuCcbIjfi+E7Ny9nmr/AplG4StiUki6eZCbqEcqFRU22rFM4Q==
X-Received: by 2002:a05:600c:a16:b0:459:ddd6:1cbf with SMTP id 5b1f17b1804b1-45b4d74b053mr15281275e9.0.1755794993528;
        Thu, 21 Aug 2025 09:49:53 -0700 (PDT)
Received: from localhost (67.red-80-39-24.staticip.rima-tde.net. [80.39.24.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b50dea2b9sm3562025e9.15.2025.08.21.09.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 09:49:53 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Daniel Wagner <dwagner@suse.de>,
	Daniel Wagner <wagi@monom.org>,
	BLOCK-ML <linux-block@vger.kernel.org>,
	NVME-ML <linux-nvme@lists.infradead.org>,
	SCSI-ML <linux-scsi@vger.kernel.org>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] nvme-cli: add 80-nvmf-storage_arrays.rules
Date: Thu, 21 Aug 2025 18:49:51 +0200
Message-ID: <20250821164952.148153-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Missing from previous patch.

Cc: Daniel Wagner <dwagner@suse.de>
Cc: Daniel Wagner <wagi@monom.org>
Cc: BLOCK-ML <linux-block@vger.kernel.org>
Cc: NVME-ML <linux-nvme@lists.infradead.org>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 meson.build  | 1 +
 nvme.spec.in | 1 +
 2 files changed, 2 insertions(+)

diff --git a/meson.build b/meson.build
index 3afd8ba3..8c0877e1 100644
--- a/meson.build
+++ b/meson.build
@@ -270,6 +270,7 @@ udev_files = [
   '71-nvmf-hpe.rules',
   '71-nvmf-netapp.rules',
   '71-nvmf-vastdata.rules',
+  '80-nvmf-storage_arrays.rules',
 ]
 
 foreach file : udev_files
diff --git a/nvme.spec.in b/nvme.spec.in
index 5f7645d7..fa921f81 100644
--- a/nvme.spec.in
+++ b/nvme.spec.in
@@ -36,6 +36,7 @@ touch %{buildroot}@SYSCONFDIR@/nvme/hostid
 @UDEVRULESDIR@/71-nvmf-hpe.rules
 @UDEVRULESDIR@/71-nvmf-netapp.rules
 @UDEVRULESDIR@/71-nvmf-vastdata.rules
+@UDEVRULESDIR@/80-nvmf-storage_arrays.rules
 @DRACUTRILESDIR@/70-nvmf-autoconnect.conf
 @SYSTEMDDIR@/nvmf-connect@.service
 @SYSTEMDDIR@/nvmefc-boot-connections.service
-- 
2.51.0

