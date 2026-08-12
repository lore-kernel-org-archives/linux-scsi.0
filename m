Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9ED485CF9
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786558454; cv=none; b=ukur+xEKg6oDyi6iHnSpZ82yQlhniZ3YTp1QWXcC0BiQjrgq8Mem44AYYMLI41tdqQPjS3PzdALuW/jWz0KLMcGRsUKJ2sarJDoEss6eaFEf5C6R0TluqMbTuL5sSj0Z9rBp4PljxfjGo1IYZRWlHQX77nA8ZrLrS12BQki01+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786558454; c=relaxed/simple;
	bh=4CHPSMtLkZkn+ALCdY42GhONGELxuDRtBOKdsP1nyEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giL34fNsN27Mug03+Dk+tvPTx7xjInyczUL4OBPXgk1Dolze9HlLFeq2KNHlU62QBQA8bTRCXRTor02E3UuJjD4EMvnIE++1sdWvPjIjoF17+16zcrvx9wkiEAyAzlQW4q4S5XiSgBV34K8dQzfKddvWhaIJRbWytsIPzhP9Iyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jTKEshao; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jTKEshao"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786558452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=woRBEeCuMp7hyrBJ2Q40BtYs80iQwOB8q8GOznjCNqM=;
	b=jTKEshao4fjQDk0Pl0Ogux90N8LhpRgnCDmmHtfbpe4Ik+P3Ag5HCLJ5ht649q/jlV0c2b
	y2ZFIfEqOaCjvksLPzbvaxWqN+Gy9V/ngQTkciZqkQIBeTTdrE2WwBV99FnBU0S2XbN5bu
	YdevT+34Bmv3A1b7Wr2S2wkPRwOzcNE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471-5lW4P-fXMsK4jTInPoZ6QA-1; Wed,
 12 Aug 2026 14:14:01 -0400
X-MC-Unique: 5lW4P-fXMsK4jTInPoZ6QA-1
X-Mimecast-MFC-AGG-ID: 5lW4P-fXMsK4jTInPoZ6QA_1786558437
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 380B81800747;
	Wed, 12 Aug 2026 18:13:57 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.22.88.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 777AB18005BC;
	Wed, 12 Aug 2026 18:13:51 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Hannes Reinecke <hare@suse.de>,
	Jesse Taube <jtaubepe@redhat.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Chris Leech <cleech@redhat.com>,
	"Ewan D . Milne" <emilne@redhat.com>,
	shinichiro.kawasaki@wdc.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org
Subject: [PATCH 08/13] scsi: scsi_transport_fc: user support for clearing NVME_CTRL_MARGINAL
Date: Wed, 12 Aug 2026 14:12:55 -0400
Message-ID: <20260812181300.3712426-9-jtaubepe@redhat.com>
In-Reply-To: <20260812181300.3712426-1-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: John Meneghini <jmeneghi@redhat.com>

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
V10 -> V11:
 - No change
---
 drivers/scsi/scsi_transport_fc.c | 42 +++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index df1edf3c23fa..af309a7bdc22 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1251,34 +1251,58 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
 						const char *buf, size_t count)
 {
 	struct fc_rport *rport = transport_class_to_rport(dev);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
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
+			if (i->f->set_rport_marginal)
+				i->f->set_rport_marginal(rport, true);
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
+			if (i->f->set_rport_marginal)
+				i->f->set_rport_marginal(rport, false);
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
2.54.0

