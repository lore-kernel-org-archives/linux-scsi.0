Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304EE2575A
	for <linux-scsi@vger.kernel.org>; Wed,  8 May 2024 10:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715163878; cv=none; b=OPLit/pZJAtxwbAVS8Bh/IEoV1rfaSJyGvvEGP0Y9nENpt2rGkKHNk5DPnRsFz4pQl2WY9be/MXd+UKRzVIIiboxqNUHaoHJN3drvtGVDcrfyYXvhtSjJxDMO2seNHUqRd7BtPf+E/RIQdCShnGeP795tUbrcxMb22iO0Kd8+u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715163878; c=relaxed/simple;
	bh=xNKGMO7Twb+6rWQOZixoTzouoiYAYQcIQHLOzzxc/8s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tz2oZrjkM5QP7/BLL0n0tC+z4Mjztny+xwCHFCVHd09JSJgiq/v2NSPEIvFziXcaC3/YwGosKkCByVMiaDYjJhPRUQLE8cH/Wabt9XQeozL+Fe6IliPN1HBvEApddufUHAQ88IceYSA0VXo59gQfUlfK/A9t3L5/MjZRkMYZXjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SJdtvPYy; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SJdtvPYy"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-41ba1ba55ffso3802625e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 May 2024 03:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1715163873; x=1715768673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NYxMu/l98xm+aQJfXUGf4HS+yG3SKnaoCLIW2aC5HtE=;
        b=SJdtvPYyisLOQb1n9Lsx72AHc3Yr6pntIyx5/wJDMx/2zym+AJzbBREJC24wVeE8kc
         hIlQWzSiL6jORMyxqj8EO2DVpV36k8Dbb4WgVBazJfg4aEx+pz641AIB4l78pMqxBTDR
         RZpd+IBjP7v3AgoV959n7n2uab8hmW52utrPQSx3dok9dK95tBukJe5f0WL6YVLlZB24
         hjYVpKWB+FRufL3QukW7Cahswus8/4Rp8crubouV7tFoLaL819dzQ9V0ls32qQggH74J
         mG6jfidcfDThCsOLNRucnJ0n8OvPvzZozcU5dsSxHt+cCtoVgesIyWuVxRhF8GLSC7xO
         qkAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715163873; x=1715768673;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NYxMu/l98xm+aQJfXUGf4HS+yG3SKnaoCLIW2aC5HtE=;
        b=H24ulg0K7bjuOlVPDpcURTvyui0DvXRD4VRBVseo5QtE2pyhJeQjNtelxNtFdCL5/o
         I6CsPVHxUeyTC7B7D1WM0Jz5mBH9ULHEkG0y793umeoga0VgiPn/1GdY2xHLRJ7zhV7F
         jB4LNy5PiuyK79/kMo4B4ErA82W6xr6tPIZKyyOtcwYxyBhBkjJpnZiT4R0jwbJchse2
         T4im5k4Uy+4iXBQlpUiVwWX2kJAbWM0jVZxdihS2oAhzP6FeLNdkmddDmCDcmmQgULpr
         9BLoRQSuePK/7UEPfVris7yAlH30+ZbAnsvTQXncgDieMxbdo+ixzLUELp5werOHdSzN
         1IPw==
X-Forwarded-Encrypted: i=1; AJvYcCXkdWNeVPvAEWGG1TFsqFlXimyt/i6YFS7VpUmZO8WF9AogZfcp65i+t9npiVb8nsEUCALGFNJjVybPJ32ZRp2Ag0ks1mikvoC91Q==
X-Gm-Message-State: AOJu0YxrnDWIX3OhWFzHr57hjjym43Eoio9b5agVGtU/O9GCZVien0q5
	SAOMUBK5wQ1wr9LR/eClKFM8hh9uX0GbypBeZCfwLSf1yT5VsK//ZSPMUwK+DKc=
X-Google-Smtp-Source: AGHT+IHGRp6eozfdvMR/gr1oU4NcWVTGFAynx2t96Zo+Qc70exyQi1md2UgOLD6GNlxBx/oOCoUXQg==
X-Received: by 2002:a05:600c:3514:b0:418:5ef3:4a04 with SMTP id 5b1f17b1804b1-41f721ad60emr20532145e9.18.1715163873502;
        Wed, 08 May 2024 03:24:33 -0700 (PDT)
Received: from localhost (p200300de371aa400e6fd936f426b4ff8.dip0.t-ipconnect.de. [2003:de:371a:a400:e6fd:936f:426b:4ff8])
        by smtp.gmail.com with UTF8SMTPSA id cx8-20020a056000092800b0034e01a80176sm14998621wrb.114.2024.05.08.03.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 May 2024 03:24:33 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	James Bottomley <jejb@linux.vnet.ibm.com>,
	Ewan Milne <emilne@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4] I/O errors for ALUA state transitions
Date: Wed,  8 May 2024 12:24:26 +0200
Message-ID: <20240508102426.19358-1-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajashekhar M A <rajs@netapp.com>

When a host is configured with a few LUNs and IO is running,
injecting FC faults repeatedly leads to path recovery problems.
The LUNs have 4 paths each and 3 of them come back active after
say an FC fault which makes two of the paths go down, instead of
all 4. This happens after several iterations of continuous FC faults.

Reason here is that we're returning an I/O error whenever we're
encountering sense code 06/04/0a (LOGICAL UNIT NOT ACCESSIBLE,
ASYMMETRIC ACCESS STATE TRANSITION) instead of retrying.

mwilck: Moved this code to alua_check_sense() as suggested by
Mike Christie [1]. Evan Milne had raised the question whether pg->state
should be set to transitioning in the UA case [2]. I believe that doing
this is correct. SCSI_ACCESS_STATE_TRANSITIONING by itself doesn't cause
I/O errors. Our handler schedules an RTPG, which will only result in
an I/O error condition if the transitioning timeout expires.

[1] https://lore.kernel.org/all/0bc96e82-fdda-4187-148d-5b34f81d4942@oracle.com/
[2] https://lore.kernel.org/all/CAGtn9r=kicnTDE2o7Gt5Y=yoidHYD7tG8XdMHEBJTBraVEoOCw@mail.gmail.com/

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
Changes v3->v4:
- fix a whitespace error (Damien Le Moal)
Changes v2->v3:
- drop return value of alua_handle_state_transition() (Christoph Hellwig)
- handle UNIT ATTENTION in alua_tur(), too (Mike Christie)
- restore comment in alua_check_sense() (Damien Le Moal)
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 31 +++++++++++++++-------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index a226dc1b65d7..4eb0837298d4 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -414,28 +414,40 @@ static char print_alua_state(unsigned char state)
 	}
 }
 
-static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
-					      struct scsi_sense_hdr *sense_hdr)
+static void alua_handle_state_transition(struct scsi_device *sdev)
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	struct alua_port_group *pg;
 
+	rcu_read_lock();
+	pg = rcu_dereference(h->pg);
+	if (pg)
+		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
+	rcu_read_unlock();
+	alua_check(sdev, false);
+}
+
+static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
+					      struct scsi_sense_hdr *sense_hdr)
+{
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
 			/*
 			 * LUN Not Accessible - ALUA state transition
 			 */
-			rcu_read_lock();
-			pg = rcu_dereference(h->pg);
-			if (pg)
-				pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
-			rcu_read_unlock();
-			alua_check(sdev, false);
+			alua_handle_state_transition(sdev);
 			return NEEDS_RETRY;
 		}
 		break;
 	case UNIT_ATTENTION:
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
+			/*
+			 * LUN Not Accessible - ALUA state transition
+			 */
+			alua_handle_state_transition(sdev);
+			return NEEDS_RETRY;
+		}
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
 			/*
 			 * Power On, Reset, or Bus Device Reset.
@@ -502,7 +514,8 @@ static int alua_tur(struct scsi_device *sdev)
 
 	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
 				      ALUA_FAILOVER_RETRIES, &sense_hdr);
-	if (sense_hdr.sense_key == NOT_READY &&
+	if ((sense_hdr.sense_key == NOT_READY ||
+	     sense_hdr.sense_key == UNIT_ATTENTION) &&
 	    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
 		return SCSI_DH_RETRY;
 	else if (retval)
-- 
2.44.0

