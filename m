Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFAE3E3C78
	for <linux-scsi@vger.kernel.org>; Tue,  5 May 2026 08:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777969752; cv=none; b=ordL5SlWxDFhrdRvxYoutGx/n654FVxLW52wFcaItm2DojtPcnREFr82KJikE1No7e1C9pL/qrH49xKGWQJ3EHF0EFpAyPC0lMAamz4qBC+Y6/b2qOj07LqrGRYmDz7sStRmdR+qn3PDyi59hOKHF92ewMDew685q0D7Ao4gGAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777969752; c=relaxed/simple;
	bh=nAGdgOqxCO5R3yvRljfcfI6W3K6vOCYCXlQjBt50rW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jGxvynHc72pjy/NBQUK05peVe8czUBuF+eS+REDdbkNTtnDg2xrcckcRwU1agQecoig2KRmff71ekqHmosJdKINDQH6YXCUtHu6vXkUU8aPi0ABoGPdqqGzKZwlQ2jkexybwm0z3CCdSNCjLlEBNT+HQ5qsO//J7C74D5qGFY3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20251104.gappssmtp.com header.i=@baylibre-com.20251104.gappssmtp.com header.b=RFJny/ht; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20251104.gappssmtp.com header.i=@baylibre-com.20251104.gappssmtp.com header.b="RFJny/ht"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso54527925e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 May 2026 01:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20251104.gappssmtp.com; s=20251104; t=1777969750; x=1778574550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9g3+vDLUTCfva+KOR/ZHqEZAa0QT1YV5qqO7qxrn+vo=;
        b=RFJny/htHyeNAkp2Smr/kfeyYhmBYyMnIuyh1Y02QLYyf60TEzayBc1bh5rOu7YITv
         vhaWrEWm0GdLZPGP4AIrjLWjw2Qn2XHqOa32LgZRgCNUrSZgwSbtQom27zIcckiUXCZD
         kgFcNDJxbIjsrUPKGg66v5xwd6Hh8qgcoMlJHDTVVMFEm/ar2JeWgv2NqOhNs+fWvjTI
         8ILeEyKGE5uw9alKYR8sJi5OzV7TAo2SFYdwaLt90bZ8u/dWQde4rvNBlxSMixuNhSMB
         udIY+uMvUh0lCAauJxuC4AiwjGQE+SIfRlkAHI5jpW1hzMxvfFWlGYcuKPbv+9eOvkq4
         a+wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777969750; x=1778574550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9g3+vDLUTCfva+KOR/ZHqEZAa0QT1YV5qqO7qxrn+vo=;
        b=rhdXPs1r2wREYWMk2R5ExFBzEfLDof3b6Yh1RzfdT3cMK3vwbi+9rsVgVYBOmRnPad
         BuIp2rFUU5A356r1jj1KHMNRflmps7UOByySg3ZxnG2Gi1wEzmG5dNgwFV5MtdqDyS5b
         nHUYmAGZvghRt4CTD+/IOtbNf1EhrePP3VPfmo+fw40MaMhtcd9M84IocyXIchRotNBX
         eULOm73Uilw+yUDSBO39XKZCwekcKwMIVZI0QR6tva+iFQO94FNTj+XiCotQICIJlM+2
         AR/uZIkDU2FLq2P/Kgu2G7hupvNulZ+gqdq+7FuzIbUF6ieyQ8HcDk37UiDe3AS/VY7k
         rDBA==
X-Forwarded-Encrypted: i=1; AFNElJ+kTrERkAcF/diAnOdO22jlbm2Onlmb/fmyatjA0dsYKNfaqF8bU+UAiehOAnn8SRJftB+EF1Yul+uY@vger.kernel.org
X-Gm-Message-State: AOJu0YxUdcZZ+z9nJQ9/VsxBPpxkewBLX4eqW/ud6MQTQm345008W4r/
	wxa3p8S+Owub9WO4FFQ413C1cULb5NLt0CbtLrk32AHMlAH5o6h8BVOWVXkD6Qif6R8=
X-Gm-Gg: AeBDievwlXdstA0i6HvmSQbUnSW075WNVsXKatVVBupk7nYMjwF+DbK/avDVXtp5Zyz
	2tLDXnMSB8VIKx7EVZ/OCzKp0rpYtZ+aSX4+UGgaKyvg0BHg6sHgK6a663QpKf6j+Fso4vZFE74
	DVSao+vrsFMUIEGOFRT7JZB/+E/P+2BQVn3x+24aoyngpMHhaJit0FEfSgXD7fUjGAM9CPJ0Nzy
	HJXPiEM4mJx10lHoZzrc1bFXztoh1G75Ea3EfCFNLag/akntfrdmTgtZguRtQNcjdFOyJbCIQkW
	w17PKrLT8iXPWnM2kghEBwSLRMtMlhIvCGp6AlHSFPZ0vmhYsoALoXVyHxDiVwGhwmtuTT6ZnpD
	vlQrL2A8G6J0/HbbyDOGUVj71na1+kf36XxGvyszIDpshOqzblksKeQr6wIhYp5N1fRuMt5L0qb
	LjmAAHNixbl8T1BKgtdvZtna5iTXlpz2kW3eJwxVEWISK66UXGJ7BNRUPanwcX9gJL1Tsyo/id7
	5Jf4nlLpA5Um2+/LvIn7jj26w==
X-Received: by 2002:a05:600c:2e49:b0:48a:5f32:62c6 with SMTP id 5b1f17b1804b1-48d1426552emr23901975e9.11.1777969749696;
        Tue, 05 May 2026 01:29:09 -0700 (PDT)
Received: from localhost (p200300f65f114e082236c6257eff72a1.dip0.t-ipconnect.de. [2003:f6:5f11:4e08:2236:c625:7eff:72a1])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-450524831cdsm3087006f8f.5.2026.05.05.01.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 01:29:09 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Archana Patni <archana.patni@intel.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ufs: tc-dwc-g210-pci: Simplify initialization of pci_device_id array
Date: Tue,  5 May 2026 10:28:52 +0200
Message-ID:  <ff015bf46ad395702f40c85c8359fd24957e7224.1777968942.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1777968942.git.u.kleine-koenig@baylibre.com>
References: <cover.1777968942.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1139; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=nAGdgOqxCO5R3yvRljfcfI6W3K6vOCYCXlQjBt50rW4=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBp+apFcaTg/mj8XungbZA0wfClVpLshxIckNp/O uvAla13A5qJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCafmqRQAKCRCPgPtYfRL+ TnyTCAC10SuEfFH8goNTlis7F0/RyfYIfi+iUM3F9mRxHbqS+QFAzHGHJvt4QHwjTrc4KdZztLv WkjkJLHqi0cfL6tiSI/XpPKca97DhtuMKVIy224jf8aPV/7lc2OV698PatakaLyevCW6avg3L3C cSo8ta6JqFWBJoHznHVLxcSHWMUp4zEV6pX0VWQhsQkxy7fB4oJEWWBT9JJpQ95tW0DpJGnWo2s 23ZEgAqaEoe1xygd266xaEvLY+g3AunM5/CVA8y9dzS84m3SPoEMyi8MOlzQAVvXsfpvskHLqeh xpKyUicPqtbp3KXLfVVAtYv8wWDCT0wJesJEzDiWgbDCRU4O
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

A list initializer is hard to parse for a human if they don't see or know
the order of the members of struct pci_devcie_id. So use the PCI_VDEVICE
macro which is much more ideomatic and skip assigning explicit zeros.

There are no changes to the compiled result of the array; verified with
builds for x86 and arm64.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
 drivers/ufs/host/tc-dwc-g210-pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/tc-dwc-g210-pci.c b/drivers/ufs/host/tc-dwc-g210-pci.c
index 0167d8bef71a..c6d89f9c44ae 100644
--- a/drivers/ufs/host/tc-dwc-g210-pci.c
+++ b/drivers/ufs/host/tc-dwc-g210-pci.c
@@ -114,8 +114,8 @@ static const struct dev_pm_ops tc_dwc_g210_pci_pm_ops = {
 };
 
 static const struct pci_device_id tc_dwc_g210_pci_tbl[] = {
-	{ PCI_VENDOR_ID_SYNOPSYS, 0xB101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VENDOR_ID_SYNOPSYS, 0xB102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VDEVICE(SYNOPSYS, 0xB101) },
+	{ PCI_VDEVICE(SYNOPSYS, 0xB102) },
 	{ }	/* terminate list */
 };
 
-- 
2.47.3

