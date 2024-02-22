Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A2E12D1E4
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 21:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638351; cv=none; b=DLPbGjA+CQYkv+T82i1ouia4Z5WC0K5+ZtOjd0lE5MTZbOkpIZ7UNhm1nlHkKnwIXMRT1WbvLXJOQQjlb/fqq7yH2hrr4na+izajj1SMqwvf1DRy0sswdiBCz3rkNA7GvbmTiIpeArOhwyUWCNK5kSVxgArMs20n/xvfahwQIW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638351; c=relaxed/simple;
	bh=Zf0R25Rg1mXeSROfgZKxHfIZKaY0FWVp6rdNT8OKDps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdbzXY8YZ15Wxu6FncNt4yU3el9lmOMgxG7V1kFlV8do+denFFrVQQHfNQVJHrtaQv1F3yoNK6V177aDtB64swRey6Gvab5tdTLfUdjzQHREOd12lMUxlbSYX8G8nEgvAbOVdGBxMTVGPqjAH6rqJ4XBWgPwi9VR/RmJOCxu/q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e43ee3f6fbso98653b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 13:45:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708638349; x=1709243149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N+HWSlaiIpcKUI/XYMTeimlVB+yEtY/A7WgNkX4Hy3o=;
        b=sL9kIB67oTo3NZy8K6/YtVHl7Yeqp2IlQR5e4ZKCvntHxtdKjX4jrloxhKI/CkBAD1
         sIISu8QCLwbEhZkAprKZYP4kCtt1UMiOw5x+yC04cYtTQe5Rr4GKYMmLzbFXgmn/Wh9u
         WsdZ3VfMPEal6rTycMH1WYbWrIPgtGSuE1Hoy+0EwQ1HgI1k8RXCU2W4RIuBh89Ultph
         7eOV25KQeO+TeHbxjAiniR4OPLHKUYQhl9KqNOJQtnDC/ozfDMRyRsJZ1xc1NEfrCk31
         mS+SQnwwy6koJFk3rKXJu8BnDnGoyZUbebaxBG3JJwzt4mC+e+o1QduxSPbw72HwZde+
         nqhw==
X-Gm-Message-State: AOJu0YzPoeoPOkTeU90qxmEETmr8ZwVBSmavztslcDeOEcbGuFtv0gVD
	W+Q/eLsaV2vzkg/rb75WAlQEnXHtUeVP2uzVuvawvQ+MLLC3KPfD
X-Google-Smtp-Source: AGHT+IHrQK7kHqtSXfeUUzC4n4a0HuhPySvbJ2sXDBnfLN1hThsLzlWob5cwYVWYyOt4W/EUTgTkGA==
X-Received: by 2002:a05:6a00:939f:b0:6e4:c4c3:d4c6 with SMTP id ka31-20020a056a00939f00b006e4c4c3d4c6mr168865pfb.4.1708638349079;
        Thu, 22 Feb 2024 13:45:49 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:bcee:4c5d:88b9:5644])
        by smtp.gmail.com with ESMTPSA id a1-20020aa78e81000000b006e414faff99sm9598203pfr.180.2024.02.22.13.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 13:45:48 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Daejun Park <daejun7.park@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v10 09/11] scsi: scsi_debug: Implement the IO Advice Hints Grouping mode page
Date: Thu, 22 Feb 2024 13:44:57 -0800
Message-ID: <20240222214508.1630719-10-bvanassche@acm.org>
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

Implement an IO Advice Hints Grouping mode page with three permanent
streams. A permanent stream is a stream for which the device server does
not allow closing or otherwise modifying the configuration of that
stream. The stream identifier enable (ST_ENBLE) bit specifies whether
the stream identifier may be used in the GROUP NUMBER field of SCSI
WRITE commands.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Tested-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 61 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b544498324f6..ccf59b3e7602 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1969,7 +1969,11 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 				arr[4] = 0x5;   /* SPT: GRD_CHK:1, REF_CHK:1 */
 			else
 				arr[4] = 0x0;   /* no protection stuff */
-			arr[5] = 0x7;   /* head of q, ordered + simple q's */
+			/*
+			 * GROUP_SUP=1; HEADSUP=1 (HEAD OF QUEUE); ORDSUP=1
+			 * (ORDERED queuing); SIMPSUP=1 (SIMPLE queuing).
+			 */
+			arr[5] = 0x17;
 		} else if (0x87 == cmd[2]) { /* mode page policy */
 			arr[3] = 0x8;	/* number of following entries */
 			arr[4] = 0x2;	/* disconnect-reconnect mp */
@@ -2559,6 +2563,40 @@ static int resp_ctrl_m_pg(unsigned char *p, int pcontrol, int target)
 	return sizeof(ctrl_m_pg);
 }
 
+/* IO Advice Hints Grouping mode page */
+static int resp_grouping_m_pg(unsigned char *p, int pcontrol, int target)
+{
+	/* IO Advice Hints Grouping mode page */
+	struct grouping_m_pg {
+		u8 page_code;	/* OR 0x40 when subpage_code > 0 */
+		u8 subpage_code;
+		__be16 page_length;
+		u8 reserved[12];
+		struct scsi_io_group_descriptor descr[MAXIMUM_NUMBER_OF_STREAMS];
+	};
+	static const struct grouping_m_pg gr_m_pg = {
+		.page_code = 0xa | 0x40,
+		.subpage_code = 5,
+		.page_length = cpu_to_be16(sizeof(gr_m_pg) - 4),
+		.descr = {
+			{ .st_enble = 1 },
+			{ .st_enble = 1 },
+			{ .st_enble = 1 },
+			{ .st_enble = 1 },
+			{ .st_enble = 1 },
+			{ .st_enble = 0 },
+		}
+	};
+
+	BUILD_BUG_ON(sizeof(struct grouping_m_pg) !=
+		     16 + MAXIMUM_NUMBER_OF_STREAMS * 16);
+	memcpy(p, &gr_m_pg, sizeof(gr_m_pg));
+	if (1 == pcontrol) {
+		/* There are no changeable values so clear from byte 4 on. */
+		memset(p + 4, 0, sizeof(gr_m_pg) - 4);
+	}
+	return sizeof(gr_m_pg);
+}
 
 static int resp_iec_m_pg(unsigned char *p, int pcontrol, int target)
 {	/* Informational Exceptions control mode page for mode_sense */
@@ -2708,6 +2746,10 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		ap = arr + offset;
 	}
 
+	/*
+	 * N.B. If len>0 before resp_*_pg() call, then form of that call should be:
+	 *        len += resp_*_pg(ap + len, pcontrol, target);
+	 */
 	switch (pcode) {
 	case 0x1:	/* Read-Write error recovery page, direct access */
 		if (subpcode > 0x0 && subpcode < 0xff)
@@ -2742,9 +2784,20 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		}
 		break;
 	case 0xa:	/* Control Mode page, all devices */
-		if (subpcode > 0x0 && subpcode < 0xff)
+		switch (subpcode) {
+		case 0:
+			len = resp_ctrl_m_pg(ap, pcontrol, target);
+			break;
+		case 0x05:
+			len = resp_grouping_m_pg(ap, pcontrol, target);
+			break;
+		case 0xff:
+			len = resp_ctrl_m_pg(ap, pcontrol, target);
+			len += resp_grouping_m_pg(ap + len, pcontrol, target);
+			break;
+		default:
 			goto bad_subpcode;
-		len = resp_ctrl_m_pg(ap, pcontrol, target);
+		}
 		offset += len;
 		break;
 	case 0x19:	/* if spc==1 then sas phy, control+discover */
@@ -2778,6 +2831,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 			len += resp_caching_pg(ap + len, pcontrol, target);
 		}
 		len += resp_ctrl_m_pg(ap + len, pcontrol, target);
+		if (0xff == subpcode)
+			len += resp_grouping_m_pg(ap + len, pcontrol, target);
 		len += resp_sas_sf_m_pg(ap + len, pcontrol, target);
 		if (0xff == subpcode) {
 			len += resp_sas_pcd_m_spg(ap + len, pcontrol, target,
