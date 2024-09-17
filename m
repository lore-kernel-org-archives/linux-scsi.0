Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D89B3AC36
	for <linux-scsi@vger.kernel.org>; Tue, 17 Sep 2024 23:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726614415; cv=none; b=VNie50QtkNDCLHnurfkL2bjOFwjZQLxjw/IbCSlqE0M8nEkHMlnyR18nC4MDsQF0N0Uc4FoNr+HIDBlp2MXsa7Lp6/DaeYFr20aquvm9K1jRzaMze36MXV39OAUf0dl64KtU2+Yv1XO4tEs3TyCTBjvqaNWrpVfvRdYOTmdojMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726614415; c=relaxed/simple;
	bh=vrEjoBfgEjdl3ySPEO6x5FWOtVxbiJ7GYzpqVwX0nXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iEESPAbWYef90zgnMGhuuCyd9xOlYrzgRlhvHkdj8N7+mQojWlbKmZ2iTuJiLVM//rV/oCTP03VKvUKw8KR6jjfemXu/7D1X2ECkc4hymKPK3cADjp9Mj7Zb2I555mjSFxi1XDPESVccGFneDKabmKY30nq+aG/1Ofh4AYIHiQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HATBcsz+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HATBcsz+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726614412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/NmHWjOhYOH+hisI5wLu32UQGw9pEJkrcdZxtm5xFR0=;
	b=HATBcsz+vnSj2AUabeey5O9uDYfeyg7WTaEqmoplx3xc0JGVRp5FbmPeOoPH32MFPetZm3
	NyabYXJf/3KLk1z6fZnHCLOq/an9PhZ7DzjQhhR6f/AmvHc68OQjbvMWYfD1mpsmwu9cZ+
	EZzA4ZcJlpXuF7Tiscyg8cAqg9ae5h4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-328-Z1D1bjSNM2CvHhgTqMQM3w-1; Tue,
 17 Sep 2024 19:06:48 -0400
X-MC-Unique: Z1D1bjSNM2CvHhgTqMQM3w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E33119560B7;
	Tue, 17 Sep 2024 23:06:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD19019560AF;
	Tue, 17 Sep 2024 23:06:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48HN6iPA966777
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 19:06:44 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48HN6h8F966776;
	Tue, 17 Sep 2024 19:06:43 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Muneendra Kumar <muneendra.kumar@broadcom.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: scsi_transport_fc: allow setting rport state to current state
Date: Tue, 17 Sep 2024 19:06:43 -0400
Message-ID: <20240917230643.966768-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The only input fc_rport_set_marginal_state() currently accepts is
"Marginal" when port_state is "Online", and "Online" when the port_state
is "Marginal". It should also allow setting port_state to its current
state, either "Marginal or "Online".

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/scsi/scsi_transport_fc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 7d088b8da075..2270732b353c 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1255,7 +1255,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
 		 */
 		if (rport->port_state == FC_PORTSTATE_ONLINE)
 			rport->port_state = port_state;
-		else
+		else if (port_state != rport->port_state)
 			return -EINVAL;
 	} else if (port_state == FC_PORTSTATE_ONLINE) {
 		/*
@@ -1265,7 +1265,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
 		 */
 		if (rport->port_state == FC_PORTSTATE_MARGINAL)
 			rport->port_state = port_state;
-		else
+		else if (port_state != rport->port_state)
 			return -EINVAL;
 	} else
 		return -EINVAL;
-- 
2.45.0

