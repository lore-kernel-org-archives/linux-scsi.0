Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0E5C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 06:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F097861184
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 06:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhETGuU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 02:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhETGuT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 02:50:19 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F65BC06175F
        for <linux-scsi@vger.kernel.org>; Wed, 19 May 2021 23:48:57 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id kr9so547256pjb.5
        for <linux-scsi@vger.kernel.org>; Wed, 19 May 2021 23:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=ah9WuIwTVXGma0griLbvLlZl0iobmLFJcW76a34Yh88=;
        b=lBApfxFR50L7SAkrcK7AbLaJRoh9UBHJA+sNi5rrpWwPa618zWTCeInefEEgx/OOL+
         cvTOwaK5LtZqkAaY+l6HTpH/cV8bvOGIvKnppo/ui611+4gOoXTcYFT9zpQNsphdNMt3
         WlUjfD1OHKa/xngtztNx2R3CvTkSpJ6vkAw1Nbt2KQz/Zk38hCVbCbyj/HdwywqF7Qkr
         GMow97u+nEkNmAL31hvaBzW+r3vx56kYMpvQ0WE2hkmiGl36lbRXBkKW/dLEYF5Shzit
         puseaBdpOvmAcCWCdvJ3WVnvZvVz1DGMs09vUruoYyiO5TQnxYbJO5oX9EDvBCRLQKWg
         gkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=ah9WuIwTVXGma0griLbvLlZl0iobmLFJcW76a34Yh88=;
        b=invn03lDhtIWBIROtaiNYesDnJCGlafvc4i3vKaipnOKdaXnP28p9To/R6Aaw/l/U1
         p3qHaNBu3rInFV0S/o1ijLj/kukP+N7ByspyO1jmfzrBZYLfrsva3N2YIsGnvqbKR8N8
         mPXaFfRijhQIUo1ehvzergha2qztEX/d+c/TF/Uf8ZhP8yV4/KyJR3hYxfX5HwN/2mpB
         sAPdIYwqT86t7CC8spOuuTfiYAmk3qh9xpSpq1I2BCiAMVHHm5ApFr5nOvjG/tw9pSY7
         WUaPqWmKCw3JgicnvChIw++MzWP4j3DI3GF0lW5cB73gMMLw1IOTbMpIstif/os+ZWFL
         wQTA==
X-Gm-Message-State: AOAM53208qISlaSMSHX/7GTb1WSW/udb3Oc0/zihlTDmyqFTmzJpgpRI
        D2rTImYDNobo4s1/Jz+qxt2+/g==
X-Google-Smtp-Source: ABdhPJx86oszuYO3f5wkZd+NreLIoQY6r7ZAmf4Q5WL7WKAVmQDXITZUJyS300XIHajmOxJomhTZzQ==
X-Received: by 2002:a17:902:7787:b029:f0:a7c0:f9e5 with SMTP id o7-20020a1709027787b02900f0a7c0f9e5mr4021671pll.5.1621493336697;
        Wed, 19 May 2021 23:48:56 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id s2sm3426348pjz.41.2021.05.19.23.48.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 May 2021 23:48:56 -0700 (PDT)
Message-ID: <61f706e52872255ba4a59613fd6a8b59678ff1e0.camel@areca.com.tw>
Subject: [PATCH 0/2] scsi: arcmsr: fix doorbell status may arrived late on
 ARC-1886
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Thu, 20 May 2021 14:48:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is against to mkp's 5.14/scsi-queue.

This patch fix the doorbell status coming from IOP may late.
The doorbell status value should not be 0.
---


