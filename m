Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D8F73F35
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 21:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638348; cv=none; b=AVq28KhKPQ+5keieH/Ni3hnfOaio6JgS4Ls0+JulS3hUFqQ1l3Aiq33cCPrWBDfyS2uJu5Lpzxnb6uztfWDqndljEfSP+i2swH0nEg5K3rBfBpx6Vk2kDVe6ynCS2sIg7uG834hDwrR6bnb6cR0vOfzNrpDq1xIjF03KpdGUVeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638348; c=relaxed/simple;
	bh=ReoAgyArusvAYBEY1Dxq9pKXMLzy1yk/3CyhJgGq2xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u456ASRHXhBglXiIejaQkzzh0BacoeeYZTj/D2y8dC7zLezdzIGmak9inZ91APyf0HcecQZfTo+QqSvi0trpRJ4FPqxADjwofggtcXBb3n3VzIOf2lSnZXPtOAmHgdUGu+El0AslsDuwRQBilhViljV+l2A3CaOAzigMRdas/ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e46dcd8feaso64447b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 13:45:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708638346; x=1709243146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2qSkiYLEpndgk91NEKVImgnQ0iTk/12SnGdfVXY3CVY=;
        b=nJ0NybmT3/d6+faDBqR0/DCX9BEOZFg6Mao9cR87HE2+5XGNH6BB1YMZ0oYJn+et2F
         wjMUyr8bUjJ0Fc72R5IDK6idqIT82je0+EpnN40UXATLH6Hx5H7glIMEYT3UELlQPJjS
         Ig04yLvFHheb8tJo3DTpzAkofIrAJEXBxett85u1AkJ8651iBIh+1IlmIO1EtqcZzkor
         7NcN/hg+QNh9ah93AueNBOpu8Kj3VUQRtYTcBX1RAwSlcW3pOyUoxibayDiuvSh0/laQ
         loiexe1FXYsvmLim3Bv4N6v65aOCbbGyb+Y0g7SlpMbhX78erdQiaiKH217Z9pPt11l6
         L8pw==
X-Gm-Message-State: AOJu0YxL1XbG8ZACk+bc8qgmTdEkoev9hsPt5p9NBpAwe28Uo+HRpCM4
	gMFhNkfRdj/Ra7eBL2s1ca8dNV/yh7Ii686HGAJnN2B637x5i8OByvKWydwo
X-Google-Smtp-Source: AGHT+IFW+F91cwA1RPrd8SZWeO410QMkdR8a/Wlg07cuJeoSjMstUsDvQF4Uy2JW+4nE00lMc3Rbww==
X-Received: by 2002:aa7:8449:0:b0:6e4:5a0f:b87a with SMTP id r9-20020aa78449000000b006e45a0fb87amr178445pfn.12.1708638345752;
        Thu, 22 Feb 2024 13:45:45 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:bcee:4c5d:88b9:5644])
        by smtp.gmail.com with ESMTPSA id a1-20020aa78e81000000b006e414faff99sm9598203pfr.180.2024.02.22.13.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 13:45:45 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Daejun Park <daejun7.park@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v10 06/11] scsi: scsi_debug: Rework page code error handling
Date: Thu, 22 Feb 2024 13:44:54 -0800
Message-ID: <20240222214508.1630719-7-bvanassche@acm.org>
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
