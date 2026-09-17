Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E304A64FD
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682269; cv=none; b=HPu5b/+k0Rqll61txS12EoX0X6uW1vLwR5FtQZYN+OZCftPc+AMuS7R5SlioZo42pwVwVqKh++W5/acDVG2QQgNSlN0RW4ck19xGGCZNdejLPQUhWRxVUFkQV1z0uOK9FCkNke3mYTZDawpkn18bxqlXtlmMscNEg4pbBZ/M8fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682269; c=relaxed/simple;
	bh=tER6xlnK90r8Qab1VZSZ1fLyySMbxeBEh1Ay11tOetw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YwdwHVOXQY/fAiK82Cf/zE3knkyNY8emOD21F3LV9ILdEOjnLT+gII6rlPyWNI3xF8piR7HPLwNK87DwFRjdtjKJiPmhJ+hnPK1JgWSvxQl5mS5Q90s7p/hvW2uRLHN/yGPKlCoIIyPNrQrAYxjGmyrC2sMoaqgHzFANwd1w2fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pRLCqdtU; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pRLCqdtU"
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2d747ed6d6eso902545ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682267; x=1790287067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WwBaVdVJ59R0rXXR591zjvN6CoT6wXS7+liHv+BZRLY=;
        b=pRLCqdtUTpRNoqCGM227pfJtvv2mdmu19UTx1JgBqqqtXyQ5j8niTFWrL5BxIQryPc
         vSworU6Gwp3tY9F96wbGi4JiE/Q0U5ehq6GDl/Yb9N6l9QznTHCA4TVPh04ZC1DGXpeK
         phRhAdqvgi0bg9IezC/V1wuZSqbgiIzQGMPdGNYJnzC8nuDzcISb03NLjarGfoYRGr5K
         wuHNUvOB741YxC19n2IEE7Zdob8YFaSzHomsybf6k6pEtrHFAVM4QOzRBjzOP19YCSnQ
         C9z8iqAOf8F/wJ42Yh81tomMDLeACmFY/sZkAT22vLFcdeREkP1c5cX5aJg04Ka/yAVR
         LGEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682267; x=1790287067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WwBaVdVJ59R0rXXR591zjvN6CoT6wXS7+liHv+BZRLY=;
        b=GxVD9yJImIkzheV3K3uomGg3LNgt3UERVUrHbbQokgWoqkxMFbRnBhY8hnWpts1je4
         7jpt63R0I5/WsaZ6sfY09/UrkwOkc/gAqKhR5oVF8W9Jc7EOK3slxEgDmXnjDd868bX4
         7WtSF2ZqvWcp6DZiqpyDcRF8q2FqKbr6NEF7E7JDx7cYuZ+ehr2AY+T/6Wyc+pPpYKM5
         lkpCEDJJLDU0kIgMc1cyRcCDve4bouuFgbhNr7efmt7S7BlqoqLfBjCFgkMMRCfdwhnB
         75nsuXK+XpK+tHfXADQYQrUhBw1vKuFanhlHy/PV9/KPOqUF4w+EW0k3UOhUjg44HbkQ
         mJrw==
X-Gm-Message-State: AFuF++lzmF5AcqqclukY9ALKxVddedvQ8AEjHfeFQUi/FA4h0LMGv8FI
	DY0qiaX4RnefLmCQ7zWvW6Pz2Oh5FPuLkiQuzjNl0MBtvD+iWEYyaP3Ox8VgZ/1l
X-Gm-Gg: AYBFou1Uy+33wWkTGSoyK1MQZ+5S9DHhtp11xNsGjvKhXARQSF0kbHRSmnq2ip/f17j
	nxeT0ptZ2c+Sbwmx0LgehoToCai/GZeV2pKVvGDzbBH9dQlcO0okT62QmEaHA9RouwV4myw+jCu
	61Ib80QeGkhxjGXLRZ5KEMwEKLeRwaFlESeqRitiI0JVutWpw8Zr/UNvpWkPMVeS57PxeI9FuyI
	yJc4puZhylalHlkdgooF9UD8Qw4eY+z/YJE6lSi7RWCxzaPZkpGopXUeGlgco/US+57LdUkSNx9
	z/pJkdqVnVFjORF24ThP8qvUNX7wtXcx8mmRlkZ1/gMncOQyB+LUn8ALh1cIxgl9l7uY6bi/pcC
	uT0B2KNmrHV+fQ0auHfCHoY+/IzGYQcj48D4hHrE/BPcPRXjU0LF+WD6tUV1l0OA87Y/0S0aBzd
	50Tv1CTbIYVAfDVh/6SPGVyS5TSre5nGp6mkWu2AQLS2HWqkMhdbgq536uP9BWoaIUtXdi/264v
	I7fsUGR7brWhlSUuEPQhOSuFO2tYqQZ0flZFgQDS2fDkezR5TFQEjbOH6M=
X-Received: by 2002:a17:902:f542:b0:2d7:2edd:d140 with SMTP id d9443c01a7336-2ddb1aac6e0mr10659915ad.3.1789682267555;
        Thu, 17 Sep 2026 14:57:47 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:47 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 14/14] lpfc: Update lpfc version to 15.0.0.1
Date: Thu, 17 Sep 2026 15:20:15 -0700
Message-Id: <20260917222015.61053-15-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260917222015.61053-1-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 15.0.0.1

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
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

