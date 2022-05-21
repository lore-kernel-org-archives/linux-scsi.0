Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED3DC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 21 May 2022 20:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbiEUUQV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 May 2022 16:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237524AbiEUUQS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 May 2022 16:16:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8803C1A38C
        for <linux-scsi@vger.kernel.org>; Sat, 21 May 2022 13:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653164175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aYfGbu7Vp6C9Yi7GEbgp8ZiZyefeISQ36nK1X14PBlY=;
        b=WpXp1yOLveQLAEZonO82eDQ4Qp9dIvZJrgYdUc2mOkj3fa1vgTzMFR39/c6luEH1ZF0708
        O9ZGZFmCk1pJJLsVFcl7PeDdgZx2igP22TW+cNPF6S37yP+F031RLODBk8zE2rS2tlC8wc
        nokhoZlg3UpyFB40bUeiRSaMSX1cfQQ=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-BdogaFE1MIulS8zcdgt5-Q-1; Sat, 21 May 2022 16:16:13 -0400
X-MC-Unique: BdogaFE1MIulS8zcdgt5-Q-1
Received: by mail-oo1-f70.google.com with SMTP id n4-20020a4a8484000000b0035f4d798c46so5368700oog.21
        for <linux-scsi@vger.kernel.org>; Sat, 21 May 2022 13:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aYfGbu7Vp6C9Yi7GEbgp8ZiZyefeISQ36nK1X14PBlY=;
        b=AYIHYUNjt566V44pRuCsjk6LZk2HqN28WJs8U9bksILTYPdEHpa7RO7b5e1Zu0E4Z5
         QNoRfQQ5gwPZnmaLpaQ+IvrUCUqQ/HsZD9YyUNdjEbccrDKQfS8uuaXj+3szh0mn4GHM
         hueuNg3+dHuE8q5vtiMoYlVVnSUpqBuZhoeqahiE8qdAO+NdQgppGzSpi9gX+vE8WiFs
         Tk9xYdPmdFqRCbVgn+b4zj58UUtx9XaM0XITsjUsUI1EH6pmQSl0L6+i83cdf4prI1NS
         5uDNIIrAzmwizbKvWRLxiBF+IZQ8/2BYZoJuzQUFGmZwjEgfPGClokd0TB75FCo1J2fe
         Ovkg==
X-Gm-Message-State: AOAM531BysiBTv4OvQxZmC66weK35cSTuoFMbZunyw0z/p3fbwR/CL+Y
        aoObhPnh6lSjXkI5WPT/heI2Xn/3f3U7npucmy46l22LRHjqqbh/9Qi5+lKYsYaOa3M/+cDKA+X
        yNO4+hkcVb6wEiDSH0QmM/g==
X-Received: by 2002:a05:6870:9725:b0:f1:b173:4241 with SMTP id n37-20020a056870972500b000f1b1734241mr8540987oaq.237.1653164173157;
        Sat, 21 May 2022 13:16:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyinaf10Wrq70gpKW7je3hbPTX3Ya2gPfVjAXkFtyz8wq/mvsZfgZkuy8Uw80NSj96eyaud+w==
X-Received: by 2002:a05:6870:9725:b0:f1:b173:4241 with SMTP id n37-20020a056870972500b000f1b1734241mr8540980oaq.237.1653164172971;
        Sat, 21 May 2022 13:16:12 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id r81-20020aca4454000000b00326a7d33635sm2537289oia.27.2022.05.21.13.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 13:16:12 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     njavali@marvell.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: qla2xxx: remove setting of 'req' and 'rsp' parameter
Date:   Sat, 21 May 2022 16:16:07 -0400
Message-Id: <20220521201607.4145298-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

cppcheck reports
[drivers/scsi/qla2xxx/qla_mid.c:594]: (warning) Assignment of function parameter has no effect outside the function. Did you forget dereferencing it?
[drivers/scsi/qla2xxx/qla_mid.c:620]: (warning) Assignment of function parameter has no effect outside the function. Did you forget dereferencing it?

The functions qla25xx_free_req_que and qla25xx_free_rsp_que are similar.
They free a 'req' and a 'rsp' parameter respectively.  The last statement of
both functions is setting the parameter to NULL.  This has no effect and
can be removed.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/qla2xxx/qla_mid.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index e6b5c4ccce97..346d47b61c07 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -591,7 +591,6 @@ qla25xx_free_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	}
 	kfree(req->outstanding_cmds);
 	kfree(req);
-	req = NULL;
 }
 
 static void
@@ -617,7 +616,6 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 		mutex_unlock(&ha->vport_lock);
 	}
 	kfree(rsp);
-	rsp = NULL;
 }
 
 int
-- 
2.27.0

