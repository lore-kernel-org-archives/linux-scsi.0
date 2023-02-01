Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D529C636D7
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Feb 2023 18:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbjBASGv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Feb 2023 13:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBASGr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2023 13:06:47 -0500
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F91B5B58E
        for <linux-scsi@vger.kernel.org>; Wed,  1 Feb 2023 10:06:47 -0800 (PST)
Received: by mail-pf1-f169.google.com with SMTP id cr11so11505186pfb.1
        for <linux-scsi@vger.kernel.org>; Wed, 01 Feb 2023 10:06:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iKY4LW1/Cl2/XYtJE0bXvt24eYOHqab5i4LELMw+uMI=;
        b=CcgEcKRp1qy5RHh7N8nzsK006lXsy2dIR3RYVJQPsDiePqMJvsIwgswMfrexRw3TQ0
         AJQYW1WULIfPh4p6R6iqum4AiSkBZLiw3IqlcsZqODNzvDlkQEsUCsswEsWhUU97ej8b
         FzgxXWgUmwhJmYCVWTIXXfXrPbCkBOtjHnrfN2ykhIWPXqk+Wshxh0QZwXC4QyH+dHn9
         9wSm8jgJyekAl8K9FmVIU27Jm3fdd8ZHMi5bKm8DSAwWwnwK3hSN12gIpphFec8fcSep
         u3RTt307913Y8xB5H+nuMgP15z5/pJ/SUgHmE/n6pbq/IH830vUuDkC8uv/SX+xmMo6M
         UiKg==
X-Gm-Message-State: AO0yUKWxeAo7FXUB/Uw5jvshHe7PEp963LrH9d73h3JFk4Nr0Fqz5hPp
        r9kmkRTyX0I2wT85CUiO7DU=
X-Google-Smtp-Source: AK7set/RXW8qKRyynpHfx7COAt4gj/HqZKschD/mYoblb/X7/3s9xJMsoP5/QICeawY73OTm7OcwFA==
X-Received: by 2002:a05:6a00:300b:b0:593:af12:9460 with SMTP id ay11-20020a056a00300b00b00593af129460mr2878956pfb.34.1675274806621;
        Wed, 01 Feb 2023 10:06:46 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f3cf:17ca:687:af15])
        by smtp.gmail.com with ESMTPSA id x13-20020aa78f0d000000b005825b8e0540sm7021264pfr.204.2023.02.01.10.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 10:06:45 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Use SYNCHRONIZE CACHE instead of FUA for UFS devices
Date:   Wed,  1 Feb 2023 10:06:35 -0800
Message-Id: <20230201180637.2102556-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Apparently UFS devices perform better when using SYNCHRONIZE CACHE instead of
FUA. Hence this patch series that makes the SCSI core submit a SYNCHRONIZE
CACHE command instead of setting the FUA bit for UFS devices. Please consider
this patch series for the next merge window.

Thanks,

Bart.

Asutosh Das (1):
  scsi: ufs: Use SYNCHRONIZE CACHE instead of FUA

Bart Van Assche (1):
  scsi: core: Introduce the BLIST_BROKEN_FUA flag

 drivers/scsi/scsi_scan.c    | 3 +++
 drivers/ufs/core/ufshcd.c   | 3 +++
 include/scsi/scsi_devinfo.h | 2 ++
 3 files changed, 8 insertions(+)

