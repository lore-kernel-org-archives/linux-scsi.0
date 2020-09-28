Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD35FC4727F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 10:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5240921775
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 10:19:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="u3OdICsH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgI1KT2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 06:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgI1KT2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 06:19:28 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1CAC0613CE
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2020 03:19:27 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s31so450682pga.7
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2020 03:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=aqKuja4n+cNWBnmmn/RpGXVE0nrfXb2IK4hEeeWWG3Y=;
        b=u3OdICsH6T+Q2k9FhEsUWwguIfe5wIrZTSCmxRqj7qmFewDfKqeED4sIS9TmvdrLhA
         hzYnT0C6dTWsHXgKFhc3vTQ0IiJQZ3wam4yLxxtGSAxWq/+L8NURYogXmVwRsQceq4RQ
         Kwa7P+M4lx14ekLnBBZe7qM2hqyTIH52nEVDruqJXFjgtY/N00gIh7RCAbFGkH0jXFF+
         bMsPorGtgaQWoiIg5cbxG3PvHX6Xqaub3T8+GQoDcypfP8lVXnlK8hUELPW0F3eK2Vsr
         4l/vvxWL/REvFBVQk2caFYbMatO40wN7xt5qOZmikK+YXBxZRvcReQhpc7WOCKanhdV3
         Grag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=aqKuja4n+cNWBnmmn/RpGXVE0nrfXb2IK4hEeeWWG3Y=;
        b=PKa/TQRdpmf1n20xpohfNW82g0c4mXfCxrNovVMBY/ANtYA6URfiZoVPQs3YoSCPTb
         2LGhkUTEvyZ80w/njP32jGlnG1EGIEvqCJdyVFFiLWoeiCXMjS5qm85tDzYFBMd3waud
         d95qeIPRYjVF17zt9S87A0sX6NRUwr3QUo6xBBeDCOptyi6kq6XibfND/YlB6yLebMuC
         Dz4YXn+5RrYZnrkrg0lxvt3tOzkM8W+5AVbmcP9DLBshPx4IcmmphDrxAOmydFsYowzU
         1IcZEl0e/RW33rzkn2KMlj2HS5BKfiQ5qCusMdPAmdTjl2tldhHR8LupWaKpKAlRBuqh
         VOxQ==
X-Gm-Message-State: AOAM5327uTNqYDjLUH8Rz40qNTaKFvuNiKYlSSzRwX1eL0fEyhmYNo1q
        p2iPWvx//YtzX/p3OQCnxGxBdA==
X-Google-Smtp-Source: ABdhPJxQK0ydTcY4tRB0S+K0h+O/S+YYo0HjyzgsduohiEaw0Q2P+jTFVVoeH8SlVqH0OZIP+4bomQ==
X-Received: by 2002:a63:b44f:: with SMTP id n15mr637920pgu.282.1601288367243;
        Mon, 28 Sep 2020 03:19:27 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id w203sm1292653pff.0.2020.09.28.03.19.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2020 03:19:26 -0700 (PDT)
Message-ID: <0fcd9588bb87f47856316677e8bb495f14fcb597.camel@areca.com.tw>
Subject: [PATCH 0/4] scsi: arcmsr: Fix timer stop and support new adapter
 ARC-1886 series
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     dan.carpenter@oracle.com, hch@infradead.org,
        Colin King <colin.king@canonical.com>
Date:   Mon, 28 Sep 2020 18:19:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series are against to mkp's 5.10/scsi-queue.

1. Remove unnecessary syntax.
2. Fix device hot-plug monitoring timer stop.
3. Add supporting ARC-1886 series Raid controllers.
4. Update driver version to v1.50.00.02-20200819.
---

