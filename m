Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A96C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jun 2022 16:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344363AbiFOQoZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jun 2022 12:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244316AbiFOQoV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2022 12:44:21 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E1F2252D;
        Wed, 15 Jun 2022 09:44:19 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id o17so10887784pla.6;
        Wed, 15 Jun 2022 09:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tdRf9f++mZXtmPEhEjfIm1j3U3xYTZByZyIU4ArniOc=;
        b=XxT0S2+N7pS29ShTdW0xTdwdwATP5kLzAEO8dVQNwvGQd47mBaiPQ45A3Qoztg24Cm
         yZFNHJY0c9K0iahJOJIQWwqW5XoNaxJWVhTLS9uLvt1jNvrnvHu7nN905AxaSgOd39Z0
         7WoLCakexLr9aUNiOxlhKO93tpmyFbWUr9jpL1JyK3dXTNMIxGbphq1KfBlvROxGaFLa
         kTaLug9pBk0iuYMHL+ewPDwjfPvuE6dKNOPyFbPaRrsiaoZPI7s5N+8GphhfvKPPX1+T
         6y89JhJrjWn1p00r6DDu5pe4+ikNsXT/1gG09RMqSeMEZThVGbZMZeC9kqwjUU8UcDj+
         GuvQ==
X-Gm-Message-State: AJIora/4VETPE+97XV6Ut8z6Do3CoYr+FLrK92BScjWpnmhmMOVpNuiJ
        AbfjYKA2ELGXm2/tEJQmxCk=
X-Google-Smtp-Source: AGRyM1ueDDeJzheH+6xxWOLQ9qGtgWUGLv8fNJ7P27DvendO/0ji2AGZfpfFMCqajAGHQKULCkCJow==
X-Received: by 2002:a17:902:f608:b0:168:e92b:47e8 with SMTP id n8-20020a170902f60800b00168e92b47e8mr500761plg.115.1655311458607;
        Wed, 15 Jun 2022 09:44:18 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:36ac:cabd:84b2:80f6? ([2620:15c:211:201:36ac:cabd:84b2:80f6])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902eec600b001641a68f1c7sm9494972plb.273.2022.06.15.09.44.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 09:44:17 -0700 (PDT)
Message-ID: <a24cdcae-8195-e3ab-0d36-c9e35c671639@acm.org>
Date:   Wed, 15 Jun 2022 09:44:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v4 01/10] scsi: ufs: Export ufshcd_uic_change_pwr_mode()
Content-Language: en-US
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        alice.chao@mediatek.com, powen.kao@mediatek.com,
        mason.zhang@mediatek.com, qilin.tan@mediatek.com,
        lin.gui@mediatek.com, eddie.huang@mediatek.com,
        tun-yu.yu@mediatek.com, cc.chou@mediatek.com,
        chaotian.jing@mediatek.com, jiajie.hao@mediatek.com
References: <20220615035146.20964-1-stanley.chu@mediatek.com>
 <20220615035146.20964-2-stanley.chu@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220615035146.20964-2-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/14/22 20:51, Stanley Chu wrote:
> Export ufshcd_uic_change_pwr_mode() to allow vendors to
> use it for SoC-specific power mode change design limitation.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
