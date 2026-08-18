Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BAF45FFAC
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075869; cv=none; b=ZSNfqzkGD1P+CuL0G966FrvXMYqLvHu3++t2X7EnnI0Oj4hFQv8XDrB2QztGKUl1mhzVIsC+5+gMHzrjjcxdGILRedScDvcSHhcTHJFjMRtYeYG5hgDHO20Xx7nglW4Icp4tCymuTQmeBxp6dpK/BqSGyRagtfxDkXk9n+id4iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075869; c=relaxed/simple;
	bh=flgIZyeonFLSvNvTj1D+RHMBBnENll0BGMLmfxgy1FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUz9zlHIpAqvct8SoOGtk7ASvxZBoK/wk4Lm+RwNVMPL1VTfbsDxVKQ3A1ZgjV44ArtOJlDgfqI+yqwKdBHPqqnXbOCIYiZhjgrsxcaJOWOIGmqERrRWP2wPpogpvbUnIBAJq657iYd9LRbCIBZ46g42gDzmcb+Qk/w7dld/3jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Wl68XtNl; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Wl68XtNl"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so239429a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075867; x=1787680667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gfxWmERZRcTUnHhZyNINd6zEzSAx2QcrQQ/ZlFPMsKM=;
        b=SViTbzdK3UzbrsBwD3yTROXXyNjWixan8dd2vLxdRa0Ig93AkZrO/NgXXHM6T/+68i
         XlxT/vrIKDontELshcI0is2VzXDYDBMtUqRCAzPFk9Ri70D8x4/xYf84XhQGmMA7UMjJ
         IV7ZgxZxcHBKMCh+rC+TnfHIc2cYKotw11cvGf01+4l9oHe7CdUwJSHtJ49WRq5CefY+
         midqe+lY85QvEEUgw/U7iGEnQMXKO29dGVitiyvams6JJvMTCzd/EDUhhPq16yxdGpBu
         K2gBR8fHgOzwBBrUA+XhYwZ38sLAnYoLPQsQrjLzhy5SIhpH+JtESupCdGF12cGBSVMH
         hJag==
X-Gm-Message-State: AOJu0Yx8EW58V6Wu6RVcMcOecfdTF3A84ezWKRAxCx9RX8M3AoNz/0ly
	7jtb8F9j99MOr/enq3XS8l9OCqj+F6/VwjJG+Q2/fhMprxwtP3oArFk9NiqLg8oAXyNh3PFmPkW
	HNISI+Mgr628toAfMpNUnfNSWjFIkLxhZjBA55U8LM4Savks0EJ2oyQgL6IA7+9aHItekEXnJVW
	W4IPAVLlm8/lU+BsVTjbsVnheqwt/zDEIpXP4F7j4oIKLgc8KmURoN08oTnsFuUPodyyYpHz/Nz
	Gd+CoSwmfWXvzFi2/Lvlswm
X-Gm-Gg: AR+sD12V4T3RZbOzuuGvmLcSw00cFg/m5kEmHWN3jszCP3ArQ9iDuN5ivd0neStD8Jq
	ouMqOUuUVmh9JqqMi2eY1XNGY6dkdcrHgtvcRJOftg0Ay5t/nE4uTGnuP6UP5KUPI8A1AYebdC5
	9uGQQl0RQtIH4ogiZORxR1nQvGgFkq10FD2zXLkqy4yH7yVzJXp7ycz9KUEF0xaoXN+3BTfIi/t
	v9Q6KOr6FcSB2SntKo5uygpgOAdCv+0GbYJiSW0RJv6sPaixf6/dZk/rKNED4ZbNvNQdDmF2eHs
	A+tSWTb9LoMxvPJthLQjMIk5K/yoaEnBTyct0b5VbRmaYUudvOZOA1bSuEejejDuOeQ2nTTaY7I
	n+m8Y8wUKnXqmsRtLqoEalndmkcWKu8Odjxn4YOR+6JcV/hCiWX8S9dua49tudDgG40nb8KRzEt
	xu2A/B1OyZymyvsrWje4Ics72BBg8UN6RIfl+cZCw56ww=
X-Received: by 2002:a17:90b:3c02:b0:380:f389:447b with SMTP id 98e67ed59e1d1-3933b8938f9mr40576591a91.11.1787075867351;
        Tue, 18 Aug 2026 10:57:47 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-19.dlp.protect.broadcom.com. [144.49.247.19])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3954d176bfesm2724155a91.0.2026.08.18.10.57.46
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:57:47 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e7ff7b375so283692a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075866; x=1787680666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gfxWmERZRcTUnHhZyNINd6zEzSAx2QcrQQ/ZlFPMsKM=;
        b=Wl68XtNlzhnAdrusOOdpr47irgYT2JpNNRpy9WVsinAJNkn8K2d6rSEYSHeIENDt2e
         ReFxrO/xWRKgTWB2g+G95cShcSopJboksTAoYUV0Ritbqanv8BKNEc0aKwgn1Dg0flZg
         I/bYknlt41mqJF+9QK5TQBU8kLelwGmXnZMK8=
X-Received: by 2002:a17:90a:dfd0:b0:38f:23d6:b4ad with SMTP id 98e67ed59e1d1-3933b792985mr37927134a91.8.1787075865613;
        Tue, 18 Aug 2026 10:57:45 -0700 (PDT)
X-Received: by 2002:a17:90a:dfd0:b0:38f:23d6:b4ad with SMTP id 98e67ed59e1d1-3933b792985mr37927070a91.8.1787075865075;
        Tue, 18 Aug 2026 10:57:45 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:57:44 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	ranjan.kumar@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 11/17] mpi3mr: Fix out-of-bounds read of event data
Date: Wed, 19 Aug 2026 04:44:20 +0530
Message-ID: <20260818231426.58105-12-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The event data length from the reply is used as is, both when caching
log data and when sizing the buffer handed to the bottom half. A length
larger than the frame makes both of them read past the end of it.

Clamp the length to what the frame can hold.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Fixes: d0d19250ed81 ("scsi: mpi3mr: Rename log data save helper to reflect threaded/BH context")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 94625e5f6af8..6d4ddc78bcd0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3109,7 +3109,7 @@ void mpi3mr_add_event_wait_for_device_refresh(struct mpi3mr_ioc *mrioc)
 void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	struct mpi3_event_notification_reply *event_reply)
 {
-	u16 evt_type, sz;
+	u16 evt_type, sz, avail_reply_room;
 	struct mpi3mr_fwevt *fwevt = NULL;
 	bool ack_req = 0, process_evt_bh = 0;
 
@@ -3170,7 +3170,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
 	case MPI3_EVENT_LOG_DATA:
 
-		sz = event_reply->event_data_length * 4;
+		if (mrioc->reply_sz > offsetof(struct mpi3_event_notification_reply, event_data))
+			avail_reply_room = mrioc->reply_sz -
+			    offsetof(struct mpi3_event_notification_reply, event_data);
+		else
+			avail_reply_room = 0;
+		sz = min_t(u16, event_reply->event_data_length * 4, avail_reply_room);
 		mpi3mr_app_save_logdata_th(mrioc,
 			(char *)event_reply->event_data, sz);
 		break;
@@ -3204,7 +3209,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		dprint_event_th(mrioc,
 		    "scheduling bottom half handler for event(0x%02x) - (0x%08x), ack_required=%d\n",
 		    evt_type, le32_to_cpu(event_reply->event_context), ack_req);
-		sz = event_reply->event_data_length * 4;
+		if (mrioc->reply_sz > offsetof(struct mpi3_event_notification_reply, event_data))
+			avail_reply_room = mrioc->reply_sz -
+			    offsetof(struct mpi3_event_notification_reply, event_data);
+		else
+			avail_reply_room = 0;
+		sz = min_t(u16, event_reply->event_data_length * 4, avail_reply_room);
 		fwevt = mpi3mr_alloc_fwevt(sz);
 		if (!fwevt) {
 			dprint_event_th(mrioc,
