Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626BF12D1E4
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 21:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638346; cv=none; b=mbLOTqYC19aiQhVUEpbmKcn+5PbiMQu1oujQ0LA+TJ0gm0TN3d+h8u2hQCdfQRgW+RcfNkbcK2XWCfw+U5/RE4wLbX4yxJZwwQgn3G/wVBt3mjHCXh4Izo+ZNWKhw4gPpGhGH6cJyx+xH3pJ726JBB5zkBOWSFoGIWPPwkq+zuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638346; c=relaxed/simple;
	bh=9j1OIZejLefmmKyhnYsUFGpVmUAOqH5O/Vj6lACD6GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O24AAQhxkU4oq6Iaiqd8D5iZN/Zxr++b3gy/d+ePG0LBHBf59Na8BwOMy+RULpxGrkJfN5zz0t2aAQZBnFMk6ES+0/hIZVjKEmPnurZ/J3stsPrQjxJgcTY6pMbNhX7ogXvJraYLXCTQ7ukWFXBnZB9LiNT+5QuG2semmjzsBoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6da4a923b1bso125112b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 13:45:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708638345; x=1709243145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X5N8iE07qnVQFaiEZk1v63nlXY8tM38tqiHwS7uEhgk=;
        b=FC6kuQaquLwXJEVtRASt7LoVYAEaq7rzQcBxQXLYCDFW74jshsB0/W9iI2SvKasdvw
         cf1G6Rf5ckGc5bzltcUYEd6Nokdf1d4xNrefO1GAhadj+JK8ECTHOhs0+tMblJQWxoLQ
         uyGO+N6pKem+Du0Cw4xmg85pfSNXBD2XVoP8K4fOoON5GfPH5xeeJKelsVKS02a6tuoF
         zGS9mGvDYf7mDjjZhclOHeuux1Su/n9E1I5CQ77N0LruV6skaOgepxBL3hU5r1n3hVoO
         ZFehsNdvgzGqRUe8NwZpabgU5kR7lLO7gl1OTl5BJ8n8LOC/Z+NmqjA15CXkLqznSc5V
         L3ug==
X-Gm-Message-State: AOJu0YzBENEHcyHQ/tBsfVay1VwMB2LOB+CVQziV9IKDoLQ9xq0hrmTw
	4OPkge3ipdB+nYWKg4xw8FyGBfnKOjG4PyQBwfE2965mQ+cqUp5V
X-Google-Smtp-Source: AGHT+IH6ZpnmGu/uTH7En5b5g3IhRVy3ZriZhfnUen+nJpCf3RofEQziOzRStjzj/xAYy2sUZNV2sg==
X-Received: by 2002:a62:6504:0:b0:6e4:3a32:49e1 with SMTP id z4-20020a626504000000b006e43a3249e1mr134249pfb.11.1708638344717;
        Thu, 22 Feb 2024 13:45:44 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:bcee:4c5d:88b9:5644])
        by smtp.gmail.com with ESMTPSA id a1-20020aa78e81000000b006e414faff99sm9598203pfr.180.2024.02.22.13.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 13:45:44 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Daejun Park <daejun7.park@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v10 05/11] scsi: scsi_debug: Support the block limits extension VPD page
Date: Thu, 22 Feb 2024 13:44:53 -0800
Message-ID: <20240222214508.1630719-6-bvanassche@acm.org>
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

From SBC-5 r05:

"Reduced stream control:
a) reduces the maximum number of streams that the device server supports;
   and
b) increases the number of write commands that are able to specify a stream
   to be written in any write command that contains the GROUP NUMBER field
   in its CDB.

If the RSCS bit (see 6.6.5) is set to one, then the device server shall:
a) support per group stream identifier usage as described in 4.32.2;
b) support the IO Advice Hints Grouping mode page (see 6.5.7); and
c) set the MAXIMUM NUMBER OF STREAMS field (see 6.6.5) to a value that is
   less than 64.

Device servers that set the RSCS bit to one may support other features
(e.g., permanent streams (see 4.32.4)).

4.32.4 Permanent streams

A permanent stream is a stream for which the device server does not allow
closing or otherwise modifying the configuration of that stream. The PERM
bit (see 5.9.2.3) indicates whether a stream is a permanent stream. If a
STREAM CONTROL command (see 5.32) specifies the closing of a permanent
stream, the device server terminates that command with CHECK CONDITION
status instead of closing the specified stream. A permanent stream is always
an open stream. Device severs should assign the lowest numbered stream
identifiers to permanent streams."

Report that reduced stream control is supported.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Tested-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 994a2b829b94..8dba838ef983 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1867,6 +1867,19 @@ static int inquiry_vpd_b6(struct sdebug_dev_info *devip, unsigned char *arr)
 	return 0x3c;
 }
 
+#define SDEBUG_BLE_LEN_AFTER_B4 28	/* thus vpage 32 bytes long */
+
+enum { MAXIMUM_NUMBER_OF_STREAMS = 6, PERMANENT_STREAM_COUNT = 5 };
+
+/* Block limits extension VPD page (SBC-4) */
+static int inquiry_vpd_b7(unsigned char *arrb4)
+{
+	memset(arrb4, 0, SDEBUG_BLE_LEN_AFTER_B4);
+	arrb4[1] = 1; /* Reduced stream control support (RSCS) */
+	put_unaligned_be16(MAXIMUM_NUMBER_OF_STREAMS, &arrb4[2]);
+	return SDEBUG_BLE_LEN_AFTER_B4;
+}
+
 #define SDEBUG_LONG_INQ_SZ 96
 #define SDEBUG_MAX_INQ_ARR_SZ 584
 
@@ -1932,6 +1945,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 					arr[n++] = 0xb2;  /* LB Provisioning */
 				if (is_zbc)
 					arr[n++] = 0xb6;  /* ZB dev. char. */
+				arr[n++] = 0xb7;  /* Block limits extension */
 			}
 			arr[3] = n - 4;	  /* number of supported VPD pages */
 		} else if (0x80 == cmd[2]) { /* unit serial number */
@@ -1974,6 +1988,8 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			arr[3] = inquiry_vpd_b2(&arr[4]);
 		} else if (is_zbc && cmd[2] == 0xb6) { /* ZB dev. charact. */
 			arr[3] = inquiry_vpd_b6(devip, &arr[4]);
+		} else if (cmd[2] == 0xb7) { /* block limits extension page */
+			arr[3] = inquiry_vpd_b7(&arr[4]);
 		} else {
 			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
 			kfree(arr);
