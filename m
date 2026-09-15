Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7760E49CF38
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 12:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476967; cv=pass; b=ICHQ+X7sZfoyDrjsN/hoI7SpwH68rfg4tGJuza3KMqQlhuxnq04euudfW5cCBfbfUL7p0ZxukTvBlf+BUct/1jIV9Qppll3wboDpGaQ2ZMUVbf9KJi26ApY2OUgvV9MZ+wiyNoE5LwPO2H6L7kkKiG81Fc5m83YZKP0CBbP7LA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476967; c=relaxed/simple;
	bh=JfTyVkhgxfL/z3btfG+skDMTPgV8u01NEtVFVAGhNFY=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=cBY8bNPSeo0sQ/UfaBp4BR3Ze6oWVbF4X94IwOMoyfc36tiPwku9JPSywUAMuV579ws5nWoNVZttdh0jxlxchc8f/N+9wxNzcsGrvAdsogNgqsOHyViFavIflRVFnckG5039L/wTVtUXyZS3prwhtQ/mCdVUxQM29UUNaOQwzXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KV/W6BZl; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KV/W6BZl"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843378fb37so1540488f8f.3
        for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 05:56:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789476964; cv=none;
        d=google.com; s=arc-20260327;
        b=e9YX9pdP1ngufFvhZoOkazt8+1Hh1BUg8Sts32ssoZmY5eQ4GKlAVvT56O/gwvBI5K
         9qcNihxH33qivY24zI74LBnPNiqM6+OTTTw4knVy4OlXmu5GUNCAggNUa4fu2TGB4ug+
         JdAQ9/v2S83NHpWRm9rsuuv62wzsxLAxNiBvaFgPVC4O4GF+WcFWNzc9EiUMgRTD4zuz
         X6sxLbcxm7qgWoA7vj/ogazwebXCFAFhNFTrgODUuRM13c6O412FHUd1ql4+8H+0bu1R
         GHLgO/C7E/pRVRi8WhGRLfKl/zY8huO6CiLDdeioQq2pajoUGsAHPP6xkOsW5jAsZR33
         uhxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=eg+7r5P/Xe1Sjdkvr4/ciPHt1vbGE5FEKbuToDdqlYc=;
        fh=Qi931tWEdrcF3B4mrWXVkXrNaTyBqDFpfzIbLvYKuOI=;
        b=YgcjgBBUeOjOlxyu1kI/j9uns2TochIFz1yIU4MrN+lixABIs8Nr2x9ybO+cS8JPK/
         fwzuT1BYOS2p3dI24u5m2W0xh2PT7QbuWiZuU5DgiJD19hUEo8QTaW2+SQWXZw9tDUy8
         0cjeh5E9PfXat7PIIWdjoOo15oBJFvlV0Hss1pl+Q4pQhQdt/glTZeOS8GkcRkO7UJHp
         PpszPsf9LFVSFb0VB81WRibY8b+VJV9Ex5AcwWwWocwuCbQyZhrPCWJon7Z98qM6JaMB
         P+E1+OtqI8JSmHH4idJ9mWHJOdyMUbRrSLfkkSyl3oEkTv6CZfnesU9tKIh67W3abp/L
         fX3Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789476964; x=1790081764; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eg+7r5P/Xe1Sjdkvr4/ciPHt1vbGE5FEKbuToDdqlYc=;
        b=KV/W6BZlaWfxPIWRy8/w5MnwWbiLLrEAMOUo/U2Ozk0tMT1TGQV4bOPCaeEiFdBmU9
         XJzY2GW6VJCg7COFGXnavGInXEfigZdQNR5n8bgMTKPRqjyx5bTPl0S4EEvHQhzNnApM
         ygNomLtcNaljuxBSd0afEHfJtHIzTpl7R2q+2K+GPmigxpfjn7NCg4JbjqS4lmg/RZMf
         Km/ta++MuByFeTEYoBeTWxnEJ84DhZBWEmZazXIA/8aK1aZy7r+1y1vu9rzMD/fZSY+y
         qyPTEWEz+LbhnqvW2LT+2PZRr5xC+7Hg7n3hpwQHe9Ml5Hjo1ElHfqda9qlXEHvKQe6h
         S3RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789476964; x=1790081764;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eg+7r5P/Xe1Sjdkvr4/ciPHt1vbGE5FEKbuToDdqlYc=;
        b=wUj6qQ2wpqN8RcrpAV+tA7eF36DQ7d3wO0UrW3XgOphpY9QKb0gZYg9ZQMHtChp7p8
         DxuTqu3uD/AaRylGnMkrx9nh8bIQm+OiSnzAGkZSi9oQwIBkyeU0/cOiweOE7yVJiw6K
         KQBvb2Heq5ZOrpuU2xXOvH9Ss65Wski/0aYdREMQhL1ICfi2tn8NboDEDPtAASd3Hnkz
         TOt4qV4jQHnbeuVz++F4NlHF+Rv51j+WTtlLVxwnN0z7FXGuEdEr94qyGDsGR8EwYa+L
         HJTG95zc5x5d0SDyA3EmN3YDydu4nf4QXLEcX2Qd7vkGTmTUfw7Z0BVn6lX/br+7ohLb
         53zg==
X-Gm-Message-State: AFuF++mX4cxLyb4f+c408Z+y5skH9IeKanLq5lg+IhiQnAosxWn49fkA
	enuatqCqHH4Vd874RrIkQPwsTalD0Q6iVJJWTDJLy5gUh7XjXIPBTbk2eTo2Y8mAez9xR7usD7I
	44WsAr35oeS7hvCBTeL1gGy63VJHe5oZHoferk1OvLvPW
X-Gm-Gg: AYBFou2IdJYmIKWrHzGkiQtCgIR5tR8Sgn8MiibyN4YJjnIVfGFrpeDhjhksuuuH2Yj
	LnpfNHy62RoM7mje5DQmP0HQIa9qmBFwwDt9P29e4HwQO6mCU0gvEQQE5xca/TN9rLVidhezATn
	9F9fM5WEBhhXumekpnqIu5KH9SQg6hVrSKn/JmL7mYfke4RlSL/KkX3PaQKBSKB2viO5FfH41+r
	qpqTDn07K5Z1EV/n6m/rVFc6oHB82YfODjxwjyWx1mmoJ7HEqShE9MyXtLv0ZANIQ0no4ZbvvI8
	DZHGE1UKKD4ymjW/1tNUjQ3daKBUreAaSP78PqjT9MAh3lW+HoAfEQ==
X-Received: by 2002:a05:6000:41c3:b0:482:eadd:174a with SMTP id
 ffacd0b85a97d-48702b069c8mr8066975f8f.17.1789476963553; Tue, 15 Sep 2026
 05:56:03 -0700 (PDT)
Received: from 830778650420 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 15 Sep 2026 05:56:01 -0700
Received: from 830778650420 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 15 Sep 2026 05:56:01 -0700
From: Ruslan Vagner <rusya92266@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 15 Sep 2026 05:56:01 -0700
X-Gm-Features: AcwNN1XPkprRgPh4CCydpSfrhYjielBopryX2EyTiUwM2QPK4PU6u57OE0y3iWo
Message-ID: <CAF9RqJ6Yk1K5Fj8BHSCXQeTL3uMp8pyPrfmP_tnKkiT=09EUFA@mail.gmail.com>
Subject: [PATCH] scsi: qla2xxx, iscsi_target: fix comment typos
To: linux-scsi@vger.kernel.org
Cc: mkp@kernel.org, target-devel@vger.kernel.org, 
	Ruslan Vagner <rusya92266@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Fix the spelling in comments. No functional change.

Signed-off-by: Ruslan Vagner <rusya92266@gmail.com>
---
 drivers/scsi/qla2xxx/qla_target.c   | 2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c  | 2 +-
 drivers/target/iscsi/iscsi_target.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c
b/drivers/scsi/qla2xxx/qla_target.c
index 53a505df8da0..e25c05b5655d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1953,7 +1953,7 @@ static void qlt_24xx_retry_term_exchange(struct
scsi_qla_host *vha,
 }

 /* drop cmds for the given lun
- * XXX only looks for cmds on the port through which lun reset was recieved
+ * XXX only looks for cmds on the port through which lun reset was received
  * XXX does not go through the list of other port (which may have cmds
  *     for the same lun)
  */
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 3be23ed067e6..fb26cd1b6383 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1439,7 +1439,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 		return -EINVAL;
 	}
 	/*
-	 * Format the FCP Initiator port_name into colon seperated values to
+	 * Format the FCP Initiator port_name into colon separated values to
 	 * match the format by tcm_qla2xxx explict ConfigFS NodeACLs.
 	 */
 	memset(&port_name, 0, 36);
diff --git a/drivers/target/iscsi/iscsi_target.c
b/drivers/target/iscsi/iscsi_target.c
index 124ff269b8e7..bbdce7d80d6e 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4547,7 +4547,7 @@ static void iscsit_logout_post_handler_closesession(
 	/*
 	 * Traditional iscsi/tcp will invoke this logic from TX thread
 	 * context during session logout, so clear tx_thread_active and
-	 * sleep if iscsit_close_connection() has not already occured.
+	 * sleep if iscsit_close_connection() has not already occurred.
 	 *
 	 * Since iser-target invokes this logic from it's own workqueue,
 	 * always sleep waiting for RX/TX thread shutdown to complete
-- 
2.54.0.windows.1
