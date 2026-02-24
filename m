Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44463644A6
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 23:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771976999; cv=none; b=oFYzqxjONhPNorVGNG9AC/N3o4dD//FyNwb6B2EPHqj9im+SZWvv9ymkQsjAd9CpwIUeEkCYYhwXO9nJ6DAugmluVoOvjGKc+aydrKSri09XFk+L534+MUfa8XLpiVoptjUSswWCUeIcsOJxWa002OaDyNXNWZRfzemh+zow20k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771976999; c=relaxed/simple;
	bh=J+4h/r6PfIA5r1H5UCrLCxldyRvYciqP75yzvjZ/MzU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KUoRRwbp+nGuQGlQyAGiFek6ffQZWoCfSfw0LnY4Dja6Hp7AQNyNmONGHHPVLDvUab5WRBjWcEM50ukVWqUSxz+yKRDczV5kdmRRSk3hpuB8mJjBffWezKsd5m9ADmBg2Qvlyhl3LiQhHld705kV3FW9aL2zASjQpZfD1SBwzT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jeFMewJD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jeFMewJD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=xJqJBNiACHhL3Sy1EJqJkuv2aUaypaQal5ETySpj2hk=; b=jeFMewJDDHtJwzK+yBKdGZ3lcZ
	/M/VP4SRsorJ6XOOP7foi5hJTv1N7q7qwrvcxqOuuuCHU0FzJ5WuYg7UxQNrGl2VBs+Tpg2jKly6w
	5GBJduDzgTSC3wrVTMHYrEKn+nQQjkHmPa9WcZSjNlFt6UTIICGnqQGxyMXUJFXt7d//5V1LojGMj
	Ed9iOIDpvM91mScDNbpp58WzNwl4kLZTjCZo+UFAJZIWhLXp9TY5Ay0qdHvyCy9jZidYaGlqu7+M5
	TC2ZF2i7Lp9XVjPzOPEOmtmKKt6vXjAyOehtkoVqKvFI+vuqENRbPI6WpqktLeVVa9Mcp4hQtYcOT
	OnrD4IOQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vv2A7-00000002wvs-0p40;
	Tue, 24 Feb 2026 23:49:55 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: lpfc: eliminate kernel-doc warnings in lpfc.h
Date: Tue, 24 Feb 2026 15:49:54 -0800
Message-ID: <20260224234954.3606638-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid all kernel-doc warnings in lpfc.h:
- use the correct function parameter name
- add a '*' to a kernel-doc line
- repair the function Returns: comments

Fixes these warnings:

Warning: drivers/scsi/lpfc/lpfc.h:1674 No description found for return
 value of 'lpfc_next_online_cpu'
Warning: drivers/scsi/lpfc/lpfc.h:1686 No description found for return
 value of 'lpfc_next_present_cpu'
Warning: drivers/scsi/lpfc/lpfc.h:1700 function parameter 'eq' not
 described in 'lpfc_sli4_mod_hba_eq_delay'
Warning: drivers/scsi/lpfc/lpfc.h:1755 bad line: --------------------------
Warning: drivers/scsi/lpfc/lpfc.h:1759 No description found for return
 value of 'lpfc_is_vmid_enabled'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Justin Tee <justin.tee@broadcom.com>
Cc: Paul Ely <paul.ely@broadcom.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

 drivers/scsi/lpfc/lpfc.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- linext-2026-0209.orig/drivers/scsi/lpfc/lpfc.h
+++ linext-2026-0209/drivers/scsi/lpfc/lpfc.h
@@ -1667,8 +1667,9 @@ lpfc_phba_elsring(struct lpfc_hba *phba)
  * @mask: Pointer to phba's cpumask member.
  * @start: starting cpu index
  *
- * Note: If no valid cpu found, then nr_cpu_ids is returned.
+ * Returns: next online CPU in @mask on success
  *
+ * Note: If no valid cpu found, then nr_cpu_ids is returned.
  **/
 static __always_inline unsigned int
 lpfc_next_online_cpu(const struct cpumask *mask, unsigned int start)
@@ -1680,8 +1681,9 @@ lpfc_next_online_cpu(const struct cpumas
  * lpfc_next_present_cpu - Finds next present CPU after n
  * @n: the cpu prior to search
  *
- * Note: If no next present cpu, then fallback to first present cpu.
+ * Returns: next present CPU after CPU @n
  *
+ * Note: If no next present cpu, then fallback to first present cpu.
  **/
 static __always_inline unsigned int lpfc_next_present_cpu(int n)
 {
@@ -1691,7 +1693,7 @@ static __always_inline unsigned int lpfc
 /**
  * lpfc_sli4_mod_hba_eq_delay - update EQ delay
  * @phba: Pointer to HBA context object.
- * @q: The Event Queue to update.
+ * @eq: The Event Queue to update.
  * @delay: The delay value (in us) to be written.
  *
  **/
@@ -1753,8 +1755,9 @@ static const char *routine(enum enum_nam
  * Pr Tag     1               0              N
  * Pr Tag     1               1              Y
  * Pr Tag     2               *              Y
- ---------------------------------------------------
+ * ---------------------------------------------------
  *
+ * Returns: whether VMID is enabled
  **/
 static inline int lpfc_is_vmid_enabled(struct lpfc_hba *phba)
 {
