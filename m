Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03F138F22D;
	Sat,  4 Jul 2026 06:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783145627; cv=none; b=tXrZiYRUxP8+1ayzI/rhi88kokk7Pa+cSpj8gNzJ+NpSXPifDQUJa04cS/0Xa6aOCRh6xTrr360ygr8CHF5GN/6A6CnXFZtQ7/H0wBca/dyNbFxIdup718ubpmnXLZmbgbnk/tBTj2LqLI7knRAhlbJP+OrFHW+pHqxkFtjB7Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783145627; c=relaxed/simple;
	bh=iNKCfDexrZzoF8CXDzYTL3Nc01DN8GTuIuLzaMmyWJ4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EUVZI2hRPkJmJTtyhqQq17esP6S1y2gVocM6F6p3Qk1jqkiNa2sfOdDQaIbEgB3Sp2VwpkbeQiOy7c13x8qSgW8rBfWb/nG0uDJVo9KQp9jIoe+5j165n56ncejEk/ztDDb5SRmBgr82bEHJDL1xFVYJUU72BYz86Gw9wgS5MKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XGAx5kJm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XGAx5kJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C761F000E9;
	Sat,  4 Jul 2026 06:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783145626;
	bh=pNftAvQH16BxWBwtuSfq3FcInYIuCbQ6Q+AZs1Wj1sE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XGAx5kJmUB4VL+ROOnL0Mh3YYqtNNPySMYBqPBhIv3rySooDU1qGodkCJXr9b2DPS
	 f/V/E8vc8bTe5gicdg5AYZqdqQCOF9ZCjXnF3dC3iER2Y/Awl/Ft9Ni5ZoQdVW8AuY
	 kbYtGVhO2+1ezoaNvfYFH26nqRbkqYL7DTCVcYpDmimBoABCj7YlGEjMX27wz0YBlB
	 c2J/5rxUOHvCLtplPC1hAKkC0QahdJSwcGELBALkujtylmQQkOZ2s+6UcacaZutIoL
	 ZLoiJpv+tbeKPu/qVGCVCu25ELXyvq1u/ewknzu0oeGVUIJyIekbRC6sJBV8vPIpoH
	 SqYPEpUjVlCHQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 04 Jul 2026 09:13:35 +0300
Subject: [PATCH v2 2/4] scsi: proc: use kmalloc() in proc writers
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260704-b4-scsi-v2-2-7d2d21a810de@kernel.org>
References: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
In-Reply-To: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, Hannes Reinecke <hare@suse.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 Wen Xiong <wenxiong@linux.ibm.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>, 
 John Garry <john.g.garry@oracle.com>
X-Mailer: b4 0.16-dev

proc_scsi_host_write(), proc_scsi_write() and proc_scsi_devinfo_write()
allocate temporary buffers for /proc writes using __get_free_page().

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Replace use of __get_free_page() with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/scsi/scsi_devinfo.c | 5 +++--
 drivers/scsi/scsi_proc.c    | 9 +++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 15ffbe93ac72..2bccadf4f22f 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -691,7 +691,8 @@ static ssize_t proc_scsi_devinfo_write(struct file *file,
 
 	if (!buf || length>PAGE_SIZE)
 		return -EINVAL;
-	if (!(buffer = (char *) __get_free_page(GFP_KERNEL)))
+	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buffer)
 		return -ENOMEM;
 	if (copy_from_user(buffer, buf, length)) {
 		err =-EFAULT;
@@ -708,7 +709,7 @@ static ssize_t proc_scsi_devinfo_write(struct file *file,
 	scsi_dev_info_list_add_str(buffer);
 
 out:
-	free_page((unsigned long)buffer);
+	kfree(buffer);
 	return err;
 }
 
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 1799dcae775c..fdc355d783da 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -28,6 +28,7 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -74,7 +75,7 @@ static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
 	if (!shost->hostt->write_info)
 		return -EINVAL;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (page) {
 		ret = -EFAULT;
 		if (copy_from_user(page, buf, count))
@@ -82,7 +83,7 @@ static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
 		ret = shost->hostt->write_info(shost, page, count);
 	}
 out:
-	free_page((unsigned long)page);
+	kfree(page);
 	return ret;
 }
 
@@ -412,7 +413,7 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 	if (!buf || length > PAGE_SIZE)
 		return -EINVAL;
 
-	buffer = (char *)__get_free_page(GFP_KERNEL);
+	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -467,7 +468,7 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 		err = length;
 
  out:
-	free_page((unsigned long)buffer);
+	kfree(buffer);
 	return err;
 }
 

-- 
2.53.0

