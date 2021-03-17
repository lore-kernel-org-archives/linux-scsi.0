Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC08C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4231364F79
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhCQJL4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhCQJLg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:11:36 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC61C061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:35 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id 61so987415wrm.12
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=omHoCGEAHHfzGsCXWaSPZZFL53Kydw/eMLAhlkpH1KI=;
        b=NOs1xeXimZT1FQY+Ocg69tjJxLZq/xMp3D5060fTK4rW+F/DEsGLmdmyXIHTzt1f9Z
         7ak1G7Rbtp8ULeiqAZxM4ipL7uGSXIrNT4wrhcDHpFI2ZMZObqN9JtH68SFyhmVxA+yP
         hBKqtQ8L0Vize5FdnfU8pGnTAVqtvVctIWXtdoXhSrlJkZrKF5QCg3z3rZZke50toe6v
         Gv3ya0UhriLKS8776/30epLokDBbALSBn3k9DyHz+V/G78qxPkOJCMzGXR0kFryI/Ybb
         QFR9AH4sJrHIBG7xnKQObLDfnfd8zx6Vw2x5moOnzUa/336kofXchmRKpDt5SVn4/oRM
         U6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=omHoCGEAHHfzGsCXWaSPZZFL53Kydw/eMLAhlkpH1KI=;
        b=t9S0AWvsSsK1MURl2Yaq3ZYv8HEbf5BG4kBrefTatLfH6b3Quls54LQDOYcFFUMSKF
         ESm5Sic8XIGnJrWjrg1AzDw8rlI5pm2GAK8zVXR7oNW8H1QGUeYG0CekBNsXl15pKn7Z
         YAHZe5vFH4z9m0UNc1oGxUjSpxrBEpD4CelayrjXy9g5XVBeFUSd2YMl9CSnFTR+5zxQ
         9knsTIMnmVmpyf1Vnvkk/46FG2tPPJn6u/0VgJEp1zDf5pZj57NpwoXVvlwBtzqQ1J07
         vNjCJGnWcw9HixKWf1mkbjpfbemHTGWXFDXdv8lNO1Duy5/dvcIjB9PSxI8r1K4a76CJ
         LJlA==
X-Gm-Message-State: AOAM533UG7ze5XuJ07yJ9gFwj55Sns+CjgHWtbDBWcZSwZMkf3FY9H9z
        92Le2K6zVLYSVf5zkWwN1BGpqQ==
X-Google-Smtp-Source: ABdhPJwyC6BzxEhifslpYQC6x8udphgqiggUDCfi2SKTbSnWZ2V4oREh2OGLAvUiUcQYvfmezHynXQ==
X-Received: by 2002:a5d:6290:: with SMTP id k16mr3161670wru.177.1615972294389;
        Wed, 17 Mar 2021 02:11:34 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id s83sm1709279wms.16.2021.03.17.02.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:11:33 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 6/8] scsi: isci: remote_device: Make local function isci_remote_device_wait_for_resume_from_abort() static
Date:   Wed, 17 Mar 2021 09:11:23 +0000
Message-Id: <20210317091125.2910058-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091125.2910058-1-lee.jones@linaro.org>
References: <20210317091125.2910058-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/isci/remote_device.c:1387:6: warning: no previous prototype for ‘isci_remote_device_wait_for_resume_from_abort’ [-Wmissing-prototypes]

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/isci/remote_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index c3f540b556895..b1276f7e49c89 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1384,7 +1384,7 @@ static bool isci_remote_device_test_resume_done(
 	return done;
 }
 
-void isci_remote_device_wait_for_resume_from_abort(
+static void isci_remote_device_wait_for_resume_from_abort(
 	struct isci_host *ihost,
 	struct isci_remote_device *idev)
 {
-- 
2.27.0

