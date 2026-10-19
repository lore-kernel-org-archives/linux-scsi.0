Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1769933939A
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 01:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792373962; cv=none; b=gvQocxu0if1wmNfGQ+m4OcG+imaanAMDO/L1NdJc69ESx5ztFdvMTe/0zSxPERxbStagvMiXxOiuIIh40ZcYn3+rLDpibuUgM4ShnCFtfViiKMoVTWsaGhVLKXtqGIMGmq1mWYoJtJwM7gGczn2aUwqPWbblkl7he8MDmUT2Rig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792373962; c=relaxed/simple;
	bh=HDe/sJAEmYOylIZNpRHLAmB90wcCrlY+qlF1S0YnkWc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p81YzgkTB2vHEfX+UR7km6+AwXXk2LJngghBjgZMJ3kWTdFz8StZIb9NN3T6Y95rb1rXA2nkefgb5QU9KPwZLBj+aD1LTaBlG7wSn9Y7ELa/k4/s9Mq9T9F+CtJ3jFb3xvoTsHQyzWxh9CAtwAdlU6sVy/VoFOfTU1nI+7IWOjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=sL8NwdK3; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="sL8NwdK3"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ac6794fe45so1331734a91.0
        for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 18:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792373958; x=1792978758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y7FGjbZkzoe6sSfHIZ7/1NewrsALE0UfgLMmOjZ+FHk=;
        b=sL8NwdK34shQcJNNM6irTQQa69JpLqegC1/k+AqvDkoqnG/MOaBsSJPE7fwsIOzkdy
         9GiO9a4L1JqdinJ/wF9JA0JPEmK8FDCeXDEOWY9JkK0NlK38q0pMtDOaRavP/uQKPTYn
         VugfXiCCDD+j7VDx7Eb47W5hd1AzcurDX6gd/AwRqSBu1tl/yISPJt+m3F1Mwmgh0LsZ
         iOgw4PnE8Om+se8Uc++w+I585QQl1PdCR9A0xoS70J/CnITsR78MIonk/RuCixcBlyce
         5sjh+iZLdvSiW/+N3YC+rcRWTlYZ5ZCFy1BcSF5UhaXiwYstsLVz52a8w9dy2HKM4SKG
         u20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792373958; x=1792978758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y7FGjbZkzoe6sSfHIZ7/1NewrsALE0UfgLMmOjZ+FHk=;
        b=Xr7MXnEetiCh7YN/MUgjHSZN86Pj5CyBgeaLs4OhNqkNEoxxTORmNRAqHgrshFKJmS
         NQoMMCw1aBEp/W82JlU/16+xMyc4oTQuBL24PdwzbO2sY2cHEmYQfD8lOgysa17D3wsI
         4g/kjhPPirzONCDXM0zxr351557eKt2iFQYiePBZFzRMvNdJ3Fe8aH8wqmVZFJvpAEKF
         Gxp/UnfaA95+9UgPR5k+LEUojyhOw7MQvzlrBTb0EhB+IR8Tt/cIJQ6p3W4tCHcOBZMq
         ICytQ2QejN7c2lxldW2SI7GgCR3KbOoaVVmvNng/sr1wqjeq4vDeppIYXsF6XaejledU
         P9BQ==
X-Gm-Message-State: AFq9FYKryalQMddr5oR7ELDOqOXXdZ5hc8EYjZVkgjGLi8NqSJu8Fpgj
	Ku7dFfzNrfW7IlU9RJovaKphjSDqy2qf2G7e+Y4r1zwgWZnYlCTVoCYyXa+RVNBEk+2lpfuqaGW
	Su435
X-Gm-Gg: AYBFou03QnTYFouMDKzosA8HGcYVIELn15knRJweJ3RYn7haWz2O+xEFVRLOoCRJwPz
	iDXROicvtq7yOMX/9E+75C4wT+ZTyonSpewX7ucC7CJUWWgjlMyFvp0Wg5+tUYOvc7oSxkzKo29
	7FFOZM7PM/8MO5q4YTUNyzXzAXZygtPmcWNNa5FvdHZqPM8DnKtgrjY9PUH1qRh/VwLUbeOb1zk
	BS7iKskU2z5Z0Ler8t4QVvNjhuXPa5uBY++HRKVUGU6Hp5XV1JFXc6cSOI91xWBapH8315qRdwz
	o9J+TpulDLCeqiiKIzl0+LqiIcbLo08Q/QkF6cJpsMNgtkM+jrpFmhkopLoJTlcMys1GavJN3mG
	ebkzMAI7APEehcqvVYjzN9s2lpO2gifTbrzMSdx9Z6Madtc61UPpuI7hERTDkaub+smHHhD5776
	UzUhH3E9cuSCOvqfc6f0WM72ISwZ63jhIZPyLF2IO3VSJalvf4fwyELbeE8mhk1LXFIb+viMN5M
	wW+jw==
X-Received: by 2002:a17:90b:4c85:b0:3ab:188b:c5bf with SMTP id 98e67ed59e1d1-3aceec79ae9mr5212268a91.18.1792373958258;
        Sun, 18 Oct 2026 18:39:18 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc4972fe6sm13789915a91.15.2026.10.18.18.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:39:17 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: pmcraid: bound the HCAM data length reported to user space
Date: Mon, 19 Oct 2026 10:39:12 +0900
Message-ID: <20261019013912.3729383-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pmcraid_notify_ccn() and pmcraid_notify_ldn() take data_len out of the
HCAM header the IOA wrote into the coherent DMA buffer and pass it on to
pmcraid_notify_aen(), which uses it as the netlink attribute length:

      data_size = le32_to_cpu(pinstance->ccn.hcam->data_len) +
                  sizeof(struct pmcraid_hcam_hdr);
      ...
      nla_put(skb, PMCRAID_AEN_ATTR_EVENT, data_size, aen_msg);

data_len is never checked against the buffer it came from.  The CCN
buffer is 4048 bytes, so an IOA reporting more than 4008 makes nla_put()
read past the end of it, and what it reads is multicast to whoever is
bound to the event group.  The LDN buffer is 4112 bytes and has the same
problem above 4072.

Driving pmcraid_notify_ccn() with data_len one byte past the limit, with
the HCAM buffer allocated by kmalloc() at the production size because
dma_alloc_coherent() memory is page granular and not tracked by KASAN:

  BUG: KASAN: slab-out-of-bounds in nla_put+0xc7/0x160
  Read of size 4049 at addr 00000000622c2000 by task kunit_try_catch/19

  CPU: 0 UID: 0 PID: 19 Comm: kunit_try_catch Tainted: G        W        N  7.3.0-rc7-g58161ead29e5-dirty #5 VOLUNTARY
  Tainted: [W]=WARN, [N]=TEST
  Call Trace:
   [<6008af12>] ? dump_stack_lvl+0x5e/0x7a
   [<6003e621>] ? _printk+0x0/0xd7
   [<6004b21d>] ? print_report+0x14b/0x517
   [<6003e621>] ? _printk+0x0/0xd7
   [<606ffcb7>] ? nla_put+0xc7/0x160
   [<603aeebb>] ? kasan_report+0x11b/0x160
   [<60950e4d>] ? __alloc_skb+0x1bd/0x9c0
   [<606ffcb7>] ? nla_put+0xc7/0x160
   [<603afe70>] ? kasan_check_range+0x0/0x1c0
   [<603affbe>] ? kasan_check_range+0x14e/0x1c0
   [<603b0a41>] ? __asan_memcpy+0x31/0x80
   [<606ffcb7>] ? nla_put+0xc7/0x160
   [<608801af>] ? pmcraid_notify_aen+0x19f/0x440
   [<60882ba7>] ? pmcraid_aen_ccn_oob_one+0x1a7/0x380
   [<60213550>] ? ktime_get_ts64+0x0/0x2c0
   [<606ea77c>] ? kunit_try_run_case+0x1bc/0x310
   [<606ea5c0>] ? kunit_try_run_case+0x0/0x310
   [<603b08f0>] ? __kasan_check_read+0x0/0x20
   [<600af020>] ? um_set_signals+0x0/0x60
   [<600af020>] ? um_set_signals+0x0/0x60
   [<6012e3cd>] ? __kthread_parkme+0xdd/0x1c0
   [<606ea5c0>] ? kunit_try_run_case+0x0/0x310
   [<606f0840>] ? kunit_generic_run_threadfn_adapter+0x0/0x100
   [<606f08bc>] ? kunit_generic_run_threadfn_adapter+0x7c/0x100
   [<6013464e>] ? kthread+0x36e/0x560
   [<601342e0>] ? kthread+0x0/0x560
   [<6008f0de>] ? new_thread_handler+0xce/0x130

  The buggy address belongs to the object at 00000000622c2000
   which belongs to the cache kmalloc-4k of size 4096
  The buggy address is located 0 bytes inside of
   allocated 4048-byte region [00000000622c2000, 00000000622c2fd0)

W is a UML virtio warning and N marks the KUnit harness that drove the
call; neither comes from this path.

Clamp data_len to what the buffer can hold before it is used as a length.
A working IOA never reports more than that, so this does not change what
user space sees from one.

Found by inspection.  Not tested on a MaxRAID adapter.

Fixes: 89a3681041507 ("[SCSI] pmcraid: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID controller")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 942a993932049..f59d5a775aebb 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -1451,6 +1451,17 @@ static int pmcraid_notify_aen(
 	return result;
 }
 
+/* The IOA picks data_len, so cap it at what the HCAM buffer holds before it
+ * becomes a copy length.  Returns the size to report, header included.
+ */
+static u32 pmcraid_hcam_data_size(__le32 data_len, size_t hcam_size)
+{
+	size_t hdr_size = sizeof(struct pmcraid_hcam_hdr);
+
+	return min_t(u32, le32_to_cpu(data_len), hcam_size - hdr_size) +
+	       hdr_size;
+}
+
 /**
  * pmcraid_notify_ccn - notifies about CCN event msg to user space
  * @pinstance: pointer adapter instance structure
@@ -1460,10 +1471,10 @@ static int pmcraid_notify_aen(
  */
 static int pmcraid_notify_ccn(struct pmcraid_instance *pinstance)
 {
-	return pmcraid_notify_aen(pinstance,
-				pinstance->ccn.msg,
-				le32_to_cpu(pinstance->ccn.hcam->data_len) +
-				sizeof(struct pmcraid_hcam_hdr));
+	u32 data_size = pmcraid_hcam_data_size(pinstance->ccn.hcam->data_len,
+					       sizeof(struct pmcraid_hcam_ccn_ext));
+
+	return pmcraid_notify_aen(pinstance, pinstance->ccn.msg, data_size);
 }
 
 /**
@@ -1475,10 +1486,10 @@ static int pmcraid_notify_ccn(struct pmcraid_instance *pinstance)
  */
 static int pmcraid_notify_ldn(struct pmcraid_instance *pinstance)
 {
-	return pmcraid_notify_aen(pinstance,
-				pinstance->ldn.msg,
-				le32_to_cpu(pinstance->ldn.hcam->data_len) +
-				sizeof(struct pmcraid_hcam_hdr));
+	u32 data_size = pmcraid_hcam_data_size(pinstance->ldn.hcam->data_len,
+					       sizeof(struct pmcraid_hcam_ldn));
+
+	return pmcraid_notify_aen(pinstance, pinstance->ldn.msg, data_size);
 }
 
 /**
-- 
2.43.0

