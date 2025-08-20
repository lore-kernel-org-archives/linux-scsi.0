Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558F92D6E70;
	Wed, 20 Aug 2025 21:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755725581; cv=none; b=tC9jMfV8ulFWg/5ncWY1TTep6FzQI+YN+UteYbHJAK7i9tyknEc7mkyOV80bakSyuN6pisuw2SKXlvHAUiZrIreiyxlNnCvSCdnbyT072e32ZhG+3j40zVDC+KZdIfGqSJ+eySgYAfccliCQsE/kJA4sh+hfiDdq55pFf92+CO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755725581; c=relaxed/simple;
	bh=PoKQrv5do0Psn+aFwt6iUyMzmLElXRyjydzGPV6DSVc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WCtETLWuk2zXM0IDJK0SGb5Z9xWzt/C5gnY+mNksv9vDUayGU/KwwaeCdJiWb6JWmA2it1uuziTSXpe1kI+/CMyiJLKXJg+fqEgF4clixLYzXUuRhZhSHq2nZtS54lrevwnBd90SnESNjOE9i1uwMTIDt90Cf7pk+vKQ5DW0zL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bvnNfEgi; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bvnNfEgi"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3b9e4140f38so55439f8f.3;
        Wed, 20 Aug 2025 14:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755725576; x=1756330376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oBgF4OquzXHZJ3H0RI6thUlJhwBomlwAaCvZIMnO3U0=;
        b=bvnNfEgiVdgdSO23JvkSvtHBDEFIlpJeoFh81LIMcixbDYzJQNj0dUrg8JCeiBmg5E
         3mkTbmjskyvLc6JS2sQTX4oQwGJlIV7sLsAH7QG16sJO91TFdVwM1DJZF61IrwoC8u4o
         AKEGN1sqnZCXcjJmlOKFhzPj1OuEr2q/qrn3+pAiCbll1LcC4sGZYBCgluydqnRYt+CY
         zzHPYhy3oV6sfN0BqpOGo2ip41PlpePiV9TdBkiEWIBW632k16d/VDfYOBRREl5/MUVo
         eHdk1KmKsEslYR67qOuMrlMW7tIDFVOq4+ABklaZLGgugWozZY/i3C9dWrA1q+hoesiR
         01ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755725576; x=1756330376;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oBgF4OquzXHZJ3H0RI6thUlJhwBomlwAaCvZIMnO3U0=;
        b=tQ3cvtVIX1kE9ZiO390xDnQiB9NKD/BPns9sO6YPNGngYuQLSA47Bn6uIhakRBHRjw
         G100xDRsheIkeLU0dldfjB4dlAh1UuqYaoEucVuTlQVwKg6c3XaWwIV59e80U6BQML1r
         AaCwfhSlr5MWhCPkIgNacoyYeVf70/AkVy2QT207nR8wS/o+uAuGuJP9dJIsvFHH52UB
         LKNr+PemQ3eX1xGgfKPeCNAJdjibjpgYzfj5kndafDbfnt/A1/4XV32KC+ceR933IrqS
         PwMisQVbGjVJBOoUG96O/pCqmP6z3XhUxYBBkWQV5D0SXYtIQ3uRkybILirNZiyGGZp8
         LuHw==
X-Forwarded-Encrypted: i=1; AJvYcCU89d3LijFEJ3oUdc5/xREsOqj7D6YQUfzcgITlHv3Sd81IyJvbmgsQA0lSBkJpL/0H83RHRUHT6rqVeg==@vger.kernel.org, AJvYcCV32FfUMXG7iSwhS7w9jiF2q38HPwM2794WL253bUv3FKqCcJ3xrAxcyrODOaC7JjJAPwxFofUPUBXaRQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzugACfVRpfDP84CeimtwiTsorOLHQDJDwQE+utYR8W4pq+WyT4
	/kGxln08M2OZXyMy+q+4LDzBh3wJlmHia8vwEt7W4kwAzANUrzo3TyI=
X-Gm-Gg: ASbGncsoI519nl+O/hpo1BwDInG21D2B8OnJVDyyd3eIiMaB9AXArRfUPXe1zIteQhf
	KqLqUxHT1PuSh87p+Llwic0xmH08w84X4JKTnbWldIT9+PMfCP8MNrvqeLQLOP1rgNt0YenKfgA
	NScoOwlghNPjpBnaN9VJt0tSuDwhr63rhCAzNxmZ+y7LC5790NInFokkn5UfrMVuSmyAiPbRqUS
	1mgd5/hRccNjN8aaNbfXsUNIciKmWP7B8XuED6iAO54QXkZQigfGnG0pE0u3IlhH9/0NJTV3pxF
	ogRrwQV4mn8RmlO+Vz9sw9JzDfv16dEbxHhFfzHGeadQZwJ4Y+EBrGkMNjlsJTWdUR7kuasqGeD
	+NLjoo00aB4AQdZZs4W5+9EyUAZUuBqDRWgX97e1RLD15GMcUevNdkTodNOSw4WaHPFhaWB4=
X-Google-Smtp-Source: AGHT+IFpaHt+QNsQklADoGadGLHhabEswBSBpdvkzZPtjH45BGr00qhJfUN625Zw9+3cWWc9heSYhA==
X-Received: by 2002:a05:600c:4f83:b0:459:db79:2102 with SMTP id 5b1f17b1804b1-45b4d86bfd7mr76075e9.7.1755725576267;
        Wed, 20 Aug 2025 14:32:56 -0700 (PDT)
Received: from localhost (67.red-80-39-24.staticip.rima-tde.net. [80.39.24.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b47c54c8fsm47614545e9.16.2025.08.20.14.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 14:32:55 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Wayne Berthiaume <Wayne.Berthiaume@dell.com>,
	Vasuki Manikarnike <vasuki.manikarnike@hpe.com>,
	Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
	Martin George <marting@netapp.com>,
	NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
	Zou Ming <zouming.zouming@huawei.com>,
	Li Xiaokeng <lixiaokeng@huawei.com>,
	Randy Jennings <randyj@purestorage.com>,
	Jyoti Rani <jrani@purestorage.com>,
	Brian Bunker <brian@purestorage.com>,
	Uday Shankar <ushankar@purestorage.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Marco Patalano <mpatalan@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Daniel Wagner <wagi@monom.org>,
	Hannes Reinecke <hare@suse.de>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	BLOCK-ML <linux-block@vger.kernel.org>,
	NVME-ML <linux-nvme@lists.infradead.org>,
	SCSI-ML <linux-scsi@vger.kernel.org>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v3] nvme-cli: nvmf-autoconnect: udev-rule: add a file for new arrays
Date: Wed, 20 Aug 2025 23:32:53 +0200
Message-ID: <20250820213254.220715-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

One file per vendor, or device, is a bit excessive for two-four rules.


If possible, select round-robin (>=5.1), or queue-depth (>=6.11).
round-robin is a basic selector, and only works well under ideal conditions.

A nvme benchmark, round-robin vs queue-depth, shows how bad it is:
https://marc.info/?l=linux-kernel&m=171931850925572
https://marc.info/?l=linux-kernel&m=171931852025575
https://github.com/johnmeneghini/iopolicy/?tab=readme-ov-file#sample-data
https://people.redhat.com/jmeneghi/ALPSS_2023/NVMe_QD_Multipathing.pdf


[ctrl_loss_tmo default value is 600 (ten minutes)]


v3:
 - add Fujitsu/ETERNUS AB/HB
 - add Hitachi/VSP

v2:
 - fix ctrl_loss_tmo commnent
 - add Infinidat/InfiniBox


Cc: Wayne Berthiaume <Wayne.Berthiaume@dell.com>
Cc: Vasuki Manikarnike <vasuki.manikarnike@hpe.com>
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Martin George <marting@netapp.com>
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: Li Xiaokeng <lixiaokeng@huawei.com>
Cc: Randy Jennings <randyj@purestorage.com>
Cc: Jyoti Rani <jrani@purestorage.com>
Cc: Brian Bunker <brian@purestorage.com>
Cc: Uday Shankar <ushankar@purestorage.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marco Patalano <mpatalan@redhat.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: John Meneghini <jmeneghi@redhat.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Daniel Wagner <wagi@monom.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: BLOCK-ML <linux-block@vger.kernel.org>
Cc: NVME-ML <linux-nvme@lists.infradead.org>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---

This will be the last iteration of this patch, there are no more NVMe storage
array manufacturers.


Maybe these rules should be merged into this new file. ???
71-nvmf-hpe.rules.in
71-nvmf-netapp.rules.in
71-nvmf-vastdata.rules.in

---
 .../80-nvmf-storage_arrays.rules.in           | 48 +++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in

diff --git a/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
new file mode 100644
index 00000000..ac5df797
--- /dev/null
+++ b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
@@ -0,0 +1,48 @@
+##### Storage arrays
+
+#### Set iopolicy for NVMe-oF
+### iopolicy: numa (default), round-robin (>=5.1), or queue-depth (>=6.11)
+
+## Dell EMC
+# PowerMax
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="EMC PowerMax"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="EMC PowerMax"
+# PowerStore
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="dellemc-powerstore"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="dellemc-powerstore"
+
+## Fujitsu
+# ETERNUS AB/HB
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="Fujitsu ETERNUS AB/HB Series"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="Fujitsu ETERNUS AB/HB Series"
+
+## Hitachi Vantara
+# VSP
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="HITACHI SVOS-RF-System"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="HITACHI SVOS-RF-System"
+
+## Huawei
+# OceanStor
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="Huawei-XSG1"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="Huawei-XSG1"
+
+## IBM
+# FlashSystem (RamSan)
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="FlashSystem"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="FlashSystem"
+# FlashSystem (Storwize/SVC)
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="IBM*214"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="IBM*214"
+
+## Infinidat
+# InfiniBox
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="InfiniBox"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="InfiniBox"
+
+## Pure
+# FlashArray
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="Pure Storage FlashArray"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="Pure Storage FlashArray"
+
+
+##### EOF
-- 
2.50.1

