Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888007E0E4
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 23:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280718; cv=none; b=JxMneRSWYKjJtrMOyEMQMKOd/2DdEuhmISDkHy6fpQBsmRWX3tRxYYi4BCNwSZ3M6NeNscvWxMe2Zy0dCV0CC5Sq6f/iquTo8m1yL+Ny09fhyO0G5D3F3kl8mf2/Eeuv1egw8Zmma1WvquEg7NyD7wUflXlL2DYkTALd8XTGz5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280718; c=relaxed/simple;
	bh=s4Q486s8+h6bfcfJkbxCQ3yW7TUXxl+UzW6c4EX2rwo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AqrUvQa8gPAAL1uuEq6Talpb1B4/lKAirBI686WFQ7qFT0VO8CVxSUgUDBpjJP9LzDnZl9tcTCoPwMREsDqzf+mMr+7Ney+FyOM3HkAIdmkN6WWeeZTUjYJSt2stXdmnIPTWe5ZpLX8AmlrPoraJP8yAvd4OfhFwEnxOw8cr1hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LlXgYAbk; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LlXgYAbk"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5fa3714d4bbso649382eaf.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 15:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738280715; x=1738885515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pybraczAWL+kojn9385tILXmJW6hETiIhSWnECKGNjw=;
        b=LlXgYAbkNHvK9zLPBc8tY7M7we1WRnMqufdqP7LC0E5Za7PnPaf8Q+4W5A7UtkjUrW
         k6FJaH1Ajyv+lHfx0PYS1LA6YeoDM4DjMWX4lbLQ6BGi2MwnG8WVQYlSZ7+9X3ad8zPn
         mH48uCRCsWlrLMPFRUafjlrahF5Qix/US0ILhpwJRppy5HQJoXUySIO3VOaef5SpyOf6
         /r5fiWJgxP1ktoJK/KKGIHOPX8JM4FNepH7QjszoIDFgRle4w8eeTiXtwi9RuVkDkf/7
         0Dg01vhUuU7EGBJFTzjMgR0JIdmeD740guRuAyhje+fsPKywnil/BMsW4iOCqc1OOa13
         jxig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738280715; x=1738885515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pybraczAWL+kojn9385tILXmJW6hETiIhSWnECKGNjw=;
        b=Fh1KGEgEnWRRhoaIZH4+0uYXRFwLOd6BCZGJU1zoHWVPLj5qSYMnZ6PsS+WQhPO5zY
         dxfGm9s7mZhLF8LIdgLqSla42JOQLxNTEXoo11ItCouJH8DNs7S3GrtqArfWbQtxzCza
         jNvkjuT+5Zl5Cr+0g+FFgBCjHccIqeupTHowSZoRTCscc+/1M97LmO+gIdhu3tbFF+ne
         Zw6uxQlb3aFRsr9YJi3At3rHOxX6W70WtVfhjq8WmRR6UzLF8HAHdtqYTqJdhgVqCItv
         mseKMAfdI/bkuvb4WuhwKmF+J0zM/z+QxU2Hia4rBh47kOI+L/tiTt4AiJHirGVbj2c2
         D3wA==
X-Gm-Message-State: AOJu0YzF5ehmbc0nd6kPMBgJuKgUCIaTHgu5M7tqaQeCrii2DcGfqQyS
	W79ahEEWQcHhy4wM8nU8zvJdCpwXZQmsWi/4YGZaGleGqOkX291rEtodWg==
X-Gm-Gg: ASbGncuQJ9K39EK5f4o/VgcrkCyvB2om7ItzU8TVi1nSbjevUNo6ZQ8H+W1MMjXcsMx
	jvgZ6q1j8HVZJs0InMTnzJr4bcHOEI5ADFTIQUsK2P+b+0PPPVYgKPrPPLkqO/aJY1mGuTjLHpv
	m8XWRZ+XXVOJ0iHp4ROFmNcnSqERIBzus9mnEihvHFKcJ8ieZkteqzIvyZ5JPDfYi6TRLjsl8K/
	qipnO/e2p1bdHVkgt7uXR+GIhRDwnwWyl8g70DvUsQjZlktxzu/ax403kUtTgI+bEs7Rn08UhLA
	+/bvr+RoITVUJcAU1+mxqKvq5YorON/vtN9pBw6I1UkKkOyg9Kj98mKHD8K2eAieCAjUmO1UzFu
	S
X-Google-Smtp-Source: AGHT+IEcO+lMLhaSz9/PyKbXIeHzgR376LI/V+EShZKdDCJITpETlSVOMBA4DTvG8M+UEF3uBXtmag==
X-Received: by 2002:a05:6820:3097:b0:5fa:1ee7:1325 with SMTP id 006d021491bc7-5fc00457a2amr6869034eaf.7.1738280715415;
        Thu, 30 Jan 2025 15:45:15 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5fc105d8a22sm517609eaf.37.2025.01.30.15.45.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2025 15:45:15 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 4/6] lpfc: Handle duplicate D_IDs in ndlp search-by D_ID routine
Date: Thu, 30 Jan 2025 16:05:22 -0800
Message-Id: <20250131000524.163662-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250131000524.163662-1-justintee8345@gmail.com>
References: <20250131000524.163662-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After a port swap between separate fabrics, there may be multiple nodes in
the vport's fc_nodes list with the same fabric well known address.
Duplication is temporary and eventually resolves itself after dev_loss_tmo
expires, but nameserver queries may still occur before dev_loss_tmo.  This
possibly results in returning stale fabric ndlp objects.  Fix by adding an
nlp_state check to ensure the ndlp search routine returns the correct newer
allocated ndlp fabric object.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2dfcf1db5395..07cd611f34bd 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5570,6 +5570,7 @@ static struct lpfc_nodelist *
 __lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
 {
 	struct lpfc_nodelist *ndlp;
+	struct lpfc_nodelist *np = NULL;
 	uint32_t data1;
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
@@ -5584,14 +5585,20 @@ __lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
 					 ndlp, ndlp->nlp_DID,
 					 ndlp->nlp_flag, data1, ndlp->nlp_rpi,
 					 ndlp->active_rrqs_xri_bitmap);
-			return ndlp;
+
+			/* Check for new or potentially stale node */
+			if (ndlp->nlp_state != NLP_STE_UNUSED_NODE)
+				return ndlp;
+			np = ndlp;
 		}
 	}
 
-	/* FIND node did <did> NOT FOUND */
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
-			 "0932 FIND node did x%x NOT FOUND.\n", did);
-	return NULL;
+	if (!np)
+		/* FIND node did <did> NOT FOUND */
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
+				 "0932 FIND node did x%x NOT FOUND.\n", did);
+
+	return np;
 }
 
 struct lpfc_nodelist *
-- 
2.38.0

