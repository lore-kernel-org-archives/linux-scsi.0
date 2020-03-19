Return-Path: <SRS0=Qc7/=5E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4E2C4332E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 17:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EBCA207FC
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584637940;
	bh=fxN4CnnOD6y03mHmAA5C+hhbqj2uKF+4bj47hgkFoVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=uXM41xg9PgiQJyPV6+PgwVoDtm7dpgRl0T4fplY5f3wWVY6vLLqzESpBquBReJF3H
	 0yQVJu3KZ/mr0S6xegJft6avh+pS55IhmDkquL0KbxDLDafyHM9uhGRXAi0Z0J9u1Z
	 4qrdizkE6XEo0ynFosyz5KEkzDk5SPOX1hAdI28w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgCSRMR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 13:12:17 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:41727 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727235AbgCSRMR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2020 13:12:17 -0400
Received: by mail-il1-f196.google.com with SMTP id l14so2938868ilj.8;
        Thu, 19 Mar 2020 10:12:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FuFy53dKsb2fck0JMwy1FXmxdDEmegXgO4r2caNX4Qo=;
        b=OLXIkvGw3tJqvUSlP6ONTJRWwZsrZTNqk6ywd2Tc1yN0IxBF7yPsMAPHoxyxnikmlD
         k6HUvjjsy+ZkZLJD/b/5D/ZzNc2TvhBMIqPGkum6U+N2BpqJaYO2YWCiIXX8t2quYGOZ
         B9l6Ooq3OXIT5mWeiBFzXRAZvXlNl4duwAsxPjXtlWE+mcTA9u9K7PHudhoHCPNWUvQk
         Uofse2osD0WeUNHdtFcNgXl3faKzC/zItp01dVoSzU8RozIq7eZagGJxGRSYoxCIVztg
         cqZyoJ1C9aPVJhzITLFfDlk64GzLy/eosDZ+tufTTuO0+bveW6C9TH7gDlPeFlOMdsMw
         X/Yw==
X-Gm-Message-State: ANhLgQ2pOWvmbDrF3UeMe3/SuzDmSDS2L73F8j6RUvKLw0eKEwhOaF96
        aPj8YMdX62qvCUId6tzDgw==
X-Google-Smtp-Source: ADFU+vs/qjBgZCguu4PgrA7kda0SwMTPsdT6I/2Mcj/b7bYNjpINO1LuIXtpzuRHB/7LUhmdIByVUQ==
X-Received: by 2002:a92:35db:: with SMTP id c88mr4010676ilf.187.1584637934049;
        Thu, 19 Mar 2020 10:12:14 -0700 (PDT)
Received: from rob-hp-laptop ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id y8sm937166iot.14.2020.03.19.10.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 10:12:13 -0700 (PDT)
Received: (nullmailer pid 16694 invoked by uid 1000);
        Thu, 19 Mar 2020 17:12:10 -0000
Date:   Thu, 19 Mar 2020 11:12:10 -0600
From:   Rob Herring <robh@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, krzk@kernel.org, avri.altman@wdc.com,
        martin.petersen@oracle.com, kwmad.kim@samsung.com,
        stanley.chu@mediatek.com, cang@codeaurora.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH v2 1/5] dt-bindings: phy: Document Samsung UFS PHY
 bindings
Message-ID: <20200319171210.GA14990@bogus>
References: <20200318111144.39525-1-alim.akhtar@samsung.com>
 <CGME20200318111805epcas5p3e68724d923a07ddd80a45e3316292940@epcas5p3.samsung.com>
 <20200318111144.39525-2-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318111144.39525-2-alim.akhtar@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 18 Mar 2020 16:41:40 +0530, Alim Akhtar wrote:
> This patch documents Samsung UFS PHY device tree bindings
> 
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  .../bindings/phy/samsung,ufs-phy.yaml         | 62 +++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/phy/samsung,ufs-phy.example.dt.yaml: example-0: 'ufs-phy@0x15571800' does not match any of the regexes: '.*-names$', '.*-supply$', '^#.*-cells$', '^#[a-zA-Z0-9,+\\-._]{0,63}$', '^[a-zA-Z][a-zA-Z0-9,+\\-._]{0,63}$', '^[a-zA-Z][a-zA-Z0-9,+\\-._]{0,63}@[0-9a-fA-F]+(,[0-9a-fA-F]+)*$', '^__.*__$', 'pinctrl-[0-9]+'

See https://patchwork.ozlabs.org/patch/1257427
Please check and re-submit.
