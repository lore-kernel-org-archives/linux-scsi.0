Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1492FF15B
	for <linux-scsi@vger.kernel.org>; Mon,  6 Apr 2026 01:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775440452; cv=none; b=g0U81YOuzoqRdgtZMFWP+kwckDupAzehhMg58tg68y2mhHQisY45OCtGMggzKCBfndz1Ulv0xroa/hrT2EXcQnXrzX4szfMW7D3Bupsr0nQMmRs540jSlRZlHxuJYKHsgbExEY1L8M+dkJreNkDgq3xsN1VHBa7MvdJTEQfxzGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775440452; c=relaxed/simple;
	bh=2UTupawkM/Buasn6mvWU4ZaVvVjcElE7vIbTnBeKfFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VxwYYKH4hfhgmKpN75K76/D2gmaHPqW1JFvWf0cZKMd6DWODB2I52bkcXYj0r5S1ASgtZm/APd0qGaMa+JhaGK5xHy67QQhC4yxZzG+8ybk2owk7bbge1H6r9NtqBuihErBV22z/p315Y10YxtIrL2SKnlzUESxaab7gH0bvMUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YBCfuaB2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YBCfuaB2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775440449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2t6NMj+k7e5t6BNImF47zecQxGvOdp4DtM9XCqytqzc=;
	b=YBCfuaB2y0jDvaLsglhNu57NJ+RYniKs86VgeSkcNOb8QkXawU7qg9OiJaXQu778VGLj+s
	E7Rd4RiXIAOekL40KGG1rCbhGc3bjubnUlIUu7q6ghaUzBOBAGb3iYN/GKdLbSIJPC1Iph
	jQ9EeRmTkYqZmrh9+81DCN5Sclymu4A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-Edb5DTryP7aHXD7Z2oDFWw-1; Sun,
 05 Apr 2026 21:54:08 -0400
X-MC-Unique: Edb5DTryP7aHXD7Z2oDFWw-1
X-Mimecast-MFC-AGG-ID: Edb5DTryP7aHXD7Z2oDFWw_1775440446
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D747180035C;
	Mon,  6 Apr 2026 01:54:06 +0000 (UTC)
Received: from localhost.redhat.com (unknown [10.72.112.37])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BD81C300019F;
	Mon,  6 Apr 2026 01:54:00 +0000 (UTC)
From: Li Tian <litian@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: Li Tian <litian@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: storvsc: Handle PERSISTENT_RESERVE_IN truncation for Hyper-V vFC
Date: Mon,  6 Apr 2026 09:53:44 +0800
Message-ID: <20260406015344.12566-1-litian@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The storvsc driver has become stricter in handling
SRB status codes returned by the Hyper-V host. When using Virtual
Fibre Channel (vFC) passthrough, the host may return
SRB_STATUS_DATA_OVERRUN for PERSISTENT_RESERVE_IN commands if the
allocation length in the CDB does not match the host's expected
response size.

Currently, this status is treated as a fatal error, propagating
Host_status=0x07 [DID_ERROR] to the SCSI mid-layer. This causes
userspace storage utilities (such as sg_persist) to fail with
transport errors, even when the host has actually returned the
requested reservation data in the buffer.

Refactor the existing command-specific workarounds into a new helper
function, storvsc_host_mishandles_cmd(), and add
PERSISTENT_RESERVE_IN to the list of commands where SRB status
errors should be suppressed for vFC devices. This ensures that
the SCSI mid-layer processes the returned data buffer instead of
terminating the command.

Signed-off-by: Li Tian <litian@redhat.com>
---
 drivers/scsi/storvsc_drv.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ae1abab97835..6977ca8a0658 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1131,6 +1131,26 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request,
 		kfree(payload);
 }
 
+/*
+ * The current SCSI handling on the host side does not correctly handle:
+ * INQUIRY with page code 0x80, MODE_SENSE / MODE_SENSE_10 with cmd[2] == 0x1c,
+ * and (for FC) MAINTENANCE_IN / PERSISTENT_RESERVE_IN passthrough.
+ */
+static bool storvsc_host_mishandles_cmd(u8 opcode, struct hv_device *device)
+{
+	switch (opcode) {
+	case INQUIRY:
+	case MODE_SENSE:
+	case MODE_SENSE_10:
+		return true;
+	case MAINTENANCE_IN:
+	case PERSISTENT_RESERVE_IN:
+		return hv_dev_is_fc(device);
+	default:
+		return false;
+	}
+}
+
 static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 				  struct vstor_packet *vstor_packet,
 				  struct storvsc_cmd_request *request)
@@ -1141,22 +1161,12 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 	stor_pkt = &request->vstor_packet;
 
 	/*
-	 * The current SCSI handling on the host side does
-	 * not correctly handle:
-	 * INQUIRY command with page code parameter set to 0x80
-	 * MODE_SENSE and MODE_SENSE_10 command with cmd[2] == 0x1c
-	 * MAINTENANCE_IN is not supported by HyperV FC passthrough
-	 *
 	 * Setup srb and scsi status so this won't be fatal.
 	 * We do this so we can distinguish truly fatal failues
 	 * (srb status == 0x4) and off-line the device in that case.
 	 */
 
-	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
-	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE) ||
-	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE_10) ||
-	   (stor_pkt->vm_srb.cdb[0] == MAINTENANCE_IN &&
-	   hv_dev_is_fc(device))) {
+	if (storvsc_host_mishandles_cmd(stor_pkt->vm_srb.cdb[0], device)) {
 		vstor_packet->vm_srb.scsi_status = 0;
 		vstor_packet->vm_srb.srb_status = SRB_STATUS_SUCCESS;
 	}
-- 
2.53.0

