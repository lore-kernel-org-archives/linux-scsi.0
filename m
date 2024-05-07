Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6BC14D2B5
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 09:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715074150; cv=none; b=gOf94yncgXUr4I9XX97FhjWH4nCCTYy6fMo98JoZd47s/AvugRJGaTWtJuvGXGKnsDVRQ147Zv0jyqueQPfGAyu2ZgKPccroVTW+u33cci2Rwh8RwnKJRI8OZXSVy/jTHBZ32mMkLjTTpFpXHeF8CQw3iBmoXoCQ5wzqFphlk5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715074150; c=relaxed/simple;
	bh=YQfERoJRIk+5ADEJXG775bBRjRyAsypK4TmpYf0Tgo0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u7XwszkzxVrmm+KQS9XDgxxRtx7Z0kDE8eFZ9lWphofoLJEQWzkgUXInqpm4GjAJQarRaCcv0ju8xfz7i5g8q4gMY6J4wNLWNt9421blF535LjdsO8+8iM2JBp1DGw6T4wGjx6i97Y15WFd87vgr48UkqTYFEzXw6KWdbDwuNPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bP+EczDL; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bP+EczDL"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a59ad12efe3so285418166b.3
        for <linux-scsi@vger.kernel.org>; Tue, 07 May 2024 02:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1715074146; x=1715678946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Aq6uq+h9/vZI8KWlSqRAJjFuqaUNCEkVZc2XxHZ1r1s=;
        b=bP+EczDLLMy2LxdznM1x13qIHL1qVDkLBF9i8AnG+FGr8Ju5lkxTm1HioznSBhAiKL
         KkJsJhm6xQ3kjgSvc4KtaA+O5YjkYyuvFwVcQ1pg4Zg07lMBOwaB1tC40IZ7uYVcgxIH
         pjMwjOMgMfIYoErv6ePjf9opbCtL6UVjYZ0y1dEs5ksMmPhWCnjKveWBwR1IGkA5jAdj
         RSbp+90bbwlHecsdJwmeNmqt3ZLVjbefcjK1nlvxp+zVLFtQ8QNMiW4fpykUvZB/3aJl
         jCIoCRuUAU5fnvIZSBSmp4m6OnlpdumQd2kUbR56bpS7lZVkxtvPqszmpnqQoco766Eh
         yP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715074146; x=1715678946;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Aq6uq+h9/vZI8KWlSqRAJjFuqaUNCEkVZc2XxHZ1r1s=;
        b=cW7HEDF1CpD/4Amh+7UTli18w+sEWc5SXCedsndSJTmojkpaQCn4a0uC3kD4SXTNoo
         VD65L7E8EeLHxCXRCtdNFDT07WbJDJSbzzpwxfgyZWFQW1eQKYThN4B7tQJmxqtOclg9
         scjTJkQbs8XMfuZhJAvVPjGG/tlY7ph4JtxOR6tNH3Ib1dSQi9w92CRvpS0Vf/0PZcg1
         j9bDpJPuxJqnFDiPKndtBtv5BuFzVT/TxwmrhppWC0dUBImgDz4ZutByqMAGvIfB1qZl
         n9abZW29QxdfbKiT/uLsJ35125UmaneqSd7GOLZ6WLPM7gCq04WQe7MUQX8O/nQsuTYz
         PtFg==
X-Forwarded-Encrypted: i=1; AJvYcCWBtZFq6Br/Rzax+prmTwHoe9Cr/3Fr4vjAZtF5vJ8VruLilSYA/SUlziIC92hgJZmUTeuDrIitzxQcX/bavpooAgTkoE8twjNP6A==
X-Gm-Message-State: AOJu0YxUG2/u9t2n15Wm7HvkO2KzCxW8tQMs1bKptmlmHCiirUUyme1/
	fP+W/gUe624yRBk1Zs+4PAvtSrRgLP+YLx60kcjLPj5mDoInUrVJLISgp6jHZwM=
X-Google-Smtp-Source: AGHT+IG2jESt0y+6aMtDG9uoVT8nPdPD6xjCkNpD+C5bkhQktZJY5BI5JYUFp4HxOJ1ywXOwvjiZJg==
X-Received: by 2002:a50:9b05:0:b0:56e:ddc:17ad with SMTP id o5-20020a509b05000000b0056e0ddc17admr5785322edi.30.1715074146314;
        Tue, 07 May 2024 02:29:06 -0700 (PDT)
Received: from localhost (p200300de371aa400e6fd936f426b4ff8.dip0.t-ipconnect.de. [2003:de:371a:a400:e6fd:936f:426b:4ff8])
        by smtp.gmail.com with UTF8SMTPSA id el4-20020a056402360400b005725ffd7305sm6075683edb.75.2024.05.07.02.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 02:29:06 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	James Bottomley <jejb@linux.vnet.ibm.com>,
	Ewan Milne <emilne@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3] I/O errors for ALUA state transitions
Date: Tue,  7 May 2024 11:28:37 +0200
Message-ID: <20240507092837.21463-1-mwilck@suse.com>
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

---
Changes v2->v3:
- drop return value of alua_handle_state_transition() (Christoph Hellwig)
- handle UNIT ATTENTION in alua_tur(), too (Mike Christie)
- restore comment in alua_check_sense() (Damien Le Moal)

---
 drivers/scsi/device_handler/scsi_dh_alua.c | 33 +++++++++++++++-------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index a226dc1b65d7..c6408678e7c4 100644
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
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a){
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

