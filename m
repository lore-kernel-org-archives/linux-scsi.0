Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D24847987A
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 13:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790256894; cv=none; b=mtNq8FvVQGRAD58Od1vi39C9+zhf1citr9PkdqlAqjoseQ9Ml5+h+jPJ7Bpvs8TU+ZJjw1L9Dy7/EmJYNQnGJc+f94uVjQjHuO5M6bitBXvoAKT5ShXHVvMTAmcvvnMePpdn28OHzajxJy6cwby1XHxcINZTpADQFYo0h4AqLE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790256894; c=relaxed/simple;
	bh=Zw0pIP5eSJI28ZqgOlOYqy4ScF2vOQAnlGs6UoZ0oSM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QQKK6sBkjoJ0uZoII5NY9zxaOQqdKxCZvDbM9PMP8CETWuxX4vTd6HH6jdHl0isziEubHzJV8isngJgP4VndxB82g/jsI9B52jTLgWZBP6wboHA1+1QbxF3OlW4Spg1YWegD4SieBZjOEMMZfWi1U1dpt5OJd6eS4O4Pyu06dHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZB4v8vx9; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZB4v8vx9"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469b355ffso996131b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 06:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790256879; x=1790861679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wOCGbQf6XP96p7s0OjDQYdkOZWkG2NUg2kYXrHgNtio=;
        b=ZB4v8vx9T5Ii0v14xNQJRScTrcNU9LVmZ0nw6SPPjOVeoti7wLSSwUAVTTzlE+Ds0j
         W1B6bPIpTw9gwbXk5IXO1TYW7FkufQpfMeeugX5AXc+lvJnMadq0Jp1LoRqmoXhUkkMh
         CguJyjIb86z6F5SpgL1+OHdcYXAYNQSNunHeStRoNZFoiwqXCON+/u9acwcOSfTFQA2T
         ik8wgcoDHGEjUixaY6aGHTXzUVryzdnD/gtQM+YgCkeN0GicqMnxzYVVl36tUE0SFuME
         TNh36Hu+C6tvjFVQh15p5EsJcCXw8Fwxnt8R+rUq4EBHAf3ZoHD+HHogoL9txBITgep+
         KMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790256879; x=1790861679;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wOCGbQf6XP96p7s0OjDQYdkOZWkG2NUg2kYXrHgNtio=;
        b=GxPBZ7RWsJ+OHz7cmZCgv/F9daXoHJnCYYnKW8PPIMpo1hAXjbjf1WmjJVCLQddyW+
         M+UxdZ+zWDN9+bAXs+AKyK73a7x5w5f++oj8Ni9c6ZbGLfpO9OmAgMD3yWiF4oU4ylTg
         85ZlkNDVMftH9alQfcZmx9oyHPWMXyrXf+FJVwp1dgYiVhFrNSjkHFW2TuAZhk4SZ6ZE
         tBguY+Mf8yhjGQDGigzIPqitLNn8XEht2kPj9H2sHh5NfiuWpaZ+HRsqL4wJ/IddWs7P
         3H/+0U4MC8+IapyDPwL5aD7OSTMrMa6GGaPVkU9tAOgaJuCSeMowoUwcuRhG23BfYyro
         x3gg==
X-Forwarded-Encrypted: i=1; AKwUvBxZQP2Ry2er+Q64EJg/Uy3gIPmZVipf5GGi5D9JVJMQ2nbsWsAVyBFYsp+ub1ergtGiaHM/WJazVGBI@vger.kernel.org
X-Gm-Message-State: AFuF++kbkhx2rA/H4j5g2b/j1LAPMPjGDdSRHs/TBj1y8uKmKTwn5S2v
	TKDCESoYrVE6LUXW79DbxdI8isIvEgJiOWD7lvX+xe67lbTeho8NBYt+
X-Gm-Gg: AYBFou12jLW1dFrwPUh4aNU23vN0qn0su4JjxF99ggg6Z5P73cvMoElNgiewv3ZqDTx
	4/MwsrVYu/b0gdjADps7NTTLx3HRq82hAxaIQb1yp0gerOFUu4bXubVn7aEb4u/3IUnkBVvbY5A
	+fyWYqDPA0xvViM6Q5760XzC4LDGYf1ytbnW1KU8+TcMBcfrayF7B20+LzVmSxaP2HfvcNOgzaA
	9fAhKM1hhB0oN0gtncMeGz93AnracOS2CkB4nk0tP3JykugWudDfNtEYq+Yo0B8eb9P00nyKT11
	bT8jACn8mJIzoU0qMs5JCw7G2zScP88yCqCd62e0YDndjlMBYsy0a59wXquF3gYun+s6Lk1Bczn
	Cm7eceVQgmLAZHrYHFzmPJBMrjiBRwbnGN6oAWBtamIWG3BCIY1zNhjhkHUEqoo6tvsYPU8ghvu
	VjxTT744sqfV69RmFENXryoNVm+lpreZeeg0YLB/nu2fOUJMrRUlp4VA==
X-Received: by 2002:a05:6a00:1302:b0:878:3783:8a4e with SMTP id d2e1a72fcca58-87e9be76a5amr2245806b3a.54.1790256878537;
        Thu, 24 Sep 2026 06:34:38 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1e0f4fbbsm3024366b3a.52.2026.09.24.06.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 06:34:38 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Joe Eykholt <jeykholt@cisco.com>,
	Robert Love <robert.w.love@intel.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] scsi: libfc: fix directory server rport memory leak
Date: Thu, 24 Sep 2026 21:34:29 +0800
Message-ID: <20260924133429.1587511-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fc_rport_create() does not add FC_FID_DIR_SERV rports to
lport->disc.rports. If fc_frame_alloc() fails in
fc_rport_recv_plogi_req() after creating a directory server rport, its
initial reference is not released through the normal rport teardown
path.

Normal rports are added to lport->disc.rports and removed from the list
before their initial reference is dropped. The directory server rport
bypasses both operations.

Add directory server rports to lport->disc.rports and use the existing
list removal path when they are deleted. Keep the existing directory
server callback and retry behavior unchanged.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: 3ac6f98f4113 ("[SCSI] libfc: correctly handle incoming PLOGI request.")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
v2:
  - Add directory server rports to the discovery rport list and use the
    existing teardown path, as suggested by Hannes Reinecke.
  - Preserve the existing LLDD callback and retry behavior for directory
    server rports.

 drivers/scsi/libfc/fc_rport.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index c25979d96808..eac3fde1246a 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -160,10 +160,9 @@ struct fc_rport_priv *fc_rport_create(struct fc_lport *lport, u32 port_id)
 	rdata->maxframe_size = FC_MIN_MAX_PAYLOAD;
 	INIT_DELAYED_WORK(&rdata->retry_work, fc_rport_timeout);
 	INIT_WORK(&rdata->event_work, fc_rport_work);
-	if (port_id != FC_FID_DIR_SERV) {
+	if (port_id != FC_FID_DIR_SERV)
 		rdata->lld_event_callback = lport->tt.rport_event_callback;
-		list_add_rcu(&rdata->peers, &lport->disc.rports);
-	}
+	list_add_rcu(&rdata->peers, &lport->disc.rports);
 	return rdata;
 }
 EXPORT_SYMBOL(fc_rport_create);
@@ -363,11 +362,8 @@ static void fc_rport_work(struct work_struct *work)
 
 		mutex_lock(&rdata->rp_mutex);
 		if (rdata->rp_state == RPORT_ST_DELETE) {
-			if (port_id == FC_FID_DIR_SERV) {
-				rdata->event = RPORT_EV_NONE;
-				mutex_unlock(&rdata->rp_mutex);
-				kref_put(&rdata->kref, fc_rport_destroy);
-			} else if ((rdata->flags & FC_RP_STARTED) &&
+			if (port_id != FC_FID_DIR_SERV &&
+			    (rdata->flags & FC_RP_STARTED) &&
 				   rdata->major_retries <
 				   lport->max_rport_retry_count) {
 				rdata->major_retries++;
-- 
2.43.0

