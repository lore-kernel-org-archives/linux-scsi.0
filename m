Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574ADFA3741
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 22:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJaWrn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiJaWrl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 18:47:41 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345DD12AD5
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:47:41 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso17294356pjc.0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:47:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wpQNpAAQ8YixFsd/ngTubko95V54wjZD2sXfGnRkK1g=;
        b=fs9mT8WkU9WxSH4Y7KQSrRaOL9/+nxhfeAQhOVPms/XLCdIdp59ujHxAFfPNr25STI
         FaEQN0xMR3y8LbPAyy9f3eMvV6WLQd/+ViQ9YhseShdErPxN8AQYmH+QcyxZAHUgTImM
         nFK5mkdvMK8qYi9Z8pYlDaqbixhXpADFxbsDMwHBoNGTFBCzuxmeMuQuAoT5bqNeNcCF
         ou5pgw3H5B4maH7j+cxWoAtyHcb6oyfPuVQYoszn83rZ5/JU6fk7YoD7qsroRAW7easP
         YLwfiYQIwfHEZdaEfqBNyniQ67I9jUr2lLz7uSOxgAjofufsxKMHyGJ9JRi4NtCXmw7k
         tUPw==
X-Gm-Message-State: ACrzQf3Kn/5IqbSns3B3noe4+hc4NJ1//EazpWyExI0HfSgbTdZD6uRj
        Lgrf6R4KLSQKKJyL19Un7iE=
X-Google-Smtp-Source: AMsMyM53U0ugriyM+yVD/i9Cs5fRb8p8g+vk9ZlXmRVTTN2XsHSMLeAMnCxKcF440A1J9LkDaTDCNQ==
X-Received: by 2002:a17:902:b28c:b0:186:708e:6ed7 with SMTP id u12-20020a170902b28c00b00186708e6ed7mr16375617plr.98.1667256460549;
        Mon, 31 Oct 2022 15:47:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8574:e82f:b860:3ad0])
        by smtp.gmail.com with ESMTPSA id x6-20020a626306000000b00565c8634e55sm5096019pfb.135.2022.10.31.15.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 15:47:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] Call scsi_device_put() from non-atomic context
Date:   Mon, 31 Oct 2022 15:47:24 -0700
Message-Id: <20221031224728.2607760-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

As reported by Dan Carpenter, a recent change may cause scsi_device_put() to
sleep while a few callers remain that call scsi_device_put() from atomic
context. This patch series converts those callers. Please consider this patch
series for the 6.0 kernel.

Thanks,

Bart.

Bart Van Assche (4):
  scsi: alua: Move a scsi_device_put() call out of alua_check_vpd()
  scsi: alua: Move a scsi_device_put() call out of
    alua_rtpg_select_sdev()
  scsi: bfa: Convert bfad_reset_sdev_bflags() from a macro into a
    function
  scsi: bfa: Rework bfad_reset_sdev_bflags()

 drivers/scsi/bfa/bfad_bsg.c                | 29 ++++++++++
 drivers/scsi/bfa/bfad_im.h                 | 26 ---------
 drivers/scsi/device_handler/scsi_dh_alua.c | 61 ++++++++++++++--------
 3 files changed, 68 insertions(+), 48 deletions(-)

