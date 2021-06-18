Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E18C48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 17:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F12C613BA
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 17:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbhFRRnG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 13:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhFRRnF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 13:43:05 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AC0C061574
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 10:40:55 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g24so6084400pji.4
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 10:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gfc2bVgtVDNW4icOcHnzEtMUdUwpEpkUhDOnizkNBaQ=;
        b=tqoqSo5wfdzjlFAXybqdOo1xpYDVdiYwW0y72RvcuMMvdSsnNTZs48e/kfWNqOTzFS
         HDtv8dtv6EceVQCsU1eJE82bOjQa7vmzKDK/ptr0DKTbXGyzMixfiV6rmgwFzMvUuS+I
         PpPxJbfcnpPtPtV97n6AEBcttEa9BJcDUd0MV+i5U/rhR4m1xrjdbri49UebWKojt+nh
         atjBqlbDKbcmYsMd+fQ4MhTTcUdQRZajeJyyBonOCGMkn6X3cGItzvn5wb5vd+pZdrvv
         nShKoYH0Ft7Ql/jPHFskbHuaSGZn28NJMl7yEoi72qDCx2/P8EjI7HE4aBfqGYhmbHTK
         MUCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gfc2bVgtVDNW4icOcHnzEtMUdUwpEpkUhDOnizkNBaQ=;
        b=R3v9of75GToViVXmRoSq8yG1Aw7AC2gAAINxq/9MR9BjMppfEGfSEHOznXLlW+aKiU
         zpeQ02SyUrQbuPDG78QIXFfwWYyKMHAfoZ7Q57PeqE4HEZHJn3Gwi4Bxh2tneVdMndtz
         PT+KtnMA0PNrNexSjBxf4lbCg0ieKZcA2ECnkjQVv+FYriGudhQfo5TYkkPnMy5uLs3v
         wyhu8SUi0Xq8hpNpMq/ppmHcexkFeZ+kCp66mGBsynDAuKgJHxLxTVlhn688XtnLBstl
         ubfPBmCSC4FkXnrzEIV66JssqBA4y1kmuIB00UkakXfJvkyvIfyDCjF4Ij6OiA5CrNRQ
         yA9w==
X-Gm-Message-State: AOAM532VwGafWseinN2uHpKyArr8mghuBhS/4L74qmaOo9kNwpHEcapa
        jQdkeKXIkdyrVlzOWtb7txrD/ewMGRo=
X-Google-Smtp-Source: ABdhPJzgNBJ3dqdFYBKXnTORltFbr7DDr7PX/GsxJN+TBaHl7/4Gk6Kwm3Bf6rsrZdWgymTANwDagw==
X-Received: by 2002:a17:903:2403:b029:ef:9419:b914 with SMTP id e3-20020a1709032403b02900ef9419b914mr5832163plo.59.1624038054859;
        Fri, 18 Jun 2021 10:40:54 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id h22sm2170701pju.22.2021.06.18.10.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 10:40:54 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     ram.vegesna@broadcom.com, linux-mm@kvack.org, dwagner@suse.de,
        hare@suse.de, martin.petersen@oracle.com,
        James Smart <jsmart2021@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] elx: efct: fix link error for _bad_cmpxchg
Date:   Fri, 18 Jun 2021 10:40:50 -0700
Message-Id: <20210618174050.80302-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

cmpxchg is being used on a bool type, which is requiring architecture
support that isn't compatible with a bool.

Convert variable abort_in_progress from bool to int.

Fixes: 	ebc076b3eddc ("scsi: elx: efct: Tie into kernel Kconfig and build process")
Reported-by: kernel test robot <lkp@intel.com>
Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index 32cff5548f0e..f3f4aa78dce9 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -223,7 +223,7 @@ struct efct_hw_io {
 	struct efc_dma		xfer_rdy;
 	u16			type;
 	bool			xbusy;
-	bool			abort_in_progress;
+	int			abort_in_progress;
 	bool			status_saved;
 	u8			wq_class;
 	u16			reqtag;
-- 
2.26.2

