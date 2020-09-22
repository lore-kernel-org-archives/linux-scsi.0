Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6DCC4727D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 23:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1FB8206DC
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 23:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600816540;
	bh=UqQFGU2JBmnUWU/TqFOAhTTcpux6EnR5ipeOlJXVr24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=jUv/JIcSO5wXNmxSKuW3z3PSQAmzWbo0pr6VjIyFeqs1CyaEfuh1PwP5Ulm3MNJdM
	 xkO4mp9O1BFin5+ykS0qwIPalpET4O5G+4RdQO6XmHdRm4a0VfM5qkiOk9NyLU/w/a
	 qtk1Y5HaiLGHxz3yU+oXaL36W5GtOzAXrCBa9bf8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgIVXPk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 19:15:40 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35598 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIVXPj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 19:15:39 -0400
Received: by mail-io1-f67.google.com with SMTP id r9so21673980ioa.2;
        Tue, 22 Sep 2020 16:15:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZTLIhHd8Y4Tf85s++I6uYziuQx8fHfBB7VVFQZPiv8M=;
        b=OPNw0F68jLtesfFmK2n6bGajXXtWxqVNEW5Dx8Og4+SVZ6CpeEr7yEG3C3Q7rnPC/e
         YnIu7RvH5a038xyixqlu7f5qAGL7hXycpcE158P/gZosQjf5Z1BGpqGnjoVmW85Fnq1x
         riRtcFr1gi80cTSNfz/EOK3rPdh91AxtHM3De3M6dlx/O3E0uVV7lmBqFluaUPbyo9Hv
         RJK5o86vEiVCXs171phhxBmx1smLYfceEzADuhsuADNca+GYhiqFHaJHa8SVJtD3X8hZ
         5QkT0qNEKMBZttbkIUwJaFpI+RLcCO+cKnwlZCyhH9Uag84v4bX8rK2p9LBWIbxIGwFo
         D2cA==
X-Gm-Message-State: AOAM531ApT+NSnjx+A1QwUYuGnW2LZv7vGIywH7/J6GlBtWp8ukh2NOz
        xo8tPHumVbXO9a8bR8nlSA==
X-Google-Smtp-Source: ABdhPJzhMLLx9e+HC1HqP5l/rc8bjuTK0s+ZE/buMcP93jRhpbAxNu4jYCqiuMQe9xq7prq/rR0USg==
X-Received: by 2002:a02:cdc5:: with SMTP id m5mr5911696jap.15.1600816539384;
        Tue, 22 Sep 2020 16:15:39 -0700 (PDT)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id w13sm8041599iox.10.2020.09.22.16.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 16:15:38 -0700 (PDT)
Received: (nullmailer pid 3448302 invoked by uid 1000);
        Tue, 22 Sep 2020 23:15:36 -0000
Date:   Tue, 22 Sep 2020 17:15:36 -0600
From:   Rob Herring <robh@kernel.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     liwei213@huawei.com, martin.petersen@oracle.com,
        chunfeng.yun@mediatek.com, jiajie.hao@mediatek.com,
        pedrom.sousa@synopsys.com, kuohong.wang@mediatek.com,
        robh+dt@kernel.org, andy.teng@mediatek.com,
        henryc.chen@mediatek.com, vivek.gautam@codeaurora.org,
        matthias.bgg@gmail.com, arvin.wang@mediatek.com,
        chaotian.jing@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, peter.wang@mediatek.com,
        linux-scsi@vger.kernel.org, avri.altman@wdc.com,
        cc.chou@mediatek.com, chun-hung.wu@mediatek.com,
        mark.rutland@arm.com, kishon@ti.com, alim.akhtar@samsung.com,
        yingjoe.chen@mediatek.com
Subject: Re: [PATCH v3 2/2] dt-bindings: ufs-mediatek: Add mt8192-ufshci
 compatible string
Message-ID: <20200922231536.GA3448246@bogus>
References: <20200914050052.3974-1-stanley.chu@mediatek.com>
 <20200914050052.3974-3-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914050052.3974-3-stanley.chu@mediatek.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 14 Sep 2020 13:00:52 +0800, Stanley Chu wrote:
> Add "mediatek,mt8192-ufshci" compatible string to for MediaTek
> UFS host controller present on MT8192 chipsets.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  Documentation/devicetree/bindings/ufs/ufs-mediatek.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
