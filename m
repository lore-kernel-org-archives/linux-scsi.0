Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCACE804
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660510; cv=none; b=hc5lD1rumw5VPe03S0tJmvZ9J40wrVjULo9qFoJt0bVs9bLCoUcZV4eV/YGIHJAPrsxSzNjBD3ilqpMiOnhQjidp2j92j6ArYHV56Thqd6F9qI8L5ndWu7cMoaUHElewbRhKqBWvDGjguPcEtKHbGup/GwSfN3PUXSCotY+VNVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660510; c=relaxed/simple;
	bh=TeNAqG9zOciolJJDBN5JSjzR4/ZqXo8umpIExwHTF3Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h52qiL4ahf81FsSzqbV+qpHeK9zRxyVz6+pbBU91zHYTBqff9g7wR5acfkY5939rQLUhqz5MIuPoejUtqQLNvdpW5e1lluXAwVeOV8qPFU/RuFn+1NLnUrrDaWipX+nshJ8CDqHa1YpWk6swoWJ4G4dENsEP14QE6vzjdkMGdj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eah7jMjx; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eah7jMjx"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-68c3de3eabbso6943546d6.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660506; x=1707265306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LSdBHh8SPhtmGDloKd5oE7NACKoA/1fnSWnziyME8nQ=;
        b=eah7jMjx0s8g8LD6DZ4QGZh1jFK4Qxbx3Br3JhCyDPt/nrCV48bDzFFpQHfMi5MdW1
         3Qnw4tgRIx+tXSi+NO5TavmYRz4X3hy1dH4h5/5xS8A/MhB5R9al9POUV9l6i/xZRMrL
         HT21yG2HukZd2xPCmQWjhJ5mZIBaGDlJIrZwSHnth7cF5QoFZttA0ZBrVM+3/FKWFmir
         leiJAK0fuiQH51yT/zJVanhMYDQssn1OND6sYdUb1MNLMXeLZQ3k7GAfxNxywwtsyP4a
         rV6117Q5ziUbBn7fmyslFoZ75zw0TbZfP4uHSEOgopOqbu9D2UZmPTK6Sf9TaEwbjKWW
         DwRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660506; x=1707265306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LSdBHh8SPhtmGDloKd5oE7NACKoA/1fnSWnziyME8nQ=;
        b=bayCZsKG119jgxwmzVISCqVZA6QD7sZQdP0RWu8pp8zrnm/sIsTCeQw5knxh0amqyi
         celkeZdqXStlhZmKpBwbrrAhD6jRo87UccTUhOr6a7uPTKbG6yJCu8RF77ol4SfnyzOX
         glcVKmQUv9lclvBRnBO1qPwcXo6nJUgkS94z2nA97nstAQn6hPvnIof4KMqbbFscFAGg
         Z2UemE2/qdV1PBIOx8SYFXmghVl2P0YC3dHfOiTSvSXFxVV/mIBFH3D94Nu91YRyjAO5
         OJ1qO5KADJoTfMKgCPLrM5bUmiI1pOZLvpViQPi7FtNZ9lQMv4OM9meHeI2jFoYCyJ9q
         YQMg==
X-Gm-Message-State: AOJu0YwvxZrRavvzq1kyDVJJRk0pmWu/ytueJ7td+AgCRA2PPizSBSv3
	5//NBY91uDc2CJNfAunO0AfzWrUjz3UMPkNW/nmn/fSJuBre0Z/WrgQxycXU
X-Google-Smtp-Source: AGHT+IFzNwS/t4wLlH10ipyVUdo8syw/x6wnZMr7R0r7+4LkVBNrApTQc3aU5/U2IhBN6gEdjrEI5Q==
X-Received: by 2002:a05:6214:5090:b0:68c:4a47:d2f0 with SMTP id kk16-20020a056214509000b0068c4a47d2f0mr182033qvb.2.1706660506487;
        Tue, 30 Jan 2024 16:21:46 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.21.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:21:46 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 04/17] lpfc: Remove D_ID swap log message from trace event logger
Date: Tue, 30 Jan 2024 16:35:36 -0800
Message-Id: <20240131003549.147784-5-justintee8345@gmail.com>
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

D_ID swaps are common during cable swaps in a SAN.  Thus, there's no reason
to log the event at a KERN_ERR level with the trace event logger.

Change the log level to KERN_INFO and the normal LOG_ELS flag.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index b147304b01fa..0bc93f346d90 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -434,7 +434,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 		if (nlp_portwwn != 0 &&
 		    nlp_portwwn != wwn_to_u64(sp->portName.u.wwn))
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 					 "0143 PLOGI recv'd from DID: x%x "
 					 "WWPN changed: old %llx new %llx\n",
 					 ndlp->nlp_DID,
-- 
2.38.0

