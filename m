Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W+wt2yFF"
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A901719
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 14:28:31 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1d05a2307a5so3294485ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Dec 2023 14:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701988111; x=1702592911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ar+ZXQ+8YnibjC1pFJIGEM53vtjFbaySsHHcyc6kyXw=;
        b=W+wt2yFFUhP150Zx2uzqEZnQpSbeCVQS8Po+9ipJAPCXyI70W98eFbo5N6lofF6MjE
         o84Qk3JvBFOfqvzGv3Hwhqz9BRGfsFmLumg/uHG9hnI2tr7W5uAK2rUmdTEaNubwH+9B
         HfFIlyJuMVw+2YJSrxSpABQk4suOhNzhCC17HCHG5I7MA4tcDXBoeuo/vzCMooYE0ToC
         ZTlw4i47vHh2lzW0dSH0YMp23QtuROi1Qh4NC3bzOE5A9tDvaMkvve4wIVNRjJ2rc1j1
         U9MxfWVwBNJITZqzP6uhuNszDWNbTD1IbaC1YELN+HczPQ3DYgng2V5Q9nRUDnxUUTED
         mOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701988111; x=1702592911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ar+ZXQ+8YnibjC1pFJIGEM53vtjFbaySsHHcyc6kyXw=;
        b=meb+c1nyExih+5zJnW0p9GcZH3PzXo7A6+HXQaLxuVytfcI5uMThqRjqpgw8aaqCP4
         BCHRxLiF/ic8vhY+KIAKVN8HT0dV1FM/3SEg3P08ihpkaXdK1N3YFY4Q8D1owXXDJ+ps
         k5S38hFoRV4jf9GGIlp2M48u3pGKs9a7A2THijaJIQzaduF745aFhDxhSRYyg5KKaUKa
         46v9cWCLhDhbXv2q1G8dxt3hr4DL25hBt0JwZwqZZReBzWvGvROTft3H/7vCaec70fvD
         vFeT7DvUCcz6P7ABLr4eN3AaS0LZZcnlSJgLnZSuphp/fCV65m05kh1Z+HHOluvaLUVz
         hJwg==
X-Gm-Message-State: AOJu0YzZzdaYIrHlRRde6kvWC5qdJ4FOdtg9DbkVelub4+seAbE1oMhq
	qIzBQOea1zEZIK5mGhv+2K8he5ffHFIRZw==
X-Google-Smtp-Source: AGHT+IFHdIcuehkc5QQ50+x80dSDPAPTNuIpjpFR1OJzaaOwIdD/Y2HhD0tMNMAnbTSKQBS1ssSeeg==
X-Received: by 2002:a17:902:e80f:b0:1d0:c128:1ef2 with SMTP id u15-20020a170902e80f00b001d0c1281ef2mr6516644plg.3.1701988110802;
        Thu, 07 Dec 2023 14:28:30 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j18-20020a170902c3d200b001cc3a6813f8sm312417plj.154.2023.12.07.14.28.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Dec 2023 14:28:30 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 2/4] lpfc: Reinitialize an NPIV's VMID data structures after FDISC
Date: Thu,  7 Dec 2023 14:40:37 -0800
Message-Id: <20231207224039.35466-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231207224039.35466-1-justintee8345@gmail.com>
References: <20231207224039.35466-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After a follow up FDISC cmpl, an NPIV's VMID data structures are not
updated.

Fix by calling lpfc_reinit_vmid and copying the physical port's vmid_flag
to the NPIV's vmid_flag in the NPIV registration cmpl code path.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f04326db8c19..3b7ed8bca01a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11143,6 +11143,14 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	lpfc_nlp_put(ndlp);
 
 	mempool_free(pmb, phba->mbox_mem_pool);
+
+	/* reinitialize the VMID datastructure before returning.
+	 * this is specifically for vport
+	 */
+	if (lpfc_is_vmid_enabled(phba))
+		lpfc_reinit_vmid(vport);
+	vport->vmid_flag = vport->phba->pport->vmid_flag;
+
 	return;
 }
 
-- 
2.38.0

