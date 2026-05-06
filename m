Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C00A3D6470;
	Wed,  6 May 2026 23:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778111160; cv=none; b=H3nYobuP3Q/J17OWUC66WMmb0sTSfUBm9h+Jc1/il7BDv5fpsM6T7NyClkGbl64ZVsuWImyhnkDa3TAPGxXcg1NfPdFWvKPFJvhj55c6DZgRqrOo8HbSqv8J/QzWeEpYmVfGcfIsN6CUqZO+WP8EQ6qK6bORA7fOvglnG+E/HcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778111160; c=relaxed/simple;
	bh=1irAv+3MHfTXWESaNzg4xLYuIifqdSJCqBORJrfLkmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSxlL+Fjgkm4GkXOclXM/ctE5cgOuX8Vuy4Lgf2Rc5Cn4OMyg6ZHOTU/oDonL5uvstNHqpbhBZw49nRQ1ifb+Y64FmZnfhP9vi/DR7e20It+Xl9NIBxXXflEQLRNSiGFc/JiqEAmbvtKrHyT9J6IYwfrR0bWFr2j+VcN/K01qyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=DuQ9oFsh; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="DuQ9oFsh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1778111155;
	bh=1irAv+3MHfTXWESaNzg4xLYuIifqdSJCqBORJrfLkmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuQ9oFshTbqbKes/2b6cca/7TqqwF6UfoS0hDth/PD0BRVV/GZp0kzpyCUwj9/Ev2
	 7xpNXR6aOwOgf1VI7rHJX39aecz5S5mKo+fYMcJ8hHGXCN1qTTeJD47HM+P7/psGXz
	 C9zs5bp1okiX42TW65L8Zu4dasrkIFPKE4iBP6pk=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 97B0FBE624;
	Wed,  6 May 2026 23:45:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 604B15F8AD;
	Thu,  7 May 2026 00:45:55 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v4 7/7] scsi: scsi_devinfo: extend BLIST_NO_LUN_1F to MATSHITA and NEC PD-1 variants
Date: Thu,  7 May 2026 00:45:48 +0100
Message-ID: <20260506234548.1974603-8-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260506234548.1974603-1-philpem@philpem.me.uk>
References: <20260506234548.1974603-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Panasonic LF-1095/LF-1195 PD/CD combo drive was sold under three
OEM identities: COMPAQ "PD-1", MATSHITA "PD-1", and NEC "PD-1 ODX654P".
All three are the same drive mechanism with the same firmware family,
so they should share the BLIST_NO_LUN_1F quirk that was applied to the
COMPAQ variant: PDT 0x1f / PQ 0 INQUIRY responses on non-existent LUNs
are treated as "LUN not present" rather than as a phantom sdev.

This patch is offered for completeness.  It has not been tested on the
MATSHITA or NEC variants -- the author only has access to the COMPAQ
unit -- but the drives are functionally identical and the flag is a
no-op on devices that do not exhibit the PDT 0x1f response.  Drop or
hold this patch if confirmation on real hardware is preferred before
extending the quirk.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/scsi/scsi_devinfo.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index bfc2cbd43897..ab1ffa9433b7 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -201,7 +201,8 @@ static struct {
 	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
 	{"Marvell", "Console", NULL, BLIST_SKIP_VPD_PAGES},
 	{"Marvell", "91xx Config", "1.01", BLIST_SKIP_VPD_PAGES},
-	{"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN |
+				   BLIST_NO_LUN_1F},
 	{"MATSHITA", "DMC-LC5", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
 	{"MATSHITA", "DMC-LC40", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
 	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
@@ -212,7 +213,8 @@ static struct {
 	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
 	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NAKAMICH", "MJ-5.16S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN |
+				      BLIST_NO_LUN_1F},
 	{"NEC", "iStorage", NULL, BLIST_REPORTLUN2},
 	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-- 
2.43.0

