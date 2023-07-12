Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D51AEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 17:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbjGLRyV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbjGLRxx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 13:53:53 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A1B2127
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:47 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-5576ad1b7e7so1162413a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689184426; x=1691776426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4br7Q1jVmRYhKEYxZCPhw0Y3V9fusF+D1c/MNj+YSos=;
        b=RS7ozfatCT7AYua1V5pHGrf9mqEYgygDzbveZ43eg6WhpzI8kPPC379ZPFFlAgtRm0
         7gAeIEpffh8j+ieeZPvrxb6vihgu5Fxk0rAUa8R3De+Bfmd1L4uWjNWHUCSnvm6pTmzO
         ZMqp9kui54hoJQpiFEvQNZc9aVgAClAZPh5xmlpF9Aw0Fsb6Wh4Cwfedc4Ukkkk0tDOE
         hVHXw0Q4Z3r9gDlNQCgq55vej1y5wToPE327S1HVbVyMTnXecFCxW36/t2cwKRM4pL6P
         siZUG5JOmosww3N+QRvCEu8g6gQxm7e+RTadEdlLQvZfgyd8P7VRpAcERVg84V47D9Z3
         fl6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689184426; x=1691776426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4br7Q1jVmRYhKEYxZCPhw0Y3V9fusF+D1c/MNj+YSos=;
        b=HiBPp+u2OjjNOyGRpGTGGCHCwrbTNiGZA4Fy6QOE7kKAr6dqnjLyJHLuCi4f8UD4HQ
         A/j3ZQ4saBOfPsYv8pHmUBUIgY8RVrXq95T80GwALR91p1ZxEO2+I2IXtLoRDH/4jtmh
         9I120XDTX8IirPQNVOC0b5Bqh6zkRNfgPuNCwzRu22mkUj2G/xU7Ee4OQ18zaeex2xvd
         mhC2AG7aCIKic4i1bWSbe3YcJnl28dcXDy3CGXbIEG2pDLwIz27uHLBtIdpph4dqHq5C
         k4Fkh+B6cLNeFMu6tR+Xp2JaBd4B3UOMBX5XGj1aoQ0CEv3qvG3iBwO9zmE+cvsAXvwB
         wdFA==
X-Gm-Message-State: ABy/qLb/Y7LPLqcw0DRM/M0chxa88Zt0LHD2V+XZL5j24Hde/sejjy0B
        bo1F5uB44wl3ViZi01P/chNfmhL+TQQ=
X-Google-Smtp-Source: APBJJlEBYkZDh2L0fGmSCi8u4RhcI7TO5HX360wYmkSieJSWZEPT3NAoojRCwMfAFhLHPL+NvtvkKQ==
X-Received: by 2002:a17:903:22c4:b0:1b8:9215:9163 with SMTP id y4-20020a17090322c400b001b892159163mr43434plg.6.1689184426478;
        Wed, 12 Jul 2023 10:53:46 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902b70b00b001b898595be7sm4218459pls.291.2023.07.12.10.53.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2023 10:53:46 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 09/12] lpfc: Refactor cpu affinity assignment paths
Date:   Wed, 12 Jul 2023 11:05:19 -0700
Message-Id: <20230712180522.112722-10-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230712180522.112722-1-justintee8345@gmail.com>
References: <20230712180522.112722-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During initialization, a lot of the same logic is used on MSI-X vector cpu
affinity assignment.

Create a lpfc_next_present_cpu helper routine, and apply its usage for
refactoring purposes.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h       | 19 +++++++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c  | 31 +++++++------------------------
 drivers/scsi/lpfc/lpfc_nvmet.c |  5 +----
 3 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index e8d7eeeb2185..bc1c5f6df090 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1709,6 +1709,25 @@ lpfc_next_online_cpu(const struct cpumask *mask, unsigned int start)
 
 	return cpu_it;
 }
+/**
+ * lpfc_next_present_cpu - Finds next present CPU after n
+ * @n: the cpu prior to search
+ *
+ * Note: If no next present cpu, then fallback to first present cpu.
+ *
+ **/
+static inline unsigned int lpfc_next_present_cpu(int n)
+{
+	unsigned int cpu;
+
+	cpu = cpumask_next(n, cpu_present_mask);
+
+	if (cpu >= nr_cpu_ids)
+		cpu = cpumask_first(cpu_present_mask);
+
+	return cpu;
+}
+
 /**
  * lpfc_sli4_mod_hba_eq_delay - update EQ delay
  * @phba: Pointer to HBA context object.
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c878fb99dc4c..9e59c050103d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12512,10 +12512,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 				    (new_cpup->eq != LPFC_VECTOR_MAP_EMPTY) &&
 				    (new_cpup->phys_id == cpup->phys_id))
 					goto found_same;
-				new_cpu = cpumask_next(
-					new_cpu, cpu_present_mask);
-				if (new_cpu >= nr_cpu_ids)
-					new_cpu = first_cpu;
+				new_cpu = lpfc_next_present_cpu(new_cpu);
 			}
 			/* At this point, we leave the CPU as unassigned */
 			continue;
@@ -12527,9 +12524,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			 * chance of having multiple unassigned CPU entries
 			 * selecting the same IRQ.
 			 */
-			start_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (start_cpu >= nr_cpu_ids)
-				start_cpu = first_cpu;
+			start_cpu = lpfc_next_present_cpu(new_cpu);
 
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 					"3337 Set Affinity: CPU %d "
@@ -12562,10 +12557,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 				if (!(new_cpup->flag & LPFC_CPU_MAP_UNASSIGN) &&
 				    (new_cpup->eq != LPFC_VECTOR_MAP_EMPTY))
 					goto found_any;
-				new_cpu = cpumask_next(
-					new_cpu, cpu_present_mask);
-				if (new_cpu >= nr_cpu_ids)
-					new_cpu = first_cpu;
+				new_cpu = lpfc_next_present_cpu(new_cpu);
 			}
 			/* We should never leave an entry unassigned */
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -12581,9 +12573,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			 * chance of having multiple unassigned CPU entries
 			 * selecting the same IRQ.
 			 */
-			start_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (start_cpu >= nr_cpu_ids)
-				start_cpu = first_cpu;
+			start_cpu = lpfc_next_present_cpu(new_cpu);
 
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 					"3338 Set Affinity: CPU %d "
@@ -12654,9 +12644,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			    new_cpup->core_id == cpup->core_id) {
 				goto found_hdwq;
 			}
-			new_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (new_cpu >= nr_cpu_ids)
-				new_cpu = first_cpu;
+			new_cpu = lpfc_next_present_cpu(new_cpu);
 		}
 
 		/* If we can't match both phys_id and core_id,
@@ -12668,10 +12656,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			if (new_cpup->hdwq != LPFC_VECTOR_MAP_EMPTY &&
 			    new_cpup->phys_id == cpup->phys_id)
 				goto found_hdwq;
-
-			new_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (new_cpu >= nr_cpu_ids)
-				new_cpu = first_cpu;
+			new_cpu = lpfc_next_present_cpu(new_cpu);
 		}
 
 		/* Otherwise just round robin on cfg_hdw_queue */
@@ -12680,9 +12665,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 		goto logit;
  found_hdwq:
 		/* We found an available entry, copy the IRQ info */
-		start_cpu = cpumask_next(new_cpu, cpu_present_mask);
-		if (start_cpu >= nr_cpu_ids)
-			start_cpu = first_cpu;
+		start_cpu = lpfc_next_present_cpu(new_cpu);
 		cpup->hdwq = new_cpup->hdwq;
  logit:
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index dff4584d338b..425328d9c2d8 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1620,10 +1620,7 @@ lpfc_nvmet_setup_io_context(struct lpfc_hba *phba)
 			cpu = cpumask_first(cpu_present_mask);
 			continue;
 		}
-		cpu = cpumask_next(cpu, cpu_present_mask);
-		if (cpu == nr_cpu_ids)
-			cpu = cpumask_first(cpu_present_mask);
-
+		cpu = lpfc_next_present_cpu(cpu);
 	}
 
 	for_each_present_cpu(i) {
-- 
2.38.0

