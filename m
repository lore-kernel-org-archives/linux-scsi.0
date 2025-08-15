Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9908224469B
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 20:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755289299; cv=none; b=q5c+XFrw8vAsUxkvui35v+MTO1nv8RDcc8nKuL/vozbVPb+fdTpYCLeqozf3l6wSyH4K92X4CvIafK6L/HD5yyVh5xTi4u9FY9tcGV2CjimZxDX75ofC/Z2fFuAHss5Sv9x8LIE2FhmFuMnIbJRyhUNhQRwczgTCuPPNRXKjIjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755289299; c=relaxed/simple;
	bh=tQr7WRhH8Zba8Vjdrrkzh7Y/7f/EOmeJuAq9zCW2Kgs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YvcJHTAKC7toOsQHApEKxwUYM1iUIFBbnNrmQWMZL5OchlIrl2iGvIi6CWELuM+x9D8RZiaVFcAneNjdj2C4RKfoKyMs++oiIwL7PcbhFY3yWRhZzr/6cevdKa/xde+sCqUCKhFXxQtRONXr/vVzC2byCBcEhcYVjUWgL0VcYkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B7Sju2lE; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B7Sju2lE"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b9d41d6e34so51717f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 13:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755289295; x=1755894095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5Ylcn4Wco/h8ojb6qCegLZ80xxCJcrayUH2qQLbr8Hc=;
        b=B7Sju2lEgtNGWu5/B1F4ea3zXMl3gPGoTBkaSACVgStap76jQPJmRLyIJoHhtFNDkm
         4/s3OQOShty1omSdEoY0efhYoPw0JxNtW79FJrqWaCs/FksdAVMS02vPVuO2KioBj87I
         O/N45K0BL5DsWQFt0qAN2vDUAoptLcYcXOEapw5xhvvShidebkqtnrx45ZmPDpP2ChkU
         0rFvBqLVF7ZZPDX9CFFbhuBEy5WKEUWYfe8Pf9EvJEzXxujnPRasAxioq6roFXtILgZq
         R7O7QWKZnwtZTwzoQlbd+EqcXkCx3WR7aue5GC70kOGhXMCsWzxJlUYyuu9ymTEPwlYa
         1Zhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755289295; x=1755894095;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Ylcn4Wco/h8ojb6qCegLZ80xxCJcrayUH2qQLbr8Hc=;
        b=WIOKprQ36pYLEZAYzwNQYUS7gZ5XHTCU6/U/eGb1sE71MESMUlc64Vu3ywtDClJdXq
         3lum6AqogLTMkFznuCCE4ccJgs571MAwXLz6sG+rrFM15RT5N+IhJjHQLdZ8wz6mYl+U
         NpBTyfOsAIfGYiE3GhKje3Dn+UOSac2ao+xHbsM0imgfpH9gzemZKr+zbzv7RHMhmJ/N
         qfWheynsSxEYFsq+eIeD3SIcmIg9YdPfD//t7hTCPYIYpvvQELgOmPN7T4QfoQ5jLHXX
         S/zCATsXZDodoLguHDC/SSFRW1ckjOZcNJmlnWQojeO0r7eMJqm3KAuyRT/BgxuPwXut
         mOKw==
X-Forwarded-Encrypted: i=1; AJvYcCVJp7ms09OgSKxd7VQGf44AYl4UzUKIeaDZpNEPFURcf/5g39kOPcKaGAscfHN83l3fCGrqXwVXouhE@vger.kernel.org
X-Gm-Message-State: AOJu0YwPMaVzbRLUAVUnyPmRRZHpycASCh3U//40c+i8uo1HZQpXJ470
	B8+SkW3IqfIIDrAz3zY31iNcBeIku0KTwDEl6zWko41keLv1dVhBtOY=
X-Gm-Gg: ASbGncthFVwxhJn9kJ1vNBqAuA6sXU21AySS3c1MfabMWwma2b2sW285MK+4yeX1rEB
	JrPKBKQPO0dYTK52WEgfxT/wThGei1gyEFAV9ZAhPC0aQ+JhVGHmRNxqp3KzPUrnzf38CSAvd43
	m1rxYQUFTWfR5wCrXFMzj+q5eSvcdD+6Q2AjLZuNawLSL75ENUUbBLRuixqftVKF8Jm9dOxVzPk
	UTkSWm+fijU8voh8Ozh/NtRk2ZA39TEUYtq0fYt4Qk49OYFCC5vxecJVpK4sEc2wniMe0tDusZl
	RAR9+YIvHVYV+lq4wkmK87aFeVWbJAqdnP0kEwfuKtTCIfrMs7UfjtzCMekLV8UFPjbYfxCacqu
	xsl77z+0XE9DfzUUOLkdVpKpAGD5AtqjU3CAHwT3EytNRcKXDiM55Yk0O+pki
X-Google-Smtp-Source: AGHT+IFljB5Ln/Tudt+a3E5R8ncefZQrJRNisqhDoxJaiqKOizwRXTpFBYvPTGGTkK7LobAriER9EQ==
X-Received: by 2002:a05:600c:1911:b0:458:bb2b:d74a with SMTP id 5b1f17b1804b1-45a21895d32mr12468775e9.5.1755289294539;
        Fri, 15 Aug 2025 13:21:34 -0700 (PDT)
Received: from localhost (67.red-80-39-24.staticip.rima-tde.net. [80.39.24.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c78c221sm74372375e9.26.2025.08.15.13.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 13:21:34 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Wayne Berthiaume <Wayne.Berthiaume@dell.com>,
	Vasuki Manikarnike <vasuki.manikarnike@hpe.com>,
	Martin George <marting@netapp.com>,
	NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
	Zou Ming <zouming.zouming@huawei.com>,
	Li Xiaokeng <lixiaokeng@huawei.com>,
	Randy Jennings <randyj@purestorage.com>,
	Thomas Song <tsong@purestorage.com>,
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
	Simon Schricker <sschricker@suse.de>,
	Daniel Wagner <dwagner@suse.de>,
	Daniel Wagner <wagi@monom.org>,
	Hannes Reinecke <hare@suse.de>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	NVME-ML <linux-nvme@lists.infradead.org>,
	SCSI-ML <linux-scsi@vger.kernel.org>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] nvme-cli: nvmf-autoconnect: udev-rule: add a file for new arrays
Date: Fri, 15 Aug 2025 22:21:32 +0200
Message-ID: <20250815202133.51160-1-xose.vazquez@gmail.com>
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


And it is unnecessary to set ctrl_loss_tmo to -1 for NVMe/TCP devices,
because it is the default.


Cc: Wayne Berthiaume <Wayne.Berthiaume@dell.com>
Cc: Vasuki Manikarnike <vasuki.manikarnike@hpe.com>
Cc: Martin George <marting@netapp.com>
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: Li Xiaokeng <lixiaokeng@huawei.com>
Cc: Randy Jennings <randyj@purestorage.com>
Cc: Thomas Song <tsong@purestorage.com>
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
Cc: Simon Schricker <sschricker@suse.de>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Daniel Wagner <wagi@monom.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
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
 .../80-nvmf-storage_arrays.rules.in           | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in

diff --git a/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
new file mode 100644
index 00000000..a2c952a5
--- /dev/null
+++ b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
@@ -0,0 +1,33 @@
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
+## Pure
+# FlashArray
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="Pure Storage FlashArray"
+ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="Pure Storage FlashArray"
+
+
+##### EOF
-- 
2.50.1
