Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42DAC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 10:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiJRKLY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 06:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiJRKLK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 06:11:10 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D84CB40F9
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 03:10:59 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z97so19705831ede.8
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 03:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v882JkcfuJYCFF+9Ak2jZZGCdby+7XFJirBF+xvjOI8=;
        b=SJ90RBNi6l7dmw7WdT3J90sOTkP8sVdQKl7epDFpEXC69eF5LgnDtJyYawt9phyBbl
         FBovWT576s8YO6Hc//S/mceB8EcPpzm/eSaHAiSSdoDzYNbjmjSSLsMM0zY2rHfprzGV
         W03jz35ymZpoRzki0MP1d1daK0HIkPcXQ4CVSvHCQXjr2xUgFfFb4uVNwLpclZNgJlT3
         QPQtw9c+k8byaFgJ2VkdBRjKh5KvRHS+3L6cQVMLw7l0n4zI4VoqTHNdxWV8mQdDtDjb
         HzuyJzhtfXBIcMPO+5kO9X34RkvaASoEexRvXE9+92ppCyK9HLIzeiRM/5H2Qv+XGRBr
         Nk8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v882JkcfuJYCFF+9Ak2jZZGCdby+7XFJirBF+xvjOI8=;
        b=KuvKgOdcstJvZHgX5FsZEhUIEtK4dTPQ64z4EuxLqIuzb8Jn0aNt0E7Vw4ZjB9K/Cy
         yXwGj7+/7gNP2WXRR8vgDUib2Y3z+xx4GWKGQvezvlbfec5uxLS0OttVcVf9UYCAWL73
         uInLrokzSFLQBNewREw9MQM9YEwRjLj2FnBdJps0geitTN5MGd8g6793FebNhogbMzLu
         QFn56FF/G3bMMWO2fcekdmwP0CSriXPkHS3/ls1iJM1PhoQs2zqnctpW2WUTLHHv4Hs4
         8ALJoaT20bc3xtuZG3mfrShxBZHscnEEqnyOmnRuIIOy4sT3nsYi8mQuKIoMfJ/FGGgk
         Ua2Q==
X-Gm-Message-State: ACrzQf1O8njbA8FTi7H7vRxRay2pz9TMs+eeqdYsByFTEjwgokY1efC5
        j0zT/xVNi/SB0DE0SMmMylQ=
X-Google-Smtp-Source: AMsMyM5DeqvmZs5FM/WWBjFeurbtZDw9DU7emLP+7Vhf0VGh/LOupGS/P57zOTo9FNBXxAmffOkN5Q==
X-Received: by 2002:a05:6402:5c9:b0:446:fb0:56bb with SMTP id n9-20020a05640205c900b004460fb056bbmr1916778edx.173.1666087856277;
        Tue, 18 Oct 2022 03:10:56 -0700 (PDT)
Received: from [10.176.234.249] ([137.201.254.41])
        by smtp.googlemail.com with ESMTPSA id qu16-20020a170907111000b00780982d77d1sm7245846ejb.154.2022.10.18.03.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 03:10:55 -0700 (PDT)
Message-ID: <ce7e86b3979f61877f0de7b8bd32637602f5a9ad.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix the error log in
 ufshcd_query_flag_retry()
From:   Bean Huo <huobean@gmail.com>
To:     d_hyun.kwon@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        cpgsproxy3 <cpgsproxy3@samsung.com>
Date:   Tue, 18 Oct 2022 12:10:54 +0200
In-Reply-To: <1891546521.01666080182092.JavaMail.epsvc@epcpadp4>
References: <CGME20221017022939epcms2p669fa5e5685ef5be1d6c4d1d3e74b6c51@epcms2p6>
         <1891546521.01666080182092.JavaMail.epsvc@epcpadp4>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2022-10-18 at 16:30 +0900, Dukhyun Kwon wrote:
> In=C2=A0ufshcd_query_flag_retry()=C2=A0failed=C2=A0log
> is=C2=A0incorrectly=C2=A0output=C2=A0as=C2=A0"ufs=C2=A0attibute"
>=20
> Signed-off-by:=C2=A0d_hyun.kwon=C2=A0<d_hyun.kwon@samsung.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>

