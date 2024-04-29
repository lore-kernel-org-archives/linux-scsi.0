Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15B9839FD
	for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 21:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714427885; cv=none; b=GWMlhirBWCd63CLDEeslBm11u6PRL8+9ePwz4hOzz7cYBrLPQMn8m8F093KSbpecovjyWcuqh7Hz2oyKv7zLeBrKPn1xc58gAaywUKER/x0IGKS9YpXhCky7gTNGgIb1X96Km3fDnIUWmHMv+SmIRmwYgtfu374Q+jYlTFth3YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714427885; c=relaxed/simple;
	bh=pWbdm3HO1XAVCIqKObLHdy6YQSr/wf74XMqsZrci5As=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lwDB7E/wuhWuEYnh2kXqd6lIY5hgNqYwu+xRnkaWXNzfIYSvTXNNw036vGqu5cDbG1DvEA4NZwaO0gAq2IY+FH3GIf3mJRhiJaqWSBXwCg/f1Y8QcnIZdfjOpHpQevwEaG/evg7vsiawzdgVnI9nVg0O+E+jg00wjHBBekCy2pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LoeC2KSw; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LoeC2KSw"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-479d3f59795so275239137.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 14:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714427882; x=1715032682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZNhgFma7kXa8W9mvzbBGVDRfXJ+fSuPrWpXZ9nFfLwI=;
        b=LoeC2KSwczeS2lr6g5XAKDFZITedQwskA+iYR34g+JMJvwEf5uDHCr0q/WMYiwGhjJ
         ZkM/oDUh9PbzVtPoXiqvERfl0TrSknxoTOghQ5mNyHhjSPR1lAuVKLmZ3xGrOYdVP8Dt
         LMAKIRbFLp9zfVRgLeLDdILOqmFugTU1kWEe6c9iGQ1ykMzAFMVfeKW6JFaO4nzuKeYs
         Gc3qblqllXmWJSTYiFGRWfeeHxoI9UXryG4hiwX8cbE/ekrg/0v38h718PskeE+pWnig
         MqHrUjZXKBpqmtPxcV5Da5B3WavJxeFXUqrtBE/6z5AgESmLhHOGVgC26xuqSnfOGuxg
         oXXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714427882; x=1715032682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZNhgFma7kXa8W9mvzbBGVDRfXJ+fSuPrWpXZ9nFfLwI=;
        b=J38WSf+TcfzoHNvvj4qchGzqZKkPQwY3ORwGaNdl4dZ0GwB/4DMWA+XIWn5eg2r1r9
         r7sOLGqUWQHFFtXl135PSEXZ+Jo1IcSHLLtQvExFl5gITwDQjG9K+UrgIkd9Zga3df7X
         +6d3QWKiju79oa3WnuyrbxtvYp6YabF1LENgJ/vz9cmrg4K7GlEgKB7SvXNMdE/vRG/+
         mGp33v6bT8IKUmRylirwwMsQ0K+Im1uZpjrR3DWjiW1V26sKOyGG5rPx9z+xJXZ6TdPL
         SnIs0paxIL6WJfsPXrdq+0prikIOgqtcEI8/hVs3o0duWPVP04LAii/rrnE4rOBjpyV6
         tyIg==
X-Gm-Message-State: AOJu0YyF1dJpar9AsHOtVj/unSJpshEgJ+11BQV9EjNL7BXHGLdXX8AV
	6Fr2j0VR97YSKNlbOykosLdkKrKVTxVaKtmITMcsnpymp04hYIA4nt8FnA==
X-Google-Smtp-Source: AGHT+IFQS5nKql8UkMcfpVfWIvUp5u8qJSFQjq8wdLyx4W7Z8ARZPLe4F/0iluabKf3qKd+ElTneXA==
X-Received: by 2002:a05:6102:1628:b0:47c:1777:c4a2 with SMTP id cu40-20020a056102162800b0047c1777c4a2mr11739504vsb.3.1714427882446;
        Mon, 29 Apr 2024 14:58:02 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mh12-20020a056214564c00b006a0cc9ef675sm1528280qvb.16.2024.04.29.14.58.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2024 14:58:02 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 2/8] lpfc: Update logging of protection type for T10 DIF I/O
Date: Mon, 29 Apr 2024 15:15:41 -0700
Message-Id: <20240429221547.6842-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240429221547.6842-1-justintee8345@gmail.com>
References: <20240429221547.6842-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A struct scsi_cmnd already contains T10 DIF protection type information in
prot_type.   So, instead of manually checking a CDBs' RD/WRPROTECT
fields with (byte[1] >> 5) utilize scsi_get_prot_type.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4a6e5223a224..89a622e3053e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5327,7 +5327,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 					 cmnd->cmnd[0],
 					 scsi_prot_ref_tag(cmnd),
 					 scsi_logical_block_count(cmnd),
-					 (cmnd->cmnd[1]>>5));
+					 scsi_get_prot_type(cmnd));
 		}
 		err = lpfc_bg_scsi_prep_dma_buf(phba, lpfc_cmd);
 	} else {
-- 
2.38.0

