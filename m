Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B4E31AF17;
	Tue, 19 Aug 2025 11:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755602208; cv=none; b=szckAOnskoCrdT8qQ1T2vHHv4IrnJD82towNCQqoAvuDxNIc9hEuwR4XyJskQIkdCJaEVSTUDTK888iGIZZTt5vHU8D142IHbAYloBZiV9ifzWJ7tumJhgiyHjJXw+idRPaGt8jxqXpLn6TVAQGFTPrKh0rqzRJl7Q0AzLNC6HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755602208; c=relaxed/simple;
	bh=1RgqftUzP8ZOFs84dBFBrH5d9aSvLPHds2WeGJKYgNg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WXBtnVxS2p72V6D5no4U9HrjVQ44VVQfxXYRG5b4AACzg/5BG+7JiQrFIBZAiNRHkURW9lCK4+ESGPNvATeo+H75yTKNsQsiIZ1oCE0icoNM4eqbTkIm93De2Eisk/fwde0sYWqUnk51CgXWwiT3ox4n3TTg4aaGn/iGDmjM82g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fAApEIkT; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fAApEIkT"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45a1b09990aso1041735e9.2;
        Tue, 19 Aug 2025 04:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755602202; x=1756207002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ru0e4pqocRWcS1MvPzlktvsHunErnNzt0vSfk38dJZI=;
        b=fAApEIkTQ55JRjAiZlJPyM5oOHyMM4TlCVmhlqQrCX9Z2KEqXlI2HZozaFmWQGTPrv
         7uDocyKu5pAhev8zP/ULBgiC542HnyqubfsbhpzVUW4X1hrjZRv0mQLZ5E0MR0AlnOT3
         ATkT7ZEzd3WICZEI3SJeFWdr4E7BhTRkckiermqKwJ2Tk3bApRxgFJW9fI3vdH8Fc3R+
         zxAm+fPjCh3E+aBH8pueSoRJMVGyUVdEyGlHczfAu6s9mJpog1WyR2St2DzPb4c96toL
         ryFAQ5ArKCZPEiiHvupDy04a74IxTf3ZPQQ3JtcaxjWK0MHNv+OME8rPN8R2z1a72lSR
         eQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755602202; x=1756207002;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ru0e4pqocRWcS1MvPzlktvsHunErnNzt0vSfk38dJZI=;
        b=WVaJ5g0yoZ59itdrHCGv149Z76LahMvBPJ99kS4obY5FPIM5qEIWBrO1cKtbL1dUoC
         K0LMZdoqUcUpI3otGrsqWOLPLGB1K+ZNpWfuQdbzk8UCkUJifxrZu39QY/wKoA0KE3hZ
         CZkoGjuuMU0muTbjlylkdBu8gxEZLBXURm1CaT9JhMFPdAVJf3oIzRtDReMDwMzefftv
         79GzlLUODQ+bF3N/XY2GsSVhXQ+NLkZ2Ed9yiXGbrK5RuU02pJwZ+AhRxd7nB5HfDKvU
         TGVWe9qmlI6jeajlPAU1UglFN3V0dCuZ04Y3TQy/qliyKPKN65IG3kRlsxvxh4usgiJZ
         lijw==
X-Forwarded-Encrypted: i=1; AJvYcCXlWT2BKJfCG/qUV4q/aGWXWzvVbGoxsgA5BtO9jQqfyQVJvnngYXfZ5aLWDzBZZBTppvCZelpQQ+EDeg==@vger.kernel.org, AJvYcCXnYOt6Lx8/w2AzWwaNMye5Yb9uKB9bVg/YVEyopb/ZP9KO/CnMhMH3Gz6VU3nNvnT2ZVZf7uDuvD4TXg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4BMc+PKtVRTDvqT3MiOhg8U10Gs5e291nI3k58ir/NIWVgtJx
	XWxCKa/2salAbB2YkjNYvBDAJWd+QTsINX+eBNgt9eZlGb6l72VqGgk=
X-Gm-Gg: ASbGnctjqPjfTZMoE0lDj5DgO0SX51N2wfJHOndszkxHiAyAaEXjspelNWf1O6U/px0
	nqR80M8x/wD+UH6g6ohHZaPQWgeNpg0oyd2uEGR+6IOqluJV33hc0avKEuQ5ygs6xu6OiWF3+3s
	QYOjrIXKxw/OlBYtG4kl/KNHkY8iLlUQFhtJFxh53TgepNKcbha5lLlX2gOgnGvl2cTwKRuYKJp
	o8XWbwAQzIkrx1vfLIws6dGX43yuyIomL1txOMLltQWcwfT0kTh7cOqe6v9TWd035n4jirkPIFz
	zTxoIaIJ92zJxFa6zu/ipkBFTxZUCzsq3SrmyUK8t3HH9jUnHyvEhUGCOMslfcaNBjo17oXQa2H
	oNILSCxwFijVp6pgkDNBuIKCDNbMRdRROaXmddWBlij8SsUV65dPBN1BWblqJ
X-Google-Smtp-Source: AGHT+IEjJ0o5DGL4y9TOsIn9ugdBJNIj8kFoFW53rL7KFzsI7YsinGg3Plurh9O2DBq6QatfYXDUww==
X-Received: by 2002:a05:600c:1c92:b0:454:aac0:ce1e with SMTP id 5b1f17b1804b1-45b43e0086dmr8414275e9.4.1755602201497;
        Tue, 19 Aug 2025 04:16:41 -0700 (PDT)
Received: from localhost (67.red-80-39-24.staticip.rima-tde.net. [80.39.24.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c773e57sm222640615e9.23.2025.08.19.04.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 04:16:40 -0700 (PDT)
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
Subject: [PATCH v2] nvme-cli: nvmf-autoconnect: udev-rule: add a file for new arrays
Date: Tue, 19 Aug 2025 13:16:36 +0200
Message-ID: <20250819111638.252890-1-xose.vazquez@gmail.com>
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

Maybe these rules should be merged into this new file. ???
71-nvmf-hpe.rules.in
71-nvmf-netapp.rules.in
71-nvmf-vastdata.rules.in

---
 .../80-nvmf-storage_arrays.rules.in           | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in

diff --git a/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
new file mode 100644
index 00000000..ceabba31
--- /dev/null
+++ b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
@@ -0,0 +1,38 @@
+##### Storage arrays
+
+#### Set iopolicy for NVMe-oF
+### iopolicy: numa, round-robin (>=5.1), or queue-depth (>=6.11)
+
+## Dell EMC
+# PowerMax
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="EMC PowerMax"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="EMC PowerMax"
+# PowerStore
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="dellemc-powerstore"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="dellemc-powerstore"
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

