Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF1A73F35
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 21:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638345; cv=none; b=TGWFR0uEYjxuD6qiK6cZ9Q9d+uthdMjLMgw4RO/Yif5+LL44CE+rHBAUQlc3rJ36aICci9dvo2KgrmtRJlmJ6bm2GC/EfaUtRC1gJnPNMP1a9FTmHk87uM5RwRHcGHpED175fhytr8DJPyDVsCw15rBJ1+00L1Hn9EnpKTUWQqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638345; c=relaxed/simple;
	bh=j5NL+pf5dNmehOHSM4AtREv1UpGo9QI/k7CIUEVDncY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMIm3hE5xknZ3ZdW2i+JSrcnx9vNBygStzXI5tf9HlJ4V5GHZLEarj6lXU/3epCBR5Aiz8G/tVU1ez92OF6oUe433r4rUeguwi6IGJVHOHcghRKgjXADB0xzSmNRL62JsOGmiiRKKd42lkvYjlJ3S343q3CG/qz1UeB5NMayRXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6da202aa138so79159b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 13:45:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708638344; x=1709243144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZzeF2/oOW/Kgo+XqzYjaeSGsfNBRPeMT9QOp9BrwRU=;
        b=hOzOfg8nBzQgtCq2Rhs0OpIv5nmG94V4nx5iWW0gn0fIjKGWRM29utL3Zky+1wTzF0
         UHj9QKE6ahTJ6WAubsMigr6SeDSPQZfRMEEBYYBxHGKVoqDxCkQqr6QUbwNfH2Wwwp7M
         3sPMl+iFGfQMaVg82ZjyeVnFvgk3GZuda7QYHeEc2nRrEL4MX9c5yqDUZTO2gvbTKgkt
         UugKvOMwlpJKxYZqa+BovimeeHfKcMuvK/vXsl83tqZhSAEK21z7A279YuQN/E+0/x4T
         Kwzy15FrWce5qxmwBjEMn+YHDO6yoCkNsoob37haw9eWPAYdroRI2dzhifzpIiNmfKrY
         3+MA==
X-Gm-Message-State: AOJu0YysJucu8qRLz/yY0rcZbfvxa5fYPT8keNE0BFEPBfzpbXGvH01w
	wdSvpT37p6TQPYzIFcg8qKQ1XUxmaqC46SlfsYz0KpvQg9bonvkJ
X-Google-Smtp-Source: AGHT+IFK6P2B3z0M9V1S0WcIzoAeQqs0kUEpWt+6biSFMJDcPa5+IDP6Zrc0ch/RC85fHjXdeq+VUg==
X-Received: by 2002:a05:6a00:4f88:b0:6e4:7453:7ed2 with SMTP id ld8-20020a056a004f8800b006e474537ed2mr239999pfb.3.1708638343616;
        Thu, 22 Feb 2024 13:45:43 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:bcee:4c5d:88b9:5644])
        by smtp.gmail.com with ESMTPSA id a1-20020aa78e81000000b006e414faff99sm9598203pfr.180.2024.02.22.13.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 13:45:43 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Daejun Park <daejun7.park@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	Douglas Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v10 04/11] scsi: scsi_debug: Reduce code duplication
Date: Thu, 22 Feb 2024 13:44:52 -0800
Message-ID: <20240222214508.1630719-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240222214508.1630719-1-bvanassche@acm.org>
References: <20240222214508.1630719-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All VPD pages have the page code in byte one. Reduce code duplication by
combining all page code assignment statements.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Tested-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d03d66f11493..994a2b829b94 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1903,7 +1903,8 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		u32 len;
 		char lu_id_str[6];
 		int host_no = devip->sdbg_host->shost->host_no;
-		
+
+		arr[1] = cmd[2];
 		port_group_id = (((host_no + 1) & 0x7f) << 8) +
 		    (devip->channel & 0x7f);
 		if (sdebug_vpd_use_hostno == 0)
@@ -1914,7 +1915,6 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 				 (devip->target * 1000) - 3;
 		len = scnprintf(lu_id_str, 6, "%d", lu_id_num);
 		if (0 == cmd[2]) { /* supported vital product data pages */
-			arr[1] = cmd[2];	/*sanity */
 			n = 4;
 			arr[n++] = 0x0;   /* this page */
 			arr[n++] = 0x80;  /* unit serial number */
@@ -1935,23 +1935,18 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			}
 			arr[3] = n - 4;	  /* number of supported VPD pages */
 		} else if (0x80 == cmd[2]) { /* unit serial number */
-			arr[1] = cmd[2];	/*sanity */
 			arr[3] = len;
 			memcpy(&arr[4], lu_id_str, len);
 		} else if (0x83 == cmd[2]) { /* device identification */
-			arr[1] = cmd[2];	/*sanity */
 			arr[3] = inquiry_vpd_83(&arr[4], port_group_id,
 						target_dev_id, lu_id_num,
 						lu_id_str, len,
 						&devip->lu_name);
 		} else if (0x84 == cmd[2]) { /* Software interface ident. */
-			arr[1] = cmd[2];	/*sanity */
 			arr[3] = inquiry_vpd_84(&arr[4]);
 		} else if (0x85 == cmd[2]) { /* Management network addresses */
-			arr[1] = cmd[2];	/*sanity */
 			arr[3] = inquiry_vpd_85(&arr[4]);
 		} else if (0x86 == cmd[2]) { /* extended inquiry */
-			arr[1] = cmd[2];	/*sanity */
 			arr[3] = 0x3c;	/* number of following entries */
 			if (sdebug_dif == T10_PI_TYPE3_PROTECTION)
 				arr[4] = 0x4;	/* SPT: GRD_CHK:1 */
@@ -1961,30 +1956,23 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 				arr[4] = 0x0;   /* no protection stuff */
 			arr[5] = 0x7;   /* head of q, ordered + simple q's */
 		} else if (0x87 == cmd[2]) { /* mode page policy */
-			arr[1] = cmd[2];	/*sanity */
 			arr[3] = 0x8;	/* number of following entries */
 			arr[4] = 0x2;	/* disconnect-reconnect mp */
 			arr[6] = 0x80;	/* mlus, shared */
 			arr[8] = 0x18;	 /* protocol specific lu */
 			arr[10] = 0x82;	 /* mlus, per initiator port */
 		} else if (0x88 == cmd[2]) { /* SCSI Ports */
-			arr[1] = cmd[2];	/*sanity */
 			arr[3] = inquiry_vpd_88(&arr[4], target_dev_id);
 		} else if (is_disk_zbc && 0x89 == cmd[2]) { /* ATA info */
-			arr[1] = cmd[2];        /*sanity */
 			n = inquiry_vpd_89(&arr[4]);
 			put_unaligned_be16(n, arr + 2);
 		} else if (is_disk_zbc && 0xb0 == cmd[2]) { /* Block limits */
-			arr[1] = cmd[2];        /*sanity */
 			arr[3] = inquiry_vpd_b0(&arr[4]);
 		} else if (is_disk_zbc && 0xb1 == cmd[2]) { /* Block char. */
-			arr[1] = cmd[2];        /*sanity */
 			arr[3] = inquiry_vpd_b1(devip, &arr[4]);
 		} else if (is_disk && 0xb2 == cmd[2]) { /* LB Prov. */
-			arr[1] = cmd[2];        /*sanity */
 			arr[3] = inquiry_vpd_b2(&arr[4]);
 		} else if (is_zbc && cmd[2] == 0xb6) { /* ZB dev. charact. */
-			arr[1] = cmd[2];        /*sanity */
 			arr[3] = inquiry_vpd_b6(devip, &arr[4]);
 		} else {
 			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
