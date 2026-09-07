Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6013B3890EE
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 06:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762938; cv=none; b=laxCat7t2lXvhHItt/+ysgbcYE7R64MM9X/UUuuMAz7zisgIESUw4LZdTjNPOphVYYEJ/m0J9xogehe7gwmqLBAhKF7eWG7l/yX0BPPYNwc/e8dDIfnEepnZjVXEGo3ry9RI+/IjvtzxtgCxtbaEMUaW2cp82Nj0yPG8yn5E04g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762938; c=relaxed/simple;
	bh=4Gfy17V7FzI7j7+uvkegy6iqdwRYBhYG7cqL/hxfzWw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hxqQlPBO2nYrKzPAYiLqFUSCY3R1UjPwWFtoXltar7dKtlLf1vY233iy7r+m9d4sDeKzhumctALLJjB4bA0uYh6J6zsE5f53lH1SdaUEmz7WfkFXOXIX6d8U2AjfsdMvNMLq0WNdIpi6snmfB2mDtV55rDqe0ilzdz+26b/o2po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YlNVUdav; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YlNVUdav"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84e0688b7e8so2412570b3a.1
        for <linux-scsi@vger.kernel.org>; Sun, 06 Sep 2026 23:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788762937; x=1789367737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4J4rYjNQoetFmHhwvDThjrrPfLTRssIW7zzZbk53w90=;
        b=YlNVUdavf/ePiDv61spsZ5Wx4nFqISGk88YzuA+U3EcUeeoyOESkREoNRm9IPURJ+c
         Z6Zsj8v4Wdwv+/O+gvLddTmvFIp5VEfudBBB6ey3mZjtgez0WbTqpn90NJSRRab/HbbJ
         9V331n2HOMgJpMi7DYdqOQpL5mAZ6x2xzccEVQMFGKaF6em+2V+wVQItKthbJz0bx1nl
         WA0S+T52xeDgS/KKqdqSEPSaPe8i/UQLt1Mriw1gI8p2ogMYXJPcK6HM96/1jXK0iHpo
         hPwmkaoFNbwqaX7RPpg7sbFeXHnY6yftip85xfjSmrjE+7vOBN8IxgGH8p49jjQGlT49
         WbZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788762937; x=1789367737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4J4rYjNQoetFmHhwvDThjrrPfLTRssIW7zzZbk53w90=;
        b=NF+kTpSReFnw9fPeaZhYyrlLcKI6Ldn9JdfvV1Tw26dTZSu3yeXOEIRIm5r7IZ5Opg
         5mu5vZNe8bq8eLNNzoTgEd9mnwq/NoWgQirw/I47EnZ+koXNg1U25EGw1aGWoqgivym5
         YlyirPmIjK8BLqhtNtFbzNEgDEDo3kSEkZ6x01PFok4iTmqQ1ZcO8UBuZPbzCwZZ0tgc
         yFeQm/1BZsjcahpaKdI2Fb1zgYG9zrnJQ9GSoioiIWyP4jU4HTTkvMCXSLOMTBZiCT8Q
         EjKlxaXV9jWgzYml8DJwdDtEeyLgqj9kcz0EmNMT01tT+zBX2zz1+ZrDSx5/k0RuZlv6
         yeHg==
X-Forwarded-Encrypted: i=1; AKwUvBzjpXrRc61NQomW8kjtNiuXSvG34xHKOeqK71X8BMkMJn7jtu7T/Wr3x5mvf+442jYjHIX43FArqoiI@vger.kernel.org
X-Gm-Message-State: AFuF++lSzsjvm37AHliZo2n/nyWHq7CjNiBv+uG9uUExlxusb3sYoDLR
	d+nM6DgMfH26L+llyS0saSi7NbVtTTwv8Fzdf2K1LAtShC5cYV/qsfzZ
X-Gm-Gg: AYBFou045XJCMcNoIxXEvb6oGKxrrpYy+BM3/80a6mY2ovQwYkVD2CWmM0OyZXEk1tV
	AzIFqI1paMrR5zPWtBQm9YOPRD5t8fEhCYDmKx9/Ia2+J4E4frAGW2YYo4y7mE0vgP0uAYjWoxd
	Jsj6iXQWG895ZtJu3f1/im8I3NEsoOBqNkEvqBBe0oiBpJWUPDH+/t5oBeWmG1dcKGze84FLMSf
	VUyrTPNI25Cm3VjKSx6sAOlIf/1eCALquN0sN5xSTC+WsZVNzBX0XBdNUu+r5hxMtePBvvxTzPp
	5f+7I4+HL6wO3PFAqVTpl9PKe3S5XmN++Y92DA4LkxnGm16YyY/QVEL8/3Qnea+FW9Qtpg5GCaA
	VlSKRUAzPkowqFQaEqcEhIzdpKzr82JDRRNanr6Ar57BnzK0XsGOHPP+Op8IVKY/Pb0vRj3mUSM
	U6KzYqzSHg0mHWleDpRpuWGwSSptgZ6CRgos17DfLG7FTZ+2P8fQC4VgV3sfZuSaRxhE+O12/Bc
	G41q/y/XqVocg==
X-Received: by 2002:a05:6a21:2983:b0:3d9:6f0:b42f with SMTP id adf61e73a8af0-3da39fd0822mr34557933637.17.1788762936771;
        Sun, 06 Sep 2026 23:35:36 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339aa37dbdsm21319326eec.11.2026.09.06.23.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:35:36 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] xen: fix typos in comments
Date: Mon,  7 Sep 2026 12:05:31 +0530
Message-ID: <20260907063531.23981-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/scsi/xen-scsifront.c     | 2 +-
 drivers/xen/mcelog.c             | 2 +-
 include/xen/interface/platform.h | 4 ++--
 include/xen/interface/xen.h      | 2 +-
 include/xen/xenbus.h             | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 989bcaee42ca..f86a47056ea8 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -1076,7 +1076,7 @@ static void scsifront_do_lun_hotplug(struct vscsifrnt_info *info, int op)
 
 		/*
 		 * Front device state path, used in sdev_configure called
-		 * on successfull scsi_add_device, and in sdev_destroy called
+		 * on successful scsi_add_device, and in sdev_destroy called
 		 * on remove of a device.
 		 */
 		snprintf(info->dev_state_path, sizeof(info->dev_state_path),
diff --git a/drivers/xen/mcelog.c b/drivers/xen/mcelog.c
index 32ab419bb503..f19cc7a67f36 100644
--- a/drivers/xen/mcelog.c
+++ b/drivers/xen/mcelog.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  * mcelog.c
- * Driver for receiving and transferring machine check error infomation
+ * Driver for receiving and transferring machine check error information
  *
  * Copyright (c) 2012 Intel Corporation
  * Author: Liu, Jinsong <jinsong.liu@intel.com>
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
index 79a443c65ea9..462e36392a9f 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -421,10 +421,10 @@ struct xenpf_pcpuinfo {
 	/* IN */
 	uint32_t xen_cpuid;
 	/* OUT */
-	/* The maxium cpu_id that is present */
+	/* The maximum cpu_id that is present */
 	uint32_t max_present;
 #define XEN_PCPU_FLAGS_ONLINE   1
-	/* Correponding xen_cpuid is not present*/
+	/* Corresponding xen_cpuid is not present*/
 #define XEN_PCPU_FLAGS_INVALID  2
 	uint32_t flags;
 	uint32_t apic_id;
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 40c9793e9880..f9acb21875cf 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -94,7 +94,7 @@
 #define VIRQ_XENOPROF   7  /* V. XenOprofile interrupt: new sample available */
 #define VIRQ_CON_RING   8  /* G. (DOM0) Bytes received on console            */
 #define VIRQ_PCPU_STATE 9  /* G. (DOM0) PCPU state changed                   */
-#define VIRQ_MEM_EVENT  10 /* G. (DOM0) A memory event has occured           */
+#define VIRQ_MEM_EVENT  10 /* G. (DOM0) A memory event has occurred           */
 #define VIRQ_XC_RESERVED 11 /* G. Reserved for XenClient                     */
 #define VIRQ_ENOMEM     12 /* G. (DOM0) Low on heap memory       */
 #define VIRQ_XENPMU     13  /* PMC interrupt                                 */
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 8ca15743af7f..6424c5cf8ef5 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -63,7 +63,7 @@ struct xenbus_watch
 	unsigned int nr_pending;
 
 	/*
-	 * Called just before enqueing new event while a spinlock is held.
+	 * Called just before enqueuing new event while a spinlock is held.
 	 * The event will be discarded if this callback returns false.
 	 */
 	bool (*will_handle)(struct xenbus_watch *,
-- 
2.48.1

