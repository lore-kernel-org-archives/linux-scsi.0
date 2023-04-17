Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E9DC77B76
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 19:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjDQTFu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 15:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjDQTFs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 15:05:48 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E796C7682
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:05:41 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b7b18a336so572500b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681758341; x=1684350341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OdJwpaLu2tZb3jZIZvv4q18r0V9tzBrb6V2n0Dk1YgU=;
        b=giL8wGQ5LZhssEUnSjWN4Jno2n0/IHVqbQxQh9QpRJqBXNCYFfu+l6xt5i33120URw
         yyzE1AofeK+hueZLlabq0BOrSntgGoPxmKiYMhIR7ta0RecmVnQ3e0VO6efVvCvrN9wr
         yjmRcgyVs0/yI7ntrzR9W4zH3q3XJz+sm4tu8M/GosubbM2c0wfiWG/lJcKPOgEzrnwh
         CSLBvWV+9HxO+ju9fjuyfj18giqvFvRVNsNASEASaDLQW8Wdqe7l28ntQp4itNolSAra
         AHO53Ei7mRtZNUkTXlyAof1/iNLfUlz41gr0UaWReEbpvSFHg30eg5998uXoP0I3606s
         QgpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681758341; x=1684350341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OdJwpaLu2tZb3jZIZvv4q18r0V9tzBrb6V2n0Dk1YgU=;
        b=jX9qzMsXEoSYdu+VRc3pEagKMy7b+SE77z5OrrHl2GAaJ0mniOrs5zTsfJ/xjXgWJt
         OwCLQXOnI53877Bx9PY8JzCEMo1h4e+brGMIowz7EQCN5E54gSOdZZSG4yocdvpwI61E
         n7KkwvvhJbGcw0y2omMz+rtjVvu0iQE+67DMcUuRt2nAITVAuhzX47hX3ifmd7kOMp+P
         P3G2xIpCgqr6ywbaAUXveHVGEmyv3cLBU4nENTu4x9SDAJvebzF70bnQSbI5ht3y6OAn
         x4AbSBME3QWrnUnsAHoHmK/r0PqUq6O9KPdzYT7yo5FFOAY+x3zAzIsNUghuK1G+a7v+
         xXRQ==
X-Gm-Message-State: AAQBX9eTF4y60PZZ/oBZGGNizPmlNORHqAglU90dngH5DpOH2TL8y9rV
        nNgAI9o8/KW1FmGqKy5hqcdh2LgZ3bg=
X-Google-Smtp-Source: AKy350YJhWjxoJAdLEY5Jo5XEVNHic/FPjkjSQmfgFmqQN2Tb0VLTAsXNLPeMYbXpHXT0rz87elgmg==
X-Received: by 2002:a05:6a00:a06:b0:63d:2d6a:47be with SMTP id p6-20020a056a000a0600b0063d2d6a47bemr2204872pfh.2.1681758341088;
        Mon, 17 Apr 2023 12:05:41 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x18-20020aa793b2000000b0063b7c42a070sm4291439pff.68.2023.04.17.12.05.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Apr 2023 12:05:40 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/7] lpfc: Fix verbose logging for scsi commands issued to SES devices
Date:   Mon, 17 Apr 2023 12:15:52 -0700
Message-Id: <20230417191558.83100-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230417191558.83100-1-justintee8345@gmail.com>
References: <20230417191558.83100-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For SES LUNs with scsi_device sector_size member set to zero, there is no
point to log an LBA.  When verbose FCP driver logging is enabled, sanity
check sector_size before calling scsi_get_lba on a scsi_cmnd.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index e989f130434e..49aa86c477c6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4273,7 +4273,8 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 				 "x%x SNS x%x x%x LBA x%llx Data: x%x x%x\n",
 				 cmd->device->id, cmd->device->lun, cmd,
 				 cmd->result, *lp, *(lp + 3),
-				 (u64)scsi_get_lba(cmd),
+				 (cmd->device->sector_size) ?
+				 (u64)scsi_get_lba(cmd) : 0,
 				 cmd->retries, scsi_get_resid(cmd));
 	}
 
-- 
2.38.0

