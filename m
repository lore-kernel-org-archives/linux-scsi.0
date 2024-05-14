Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFFF17088C
	for <linux-scsi@vger.kernel.org>; Tue, 14 May 2024 14:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715697136; cv=none; b=O9UE7mrgum3h6KYyr6WI/EH0Wwrk2NgVnRNomcnO/Cy3YLxggLQdhHDR/yaKjG4a41An86eibL2RbHfyFbB6r12Af8qFLaORlf7jhCGG2SmtZYEB8m9AHAXtchHtwiN/ddJjvwXE7mfMpT6CDxRtbL9TPOHLUzY738K1RmQd/cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715697136; c=relaxed/simple;
	bh=MqKD1U+oGIwvhXmP2cclP9Cnb2F4x3QUgkI/brBuztU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PTqvGq7/wr+zpjVR670+6pQtlBX41Ob8OB1hKv2pR4/3glIz5ADwhesDKV6d+X+cdXSGrCvHMncBnHFOtXsYnkKKJo3by6EPUV6RwNJEM6Y3x4oa0CJ3E58csRZTiYV3mt1IdXjBH0QI2GBOCMHN8RMF1G7v/HQjYORYP2E2NTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=dY4eCe/e; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dY4eCe/e"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5ad2da2196aso3694344eaf.2
        for <linux-scsi@vger.kernel.org>; Tue, 14 May 2024 07:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1715697133; x=1716301933; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=clGc79b7/apzlHSow54oGmjg8Lu+sWbEMlIp7FhAVUA=;
        b=dY4eCe/ecReZoYOXjHp+rK+RmAHIL878zsYkKLd2/OqoE9hJOJyJrRzsfby7s3zm8b
         s/WGULy198IDR4HYnzEFQDp11aLpZgqL6pnodkkA6ddRA9dSXYRXLkZDDvpbvAh85a6S
         WmUudMWZvu9jW1D1NZe6Rpfh+pW1WymXWwp7c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715697133; x=1716301933;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=clGc79b7/apzlHSow54oGmjg8Lu+sWbEMlIp7FhAVUA=;
        b=eRUdLLk1m5rUAUIfvv0gFB0gUkUjVHw5+QQ6P5B758m98dJkzodIUlZ7keqaltsIYX
         tuu0mOo/EYmtmjW4kitPgeLU6RN9XPRdCIsySF/L5lYW1AIhTDIMmzTzvRHrMALArM2n
         4oV3tMt8MD1TWlXk3v7QuQPfWDpUPe5mWU8r9/1LXGxRjiikg6OLMP+uTDHMx8CMTj+p
         twG4KO9EROvA31Akxzl6oq2S5dobPzbWcb6TX3n2+hWIRsN0cMDvDrGp60A+rdr4WNzZ
         b7n4NnKfMYmOWn74wxflT6MsEocVAdvzaogmYjp+vCp4ZFXfqtuW6gms+bh9scnxwIos
         WQJQ==
X-Gm-Message-State: AOJu0YzBHIetGKNvdBW8KF5fpLG10hyIks5GbXVUsP4+Fj/zvArARN1T
	FDabc9YCNGFNNYKbzbfhgHT4bFyhiIJv/kuoivmB+KVKhZns8ofvFvyFJD3/bMAo42b6aj5k6S5
	65QcEc0ucWxVKWPt3XW3zMFOms+vTpPuZVqJMCrOuefZD4PMF6Ilx95nfgZZBfrx3NKS4ZBiK1V
	IGwaFJzojf1HBbQLs61HabGD5YhXKBFxio/lNw2FbNXO1nrw==
X-Google-Smtp-Source: AGHT+IF8/H+Iz+e+VZ2eSdS+IePanLwRbjkFlPfnxcXCTvx31bKDhJn888i8t/eouxhr711ire4gWA==
X-Received: by 2002:a05:6358:5926:b0:186:3fea:b69f with SMTP id e5c5f4694b2df-193bcfe024fmr1415366355d.21.1715697131924;
        Tue, 14 May 2024 07:32:11 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-63560731046sm7849104a12.67.2024.05.14.07.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 07:32:10 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 4/6] mpi3mr: Trigger support
Date: Tue, 14 May 2024 19:58:56 +0530
Message-Id: <20240514142858.51992-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240514142858.51992-1-ranjan.kumar@broadcom.com>
References: <20240514142858.51992-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000002eedde06186adee7"

--0000000000002eedde06186adee7
Content-Transfer-Encoding: 8bit

This patch adds functions to process automatic diag triggers and
if a condition defined in the triggers is met the driver will call
appropriate controller functions to save the diagnostic information.

Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  44 ++++
 drivers/scsi/mpi3mr/mpi3mr_app.c | 334 +++++++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c  |  79 +++++++-
 drivers/scsi/mpi3mr/mpi3mr_os.c  | 113 +++++++++++
 4 files changed, 563 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index b6030a665ec8..259f58b347fd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -194,7 +194,12 @@ extern atomic64_t event_counter;
 #define MPI3MR_DEFAULT_HDB_MIN_SZ       (2 * 1024 * 1024)
 #define MPI3MR_MAX_NUM_HDB      2
 
+#define MPI3MR_HDB_TRIGGER_TYPE_UNKNOWN		0
+#define MPI3MR_HDB_TRIGGER_TYPE_FAULT		1
+#define MPI3MR_HDB_TRIGGER_TYPE_ELEMENT		2
 #define MPI3MR_HDB_TRIGGER_TYPE_GLOBAL          3
+#define MPI3MR_HDB_TRIGGER_TYPE_SOFT_RESET      4
+#define MPI3MR_HDB_TRIGGER_TYPE_FW_RELEASED     5
 
 /* Driver Host Diag Buffer (drv_db) */
 #define MPI3MR_MIN_DIAG_HOST_BUFFER_SZ		((32 * 1024) + \
@@ -226,6 +231,8 @@ extern atomic64_t event_counter;
 #define MPI3MR_WRITE_SAME_MAX_LEN_256_BLKS 256
 #define MPI3MR_WRITE_SAME_MAX_LEN_2048_BLKS 2048
 
+#define MPI3MR_DRIVER_EVENT_PROCESS_TRIGGER	(0xFFFD)
+
 struct mpi3mr_kmsg_dumper {
 	struct kmsg_dump_iter kdumper;
 };
@@ -321,6 +328,7 @@ enum mpi3mr_reset_reason {
 	MPI3MR_RESET_FROM_FIRMWARE = 27,
 	MPI3MR_RESET_FROM_CFG_REQ_TIMEOUT = 29,
 	MPI3MR_RESET_FROM_SAS_TRANSPORT_TIMEOUT = 30,
+	MPI3MR_RESET_FROM_TRIGGER = 31,
 };
 
 #define MPI3MR_RESET_REASON_OSTYPE_LINUX	1
@@ -896,6 +904,24 @@ union mpi3mr_trigger_data {
 	union mpi3_driver2_trigger_element element;
 };
 
+/**
+ * struct trigger_event_data - store trigger related
+ * information.
+ *
+ * @trace_hdb: Trace diag buffer descriptor reference
+ * @fw_hdb: FW diag buffer descriptor reference
+ * @trigger_type: Trigger type
+ * @trigger_specific_data: Trigger specific data
+ * @snapdump: Snapdump enable or disable flag
+ */
+struct trigger_event_data {
+	struct diag_buffer_desc *trace_hdb;
+	struct diag_buffer_desc *fw_hdb;
+	u8 trigger_type;
+	union mpi3mr_trigger_data trigger_specific_data;
+	bool snapdump;
+};
+
 /**
  * struct diag_buffer_desc - memory descriptor structure to
  * store virtual, dma addresses, size, buffer status for host
@@ -1134,6 +1160,9 @@ struct scmd_priv {
  * @drv_diag_buffer: Diagnostic host buffer virtual address
  * @drv_diag_buffer_dma: Diagnostic host buffer DMA address
  * @drv_diag_buffer_sz: Diagnostic host buffer size
+ * @trace_release_trigger_active: Trace trigger active flag
+ * @fw_release_trigger_active: Fw release trigger active flag
+ * @snapdump_trigger_active: Snapdump trigger active flag
  *
  */
 struct mpi3mr_ioc {
@@ -1336,6 +1365,9 @@ struct mpi3mr_ioc {
 	dma_addr_t drv_diag_buffer_dma;
 	u32 drv_diag_buffer_sz;
 	struct mpi3mr_kmsg_dumper dump;
+	bool snapdump_trigger_active;
+	bool trace_release_trigger_active;
+	bool fw_release_trigger_active;
 };
 
 /**
@@ -1540,4 +1572,16 @@ struct diag_buffer_desc *mpi3mr_diag_buffer_for_type(struct mpi3mr_ioc *mrioc,
 	u8 buf_type);
 int mpi3mr_issue_diag_buf_post(struct mpi3mr_ioc *mrioc,
 	struct diag_buffer_desc *diag_buffer);
+void mpi3mr_set_trigger_data_in_all_hdb(struct mpi3mr_ioc *mrioc,
+	u8 type, union mpi3mr_trigger_data *trigger_data, bool force);
+void mpi3mr_reply_trigger(struct mpi3mr_ioc *mrioc, u16 iocstatus,
+	u32 iocloginfo);
+void mpi3mr_hdb_trigger_data_event(struct mpi3mr_ioc *mrioc,
+	struct trigger_event_data *event_data);
+void mpi3mr_scsisense_trigger(struct mpi3mr_ioc *mrioc, u8 senseky, u8 asc,
+	u8 ascq);
+void mpi3mr_event_trigger(struct mpi3mr_ioc *mrioc, u8 event);
+void mpi3mr_global_trigger(struct mpi3mr_ioc *mrioc, u64 trigger_data);
+void mpi3mr_hdbstatuschg_evt_th(struct mpi3mr_ioc *mrioc,
+	struct mpi3_event_notification_reply *event_reply);
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index f9571b615a8c..95f6c37fd977 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -316,6 +316,263 @@ int mpi3mr_issue_diag_buf_release(struct mpi3mr_ioc *mrioc,
 	return retval;
 }
 
+/**
+ * mpi3mr_process_trigger - Generic HDB Trigger handler
+ * @mrioc: Adapter instance reference
+ * @trigger_type: Trigger type
+ * @trigger_data: Trigger data
+ * @trigger_flags: Trigger flags
+ *
+ * This function checks validity of HDB, triggers and based on
+ * trigger information, creates an event to be processed in the
+ * firmware event worker thread .
+ *
+ * This function should be called with trigger spinlock held
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_process_trigger(struct mpi3mr_ioc *mrioc, u8 trigger_type,
+	union mpi3mr_trigger_data *trigger_data, u8 trigger_flags)
+{
+	struct trigger_event_data event_data;
+	struct diag_buffer_desc *trace_hdb = NULL;
+	struct diag_buffer_desc *fw_hdb = NULL;
+	u64 global_trigger;
+
+	trace_hdb = mpi3mr_diag_buffer_for_type(mrioc,
+	    MPI3_DIAG_BUFFER_TYPE_TRACE);
+	if (trace_hdb &&
+	    (trace_hdb->status != MPI3MR_HDB_BUFSTATUS_POSTED_UNPAUSED) &&
+	    (trace_hdb->status != MPI3MR_HDB_BUFSTATUS_POSTED_PAUSED))
+		trace_hdb =  NULL;
+
+	fw_hdb = mpi3mr_diag_buffer_for_type(mrioc, MPI3_DIAG_BUFFER_TYPE_FW);
+
+	if (fw_hdb &&
+	    (fw_hdb->status != MPI3MR_HDB_BUFSTATUS_POSTED_UNPAUSED) &&
+	    (fw_hdb->status != MPI3MR_HDB_BUFSTATUS_POSTED_PAUSED))
+		fw_hdb = NULL;
+
+	if (mrioc->snapdump_trigger_active || (mrioc->fw_release_trigger_active
+	    && mrioc->trace_release_trigger_active) ||
+	    (!trace_hdb && !fw_hdb) || (!mrioc->driver_pg2) ||
+	    ((trigger_type == MPI3MR_HDB_TRIGGER_TYPE_ELEMENT)
+	     && (!mrioc->driver_pg2->num_triggers)))
+		return;
+
+	memset(&event_data, 0, sizeof(event_data));
+	event_data.trigger_type = trigger_type;
+	memcpy(&event_data.trigger_specific_data, trigger_data,
+	    sizeof(*trigger_data));
+	global_trigger = le64_to_cpu(mrioc->driver_pg2->global_trigger);
+
+	if (global_trigger & MPI3_DRIVER2_GLOBALTRIGGER_SNAPDUMP_ENABLED) {
+		event_data.snapdump = true;
+		event_data.trace_hdb = trace_hdb;
+		event_data.fw_hdb = fw_hdb;
+		mrioc->snapdump_trigger_active = true;
+	} else if (trigger_type == MPI3MR_HDB_TRIGGER_TYPE_GLOBAL) {
+		if ((trace_hdb) && (global_trigger &
+		    MPI3_DRIVER2_GLOBALTRIGGER_DIAG_TRACE_RELEASE) &&
+		    (!mrioc->trace_release_trigger_active)) {
+			event_data.trace_hdb = trace_hdb;
+			mrioc->trace_release_trigger_active = true;
+		}
+		if ((fw_hdb) && (global_trigger &
+		    MPI3_DRIVER2_GLOBALTRIGGER_DIAG_FW_RELEASE) &&
+		    (!mrioc->fw_release_trigger_active)) {
+			event_data.fw_hdb = fw_hdb;
+			mrioc->fw_release_trigger_active = true;
+		}
+	} else if (trigger_type == MPI3MR_HDB_TRIGGER_TYPE_ELEMENT) {
+		if ((trace_hdb) && (trigger_flags &
+		    MPI3_DRIVER2_TRIGGER_FLAGS_DIAG_TRACE_RELEASE) &&
+		    (!mrioc->trace_release_trigger_active)) {
+			event_data.trace_hdb = trace_hdb;
+			mrioc->trace_release_trigger_active = true;
+		}
+		if ((fw_hdb) && (trigger_flags &
+		    MPI3_DRIVER2_TRIGGER_FLAGS_DIAG_FW_RELEASE) &&
+		    (!mrioc->fw_release_trigger_active)) {
+			event_data.fw_hdb = fw_hdb;
+			mrioc->fw_release_trigger_active = true;
+		}
+	}
+
+	if (event_data.trace_hdb || event_data.fw_hdb)
+		mpi3mr_hdb_trigger_data_event(mrioc, &event_data);
+}
+
+/**
+ * mpi3mr_global_trigger - Global HDB trigger handler
+ * @mrioc: Adapter instance reference
+ * @trigger_data: Trigger data
+ *
+ * This function checks whether the given global trigger is
+ * enabled in the driver page 2 and if so calls generic trigger
+ * handler to queue event for HDB release.
+ *
+ * Return: Nothing
+ */
+void mpi3mr_global_trigger(struct mpi3mr_ioc *mrioc, u64 trigger_data)
+{
+	unsigned long flags;
+	union mpi3mr_trigger_data trigger_specific_data;
+
+	spin_lock_irqsave(&mrioc->trigger_lock, flags);
+	if (le64_to_cpu(mrioc->driver_pg2->global_trigger) & trigger_data) {
+		memset(&trigger_specific_data, 0,
+		    sizeof(trigger_specific_data));
+		trigger_specific_data.global = trigger_data;
+		mpi3mr_process_trigger(mrioc, MPI3MR_HDB_TRIGGER_TYPE_GLOBAL,
+		    &trigger_specific_data, 0);
+	}
+	spin_unlock_irqrestore(&mrioc->trigger_lock, flags);
+}
+
+/**
+ * mpi3mr_scsisense_trigger - SCSI sense HDB trigger handler
+ * @mrioc: Adapter instance reference
+ * @sensekey: Sense Key
+ * @asc: Additional Sense Code
+ * @ascq: Additional Sense Code Qualifier
+ *
+ * This function compares SCSI sense trigger values with driver
+ * page 2 values and calls generic trigger handler to release
+ * HDBs if match found
+ *
+ * Return: Nothing
+ */
+void mpi3mr_scsisense_trigger(struct mpi3mr_ioc *mrioc, u8 sensekey, u8 asc,
+	u8 ascq)
+{
+	struct mpi3_driver2_trigger_scsi_sense *scsi_sense_trigger = NULL;
+	u64 i = 0;
+	unsigned long flags;
+	u8 num_triggers, trigger_flags;
+
+	if (mrioc->scsisense_trigger_present) {
+		spin_lock_irqsave(&mrioc->trigger_lock, flags);
+		scsi_sense_trigger = (struct mpi3_driver2_trigger_scsi_sense *)
+			mrioc->driver_pg2->trigger;
+		num_triggers = mrioc->driver_pg2->num_triggers;
+		for (i = 0; i < num_triggers; i++, scsi_sense_trigger++) {
+			if (scsi_sense_trigger->type !=
+			    MPI3_DRIVER2_TRIGGER_TYPE_SCSI_SENSE)
+				continue;
+			if (!(scsi_sense_trigger->sense_key ==
+			    MPI3_DRIVER2_TRIGGER_SCSI_SENSE_SENSE_KEY_MATCH_ALL
+			      || scsi_sense_trigger->sense_key == sensekey))
+				continue;
+			if (!(scsi_sense_trigger->asc ==
+			    MPI3_DRIVER2_TRIGGER_SCSI_SENSE_ASC_MATCH_ALL ||
+			    scsi_sense_trigger->asc == asc))
+				continue;
+			if (!(scsi_sense_trigger->ascq ==
+			    MPI3_DRIVER2_TRIGGER_SCSI_SENSE_ASCQ_MATCH_ALL ||
+			    scsi_sense_trigger->ascq == ascq))
+				continue;
+			trigger_flags = scsi_sense_trigger->flags;
+			mpi3mr_process_trigger(mrioc,
+			    MPI3MR_HDB_TRIGGER_TYPE_ELEMENT,
+			    (union mpi3mr_trigger_data *)scsi_sense_trigger,
+			    trigger_flags);
+			break;
+		}
+		spin_unlock_irqrestore(&mrioc->trigger_lock, flags);
+	}
+}
+
+/**
+ * mpi3mr_event_trigger - MPI event HDB trigger handler
+ * @mrioc: Adapter instance reference
+ * @event: MPI Event
+ *
+ * This function compares event trigger values with driver page
+ * 2 values and calls generic trigger handler to release
+ * HDBs if match found.
+ *
+ * Return: Nothing
+ */
+void mpi3mr_event_trigger(struct mpi3mr_ioc *mrioc, u8 event)
+{
+	struct mpi3_driver2_trigger_event *event_trigger = NULL;
+	u64 i = 0;
+	unsigned long flags;
+	u8 num_triggers, trigger_flags;
+
+	if (mrioc->event_trigger_present) {
+		spin_lock_irqsave(&mrioc->trigger_lock, flags);
+		event_trigger = (struct mpi3_driver2_trigger_event *)
+			mrioc->driver_pg2->trigger;
+		num_triggers = mrioc->driver_pg2->num_triggers;
+
+		for (i = 0; i < num_triggers; i++, event_trigger++) {
+			if (event_trigger->type !=
+			    MPI3_DRIVER2_TRIGGER_TYPE_EVENT)
+				continue;
+			if (event_trigger->event != event)
+				continue;
+			trigger_flags = event_trigger->flags;
+			mpi3mr_process_trigger(mrioc,
+			    MPI3MR_HDB_TRIGGER_TYPE_ELEMENT,
+			    (union mpi3mr_trigger_data *)event_trigger,
+			    trigger_flags);
+			break;
+		}
+		spin_unlock_irqrestore(&mrioc->trigger_lock, flags);
+	}
+}
+
+/**
+ * mpi3mr_reply_trigger - MPI Reply HDB trigger handler
+ * @mrioc: Adapter instance reference
+ * @ioc_status: Masked value of IOC Status from MPI Reply
+ * @ioc_loginfo: IOC Log Info from MPI Reply
+ *
+ * This function compares IOC status and IOC log info trigger
+ * values with driver page 2 values and calls generic trigger
+ * handler to release HDBs if match found.
+ *
+ * Return: Nothing
+ */
+void mpi3mr_reply_trigger(struct mpi3mr_ioc *mrioc, u16 ioc_status,
+	u32 ioc_loginfo)
+{
+	struct mpi3_driver2_trigger_reply *reply_trigger = NULL;
+	u64 i = 0;
+	unsigned long flags;
+	u8 num_triggers, trigger_flags;
+
+	if (mrioc->reply_trigger_present) {
+		spin_lock_irqsave(&mrioc->trigger_lock, flags);
+		reply_trigger = (struct mpi3_driver2_trigger_reply *)
+			mrioc->driver_pg2->trigger;
+		num_triggers = mrioc->driver_pg2->num_triggers;
+		for (i = 0; i < num_triggers; i++, reply_trigger++) {
+			if (reply_trigger->type !=
+			    MPI3_DRIVER2_TRIGGER_TYPE_REPLY)
+				continue;
+			if ((le16_to_cpu(reply_trigger->ioc_status) !=
+			     ioc_status)
+			    && (le16_to_cpu(reply_trigger->ioc_status) !=
+			    MPI3_DRIVER2_TRIGGER_REPLY_IOCSTATUS_MATCH_ALL))
+				continue;
+			if ((le32_to_cpu(reply_trigger->ioc_log_info) !=
+			    (le32_to_cpu(reply_trigger->ioc_log_info_mask) &
+			     ioc_loginfo)))
+				continue;
+			trigger_flags = reply_trigger->flags;
+			mpi3mr_process_trigger(mrioc,
+			    MPI3MR_HDB_TRIGGER_TYPE_ELEMENT,
+			    (union mpi3mr_trigger_data *)reply_trigger,
+			    trigger_flags);
+			break;
+		}
+		spin_unlock_irqrestore(&mrioc->trigger_lock, flags);
+	}
+}
+
 /**
  * mpi3mr_get_num_trigger - Gets number of HDB triggers
  * @mrioc: Adapter instance reference
@@ -467,6 +724,83 @@ void mpi3mr_set_trigger_data_in_hdb(struct diag_buffer_desc *hdb,
 		memcpy(&hdb->trigger_data, trigger_data, sizeof(*trigger_data));
 }
 
+/**
+ * mpi3mr_set_trigger_data_in_all_hdb - Updates HDB trigger type
+ * and trigger data for all HDB
+ *
+ * @mrioc: Adapter instance reference
+ * @type: Trigger type
+ * @data: Trigger data
+ * @force: Trigger overwrite flag
+ *
+ * Updates trigger type and trigger data based on parameter
+ * passed to this function
+ *
+ * Return: Nothing
+ */
+void mpi3mr_set_trigger_data_in_all_hdb(struct mpi3mr_ioc *mrioc,
+	u8 type, union mpi3mr_trigger_data *trigger_data, bool force)
+{
+	struct diag_buffer_desc *hdb = NULL;
+
+	hdb = mpi3mr_diag_buffer_for_type(mrioc, MPI3_DIAG_BUFFER_TYPE_TRACE);
+	if (hdb)
+		mpi3mr_set_trigger_data_in_hdb(hdb, type, trigger_data, force);
+	hdb = mpi3mr_diag_buffer_for_type(mrioc, MPI3_DIAG_BUFFER_TYPE_FW);
+	if (hdb)
+		mpi3mr_set_trigger_data_in_hdb(hdb, type, trigger_data, force);
+}
+
+/**
+ * mpi3mr_hdbstatuschg_evt_th - HDB status change evt tophalf
+ * @mrioc: Adapter instance reference
+ * @event_reply: event data
+ *
+ * Modifies the status of the applicable diag buffer descriptors
+ *
+ * Return: Nothing
+ */
+void mpi3mr_hdbstatuschg_evt_th(struct mpi3mr_ioc *mrioc,
+	struct mpi3_event_notification_reply *event_reply)
+{
+	struct mpi3_event_data_diag_buffer_status_change *evtdata;
+	struct diag_buffer_desc *diag_buffer;
+
+	evtdata = (struct mpi3_event_data_diag_buffer_status_change *)
+	    event_reply->event_data;
+
+	diag_buffer = mpi3mr_diag_buffer_for_type(mrioc, evtdata->type);
+	if (!diag_buffer)
+		return;
+	if ((diag_buffer->status != MPI3MR_HDB_BUFSTATUS_POSTED_UNPAUSED) &&
+	    (diag_buffer->status != MPI3MR_HDB_BUFSTATUS_POSTED_PAUSED))
+		return;
+	switch (evtdata->reason_code) {
+	case MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RELEASED:
+	{
+		diag_buffer->status = MPI3MR_HDB_BUFSTATUS_RELEASED;
+		mpi3mr_set_trigger_data_in_hdb(diag_buffer,
+		    MPI3MR_HDB_TRIGGER_TYPE_FW_RELEASED, NULL, 0);
+		atomic64_inc(&event_counter);
+		break;
+	}
+	case MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RESUMED:
+	{
+		diag_buffer->status = MPI3MR_HDB_BUFSTATUS_POSTED_UNPAUSED;
+		break;
+	}
+	case MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_PAUSED:
+	{
+		diag_buffer->status = MPI3MR_HDB_BUFSTATUS_POSTED_PAUSED;
+		break;
+	}
+	default:
+		dprint_event_th(mrioc, "%s: unknown reason_code(%d)\n",
+		    __func__, evtdata->reason_code);
+		break;
+	}
+}
+
 /**
  * mpi3mr_diag_buffer_for_type - returns buffer desc for type
  * @mrioc: Adapter instance reference
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 35143d2b7fe4..1769113d74da 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -285,6 +285,9 @@ static void mpi3mr_print_event_data(struct mpi3mr_ioc *mrioc,
 	case MPI3_EVENT_PREPARE_FOR_RESET:
 		desc = "Prepare For Reset";
 		break;
+	case MPI3_EVENT_DIAGNOSTIC_BUFFER_STATUS_CHANGE:
+		desc = "Diagnostic Buffer Status Change";
+		break;
 	}
 
 	if (!desc)
@@ -353,13 +356,14 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 {
 	u16 reply_desc_type, host_tag = 0;
 	u16 ioc_status = MPI3_IOCSTATUS_SUCCESS;
-	u32 ioc_loginfo = 0;
+	u32 ioc_loginfo = 0, sense_count = 0;
 	struct mpi3_status_reply_descriptor *status_desc;
 	struct mpi3_address_reply_descriptor *addr_desc;
 	struct mpi3_success_reply_descriptor *success_desc;
 	struct mpi3_default_reply *def_reply = NULL;
 	struct mpi3mr_drv_cmd *cmdptr = NULL;
 	struct mpi3_scsi_io_reply *scsi_reply;
+	struct scsi_sense_hdr sshdr;
 	u8 *sense_buf = NULL;
 
 	*reply_dma = 0;
@@ -374,6 +378,7 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 		    MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_LOGINFOAVAIL)
 			ioc_loginfo = le32_to_cpu(status_desc->ioc_log_info);
 		ioc_status &= MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_STATUS_MASK;
+		mpi3mr_reply_trigger(mrioc, ioc_status, ioc_loginfo);
 		break;
 	case MPI3_REPLY_DESCRIPT_FLAGS_TYPE_ADDRESS_REPLY:
 		addr_desc = (struct mpi3_address_reply_descriptor *)reply_desc;
@@ -391,7 +396,15 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 			scsi_reply = (struct mpi3_scsi_io_reply *)def_reply;
 			sense_buf = mpi3mr_get_sensebuf_virt_addr(mrioc,
 			    le64_to_cpu(scsi_reply->sense_data_buffer_address));
+			sense_count = le32_to_cpu(scsi_reply->sense_count);
+			if (sense_buf) {
+				scsi_normalize_sense(sense_buf, sense_count,
+				    &sshdr);
+				mpi3mr_scsisense_trigger(mrioc, sshdr.sense_key,
+				    sshdr.asc, sshdr.ascq);
+			}
 		}
+		mpi3mr_reply_trigger(mrioc, ioc_status, ioc_loginfo);
 		break;
 	case MPI3_REPLY_DESCRIPT_FLAGS_TYPE_SUCCESS:
 		success_desc = (struct mpi3_success_reply_descriptor *)reply_desc;
@@ -974,6 +987,14 @@ static const struct {
 	},
 	{ MPI3MR_RESET_FROM_SYSFS, "sysfs invocation" },
 	{ MPI3MR_RESET_FROM_SYSFS_TIMEOUT, "sysfs TM timeout" },
+	{
+		MPI3MR_RESET_FROM_DIAG_BUFFER_POST_TIMEOUT,
+		"diagnostic buffer post timeout"
+	},
+	{
+		MPI3MR_RESET_FROM_DIAG_BUFFER_RELEASE_TIMEOUT,
+		"diagnostic buffer release timeout"
+	},
 	{ MPI3MR_RESET_FROM_FIRMWARE, "firmware asynchronous reset" },
 	{ MPI3MR_RESET_FROM_CFG_REQ_TIMEOUT, "configuration request timeout"},
 	{ MPI3MR_RESET_FROM_SAS_TRANSPORT_TIMEOUT, "timeout of a SAS transport layer request" },
@@ -2641,6 +2662,7 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code)
 {
 	u32 ioc_status, host_diagnostic, timeout;
+	union mpi3mr_trigger_data trigger_data;
 
 	if (mrioc->unrecoverable) {
 		ioc_err(mrioc, "controller is unrecoverable\n");
@@ -2652,16 +2674,30 @@ void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code)
 		ioc_err(mrioc, "controller is not present\n");
 		return;
 	}
-
+	memset(&trigger_data, 0, sizeof(trigger_data));
 	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
-	if ((ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) ||
-	    (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT)) {
+
+	if (ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) {
+		mpi3mr_set_trigger_data_in_all_hdb(mrioc,
+		    MPI3MR_HDB_TRIGGER_TYPE_FW_RELEASED, NULL, 0);
+		return;
+	} else if (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT) {
+		trigger_data.fault = (readl(&mrioc->sysif_regs->fault) &
+		      MPI3_SYSIF_FAULT_CODE_MASK);
+
+		mpi3mr_set_trigger_data_in_all_hdb(mrioc,
+		    MPI3MR_HDB_TRIGGER_TYPE_FAULT, &trigger_data, 0);
 		mpi3mr_print_fault_info(mrioc);
 		return;
 	}
+
 	mpi3mr_set_diagsave(mrioc);
 	mpi3mr_issue_reset(mrioc, MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
 	    reason_code);
+	trigger_data.fault = (readl(&mrioc->sysif_regs->fault) &
+		      MPI3_SYSIF_FAULT_CODE_MASK);
+	mpi3mr_set_trigger_data_in_all_hdb(mrioc, MPI3MR_HDB_TRIGGER_TYPE_FAULT,
+	    &trigger_data, 0);
 	timeout = MPI3_SYSIF_DIAG_SAVE_TIMEOUT * 10;
 	do {
 		host_diagnostic = readl(&mrioc->sysif_regs->host_diagnostic);
@@ -2841,7 +2877,8 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	    container_of(work, struct mpi3mr_ioc, watchdog_work.work);
 	unsigned long flags;
 	enum mpi3mr_iocstate ioc_state;
-	u32 fault, host_diagnostic, ioc_status;
+	u32 host_diagnostic, ioc_status;
+	union mpi3mr_trigger_data trigger_data;
 	u16 reset_reason = MPI3MR_RESET_FROM_FAULT_WATCH;
 
 	if (mrioc->reset_in_progress)
@@ -2872,8 +2909,11 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 		return;
 	}
 
+	memset(&trigger_data, 0, sizeof(trigger_data));
 	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
 	if (ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) {
+		mpi3mr_set_trigger_data_in_all_hdb(mrioc,
+		    MPI3MR_HDB_TRIGGER_TYPE_FW_RELEASED, NULL, 0);
 		mpi3mr_soft_reset_handler(mrioc, MPI3MR_RESET_FROM_FIRMWARE, 0);
 		return;
 	}
@@ -2883,7 +2923,9 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	if (ioc_state != MRIOC_STATE_FAULT)
 		goto schedule_work;
 
-	fault = readl(&mrioc->sysif_regs->fault) & MPI3_SYSIF_FAULT_CODE_MASK;
+	trigger_data.fault = readl(&mrioc->sysif_regs->fault) & MPI3_SYSIF_FAULT_CODE_MASK;
+	mpi3mr_set_trigger_data_in_all_hdb(mrioc,
+	    MPI3MR_HDB_TRIGGER_TYPE_FAULT, &trigger_data, 0);
 	host_diagnostic = readl(&mrioc->sysif_regs->host_diagnostic);
 	if (host_diagnostic & MPI3_SYSIF_HOST_DIAG_SAVE_IN_PROGRESS) {
 		if (!mrioc->diagsave_timeout) {
@@ -2898,7 +2940,7 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	mpi3mr_print_fault_info(mrioc);
 	mrioc->diagsave_timeout = 0;
 
-	switch (fault) {
+	switch (trigger_data.fault) {
 	case MPI3_SYSIF_FAULT_CODE_COMPLETE_RESET_NEEDED:
 	case MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED:
 		ioc_warn(mrioc,
@@ -4245,6 +4287,7 @@ static int mpi3mr_enable_events(struct mpi3mr_ioc *mrioc)
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PREPARE_FOR_RESET);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_CABLE_MGMT);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENERGY_PACK_CHANGE);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DIAGNOSTIC_BUFFER_STATUS_CHANGE);
 
 	retval = mpi3mr_issue_event_notification(mrioc);
 	if (retval)
@@ -4423,6 +4466,12 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 	}
 
+	retval = mpi3mr_refresh_trigger(mrioc, MPI3_CONFIG_ACTION_READ_CURRENT);
+	if (retval) {
+		ioc_err(mrioc, "failed to refresh triggers\n");
+		goto out_failed;
+	}
+
 	dprint_reset(mrioc, "posting driver diag buffer\n");
 	retval = mpi3mr_alloc_issue_host_diag_buf(mrioc);
 	if (retval) {
@@ -5383,6 +5432,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	int retval = 0, i;
 	unsigned long flags;
 	u32 host_diagnostic, timeout = MPI3_SYSIF_DIAG_SAVE_TIMEOUT * 10;
+	union mpi3mr_trigger_data trigger_data;
 
 	/* Block the reset handler until diag save in progress*/
 	dprint_reset(mrioc,
@@ -5415,10 +5465,13 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	mrioc->reset_in_progress = 1;
 	mrioc->stop_bsgs = 1;
 	mrioc->prev_reset_result = -1;
+	memset(&trigger_data, 0, sizeof(trigger_data));
 
 	if ((!snapdump) && (reset_reason != MPI3MR_RESET_FROM_FAULT_WATCH) &&
 	    (reset_reason != MPI3MR_RESET_FROM_FIRMWARE) &&
 	    (reset_reason != MPI3MR_RESET_FROM_CIACTIV_FAULT)) {
+		mpi3mr_set_trigger_data_in_all_hdb(mrioc,
+		    MPI3MR_HDB_TRIGGER_TYPE_SOFT_RESET, NULL, 0);
 		dprint_reset(mrioc,
 		    "soft_reset_handler: releasing host diagnostic buffers\n");
 		mpi3mr_release_diag_bufs(mrioc, 0);
@@ -5441,6 +5494,8 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		retval = mpi3mr_issue_reset(mrioc,
 		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
 		if (!retval) {
+			trigger_data.fault = (readl(&mrioc->sysif_regs->fault) &
+				      MPI3_SYSIF_FAULT_CODE_MASK);
 			do {
 				host_diagnostic =
 				    readl(&mrioc->sysif_regs->host_diagnostic);
@@ -5449,6 +5504,8 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 					break;
 				msleep(100);
 			} while (--timeout);
+			mpi3mr_set_trigger_data_in_all_hdb(mrioc,
+			    MPI3MR_HDB_TRIGGER_TYPE_FAULT, &trigger_data, 0);
 		}
 	}
 
@@ -5485,6 +5542,14 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	}
 	mpi3mr_memset_buffers(mrioc);
 	mpi3mr_release_diag_bufs(mrioc, 1);
+	mrioc->fw_release_trigger_active = false;
+	mrioc->trace_release_trigger_active = false;
+	mrioc->snapdump_trigger_active = false;
+	mpi3mr_set_trigger_data_in_all_hdb(mrioc,
+	    MPI3MR_HDB_TRIGGER_TYPE_SOFT_RESET, NULL, 0);
+
+	dprint_reset(mrioc,
+	    "soft_reset_handler: reinitializing the controller\n");
 	retval = mpi3mr_reinit_ioc(mrioc, 0);
 	if (retval) {
 		pr_err(IOCNAME "reinit after soft reset failed: reason %d\n",
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 5f975e0db388..0e1c87b02e91 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -241,6 +241,40 @@ static void mpi3mr_fwevt_add_to_list(struct mpi3mr_ioc *mrioc,
 	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 }
 
+/**
+ * mpi3mr_hdb_trigger_data_event - Add hdb trigger data event to
+ * the list
+ * @mrioc: Adapter instance reference
+ * @event_data: Event data
+ *
+ * Add the given hdb trigger data event to the firmware event
+ * list.
+ *
+ * Return: Nothing.
+ */
+void mpi3mr_hdb_trigger_data_event(struct mpi3mr_ioc *mrioc,
+	struct trigger_event_data *event_data)
+{
+	struct mpi3mr_fwevt *fwevt;
+	u16 sz = sizeof(*event_data);
+
+	fwevt = mpi3mr_alloc_fwevt(sz);
+	if (!fwevt) {
+		ioc_warn(mrioc, "failed to queue hdb trigger data event\n");
+		return;
+	}
+
+	fwevt->mrioc = mrioc;
+	fwevt->event_id = MPI3MR_DRIVER_EVENT_PROCESS_TRIGGER;
+	fwevt->send_ack = 0;
+	fwevt->process_evt = 1;
+	fwevt->evt_ctx = 0;
+	fwevt->event_data_size = sz;
+	memcpy(fwevt->event_data, event_data, sz);
+
+	mpi3mr_fwevt_add_to_list(mrioc, fwevt);
+}
+
 /**
  * mpi3mr_fwevt_del_from_list - Delete firmware event from list
  * @mrioc: Adapter instance reference
@@ -898,6 +932,8 @@ void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
 		}
 	} else
 		mpi3mr_remove_tgtdev_from_sas_transport(mrioc, tgtdev);
+	mpi3mr_global_trigger(mrioc,
+	    MPI3_DRIVER2_GLOBALTRIGGER_DEVICE_REMOVAL_ENABLED);
 
 	ioc_info(mrioc, "%s :Removed handle(0x%04x), wwid(0x%016llx)\n",
 	    __func__, tgtdev->dev_handle, (unsigned long long)tgtdev->wwid);
@@ -1429,6 +1465,62 @@ struct mpi3mr_enclosure_node *mpi3mr_enclosure_find_by_handle(
 	return r;
 }
 
+/**
+ * mpi3mr_process_trigger_data_event_bh - Process trigger event
+ * data
+ * @mrioc: Adapter instance reference
+ * @event_data: Event data
+ *
+ * This function releases diage buffers or issues diag fault
+ * based on trigger conditions
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_process_trigger_data_event_bh(struct mpi3mr_ioc *mrioc,
+	struct trigger_event_data *event_data)
+{
+	struct diag_buffer_desc *trace_hdb = event_data->trace_hdb;
+	struct diag_buffer_desc *fw_hdb = event_data->fw_hdb;
+	unsigned long flags;
+	int retval = 0;
+	u8 trigger_type = event_data->trigger_type;
+	union mpi3mr_trigger_data *trigger_data =
+		&event_data->trigger_specific_data;
+
+	if (event_data->snapdump)  {
+		if (trace_hdb)
+			mpi3mr_set_trigger_data_in_hdb(trace_hdb, trigger_type,
+			    trigger_data, 1);
+		if (fw_hdb)
+			mpi3mr_set_trigger_data_in_hdb(fw_hdb, trigger_type,
+			    trigger_data, 1);
+		mpi3mr_soft_reset_handler(mrioc,
+			    MPI3MR_RESET_FROM_TRIGGER, 1);
+		return;
+	}
+
+	if (trace_hdb) {
+		retval = mpi3mr_issue_diag_buf_release(mrioc, trace_hdb);
+		if (!retval) {
+			mpi3mr_set_trigger_data_in_hdb(trace_hdb, trigger_type,
+			    trigger_data, 1);
+		}
+		spin_lock_irqsave(&mrioc->trigger_lock, flags);
+		mrioc->trace_release_trigger_active = false;
+		spin_unlock_irqrestore(&mrioc->trigger_lock, flags);
+	}
+	if (fw_hdb) {
+		retval = mpi3mr_issue_diag_buf_release(mrioc, fw_hdb);
+		if (!retval) {
+			mpi3mr_set_trigger_data_in_hdb(fw_hdb, trigger_type,
+		    trigger_data, 1);
+		}
+		spin_lock_irqsave(&mrioc->trigger_lock, flags);
+		mrioc->fw_release_trigger_active = false;
+		spin_unlock_irqrestore(&mrioc->trigger_lock, flags);
+	}
+}
+
 /**
  * mpi3mr_encldev_add_chg_evt_debug - debug for enclosure event
  * @mrioc: Adapter instance reference
@@ -2015,6 +2107,12 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 		    "scan for non responding and newly added devices after soft reset completed\n");
 		break;
 	}
+	case MPI3MR_DRIVER_EVENT_PROCESS_TRIGGER:
+	{
+		mpi3mr_process_trigger_data_event_bh(mrioc,
+		    (struct trigger_event_data *)fwevt->event_data);
+		break;
+	}
 	default:
 		break;
 	}
@@ -2853,6 +2951,7 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		ack_req = 1;
 
 	evt_type = event_reply->event;
+	mpi3mr_event_trigger(mrioc, event_reply->event);
 
 	switch (evt_type) {
 	case MPI3_EVENT_DEVICE_ADDED:
@@ -2891,6 +2990,11 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		ack_req = 0;
 		break;
 	}
+	case MPI3_EVENT_DIAGNOSTIC_BUFFER_STATUS_CHANGE:
+	{
+		mpi3mr_hdbstatuschg_evt_th(mrioc, event_reply);
+		break;
+	}
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
 	case MPI3_EVENT_LOG_DATA:
 	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
@@ -3154,6 +3258,7 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 		    MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_LOGINFOAVAIL)
 			ioc_loginfo = le32_to_cpu(status_desc->ioc_log_info);
 		ioc_status &= MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_STATUS_MASK;
+		mpi3mr_reply_trigger(mrioc, ioc_status, ioc_loginfo);
 		break;
 	case MPI3_REPLY_DESCRIPT_FLAGS_TYPE_ADDRESS_REPLY:
 		addr_desc = (struct mpi3_address_reply_descriptor *)reply_desc;
@@ -3182,6 +3287,12 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 		ioc_status &= MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_STATUS_MASK;
 		if (sense_state == MPI3_SCSI_STATE_SENSE_BUFF_Q_EMPTY)
 			panic("%s: Ran out of sense buffers\n", mrioc->name);
+		if (sense_buf) {
+			scsi_normalize_sense(sense_buf, sense_count, &sshdr);
+			mpi3mr_scsisense_trigger(mrioc, sshdr.sense_key,
+			    sshdr.asc, sshdr.ascq);
+		}
+		mpi3mr_reply_trigger(mrioc, ioc_status, ioc_loginfo);
 		break;
 	case MPI3_REPLY_DESCRIPT_FLAGS_TYPE_SUCCESS:
 		success_desc = (struct mpi3_success_reply_descriptor *)reply_desc;
@@ -3807,6 +3918,8 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 	default:
 		break;
 	}
+	mpi3mr_global_trigger(mrioc,
+	    MPI3_DRIVER2_GLOBALTRIGGER_TASK_MANAGEMENT_ENABLED);
 
 out_unlock:
 	drv_cmd->state = MPI3MR_CMD_NOTUSED;
-- 
2.31.1


--0000000000002eedde06186adee7
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQbQYJKoZIhvcNAQcCoIIQXjCCEFoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3EMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBUwwggQ0oAMCAQICDExX4+q15YXlYbDuOzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjExMTQxMjAzMThaFw0yNTExMTQxMjAzMThaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDFJhbmphbiBLdW1hcjEoMCYGCSqGSIb3DQEJ
ARYZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAOgccBnKTcRY5ViAG6iAGKWZ8pjYBaC0yPSOnu903VijdPFPnRdvshVcVxr6QvmlBCzKJaet
zZlOdDzH9Sh5FfHxwia1H790mce+cjggA6koNdslP25m4SfoAUcvLxNk1koVjbyxvNPG40Mlg8f8
Dp9JubCHz3kEFHjItKFkpS8CHMR1Hx4Cnws434zD/pz1TMUmYyq1kma0Vi8YPVlwkaHgq4J/9Lw/
GK2Ee6ez7fr/FL1RWbOPVHJR+deNIorOjW7U5HVwnRYhM1OR4mAkrkqcN+3kwae0KmVO3SDKFd7h
Ok4L2e1ixyaRTo379Ur3iVTnagglDOliayMGRITBPe0CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU8WuEiYXvpeCaubgLCCFoyRBc
8QwwDQYJKoZIhvcNAQELBQADggEBAA5th3yz1fvJCBmK21x68IdDNFC0gmynT76I3fOgslLHc7ey
lC9VXLb+vJ863blS/WxEOwf0fvc0ks7qYWl8xisInHu5AX9glaooGhLImlzE0l9rDf0tcq2kkgc4
CXL9UGDEoqdxfRj3j9xn9fm9gpTBWSck6ufc/8RV1TLVjcZvrYkMqQwoVulGkr+HCnzaEFxBRmO/
nWsVitGa1sKS9usFXoW1bQXgJ9TtRdy8gka8b9SaKnh4TaiEKpdl8ztXhugWp7RpFGVu/ZZ8narx
0H1L9W/UIr3J/uYokdFr+hIrXOfOwJLB18bWOTCVWxTEo4zYC8qZ/h7UcS5aispm/rkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxMV+PqteWF5WGw7jsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIH35SnCPTqMhQLEtOGr7sPR1a898WwiX
d/uBh91m4ucrMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDUx
NDE0MzIxM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAeUJMESfVtYZ9suYK8wARvd9czQufhFX0sXp0CRWuX7necsFX6
QdQwdOyBnmxlwK/GqUidOpwR/FXo2WRioQdo1TseDZIWAuiJo088clIcupXgL/Rml4Cj4wtTpuWd
9bq+io/uTRhu2+DwhSanJNiwjs2r+V3AN/RaDLmvT7ngWY527m/1No3tVQkJvH1dAF2YwmhZm2UB
S7P2ElkD+a3NzJ1frK2CgXbmY3zBQWowiup0YUum/uXdm0R9fGq9GsQEhDXSj+dNDOF4Qbow/buc
9HOjuEfG5RX/959HFjWajB8RX7+4mgYB3WfLv2RI7kMyr5waj+HTG9fAvr3Npm0K
--0000000000002eedde06186adee7--
