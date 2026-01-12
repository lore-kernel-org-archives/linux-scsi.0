Received: from mail-vk1-f227.google.com (mail-vk1-f227.google.com [209.85.221.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E964B30F959
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 08:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768205834; cv=none; b=a1GJmM/jN83Ln3/6EClU80+DvKeYYFlaubC6SStA6DTqIFA6iAJe0YG4Gnv391Uo7pwSqHx/n6abMoHadwZcx1DesdghYtwVhgUMfNjEmk9UBAZ+u9LIJBZwZgMenFrpr7g47bF0Ia8rMLddJDgjU3vpIaFI6440ZmmyTSZbXD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768205834; c=relaxed/simple;
	bh=iwkru/jAhMFds4hkPIyv3TUGwNbaIraOztW61MyAvtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lq/CEncj7uYfxxFQR9gslopL3GusKIE8HjH0qwLKkH4SfLH7PKl6B+PjOaS42jMzFtqLCWv8HyJl/Qdu/YJB/WOAPhzw0eivCNtstK1EPPJU+MAlPNChtZZ/WQWuKRfgvhIPnf/i6x2g0GS4gUQTC3FyeJHp/yH1fN5dNL0zdbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Jr06Cjtx; arc=none smtp.client-ip=209.85.221.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Jr06Cjtx"
Received: by mail-vk1-f227.google.com with SMTP id 71dfb90a1353d-5636784884eso685300e0c.2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 00:17:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768205832; x=1768810632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fdW5gEOdqWA5xgWHnEM8utKtfZOt0NSBcNP+5uNcuMM=;
        b=VwsGupcM+BrhgbjNKK641q5E414uFcVHgQyzUzp/AsVNa3bZj1/CQptUdH79PYBDEP
         WYvzHOkjJjEMI8+Y6KwCeU3elB/id4GiFgMGJk/fDNF8YbcWKNjCvpDyLIPVidycZfZj
         l1ClXVrp5aXYmLQwSI9XGqmgJ59m00Pya/B7YEnIFJD7ZVVeUofUav1iTzU1WwqfwuOT
         83Qy4nPwPBJZqx0S3qKz3Aqv+Ad0I0r4t4HXVSY4FWgPn27+0T/+zozzZ5sazfzUuqyL
         6jItHhN/3vXeqGlpBKHSHB3zxBEEnW/LGtYz7QJFD208RGr2BV1re9t2ESaNCRznmk0q
         TvnA==
X-Gm-Message-State: AOJu0YzPet4NXM2tYvNhB5f5CGtEq7aK2KsxJcbMhFSppIeWJmU6RCFt
	PcZhQhDvxQLK7LaTAjJHoo+JLP9MlwlJmCsnq2dUcfpqnp+FtXexpkrztOnz/iLLRLyJ19vSP6r
	USRnT/S6J2hs12obuEdyQCBh3UW/b9uSU1UZaUgSRJh6KKDDelmxhHQhf3jFoVY0wRvxWop6w9f
	Ec5JBxqPmQ2Wge5tcR9EHV3Z+N4iC+C1re7+GMK6ObNSTjR16buRrfpSZU4pP9XokeR5IMVukE9
	m5E0Dipe62ILFmU
X-Gm-Gg: AY/fxX6tW7fQ3elB6QwkWRzPazkoQMElnIySQtQuzC6+LEzZDNuJxvrA6Y6k5Q4YTGE
	zd8KdgOmVl+8pnUWfNaxcNeEXvAUUJGxLnVe3DBAyI13EGfUoFzuGo9TV5Y82hG+3PVyitW9rxb
	T+a2IWCbnYxMn4z75psjk8Y4XZrZA1soEW1iQXwSyYnKeqMebZx9u30wPbMe1kROqetdjZZxk0J
	uRV5PCaEJRlb46F/2Ylyynyzt/mvuOiXk4ME69YH7oIZ/S0niE+tUH91UQCpQslhlTUwrcJohTv
	gLlx0h5w2WM25FeFYaBjtnUy1z6c5pfZ917foms2nw3Bgp955cf0LOgiiXIbAbmnXwlh9YXvk0h
	1AJ2PQFdQUGJZpCNtiGaRRs7LA6LhcSriAfh/0t+z2oh9zb7/j4TwjuZIbboev/pUyP9NbOQJKu
	SAViEoGN1+U12vtyMiQRW7cYGqqKRIeuW28P3mDMfxUA==
X-Google-Smtp-Source: AGHT+IFqubAi28v90beBXlpOTrDrDuRc2S1wsSdjVt/3Zsxdc2fhSz+IJWPkAfuZ/Skoa7Fen7uyWdtcC5ja
X-Received: by 2002:a05:6122:1d4d:b0:55b:1a1b:3273 with SMTP id 71dfb90a1353d-56347d4a0bemr5202469e0c.6.1768205831678;
        Mon, 12 Jan 2026 00:17:11 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5636d78a25esm1072716e0c.4.2026.01.12.00.17.10
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jan 2026 00:17:11 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34ac814f308so9248456a91.3
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 00:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768205829; x=1768810629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdW5gEOdqWA5xgWHnEM8utKtfZOt0NSBcNP+5uNcuMM=;
        b=Jr06Cjtxmge2bpbDFBCnnYWsVoKrdZVTSP3N9GlLTroA8o0fLvvuW4uv4NhGjj/Vxz
         Pi6XW16m5j/uj9KL9PZLiMGVbUejpeHNnm5Ib9TfdpOkFjYMvPjnp4sNF+amkqufCNAG
         zEanqc2GXrGQqjYEciv8lffCODBSQjWIfIbds=
X-Received: by 2002:a17:90b:2b8f:b0:341:315:f4ec with SMTP id 98e67ed59e1d1-34f68c30789mr17084470a91.7.1768205829529;
        Mon, 12 Jan 2026 00:17:09 -0800 (PST)
X-Received: by 2002:a17:90b:2b8f:b0:341:315:f4ec with SMTP id 98e67ed59e1d1-34f68c30789mr17084451a91.7.1768205829034;
        Mon, 12 Jan 2026 00:17:09 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5f8b1526sm16808659a91.14.2026.01.12.00.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 00:17:08 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 2/7] mpi3mr: Rename log data save helper to reflect threaded/BH context
Date: Mon, 12 Jan 2026 13:40:32 +0530
Message-ID: <20260112081037.74376-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
References: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Log data events can be processed from BH and threaded contexts.
Rename the save helper to document its intended usage and improve
readability of the event handling flow.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c | 4 ++--
 drivers/scsi/mpi3mr/mpi3mr_os.c  | 8 +++++++-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 31d68c151b20..611a51a353c9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1508,7 +1508,7 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd);
 int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd);
-void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
+void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size);
 struct mpi3mr_enclosure_node *mpi3mr_enclosure_find_by_handle(
 	struct mpi3mr_ioc *mrioc, u16 handle);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 0e5478d62580..37cca0573ddc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2920,7 +2920,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 }
 
 /**
- * mpi3mr_app_save_logdata - Save Log Data events
+ * mpi3mr_app_save_logdata_th - Save Log Data events
  * @mrioc: Adapter instance reference
  * @event_data: event data associated with log data event
  * @event_data_size: event data size to copy
@@ -2932,7 +2932,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
  *
  * Return:Nothing
  */
-void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
+void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size)
 {
 	u32 index = mrioc->logdata_buf_idx, sz;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index d4ca878d0886..4dbf2f337212 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1962,7 +1962,7 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 static void mpi3mr_logdata_evt_bh(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_fwevt *fwevt)
 {
-	mpi3mr_app_save_logdata(mrioc, fwevt->event_data,
+	mpi3mr_app_save_logdata_th(mrioc, fwevt->event_data,
 	    fwevt->event_data_size);
 }
 
@@ -3058,6 +3058,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	}
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
 	case MPI3_EVENT_LOG_DATA:
+	{
+		sz = event_reply->event_data_length * 4;
+		mpi3mr_app_save_logdata_th(mrioc,
+		    (char *)event_reply->event_data, sz);
+		break;
+	}
 	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
 	case MPI3_EVENT_ENCL_DEVICE_ADDED:
 	{
-- 
2.47.3

