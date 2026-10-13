Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4F54825B4
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 17:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791912719; cv=none; b=YcINiHqYHK2rQZ7cerzs8eFq5yNMIdp9tRBDvO2AQG+ECL0fk8uaGj6zihsjZczBkk0pP3A6vKm/gPQxPAxJIf0ua+qwJ12By/ddVS6IxsgrceGKRa6Dkbnjpfy5CLcDr9NT0RtNA9tg8qcwnLeZ+MFt0UsYjpE4yIZWxKGwEGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791912719; c=relaxed/simple;
	bh=WWTcqcrYuK6IbdrjMRhsuwFkgDt4+Cy7tBLo38z8uik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRcvrwAyUy9ZH06FgU9qpIKRExp9KwF8xUzXz4YNIwcqxxAhjLxNU5+IBppLiuJD3+i0x1qM8iHhUc5SCcZDjldp+4aqPhF86VWRkrznBH0Vl2VhbdLwWVhkRamWH4dWb75OrxedoTPKJzxJQjNPcRzNmOMrIWZK+pqab9WYI38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=PznwGQJd; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="PznwGQJd"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc502d509c0so43427a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 10:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791912717; x=1792517517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cmaZjOlL7Z4YX68oXGeP0K0pl8aIA8E2Yu5c3A96tCc=;
        b=PznwGQJd+Zg5hqt+wtLBHz8nIdnKFSN04lKF/evhNefGtdkydtLpWcgj4Py1zvg1AQ
         MYQbFhhY9q3zRp29YjbzF6VrseL81TI+aL3b6RDlQNSUP2BGrx06giXuBCDBVvzWi633
         ZCNJOqydrS1yzISgoTIWkc72z7XKcwH5xsaOF4VYy4Qq9hjVE8MiVcEiTEVai7S2mLbQ
         9jtb+0K2NB53HFS7RtmthGDKtqgKIEIQ30MSNWw+yEHGpRnbnv72Wb27rikdr0Biusnj
         pDVE6B2IaOhZS7VSyyH8WpSteWHxdrXQH5aGkOmWdQATQauFSuQQSRK0EY+wSmazYn2P
         99ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791912717; x=1792517517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cmaZjOlL7Z4YX68oXGeP0K0pl8aIA8E2Yu5c3A96tCc=;
        b=WIL6RY11EBVJHQxaQ7a8Iq7xnaOoD0EDbj5y5w1fLCZtjQAsF2Yuc1sdBsOWB3Kr2C
         iIwi61+wIlQQjoY3eOqolteXOaA5AVePRFJdR5/P4XveKtkLEHYnUCxbciWCoVo+XR3g
         3mCqKoutwLO2bNrJUCwgTsIoNet6K/TV21aeUIsaMhrIoyQB17RHfytYhAgc+xRB3+/M
         V5+RPBGAeHJ6X4WijRshDezo91pAGzg5qzTaCHKFO9j7TtrxYD2HnKAbERSqarA6rm9+
         I0R+q6X4RoERJ2DZMMeZCqkVb9BwV0jwc8qn9ZwJFPcKXtQ3b9SNT/gXzi4X+oT+omDd
         uvjg==
X-Gm-Message-State: AFq9FYIXTRqKayc0HwXsFVCaJjwMGRe6uSd7nNox15puwaapKpB1J8Z3
	lgRDTVv6pkKZyKBLhbbJwInIQzbmX3kVJT57jmUEIu4I9FLsVqeoyXX5NJqplRS6u60=
X-Gm-Gg: AYBFou2WDFHD28keRG/Q1fpDRJoP33OjhHohLPaHunzttD3ga2uZx3JbwNBbHM14sJf
	QRgpO2/7ZAtigGhMyM84hxf9vU7hKJefUMYSFEZ60pJ8tcLk2CMxaLclTlV+gmxxDc/cYC81IwQ
	fUssMmQw1ZgyYdP5FiI510HSRy7/fwuzB+6WcIqg8cQrC3e7Exrz+2d2IfEYJvWkK+/2oHNcUIm
	9ekrv7jdk1ibS6Ytafb+pwgsIBJuFYq4eiU5Wqp5MKYtYiV7rPYwGG9RzUQ3M8zYRU7bLKt/3NI
	vhAazDpmQcJh3Xwx80O5qyIA2jdd5revzk3ikgdnO8R3RET5V5ZYl7DlrR95py4pYM9+iqyFoOK
	hS4DXhGmJ+vidnBi4c06YZG+kE7AS/QlYD85lXWu3Bbcj2F/edWhVPnkNSYrepjj8sNTZwc1eEx
	AqNkmryNewGFp8duwp4s2IYgQ9FwTMygND47Z+fiW05vfkqzhDHcqSK3987vF1u4lxZG2CzMJxt
	igwrjv+dHvCl2Gnh00K
X-Received: by 2002:a17:90a:d2c7:b0:3ab:1b19:78f0 with SMTP id 98e67ed59e1d1-3ab3a8e1d1bmr11092955a91.41.1791912717265;
        Tue, 13 Oct 2026 10:31:57 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac6019ca59sm607396a91.9.2026.10.13.10.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 10:31:56 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 1/2] scsi: mvumi: bound the per-event parameter and sense dumps
Date: Wed, 14 Oct 2026 02:31:44 +0900
Message-ID: <20261013173145.3412863-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013173145.3412863-1-yhlee@isslab.korea.ac.kr>
References: <20261013173145.3412863-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvumi_show_event() prints param_count u32 words from params[] and
sense_data_length bytes from sense_data[], but both counts come from the
firmware event (struct mvumi_driver_event) and are never checked against
the arrays, which hold four words and 30 bytes.  A firmware that reports
the maximum (255 each) makes the loops read far past the event and past
the 512-byte buffer the event block is allocated in, printing the result
to the kernel log.

Stop each loop at the size of its array.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index e70d336b4ab39..38a92f8c25f5b 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1361,7 +1361,8 @@ static void mvumi_show_event(struct mvumi_hba *mhba,
 	if (ptr->param_count) {
 		printk(KERN_WARNING "Event param(len 0x%x): ",
 						ptr->param_count);
-		for (i = 0; i < ptr->param_count; i++)
+		for (i = 0; i < ptr->param_count &&
+		     i < ARRAY_SIZE(ptr->params); i++)
 			printk(KERN_WARNING "0x%x ", ptr->params[i]);
 
 		printk(KERN_WARNING "\n");
@@ -1370,7 +1371,8 @@ static void mvumi_show_event(struct mvumi_hba *mhba,
 	if (ptr->sense_data_length) {
 		printk(KERN_WARNING "Event sense data(len 0x%x): ",
 						ptr->sense_data_length);
-		for (i = 0; i < ptr->sense_data_length; i++)
+		for (i = 0; i < ptr->sense_data_length &&
+		     i < sizeof(ptr->sense_data); i++)
 			printk(KERN_WARNING "0x%x ", ptr->sense_data[i]);
 		printk(KERN_WARNING "\n");
 	}
-- 
2.43.0

