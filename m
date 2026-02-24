Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEB41F92E
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 01:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771895284; cv=none; b=LIB1NcLVS95BRhMazwFlJceVqU3+RbBrUE8+X0VJ+OGi303G3tyGaUUnjRjgHmFkJTu3ZQ+bgQqh7vVMtWonuJuz76n4T3/Q9/zpi63u4QR5n4aD9biPEOZk3eFQbUt280CiSrKc1/TYiXgx/tvYAD7iL9/P9KAnxSmthAMAmZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771895284; c=relaxed/simple;
	bh=0SdMD3ss4P4g+qwQa2oPCJ8A6Sz8Vglwg8s87mhKmfs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N70UX6g3COeIFLvVA5NWXDucPKIQnWAal+LjCjDxrwy1PzkMLVmHz+TnDYOHAA3kn4WwYAfyz8NxmaeOTFxehqo4GxL8Zv2Y/CtoYBhH/FejBVCaLPLgKT8qR/+nJcLh/913oN6D6rC8oGoURdvK09mTrIsfktVFU4u7sIDnR2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=aZ3L9qOt; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="aZ3L9qOt"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2b86ce04c5cso1222585eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 17:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771895282; x=1772500082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aOYPz4JPQYdbPHHE9mVdr8Ua7IC4VPw7SUprP6opF2g=;
        b=aZ3L9qOt2wlN+D/Y5ib/q/ZxPItBsBJLywB01UWR/9BB/nn6aW1VKNt7eMVqZUMKhY
         nlrOnEfkuYogLsC5+u+wv8n1uYETiMLDFsd8eC3dlD3ZCl6w4LXMvtVx70y2bdZAMhrN
         kQqIYBeaYJiSYvG8ed3a5duQ2/lZIfwJkVojypiXuAFm7tPQewr/pWPU+nmocBwitp+J
         6tMDKfaJ1CIqR4m2B7YlqhJClF6mrdTcE1eqjT3MocbDze/Hw/Yd7v3AtOUFMFBN0ntK
         LlQ58hePlOOq5tZrFcaSaX+IdKwII6cYuqETSnZ/XhR4ZUP2JSDf9LliRBXmYuW+wiCd
         NqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771895282; x=1772500082;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aOYPz4JPQYdbPHHE9mVdr8Ua7IC4VPw7SUprP6opF2g=;
        b=gM0uLc3Ci6JXdndg8MSFuw7V/ubDc0pbtkF6J5r0K/poHNyhbrAY4EOEy+bI6LH5CH
         AMfMZ2MN6s+iMxns356s4ImKngP4dcyu+5O6EUfxbga7Y9af8DntNDjZWRtPZLP7Jn7b
         fGCRcXf/rcW9oJf6YU8jxr8Nt9ZphHnZytiMJ17P/dIxqvpUHXq+2Z2zedLIbHakSv6c
         shyu65WjplWBGj65h2YBggd7c+L4ej3NbZcXw3jqgWCjIzQwt3X8n5IBKNP5xV8jhfiN
         YZcWZZXjQXtKDFu66DXm59YmjEoRX//xY+wI/IXO8NSSj8PAnx5KH9v/hvCv4fq12+D4
         b8nw==
X-Gm-Message-State: AOJu0Yz3PJ+FeRU+zftSktgFwxEL/GCD00gQ/wd6lL4wDJl5kEyFU/4b
	6Z1T6kxiTSuDv4nxQvpsO9d2y6X5sV8MvvaE6FuARFOjWsa4i9hcsALfWtqCJ9aXk405IIck8qZ
	yyYJVos8eXEYxbU4BPIE6gfOXWMu+vhn3z+MTN75b+tdJ7jl7WraKo63dIIGyG5f4TAOE4ahxza
	wBbidAhibAly5y3bbmLRQKycIb/n4MLtEsulnK4Fp5X72HOo0=
X-Gm-Gg: AZuq6aIksgV4mJqw7mzN8IDtU0KZ5B2Y3MlG3sIt+YkyaptUKbTs9XSRYKDn5NfOCEQ
	wNsPnFzLCMbRxXdpc3HkHdRoaoqw4ZkNibM2IK9CNSYQQcqHai+yiQJb+SYecykGPmxa+KIm4eQ
	dJ/Azol/cV4C5MR/4+5UG/W3njVLPVtuULf5EXLW0mrSMdrLh1gC2R019QojURw7wohiT7UcGaG
	5QpbXv8DusQCaoY8nlf0Mx7CXto30xdu//09OUgJRJiYfuj8F9+0LU5CUfGsu7BMgzUnT/vhtfe
	f/2gAOXQtLg43hk+DYJTVQO5utTKXdYdA708bkLGVJSYikpWmnYRyNFBAWYHq64HjCT7cQ9sfqQ
	9UeOAXsSEMTtDi/dm5BnGIU1pmg5+juRxJ57zP0Iornlh/N5YK7nvACmiTikE6etcJOQDl2yy0p
	/FUt5+hP1Nav/uQLodyLp2So4wcGq2v74pvJnYzkmQhPa/6Q77rqya71MXxlhA82JDMMAUQBT/2
	14wxuZF99h77lSxWDy380wTFeTK/uG5CsbFLztYUBS1k+FD9uvILi6o
X-Received: by 2002:a05:7022:160c:b0:119:e56b:9596 with SMTP id a92af1059eb24-1276ad1181cmr4289465c88.27.1771895281517;
        Mon, 23 Feb 2026 17:08:01 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([165.225.243.14])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1276af9f74bsm7994439c88.15.2026.02.23.17.08.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Feb 2026 17:08:00 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de,
	Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH] scsi: scsh_dh_alua use the device timeout rather than a constant
Date: Mon, 23 Feb 2026 17:07:54 -0800
Message-ID: <20260224010754.37001-1-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of using a constant for timeouts, use the timeout of the SCSI
device itself. There are reaasons why someone might want to extend
the SCSI timeout and having the constant out of sync can lead to
early timeouts.

Acked-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index efb08b9b145a..7f11acf714ad 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -143,7 +143,7 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 	put_unaligned_be32(bufflen, &cdb[6]);
 
 	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
-				ALUA_FAILOVER_TIMEOUT * HZ,
+				sdev->request_queue->rq_timeout ?: ALUA_FAILOVER_TIMEOUT * HZ,
 				ALUA_FAILOVER_RETRIES, &exec_args);
 }
 
@@ -178,7 +178,7 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 	put_unaligned_be32(stpg_len, &cdb[6]);
 
 	return scsi_execute_cmd(sdev, cdb, opf, stpg_data,
-				stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
+				stpg_len, sdev->request_queue->rq_timeout ?: ALUA_FAILOVER_TIMEOUT * HZ,
 				ALUA_FAILOVER_RETRIES, &exec_args);
 }
 
@@ -512,7 +512,7 @@ static int alua_tur(struct scsi_device *sdev)
 	struct scsi_sense_hdr sense_hdr;
 	int retval;
 
-	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
+	retval = scsi_test_unit_ready(sdev, sdev->request_queue->rq_timeout ?: ALUA_FAILOVER_TIMEOUT * HZ,
 				      ALUA_FAILOVER_RETRIES, &sense_hdr);
 	if ((sense_hdr.sense_key == NOT_READY ||
 	     sense_hdr.sense_key == UNIT_ATTENTION) &&
@@ -552,7 +552,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	valid_states_old = pg->valid_states;
 
 	if (!pg->expiry) {
-		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
+		unsigned long transition_tmo = min(sdev->request_queue->rq_timeout ?: ALUA_FAILOVER_TIMEOUT * HZ,
+						   (unsigned long)U8_MAX * HZ);
 
 		if (pg->transition_tmo)
 			transition_tmo = pg->transition_tmo * HZ;
@@ -664,7 +665,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
 		pg->transition_tmo = buff[5];
 	else
-		pg->transition_tmo = ALUA_FAILOVER_TIMEOUT;
+		pg->transition_tmo = min((sdev->request_queue->rq_timeout ?: ALUA_FAILOVER_TIMEOUT * HZ) / HZ,
+					 (unsigned long)U8_MAX);
 
 	if (orig_transition_tmo != pg->transition_tmo) {
 		sdev_printk(KERN_INFO, sdev,
-- 
2.52.0

