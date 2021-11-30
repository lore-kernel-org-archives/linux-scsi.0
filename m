Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C37FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 19:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238344AbhK3TgE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 14:36:04 -0500
Received: from mail-pg1-f175.google.com ([209.85.215.175]:39860 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbhK3Tfq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 14:35:46 -0500
Received: by mail-pg1-f175.google.com with SMTP id r5so20878104pgi.6
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 11:32:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FGJHCtmg2p0jEd3C1f97Dx+Eko6wlb8p+DGE5PgWzeQ=;
        b=ZCpnEzMyhGp2eKdTm5hGNmS7/g8Tltnf0TFdhKz1F03D1eUfB93PNZCUxgCmkQZntY
         h4DNb5Dn4WJ003GrmRrsNtkAibYdrgCiT8Fc1dYepRyQ7wBnNBL57Ttx3Ispjoa2+v9m
         4QgurnxF9uHkG8TGGbJ4Pqg4Ie3axfbyqzJ3uEKV72xtX9eWbKggtLZs5D+Ms2ZNn903
         G2A8mjrXHsS/5Mxe0Jske+/CGzxk/8j0BCy0BHf+p9HF8oWge83ilXiDvY0xFzWFoJAz
         WDl/A7F5CMgN3OLpFvS32uMfv6EqQTX/BIfeDskGTh9TsNjyzkD2FHmbYFLK3J+FT//L
         sfvA==
X-Gm-Message-State: AOAM533ipktBDS+A2oQwmLpgJZYsZX93B8WNH6lAoapAnSzDsztigpRg
        FLxUvlteqOAgcYEgxU5AkyM=
X-Google-Smtp-Source: ABdhPJxUBTM6+euupcIWF+QGrDAYeUXG2M63d3uyGalLzLTgZZsiN7vaP/Lg4lpbMC0Hszz/4HCzpw==
X-Received: by 2002:a05:6a00:1693:b0:44c:64a3:d318 with SMTP id k19-20020a056a00169300b0044c64a3d318mr886788pfc.81.1638300747061;
        Tue, 30 Nov 2021 11:32:27 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id na13sm3795225pjb.11.2021.11.30.11.32.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 11:32:26 -0800 (PST)
Subject: Re: [PATCH v2 13/20] scsi: ufs: Fix a deadlock in the error handler
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-14-bvanassche@acm.org>
 <788d060573ed475a902f17bc32d05540b78e66da.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <235fe40e-5695-a7a6-7422-68fc6d33cdac@acm.org>
Date:   Tue, 30 Nov 2021 11:32:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <788d060573ed475a902f17bc32d05540b78e66da.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/21 12:54 AM, Bean Huo wrote:
> We are looking for alternative
> methods: for example, to fix this problem from the SCSI layer;
> Add a new dedicated hardware device management queue on the UFS device
> side.

Hi Bean,

I don't think that there are any alternatives. If all host controller tags
are in use, it is not possible to implement a mechanism in software to
create an additional tag. Additionally, stealing a tag is not possible since
no new request can be submitted to a UFS controller if all tags are in use.

Thanks,

Bart.
