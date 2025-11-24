Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB8D3126B7
	for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2025 14:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763996350; cv=none; b=dsdRcUsvMSm+q/IPDnnBQ/PzKJYIJfSWBFHypdP9yppKuOOi/s9rxtrcspWsEMb1UPJ726Dm+0fZ+eYFWBx5BysCKg1Y7nKdz1jpt3F+T2/Oyk3OU9tu+gDGohR1EDAh0bS3hi4VE7cqx9UlHbN39xZh6jvlxxoEM+ubAXNsvvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763996350; c=relaxed/simple;
	bh=2alUDv8rvceCb5R0lAIMpgim+otu2LkDkNJp3n4GNU8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VKzSqm2263em5dg7ApKC8vJgZBatxSsBkEJTe9Y+2M9VhXGGHQo1yfHV4xGn30JWuEjxkfhxRhJXRKW8K7Nl+uEIHVI7cRdh3bl8k3yY4Al3EQkjMjMtU3WoQgP62Vn6320kHUil3a6+u0Ll8ChRL9bQJJ5N5lBLi+Akx7Ze1Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lmc8TUCw; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lmc8TUCw"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-340bb1cb9ddso3616493a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2025 06:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763996348; x=1764601148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xb/VAa48jm4ZVOyqZFMVfLn47WQAUiV4skOomqo7/fk=;
        b=Lmc8TUCw8zEh6pp+UGkQZWgl82kzg8HJn2UB51yJmScKIE0aIfF0xJAqDOQT4A7A6B
         P6gyhruyc5g+ivirXeFkEmGfB6xwgJyeD1ET07kG9Hmfx0Z7/OUTsO8Ifwp62TAiwCFu
         1QCLHPE8tAC5k0Te6GDRmC415MWI6KNI5t4hzpdIYRLmNrTMb99Xn3z5E5QmfhcmVjUm
         1VngG8OKEzn/QeE0bygIQOCDnvwE+Qmo8Kgf05SGSD4M59hdVXlS+anuCROX8WiUkba0
         Bv0kimkeKH0eKJwEbVcj1/1QFJ0LUDK6rNkyg/qI3a+sNdV37ejw1sieQqAEXi5ZJ4Jq
         rDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763996348; x=1764601148;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xb/VAa48jm4ZVOyqZFMVfLn47WQAUiV4skOomqo7/fk=;
        b=s8yHDaqBxKD8IhKqhh+jmmlrJq1dhRsK3gD2qG34kgsXhs3Z03E55s7uZbmhzHxa1q
         vWtNfcXr+bBlzOMOhkKlXGWZ3QlHJX2KHmvNLK/GQtRUpIqmcVIEpbehIMbKdIse36wi
         xxqXtherLuzQJ/8o/JERqoL6jOH82q977vYSdB+Ou5+GVGbp3TI/wb86iPX6g7+mSmzX
         A0uFLGS1vJ4q/rE2D2uAfhn8hewt4mLW62zneLppAnVy30GBKMyqSStFczrJMDJqoQd+
         UvtbQJYHhnmxYip5iaWoK6wu5lFwhy8jWTF6dvlX6SRhs7Lo+Nd02MqeHuOBrD8qaqHT
         bfLg==
X-Forwarded-Encrypted: i=1; AJvYcCXoyaMzhlltCnU2gSY1ZiLUdSnpFF/Bbg9rGeQDGVxHioPlnrzEmejKehmrJmZdNQZe0CeuwcKmAoEm@vger.kernel.org
X-Gm-Message-State: AOJu0YywTdkOUAFoPt3dstgKwpZ/GOqNuRPl8IrUiZd9G683i39eUNzF
	nLYf3Qrl2JrBoUdRbQeCKbZQzHdxmb1CR7LbeiZaRShbjys/rxe2OL+i
X-Gm-Gg: ASbGncuHEsibvbUZbcp8+H7nLuGwM0zFkPwnitKMjwzdfvwxK6pp3Uf77MjMPy1CEBo
	JGJYj/c9JSim5w6TLNnprgYSsjB+pNZamAxiXYEgMIUvp/Fceml8qcjySMCCzV4BNKjlzASZmkJ
	nc0oZbbHXGgsm3q0z3FhCz1CQj2rAym0dSe1zvLy7eeluNwgwMr8//Krd0LvltfC9+tqkPhzz4E
	+CUHcRHb8Cemo7cI6C9YlB7IHdYAnM6Aehn60OL3pQ6Ct0f+iqxvvg6YsWLw4k0FD//xVkQ/B5K
	zVIiUB4lF9OXnH3M9zuW1TsvYQNH8HGP6mm0QPYimzgSVuO3hbggV1Y8DelWYkYsxyc7unFuOb+
	IxEIorn2vqThTyz8UJ+hZleipnnA7q/dX9F6PbmLFJNDf68cF0Dol9lCJc1IIFSR/2n32WromXt
	2nXfL6ZbD5Z58=
X-Google-Smtp-Source: AGHT+IF47tZPA1s/sNz5ZKhfOqmGjsFMQe6TdOQJCoWicSrdNNBoEVVUABWVfRIaFbBPxSsULWLDjw==
X-Received: by 2002:a17:90b:48c5:b0:345:badf:f1b7 with SMTP id 98e67ed59e1d1-34733f3eb64mr11950422a91.28.1763996348107;
        Mon, 24 Nov 2025 06:59:08 -0800 (PST)
Received: from lgs.. ([2408:843c:3010:c65:73e9:29e7:cb49:995d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f175275asm14937606b3a.69.2025.11.24.06.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 06:59:07 -0800 (PST)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: HighPoint Linux Team <linux@highpoint-tech.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] [SCSI] hptiop: Add inbound queue offset bounds check in iop_get_config_itl
Date: Mon, 24 Nov 2025 22:58:48 +0800
Message-ID: <20251124145848.45687-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In the driver code for the MV‑based queue variant (struct hpt_iopmu_mv of the
hptiop driver), the field "inbound_head" is read from the hardware register
and used as an index into the array "inbound_q[MVIOP_QUEUE_LEN]". For example:

    u32 inbound_head = readl(&hba->u.mv.mu->inbound_head);
    /* ... */
    memcpy_toio(&hba->u.mv.mu->inbound_q[inbound_head], &p, 8);

The code then increments head and wraps it to zero when it equals MVIOP_QUEUE_LEN.
However, the driver does *not* check that the initial value of "inbound_head"
is strictly less than "MVIOP_QUEUE_LEN". If the hardware (or attacker‑controlled
firmware/hardware device) writes a malicious value into the inbound_head register
(which could be ≥ MVIOP_QUEUE_LEN), then subsequent "memcpy_toio" will write
past the end of "inbound_q", leading to an out‑of‑bounds write condition.

Since inbound_q is allocated with exactly MVIOP_QUEUE_LEN entries (see:

    __le64 inbound_q[MVIOP_QUEUE_LEN];  /* MVIOP_QUEUE_LEN == 512 */

), indexing at e.g. "inbound_head == 512" or greater results in undefined memory access
and potential corruption of adjacent fields or memory regions.

This issue is particularly concerning in scenarios where an attacker has control
or influence over the hardware/firmware on the adapter card (for example a malicious
or compromised controller), because they could deliberately set "inbound_head" to
a value outside the expected [0, MVIOP_QUEUE_LEN‑1] range, thus forcing the driver
to write arbitrary data beyond the queue bounds.

To mitigate this issue, we add a check to validate the value of "inbound_head"
before it is used as an index. If "inbound_head" is found to be out of bounds (≥ MVIOP_QUEUE_LEN),
the head will be reset to 0, and "head" will be set to 1 to ensure that a valid entry is written to
the queue. The resetting of "inbound_head" to 0 ensures that the queue processing can continue
safely and predictably, while the adjustment of "head = 1" ensures that the next valid index is used
for subsequent writes.

This prevents any out-of-bounds writes and ensures that the queue continues to operate safely
even if the hardware is compromised.

Fixes: 00f5970193e22 ("[SCSI] hptiop: add more adapter models and other fixes")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/scsi/hptiop.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index c01370893a81..a1a3840e6ea8 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -166,6 +166,14 @@ static void mv_inbound_write(u64 p, struct hptiop_hba *hba)
 	if (head == MVIOP_QUEUE_LEN)
 		head = 0;
 
+	if (inbound_head >= MVIOP_QUEUE_LEN) {
+		dev_err(&hba->pdev->dev,
+			"hptiop: inbound_head out of range (%u)\n",
+			inbound_head);
+		inbound_head = 0;
+		head = 1;
+	}
+
 	memcpy_toio(&hba->u.mv.mu->inbound_q[inbound_head], &p, 8);
 	writel(head, &hba->u.mv.mu->inbound_head);
 	writel(MVIOP_MU_INBOUND_INT_POSTQUEUE,
-- 
2.43.0

