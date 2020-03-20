Return-Path: <SRS0=SK/U=5F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AE6C43333
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Mar 2020 00:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F3A62076C
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Mar 2020 00:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584663714;
	bh=JOFW0NHtW4ZUJ1TUB8kyFXIrkQlxTzvn2FHFdNi15/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mce/Ek2BWkVuneMbJc22vsYUkd+cT5sZ7Uc80kl6yExOPACBosayfvTfkuhCg6ye2
	 eYe+PH34PlBLPkggYn5xf40WXyfaohharlMU4y2o5axOE4GtknzZoAJ99xiI/nA3X/
	 Pb03L8Si/IbQcXiD7vRTb+czJb6Y3z2fzvAomjdY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbgCTAVw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 20:21:52 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:38828 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCTAVv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2020 20:21:51 -0400
Received: by mail-il1-f193.google.com with SMTP id p1so4054353ils.5;
        Thu, 19 Mar 2020 17:21:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FNX6oJTq7J+/RlIA0O/fMH+A64Z+Gex/rEUfT2IWpQ4=;
        b=IxJadD6okQwVJF0USZvfFi0IWnWAga5zo/DJyVSfFzdgBWOVickbFwRNMrtXsx3UyU
         DjzwKW3F9fVs4ieqq5+ImhlFi9xuwQtmh4zxyGOwMh/9XFPN7gvawGlVviyLDA5lAidg
         BDgvjwanKHlF/VAR7U3i+65nnqy3lhJgvE52AdqruyGCv85w9kycYRJqQzjHV7Lf5Oz5
         GWXn/FuSpJDV6QKX18jcaf/jY3e7mnqMtc15O3J4QbUjsN7ex3ka135WFSU5r3Oz+vrA
         dNbtn1xEtKw2OCKijbyn6yCKnrGYQAftUBvvcnMvw4IPB4CJPfIBoSc+Bmsr1CxGfBY2
         jZoA==
X-Gm-Message-State: ANhLgQ1eZT4mAYcDB9U6pBz6AE33XTfrNYzSettBzART9I55rLSqRJzj
        dWrPQJrJHuIwFEvn6orBow==
X-Google-Smtp-Source: ADFU+vuWqcE4xeIgd8bciqMNI9OIj6xfhQTbXQpazdl4HeI9o71TkgH6pZjD9kWRH/39xisTogRLwg==
X-Received: by 2002:a05:6e02:e81:: with SMTP id t1mr5969536ilj.226.1584663710753;
        Thu, 19 Mar 2020 17:21:50 -0700 (PDT)
Received: from rob-hp-laptop ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id r9sm1280333ioa.44.2020.03.19.17.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 17:21:50 -0700 (PDT)
Received: (nullmailer pid 12090 invoked by uid 1000);
        Fri, 20 Mar 2020 00:21:47 -0000
Date:   Thu, 19 Mar 2020 18:21:47 -0600
From:   Rob Herring <robh@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, krzk@kernel.org, avri.altman@wdc.com,
        martin.petersen@oracle.com, kwmad.kim@samsung.com,
        stanley.chu@mediatek.com, cang@codeaurora.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH v3 1/5] dt-bindings: phy: Document Samsung UFS PHY
 bindings
Message-ID: <20200320002147.GA11283@bogus>
References: <20200319150031.11024-1-alim.akhtar@samsung.com>
 <CGME20200319150703epcas5p2d917898f6f1e0554cb978a70a34ee507@epcas5p2.samsung.com>
 <20200319150031.11024-2-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319150031.11024-2-alim.akhtar@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 19 Mar 2020 20:30:27 +0530, Alim Akhtar wrote:
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

See https://patchwork.ozlabs.org/patch/1258280

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure dt-schema is up to date:

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade

Please check and re-submit.
