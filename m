Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CCB7C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 04:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EBDE60EC0
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 04:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhGaEIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Jul 2021 00:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhGaEIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Jul 2021 00:08:01 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C211C06175F;
        Fri, 30 Jul 2021 21:07:55 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t21so13344744plr.13;
        Fri, 30 Jul 2021 21:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=RQqVtiTyJeVcxA5GWy4zdmGjVoOz7+UKLkP+vxeNZcI=;
        b=X9VUBmS4dSCy7vQuiVxdMVBhk3M9KHwJpVBaQui+u/OLoINYLsCtwTRtDPVBV4iMUu
         zOFxds5pM5880egn83T1HsbcVWgb/Hkye4rsB7QbsOD0q6gRku+zkQkQKNgL7Zp2TDZG
         TdYFfNjssKCYn8vdPzEqfXS/U9/YpMcdw59QFmL0Sc5z4lNmHqSFtb0sjJL4yLciq2xT
         9SBr4EZKczyLjX9Mvt6Xg1720F86MmftAiFOc/bNLXggOAtUWwC6oLZl9L6ah44D5NZ4
         rbv+P1at9PiFT5P6BCj0c783AAt5mCVZ2sBxm6ehMfP5RWru4VPIs67GSdis3h22Y1PH
         URFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=RQqVtiTyJeVcxA5GWy4zdmGjVoOz7+UKLkP+vxeNZcI=;
        b=fHtEjGmyHDsA5ZYX8x/cNtypU7b7UgRjQICD+6OAbA3I14EP3/W5aS61Z7kQDYw2d4
         SePl1QBw/fAoq204Rb4iaVKHMMSWT060y26Qxb+KbdSVU1ZE138M2AlborH/MH57sT0c
         Ks1d1CegxT9K7cDFQQBy2oZDvqPrmgPxrDjiQVvEN6wgT8EoSPfqHiXYQC2yyl0W2IG/
         980hmu/+eZ3tKsPTy6oRCM+gm7FmdQRArqfKpIIkDUOS/N4C3yKPhNi0UbCNh7nSiZ7O
         yH+VVKBNUcBOXigGOKOStuWdVcEBwDEK+oyu0VLFLdbieplGGcWYiuMsI8sos3I1yL7R
         oiig==
X-Gm-Message-State: AOAM533HKOWe0hyopB0zk1x4xOVraNlOs8S/oF3FSczZgx9EZAR4U4a2
        dSWi0uMRP//OoQdO2nwQ670=
X-Google-Smtp-Source: ABdhPJy7nHp2uIiFbhYyUTaREuf9WYqfpauLBC4RMP59sz98I3o57yNHPAzFn/GxTpq/YoQdy2eWZQ==
X-Received: by 2002:a17:90a:a78d:: with SMTP id f13mr6300392pjq.206.1627704474833;
        Fri, 30 Jul 2021 21:07:54 -0700 (PDT)
Received: from [10.106.0.50] ([45.135.186.29])
        by smtp.gmail.com with ESMTPSA id e8sm3973146pfm.218.2021.07.30.21.07.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 21:07:54 -0700 (PDT)
To:     yokota@netlab.is.tsukuba.ac.jp, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com
From:   Li Tuo <islituo@gmail.com>
Subject: [BUG] scsi: pcmcia: nsp_cs: possible null-pointer dereference in
 nsp_cs_config()
Message-ID: <688ece87-00f9-7a54-cd58-3c6b9b416cb4@gmail.com>
Date:   Sat, 31 Jul 2021 12:07:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

Our static analysis tool finds a possible null-pointer dereference in 
the pcmcia driver in Linux 5.14.0-rc3:

The variable link->resource[0] is checked in:
1599:    if (link->resource[0])

This indicates that link->resource[0] can be NULL.
But it is dereferenced in:
1610:    data->BaseAddress = link->resource[0]->start;

I am not quite sure whether this possible null-pointer dereference is 
real and how to fix it if it is real.
Any feedback would be appreciated, thanks!

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>

Best wishes,
Tuo Li
