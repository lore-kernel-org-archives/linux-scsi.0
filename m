Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFC3296BD6
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 17:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773507735; cv=none; b=eDYfZIlUizdkq2w0rknVxSbZFJjO9JsItlpZYZ2uqrPIinTTmeW86Kwa09ilEZdlgtjzQBP8ZPMfcy91YgdrJksZgcID4y146zWmjtsq8VwFFcRg032wviBvnotho1P0TmrmgxQMMWkvdCu1Ka/jyNxt4QBVdhaF5f6ertGHYO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773507735; c=relaxed/simple;
	bh=pKI3AjG1lVa23KqAUrCKI+IQe27+GwOawv6PKd+Q5N8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NDM0ddZhFHIyHQdivuBzr+TggYW5S+7fj9E/aeC8ut4KAETyNGAngUnmCRZYXXnJqPBuL0yCChMLQz85SI6OrW+3EXhCveGxA29EdeSi776SPcaeqDjaoIg0GeZmMAx89j0MtrE7W+HaSZItW3ULxaIOd2a/19+HZyhWWqWQFq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i7VVccyg; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i7VVccyg"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d738fe814cso2663233a34.3
        for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 10:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773507732; x=1774112532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LM37OfuWQSqpQhEds9aiEp1hWY724n1ZIFNOigUMwNc=;
        b=i7VVccygtZxgq2bgLlL76PB0wDdamDGgBdxs4KqrxF1eVFsTIvA5WtutoQbizVkIyF
         ew40h3CK/+NlCOO0Yomn1y27ADax2y6MvXIz9bwqipPuSTgDxZj7htRkpAYW7MzVZq2Y
         SpwR7Nj7Xi9mC2ywStEpaueocA6vkwHXsX+nEJyYXtBxpuJJQ/53Qt0JYV2MQtJ0JrWL
         kCBJor4bonrpD2PioOy9QSiq+rEyoZDTGS/BUjkOG43SdCpARWQEsZP1jVvSNTLdwt1n
         3CNz31odthFpPVdR79rFP3H6bAEp/uGKkpeQ/43STCi92/iuoAyfjX3g9iM9nu6Qg8cp
         Ygfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773507732; x=1774112532;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LM37OfuWQSqpQhEds9aiEp1hWY724n1ZIFNOigUMwNc=;
        b=pkddhtNHiRgoHXj3eeW1d0uS5Xxv9yiybY9UaIBlPuUtK/e5ca3HIcTmn4tizTsgup
         st7wuJ9Ud40dA0cr/mK7cx3eFcI6DzOanDDaU371X1C3iUL98weV/NgAmxm5uezGRz/0
         sQNjcEuIhRSp5ezrUqLycuqbF8CKlY8A3ZxNi+pxEW3B/1jfZqPqWdIkLWcsIv5Zetuf
         CZHwu6JBPrErLWWzejKIyCP7AUXW4P4cuVm3REMODOhJhCijxhqViEh5ykXuxkzxeXnZ
         DzaSXDmE+UqmqFFjjmFk1lOXzyWOzcBEM37XVI4fM+Yq5oyeXRnN7Iq9pTlAxj4V/Wt+
         Hd9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUVSrlk25QW1WWSh/b2ZQqFMaRswH3puVnNUvW0K7CvAClNi099OAUFpEF97mghiQ3vBeMdYEUv4voc@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6w3fUC/GQ0WUJuN8rMSy+yllBk0MmDXoHkpNk3lLwMiFlZy4B
	fBnHNzmnlUihI9hgvxn2nRULwZfk2ebn6IPJhNbGmq9zicamc0NGKSHr
X-Gm-Gg: ATEYQzy+2Il3gA5OlknNNwCe6U2m11N5n1coxwR1XFxZZlxoWCHQ2nO2WfETMFbuNYd
	XjnYovyE3+7SoqgxASnOvo9A4oyQUBLQAPZCF+VZP6oSqk3Rw72HrsUZayO99NXRKSY2MvexSfw
	hBDVux1apV3wD78RlBJCXPtVKqyaG7PxkPzctlFkuiSzxn6AqXawiQ5ebsESJl0CWwcWaYcuQ2t
	DaRllIsL7xj68rGbH2+PbdQkLp0WJR/znmY004MAk3YGLlcDh4cpwW2K9jx9p/qjaHgIfdaCjps
	T3GmqD6PJ1JPjFSKPjBL3H2hVDFXKzDjZy4vc/LrpKyMcrNGyJtLbmawqJCWXaGaayZSYPGccqY
	H4ig6MJ21YoqlL7xHzU7T092Ssed2zHu+8XkW3Ur/QdTtrmq1UBSE4b5BrCx6MOvY144bchz/BI
	+7Q6r56MM0hgItd8ZdQ144RbM+X9hES24zuZ7JgB9hlN4wt8OX97ekXwdfoHTMEtLjDllI55UpS
	btT
X-Received: by 2002:a05:6830:6607:b0:7d7:3937:97bb with SMTP id 46e09a7af769-7d78245c4famr5186888a34.9.1773507731706;
        Sat, 14 Mar 2026 10:02:11 -0700 (PDT)
Received: from CS-396-Lab-Machine.. (c-24-12-10-127.hsd1.il.comcast.net. [24.12.10.127])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e2a17f1sm11610430fac.8.2026.03.14.10.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 10:02:11 -0700 (PDT)
From: Tyllis Xu <livelycarpet87@gmail.com>
X-Google-Original-From: Tyllis Xu <LivelyCarpet87@gmail.com>
To: tyreld@linux.ibm.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	brking@linux.vnet.ibm.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	danisjiang@gmail.com,
	ychen@northwestern.edu,
	Tyllis Xu <LivelyCarpet87@gmail.com>
Subject: [PATCH] scsi: ibmvfc: fix OOB access in ibmvfc_discover_targets_done()
Date: Sat, 14 Mar 2026 12:01:50 -0500
Message-ID: <20260314170151.548614-1-LivelyCarpet87@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A malicious or compromised VIO server can return a num_written value in
the discover targets MAD response that exceeds max_targets. This value
is stored directly in vhost->num_targets without validation, and is then
used as the loop bound in ibmvfc_alloc_targets() to index into disc_buf[],
which is only allocated for max_targets entries. Indices at or beyond
max_targets access kernel memory outside the DMA-coherent allocation.
The out-of-bounds data is subsequently embedded in Implicit Logout and
PLOGI MADs that are sent back to the VIO server, leaking kernel memory.

Fix by clamping num_written to max_targets before storing it.

Fixes: 072b91f9c651 ("[SCSI] ibmvfc: IBM Power Virtual Fibre Channel Adapter Client Driver")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Tyllis Xu <LivelyCarpet87@gmail.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a20fce04fe79..3dd2adda195e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4966,7 +4966,8 @@ static void ibmvfc_discover_targets_done(struct ibmvfc_event *evt)
 	switch (mad_status) {
 	case IBMVFC_MAD_SUCCESS:
 		ibmvfc_dbg(vhost, "Discover Targets succeeded\n");
-		vhost->num_targets = be32_to_cpu(rsp->num_written);
+		vhost->num_targets = min_t(u32, be32_to_cpu(rsp->num_written),
+					   max_targets);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);
 		break;
 	case IBMVFC_MAD_FAILED:
-- 
2.43.0

