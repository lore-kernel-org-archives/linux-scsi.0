Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000ED57CBE
	for <linux-scsi@vger.kernel.org>; Fri,  3 May 2024 19:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714766181; cv=none; b=cpav6QQTK4ZVZe+lQ4CZem9kQSwao0rSejz/pBf4dNyLgeA070sIOPjIQ7H73iKAc3nM3oTUzTjSKrDGra4DOHyaTUomXSQ91iGwASoNDETw6niC/atWvd+gWGfSBHQY2up8Y6ohwIdX/IVSnwYGRJyYKqdor73qwPN72Lbsti8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714766181; c=relaxed/simple;
	bh=rruAxGlsWOVHb/PWrKJeqJtdiIatr+RH7bxsABwlkc0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cXJkbvSDyETBz2+1jh2MM3KH+Jn41X9MfOd1IYwGKTJRSlJE2CynkfnYCYkDvB8yOajvzCqXl03PXh5sVxPgOYoGJGRk96qbFYFhKdB8WRAoYXxnsYqT8RdO7gfsfugi9oPAAe9xAKUkWW6eP9QAiThNdFbP9reGA+zAoUpBYJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=In/Gjhdq; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="In/Gjhdq"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-51fea3031c3so62247e87.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 May 2024 12:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714766177; x=1715370977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gUFHfwB+QxluEhVu8AaNPMKQBBH914SJzmLfzGlYl54=;
        b=In/GjhdqV3CE3ZiJH72hFDQr4GRSVUJxrj43sCdsgZ30oZmfU+XxgBPk6Z/a51f5yp
         vvUS9Jk/JnwVMmM1Lhiejw9Zbj4kxhRlhaW0qWaPPjMO8QRBtMwK4t9CbBciqNPu571/
         zMXRKpCQhH0GADst12VgoWI5LBS3XEP6H6i2GLzE21UvTtkGI6hOnRYYe3YGjuqJx9DP
         TaCaog6EI3H+UhiiNTDpVscComOMbtFbEutv2sDmzJLWtP8q100pMCGNi2isqmQnykC/
         PCr2FPWlcHOKwKyce6zF2wwrmIoey1NIgo+5YvBYwdkW7pEwT6UDOhxP9MF5YFk1WU09
         RYWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714766177; x=1715370977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gUFHfwB+QxluEhVu8AaNPMKQBBH914SJzmLfzGlYl54=;
        b=Ww6KCRCzekrclUQMubmRA7lsdOH9aZ4FYAZD5hlfQLS4/zuATYtCBemwD48sHADrTC
         rFpVyUIvQkxut27Mralcon9Z6KN8FRgWlu1CrBdBvMrZLuDZMVVqDqj9q4eQHvRJf/+B
         w1kDDKAOFIwDdenizfA6chD3YBDdI0FQaUhg41ehCaX8qn5K27GPiTZIAlqt3nQZ9Bry
         voZKS+Fn1qV1MrOsK0gpLKym2mkaMBXtp4Q29Pzz/ssum07jXfyep1wRq648GeCnbqDo
         LmzkL8RM/z3J2UybVF+WPs5wmMXUEnUHe2brktpmLKammX+yhGzKx6+8Y2g5WtwKHd4m
         KOLw==
X-Forwarded-Encrypted: i=1; AJvYcCX3X3fagQ8VabaaaxgYLLm4H5AZrp6uTTPjUvQZI8w5SIU2WJ3O3IMcGAQcb+mul36NnsiCXWw30R42/q1H09psPA4y7HCgh6aokA==
X-Gm-Message-State: AOJu0Yw1gihvkbxmaVDKzjRpfbk0fd3bWxHmgsAIC7fzbGJXptxzXkBn
	RTcT7Tdvf/31IWX1IW9wfPs+/TWOdeEkocmdAac/NzzDon+D9IGRcx0GhjeHzpg=
X-Google-Smtp-Source: AGHT+IGybq2AGCV6vThVuEiW19bgcJa4sp/VD9bOWsfWiiHNBgV+g1Qu6QqitmI/KMYjJVF444//Hw==
X-Received: by 2002:a19:c505:0:b0:51f:2f5a:54ae with SMTP id w5-20020a19c505000000b0051f2f5a54aemr2900532lfe.7.1714766177073;
        Fri, 03 May 2024 12:56:17 -0700 (PDT)
Received: from localhost (p200300de374e0700e6b318fffe37a690.dip0.t-ipconnect.de. [2003:de:374e:700:e6b3:18ff:fe37:a690])
        by smtp.gmail.com with UTF8SMTPSA id g21-20020a170906595500b00a55662919c1sm2101039ejr.172.2024.05.03.12.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 May 2024 12:56:16 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	James Bottomley <jejb@linux.vnet.ibm.com>,
	Ewan Milne <emilne@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	Martin Wilck <mwilck@suse.com>,
	Rajashekhar M A <rajs@netapp.com>
Subject: [PATCH v2] I/O errors for ALUA state transitions
Date: Fri,  3 May 2024 21:56:06 +0200
Message-ID: <20240503195606.13120-1-mwilck@suse.com>
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

mwilck: Resending a modified version of this patch, which was originally
authored by Rajashekhar M A from Netapp, and submitted in 2021.
Moved the changes to alua_check_sense() as suggested by Mike Christie [1].
Evan Milne had raised the question whether pg->state should be set to
transitioning in the UA case [2]. I believe that doing this is
correct. SCSI_ACCESS_STATE_TRANSITIONING by itself doesn't cause I/O
errors. Our handler schedules an RTPG, which will only result in an I/O
error condition if the transitioning timeout expires.

[1] https://lore.kernel.org/all/0bc96e82-fdda-4187-148d-5b34f81d4942@oracle.com/
[2] https://lore.kernel.org/all/CAGtn9r=kicnTDE2o7Gt5Y=yoidHYD7tG8XdMHEBJTBraVEoOCw@mail.gmail.com/

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Co-authored-by: Rajashekhar M A <rajs@netapp.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 34 +++++++++++++---------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index a226dc1b65d7..682d5bb53d14 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -414,28 +414,34 @@ static char print_alua_state(unsigned char state)
 	}
 }
 
-static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
-					      struct scsi_sense_hdr *sense_hdr)
+static enum scsi_disposition alua_handle_state_transition(struct scsi_device *sdev)
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	struct alua_port_group *pg;
 
+	/*
+	 * LUN Not Accessible - ALUA state transition
+	 */
+	rcu_read_lock();
+	pg = rcu_dereference(h->pg);
+	if (pg)
+		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
+	rcu_read_unlock();
+	alua_check(sdev, false);
+	return NEEDS_RETRY;
+}
+
+static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
+					      struct scsi_sense_hdr *sense_hdr)
+{
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
-			/*
-			 * LUN Not Accessible - ALUA state transition
-			 */
-			rcu_read_lock();
-			pg = rcu_dereference(h->pg);
-			if (pg)
-				pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
-			rcu_read_unlock();
-			alua_check(sdev, false);
-			return NEEDS_RETRY;
-		}
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a)
+			return alua_handle_state_transition(sdev);
 		break;
 	case UNIT_ATTENTION:
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a)
+			return alua_handle_state_transition(sdev);
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
 			/*
 			 * Power On, Reset, or Bus Device Reset.
-- 
2.44.0

