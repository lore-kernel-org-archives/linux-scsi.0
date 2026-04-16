Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFDE28640B
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 16:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776357461; cv=none; b=qo7c7y22O+MGp3Bzi6N3LCQ+gFT5hR9vHT/ueZ3+VaiGW4q/m/kkTWZnNe8urKpWiIuZT1t3Xa1gh2kKMpX12E/MRO7R6Lqch9X0UiLxLX+0Ymarzmu34meD626GuwSOd275hIJRNrBZZmVrrfj33XMeP8tEeZse3mwIVivQ0Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776357461; c=relaxed/simple;
	bh=euQ/nHZGoBRLOhdIpA/VSL/kHPZEQBHcIcEV1SybX0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e/Ym1ZwljjiiJB7AUbIPvRdzTMr5ON4XKUNKCMRxE7fkxiCH4UgByUoKS2bfgjILnX+HW7T4bpvpAXHkeHo2D4DZdeDf1N7bmBfYzx9HumIPxz09ypNwsBtUG7d3cH5Cfp8sGT+5EeHrLMzog+nRZj7fESE8GRvH2WNd6IO7mCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GULqEomo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GULqEomo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776357459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pZlqPGep0YvgkiqlU3bpjXOZdp8mCLP1HEjaqwNbFCk=;
	b=GULqEomo0FAtXWmooZyfRifkv+K2z04hdl5KeGVYSDtCH20ZaghBYlmtTiDN73HnCR8oV4
	z2aanrbX+pcAdL2NfzTeKqgvCCM+HGSfRaqbiaFCDFmsp6sfjHs5WSuXPyARQhBBPpy5KP
	ogQYSGnDFZlWC7OCI0W8fr+K/fdxI3E=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-GivNzPeROYKM2OFnrukzdg-1; Thu,
 16 Apr 2026 12:37:38 -0400
X-MC-Unique: GivNzPeROYKM2OFnrukzdg-1
X-Mimecast-MFC-AGG-ID: GivNzPeROYKM2OFnrukzdg_1776357457
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 262531800451;
	Thu, 16 Apr 2026 16:37:37 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.rmtusma.csb (unknown [10.2.16.92])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2E46C1955D71;
	Thu, 16 Apr 2026 16:37:36 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com,
	james.bottomley@hansenpartnership.com,
	loberman@redhat.com
Subject: [PATCH 0/2] scsi: Replace FC-specific jammer with transport-agnostic fault injector
Date: Fri, 17 Apr 2026 00:37:25 +0800
Message-ID: <20260416163727.1144923-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

This two-patch series replaces the FC-specific SCSI command jammer
introduced in commit 54a5e73f4d6e ("tcm_qla2xxx Add SCSI command
jammer/discard capability") with a transport-agnostic initiator-side
fault injection module.

The original implementation required LIO configured in target mode
with a QLogic qla2xxx HBA, limiting it to FC environments only.
tcm_qla2xxx target mode has effectively been retired, making the
original approach no longer viable as a general-purpose test tool.

The replacement module (scsi_jammer) operates on the initiator side
at the queuecommand level of the SCSI mid-layer. It intercepts
commands before they reach any HBA driver by saving and replacing
the queuecommand function pointer of the selected Scsi_Host at
runtime. This makes it equally effective for FC, FCoE, iSCSI, SAS,
and any other transport that presents a Scsi_Host, with no
target-side configuration required.

Three injection modes simulate different fabric failure scenarios:
  - drop:    immediate DID_NO_CONNECT (dead path / cable pull)
  - timeout: delayed completion beyond SCSI timeout (slow drain)
  - flap:    periodic arm/disarm (repeated RSCN events)

The flap mode is particularly useful for testing dm-multipath path
reinstatement logic in addition to initial failover.

Safety: commands are never silently dropped; every intercepted
command is completed via scsi_done() either immediately or from a
workqueue timer. The initiator will not panic or be left with
orphaned commands regardless of when the module is unloaded.

This patch series was developed with the assistance of Claude AI
(Anthropic). The design, testing, and sign-off responsibility
remain with the author.

Tested on x86_64 with Emulex lpfc FC HBA, dm-multipath,
Linux 7.0.0+. All three injection modes verified against active
multipath configurations.

Note to reviewers: checkpatch reports 4 CHECKs on patch 2/2,
all of which are false positives:
  - "Alignment should match open parenthesis": checkpatch
    miscounts tabs for enum return types; alignment is correct.
  - "Lines should not end with a '('": common kernel pattern.
  - "Macro argument reuse '_var'" (x2): READ_ONCE/WRITE_ONCE
    are specifically designed to be safe with macro argument
    reuse; this is a known false positive for these accessors.

Laurence Oberman (2):
  scsi: tcm_qla2xxx: Remove FC-specific SCSI command jammer
  scsi: Add transport-agnostic initiator-side fault injector

 MAINTAINERS                        |   6 +
 drivers/scsi/Kconfig               |  22 +
 drivers/scsi/Makefile              |   1 +
 drivers/scsi/qla2xxx/Kconfig       |   9 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  23 --
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |   1 -
 drivers/scsi/scsi_jammer.c         | 619 +++++++++++++++++++++++++++++
 7 files changed, 648 insertions(+), 33 deletions(-)
 create mode 100644 drivers/scsi/scsi_jammer.c

-- 
2.53.0

