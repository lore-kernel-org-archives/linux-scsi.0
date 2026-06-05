Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EDE36EA8C
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 17:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780681521; cv=none; b=ClGRHP7nw+bWWGTsMokNxtYJI4YA08Q1O5VDXwfXJM5l/YvENcQvUkopVPnWd2PV0ixANXtOK9kTOIA/MuiUNA4q+ErzpRsyeMPvrLyqa++9zcR8uSLygENxITRa5+2dNu+4vRbKDCB9agyAR05gXA3uEyblUumtTZeOKJZvZKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780681521; c=relaxed/simple;
	bh=bdwMNcZVjf0I1CDFWjmxuzGycazN9aJDtvxsS5g9hFg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LmJHlDR78zre1CJLb9i4jSx7jhpKu9Mp0WuBR1t1gHvPNbwZJB8c5zyTWXKtAdAfUdY/4o6ZmVTy43U24b2O1HxeKddtj8NDWDllCcmwmY1ORtNWAfy9prSiR63g9r4ZEH6L26+BqUM0O2X54/4yAJ21Hr73YTisKfRps29aLMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EZlzhAnk; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EZlzhAnk"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-517907feed0so15447431cf.1
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 10:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681514; x=1781286314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2CQIKIOUNHK4p/kK1ZVRgUxKnjETRbt3AMrCW5x1awc=;
        b=EZlzhAnkgEnVALpp1rZIjCiFRVblaVhz3lA9wlKhEFl3HR+IJ3aq8e+OXG3eI3xTxq
         wLM046RF5yu5n0DYqIKfp8xbPm842IJ5FFlsaUqciOmO/mNYQ/r9vi2zqCjNsbW7pmbX
         ebCbOYehmig10vKu59lX8m4LDAXIMFJNfTo0RKSPLEGf0V95qU76WwzL0ZW4lGAY6/oK
         wHbbiEJQ/MeY8qUh+p6DJnUawhoEBWYtsIrTv3vgBrlUMKlvvIN29j8Fj4eo2AzchOst
         7PyUC+zVlchB0FgxwqwQBsgGEknja+DkKQd3zVfo8KPWzW5tURpEa6lilmVyNDW7i9T3
         CdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681514; x=1781286314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2CQIKIOUNHK4p/kK1ZVRgUxKnjETRbt3AMrCW5x1awc=;
        b=HZHp4GpSrzn8Cn3h72rLyrNmcWJlpt6ne7oRepdDD2XVeVc1rURfwCDE3rK+0ClRwe
         ePMdMOoKDoyDFtK7pjD8BDSlajXJwNkrGBNRovRz1o+85lc4diCV/UqAb0uhN+D1YefT
         ff7ZruF5Kn3r6jiyihlMjQXKv0MsKQt04m1Ssh5kCzyqVTmvVdubcAz27EzsJ0QUPQQr
         bh5fj+AyZCiQWZcO5Os4DLcpxvE2MWdXL1SIBYtUvXl/FcbAmLPqeKT/sEYnx4Th1MMe
         lSg5AusTZRINvNvlAdyU6srMR71d0aKUxXB223Rc7a6HSuOn85YTFa6GVI4z6KUhu5fI
         DSTw==
X-Gm-Message-State: AOJu0YwBNIjnh5DvQ0y9kRBbKnsLazTv6s9eQKopcGapE0DYtLzqp+L4
	XAaEFGJNL/GiX8j9MQ2ptB7DPWrPBM/ggQnCaxLSbcCWDRuvbxX5hhIYsbszar/M
X-Gm-Gg: Acq92OHNhwR5XKgmrbEqeq9pJ3E9x5vtz/HbO85SAlARc4B9FLwTFZzu7stPZFLznuP
	jpNBp5g/lLAMwsEhhSIYt1Bz7tx4ewA+ZBEEObzFWDZ5/bJXP/9yA7TKMJemH0kYmjAt5yxYvU5
	ul/ep/YB+0nXDU+cAtiHfiUaOZVurofy0e+zorfO5OFK8IgbB31VhdD76QoRDsGfhjCSte7npkM
	AV6nBlmQ7Rg1QEhMVqbKwqYm0veMgnvPnasrmHTindmTvFXGwqkqqN9uxzTAchORf5Y9yCuuB7E
	kb5Mivje9BHU/FHDIlSopMjVzsh7t3X3KXnr7DMh69TTJoxzKmmA3+v2jSwBfZ0xJFE1kKESqn/
	SMHxBp5yPP74VvPzF+Q644NVZIxWL8lvb1YM83psK0MpSGtdQ58LGkIJ1U356ftD5PM2MbdVZEh
	0T2S9NPih1Z7KmhhmbEQseJi/XXkaVDpI2g1ow8DNPxRVXQHFNbk/4zeEOXYotJYNxoEpcNjgEf
	U5wPlW1OYW1FV81xEAcdx7HuCS48DymhN1hmUoJctEaq0o/37ndFg==
X-Received: by 2002:ac8:57cc:0:b0:517:70a5:c875 with SMTP id d75a77b69052e-517987a8e1dmr11206451cf.14.1780681514562;
        Fri, 05 Jun 2026 10:45:14 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51789407da8sm53376171cf.19.2026.06.05.10.45.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:45:14 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 14/14] lpfc: Update lpfc version to 15.0.0.1
Date: Fri,  5 Jun 2026 11:23:36 -0700
Message-Id: <20260605182336.134919-15-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260605182336.134919-1-justintee8345@gmail.com>
References: <20260605182336.134919-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 15.0.0.1

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index d6e6e436fbfc..7df63d118234 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "15.0.0.0"
+#define LPFC_DRIVER_VERSION "15.0.0.1"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

