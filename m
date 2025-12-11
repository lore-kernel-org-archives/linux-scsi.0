Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com [209.85.215.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25103285C8C
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2025 06:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765436152; cv=none; b=rrdS0K22+qP/4NxMziUwG5OT+ufIMxVbD2T1t4xtTg0bwuBI1iFOqOhdLDgXZkLl8R4sqJKFT2BcaTV/OXvHi+2aUlC2O4DiSuopRtAIy8OCAgpx1bP6pDJ9u0UMslH4wKDetI7EZahfnGMZJsjpqo6/eB4s2rSXUfQss02yNk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765436152; c=relaxed/simple;
	bh=R9WIV3vMS8EaHi9ctZrx08nI4MLcLki1EX028FF44kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcvJmftEdp9eEF03bC6HKsaOXo6b3YyMSPeLMNwe9TPYZZkqoD/guLHyTtP9EWhzs+IMizc6K9lP22UCHdCXmuNRWKJ29waSu/YgxrTs2SiR15FbD+mWs+VYiu+y8lYRjc5zYpRSm8bLtSa3+dbR0BTbDlpQMuLi+G1EYfctiYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S2uwwQ5C; arc=none smtp.client-ip=209.85.215.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S2uwwQ5C"
Received: by mail-pg1-f193.google.com with SMTP id 41be03b00d2f7-c075ec1a58aso431490a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 22:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765436149; x=1766040949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pe5WSOcUQ6AzyM6/rOewkIk9M5gMmXAAUpRdwUcW3jo=;
        b=S2uwwQ5C206Fnbfz9/Du2KrB5v8MEI1ytZRGabgFBLC5/H26vetoXbMhibAXzSQAEw
         AbcQ7ySC0Sjak66sh4jDXwSMxvy9wiYur7uuKIa+ipjgI+qLeMdyQlEbuS0bKLaAJsF5
         Jh6K37vqZJMQM9RowvVwqfJXa2eiPZuMP6TevrBppvN6ly1t18nK1UQsxzCwgWbj16uW
         W4zCBPyDBcLf1DPfAnkcEtkLIAR9czXUAsQA8x8RNdhTDDix9qEgjSlFy3ADVa0US6/E
         MM66rhdJ+9dcJsBQ3u3DUMtDnlWh+ODTD105bk5pnFYGT5vn5eMxe3N1LdCsTCfXA9E/
         CF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765436149; x=1766040949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Pe5WSOcUQ6AzyM6/rOewkIk9M5gMmXAAUpRdwUcW3jo=;
        b=RY+BZ8cM+3o1S4LT0b6IlmGxJZcEXp4eC2vCruQREPVaS3lYD6LtwEa8Gv0iy2/kNh
         IODItxzbY+v7YnUzACD/eSuJQ7sL7y2z7Sjha9mWomN+V2qKCjjMdHZhKVUrQmiliH81
         TVHZn6tBtXYnajqqwaDjMoyRAUhrmrtSdT83i+JGju37HHIf+1C7w4rC2gsATROzYmnH
         5K1Tg3KRsVM66rRzo4V80n2l5LmzkAjnmHFSTU8Nbi29AsPbZdz4sBRRhtrESZju8eyn
         ToHuz1lb2PVn45TplaUGudsPoMPrEQXbCnRojyO+3+d8P7gqdPMJgeI61T3PlD4t61GX
         Pzcw==
X-Gm-Message-State: AOJu0YwVYs2qufMq6SEYPw6QM19qSmR7A5/kHwvU5UzRDKHfrHBYHrp+
	aLAK/E48TRV0fiiOm7haCrK2MWONwIVYOSowaVfOM+KNdCTYOv5MlY4zMDURdcIWGCXfew==
X-Gm-Gg: AY/fxX7nB02YhjAWyVO3cZtsu9Nv54htCLq+VlBahAUPg1D0aJ4m/fY3sxg522nmhAo
	fXeJyBVLBFU61Yq/tv4ba+RN/dzkPEsvdCtRQ3wYF5H5Up+MNBceEFla0ai0ZOAvjN3TA45molI
	B3bTfpfrZi+fub1os1EynYDXiAF/SOee5IUaapHbydyQUe7apG33irsTy+Gdrt8JyoE44OLlCX6
	t1W+qoPnuc8tS4mjHEB1CXK875f4FPsa/SOPm1pi00XOPUdAigzf0jRkxJOztP5oG70WfpikF+i
	Z3JT6i47u8pPlSH0YnUkywYZuTDCNkQs94EXTaZAZm9uhLJHPLkqkBI6Bw52kK2tFDayJ3at5JF
	941jGOEiVuVYlwdTJqae7jhffq6eH1aDibOtjq0g90xCJ+mKjvcxnIX9HWFFAFKmQdjwi+pPNKB
	VUl9zV02Fl1xCRx1bdH9yPS9/6+qZeSyl+kQ83VrwP7DoS7W9Xb+/uTavSxETHwsXvjzOxDyPVM
	aw8
X-Google-Smtp-Source: AGHT+IE3FPn3HxWcgC5ukMMK94STYbDl1jgCQ/4/wO9iVAR1MkTnwJR3BGeGs55M1tC6fbcSxn1yzQ==
X-Received: by 2002:a05:7022:6b99:b0:11b:923d:7735 with SMTP id a92af1059eb24-11f29669e54mr3780617c88.1.1765436149063;
        Wed, 10 Dec 2025 22:55:49 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e2ffac2sm5355997c88.11.2025.12.10.22.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 22:55:48 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: [PATCH v2 1/2] scsi: sym53c8xx_2: remove code depending on non-default values of macros
Date: Wed, 10 Dec 2025 22:55:30 -0800
Message-ID: <20251211065538.146629-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251211014246.38423-2-enelsonmoore@gmail.com>
References: <20251211014246.38423-2-enelsonmoore@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The macros themselves are also removed.
This makes the code easier to understand and maintain. There is more
unused code to remove, but this takes care of some low-hanging fruit.
The changes were mostly done via unifdef.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/scsi/sym53c8xx_2/sym53c8xx.h | 30 ------------
 drivers/scsi/sym53c8xx_2/sym_fw.c    | 10 ----
 drivers/scsi/sym53c8xx_2/sym_glue.c  | 40 ----------------
 drivers/scsi/sym53c8xx_2/sym_hipd.c  | 72 +---------------------------
 drivers/scsi/sym53c8xx_2/sym_hipd.h  | 16 +------
 drivers/scsi/sym53c8xx_2/sym_nvram.h | 16 -------
 6 files changed, 3 insertions(+), 181 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym53c8xx.h b/drivers/scsi/sym53c8xx_2/sym53c8xx.h
index 11f5dc29aa59..fbfda238b703 100644
--- a/drivers/scsi/sym53c8xx_2/sym53c8xx.h
+++ b/drivers/scsi/sym53c8xx_2/sym53c8xx.h
@@ -38,28 +38,6 @@
  */
 #define	SYM_CONF_DMA_ADDRESSING_MODE CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE
 
-/*
- *  NVRAM support.
- */
-#if 1
-#define SYM_CONF_NVRAM_SUPPORT		(1)
-#endif
-
-/*
- *  These options are not tunable from 'make config'
- */
-#if 1
-#define	SYM_LINUX_PROC_INFO_SUPPORT
-#define SYM_LINUX_USER_COMMAND_SUPPORT
-#define SYM_LINUX_USER_INFO_SUPPORT
-#define SYM_LINUX_DEBUG_CONTROL_SUPPORT
-#endif
-
-/*
- *  Also handle old NCR chips if not (0).
- */
-#define SYM_CONF_GENERIC_SUPPORT	(1)
-
 /*
  *  Allow tags from 2 to 256, default 8
  */
@@ -191,12 +169,4 @@ extern unsigned int sym_debug_flags;
 #define SYM_CONF_IARB_MAX 3
 #define SYM_CONF_SET_IARB_ON_ARB_LOST 1
 
-/*
- *  Returning wrong residuals may make problems.
- *  When zero, this define tells the driver to 
- *  always return 0 as transfer residual.
- *  Btw, all my testings of residuals have succeeded.
- */
-#define SYM_SETUP_RESIDUAL_SUPPORT 1
-
 #endif /* SYM53C8XX_H */
diff --git a/drivers/scsi/sym53c8xx_2/sym_fw.c b/drivers/scsi/sym53c8xx_2/sym_fw.c
index c536d2a9a657..6fe98f754333 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw.c
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.c
@@ -36,7 +36,6 @@
 #define	PADDR_B(label)		SYM_GEN_PADDR_B(struct SYM_FWB_SCR, label)
 
 
-#if	SYM_CONF_GENERIC_SUPPORT
 /*
  *  Allocate firmware #1 script area.
  */
@@ -56,7 +55,6 @@ static struct sym_fwz_ofs sym_fw1z_ofs = {
 #undef	SYM_FWA_SCR
 #undef	SYM_FWB_SCR
 #undef	SYM_FWZ_SCR
-#endif	/* SYM_CONF_GENERIC_SUPPORT */
 
 /*
  *  Allocate firmware #2 script area.
@@ -86,7 +84,6 @@ static struct sym_fwz_ofs sym_fw2z_ofs = {
 #undef	PADDR_A
 #undef	PADDR_B
 
-#if	SYM_CONF_GENERIC_SUPPORT
 /*
  *  Patch routine for firmware #1.
  */
@@ -127,7 +124,6 @@ sym_fw1_patch(struct Scsi_Host *shost)
 	scriptb0->done_pos[0]	= cpu_to_scr(np->dqueue_ba);
 	scriptb0->targtbl[0]	= cpu_to_scr(np->targtbl_ba);
 }
-#endif	/* SYM_CONF_GENERIC_SUPPORT */
 
 /*
  *  Patch routine for firmware #2.
@@ -274,7 +270,6 @@ sym_fw_setup_bus_addresses(struct sym_hcb *np, struct sym_fw *fw)
 		pa[i] = np->scriptz_ba + po[i];
 }
 
-#if	SYM_CONF_GENERIC_SUPPORT
 /*
  *  Setup routine for firmware #1.
  */
@@ -295,7 +290,6 @@ sym_fw1_setup(struct sym_hcb *np, struct sym_fw *fw)
 	 */
 	sym_fw_setup_bus_addresses(np, fw);
 }
-#endif	/* SYM_CONF_GENERIC_SUPPORT */
 
 /*
  *  Setup routine for firmware #2.
@@ -321,9 +315,7 @@ sym_fw2_setup(struct sym_hcb *np, struct sym_fw *fw)
 /*
  *  Allocate firmware descriptors.
  */
-#if	SYM_CONF_GENERIC_SUPPORT
 static struct sym_fw sym_fw1 = SYM_FW_ENTRY(sym_fw1, "NCR-generic");
-#endif	/* SYM_CONF_GENERIC_SUPPORT */
 static struct sym_fw sym_fw2 = SYM_FW_ENTRY(sym_fw2, "LOAD/STORE-based");
 
 /*
@@ -334,10 +326,8 @@ sym_find_firmware(struct sym_chip *chip)
 {
 	if (chip->features & FE_LDSTR)
 		return &sym_fw2;
-#if	SYM_CONF_GENERIC_SUPPORT
 	else if (!(chip->features & (FE_PFEN|FE_NOPM|FE_DAC)))
 		return &sym_fw1;
-#endif
 	else
 		return NULL;
 }
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 57637a81776d..9c590211f3fe 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -908,7 +908,6 @@ static const char *sym53c8xx_info (struct Scsi_Host *host)
 }
 
 
-#ifdef SYM_LINUX_PROC_INFO_SUPPORT
 /*
  *  Proc file system stuff
  *
@@ -918,8 +917,6 @@ static const char *sym53c8xx_info (struct Scsi_Host *host)
  *  to the sym_usercmd() function.
  */
 
-#ifdef SYM_LINUX_USER_COMMAND_SUPPORT
-
 struct	sym_usrcmd {
 	u_long	target;
 	u_long	lun;
@@ -944,11 +941,9 @@ static void sym_exec_user_command (struct sym_hcb *np, struct sym_usrcmd *uc)
 	switch (uc->cmd) {
 	case 0: return;
 
-#ifdef SYM_LINUX_DEBUG_CONTROL_SUPPORT
 	case UC_SETDEBUG:
 		sym_debug_flags = uc->data;
 		break;
-#endif
 	case UC_SETVERBOSE:
 		np->verbose = uc->data;
 		break;
@@ -1084,10 +1079,8 @@ static int sym_user_command(struct Scsi_Host *shost, char *buffer, int length)
 		uc->cmd = UC_SETVERBOSE;
 	else if	((arg_len = is_keyword(ptr, len, "setwide")) != 0)
 		uc->cmd = UC_SETWIDE;
-#ifdef SYM_LINUX_DEBUG_CONTROL_SUPPORT
 	else if	((arg_len = is_keyword(ptr, len, "setdebug")) != 0)
 		uc->cmd = UC_SETDEBUG;
-#endif
 	else if	((arg_len = is_keyword(ptr, len, "setflag")) != 0)
 		uc->cmd = UC_SETFLAG;
 	else if	((arg_len = is_keyword(ptr, len, "resetdev")) != 0)
@@ -1097,10 +1090,6 @@ static int sym_user_command(struct Scsi_Host *shost, char *buffer, int length)
 	else
 		arg_len = 0;
 
-#ifdef DEBUG_PROC_INFO
-printk("sym_user_command: arg_len=%d, cmd=%ld\n", arg_len, uc->cmd);
-#endif
-
 	if (!arg_len)
 		return -EINVAL;
 	ptr += arg_len; len -= arg_len;
@@ -1119,9 +1108,6 @@ printk("sym_user_command: arg_len=%d, cmd=%ld\n", arg_len, uc->cmd);
 		} else {
 			GET_INT_ARG(ptr, len, target);
 			uc->target = (1<<target);
-#ifdef DEBUG_PROC_INFO
-printk("sym_user_command: target=%ld\n", target);
-#endif
 		}
 		break;
 	}
@@ -1133,11 +1119,7 @@ printk("sym_user_command: target=%ld\n", target);
 	case UC_SETWIDE:
 		SKIP_SPACES(ptr, len);
 		GET_INT_ARG(ptr, len, uc->data);
-#ifdef DEBUG_PROC_INFO
-printk("sym_user_command: data=%ld\n", uc->data);
-#endif
 		break;
-#ifdef SYM_LINUX_DEBUG_CONTROL_SUPPORT
 	case UC_SETDEBUG:
 		while (len > 0) {
 			SKIP_SPACES(ptr, len);
@@ -1167,11 +1149,7 @@ printk("sym_user_command: data=%ld\n", uc->data);
 				return -EINVAL;
 			ptr += arg_len; len -= arg_len;
 		}
-#ifdef DEBUG_PROC_INFO
-printk("sym_user_command: data=%ld\n", uc->data);
-#endif
 		break;
-#endif /* SYM_LINUX_DEBUG_CONTROL_SUPPORT */
 	case UC_SETFLAG:
 		while (len > 0) {
 			SKIP_SPACES(ptr, len);
@@ -1198,15 +1176,12 @@ printk("sym_user_command: data=%ld\n", uc->data);
 	return length;
 }
 
-#endif	/* SYM_LINUX_USER_COMMAND_SUPPORT */
-
 
 /*
  *  Copy formatted information into the input buffer.
  */
 static int sym_show_info(struct seq_file *m, struct Scsi_Host *shost)
 {
-#ifdef SYM_LINUX_USER_INFO_SUPPORT
 	struct sym_data *sym_data = shost_priv(shost);
 	struct pci_dev *pdev = sym_data->pdev;
 	struct sym_hcb *np = sym_data->ncb;
@@ -1226,13 +1201,8 @@ static int sym_show_info(struct seq_file *m, struct Scsi_Host *shost)
 		 SYM_CONF_MAX_START, SYM_CONF_MAX_TAG);
 
 	return 0;
-#else
-	return -EINVAL;
-#endif /* SYM_LINUX_USER_INFO_SUPPORT */
 }
 
-#endif /* SYM_LINUX_PROC_INFO_SUPPORT */
-
 /*
  * Free resources claimed by sym_iomap_device().  Note that
  * sym_free_resources() should be used instead of this function after calling
@@ -1431,7 +1401,6 @@ static struct Scsi_Host *sym_attach(const struct scsi_host_template *tpnt, int u
 /*
  *    Detect and try to read SYMBIOS and TEKRAM NVRAM.
  */
-#if SYM_CONF_NVRAM_SUPPORT
 static void sym_get_nvram(struct sym_device *devp, struct sym_nvram *nvp)
 {
 	devp->nvram = nvp;
@@ -1439,11 +1408,6 @@ static void sym_get_nvram(struct sym_device *devp, struct sym_nvram *nvp)
 
 	sym_read_nvram(devp, nvp);
 }
-#else
-static inline void sym_get_nvram(struct sym_device *devp, struct sym_nvram *nvp)
-{
-}
-#endif	/* SYM_CONF_NVRAM_SUPPORT */
 
 static int sym_check_supported(struct sym_device *device)
 {
@@ -1694,13 +1658,9 @@ static const struct scsi_host_template sym2_template = {
 	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
 	.this_id		= 7,
 	.max_sectors		= 0xFFFF,
-#ifdef SYM_LINUX_PROC_INFO_SUPPORT
 	.show_info		= sym_show_info,
-#ifdef	SYM_LINUX_USER_COMMAND_SUPPORT
 	.write_info		= sym_user_command,
-#endif
 	.proc_name		= NAME53C8XX,
-#endif
 };
 
 static int attach_count;
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index f0db17e34ea0..38747ece8c94 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -31,10 +31,6 @@
 #include "sym_glue.h"
 #include "sym_nvram.h"
 
-#if 0
-#define SYM_DEBUG_GENERIC_SUPPORT
-#endif
-
 /*
  *  Needed function prototypes.
  */
@@ -438,11 +434,7 @@ static int sym_getpciclock (struct sym_hcb *np)
 	 *  For now, we only need to know about the actual 
 	 *  PCI BUS clock frequency for C1010-66 chips.
 	 */
-#if 1
 	if (np->features & FE_66MHZ) {
-#else
-	if (1) {
-#endif
 		OUTB(np, nc_stest1, SCLK); /* Use the PCI clock as SCSI clock */
 		f = sym_getfreq(np);
 		OUTB(np, nc_stest1, 0);
@@ -496,7 +488,6 @@ sym_getsync(struct sym_hcb *np, u_char dt, u_char sfac, u_char *divp, u_char *fa
 	 *  to 5 Mega-transfers per second and may result in
 	 *  using higher clock divisors.
 	 */
-#if 1
 	if ((np->features & (FE_C10|FE_U3EN)) == FE_C10) {
 		/*
 		 *  Look for the lowest clock divisor that allows an 
@@ -517,7 +508,6 @@ sym_getsync(struct sym_hcb *np, u_char dt, u_char sfac, u_char *divp, u_char *fa
 		*fakp = fak;
 		return ret;
 	}
-#endif
 
 	/*
 	 *  Look for the greatest clock divisor that allows an 
@@ -825,11 +815,7 @@ static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, stru
 		np->rv_dmode	|= BOF;		/* Burst Opcode Fetch */
 	if (np->features & FE_ERMP)
 		np->rv_dmode	|= ERMP;	/* Enable Read Multiple */
-#if 1
 	if ((np->features & FE_PFEN) && !np->ram_ba)
-#else
-	if (np->features & FE_PFEN)
-#endif
 		np->rv_dcntl	|= PFEN;	/* Prefetch Enable */
 	if (np->features & FE_CLSE)
 		np->rv_dcntl	|= CLSE;	/* Cache Line Size Enable */
@@ -1032,7 +1018,7 @@ static int sym_snooptest(struct sym_hcb *np)
 	 *  Check for fatal DMA errors.
 	 */
 	dstat = INB(np, nc_dstat);
-#if 1	/* Band aiding for broken hardwares that fail PCI parity */
+	/* Band aiding for broken hardware that fails PCI parity */
 	if ((dstat & MDPE) && (np->rv_ctest4 & MPEE)) {
 		printf ("%s: PCI DATA PARITY ERROR DETECTED - "
 			"DISABLING MASTER DATA PARITY CHECKING.\n",
@@ -1040,7 +1026,6 @@ static int sym_snooptest(struct sym_hcb *np)
 		np->rv_ctest4 &= ~MPEE;
 		goto restart_test;
 	}
-#endif
 	if (dstat & (MDPE|BF|IID)) {
 		printf ("CACHE TEST FAILED: DMA error (dstat=0x%02x).", dstat);
 		return (0x80);
@@ -1187,15 +1172,9 @@ static struct sym_chip sym_dev_table[] = {
  {PCI_DEVICE_ID_NCR_53C810, 0x0f, "810", 4, 8, 4, 64,
  FE_ERL}
  ,
-#ifdef SYM_DEBUG_GENERIC_SUPPORT
- {PCI_DEVICE_ID_NCR_53C810, 0xff, "810a", 4,  8, 4, 1,
- FE_BOF}
- ,
-#else
  {PCI_DEVICE_ID_NCR_53C810, 0xff, "810a", 4,  8, 4, 1,
  FE_CACHE_SET|FE_LDSTR|FE_PFEN|FE_BOF}
  ,
-#endif
  {PCI_DEVICE_ID_NCR_53C815, 0xff, "815", 4,  8, 4, 64,
  FE_BOF|FE_ERL}
  ,
@@ -1224,17 +1203,10 @@ static struct sym_chip sym_dev_table[] = {
  FE_WIDE|FE_ULTRA|FE_DBLR|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_DIFF|FE_VARCLK}
  ,
-#ifdef SYM_DEBUG_GENERIC_SUPPORT
- {PCI_DEVICE_ID_NCR_53C895, 0xff, "895", 6, 31, 7, 2,
- FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|
- FE_RAM|FE_LCKFRQ}
- ,
-#else
  {PCI_DEVICE_ID_NCR_53C895, 0xff, "895", 6, 31, 7, 2,
  FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_LCKFRQ}
  ,
-#endif
  {PCI_DEVICE_ID_NCR_53C896, 0xff, "896", 6, 31, 7, 4,
  FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_LCKFRQ}
@@ -1941,10 +1913,6 @@ static void sym_settrans(struct sym_hcb *np, int target, u_char opts, u_char ofs
 	wval = tp->head.wval;
 	uval = tp->head.uval;
 
-#if 0
-	printf("XXXX sval=%x wval=%x uval=%x (%x)\n", 
-		sval, wval, uval, np->rv_scntl3);
-#endif
 	/*
 	 *  Set the offset.
 	 */
@@ -2363,11 +2331,8 @@ static void sym_int_par (struct sym_hcb *np, u_short sist)
 		}
 	}
 	else if (phase == 7)	/* We definitely cannot handle parity errors */
-#if 1				/* in message-in phase due to the relection  */
+				/* in message-in phase due to the relection  */
 		goto reset_all; /* path and various message anticipations.   */
-#else
-		OUTL_DSP(np, SCRIPTA_BA(np, clrack));
-#endif
 	else
 		OUTL_DSP(np, SCRIPTA_BA(np, dispatch));
 	return;
@@ -3219,9 +3184,6 @@ int sym_clear_tasks(struct sym_hcb *np, int cam_status, int target, int lun, int
 		if (sym_get_cam_status(cmd) != DID_TIME_OUT)
 			sym_set_cam_status(cmd, cam_status);
 		++i;
-#if 0
-printf("XXXX TASK @%p CLEARED\n", cp);
-#endif
 	}
 	return i;
 }
@@ -4950,15 +4912,6 @@ static struct sym_ccb *sym_ccb_from_dsa(struct sym_hcb *np, u32 dsa)
  */
 static void sym_init_tcb (struct sym_hcb *np, u_char tn)
 {
-#if 0	/*  Hmmm... this checking looks paranoid. */
-	/*
-	 *  Check some alignments required by the chip.
-	 */	
-	assert (((offsetof(struct sym_reg, nc_sxfer) ^
-		offsetof(struct sym_tcb, head.sval)) &3) == 0);
-	assert (((offsetof(struct sym_reg, nc_scntl3) ^
-		offsetof(struct sym_tcb, head.wval)) &3) == 0);
-#endif
 }
 
 /*
@@ -5394,15 +5347,6 @@ void sym_complete_error(struct sym_hcb *np, struct sym_ccb *cp)
 	 */
 	resid = sym_compute_residual(np, cp);
 
-	if (!SYM_SETUP_RESIDUAL_SUPPORT) {/* If user does not want residuals */
-		resid  = 0;		 /* throw them away. :)		    */
-		cp->sv_resid = 0;
-	}
-#ifdef DEBUG_2_0_X
-if (resid)
-	printf("XXXX RESID= %d - 0x%x\n", resid, resid);
-#endif
-
 	/*
 	 *  Dequeue all queued CCBs for that device 
 	 *  not yet started by SCRIPTS.
@@ -5519,18 +5463,6 @@ void sym_complete_ok (struct sym_hcb *np, struct sym_ccb *cp)
 	if (cp->phys.head.lastp != cp->goalp)
 		resid = sym_compute_residual(np, cp);
 
-	/*
-	 *  Wrong transfer residuals may be worse than just always 
-	 *  returning zero. User can disable this feature in 
-	 *  sym53c8xx.h. Residual support is enabled by default.
-	 */
-	if (!SYM_SETUP_RESIDUAL_SUPPORT)
-		resid  = 0;
-#ifdef DEBUG_2_0_X
-if (resid)
-	printf("XXXX RESID= %d - 0x%x\n", resid, resid);
-#endif
-
 	/*
 	 *  Build result in CAM ccb.
 	 */
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 9231a2899064..b51f7130b327 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -293,12 +293,8 @@
 #define CCB_HASH_SHIFT		8
 #define CCB_HASH_SIZE		(1UL << CCB_HASH_SHIFT)
 #define CCB_HASH_MASK		(CCB_HASH_SIZE-1)
-#if 1
 #define CCB_HASH_CODE(dsa)	\
 	(((dsa) >> (_LGRU16_(sizeof(struct sym_ccb)))) & CCB_HASH_MASK)
-#else
-#define CCB_HASH_CODE(dsa)	(((dsa) >> 9) & CCB_HASH_MASK)
-#endif
 
 #if	SYM_CONF_DMA_ADDRESSING_MODE == 2
 /*
@@ -660,7 +656,6 @@ struct sym_ccbh {
  *  that use directly the header in the CCB, and the NCR-GENERIC 
  *  SCRIPTS that use the copy of the header in the HCB.
  */
-#if	SYM_CONF_GENERIC_SUPPORT
 #define sym_set_script_dp(np, cp, dp)				\
 	do {							\
 		if (np->features & FE_LDSTR)			\
@@ -671,14 +666,6 @@ struct sym_ccbh {
 #define sym_get_script_dp(np, cp) 				\
 	scr_to_cpu((np->features & FE_LDSTR) ?			\
 		cp->phys.head.lastp : np->ccb_head.lastp)
-#else
-#define sym_set_script_dp(np, cp, dp)				\
-	do {							\
-		cp->phys.head.lastp = cpu_to_scr(dp);		\
-	} while (0)
-
-#define sym_get_script_dp(np, cp) (cp->phys.head.lastp)
-#endif
 
 /*
  *  Data Structure Block
@@ -801,11 +788,10 @@ struct sym_hcb {
 	 *  chips (810, 815, 825) copy part of the data structures 
 	 *  (CCB, TCB and LCB) in fixed areas.
 	 */
-#if	SYM_CONF_GENERIC_SUPPORT
 	struct sym_ccbh	ccb_head;
 	struct sym_tcbh	tcb_head;
 	struct sym_lcbh	lcb_head;
-#endif
+
 	/*
 	 *  Idle task and invalid task actions and 
 	 *  their bus addresses.
diff --git a/drivers/scsi/sym53c8xx_2/sym_nvram.h b/drivers/scsi/sym53c8xx_2/sym_nvram.h
index d07da39cc240..890d2bda8d88 100644
--- a/drivers/scsi/sym53c8xx_2/sym_nvram.h
+++ b/drivers/scsi/sym53c8xx_2/sym_nvram.h
@@ -170,32 +170,16 @@ struct sym_nvram {
 #define	SYM_SYMBIOS_NVRAM	(1)
 #define	SYM_TEKRAM_NVRAM	(2)
 #define SYM_PARISC_PDC		(3)
-#if SYM_CONF_NVRAM_SUPPORT
 	union {
 		Symbios_nvram Symbios;
 		Tekram_nvram Tekram;
 		struct pdc_initiator parisc;
 	} data;
-#endif
 };
 
-#if SYM_CONF_NVRAM_SUPPORT
 void sym_nvram_setup_host(struct Scsi_Host *shost, struct sym_hcb *np, struct sym_nvram *nvram);
 void sym_nvram_setup_target (struct sym_tcb *tp, int target, struct sym_nvram *nvp);
 int sym_read_nvram (struct sym_device *np, struct sym_nvram *nvp);
 char *sym_nvram_type(struct sym_nvram *nvp);
-#else
-static inline void sym_nvram_setup_host(struct Scsi_Host *shost, struct sym_hcb *np, struct sym_nvram *nvram) { }
-static inline void sym_nvram_setup_target(struct sym_tcb *tp, struct sym_nvram *nvram) { }
-static inline int sym_read_nvram(struct sym_device *np, struct sym_nvram *nvp)
-{
-	nvp->type = 0;
-	return 0;
-}
-static inline char *sym_nvram_type(struct sym_nvram *nvp)
-{
-	return "No NVRAM";
-}
-#endif
 
 #endif /* SYM_NVRAM_H */
-- 
2.43.0

