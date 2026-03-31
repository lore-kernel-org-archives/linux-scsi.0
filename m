Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC66044E040
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 20:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774988599; cv=none; b=IDVMihlUVaU4hPgDDNKXnNhhhVrHytVl5LCM9ac59iFv7lQZunnfpJ5vZsvWvTuZr+SuEKoLTXZ1ot4R7ncAWxrIgxA6uP/av1ixihSHFxI0SsMdJkJhKirONwYp6aJuhd9ylzxJWsmDCCL+q5x6zW2Xcc5KCuMCJExFTFQszmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774988599; c=relaxed/simple;
	bh=fV1XHTeUIpXF1yqqzeCRjmcZWOPv940xnXhyCV51FwE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sqLEB2CXe0UvcO1YRwSBxGxvsn5Rbl9XUIcc1QetXYeo3UPPf9P1Bj+JKxCzNFn8ckAOpJ3crAZ+/KxTTu1bNUwKzPYTo7E4lFB/N0pk3kFHqiyCWwLgZEfw99LVhEfLLXwOaVWRlb0XeF2x7bRQsRM9ITHSolPSZFjPfjlSrog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gGBzoVtZ; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gGBzoVtZ"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cbc593a67aso662226085a.2
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 13:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774988597; x=1775593397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aY3YsyKkxZcqvy0iw+mK4hvnnKTvQgGHfXYnrWkrmNM=;
        b=gGBzoVtZTEc43SLKsvwdy2SqcEs5dGYwSC1t0ZiP02DBjhBlUpiKwzoSdqg6sAb1AS
         QqR2Dm0EOJc39CLZgWXmjdQfXk+xT1EluXwZKHLoIl2MbIrg5T9nHKaPotR4hsUlSz/h
         HOjf922nY116tjTtGKrDYXdVl3sPHktisIJ+lIJsz8NvdgF8SzaBSq1s/vxECC5Wv6yx
         BmiJSW6oiENWnqsFcjKMxW/Mydjyapx6O8Al8EVmmqZiunLs7m/EjjJCkoLAGPQjFkuW
         UAhP1rzo+KXKy1MKfVxcDBqmUgQpRyovZXH1PUUisUiyURqbwZbiqWQuJ13q1cyKqUyE
         VCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774988597; x=1775593397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aY3YsyKkxZcqvy0iw+mK4hvnnKTvQgGHfXYnrWkrmNM=;
        b=aYHBGDKW3FAEKLQrHsFZgEWRdxc/f7OpVmW+Q/OjSP259Xjl1N6fh4eUPB2iJAyaIK
         3KpQ+ZHpMGUFCOhmTd/nJm3qmo6ag2nogFteFOiX7OE3LiCCnMqXG00UiEvJPub3GQSK
         NdFtyjZbXEHKHOlgATAp0uJTEs9rNfd2aHYztzPep0ldbItZ7SAbD465VDYyg989v+r2
         nnU+ZaEDqGkEHzvE5G2xP5+ZngRCRl94IIZXCDZOz/NcbDFx+lx0hcP7inExgd1AKjDh
         lNkC/ttcGqV7zMAscJeZNrQKBvkEuotMabk73IO1oOUj9MgjBifEf0UZHORSCJHwo+6O
         MpnA==
X-Gm-Message-State: AOJu0Yyau3BpoWyTHhmkUoSjVR0GtdE6eYYmngJBNZPcxF4F6TywvCDs
	leWODbo4vooR0ftOACxSgQK/p3pqnDopjUTYG3EpQ/uUInsvrkFCotg85FVl0g==
X-Gm-Gg: ATEYQzwnkjlWkRXDu1NaX6KNDo7wSAt9sBUTWqmfxMyvhrIbYqzJNILk2sYt3I0DsJ/
	DnyomkcRyluYy1kARJzTjYrmUe/6uBhrrltfuUZoknbAch8GOD/NoEBnaFEBYSajNnh+fK4Vdvk
	nU+pO/5XL5q0aUGnOJ1n56bUdOS/GLrCkBc+pZyz79EW94cwswY6xcHdkQCHAw5I/3TBRpSVmOo
	z1cIgCOl43Ao0hm46UBpkOOTmfs3OBS0a6tO77NCcZPk+9Q4YydIKyv1W2kZbHk+xIYfrAmzK9/
	AEl23PudDbsrLmiqfQwApiuxOD21R48kuhgf8GPmjVCJDziYxp1SPfWzXSPetRCI6Zargzzb8uf
	dTXogGPS2clrh+Rv9zfwjUXzJMpSGw6QDI940K8uy6e+4L2pRl0JiUSnx3RoaWQxSI2W7+5TBB2
	g0EtVvaUSpjeKbVNcY4u10wW47jHkVlWC7tR3mt8WtsmyE07OvzNNx6U2g0O4l5lcxQ0N4dcK0n
	ohmy4b/5OxKmH2JmN3klP4vbjnUqbrdTnVOVYGkG4M=
X-Received: by 2002:a05:6214:3a8a:b0:89c:806c:93 with SMTP id 6a1803df08f44-8a4394ab0a1mr15810186d6.30.1774988597551;
        Tue, 31 Mar 2026 13:23:17 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf865ccesm96685616d6.39.2026.03.31.13.23.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2026 13:23:17 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 10/10] lpfc: Update lpfc version to 15.0.0.0
Date: Tue, 31 Mar 2026 13:59:28 -0700
Message-Id: <20260331205928.119833-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260331205928.119833-1-justintee8345@gmail.com>
References: <20260331205928.119833-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 15.0.0.0

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 31a0cd9db1c2..d6e6e436fbfc 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.14"
+#define LPFC_DRIVER_VERSION "15.0.0.0"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

