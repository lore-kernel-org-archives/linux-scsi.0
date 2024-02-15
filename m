Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F7913246C
	for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2024 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708007997; cv=none; b=fpPM4I5cGE01/U66L5xu7Nvheg8vausnjPlm3q/nMuSRGbq9D9eYQgFW+rKr8CTK2nf3+ZL0fLdfpXkNAwbj4JgWK+EVHgmIu4417VDxW27ZEGtVimNJinlMlJDbWDl/OzPFoA8f+pLVouS+dpUmOsulJHA62Edf1J1vnV5k8ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708007997; c=relaxed/simple;
	bh=5QjbBfVEkcElXu49JZBLrmwO07FcPAyl3bJ/GQNX4go=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bSh8uK8PDtyjmfp4XP9+nMJ1MYdxoLBKRVIfdOXd+D0Wvte2zguhg3/0RbSfz5NZWiELRQ842wOnJ0VZJgd7It22iUbSNkrvLu7YhMlsV4/tgO2ZXs1lTgOnBrMpYwIHePPAswk9me1UOkz5aRA7pGz6BRWy0TCG7h3sdhJLluI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ihT3y1sL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ihT3y1sL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708007994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fTaL/Wmwx0q9eUMq67PddSTgAdguaj7sxRsXalaYDMc=;
	b=ihT3y1sLzUlvldvCgE5A9J9C/ReRi+G+wHVPA4qbtiflXGqm7Y++C0RwsTV9oNvjmh7CKK
	0p7WbNQbSVuE8jeAx+UVg0a9O6pCKuGLL5AjGGKAFIygBvRfUwegjwI762gkjmTxzhJ8Kh
	QX23I+ZEL7Bqm2NG/B0I71EZ+eLvECw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-0HoolzCJPsq-gon2v2_CHQ-1; Thu, 15 Feb 2024 09:39:50 -0500
X-MC-Unique: 0HoolzCJPsq-gon2v2_CHQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59C9F8A0110;
	Thu, 15 Feb 2024 14:39:50 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.47.238.145])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C0AC40153A7;
	Thu, 15 Feb 2024 14:39:48 +0000 (UTC)
From: Maurizio Lombardi <mlombard@redhat.com>
To: michael.christie@oracle.com
Cc: d.bogdanov@yadro.com,
	target-devel@vger.kernel.org,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	james.bottomley@hansenpartnership.com
Subject: [PATCH V2 1/2] target: fix selinux error when systemd-modules loads the target module
Date: Thu, 15 Feb 2024 15:39:43 +0100
Message-Id: <20240215143944.847184-2-mlombard@redhat.com>
In-Reply-To: <20240215143944.847184-1-mlombard@redhat.com>
References: <20240215143944.847184-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

If the systemd-modules service loads the target module, the credentials
of that userspace process will be used to validate the access to the
target db directory.
selinux will prevent it, reporting an error like the following:

kernel: audit: type=1400 audit(1676301082.205:4): avc: denied  { read }
for  pid=1020 comm="systemd-modules" name="target" dev="dm-3"
ino=4657583 scontext=system_u:system_r:systemd_modules_load_t:s0
tcontext=system_u:object_r:targetd_etc_rw_t:s0 tclass=dir permissive=0

Fix the error by using the kernel credentials to access the db directory

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---

v2: call target_xcopy_release_pt() to destroy the xcopy_wq in case of failure

 drivers/target/target_core_configfs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index a5f58988130a..3f3dd0c0ce8c 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3656,6 +3656,8 @@ static int __init target_core_init_configfs(void)
 {
 	struct configfs_subsystem *subsys = &target_core_fabrics;
 	struct t10_alua_lu_gp *lu_gp;
+	struct cred *kern_cred;
+	const struct cred *old_cred;
 	int ret;
 
 	pr_debug("TARGET_CORE[0]: Loading Generic Kernel Storage"
@@ -3732,11 +3734,21 @@ static int __init target_core_init_configfs(void)
 	if (ret < 0)
 		goto out;
 
+	/* We use the kernel credentials to access the target directory */
+	kern_cred = prepare_kernel_cred(&init_task);
+	if (!kern_cred) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	old_cred = override_creds(kern_cred);
 	target_init_dbroot();
+	revert_creds(old_cred);
+	put_cred(kern_cred);
 
 	return 0;
 
 out:
+	target_xcopy_release_pt();
 	configfs_unregister_subsystem(subsys);
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
-- 
2.39.3

