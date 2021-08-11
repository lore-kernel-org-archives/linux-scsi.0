Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E9DC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Aug 2021 13:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5BF361008
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Aug 2021 13:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhHKNo5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Aug 2021 09:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhHKNo5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Aug 2021 09:44:57 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528AAC061765;
        Wed, 11 Aug 2021 06:44:33 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so9578876pji.5;
        Wed, 11 Aug 2021 06:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=eCt2wsyZd2oXWNANaRGNRd49CscrG4STsqKNCVrAZMc=;
        b=KR0jaHtdFKt/MKcdHAdLGTfpT584saeRGF0HariciM+9jXidZbnTVW7h2iiIW4mQvD
         bxTxJv5DL9IvTx4GYCDrsGl553X7/w3//Yre7y63maWBnvt5wcs/I5sFvpHogn6ozEy7
         Md6WPuxg6p3WKauy+FuYyzXMxMhwFqiv71HmmhF5KICx43oKJoZ62gNBFxR45Is/eAk5
         oE/KRoiaUfYnnwrJ3mZeXDZVz6sc5QtFe9Dge1YoHSZKxIILNjx4+DcVQpZSJkV9ClQo
         QQK/FFwRKglrtv7YX6Ya60COo0dxOcSreg0I+Bke3eIZ/S4k0tc9llTKspBw1pF0MVRa
         ILhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=eCt2wsyZd2oXWNANaRGNRd49CscrG4STsqKNCVrAZMc=;
        b=L+aukZwcbSYg2Qm0wUV+16iFbABWFUOWX3wvpTdHpSl91eRLMko5A6dWRF0ZYCZHtZ
         WXhO6Q2RFXsbnjE38p80acylgUDy489LhHxx+PFudwcGatXQDGUGKHQvyhbq5YVJ6+vg
         roCD4Opmgk8Z5lm+5s2ynZUopqsZvaaOkrn5e7vsZrp8s1k718gSPQWTUlXizhE17rmh
         z2enW6YBDPHqzBxzScjfMys3gWzMBV8oV88N17Ggn3vDwHsfvmCxUwH6oMe1GXNy+FSs
         s0FEhbljzqmtL72wXeqqpLbKz3BGQm0mYGnMGItQ/ZM0wPZdUrVRHWY6ww2oJ34V4XEj
         34dw==
X-Gm-Message-State: AOAM532Yn6npiwgTH7/P6IHqhFzqIBfedAS1p92ys+WuPzumCB9Nnosa
        n3A6nfF/dqndbrcW+Cwknf4=
X-Google-Smtp-Source: ABdhPJz2sWNeOQxA0VhWcX8bUiL7AMEKuDWyy6xIy6ATye9lPxBjS9yXZfWuIMOKGT8KoX/JMFwrsQ==
X-Received: by 2002:a63:f004:: with SMTP id k4mr23341pgh.390.1628689472821;
        Wed, 11 Aug 2021 06:44:32 -0700 (PDT)
Received: from [10.178.0.42] ([85.203.23.37])
        by smtp.gmail.com with ESMTPSA id q4sm9160247pga.48.2021.08.11.06.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 06:44:32 -0700 (PDT)
To:     njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "baijiaju1990@gmail.com" <baijiaju1990@gmail.com>
From:   Tuo Li <islituo@gmail.com>
Subject: [BUG] scsi: qla4xxx: possible double lock in qla4_82xx_wr_32()
Message-ID: <50b8ad40-b272-d601-889e-9ef336bf9170@gmail.com>
Date:   Wed, 11 Aug 2021 21:44:29 +0800
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

Our static analysis tool finds a possible double lock in ql4_nx.c in 
Linux 5.14.0-rc3:

ha->hw_lock is first locked in:
418:    write_lock_irqsave(&ha->hw_lock, flags);

And then the function qla4_82xx_crb_win_lock() is called:
419:    qla4_82xx_crb_win_lock(ha);

In this function, the function qla4_82xx_rd_32() is called:
389:    done = qla4_82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM7_LOCK));

In this function, ha->hw_lock is locked again:
442:    write_lock_irqsave(&ha->hw_lock, flags);

I am not quite sure whether this possible double lock is real and how to 
fix it if it is real.
Any feedback would be appreciated, thanks!

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>

Best wishes,
Tuo Li
