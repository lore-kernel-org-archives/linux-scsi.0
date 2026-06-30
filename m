Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21503FF1D5;
	Tue, 30 Jun 2026 10:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782816866; cv=none; b=AwGb0cFLKGftlQUV7bUddt3/B/Iy6eWFq2hPEnNot7FR8jEqJxRsfKgrBF1z/R38pHj9f/jkC6ExYIoEhJZ0N+2jt9MQrsf58+mxv60K61TBriR7l7EZXh7dVmyieBzwsERVLUg744Wg3lry+Hc4cnLTv/i4PcJVEQiWIC5kqgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782816866; c=relaxed/simple;
	bh=iVgYnCclAX+Ju7VWq50P2y9AdH1arO83z8+yfFQaziE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AoqPMhmfu4VcD/SCDTPhcve6wnl7mk2J7ZQcz9tXXIlw9UM+rT67bNCgZ4yJ3hyDgrSvDTZ5+MAEiBlV1oSXMUmRLM9rZ0xB+TngULpgwau/BwEL9c0Ht8MsdreEDrkxZOy9sn0TBnILI4B1y6yRFp3tbgXWTl74yvYBj5fQ9jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gjf/ZuGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gjf/ZuGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1951F00A3A;
	Tue, 30 Jun 2026 10:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816865;
	bh=KvAMoaymjsNlTe4kwsyBLHq1Qu+UJKHUnCgBBRJ3/ao=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gjf/ZuGe9/6tmqVaNQU85VRcHoOkG2BkpuNKDBPGkJR+sdHeZqmEMjjOq4X+bf6Jj
	 kcYkVsKjDRym5vCqxmovsyaqquaHOr20VeJy3Wi9n5lZ15vWTC/rQAuGjdn9rlD1ot
	 aIehXwlUMfnL03EFyofiqO48TFZGSo2yAKkyi/anxE4e850c+PfJd0BZeAm94uiw99
	 vlMIFizPVCSqklDNClOZLR2m5o8PEo8WgrJOSobc1sBe6tPqOKWcgEleB3IEEYr0Aw
	 twVQjEQHpgLLFcD/PbULzMoiFWjNLZxcWhDuTB+yvzSR8a0yCx8V+x5+nXWqllVwd8
	 l3AcZ+ouFkp/A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:54:18 +0300
Subject: [PATCH 1/4] scsi: target: file: use kmalloc() to allocate
 temporary protection buffer
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-scsi-v1-1-494fb37ebe7b@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
In-Reply-To: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
X-Mailer: b4 0.15.2

fd_do_prot_unmap() uses __get_free_page() to allocate a temporary buffer
that is used to invalidate protection info for the unmapped region by
filling with 0xff pattern.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Replace use of __get_free_page() with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
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

