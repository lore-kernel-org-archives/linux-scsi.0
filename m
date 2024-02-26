Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E7D12C815
	for <linux-scsi@vger.kernel.org>; Mon, 26 Feb 2024 15:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708960222; cv=none; b=stlo2aFvuV3m+XdiZUIJcG3Tw1tX0xzSx43TBbSs8BPD5WLI92IBJmR9ZABoaOEHnCn4ajSKjUaDmLKW2yABrMQx6uhiHgE7Ipe0vDknyOC3UuEptdWmZz5d/TXPCdaO9+D+94NKyoXmb0xjeIrfNl7npqTcNhYAWh1nrDoeuLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708960222; c=relaxed/simple;
	bh=KvuVwc853ixvAmQccVnLhr6U2mFzrJgwO7J+DZHnpOU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b1DHENyLfG3IQqApsysE0BbRwkubT0DMgn6DCR+b43rf3P76qu/OJ17bneLIXb4XZpYekkBcDDaIjOewD6aqyUjKGTJTB7s6Uy/W4720PaBdCE3brprB43iCxCUCCtoHa0XSd/xHaFMO8IM5GsmgKFJJV8wEESJrPafwsScG6ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FkCZL5ch; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FkCZL5ch"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708960219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8P7hpjKv2/9s56+nSp/1tA0da0R1ibwVkPSA+X8ClF4=;
	b=FkCZL5chuwrUe3zSyECdS8soix1o8EgOARqERwbfgn4+OoxS+mxDdaPj1i/QIYUe7sZWXu
	gbL4IyHoiplIsY84S8n5KnYr8GHs3AAtnH4zhUrg4eoLZgk53PqiNQdL4onI44Ld7JWtkW
	78xNtpr+L5q2zFgYo6GgMIxQMlru6/k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-fDhjlkRhMZaRavNzDsYbAg-1; Mon, 26 Feb 2024 10:10:15 -0500
X-MC-Unique: fDhjlkRhMZaRavNzDsYbAg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EEE5108C061;
	Mon, 26 Feb 2024 15:10:15 +0000 (UTC)
Received: from localhost.redhat.com (unknown [10.45.225.250])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6D1D91121306;
	Mon, 26 Feb 2024 15:10:14 +0000 (UTC)
From: Tomas Henzl <thenzl@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: chandrakanth.patil@broadcom.com,
	sathya.prakash@broadcom.com
Subject: [PATCH] mpi3mr: sanitise num_phys
Date: Mon, 26 Feb 2024 16:10:13 +0100
Message-ID: <20240226151013.8653-1-thenzl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Information is stored in mr_sas_port->phy_mask, values larger then size
of this field shouldn't be allowed.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index c0c8ab586957..352f006c8fe4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1355,11 +1355,21 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	mpi3mr_sas_port_sanity_check(mrioc, mr_sas_node,
 	    mr_sas_port->remote_identify.sas_address, hba_port);
 
+	if (mr_sas_node->num_phys > sizeof(mr_sas_port->phy_mask) * 8)
+		ioc_info(mrioc, "max port count %u could be too high\n",
+		    mr_sas_node->num_phys);
+
 	for (i = 0; i < mr_sas_node->num_phys; i++) {
 		if ((mr_sas_node->phy[i].remote_identify.sas_address !=
 		    mr_sas_port->remote_identify.sas_address) ||
 		    (mr_sas_node->phy[i].hba_port != hba_port))
 			continue;
+
+		if (i > sizeof(mr_sas_port->phy_mask) * 8) {
+			ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",
+			    i, sizeof(mr_sas_port->phy_mask) * 8);
+			goto out_fail;
+		}
 		list_add_tail(&mr_sas_node->phy[i].port_siblings,
 		    &mr_sas_port->phy_list);
 		mr_sas_port->num_phys++;
-- 
2.43.2

