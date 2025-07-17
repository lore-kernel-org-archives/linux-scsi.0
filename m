Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A6E2FCE34
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 19:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752781233; cv=none; b=kk3+M2VScwWsL8BdXGkiQRWBMb+7M0zOaQrFnGRlA8dNSSGuwYK1iMMEL4NrasMl8z12Oi8Hsv2b1ehLTGErknWW+RgoUsMnpIiif5VBflYA4rP6OKKZtBRkFvL3kCP5DeboU2qe/BgFbWEwAg8b1zLxnbJbtjSu5ajQCkwiJ5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752781233; c=relaxed/simple;
	bh=J5T522Xe3jwCY3eAP8SMXr/V7enkbaM2npbeBlIkiMc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kPPk/P4pT7b+S2B+N1gxcxp9pQ4TSO9U806Xmd/nb5B350TtYfNhUI0X+UBWWsYJDKDkhjnz4Yaf9nxPsiuAwYIhkJzGsglAttKYyT2wdOermnGBUQLEXSffSvmjB92oy6bxXMHsFYZQvHNFzhXwcQH5wFTmbblQSArSHxaAwTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iZI7wLv5; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iZI7wLv5"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74b4d2f67d5so1170959b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 12:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752781231; x=1753386031; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EabJr18a3SZdXkqRpkIMgBHho+rbTVnRfJqLTg0l/2k=;
        b=iZI7wLv5s3zEzFg3rI1f8o+PPq7IWmE+iE0JLWfUksOJUpHOfYUiwj2RlZqjQpkrRF
         Cd2P279rMV2jZKnk7MhL4svPmOkk+EtIlgbL+xMEVnVyEtripKQJmpUTwFMOdOEHi+HD
         ikvMY65laYP5Z1fCNW7S0LxgvK534TBmr0yZOrKrU1oVmM3Pv79bc2SrjTNLjG/ZQSeC
         GWx59nSGT6JSgGiVYbifVsX8wxZmqCXVMiwZw/r1/9G3redOxxMxcfVFN0jbWMop6Zfl
         jMFSUYo4vkoW9ApTW2mrpTeCX89Qd3dopLnjVH8KBoKM7z2jSgPnZdKIP3iUgw/gABHC
         lb/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752781231; x=1753386031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EabJr18a3SZdXkqRpkIMgBHho+rbTVnRfJqLTg0l/2k=;
        b=OP8vLLzrQ3d0k7odIaGDbEVt2pcrv2qObuZgjBRr8ntrC1IvTzy/FH1heX6aenfOzw
         C7a01xMoMxf78keZkk0LjS8lTgp9IfXOu0mRivXjFpucSCsloaN4Qdf5LwD4nOVmYzj/
         joRosbqsZbGAduwXVqooFSPldi/HHtuJmfNjOULSgSDrkDhHieDoYdAcVnqnJx+qfnFB
         QqKlGfE8y/ra8/i8ginJZOK2ueCChW4kF9ILLYMDF4siMTWR5cxxk0yt1IpdoFZk5gzU
         CokoZOJDAT8P1gMO0Bzn9Tuget8dr14+lrSm3WbMWp3RtLaMFd2CTfd7+wUr6f0It6p+
         +STw==
X-Forwarded-Encrypted: i=1; AJvYcCVtsRFL451TCY0dbVdDS5yoYCCueUj60mKobZhNFrm20FoTr569u4MbGLspU5+Tw+zaCZf0607lO/SN@vger.kernel.org
X-Gm-Message-State: AOJu0YyGMKVNNvvD1oHnDZYvj76cq51PuTnSCkEiz6tmku2HUQEqG3rj
	ZOoDW/fXRGVNeY9JjMjkcZiT5ioXcimzdTK+/v+9TAvlQ65AyKtzH84rob5Sme0FzV8+muQdjDj
	/hpjBpvXfpQpOcfMnKs1HJLZpXA==
X-Google-Smtp-Source: AGHT+IET9IaKD5CuoVhly7YexMTdSilD1ZfKaS6gelsVj0NBUm48zNtNHHWQ7BYJMEXFZUmxjmmo3qvk/nU3bh+Ptg==
X-Received: from pfbjw38.prod.google.com ([2002:a05:6a00:92a6:b0:748:ec4d:30ec])
 (user=salomondush job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a22:b0:225:7617:66ff with SMTP id adf61e73a8af0-2391c962646mr266495637.20.1752781230976;
 Thu, 17 Jul 2025 12:40:30 -0700 (PDT)
Date: Thu, 17 Jul 2025 19:40:25 +0000
In-Reply-To: <30f8ea8d-79c4-4e5c-b354-51ad8146a61c@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <30f8ea8d-79c4-4e5c-b354-51ad8146a61c@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717194025.3218107-1-salomondush@google.com>
Subject: [PATCH v2] scsi: mpi3mr: Emit uevent on controller diagnostic fault
From: Salomon Dushimirimana <salomondush@google.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com, kashyap.desai@broadcom.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	salomondush@google.com, sathya.prakash@broadcom.com, 
	sreekanth.reddy@broadcom.com, sumit.saxena@broadcom.com
Content-Type: text/plain; charset="UTF-8"

Introduces a uevent mechanism to notify userspace when the controller
undergoes a reset due to a diagnostic fault. A new function,
mpi3mr_fault_event_emit(), is added and called from the reset path. This
function filters for a diagnostic fault type
(MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT) and generates a uevent
containing details about the event:

- DRIVER: mpi3mr in this case
- HBA_NUM: scsi host id
- EVENT_TYPE: indicates fatal error
- RESET_TYPE: type of reset that has occurred
- RESET_REASON: specific reason for the reset

This will allow userspace tools to subscribe to these events and take
appropriate action.

Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
---
Changes in v2:
- Addressed feedback from Bart regarding use of __free(kfree) and more

 drivers/scsi/mpi3mr/mpi3mr_fw.c | 37 +++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 1d7901a8f0e40..a050c4535ad82 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1623,6 +1623,42 @@ static inline void mpi3mr_set_diagsave(struct mpi3mr_ioc *mrioc)
 	writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
 }
 
+/**
+ * mpi3mr_fault_uevent_emit - Emit uevent for a controller diagnostic fault
+ * @mrioc: Pointer to the mpi3mr_ioc structure for the controller instance
+ * @reset_type: The type of reset that has occurred
+ * @reset_reason: The specific reason code for the reset
+ *
+ * This function is invoked when the controller undergoes a reset. It specifically
+ * filters for MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT and ignores other
+ * reset types, such as soft resets.
+ */
+static void mpi3mr_fault_uevent_emit(struct mpi3mr_ioc *mrioc, u16 reset_type,
+	u16 reset_reason)
+{
+	struct kobj_uevent_env *env __free(kfree);
+
+	if (reset_type != MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT)
+		return;
+
+	env = kzalloc(sizeof(*env), GFP_KERNEL);
+	if (!env)
+		return;
+
+	if (add_uevent_var(env, "DRIVER=%s", mrioc->driver_name))
+		return;
+	if (add_uevent_var(env, "HBA_NUM=%u", mrioc->id))
+		return;
+	if (add_uevent_var(env, "EVENT_TYPE=FATAL_ERROR"))
+		return;
+	if (add_uevent_var(env, "RESET_TYPE=%s", mpi3mr_reset_type_name(reset_type)))
+		return;
+	if (add_uevent_var(env, "RESET_REASON=%s", mpi3mr_reset_rc_name(reset_reason)))
+		return;
+
+	kobject_uevent_env(&mrioc->shost->shost_gendev.kobj, KOBJ_CHANGE, env->envp);
+}
+
 /**
  * mpi3mr_issue_reset - Issue reset to the controller
  * @mrioc: Adapter reference
@@ -1741,6 +1777,7 @@ static int mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type,
 	    ioc_config);
 	if (retval)
 		mrioc->unrecoverable = 1;
+	mpi3mr_fault_uevent_emit(mrioc, reset_type, reset_reason);
 	return retval;
 }
 
-- 
2.50.0.727.gbf7dc18ff4-goog

