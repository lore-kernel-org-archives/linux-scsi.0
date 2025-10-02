Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA26127F749
	for <linux-scsi@vger.kernel.org>; Thu,  2 Oct 2025 05:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759382798; cv=none; b=lq7WkTYXiA68qczAhO4UJmUtksHLXAeKRgDKYwj95skvo6V6XlfzFg+Ui4SkUpQBF7DGxuDH4fg4zAzOZ/BqOG22s21QXh8bCr8aixddM08BJSx0bTcMeW4Atsn8KO5M8cPI6xlbLyNk0XmOREAuCjyt6tr0PziXnXDNG4/B/EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759382798; c=relaxed/simple;
	bh=IrCR+MhlLo9ogR9M2WOk3pIVlPMhWUizgRZCayEgJL0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Crg9f1crTBTyo5Y3o4GQdHHntgya5doUelZAdb9BkiUNhTJRxXbWyyA6vo4g33Vjb4Ae/HwHPJEFOApLPRDtWZdTit3hC3gM3sEeJhyy7puMLjbA/h6LAgDfji3/VfgViVn6gPrCyBzU3LgOwZbdF43P+CAScWYaK5u4n977EOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YqUeviPY; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YqUeviPY"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-57a59124323so606772e87.2
        for <linux-scsi@vger.kernel.org>; Wed, 01 Oct 2025 22:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759382794; x=1759987594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eK6KFYZ1WJDqYwvEkBhzBI4Di9nWKpUoo1mNcrKQMbg=;
        b=YqUeviPYuDTVrOUoSb/FG+fPS9eHUnnMrmxQZ2WmhaEXdV74JnrQWMxtX6eXJ0FDw2
         bKmWpCZcfgSu66RyIyYsIIKu09Wt7PPF2z/Z01xODe/etIaJECNEYfa37MOg6U1awTZo
         7udN4vTtPC2OYPV9d/9Wee6KI66lkZ7eG1rWPZicwQxNZnLG/tbFXp21hsgKuwEoIA/G
         yKL7ptIvu6XtPvolLOOZXR8cxyQGEfZp6ncOSjlNIAu09jnnH2i1egHVR7sti7akvFSM
         njFHw0Lj5xXp89BjIjrCm/eLWYP2JdZNzIztJ+LvgHmBQ3fStDqaliu/PWQVQdPeMS37
         EO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759382794; x=1759987594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eK6KFYZ1WJDqYwvEkBhzBI4Di9nWKpUoo1mNcrKQMbg=;
        b=m7B2M32xSMyLMpQVKg2DcsOSk7m71I151z8YmNpzm/Z9ius2VwrBqfCNeE4KLu8AjH
         rwWTYafCqBeuFH3f6JJjO8gWnq5hn1/vjwiO1UDwrOFcdSNTVhZ/X2hVsO6BnKNGRIa5
         pnSL9t8+h/bRE8Zo7uAyjT4rYGZMJOLqyslC3Yq8wiN+PPzb/UQGLg37DPXYVAYVAj4Y
         cFWF9jzVWNCihWyrXuq4zdAh0z8vf56Dn6j2VIzoN7Cn25oH22+tVpe9JlskdU9zDSGA
         7yN3Zqkenx2I1mqEl8kxaRY82aZ2uHr7XZxgBobx5YxT5RxR/97pY2AtUnwCBY9lj5MK
         7g7g==
X-Forwarded-Encrypted: i=1; AJvYcCXxRieAuKDbPsne7yp9uhOjNOO580JsobXe5RsD2hp6F1ofanxAgy3YFBTJzIqpNxB0uXr2OI3uN3uX@vger.kernel.org
X-Gm-Message-State: AOJu0YxwOsoGxdBU8mymm6aPYjQhjHNUX3hAO9hCbCBLRoaxl8EQf+0J
	bVWyxhV7Vj2Qd7mQEZy3nUgAtNUzfPuTbnaLM2GgXqLrYKIxTRcREEWY
X-Gm-Gg: ASbGncvQ8/ixBGc5rzRfNJ0cYuhYtcys8B9YqSJ8ecyhrAIs/v34Pw8BxByc94ou6y7
	+I5sALzA6wiRWayG0J6zHVnI+6cLJpIp9Nu51TBtmFWRjXx3CRDgk4bq6ZfXiWkMnmyca0Nyda8
	U5k8WOzOH7EKCbhs4nfoH/s9k7//D5MclXI/o5GiM8cubqAnZRgwL7nmuGstVQwPZ/LDShRibLK
	kjNqwCiWVqBg1sjYqV1vDBK10Qdn/tP4t0XEdUw8nGTqFqBHZek7HMAOJYrH9dZPAEATW+WQqVv
	STuI0jjQEBZv7eLjPndbcQWD77X0Q5uyg8wXLk2E7GExY3Y0fmGXLZLfblrVbE5LIcMaztzV3Sm
	0GQjBAR0I2csohE0yIDAxUpFwdxeALszZcVr7fSrTgKbgWQaOHlbXQfF3PhjXhRROqdmcYyfKWJ
	tSLg15b/U6DhIC1aooAEQwC48=
X-Google-Smtp-Source: AGHT+IGx0TmMId2k4OxpwBsBxNp5vaWRWUNwEeINRHFP67qi+nW6n36bR9aB6MgBpyixiRJR6NaLfw==
X-Received: by 2002:ac2:51c6:0:b0:55f:536f:e895 with SMTP id 2adb3069b0e04-58af9f50c7emr1801728e87.45.1759382793740;
        Wed, 01 Oct 2025 22:26:33 -0700 (PDT)
Received: from buildhost.darklands.se (h-94-254-104-176.A469.priv.bahnhof.se. [94.254.104.176])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b01124438sm510914e87.4.2025.10.01.22.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 22:26:33 -0700 (PDT)
From: Magnus Lindholm <linmag7@gmail.com>
To: james.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Magnus Lindholm <linmag7@gmail.com>
Subject: [PATCH] scsi: qla1280.c: fix compiler warnings (DEBUG mode)
Date: Thu,  2 Oct 2025 07:25:24 +0200
Message-ID: <20251002052604.24590-1-linmag7@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Building the qla1280 driver with DEBUG_QLA1280 set will emit compiler
warnings. Fix some print formatting strings to reflect the correct
type of printed variables as well as remove unused  code. (static
function ql1280_dump_device) in order to avoid compiler warnings.

Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
---
 drivers/scsi/qla1280.c | 35 ++++++-----------------------------
 1 file changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 6af018f1ca22..55262500d11e 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2799,7 +2799,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 
 	dprintk(2, "start: cmd=%p sp=%p CDB=%xm, handle %lx\n", cmd, sp,
 		cmd->cmnd[0], (long)CMD_HANDLE(sp->cmd));
-	dprintk(2, "             bus %i, target %i, lun %i\n",
+	dprintk(2, "             bus %i, target %i, lun %llu\n",
 		SCSI_BUS_32(cmd), SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
 	qla1280_dump_buffer(2, cmd->cmnd, MAX_COMMAND_SIZE);
 
@@ -2871,7 +2871,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			remseg--;
 		}
 		dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
-			"command packet data - b %i, t %i, l %i \n",
+			"command packet data - b %i, t %i, l %llu \n",
 			SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
 			SCSI_LUN_32(cmd));
 		qla1280_dump_buffer(5, (char *)pkt,
@@ -2929,14 +2929,14 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			remseg -= cnt;
 			dprintk(5, "qla1280_64bit_start_scsi: "
 				"continuation packet data - b %i, t "
-				"%i, l %i \n", SCSI_BUS_32(cmd),
+				"%i, l %llu \n", SCSI_BUS_32(cmd),
 				SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
 			qla1280_dump_buffer(5, (char *)pkt,
 					    REQUEST_ENTRY_SIZE);
 		}
 	} else {	/* No data transfer */
 		dprintk(5, "qla1280_64bit_start_scsi: No data, command "
-			"packet data - b %i, t %i, l %i \n",
+			"packet data - b %i, t %i, l %llu \n",
 			SCSI_BUS_32(cmd), SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
 		qla1280_dump_buffer(5, (char *)pkt, REQUEST_ENTRY_SIZE);
 	}
@@ -3655,7 +3655,7 @@ qla1280_status_entry(struct scsi_qla_host *ha, struct response *pkt,
 
 			dprintk(2, "qla1280_status_entry: Check "
 				"condition Sense data, b %i, t %i, "
-				"l %i\n", SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
+				"l %llu\n", SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
 				SCSI_LUN_32(cmd));
 			if (sense_sz)
 				qla1280_dump_buffer(2,
@@ -3955,7 +3955,7 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
 
 	sp = scsi_cmd_priv(cmd);
 	printk("SCSI Command @= 0x%p, Handle=0x%p\n", cmd, CMD_HANDLE(cmd));
-	printk("  chan=%d, target = 0x%02x, lun = 0x%02x, cmd_len = 0x%02x\n",
+	printk("  chan=%d, target = 0x%02x, lun = 0x%02llx, cmd_len = 0x%02x\n",
 	       SCSI_BUS_32(cmd), SCSI_TCN_32(cmd), SCSI_LUN_32(cmd),
 	       CMD_CDBLEN(cmd));
 	printk(" CDB = ");
@@ -3976,29 +3976,6 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
 	printk(" underflow size = 0x%x, direction=0x%x\n",
 	       cmd->underflow, cmd->sc_data_direction);
 }
-
-/**************************************************************************
- *   ql1280_dump_device
- *
- **************************************************************************/
-static void
-ql1280_dump_device(struct scsi_qla_host *ha)
-{
-
-	struct scsi_cmnd *cp;
-	struct srb *sp;
-	int i;
-
-	printk(KERN_DEBUG "Outstanding Commands on controller:\n");
-
-	for (i = 0; i < MAX_OUTSTANDING_COMMANDS; i++) {
-		if ((sp = ha->outstanding_cmds[i]) == NULL)
-			continue;
-		if ((cp = sp->cmd) == NULL)
-			continue;
-		qla1280_print_scsi_cmd(1, cp);
-	}
-}
 #endif
 
 
-- 
2.49.0

