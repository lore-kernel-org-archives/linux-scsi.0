Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BF238E126;
	Sat,  4 Jul 2026 06:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783145624; cv=none; b=aTzssabHCAB8ANZEayFlO852epCWkvw7h/tsykg/GzzygCyM36E9w52VLre8tFpf4XSAOxzSh7VGi71YacsWbgD7l7gjGPmNmEAgE2GckkW2mqkQR2t8jy+naWsPBxyTzSIBak4PPO/3TmGAf1D/HDHymd+csF614NVJ0PdYMFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783145624; c=relaxed/simple;
	bh=kO9BwleYl6YD1G6ypvNTKiL1gpICoX72/Fc6vqOheGI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bHHKcS6Wx6fy4NHNo70KD+Y9v2Bs829mBiWiUw9aRnV18AonxUsZp3yxjkPELvdOldv4IxHK+N33xRmDpci+598lQplbO4HEUvDbKVgT3JIrneZzUOcR+8tK8h0wDxmZ3FPzVS0N8c1dAfNUf9fINs745AWpGGMHKfZEXHBQQKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JkcCyOCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JkcCyOCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25C71F00A3A;
	Sat,  4 Jul 2026 06:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783145623;
	bh=9+SDuZDxwIL1kIbOtke72tYDvudvYgsBJGC1Qp/Jzm4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JkcCyOCq6l6LrtrHM0kwOqlM+Adl8sZyIF/PIBgjnTQj8QxOt4K4QpBvezc8CgPKx
	 wv0y0fpp90yXKlE6PshiAYUZXTUj9MP1LrXgL+GLzhCLw7HyJNGN1jf7xmzE/dLkwd
	 cbdJTAbyuNnJ9/PrmSUZw2OBVg+frBsIHbHPCtlhLFJSSnf1ynSDxB36JsGR4XzW4j
	 KMDSgtMvyTp3V3x2bkEwfwkLO9uW4GJ9z3At9YiQgxMjSvpnToLq5o0uwiNwvjAYDj
	 j2EDIq6Tbsad2Rsz3SYqC//r7ylzZOtQ4BB9dmy5ND7WrVTQg34nk2hcUMk0RriVa3
	 LmCwYMxhsvXNg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 04 Jul 2026 09:13:34 +0300
Subject: [PATCH v2 1/4] scsi: target: file: use kmalloc() to allocate
 temporary protection buffer
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260704-b4-scsi-v2-1-7d2d21a810de@kernel.org>
References: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
In-Reply-To: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, Hannes Reinecke <hare@suse.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 Wen Xiong <wenxiong@linux.ibm.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
X-Mailer: b4 0.16-dev

fd_do_prot_unmap() uses __get_free_page() to allocate a temporary buffer
that is used to invalidate protection info for the unmapped region by
filling with 0xff pattern.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Replace use of __get_free_page() with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/target/target_core_file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 62ced9f5102f..ab9824a4852f 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -516,7 +516,7 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 	void *buf;
 	int rc;
 
-	buf = (void *)__get_free_page(GFP_KERNEL);
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf) {
 		pr_err("Unable to allocate FILEIO prot buf\n");
 		return -ENOMEM;
@@ -524,7 +524,7 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 
 	rc = fd_do_prot_fill(cmd->se_dev, lba, nolb, buf, PAGE_SIZE);
 
-	free_page((unsigned long)buf);
+	kfree(buf);
 
 	return rc;
 }

-- 
2.53.0

