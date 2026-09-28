Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B002485949
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 09:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790586049; cv=none; b=YcLVCzLKhao+cgqmYuxxiAezZqXtZNYthMI4Y0kjl7WAmUP+YiwAo9oejSaawC0lq0SKalYMVVRJoga2gubbpqSNV66gfFsVvONv7B0qb466v0URg4+ORcjdxWWXcbNa0h7CKuvHXaAFN7sRLhlpLnM6PlCQOs91YJlKDQi0nqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790586049; c=relaxed/simple;
	bh=90Z+tq/rVthsa03WRevq69b5pMIoGPu1Al1piH2Xmw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSo1RooDRhvC81p+gZZmDBeZxqSUNM1JPnAxEAYbhc2babrte9HA4IeeGGKmG0ImldFLPWFO5axd/wYK7VoRi6XWfTmXWRWR3hScSWwmQ5phhh4zIzC2E7eSnws5oxwjFFFA8KScicxS9x22PjpfHmqMI5iuzVYfsTMV0btLn6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=so2ujzGR; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="so2ujzGR"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-341d0522b4dso4348042eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 02:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790586047; x=1791190847; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t9bnHwcjdxWdO3Bfc0MWq5AqnySTB+8KpwDsijUilmA=;
        b=so2ujzGRZEUzxnZV7fGSf8xLZfMOzeAM5ih74JejP6KRNmhx+atrtgcOmhNe5BGIjz
         y6yTHx/8jm5ZD5fF/8xeys3c7FQz1IOuDJ/4qa/7C1MkhjFgtiyweSwr0INA0afaTeuX
         z2gY/iyPGaJq2+4si4/eXqK6GHwiDxI5/gNjT8srAu07mpQqSiuleLIsxcwDwpfLB2MF
         2o+RkbetBhEOBa1rKRrneCujaGD2Kal3UVSHUd1c2UkmWKtWqVRgXu+bwVOi72WWW985
         hl/+/OfeEYSEk0hQbiIhgZSyoOMnR4m+ET4zP5JQbQOz/oZOepRuCXuMG6jhJcvy1Qx/
         8vOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790586047; x=1791190847;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t9bnHwcjdxWdO3Bfc0MWq5AqnySTB+8KpwDsijUilmA=;
        b=UWXqPUC7uCb4SJKuoUo3eT4f6TIDUd60KYeBbxxiR/o2DQURFKrQhsX7AQGq0fE7KX
         VNiuTdD/qBkHnrUGc1QHLQI1xzTQ6qFTt41ywXj5F1yKRrpXE9uB3jl/Y+gao7es1jYa
         nVUSL/EgdbVgxxs73JRnhZs+VA0RMuLth1Y9v7lWs81ETT1R/BulHOL+38X+QNBirWH5
         dH825R7QwvM7Mvm1caY4Omml7+UPGMj9owQQGhWue/NN5uPcr3VAln8Pg7UrrEJKVFdb
         BY4IHIWSSj8n9muDgZzzNlt7gKnkNj4uRemTdVT7gO4qRIA4JhB3gA73y1j/gQ6vhfaf
         w2ZA==
X-Gm-Message-State: AFq9FYJZasost+gVP+5gffzYqJF8M9OrUXErGRZVXL6jCYKNT2jFAX5p
	vDNbwcYmqmMFLfddBZXF3Gwhlb6ghuwDQrrVUnjwCt+jyN+QMf6snMNq
X-Gm-Gg: AYBFou1H/GptFCpzx+qLlTPOha+xlK3+DpGST0ZCxqhYT6YBfamzHJXWNCkNTK9eH8p
	8apmaFP+uv0p7jDUhQ14h/v0mBPfDpFw1MQkI8RpZrKtr7hc9Q6Oy3cSkWA+rjiRhmfCYnZF6nZ
	6hcxGGd2RVlG1a9vkQr71I9anUluksUem+7N0b/i4vlYpt5s6u/Jaiz6OGbaGS+FHHFMTDKI3rS
	zh7F7sIR5iyTplckJHA8hMcajDppUTVfxkY1Fqxu7JnpILK091YPBQpnVqp5X8xAOhZf4mtWenv
	SEfSKzhTNngDBF14ZYyWhY+40xG3LHqqL2Tt0oRitWdMFswTE6XgCcR8wzFCLo7QdQatO77s71w
	RXBYCaEmYZDMCLxRShQbvITbU8ooBji8eXmUPwjD4s/uvEPT8+f/kX/pU/qxaVMsU0aJoYkaQ/G
	HT3gotuS23A2jDRNxsLjRELH/6lq6sQHtLWB9RMTFCVdXET9glPleIMTz3yMVaUSO9CqiODr4Zx
	3eGgjed0wcR99JbnUl5Z79TDO8S
X-Received: by 2002:a05:7300:3b28:b0:328:2ea5:bd39 with SMTP id 5a478bee46e88-342705b94bcmr14473911eec.4.1790586046805;
        Mon, 28 Sep 2026 02:00:46 -0700 (PDT)
Received: from homik.search.charter.net ([2603:8002:ad40:56f0:3430:2ac1:d99f:94d7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34144172de6sm43351473eec.9.2026.09.28.02.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 02:00:46 -0700 (PDT)
From: Mariia Nikitash <nikitash.mariiaw@gmail.com>
To: anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	morbo@google.com,
	kees@kernel.org,
	justinstitt@google.com,
	codemender-patching+linux@google.com,
	Mariia Nikitash <nikitash.mariiaw@gmail.com>
Subject: [PATCH v2 2/2] scsi: bfa: Use snprintf() in bfa_fcs_fabric_psymb_init()
Date: Mon, 28 Sep 2026 02:00:30 -0700
Message-ID: <20260928090031.712418-3-nikitash.mariiaw@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260928090031.712418-1-nikitash.mariiaw@gmail.com>
References: <20260928090031.712418-1-nikitash.mariiaw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bill Wendling <morbo@google.com>

Similar to bfa_fcs_fabric_nsymb_init(), bfa_fcs_fabric_psymb_init()
builds the port symbolic name using strscpy() and a chain of seven or
eight strlcat() calls.

In preparation for removing the deprecated strlcat() API[1], replace the
chained strscpy() and strlcat() calls with a single snprintf() call.

An empty host_os_patch naturally contributes no characters through %s,
allowing both cases to be handled by the same snprintf() call. Since
snprintf() also NUL-terminates the destination, the explicit final NUL
assignment can be dropped.

Link: https://github.com/KSPP/linux/issues/370 [1]
Cc: codemender-patching+linux@google.com
Assisted-by: LLM
Signed-off-by: Bill Wendling <morbo@google.com>
Signed-off-by: Mariia Nikitash <nikitash.mariiaw@gmail.com>
---
 drivers/scsi/bfa/bfa_fcs.c | 57 +++++++-------------------------------
 1 file changed, 10 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 7a4e0e8c7182..3e5d3a141f32 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -760,53 +760,16 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric)
 
 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
 
-	/* Model name/number */
-	strscpy(port_cfg->sym_name.symname, model,
-		BFA_SYMNAME_MAXLEN);
-	strlcat(port_cfg->sym_name.symname, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-		BFA_SYMNAME_MAXLEN);
-
-	/* Driver Version */
-	strlcat(port_cfg->sym_name.symname, driver_info->version,
-		BFA_SYMNAME_MAXLEN);
-	strlcat(port_cfg->sym_name.symname, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-		BFA_SYMNAME_MAXLEN);
-
-	/* Host machine name */
-	strlcat(port_cfg->sym_name.symname,
-		driver_info->host_machine_name,
-		BFA_SYMNAME_MAXLEN);
-	strlcat(port_cfg->sym_name.symname, BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-		BFA_SYMNAME_MAXLEN);
-
-	/*
-	 * Host OS Info :
-	 * If OS Patch Info is not there, do not truncate any bytes from the
-	 * OS name string and instead copy the entire OS info string (64 bytes).
-	 */
-	if (driver_info->host_os_patch[0] == '\0') {
-		strlcat(port_cfg->sym_name.symname,
-			driver_info->host_os_name,
-			BFA_SYMNAME_MAXLEN);
-		strlcat(port_cfg->sym_name.symname,
-			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			BFA_SYMNAME_MAXLEN);
-	} else {
-		strlcat(port_cfg->sym_name.symname,
-			driver_info->host_os_name,
-			BFA_SYMNAME_MAXLEN);
-		strlcat(port_cfg->sym_name.symname,
-			BFA_FCS_PORT_SYMBNAME_SEPARATOR,
-			BFA_SYMNAME_MAXLEN);
-
-		/* Append host OS Patch Info */
-		strlcat(port_cfg->sym_name.symname,
-			driver_info->host_os_patch,
-			BFA_SYMNAME_MAXLEN);
-	}
-
-	/* null terminate */
-	port_cfg->sym_name.symname[BFA_SYMNAME_MAXLEN - 1] = 0;
+	snprintf(port_cfg->sym_name.symname, BFA_SYMNAME_MAXLEN,
+		 "%s" BFA_FCS_PORT_SYMBNAME_SEPARATOR
+		 "%s" BFA_FCS_PORT_SYMBNAME_SEPARATOR
+		 "%s" BFA_FCS_PORT_SYMBNAME_SEPARATOR
+		 "%s" BFA_FCS_PORT_SYMBNAME_SEPARATOR
+		 "%s",
+		 model, driver_info->version,
+		 driver_info->host_machine_name,
+		 driver_info->host_os_name,
+		 driver_info->host_os_patch);
 }
 
 /*
-- 
2.43.0

