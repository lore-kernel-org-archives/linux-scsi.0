Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F60C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 03:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D623610CE
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 03:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbhDPDia (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 23:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236943AbhDPDi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 23:38:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A6BC061756
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 20:38:03 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so9013333pja.5
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 20:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=9YrdWgC2SFRBEtg49JT1X0HhBm78LmIvkwcHdeoziQA=;
        b=JsZPk/tojGvPw0Ly046RGV1Ws4CtLQ7QucqbfbuT0QIcjjs9f5EjQKArpdXFi8hV+i
         a/xGS5MYSXm8kFeM7OU0YAiCP5EF42/t3QDKFqKYMqE7CNc6DVe334Sjfq8ljFaVnOhA
         yf+RzOEKovd5lAAM5XshlojbIL+qcrj523XzvTtBSUKintg12FziDbtkEHu2GzzsXlf7
         uVPPW5nksO89xPiyzvUymSiF7PSFTUfo84eVZjd4MFPQuj6aczNTpnOxDgw1jejTyS/5
         4UvwsKfSOIUv02IIi1iTIn0s9/Yhrp9FV+d4WQTMKXdB2FCkNb7E8Gc6Lb3UF+eT1c7r
         Aabw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=9YrdWgC2SFRBEtg49JT1X0HhBm78LmIvkwcHdeoziQA=;
        b=gYPlmLyNelpmRw2o8vaYqqI0ZLhjRMDM2MfopFQeA/0DQkD9Jai6zNqcH+vGCVB/4v
         4Ng/tY/q9+TOQgVIhfABIus0F9VkHyK1+UqSDH//976AwFjIK8JJWjfoj5MEP9mlvbmb
         0JEivkkWqj0LvUoIdL9A8SZNdgzurUlE5QTvodMrgFXd1vJO1nrnsugFqNl2wQmzBjfD
         q8Y673/6SM+7UIED1pjG+U/3hNaL/Mp0tue9xoOSzqJpjQIhe91i+QChq5k2b8TmgtpC
         USuB+0/hA5HgUFN/wrlkOTqguJpsmhJmLuk8cxxUOT0Yr7GsNw56HHMej/Z2rlD0SR/F
         03eA==
X-Gm-Message-State: AOAM530DmakNnKmrrS304EkYJQPRnY7sPOUtc1ppZFuCm9GuzeD9BFeK
        qss6LJq6b+kAJv/SD1dbx5LwPg==
X-Google-Smtp-Source: ABdhPJzwuHP98jFLc7VDRXgO6t852ZA7yohI3crumgP2QljiMkwxyYJ+NbQNftjPqjT4gd92JCL+Zg==
X-Received: by 2002:a17:90b:1647:: with SMTP id il7mr6979963pjb.132.1618544283266;
        Thu, 15 Apr 2021 20:38:03 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id 14sm3308259pfl.1.2021.04.15.20.38.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Apr 2021 20:38:02 -0700 (PDT)
Message-ID: <0b1571666e97dd121da59b2861d389550ab86597.camel@areca.com.tw>
Subject: [PATCH 0/2] scsi: arcmsr: fix SCSI command timeout on ARC-1886
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Fri, 16 Apr 2021 11:38:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is against to mkp's 5.13/scsi-staging.

This patch fixed the wrong cdb payload report to IOP, that cause scsi command
timeout when scatter-gather count is large than some number.
---


