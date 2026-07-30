Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588543BAD89
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 20:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785442307; cv=none; b=kzmcSaKvGmzTAW7AwMmsweirLm10bi0PaWgtnGB46Y0vszLO+3trrHnFrdqAXcOpQkqXS7QM6uOsf6M57kTFA1OA1xs8a1gnbLNBsbAUHQKX5dM27sNI+JhtiY4aDULvT3CIU5F+7VyPsfTI6ibGMtUY6kVjzCAIJgeR1VFZOuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785442307; c=relaxed/simple;
	bh=cM4XkvF7y2BcRDcPI9DO0f3mTOQg4RfEJTwnq/GPqwE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Di4h7pEaglxxxwm63r8cpymCFfCWN4RnvmhSdXuma9kxKVyx45KV1qvH2un5UJcMFkYSuk8exA0MWP2ubBRmBf6PEDzdeGNo62cUTffgQRnThh/xsVNQvATiVTbLIHZWNVLIp74YFcoYex0oE3opa+kiyDhtkgk6MZ0V5VsOb2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ftGi+Kh3; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ftGi+Kh3"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84867f07d63so350325b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 13:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785442296; x=1786047096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pHOPI0ut4H55mAZaYylYOWy1NMuvGn1YFD0lfQuRbRc=;
        b=ftGi+Kh3A1bdxNpxyKrhPmCDEdThdnpxKLwrERZjZiYFYjNxpcrTnNrHIUivc2kHck
         fMVmJGkNEDl5TjDIPX7NafzhowByopJWjpnTiwmp5lDBWlxdg9+umrljG5sqvdSwnYTR
         4PaNm5Iy74TSpXNmelTaR4iteVw71a+Vc7OsHsXK1e1BCDj8sPZ5DfK3Gp8UOtnubk9C
         fXKj/ayXf9GikLQ7BXzDalp6X1FmLgiiHHeLz8EEhXtbvixBd2mckIp0S4HHyO04HR92
         +xT4K61Khy3p7KxT2FpVaDHGwRkX6w6/KfRTid/ptMjE7wHz3oY15jzcQS7PaU2e01+m
         WNmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785442296; x=1786047096;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pHOPI0ut4H55mAZaYylYOWy1NMuvGn1YFD0lfQuRbRc=;
        b=YJ1NTvDqkOrT9cSK6aepmlTWPpYAgQHHOAOYGtrYfwCcDtPK0G7zpE2sxV9M8bpBxF
         jX/vRUVuhbsy2RSVFYz/k+Nmvz09e5RuYv3ehUdlHN/KRhaiCYxd0hQjum5nSH4K1+Z4
         ihm4GLGKuSkPTGEAjk0m46wGztOB1vLaIYMezVdVkfh2qd9xuMmF2lfZoyZv+UPpPswd
         iT3sZwdmmFumsAqNHl76DXXrqSOy9/aa/EE+laB7rE2Hl+h/URO3YY54+L0P6yf2vP/C
         kgWpCDGq1bhuvI4jBxX4cKTLhvDssBQSaPtvaR7jLbWkfun2YUfcYwmCsPRsSkDSziIC
         tT9Q==
X-Forwarded-Encrypted: i=1; AHgh+RpLiQayttFt0Ivvlk5n6BymopHY3MSlEdzopD+/lNOKCIXMkHiVrJ1M3LxnSVgqWz0bqIkj5kyJ+ie6@vger.kernel.org
X-Gm-Message-State: AOJu0YyGtNboA+NoRDIsdZb+FOOnhmRapck05FMNp6qam+0vqyvk2O76
	XQYZTRwk73zvBxMIfRp2zKc47dCwhelnVzEtiR90/MmmJSZCb6GpQpaj
X-Gm-Gg: AR+sD12FE9SK3odFVP+uy3xyszJHIWmaGtPy9S1gIffgVmFYrvVL+bVtryC9SVo9Dxs
	KL4vfZS0lIrZxIX7v9RhRiroKCQLuaEjz/74W5CnHAcKhXCAPF43/FM/RKxqpK2SEg87cCvzhhf
	MCnc8WU9ZjoDGjy87z/nmPWSnhiwnL0+hkkER2dkn0OPs3c8WBt4KkxeRHU2+e5MZYebOd75EjM
	Fk+ihffYHDWXm4Ix/jUFKLgVeFViXlP3GncTPjwxBlEoGuRSVVW0Susfodzzsn2g7phgzW1M2i5
	pLfA6inP6onNebiHxIK66IH7+UmwaptjYlK5htjPlWtXvfHeNZtvAGJGI6kw9s35/c2uV9lpihv
	cuBZRMTbQnsLjo7JpEF06FINOJejUGBM0CA06NfwWiezM5c3KtdD7yfHAbzCr4EECsK/+FsdVRV
	VFpzTtW0GZQXW4KP3o85ErZksThiXZ044I7dlpsFUNbwpiUhrPyW5rY6WcNbFODgyVxJqFID2Ex
	q7tXzT2XM3T7/cIhyvT0+S6FoTcLYPAuxf4OW1GLSO5txbrfXiv9Q==
X-Received: by 2002:a05:6a00:e13:b0:84a:64ea:e767 with SMTP id d2e1a72fcca58-84ebc3db9bdmr3490632b3a.49.1785442295721;
        Thu, 30 Jul 2026 13:11:35 -0700 (PDT)
Received: from localhost.localdomain (c-174-165-208-10.hsd1.wa.comcast.net. [174.165.208.10])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea0055325sm3689108b3a.15.2026.07.30.13.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 13:11:34 -0700 (PDT)
From: Michael Kelley <mhkelley58@gmail.com>
X-Google-Original-From: Michael Kelley <mhklinux@outlook.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	daniel.lezcano@kernel.org,
	ssengar@linux.microsoft.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	sgarzare@redhat.com,
	horms@kernel.org
Cc: x86@kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [RESEND PATCH 1/6] Drivers: hv: Remove support for WS2012/2012R2 & Win8/8.1 version of Hyper-V
Date: Thu, 30 Jul 2026 13:11:18 -0700
Message-Id: <20260730201123.1767-2-mhklinux@outlook.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730201123.1767-1-mhklinux@outlook.com>
References: <20260730201123.1767-1-mhklinux@outlook.com>
Reply-To: mhklinux@outlook.com
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linux code for running as a Hyper-V guest includes special cases for
running on Hyper-V in WS2012/2012R2 and Windows 8/8.1. These versions
were initially released 14 years ago, and official support ended in 2023
(unless a customer has contracted for extended security updates). Given
the release of subsequent versions with improved functionality, there's
no need to continue to support the latest Linux kernels on these versions
of Hyper-V. If someone is running Linux on one of these older Hyper-V
versions and doesn't want to upgrade, they can continue to do so as
presumably they don't want upgrade the Linux version either.

Simplify Linux code by removing special cases for running on these
old versions of Hyper-V. Remove the negotiation of the VMBus protocol
versions for WS2012/Win8, and remove special case code based on those
VMBus protocol versions. Also update the balloon and snapshot drivers
to no longer negotiate driver-specific protocol versions for these
older Hyper-V versions, and remove any related special cases.

Signed-off-by: Michael Kelley <mhklinux@outlook.com>
---
 drivers/hv/channel_mgmt.c |  4 ----
 drivers/hv/connection.c   |  8 ++++----
 drivers/hv/hv_balloon.c   | 36 +++++++++++++++---------------------
 drivers/hv/hv_snapshot.c  |  5 -----
 include/linux/hyperv.h    |  5 ++---
 5 files changed, 21 insertions(+), 37 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 89d214dda360..84dc56a06c78 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -933,10 +933,6 @@ void vmbus_initiate_unload(bool crash)
 	if (xchg(&vmbus_connection.conn_state, DISCONNECTED) == DISCONNECTED)
 		return;
 
-	/* Pre-Win2012R2 hosts don't support reconnect */
-	if (vmbus_proto_version < VERSION_WIN8_1)
-		return;
-
 	reinit_completion(&vmbus_connection.unload_event);
 	memset(&hdr, 0, sizeof(struct vmbus_channel_message_header));
 	hdr.msgtype = CHANNELMSG_UNLOAD;
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 0fd50d4cb573..a9e87cf3f51c 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -47,7 +47,9 @@ EXPORT_SYMBOL_GPL(vmbus_proto_version);
 
 /*
  * Table of VMBus versions listed from newest to oldest.
- * VERSION_WIN7 and VERSION_WS2008 are no longer supported in
+ * VERSION_WIN7,VERSION_WS2008, VERSION_WIN8 (which is
+ * Windows Server 2012) and VERSION_WIN8_1 (which is
+ * Windows Server 2012 R2) are no longer supported in
  * Linux guests and are not listed.
  */
 static __u32 vmbus_versions[] = {
@@ -57,9 +59,7 @@ static __u32 vmbus_versions[] = {
 	VERSION_WIN10_V5_1,
 	VERSION_WIN10_V5,
 	VERSION_WIN10_V4_1,
-	VERSION_WIN10,
-	VERSION_WIN8_1,
-	VERSION_WIN8
+	VERSION_WIN10
 };
 
 /*
diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 42ce27be344d..9cba97e81111 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -58,6 +58,10 @@
 #define DYNMEM_MAJOR_VERSION(Version) ((__u32)(Version) >> 16)
 #define DYNMEM_MINOR_VERSION(Version) ((__u32)(Version) & 0xff)
 
+/*
+ * VERSION_1 and VERSION_2 are retained for the historical record,
+ * but are no longer supported in Linux guests.
+ */
 enum {
 	DYNMEM_PROTOCOL_VERSION_1 = DYNMEM_MAKE_VERSION(0, 3),
 	DYNMEM_PROTOCOL_VERSION_2 = DYNMEM_MAKE_VERSION(1, 0),
@@ -65,9 +69,7 @@ enum {
 
 	DYNMEM_PROTOCOL_VERSION_WIN7 = DYNMEM_PROTOCOL_VERSION_1,
 	DYNMEM_PROTOCOL_VERSION_WIN8 = DYNMEM_PROTOCOL_VERSION_2,
-	DYNMEM_PROTOCOL_VERSION_WIN10 = DYNMEM_PROTOCOL_VERSION_3,
-
-	DYNMEM_PROTOCOL_VERSION_CURRENT = DYNMEM_PROTOCOL_VERSION_WIN10
+	DYNMEM_PROTOCOL_VERSION_WIN10 = DYNMEM_PROTOCOL_VERSION_3
 };
 
 /*
@@ -1434,19 +1436,9 @@ static void version_resp(struct hv_dynmem_device *dm,
 	version_req.version.version = dm->next_version;
 	dm->version = version_req.version.version;
 
-	/*
-	 * Set the next version to try in case current version fails.
-	 * Win7 protocol ought to be the last one to try.
-	 */
-	switch (version_req.version.version) {
-	case DYNMEM_PROTOCOL_VERSION_WIN8:
-		dm->next_version = DYNMEM_PROTOCOL_VERSION_WIN7;
-		version_req.is_last_attempt = 0;
-		break;
-	default:
-		dm->next_version = 0;
-		version_req.is_last_attempt = 1;
-	}
+	/* Set the next version to try in case current version fails. */
+	dm->next_version = 0;
+	version_req.is_last_attempt = 1;
 
 	ret = vmbus_sendpacket(dm->dev->channel, &version_req,
 				sizeof(struct dm_version_request),
@@ -1735,16 +1727,18 @@ static int balloon_connect_vsp(struct hv_device *dev)
 
 	/*
 	 * Initiate the hand shake with the host and negotiate
-	 * a version that the host can support. We start with the
-	 * highest version number and go down if the host cannot
-	 * support it.
+	 * a version that the host can support. The mechanism is in place
+	 * to start with the highest version number and go down if the host
+	 * cannot support it. But currently we only try the WIN10 version
+	 * since support for older Hyper-V versions has been removed from
+	 * Linux.
 	 */
 	memset(&version_req, 0, sizeof(struct dm_version_request));
 	version_req.hdr.type = DM_VERSION_REQUEST;
 	version_req.hdr.size = sizeof(struct dm_version_request);
 	version_req.hdr.trans_id = atomic_inc_return(&trans_id);
 	version_req.version.version = DYNMEM_PROTOCOL_VERSION_WIN10;
-	version_req.is_last_attempt = 0;
+	version_req.is_last_attempt = 1;
 	dm_device.version = version_req.version.version;
 
 	ret = vmbus_sendpacket(dev->channel, &version_req,
@@ -1964,7 +1958,7 @@ static int balloon_probe(struct hv_device *dev,
 #endif
 	dm_device.dev = dev;
 	dm_device.state = DM_INITIALIZING;
-	dm_device.next_version = DYNMEM_PROTOCOL_VERSION_WIN8;
+	dm_device.next_version = 0;
 	init_completion(&dm_device.host_event);
 	init_completion(&dm_device.config_event);
 	INIT_LIST_HEAD(&dm_device.ha_region_list);
diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index 506871aeacf0..847dc69e8250 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -372,11 +372,6 @@ static void vss_on_reset(void)
 int
 hv_vss_init(struct hv_util_service *srv)
 {
-	if (vmbus_proto_version < VERSION_WIN8_1) {
-		pr_warn("Integration service 'Backup (volume snapshot)'"
-			" not supported on this host version.\n");
-		return -ENOTSUPP;
-	}
 	recv_buffer = srv->recv_buffer;
 	vss_transaction.recv_channel = srv->channel;
 	vss_transaction.recv_channel->max_pkt_size = VSS_MAX_PKT_SIZE;
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index a2b484679eb4..9652083b6798 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -260,9 +260,8 @@ static inline u32 hv_get_avail_to_write_percent(
  * 5 . 2  (Windows Server 2019, RS5)
  * 5 . 3  (Windows Server 2022)
  *
- * The WS2008 and WIN7 versions are listed here for
- * completeness but are no longer supported in the
- * Linux kernel.
+ * The WS2008, WIN7, WIN8, and WIN8_1 versions are listed here for
+ * completeness but are no longer supported in the Linux kernel.
  */
 
 #define VMBUS_MAKE_VERSION(MAJ, MIN)	((((u32)MAJ) << 16) | (MIN))
-- 
2.25.1

