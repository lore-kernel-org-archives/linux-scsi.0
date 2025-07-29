Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111C426CE26;
	Tue, 29 Jul 2025 06:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753771809; cv=none; b=C6PLjk5fOxPMHKrhkvIprVPtfXnPOtIi06fDqnJ1YPK81pcTs94U4i9i7aT3LLc0obXGF43jU4X1QGwuyLCeaZiT4TxsCIz3TLna9djBc8IjQJZlKYmK8S771OCso5s0ZgpafMjZPfP4P8DtuTHVJ1MUtaUIjJ2zW+T823JUWXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753771809; c=relaxed/simple;
	bh=8x6t2E3bvaUsqe85HBcgG0NsUSVA+YA+IiexRtuqtRY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RO1e1e3opPVZBhX/YZUdzqaFFyB1Hg3H01Maw8u61o3J6a5/ZTsg/KAbePkS9plkKQO2pPnKNYorK4VnybVeCbYAeo8Ieq8gg62CsMh6NTDU2PFD8fNi+Ius2kkpzYtt/1dwvKjF8TALZzqahkW7epApJcDP72UUQxBgOr5rsxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NblPqzHq; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NblPqzHq"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b783d851e6so2303920f8f.0;
        Mon, 28 Jul 2025 23:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753771805; x=1754376605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a7haeLuJT5v3aQv8eOv4BBhTxNeYgMYlcDfN4H3p9Y4=;
        b=NblPqzHq59a4jmx1B8cWyA1DiXAG784WaCDhCRqAAXHdDAZdPuisYFdtppS9h+3Lxy
         kwTC9IcsxJ2U12LdDqKiJgXGegx5PrP5cCRfqexL1Wx8JY9p5qJ8gLtKKjC6+cKVh+Wp
         Z8yR34REFY9kd5nRpRwVp03F7lj6yIPXx7bufmRiJBrJnaedXJDGYDS0PHBl5ZJZUH1o
         hOFUWt0U7P8RphZ0HWbWKx4CI4jofztmyCBOl0EY9uNSZbiBYcJoOlKdODpatrJc7Zwq
         94bE8L27hfxFuDlLvaxkKhtJgnwXlBqsh4MjiJtSB/3lFHYZMA+KmCs+RLkZlzu5GbP9
         oO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753771805; x=1754376605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a7haeLuJT5v3aQv8eOv4BBhTxNeYgMYlcDfN4H3p9Y4=;
        b=hLcu7I0DR6RFXXf7cwMQoMArp4wkWBE09HHvtPVlTE8vtuXSTgS8N70c/zRJjsRpL8
         et8A3/i/qajsOafWxDAW7MBPqKROc/vhnl4YOe3FlbkXuwWwTg2Q8i/7qcayinmndZnM
         QLfKQ7UYBIDfaX0jS5x7FbIfGoDZmpRHb/Znnbwp8AIWwxuTQLdumhzeqBNhqlAnzlV1
         eL2xiB537lxApclqH0W2OYVzGhS/hx0Ls5+6DiJGK01dBTuKBR4kUjnez308oiUNYs33
         hJgjvvNILJgMlRVUOU2D0gG23tPWK68UupNwC+T1x3Uj/7RfR+MJD9vbdM5gujK50RpM
         I/2A==
X-Forwarded-Encrypted: i=1; AJvYcCWPUuyrJNGmR8L/UGoygWcRCKVJgs5fBLu30YNvPy+UYIfWOTqvxZXydg9LcPeFx6NfYXdrn+aqshiNvg==@vger.kernel.org, AJvYcCXmQEQ1PahTfVTVBhPOkK6Hs/TJU6TrP3N6LKa6e+LD+C7oi4IoG+FfYDDpy1laheeOVn5D82DqNSxyrww=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7lIecoqKm8YguCAKSpoimdSYS9+6p3bvXbTwWZBG4Fbc2KHbj
	IEAuzxTZGPjNoB/UuVOY8gD0HOPw5yYsCaa3lNMsTnTm2YVS+HkszNPr
X-Gm-Gg: ASbGncsqyYnzQ896oGiC1jNbCB7FkHIzmd4pOXWPx5t+07UGRKoqSefLXkv7DRihBfR
	5P5GOlxs3pg1RTg4+0pUe56eHIHJri/k7tmuskNGyj270Qnm3kOSScSwDA8D6y1FOYPdgTDtt+5
	+va+4u+cYdz79Gyw5+hz6P9+ut+R6hvvPV6KK9iaf6TpHI8vqKFeFSVCdbO76K3ECqeM9NAIBmL
	hVn0Ox+yVShFl3vAWLNzbcWNP1FVeY1KDvKHalwEuj3bkfKuMK8vS7YXVicrLh7oRVqMDsUVc/e
	BR2qPyWslEx32j8KDzEOxnPz/STbMDtsH6jf/7RtaESnAnF3ekqUy7eiYpZe2EfJ4Uw0Oa/4zSc
	W+jB+QYey+0j/4Gmm6ovQzmYwo0yhC84=
X-Google-Smtp-Source: AGHT+IFAq6oFD9LEGvdnmvej5FK2oM8kVMdZdRvJvsrdRhsTT6J4H0UaalYv6DCU5UcaeQImu+me1w==
X-Received: by 2002:a05:6000:4c8:b0:3b7:83c0:a9dc with SMTP id ffacd0b85a97d-3b783c0b070mr4778105f8f.48.1753771804972;
        Mon, 28 Jul 2025 23:50:04 -0700 (PDT)
Received: from localhost ([87.254.0.133])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4587054f27dsm182810505e9.11.2025.07.28.23.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 23:50:04 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: scsi_debug: make read-only arrays static const
Date: Tue, 29 Jul 2025 07:49:30 +0100
Message-ID: <20250729064930.1659007-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Don't populate the read-only arrays on the stack at run time, instead
make them static const. Also reduces overall size.

before:
   text	   data	    bss	    dec	    hex	filename
 367439	  89582	   5952	 462973	  7107d	drivers/scsi/scsi_debug.o

after:
   text	   data	    bss	    dec	    hex	filename
 365847	  90702	   5952	 462501	  70ea5	drivers/scsi/scsi_debug.o

(gcc 14.2.0, x86-64)

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/scsi_debug.c | 91 ++++++++++++++++++++++++---------------
 1 file changed, 57 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0847767d4d43..353cb60e1abe 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2674,8 +2674,10 @@ static int resp_rsup_tmfs(struct scsi_cmnd *scp,
 
 static int resp_err_recov_pg(unsigned char *p, int pcontrol, int target)
 {	/* Read-Write Error Recovery page for mode_sense */
-	unsigned char err_recov_pg[] = {0x1, 0xa, 0xc0, 11, 240, 0, 0, 0,
-					5, 0, 0xff, 0xff};
+	static const unsigned char err_recov_pg[] = {
+		0x1, 0xa, 0xc0, 11, 240, 0, 0, 0,
+		5, 0, 0xff, 0xff
+	};
 
 	memcpy(p, err_recov_pg, sizeof(err_recov_pg));
 	if (1 == pcontrol)
@@ -2685,8 +2687,10 @@ static int resp_err_recov_pg(unsigned char *p, int pcontrol, int target)
 
 static int resp_disconnect_pg(unsigned char *p, int pcontrol, int target)
 { 	/* Disconnect-Reconnect page for mode_sense */
-	unsigned char disconnect_pg[] = {0x2, 0xe, 128, 128, 0, 10, 0, 0,
-					 0, 0, 0, 0, 0, 0, 0, 0};
+	static const unsigned char disconnect_pg[] = {
+		0x2, 0xe, 128, 128, 0, 10, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0
+	};
 
 	memcpy(p, disconnect_pg, sizeof(disconnect_pg));
 	if (1 == pcontrol)
@@ -2696,9 +2700,11 @@ static int resp_disconnect_pg(unsigned char *p, int pcontrol, int target)
 
 static int resp_format_pg(unsigned char *p, int pcontrol, int target)
 {       /* Format device page for mode_sense */
-	unsigned char format_pg[] = {0x3, 0x16, 0, 0, 0, 0, 0, 0,
-				     0, 0, 0, 0, 0, 0, 0, 0,
-				     0, 0, 0, 0, 0x40, 0, 0, 0};
+	static const unsigned char format_pg[] = {
+		0x3, 0x16, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0x40, 0, 0, 0
+	};
 
 	memcpy(p, format_pg, sizeof(format_pg));
 	put_unaligned_be16(sdebug_sectors_per, p + 10);
@@ -2716,10 +2722,14 @@ static unsigned char caching_pg[] = {0x8, 18, 0x14, 0, 0xff, 0xff, 0, 0,
 
 static int resp_caching_pg(unsigned char *p, int pcontrol, int target)
 { 	/* Caching page for mode_sense */
-	unsigned char ch_caching_pg[] = {/* 0x8, 18, */ 0x4, 0, 0, 0, 0, 0,
-		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
-	unsigned char d_caching_pg[] = {0x8, 18, 0x14, 0, 0xff, 0xff, 0, 0,
-		0xff, 0xff, 0xff, 0xff, 0x80, 0x14, 0, 0,     0, 0, 0, 0};
+	static const unsigned char ch_caching_pg[] = {
+		/* 0x8, 18, */ 0x4, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+	};
+	static const unsigned char d_caching_pg[] = {
+		0x8, 18, 0x14, 0, 0xff, 0xff, 0, 0,
+		0xff, 0xff, 0xff, 0xff, 0x80, 0x14, 0, 0, 0, 0, 0, 0
+	};
 
 	if (SDEBUG_OPT_N_WCE & sdebug_opts)
 		caching_pg[2] &= ~0x4;	/* set WCE=0 (default WCE=1) */
@@ -2738,8 +2748,10 @@ static int resp_ctrl_m_pg(unsigned char *p, int pcontrol, int target)
 { 	/* Control mode page for mode_sense */
 	unsigned char ch_ctrl_m_pg[] = {/* 0xa, 10, */ 0x6, 0, 0, 0, 0, 0,
 					0, 0, 0, 0};
-	unsigned char d_ctrl_m_pg[] = {0xa, 10, 2, 0, 0, 0, 0, 0,
-				     0, 0, 0x2, 0x4b};
+	static const unsigned char d_ctrl_m_pg[] = {
+		0xa, 10, 2, 0, 0, 0, 0, 0,
+		0, 0, 0x2, 0x4b
+	};
 
 	if (sdebug_dsense)
 		ctrl_m_pg[2] |= 0x4;
@@ -2794,10 +2806,14 @@ static int resp_grouping_m_pg(unsigned char *p, int pcontrol, int target)
 
 static int resp_iec_m_pg(unsigned char *p, int pcontrol, int target)
 {	/* Informational Exceptions control mode page for mode_sense */
-	unsigned char ch_iec_m_pg[] = {/* 0x1c, 0xa, */ 0x4, 0xf, 0, 0, 0, 0,
-				       0, 0, 0x0, 0x0};
-	unsigned char d_iec_m_pg[] = {0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
-				      0, 0, 0x0, 0x0};
+	static const unsigned char ch_iec_m_pg[] = {
+		/* 0x1c, 0xa, */ 0x4, 0xf, 0, 0, 0, 0,
+		0, 0, 0x0, 0x0
+	};
+	static const unsigned char d_iec_m_pg[] = {
+		0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
+		0, 0, 0x0, 0x0
+	};
 
 	memcpy(p, iec_m_pg, sizeof(iec_m_pg));
 	if (1 == pcontrol)
@@ -2809,8 +2825,9 @@ static int resp_iec_m_pg(unsigned char *p, int pcontrol, int target)
 
 static int resp_sas_sf_m_pg(unsigned char *p, int pcontrol, int target)
 {	/* SAS SSP mode page - short format for mode_sense */
-	unsigned char sas_sf_m_pg[] = {0x19, 0x6,
-		0x6, 0x0, 0x7, 0xd0, 0x0, 0x0};
+	static const unsigned char sas_sf_m_pg[] = {
+		0x19, 0x6, 0x6, 0x0, 0x7, 0xd0, 0x0, 0x0
+	};
 
 	memcpy(p, sas_sf_m_pg, sizeof(sas_sf_m_pg));
 	if (1 == pcontrol)
@@ -2854,9 +2871,10 @@ static int resp_sas_pcd_m_spg(unsigned char *p, int pcontrol, int target,
 
 static int resp_sas_sha_m_spg(unsigned char *p, int pcontrol)
 {	/* SAS SSP shared protocol specific port mode subpage */
-	unsigned char sas_sha_m_pg[] = {0x59, 0x2, 0, 0xc, 0, 0x6, 0x10, 0,
-		    0, 0, 0, 0, 0, 0, 0, 0,
-		};
+	static const unsigned char sas_sha_m_pg[] = {
+		0x59, 0x2, 0, 0xc, 0, 0x6, 0x10, 0,
+		0, 0, 0, 0, 0, 0, 0, 0,
+	};
 
 	memcpy(p, sas_sha_m_pg, sizeof(sas_sha_m_pg));
 	if (1 == pcontrol)
@@ -2923,8 +2941,10 @@ static int process_medium_part_m_pg(struct sdebug_dev_info *devip,
 static int resp_compression_m_pg(unsigned char *p, int pcontrol, int target,
 	unsigned char dce)
 {	/* Compression page for mode_sense (tape) */
-	unsigned char compression_pg[] = {0x0f, 14, 0x40, 0, 0, 0, 0, 0,
-		0, 0, 0, 0, 00, 00};
+	static const unsigned char compression_pg[] = {
+		0x0f, 14, 0x40, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0
+	};
 
 	memcpy(p, compression_pg, sizeof(compression_pg));
 	if (dce)
@@ -3282,9 +3302,10 @@ static int resp_mode_select(struct scsi_cmnd *scp,
 
 static int resp_temp_l_pg(unsigned char *arr)
 {
-	unsigned char temp_l_pg[] = {0x0, 0x0, 0x3, 0x2, 0x0, 38,
-				     0x0, 0x1, 0x3, 0x2, 0x0, 65,
-		};
+	static const unsigned char temp_l_pg[] = {
+		0x0, 0x0, 0x3, 0x2, 0x0, 38,
+		0x0, 0x1, 0x3, 0x2, 0x0, 65,
+	};
 
 	memcpy(arr, temp_l_pg, sizeof(temp_l_pg));
 	return sizeof(temp_l_pg);
@@ -3292,8 +3313,9 @@ static int resp_temp_l_pg(unsigned char *arr)
 
 static int resp_ie_l_pg(unsigned char *arr)
 {
-	unsigned char ie_l_pg[] = {0x0, 0x0, 0x3, 0x3, 0x0, 0x0, 38,
-		};
+	static const unsigned char ie_l_pg[] = {
+		0x0, 0x0, 0x3, 0x3, 0x0, 0x0, 38,
+	};
 
 	memcpy(arr, ie_l_pg, sizeof(ie_l_pg));
 	if (iec_m_pg[2] & 0x4) {	/* TEST bit set */
@@ -3305,11 +3327,12 @@ static int resp_ie_l_pg(unsigned char *arr)
 
 static int resp_env_rep_l_spg(unsigned char *arr)
 {
-	unsigned char env_rep_l_spg[] = {0x0, 0x0, 0x23, 0x8,
-					 0x0, 40, 72, 0xff, 45, 18, 0, 0,
-					 0x1, 0x0, 0x23, 0x8,
-					 0x0, 55, 72, 35, 55, 45, 0, 0,
-		};
+	static const unsigned char env_rep_l_spg[] = {
+		0x0, 0x0, 0x23, 0x8,
+		0x0, 40, 72, 0xff, 45, 18, 0, 0,
+		0x1, 0x0, 0x23, 0x8,
+		0x0, 55, 72, 35, 55, 45, 0, 0,
+	};
 
 	memcpy(arr, env_rep_l_spg, sizeof(env_rep_l_spg));
 	return sizeof(env_rep_l_spg);
-- 
2.50.0

