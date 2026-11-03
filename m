Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793734378;
	b=szCxed3+/gxawTphofMMihOspWHVHF9DyYrQEVBYqISzTVBO3filHIaoSwxVqoglVczn
	 mS20SHv83rULJAFj34uKi5d+s2Rp0AtlYiCVYZ+qLicFPJ75UGPcYttCf5nMX/P4pGmBI
	 fkJN3usefTLTMALLI4Rj6GrqugvmjALDsw2HIbVdUBjeRk80eiaBMJxX4kOeOb7hRXlnu
	 fLteR26ENddbv0wxSOhPmVjklCoIyDraR9L3MD97PiC5+STQwyF44h55tLv0M6PJOnYOV
	 OU6fOhoD9ypg8IAxY8pN0ThAKIDDA/66VPseOpgv8mkBGnoYLl+BejnzGrh9zimHeeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793734378;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=qEmYCkPXDtF9hobALFV6QXuRhofx2fxJSYASJMiIobw=;
	b=ds+udkcytnIXTRRreT4OEnLC4q+mH2ZzGFTIwMFDhroqWaW6ySuPBGwmUu3q2x77jj0U
	 hSaOttO3yKvLC0QwftjlN/Ug5kAhS0H9Lrz31dz0EVkEgrJHqDfX6Auft8RJwqH4Dt7f6
	 9+tTWbCquXwVU3SfXXK7A9iMbqbK1SrAuU3ic0yoyTWKu1KLRtGKFnn+82bbU9YnL2zh0
	 XJMvx+aw7DP2dunwH4XgvSXIJJCnC7FrqB27gMeiUCPHQBPJMJPbXrRprcT0oCg/OTeiD
	 CKnoWmmGceDAFQaMSjCzVAoMPyelUPLB3mPwsMtmLL6DCqJj4QfF5ehYp1oYn52NpZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XW0jWu+l;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E7F606D816
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 19:32:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09E7F606D816
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XW0jWu+l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793734377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEmYCkPXDtF9hobALFV6QXuRhofx2fxJSYASJMiIobw=;
	b=XW0jWu+l54HbHXR6bS2EGYJdLZ/mKC9+cD1bqQDA2RdWlAySPCdVRqoviBQNSwFp8pJu3H
	JCKmTWk4tYiGNzF81CKzzIvVIt9h5eIcUuvtepF86oisYBcQg+bXAX+Yg1ursNcLarC451
	aZeFk0WYMenYAfSihmbn2v//fvnjFYQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-gXfGBPJrNy2kjCo_cvKisw-1; Tue,
 03 Nov 2026 14:32:53 -0500
X-MC-Unique: gXfGBPJrNy2kjCo_cvKisw-1
X-Mimecast-MFC-AGG-ID: gXfGBPJrNy2kjCo_cvKisw_1793734371
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA97E195604F;
	Tue,  3 Nov 2026 19:32:50 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E19A1800347;
	Tue,  3 Nov 2026 19:32:48 +0000 (UTC)
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
Subject: [PATCH] scsi: scsi_debug: Wait for async target cleanup on module exit
Date: Tue,  3 Nov 2026 14:32:35 -0500
Message-ID: <20261103193235.1564898-3-loberman@redhat.com>
In-Reply-To: <20261103193235.1564898-1-loberman@redhat.com>
References: <8e4ba1820a7c56867bf7fff07bd52ff3f79573a1.camel@redhat.com>
 <20261103193235.1564898-1-loberman@redhat.com>
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

sdebug_target_destroy() is called with the host lock held, so it defers
removal of the per-target debugfs directory to
sdebug_tartget_cleanup_async() on sdebug_async_domain.
scsi_debug_exit() removes the hosts and then removes
sdebug_debugfs_root without waiting for that work. The recursive
removal of the root frees the per-target dentries, and a cleanup that
runs afterwards calls debugfs_remove() on a stale dentry:

  BUG: KASAN: slab-use-after-free in _raw_spin_lock+0x2d/0x40
  Workqueue: async async_run_entry_fn
  Call Trace:
   kasan_report+0x92/0xc0
   _raw_spin_lock+0x2d/0x40
   lockref_get+0x9/0x40
   __simple_recursive_removal+0x35/0x570
   debugfs_remove+0x40/0x60
   sdebug_tartget_cleanup_async+0x43/0x60 [scsi_debug]
   async_run_entry_fn+0x96/0x520
   process_one_work+0x925/0x1910
   worker_thread+0x567/0xcc0
   kthread+0x355/0x450
  Allocated by task 150:
   __d_alloc+0x34/0x9e0
   d_alloc+0x44/0x1d0
   ...
   debugfs_create_dir+0x18/0x3d0
   sdebug_target_alloc
   scsi_alloc_target+0x7c7/0xa70

followed by a NULL inode dereference in down_write() from
__simple_recursive_removal(). CKI hit this running blktests throtl/001
on arm64. The cleanup can also run after the module text has been
freed.

Commit b402a0dce64a ("scsi: scsi_debug: Fix create target debugfs
failure") drains sdebug_async_domain before creating a target. Do the
same in scsi_debug_exit() just before removing the debugfs root, after
the driver has been unregistered so that no host can still be bound and
queue further cleanup work.

Fixes: f084fe52c640 ("scsi: scsi_debug: Add debugfs interface to fail target reset")
Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Closes: https://lore.kernel.org/r/auja2VnJTp-ijxqu@arm.com
Reported-by: CKI Project <cki-project@redhat.com>
Closes: https://datawarehouse.cki-project.org/kcidb/checkouts/redhat:3017229113
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/scsi_debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a922c8318a2f..deaed8b3e6c4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -9053,6 +9053,8 @@ static void __exit scsi_debug_exit(void)
 
 	sdebug_erase_all_stores(false);
 	xa_destroy(per_store_ap);
+	/* Wait for deferred per-target debugfs cleanup before removing the root */
+	async_synchronize_full_domain(&sdebug_async_domain);
 	debugfs_remove(sdebug_debugfs_root);
 }
 
-- 
2.56.0

