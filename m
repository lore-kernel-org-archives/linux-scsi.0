Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33000158D94
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 22:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731278074; cv=none; b=K1yn8SrhwavGhpBwVCSJh+f9n9RWprT7XFEHcV3/cns0pYXTGcVbivw01y/aEAAzU+eNB8+21ad9hgWrg6ih98egbHoLp3d8gm+3VV8ci2LlDUZdzkiow36dzpqvezfXhxh0u07U7wvymAYctaRqLx59IvMpudPWuan+Vwhw85w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731278074; c=relaxed/simple;
	bh=lMgvd/6Lb6Mv/sN/h/nJ3YyBm4498RljATrzTgtmsAw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sh36LdSTaNdw4k9PnD1teXDUg46F6DDaMeyl/YyqsqhhYM4rVzJKnGqLacsbY7NjGd2RAJ/mgiuDlgMlKX4nAVEjJeVBFPXR42Cn5LR8R9IKzgfw8ntOXlID2gSAf7EY/i9g1Ls3NxkD6IlqGZ/K9O4cm/KzT8aXnL5ULq9YbFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DUR+0wlB; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DUR+0wlB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731278070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GwBh2zyz1I6gYEB9wKU7YYpCisQ6JYb2gFv5nfuGH+U=;
	b=DUR+0wlB0yFBOjR+jEY9pG3cNye6e/AI/Na2o832EQQ8gNorf3MTn2zvaoMeYgR1+rb6XG
	lVr7ChKDIYbJfQHQ561XZDbzbKbHQLuzSS5yso9nhh52k9AO94PUkG/tVO7AdakgckMRDf
	/KmWy8x2THMQOZnXAEzb3AjKZPiQdp0=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-hardening@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: Replace zero-length array with flexible array member
Date: Sun, 10 Nov 2024 23:33:24 +0100
Message-ID: <20241110223323.42772-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace the deprecated zero-length array with a modern flexible array
member in the struct iscsi_bsg_host_vendor_reply.

Link: https://github.com/KSPP/linux/issues/78
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Use DECLARE_FLEX_ARRAY() as suggested by Gustavo A. R. Silva
- Link to v1: https://lore.kernel.org/r/20241110151749.3311-2-thorsten.blum@linux.dev/
---
 include/scsi/scsi_bsg_iscsi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_bsg_iscsi.h b/include/scsi/scsi_bsg_iscsi.h
index 9b1f0f424a79..a569c35b258d 100644
--- a/include/scsi/scsi_bsg_iscsi.h
+++ b/include/scsi/scsi_bsg_iscsi.h
@@ -59,7 +59,7 @@ struct iscsi_bsg_host_vendor {
  */
 struct iscsi_bsg_host_vendor_reply {
 	/* start of vendor response area */
-	uint32_t vendor_rsp[0];
+	DECLARE_FLEX_ARRAY(uint32_t, vendor_rsp);
 };
 
 
-- 
2.47.0

