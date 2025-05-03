Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E19D1993A3;
	Sat,  3 May 2025 23:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746313670; cv=none; b=CEiSzDwjy8aBWzYmvBQy2VmSaYP3lEt0MoyQi+BJhiB1Ng6U/4XXm3JThHdMHQGTK9S6sOhCD0eGUy6K3AaL+7bCbMV+KYiW2gueWKCiD4ggYh3VEwbZYN5FfuX26Oo+wnhVnxQLmKZQRtVJABt5Poafnf18hr6tyGIiSa6IC8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746313670; c=relaxed/simple;
	bh=enTALIILXCHt7GDyZfCJ+WJN8o16l3pomAxqJ0ohMTU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZySY//+Bw89eivB7hFon2/yakgXjK3SSmocUMhyzXV2YbmdQp93zSV81msb8PJ2cDAG3+t0t26wCA389WymLReOaoUCoHX69wzJ5D5BzM8y4EP3zGvjrwJmWMmy5NX9kiupGQgM2tUfq+jIxn/hiKLq5YehJIEbcMkTC34u82xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Ihs73pkS; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Ihs73pkS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=70dm7lKTwuo8qSWczM3W315YVZUE6y8aMFydwom8o2w=; b=Ihs73pkSuPdX86Dn
	BtYFZHYm+Wv1g6cJyT/xgceYJJLQa9USRaTYPXArc/DWLZrqGYof0YL6Nnh7q0e9PxcZHF1hy8JRV
	HovRVF4gGYKd4bD20R+KLBOMgishQTZxJq0EjnukKGvSuztRZPPnPAHdl48cN4kC8Siq95+mdzZT2
	t9TBLLfJ4ocudJmkMLGCOoBQ6+pP6V+MY5dIZ4UwJBkCg4vn4OwxzZAv0joP5xXcfQ/Q/LB27ewcW
	7AAKpaLlYSp5Z+uRGdoxfzUpneTrDGqnxU2FdmAZrSC0wJ1ECjAx109hibUhDVktZ5zFSvj3XVLYk
	2JcoBapEhJ3U8lKk2g==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1uBLxP-001GFz-2B;
	Sat, 03 May 2025 23:07:43 +0000
From: linux@treblig.org
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] scsi: core: Remove unused scsi_dev_info_list_del_keyed
Date: Sun,  4 May 2025 00:07:42 +0100
Message-ID: <20250503230743.124978-1-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

The last use of scsi_dev_info_list_del_keyed() was removed by 2011's
commit 2b132577a05e ("[SCSI] scsi_dh: code cleanup and remove the
references to scsi_dev_info")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/scsi_devinfo.c | 27 ---------------------------
 drivers/scsi/scsi_priv.h    |  2 --
 2 files changed, 29 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 90f1393a23f8..a348df895dca 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -485,33 +485,6 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 	return ERR_PTR(-ENOENT);
 }
 
-/**
- * scsi_dev_info_list_del_keyed - remove one dev_info list entry.
- * @vendor:	vendor string
- * @model:	model (product) string
- * @key:	specify list to use
- *
- * Description:
- *	Remove and destroy one dev_info entry for @vendor, @model
- *	in list specified by @key.
- *
- * Returns: 0 OK, -error on failure.
- **/
-int scsi_dev_info_list_del_keyed(char *vendor, char *model,
-				 enum scsi_devinfo_key key)
-{
-	struct scsi_dev_info_list *found;
-
-	found = scsi_dev_info_list_find(vendor, model, key);
-	if (IS_ERR(found))
-		return PTR_ERR(found);
-
-	list_del(&found->dev_info_list);
-	kfree(found);
-	return 0;
-}
-EXPORT_SYMBOL(scsi_dev_info_list_del_keyed);
-
 /**
  * scsi_dev_info_list_add_str - parse dev_list and add to the scsi_dev_info_list.
  * @dev_list:	string of device flags to add
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 9fc397a9ce7a..5b2b19f5e8ec 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -79,8 +79,6 @@ extern int scsi_dev_info_list_add_keyed(int compatible, char *vendor,
 					char *model, char *strflags,
 					blist_flags_t flags,
 					enum scsi_devinfo_key key);
-extern int scsi_dev_info_list_del_keyed(char *vendor, char *model,
-					enum scsi_devinfo_key key);
 extern int scsi_dev_info_add_list(enum scsi_devinfo_key key, const char *name);
 extern int scsi_dev_info_remove_list(enum scsi_devinfo_key key);
 
-- 
2.49.0

