Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF47C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 03:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240828AbhKXDb0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhKXDb0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 22:31:26 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11585C061574;
        Tue, 23 Nov 2021 19:28:17 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id g1so815971qvd.2;
        Tue, 23 Nov 2021 19:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tXN21RYqaojNN2dpv2PnfKDhEnV98coiCnITanBWxSM=;
        b=bdMLPCLqOnrgJgV+iFVH1sN3GWzt+/SzNSffpLT95SSxazc1Xi21fLaIt0LKFQlTX0
         JSH1r4qjQEKa0Is9U5DatCFtpXj6g4s1L4jtIlpbBAFeX7gE733VNZKsLkUCDs9UPFiu
         IMFe7+2biaiqEIfhLJmkTefzNsqMi7a2cvM60xSEKQe9sdvMv/7K9M0JNMRW8lSsgoS9
         WsCxfVfgcmZ8eW0DHHyDQQ8ZXgG0TYlo8tatacodJQCSMNpgQBR+bsS93DZhsXoKYkSC
         i9tjJzuWr+qUvxclzzDgWWDTRJbID4W0Lei6A/2tPVwKDoxvCMQ3WypSaWCr4n9O19Gg
         W6lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tXN21RYqaojNN2dpv2PnfKDhEnV98coiCnITanBWxSM=;
        b=J5ILTnWq2GIbjUPb8izpEIYnT1cVs37N2tH78hKgKEq/STowPLnJuPUXtUrq788eNk
         HSYD+S/5wpckDxRw0SZhyjrC+z/ljo5n4/n+EditlPOZg6fwT94KAQfEMNcRu+1euo+A
         eenT6y9n4bzsrGWeJxJtYZ5w3qZ6jRZYDdKABpUPdGeEIRCCL0sGw6Pk7JOnUdoWh2yz
         6K/KlMjIZLzaHvn0mVFTcYaQhBUpNWq673RW1xicTb4B9cNpisXMwG+J7A6Zu794lNMk
         6kWT1foDn/U1KmjIzPQ8cQdJl7+xzGxFNJKeitSGrWHELl6v2nEmQZjaBQKTcS3mGXDh
         /xdA==
X-Gm-Message-State: AOAM531cuDacSiZa1IPu0HiifzbnmUaa/v+sA7KdRphxgrEJLmmKUtVp
        TQM2pk5aAOVlwrea2EjPYPw=
X-Google-Smtp-Source: ABdhPJxYQsFxyRebODFfGpuPwsD9OxUwrl1/WhOLSbnuhWVhNHU6UNqntDqMx6rn/F82qXSjks37JA==
X-Received: by 2002:a05:6214:f61:: with SMTP id iy1mr3208027qvb.0.1637724496323;
        Tue, 23 Nov 2021 19:28:16 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h12sm7229011qkp.52.2021.11.23.19.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 19:28:15 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     mdr@sgi.com
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi: qla1280: Use bitwise instead of arithmetic operator for flags
Date:   Wed, 24 Nov 2021 03:28:09 +0000
Message-Id: <20211124032809.35693-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Fix the following coccicheck warnings:
./drivers/scsi/qla1280.c: 3719: sum of probable bitmasks, consider |

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 1dc56f4c89d8..1147a32ef488 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -3716,7 +3716,7 @@ qla1280_error_entry(struct scsi_qla_host *ha, struct response *pkt,
 		ha->outstanding_cmds[handle] = NULL;
 
 		/* Bad payload or header */
-		if (pkt->entry_status & (BIT_3 + BIT_2)) {
+		if (pkt->entry_status & (BIT_3 | BIT_2)) {
 			/* Bad payload or header, set error status. */
 			/* CMD_RESULT(sp->cmd) = CS_BAD_PAYLOAD; */
 			CMD_RESULT(sp->cmd) = DID_ERROR << 16;
-- 
2.25.1

