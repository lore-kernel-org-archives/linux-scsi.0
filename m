Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295911388
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 00:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758844968; cv=none; b=gBiqLQhnXvK+A3PHbev2asDUNQA7nTgWFzP6Zl+PO0Ap0cpTBm9QrgMcv+nRohdg4dkZSSXJLvw0rUAdK2UgPfYfrkPN0FXm/0CzWU3fUyEXsPLVNPflNHsnl8tb0hqEucYaU9BJLv6TyVkzA5AupZS+qBduEZFPeX9/EUDA1mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758844968; c=relaxed/simple;
	bh=sFcKWpkA2zNty9VbAz6hFb3Bm++l1aqL3ZoPZqGzjao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=t2Soc/Vi1zhOgZkdAqEVQTZUPXGkf9WG4Mu3ntsVMqotCe+9fZScTYJ3rRalpqcuApW/iLLmMAGLlQIVCWfcZ8MxdfpyRR90CWCs5RdWni0fGYzGwtBU6o7f1g3lr5wXph9dzVdlo5qyYY8ESILy8QPDEzMvAVtWGplM4ClnULQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V6FHtlPJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V6FHtlPJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758844966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oOCNSFj0boKPObH1IRJgBgrfzdnsFJW7TsmFPXRIPIc=;
	b=V6FHtlPJ9IjouldjEgOUBxciKsnOChoe0XIMpep5V2ilT903OasdDjIFfIfvp2Yv0EhjqS
	MuAWkcJpSGHPJaSTPSd9j7LsnGBzmmloLNDMLCRHiHsubyjNbZ1zZoU01CBCraHNOwHMLH
	Bh/7SVhB5l3iUwKFEWzI5a4+/8TWjWM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-378-ctneWnYDOn2SbZ7hYlKuTA-1; Thu,
 25 Sep 2025 20:02:42 -0400
X-MC-Unique: ctneWnYDOn2SbZ7hYlKuTA-1
X-Mimecast-MFC-AGG-ID: ctneWnYDOn2SbZ7hYlKuTA_1758844960
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5C6819560B2;
	Fri, 26 Sep 2025 00:02:40 +0000 (UTC)
Received: from jmeneghi-thinkpadp1gen7.rmtusnh.csb (unknown [10.22.81.200])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0579E1800579;
	Fri, 26 Sep 2025 00:02:37 +0000 (UTC)
From: John Meneghini <jmeneghi@redhat.com>
To: hare@suse.de,
	kbusch@kernel.org,
	martin.petersen@oracle.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Cc: bgurney@redhat.com,
	axboe@kernel.dk,
	emilne@redhat.com,
	gustavoars@kernel.org,
	hch@lst.de,
	james.smart@broadcom.com,
	jmeneghi@redhat.com,
	kees@kernel.org,
	linux-hardening@vger.kernel.org,
	njavali@marvell.com,
	sagi@grimberg.me
Subject: [PATCH v10 10/11] scsi: scsi_transport_fc: user support for clearing NVME_CTRL_MARGINAL
Date: Thu, 25 Sep 2025 20:01:59 -0400
Message-ID: <20250926000200.837025-11-jmeneghi@redhat.com>
In-Reply-To: <20250926000200.837025-1-jmeneghi@redhat.com>
References: <20250926000200.837025-1-jmeneghi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Refactor and fc_rport_set_marginal_state smp safe by holding
`shost->host_lock` around all `rport->port_state` accesses.

Call nvme_fc_modify_rport_fpin_state() when FC_PORTSTATE_MARGINAL is set
or cleared.  This allows the user to quickly set or clear the
NVME_CTRL_MARGINAL state from sysfs.

E.g.:

 echo "Marginal" > /sys/class/fc_remote_ports/rport-13:0-5/port_state
 echo "Online" > /sys/class/fc_remote_ports/rport-13:0-5/port_state

Note: nvme_fc_modify_rport_fpin_state() will only affect rports that
      have FC_PORT_ROLE_NVME_TARGET set.

Signed-off-by: John Meneghini <jmeneghi@redhat.com>
---
 drivers/scsi/scsi_transport_fc.c | 46 +++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 4dc03cbaf3e2..811530037a1e 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1305,34 +1305,62 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
 						const char *buf, size_t count)
 {
 	struct fc_rport *rport = transport_class_to_rport(dev);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	u64 local_wwpn = fc_host_port_name(shost);
 	enum fc_port_state port_state;
 	int ret = 0;
+	unsigned long flags;
 
 	ret = get_fc_port_state_match(buf, &port_state);
 	if (ret)
 		return -EINVAL;
-	if (port_state == FC_PORTSTATE_MARGINAL) {
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	switch (port_state) {
+	case FC_PORTSTATE_MARGINAL:
 		/*
 		 * Change the state to Marginal only if the
 		 * current rport state is Online
 		 * Allow only Online->Marginal
 		 */
-		if (rport->port_state == FC_PORTSTATE_ONLINE)
+		if (rport->port_state == FC_PORTSTATE_ONLINE) {
 			rport->port_state = port_state;
-		else if (port_state != rport->port_state)
-			return -EINVAL;
-	} else if (port_state == FC_PORTSTATE_ONLINE) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+#if (IS_ENABLED(CONFIG_NVME_FC))
+			nvme_fc_modify_rport_fpin_state(local_wwpn,
+					rport->port_name, true);
+#endif
+			return count;
+		}
+		break;
+
+	case FC_PORTSTATE_ONLINE:
 		/*
 		 * Change the state to Online only if the
 		 * current rport state is Marginal
 		 * Allow only Marginal->Online
 		 */
-		if (rport->port_state == FC_PORTSTATE_MARGINAL)
+		if (rport->port_state == FC_PORTSTATE_MARGINAL) {
 			rport->port_state = port_state;
-		else if (port_state != rport->port_state)
-			return -EINVAL;
-	} else
+			spin_unlock_irqrestore(shost->host_lock, flags);
+#if (IS_ENABLED(CONFIG_NVME_FC))
+			nvme_fc_modify_rport_fpin_state(local_wwpn,
+					rport->port_name, false);
+#endif
+			return count;
+		}
+		break;
+	default:
+		break;
+	}
+
+	if (port_state != rport->port_state) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
 		return -EINVAL;
+	}
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
 	return count;
 }
 
-- 
2.51.0

