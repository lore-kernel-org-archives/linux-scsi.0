Return-Path: <SRS0=xWhZ=DN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8163FC41604
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 07:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 383E020760
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 07:20:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="F4WNRrKB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgJFHUX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 03:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJFHUW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 03:20:22 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBB5C061755
        for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2020 00:20:22 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id q123so8514712pfb.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2020 00:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=rxAgGOnSp5xOsvFWw6q8lz/Ct2uhAJkdx7TguqBlof8=;
        b=F4WNRrKBKMcxU+n0nc4dkanncDiXPL/ee8GnugHv1N24B0UhktyHf/9Iu413xLq5OI
         6VELsmsoRfB9B1ijm+X/74ew8aD/Tdm9ahgm4sHvORS8XjaPn3Q+3RFpfGINGQWaDT+8
         anAbUBW5CWTSrodFiXxo9FT867C7JW1jd6d5628LVpUje4qyaEE+g9DlOcX4M7fEId+v
         W8Z53x3vdgJelEeyn1S++eSHd6zh/Gt+x8cu9Il+7txxQ30oECUzMB2c+YusC3P0hQYv
         z+jLWgSkio71KxMZ4/uXvRuStv+fY3Jc/ZdR7KWvJwHoGknAlFcnmVZa+MCU7h3czH1/
         kYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=rxAgGOnSp5xOsvFWw6q8lz/Ct2uhAJkdx7TguqBlof8=;
        b=n2x1Exnwy49b44iJW/euZ4nImsNALu+g6ZNu7Xzq0TVfaRjnwyfpKASUjwfS0KlYO9
         +t6eUZornlQJV9tpPGr3PTkbCGvpXDjepnhTcRgk/ngMJTpzQEyiJJhzVPtrVjMwpN9s
         KlN9oiDbu29JuqBAA8VDKuTTbiXllCLhNoDeKPBjqgtfgJuXvBba6Q+t7o1xd89FSf6C
         lpLzMil80GVLgezAZ3jaVFZKq9IX9IVKr8oexkObiDY+HRf1mkknB85zSx7Lxhysc6lM
         nCtipSGKHySjITJ9+EyZ51YYRl4rX4/LyYi5Z2/pR6N5snRXUwbLQ8jsl7C7/VvvNQGC
         SA8w==
X-Gm-Message-State: AOAM533/7sov8ZK3yJxGgWEWQHPNZRKE4RHLWHEpdVqFNJqTex5rqRy7
        9joSj86d/0Pk8I3mxwWxB21OrJ669rJjQA==
X-Google-Smtp-Source: ABdhPJwFixwHBWx7FZbq4mDm9X1o+f9+TAKkQxezHJdX1AtJAI7MPnznxBsp8EZFQ4Y8Rt+/Fs+n5A==
X-Received: by 2002:aa7:9201:0:b029:13e:d13d:a10c with SMTP id 1-20020aa792010000b029013ed13da10cmr3081378pfo.40.1601968822143;
        Tue, 06 Oct 2020 00:20:22 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id j6sm2238910pfi.129.2020.10.06.00.20.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2020 00:20:21 -0700 (PDT)
Message-ID: <c065aef85fd477f3d3e17b8d095d563226e568dd.camel@areca.com.tw>
Subject: [PATCH 0/1] scsi: arcmsr: fix warning: right shift count >= width
 of type
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     kbuild test robot <lkp@intel.com>
Date:   Tue, 06 Oct 2020 15:20:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is against to mkp's 5.10/scsi-staging.

1. fix warning: right shift count >= width of type.
---

