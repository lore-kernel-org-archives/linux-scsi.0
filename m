Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEF126E70E
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 20:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313148; cv=none; b=TUjy7ku7D/RkUT0BnJokcI8S30xCiUeqs5xMChs5gxgMNytJj7irnrzjAcEmJIZqyFOQhEKXaxREHi7cZDcFE2h6MJjq0VNMXOXsafSyttesApnA1BowN0GHGNsKqWCOhPlwsH7RtM9pJyk3IA0fZs4WPWg01twWVowk99OmEKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313148; c=relaxed/simple;
	bh=H8u2xCwxhEO9cstxFIISlx3NHVB9V+m2E1dcrwR7MsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QoxhLRejPXPVd3Q7cqtycweWiNbjH/cnfX1VhOFlGIFOo+7F0ecMHu9LoouBsOyBWtvPkd1cDGGHSNTiHEeY24px3K+5BSslOlvafo2uAWoSSdAdwS5GB5a25yFgGzFyrT9qkqIaNvrSliJ7sNdJZUzXXOSWDy69DB5RvSkTT0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=SF/IA1pM; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="SF/IA1pM"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-641977dc00fso7471106a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 12:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765313145; x=1765917945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YHekEjBvjwHMAcNaRPMmdboMQ+Tr07K9smln78GYT9g=;
        b=SF/IA1pMKeDji0bCYpX0iVzmURfOs/GxYfl8j3LIFMCV/Bcsno4fkzByFUhYE+lFFf
         lZfsaBeCkzE+7hl1EIRGw/6N9DDU63tNMSjySB38n5kL2MBnbPTE1nbSpsIW1uUdEWjg
         c8PignzubY/RNcdjL7Fjw1oO0QW2Wseg2x4M9jkOviBkvP+aj86caTevj1QZI1iF9Zh7
         oAjpw91izJ+Jl0Sy7k2p5QYi0yE4k77VZSS2ly9NS8412nPJBkpPrxtizyd+3I57oTtZ
         IiAbAsakDou4nPT5WlWVi+6FzcqpyHYxfZWG+oEtBW+WW5EBPpIBsPze9/STtKRhvjNR
         sm9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313145; x=1765917945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YHekEjBvjwHMAcNaRPMmdboMQ+Tr07K9smln78GYT9g=;
        b=vmr0CIYCl6wJIW7w8cDX2lNXr96+eYCpvSJnQpE8fUwUPLHAp1wQSegQ9fKsKQ5UMf
         wfwm8QltXx+BDa82FNsNwPxw2fvEIAVHA+QO4K1lIxwiI0JfJkumbh3xr9MuYLvSkm6T
         0t0k3Gew0WvHRlTAFm4ziJ3LFqsaB3AtBFg5cJ0WMoj+RH74gC1FgIaubpppq5rMY9Sf
         LFLTXAU19jDtoyXG0DYGBkLXNbygzHvKGIITx4L/FlwDoIk8g09c6Yt8OaLqDrF3vH65
         M7l747ChylF5+EtZNjd4rhk7GFLxFkl11L3PRk2+A6juhYwLujS2XNE9kXbyCS7Ninbd
         aoyw==
X-Forwarded-Encrypted: i=1; AJvYcCUrD4nZrAMTvYctLkLjYQ5/VfwH28x7ke4NnTx7T+LOhezhaaChGaj7iOdUlSaRRh5Ly7fllUpzSHLi@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5G/6zt0ZD1RsCUU/xZje8S6X1p6BOqT3F9uLrAacU27JzLyer
	T350Voh9W71k85e6I+11ZJrzS1maZV8eq5KqF7aliqJC0K0vey4xzYN/J3ho4t5XxL8=
X-Gm-Gg: ASbGncucO4mcsaeI50ja5/h5U3Q8h5BHHhglCGr+4m+MlwlVv1h7kMz7+pwbWlckMvX
	dZgYTGGco+lJYHGSmcazn5Xz0iAJ8xpioordd6/Qv4blu/vUaJYWDqXMCWqvDlN36MnIwB0hiog
	kXcQjGB+wWWLG5Eq6vF/3IYJXdtYu8Rj/hE6DHw6smIz1yZFZxHvkM3tW0KAnVEeaI3znNdK+W0
	3LNatDQganzqrKTJh+tgA0PQcbBfyNyb162iXOYRVeFGqSS6XPXzx4kB+9blMagYHlGVgaBgx4/
	QOrhOwRsMTOpwYzAFhwjvp+afvVYIkS4FSEBezUVjUS1vjEEzlRNGVH3jp3HzZnIRVYmk+mSALQ
	SCraxyU+GrVYtc0WLvGU8gbjtC0MSGuUGlUkyZZyo9wmqTuY22Rjfxkf8G76g0u/5HJ0yT9xaQ/
	n1MvH/t5ayrAYmI/R7BNjt4v/06A8=
X-Google-Smtp-Source: AGHT+IH+H4QQ++Fv53h/hWfJQ7kdMnYmuOCHw4alMlUSXpAK9vlNPTwgLTogWVz8QQfPxpkWab6YGg==
X-Received: by 2002:a17:907:2d25:b0:b76:3dbe:7bf0 with SMTP id a640c23a62f3a-b7a24304488mr1269150566b.2.1765313145149;
        Tue, 09 Dec 2025 12:45:45 -0800 (PST)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b79f4975c56sm1465074166b.33.2025.12.09.12.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 12:45:44 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 8/8] scsi: ufs: Convert to scsi bus methods
Date: Tue,  9 Dec 2025 21:45:09 +0100
Message-ID:  <56e89c3f452dc3c9f343f1b9a9c8b200642da593.1765312062.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
References: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2101; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=H8u2xCwxhEO9cstxFIISlx3NHVB9V+m2E1dcrwR7MsE=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpOIpjODgt+DNTcfTeWKJ+w20sxl9Yo7xd7s5oh ZR0yjFheRSJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaTiKYwAKCRCPgPtYfRL+ ToS3CACNw6nRnaXRGhVQ1Hyzy7xJArdAgGgATgXr2CsevbBsMvz2C/HYP32R/akEB409TGZXmQO Hm2kScAC8H5RWTlaFDzTsTNj1q2NqfhFrxILXeCC92JzLHOWOltcS6q0V7RhyOK+Qz5YeIrAc9w wbTwYjR91No5UexdJAaV5bd4egxyafuibhYMfZPB9Eq+S53mG74vFwzyuXeL1SrUQA1zKisRCDW 7vyRVv3+w5ckf8C0GOUNK0QiQCj+qfRsJ8tUankQj7FONGjei0dZbNwdPp1M6UnYJvAVho/pP/X c2eUvHwGPUQWrPIn2wNK1IaE06KceVqilauUCQazRZ9KwpDX
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The scsi bus got dedicated callbacks for probe, remove and shutdown.
Make use of that. This fixes a runtime warning about the driver needing
to be converted to the bus probe method.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/ufs/core/ufshcd.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 98a3aec81ade..84db44c7a583 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10386,9 +10386,8 @@ int ufshcd_runtime_resume(struct device *dev)
 EXPORT_SYMBOL(ufshcd_runtime_resume);
 #endif /* CONFIG_PM */
 
-static void ufshcd_wl_shutdown(struct device *dev)
+static void ufshcd_wl_shutdown(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
 	struct ufs_hba *hba = shost_priv(sdev->host);
 
 	down(&hba->host_sem);
@@ -10981,9 +10980,9 @@ static int ufshcd_wl_poweroff(struct device *dev)
 }
 #endif
 
-static int ufshcd_wl_probe(struct device *dev)
+static int ufshcd_wl_probe(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
+	struct device *dev = &sdev->sdev_gendev;
 
 	if (!is_device_wlun(sdev))
 		return -ENODEV;
@@ -10995,10 +10994,11 @@ static int ufshcd_wl_probe(struct device *dev)
 	return  0;
 }
 
-static int ufshcd_wl_remove(struct device *dev)
+static void ufshcd_wl_remove(struct scsi_device *sdev)
 {
+	struct device *dev = &sdev->sdev_gendev;
+
 	pm_runtime_forbid(dev);
-	return 0;
 }
 
 static const struct dev_pm_ops ufshcd_wl_pm_ops = {
@@ -11071,12 +11071,12 @@ static void ufshcd_check_header_layout(void)
  * Hence register a scsi driver for ufs wluns only.
  */
 static struct scsi_driver ufs_dev_wlun_template = {
+	.probe = ufshcd_wl_probe,
+	.remove = ufshcd_wl_remove,
+	.shutdown = ufshcd_wl_shutdown,
 	.gendrv = {
 		.name = "ufs_device_wlun",
-		.probe = ufshcd_wl_probe,
-		.remove = ufshcd_wl_remove,
 		.pm = &ufshcd_wl_pm_ops,
-		.shutdown = ufshcd_wl_shutdown,
 	},
 };
 
-- 
2.47.3

