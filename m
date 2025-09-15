Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8129296BA6
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957961; cv=none; b=agxCwKifQblfmZA8hG6E/X/6qZaHxh2BsTD3AzQxrjXNiTxUtFW5EKD25cH9S4qvRkQufz1Sv/N0UJJerFeIiZtgbCfaEpD4xl1FA44f0wuQ+032GcPxF2LSfS+bBoXTRhPPOEtcmJeG30vdhfW4wtdeQnEJrQN3QeNeFw8g6UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957961; c=relaxed/simple;
	bh=diobUSZv2Dor0tJ5sXo+Lg2E4qbmU1zoOvDLNaO0hrQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vj+KBV4al+bVx00uitgNhE/Q7K+S03hxasf8zVHarMNeSvUNHwh8TaceNZvJvm1pZHDa+QkwrtNS9JlqfFk+lFhFwCC3huTtUtcLst48JpT46y4Tjlqj5iErU/jOj5H2A4+ix051xERaz+M4Udzea64JY6id1sHZ7hrwqhCR5NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GUUBpGIc; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GUUBpGIc"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-776e2e357abso18687406d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957959; x=1758562759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OLN/EWjaVQlQuugGYdJ2VRbo2LzmC/UqhXomSx5sDdk=;
        b=GUUBpGIc1MW5JcixCrEaNVl6LcQQkOHBXmOhao+I9VD5WJtXvYMp8T4PKhaKeINkCB
         tolD86h+gR0oVe+/ttVf6SRAh+jiOHy4zndTp16wy009/pi9jO6PvuQILbLW0GpoN+Uf
         cBXh+oo+8V8ryirWEpccialFZ+NcLSovf8UUJGTdgdPbRLCOuSPAamavdLqm9KX2Jdbl
         0RHuAE4yhVOm3vexkRFMZ4xwHR3p1xgciWaGii7SGQUUT4wElLZ054FBKQ/reA7TmwNn
         YdwQQ3cDwC+Ko/aR/xUAIFD5C5RgttXzsoi/aVyN+nKiLTyH8MSiblIqKzqktaLY80pK
         INWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957959; x=1758562759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OLN/EWjaVQlQuugGYdJ2VRbo2LzmC/UqhXomSx5sDdk=;
        b=FULF+3qO9BWrTjDbfNy0l3CmLl2lF6pMoYLLqj/7HPvr7KxkwRKg6CM2OCTwsPvEl+
         hDXl84fczE5rRxTjs6pN752UkGZzcv3DtM167xjpNnd2MpYIkJlvRTeF/pBtoCViAeV6
         m9DyMDpB9VU0Q6uRy38mhKpX9wjNEGhjQOc7LYM4hwhi78jHx7HCCK2wClbqnSWFlqAG
         CfxmTak1+OyCRH0XhVKzfKiKy7/9NlNHLuqLs3dU6QtiwiItVIetUkbENvBGAavAPdnz
         tHL1YfixfTOoe7z2EvBjKab1SiVRcGvfcnDiOs+RZ56NtRQUP/VKNvDxEaVWJd9AGZNU
         J+1g==
X-Gm-Message-State: AOJu0Yy30TobUQMytcf5PcwSpTDDvthvs0dRx0na3vlfbI6PZX/efv0o
	CJ6MFrdl+DY0FyfWJtHEncXcMVbr1EpUraH2fNDJh5DefYdeywL7FvDpKrFk3g==
X-Gm-Gg: ASbGncuNeOW7YE6kCi88vqjqeYbBicEttvJkoI3wtbE4tOFYISoAumfySJcR5A1OgdR
	FBa0cxcMQaPzrNIabYXg2g136e7bO4x7+2mOBb7oiIi2CV+vHwBAZm+pQpDgEjusfrCGDgKpn8E
	asPgY/1U2+ObFEZSMw/4PTphyfLpdaeJUyl+xKT0lhynWCpkSXYL86SiumPo8ma1OfOuzyKKx7F
	4KYAQsVGWuSYJsZUXZ/FxAoT1HcYJQvY46C0K/6iIadxl2e0+TKit71w3fRnZvTDyhcJQ4vLtxR
	9E8ObkLnoVVL03k/t1KW+y6QbsmV15AX46m5BzGBgbrOnY0x2ee1Vx02VTml72+oOVkWCyM90vp
	x9w0Hr72jfmysP94JwltVgVL5dnk/P4yWBpLZr9Za9U3Ic6AJMSeZkkgxnQkAtYmTl5ZpelkQ/8
	Oss9uGkbilkzKEWaLUww==
X-Google-Smtp-Source: AGHT+IENekAWgQhPSgD5r4QRToCOtqpkPZCCF56EYbN8LULu0S6xRAS2HU3hCqiI+j2by4MC32AAvg==
X-Received: by 2002:a05:6214:5506:b0:772:d8b4:8a1e with SMTP id 6a1803df08f44-772d8b4a11emr107291666d6.17.1757957958472;
        Mon, 15 Sep 2025 10:39:18 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:18 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 05/14] lpfc: Decrement ndlp kref after FDISC retries exhausted
Date: Mon, 15 Sep 2025 11:08:02 -0700
Message-Id: <20250915180811.137530-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250915180811.137530-1-justintee8345@gmail.com>
References: <20250915180811.137530-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kref for Fabric_DID ndlps is not decremented after repeated FDISC
failures and exhausting maximum allowed retries.  This can leave the ndlp
lingering unnecessarily.  Add a test and set bit operation for the
NLP_DROPPED flag. If not previously set, then a kref is decremented. The
ndlp is freed when the remaining reference for the completing ELS is put.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 38b8c30d33b8..5ac2d5f9151c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11259,6 +11259,11 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
 			      "0126 FDISC cmpl status: x%x/x%x)\n",
 			      ulp_status, ulp_word4);
+
+		/* drop initial reference */
+		if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
+			lpfc_nlp_put(ndlp);
+
 		goto fdisc_failed;
 	}
 
-- 
2.38.0

