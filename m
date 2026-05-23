Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2CE2DC79F
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 05:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779512581; cv=none; b=nBjHkRGcx4SVJAZYaFj+QZfZuj/7A2dnpmMXlcDSF3WUlxE56TZLo1V0X8uyeycqhftEm7TbOnl2kkGmOxY9c5hn9DwxxpPqwOojvUaPbm+nllJAF6Z3gbujfEKnMV5hYM7mbLCWDH4tLPqjh9mxk6dqeVtsPHPrsS41D9OIfM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779512581; c=relaxed/simple;
	bh=jQJ2qFF074cR89wuFp4c9Jj5HzBzhq4twa0i+QOq2eA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RJNAtuVaY2jdb5NPS0u+gqJw9m9axEBqccA5ryi0n/D0XrzwYLKW9/VFEKNMRsAlL8RNwMVILU52q5HZcpOYj53sXBrFsIXbmTxIF5eaUimLMlpDjuEi/xYP7G45CPDPn+GJDvpXcKr7ernPcoARpAcopNpJmZGuPBHpDmMz2Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C4SweenO; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C4SweenO"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-835386ff122so8208602b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 22:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779512579; x=1780117379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=875rkuTs2QJz3nUSmxbt1umQe94h+dEtfCuWCoCurMk=;
        b=C4SweenOwwTgOVlCyG1ilxYCduaXjxKapaX9HReIlidj2Q8QZAn5Eqw5yMO6EDsZ2N
         k5XSrwm0xvha1XX4T0OMrfY75+BdU7Ei1e4/xZ8GgiT6mvGmv9Ad8VUlmTl0e44zOz0a
         WF206cxlFB2zIr63J5cwnoJat2Ga2szsNlGXuDnGFvt56ldJbBZDKJrW4Ii+N93RkVvQ
         rVmzCYlerZ1oX59EKYCoOWoiWWL9p3ZOzeJM6aeeqhxiXMpjxuor9ypgl1RxTGHdY+Im
         56mkNgM4BT0xRtracDIGI5lTsXm3CwPfnBHL6/XZo74di2raH9vpcmy8e38E6BWtR44J
         93iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779512579; x=1780117379;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=875rkuTs2QJz3nUSmxbt1umQe94h+dEtfCuWCoCurMk=;
        b=FrPzLcOOp2ly7AwbWZBwu4WPtFbR5Zb78AgSWic75o0lRdCI/9AYQ22IBnXZYijPmk
         ifEH8egVkCTiIbNw0BYbm8++y4UanoHTMF7ldFDimsABkFVciqu/wAyQLD4QViWksokW
         ZvFyKsmcrOKH14I7RE8RRWKJ2rHLHQxz+mxVQuO+mJNoAChJrxL6JZFBRVFo6//NEuc3
         ha1yJqvcchyLCzlV0RfOHMAJ9YCLFeRnJ7EcwDoAFrti24R1L1vVK1k1ccfiOcsAtV3B
         OKVwAJo/DBgN2PfPl1wu1NhDyX1oqCDmIRmwmnVrzvxVLF6iGr8cJLbqcMiDKbK+FQEj
         WJCg==
X-Gm-Message-State: AOJu0YzxHAJCFMdbR/miyookwb+cwVOABSgvKLy9uMV9NPxS7ocMvzXo
	Ijl9dSR+2KkCHUXgbpE94PQiheeGjcYttf2WV05yxa8jub5JZPs6C35D96nLlTM4
X-Gm-Gg: Acq92OEcdndHWtj6+kBSZqbvU+v2lLtzTkhdP7aHEfwLVfol3/lSeJBA/9SVmu0gyHt
	EQbeqkSA5ShhYVwGPc4xrVRdtIR25AHx9epsaZPfCeAl7/ma7bZ3ARG0yN+RU2/H/htgSBSS+EB
	i7EyF+s+A0t6IuCHmkk22o5dEOfIfOGTpNSGG4cHNuxQGc6neZmzVJzUAbVWVjwVuj1IIOSXYfn
	ib0eiaMGpqV8b2llQvbpc9s94nEb80HAL4+SJOjFwzQZFQc3iHgbke1O1ZyuTbifd0FCypdFXS9
	1iy3GKloFDDC/ErrHcYesgoo9BIYRBNzIhMcujWgLoA29o9AbjsLLIxT0H2U34ZPGGwYZLeYXfm
	ZT4Otu86w27NuF3VNGkbBEwbTOkAdFuP1e2LMBW7MZcOIl1YvG83wyfXSxRIscDxS+kanINCTVw
	vSouXhogQBpsc+YMvdg0ibF5d8mrpORorAcjmAo05m7AEsTRU9aBXIDEJUnqKMW2iju+17Y7PsT
	HIpd1sqMv6ClT8uw7QKEiTFHh7t9r1QuvywDdPEsU4jfXt8fKYj4RQ6
X-Received: by 2002:a05:6a00:8c04:b0:82f:4f63:31e1 with SMTP id d2e1a72fcca58-8415f3af3e3mr7144628b3a.8.1779512579512;
        Fri, 22 May 2026 22:02:59 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164fe0bb8sm3184236b3a.51.2026.05.22.22.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 22:02:58 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: lpfc: turn lpfc_queue q_pgs into a flexible array
Date: Fri, 22 May 2026 22:02:41 -0700
Message-ID: <20260523050241.190239-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The q_pgs pointer was assigned to point at the trailing memory
allocated past the struct. Convert it to a proper C99 flexible
array member and use struct_size() for the allocation.

Assisted-by: Claude:Opus-4.7
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c  | 3 +--
 drivers/scsi/lpfc/lpfc_sli4.h | 3 ++-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d38fb374b379..0e56e7034566 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15875,7 +15875,7 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t page_size,
 	if (pgcnt > phba->sli4_hba.pc_sli4_params.wqpcnt)
 		pgcnt = phba->sli4_hba.pc_sli4_params.wqpcnt;
 
-	queue = kzalloc_node(sizeof(*queue) + (sizeof(void *) * pgcnt),
+	queue = kzalloc_node(struct_size(queue, q_pgs, pgcnt),
 			     GFP_KERNEL, cpu_to_node(cpu));
 	if (!queue)
 		return NULL;
@@ -15892,7 +15892,6 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *phba, uint32_t page_size,
 	 * resources, the free routine needs to know what was allocated.
 	 */
 	queue->page_count = pgcnt;
-	queue->q_pgs = (void **)&queue[1];
 	queue->entry_cnt_per_pg = hw_page_size / entry_size;
 	queue->entry_size = entry_size;
 	queue->entry_count = entry_count;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 2744786d9c94..e2b95fb50d55 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -280,9 +280,10 @@ struct lpfc_queue {
 	uint64_t isr_timestamp;
 	struct lpfc_queue *assoc_qp;
 	struct list_head _poll_list;
-	void **q_pgs;	/* array to index entries per page */
 
 	enum lpfc_poll_mode poll_mode;
+
+	void *q_pgs[];	/* array to index entries per page */
 };
 
 struct lpfc_sli4_link {
-- 
2.54.0

