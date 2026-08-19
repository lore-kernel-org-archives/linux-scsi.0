Received: from mail.amicon.ru (unknown [77.108.111.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23FA2D9484;
	Wed, 19 Aug 2026 09:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.108.111.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787132041; cv=none; b=ogQeZp4TABp8Uxcgb83NSPUh3NQXuWFhG6/wXEFN2Nqcm1/TQdbrIWTGHGHW1SE15X/gr4/AAxoheVT7e+snj+PcFmXWcJn8fpEPq1UzlW5Ju/Gh35kvBO4RTWBoquNAwoE2BbyqFVFHQozN//iJY5yt1xHJbL+XH1ndPRcChxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787132041; c=relaxed/simple;
	bh=kXAsaXEapjGekR0SKDzQ3qc47yMzVUW7M+ikDRB+Ge8=;
	h=Content-Type:From:To:CC:Subject:Date:Message-ID:MIME-Version; b=ISdiFGod93EdzeSJMHSRZ/LC7TXRAyHkNRf/jxedvsUO37o0L7vh66bfFfPjOVtFttU7ngD5gcmeAh0e0xmhZF8t6IBRNOqyWbdVis2ZapR7jT26Wxp+6uOffa+16pHakEv3mAvWcrjQsngVh+bg9BPGZY62KR5Pgl/jtOqjkx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amicon.ru; spf=pass smtp.mailfrom=amicon.ru; dkim=pass (2048-bit key) header.d=amicon.ru header.i=@amicon.ru header.b=CwZjTqn1; arc=none smtp.client-ip=77.108.111.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amicon.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amicon.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amicon.ru header.i=@amicon.ru header.b="CwZjTqn1"
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; d=amicon.ru; s=mail; c=simple/simple;
	t=1787132027; h=from:subject:to:date:message-id;
	bh=kXAsaXEapjGekR0SKDzQ3qc47yMzVUW7M+ikDRB+Ge8=;
	b=CwZjTqn1m7h2rnMdofaKtvupPPw5BDNleY1DlXyKaLdzkfrMHZWri8LgVTfPcqWNCxV1o82SOyv
	SJQVudk8Xqqk5mz/qykx5OYD20+nlOwjCQmtSkdEtB01xB0ma6G5xukIZNi2eLcZUoT76FPHAO+SZ
	qa3MNnX7wCXzyVzyqDHE38Sj6UqVmk2DWeqaMSXaR0M9a3p4m29NJUwbYuUJ3JdpYiSy7jkgPgiMh
	jVEsipYABHvltXIkD4wW9ivzS27swU2xPjj4ZtMMJ0rqaU1k9oaTaY7R4EkWSzfMYVo2IS1YTSRoD
	u/kCiOHZ1hiXdo59Ejs0mnVNQh2aFl7mCxLA==
Received: from dish.amicon.lan (172.16.30.10) by mail.amicon.lan
 (192.168.0.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.27; Wed, 19 Aug
 2026 12:33:47 +0300
From: Daniil Iskhakov <dish@amicon.ru>
To: <stable@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Daniil Iskhakov <dish@amicon.ru>, Achim Leubner
	<achim_leubner@adaptec.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Agalakov Daniil
	<ade@amicon.ru>, Roman Razov <rrv@amicon.ru>, <lvc-project@linuxtesting.org>
Subject: [PATCH 5.10] scsi: gdth: ensure event string is NUL-terminated
Date: Wed, 19 Aug 2026 12:35:20 +0300
Message-ID: <20260819093542.23409-1-dish@amicon.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: mail.amicon.lan (192.168.0.59) To mail.amicon.lan
 (192.168.0.59)

No upstream commit exists for this patch. GDT driver was removed from
kernel in commit 0653c358d2dc ("scsi: Drop gdth driver").

For GDT_PCIMPR controllers, the driver copies up to 256 bytes from the
controller event buffer and later handles the result as a C string.

If the firmware does not provide a NUL byte within the buffer,
gdth_log_event() may read beyond event_string through printk() and
sprintf().

Force the last byte of event_string to NUL after copying it from the
controller. This preserves shorter strings and safely truncates an
unterminated full-length event.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Co-developed-by: Agalakov Daniil <ade@amicon.ru>
Signed-off-by: Agalakov Daniil <ade@amicon.ru>
Signed-off-by: Daniil Iskhakov <dish@amicon.ru>
---
 drivers/scsi/gdth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 5d801388680b..744fc1bf1855 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2562,6 +2562,7 @@ static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
                         if (ha->dvr.event_string[i] == 0)
                             break;
                     }
+                    ha->dvr.event_string[255] = 0;
                 }
             }
             writeb(0xff, &dp6m_ptr->i960r.edoor_reg);
-- 
2.43.0
