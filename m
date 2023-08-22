Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4077CEE4993
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 15:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237408AbjHVPyW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 11:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbjHVPyV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 11:54:21 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973C0E52;
        Tue, 22 Aug 2023 08:54:13 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1bee82fad0fso29607465ad.2;
        Tue, 22 Aug 2023 08:54:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692719653; x=1693324453;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bW/CU0xlLJuZPmhDEgLGdzcNCVaJBUqD/qrlwzgGMII=;
        b=iuPFM4DAUy/7ZeTOk8m35Y8AK6kvMG+pNEfQZFwFtMm2c8GkAuF1syAFcj8tEppq5D
         hSJ5HIwHcphFDdr8ji6k76lDHpNza/UtW1Ga53+sTAgjFw3oC4ZJXDW8BpO+vdseggwO
         OhMHfP1WPtUVzIvFAEVeiX+HRJSl6zaqcNgj7NEDba9yn5pGK3vMdiFP6GKj7TC/tdBK
         0r6WQQNxGOwcIWHYA+vqN2pqdYDjgXtXZ7QLYX+fv72w+GWrjWwT7WIS97ekFo/xi2Yi
         tNRs8lngBJd1JLM8Or/O1xegyRF4yDAFLNGUO65TwcLTMe1syA69kQQKjcB4blK228nS
         ypCg==
X-Gm-Message-State: AOJu0YwNZs7FWRg/SOTV5SKFbRZqjAN4lKlrSZJOSfkPIwB2OU6KUNhY
        JeZn906Chu7hLOnpWqJ+Nnw=
X-Google-Smtp-Source: AGHT+IGeNNdJ+AeZVl7pqg52h4asx49vg3Qmn/d8bXD0BaKOD/DnGt48yIEWxx3s2QqeeT0n4DoB/Q==
X-Received: by 2002:a17:902:e842:b0:1b9:e972:134d with SMTP id t2-20020a170902e84200b001b9e972134dmr8328710plg.3.1692719652938;
        Tue, 22 Aug 2023 08:54:12 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:88be:bf57:de29:7cc? ([2620:15c:211:201:88be:bf57:de29:7cc])
        by smtp.gmail.com with ESMTPSA id iz22-20020a170902ef9600b001b9e86e05b7sm9235010plb.0.2023.08.22.08.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Aug 2023 08:54:12 -0700 (PDT)
Message-ID: <a97dcd51-07e1-8972-2661-2a1dd0048e91@acm.org>
Date:   Tue, 22 Aug 2023 08:54:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v10 13/18] scsi: ufs: mediatek: Rework the code for
 disabling auto-hibernation
Content-Language: en-US
To:     =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "hch@lst.de" <hch@lst.de>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        =?UTF-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>
References: <20230818193546.2014874-1-bvanassche@acm.org>
 <20230818193546.2014874-14-bvanassche@acm.org>
 <884fead2cdf88b2690e0aa87769684de60e26ac2.camel@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <884fead2cdf88b2690e0aa87769684de60e26ac2.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/22/23 02:20, Peter Wang (王信友) wrote:
> Cannot call ufshcd_auto_hibern8_update here.
> ufshcd_auto_hibern8_update will get runtime pm.
> but
> ufs_mtk_auto_hibern8_disable only used in runtime suspend flow.
> So, call ufshcd_auto_hibern8_update will get deadlock to wait runtime
> resume.

Hi Peter,

Thanks for the feedback. I'm going to drop this patch and also ufs-hisi
patch. Although that will lead to suboptimal performance if the user
enables auto-hibernation, users can achieve full performance for small
zoned writes by disabling auto-hibernation through sysfs.

Thanks,

Bart.

