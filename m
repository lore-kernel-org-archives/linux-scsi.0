Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAB2335BA
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 20:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313144; cv=none; b=dBOvlP5T5SzmkMLxi2siQ+bNXZz35J9VwmIFqU1AHEa8o4/uL1BTmE0GrRb8LgFsL+qbCoeInbAFz9diLlg8y2Uj66CCRQ58wGl3mCJZtLNw3LF864NWfBnvFwK2cX7f7R9qX77jpZGa24/9iKYnqGpI0zCfIsld/1Y9FQ/ufS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313144; c=relaxed/simple;
	bh=FUi2lUc8csVQ3CwUjNI7QrZ++iyIy7VXB7BzrZqZyhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kfe4WiWr1t3WsIpnRcf7wai/RBIAqLqHdntQG4JS7D9f9QsOei7W7ZHIjZoHym8ZcFzq/vCMrsQQo6agTaUmNHi9RNW8eE4Y/zRhJS0M0hWpyvzVoFHFw2Z2hh+z4YYrxJ7oxTjuduQwe8OrkKNjmYG/ILctyeFUHvFgZ3T9ny0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=T19mLdok; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="T19mLdok"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64951939e1eso3066346a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 12:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765313140; x=1765917940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9BjS3Brvu+yeXg6ZhNe+gRYs2eSaCSu1ogiWz1KPaAo=;
        b=T19mLdokCTvnpRmX3X1YQ11Xu8rPpLGmEbyEMRLuzWsIYVFR5Sfh5Y6YYONJK8f0ol
         bx/FFDUocyFRAPEbwTdYbA7eO4oP43VhCZdd9p9KP/Ptg5M85YWMS/YU8O59eqsz8Df+
         SLWJ45cNyZzAzyFp6FpnMyt+GFDRnPQDe2+Ug+rQqhoMo+ce1muMZsGvyQLNURP7szkh
         dFSgcd+G1K38AmsAbbJRD07UvyjOLieQcwaMGpE15IdU5BCa2pPvkqXHCUHWIOITZlmN
         K5XWQSmkjlrgWsvdrIi+xv72QlS0FwxMP+DFxxQYpM9dnT3ScOCBrUwmL2m0yfVP8R4/
         F3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313140; x=1765917940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9BjS3Brvu+yeXg6ZhNe+gRYs2eSaCSu1ogiWz1KPaAo=;
        b=TO2qjQEU7fT8n+4kv6Ec4xlj1Qz1ovyiToCqBp4VXW7CvF5Qe6pkLfdYPryku23S1J
         aAC9TtMwerpG5k8ReFH7A6WgF/8XEa53FcC60SNI9TnGQUTYcoc4T9oZIINnPdX5eeuQ
         OGjMnEjZ5tixjiu6JejFFgEmKFtm/e93qhiVDtBp3h5tVn5QMhZJtFgdHpH/PdNUfCgJ
         jAfxGTLstTtrmQIvXZu7z8cViyfd3EUDrjnvskNesasSC5yBmpPoMUWAYDluN4nk0fdJ
         HiqGhY2xSPCcouZ8BU4dXsJULg0lah+ZtmragDSslpm26kcvcFq3ipR9Waavj92rOwua
         khdA==
X-Forwarded-Encrypted: i=1; AJvYcCWweBI5DeC5GVLGZDXxNwdD9kHMTvLPWXPa9N1C5rMA17XXzrLppBoswJFRjIN5E9/nxuzJAjUsUS1O@vger.kernel.org
X-Gm-Message-State: AOJu0YzdmW3i0cUNK2EbXbFOfPie5Fy2X6C/bMgb1gMs4Q195RJQSitt
	ynaC9DK5oy6QaRE5Y55dRWWiOJNKDg8jLywRWvu3lKrQMx1NLzITANlNRgxk23iBsb0=
X-Gm-Gg: AY/fxX4X4yfl/18E9+Tr7Y32yx0YNnheEPejHvFuATqmAbIJ53OV/9DwE92HgohQ+1Q
	nm7fUeIaLyfZqpY1ae6MYywp82EdlxV4SNSwUaHb0V7231fP4JU+dm53D1fLOw/UMG6+/wiPSTF
	fKeRGeFywfcFxEaeYvfFo3jPmUv9+fAHBYYY5RI6DyFQuCmNyRessJZW9WUqVbkq/1TZO2HWmty
	P/CHkx5FlRyiVARINiFR8pZtznpKczuOYPhZKcZGoOmihDPDhYnblNHCHiCOslUzhiLqCfvUW7W
	YphntAkSgce15Ypb0U5IkVpy+vJVGG5Fnl1ZSrN6qVaAb930bMJMFuU+AZYocZn1ljV4Drb3CGQ
	qXzI3Hn9GIDeFRUSP/SWym6qCzcR37bzfvn/Abjnot6zxdqImc67PhzeY4AooOdBhnIbJ9AuH5m
	v6o36TvGE2+ooymc6y
X-Google-Smtp-Source: AGHT+IG/Zrb+rnQQwVUNU6d3JXfgV2erBpYwsk6T7kn6i+Lx+//NgKl0Nwf9ntToIgofxxdOwlgwvw==
X-Received: by 2002:a05:6402:1e8f:b0:640:b497:bf71 with SMTP id 4fb4d7f45d1cf-6496d7f7f36mr144284a12.8.1765313140537;
        Tue, 09 Dec 2025 12:45:40 -0800 (PST)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-647b2c5575fsm15228967a12.0.2025.12.09.12.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 12:45:40 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 5/8] scsi: ses: Convert to scsi bus methods
Date: Tue,  9 Dec 2025 21:45:06 +0100
Message-ID:  <a9a01533654e6accd3fc6acb85238e772834c881.1765312062.git.u.kleine-koenig@baylibre.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1513; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=FUi2lUc8csVQ3CwUjNI7QrZ++iyIy7VXB7BzrZqZyhg=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpOIpZ9mzIytwwzE8jjadVBegTno7P18s+6Rlq+ Ur1HjGFpV2JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaTiKWQAKCRCPgPtYfRL+ TirmCAClKVkIRQNTfYWIw7VerXpOMqD11mwzqOhyZTojT+GmTXMYEwwfk1Yg1ucso0AoxvscutW 5z/NV6z4n1uzTu3TeRFdIlLUED6BXjn5eE+iPR6oMXknMYF2C8DU80RduKflDqKvU/5Jf1es1Qh 7CBb8UvcLEwrADntGxXPyGkm/HY2R/93a1HdJqr8qvlo7Q4ObTpAtfcaHl+7GSHFeCeVP43sMKA fU2eef0z5OcIWMU/gb1GZjaLExT2aeUdz1Brsh/BtrrYJqZ9y4zl1EYDr5deXs+EeTRDrp/0QHF Yf6s1whbn2e0Hrw+8EUWiZOMJaPKppHkCnf8ZEnitfasnZW5
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The scsi bus got dedicated callbacks for probe, remove and shutdown.
Make use of that. This fixes a runtime warning about the driver needing
to be converted to the bus probe method.

There is no need for an empty remove callback, no remove callback has
the same semantics. So instead of converting the remove callback, drop
it.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/scsi/ses.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index f8f5164f3de2..789b170da652 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -42,9 +42,8 @@ static bool ses_page2_supported(struct enclosure_device *edev)
 	return (ses_dev->page2 != NULL);
 }
 
-static int ses_probe(struct device *dev)
+static int ses_probe(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
 	int err = -ENODEV;
 
 	if (sdev->type != TYPE_ENCLOSURE)
@@ -847,11 +846,6 @@ static int ses_intf_add(struct device *cdev)
 	return err;
 }
 
-static int ses_remove(struct device *dev)
-{
-	return 0;
-}
-
 static void ses_intf_remove_component(struct scsi_device *sdev)
 {
 	struct enclosure_device *edev, *prev = NULL;
@@ -906,10 +900,9 @@ static struct class_interface ses_interface = {
 };
 
 static struct scsi_driver ses_template = {
+	.probe = ses_probe,
 	.gendrv = {
 		.name		= "ses",
-		.probe		= ses_probe,
-		.remove		= ses_remove,
 	},
 };
 
-- 
2.47.3

