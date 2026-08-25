Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AC046F495
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672703; cv=none; b=tHUr5IKPoeCOMSz5ymGEkpkS/qZYN9u14GuDE81pqNEe6xfostol+RtdgpKOrRHMvU2+JnU3dY2bcaG6K2iNqVEfaFhC06cXjZwhyMZPoKw0mTNo8TJEncag79iSF0qlo2bjrTWMDoB2EjKkg1jgzHHtfEzhr338nUNFILWtUJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672703; c=relaxed/simple;
	bh=gJnJ1GzOc3NtBEprkN9G/2QdIQK0xy19eLiyIKOiVzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioW7yCI5kSdTE+8dO06b2y9YlMvWKQGOjH+hPzFMYTCNJqZFBy1Mb7aaZyJk6P0A6JMKFzSlFVb/AnbInqzTiNF6aOWn9dK0ywfZNWfd9NJUrAUVPzWmlPNGONRhQHjGDCr7+0y3lJJqVhcpv/lUOCuTtt/qEPhnksXslO6PfHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Oav/dkvP; arc=none smtp.client-ip=209.85.210.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Oav/dkvP"
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-84eb992a881so3807485b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:45:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672701; x=1788277501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7R/YatEY/NQk3B4Uzfvq1K+K+6aL4J3sbQFv6Yj+giU=;
        b=XtKg7nCLg0fKBSvtWMLIJdKpu7WiMjDsEURMApCoR4TcdzcbM0h6KSHfNhmHLV4+dC
         1pkNkHAbgkeQM74D1JfsTnoqa3BXcz5XQzzoLZn0FRy/2FNRXeoBaZ8UIewTD6EYM2ID
         a9fjx84wp9uKG0dnR//SlZFrSVQxrhvCZCaMtbnNVYu4IzRHAcHz/GrnjkDlqZFdWhtx
         puVJV36R+hKqP2UwTvIJMEYFsYhnU42EQV0U0Pzvx6wmqQYQe7aJfWOE34eJ65MiKj6X
         VO0Xnk+/XKDB3e2OQdR6JeFVy4pU2l+oHZd8SrkNAB8mYkH7ZbjvzyE2bSvTpee/3aBy
         ZthA==
X-Gm-Message-State: AFuF++kWOFPvca+l3IljaXDElya+h3h9oSVC389mlvVYjZPu77m1Kksw
	bc31Qnv7ClTA/dhQvGfUNny6GWmd6upJM0jS9yVuAYwf7Uh8DtRpitmBVdmlGDZ2qZ4sXy6ibr2
	FGKQ7CslNnZn/rtLCR59g5wX7xjt/D65ZXGad6JCVJLrzRM+cF4UfUMS258GtulHB81eYSQhPBY
	yAA8pV0Fs2K8QspRq3YhORNgD3mKzJbVYsu1PXNZ8GbYLpILo7NlOXGToOAnKIdFX3yCoZyAfRq
	y3UxMo6FM3taORDaEO2ZjjR
X-Gm-Gg: AR+sD13iBFy99YLt92OPVwR1zSjnrmLnrT17uNIra9C7kYZrqjDdzjLaIQ/kO0OM0xR
	cuVFHUr+zD5nt9VdwCCDscJjzVkT/HDv6Iqk8kH5SmZAXU5Z0OGqYeQUHcg4vNArf5lWjGFpPPX
	aNYFHxL9pApyRwgGVpKp2KCcYOsofr7F4fWcDgqsQyfiAYvj8KZo00aD4QIEAP7o4/Y39af2VOs
	mPxBK1AkaiSS4qwmtnl2x8alPF5SVkZp8HFnIa+Yzq0Q8KxhhVlJxRpY+JTYlFLq7ghXYCOEUpv
	jEN+j1ATkYoa0Fr8VvkSYBHF/aHupxQVCr8asO45QXAH923SWq9/wlm27rocrutppRbDHiUPaw9
	w+P9nFmCXH2GEeIH2UShtxZKgUPEG6lgLBi1xH38Ekq8QdPmAKnI7qdpZ6YUWBP4G/pa3cSGHyT
	EgBKvU9khEZ01PRjzrnAYD6gOauD7a5UpsmR7zfdNUUIk=
X-Received: by 2002:a05:6a20:6f8f:b0:3c3:a31b:3949 with SMTP id adf61e73a8af0-3cd911bf820mr17538580637.11.1787672700702;
        Tue, 25 Aug 2026 08:45:00 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc199dc87adsm1267948a12.4.2026.08.25.08.45.00
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:45:00 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e11baa66eso7350888a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672699; x=1788277499; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7R/YatEY/NQk3B4Uzfvq1K+K+6aL4J3sbQFv6Yj+giU=;
        b=Oav/dkvPENbEJ3Myp6ovcJEOoykblgsRnJwKdQrXw7mfkEVxF/uec350ikSnxKIfMD
         C40iKE8COfo3Ng+6RUEbUrKoqjZsdH30YNyE97r2BpfVf7JGLKeJunVH8P7WcL9Wvd7+
         JI9Lc5U+23PonEw/WBJ69cKn/WCQT9yDfhWeY=
X-Received: by 2002:a17:90b:3b52:b0:396:602a:5bb6 with SMTP id 98e67ed59e1d1-3966d20f12cmr152683a91.8.1787672698837;
        Tue, 25 Aug 2026 08:44:58 -0700 (PDT)
X-Received: by 2002:a17:90b:3b52:b0:396:602a:5bb6 with SMTP id 98e67ed59e1d1-3966d20f12cmr152576a91.8.1787672698230;
        Tue, 25 Aug 2026 08:44:58 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:44:57 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	sumit.saxena@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH v2 11/17] mpi3mr: Fix out-of-bounds read of event data
Date: Wed, 26 Aug 2026 02:34:05 +0530
Message-ID: <20260825210411.301535-12-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
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
v2:
 - No changes from v1.
 drivers/scsi/mpi3mr/mpi3mr_os.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6a80b784200b..65a6192cf396 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3118,7 +3118,7 @@ void mpi3mr_add_event_wait_for_device_refresh(struct mpi3mr_ioc *mrioc)
 void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	struct mpi3_event_notification_reply *event_reply)
 {
-	u16 evt_type, sz;
+	u16 evt_type, sz, avail_reply_room;
 	struct mpi3mr_fwevt *fwevt = NULL;
 	bool ack_req = 0, process_evt_bh = 0;
 
@@ -3179,7 +3179,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
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
@@ -3213,7 +3218,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
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
-- 
2.52.0

