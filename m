Received: from mail-qt1-f228.google.com (mail-qt1-f228.google.com [209.85.160.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782DC33C1BC
	for <linux-scsi@vger.kernel.org>; Thu,  8 Jan 2026 06:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767854616; cv=none; b=QfwWkdZnDl6xzLa0wGGvMAlJ5ln7RnXPE3YDPLEXvCvOnHrl75mR488oRIKFdoNJJ9bq771YmaeaHT/luwA6+92Y0Wg2O+C8afbCLPgdY+uK7yY2ShP+Ks0WAP2FTZoGa4J4qbFlSntzZZ4Dntx5qunVkZN+3QyuyWbhGu3MbTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767854616; c=relaxed/simple;
	bh=5mic/q6vuxQbS8YXyfZUjqQArn9vFbNhUdp2DnF4O0M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iCUuBMlq5FKwx9IcUuBqbMdOUrxa/b9aXwdmf3T5FhMoI/5t3gYPtj0cCiFP8lSZBmfQrbf8gmMP3JYUE9ebOxV+AYeCe6bnv/av0RBZp6KVcINdczhJo4O6R8JwWgJlN6nf62mjdzDJx1D6JdqPhoCxvPD222riS2io1uYSaXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=X/qFFU1e; arc=none smtp.client-ip=209.85.160.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="X/qFFU1e"
Received: by mail-qt1-f228.google.com with SMTP id d75a77b69052e-4ffc5fa3d14so229781cf.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 22:43:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767854608; x=1768459408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RXr5VPevjUOPqn3fRQwqWW7ZEAc2kKpuQcOkyGsfGno=;
        b=i9NaaqpFgCbaVbnNL0vORFU4W87oyR11cCtPLrpwTsRul3d76sGDa+x6zdoq9kLJMj
         psJhvkH0RNk85QjZMXgxSZydVhyf6SVpiYtk1vUuIFRNG80EiU6dSokVnKX7OuRuCovh
         BDOph2OfR2JbQeEMgVuEuXiTlWqb2xnAzC2mHdHBIhd5di0BWczI/BNIGVb8N0eFW/Hp
         RyUdvFa5fEm6gefnUjl/wT0f7I5WCr4J779UqT708Xv/OhDVvkldsXOS4o/Eydk53+Xb
         nWmjec3+zEAdNGxzr61fs4ZCLGw93vGmfyCXzJZX5g5iyKOTQMHV2/BdjpOpgtn//pkR
         eCLw==
X-Forwarded-Encrypted: i=1; AJvYcCUic/3y/gMXr6LAhj6w8/fErwHmSSBlA7hUOquNozg4ikEKFMnS5cMFQq0uw25kmnQPRrIGlqyV4Qi8@vger.kernel.org
X-Gm-Message-State: AOJu0YzymsnfyO4y8JyCg9CcyCx84pvfIjtl533hublDSuN2UtEV5zUc
	u9R4dSlnjkjnpPXhQG8jNYk0l5KUjgozWmFZWKzlgDU39rQVLv+84/shgBGVqe4AQhi6MB0I61C
	Y+h1w95BFVau6YL0R0nUF1GPmgcxy/GnMlOaYFTlXAWe6LjgvsHRpGoFSswR0H2F45kNBvVZovo
	9ywC0tjmePnr0kB8us3Dld4OGrnHnwsyXWLflneZwG6XUk6szB/SZo9p4L1IJrkiEfxSQc9jdyE
	+37RD2EA1hPD/qWCxDqM4o=
X-Gm-Gg: AY/fxX77z1lexHl0SuDK01e68kZMS697Esbl+8LmBralfdEcVsm7lfh36gEwLGagU5m
	xowGzwA0zI3jeUNKFQeFGwdQH6Qz5jGi7SvP0i4Svu7kYOmFWgEbFUpogteWF8egdlMYJecYsdm
	eR3OdFpiBRjOQNhmxrWThGFUyJRC+OWxkuA1lU2jW5FL6mKQShg0Hxh6Fsml4jMtzXcLJXlVkff
	BCMOX4y1KxIKJMnzmC+mW20uwmTsrQeeQaQn1iI7PyxFstFOlStOjHsHShtSWpowOHb0hS45dcw
	exraGucLIS2LqhX+hEhAPTwJKPD8LSbHvbvkNNrTdBbnLaa6Dp6WP/yg0DGJPUoNthVm4AOLT0w
	mSjzGh97u1RHUVHNFxzOYLeoimEGoXg6pRB8IMzNXYbyd3rQ9/9yQ9SH1svVKLttuXnkTP+jSC0
	N5dN3fWhcjFgvX3kYs4P2v3y4c9TF8MAyOjoVeTOe+mK4rsEeH8Qs=
X-Google-Smtp-Source: AGHT+IEQeZWmPByyylXZNzf+NLmq2nVg1wHYQ4MC1hNLGIKjNYRHFQ+Ah7ptEv037zVwogh0vWopCcwRiUtQ
X-Received: by 2002:a05:622a:40ca:b0:4f1:be95:5a4c with SMTP id d75a77b69052e-4ffb4a2797amr59348191cf.63.1767854608607;
        Wed, 07 Jan 2026 22:43:28 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-89077179352sm8895496d6.32.2026.01.07.22.43.28
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jan 2026 22:43:28 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2b0531e07e3so2204800eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 22:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1767854607; x=1768459407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RXr5VPevjUOPqn3fRQwqWW7ZEAc2kKpuQcOkyGsfGno=;
        b=X/qFFU1epwDz+O9K6wN8ilUkSsPuGpAF0QNELYXjzcmCMmYJ0BeXEYZcbiN4Rj4YS0
         c6jZoYmOVQEBFm0QMrgRlIlYn/C+RRHxMkqDcwX3lh0LaFEXJFhECxuJl7XhZweBKBU6
         hMNRZGQG+QBXgNIKdLYl4hAvCiuFE08Uo7Wr0=
X-Forwarded-Encrypted: i=1; AJvYcCU2jVdLHWVHUVu6qE7inen6vE2PTSv5D11XM1bMuv2u/MEzaL1SSa71Q90SwFD8xbbrxYG30/x+eMen@vger.kernel.org
X-Received: by 2002:a05:7022:6889:b0:11b:9386:a38b with SMTP id a92af1059eb24-121f8b9cf51mr4645220c88.46.1767854607344;
        Wed, 07 Jan 2026 22:43:27 -0800 (PST)
X-Received: by 2002:a05:7022:6889:b0:11b:9386:a38b with SMTP id a92af1059eb24-121f8b9cf51mr4645201c88.46.1767854606766;
        Wed, 07 Jan 2026 22:43:26 -0800 (PST)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121f243421esm13193731c88.2.2026.01.07.22.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 22:43:26 -0800 (PST)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 1/2 v5.10] scsi: iscsi: Move pool freeing
Date: Wed,  7 Jan 2026 22:22:21 -0800
Message-Id: <20260108062222.670715-2-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260108062222.670715-1-shivani.agarwal@broadcom.com>
References: <20260108062222.670715-1-shivani.agarwal@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit a1f3486b3b095ed2259d7a1fc021a8b6e72a5365 ]

This doesn't fix any bugs, but it makes more sense to free the pool after
we have removed the session. At that time we know nothing is touching any
of the session fields, because all devices have been removed and scans are
stopped.

Link: https://lore.kernel.org/r/20210525181821.7617-19-michael.christie@oracle.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[Shivani: Modified to apply on 5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
---
 drivers/scsi/libiscsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index bad5730bf7ab..59da5cc280a4 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2902,10 +2902,9 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	struct module *owner = cls_session->transport->owner;
 	struct Scsi_Host *shost = session->host;
 
-	iscsi_pool_free(&session->cmdpool);
-
 	iscsi_remove_session(cls_session);
 
+	iscsi_pool_free(&session->cmdpool);
 	kfree(session->password);
 	kfree(session->password_in);
 	kfree(session->username);
-- 
2.43.7

