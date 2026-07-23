Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F9536B909
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 16:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784824679; cv=none; b=VltZaTADeUzf1WujCOPbyW2+1GzEyb06q8wvWvNTNfN/kyema0c9JKD5WJWCE2VUBG6M9t0tr2l816AJ0d1YtM2xjxejzYcNXwIeDRI9QOHdyjSM1WxEK6oIENbtSQH7fJQUStqZwDNYJXLwf3bquCzrWOL7ITA0qxS2HqAfQH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784824679; c=relaxed/simple;
	bh=DFd9dt5y9JGMgEV69pl90+yVQfFmUipOmqgcExQa2Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BJQlbA4U2yXgJjQDq5T4ldLTeiuPretr4RyadAdS9Slt4XizR7EkJOo3RhpaJoiNjq8Em5Gnjg8bHhausprtTfzp1mGV1G+qRKNTYjYlnqfK5y6tIlArbzXETLTqkdqnaw73UOMobNjJT69qLU6xRBWcDMcKiBsiLiwksqsWmVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GVikHgqb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GVikHgqb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784824675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PqJJwyPcyrJA489wBly1PHlAUlC9pJG9hGeVBDyySeo=;
	b=GVikHgqbtcL8rS8O9QW7+/RILMgUMhkmJrkC65ZcYvKc5o9G2Ikm5a8+Mf9wA/HP+d2Hrm
	Hu7Jz+sHhhpjG3iopl2fEQh3NDRaFqnGlM1/pR6sDiRKhgWkaJXdhVOHxzi6RbYU3SU4F+
	+z27MF9AqMJMMR5O4nJV9LncGceG3sQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-280-4jqHKfLsMpiKJQfr8iMTOA-1; Thu,
 23 Jul 2026 12:37:52 -0400
X-MC-Unique: 4jqHKfLsMpiKJQfr8iMTOA-1
X-Mimecast-MFC-AGG-ID: 4jqHKfLsMpiKJQfr8iMTOA_1784824671
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA024180AA7D;
	Thu, 23 Jul 2026 16:37:50 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.rmtusma.csb (unknown [10.22.65.166])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE3CB18002AE;
	Thu, 23 Jul 2026 16:37:48 +0000 (UTC)
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
Subject: [PATCH v2] scsi: storvsc: Support manual scans for all Hyper-V targets
Date: Thu, 23 Jul 2026 12:37:43 -0400
Message-ID: <20260723163743.1274830-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

The Fibre Channel transport topology created by storvsc exposes only one
dummy remote port per SCSI host. Its scsi_target_id is always zero.

As a result, the FC transport user-scan path looks up the remote port using
target ID 0. It cannot initiate a scan for Target 1 or higher. No SCSI
command is therefore sent to Hyper-V when userspace explicitly requests a
scan of one of these targets.

storvsc itself supports up to STORVSC_FC_MAX_TARGETS and already passes
scmnd->device->id to Hyper-V as vm_srb->target_id. Devices on Target 1 and
higher work when initially discovered. They can also be rediscovered by a
full host scan, such as the scan triggered after an FC port bounce.

Provide a storvsc-specific user_scan callback that uses the exported
scsi_scan_target() interface. Iterate over the requested channel and target
ranges so that wildcard and explicitly addressed scans retain the expected
SCSI sysfs scan semantics.

This bypasses the single-rport lookup in fc_user_scan() and allows
userspace to explicitly scan any target supported by storvsc without
requiring one synthetic fc_rport for every Hyper-V target.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---

Changes in v2:
- Replace the private, unexported scsi_scan_host_selected() helper with
  the exported scsi_scan_target() interface.
- Preserve wildcard channel and target scan behavior.
- Verify that storvsc_eh_timed_out() does not use the FC error-handler
  helpers; the reported missing-rport dereference is not present.

 drivers/scsi/storvsc_drv.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 571ea549152b..58b6ae96d03f 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -520,6 +520,36 @@ static void storvsc_host_scan(struct work_struct *work)
 	scsi_scan_host(host);
 }
 
+#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
+static int storvsc_user_scan(struct Scsi_Host *host,
+			     unsigned int channel,
+			     unsigned int id,
+			     u64 lun)
+{
+	unsigned int first_channel, last_channel;
+	unsigned int first_id, end_id;
+	unsigned int ch, target;
+
+	if ((channel != SCAN_WILD_CARD && channel > host->max_channel) ||
+	    (id != SCAN_WILD_CARD && id >= host->max_id) ||
+	    (lun != SCAN_WILD_CARD && lun >= host->max_lun))
+		return -EINVAL;
+
+	first_channel = channel == SCAN_WILD_CARD ? 0 : channel;
+	last_channel = channel == SCAN_WILD_CARD ? host->max_channel : channel;
+	first_id = id == SCAN_WILD_CARD ? 0 : id;
+	end_id = id == SCAN_WILD_CARD ? host->max_id : id + 1;
+
+	for (ch = first_channel; ch <= last_channel; ch++) {
+		for (target = first_id; target < end_id; target++)
+			scsi_scan_target(&host->shost_gendev, ch, target, lun,
+					 SCSI_SCAN_MANUAL);
+	}
+
+	return 0;
+}
+#endif
+
 static void storvsc_remove_lun(struct work_struct *work)
 {
 	struct storvsc_scan_work *wrk;
@@ -2232,6 +2262,8 @@ static int __init storvsc_drv_init(void)
 	fc_transport_template = fc_attach_transport(&fc_transport_functions);
 	if (!fc_transport_template)
 		return -ENODEV;
+
+	fc_transport_template->user_scan = storvsc_user_scan;
 #endif
 
 	ret = vmbus_driver_register(&storvsc_drv);
-- 
2.55.0

