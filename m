Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 056EBC49EA5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 23:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA7A06120D
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 23:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhFXXc0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 19:32:26 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:37588 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhFXXc0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 19:32:26 -0400
Received: by mail-pl1-f173.google.com with SMTP id y21so3778463plb.4
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2021 16:30:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aHhqg3xXDnOND00EozhaNn4eU5n8UO+yo7EreuldJRA=;
        b=pTOUXNNZ3uWISo8KWr/9pUKK36gsFtIoroP/9xBZIaki46xSzOqDb/Xr9GOjTNr56r
         JN/H1HSaPQ0/DnIBl1z0IsnVXHRopVypITiQLiYUikYIMFopXruqs/UzN8lFNOoweFUH
         Nj7zOi5wl90vRGY7Zv9qeGnvCUY8hnujRaQFvHz4lubmkEa/S/bYEY4/+FPX/bDREXMA
         PU/6gQEcGkgOYjaRmbEb/c7pD653VlXHlcN34EtWQqOzcrOQCh+rI0g3CKthmPHDzbqa
         QWhcm4K0VZucM+TygprT46B3445TNc3W6dc2qKDgNbQIDInzM8oalmdqpBUu5zREqYux
         Xkgw==
X-Gm-Message-State: AOAM532SwrpvFhKbQzdU9zn8naUNq0yZEKLickX0xCOmyAcpmmqHQbtU
        ZI2SOqCUY37ygQ3KIwf6rUw=
X-Google-Smtp-Source: ABdhPJwzjlhewRr1m30fs0LluCEYvfZOEHs0OR5GrCpCRyz+NlxD30wbRSwKbmtjme5ZaWC+RHMN7g==
X-Received: by 2002:a17:90b:a4e:: with SMTP id gw14mr15289425pjb.223.1624577405192;
        Thu, 24 Jun 2021 16:30:05 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id j16sm3599908pgh.69.2021.06.24.16.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 16:30:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/3] UFS patches for Linux kernel v5.14
Date:   Thu, 24 Jun 2021 16:29:54 -0700
Message-Id: <20210624232957.6805-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Martin,

The three patches in this series are intended for kernel v5.14. These
patches have been compile tested only but should be easy to review.

Thanks,

Bart.

Changes compared to v1:
- Dropped patches 3 and 4.
- Added a new patch at the start of this series that reduces code duplication
  in the runtime power managment implementation.

Bart Van Assche (3):
  ufs: Reduce code duplication in the runtime power managment
    implementation
  ufs: Rename the second ufshcd_probe_hba() argument
  ufs: Remove ufshcd_valid_tag()

 drivers/scsi/ufs/tc-dwc-g210-pci.c | 34 ++----------
 drivers/scsi/ufs/ufshcd-pci.c      | 48 +----------------
 drivers/scsi/ufs/ufshcd-pltfrm.c   | 47 -----------------
 drivers/scsi/ufs/ufshcd.c          | 83 ++++++++++--------------------
 drivers/scsi/ufs/ufshcd.h          |  9 ++--
 5 files changed, 36 insertions(+), 185 deletions(-)

