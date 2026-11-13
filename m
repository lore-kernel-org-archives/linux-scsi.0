Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794530146;
	b=M6R0DwpMh56qDgt3i3klGTkWZQZE9cSOGRHHC6yozEpk+TMBDN9yhgy7fHhLoSwn2rNW
	 YSKRVQc+xoL7xCnnqt5Zu6I0kqbD/XAtlbIlaRmEPthYods5uTFzCQwBkkVENTH4uWVHt
	 QPaKOEoq/DDqpt/dwT/cIyLvUPFDfsimZei1KTgnbvFqXmQnxSjcGYOIK6Iyr9Z4xka0S
	 oKDIWg2Bh+dSq5zzxsUa/ZR3GeBV+IylakQvp7OSQ59PSPUmKXF8jpyRtESgYy7r9ccpV
	 xZqHYl9c6nykBj90cZK+CxDsfNC6WG4hqL7vesa0ZhLQKFWunXIWIPNHt38vkk5O2bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794530146;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=8O2rqQe37Ap0D9XOCLpMKH/b4xU4kX+ufh8uf0elaoo=;
	b=jbd7go0ud7K2QiP3CllKWteKyIq4dGb87zQW5mKh2oGBO+YSO/BLPbWJ4UFLNr2Ixlav
	 GHaTFVR7QUwE7uIf/2CFadlsMQVsHixLZIG7FTl+4aIJ6oMixMZFEzunkOKBeOWdEXrh7
	 V/QTlaqQZ+0OBGbvUI9hN36vq/+ED1GHhoDyryex92XggrK9B45zrVQcLwz/I5bsHwrfx
	 Rlg2piE9cDIrM2cl5052qinRqRta2Fov5UUx5LPC/o6XfnJF7s8nwrBgVE5QUsInUqm7I
	 esLeVX6JirIVrn/RjZWL/knf4aJKMttlwXo2hBrrT2diGu+28VQkH3/UNK0culpc9Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pr7ecsZG;
	arc=none smtp.remote-ip=209.85.214.198
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC928606B7F3
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 00:35:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC928606B7F3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sarthakkukreti.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pr7ecsZG
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e9501034c4so6823325ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 16:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794530145; x=1795134945; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8O2rqQe37Ap0D9XOCLpMKH/b4xU4kX+ufh8uf0elaoo=;
        b=pr7ecsZGvUtYZt2F88GEhZAXyVRfob6OO+ROkRbfMcnWklsSxclypci8XpB8Ekr0MP
         KoSewPODLpsgPUe8uPmpQgw/DPElcgzxooSfLOyDSWhLQ86p9YFJ4Aw5f0yJye9iPlGY
         8mTyKB8eGwNsHy2TaGyR3hK3gQy9JBzm7P6vkRKNH6RzeW9QK3Q7a43DQ4Iv5qkudomq
         PZPu+OwNc6mA5PBXNV5uXk6WEbamoUVgQFU/3bPjxNvpbznrTgmWvST3XM1vmEutqS7h
         sVoL+s91IhUp5pNlDVqspW09BMm7Nf0NBdAY3w0q0FLGeEpeCFLLCAFrALM/j9fWrvUP
         rk1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794530145; x=1795134945;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8O2rqQe37Ap0D9XOCLpMKH/b4xU4kX+ufh8uf0elaoo=;
        b=lyx0ZiddGmURsoO9B/A8YQRt7c9Mx0nDD2ZkcAoDqNVLsGvkBzGmPMQ1i23/dZ3CrP
         JsSX+N2woFJgUD5p2nA2Qp8GVdUMm1+2aJZqZWrOnnd1VLgiSK09gH1hMhakGYJoEH4b
         uWu9bgSFePBvQKXmKgt/0TZ39DoE3cVCk9GBF7LLPFZuOB56Kvq5u2ghIS21VozoGPih
         r/OWnXAPZlif7Vv6OxUanBrWZy6ncQpZ97XMVM9LYr5doLCOXlHb7No4XoR2S7ihhvO1
         6Ox3yV/v7X/XLIdlEaw7P1v+vGsTwdcVkBJv97bViSRBkpNPGQ5AF4bVroZS78gq29Hs
         mjqw==
X-Forwarded-Encrypted: i=1; AL+hErG48IxA1imyNR1AdpZKrmzGAwOING6faOSj+DMYd8WsxeR4xy6LwhvnVAijXJHCQIUl3YnzAkrQsKLS@vger.kernel.org
X-Gm-Message-State: APuU4Z/hbI0Ezo5RogkyTFSI+ibAcgYlmd8y3r070koUuYjleDG4DXOE
	Dn+qZmg++nAMN2w+6jnShYhcRjaOgjryzljUfz2nEvEwA52m7xLffqFHvdH2A6WZ/bGdBF0JThG
	B71yiij3zTf7kLumGaMWhMBbrE6Riaypsxdk5Iw==
X-Received: from plfh1.prod.google.com ([2002:a17:902:f541:b0:2ea:ff0c:b0a7])
 (user=sarthakkukreti job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ffcf:b0:2e7:4a2f:68e6 with SMTP id d9443c01a7336-2ee0de29212mr9523355ad.39.1794530144817;
 Thu, 12 Nov 2026 16:35:44 -0800 (PST)
Date: Thu, 12 Nov 2026 16:35:34 -0800
In-Reply-To: <20261113003536.3622755-1-sarthakkukreti@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261113003536.3622755-1-sarthakkukreti@google.com>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261113003536.3622755-2-sarthakkukreti@google.com>
Subject: [PATCH 1/3] usb: uas: complete inflight commands on status URB error
From: Sarthak Kukreti <sarthakkukreti@google.com>
To: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Sarthak Kukreti <sarthakkukreti@google.com>
Content-Type: text/plain; charset="UTF-8"

When a UAS device is unplugged while hub_wq is frozen during system
suspend, usb_disconnect() is deferred and sd_sync_cache() issues
SYNCHRONIZE_CACHE to the disconnected target. If the status URB fails in
uas_stat_cmplt() with a non-unlink error (such as -EPROTO, -EILSEQ,
-ETIME, or -ESHUTDOWN), uas_stat_cmplt() logs the error and frees the
URB without completing inflight commands, leaving SYNCHRONIZE_CACHE
pending until the 60s SCSI timeout and triggering the 25s DPM watchdog.

Complete inflight commands with DID_NO_CONNECT in uas_stat_cmplt() on
non-unlink status URB errors while not resetting, and unlink inflight
data URBs outside devinfo->lock. Preserve non-DID_OK host bytes in
uas_data_cmplt() when the unlinked data URB completes.

Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
---
 drivers/usb/storage/uas.c | 47 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 265162981269..5aa369087295 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -310,9 +310,49 @@ static void uas_stat_cmplt(struct urb *urb)
 	bool success;
 
 	if (status) {
-		if (status != -ENOENT && status != -ECONNRESET && status != -ESHUTDOWN)
+		if (status == -ENOENT || status == -ECONNRESET)
+			goto bail;
+		if (status != -ESHUTDOWN)
 			dev_err(&urb->dev->dev, "stat urb: status %d\n", status);
-		goto bail;
+
+		spin_lock_irqsave(&devinfo->lock, flags);
+		if (devinfo->resetting)
+			goto out;
+
+		for (idx = 0; idx < devinfo->qdepth; idx++) {
+			cmnd = devinfo->cmnd[idx];
+			if (!cmnd)
+				continue;
+			cmdinfo = scsi_cmd_priv(cmnd);
+			if (!(cmdinfo->state & COMMAND_INFLIGHT))
+				continue;
+
+			if (cmdinfo->state & DATA_IN_URB_INFLIGHT)
+				data_in_urb = usb_get_urb(cmdinfo->data_in_urb);
+			if (cmdinfo->state & DATA_OUT_URB_INFLIGHT)
+				data_out_urb = usb_get_urb(cmdinfo->data_out_urb);
+			cmdinfo->state &= ~COMMAND_INFLIGHT;
+			set_host_byte(cmnd, DID_NO_CONNECT);
+			uas_try_complete(cmnd, __func__);
+
+			if (data_in_urb || data_out_urb) {
+				spin_unlock_irqrestore(&devinfo->lock, flags);
+				if (data_in_urb) {
+					usb_unlink_urb(data_in_urb);
+					usb_put_urb(data_in_urb);
+					data_in_urb = NULL;
+				}
+				if (data_out_urb) {
+					usb_unlink_urb(data_out_urb);
+					usb_put_urb(data_out_urb);
+					data_out_urb = NULL;
+				}
+				spin_lock_irqsave(&devinfo->lock, flags);
+				if (devinfo->resetting)
+					break;
+			}
+		}
+		goto out;
 	}
 
 	idx = be16_to_cpup(&iu->tag) - 1;
@@ -428,7 +468,8 @@ static void uas_data_cmplt(struct urb *urb)
 			uas_log_cmd_state(cmnd, "data cmplt err", status);
 		/* error: no data transfered */
 		scsi_set_resid(cmnd, sdb->length);
-		set_host_byte(cmnd, DID_ERROR);
+		if (host_byte(cmnd->result) == DID_OK)
+			set_host_byte(cmnd, DID_ERROR);
 	} else {
 		scsi_set_resid(cmnd, sdb->length - urb->actual_length);
 	}
-- 
2.56.0.611.g1030f0b940-goog

