Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9228A33EB06
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 06:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782714170; cv=none; b=lGu4mSpk+W3gr6iFCz/N4Wnsf7Yj6Wdp+GpH1eZF1xJuGlV477/e8GTsfun3Gyu82s7B0LnNP6bO5jzIQ9vIYU0niRtWElFpBASdmHIJ48y8zN0j7sMB8c/EzCj+uOIppQuKmKdrI/3eUjYaxX7TO4R/RgOn+CVqwujXWSC99go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782714170; c=relaxed/simple;
	bh=cmjEgHg/Qoy7+tzJTymi99q3KCOIYdQ+VFjBel4ivMs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kn+4C7u5NAXY3a2uuGh8u1JIEFSxTzIidsMql447z/YCpSI5OlxRBqZAkSrFScTaG51djfLrB559FNINsk0J3+4VdQCG1YJWAGyhQqr5XtV/W8dhp60RNhOtPLrNQYITl6SCeitOkLt7rNCIRY+uNkfW7dYCQsPRrPJPGj4RQD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XRDF+6BJ; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XRDF+6BJ"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-698587a1335so1092472a12.3
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jun 2026 23:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782714164; x=1783318964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n0RkwGU+3NLvWa6/fwLv/AjqueGcOC9GSk8SPtDeSac=;
        b=XRDF+6BJ6FFIpj2YYRCv5RrqQWiNwN2Pz5jmVP/Rph4mloXTEywXnQ9bsNzqy3xOX+
         o8HWJWigvl0c8J5DBSnVeo5LcyrpWR5j5ubG7/2s1kh449kiW9LP1VaxqmHvwwvWu1OT
         VU3x55SgIq1bi/+8a8cAQYs/wRMcx8xRceeB5+BdnSfX8VBtcoNxH8s/zok54BDmr76n
         yP9f4w84uA4vmLXQwzVCXkARQD/phvnlB8kjpV6PJVgh1OS2w9oL1do27JY99/dYsACn
         ws9xX4lIvS7/eJ1vFk95Y1HAWtd1NeITKcU4Zml+48/qAqdrGo4Ue6bTiV+4DxZD1EUG
         1wSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782714164; x=1783318964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0RkwGU+3NLvWa6/fwLv/AjqueGcOC9GSk8SPtDeSac=;
        b=NGX/IQMSN0JD4NJC6OAHMDrY30KY2dTdoth/SrZzQ0VSDuOyhzHSGvOZV9gnRAwJ49
         BTDwXdHTL25Jx5hpzG9sJg2fUuqhG/YHexIwgDB3IIDEcLTm/7vOgnPbiTmqHs3qunw7
         /Ga0uM7ablSznekg09Gxl5M/33WnPuTg13yhlTyFLSOWirpzbaJJ0eHIkg8qh6iGz7zs
         sO171aVAe8dxIDMwUXeC5tMNFdd9G/Ke7rnL4q+7MnWpdmjz/JVDtc3On8QPqYiEFVXP
         YYgB2IRElCDcaQj99UQIQIzj8z427G0qmMHuatW1RLuY3vEFTpgdsmLXdEmBZ171VIFR
         n0Dw==
X-Gm-Message-State: AOJu0Yz43fMq3XdRG7/FO6bqQvbFycj352D/FJ7idEsy0ybXm3JQoFBx
	tukGHjeJVk8pRQmUllQLflxyjf12pPrPuSe3NLiqz4s8MzgXZ9Z5Ily4A4kRWt9QkNM=
X-Gm-Gg: AfdE7cmc7hS3pJCJmUs9LrBvnYbbH1BjJHzRmJivKXPdayOuktY2wolKd4DVFJIWvQS
	Md2b5clrB0ErwrF1XElHaKC+nDHaJ8vPxoFKAWoHebjjAxGqwm86BO9h8VEtBY6wxICSQy0c0kq
	MXu9cElkqQfjRsyNJbl1qKHjwcMioirkFnSwSSsRP4FhllTVkQhQSimENtOP7rRn2S3YyjqsK5N
	9QJIiKrIYtJHcqxhjHOuizMW5YQ5mIqjMNgj4vaM+u/z34K8EiqSRq8AJC1zss/OawzWrOuV5+W
	NdblETs+StZ8Pf8ZgpqKBAVPQNNyTg2TwIdNMkhasDyOTClQhsQUaNUD6TKudbAK0KHUg9BQFaK
	PVsbXPB9xuAHQ2mCH9733a84MYadWWFwI3+SWcF8Yo8Of9TdSgKFGMwq1MKPJ9Jh8E8mB9rfgtm
	f8/0Ge+q1e5EwDw98Pg3zvKt2Aaogv94eb0IoKSxH4WffuK2YStZedTP3y3WqMnPZgGmqiR72Zo
	oiWCmNt9dchMG+P
X-Received: by 2002:a05:6402:34c6:b0:67b:d0e3:771d with SMTP id 4fb4d7f45d1cf-69810a5c861mr5900877a12.7.1782714163695;
        Sun, 28 Jun 2026 23:22:43 -0700 (PDT)
Received: from arch-piotr.tailb7ebba.ts.net (226.55.classcom.pl. [195.150.55.226])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6983a7f3989sm3592648a12.16.2026.06.28.23.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 23:22:43 -0700 (PDT)
From: Piotr Zarycki <piotr.zarycki@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org,
	Piotr Zarycki <piotr.zarycki@gmail.com>
Subject: [PATCH] scsi: isci: remove unused macros from scu_task_context.h
Date: Mon, 29 Jun 2026 08:22:57 +0200
Message-ID: <20260629062257.986945-1-piotr.zarycki@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove three accessor macros that are defined but never used:
- scu_get_command_request_subtype()
- scu_get_command_request_full_type()
- scu_get_command_protocl_engine_group()

Also remove SCU_CONTEXT_COMMAND_REQUEST_FULLTYPE_MASK and
SCU_CONTEXT_COMMAND_PROTOCOL_ENGINE_GROUP_MASK which were only
referenced by the removed macros.

Signed-off-by: Piotr Zarycki <piotr.zarycki@gmail.com>
---
 drivers/scsi/isci/scu_task_context.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/scsi/isci/scu_task_context.h b/drivers/scsi/isci/scu_task_context.h
index 582d22d54689..f877a5ebbbe0 100644
--- a/drivers/scsi/isci/scu_task_context.h
+++ b/drivers/scsi/isci/scu_task_context.h
@@ -193,21 +193,7 @@ typedef enum {
 
 #define SCU_CONTEXT_COMMAND_REQUEST_SUBTYPE_SHIFT        18
 #define SCU_CONTEXT_COMMAND_REQUEST_SUBTYPE_MASK         0x001C0000
-#define scu_get_command_request_subtype(x) \
-	((x) & SCU_CONTEXT_COMMAND_REQUEST_SUBTYPE_MASK)
-
-#define SCU_CONTEXT_COMMAND_REQUEST_FULLTYPE_MASK	 \
-	(\
-		SCU_CONTEXT_COMMAND_REQUEST_TYPE_MASK		  \
-		| SCU_CONTEXT_COMMAND_REQUEST_SUBTYPE_MASK	    \
-	)
-#define scu_get_command_request_full_type(x) \
-	((x) & SCU_CONTEXT_COMMAND_REQUEST_FULLTYPE_MASK)
-
 #define SCU_CONTEXT_COMMAND_PROTOCOL_ENGINE_GROUP_SHIFT  16
-#define SCU_CONTEXT_COMMAND_PROTOCOL_ENGINE_GROUP_MASK   0x00010000
-#define scu_get_command_protocl_engine_group(x)	\
-	((x) & SCU_CONTEXT_COMMAND_PROTOCOL_ENGINE_GROUP_MASK)
 
 #define SCU_CONTEXT_COMMAND_LOGICAL_PORT_SHIFT           12
 #define SCU_CONTEXT_COMMAND_LOGICAL_PORT_MASK            0x00007000
-- 
2.54.0

