Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B486D1A7
	for <linux-scsi@vger.kernel.org>; Tue, 14 May 2024 14:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715695494; cv=none; b=Q9jsID3RWOiUthHYtzczdWiEs9lj5H4p4q96h7A1og8PCKlkkMYGJBP5piJobY3CLv815YCjk1iaf3fxOctkByHh3HOUjtX2v76KosqwOG2PsoUdFo1L8x1XIlUk9biKogsClcMLf8r4Rp+pZf5oEdkZU7Tk1L8IBanuMDiJH3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715695494; c=relaxed/simple;
	bh=vlBQAD/Tv9YleoM02CxG5iMKGrAvUOnP2IVjZegIufo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t9N+Sri6wynHgMIJ6PYlGtnSiX/9l5XxQafI1MSNgfo/xYwAsumH9KOBtsecWVb4AIBv+zUZTr58TdqYWvo1MpaidAjtV/CNTgVBuAUxFAlGKCXhGwqAI6ttbmH6Wk0fZ5YA8EZDzJaVwfhCOcaVB7jPUsEwWAvJx4FNqsAz8FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QWuaKNxc; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QWuaKNxc"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-56e6a1edecfso268271a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 14 May 2024 07:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1715695490; x=1716300290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P9KOgbcaFaqw1h3hRmDmamViBsOOFXbwUuSP4Q/kLpE=;
        b=QWuaKNxcCPKP37t6TIutqSeBoCOfhS/4udbD/W5SIT5U++LQHOmHiGiMFouDprvV5A
         1Kmpxxnwr3QvquF84Oj4RB4RfbFLgZoTtvhT0A6vqPPWrF3Tq0WvW6xFmgXk5m585JiH
         YRD9nS3OHY3/uMXi7J6UW3d/lCXYIGyqCNm6XnvqriKyHEmWqz/+vX3PK4WEXY0MxYbv
         ef4NevEuL9+QTFxsy5K1ZE6Sqsfc+ilG5JHs9GV+tkphWidjRUOIAeBZSiiJYZmmgNIU
         k/cA7q0VPFqoxYFE+oQthQxqT5GsLbFRoW3mPXMPdm6AtWyPluUc2zUeH/W2ha7Am2SC
         gYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715695490; x=1716300290;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P9KOgbcaFaqw1h3hRmDmamViBsOOFXbwUuSP4Q/kLpE=;
        b=VSFGG+QSo+q1qIpCxoO6xtl9sPIc1bn1ysYdukWZboDu1GyDwwgLSx7erofaohK4c8
         ImsoMjd0RUr9BqorOG3LqQWc8c/07QcvjwOxHT005sB9ASeKOHUWIM8Hdr280skw/l7B
         9nW8j39l7rKz3+09f42AoxvyOeP4hzAy+cOaCbYxO5nK70Xn0rHbmz88g2EhJ9NG/Qad
         PafZ7dGfi7rsazAoGyDRx8GhguwdNL85RBZro9TU0orV/VcKU/8BV5VxSEO73D5CvQx/
         kfpTEC5WloCGz0TVqOsAAWjwONpMYhJtckvT2vU1adZQLvs61Kg2NpO8AEcV/tEjAd8E
         PZzg==
X-Forwarded-Encrypted: i=1; AJvYcCUED86g4sNjtSmEsr5VYkMYK0Hs7q9m6H/0X9QET/17Zqg5P0f4i1WG9EZvfpmEECDkQn5YOfxLl0Q2co+YPqY0xU5gSNTuHClNhw==
X-Gm-Message-State: AOJu0YxFETMrTKuTAFo+kVjHbJHgzbry5AYsWoVrnrOVnFPj2hqvBYz7
	XOKpna0l4+Tcj0bcp+jhNO/tMbpdR2Vui/6Dkc6G3Yq1V5mcNOpANqvslFhjdLA=
X-Google-Smtp-Source: AGHT+IEDr+IKe4bWuGFBABYwnSY29kQX/wi+lLFK6mriHgr7sEclvfCg6Kr3xFFRaLcScLR5fjbP4w==
X-Received: by 2002:a17:906:68d5:b0:a59:a078:9e41 with SMTP id a640c23a62f3a-a5a2d5cdb7fmr798257466b.45.1715695490480;
        Tue, 14 May 2024 07:04:50 -0700 (PDT)
Received: from localhost (p200300de371aa400e6fd936f426b4ff8.dip0.t-ipconnect.de. [2003:de:371a:a400:e6fd:936f:426b:4ff8])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a5a17b17844sm722620866b.190.2024.05.14.07.04.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 May 2024 07:04:50 -0700 (PDT)
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
Subject: [PATCH v5] I/O errors for ALUA state transitions
Date: Tue, 14 May 2024 16:03:44 +0200
Message-ID: <20240514140344.19538-1-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a host is configured with a few LUNs and IO is running,
injecting FC faults repeatedly leads to path recovery problems.
The LUNs have 4 paths each and 3 of them come back active after
say an FC fault which makes two of the paths go down, instead of
all 4. This happens after several iterations of continuous FC faults.

Reason here is that we're returning an I/O error whenever we're
encountering sense code 06/04/0a (LOGICAL UNIT NOT ACCESSIBLE,
ASYMMETRIC ACCESS STATE TRANSITION) instead of retrying.

mwilck: The original patch was developed by Rajashekhar M A and Hannes
Reinecke. I moved the code to alua_check_sense() as suggested by
Mike Christie [1]. Evan Milne had raised the question whether pg->state
should be set to transitioning in the UA case [2]. I believe that doing
this is correct. SCSI_ACCESS_STATE_TRANSITIONING by itself doesn't cause
I/O errors. Our handler schedules an RTPG, which will only result in
an I/O error condition if the transitioning timeout expires.

[1] https://lore.kernel.org/all/0bc96e82-fdda-4187-148d-5b34f81d4942@oracle.com/
[2] https://lore.kernel.org/all/CAGtn9r=kicnTDE2o7Gt5Y=yoidHYD7tG8XdMHEBJTBraVEoOCw@mail.gmail.com/

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Co-authored-by: Rajashekhar M A <rajs@netapp.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
---
Changes v4->v5:
- changed patch author to myself per discussion with Martin K. Petersen,
  as we can't get Rajashekhar's S-o-b tag easily. Changed commit message
  accordingly. No code changes.
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

