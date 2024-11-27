Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B14C1FBEBE
	for <linux-scsi@vger.kernel.org>; Wed, 27 Nov 2024 18:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732731218; cv=none; b=WTVWnKIkCBxfj1f9l6Nvf2oxDEUFQC5bSBKWBbK5uFhoK8vz0ZPWbjdgN61k0jEb2cARV1aC2tadjPBF5y+Ja0IPN9RjxmjZtwyRERAWGiloRkBXyKRG9sVpfry+TWpW9/8seRt0HtoCdOb3OesLsWrzjzKEjJ724Gr0IiklVyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732731218; c=relaxed/simple;
	bh=uCK/oSvqKJse6UZiS4QNw7GTSY59CPZ6FRheoY3Jwjg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h4BXTYpiQi2h8nhZI3M4nyCLmTvrB8IJ12jclKcWrFJ3KZj15sqnfuoGaD10ipj+EZ9QPBQ4NXTtJbpCcvVpVD5tYtmk3tm/auPN65WnBHlG9KsuewLoL8rXp88knDlekieptLfaUKA4RcZb/YJSfbcNFVQ1QH5NXS9L4IMhaqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FKGIP4WY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FKGIP4WY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732731215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bBLKMV5jpNDuJoQl4/1hOw5nZa8O963JZs4hwXdVXR4=;
	b=FKGIP4WYWf2BqL3Sb+6B1zxI7w54xZxjl187rtw8oRSYQlRbCAXt2yidgHplOEJNP6LnE+
	0xSCFi0kHXvEoRiYV74nq629hPqr0LG3dne2+PzF+i2Wt4tmuVe2KoZ6zmWAiRr90qQkyq
	X/El9OSTTOXjvu1NElqZzRIRb5qD42M=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-374-NRDJlUbdOtKuuTsUwaJxTg-1; Wed,
 27 Nov 2024 13:13:32 -0500
X-MC-Unique: NRDJlUbdOtKuuTsUwaJxTg-1
X-Mimecast-MFC-AGG-ID: NRDJlUbdOtKuuTsUwaJxTg
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4020D1956064;
	Wed, 27 Nov 2024 18:13:27 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.211])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D0435195E480;
	Wed, 27 Nov 2024 18:13:24 +0000 (UTC)
From: Cathy Avery <cavery@redhat.com>
To: kys@microsoft.com,
	martin.petersen@oracle.com,
	wei.liu@kernel.org,
	haiyangz@microsoft.com,
	decui@microsoft.com,
	jejb@linux.ibm.com,
	mhklinux@outlook.com,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: bhull@redhat.com,
	emilne@redhat.com,
	loberman@redhat.com,
	vkuznets@redhat.com
Subject: [PATCH v2] scsi: storvsc: Do not flag MAINTENANCE_IN return of SRB_STATUS_DATA_OVERRUN as an error
Date: Wed, 27 Nov 2024 13:13:24 -0500
Message-ID: <20241127181324.3318443-1-cavery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This patch partially reverts

	commit 812fe6420a6e789db68f18cdb25c5c89f4561334
	Author: Michael Kelley <mikelley@microsoft.com>
	Date:   Fri Aug 25 10:21:24 2023 -0700

	scsi: storvsc: Handle additional SRB status values

HyperV does not support MAINTENANCE_IN resulting in FC passthrough
returning the SRB_STATUS_DATA_OVERRUN value. Now that SRB_STATUS_DATA_OVERRUN
is treated as an error multipath ALUA paths go into a faulty state as multipath
ALUA submits RTPG commands via MAINTENANCE_IN.

[    3.215560] hv_storvsc 1d69d403-9692-4460-89f9-a8cbcc0f94f3:
tag#230 cmd 0xa3 status: scsi 0x0 srb 0x12 hv 0xc0000001
[    3.215572] scsi 1:0:0:32: alua: rtpg failed, result 458752

MAINTENANCE_IN now returns success to avoid the error path as
is currently done with INQUIRY and MODE_SENSE.

Suggested-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Cathy Avery <cavery@redhat.com>
---
Changes since v1:
- Handle error and logging by returning success as previously
  done with INQUIRY and MODE_SENSE [Michael Kelley].
---
 drivers/scsi/storvsc_drv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 7ceb982040a5..d0b55c1fa908 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -149,6 +149,8 @@ struct hv_fc_wwn_packet {
 */
 static int vmstor_proto_version;
 
+static bool hv_dev_is_fc(struct hv_device *hv_dev);
+
 #define STORVSC_LOGGING_NONE	0
 #define STORVSC_LOGGING_ERROR	1
 #define STORVSC_LOGGING_WARN	2
@@ -1138,6 +1140,7 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 	 * not correctly handle:
 	 * INQUIRY command with page code parameter set to 0x80
 	 * MODE_SENSE command with cmd[2] == 0x1c
+	 * MAINTENANCE_IN is not supported by HyperV FC passthrough
 	 *
 	 * Setup srb and scsi status so this won't be fatal.
 	 * We do this so we can distinguish truly fatal failues
@@ -1145,7 +1148,9 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 	 */
 
 	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
-	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
+	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE) ||
+	   (stor_pkt->vm_srb.cdb[0] == MAINTENANCE_IN &&
+	   hv_dev_is_fc(device))) {
 		vstor_packet->vm_srb.scsi_status = 0;
 		vstor_packet->vm_srb.srb_status = SRB_STATUS_SUCCESS;
 	}
-- 
2.42.0

