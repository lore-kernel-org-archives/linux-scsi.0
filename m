Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F111CC888
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 22:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412933; cv=none; b=Sa3yyStd0aYYjojtuE1G0TodBQBdYz2sbleeX+eRrCti+xdv8+Ag9nDKeqeziw3SuZOXjoF0ZvLMK187GOwgsJCyA0Bgbb02SJhjj9QBR53WiwmKx/hlIK4tyo3DvMqWgwipfGmnAWYfu9ybikFZzPd6vdNI1pG504QMljA9Ln0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412933; c=relaxed/simple;
	bh=pGv4Mff/tVdvWjwpUHYBqHZk4AN/FnSiJICeHVhAWX0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q8HzBZeptb40Eg1K5Bo60COPHxoTUPgnnSln2JH38OBgeqITzFNbPMcsr2NKQ7OrqbJc9i4hjCXmhZzPxBVeFhmfyxN2mtfrcHtWN4+68Jf/C9j8294CDOqpND16+G+MdLmEw0kwSHFsFv2JlsnQM8+VVWsIpvvLB0Vz5+q7v1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WuCdJfya; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WuCdJfya"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2e91403950dso1059718a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730412927; x=1731017727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7414LaWmD8//owksRQA6K9GgZonI0m69/c6El6MaY8E=;
        b=WuCdJfyaa1ogANDG3cKE0Hg+KX92mBIyas9ocC5n2Kay5Y6SUQ3L7cQg93qA1PqbOW
         pLxrrPy1BNYK/lAc0cm0R2Mh5MEOdfW9Mh0G8uVWBXuSrTmsUYnoUz+fWZPs9wsvp0V8
         Knz7Nj/Y8sG3zCSzBhis4GUUEvU6eTJSo6J8e0FZBptfFSUkR4JPtKsRZnHI+PW4YKIg
         UFimwGlTQfHSUAm8D+hO7opqRpcOYSKs+oMJbB9yF7F8WpUuR57Yrfnnd/38LtKkk4i3
         SqN6YjFv9oK8fsulEcho/R1ihcL29pGHxirlpEnX0qWb7+xcnfPCCNuwXK8JeBiDenYI
         gvXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730412927; x=1731017727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7414LaWmD8//owksRQA6K9GgZonI0m69/c6El6MaY8E=;
        b=EZzewu/6lvicy/vn24yTCrWMyHSbwV5Ug1FeRa1mM3JooPCjJdY58TOwHRfXC1cEnM
         qo+tRzbtcEkY9kk53FLdUotomzm39K+Uqrgnhqd5fszpjq5PD79qf28lHKroLbbgyOXB
         6nunMx1CCwDQdYz1kWnYykk2z4MBHp5fsCpRvijC2t0crEtDeoqB8d0fRyjrvdbvZuZ0
         wrqZ+3ssoWQ81d3+vRNCfwcQ+XpQV+mOQ4C0u5hejh1olzcOLljgnaVcEePLQjFPjSUw
         YrIBOHHUNtJ7LG7HIj+9MX5m+EF+dgRy/xPJ5L+7kBPWiwLsH3oBz+z2L/UiwAcJx5Ui
         uW5Q==
X-Gm-Message-State: AOJu0YyPW0/VUFZ8L5i5eatFWRpmEQpbO3iVmu29VQMdotcDJ+Yu56RH
	CvZBoSNy8nRlqYXO0aec2B7pWHqXk4U0YG03taWa065eEMYNbMHu+6xDiw==
X-Google-Smtp-Source: AGHT+IFxB3zkg5uDo8WmIVAVuWn1Nl6Tq6XwfoHS3tpvwIq58xPkYtb0W3WEyMwJ0pyQLeIdDK5TFg==
X-Received: by 2002:a17:90b:4b0d:b0:2e2:b219:40a2 with SMTP id 98e67ed59e1d1-2e8f11b8bdfmr23047253a91.28.1730412926964;
        Thu, 31 Oct 2024 15:15:26 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa25742sm3916528a91.19.2024.10.31.15.15.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2024 15:15:26 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 02/11] lpfc: Check devloss callbk done flag for potential stale ndlp ptrs
Date: Thu, 31 Oct 2024 15:32:10 -0700
Message-Id: <20241031223219.152342-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241031223219.152342-1-justintee8345@gmail.com>
References: <20241031223219.152342-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Should an rport remain in the NOTPRESENT state it is possible that
stgt_delete_work is scheduled after dev_loss_tmo_callbk.  In such cases,
dev_loss_tmo_callbk would have cleaned up the ndlp object resulting in
stale ndlp pointers in lpfc_terminate_rport_io.

Check for the DEVLOSS_CALLBK_DONE flag to know if dev_loss_tmo_callbk has
been called.  This is a more reliable way to avoid dereferencing stale ndlp
pointers.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 9241075f72fa..a434faec3c92 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -100,6 +100,12 @@ lpfc_rport_invalid(struct fc_rport *rport)
 		return -EINVAL;
 	}
 
+	if (rport->flags & FC_RPORT_DEVLOSS_CALLBK_DONE) {
+		pr_info("**** %s: devloss_callbk_done rport x%px SID x%x\n",
+			__func__, rport, rport->scsi_target_id);
+		return -EINVAL;
+	}
+
 	rdata = rport->dd_data;
 	if (!rdata) {
 		pr_err("**** %s: NULL dd_data on rport x%px SID x%x\n",
-- 
2.38.0

