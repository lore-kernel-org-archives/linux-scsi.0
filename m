Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 454FDC001B0
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 18:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjHHSnB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 14:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbjHHSmZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 14:42:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E07591B31
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 10:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691515990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rdR/nWVu06E+qaDd21vThD7HnAhSxkVHgZWXT66GKkM=;
        b=OSxGyrCOKN+D5/ggvVc9BJ9xFTTtXvz2ZyXhMr2lON8AWKgBbx+aI9h8nKP5bQPuK9/uBi
        OBbn68GcIPT4zUKAUHxpZNxqSXCLQqV/I5xMHUboPmaNy84MqFXVFF7A2RuGERmkvdEbCn
        /0McHz3MgFSruDF6FMwiVmmkKuP8idk=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-VSCvt5xqMuuUZhTtYKx8IA-1; Tue, 08 Aug 2023 10:27:12 -0400
X-MC-Unique: VSCvt5xqMuuUZhTtYKx8IA-1
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-d4e1be2dd10so3466579276.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Aug 2023 07:27:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691504831; x=1692109631;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rdR/nWVu06E+qaDd21vThD7HnAhSxkVHgZWXT66GKkM=;
        b=XQd7SVG/vBTFGiZt4/rTy0BYVIn1koULRtD+9aTytx9gAWawOFKkhFV8k+DH7gznjY
         ntfIqRjoTZKSQWwErcaXEQTxvOP03XG3nDN2pGBIkjrzF81fLxrIBLac3pXwKbTRDavN
         7dUzGhmKcmBxRWhVCZHffu0LrfDX4L/o2VpVCien/wj/T8SxLlKZ/7nefaPPM3uYBcDb
         /OgtrwBmh0MyUh260D11hCTwEARyU9iZnbSpxXfbwnOtFG8PfolLCmyIy4fGKuH2n7Uz
         Ou7XsSbgm05wFJzUTYuTRz4unOlwZp8lCjH9fe7NVbE0wRfpY0liVLalxExdxXMLfLgj
         AojA==
X-Gm-Message-State: AOJu0YyxgozPg3lVEBLnxDyWg6huu85jbtxIRBUiskNLDXeyrqqo5cSK
        BRQoe4KITU8ImXaSjACBgwj7EiQX1ZWqNd2cZ7vwcfzS4tV+vvZ3ja5HnstzjtB2b4mfngZbVUn
        RsnSa4Kefk1Adx58n/tmqMw==
X-Received: by 2002:a25:aa31:0:b0:ced:6134:7606 with SMTP id s46-20020a25aa31000000b00ced61347606mr13222324ybi.30.1691504831617;
        Tue, 08 Aug 2023 07:27:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYUnMBFGOvVTn0B2fVJuWFGk0rbvX7MlTI9s+MDkABAAgnqZK/6AMRAo9gbZmrxokTCuY6Gg==
X-Received: by 2002:a25:aa31:0:b0:ced:6134:7606 with SMTP id s46-20020a25aa31000000b00ced61347606mr13222304ybi.30.1691504831336;
        Tue, 08 Aug 2023 07:27:11 -0700 (PDT)
Received: from brian-x1.redhat.com (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id y9-20020a259c89000000b00c71e4833957sm2713058ybo.63.2023.08.08.07.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 07:27:10 -0700 (PDT)
From:   Brian Masney <bmasney@redhat.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] scsi: ufs: convert probe to use dev_err_probe()
Date:   Tue,  8 Aug 2023 10:26:48 -0400
Message-ID: <20230808142650.1713432-1-bmasney@redhat.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following two log messages are shown on bootup due to an
-EPROBE_DEFER when booting on a Qualcomm sa8775p development board:

    ufshcd-qcom 1d84000.ufs: ufshcd_variant_hba_init: variant qcom init
        failed err -517
    ufshcd-qcom 1d84000.ufs: Initialization failed

This patch series converts the relevant two probe functions over to use
dev_err_probe() so that these messages are not shown on bootup.

Brian Masney (2):
  scsi: ufs: core: convert to dev_err_probe() in hba_init
  scsi: ufs: host: convert to dev_err_probe() in pltfrm_init

 drivers/ufs/core/ufshcd.c        | 17 +++++++++--------
 drivers/ufs/host/ufshcd-pltfrm.c |  2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

-- 
2.41.0

