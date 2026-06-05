Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89DD39935D
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 17:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780681516; cv=none; b=JotksxsVzTyKBliEi/nr/ba4q9dNMakoz35Fv/h7IslVJFgLqNeIWYqr5bVt6ZE5BIEZEwdxFqXDrxGSTqyc01jRnJK3YkHFKFDaXKySRDUAOU9GtZWEmtuW/ErwJLy9unb4Fn2DFbsANW00BzGvUKO/uDm4Do3s9Y5hdnMcaqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780681516; c=relaxed/simple;
	bh=LCrHk0mXmBoxqijlXX61kg8RAalLQLRHE4JPG4lfKDw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q2/xfMQ3FHup685wCtRnCFdB+21DBmgaFS4D1ebmMPAC/80tiLiuHPlZGvfZ7F60W9JHuGDZfvBRr2tE+HiQw9pYgjp/0C0pWhxry2V/Ax1QjPnGI1B5cnhpk6k0i3Zmx6Ht00I5onrCyFVHcgdhM466QapyU2wZe42ozVB0pOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sK8mXE/Z; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sK8mXE/Z"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5177b1a7441so31574981cf.3
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 10:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681509; x=1781286309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ad6xz+bi/Z+3fCS3JOxccp7lrZfKAVizkwzbCWI1elc=;
        b=sK8mXE/ZKq41yDVWL9RkU2pGPDzOH4Rbusj9cIIHz7t+IQ/SrnAugthF8X+5j3xDzf
         vWh+xBgBHCsaftO1xfh17bz16B1GN/lIdUWWqw9mLe1I1dw1nrL0BoFWVp0PRyHBS9ov
         gOBH8vd+BecIabXE/meDKoYPhtEnSUxTGga1fRsMk1nskYQqQxVRZbajjKjfVg1E0HY6
         4IghGWeFjR0x9pvtNG91kOWxik6U7e3N8LK7YknO+blCv4evNHGb2SM2W2LtMI8FS1dr
         LnjY/x5KG9yi2BvSEnPMH4BgEtmButGKoGcHtnQXs0zxM4nPWQLpGg64hPkPH5Ihwuin
         fT5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681509; x=1781286309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ad6xz+bi/Z+3fCS3JOxccp7lrZfKAVizkwzbCWI1elc=;
        b=KlXMSja5teLIV56TNO/RiJ9CCnVP3Iv0+MtPPixZ21cpV9GBVgfXTBW7BD27APNeh5
         K8qto+FLhyZF3NiST2y+DSejijE8JkCn7TJhlPGmvIHzmXYj9MY/Vu/2dLfJSW0sNfhI
         vZ+iAmcCfpKe+D1W6W6QgS+JC8PauiGNBjDwiuf6DoQyXV4+AYlry/uo5WVB/lH4uBK0
         Ae7dLrSb7YsRGh+BtO5xiZdhWRFEN6W0nveQWpbW3pkHtv9eDfWMRXef4TrBsN9K5NYJ
         iNNCCK+2BhzP2GRfefeZhMLGaU9QKWulV0RSRcBRr7HaPoXgD0mtR+zwNVztnJWtsoTq
         3K8A==
X-Gm-Message-State: AOJu0YyY9VD2ugYr8HMFb4Z4M3y8EXcePamfAXHMUTydER4iZ7RtKrNj
	4meiic+h4ZgsRJrp8MTA9Q4hPaLJio+6nYc9A2K095qqGW19N4/t1BGur6gS3YOY
X-Gm-Gg: Acq92OHtCrbEVy5IIUTNuX0+Ln4DSvvBJTGiWa43+fZpYBIDhgEduzguygkrqbKvDXK
	LRJv6QwGI9o9L2X7m3IbGTih4qNDxYOYgHFb4uzwzufm/brBo451TE+osWqZYdPLupUwy4rE2Fi
	SSNYDwT+YxFXPSigBD3qhdLBAkFbC21arlvWEFtCk5ieAvNuNR/9rBLDXHtHZT8IuMZ1J8DyNhC
	If0esEq40lJJX0yHM9X5Ml71cqxMVhbd7AKlWjSOqVol1yWQ0M5wdHRUOTdCJOeHFYmsdteSkfY
	xnitSY7NJOcmRPNbC1owDshWAyI84lGWYSS7FN+D4UQ4eYmOjpTEwxPXhnhUpYxhPG2YVZD0jWl
	lRmwi5au7H5ZtezpeIMnBtG+ssx+paoTJJNOFJYEzb5DGY/HyGedTw1l6rZ94drAgcvVHLlp4ME
	ot5mws3e5rpju94XF9yk9XWIJKqfwU5NheT1s9p37OJHMXSMu/alIkVBwpVBAqiQ+G9+ZbvUbdB
	u9K/4X0/Wi73ddA1piXm5OoeRuVtAkW4b270+YsIpDXqJ3EmqBSGQ==
X-Received: by 2002:a05:622a:400c:b0:517:7971:a234 with SMTP id d75a77b69052e-51795b729ffmr69681091cf.4.1780681508604;
        Fri, 05 Jun 2026 10:45:08 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51789407da8sm53376171cf.19.2026.06.05.10.45.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:45:08 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 10/14] lpfc: Remove slowpath cqe process limiter in slow ring event handler
Date: Fri,  5 Jun 2026 11:23:32 -0700
Message-Id: <20260605182336.134919-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260605182336.134919-1-justintee8345@gmail.com>
References: <20260605182336.134919-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a cqe process limit of 64 cqes in
lpfc_sli_handle_slow_ring_event_s4.  The HBA_SP_QUEUE_EVT flag is not set
nor the worker thread rescheduled when reaching this 64 limit.  This means
a burst of over 64 cqes can incur a delayed processing penalty, which can
be problematic in large SAN configurations waiting for rediscovery after a
link perturbation.

Remove the slowpath cqe process limiter in
lpfc_sli_handle_slow_ring_event_s4 to ensure the slow path CQ is drained.
Add log messages to notify when the 64 cqe count is reached.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 31ab72cbee95..5c559cec9f55 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4527,7 +4527,7 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
 	struct hbq_dmabuf *dmabuf;
 	struct lpfc_cq_event *cq_event;
 	unsigned long iflag;
-	int count = 0;
+	u32 count = 0;
 
 	clear_bit(HBA_SP_QUEUE_EVT, &phba->hba_flag);
 	while (!list_empty(&phba->sli4_hba.sp_queue_event)) {
@@ -4547,22 +4547,39 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
 			if (irspiocbq)
 				lpfc_sli_sp_handle_rspiocb(phba, pring,
 							   irspiocbq);
-			count++;
 			break;
 		case CQE_CODE_RECEIVE:
 		case CQE_CODE_RECEIVE_V1:
 			dmabuf = container_of(cq_event, struct hbq_dmabuf,
 					      cq_event);
 			lpfc_sli4_handle_received_buffer(phba, dmabuf);
-			count++;
 			break;
 		default:
+			lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+					"7771 Unknown WCQE completion code "
+					"x%x, ignoring.\n",
+					bf_get(lpfc_wcqe_c_code,
+					       &cq_event->cqe.wcqe_cmpl));
 			break;
 		}
 
-		/* Limit the number of events to 64 to avoid soft lockups */
-		if (count == 64)
-			break;
+		/* This loop runs until the ELS/CT CQ is empty.  Post a one
+		 * time message for debug support when ELS WQ ecount
+		 * completions are processed - this represent 1 full ELS WQ
+		 * wrap.
+		 */
+		if (++count == LPFC_WQE_DEF_COUNT) {
+			lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+					"7772 %s SP CQE count %d\n",
+					__func__, count);
+		}
+	}
+
+	/* Log a final message to note how many CQEs were processed. */
+	if (count > LPFC_WQE_DEF_COUNT) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+				"7773 %s SP CQEs complete, count %d\n",
+				__func__, count);
 	}
 }
 
-- 
2.38.0

