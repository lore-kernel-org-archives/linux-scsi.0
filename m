Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE7778671;
	Tue, 30 Jan 2024 21:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706651400; cv=none; b=oUGn5ThINWzKknzRgSje9oRd32xWVSbl7KX7RdednUXofEtYeyApLTrYNleFgWAjvI/VdLoKZsPJ3QoaZkmPtXNasFo+YGSHuer5RK9pxR1gO4nvISmipzfEtlmTE+rSSjKr8VkRrK7zpiogzoudG3Ifh9uYYfLTu8JQKBGSS6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706651400; c=relaxed/simple;
	bh=ReoAgyArusvAYBEY1Dxq9pKXMLzy1yk/3CyhJgGq2xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoWqD3d8K9hT7HEz9fACqek1BvF9avk839XLlXjScE31RYyhIAgbWr4xqMOuyzVXH5WdX8V2RpxRtJ+167w+1wpp2IH/NAroF1sRrN/1CTt00W8zm/DoKrkJkmHuejneJiDM5i7vV1g1x9hN23rJ7VUPmmo/KPcYQ23hEs4kLdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6de0ba30994so186607b3a.1;
        Tue, 30 Jan 2024 13:49:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706651398; x=1707256198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2qSkiYLEpndgk91NEKVImgnQ0iTk/12SnGdfVXY3CVY=;
        b=GOdZDrgycvrOafF54VIkAobKUd9F7Zgx2srP4nYLOomFTpwFJkllD4ZZ4/DCjBni9b
         doovKo/soBJa910s5s+z07Wdcl8jzJLArFf3Sr+eqr7Ey6UjAMfFJS4Mpteu4vr6Pvwb
         YRuv9rg/VI2xN2/RMmCGxBFWLWQn45YtDjgTCvK96oEU+Z+yrrdZO1qgaD2FR2DhJ4wO
         4M9VH3Vg6dscI4d7MmFPlOmsk6EpylNvGHuLp1UCPH7sqA57XExVSF9lu5XAhbo9atRK
         JFEl/6ILEJvRIS7+dbcGLBZwCnDWnB4f31232x6huBFCcjVhKQZSeXb11Yh0OXoiEA7v
         w5/A==
X-Gm-Message-State: AOJu0YwrAcOET7dST7WuyMgaaajN43Ttdd/xyA5jRi/qGgnnYu0uEUcJ
	EFQzMtHj2Tp5S7W20VbhWfgU2tYSEf6LgtoWQPeOI1Pn73oNtO+X
X-Google-Smtp-Source: AGHT+IHgH41lIf+K9v0jjF+4UajBXpzgWhN3dMHv2rFxF7TEQ8FTFb+wqWSVmwWTswZNWbnsMfTJ9w==
X-Received: by 2002:a05:6a00:b52:b0:6da:ca92:3e2e with SMTP id p18-20020a056a000b5200b006daca923e2emr2672584pfo.7.1706651398204;
        Tue, 30 Jan 2024 13:49:58 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:f45c:fd18:bfa0:e084])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7998e000000b006db87354a8fsm8285597pfh.119.2024.01.30.13.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 13:49:57 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Daejun Park <daejun7.park@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v9 14/19] scsi: scsi_debug: Rework page code error handling
Date: Tue, 30 Jan 2024 13:48:40 -0800
Message-ID: <20240130214911.1863909-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
In-Reply-To: <20240130214911.1863909-1-bvanassche@acm.org>
References: <20240130214911.1863909-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of tracking whether or not the page code is valid in a boolean
variable, jump to error handling code if an unsupported page code is
encountered.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Tested-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8dba838ef983..ba0a29e6a86d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2644,7 +2644,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	unsigned char *ap;
 	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
 	unsigned char *cmd = scp->cmnd;
-	bool dbd, llbaa, msense_6, is_disk, is_zbc, bad_pcode;
+	bool dbd, llbaa, msense_6, is_disk, is_zbc;
 
 	dbd = !!(cmd[1] & 0x8);		/* disable block descriptors */
 	pcontrol = (cmd[2] & 0xc0) >> 6;
@@ -2708,7 +2708,6 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
 		return check_condition_result;
 	}
-	bad_pcode = false;
 
 	switch (pcode) {
 	case 0x1:	/* Read-Write error recovery page, direct access */
@@ -2723,15 +2722,17 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		if (is_disk) {
 			len = resp_format_pg(ap, pcontrol, target);
 			offset += len;
-		} else
-			bad_pcode = true;
+		} else {
+			goto bad_pcode;
+		}
 		break;
 	case 0x8:	/* Caching page, direct access */
 		if (is_disk || is_zbc) {
 			len = resp_caching_pg(ap, pcontrol, target);
 			offset += len;
-		} else
-			bad_pcode = true;
+		} else {
+			goto bad_pcode;
+		}
 		break;
 	case 0xa:	/* Control Mode page, all devices */
 		len = resp_ctrl_m_pg(ap, pcontrol, target);
@@ -2784,18 +2785,17 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		}
 		break;
 	default:
-		bad_pcode = true;
-		break;
-	}
-	if (bad_pcode) {
-		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 5);
-		return check_condition_result;
+		goto bad_pcode;
 	}
 	if (msense_6)
 		arr[0] = offset - 1;
 	else
 		put_unaligned_be16((offset - 2), arr + 0);
 	return fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, offset));
+
+bad_pcode:
+	mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 5);
+	return check_condition_result;
 }
 
 #define SDEBUG_MAX_MSELECT_SZ 512
