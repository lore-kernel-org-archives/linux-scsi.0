Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9203DC43332
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77DF064F70
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhCQJL5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhCQJLk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:11:40 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5913C06175F
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:29 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x13so998051wrs.9
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I82Btd+WVHIiPCtw03KBCwnnKsQgGGYmx7xND9MdwYA=;
        b=E9L3JiUARuk60dnHpdoLup8xflMxXQLLQdzgkIFwAmFHyHDWahFyYI4qSAhLEH/KYR
         haUWnCDT5Y4vnZCGMsbBGveaakPnwqS3uVB9yDMe4Kb5o5Km4+RWTzKaniq0WwfTa2P8
         fZ51IJjnUQVA/GLsIElaoTQauOBK6X1eAVivrvAbZNXOW6kSRbM0DdHNPzUKLt2JF2El
         FXcVoGEETVmIaBi1jccm4zGy3HPIPYSNLbQWVX1DPChjKg9xVO/trDOXB+Y9vbe49Pta
         IcqSMNktuQmijCgsjOgq1hTQXULQgXd1i1IhmjzFwYMFww5ErCb6z51nQAMV431Virg+
         lRxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I82Btd+WVHIiPCtw03KBCwnnKsQgGGYmx7xND9MdwYA=;
        b=jvGVxiaBwxB8tD8k6XutsXSZueVMzXR+g++xfP0RL3kn+5rrjOIYsu5BwVbjYbQ3C/
         zRyE/MbjFvdV+I/BT7LsIRlmAVbeMjLlE31j2V04xWZUqjyFLWU5pRe2kgzzKC1y/q6t
         Fe6Pgg1XjSa+Rw5BlUYedVxEDPsPrlVBDnjRazrcs0efw4fSvMgJEvsgswfbK8RA9EoU
         gawwf4QnwR/c42eKKMEfAlXR3zckn39Vr/BL4l4ETAxeGEomHyOxqCtMQY7r1H7yvGwa
         LE95WWjoXp+XSEb3ka4386RKowFKUWTX5tq+mX1UsZyCCFf8AtkAuUeTRwg6eyWGeoYh
         moog==
X-Gm-Message-State: AOAM530OBz2CvzozepkWvAInzGty++JUVuuyxTSfim2AtF9on+jMBcHw
        Nsp82nnoHbWxcbJpYZJQWYYpvw==
X-Google-Smtp-Source: ABdhPJy7uZ6IRh01G4V7CU7eVy6v4zESEGtViXUZMTass0PqzEtjjb9v+wpS+58fer4PEC+gBMu5oA==
X-Received: by 2002:a5d:5105:: with SMTP id s5mr3472218wrt.140.1615972288457;
        Wed, 17 Mar 2021 02:11:28 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id s83sm1709279wms.16.2021.03.17.02.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:11:28 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        c by <James.Bottomley@SteelEye.com>,
        GOTO Masanori <gotom@debian.or.jp>, gotom@debian.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Richard Hirst <richard@sleepie.demon.co.uk>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 0/8] [Set 3 v2] Rid W=1 warnings in SCSI
Date:   Wed, 17 Mar 2021 09:11:17 +0000
Message-Id: <20210317091125.2910058-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This set contains functional changes.

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

Lee Jones (8):
  scsi: BusLogic: Supply __printf(x, y) formatting for blogic_msg()
  scsi: nsp32: Supply __printf(x, y) formatting for nsp32_message()
  scsi: nsp32: Remove or exclude unused variables
  scsi: FlashPoint: Remove unused variable 'TID' from
    'FlashPoint_AbortCCB()'
  scsi: sim710: Remove unused variable 'err' from sim710_init()
  scsi: isci: remote_device: Make local function
    isci_remote_device_wait_for_resume_from_abort() static
  scsi: isci: port: Make local function 'port_state_name()' static
  scsi: nsp32: Correct expected types in debug print formatting

 drivers/scsi/BusLogic.c           |  2 +-
 drivers/scsi/FlashPoint.c         |  4 ----
 drivers/scsi/isci/port.c          |  2 +-
 drivers/scsi/isci/remote_device.c |  2 +-
 drivers/scsi/nsp32.c              | 31 +++++++++----------------------
 drivers/scsi/sim710.c             | 14 ++++++--------
 6 files changed, 18 insertions(+), 37 deletions(-)

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: c by <James.Bottomley@SteelEye.com>
Cc: GOTO Masanori <gotom@debian.or.jp>
Cc: gotom@debian.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: Khalid Aziz <khalid@gonehiking.org>
Cc: "Leonard N. Zubkoff" <lnz@dandelion.com>
Cc: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Hirst <richard@sleepie.demon.co.uk>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
-- 
2.27.0

