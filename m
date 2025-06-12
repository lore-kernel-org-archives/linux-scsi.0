Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14A623185C
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2025 10:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749723368; cv=none; b=hztOdWS7QgjLLHP3vuIlvzrEUWURp5R9kdYClv4Zy+9TPqKXDv/TlaNwDYGeiiiDgpf94TbdL1C9i6jFnNZsWZy9xlaQ5n/g/6J6mwM6cfKa/hOgpEWplR7d30gEBY2jsVrBoI/ip1XztZlwfLU5SaBXVycAC0WclOy5gOmIQdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749723368; c=relaxed/simple;
	bh=DXTFj7+ooipVpXUwtfksauCcsc5cn9FQKlCUC8ETSYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MWFIGkyTzxjK98hWaWA8kku5popVLansIa6WXVclFyNeWSqAFUGVn7rmAkjOSBx8zLDJs8M5axwz7iga2+Q6IjVrs9vbXQk8guY0Jz0YyrNGRb3YUW5Qs9pT0mcj05ehBXxAlF4qI5O6jFelmQxCZfBsmh9z9qeppa/AQsfue4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jOdhGk6j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jOdhGk6j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749723365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MKTsOWalSEh9Swp/BjoAyyoOsi8/EO5jetbKJbG4Hws=;
	b=jOdhGk6jCUYcdd+DeM/SAQHUWLzywhag2nphl9kTc90LI7atSpXyMaMgpwQ/SS6PftaGzu
	PWrz5wYZP79f06a1chRjxI4FAR+tv8tkl9j98sEVmA5+QQUE2APJx42IPru9u5m1sZavfg
	L2E313FM7McG2jHkpbhlYKzB1d4muHY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-ZZ18GLUMPAmOBpJC2ERqWA-1; Thu,
 12 Jun 2025 06:16:02 -0400
X-MC-Unique: ZZ18GLUMPAmOBpJC2ERqWA-1
X-Mimecast-MFC-AGG-ID: ZZ18GLUMPAmOBpJC2ERqWA_1749723361
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 183FB1800291;
	Thu, 12 Jun 2025 10:16:01 +0000 (UTC)
Received: from kinzhal.redhat.com (unknown [10.42.28.41])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1EB8A18003FC;
	Thu, 12 Jun 2025 10:15:58 +0000 (UTC)
From: Maurizio Lombardi <mlombard@redhat.com>
To: martin.petersen@oracle.com
Cc: mlombard@bsdbackstore.eu,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	michael.christie@oracle.com
Subject: [PATCH] scsi: target: Fix NULL pointer dereference in core_scsi3_decode_spec_i_port
Date: Thu, 12 Jun 2025 12:15:56 +0200
Message-ID: <20250612101556.24829-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

The function core_scsi3_decode_spec_i_port(), in its error code path,
unconditionally calls core_scsi3_lunacl_undepend_item()
passing the dest_se_deve pointer, which may be NULL.

This can lead to a NULL pointer dereference if
dest_se_deve remains unset.

SPC-3 PR SPEC_I_PT: Unable to locate dest_tpg
Unable to handle kernel paging request at virtual address dfff800000000012
Call trace:
  core_scsi3_lunacl_undepend_item+0x2c/0xf0 [target_core_mod] (P)
  core_scsi3_decode_spec_i_port+0x120c/0x1c30 [target_core_mod]
  core_scsi3_emulate_pro_register+0x6b8/0xcd8 [target_core_mod]
  target_scsi3_emulate_pr_out+0x56c/0x840 [target_core_mod]

Fix this by adding a NULL check before calling
core_scsi3_lunacl_undepend_item()

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/target_core_pr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 34cf2c399b39..70905805cb17 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1842,7 +1842,9 @@ core_scsi3_decode_spec_i_port(
 		}
 
 		kmem_cache_free(t10_pr_reg_cache, dest_pr_reg);
-		core_scsi3_lunacl_undepend_item(dest_se_deve);
+
+		if (dest_se_deve)
+			core_scsi3_lunacl_undepend_item(dest_se_deve);
 
 		if (is_local)
 			continue;
-- 
2.47.1

