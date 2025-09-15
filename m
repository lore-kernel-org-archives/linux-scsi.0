Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C58A23814D
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957959; cv=none; b=PWlFFOZjWlUNUmRgS/IHFVajct7lZ5SR7SpuH+5aQc2HiWFfpTGpX1KP9In0AiKQ7Zvb46iTiwv6RLiY27SFMEoIanfAl1PMuXgYXMWMjdY67vyr4Mcc7z3PiagZkK5/Z5VXdv/bBRim8GzDP7NIzZnPjPnc43lqJHMLd38w6cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957959; c=relaxed/simple;
	bh=EsRyw+Og437KADZtopVeod3q3fCHPLV5EZINvOZY5u4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uhGtXdK1PyPWI3if49GYPRkE/VPQmIzw+qEJfR2HNLPnc5zLC90TRMHcBSGvWdvatt5M5nqmS3wxhHssxlIbthI7GyOXUjX2zguwNfoR+VX39TVQiFDOSFoNKwBRvgVpBLmBP5sKcbktRg/U9LkyMYSQ4qg42Tc93cCyCxfo9Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WgyovQvZ; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WgyovQvZ"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-77766aae080so17775126d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957955; x=1758562755; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDhJATdMvwXBHUgpKYn792LwvYpkDerYJ5soIU5FRr4=;
        b=WgyovQvZdG3QpUnapa+KSdWR+hI9CdmCe4c0lTZPfCB+H5Cq2uHAGZMP6/yf+cNLjT
         Wvjbd1a7TZPd0sn01NipcHxSxpjPXECqCFPnXnspdZft0uAcQSoZM2ceBSRJdt622eel
         KD+yHUtNzHsGd3GU2IfSlumnapK7fWAOsE17J91s6jp+NsOzBhsMrGXXMzRgWqg7bEXJ
         fCVIwFwf+inMgM/SIeOD1TjcPIgCBqLKIfoUwwngNiIlWLCYrenZddNkqeyNeXbOcFDR
         o5G/flz/MzguoaVLcx7KnloDzIcqfvi20uWOZzLeBg4xtv1Tij9d8q8+d47bJJYTKklY
         JFxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957955; x=1758562755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vDhJATdMvwXBHUgpKYn792LwvYpkDerYJ5soIU5FRr4=;
        b=IEvi7i173/UXbnZBSs9WLkHVXc+b6ORi0pRsczAEUv1kQQ24IBsXXC9vaiyMvsJbbx
         sJdfreeKvRHkhA00rUuaQSVvbd7368XO2qfg7QYPuWkwTFpUHcPEHSSAoW1xYgHt6w6c
         HDKA1HXggeKrpd6vNfGS0N9fnqsrH0F5oYVUWISCUvId+NUDTkP6Oo9x3gEB5BAHmh68
         Usbj8DBIOS4e49PkogkfhoqI0boP7+PDtHD1LPRF9qd3d8Sbn2uzHOs7CSWw+BzQG4oE
         9DTTf2EpSYET/9418fhcL3YIR5pYDzsYSm1cMp2pI+3+bnAvL/4vDGNou+fsG7YZ1pUe
         BmBA==
X-Gm-Message-State: AOJu0YyfuEciSS67SwXP03ODlHJIVyWOHFp/x5cOZR7xkBVYPKccndu4
	Yy30DVGFzMHvtwVi15iEj8SgFBz0F0lEAPUsxSZ0DNQXXIfpxTIH+A7NiHqS1w==
X-Gm-Gg: ASbGncsJAJssXxr2Iw6OTwkA1Wp4E86lybyvkBQcpXUZmwx0ykL31bri5yPJ9xkuEG2
	m8F7dV1F4nkaLrZd6FYLANkxOTBYG5guMnhskUwMHXHCGCPpbmC1hv7vzUKaQWpymyK17ZY57S0
	wWTOuVMK175FpMBdd9XOZTFgBKwIxW9jR9ewl96tlUep4qdGM7kKIfH+QAbXjRNuacxjusWN8bj
	cvoWkLDJYCf+DtgI2QHG5dlK0UBGZZJ5jxs9KBLDNsmy16BWpaM54BIWh+1suCU5lcDU30fLl6K
	4q9Gblhf8AZBRylUlh3kX6fcHTb9y4nFVYZhBFAMfapVpld2Huw5NR+pAtfYWB1SI3LypAcsiIk
	hjySbxu21sAeplqpGVOqPBocgvlywmGyuiWQGobNA7OX3VtB5ioDERpzv8s0GGqh8CkwLogB+do
	wvH6cGsPHyEwWlrog/oIXjaHnKMnbu
X-Google-Smtp-Source: AGHT+IE0WzWcpGTsC+MlbVhshPQzRIUveGjK7fmJIAqDsUM8yW5SL8F9KjkHDAjjQd9GFKBechNu6A==
X-Received: by 2002:a05:6214:27c7:b0:70d:deb1:4bf1 with SMTP id 6a1803df08f44-7621f7211d3mr246065016d6.15.1757957954755;
        Mon, 15 Sep 2025 10:39:14 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:14 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 03/14] lpfc: Clean up allocated queues when queue setup mbox commands fail
Date: Mon, 15 Sep 2025 11:08:00 -0700
Message-Id: <20250915180811.137530-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250915180811.137530-1-justintee8345@gmail.com>
References: <20250915180811.137530-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

lpfc_sli4_queue_setup() does not allocate memory and is used for submitting
CREATE_QUEUE mailbox commands.  Thus, if such mailbox commands fail we
should clean up by also freeing the memory allocated for the queues with
lpfc_sli4_queue_destroy().  Change the intended clean up label for the
lpfc_sli4_queue_setup() error case to out_destroy_queue.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f84dca848bf0..e1f5310f6353 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8820,7 +8820,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	if (unlikely(rc)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"0381 Error %d during queue setup.\n", rc);
-		goto out_stop_timers;
+		goto out_destroy_queue;
 	}
 	/* Initialize the driver internal SLI layer lists. */
 	lpfc_sli4_setup(phba);
@@ -9103,7 +9103,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	lpfc_free_iocb_list(phba);
 out_destroy_queue:
 	lpfc_sli4_queue_destroy(phba);
-out_stop_timers:
 	lpfc_stop_hba_timers(phba);
 out_free_mbox:
 	mempool_free(mboxq, phba->mbox_mem_pool);
-- 
2.38.0

