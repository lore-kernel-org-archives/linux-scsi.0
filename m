Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793734369;
	b=ZYr+UguwmL1cs4Yjcx6YIcP2TRfbSVm53QS1snkCRr/Xe2d+XEdZfknatVfM9bXH2SuZ
	 C4rd9H8us3dfwNtgsQhNUcBfwF5ZqlPZT/Ez+TabNbZ2Y0nZw2EpChBzJOIz9/kcfD0Dd
	 zneaLx+yWqKG3pB8rZxdZNJy5jYiWAMB5g8xOjI3v91bqs26EYf8pgDPi0Z7Uz9Qf3RLU
	 aINuiA1Lb/ebQMI4Uwxt46jaEnW5f8ZJMhP+sc+Oy+/mgjyEj8RhIbHOeNa7mB6jOvOBJ
	 f9DRnAxIL8DGhZyvXhYAeT+mqO2S2Pn0F0DSh6KTBTW4dyggXeIY8dTAI3K3BShHSRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793734369;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=TIgU+Ph3TU3fSxrpE5w9RHNSxCs4sGelZ3NDiZdAMQo=;
	b=wmQMvKNhHiBTCoLi1EIctB2QNgIEb4DczCWh8aNjuj+w74AOl+9ciYiFfeyhNfMTMSCp
	 X+Vbdv7mroGrEY/KKVmXQ9Njn64WRk60yTGQq+YzYygzPo2YOGHtWZxSQa/aFXEPgNGKq
	 61lHPrO0YowO0laJioKbICJESaSPZUfgwRXHJVpbjxygQKIGbwHoyuh+ZKuRRcfoffEVv
	 qi7iU8qPSPGOGlBAnX8WTPVhd4s8bQV5kkaOzrMhD9b8YSBU5fwX6UKxBgZDN+Nb7iQKv
	 q0hQOORF4QKMT4s4NqHKwfYm3QZZNH/W74HEHOVYv0L2yBO8N+hn7BV7khBASEIlQeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=K3cjS6dT;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F714606A31B
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 19:32:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F714606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=K3cjS6dT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793734368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TIgU+Ph3TU3fSxrpE5w9RHNSxCs4sGelZ3NDiZdAMQo=;
	b=K3cjS6dTsoUal1MujKyF2bv/8D135wZ+xGAoSMVK6nacqFk32BSm0BfA0t7griJvK3A75L
	EPAG2dl1nD19F8DvqEIS3eq7gaDkKDMH5T3dVrsE34g5nKfSP2knkudgVJZCPP5mjpvzcU
	88rWBYmYbpdsYW1IK4oOynoMgrF5CcA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-440-Bqcr0AShMuyZGg5nbjr7Eg-1; Tue,
 03 Nov 2026 14:32:45 -0500
X-MC-Unique: Bqcr0AShMuyZGg5nbjr7Eg-1
X-Mimecast-MFC-AGG-ID: Bqcr0AShMuyZGg5nbjr7Eg_1793734363
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FB6D19560AE;
	Tue,  3 Nov 2026 19:32:42 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CCAE51800586;
	Tue,  3 Nov 2026 19:32:38 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Wenchao Hao <haowenchao2@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Will Deacon <will@kernel.org>,
	cki-project@redhat.com,
	jmoyer@redhat.com,
	bgoncalv@redhat.com,
	mpatalan@redhat.com,
	ftjahjad@redhat.com,
	fsuba@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] scsi: fix scsi_debug module-exit panic and pseudo target leak
Date: Tue,  3 Nov 2026 14:32:33 -0500
Message-ID: <20261103193235.1564898-1-loberman@redhat.com>
In-Reply-To: <8e4ba1820a7c56867bf7fff07bd52ff3f79573a1.camel@redhat.com>
References: <8e4ba1820a7c56867bf7fff07bd52ff3f79573a1.camel@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

CKI reported a NULL pointer dereference in debugfs_remove() from
sdebug_tartget_cleanup_async() while blktests throtl/001 unloaded
scsi_debug on 7.4.0-rc1 (arm64). The bug is not arm64 specific. It
reproduces on x86_64 with KASAN as a slab-use-after-free of the
per-target debugfs dentry.

While fixing it, instrumenting target alloc/destroy in scsi_debug showed
a second, independent problem in the SCSI core: the pseudo SCSI device's
target is never destroyed, because scsi_get_pseudo_sdev() leaks a
reap_ref. With add_host=4 num_tgts=16, ->target_alloc() was called 68
times and ->target_destroy() only 64; the missing four were the
pseudo-device targets at id max_id. Any LLD that sets nr_reserved_cmds
leaks its pseudo target.

Patch 1 fixes the core leak. Patch 2 makes scsi_debug_exit() wait for
the deferred per-target debugfs cleanup before removing the debugfs
root and unloading. Patch 1 was found while testing patch 2, and
patch 2 was tested on top of it.

Testing (x86_64 VM, KASAN, 7.4.0-rc1): loop
"modprobe scsi_debug add_host=4 num_tgts=16; rmmod scsi_debug", with
an msleep(200) temporarily added to sdebug_tartget_cleanup_async() to
force the race window.
  - unpatched: KASAN slab-use-after-free / oops on the first rmmod
  - patch 1: 68 target_alloc / 68 target_destroy, pseudo targets
    destroyed during scsi_remove_host()
  - patches 1+2: 50 iterations clean with the msleep

I had assistatnce from LLM for both of these and ran a local sashiko
which was clean other than a pre-existing issue

Laurence Oberman (2):
  scsi: core: Fix target reap_ref leak in scsi_get_pseudo_sdev()
  scsi: scsi_debug: Wait for async target cleanup on module exit

 drivers/scsi/scsi_debug.c |  2 ++
 drivers/scsi/scsi_scan.c  | 15 ++++++++-------
 2 files changed, 10 insertions(+), 7 deletions(-)

-- 
2.43.0

