Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 532E9C433E2
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25712206F2
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DpCtwgTP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgIDEmf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgIDEme (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 00:42:34 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C8EC061244
        for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2020 21:42:33 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id lo4so6837435ejb.8
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 21:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=H0J+XAKI68OBxXaao+phIHgjbc+3THLPO9QuRRNKbwM=;
        b=DpCtwgTPc2VHYQHJQVFNf6200UmrcQwKYK+vXrZori0qvhNUKBMFClD2M5H7lQc338
         v+rB3KpFy2XrCgUvQQNof8rW/hKYv4RmJ7PKwpZyVWGTUz4VwauTIB0/oURzhsC6rVO4
         QmcGg5lrqulklyxMfia1T/GDJKv2U3jIdEfAznMsRNm6GsDugTxN660L8hGUO/qdizln
         D0xBieYTBE66ruZCJSRQ6BbMPzxWH/q11OmwBaHE/1I2gYZc9DW4ewncYVC/L50Zx7DK
         bQeI7vG02ciB9D8f9j2Y7t/XSXyLP47GThfaSKOT3YjoXNqHAFd8gBgmrb5cq1Hv3owa
         vLJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=H0J+XAKI68OBxXaao+phIHgjbc+3THLPO9QuRRNKbwM=;
        b=rpmR2Rb3qQWYUmPO1IN6uS8SSNLwhAFEbNRcqJt+x3nst8/YrDD5/kCCuelmjbUQz+
         Kdvfm7PxZ+uGoNx30ckGk4h6Nb+3aMgx6mUbzYTe+taVQBerj43fttHHUzBq7K8Hzf7S
         /qIYCZCvQX3CZ3KR1RWUp1cTmYUfWdBafLqYgIdnSLjnev5vLuOFei1crANoDtE0Uv3G
         pwx/nxt9n1EE1N9t9yVYQtAwY6GtDCfGrEwwGQtSfFQLLnR2tIbtHblJfuCDSUy1Znpq
         u0YxmBF1rVx6yh5ExsGaOLu7Kl3q7C0RWIlcPj9xPqHApI1uhVfJ5TVa9Krvh34gUeON
         aDkQ==
X-Gm-Message-State: AOAM530wts9grXtTvGfnAqLIMDC4CaR3Ub6uVrCFEXFeuHrOS7L7UzCf
        G+PoyOXN1CY7PxRkYKT1ZjAZx+hwmhmlNqoj16v44zkKoVE=
X-Google-Smtp-Source: ABdhPJy9BHh4tf+THyGX00yZEd3kx7JClSpnwLh4qYL7vWrDC6/AfvOAnsbSi8m7hgxQazoob2DoThaQDj7/BqwEAOw=
X-Received: by 2002:a17:906:6b0b:: with SMTP id q11mr5644790ejr.412.1599194552145;
 Thu, 03 Sep 2020 21:42:32 -0700 (PDT)
MIME-Version: 1.0
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Fri, 4 Sep 2020 12:42:21 +0800
Message-ID: <CAGnHSEnhpaqcF8gWG9udrq_vwYWh2vOGL1VgN3=E=1OVjenVUQ@mail.gmail.com>
Subject: About BLKSECTGET in sg
To:     linux-scsi@vger.kernel.org, dgilbert@interlog.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Is BLKSECTGET in sg intentionally kept "broken" (i.e. it gives out
max_sectors in bytes) or is it just a miss? I'm just wondering if I
should send a patch to fix it (and implement BLKSSZGET).

Also, shouldn't max_sectors_bytes() in both drivers/scsi/sg.c and
block/scsi_ioctl.c use queue_logical_block_size() instead?

Regards,
Tom
