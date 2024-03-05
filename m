Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3435A18639
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 19:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709668148; cv=none; b=gLfy7FJCo9hrrQDq7SxLbNc/Dk6TakoBVnicGqmLihXn5M80CvAj5TyojT1ELLgi4HYVwfgPL64rH2CVzZ4fOBN3KDrzKrAC6fCjQm6pxKaAUsQ/UrMjcuTtTgDz6rTzLbUgyMrtH+f8qWA101hmez5oAu5UE7hu9jmgKqKTPeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709668148; c=relaxed/simple;
	bh=fAYu/3ZYnBoC4sdVkhLq1OnTV7uGYF9fez843cbKrOI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XWZu58wSFUHnr2oHAME1HqnkPPjw22uIYsnlg+TikyXYgSTCxDazqm7B2GoACuJQbq1ERobBZcVe0KqVOdR7F968EdFlfSSXfADUX0zAd/a3kkW6kvg1C4qk4xdUskyrGqKqosDciFnSBAFS1EijYvZgLEH6PIqMMaELbRfW7PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ys0HiA9n; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ys0HiA9n"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-788251ac2f5so16307285a.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 11:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709668146; x=1710272946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddTpIQsjU40JpxkVRBtuFU7xCGs8zXtmzscIjPLqOSg=;
        b=Ys0HiA9nQYn/NoIGoQ2irhkpDrS9sxnhfg/FMHYl4m+tM+41Jj4yhxNlAhxiN0YZDE
         vXDV5hsJOWNz9ScUb9v8xq1MezOqJvIaWmR6HCm8rSrEgBPUga66VBZA4kbrSXrBEVJh
         XV6T6tJ2v2YOfvI9pmoJHx5zPvReB8tcOf86DYT4f4YwxMqsBHpJWjm8KF6u9IMyF/Ik
         VqAW639XQc5dUpSM7youc56nFZRDsm4rO/vMAVG824aJpY0vV43g8rd7ipOnUVUlbtD9
         iLJBHl0IV5caZOX+ELDTl/nhEDXGcH0DQlMcAKwcqNVE1t+mDD0v4eruQoLgOnk5niI6
         e3iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709668146; x=1710272946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ddTpIQsjU40JpxkVRBtuFU7xCGs8zXtmzscIjPLqOSg=;
        b=u+qi9DTjh8tS5PTS/NEtdnhaq18i5zEiyqLZWfUWwoAV1qOtJ8lmlRbNnBvrV8MXs1
         yk1SxmBqtpgKRqOvIXLuTWiyE0RSItbtm9vR93PPL8omcYRQswiog74Ev21sljjaYHke
         OjTffNkLgp4tefzSSbtw/DIT3xh0vD9hyyir9Aryumo0IfGmD2eJIUuELiviRC3Inw8r
         VOsPIp0hIDIfc78UMWLvy3GO0TBqSs1X7t8uokEBPQa1vWd96I7FJWdUk3kIBIBnRmYR
         5mmykEtUsWL8gWyoq//5Lyq76qVH/1vnJ65YB8wNvuPQzGbMPFl1Bv4TBet5vbXS5+8y
         MrKQ==
X-Gm-Message-State: AOJu0Yw8xIVfLCjmV5P2g+zpGKmnmu6uhFQu0kidIJ32m3Pl8+jJAFcz
	kmZ7rri1PjCbbWxyTCYhU6N6QiK697GA36HYvmegV1OKJmIeiqBGKs1PAJR6
X-Google-Smtp-Source: AGHT+IH3NPLOzLnddgrSHAQY220Qw6gcbSQ9SO+Poo+7wh2JcIYSKfUKeZQtgnXql+CYjz60/rBAZA==
X-Received: by 2002:a05:622a:1c8:b0:42e:dd5b:e014 with SMTP id t8-20020a05622a01c800b0042edd5be014mr1301154qtw.4.1709668146115;
        Tue, 05 Mar 2024 11:49:06 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bj13-20020a05620a190d00b007877f52a6b9sm5706050qkb.136.2024.03.05.11.49.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:49:05 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 01/12] lpfc: Remove unnecessary log message in queuecommand path
Date: Tue,  5 Mar 2024 12:04:52 -0800
Message-Id: <20240305200503.57317-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240305200503.57317-1-justintee8345@gmail.com>
References: <20240305200503.57317-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Message 9038 logs when LLDD receives SCSI_PROT_NORMAL when T10 DIF
protection is configured.  The event is not wrong, but the log message has
not proven useful in debugging so it is removed.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 81fb766c7746..e7bfaa0eb811 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5336,16 +5336,6 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 		}
 		err = lpfc_bg_scsi_prep_dma_buf(phba, lpfc_cmd);
 	} else {
-		if (vport->phba->cfg_enable_bg) {
-			lpfc_printf_vlog(vport,
-					 KERN_INFO, LOG_SCSI_CMD,
-					 "9038 BLKGRD: rcvd PROT_NORMAL cmd: "
-					 "x%x reftag x%x cnt %u pt %x\n",
-					 cmnd->cmnd[0],
-					 scsi_prot_ref_tag(cmnd),
-					 scsi_logical_block_count(cmnd),
-					 (cmnd->cmnd[1]>>5));
-		}
 		err = lpfc_scsi_prep_dma_buf(phba, lpfc_cmd);
 	}
 
-- 
2.38.0

