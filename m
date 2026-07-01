Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4649638D40C
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 04:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782878640; cv=none; b=YN8XpOfX/x9NVhE8kcY21o6N4WY5tfeDGHts2l7qu/hx7U6+4PhCnrwpWxt6YRwnnZxy3NxRnjeUZGUJ6cmgU8oUgjtNYBlelffDecd9nN2L23Wk/8JBw6PxU95lit6nmt4hJSdvsF8sE5WArvGej55gc5qPQNSSDcgI6UzerQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782878640; c=relaxed/simple;
	bh=p5NgUKZ2hv+769HgwMAjnNfNVsr0gFeP4zwmzFI1fxE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QN/MIAJRtPdu3xoVGBNVFhrYsslqE8B/qZgo+dT87Il5ILZWSk5kUMjwrwIFJbjzjjuBu66vmQK2wSf8yTTdwwjVkFYhw+zv0+05Uap1gCvZ1FUmyxSsjbsxdHDRxYAYrkCLHb9kmNDARMoj5G3hJwhayo8IE5s3qud02fwEbCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=LJqpIWCx; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LJqpIWCx"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2c9dbd00f1dso1115705ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 21:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1782878633; x=1783483433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b+K/6nqTz+KsszBu+0AY+5reuM2Ql/csxHaZ7h5OS08=;
        b=LJqpIWCxzoAYKbblN5NG6MiaME1e5FBkthIfNxI4HsVuK4CC9SM23OWHkAYYA2ZZQ2
         kYHW/v8Ok54JfH5HdJsH4i8ci0gkFPNRhPUIPNrMPZGeGo7iKsBKubTgAmYcH8ZmNZUi
         peVy3uKaX0/smSqmTBDEFyVYlkSn/OJIr2A3Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782878633; x=1783483433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+K/6nqTz+KsszBu+0AY+5reuM2Ql/csxHaZ7h5OS08=;
        b=bYifdD58wnV2EBQ4aHmq0EjcJ2UH1YoEX+Pde/NKxH/6cd5T0V4T9qOlWzqJ71Do7O
         4YzvFCg+KhAVxN653JouqUvRfLbehSAj3MJro8B2pzejY03URPJqMrmGfnH0pA+vkfXD
         N+FyIdJfXvHZv72n+DSV8mMRCGW8JO3OZ+61Oht7ae247Pix3nVJuxJ1VgQGyGV0hlFq
         NEL+h3C1YroAsY+Tqre1sDKHeb0PRJeklAk5gsID+lPhLRwhKr0ss4PLoAN6EC0cL725
         N8agz8/LTXGC2HPkUFzNHOXjCPd4aTG743IsVi/NJwkDlSGKhp8BHNo37W9/8Bw18Xnc
         ESMA==
X-Forwarded-Encrypted: i=1; AHgh+RqpQHCZGqz79yWiyFCBW9xdJ3t6Jtn2E28RxHYy2sn065arwzpxDv2poFPbAg0vi3I9UAiLzkENWSgD@vger.kernel.org
X-Gm-Message-State: AOJu0YyP1tAreF5Yl64dSThbp2M2ZOdcvW9zX3UqnQmPdbpFkpBtZjfh
	nTwuk9JVEVfKpkpRkkHM9oITsDS1DZzuiwfZHxoFwEMtqQ4ANCED9oMeV/Smv6X7zA==
X-Gm-Gg: AfdE7clAXhqMGQnkQg10W0ef5YS42WZ7GDtMFBrbnfGRnxjSfXAplr8kcNOerhIyYYd
	Iw3lKkMOvUhvssYVd8hdrVkq3RB54IG/3jojxTVEq+Wg9aP56FLIqY0ynkpwByQ8b5rvYE1Up+S
	omOZZs9yx2iUBM8fH1sRTCfQprbMCd+IH3TdwTN4CFOSDoicY5v1KHLtfH5vd1/OcsB9JhxJEX1
	rJvgCehLc/VZ3DVLIagWSnJb5bVZxuDRFF4l+l+7vC9vHZgdxR8w2Q8Ye/J30olWQ2MQHRuvMj8
	zy+ZhbGTB4DuRj0ymv0iMj+nPF7tw/3tSG1Hr8EoHzccJ4f6QY2vQd96cXqL34D31gcPefPZEa3
	Qwjn7m+aX1INhE0+EU4ybejSRKCtlX6Ddk38dBkXcVcQgdbnLocSTk7NJYxJ8oIpumSU7xWVvU5
	QDzDdvNMwqD48aSjdk1aDRS7TFZpM2ike4yCvEb1XByFtjkNmwYr0Cmx4f/rNb3L64wM9/eb7W2
	1A=
X-Received: by 2002:a17:903:291:b0:2c1:f262:4962 with SMTP id d9443c01a7336-2ca7e6da0c0mr963905ad.20.1782878632576;
        Tue, 30 Jun 2026 21:03:52 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:1379:da2f:9be6:bff2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca382bb30dsm23927835ad.68.2026.06.30.21.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 21:03:52 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org,
	Tomasz Figa <tfiga@chromium.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [RFC PATCH] usb: storage: uas: limit consecutive device resets in error handling
Date: Wed,  1 Jul 2026 13:03:21 +0900
Message-ID: <20260701040335.810297-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a UAS storage device experiences persistent wire or hardware IO
failures, commands time out and the SCSI error handler thread invokes
uas_eh_device_reset_handler().  If usb_reset_device() succeeds at the
USB hub level but the underlying drive remains unresponsive, the reset
handler returns SUCCESS. SCSI EH then requeues pending commands with
DID_RESET (ACTION_RETRY), causing them to time out again 30 seconds
later in an infinite loop.  This blocks block layer queues indefinitely:

[..]
 sd 0:0:0:0: [sda] tag#4 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD
 sd 0:0:0:0: [sda] tag#4 CDB: Write(10) 2a 00 00 d3 98 08 00 04 00 00
 sd 0:0:0:0: [sda] tag#0 uas_eh_abort_handler 0 uas-tag 2 inflight: CMD OUT
 sd 0:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 00 d3 9c 08 00 04 00 00
 scsi host0: uas_eh_device_reset_handler start
 usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
 scsi host0: uas_eh_device_reset_handler success
 sd 0:0:0:0: [sda] tag#3 uas_eh_abort_handler 0 uas-tag 3 inflight: CMD IN
 sd 0:0:0:0: [sda] tag#3 CDB: Read(10) 28 00 00 00 00 00 00 00 20 00
 scsi host0: uas_eh_device_reset_handler start
 sd 0:0:0:0: [sda] tag#1 uas_zap_pending 0 uas-tag 1 inflight: CMD
 sd 0:0:0:0: [sda] tag#1 CDB: Write(10) 2a 00 00 d3 98 08 00 04 00 00
 sd 0:0:0:0: [sda] tag#2 uas_zap_pending 0 uas-tag 2 inflight: CMD
 sd 0:0:0:0: [sda] tag#2 CDB: Write(10) 2a 00 00 d3 9c 08 00 04 00 00
 usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
 scsi host0: uas_eh_device_reset_handler success
[..]

Introduce a runtime-configurable module parameter 'reset_limit' (default
3) and track consecutive resets in devinfo->reset_cnt.  When a productive
block layer command completes successfully (SUBMITTED_BY_BLOCK_LAYER),
reset the counter to zero.  If consecutive resets exceed reset_limit,
abort the loop by completing pending commands with DID_NO_CONNECT and
returning FAILED.  This allows SCSI EH to offline the unresponsive
device.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/usb/storage/uas.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 265162981269..a63c66c8bbad 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -32,6 +32,10 @@
 
 #define MAX_CMNDS 256
 
+static int uas_reset_limit = 3;
+module_param_named(reset_limit, uas_reset_limit, int, 0644);
+MODULE_PARM_DESC(reset_limit, "Maximum number of consecutive device resets during error handling before failing");
+
 struct uas_dev_info {
 	struct usb_interface *intf;
 	struct usb_device *udev;
@@ -40,6 +44,7 @@ struct uas_dev_info {
 	struct usb_anchor data_urbs;
 	u64 flags;
 	int qdepth, resetting;
+	int reset_cnt;
 	unsigned cmd_pipe, status_pipe, data_in_pipe, data_out_pipe;
 	unsigned use_streams:1;
 	unsigned shutdown:1;
@@ -255,6 +260,8 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 		return -EBUSY;
 	devinfo->cmnd[cmdinfo->uas_tag - 1] = NULL;
 	uas_free_unsubmitted_urbs(cmnd);
+	if (cmnd->result == 0 && cmnd->submitter == SUBMITTED_BY_BLOCK_LAYER)
+		devinfo->reset_cnt = 0;
 	scsi_done(cmnd);
 	return 0;
 }
@@ -796,6 +803,21 @@ static int uas_eh_host_reset_handler(struct scsi_cmnd *cmnd)
 	usb_kill_anchored_urbs(&devinfo->cmd_urbs);
 	usb_kill_anchored_urbs(&devinfo->sense_urbs);
 	usb_kill_anchored_urbs(&devinfo->data_urbs);
+
+	spin_lock_irqsave(&devinfo->lock, flags);
+	if (uas_reset_limit > 0 && devinfo->reset_cnt >= uas_reset_limit) {
+		devinfo->resetting = 0;
+		spin_unlock_irqrestore(&devinfo->lock, flags);
+		uas_zap_pending(devinfo, DID_NO_CONNECT);
+		usb_unlock_device(udev);
+		shost_printk(KERN_ERR, sdev->host,
+			     "%s FAILED reset limit %d exceeded\n",
+			     __func__, uas_reset_limit);
+		return FAILED;
+	}
+	devinfo->reset_cnt++;
+	spin_unlock_irqrestore(&devinfo->lock, flags);
+
 	uas_zap_pending(devinfo, DID_RESET);
 
 	err = usb_reset_device(udev);
-- 
2.55.0.795.g602f6c329a-goog

