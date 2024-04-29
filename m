Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FC1177990
	for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 20:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714423302; cv=none; b=QucmARu8khfvunI1mvVlcUglEjIRk1BBaEfEMZV8QS9kGqsaXm6LG6CHBzeEzKEBThYz57u3Sk3rvyY2i5QwZKWwBptGsJhI8KE94y6VK82vl2w/W6Z3OzKOxNvoTseTNey0nd04iWla1QJ43DJb1KiKewfrTNES6nuN2zOe4/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714423302; c=relaxed/simple;
	bh=ShCokyp7WaKHXsOH1IP5K/hVAlu8BqMuRCrIfNBGjdM=;
	h=From:Subject:To:Message-ID:Date:MIME-Version:Content-Type; b=HkziADuj465/tC3hqSbcNXEhDhdaN+Z0+x/Pnerw6XeQfi4c32WUSWOFM2azRkZoKfsgxyp2W4kTUhatia1LMqbWZXfBcgR4RLPHpq+h0a3I9o4bNIUOSJer2Mvz/EOkevwQg4Vb98yCM5f+E3nco/D2aLYYwG8mybilbvUv1nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from [192.168.1.105] (178.176.72.208) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Mon, 29 Apr
 2024 23:41:22 +0300
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH] scsi: sym53c8xx_2: hipd: clean up error path in
 sym_alloc_ccb()
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Matthew Wilcox <willy@infradead.org>,
	<linux-scsi@vger.kernel.org>
Organization: Open Mobile Platform
Message-ID: <9bb4378b-dbf7-954e-9d89-3f25aca70cb1@omp.ru>
Date: Mon, 29 Apr 2024 23:41:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.0, Database issued on: 04/29/2024 20:26:07
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 184981 [Apr 29 2024]
X-KSE-AntiSpam-Info: Version: 6.1.0.4
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 18 0.3.18
 b9d6ada76958f07c6a68617a7ac8df800bc4166c
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 178.176.72.208 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: {Found in DNSBL: 178.176.72.208 in (user)
 dbl.spamhaus.org}
X-KSE-AntiSpam-Info:
	127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;omp.ru:7.1.1
X-KSE-AntiSpam-Info: ApMailHostAddress: 178.176.72.208
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/29/2024 20:30:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 4/29/2024 5:01:00 PM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

In sym_alloc_ccb(), if sym_calloc_dma() call fails, the code tries to call
sym_mfree_dma() on the cp local variable which is still NULL at this point.
Get rid of the meaningless code under the out_free label and, while at it,
get rid of the useless cp variable initializer...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

---
The patch is against the for-next branch of Martin Petersen's scsi.git repo.

 drivers/scsi/sym53c8xx_2/sym_hipd.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: scsi/drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
--- scsi.orig/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ scsi/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -4862,7 +4862,7 @@ void sym_free_ccb (struct sym_hcb *np, s
  */
 static struct sym_ccb *sym_alloc_ccb(struct sym_hcb *np)
 {
-	struct sym_ccb *cp = NULL;
+	struct sym_ccb *cp;
 	int hcode;
 
 	/*
@@ -4877,7 +4877,7 @@ static struct sym_ccb *sym_alloc_ccb(str
 	 */
 	cp = sym_calloc_dma(sizeof(struct sym_ccb), "CCB");
 	if (!cp)
-		goto out_free;
+		return NULL;
 
 	/*
 	 *  Count it.
@@ -4919,10 +4919,6 @@ static struct sym_ccb *sym_alloc_ccb(str
 	sym_insque_head(&cp->link2_ccbq, &np->dummy_ccbq);
 #endif
 	return cp;
-out_free:
-	if (cp)
-		sym_mfree_dma(cp, sizeof(*cp), "CCB");
-	return NULL;
 }
 
 /*
