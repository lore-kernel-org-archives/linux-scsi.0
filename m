Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B681C2DCF
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 23:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726182605; cv=none; b=TAtLV5sKeY972iS0IOFy4WtEg0BpNurgJB0TY4MwhIYnNeHkGNzUS2QLIA8fq1TJU23/ELxyzVU51HHkWDW0z7pwTPIFqiaAUgRiWL1lR66nnXC6DB2Ph2VhUTa3BmjJHbTuyoWqfYLSgZ0lA3auXqK2gFjof1xFgmk+QoN4Er8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726182605; c=relaxed/simple;
	bh=6Ooz5ZnOE4Zgy3EOkwwYN8TYdvq4lKh26mkmpyeNHrw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DCCJoyjJHWeqdCnB3Q4rylJVCggrA1/NYls9JMtDeQkgXXsQqDdCmmF/hQKGyOSdO0/l2v5KqDmCRaFd03QqDmK6CuK0vHYc9qR3GrgW7b4SyXGjRCunyfMl8tHY8e5g+sFnFJhP2vI+m/aw1TTZilAbiuluBRaK620IrcvGT5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DanfSIJq; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DanfSIJq"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6c35b545b41so23402756d6.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 16:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726182603; x=1726787403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kaYbicTWQW1jLKelXt5LSFWDCPSznt6D0PyW+bVvXBM=;
        b=DanfSIJqHdbMviIxbrFipH0f43mzqkXNtMuWVi+aMMXa++e6J4cXIyveWecQCoYglr
         eGoMg/XAPjd/3pGCHsCXtv8hKVH4jzpBrzIpXodOYFyM96QoPemaEBqP6hMQkQgQqY15
         4zxi3XzK+XE3gYoyPtiMXwPviln7vj8qqVsFefRQHcnw/EBAhp8VPfBxIfyDCawQnU+j
         7x88jUeImMS1L784/9roBpXb2VfL/KHC2Gr+a8TAV4KyDLa9YPQBCRBHVSQjVwK/pQVX
         MR4g0svbTO00EYwf+BUprchB+U+CoCC1lyJhG8khEZWXYmbV/0sILsAEGXKR4NxHkRXg
         tAFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726182603; x=1726787403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kaYbicTWQW1jLKelXt5LSFWDCPSznt6D0PyW+bVvXBM=;
        b=Z8Re85K3clKfTlD5jMb6v0lhcINmSw9V2qUDI4icnc/lBfsG59BxQThyhchzSIaHZR
         +bBPTFabk7AMQ8KcEFt89SMxF12/CHeq86+nmHvDTr5KvSVXKSMsRrUnDYXCc2Edhg3p
         J4hmIY/oZfOqUzxp+DEUtqKDSODoN5TGXLwBflPRsrf1lOfv6KLNjrzDxRleZlKjDUgR
         pMahmtHs6n5uO0d67tkBvuG1efCfbjKvfOGPs9SfQYXrSkRfw1Y9MVgaDJ4wyhglPkym
         Ys6DieHqRc7JUeawVXqbXAUvjI7+m7AHKBlAwR1aogCIcZolRps2WzQxbVhtUgCLQ7qw
         72yg==
X-Gm-Message-State: AOJu0YznlQSynBWsAP+/IGD65EXP9usX8X814khsNVuIKGiSNvpmK2LX
	TcAHOfsVmHgs0jpC3Hb3gzjBq7apwXeNGCdo7y1UfJJQUtgGAiyeXxadPg==
X-Google-Smtp-Source: AGHT+IHX3skUETbOlMiOKiTSiDSdvx9zoi6YKvWKcuu9NDEwrfkypXSfv6XzEY/TcN+A54BYAX/hQw==
X-Received: by 2002:a05:6214:5b86:b0:6c5:5256:62f0 with SMTP id 6a1803df08f44-6c573b812c7mr67130176d6.26.1726182602841;
        Thu, 12 Sep 2024 16:10:02 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c534339a88sm59363136d6.50.2024.09.12.16.10.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2024 16:10:02 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 4/8] lpfc: Fix kref imbalance on fabric ndlps from dev_loss_tmo handler
Date: Thu, 12 Sep 2024 16:24:43 -0700
Message-Id: <20240912232447.45607-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240912232447.45607-1-justintee8345@gmail.com>
References: <20240912232447.45607-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With a FLOGI outstanding and loss of physical link connection to the
fabric for the duration of dev_loss_tmo, there is a fabric ndlp kref
imbalance that decrements the kref and sets the NLP_IN_RECOV_POST_DEV_LOSS
flag at the same time.

The issue is that when the FLOGI completion routine executes, the fabric
ndlp could already be freed because of the final kref put from the
dev_loss_tmo handler.  Fix by early returning before the ndlp kref put if
the ndlp is deemed a candidate for NLP_IN_RECOV_POST_DEV_LOSS in the FLOGI
completion routine.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 35c9181c6608..9241075f72fa 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -527,6 +527,9 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 		 * the following lpfc_nlp_put is necessary after fabric node is
 		 * recovered.
 		 */
+		spin_lock_irqsave(&ndlp->lock, iflags);
+		ndlp->nlp_flag &= ~NLP_IN_DEV_LOSS;
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
 		if (recovering) {
 			lpfc_printf_vlog(vport, KERN_INFO,
 					 LOG_DISCOVERY | LOG_NODE,
@@ -539,6 +542,7 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 			spin_lock_irqsave(&ndlp->lock, iflags);
 			ndlp->save_flags |= NLP_IN_RECOV_POST_DEV_LOSS;
 			spin_unlock_irqrestore(&ndlp->lock, iflags);
+			return fcf_inuse;
 		} else if (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) {
 			/* Fabric node fully recovered before this dev_loss_tmo
 			 * queue work is processed.  Thus, ignore the
@@ -552,15 +556,9 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 					 ndlp->nlp_DID, kref_read(&ndlp->kref),
 					 ndlp, ndlp->nlp_flag,
 					 vport->port_state);
-			spin_lock_irqsave(&ndlp->lock, iflags);
-			ndlp->nlp_flag &= ~NLP_IN_DEV_LOSS;
-			spin_unlock_irqrestore(&ndlp->lock, iflags);
 			return fcf_inuse;
 		}
 
-		spin_lock_irqsave(&ndlp->lock, iflags);
-		ndlp->nlp_flag &= ~NLP_IN_DEV_LOSS;
-		spin_unlock_irqrestore(&ndlp->lock, iflags);
 		lpfc_nlp_put(ndlp);
 		return fcf_inuse;
 	}
-- 
2.38.0

