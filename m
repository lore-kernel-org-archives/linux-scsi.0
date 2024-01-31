Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5297804
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660517; cv=none; b=lApww/wzPg9gad2SKi/FWMyZ93z9qUQf72kDdhgsWW1uYlSu/m2fy6SZfrk4NoLdD3kdDfjxMbnaU67dyViU9XxNZvNwe8MOBquWUe4SIpaYq0ytrf/ReHSbSSqsix6CYz2YtIimiXT9T2w9Za21fdhlykG5rtyjZadIezN8aAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660517; c=relaxed/simple;
	bh=ZyEG7dNV7noeSjibWL/PNqSsqcqEK+UhCQ/4lRvsttE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EGDJcYyd+e8EVcS1El3P9VJM3r+RcPu3by6WUdvj5lP7MkuEAGBTmkIT/HUblKo53zHjhU9OwCrRvIkoHD4hnVUMOfPAsx/YRZeHE9PbWUCf8O7P/8PP7pf/sbJChFDiT9zFP0VPrmSSswKKERu1oQeLRN6VELnwcOwtSUecEH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DkNu3F5t; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DkNu3F5t"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-46caa53a65eso41262137.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660514; x=1707265314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WPXnMQ35OYwNhWGkqopxVNUcuap0FITt0rduOYfQkIw=;
        b=DkNu3F5twhb6JbwKXZcIhPbYkVOnTb3QvNVbySLP63Pipxh2jmBn880gphFc+poorR
         Z7f3+7XEF8DD20o9E/ZeEKr5/p3wPJ2HelCBjsOVx0NN5Zg7WJ+D63G40CsnNKs/PQQR
         +A4ja0gRQ7a81LKb2jIjgZJ2ShvXVNBIssoAoTM08A3qYb8KbUJUJERcHYQhXDXxh+xF
         Q6OetvTof9IzitxpMLI7AKM8s2lRzTccP11q9AHHVWqC+f+wapCpqu06l/iuccKEpKSY
         ZQ1M1WxVDSjrxrV9bFL6goZgqVi0RsvFYbbZd2WxE0QGz2CeOfrUyOvjoLjaz5s1ThQg
         FWmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660514; x=1707265314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WPXnMQ35OYwNhWGkqopxVNUcuap0FITt0rduOYfQkIw=;
        b=Vldf8GnDt/Mh0pGW3kUHQUuH333McplBWMZmaQV1hWC0+kEHOOv5QJ5q7p5HAlHGBu
         JlC2nYXuFUOdv+tCeZtmlnsbI0FElCPV++PC160iO80vgwEIQ92xMIpxBYOIsJ3nEz0y
         iJ7sJfjvm7tapRXMMFA0oqwsvhqiYtYCotR5vVFxInCqpPkulgTbSeGOjney4VaSNIzC
         YPKLTOAraAP/1kc4bZwr3EAEHI8osPsxAZd3xGMwvA8Vv7l9VObmJrGS0ZVDzBh/nH7B
         QTIHa57lh9Djq1MtXFXOO14LVy41QVWJYyqmzs5QJHzNSJPLV0zo8OJSELpH/g1rd+Ph
         /BVQ==
X-Gm-Message-State: AOJu0Yw1qDDM7DHXO1sTIo3x1oE9rG7zxQUSIS7i/nNM799xtAcYHnTt
	rDXhy+KftUryv10lR0hHJP+uxGBTeR4UQcsY5jsPjYn8S2HsDYor5RXxtUVf
X-Google-Smtp-Source: AGHT+IGJywCwthZe/fwgF7iRXrkkaO4GlIT31OLdowqb8tV6IGt+oKNNJ9li0o2p/Eqxjeagbdpebg==
X-Received: by 2002:a05:6122:4492:b0:4b7:53d0:846b with SMTP id cz18-20020a056122449200b004b753d0846bmr111735vkb.0.1706660514668;
        Tue, 30 Jan 2024 16:21:54 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.21.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:21:54 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 08/17] lpfc: Add condition to delete ndlp object after sending BLS_RJT to an ABTS
Date: Tue, 30 Jan 2024 16:35:40 -0800
Message-Id: <20240131003549.147784-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131003549.147784-1-justintee8345@gmail.com>
References: <20240131003549.147784-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The "Nodelist not empty" log message and an accompanying delay may be
observed when deleting an NPIV port or unloading the lpfc driver.  This
can occur due to receipt of an ABTS for which there is no corresponding
login context or ndlp allocated.  In such cases, the driver allocates a new
ndlp object to send a BLS_RJT after which the ndlp object unintentionally
remains in the NLP_STE_UNUSED_NODE state forever.

Add a check to conditionally remove ndlp's initial reference count when
queuing a BLS response.  If the initial reference is removed, then set
the NLP_DROPPED flag to notify other code paths.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c7a2f565e2c2..29fd2eda70d5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -18933,7 +18933,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 					 "oxid:x%x SID:x%x\n", oxid, sid);
 			return;
 		}
-		/* Put ndlp onto pport node list */
+		/* Put ndlp onto vport node list */
 		lpfc_enqueue_node(vport, ndlp);
 	}
 
@@ -18953,7 +18953,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 		return;
 	}
 
-	ctiocb->vport = phba->pport;
+	ctiocb->vport = vport;
 	ctiocb->cmd_cmpl = lpfc_sli4_seq_abort_rsp_cmpl;
 	ctiocb->sli4_lxritag = NO_XRI;
 	ctiocb->sli4_xritag = NO_XRI;
@@ -19040,6 +19040,16 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 		ctiocb->ndlp = NULL;
 		lpfc_sli_release_iocbq(phba, ctiocb);
 	}
+
+	/* if only usage of this nodelist is BLS response, release initial ref
+	 * to free ndlp when transmit completes
+	 */
+	if (ndlp->nlp_state == NLP_STE_UNUSED_NODE &&
+	    !(ndlp->nlp_flag & NLP_DROPPED) &&
+	    !(ndlp->fc4_xpt_flags & (NVME_XPT_REGD | SCSI_XPT_REGD))) {
+		ndlp->nlp_flag |= NLP_DROPPED;
+		lpfc_nlp_put(ndlp);
+	}
 }
 
 /**
-- 
2.38.0

