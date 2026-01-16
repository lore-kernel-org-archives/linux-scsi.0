Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95F9346FAD
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 18:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588011; cv=none; b=nsqyLdI48Rwkr18iVHWt6DZJ6XS4H2crB4yRn7qj8KXgQWQh8zJr7/93QiFuJInKtu8eLhX1nSDFO/MjoLqIO5/13lR3TdjKgGuInkAz/NHwYgge+f+whSLh4nu/oJfAgRjLWD9U+DeyrVYvTCld5fRZtniw+qnnN5B9M1HGdlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588011; c=relaxed/simple;
	bh=aLZey/tZhgdag+3kXexTw6jB7rYmYLVGPB5CGh2ZPA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqPFroDh9DyqOlANkTg1YSugQLB8md1IXHMy99D1dgmoQvXT0no+OGrVcB3Pkh6HN13xwZ83ly0V/tgULlToR4h/5qFWNvdbgW4FQhrMZcan4fIzrBxth8/J8zt/ZW82Bnf6y90Wmy/jFdwmT69zxIiAYnoKh6yPa85YIsdhKVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=a5P4TGpe; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="a5P4TGpe"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dt7bs3c9qzlfl7l;
	Fri, 16 Jan 2026 18:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768588007; x=1771180008; bh=mtgcf
	Y2YVowbzfzXiagsb2tuaynHk62dXDLJcKc7RPk=; b=a5P4TGpeyXtFYAsfGLtCk
	GGkHoug7M5B18CeZvIsYUT7M/u6i4g1mBD7MwDJl79BLFxMipXhd99DFf+HHIBEH
	jDQMArhV+hMd8rVz3cxitAtsVZrei2Zhg9r4kM4YZHrO8nKzTGxSkvO//FKlOuzf
	IC2YOf6TRZMura92086OmOfRSWOMrqRJCO/S24RxSB344dpCOdgLJg+GKAv+CMF8
	tJ+cvozPpJ+3GwNbk6HOM4aapYNRisbEY4ya8jl90hDW6PcSqq8DkfNqYM9bvvXL
	iTVaSWH1UmvTdrNvZcygejjQshDVIkhXmYvs3HHO1nVSmDZpajnDfashnQh6N+kb
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VzFhJjIQi0ag; Fri, 16 Jan 2026 18:26:47 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dt7bn5FmRzlgr4B;
	Fri, 16 Jan 2026 18:26:45 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 1/7] ufs: core: Change the type of an ufshcd_clkgate_delay_set() argument
Date: Fri, 16 Jan 2026 10:26:03 -0800
Message-ID: <20260116182628.3255116-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260116182628.3255116-1-bvanassche@acm.org>
References: <20260116182628.3255116-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for introducing a second ufshcd_clkgate_delay_set() caller and
also for modifying the implementation of ufshcd_clkgate_delay_set(). No
functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 7 +++----
 include/ufs/ufshcd.h      | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 057678f4c50a..2ee1947af797 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2115,10 +2115,8 @@ static ssize_t ufshcd_clkgate_delay_show(struct de=
vice *dev,
 	return sysfs_emit(buf, "%lu\n", hba->clk_gating.delay_ms);
 }
=20
-void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value)
+void ufshcd_clkgate_delay_set(struct ufs_hba *hba, unsigned long value)
 {
-	struct ufs_hba *hba =3D dev_get_drvdata(dev);
-
 	guard(spinlock_irqsave)(&hba->clk_gating.lock);
 	hba->clk_gating.delay_ms =3D value;
 }
@@ -2127,12 +2125,13 @@ EXPORT_SYMBOL_GPL(ufshcd_clkgate_delay_set);
 static ssize_t ufshcd_clkgate_delay_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
 	unsigned long value;
=20
 	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
=20
-	ufshcd_clkgate_delay_set(dev, value);
+	ufshcd_clkgate_delay_set(hba, value);
 	return count;
 }
=20
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 19154228780b..b4aef7acd351 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1433,7 +1433,7 @@ void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
 void ufshcd_hold(struct ufs_hba *hba);
 void ufshcd_release(struct ufs_hba *hba);
=20
-void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value);
+void ufshcd_clkgate_delay_set(struct ufs_hba *hba, unsigned long value);
=20
 int ufshcd_get_vreg(struct device *dev, struct ufs_vreg *vreg);
=20
