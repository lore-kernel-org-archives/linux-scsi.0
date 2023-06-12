Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B461C7EE2F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 14:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbjFLOmp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 10:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239373AbjFLOk2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 10:40:28 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF881B2;
        Mon, 12 Jun 2023 07:40:26 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1b3c3f2d71eso8229425ad.2;
        Mon, 12 Jun 2023 07:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686580826; x=1689172826;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V2k5h5v6QzCcR3eX2PETHxqpP7p+MsuD7VNAtY9j2X8=;
        b=TVGdFhuZTTzkiM4eSi6ccUZHupcCJvGsUCyaYOQ/xxeY4j6RB8nxPwUtz8P1AQU30D
         b4QDm9zzlIUTkZEPOKI9XCCPNyHXLJdS6FmCDPZogJ41ro+DYGqObDhtBdHg2zTHV0/X
         CC2VFT0/aPjQnFSrc/MV6niM4QFDD1wk3QhB2z9AxpF88Ra0Vf2OOK30oWaXhAMnFXsk
         RbElDzLc+9UV8fhLFU1ZUVlOFApOK8rZTaUSdYGTwmQC63Ffkpaa5PKto3prQDWsWmXL
         nj5la0PIs+02DS1ogo6EKjeISzW+FPfeQDUQ1rL2HAvuyPD4WrNIl2kBHRvWJ1efxGJR
         49Lw==
X-Gm-Message-State: AC+VfDx3xcuJ2oYRnREM48C/AKiDWeTMqrJD1veHNccw2DCxxg9f2h07
        qc7EBpofpXEDvCPdEE8x5so=
X-Google-Smtp-Source: ACHHUZ6egE9KlLIhazWftG0Nc619mPVQjblmmoart7BaveADrHDJZm8cMpprlOORgCQGRmtObxAC3Q==
X-Received: by 2002:a17:90b:388f:b0:255:6c5b:3660 with SMTP id mu15-20020a17090b388f00b002556c5b3660mr7826413pjb.20.1686580826113;
        Mon, 12 Jun 2023 07:40:26 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id 6-20020a17090a030600b0024dfb8271a4sm8157323pje.21.2023.06.12.07.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 07:40:25 -0700 (PDT)
Message-ID: <b3bbc7c7-d607-8ad8-03ed-3ce18c0274e1@acm.org>
Date:   Mon, 12 Jun 2023 07:40:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v1 0/4] ufs: Introduce MCQ Quirks for MediaTek host
Content-Language: en-US
To:     Po-Wen Kao <powen.kao@mediatek.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     wsd_upstream@mediatek.com, peter.wang@mediatek.com,
        stanley.chu@mediatek.com, alice.chao@mediatek.com,
        naomi.chu@mediatek.com, chun-hung.wu@mediatek.com,
        cc.chou@mediatek.com, eddie.huang@mediatek.com
References: <20230612085817.12275-1-powen.kao@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230612085817.12275-1-powen.kao@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 01:58, Po-Wen Kao wrote:
> v1
> Introduce quirks for non-standard part of UFSHCI and address Bart's comment
> from last patch
> https://lore.kernel.org/all/20230328103801.11198-1-powen.kao@mediatek.com/

For the entire series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

