Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D90EC47080
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 21:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35B966117A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 21:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhEWVPv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 17:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhEWVPv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 17:15:51 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0224CC061574;
        Sun, 23 May 2021 14:14:24 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id lg14so38558228ejb.9;
        Sun, 23 May 2021 14:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cp+lXxuzy3/NDKR9R1LMBixskQkuBqRKdw9LribBJpg=;
        b=hrNHUn+d/oHsQ/RaKMFzrRpiCVE5AXSEZDDXafFDkU+fmo2cC0N1ElC5aprM3dz6lY
         3Hful9f7Gu3m8cKCFG+xkLVTcvgCj9lPesAeUppSSy9HCFX+MOdZv+RlfAYYBXx4fLAx
         uOuPDh5xPZWLhxtjuRnLKdtCx4G3EM59NGSLo10tJYSpoaPvuGdqgAfMLTWLOJ6ZACOA
         BtPQRLhcpwhReNKg9U4IS7RpLS4pXJAePdQXCqezRChQrHXScTjmsAaxaLQyvWBdngGo
         zMrLRGLk7owu5ugvXSt/tbjS6Exe/+q0AiecemQPUYxnyXdilSE0klC4en5GVKHVgg/7
         DUrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cp+lXxuzy3/NDKR9R1LMBixskQkuBqRKdw9LribBJpg=;
        b=nfd1ySfxfcfpm4AHefhBAnof9dZ6AdlURyw2Zzt2ENM1fPJrv3QEcf0FcOhAG7ps6j
         1KKXhLO+tG3g6DQ3xBtOEq28c5uhzbVEuR+9+zLn1XOYr+OxCJBD1+lhUwcxSxvFFo7l
         NZR2p+b/ls+ixe5Pz/+pvnHbql4cK5aQuh2NUx7besig5iAGl3hRTcnD/y0B+8LKeQNG
         w2DIkQtohe293/Ukria+z3vdeaU9w2ddsL/iDLPiWMR6DIKx1pt+tRRHVQIFX9AsqUSh
         ADAYGEqaYR+XsYCV/91rqkOnW9WwRCKWX9eSbyNlFrmRTFUW6JcqI3i2tMn0cygXhSvW
         LVgQ==
X-Gm-Message-State: AOAM532nRH8DL9Fsv23pLBUdsepIAQ4ZPlWy1229laLHJ3Mw6oJqU1r6
        NHRIWG0KoSyPcGEZ2frSEGY=
X-Google-Smtp-Source: ABdhPJw07QDA+ryt4ihtMiG1NiDv345KUPnaez9mg0W/dFdoIyWLYjElgnCV2S71oRm6gvJfyFZ7Sw==
X-Received: by 2002:a17:907:7749:: with SMTP id kx9mr20415625ejc.90.1621804462668;
        Sun, 23 May 2021 14:14:22 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.gmail.com with ESMTPSA id t6sm2444ejd.123.2021.05.23.14.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 14:14:22 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/3] Three minor changes for UFS
Date:   Sun, 23 May 2021 23:14:06 +0200
Message-Id: <20210523211409.210304-1-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

*** BLURB HERE ***

Bean Huo (3):
  scsi: ufs: Let UPIU completion trace print RSP UPIU
  scsi: ufs: Let command trace only for the cmd != null case
  scsi: ufs: Use UPIU query trace in devman_upiu_cmd

 drivers/scsi/ufs/ufshcd.c | 64 +++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

-- 
2.25.1

