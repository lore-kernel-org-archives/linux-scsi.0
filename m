Return-Path: <SRS0=qdS7=42=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270EEC10F27
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 18:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC83221D56
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 18:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583777438;
	bh=qOKa5+48209mLBEkUPuuBB1K+HV64pW5TiQ1KS9b9Sc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DkEVYOTfVV7dZ8VZMO5RCT/pHsqHEfrvo2ff/+bPSDRq+t+4c8cftIPBEgBnsw5d8
	 ylRGWClox6bN7uNVqfWq0AzPAafXjvFyYYXQqL637swdBBx3HEGD4Z+IgIPcs++qki
	 n9fL8PvDGR5mJ4b0BqDn7oGVBgyHLGkRfQOmxX7w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgCISKi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 14:10:38 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40026 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgCISKi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2020 14:10:38 -0400
Received: by mail-ot1-f67.google.com with SMTP id x19so10526543otp.7;
        Mon, 09 Mar 2020 11:10:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=deNJF5N+tcxiITRRxmIT4oQ72noV576m4MdDvXlZn9Q=;
        b=JY0/3E85ETw2xhECMuLA6Ui+lLaQit9F3DHjzFfmqJbtQ38ds7dxRCxiWZ6YGv9O2A
         ihIWxs/LjUTVZyoTepRovhOjy9YUncqBMZQdfCOgYyDyCqNTocQheLOvNBOgecZRNpTv
         opxIlq+DO9eoVpijgjR4a4htrVPQquKhcF5Kx32wabTWr+AbkuLBktg+YReiRY5fy83b
         9dTQpJrZBCKZFji9Gkk4RE7BYstJ0KDbPFTJfT9AcBoeigHlNRkf4qdN1bl5DSRsjgY0
         vzvnjbOSrCMDkQFYaA0gHQ32CrV/pnYck4015QkulZWpE+AjjmFJCBAUQ2eb//NVFa6M
         78mw==
X-Gm-Message-State: ANhLgQ0XA+44/kzX9RzIie/7PnQOshAqe5v4Udq7MPrxLxaapsVUxneR
        NiOSNOEDMEBEZHortRjn+g==
X-Google-Smtp-Source: ADFU+vtDOB4TE8oXStOHtxCcHfpJSMs3sf9ZfzaL10Bhyl2BiHDsj4rlSKGldbHXefilyYKA54CiwA==
X-Received: by 2002:a05:6830:1aca:: with SMTP id r10mr7435564otc.330.1583777437384;
        Mon, 09 Mar 2020 11:10:37 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id c3sm2023128otl.81.2020.03.09.11.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 11:10:36 -0700 (PDT)
Received: (nullmailer pid 23932 invoked by uid 1000);
        Mon, 09 Mar 2020 18:10:35 -0000
Date:   Mon, 9 Mar 2020 13:10:35 -0500
From:   Rob Herring <robh@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, krzk@kernel.org, avri.altman@wdc.com,
        martin.petersen@oracle.com, kwmad.kim@samsung.com,
        stanley.chu@mediatek.com, cang@codeaurora.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH 1/5] dt-bindings: phy: Document Samsung UFS PHY bindings
Message-ID: <20200309181035.GA23663@bogus>
References: <20200306150529.3370-1-alim.akhtar@samsung.com>
 <CGME20200306151021epcas5p40139bc39ddabb00f054f872c2b77db8f@epcas5p4.samsung.com>
 <20200306150529.3370-2-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306150529.3370-2-alim.akhtar@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri,  6 Mar 2020 20:35:25 +0530, Alim Akhtar wrote:
> This patch documents Samsung UFS PHY device tree bindings
> 
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  .../bindings/phy/samsung,ufs-phy.yaml         | 60 +++++++++++++++++++
>  1 file changed, 60 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

Error: Documentation/devicetree/bindings/phy/samsung,ufs-phy.example.dts:23.36-37 syntax error
FATAL ERROR: Unable to parse input tree
scripts/Makefile.lib:311: recipe for target 'Documentation/devicetree/bindings/phy/samsung,ufs-phy.example.dt.yaml' failed
make[1]: *** [Documentation/devicetree/bindings/phy/samsung,ufs-phy.example.dt.yaml] Error 1
Makefile:1262: recipe for target 'dt_binding_check' failed
make: *** [dt_binding_check] Error 2

See https://patchwork.ozlabs.org/patch/1250378
Please check and re-submit.
