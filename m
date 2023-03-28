Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883FDC6FD1D
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Mar 2023 00:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjC1ARm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Mar 2023 20:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC1ARm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2023 20:17:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15271FCF
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 17:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679962614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=l9TloykkvVXc8o7UP6x81LrTcABAgCIQ1kB1+I+fT8w=;
        b=Ko4WJzybRJOiRdB8I8ndDh6A61QVkEeWjkwWInxYvLJvkK9LNI4h5p/v9KeC1f8aVvBwy4
        edd/BYEcuTVHcv4LfmMF1yx37C6RkasS7ZZSn5oWG4zhtKey5OfP7/ZuMaBkLowoVMSDMz
        ETfqWp2qUW2heah4NlVjtWJrV1SZp/E=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-MCIoBIKPMs2nPLk5m6Gb2Q-1; Mon, 27 Mar 2023 20:16:52 -0400
X-MC-Unique: MCIoBIKPMs2nPLk5m6Gb2Q-1
Received: by mail-qk1-f198.google.com with SMTP id c186-20020a379ac3000000b007484744a472so4543362qke.22
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 17:16:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679962612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l9TloykkvVXc8o7UP6x81LrTcABAgCIQ1kB1+I+fT8w=;
        b=P8WDK9XENs2Q8Z3L+oaslC59I8bqaUurVZEEcoxj2e6Fgn33VSCcBQZKBPw5uSUX0s
         QCDJukrmKjDZlA2ec3rmvv2wAJSeoIpZrOxa5zmgmnsul+aRmh/JVff1ReiQloZAHG9l
         RBQ8zV3aOFlArs3QLK98HyWIEQ854uewds2o1vKSr8YVlJpYGLEaqScweiN02SFFl6w7
         dd+JwXDrx8y4aABFVoDayo79iLAt9KvNWKv5kq3ys7n9hohg+SKrD2bNFrfhQnETyKS7
         KsteQCsOifciLQWKtk6xL9csP0jBesvzI9jqLuvmRzecLk4JRVbSYjvQS01Y4XC0M0sE
         6XVA==
X-Gm-Message-State: AO0yUKUNfG/r75Z8xcYuoiwUCs26L30/U6qWlw9vryLHXZTFmSVsPzY3
        0cwpQ9pp4gHDQ+iUmEmZv/061DH0iSqes1ArnCFw/f0BDQxXLdEJPSz19yav/fLAJZ9BLAjW19p
        VjLXI9Bti0kAv4RCh6NSdBA==
X-Received: by 2002:a05:622a:18aa:b0:3b8:6442:2575 with SMTP id v42-20020a05622a18aa00b003b864422575mr22673854qtc.49.1679962612316;
        Mon, 27 Mar 2023 17:16:52 -0700 (PDT)
X-Google-Smtp-Source: AKy350btSLeE0R9uHWk3nYnNxmFX2+jJghagg9JtvjX2KzEzjA2jaBgsmO5jb10c3S8J3WgiOfmnHw==
X-Received: by 2002:a05:622a:18aa:b0:3b8:6442:2575 with SMTP id v42-20020a05622a18aa00b003b864422575mr22673825qtc.49.1679962612093;
        Mon, 27 Mar 2023 17:16:52 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id m4-20020ac866c4000000b003e30aec0b70sm9500482qtp.64.2023.03.27.17.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 17:16:51 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     kartilak@cisco.com, sebaddel@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: snic: remove unused xfer_len variable
Date:   Mon, 27 Mar 2023 20:16:47 -0400
Message-Id: <20230328001647.1778448-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

clang with W=1 reports
drivers/scsi/snic/snic_scsi.c:490:6: error: variable
  'xfer_len' set but not used [-Werror,-Wunused-but-set-variable]
        u64 xfer_len = 0;
            ^
This variable is not used so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/snic/snic_scsi.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 961af6fc21bc..c50ede326cc4 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -487,7 +487,6 @@ snic_process_icmnd_cmpl_status(struct snic *snic,
 			       struct scsi_cmnd *sc)
 {
 	u8 scsi_stat = icmnd_cmpl->scsi_status;
-	u64 xfer_len = 0;
 	int ret = 0;
 
 	/* Mark the IO as complete */
@@ -496,15 +495,11 @@ snic_process_icmnd_cmpl_status(struct snic *snic,
 	if (likely(cmpl_stat == SNIC_STAT_IO_SUCCESS)) {
 		sc->result = (DID_OK << 16) | scsi_stat;
 
-		xfer_len = scsi_bufflen(sc);
-
 		/* Update SCSI Cmd with resid value */
 		scsi_set_resid(sc, le32_to_cpu(icmnd_cmpl->resid));
 
-		if (icmnd_cmpl->flags & SNIC_ICMND_CMPL_UNDR_RUN) {
-			xfer_len -= le32_to_cpu(icmnd_cmpl->resid);
+		if (icmnd_cmpl->flags & SNIC_ICMND_CMPL_UNDR_RUN)
 			atomic64_inc(&snic->s_stats.misc.io_under_run);
-		}
 
 		if (icmnd_cmpl->scsi_status == SAM_STAT_TASK_SET_FULL)
 			atomic64_inc(&snic->s_stats.misc.qfull);
-- 
2.27.0

