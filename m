Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29201C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 04:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E452D208C7
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 04:32:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="D6l/DmN3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgJGEcg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 00:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbgJGEcf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 00:32:35 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B298C061755
        for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2020 21:32:34 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x22so594392pfo.12
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2020 21:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=M52oZrMi9dCtDbxAjDKC3w2Xn750c74KunzKHY+WZkY=;
        b=D6l/DmN3gqgifcj7qXftu2zdBTUAituYO2V5XfTpjzryg5w420y1a83h5y0uiTm91R
         I/zZGmrEGGulyFEVEaqwz9eY13sT50T0ZKEfAp2K3Bj2PMwLtzkbbnXIaI2Bsv4fGQYK
         3MyXZfGFnDqu2KPzxklsTZhER7enYE8ZvjMzDMXL4lUQ/YHQO/7Buc5AJ6cJ380bkTb9
         EXW2wIV8nOdOo1/saWYiNd+1da+WnSGOO9AB819PEAAiUax6sZe36Hiojo9O6jD9qNAa
         HpKW57GQi0pdwZRPl2ODezeeNfqXSlO4xQy4KDu+SVh7oLusj7aM8+e0qw9QDfWfpu49
         PCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=M52oZrMi9dCtDbxAjDKC3w2Xn750c74KunzKHY+WZkY=;
        b=OZNfPZuiaxcOJNkO7VBbbz8tFGgmblmpDiKYUl7WILcWa670QloyEdxP0tq07vkENO
         xmQk1nWKSZ23RVFWFMbeDCGoLdh9iFbNuTtiG//iiY4o04sirFLbug5/02QZ5p0E5YLu
         S1KrijSlWn+/zniGBpvReSNS6pe+CBZMPVcFZFvSAbYacrgn/byFQVkLcU0SFdwil+aZ
         6EhJ2Tn6PB9MdMAUpisOu8thX1sM/UO+IHr9rKZcqS03CRQUI94vpuvW9T+cu3meEEj3
         9HMYowBvbzgNUCDnzidYWJNWeMd5N5vIFFam8EDpRDzSiemr7cokBk9nsRPqWY8BDKKz
         aAPA==
X-Gm-Message-State: AOAM533VHaNA6u8uO1kXD3Yx+vPjar8S9YorNqPmw/hYcREDw8hej+bt
        NIfFp5XPgiUU3CYJKNt8nebd6cWyn5UcRw==
X-Google-Smtp-Source: ABdhPJzQT89WT7rRYWfnRKbt17fvHcbha1TTHMEjfz7leHTYTUS8ugTbfIbiz86KfnNlKO4T78vYtg==
X-Received: by 2002:a63:f342:: with SMTP id t2mr1366738pgj.313.1602045154069;
        Tue, 06 Oct 2020 21:32:34 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id f18sm960710pfe.153.2020.10.06.21.32.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2020 21:32:33 -0700 (PDT)
Message-ID: <281cbfc346d55de4bd796916fa5779e06a833040.camel@areca.com.tw>
Subject: [PATCH v2 0/2] scsi: arcmsr: fix warning: right shift count >=
 width of type
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     kbuild test robot <lkp@intel.com>
Date:   Wed, 07 Oct 2020 12:32:32 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is against to mkp's 5.10/scsi-staging.

1. fix warning: right shift count >= width of type.
2. use round_up() instead of logical operation.
---


