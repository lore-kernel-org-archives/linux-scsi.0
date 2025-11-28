Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820EE226CFD
	for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2025 14:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764341277; cv=none; b=oIaDq1UE679gbbkZhbuSwPXUrZiKOsBzSPgPfs1+5KV/2y7/VF+hHeUFKLphTrIJ55MvxDGCYr/mdbrWwxTEdNRWlZZpTK6137J+D5URK4t6ckvtQGWiqPEbAHg2uGezzI6gkkBhkdhvYsggAXIx/xj2nSpAQ+0RmeFLhpif8KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764341277; c=relaxed/simple;
	bh=kBsXaBTbTfKM2axj9Do1FbixYAYlvJ2ocJAHzb3rwog=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=peGkm7aG+R1Z4GFnwbZzKPdrLhB62PZXW6uv6MpquL7qG5xYieby1AZnPSuHG+lGzbATR6MMbEEPU7ZaG367Ab1q9qj3lR5Pb8z4zLxXWcP2LJeEE0X9ke6yu1zgakhj5zQFmIOg6B9o3mowQfrG80i/DB31bi6raYOh9Nrpg/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y40UwwV8; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y40UwwV8"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-595819064cdso2672345e87.0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2025 06:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764341274; x=1764946074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q6/Fm/oVY95uFXuY2detaFQ/ocohpIH0USIsHRoZb9Q=;
        b=Y40UwwV8f93b/2anVNRU2FGNsOTTNhrozfofzHUHfYXVRjntSZAVok0FBAf35+Br6k
         YNkN4XMsql/b6dmbI+Iz3Uod3UYo1tRbmebWwog9NWoCPs1+EcM8RTjYg4qqxeb8CqMx
         HBbWQvb4TcTwfHPyHBNQhwUZnSc1urx1SUF8CPkCFnWGQEi7drfUSqY2FzJudSI5sX8g
         bHt+8OCtXI95VB269iQVAstQbM/xGU+KxcQ0NChNoJ1N0VonmalcmmiBAmcTg9q1Qu2g
         hcWssjaIuFpclqWa/hbKRGWsKhwzOGUTPx7qEfF5k4Bp/Q54WpT4fGd3OjoGH2MPDM8+
         Ik3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764341274; x=1764946074;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q6/Fm/oVY95uFXuY2detaFQ/ocohpIH0USIsHRoZb9Q=;
        b=BKIaVhNgL1aqHbYWQKnTY454ce4w/OqyFyG51dwa8z0BOG+y7p26sFStfuj7Zf1Pi9
         KeXYHBavzH/rcWhMRpHBU8RQmwN2mFmP9GKTbUxW+0yY30Ol3MkFIIvsPuSFQfNZVOHh
         s8ONpjHZvgNO62T7dGEbe3yRAxKI+H7jW8QgACD1nDeUg691OKP3Y+Kv71Gt+/vcwT7W
         KoFEyBw3X9kMIYHAwscuZal3F5KsRAcr2QMFJpf4XtZjBJ1P2q7c/LSTigBhEk7boKY6
         fSZ/95SQBcGWSir+OBpCIzTAxi9Dd21lZoPO5L68M2R5q/MSbpzQ0LIgomp+aVcLozFe
         QekQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJR4nvsr8S6bWGEQN1Qkxyfev0al7mLuO+uzKOk1J0s57Iofx1WhhD121BsvO4uoj1At85C8WV9o63@vger.kernel.org
X-Gm-Message-State: AOJu0YyKCOAwmAqGTYFodpicHuH8RZqWcKilZhbYXSqa5mcmRASwx6mY
	pXycj4Yi46bmROIBxaBP7/BMF2Ap922Bk+i0xswd14IJJxGwoaqHo8oX
X-Gm-Gg: ASbGnct8lu/LfAHcQLdOY9FFwjdUvT2XBCNvy6/SmYu8TsaCLFMOYgCNL8BxhXFX+g7
	A1wg0Wph1ELAy7jyPhI6TC/zPQgFkTB/d3wp0hTHelzfBi7Ls7iM5G8HUExmdvbdnFgpe9Mt2kn
	Ct4sk577Rs4qqtlseHucAItXA/X6qWHdLA9bXolv6jDWOnWwiVauZRZ5AdbfBA0XE7zOX2SeMuz
	Ic3O+w5VwFOMq6tYgQFLhb4RDUpE71NisTxbCmOCyBBlkUjtCt6tpkbaxbm0LRU9nPNblslA8QJ
	Cizpb01GNLs5nT1OiR/eSGfG2SlfGIazi3cWuagtxwux/IisU9aJRufkviBKYywyoch80ebEoKK
	xahYd4QJsoJ/Vuf7wu/ZPpR7WiXxQlP02BpOPRjPfKuhp6WVtrrQg5Du8dNlRNZ3ahM2soHuhFm
	s48ZJFIZwoudnlV8WxVXZtBZEeZfbvwWFy4bhgzSniGC9o7ZFYWSKvgXHP
X-Google-Smtp-Source: AGHT+IGri/Kcqai6Ho5kp6UE3YX9ridRldxzonTf7wiVODikqOhdC/WBm9NPMdz2N8FXWRU8ePEc8A==
X-Received: by 2002:ac2:4e04:0:b0:595:90ce:df8e with SMTP id 2adb3069b0e04-596a3740821mr10547766e87.5.1764341273519;
        Fri, 28 Nov 2025 06:47:53 -0800 (PST)
Received: from cherrypc.astracloud.ru (109-252-18-135.nat.spd-mgts.ru. [109.252.18.135])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-596bfa43e6csm1261533e87.54.2025.11.28.06.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 06:47:53 -0800 (PST)
From: Nazar Kalashnikov <sivartiwe@gmail.com>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nazar Kalashnikov <sivartiwe@gmail.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Igor Pylypiv <ipylypiv@google.com>,
	Terrence Adams <tadamsjr@google.com>,
	Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 5.10/5.15/6.1] scsi: pm80xx: Set phy->enable_completion only when we
Date: Fri, 28 Nov 2025 17:48:15 +0300
Message-ID: <20251128144816.55522-1-sivartiwe@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit e4f949ef1516c0d74745ee54a0f4882c1f6c7aea ]

pm8001_phy_control() populates the enable_completion pointer with a stack
address, sends a PHY_LINK_RESET / PHY_HARD_RESET, waits 300 ms, and
returns. The problem arises when a phy control response comes late.  After
300 ms the pm8001_phy_control() function returns and the passed
enable_completion stack address is no longer valid. Late phy control
response invokes complete() on a dangling enable_completion pointer which
leads to a kernel crash.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Terrence Adams <tadamsjr@google.com>
Link: https://lore.kernel.org/r/20240627155924.2361370-2-tadamsjr@google.com
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Nazar Kalashnikov <sivartiwe@gmail.com>
---
Backport fix for CVE-2024-47666
 drivers/scsi/pm8001/pm8001_sas.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 765c5be6c84c..85c27f2f990f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -163,7 +163,6 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	unsigned long flags;
 	pm8001_ha = sas_phy->ha->lldd_ha;
 	phy = &pm8001_ha->phy[phy_id];
-	pm8001_ha->phy[phy_id].enable_completion = &completion;
 	switch (func) {
 	case PHY_FUNC_SET_LINK_RATE:
 		rates = funcdata;
@@ -176,6 +175,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 				rates->maximum_linkrate;
 		}
 		if (pm8001_ha->phy[phy_id].phy_state ==  PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}
@@ -184,6 +184,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 	case PHY_FUNC_HARD_RESET:
 		if (pm8001_ha->phy[phy_id].phy_state == PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}
@@ -192,6 +193,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 	case PHY_FUNC_LINK_RESET:
 		if (pm8001_ha->phy[phy_id].phy_state == PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}
-- 
2.43.0

