Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78F5846D
	for <linux-scsi@vger.kernel.org>; Tue,  3 Sep 2024 13:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725371951; cv=none; b=ukbyQe7J8tAaVvMDjBUU9aBn2hkK5cI6vNPJvRyFymK9HiWNVjkzmORyPAU5U+pilHci+vilqkFC8MPxFLMZ8nKCryOVmzqXD6H8/3Mn8Xl4to37/cUvSgLfgAax2MqVlGpVZE461ACZU4f7bvk0+q7f0egPuVOOgI6UolbfHpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725371951; c=relaxed/simple;
	bh=2p59Io14Tx6Jv5Z+uTWRhGzxXeHD3dt3DFGNdbpHvhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlHNfnvhqmkPMWa4fm7iW4F4sCQA5DvivBKwRBIjeMBDKQJ0nmwTc/a2cdUb0ihs8KpZgF/Cc9+0NMjXub+xZ/mjL1Fyv/4m+eVnfHR6qk4Qpobd85zJh80moK82qgCh/keU//GDNQUDTK2D4ntke/pOnu5TlZGI7yWqTGyWn0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x0f.com; spf=pass smtp.mailfrom=0x0f.com; dkim=pass (1024-bit key) header.d=0x0f.com header.i=@0x0f.com header.b=JMqZLRf6; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x0f.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0x0f.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0x0f.com header.i=@0x0f.com header.b="JMqZLRf6"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2059112f0a7so14624435ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 03 Sep 2024 06:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google; t=1725371949; x=1725976749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UGDCAIae5kRwEgTwP4mEBr6L2E7fTYcFokMRKodxlJQ=;
        b=JMqZLRf6CtTLFKK68CnUA6S46oCW0HqiEtLH8oQLOkj4y3i08ICNXoxNrXNrGljYhk
         pARxP6ehO4KXy/Zbh5QYtMaZvG6DPjdi7EAExPz/PBRQpu+ulbjx9M7aaj2jO51Q2Y0n
         wXMKaFhXAYcJjn9YgLxVj16SFKjCm/B3At5MU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725371949; x=1725976749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UGDCAIae5kRwEgTwP4mEBr6L2E7fTYcFokMRKodxlJQ=;
        b=d6q73G9j4lY9zbMSd94efX7j4WeOW3KOYMDl1O1rBOI5ZOtzhHUu2wXVshFoXIsieb
         16UYnn9V4l0QDaPfDQ1UeO197aE6/IBRy3INt8NRtBXA1xWfyN6u0SpNtAjphlS/kgPB
         vzCbyb4HBAL3JdlQvxsIl0Y4WEapprUqnx4XvUeGl68YoU/ZF7uragQhv4IWBn9iMAg+
         nZUv3IWXa5gp6El0h8WMf3UaaCV+rks1d6gbf+oOHY6o1cv3gItH6/KovJBRH9wq8KyU
         72W6YI6wzD9r6ROFYhP8BD5N+PLIln+Wu41ycI7vXB1yVOOkE2yt3V/BWYXjCITRoPdn
         +qjg==
X-Forwarded-Encrypted: i=1; AJvYcCVtn1uGF9lvKEGpSB0GufuPWok7pejLs0aWISPbGfSVCumGOhDkD2I3nZE5L/2dsA6y2LkpPbjDUv7s@vger.kernel.org
X-Gm-Message-State: AOJu0YyFAPXKFxAdOU/5Q2CoNPv6QwXeVPMakIKC+isuAE19uVB4XMRU
	6NMf3MmBTwza26p7Klzwl963rDniBV/N9jActKOJVkNzzOrPikHItoBIuezGwMc=
X-Google-Smtp-Source: AGHT+IEWpsD6HI7caSArtIN54zToreNlZkIRIyHGpC3jul4Och+Ow+zGZAbP2qHt0qBXDIp10quhBg==
X-Received: by 2002:a17:903:22c7:b0:205:866d:174f with SMTP id d9443c01a7336-205866d1a85mr45493385ad.44.1725371949200;
        Tue, 03 Sep 2024 06:59:09 -0700 (PDT)
Received: from shiro.work.home.arpa (p1980092-ipxg00g01sizuokaden.shizuoka.ocn.ne.jp. [153.201.32.92])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-20535e8aa0fsm62688305ad.286.2024.09.03.06.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 06:59:08 -0700 (PDT)
From: Daniel Palmer <daniel@0x0f.com>
To: linux-m68k@lists.linux-m68k.org,
	linux-scsi@vger.kernel.org,
	geert@linux-m68k.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org,
	Daniel Palmer <daniel@0x0f.com>
Subject: [PATCH 2/2] scsi: wd33c93: Avoid deferencing null pointer in interrupt handler
Date: Tue,  3 Sep 2024 22:58:57 +0900
Message-ID: <20240903135857.455818-2-daniel@0x0f.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240903135857.455818-1-daniel@0x0f.com>
References: <20240903135857.455818-1-daniel@0x0f.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I have no idea if this fix is appropriate, the code in this driver
makes my brain hurt just looking at it, but sometimes when getting
scsi_pointer from cmd cmd itself is actually null and we get a weird
garbage pointer for scsi_pointer.

When this is accessed later on bad things happen. For my machine
this happens when the SCSI bus is initially scanned.

With this "fix" SCSI on my MVME147 is happy again.

[   84.330000] wd33c93-0: chip=WD33c93B/13 no_sync=0xff no_dma=0
[   84.330000]  debug_flags=0x00
[   84.350000]            setup_args=
<snip>
[   84.490000]
[   84.510000]            Version 1.26++ - 10/Feb/2007
[   84.520000] scsi host0: MVME147 built-in SCSI
[   85.480000]  sending SDTR 0103015e00
[   85.480000] 01
[   85.490000] 03
[   85.500000] 01
[   85.510000] 00
[   85.520000] 00
[   85.520000]  sync_xfer=30
[   85.530000] scsi 0:0:5:0: Direct-Access     BlueSCSI HARDDRIVE        2.0  PQ: 0 ANSI: 2
[   85.820000] st: Version 20160209, fixed bufsize 32768, s/g segs 256
[   85.900000] sd 0:0:5:0: Attached scsi generic sg0 type 0

Signed-off-by: Daniel Palmer <daniel@0x0f.com>
---
 drivers/scsi/wd33c93.c | 10 +++++++---
 drivers/scsi/wd33c93.h |  2 ++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index a44b60c9004a..9789d852d541 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -733,7 +733,7 @@ transfer_bytes(const wd33c93_regs regs, struct scsi_cmnd *cmd,
 void
 wd33c93_intr(struct Scsi_Host *instance)
 {
-	struct scsi_pointer *scsi_pointer;
+	struct scsi_pointer *scsi_pointer = NULL;
 	struct WD33C93_hostdata *hostdata =
 	    (struct WD33C93_hostdata *) instance->hostdata;
 	const wd33c93_regs regs = hostdata->regs;
@@ -752,7 +752,9 @@ wd33c93_intr(struct Scsi_Host *instance)
 #endif
 
 	cmd = (struct scsi_cmnd *) hostdata->connected;	/* assume we're connected */
-	scsi_pointer = WD33C93_scsi_pointer(cmd);
+	/* cmd could be null */
+	if (cmd)
+		scsi_pointer = WD33C93_scsi_pointer(cmd);
 	sr = read_wd33c93(regs, WD_SCSI_STATUS);	/* clear the interrupt */
 	phs = read_wd33c93(regs, WD_COMMAND_PHASE);
 
@@ -828,8 +830,10 @@ wd33c93_intr(struct Scsi_Host *instance)
 		    (struct scsi_cmnd *) hostdata->selecting;
 		hostdata->selecting = NULL;
 
-		/* construct an IDENTIFY message with correct disconnect bit */
+		/* cmd should now be valid and we can get scsi_pointer */
+		scsi_pointer = WD33C93_scsi_pointer(cmd);
 
+		/* construct an IDENTIFY message with correct disconnect bit */
 		hostdata->outgoing_msg[0] = IDENTIFY(0, cmd->device->lun);
 		if (scsi_pointer->phase)
 			hostdata->outgoing_msg[0] |= 0x40;
diff --git a/drivers/scsi/wd33c93.h b/drivers/scsi/wd33c93.h
index e5e4254b1477..898c1c7d024d 100644
--- a/drivers/scsi/wd33c93.h
+++ b/drivers/scsi/wd33c93.h
@@ -259,6 +259,8 @@ struct WD33C93_hostdata {
 
 static inline struct scsi_pointer *WD33C93_scsi_pointer(struct scsi_cmnd *cmd)
 {
+	WARN_ON_ONCE(!cmd);
+
 	return scsi_cmd_priv(cmd);
 }
 
-- 
2.43.0

