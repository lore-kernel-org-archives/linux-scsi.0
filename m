Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F1B47CA96
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 15:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784819718; cv=none; b=JJDJ9//zQwWiGKncR6jGLFc/2M9yQkYKKiFKpyyoPvCoxK2RzGVBDTp3WgpV2AkzWnkF90QIiXb2YiY7it/IlHuol9E2rfc5YyHNDNsht4clwxM2Zlpmxp866h3T/foFdu0kwFYM/KlJUcHBseTtl6HFteWZdF/ofzHbYDjov/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784819718; c=relaxed/simple;
	bh=7mkgfJMIvnWDuxf9XOpiSukx4PvaH2PUWQhve/o8iKM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cCE+yrNJyJsSSIPzWCkSvbQ4Qa6FSgBlkXkTWaG/0rRUZ/oAL4ABgrjhiWUEUSEEV5o6N1TCg3RCTurWG1zrCYf0AA0nTw5a/+LAavly3apvfzw4yenEQCte+52HXFubd4H7KOhMF4pMausVMpxLAv0K7MbFmOgXpI7pI1ctf2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DSUELphl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DSUELphl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784819715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KVppPbl3dmlDGLPvTVATpK1M0Teh8q3hfsk+acDK8cg=;
	b=DSUELphlf2c2oCgSToP2hDejcoRMRQZnFS3Q7FhYUrcW3mwSbwOCHT+qYOxrNzY57PvV4G
	OWEvEUeC5q53i5wIUQRZC43R0iPZ9upctdTmE8REokO2ExOwdil1iWDveayw1zjfXdekkJ
	MefubCEyYUdiJCyQDo0I5wgiTuEGkXA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-D1DEHV3KMHqHnEVtDvWddQ-1; Thu,
 23 Jul 2026 11:15:10 -0400
X-MC-Unique: D1DEHV3KMHqHnEVtDvWddQ-1
X-Mimecast-MFC-AGG-ID: D1DEHV3KMHqHnEVtDvWddQ_1784819708
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D5951805F22;
	Thu, 23 Jul 2026 15:15:08 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.rmtusma.csb (unknown [10.22.65.166])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31F671800264;
	Thu, 23 Jul 2026 15:15:06 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	linux-hyperv@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: storvsc: Support manual scans for all Hyper-V targets
Date: Thu, 23 Jul 2026 11:14:58 -0400
Message-ID: <20260723151458.872265-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

The Fibre Channel transport topology created by storvsc exposes only one
dummy remote port per SCSI host. Its scsi_target_id is always zero.

As a result, the FC transport user-scan path performs its remote-port lookup
using target ID 0 and cannot initiate a scan for Target 1 or higher. No SCSI
command is therefore sent to Hyper-V when userspace explicitly requests a
scan of one of these targets.

storvsc itself supports up to STORVSC_FC_MAX_TARGETS and already passes
scmnd->device->id to Hyper-V as vm_srb->target_id. Devices on Target 1 and
higher work when initially discovered and can be rediscovered by a full host
scan, such as the scan triggered after an FC port bounce.

Provide a storvsc-specific user_scan callback that directly invokes
scsi_scan_host_selected(). This bypasses the single-rport lookup in
fc_user_scan() and allows userspace to explicitly scan any target supported
by storvsc.

This avoids requiring storvsc to create and manage one synthetic fc_rport
for every Hyper-V target.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/storvsc_drv.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 571ea549152b..80830aa12532 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -33,6 +33,7 @@
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_transport.h>
+#include "scsi_priv.h"
 
 /*
  * All wire protocol details (storage protocol between the guest and the host)
@@ -520,6 +521,17 @@ static void storvsc_host_scan(struct work_struct *work)
 	scsi_scan_host(host);
 }
 
+#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
+static int storvsc_user_scan(struct Scsi_Host *host,
+			     unsigned int channel,
+			     unsigned int id,
+			     u64 lun)
+{
+	return scsi_scan_host_selected(host, channel, id, lun,
+				       SCSI_SCAN_MANUAL);
+}
+#endif
+
 static void storvsc_remove_lun(struct work_struct *work)
 {
 	struct storvsc_scan_work *wrk;
@@ -2232,6 +2244,8 @@ static int __init storvsc_drv_init(void)
 	fc_transport_template = fc_attach_transport(&fc_transport_functions);
 	if (!fc_transport_template)
 		return -ENODEV;
+
+	fc_transport_template->user_scan = storvsc_user_scan;
 #endif
 
 	ret = vmbus_driver_register(&storvsc_drv);
-- 
2.55.0

