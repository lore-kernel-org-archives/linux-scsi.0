Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9392134F
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726249; cv=none; b=dtT51uSDiyJbD2xPlaGr2P3WZKNN/rXEZA0FdGq3GKexBUeI2qkEO+M4kjxJmFl0mrbVfc6X0FOYQLjDym5TLc50KAPJXXUHtZOXjecjMpI8L6QFscWzl4g9D4l1VZBIRAVLXMLZoBooUY5+qkoOY6WIWDuLacnTfCv5ZT/LBzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726249; c=relaxed/simple;
	bh=27ez7l46OQ5EDPuSrVLB/podSPCjXJKMhlYt1vMOryc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ui6Pf6Pze7xSVgQciDjEKu/JDo2loTx+b3CUpZ8CvrnMefqUzS7JXeGHIIMzSJv+m0m8unzg0wsxF4y3JH1mkTIzZgyZg1ON47IZRL6igbjVmzh62jkHj3MPVXF+UeEJ+htV2lm2KLb7TlSSE0iFcf70fw2IXcU5FhLcab+mtT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B4+XBn7z; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B4+XBn7z"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-68155fca099so205376d6.1
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726247; x=1707331047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5YkMNKhf89ZQKnipc+gTJjo6GDA+oFnGwlqZm3Y8nZ4=;
        b=B4+XBn7zg8sB9AzCF6oZe9O7VFmwK7k7IZ6K+Zleaua5u8EhbSvJLGk5whKv/5PK0d
         yQUtmJT+W37a2Sg2UJl6smjvakRFEV5NU61BPo6FGpr+8HrJR3gqNRuX6ADb6Ggcuo7J
         TjPGWPyWZeBy43qaHJr8rNFVBp3COKMwUDyRdn52JjICyCbLUEXMM4HGz3+W0EOueElw
         KF0LQwljZ9zXJCU3uhiCm4IyHS7x+IYsN5KW6dt8vK2k8aZdz5WYLzVFlArL1wRlTE+4
         gDjvb3INRitebwY3mXt0uwrIZBLfpcdbutKGCKPWaoZBwGwYZBHzGxBIou1kYCvzJu/u
         rx/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726247; x=1707331047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5YkMNKhf89ZQKnipc+gTJjo6GDA+oFnGwlqZm3Y8nZ4=;
        b=fhCAFJD0JLZVmXBVOSAkmKnJ74DrTGl31FJTGzjyiKwvKUkPYWZ/8NUbM29G5lt51H
         +w8aY0GD2f3GgM81bndNF0R9IMS3+xmJO0+h20qoBdP52hFJ1CfJDgOgvmyJhRbMqCfO
         tOI2kZyzFmQSbajDfKd3akryCw8hdbKQMpn3zg2QBvBiB7OZsPo08mRUxVocjafDXDyZ
         WMOw8nzCvVrQn2xauzKU9464SOtA7oBwKba+lcjgfgyAFvqZesAQ6XIGMeDK1aLG2gxV
         M5ycZnuVNavNDD1ICO+n2iJ9kONfrreKRUMaSRnWz/FzIqZ0G+ds2n+kUyDFBXU7/j37
         +Dlg==
X-Gm-Message-State: AOJu0YwM0jKjK7nMSm2JVd8038erjzAfCeDjTpeXyg6zANsWDPsl9sQb
	trbpxPY7wIFxCiXRmdC27IV6NiQXZ3QLbOcuOnl1FAZvKzNIKiwlsiFudIFa
X-Google-Smtp-Source: AGHT+IH3gCpztv9zVubRrRSS4Wv35TBo1B9pR7HGYMDPkb284c5M39Rubd2Jnkr7uqrUjbGxdsOSRg==
X-Received: by 2002:ad4:5495:0:b0:685:6147:3607 with SMTP id pv21-20020ad45495000000b0068561473607mr212798qvb.2.1706726246775;
        Wed, 31 Jan 2024 10:37:26 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:26 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 06/17] lpfc: Remove NLP_RCV_PLOGI early return during RSCN processing for ndlps
Date: Wed, 31 Jan 2024 10:51:01 -0800
Message-Id: <20240131185112.149731-7-justintee8345@gmail.com>
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

Upon first RSCN receipt of a target server's remote port that is
initially acting as an initiator function, the driver marks the
ndlp->nlp_type as an initiator role.  Then later, when processing an RSCN
for a target function role switch, that ndlp remote port is permanently
stuck as an initiator role and can never transition to be discovered as an
updated target role function.

Remove the NLP_RCV_PLOGI early return if statement clause so that the
NLP_NPR_2B_DISC flag gets set.  This allows for role change detections.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f80bbc315f4c..35ea67431239 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5774,14 +5774,6 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			if (vport->phba->nvmet_support)
 				return ndlp;
 
-			/* If we've already received a PLOGI from this NPort
-			 * we don't need to try to discover it again.
-			 */
-			if (ndlp->nlp_flag & NLP_RCV_PLOGI &&
-			    !(ndlp->nlp_type &
-			     (NLP_FCP_TARGET | NLP_NVME_TARGET)))
-				return NULL;
-
 			if (ndlp->nlp_state > NLP_STE_UNUSED_NODE &&
 			    ndlp->nlp_state < NLP_STE_PRLI_ISSUE) {
 				lpfc_disc_state_machine(vport, ndlp, NULL,
-- 
2.38.0

