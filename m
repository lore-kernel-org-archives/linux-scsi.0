Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4752C77B73
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 19:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbjEVTfR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 15:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbjEVTfO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 15:35:14 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D06E43
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 12:34:35 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1ae58e4b295so41497015ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 12:34:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684784021; x=1687376021;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iOM1p1OAZMRMTX3iv7hLOpNRR+zec9raB/v6bxeDAJc=;
        b=fH+heH6ZI1WcY4RZ+42dyM9aP3DEWGVbGebwZT9hb6cZlnPO4if+tnMdj0tDV8aGmR
         l78YbPlo1bSonnpsociAu0W0K2hPxaX1zhHaoyEMf52nHDFKFhq4DoCvayZPwzhEhkMN
         4VknwJ9eDkmHYixNiT/82gIe1PkOvxouqs5HoKdkQPjU+sXp99zJ94Syirkn9lYbPPCl
         15QtZUPG2Js5jr2XKNNGFuCH1pfEUaUTWYfkGRVodyPbmTqlTu12V8gCcegc3fFshGHZ
         QazqP1L7dHuZJ4dO66wp9zkfUltz+grfJDsFxwxpXMl7SR6keeeeTfoo/mlBCQPYbKJF
         IUqQ==
X-Gm-Message-State: AC+VfDw+ljLlo2hPLv0n5dOGsjRNeV18ho3ybxFCN4lUOXgRfyENDj1A
        tcBmcjUUqU8Zb5IFGw+tUtA=
X-Google-Smtp-Source: ACHHUZ6aHNHgrwKl+Z/jo6Ub4yfQywJXwOZlQ6G01cXKmvtU5Gbg4WvpPe6UGG9Wtrh4i0tADkuPMQ==
X-Received: by 2002:a17:902:f7c6:b0:1ae:3036:b594 with SMTP id h6-20020a170902f7c600b001ae3036b594mr10691684plw.49.1684784021037;
        Mon, 22 May 2023 12:33:41 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:642f:e57f:85fb:3794? ([2620:15c:211:201:642f:e57f:85fb:3794])
        by smtp.gmail.com with ESMTPSA id n4-20020a170902e54400b001a4edbabad3sm483834plf.230.2023.05.22.12.33.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 12:33:40 -0700 (PDT)
Message-ID: <935b8998-cb5d-7f7e-c95c-454f2cbedc14@acm.org>
Date:   Mon, 22 May 2023 12:33:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 0/4] ufs: Do not requeue while ungating the clock
Content-Language: en-US
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20230517222359.1066918-1-bvanassche@acm.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230517222359.1066918-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/17/23 15:23, Bart Van Assche wrote:
> In the traces we recorded while testing zoned storage we noticed that UFS
> commands are requeued while the clock is being ungated. Command requeueing
> makes it harder than necessary to preserve the command order. Hence this
> patch series that modifies the SCSI core and also the UFS driver such that
> clock ungating does not trigger command requeueing.

Can anyone please help with reviewing this patch series? I will be OoO in
June so it would help if review comments would be posted soon.

Thanks,

Bart.
