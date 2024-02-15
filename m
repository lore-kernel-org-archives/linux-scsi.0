Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8189F12BEA8
	for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2024 10:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707993321; cv=none; b=j4b0OPUXsCZBHgyweRoXWZaqABhCjI5xMooGvwMk57YC7AikIZtAxbRUcFgVDoLd6eUY6iAbspNCF/1KsSvF8dgsrdUdU0naF88P8mSNvIu0bqfQHAOa0fMIeg278Crukuil4+mZJFSwsmdeMGmiSDU36RDg7vM4CBVdVZJAAwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707993321; c=relaxed/simple;
	bh=3XHvTxvC3myjepJdugUtJ2tOu+LUGxC4DtHdUwTwYKk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HQZO9Saec5vFA4Pg3bka6rh9k0+YqqvoG1twUo3XfUTkUtlUow2nWrJI9na5sm5hd15EVz9rbHokfQ09YbV5CCl6draOWEJyrDNP5DwIDvz6/WUl1Ag9IBlxRRxo5TY1/KCgJT0dIFZcJGPK14UxA1WScdebiehH5sqlajo8m+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UZoI+Yvo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UZoI+Yvo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707993318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jhp4LT+tO8HW1+Ex+dEJS/RSM0F4ijYSVYAnKp/JEpI=;
	b=UZoI+Yvorb7E8fGZKKrXjdKOQ0LkdVtbMLLA7pZrnHTtp4JZRQLYeYK9eSV8FsGLRPgjf5
	oG0aPiw3XqF8dbF7/Qg8/2SZ6OLcOTS/xoSyAcfi5uY5tZJyV4iKmSIATs64FilY6Zb4hv
	h3UoSLkqPXbp3yoT5dTdIDbMphHRd18=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-493-_Pe9OnOsNmmS3UPEd0ETEQ-1; Thu,
 15 Feb 2024 05:35:14 -0500
X-MC-Unique: _Pe9OnOsNmmS3UPEd0ETEQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 830831C0BA47;
	Thu, 15 Feb 2024 10:35:14 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.47.238.145])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A20E314F0;
	Thu, 15 Feb 2024 10:35:12 +0000 (UTC)
From: Maurizio Lombardi <mlombard@redhat.com>
To: michael.christie@oracle.com
Cc: d.bogdanov@yadro.com,
	target-devel@vger.kernel.org,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	james.bottomley@hansenpartnership.com
Subject: [PATCH 1/1] target: fix selinux error when systemd-modules loads the target module
Date: Thu, 15 Feb 2024 11:35:08 +0100
Message-Id: <20240215103508.839426-2-mlombard@redhat.com>
In-Reply-To: <20240215103508.839426-1-mlombard@redhat.com>
References: <20240215103508.839426-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

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
 drivers/target/target_core_configfs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index a5f58988130a..26c6f1cac677 100644
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
@@ -3732,7 +3734,16 @@ static int __init target_core_init_configfs(void)
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
 
-- 
2.39.3

