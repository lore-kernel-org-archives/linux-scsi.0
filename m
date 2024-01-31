Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7F41E495
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726254; cv=none; b=OWY4kcAMIxOlk9olzIqJrtUVF5J7uXENYPY7P7irt6QGftRVc//20Kq8BZCEVyxoeYwP4nh0Hn1aD2qYaW9vGSdM1+0ywh1Q2SiwGL7DtjWsT22UM+FEHuGlXGM7o6Wprjnu9ATXyPy79OPuGpnsxfor7UlvA+Hy1NOv0yItocw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726254; c=relaxed/simple;
	bh=IAhuP0aGhWisW08xFRWK8KqxsKmD3kZUDLpYtizbU7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rY34NtGVd5o+pe5Y41ff70tEI3NMHMvzPgNeUDZNRnegyB8v4VJgpii14eu7uB2ay/bykJwC4flIXaQDqMayAS9u0IXtaQ9tTRR7XQCo6fHDALhhd1EbwdRVtl5TLDzdN2qfV6RpJSDsmNaSvXWV21ooSFmNq1YheD7TbH5uF0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iYRMkeNh; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iYRMkeNh"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-46b3a129522so8629137.1
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726252; x=1707331052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q18ukcNe8RLqMGrS2HndRD7T0y1FTeIt8zCq4DL37vQ=;
        b=iYRMkeNhj5Z8ufCTBSdf4QrZGPhknUbHHPKTmLWamTLc5ZxqpcX0jun4YY0Smea3SI
         AJ2rmm0G2kp98ABlZol5nwfd7g1JCaE80D5FYPjw/DYmE2cFfKArorDx3vkljF9Hqj6I
         XCYvlpdxQMJhv7eQZLIjXHzLK2v7s+92bWaAwB75EExkxSw8PmDSSSbw3T2qcrW+W098
         EXrEtJaxYzBtdVtaFHKIXbFBabvajvBJWGHvE3+FStjIJXy4mH0OGnsVw5sV3nlmIaAE
         fadI9b2zExSnIUIJv/uM7KRt5giQayE+JmivpsXn/HxDZwfjrP4WPA1aaAp+682waMxU
         K0/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726252; x=1707331052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q18ukcNe8RLqMGrS2HndRD7T0y1FTeIt8zCq4DL37vQ=;
        b=JqqIyI/ot0IvilZjGesVyJzNj4rFEHSPY/IB3f0DM19Yp4RGj90S4kEKHcogWF2ueN
         d1a4SoenJ51M/t+xzPyvltpUor3yXcgVebLIuiZdFplNlhSCUTEFdT9rOIwxz8fGGueQ
         H8BxrNvpvzUC49ogveBitqv/aOCj6GTnWIQZsRc89avyM7Cy0XEygaU8dGc61Z7fzNCf
         nk52oKS6HkVMs0CMWJTChRnQ4xAQwaWStEJkx/1twy7AQ2t7JgXq/QjM6A4MKbxkvjau
         3cLlN2YRlHjR6Hfz7flRIZIIsZN6Z9NpkXPkz3NMgoOlQrklOc4zkOnohu6y0d3ijEjm
         P4cw==
X-Gm-Message-State: AOJu0YySDDXbTxRxdjCU+Ibss+4sAj60Y+X0lSrTcyrMJYXGymlUs3dO
	4rvow8PZa6uVm18OTxidLuayHevW/yDlO5fqaWgGQwHBmOHXReDo4ydy4i23
X-Google-Smtp-Source: AGHT+IGDV1G3Os2DApDIko4v9UuR7LbhR5X03fk3KAarTCZqQlKb0W/og2zEOWGZhrn22643Xf12Lw==
X-Received: by 2002:a05:6102:2913:b0:46c:b185:81c with SMTP id cz19-20020a056102291300b0046cb185081cmr426769vsb.2.1706726251868;
        Wed, 31 Jan 2024 10:37:31 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:31 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 09/17] lpfc: Save FPIN frequency statistics upon receipt of peer cgn notifications
Date: Wed, 31 Jan 2024 10:51:04 -0800
Message-Id: <20240131185112.149731-10-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131185112.149731-1-justintee8345@gmail.com>
References: <20240131185112.149731-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FPIN frequency is provided by the fabric in peer congestion notifications.

Currently, the frequency is only logged in a message, but it should also be
saved into the phba's cgn_fpin statistics member for proper application
functionality.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index a17c66e31637..1ada8ba6cc2a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -10131,6 +10131,9 @@ lpfc_els_rcv_fpin_peer_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 	pc_evt_str = lpfc_get_fpin_congn_event_nm(pc_evt);
 	cnt = be32_to_cpu(pc->pname_count);
 
+	/* Capture FPIN frequency */
+	phba->cgn_fpin_frequency = be32_to_cpu(pc->event_period);
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT | LOG_ELS,
 			"4684 FPIN Peer Congestion %s (x%x) "
 			"Duration %d mSecs "
-- 
2.38.0

