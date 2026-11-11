Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422337;
	b=wwQwzKotFd9pVlSbgJ6Wl7ylKLEdpETPcLbcOE22QS5/Y6buGeRyBxNvGsS27PN+Vyv5
	 2DL+ZPsqEUPTPzhFCjtYB3jZJpRjSw6lmatC8ih0giw5GsZK1JrZnb31vBIn899FLvu4Z
	 4aAbDBfbRyiCbguhJwbMJhDGy3u9gnHxJL5kiS81JIzCzaeMY40yMmSbgNlsPcN/lBlJ/
	 Fk3gA8zgkT1fpAlis0bd02X0srUFu8kS+dvGuklFPM2K6+HhZtDqjF0TcBc4gIIb5TeMr
	 eJpD9h/4BSWdwmCNmyF8Gp51VwqtYbUKk4drIe35kcdAMPn5AaP0x95ZKAsS7zd6LDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422337;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding;
	bh=F7ALA26NgTOpZK5QKHI9q8CAj4FJwa+1TITgbPyYNaE=;
	b=VIZVkUVH7jEpNZyXwY6CG5TGM+xJ9wIhyewPLaIN/W0co2ts6bcSK4Pd5c1lSR09/3Q3
	 snkdR1vFdo/PnQB/p/CnREXeFjvS9/Pqv2QJs/M3eAgPhlxYWXQKII//hKOzf7vZXgggq
	 x6ZPzY6t4Eaj1CTcNQHKJ6b3vb/MrLQzyMqEArm4Dq16o9SHSiR9Txdxy94L6WFUUUc+s
	 Dd0DJ2oxSS2DYCzUVtJyjW6XM7ySlS5s+3WbIixvQcGR8tP4mxQrmg/+K07RmRovRpnNC
	 ZxBIlU+hhR/6wP+Y+tL/9SM6Uts+kvQf/coW0CEMnFNW7ekr/UeZMrWAgikGdMl18bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=baylibre.com;
	spf=pass smtp.mailfrom=baylibre.com;
	dkim=pass header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b="TRCW6s/m";
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE86606A334
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 18:38:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FE86606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=TRCW6s/m
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4b467581b98so32103855e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 10:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1794422334; x=1795027134; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F7ALA26NgTOpZK5QKHI9q8CAj4FJwa+1TITgbPyYNaE=;
        b=TRCW6s/mlpBOrMd0eliUrR6FcgmJDpiXNmIRe5YEmWTLt7XqwhI3Wef0YrU0ahuJQr
         nmZr5gnQgkDIqGYmlkO7S5qYgd1E1HI00OxBz1shZntbQD0p0NqEFuWwmVFnmTeNBmu1
         JTYEfaZQ2Z6y9ma06v0fztmFn77VUWklTM4zNsNNZF/5f8+hNeD7IPn1aEgSoO5WlKqD
         Pgn+W+NrsDpNIMgu6vgzDzmEZKYNGZCIfNse4VqQZderEADWWMQZKvTGVRINspfHRiQS
         fUipPM7Fvr2mlOD96eT+tJirHT+VZ+7Oo4IoClmoDH74agoSI1Cm2F1u6tMzc2Y03g6g
         4xmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794422334; x=1795027134;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F7ALA26NgTOpZK5QKHI9q8CAj4FJwa+1TITgbPyYNaE=;
        b=YugLS2kk4oE6ae8l9VZQXwR68zIO53RbOLrFtBX5keLL9SKt/kx2545fkEsfg/Yr7n
         woNSlTq6Rxj6FhhKpYvdI5nKDi5ixfYahKT74nAN04NQLCYTupij9vs9CrD1daeN2fYA
         UTpabYpex1S+68x0pJzi4RoDPPsks3dg7yiEhuly4jTXv0buFlN3h4bcvqYp63UhMZ/7
         DGutyCCacCu3cmLcouciaI1AHAWUsCK2uxTLXoFPG/6e8yUhi7xe8Hh+gQrUnKGML3kn
         4f95wpW4KH7Rj/piZUdAmLG8l8IcEAMIR8DYm48sBb+8XUVnPKkBiSlQW1MdhEqKQURW
         GtmQ==
X-Forwarded-Encrypted: i=1; AL+hErH6EvymE6tR/vwojJm2jUv3NPfSiJ9llADjisj6ULlmhoyPcikmc+awtcf07GTsBhT6NcCzdepnfdN6@vger.kernel.org
X-Gm-Message-State: APuU4Z8C7BfqW6eeUnhA+sykwPLz5J+6b81BFa0nONRYOc7jTjarnD+T
	uwACWiNg1QCVUYwINjwtzDBwGdQkUQW8E44a5TEr6aCaenKRbxCjsy2sBnoyVifkSvEQ5JHYd3x
	M0SVmF6MuEQ==
X-Gm-Gg: AYBFou30dz0XiRJWYEx/7wfLwiJIGmbeWgIyn1672bA8es9FY2Cg+b/5ROgRNG9UOD4
	7QFzNBMWp5xS/K5o4DoKGYjYzd9TyeCo8/NApBw2GWTtBVwQAnEBKN7IcjopAhS8V4LIeowOTOu
	ukl13niV5Ug5fwGRV3xM1p9oOx3GK6bsBxclpGrQo6QkHO0NTYA/D3BQ1jZk3ud2mEyrUFIS78h
	3S4XjD2y21DjpaKARrvx1eR9Jvfd8uc0arcIpuXZr1ILiiIE3wGSXjz+rx1WKEC51j1RiIop+hy
	N+gKytquNRCpIW+8qqCbTh9yR9N9l5cGx9dxiN75DgLJXe1RR4v8q5pvnrzoPcOHmV1B7BTagqc
	KuGCDTWrrMVcXApH9LPNPOIiaiKuNo0oF8ZFf1KpDjuHLwaXgqBgn9JtK+Ynjhs9JPss9Jq6Av2
	U1pBuS6TTzO0s/C+WggIvkrxs9VwpwX/Y8/NxKOuUT01iZq13Jdm+b+mKot//BBtQ5mUzC/K9pg
	HFRm5dQMo6q8Oqx75IjqcA8pRkhB/SQ9xtajFrg8+AjSo0SW5j8M0sp0cs4nkMfayPE7+B/AyMk
	8xuxmbu1slNE7Y2LrXTMPacc487j0StlJ1Cw03acpguiNrY6ut4H24CeSPjKExj4InuudmNhkPn
	qgkcZ7BHXm5AHNfDv
X-Received: by 2002:a05:600c:4e0e:b0:4a8:b8b4:6226 with SMTP id 5b1f17b1804b1-4ba093ae6f2mr57568095e9.28.1794422333335;
        Wed, 11 Nov 2026 10:38:53 -0800 (PST)
Received: from localhost (p200300f65f19a9045674a4e2f3db58c3.dip0.t-ipconnect.de. [2003:f6:5f19:a904:5674:a4e2:f3db:58c3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4bb4e26700fsm7495835e9.10.2026.11.11.10.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 10:38:52 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Adam Radford <aradford@gmail.com>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	Don Brace <don.brace@microchip.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Brian King <brking@us.ibm.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Kees Cook <kees@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Duoming Zhou <duoming@zju.edu.cn>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	target-devel@vger.kernel.org,
	storagedev@microchip.com,
	megaraidlinux.pdl@broadcom.com,
	Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH RESEND] scsi: Consistently define pci_device_ids using named initializers
Date: Wed, 11 Nov 2026 19:38:43 +0100
Message-ID: <20261111183844.1906794-2-u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.56.0.rc1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=75887; i=u.kleine-koenig@baylibre.com; h=from:subject; bh=i+8hcZ7wr6neLqeciPzwQddgzrJKEKeNBFV+3gwMIg4=; b=owGbwMvMwMXY3/A7olbonx/jabUkhqwv20yCuCwcQq0mLLhut6p8r6eJoYs/l1pudH2L2Cvth 4n2SmGdjMYsDIxcDLJiiiz2jWsyrarkIjvX/rsMM4iVCWQKAxenAEwk9Df7/6yElLqCO5qzXgU5 aNiJ32OTCGC80dnLrFv2aHHtopOdhhMyn5b9VpXW2B/nPn/Zd++fLDndu0wqb92OjrpzKuIOE5d iq8CGVL/9qUd3dbNVMjCfiv96xcrhXO3WgroLes09FXf139kmpIVv5CqNTjx37uuHjIY5oud2sy 4qLjrk/mCp5AOTeI2Mv46nxZ55zm20vVPSGOpUel3t45zsUyfPz/t9P/finYu2i/YU5G9z7LvDu /htYPWVjcf4s1htcnZN+1scxbj6ADtbSP/PnRN0S+YsNwv04w/L7HjV+c3v1pm9ZxmmdDu8a5zb Gp0vX/9YLmFHujVLxc7FPp0C7Zs1GuK9Z5Z6NB1ekOYPAA==
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

... and PCI device helpers.

The various struct pci_device_id arrays were initialized mostly by one
of the PCI_DEVICE macros and then list expressions. The latter isn't
easily readable if you're not into PCI. Using named initializers is more
explicit and thus easier to parse.

Also use PCI_DEVICE* helper macros to assign .vendor, .device,
.subvendor and .subdevice where appropriate and skip explicit
assignments of 0 (which the compiler takes care of).

The secret plan is to make struct pci_device_id::driver_data an
anonymous union (similar to
https://lore.kernel.org/all/cover.1776579304.git.u.kleine-koenig@baylibre.com/)
and that requires named initializers. But it's also a nice cleanup on
its own.

This change doesn't introduce changes to the compiled pci_device_id
arrays. Tested on x86 and arm64.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
Hello,

this patch was sent initially back in April with not maintainer feedback
despite several pings. So I'm trying with a resend now.

Best regards
Uwe

 drivers/scsi/3w-9xxx.c                 |  12 +-
 drivers/scsi/3w-xxxx.c                 |   6 +-
 drivers/scsi/a100u2w.c                 |   6 +-
 drivers/scsi/aacraid/linit.c           | 138 +++++------
 drivers/scsi/advansys.c                |  20 +-
 drivers/scsi/aic7xxx/aiclib.h          |   8 +-
 drivers/scsi/aic94xx/aic94xx_init.c    |  20 +-
 drivers/scsi/am53c974.c                |   3 +-
 drivers/scsi/csiostor/csio_init.c      |   4 +-
 drivers/scsi/dmx3191d.c                |   6 +-
 drivers/scsi/elx/efct/efct_driver.c    |   6 +-
 drivers/scsi/esas2r/esas2r_main.c      |  31 +--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |   4 +-
 drivers/scsi/hpsa.c                    | 118 +++++-----
 drivers/scsi/hptiop.c                  |  66 +++---
 drivers/scsi/initio.c                  |  12 +-
 drivers/scsi/ipr.c                     | 310 ++++++++++++++++---------
 drivers/scsi/megaraid.c                |  11 +-
 drivers/scsi/mvsas/mv_init.c           |  86 +++----
 drivers/scsi/pm8001/pm8001_init.c      | 243 +++++++++++++------
 drivers/scsi/pmcraid.c                 |   7 +-
 drivers/scsi/qla1280.c                 |  22 +-
 drivers/scsi/stex.c                    |  91 +++++---
 drivers/scsi/sym53c8xx_2/sym_glue.c    |  62 +++--
 24 files changed, 725 insertions(+), 567 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index e6694f242ebe..a89869c57da7 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2262,14 +2262,10 @@ static int __maybe_unused twa_resume(struct device *dev)
 
 /* PCI Devices supported by this driver */
 static const struct pci_device_id twa_pci_tbl[] = {
-	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9000,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9550SX,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9650SE,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9690SA,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9000) },
+	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9550SX) },
+	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9650SE) },
+	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9690SA) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, twa_pci_tbl);
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 11326465abb6..0b6335a373c4 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2395,10 +2395,8 @@ static void tw_remove(struct pci_dev *pdev)
 
 /* PCI Devices supported by this driver */
 static const struct pci_device_id tw_pci_tbl[] = {
-	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_1000,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_7000,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_1000) },
+	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_7000) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, tw_pci_tbl);
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 7e6776325d9b..3c8a8100741d 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1204,11 +1204,11 @@ static void inia100_remove_one(struct pci_dev *pdev)
         release_region(shost->io_port, 256);
 
 	scsi_host_put(shost);
-} 
+}
 
 static const struct pci_device_id inia100_pci_tbl[] = {
-	{PCI_VENDOR_ID_INIT, 0x1060, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0,}
+	{ PCI_VDEVICE(INIT, 0x1060) },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, inia100_pci_tbl);
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 2fa8f7ddb703..30d614cfcd22 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -74,80 +74,80 @@ char aac_driver_version[] = AAC_DRIVER_FULL_VERSION;
  * Because of the way Linux names scsi devices, the order in this table has
  * become important.  Check for on-board Raid first, add-in cards second.
  *
- * Note: The last field is used to index into aac_drivers below.
+ * Note: .driver_data is used to index into aac_drivers below.
  */
 static const struct pci_device_id aac_pci_tbl[] = {
-	{ 0x1028, 0x0001, 0x1028, 0x0001, 0, 0, 0 }, /* PERC 2/Si (Iguana/PERC2Si) */
-	{ 0x1028, 0x0002, 0x1028, 0x0002, 0, 0, 1 }, /* PERC 3/Di (Opal/PERC3Di) */
-	{ 0x1028, 0x0003, 0x1028, 0x0003, 0, 0, 2 }, /* PERC 3/Si (SlimFast/PERC3Si */
-	{ 0x1028, 0x0004, 0x1028, 0x00d0, 0, 0, 3 }, /* PERC 3/Di (Iguana FlipChip/PERC3DiF */
-	{ 0x1028, 0x0002, 0x1028, 0x00d1, 0, 0, 4 }, /* PERC 3/Di (Viper/PERC3DiV) */
-	{ 0x1028, 0x0002, 0x1028, 0x00d9, 0, 0, 5 }, /* PERC 3/Di (Lexus/PERC3DiL) */
-	{ 0x1028, 0x000a, 0x1028, 0x0106, 0, 0, 6 }, /* PERC 3/Di (Jaguar/PERC3DiJ) */
-	{ 0x1028, 0x000a, 0x1028, 0x011b, 0, 0, 7 }, /* PERC 3/Di (Dagger/PERC3DiD) */
-	{ 0x1028, 0x000a, 0x1028, 0x0121, 0, 0, 8 }, /* PERC 3/Di (Boxster/PERC3DiB) */
-	{ 0x9005, 0x0283, 0x9005, 0x0283, 0, 0, 9 }, /* catapult */
-	{ 0x9005, 0x0284, 0x9005, 0x0284, 0, 0, 10 }, /* tomcat */
-	{ 0x9005, 0x0285, 0x9005, 0x0286, 0, 0, 11 }, /* Adaptec 2120S (Crusader) */
-	{ 0x9005, 0x0285, 0x9005, 0x0285, 0, 0, 12 }, /* Adaptec 2200S (Vulcan) */
-	{ 0x9005, 0x0285, 0x9005, 0x0287, 0, 0, 13 }, /* Adaptec 2200S (Vulcan-2m) */
-	{ 0x9005, 0x0285, 0x17aa, 0x0286, 0, 0, 14 }, /* Legend S220 (Legend Crusader) */
-	{ 0x9005, 0x0285, 0x17aa, 0x0287, 0, 0, 15 }, /* Legend S230 (Legend Vulcan) */
+	{ PCI_DEVICE_SUB(0x1028, 0x0001, 0x1028, 0x0001), .driver_data = 0 }, /* PERC 2/Si (Iguana/PERC2Si) */
+	{ PCI_DEVICE_SUB(0x1028, 0x0002, 0x1028, 0x0002), .driver_data = 1 }, /* PERC 3/Di (Opal/PERC3Di) */
+	{ PCI_DEVICE_SUB(0x1028, 0x0003, 0x1028, 0x0003), .driver_data = 2 }, /* PERC 3/Si (SlimFast/PERC3Si */
+	{ PCI_DEVICE_SUB(0x1028, 0x0004, 0x1028, 0x00d0), .driver_data = 3 }, /* PERC 3/Di (Iguana FlipChip/PERC3DiF) */
+	{ PCI_DEVICE_SUB(0x1028, 0x0002, 0x1028, 0x00d1), .driver_data = 4 }, /* PERC 3/Di (Viper/PERC3DiV) */
+	{ PCI_DEVICE_SUB(0x1028, 0x0002, 0x1028, 0x00d9), .driver_data = 5 }, /* PERC 3/Di (Lexus/PERC3DiL) */
+	{ PCI_DEVICE_SUB(0x1028, 0x000a, 0x1028, 0x0106), .driver_data = 6 }, /* PERC 3/Di (Jaguar/PERC3DiJ) */
+	{ PCI_DEVICE_SUB(0x1028, 0x000a, 0x1028, 0x011b), .driver_data = 7 }, /* PERC 3/Di (Dagger/PERC3DiD) */
+	{ PCI_DEVICE_SUB(0x1028, 0x000a, 0x1028, 0x0121), .driver_data = 8 }, /* PERC 3/Di (Boxster/PERC3DiB) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0283, 0x9005, 0x0283), .driver_data = 9 }, /* catapult */
+	{ PCI_DEVICE_SUB(0x9005, 0x0284, 0x9005, 0x0284), .driver_data = 10 }, /* tomcat */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x0286), .driver_data = 11 }, /* Adaptec 2120S (Crusader) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x0285), .driver_data = 12 }, /* Adaptec 2200S (Vulcan) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x0287), .driver_data = 13 }, /* Adaptec 2200S (Vulcan-2m) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x17aa, 0x0286), .driver_data = 14 }, /* Legend S220 (Legend Crusader) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x17aa, 0x0287), .driver_data = 15 }, /* Legend S230 (Legend Vulcan) */
 
-	{ 0x9005, 0x0285, 0x9005, 0x0288, 0, 0, 16 }, /* Adaptec 3230S (Harrier) */
-	{ 0x9005, 0x0285, 0x9005, 0x0289, 0, 0, 17 }, /* Adaptec 3240S (Tornado) */
-	{ 0x9005, 0x0285, 0x9005, 0x028a, 0, 0, 18 }, /* ASR-2020ZCR SCSI PCI-X ZCR (Skyhawk) */
-	{ 0x9005, 0x0285, 0x9005, 0x028b, 0, 0, 19 }, /* ASR-2025ZCR SCSI SO-DIMM PCI-X ZCR (Terminator) */
-	{ 0x9005, 0x0286, 0x9005, 0x028c, 0, 0, 20 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
-	{ 0x9005, 0x0286, 0x9005, 0x028d, 0, 0, 21 }, /* ASR-2130S (Lancer) */
-	{ 0x9005, 0x0286, 0x9005, 0x029b, 0, 0, 22 }, /* AAR-2820SA (Intruder) */
-	{ 0x9005, 0x0286, 0x9005, 0x029c, 0, 0, 23 }, /* AAR-2620SA (Intruder) */
-	{ 0x9005, 0x0286, 0x9005, 0x029d, 0, 0, 24 }, /* AAR-2420SA (Intruder) */
-	{ 0x9005, 0x0286, 0x9005, 0x029e, 0, 0, 25 }, /* ICP9024RO (Lancer) */
-	{ 0x9005, 0x0286, 0x9005, 0x029f, 0, 0, 26 }, /* ICP9014RO (Lancer) */
-	{ 0x9005, 0x0286, 0x9005, 0x02a0, 0, 0, 27 }, /* ICP9047MA (Lancer) */
-	{ 0x9005, 0x0286, 0x9005, 0x02a1, 0, 0, 28 }, /* ICP9087MA (Lancer) */
-	{ 0x9005, 0x0286, 0x9005, 0x02a3, 0, 0, 29 }, /* ICP5445AU (Hurricane44) */
-	{ 0x9005, 0x0285, 0x9005, 0x02a4, 0, 0, 30 }, /* ICP9085LI (Marauder-X) */
-	{ 0x9005, 0x0285, 0x9005, 0x02a5, 0, 0, 31 }, /* ICP5085BR (Marauder-E) */
-	{ 0x9005, 0x0286, 0x9005, 0x02a6, 0, 0, 32 }, /* ICP9067MA (Intruder-6) */
-	{ 0x9005, 0x0287, 0x9005, 0x0800, 0, 0, 33 }, /* Themisto Jupiter Platform */
-	{ 0x9005, 0x0200, 0x9005, 0x0200, 0, 0, 33 }, /* Themisto Jupiter Platform */
-	{ 0x9005, 0x0286, 0x9005, 0x0800, 0, 0, 34 }, /* Callisto Jupiter Platform */
-	{ 0x9005, 0x0285, 0x9005, 0x028e, 0, 0, 35 }, /* ASR-2020SA SATA PCI-X ZCR (Skyhawk) */
-	{ 0x9005, 0x0285, 0x9005, 0x028f, 0, 0, 36 }, /* ASR-2025SA SATA SO-DIMM PCI-X ZCR (Terminator) */
-	{ 0x9005, 0x0285, 0x9005, 0x0290, 0, 0, 37 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II) */
-	{ 0x9005, 0x0285, 0x1028, 0x0291, 0, 0, 38 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
-	{ 0x9005, 0x0285, 0x9005, 0x0292, 0, 0, 39 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
-	{ 0x9005, 0x0285, 0x9005, 0x0293, 0, 0, 40 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
-	{ 0x9005, 0x0285, 0x9005, 0x0294, 0, 0, 41 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
-	{ 0x9005, 0x0285, 0x103C, 0x3227, 0, 0, 42 }, /* AAR-2610SA PCI SATA 6ch */
-	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 43 }, /* ASR-2240S (SabreExpress) */
-	{ 0x9005, 0x0285, 0x9005, 0x0297, 0, 0, 44 }, /* ASR-4005 */
-	{ 0x9005, 0x0285, 0x1014, 0x02F2, 0, 0, 45 }, /* IBM 8i (AvonPark) */
-	{ 0x9005, 0x0285, 0x1014, 0x0312, 0, 0, 45 }, /* IBM 8i (AvonPark Lite) */
-	{ 0x9005, 0x0286, 0x1014, 0x9580, 0, 0, 46 }, /* IBM 8k/8k-l8 (Aurora) */
-	{ 0x9005, 0x0286, 0x1014, 0x9540, 0, 0, 47 }, /* IBM 8k/8k-l4 (Aurora Lite) */
-	{ 0x9005, 0x0285, 0x9005, 0x0298, 0, 0, 48 }, /* ASR-4000 (BlackBird) */
-	{ 0x9005, 0x0285, 0x9005, 0x0299, 0, 0, 49 }, /* ASR-4800SAS (Marauder-X) */
-	{ 0x9005, 0x0285, 0x9005, 0x029a, 0, 0, 50 }, /* ASR-4805SAS (Marauder-E) */
-	{ 0x9005, 0x0286, 0x9005, 0x02a2, 0, 0, 51 }, /* ASR-3800 (Hurricane44) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x0288), .driver_data = 16 }, /* Adaptec 3230S (Harrier) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x0289), .driver_data = 17 }, /* Adaptec 3240S (Tornado) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x028a), .driver_data = 18 }, /* ASR-2020ZCR SCSI PCI-X ZCR (Skyhawk) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x028b), .driver_data = 19 }, /* ASR-2025ZCR SCSI SO-DIMM PCI-X ZCR (Terminator) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x9005, 0x028c), .driver_data = 20 }, /* ASR-2230S + ASR-2230SLP PCI-X (Lancer) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x9005, 0x028d), .driver_data = 21 }, /* ASR-2130S (Lancer) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x9005, 0x029b), .driver_data = 22 }, /* AAR-2820SA (Intruder) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x9005, 0x029c), .driver_data = 23 }, /* AAR-2620SA (Intruder) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x9005, 0x029d), .driver_data = 24 }, /* AAR-2420SA (Intruder) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x9005, 0x029e), .driver_data = 25 }, /* ICP9024RO (Lancer) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x9005, 0x029f), .driver_data = 26 }, /* ICP9014RO (Lancer) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x9005, 0x02a0), .driver_data = 27 }, /* ICP9047MA (Lancer) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x9005, 0x02a1), .driver_data = 28 }, /* ICP9087MA (Lancer) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x9005, 0x02a3), .driver_data = 29 }, /* ICP5445AU (Hurricane44) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x02a4), .driver_data = 30 }, /* ICP9085LI (Marauder-X) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x02a5), .driver_data = 31 }, /* ICP5085BR (Marauder-E) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x9005, 0x02a6), .driver_data = 32 }, /* ICP9067MA (Intruder-6) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0287, 0x9005, 0x0800), .driver_data = 33 }, /* Themisto Jupiter Platform */
+	{ PCI_DEVICE_SUB(0x9005, 0x0200, 0x9005, 0x0200), .driver_data = 33 }, /* Themisto Jupiter Platform */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x9005, 0x0800), .driver_data = 34 }, /* Callisto Jupiter Platform */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x028e), .driver_data = 35 }, /* ASR-2020SA SATA PCI-X ZCR (Skyhawk) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x028f), .driver_data = 36 }, /* ASR-2025SA SATA SO-DIMM PCI-X ZCR (Terminator) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x0290), .driver_data = 37 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x1028, 0x0291), .driver_data = 38 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x0292), .driver_data = 39 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x0293), .driver_data = 40 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x0294), .driver_data = 41 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x103C, 0x3227), .driver_data = 42 }, /* AAR-2610SA PCI SATA 6ch */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x0296), .driver_data = 43 }, /* ASR-2240S (SabreExpress) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x0297), .driver_data = 44 }, /* ASR-4005 */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x1014, 0x02F2), .driver_data = 45 }, /* IBM 8i (AvonPark) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x1014, 0x0312), .driver_data = 45 }, /* IBM 8i (AvonPark Lite) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x1014, 0x9580), .driver_data = 46 }, /* IBM 8k/8k-l8 (Aurora) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x1014, 0x9540), .driver_data = 47 }, /* IBM 8k/8k-l4 (Aurora Lite) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x0298), .driver_data = 48 }, /* ASR-4000 (BlackBird) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x0299), .driver_data = 49 }, /* ASR-4800SAS (Marauder-X) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x9005, 0x029a), .driver_data = 50 }, /* ASR-4805SAS (Marauder-E) */
+	{ PCI_DEVICE_SUB(0x9005, 0x0286, 0x9005, 0x02a2), .driver_data = 51 }, /* ASR-3800 (Hurricane44) */
 
-	{ 0x9005, 0x0285, 0x1028, 0x0287, 0, 0, 52 }, /* Perc 320/DC*/
-	{ 0x1011, 0x0046, 0x9005, 0x0365, 0, 0, 53 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x0364, 0, 0, 54 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x1364, 0, 0, 55 }, /* Dell PERC2/QC */
-	{ 0x1011, 0x0046, 0x103c, 0x10c2, 0, 0, 56 }, /* HP NetRAID-4M */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x1028, 0x0287), .driver_data = 52 }, /* Perc 320/DC*/
+	{ PCI_DEVICE_SUB(0x1011, 0x0046, 0x9005, 0x0365), .driver_data = 53 }, /* Adaptec 5400S (Mustang)*/
+	{ PCI_DEVICE_SUB(0x1011, 0x0046, 0x9005, 0x0364), .driver_data = 54 }, /* Adaptec 5400S (Mustang)*/
+	{ PCI_DEVICE_SUB(0x1011, 0x0046, 0x9005, 0x1364), .driver_data = 55 }, /* Dell PERC2/QC */
+	{ PCI_DEVICE_SUB(0x1011, 0x0046, 0x103c, 0x10c2), .driver_data = 56 }, /* HP NetRAID-4M */
 
-	{ 0x9005, 0x0285, 0x1028, PCI_ANY_ID, 0, 0, 57 }, /* Dell Catchall */
-	{ 0x9005, 0x0285, 0x17aa, PCI_ANY_ID, 0, 0, 58 }, /* Legend Catchall */
-	{ 0x9005, 0x0285, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 59 }, /* Adaptec Catch All */
-	{ 0x9005, 0x0286, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 60 }, /* Adaptec Rocket Catch All */
-	{ 0x9005, 0x0288, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 61 }, /* Adaptec NEMER/ARK Catch All */
-	{ 0x9005, 0x028b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 62 }, /* Adaptec PMC Series 6 (Tupelo) */
-	{ 0x9005, 0x028c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 63 }, /* Adaptec PMC Series 7 (Denali) */
-	{ 0x9005, 0x028d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 64 }, /* Adaptec PMC Series 8 */
-	{ 0,}
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x1028, PCI_ANY_ID), .driver_data = 57 }, /* Dell Catchall */
+	{ PCI_DEVICE_SUB(0x9005, 0x0285, 0x17aa, PCI_ANY_ID), .driver_data = 58 }, /* Legend Catchall */
+	{ PCI_DEVICE(0x9005, 0x0285), .driver_data = 59 }, /* Adaptec Catch All */
+	{ PCI_DEVICE(0x9005, 0x0286), .driver_data = 60 }, /* Adaptec Rocket Catch All */
+	{ PCI_DEVICE(0x9005, 0x0288), .driver_data = 61 }, /* Adaptec NEMER/ARK Catch All */
+	{ PCI_DEVICE(0x9005, 0x028b), .driver_data = 62 }, /* Adaptec PMC Series 6 (Tupelo) */
+	{ PCI_DEVICE(0x9005, 0x028c), .driver_data = 63 }, /* Adaptec PMC Series 7 (Denali) */
+	{ PCI_DEVICE(0x9005, 0x028d), .driver_data = 64 }, /* Adaptec PMC Series 8 */
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
 
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index e6fa05ffc024..4e5c7a6d9ce3 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -11409,19 +11409,13 @@ static struct eisa_driver advansys_eisa_driver = {
 
 /* PCI Devices supported by this driver */
 static const struct pci_device_id advansys_pci_tbl[] = {
-	{PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_1200A,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_ABP940,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_ABP940U,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_ABP940UW,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_38C0800_REV1,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_38C1600_REV1,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{}
+	{ PCI_VDEVICE(ASP, PCI_DEVICE_ID_ASP_1200A) },
+	{ PCI_VDEVICE(ASP, PCI_DEVICE_ID_ASP_ABP940) },
+	{ PCI_VDEVICE(ASP, PCI_DEVICE_ID_ASP_ABP940U) },
+	{ PCI_VDEVICE(ASP, PCI_DEVICE_ID_ASP_ABP940UW) },
+	{ PCI_VDEVICE(ASP, PCI_DEVICE_ID_38C0800_REV1) },
+	{ PCI_VDEVICE(ASP, PCI_DEVICE_ID_38C1600_REV1) },
+	{ }
 };
 
 MODULE_DEVICE_TABLE(pci, advansys_pci_tbl);
diff --git a/drivers/scsi/aic7xxx/aiclib.h b/drivers/scsi/aic7xxx/aiclib.h
index ba08eb3c4e3b..0ffc59b93036 100644
--- a/drivers/scsi/aic7xxx/aiclib.h
+++ b/drivers/scsi/aic7xxx/aiclib.h
@@ -142,10 +142,10 @@ scsi_4btoul(uint8_t *bytes)
 
 #define GETID(v, s) (unsigned)(((v) >> (s)) & 0xFFFF ?: PCI_ANY_ID)
 
-#define ID_C(x, c)						\
-{								\
-	GETID(x,32), GETID(x,48), GETID(x,0), GETID(x,16),	\
-	(c) << 8, 0xFFFF00, 0					\
+#define ID_C(x, c)								\
+{										\
+	PCI_DEVICE_SUB(GETID(x, 32), GETID(x, 48), GETID(x, 0), GETID(x, 16)),	\
+	.class = (c) << 8, .class_mask = 0xFFFF00,				\
 }
 
 #define ID2C(x)                          \
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 4400a3661d90..73f9432598c1 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -967,16 +967,16 @@ static struct sas_domain_function_template aic94xx_transport_functions = {
 };
 
 static const struct pci_device_id aic94xx_pci_table[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x410),0, 0, 1},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x412),0, 0, 1},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x416),0, 0, 1},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x41E),0, 0, 1},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x41F),0, 0, 1},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x430),0, 0, 2},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x432),0, 0, 2},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x43E),0, 0, 2},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x43F),0, 0, 2},
-	{}
+	{ PCI_VDEVICE(ADAPTEC2, 0x0410), .driver_data = 1 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x0412), .driver_data = 1 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x0416), .driver_data = 1 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x041E), .driver_data = 1 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x041F), .driver_data = 1 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x0430), .driver_data = 2 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x0432), .driver_data = 2 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x043E), .driver_data = 2 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x043F), .driver_data = 2 },
+	{ }
 };
 
 MODULE_DEVICE_TABLE(pci, aic94xx_pci_table);
diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index f972a3c90a2f..ea49379ca9cb 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -514,8 +514,7 @@ static void pci_esp_remove_one(struct pci_dev *pdev)
 }
 
 static const struct pci_device_id am53c974_pci_tbl[] = {
-	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_SCSI,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_SCSI) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, am53c974_pci_tbl);
diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 238431524801..2df8848ae723 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1176,9 +1176,9 @@ static const struct pci_error_handlers csio_err_handler = {
 #define CH_PCI_DEVICE_ID_FUNCTION	0x6
 
 #define CH_PCI_ID_TABLE_ENTRY(devid) \
-		{ PCI_VDEVICE(CHELSIO, (devid)), 0 }
+		{ PCI_VDEVICE(CHELSIO, (devid)) }
 
-#define CH_PCI_DEVICE_ID_TABLE_DEFINE_END { 0, } }
+#define CH_PCI_DEVICE_ID_TABLE_DEFINE_END { } }
 
 #include "t4_pci_id_tbl.h"
 
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index d6d091b2f3c7..3676400f992a 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -128,8 +128,10 @@ static void dmx3191d_remove_one(struct pci_dev *pdev)
 }
 
 static const struct pci_device_id dmx3191d_pci_tbl[] = {
-	{PCI_VENDOR_ID_DOMEX, PCI_DEVICE_ID_DOMEX_DMX3191D,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
+	{
+		PCI_VDEVICE(DOMEX, PCI_DEVICE_ID_DOMEX_DMX3191D),
+		.driver_data = 4,
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, dmx3191d_pci_tbl);
diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index 07c2f453459e..35b6dead3736 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -465,9 +465,9 @@ efct_setup_msix(struct efct *efct, u32 num_intrs)
 }
 
 static const struct pci_device_id efct_pci_table[] = {
-	{PCI_DEVICE(EFCT_VENDOR_ID, EFCT_DEVICE_LANCER_G6), 0},
-	{PCI_DEVICE(EFCT_VENDOR_ID, EFCT_DEVICE_LANCER_G7), 0},
-	{}	/* terminate list */
+	{ PCI_DEVICE(EFCT_VENDOR_ID, EFCT_DEVICE_LANCER_G6) },
+	{ PCI_DEVICE(EFCT_VENDOR_ID, EFCT_DEVICE_LANCER_G7) },
+	{ }	/* terminate list */
 };
 
 static int
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index ada278c24c51..d59b066e9b25 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -303,29 +303,14 @@ MODULE_PARM_DESC(interrupt_mode,
 		 "Defines the interrupt mode to use.  0 for legacy"
 		 ", 1 for MSI.  Default is MSI (1).");
 
-static const struct pci_device_id
-	esas2r_pci_table[] = {
-	{ ATTO_VENDOR_ID, 0x0049,	  ATTO_VENDOR_ID, 0x0049,
-	  0,
-	  0, 0 },
-	{ ATTO_VENDOR_ID, 0x0049,	  ATTO_VENDOR_ID, 0x004A,
-	  0,
-	  0, 0 },
-	{ ATTO_VENDOR_ID, 0x0049,	  ATTO_VENDOR_ID, 0x004B,
-	  0,
-	  0, 0 },
-	{ ATTO_VENDOR_ID, 0x0049,	  ATTO_VENDOR_ID, 0x004C,
-	  0,
-	  0, 0 },
-	{ ATTO_VENDOR_ID, 0x0049,	  ATTO_VENDOR_ID, 0x004D,
-	  0,
-	  0, 0 },
-	{ ATTO_VENDOR_ID, 0x0049,	  ATTO_VENDOR_ID, 0x004E,
-	  0,
-	  0, 0 },
-	{ 0,		  0,		  0,		  0,
-	  0,
-	  0, 0 }
+static const struct pci_device_id esas2r_pci_table[] = {
+	{ PCI_DEVICE_SUB(ATTO_VENDOR_ID, 0x0049, ATTO_VENDOR_ID, 0x0049) },
+	{ PCI_DEVICE_SUB(ATTO_VENDOR_ID, 0x0049, ATTO_VENDOR_ID, 0x004A) },
+	{ PCI_DEVICE_SUB(ATTO_VENDOR_ID, 0x0049, ATTO_VENDOR_ID, 0x004B) },
+	{ PCI_DEVICE_SUB(ATTO_VENDOR_ID, 0x0049, ATTO_VENDOR_ID, 0x004C) },
+	{ PCI_DEVICE_SUB(ATTO_VENDOR_ID, 0x0049, ATTO_VENDOR_ID, 0x004D) },
+	{ PCI_DEVICE_SUB(ATTO_VENDOR_ID, 0x0049, ATTO_VENDOR_ID, 0x004E) },
+	{ }
 };
 
 MODULE_DEVICE_TABLE(pci, esas2r_pci_table);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 9391d031f5df..bb6a4e33e9b6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -5317,8 +5317,8 @@ static int __maybe_unused resume_v3_hw(struct device *device)
 }
 
 static const struct pci_device_id sas_v3_pci_table[] = {
-	{ PCI_VDEVICE(HUAWEI, 0xa230), hip08 },
-	{}
+	{ PCI_VDEVICE(HUAWEI, 0xa230), .driver_data = hip08 },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, sas_v3_pci_table);
 
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 14e9ba693169..851f01363916 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -91,64 +91,66 @@ MODULE_PARM_DESC(hpsa_simple_mode,
 
 /* define the PCI info for the cards we can control */
 static const struct pci_device_id hpsa_pci_device_id[] = {
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3241},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3243},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3245},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3247},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3233},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3350},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3351},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3352},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3353},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3356},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103c, 0x1920},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1921},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1922},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1923},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1924},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103c, 0x1925},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1926},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1928},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1929},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BD},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BE},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BF},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C0},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C1},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C2},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C3},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C4},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C5},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C6},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C7},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C8},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C9},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CA},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CB},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CC},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CD},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CE},
-	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0580},
-	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0581},
-	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0582},
-	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0583},
-	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0584},
-	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0585},
-	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0076},
-	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0087},
-	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x007D},
-	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0088},
-	{PCI_VENDOR_ID_HP, 0x333f, 0x103c, 0x333f},
-	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
-	{PCI_VENDOR_ID_COMPAQ,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
-	{0,}
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSE, 0x103C, 0x3241) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSE, 0x103C, 0x3243) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSE, 0x103C, 0x3245) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSE, 0x103C, 0x3247) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSE, 0x103C, 0x3249) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSE, 0x103C, 0x324A) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSE, 0x103C, 0x324B) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSE, 0x103C, 0x3233) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSF, 0x103C, 0x3350) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSF, 0x103C, 0x3351) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSF, 0x103C, 0x3352) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSF, 0x103C, 0x3353) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSF, 0x103C, 0x3354) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSF, 0x103C, 0x3355) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSF, 0x103C, 0x3356) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSH, 0x103c, 0x1920) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSH, 0x103C, 0x1921) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSH, 0x103C, 0x1922) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSH, 0x103C, 0x1923) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSH, 0x103C, 0x1924) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSH, 0x103c, 0x1925) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSH, 0x103C, 0x1926) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSH, 0x103C, 0x1928) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSH, 0x103C, 0x1929) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21BD) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21BE) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21BF) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21C0) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21C1) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21C2) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21C3) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21C4) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21C5) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21C6) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21C7) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21C8) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21C9) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21CA) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21CB) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21CC) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21CD) },
+	{ PCI_VDEVICE_SUB(HP, PCI_DEVICE_ID_HP_CISSI, 0x103C, 0x21CE) },
+	{ PCI_VDEVICE_SUB(ADAPTEC2, 0x0290, 0x9005, 0x0580) },
+	{ PCI_VDEVICE_SUB(ADAPTEC2, 0x0290, 0x9005, 0x0581) },
+	{ PCI_VDEVICE_SUB(ADAPTEC2, 0x0290, 0x9005, 0x0582) },
+	{ PCI_VDEVICE_SUB(ADAPTEC2, 0x0290, 0x9005, 0x0583) },
+	{ PCI_VDEVICE_SUB(ADAPTEC2, 0x0290, 0x9005, 0x0584) },
+	{ PCI_VDEVICE_SUB(ADAPTEC2, 0x0290, 0x9005, 0x0585) },
+	{ PCI_VDEVICE_SUB(HP_3PAR, 0x0075, 0x1590, 0x0076) },
+	{ PCI_VDEVICE_SUB(HP_3PAR, 0x0075, 0x1590, 0x0087) },
+	{ PCI_VDEVICE_SUB(HP_3PAR, 0x0075, 0x1590, 0x007D) },
+	{ PCI_VDEVICE_SUB(HP_3PAR, 0x0075, 0x1590, 0x0088) },
+	{ PCI_VDEVICE_SUB(HP, 0x333f, 0x103c, 0x333f) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_HP, PCI_ANY_ID),
+	  .class = PCI_CLASS_STORAGE_RAID << 8,
+	  .class_mask = 0xffff << 8 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, PCI_ANY_ID),
+	  .class = PCI_CLASS_STORAGE_RAID << 8,
+	  .class_mask = 0xffff << 8 },
+	{ }
 };
 
 MODULE_DEVICE_TABLE(pci, hpsa_pci_device_id);
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index a3afb3446bbb..bacc4a76326b 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1635,39 +1635,39 @@ static struct hptiop_adapter_ops hptiop_mvfrey_ops = {
 };
 
 static const struct pci_device_id hptiop_id_table[] = {
-	{ PCI_VDEVICE(TTI, 0x3220), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3320), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3410), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3510), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3511), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3520), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3521), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3522), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3530), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3540), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3560), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x4210), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x4211), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x4310), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x4311), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x4320), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x4321), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x4400), (kernel_ulong_t)&hptiop_itl_ops },
-	{ PCI_VDEVICE(TTI, 0x3120), (kernel_ulong_t)&hptiop_mv_ops },
-	{ PCI_VDEVICE(TTI, 0x3122), (kernel_ulong_t)&hptiop_mv_ops },
-	{ PCI_VDEVICE(TTI, 0x3020), (kernel_ulong_t)&hptiop_mv_ops },
-	{ PCI_VDEVICE(TTI, 0x4520), (kernel_ulong_t)&hptiop_mvfrey_ops },
-	{ PCI_VDEVICE(TTI, 0x4522), (kernel_ulong_t)&hptiop_mvfrey_ops },
-	{ PCI_VDEVICE(TTI, 0x3610), (kernel_ulong_t)&hptiop_mvfrey_ops },
-	{ PCI_VDEVICE(TTI, 0x3611), (kernel_ulong_t)&hptiop_mvfrey_ops },
-	{ PCI_VDEVICE(TTI, 0x3620), (kernel_ulong_t)&hptiop_mvfrey_ops },
-	{ PCI_VDEVICE(TTI, 0x3622), (kernel_ulong_t)&hptiop_mvfrey_ops },
-	{ PCI_VDEVICE(TTI, 0x3640), (kernel_ulong_t)&hptiop_mvfrey_ops },
-	{ PCI_VDEVICE(TTI, 0x3660), (kernel_ulong_t)&hptiop_mvfrey_ops },
-	{ PCI_VDEVICE(TTI, 0x3680), (kernel_ulong_t)&hptiop_mvfrey_ops },
-	{ PCI_VDEVICE(TTI, 0x3690), (kernel_ulong_t)&hptiop_mvfrey_ops },
-	{},
+	{ PCI_VDEVICE(TTI, 0x3220), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3320), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3410), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3510), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3511), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3520), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3521), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3522), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3530), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3540), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3560), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4210), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4211), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4310), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4311), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4320), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4321), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4322), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4400), .driver_data = (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3120), .driver_data = (kernel_ulong_t)&hptiop_mv_ops },
+	{ PCI_VDEVICE(TTI, 0x3122), .driver_data = (kernel_ulong_t)&hptiop_mv_ops },
+	{ PCI_VDEVICE(TTI, 0x3020), .driver_data = (kernel_ulong_t)&hptiop_mv_ops },
+	{ PCI_VDEVICE(TTI, 0x4520), .driver_data = (kernel_ulong_t)&hptiop_mvfrey_ops },
+	{ PCI_VDEVICE(TTI, 0x4522), .driver_data = (kernel_ulong_t)&hptiop_mvfrey_ops },
+	{ PCI_VDEVICE(TTI, 0x3610), .driver_data = (kernel_ulong_t)&hptiop_mvfrey_ops },
+	{ PCI_VDEVICE(TTI, 0x3611), .driver_data = (kernel_ulong_t)&hptiop_mvfrey_ops },
+	{ PCI_VDEVICE(TTI, 0x3620), .driver_data = (kernel_ulong_t)&hptiop_mvfrey_ops },
+	{ PCI_VDEVICE(TTI, 0x3622), .driver_data = (kernel_ulong_t)&hptiop_mvfrey_ops },
+	{ PCI_VDEVICE(TTI, 0x3640), .driver_data = (kernel_ulong_t)&hptiop_mvfrey_ops },
+	{ PCI_VDEVICE(TTI, 0x3660), .driver_data = (kernel_ulong_t)&hptiop_mvfrey_ops },
+	{ PCI_VDEVICE(TTI, 0x3680), .driver_data = (kernel_ulong_t)&hptiop_mvfrey_ops },
+	{ PCI_VDEVICE(TTI, 0x3690), .driver_data = (kernel_ulong_t)&hptiop_mvfrey_ops },
+	{ },
 };
 
 MODULE_DEVICE_TABLE(pci, hptiop_id_table);
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index da2670cd7edf..34facaa6d70d 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2942,12 +2942,12 @@ static void initio_remove_one(struct pci_dev *pdev)
 MODULE_LICENSE("GPL");
 
 static const struct pci_device_id initio_pci_tbl[] = {
-	{PCI_VENDOR_ID_INIT, 0x9500, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_INIT, 0x9400, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_INIT, 0x9401, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_INIT, 0x0002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_DOMEX, 0x0002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0,}
+	{ PCI_VDEVICE(INIT, 0x9500) },
+	{ PCI_VDEVICE(INIT, 0x9400) },
+	{ PCI_VDEVICE(INIT, 0x9401) },
+	{ PCI_VDEVICE(INIT, 0x0002) },
+	{ PCI_VDEVICE(DOMEX, 0x0002) },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, initio_pci_tbl);
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index a68ec85a7780..1a5e362cccbd 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9879,115 +9879,207 @@ static void ipr_shutdown(struct pci_dev *pdev)
 }
 
 static const struct pci_device_id ipr_pci_table[] = {
-	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_5702, 0, 0, 0 },
-	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_5703, 0, 0, 0 },
-	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_573D, 0, 0, 0 },
-	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_573E, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571B, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572E, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571A, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575B, 0, 0,
-		IPR_USE_LONG_TRANSOP_TIMEOUT },
-	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A, 0, 0, 0 },
-	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B, 0, 0,
-	      IPR_USE_LONG_TRANSOP_TIMEOUT },
-	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C, 0, 0,
-	      IPR_USE_LONG_TRANSOP_TIMEOUT },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B, 0, 0,
-	      IPR_USE_LONG_TRANSOP_TIMEOUT},
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C, 0, 0,
-	      IPR_USE_LONG_TRANSOP_TIMEOUT },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_574E, 0, 0,
-	      IPR_USE_LONG_TRANSOP_TIMEOUT },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B3, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57CC, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7, 0, 0,
-	      IPR_USE_LONG_TRANSOP_TIMEOUT | IPR_USE_PCI_WARM_RESET },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2780, 0, 0, 0 },
-	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571E, 0, 0, 0 },
-	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571F, 0, 0,
-		IPR_USE_LONG_TRANSOP_TIMEOUT },
-	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572F, 0, 0,
-		IPR_USE_LONG_TRANSOP_TIMEOUT },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B5, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_574D, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B2, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C0, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C3, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C4, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B4, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B1, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C6, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C8, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57CE, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D5, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D6, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D7, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D8, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D9, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57DA, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EB, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EC, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57ED, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EE, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EF, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57F0, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2CCA, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2CD2, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2CCD, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_RATTLESNAKE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_580A, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_RATTLESNAKE,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_580B, 0, 0, 0 },
+	{
+		PCI_VDEVICE_SUB(MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_5702),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_5703),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_573D),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_573E),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CITRINE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571B),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CITRINE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572E),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CITRINE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571A),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CITRINE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575B),
+		.driver_data = IPR_USE_LONG_TRANSOP_TIMEOUT,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B),
+		.driver_data = IPR_USE_LONG_TRANSOP_TIMEOUT,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C),
+		.driver_data = IPR_USE_LONG_TRANSOP_TIMEOUT,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572A),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572B),
+		.driver_data = IPR_USE_LONG_TRANSOP_TIMEOUT,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575C),
+		.driver_data = IPR_USE_LONG_TRANSOP_TIMEOUT,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_574E),
+		.driver_data = IPR_USE_LONG_TRANSOP_TIMEOUT,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B3),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57CC),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7),
+		.driver_data = IPR_USE_LONG_TRANSOP_TIMEOUT | IPR_USE_PCI_WARM_RESET,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_SNIPE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2780),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571E),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_571F),
+		.driver_data = IPR_USE_LONG_TRANSOP_TIMEOUT,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_572F),
+		.driver_data = IPR_USE_LONG_TRANSOP_TIMEOUT,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B5),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_574D),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B2),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C0),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C3),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C4),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B4),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B1),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C6),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C8),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57CE),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D5),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D6),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D7),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D8),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D9),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57DA),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EB),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EC),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57ED),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EE),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EF),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57F0),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2CCA),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2CD2),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2CCD),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_RATTLESNAKE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_580A),
+		.driver_data = 0,
+	}, {
+		PCI_VDEVICE_SUB(IBM, PCI_DEVICE_ID_IBM_RATTLESNAKE,
+				PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_580B),
+		.driver_data = 0
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index a4079866f747..22e030001ba8 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4554,13 +4554,10 @@ megaraid_shutdown(struct pci_dev *pdev)
 }
 
 static const struct pci_device_id megaraid_pci_tbl[] = {
-	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_AMI_MEGARAID3,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0,}
+	{ PCI_VDEVICE(AMI, PCI_DEVICE_ID_AMI_MEGARAID) },
+	{ PCI_VDEVICE(AMI, PCI_DEVICE_ID_AMI_MEGARAID2) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_AMI_MEGARAID3) },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, megaraid_pci_tbl);
 
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 5abc17a2e261..72bc6e5d4504 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -610,61 +610,37 @@ static void mvs_pci_remove(struct pci_dev *pdev)
 }
 
 static const struct pci_device_id mvs_pci_table[] = {
-	{ PCI_VDEVICE(MARVELL, 0x6320), chip_6320 },
-	{ PCI_VDEVICE(MARVELL, 0x6340), chip_6440 },
-	{
-		.vendor 	= PCI_VENDOR_ID_MARVELL,
-		.device 	= 0x6440,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= 0x6480,
-		.class		= 0,
-		.class_mask	= 0,
-		.driver_data	= chip_6485,
-	},
-	{ PCI_VDEVICE(MARVELL, 0x6440), chip_6440 },
-	{ PCI_VDEVICE(MARVELL, 0x6485), chip_6485 },
-	{ PCI_VDEVICE(MARVELL, 0x9480), chip_9480 },
-	{ PCI_VDEVICE(MARVELL, 0x9180), chip_9180 },
-	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), chip_1300 },
-	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), chip_1320 },
-	{ PCI_VDEVICE(ADAPTEC2, 0x0450), chip_6440 },
-	{ PCI_VDEVICE(TTI, 0x2640), chip_6440 },
-	{ PCI_VDEVICE(TTI, 0x2710), chip_9480 },
-	{ PCI_VDEVICE(TTI, 0x2720), chip_9480 },
-	{ PCI_VDEVICE(TTI, 0x2721), chip_9480 },
-	{ PCI_VDEVICE(TTI, 0x2722), chip_9480 },
-	{ PCI_VDEVICE(TTI, 0x2740), chip_9480 },
-	{ PCI_VDEVICE(TTI, 0x2744), chip_9480 },
-	{ PCI_VDEVICE(TTI, 0x2760), chip_9480 },
-	{
-		.vendor		= PCI_VENDOR_ID_MARVELL_EXT,
-		.device		= 0x9480,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= 0x9480,
-		.class		= 0,
-		.class_mask	= 0,
-		.driver_data	= chip_9480,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_MARVELL_EXT,
-		.device		= 0x9445,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= 0x9480,
-		.class		= 0,
-		.class_mask	= 0,
-		.driver_data	= chip_9445,
-	},
-	{ PCI_VDEVICE(MARVELL_EXT, 0x9485), chip_9485 }, /* Marvell 9480/9485 (any vendor/model) */
-	{ PCI_VDEVICE(OCZ, 0x1021), chip_9485}, /* OCZ RevoDrive3 */
-	{ PCI_VDEVICE(OCZ, 0x1022), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
-	{ PCI_VDEVICE(OCZ, 0x1040), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
-	{ PCI_VDEVICE(OCZ, 0x1041), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
-	{ PCI_VDEVICE(OCZ, 0x1042), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
-	{ PCI_VDEVICE(OCZ, 0x1043), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
-	{ PCI_VDEVICE(OCZ, 0x1044), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
-	{ PCI_VDEVICE(OCZ, 0x1080), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
-	{ PCI_VDEVICE(OCZ, 0x1083), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
-	{ PCI_VDEVICE(OCZ, 0x1084), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(MARVELL, 0x6320), .driver_data = chip_6320 },
+	{ PCI_VDEVICE(MARVELL, 0x6340), .driver_data = chip_6440 },
+	{ PCI_VDEVICE_SUB(MARVELL, 0x6440, PCI_ANY_ID, 0x6480), .driver_data = chip_6485 },
+	{ PCI_VDEVICE(MARVELL, 0x6440), .driver_data = chip_6440 },
+	{ PCI_VDEVICE(MARVELL, 0x6485), .driver_data = chip_6485 },
+	{ PCI_VDEVICE(MARVELL, 0x9480), .driver_data = chip_9480 },
+	{ PCI_VDEVICE(MARVELL, 0x9180), .driver_data = chip_9180 },
+	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), .driver_data = chip_1300 },
+	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), .driver_data = chip_1320 },
+	{ PCI_VDEVICE(ADAPTEC2, 0x0450), .driver_data = chip_6440 },
+	{ PCI_VDEVICE(TTI, 0x2640), .driver_data = chip_6440 },
+	{ PCI_VDEVICE(TTI, 0x2710), .driver_data = chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2720), .driver_data = chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2721), .driver_data = chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2722), .driver_data = chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2740), .driver_data = chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2744), .driver_data = chip_9480 },
+	{ PCI_VDEVICE(TTI, 0x2760), .driver_data = chip_9480 },
+	{ PCI_VDEVICE_SUB(MARVELL_EXT, 0x9480, PCI_ANY_ID, 0x9480), .driver_data = chip_9480 },
+	{ PCI_VDEVICE_SUB(MARVELL_EXT, 0x9445, PCI_ANY_ID, 0x9480), .driver_data = chip_9445 },
+	{ PCI_VDEVICE(MARVELL_EXT, 0x9485), .driver_data = chip_9485 }, /* Marvell 9480/9485 (any vendor/model) */
+	{ PCI_VDEVICE(OCZ, 0x1021), .driver_data = chip_9485 }, /* OCZ RevoDrive3 */
+	{ PCI_VDEVICE(OCZ, 0x1022), .driver_data = chip_9485 }, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1040), .driver_data = chip_9485 }, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1041), .driver_data = chip_9485 }, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1042), .driver_data = chip_9485 }, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1043), .driver_data = chip_9485 }, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1044), .driver_data = chip_9485 }, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1080), .driver_data = chip_9485 }, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1083), .driver_data = chip_9485 }, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
+	{ PCI_VDEVICE(OCZ, 0x1084), .driver_data = chip_9485 }, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
 
 	{ }	/* terminate list */
 };
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 5af81c73a8f8..427a02b916bd 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1437,79 +1437,176 @@ static int __maybe_unused pm8001_pci_resume(struct device *dev)
  * unique value for each of the controller
  */
 static const struct pci_device_id pm8001_pci_table[] = {
-	{ PCI_VDEVICE(PMC_Sierra, 0x8001), chip_8001 },
-	{ PCI_VDEVICE(PMC_Sierra, 0x8006), chip_8006 },
-	{ PCI_VDEVICE(ADAPTEC2, 0x8006), chip_8006 },
-	{ PCI_VDEVICE(ATTO, 0x0042), chip_8001 },
-	/* Support for SPC/SPCv/SPCve controllers */
-	{ PCI_VDEVICE(ADAPTEC2, 0x8001), chip_8001 },
-	{ PCI_VDEVICE(PMC_Sierra, 0x8008), chip_8008 },
-	{ PCI_VDEVICE(ADAPTEC2, 0x8008), chip_8008 },
-	{ PCI_VDEVICE(PMC_Sierra, 0x8018), chip_8018 },
-	{ PCI_VDEVICE(ADAPTEC2, 0x8018), chip_8018 },
-	{ PCI_VDEVICE(PMC_Sierra, 0x8009), chip_8009 },
-	{ PCI_VDEVICE(ADAPTEC2, 0x8009), chip_8009 },
-	{ PCI_VDEVICE(PMC_Sierra, 0x8019), chip_8019 },
-	{ PCI_VDEVICE(ADAPTEC2, 0x8019), chip_8019 },
-	{ PCI_VDEVICE(PMC_Sierra, 0x8074), chip_8074 },
-	{ PCI_VDEVICE(ADAPTEC2, 0x8074), chip_8074 },
-	{ PCI_VDEVICE(PMC_Sierra, 0x8076), chip_8076 },
-	{ PCI_VDEVICE(ADAPTEC2, 0x8076), chip_8076 },
-	{ PCI_VDEVICE(PMC_Sierra, 0x8077), chip_8077 },
-	{ PCI_VDEVICE(ADAPTEC2, 0x8077), chip_8077 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8081,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0400, 0, 0, chip_8001 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8081,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0800, 0, 0, chip_8001 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8088,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0008, 0, 0, chip_8008 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8088,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0800, 0, 0, chip_8008 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8089,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0008, 0, 0, chip_8009 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8089,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0800, 0, 0, chip_8009 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8088,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0016, 0, 0, chip_8018 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8088,
-		PCI_VENDOR_ID_ADAPTEC2, 0x1600, 0, 0, chip_8018 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8089,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0016, 0, 0, chip_8019 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8089,
-		PCI_VENDOR_ID_ADAPTEC2, 0x1600, 0, 0, chip_8019 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8074,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0800, 0, 0, chip_8074 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8076,
-		PCI_VENDOR_ID_ADAPTEC2, 0x1600, 0, 0, chip_8076 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8077,
-		PCI_VENDOR_ID_ADAPTEC2, 0x1600, 0, 0, chip_8077 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8074,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0008, 0, 0, chip_8074 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8076,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0016, 0, 0, chip_8076 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8077,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0016, 0, 0, chip_8077 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8076,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0808, 0, 0, chip_8076 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8077,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0808, 0, 0, chip_8077 },
-	{ PCI_VENDOR_ID_ADAPTEC2, 0x8074,
-		PCI_VENDOR_ID_ADAPTEC2, 0x0404, 0, 0, chip_8074 },
-	{ PCI_VENDOR_ID_ATTO, 0x8070,
-		PCI_VENDOR_ID_ATTO, 0x0070, 0, 0, chip_8070 },
-	{ PCI_VENDOR_ID_ATTO, 0x8070,
-		PCI_VENDOR_ID_ATTO, 0x0071, 0, 0, chip_8070 },
-	{ PCI_VENDOR_ID_ATTO, 0x8072,
-		PCI_VENDOR_ID_ATTO, 0x0072, 0, 0, chip_8072 },
-	{ PCI_VENDOR_ID_ATTO, 0x8072,
-		PCI_VENDOR_ID_ATTO, 0x0073, 0, 0, chip_8072 },
-	{ PCI_VENDOR_ID_ATTO, 0x8070,
-		PCI_VENDOR_ID_ATTO, 0x0080, 0, 0, chip_8070 },
-	{ PCI_VENDOR_ID_ATTO, 0x8072,
-		PCI_VENDOR_ID_ATTO, 0x0081, 0, 0, chip_8072 },
-	{ PCI_VENDOR_ID_ATTO, 0x8072,
-		PCI_VENDOR_ID_ATTO, 0x0082, 0, 0, chip_8072 },
-	{} /* terminate list */
+	{
+		PCI_VDEVICE(PMC_Sierra, 0x8001),
+		.driver_data = chip_8001,
+	}, {
+		PCI_VDEVICE(PMC_Sierra, 0x8006),
+		.driver_data = chip_8006,
+	}, {
+		PCI_VDEVICE(ADAPTEC2, 0x8006),
+		.driver_data = chip_8006,
+	}, {
+		PCI_VDEVICE(ATTO, 0x0042),
+		.driver_data = chip_8001
+	}, {
+		/* Support for SPC/SPCv/SPCve controllers */
+		PCI_VDEVICE(ADAPTEC2, 0x8001),
+		.driver_data = chip_8001,
+	}, {
+		PCI_VDEVICE(PMC_Sierra, 0x8008),
+		.driver_data = chip_8008,
+	}, {
+		PCI_VDEVICE(ADAPTEC2, 0x8008),
+		.driver_data = chip_8008,
+	}, {
+		PCI_VDEVICE(PMC_Sierra, 0x8018),
+		.driver_data = chip_8018,
+	}, {
+		PCI_VDEVICE(ADAPTEC2, 0x8018),
+		.driver_data = chip_8018,
+	}, {
+		PCI_VDEVICE(PMC_Sierra, 0x8009),
+		.driver_data = chip_8009,
+	}, {
+		PCI_VDEVICE(ADAPTEC2, 0x8009),
+		.driver_data = chip_8009,
+	}, {
+		PCI_VDEVICE(PMC_Sierra, 0x8019),
+		.driver_data = chip_8019,
+	}, {
+		PCI_VDEVICE(ADAPTEC2, 0x8019),
+		.driver_data = chip_8019,
+	}, {
+		PCI_VDEVICE(PMC_Sierra, 0x8074),
+		.driver_data = chip_8074,
+	}, {
+		PCI_VDEVICE(ADAPTEC2, 0x8074),
+		.driver_data = chip_8074,
+	}, {
+		PCI_VDEVICE(PMC_Sierra, 0x8076),
+		.driver_data = chip_8076,
+	}, {
+		PCI_VDEVICE(ADAPTEC2, 0x8076),
+		.driver_data = chip_8076,
+	}, {
+		PCI_VDEVICE(PMC_Sierra, 0x8077),
+		.driver_data = chip_8077,
+	}, {
+		PCI_VDEVICE(ADAPTEC2, 0x8077),
+		.driver_data = chip_8077,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8081,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0400),
+		.driver_data = chip_8001,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8081,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0800),
+		.driver_data = chip_8001,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8088,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0008),
+		.driver_data = chip_8008,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8088,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0800),
+		.driver_data = chip_8008,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8089,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0008),
+		.driver_data = chip_8009,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8089,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0800),
+		.driver_data = chip_8009,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8088,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0016),
+		.driver_data = chip_8018,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8088,
+				PCI_VENDOR_ID_ADAPTEC2, 0x1600),
+		.driver_data = chip_8018,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8089,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0016),
+		.driver_data = chip_8019,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8089,
+				PCI_VENDOR_ID_ADAPTEC2, 0x1600),
+		.driver_data = chip_8019,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8074,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0800),
+		.driver_data = chip_8074,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8076,
+				PCI_VENDOR_ID_ADAPTEC2, 0x1600),
+		.driver_data = chip_8076,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8077,
+				PCI_VENDOR_ID_ADAPTEC2, 0x1600),
+		.driver_data = chip_8077,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8074,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0008),
+		.driver_data = chip_8074,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8076,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0016),
+		.driver_data = chip_8076,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8077,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0016),
+		.driver_data = chip_8077,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8076,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0808),
+		.driver_data = chip_8076,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8077,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0808),
+		.driver_data = chip_8077,
+	}, {
+		PCI_VDEVICE_SUB(ADAPTEC2, 0x8074,
+				PCI_VENDOR_ID_ADAPTEC2, 0x0404),
+		.driver_data = chip_8074,
+	}, {
+		PCI_VDEVICE_SUB(ATTO, 0x8070,
+				PCI_VENDOR_ID_ATTO, 0x0070),
+		.driver_data = chip_8070,
+	}, {
+
+		PCI_VDEVICE_SUB(ATTO, 0x8070,
+				PCI_VENDOR_ID_ATTO, 0x0071),
+		.driver_data = chip_8070,
+	}, {
+
+		PCI_VDEVICE_SUB(ATTO, 0x8072,
+				PCI_VENDOR_ID_ATTO, 0x0072),
+		.driver_data = chip_8072,
+	}, {
+
+		PCI_VDEVICE_SUB(ATTO, 0x8072,
+				PCI_VENDOR_ID_ATTO, 0x0073),
+		.driver_data = chip_8072,
+	}, {
+
+		PCI_VDEVICE_SUB(ATTO, 0x8070,
+				PCI_VENDOR_ID_ATTO, 0x0080),
+		.driver_data = chip_8070,
+	}, {
+
+		PCI_VDEVICE_SUB(ATTO, 0x8072,
+				PCI_VENDOR_ID_ATTO, 0x0081),
+		.driver_data = chip_8072,
+	}, {
+
+		PCI_VDEVICE_SUB(ATTO, 0x8072,
+				PCI_VENDOR_ID_ATTO, 0x0082),
+		.driver_data = chip_8072,
+	},
+	{ } /* terminate list */
 };
 
 static SIMPLE_DEV_PM_OPS(pm8001_pci_pm_ops,
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index b68f6460207c..34f10dfc2bd0 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -114,10 +114,11 @@ static struct pmcraid_chip_details pmcraid_chip_cfg[] = {
  * PCI device ids supported by pmcraid driver
  */
 static const struct pci_device_id pmcraid_pci_table[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_PMC, PCI_DEVICE_ID_PMC_MAXRAID),
-	  0, 0, (kernel_ulong_t)&pmcraid_chip_cfg[0]
+	{
+		PCI_VDEVICE(PMC, PCI_DEVICE_ID_PMC_MAXRAID),
+		.driver_data = (kernel_ulong_t)&pmcraid_chip_cfg[0],
 	},
-	{}
+	{ }
 };
 
 MODULE_DEVICE_TABLE(pci, pmcraid_pci_table);
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index f71e668d011c..12e298ed0f05 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -502,21 +502,15 @@ struct qla_boards {
 	int fw_index;		/* index into qla1280_fw_tbl for firmware */
 };
 
-/* NOTE: the last argument in each entry is used to index ql1280_board_tbl */
+/* NOTE: the driver_data argument in each entry is used to index ql1280_board_tbl */
 static const struct pci_device_id qla1280_pci_tbl[] = {
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP12160,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1020,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1080,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1240,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1280,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP10160,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 5},
-	{0,}
+	{ PCI_VDEVICE(QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP12160), .driver_data = 0 },
+	{ PCI_VDEVICE(QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1020), .driver_data = 1 },
+	{ PCI_VDEVICE(QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1080), .driver_data = 2 },
+	{ PCI_VDEVICE(QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1240), .driver_data = 3 },
+	{ PCI_VDEVICE(QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1280), .driver_data = 4 },
+	{ PCI_VDEVICE(QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP10160), .driver_data = 5 },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, qla1280_pci_tbl);
 
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index d4899816f7dc..057aa4b02674 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1489,47 +1489,80 @@ static const struct scsi_host_template driver_template = {
 
 static const struct pci_device_id stex_pci_tbl[] = {
 	/* st_shasta */
-	{ 0x105a, 0x8350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		st_shasta }, /* SuperTrak EX8350/8300/16350/16300 */
-	{ 0x105a, 0xc350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		st_shasta }, /* SuperTrak EX12350 */
-	{ 0x105a, 0x4302, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		st_shasta }, /* SuperTrak EX4350 */
-	{ 0x105a, 0xe350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		st_shasta }, /* SuperTrak EX24350 */
-
+	{
+		/* SuperTrak EX8350/8300/16350/16300 */
+		PCI_DEVICE(0x105a, 0x8350),
+		.driver_data = st_shasta,
+	}, {
+		/* SuperTrak EX12350 */
+		PCI_DEVICE(0x105a, 0xc350),
+		.driver_data = st_shasta,
+	}, {
+		/* SuperTrak EX4350 */
+		PCI_DEVICE(0x105a, 0x4302),
+		.driver_data = st_shasta,
+	}, {
+		/* SuperTrak EX24350 */
+		PCI_DEVICE(0x105a, 0xe350),
+		.driver_data = st_shasta,
+	},
 	/* st_vsc */
-	{ 0x105a, 0x7250, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_vsc },
+	{
+		PCI_DEVICE(0x105a, 0x7250),
+		.driver_data = st_vsc,
+	},
 
 	/* st_yosemite */
-	{ 0x105a, 0x8650, 0x105a, PCI_ANY_ID, 0, 0, st_yosemite },
+	{
+		PCI_DEVICE_SUB(0x105a, 0x8650, 0x105a, PCI_ANY_ID),
+		.driver_data = st_yosemite,
+	},
 
 	/* st_seq */
-	{ 0x105a, 0x3360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_seq },
+	{
+		PCI_DEVICE(0x105a, 0x3360),
+		.driver_data = st_seq,
+	},
 
 	/* st_yel */
-	{ 0x105a, 0x8650, 0x1033, PCI_ANY_ID, 0, 0, st_yel },
-	{ 0x105a, 0x8760, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_yel },
+	{
+		PCI_DEVICE_SUB(0x105a, 0x8650, 0x1033, PCI_ANY_ID),
+		.driver_data = st_yel,
+	}, {
+		PCI_DEVICE(0x105a, 0x8760),
+		.driver_data = st_yel,
+	},
 
 	/* st_P3, pluto */
-	{ PCI_VENDOR_ID_PROMISE, 0x8870, PCI_VENDOR_ID_PROMISE,
-		0x8870, 0, 0, st_P3 },
-	/* st_P3, p3 */
-	{ PCI_VENDOR_ID_PROMISE, 0x8870, PCI_VENDOR_ID_PROMISE,
-		0x4300, 0, 0, st_P3 },
+	{
+		/* st_P3, p3 */
+		PCI_VDEVICE_SUB(PROMISE, 0x8870, PCI_VENDOR_ID_PROMISE, 0x8870),
+		.driver_data = st_P3,
+	}, {
+		/* st_P3, SymplyStor4E */
+		PCI_VDEVICE_SUB(PROMISE, 0x8870, PCI_VENDOR_ID_PROMISE, 0x4300),
+		.driver_data = st_P3,
+	}, {
+		/* st_P3, SymplyStor8E */
+		PCI_VDEVICE_SUB(PROMISE, 0x8871, PCI_VENDOR_ID_PROMISE, 0x4311),
+		.driver_data = st_P3,
+	}, {
+		PCI_VDEVICE_SUB(PROMISE, 0x8871, PCI_VENDOR_ID_PROMISE, 0x4312),
+		.driver_data = st_P3,
+	},
 
-	/* st_P3, SymplyStor4E */
-	{ PCI_VENDOR_ID_PROMISE, 0x8871, PCI_VENDOR_ID_PROMISE,
-		0x4311, 0, 0, st_P3 },
-	/* st_P3, SymplyStor8E */
-	{ PCI_VENDOR_ID_PROMISE, 0x8871, PCI_VENDOR_ID_PROMISE,
-		0x4312, 0, 0, st_P3 },
 	/* st_P3, SymplyStor4 */
-	{ PCI_VENDOR_ID_PROMISE, 0x8871, PCI_VENDOR_ID_PROMISE,
-		0x4321, 0, 0, st_P3 },
+	{
+		PCI_VDEVICE_SUB(PROMISE, 0x8871, PCI_VENDOR_ID_PROMISE, 0x4321),
+		.driver_data = st_P3,
+	},
+
 	/* st_P3, SymplyStor8 */
-	{ PCI_VENDOR_ID_PROMISE, 0x8871, PCI_VENDOR_ID_PROMISE,
-		0x4322, 0, 0, st_P3 },
+	{
+		PCI_VDEVICE_SUB(PROMISE, 0x8871, PCI_VENDOR_ID_PROMISE, 0x4322),
+		.driver_data = st_P3,
+	},
+
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index e3783c015b02..3714a4139e7c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -2032,41 +2032,33 @@ static struct spi_function_template sym2_transport_functions = {
 };
 
 static const struct pci_device_id sym2_id_table[] = {
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C810,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C820,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL }, /* new */
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C825,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C815,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C810AP,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL }, /* new */
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C860,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1510,
-	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_SCSI<<8,  0xffff00, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C896,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C895,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C885,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C1510,
-	  PCI_ANY_ID, PCI_ANY_ID,  PCI_CLASS_STORAGE_SCSI<<8,  0xffff00, 0UL }, /* new */
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C895A,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C875A,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1010_33,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1010_66,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875J,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ 0, }
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C810) },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C820) }, /* new */
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C825) },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C815) },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_LSI_53C810AP) }, /* new */
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C860) },
+	{
+		PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1510),
+		.class = PCI_CLASS_STORAGE_SCSI << 8,
+		.class_mask = 0xffff00,
+	},
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C896) },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C895) },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C885) },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875) },
+	{
+		/* new */
+		PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C1510),
+		.class = PCI_CLASS_STORAGE_SCSI << 8,
+		.class_mask = 0xffff00,
+	},
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_LSI_53C895A) },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_LSI_53C875A) },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1010_33) },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1010_66) },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875J) },
+	{ }
 };
 
 MODULE_DEVICE_TABLE(pci, sym2_id_table);

base-commit: 793807ca13bf3072fc6d16ce6d90e9ab9beff2a5
-- 
2.56.0.rc1

