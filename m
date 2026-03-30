Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77EC3C5DA6
	for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 13:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774877678; cv=none; b=XRk1pIk4MiILCy1bPVwOLJqb12FrDn5ACbUqcomZTBLOcgjdm/ilbfPxn662P2zxeG5Pb4FuPag/34wRtADP7CG1d22TnDoQtZDVYTKpwQEPj4u2kA3gVLD90HpAZ69kN+c1puda2i8AyIqPTyCOzx5BGMAo+WR8IgxMt6vk5CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774877678; c=relaxed/simple;
	bh=SMm/MalzvwZOuWvtsnqIE4P63pybRiqqI03IrNEAzd0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gDvg+C5Px5o3Vy+tR6OlcWu8cTtVUNsVCeL2DB8iURREnKqJNB1hA6eSUBOmTSGnTvDbeLlxsAet5QubtizC7gL2r4ZoGQYZMtpJwCYMZySanKcy3XLDiWrwH4347FQrb/8j0VY8SaMVAB7uSxMQsovUCUWcjg37tj5/V2lf7AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iM4blTxb; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iM4blTxb"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-486b96760easo49637475e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 06:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774877675; x=1775482475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OO2vG9yiybjnLZsgJDrpUYIdHTE0h5TlRhucZVQXxNQ=;
        b=iM4blTxbOzoTrsor3ntwIh79hhxWZ0V3IdPoO9Ht5Ttd9oPdedp62zfdpitRiMCTjf
         L/klI/gCdcQ3/4NpPNKXy79qE3urQO6mAZ0iF3o6sNwes7u+7HWH7VAPJ48Yd2zfLm9m
         /n53JudmyAcSZz/GLBgT6aHMZLlrg9xXsVijQDLcZU3scIP6ZGzfo2rxIRbBEzt58u23
         dHF/lM3l8NpNFLUxQoIzEeLo5ioq30Z3ZoCnwwX3xEB9ISNrtsa6tqVoJQriMgBbxnvF
         gfcM1sUC9FjhMfd0onshYU6JYvbZ6GDV6SMsLo5KIUMGpTYgHPgU+jazNcvPs0cB+LGu
         UKZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774877675; x=1775482475;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OO2vG9yiybjnLZsgJDrpUYIdHTE0h5TlRhucZVQXxNQ=;
        b=l0jr8xb9rlVLTOHcuvzUAONLrwWdEYv2LsuUFvl1kO9Oi0/hladMXGL4UaS4MiYljA
         vZ0NvMprByMPHKkW1aFazFdr/wG8V4ZnZfnUCjA5uSLLwfrFsP7ImPnkZX1/IFHoZDBw
         sI6+mWa8rFtcPKClLjuE2LRivJSoML6fe+tXle90dY4DFL0hpSR1e7EeBnMlnJPdiWKq
         S7xI9ZkVnWmapFRUElRGBvj5ewqkxqH3WfPT+/A9YcDdv8BvSbFRGIWeYFGJpe5fCtzi
         iGKglf5Nrftc05IIq5amLxZaRXMSEpCk77so+FjHrTeb7S29EwGprHcChwaA5qMZIVuP
         uovg==
X-Gm-Message-State: AOJu0YwjRbfJCQeFcji3WVoUfReRPdlNRQCgaQ2OyVhiKLu8ij2Y8pZ0
	vvpvcOeT6KLSrsNP7JcOpVTcmWHqzgVNCjP6D5Os8+J6uH516TBe1GZwz0Mawvyz
X-Gm-Gg: ATEYQzzQou3V2YU4XSBgMHL/7k1jqTaHZ5JAk+yU7LV/Dva7dOv3ujKTDy9C0iWzXsE
	fWNEpSH4OC5UwSDH8HBPoJh4d2FGuqPfXjCd7Dv9CJrBkRvNKp92VvuQKl5HGnrSxXtY0AD7F8x
	uXQwO8bYx3uFzRMuozZO1d20/cw6Du1Dta83zCSPjRdhCcj4xFe1/5jgA9pf5VmYV2/qQcQqj/B
	0nwHLs6rItwc7AjGzNQRoj7RECerGF4STTVa4eRvTvhfvsG6MBGGDu/IvhDE9DxJANsKsZ+V4+H
	yx5ix6ePPm+kyWLpAQcOiA/oBSDCwFHcFnofGYMFIbmEDFA4QoWOtuHZx+3snc6Vx+Fl6Ryaj5C
	oEuWQVVANBDKYAs+AV//+wsCEQCMPjdP5+eOXN0z3m5ad1oZacp3mz8oHTMyMSpxFPwLXj2AqiP
	7ixc7D7UKvEgireSf+abUuLM6k8KG0/pE7ExyzOusdAW49/J4sVHDuqwqYuMqyRU26mG8Z7/Cef
	yWZuIdzQge54xtw8RD6O3JkOjOCjxXQT28e7YxqJ7R1V6/qhwrIIA+8uMwGpVTIAwPD+C9z6V2y
	ZCvOcmhMUhvLIhAkuxez
X-Received: by 2002:a05:600c:4e02:b0:485:3b9e:caa7 with SMTP id 5b1f17b1804b1-48727edf669mr201561995e9.23.1774877674488;
        Mon, 30 Mar 2026 06:34:34 -0700 (PDT)
Received: from particle-0df3-d360 (2a02-1810-950a-eb00-f9cf-2393-cb7f-6fd9.ip6.access.telenet.be. [2a02:1810:950a:eb00:f9cf:2393:cb7f:6fd9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4873881c195sm53843005e9.9.2026.03.30.06.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 06:34:33 -0700 (PDT)
From: Daan De Meyer <daan.j.demeyer@gmail.com>
X-Google-Original-From: Daan De Meyer <daan@amutable.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	Daan De Meyer <daan@amutable.com>,
	Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: [PATCH] scsi: sr: exclude CDC_MRW_W and CDC_RAM from writeable check
Date: Mon, 30 Mar 2026 13:34:03 +0000
Message-ID: <20260330133403.796330-1-daan@amutable.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The writeable check in get_capabilities() includes CDC_MRW_W and
CDC_RAM in its bitmask, but these capabilities are not determined from
the MODE SENSE capabilities page. They require the SCSI GET
CONFIGURATION command, which is only issued later by cdrom_open_write()
at device open time.

Since cdi.mask is initialized to zero (all capabilities assumed
present), CDC_MRW_W and CDC_RAM are left unmasked by default. This
makes the writeable check always true when MODE SENSE succeeds,
regardless of the drive's actual write capabilities as reported in the
capabilities page.

Fix this by only checking CDC_DVD_RAM and CDC_CD_RW in the writeable
condition, as these are the write capabilities actually determined from
the MODE SENSE capabilities page. CDC_MRW_W and CDC_RAM will continue
to be evaluated by cdrom_open_write() at open time via GET
CONFIGURATION.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Daan De Meyer <daan.j.demeyer@gmail.com>
---
 drivers/scsi/sr.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 8ed002f82e36..0a6413b77dd3 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -901,10 +901,14 @@ static int get_capabilities(struct scsi_cd *cd)
 		cd->cdi.mask |= CDC_CLOSE_TRAY; */
 
 	/*
-	 * if DVD-RAM, MRW-W or CD-RW, we are randomly writable
+	 * Check if the drive has write capabilities. Only consider
+	 * capabilities that are determined from the MODE SENSE capabilities
+	 * page here. CDC_MRW_W (MRW writing) and CDC_RAM (random writable)
+	 * require the SCSI GET CONFIGURATION command to determine, which
+	 * is issued later by cdrom_open_write() at device open time.
 	 */
-	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) !=
-			(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) {
+	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_CD_RW)) !=
+			(CDC_DVD_RAM | CDC_CD_RW)) {
 		cd->writeable = 1;
 	}
 
-- 
2.53.0

