Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACF72F547F
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 18:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272973; cv=none; b=hsNSHlw2MrQAcBPWRGs3UQyd4MWgUkCDCFRTRErDDPOoELa+5LN0gwrPMGlhBafc0uPAbr4izmFNNP0c989o07AQYxWRQABl1hVyxcaN+ep+w+jwIjFeKfA0CEo5u/eWCrVKkOyBnddFaBF8i4n7SatcV59KHLRPWr8SwzuSGrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272973; c=relaxed/simple;
	bh=bV+4o2bU6DJMjg0vmp3iadxgbx4V3hLGKcNgTvsouXA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G+F6qKOd8dLCIxTPRY4OYdDD+bNgAvgBlOi04ut3jVqdBY5wEQ0yh377YXcLZ3iGbJJ6RtEvyhL2CBGyIV0MkrcAShK41rdxDYMQlAEDsQ32fDNi529itm5cyMDfCHnQ9ZitYDXcQGpEAlrisx8NXUo2GPN+r/i7NPHSUG7v4aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OPRSTwbm; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OPRSTwbm"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso7793567b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 11:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272971; x=1750877771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwuUKYYST8VwsmQcvm50vhpuu2t9Kf7/tp9whRrZdeE=;
        b=OPRSTwbmI9E6U10d5IbkkTUXUEI3EQ1dvZfoknPlBJ7K6VB69w5rg1szPswGdB4YLD
         jY19MQEtTJ8SIaYKrot9EGWnziryJrWQm86k66eGEV2FQ369X6j/87oIcfg2YgtUs8tr
         cuUiGPvu61+Vx6VpWWpnJhg5DZssbRGWydJ64b+s1quYSWo20m+IwF/n3mLSMHvVUEA6
         LZEqHWyS5gQ9s5rfGiov/GE9UEjmNjH/gGRKSzxlqnqgipqlb6HtKWbvF8Qnbtnvbhom
         YkL/4HbKofg6ySyEW6PRElnCU/ftG+etlAkWghiQ9WWFcOedeTZYJMc2jifJexc8WpRW
         SigA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272971; x=1750877771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UwuUKYYST8VwsmQcvm50vhpuu2t9Kf7/tp9whRrZdeE=;
        b=SGvcS/eaN+Bc9Sctz/Ys7OxGq7F6+6fAy5YxGfiZG0JaQHLT2KRknAC4aOH3I7yZyL
         BmmAsKE5xXCD0kguMUXlKvK5NvUurDvC8cZBcOqmdi7AqA63A2P7bd1XA+nr5r0WDFPx
         P+gNXcFjaX4yaiPcyuZMSRX6stxiP730NHI9AN4wRR9f1vjBYtFmdJ7F32lv/57g5au6
         48xm19MctZqVTwH4s3Q91Z5Z+iooXFjG1r8fsXnpgph2yQ+myBok04Lxj1OKs9xf+To+
         4nw9McXPebA0Kd2e2MoPlxFf2GCNWfI8pRcOlwv86rVYrbRu3vDOIpaCMhUZxPNeQ4q3
         WW3w==
X-Gm-Message-State: AOJu0YwjD3Gd4lK0wObY/8T0yrBbVXTQGtpXVsesOUExIFJTz8lY8DP6
	I8ldOEIytydSzx3qHN8UtNkrVMEcOeoCqf+xc3wQ66Viv/mtn7odJnuKG4eh/Q==
X-Gm-Gg: ASbGnculamX2T2MIkFCIm+NQ6b0h9mgoSNkJOxGDOSPVLdMo2ydT/AnYqnp+rC8hG59
	gV44NJFVql7e9vCPG6beNz6K1dZGb0DBZdHwdS4rQBIMacSCFDqcHWhuxdyPHO88vZ9V1kFB5Kv
	0OVFy2KwrLbpwLlDNOfErCuQcADxFKHIBnuPQAS3qehWIrRXuEDqjiBXo0KRVW3RpwSuaMkI1QY
	ip5UAcTpb+paaP6FeNJR8zuANZzFnmKP057objw2bNWHzATbTQ8CaZWEflrLBXFIn4y972bpUnE
	zU6mEbyXZV0ib6EsYJV+1CCMztJQ4m3H/joJSQAwyebFz55bTPWTZJkGTk8jB2wdv3jfmqZZmY6
	uNAUpWa6Pj9AVQAGgpZJq8eV2FDTBN+Vu44ystApIaQmPWGo=
X-Google-Smtp-Source: AGHT+IHRfNBC+cz4yA2crzcmuuaaeYR3ZT7oB8apqrNCM8MxnMEZPcwKi2IKkEWiPSGsYtjcIehujA==
X-Received: by 2002:a05:6a00:3999:b0:736:31cf:2590 with SMTP id d2e1a72fcca58-7489d1730cbmr28603236b3a.16.1750272970826;
        Wed, 18 Jun 2025 11:56:10 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm11798834b3a.133.2025.06.18.11.56.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:56:10 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 04/13] lpfc: Skip RSCN processing when FC_UNLOADING flag is set
Date: Wed, 18 Jun 2025 12:21:29 -0700
Message-Id: <20250618192138.124116-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250618192138.124116-1-justintee8345@gmail.com>
References: <20250618192138.124116-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During rmmod, all ndlp objects are cleaned up and marked with the
NLP_DROPPED flag indicating that an ndlp object is currently being
released.  Thus, if an RSCN is received during driver unload, then walking
the fc_nodes list to process the RSCN is unnecessary because the ndlp
objects are very shortly going to be released.

In the lpfc_rscn_recovery_check routine, early return if the driver is in
the middle of unloading by checking for the FC_UNLOADING flag.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b1a61eca8295..f7ed245aece5 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7861,6 +7861,13 @@ lpfc_rscn_recovery_check(struct lpfc_vport *vport)
 
 	/* Move all affected nodes by pending RSCNs to NPR state. */
 	list_for_each_entry_safe(ndlp, n, &vport->fc_nodes, nlp_listp) {
+		if (test_bit(FC_UNLOADING, &vport->load_flag)) {
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+					 "1000 %s Unloading set\n",
+					 __func__);
+			return 0;
+		}
+
 		if ((ndlp->nlp_state == NLP_STE_UNUSED_NODE) ||
 		    !lpfc_rscn_payload_check(vport, ndlp->nlp_DID))
 			continue;
-- 
2.38.0

