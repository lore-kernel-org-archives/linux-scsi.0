Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AA92D7DCE
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 16:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768236848; cv=none; b=ZYKjEuqRFe/SvmRRJby3iWMZCE8pJ0r4/OxZ9ddG0PMTMw24hayLHdJfY5griwbg6JBivksXBwRZy5/I63OixdKwNA4KtfggOIVqrZ31J4I7o9kugBuiAbCfzP8cyZl2DukP9ZUmlcRoJuju3K0LMqvZ5jFgc++2BRnJ3ZLeJO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768236848; c=relaxed/simple;
	bh=gbjMjD9H0hKzoc/TbAv75RVZA/F/gfKVBRzvgwbuGPk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kVmMW9ujGAk+vMQb0sGwr6nrTDyhS8/jP4s6hBKYFAxppfOPD6e/dQFlFQQycFqGdrTkhhpNnYOWScpGPFs2rdeTHSXmcw7Vpv7+5l4V2PYFUDbatrgoYHAd12EKBeU5cU68/r+jI8y6pL261s/mGi4S/vNKFNVYYdlt2Bl/Kg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aHF3pH/b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aHF3pH/b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768236846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SrviirN/H2srI1mOFG6xd/TFt3X78J3/k99ooXMwVAg=;
	b=aHF3pH/b9TR6lPMGjcSo8731+Nx774AJ35oPRj2MrqlPlkXSLtNaIX2zOQR5cIqjnARO+4
	hcRP4ricm/95BsVeuv/m7250zYqPsJcAY2CXq4dLFsu+EAHMFNJ8oYwO2QAd6GyoGJ64z5
	kgMwvNQmvqStG8hiQwxS8N995DabRR0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-546-6tEj-VfhMcWQg5-4LqXYMw-1; Mon,
 12 Jan 2026 11:54:03 -0500
X-MC-Unique: 6tEj-VfhMcWQg5-4LqXYMw-1
X-Mimecast-MFC-AGG-ID: 6tEj-VfhMcWQg5-4LqXYMw_1768236841
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB5D319539A0;
	Mon, 12 Jan 2026 16:53:55 +0000 (UTC)
Received: from rocky.redhat.com (unknown [10.44.32.113])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A599E1801AF1;
	Mon, 12 Jan 2026 16:53:53 +0000 (UTC)
From: Maurizio Lombardi <mlombard@redhat.com>
To: martin.petersen@oracle.com
Cc: mlombard@bsdbackstore.eu,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	michael.christie@oracle.com
Subject: [PATCH 0/2] Fix a use after free in target driver
Date: Mon, 12 Jan 2026 17:53:50 +0100
Message-ID: <20260112165352.138606-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

The following KASAN report has been reported
by Zhaojuan Guo <zguo@redhat.com>


==================================================================
 BUG: KASAN: slab-use-after-free in lock_release+0xd4/0x1e8
 Read of size 8 at addr ffff0000e9b2c778 by task targetctl/21319

 kasan_report+0x90/0xc8
 __asan_load8+0xb8/0xc0
 lock_release+0xd4/0x1e8
 rt_spin_unlock+0x2c/0xb8
 iscsit_dec_conn_usage_count+0x68/0xa0 [iscsi_target_mod]
 iscsit_stop_session+0x140/0x220 [iscsi_target_mod]
 iscsit_release_sessions_for_tpg+0x380/0x480 [iscsi_target_mod]
 iscsit_tpg_disable_portal_group+0x104/0x260 [iscsi_target_mod]
 lio_target_tiqn_enabletpg+0x3c/0x80 [iscsi_target_mod]
 target_tpg_disable+0x6c/0xb0 [target_core_mod]
 target_fabric_tpg_base_enable_store+0x110/0x128 [target_core_mod]
 configfs_write_iter+0x154/0x1d0
 new_sync_write+0x1c8/0x298
 vfs_write+0x2e8/0x348
 ksys_write+0xd8/0x198

 Allocated by task 20969:
  __kasan_kmalloc+0xb8/0xc0
  __kmalloc_cache_noprof+0x194/0x300
  iscsit_alloc_conn+0x48/0x4e0 [iscsi_target_mod]
  __iscsi_target_login_thread+0x108/0x960 [iscsi_target_mod]
  iscsi_target_login_thread+0x30/0x80 [iscsi_target_mod]
  kthread+0x190/0x1a8
  ret_from_fork+0x10/0x20

 Freed by task 21085:
  __kasan_slab_free+0x4c/0x70
  kfree+0x108/0x430
  iscsit_free_conn+0x74/0x90 [iscsi_target_mod]
  iscsit_close_connection+0x4ec/0xc98 [iscsi_target_mod]
  iscsit_take_action_for_connection_exit+0x114/0x270 [iscsi_target_mod]
  iscsi_target_tx_thread+0x268/0x340 [iscsi_target_mod]
  kthread+0x190/0x1a8
  ret_from_fork+0x10/0x20


I reproduced it by inserting a delay between the call to complete()
and the call to spin_unlock() inside the iscsit_dec_conn_usage_count().

iscsit_dec_session_usage_count() has the same problem.

Maurizio Lombardi (2):
  target: iscsi: fix use-after-free in iscsit_dec_conn_usage_count()
  target: iscsi: fix use-after-free in iscsit_dec_session_usage_count()

 drivers/target/iscsi/iscsi_target_util.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

-- 
2.47.3

