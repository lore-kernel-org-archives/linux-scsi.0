Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C7BEBF
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660519; cv=none; b=M3Nbr9wKH+P38GxChXci3cb4Ug/1GA3WIEHMcrht8SUB1o0qncXPPxgtl4t3rADQ/dfm9TT5wlDNVKOb0WtFKA+c+SYl8Cju0HF1GqPZ0S1BoR5x5puz2DKFJX8AIrGGRl9rh81Qv+wuPsp6OmxuoIeOVAFdXU9eQQRaDs5Qea0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660519; c=relaxed/simple;
	bh=IAhuP0aGhWisW08xFRWK8KqxsKmD3kZUDLpYtizbU7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MB1/NlINGNqO+F8MW+mPFSHB65uzAZuZo51T3AayqeTwXylINQZ+9+Mzi1IdqsdghqHskXGzpK6ZWu9cqcDRitNGW+jnoWh8LRcSxzwNwSOqQ5gGvpl/LTsPHh53WLpm5fHbDn1jpk3THDzwttUakpGz2BKoXs1sUc7YSsALPCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FRiPpCxq; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FRiPpCxq"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-42a9c3f31e0so4803231cf.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660516; x=1707265316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q18ukcNe8RLqMGrS2HndRD7T0y1FTeIt8zCq4DL37vQ=;
        b=FRiPpCxqOG4zn1AVvY215lQfb+YZrzuIYEEb1n3HBSWmZA9rIYz0h3peB4HtGkyCXe
         j+Qg3kP07UhznofbFcptgPhhrc2OdNM2QAOMmNpxE7RWyR4O2zZRA9F790l1jG25si9u
         ht7DxqT5QbMtjKnqjPd4OaDOB6FR1nwPtZrOVI1d85BNIeymITmouvPcwxVtUnMwPrhI
         M42zXCG+NPJVgGOoLO1wd5CjJ5kBdWv73KnJTQ54j4XZCnnafJuyCTuFk9s9cprY2KQP
         wW4PSuj356dKcopb2x4toatPmJ1rKwFa2w3sCImL1aG5tZGrWxBUXxFOfT3WDGuw7bJV
         z4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660516; x=1707265316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q18ukcNe8RLqMGrS2HndRD7T0y1FTeIt8zCq4DL37vQ=;
        b=Aw85+Eehm+2GDin3pz8WsjkhUdhzvL8lgdWly0ocrQffaZ4I4WeoMBV/c2mW8eiX7T
         fLk25XLUhhRXaNTq9G9wuLoOLu44rRr7vfRjhaz2lSxNAllgkHndwHfOlvAXawRbdw8K
         pWyuDQGxLafq+B/I41Bhv0XP0CzHXuqrA5awjTohX7pzpMl6MdlOEn4rlS5adav97Rnb
         uaqiW1ke/zGdhTPEMpH27j2Olm7UW17bb9RMTR7yy5j4uR++uJ7grnMpd6ZShKBF6krk
         1XcGIX35Sr6hCYvoPeXNdSNC+FkezJsxb0oCKluCdOmsTjCfy4oJaGVqNCiaJNcpGymz
         Y+uA==
X-Gm-Message-State: AOJu0YwquicSsywANuoNJ5rx+F3HE+0drIjSvx5sQawIufHoYXDZApru
	qVyB2TdsCLMGxB3C4H6jAfa5/IWqim0fgfdax3gLGx1GTaQZnWGH4uOpP/le
X-Google-Smtp-Source: AGHT+IErYiZd4NfelRuz9M8ybk6ITYpY23N4w/EkYw2RtuXI0jW4OaKJ6SLohUw6zTyMm0//qd7Wzw==
X-Received: by 2002:a05:6214:508c:b0:68c:5fc9:1e79 with SMTP id kk12-20020a056214508c00b0068c5fc91e79mr151637qvb.4.1706660516430;
        Tue, 30 Jan 2024 16:21:56 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.21.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:21:56 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 09/17] lpfc: Save FPIN frequency statistics upon receipt of peer cgn notifications
Date: Tue, 30 Jan 2024 16:35:41 -0800
Message-Id: <20240131003549.147784-10-justintee8345@gmail.com>
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

