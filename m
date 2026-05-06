Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD78348B370
	for <linux-scsi@vger.kernel.org>; Wed,  6 May 2026 14:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778076591; cv=none; b=sOk7VvuMTG/vxW3EM4FLOYgCMo/sdRxUlGLpC3nSRQz441WgvHiA1iPWSYlxJ2tgvKHcy7jbVN2hSjKdHZ3Lpuk4ScRWub7s3/geMXDAnYBd6wFR1rFsyp47w/8L2naY4MUWSDTFTTP7pJwKDTBfTY/CwSpWwQDYZWxEBPQeDSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778076591; c=relaxed/simple;
	bh=mBzjgyvTiUqoWkXYslRPk2bfkWMakb8gn6U0DIyuIzo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ebrlw967u9zQNcGPUxIomkQqe3FE3ZTkKdEWgwPR65vrgjnr8Jg/k8ubOt3J02b7tknxO9b06uj1Mp2hEDi6BTbqQjYoEOB/saOaZ14Nb12GP8gSq6JXl2OGGZ4WbxfDLrtB2sdmOEzMpLdax2wkr3lKOdK//ScGjHzxoMR3O2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OkMX5EJX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OkMX5EJX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778076588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rB6mxx0RXB5aP3t67X3dbvwfnGYuDrJ/l+d8J4CapX8=;
	b=OkMX5EJXeaZGNMBW4Za36HEVOKMQF+EuXKQWrw92wHxVoRFMTlXy3qFs5iQwy7iMVCxCHV
	6cFVY+illQHikw0vzQSCUcQVKZ6vrQnkEHggLINUM54h0nTqBlQ2AUPj5cwrMDwZx/4Vqt
	mSSOxSQyUsAXCGOmC3FgNuW/GbzjzBQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-SkVtXGVyMWWre9EkDY2I0w-1; Wed,
 06 May 2026 10:09:47 -0400
X-MC-Unique: SkVtXGVyMWWre9EkDY2I0w-1
X-Mimecast-MFC-AGG-ID: SkVtXGVyMWWre9EkDY2I0w_1778076584
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63DB5180059C;
	Wed,  6 May 2026 14:09:44 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.rmtusma.csb (unknown [10.2.16.24])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E5D61800374;
	Wed,  6 May 2026 14:09:43 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	loberman@redhat.com
Subject: [PATCH v2 0/2] scsi: Replace FC-specific jammer with transport-agnostic fault injector
Date: Wed,  6 May 2026 10:09:32 -0400
Message-ID: <20260506140934.1005361-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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

An optional jam_tur_passthrough knob lets TEST UNIT READY commands
pass through to the real driver while all other commands are jammed.
This simulates the real-world slow-drain failure mode where the path
appears alive to dm-multipath path checkers but data I/O is stalled.

Safety: commands are never silently dropped; every intercepted
command is completed via scsi_done() either immediately or from a
workqueue timer. The initiator will not panic or be left with
orphaned commands regardless of when the module is unloaded.

This patch series was developed with the assistance of Claude AI
(Anthropic). The design, testing, and sign-off responsibility
remain with the author.

Tested on x86_64 with Emulex lpfc FC HBA, dm-multipath,
Linux 7.0.0+. All three injection modes and TUR passthrough
verified against active multipath configurations.

Note to reviewers: checkpatch reports 4 CHECKs on patch 2/2,
all of which are false positives:
  - "Alignment should match open parenthesis": checkpatch
    miscounts tabs for enum return types; alignment is correct.
  - "Lines should not end with a '('": common kernel pattern.
  - "Macro argument reuse '_var'" (x2): READ_ONCE/WRITE_ONCE
    are specifically designed to be safe with macro argument
    reuse; this is a known false positive for these accessors.

Changes since v1:
  - Patch 2: Add jam_tur_passthrough control to pass TEST UNIT
    READY commands through while jamming all other commands.
    Simulates slow-drain where path appears alive to multipath
    but data I/O is stalled.
  - Patch 1: unchanged
  - Fix duplicate flap_work_fn forward declaration in patch 2

Laurence Oberman (2):
  scsi: tcm_qla2xxx: Remove FC-specific SCSI command jammer
  scsi: Add transport-agnostic initiator-side fault injector

 MAINTAINERS                        |   6 +
 drivers/scsi/Kconfig               |  22 +
 drivers/scsi/Makefile              |   1 +
 drivers/scsi/qla2xxx/Kconfig       |   9 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  23 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |   1 -
 drivers/scsi/scsi_jammer.c         | 657 +++++++++++++++++++++++++++++
 7 files changed, 686 insertions(+), 33 deletions(-)
 create mode 100644 drivers/scsi/scsi_jammer.c

-- 
2.54.0

