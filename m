Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE3222A7E9
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2025 01:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765417449; cv=none; b=oqiOmSZ5iuTT49iIs6EpcilXQqj4Gm1DmvYZMNQFBXgfTLke/V7Kd2sZ+ZpoxsDtfvJOf4wuYEWfZiFC3lHc1iRJ/rhoAx2k8hoMiLIfoq51QdcEUSOS/4Pwm69sBtjr25/J9uIp4a1whvjEVRcNDv6eHDoE312hLxiOVhjaH3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765417449; c=relaxed/simple;
	bh=Mkjb8FmlHofdZ4LQA/AqsxtCw5U0GijjUPoZvOhitVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ose/6TsYWr1+iQt5V0RBk4VHBq792t67jY3MbdIFodsVIuEpX9u8QG2kevpYuS+LAzLnW7Si8cGFJEe/cKpEZcyBN+xwKWm5orPmeIOCcLI6IODoVFslvKzlO2TPD19M1+uZH9MhuUTYRXqbWi+Ac63jtmKxITPYXAxvSiVRJ3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A0L+H/9K; arc=none smtp.client-ip=209.85.215.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A0L+H/9K"
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-bd610f4425fso253089a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 17:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765417447; x=1766022247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yf88xxHSv/EseHBXYTUsvbNHLGypn/BpxJ84JD2iEf8=;
        b=A0L+H/9KyILI0RThTFTtyyG5Iw1QcKc2qdtjAYMlW0kIxMZnP9gXbIFl3WriZm5z18
         5tSQjDf0X4p5I19kRTDItaEkbls/AxohfMP3fIBrimZNsTZ/W+G4qvpWaNi9KYq1HJsa
         cdhYPMHot5In6bLdiKXMHE+sEfiUd1YsDY7MWo5pRPC1SXo/ArTUHsoaLltknXRT8SEh
         zPKtx6mskCkNbU/c1eZ/uyieucWwmVImPLNQMH9wUojFFm2pQtccHhc1kHe3WZHIrQlX
         3EOvUQV4GnmStesHTCPkeR95EBdoO2UjU+NCcRAiAOK1JeqXMDmZHwB2/iQhDHCUmAGL
         0ILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765417447; x=1766022247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yf88xxHSv/EseHBXYTUsvbNHLGypn/BpxJ84JD2iEf8=;
        b=XapY3y0aK+ugSNZDlGUh7Xx+cOKuWiRQJJSPbQZdYLD9jzxbjqFyxCRGZDmSCqnUp2
         C+KbBNReHdp5mJfv1kK6iyAUSZxlPxGa5tuXNN8OSs/j7E7+veWW04cSZztCz3g5PQex
         57i09Vk8O6HYcFO/0MQT8wpY5/ojDCfNI/azjukgXaxQSmmxZ8WPdKQT8HSkoHtJ0vPl
         R/hvuZulGP6MyNS9vuGdXl8/9Q2tSoF6sjT0akE3/nrR6kf/6Rdf1co9P1fS1nu6jMkT
         H2wAt+JJZm3BuAwj72+sZq3Nj9WpCZR/OBdGXHVjvy7vTonpqu2VUSLOR3mXULxQArP5
         xHRg==
X-Gm-Message-State: AOJu0YzZQtizPvu1MZs+Ky27v5xsYuf2zVWkBxHwd+YWvewai8TWLmZ7
	VbvfiJRXx1LtFxjZgdfltjVK1ZWaQYsn1C/jWy3thcxbAdqQe6HqT8it8p3C2pDbERMryw==
X-Gm-Gg: AY/fxX65A/sYG1NKdL+twE9o73WycF6/IBA5zksv3s8kW2JOtpc1oUBI+aRHpgpodq/
	JcDC5UUKCezgpdDx0Z6YgGkXEqZa37xGYkonMcHv1851Dk7VSWquhJCQEc2Uu67kLy4Gl41U2Uk
	YB0UjDUYeaPpEGYoYfHMcqlj1h+fOIjKr/TSArXeXzaxIS8sLhsqsBJ3xzIgONGmeJePmTbsXIT
	PRKYVLbJ5wsaQ6OqmfjpgsTKuvf2rd5c2/stoauOX87+5YKO2PrFbG4wN2wzMeFnBAe4yVU8UEs
	sEbK93F+RqSy9Itqs13ugzLDvP4wC3JqQ0vK38DoTdUfiJ0q3U5RmURGuYGCd/+xSShQuASV+xx
	ykbZAiAu9RcoZnx+j3/IHnvGeV1GY2M0gtkAiiGJ3BdRQhM9EiOw3NzqQQr9Qx5v8+jIuLDlmxj
	ZpqQAFOuAysxNRJXr55rKX36jvUfJQTxCCvrTBHpQqv4v7ljf/bdjsFPZHwJ+8j+bYbUDvkRFaD
	6tp
X-Google-Smtp-Source: AGHT+IESz/r97FEtE0abBwYzY675dZegLuiEN1PPlJaIzCxvjU9JP7XXfjYBtz/vT9AHGTX89Lbt5g==
X-Received: by 2002:a05:7300:f785:b0:2ab:a4ac:1f4b with SMTP id 5a478bee46e88-2ac05449b8amr3174411eec.6.1765417447267;
        Wed, 10 Dec 2025 17:44:07 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e1bb3b4sm3273748c88.4.2025.12.10.17.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 17:44:07 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: [PATCH 2/2] scsi: sym53c8xx_2: remove empty sym_init_tcb function
Date: Wed, 10 Dec 2025 17:42:46 -0800
Message-ID: <20251211014246.38423-3-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251211014246.38423-1-enelsonmoore@gmail.com>
References: <20251211014246.38423-1-enelsonmoore@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 38747ece8c94..426608324af8 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -4906,14 +4906,6 @@ static struct sym_ccb *sym_ccb_from_dsa(struct sym_hcb *np, u32 dsa)
 	return cp;
 }
 
-/*
- *  Target control block initialisation.
- *  Nothing important to do at the moment.
- */
-static void sym_init_tcb (struct sym_hcb *np, u_char tn)
-{
-}
-
 /*
  *  Lun control block allocation and initialization.
  */
@@ -4922,11 +4914,6 @@ struct sym_lcb *sym_alloc_lcb (struct sym_hcb *np, u_char tn, u_char ln)
 	struct sym_tcb *tp = &np->target[tn];
 	struct sym_lcb *lp = NULL;
 
-	/*
-	 *  Initialize the target control block if not yet.
-	 */
-	sym_init_tcb (np, tn);
-
 	/*
 	 *  Allocate the LCB bus address array.
 	 *  Compute the bus address of this table.
-- 
2.43.0

