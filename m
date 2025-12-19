Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11C52F1FD9
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 09:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766136373; cv=none; b=AJVyFpIvIS07BU+7/6bZRMpVzbaKzD5MOe98B7fKiKNtX8ezNwQfPRMdAvQB02ywdhkdU6Qb4OVwQ+dEOEYqEqb5bgwKeEY/csVf0AUN3Qv4tyUlVfmDtlD0AYHXvueFft1HQrIhzQpwKW5YOiHbb2530FOS2LMPzEXuitnaN2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766136373; c=relaxed/simple;
	bh=Ha+uiHaMJra/tpoJYz18Ffvn2OeV0ctEe8T4bPF2qP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2vKMslELkUe+8SY1bsvqZJpogMSnoGPa2kfu1bYWA/alnL8ELHkOwcMgqFJfDpoOCEc14d8l1q2IxLtsWxJUgMZO2eW+ut2VdXQds1Q8XO1hOMFliCm25klamA8E+l9eixOGr+XuvnT7dlOPpzsTY8/XWwT55KQe4Sd4u1R8LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=lD3wDDEo; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="lD3wDDEo"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-430fbb6012bso1090273f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 01:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1766136369; x=1766741169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahgjes9XzM+jSKJ/cc+7D3vL3FPvfaJVgUOakHx6XCQ=;
        b=lD3wDDEoPJQU5uJfmUTc6jNkV5eUmAvBGmuPBuE5vcBVGv/Boo1sHhYdpxvassuOSp
         b6VFVkkkZ1AHGioj7r3pyezHAqK04aCsOA4fKD9Oq+Oxuv8JuP5rYfOcxb5++WqUl5jN
         /rclxF8rw2p0HA3EjXEIeibXgKX4j57Es5TwPM5/wSOuuC5HWchrmqGH1sSYDPH7AdAE
         ydQQxhBs2Wx4Y+K3j6JmDp3eB9MF3n3nMuHjfO2+CAhKFiiaTYcfR2YvRiaAeE8yI/aD
         M/g1brbBuj3pkN0h+aO2t3Nj4CmWkdwId9Jk0mZMV3tMfBfpW6v6UF9GbvDCxcBRHCJi
         Xw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766136369; x=1766741169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ahgjes9XzM+jSKJ/cc+7D3vL3FPvfaJVgUOakHx6XCQ=;
        b=DvFhFohW7A7zpMXZM2Ykj7ogGxeJByxROsvrVz6WsX7P5CtFV1wz4vc+wCVSC3TpXU
         Ql7wNdQzmDCmZD7b+Nb3bCmFQ0XAQ5Onayeh11z0v19P2RHWix6GaZN3qcK6HcauPm/g
         pylLMCzumeB31LlX5V2Mkz+tEqXEZqn0GI1swRb99yIxcLeYqu1fOOSBfMHp0QpdD73k
         1++PJsMsB4ihACzTppTT+q4Cqic5ty89E40DRvlSMLaRzMOpOKWXrzye+WfoLcpceZEM
         aTwRxYX/zkf0/YKCdcgXvuEG8F52O3ZcsAtFWLmQQQTHi8FPD8FR8LYZj/1J6AiiHG/E
         xvZg==
X-Gm-Message-State: AOJu0Yy7Xplcr3rC4ip1meQ74uXer3JndMFdBJ0YCCzNS3fLAWLdxUVO
	5dWjKMvxtFT1gnECR0xc+jar+uqKDPuH6JxYl+SxV0j3Aa0Sf44SyCouuzllu99q5d8=
X-Gm-Gg: AY/fxX4nnHNdWBl0ZWFNwEVpX3IBZ/ZW5V2uaCUmw6OzMyboKjdm2lvGPeGEdKJ2psc
	pB3XaKYPBqDZFTIR8BrPNJGNgE5o77TisOdknG8Uq5ZEST+9Dsw1zddIaqyBeUFtEhvDepym3d2
	YoVpRDWpU6La4RfAOK90QMT9rwyB/qBnvifT9UBou8U8GeFQR2ve0OrLH9lS+F0lY6zzfVvnDqy
	ntRFXF8gDuMk45H9yTbubrXRiFss6fjC4lGbjsyiLL9nvzGdSWJ0ZNCrcw4oOzyu34W3KHPekak
	6COYiRCyQS+F0ArTJJyfZ41LZG8HdkMLcDx8bdFh7TT6PycNbeOERUlTaFGT7X83LnUVR84ixIl
	V4CLJg8/FoUYE2te+QuVdEDtPu2zGTjattrZi1cM8+Ys2RI9XbZ9E/2ab228eAFmS6iBvZ1GZ3p
	qLAJzavhVNaTDfUcooff48wNMEAPIOGEQUCU3UO9DqFJNOxwljCR0OhZWUauIcnP+Kdg0oxxXMX
	Q4=
X-Google-Smtp-Source: AGHT+IEiaYxxjSh6As+/RGh0LXqO3qZFkZDFx8+qOOE20eUg1POT836cP+rSJyDu+DaLqqr8/KTMdA==
X-Received: by 2002:a05:6000:26d1:b0:430:f463:b6a7 with SMTP id ffacd0b85a97d-4324e50ec19mr2490421f8f.45.1766136368795;
        Fri, 19 Dec 2025 01:26:08 -0800 (PST)
Received: from localhost (p200300f65f0066087cf387e078e1a5dc.dip0.t-ipconnect.de. [2003:f6:5f00:6608:7cf3:87e0:78e1:a5dc])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4324ea1ae12sm3928549f8f.6.2025.12.19.01.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 01:26:08 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: =?utf-8?q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH v2 7/8] scsi: st: Convert to scsi bus methods
Date: Fri, 19 Dec 2025 10:25:36 +0100
Message-ID:  <6da44731f77e8fdcd18e5f438643d58c98945db4.1766133330.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1766133330.git.u.kleine-koenig@baylibre.com>
References: <cover.1766133330.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2115; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=Ha+uiHaMJra/tpoJYz18Ffvn2OeV0ctEe8T4bPF2qP0=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpRRofKLKjBBxH21zYxWEmyigEpUduGoy0STVJB wPCVSxcwEaJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaUUaHwAKCRCPgPtYfRL+ TrU7B/93OZvmNh2x/gsH/sjmd1uM51Q8vdmyhwKjYRYplUwhwEn5UcpkCAsI4DaZ7AaejGOwxp5 hECRGee6BlgejWL4pnYAmsbOC6fuE5SntTCAI+UnjMgg9RfDaOtw4yLSYd14kjfddSpRsfHmkFN IRy2zxVkrFUIv655VealrIrfJlEso90sqsiVVcLnZEJtuXAJiFWc9ZM+7TZWjYeWRKoo8h9UZVI U0wK5lidHeOAKjppazoFeODQDwLOKu2Ez7fGZA/TDh83fnGn0NHacZ+WyGGlX1t9jd6COhob+O8 2vTon7Q7jE2ezUxOjxqvlyma3HwQ4X17c11pPN76sccC2SEB
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The scsi subsystem has implemented dedicated callbacks for probe, remove
and shutdown. Make use of them. This fixes a runtime warning about the
driver needing to be converted to the bus probe method.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/scsi/st.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 45622cfce926..40d88bbb4388 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -202,14 +202,14 @@ static int sgl_map_user_pages(struct st_buffer *, const unsigned int,
 			      unsigned long, size_t, int);
 static int sgl_unmap_user_pages(struct st_buffer *, const unsigned int, int);
 
-static int st_probe(struct device *);
-static int st_remove(struct device *);
+static int st_probe(struct scsi_device *);
+static void st_remove(struct scsi_device *);
 
 static struct scsi_driver st_template = {
+	.probe = st_probe,
+	.remove = st_remove,
 	.gendrv = {
 		.name		= "st",
-		.probe		= st_probe,
-		.remove		= st_remove,
 		.groups		= st_drv_groups,
 	},
 };
@@ -4342,9 +4342,9 @@ static void remove_cdevs(struct scsi_tape *tape)
 	}
 }
 
-static int st_probe(struct device *dev)
+static int st_probe(struct scsi_device *SDp)
 {
-	struct scsi_device *SDp = to_scsi_device(dev);
+	struct device *dev = &SDp->sdev_gendev;
 	struct scsi_tape *tpnt = NULL;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -4499,12 +4499,13 @@ static int st_probe(struct device *dev)
 };
 
 
-static int st_remove(struct device *dev)
+static void st_remove(struct scsi_device *SDp)
 {
+	struct device *dev = &SDp->sdev_gendev;
 	struct scsi_tape *tpnt = dev_get_drvdata(dev);
 	int index = tpnt->index;
 
-	scsi_autopm_get_device(to_scsi_device(dev));
+	scsi_autopm_get_device(SDp);
 	remove_cdevs(tpnt);
 
 	mutex_lock(&st_ref_mutex);
@@ -4513,7 +4514,6 @@ static int st_remove(struct device *dev)
 	spin_lock(&st_index_lock);
 	idr_remove(&st_index_idr, index);
 	spin_unlock(&st_index_lock);
-	return 0;
 }
 
 /**
-- 
2.47.3

