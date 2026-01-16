Received: from mail-dy1-f227.google.com (mail-dy1-f227.google.com [74.125.82.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7055B34C981
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 06:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768544038; cv=none; b=VBfVWpuI0gfUdMhJioQ2fFYpGpCIgs5ofwtRBS5dR94TMGGQiLU+KxUO4O/9XqytZfCn9OyzDK7ROwkLjPDLf94aWs2FSaMaiLwrvuanlThJ0KbDiH+yfqeFpQ+NS2hI2n5yo7bo+hLYW8F619jTD+Fjim7H17klUI8CQaT4wgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768544038; c=relaxed/simple;
	bh=sqc9qiLuny+YbTIaQMqw6aU3begX+rFP/XWEIr7R2oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BP9B532fMn5Dt6KeHWju7zZ7k0iwPrpYKdXz0/g+8SIFK+rDV5AGYhFZrX07R+Ok8S18i58OA3VKcZdPeYMPO8C7njXomp76gBrSrnaKcrVjxCcryd80l7VfdQnVvGeSBNTYkVwO0IxwLaz48jnsfSKsseq+MQzDobXUGcwxlQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=FT2i9YnM; arc=none smtp.client-ip=74.125.82.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FT2i9YnM"
Received: by mail-dy1-f227.google.com with SMTP id 5a478bee46e88-2b0ea1edf11so386067eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:13:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768544036; x=1769148836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZQy6CkAGr5GpYQJvOoiTsFhqIBGw7XhfHMf9hiwdrw=;
        b=Kv3cMVG3FJRTrK4XVrFUX/PVaBhdzf9R6MT6Wc2GdoeX+MtOSjLikw6kDtjTDoLB1w
         YDMEnmoEtUl9Tkhvaow43DXlan+v6zNdj9woUbSfSbFZDjz47wOrzIJX8GSdqip0pB9c
         phbu0h3u+kndajfglZ71HIBrG5qohNGbaQG6mM1T+maR/Pqcy81mnyCoF7U4K/pOIztX
         7L7FJghCZmeaNCwdLZeKQ4nlB2lBi9crsS2LDHXUPEcdsQpZGMJif0PVaFFhqCMjZtxr
         JX0YCyn+NlRGEwfN1vXyfehnhooe6K5pQVUsOUcDTJg84WtUP0xbGr2QoauRcFfnNBqb
         2dRg==
X-Gm-Message-State: AOJu0Yy8YczjfdRSCcN43t0j1FxaNZGre27rdXcaZA/e7xJQXGW+tEl7
	sv1Fh9y8bjlodprHo1S5K9TFp3OXJRkTY/QZnxY6bsBAihoDIt9tJ0IWFTWkmdbSFS0VqFRDLlU
	d6msRQ/zvl7xElMG+4bt7TFjGzuICTZyTkef69aiLSwukZfNZZ/rNfzqV72QZoM6Jt0zkjq99br
	avCodbxc7skurHIBxrSc13/fKS29hLljwD1GPFpTGvzsToXv9TejuThWWEwMkmHgeokxQOvDJUi
	qhlsAxosvTjAN+1
X-Gm-Gg: AY/fxX6rbaf4VEpuCpygFVW3tP/bDSo2UABA4+EhEuQ3DuEkQJbTsuVdruUAp7qBm5v
	DZdKZL4AhvOPBLpJSvxkrRchB/qKwXYCJ2rbm4G0Ntv6CxkdfhDRgyjHA5pIWi4DwmTwuXshpBw
	hhuicxmtLyvh0Ooa3W7PQzhSGxHenBgHCP2UAf0gTeNC62nBpDzXPgQTlq6lQ5DdkarOsG+SyY6
	0uhUSYGeh5UsVx3MzTNVWdLKFKRtIlqiipiEAKZo4ePq5D5BnBWe4WdbR6/qRTYwzmXXF8M+OS2
	OlmIehbWIRwQcGHG/yvCfTQ7p8BTDLOlI5vSRSU4TO+wVXJrEX5JsmOo+0nInOZq7femANOh/Nh
	Bb2n+HMPeDr7D18+Du60p+H/I8IKjKxTdcfUgrROeFyJmKbbu3qcsMetWroVND6a/3DFviz6HTE
	KnP3plqTvGCTLWcmj8pHouFn+NaEQslKaiE3kn7lSRL0Bc
X-Received: by 2002:a05:7300:f18f:b0:2ae:6118:dbce with SMTP id 5a478bee46e88-2b6b4e59a89mr1391625eec.10.1768544036455;
        Thu, 15 Jan 2026 22:13:56 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-72.dlp.protect.broadcom.com. [144.49.247.72])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-2b6bd8c4cb6sm32416eec.7.2026.01.15.22.13.56
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jan 2026 22:13:56 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a0dabc192eso17679115ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768544034; x=1769148834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ZQy6CkAGr5GpYQJvOoiTsFhqIBGw7XhfHMf9hiwdrw=;
        b=FT2i9YnMyT0/2bjjNcKPr53QZRZEgstJjOXYC411QXrFxeQlx+9UedrWxclANmGddy
         9aKGKNKksHQqbaL6yI8RlZfFqKDCvLqt/eH/1xmj14pL5lBeE0qC4z8123BG712pX/iz
         5XZqAgW2htAUHfw4DG68NEgDwQMKLlEb3Ix+s=
X-Received: by 2002:a17:902:e952:b0:2a0:bb3b:4199 with SMTP id d9443c01a7336-2a71888b462mr21454145ad.2.1768544034442;
        Thu, 15 Jan 2026 22:13:54 -0800 (PST)
X-Received: by 2002:a17:902:e952:b0:2a0:bb3b:4199 with SMTP id d9443c01a7336-2a71888b462mr21454025ad.2.1768544033946;
        Thu, 15 Jan 2026 22:13:53 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a71941bd9bsm10231315ad.93.2026.01.15.22.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 22:13:53 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 2/8] mpi3mr: Rename log data save helper to reflect threaded/BH context
Date: Fri, 16 Jan 2026 11:37:13 +0530
Message-ID: <20260116060719.32937-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
References: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
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
 drivers/scsi/mpi3mr/mpi3mr_os.c  | 7 ++++++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 82f4ae87d6bc..711f2aa11294 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1506,7 +1506,7 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
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
index d4ca878d0886..028a3a1a6be0 100644
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
 
@@ -3058,6 +3058,11 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	}
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
 	case MPI3_EVENT_LOG_DATA:
+
+		sz = event_reply->event_data_length * 4;
+		mpi3mr_app_save_logdata_th(mrioc,
+			(char *)event_reply->event_data, sz);
+		break;
 	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
 	case MPI3_EVENT_ENCL_DEVICE_ADDED:
 	{
-- 
2.47.3

