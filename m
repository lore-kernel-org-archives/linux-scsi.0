Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E189C54E8E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 18:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CA8820736
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 18:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589221669;
	bh=MNLT9Ly3q27NJ1zovyEsgJm+yVYF6hlvpJ+zNVddp+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=S6SacEhUDxwO0n4qyjrWCOjZn0PkhmBH0gbSbaHR6gcj2lbMHKaticSU0aWkdX7sk
	 KKQ2IYOZqFev+8Q7++HOL1apemdoa8sFTpOGFr/xjJfHMHVAQz2K0BtoI4DBHsZust
	 vFDWxKUmNann9CQxcqF9o35e6V59vc3858fH50rc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731212AbgEKS1t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 14:27:49 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35532 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731208AbgEKS1r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 14:27:47 -0400
Received: by mail-oi1-f196.google.com with SMTP id o7so15979571oif.2;
        Mon, 11 May 2020 11:27:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AF44SBQidL/1nuTUY00MQnDKIQPVWNPKZOL9w+D+Z08=;
        b=FaKTCDNNDI1JSfVVpva2xLUavzYmsOE8PZUPprG9yotpAsnhR9leOm2KeCT6Byczef
         hzndFH39S7cBlOHbIOnywrPtKtikS4G6gqnygFqleV07Ut4bgF9EgK5LNahV8+/ZMlSB
         ATbuXolqj+yBEhvNsjfkezI+E9ltvZxGeypD3ZwPTtLjEdwmIhAl6IN3bme4K0Woq/z6
         LIldXWsGuBdNnHI+ALV2BnJL1pMbu9rP92u+pZlTStUi2UEYJMBtcxwrDeW+ysx/p5iG
         z4xnt7+BjcAPO0uZLN4gh8ACluEx2gl93gaEnQOhS3oOcuz+2qeFe+RUViJFDg8iIFsd
         Cthw==
X-Gm-Message-State: AGi0PuZrkgRqPVteCJUMOrGI6Gl6u8LppYCyjMt7gMBmrY7JXu9iLTqs
        R368qOWGicFeAhYAKU97yA==
X-Google-Smtp-Source: APiQypJZp8K7ZKYFivbdUWwWOufHVF5HSbqXoCMZfWZ7Fhk4i9srELxLj+oi9ZKacSVH9aLLafe8xQ==
X-Received: by 2002:a05:6808:b36:: with SMTP id t22mr21158774oij.121.1589221665737;
        Mon, 11 May 2020 11:27:45 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id x5sm3322995oif.29.2020.05.11.11.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 11:27:45 -0700 (PDT)
Received: (nullmailer pid 20642 invoked by uid 1000);
        Mon, 11 May 2020 16:10:23 -0000
Date:   Mon, 11 May 2020 11:10:23 -0500
From:   Rob Herring <robh@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     devicetree@vger.kernel.org, krzk@kernel.org,
        stanley.chu@mediatek.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, cang@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        avri.altman@wdc.com
Subject: Re: [PATCH v8 08/10] dt-bindings: ufs: Add DT binding documentation
 for ufs
Message-ID: <20200511161023.GA20124@bogus>
References: <20200511020031.25730-1-alim.akhtar@samsung.com>
 <CGME20200511021406epcas5p229fb46815d3c29ae06709fa6160e0308@epcas5p2.samsung.com>
 <20200511020031.25730-9-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511020031.25730-9-alim.akhtar@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 11 May 2020 07:30:29 +0530, Alim Akhtar wrote:
> This patch adds DT binding for samsung ufs hci
> 
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  .../bindings/ufs/samsung,exynos-ufs.yaml      | 92 +++++++++++++++++++
>  1 file changed, 92 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.example.dt.yaml: ufs@15570000: 'pclk-freq-avail-range' does not match any of the regexes: 'pinctrl-[0-9]+'

See https://patchwork.ozlabs.org/patch/1287439

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure dt-schema is up to date:

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade

Please check and re-submit.

