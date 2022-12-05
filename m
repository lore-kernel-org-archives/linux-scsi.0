Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADC6C47089
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 13:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbiLENhW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 08:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbiLENhU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 08:37:20 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966541CB2E
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 05:37:19 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id h193so10494276pgc.10
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2022 05:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7sTPl2CwcyL7NYDti5yrOYtN19f0pJQ8P3lm7QlXrGE=;
        b=XRYEKZZsMG7OHUWU8pDePIfLrWJeGy6oWYI8/6PzK7kPXNtXWvHrSK+Ym4qDdMa2sB
         4u1UEK9xRjIFBJzxEQOR/+GRtlpgPNqkHD8RawO9SxgbjJ0dh8CccomTKM7Hk/sz1ad4
         T5aEJbMofGqXyUev5o8n4vzSInYiEk2mhFu9Meh4WI0+qIBRWb29G46KfNGj0j9gY3dD
         1JVJJ+uY2UqQBGzUM2bnhnGQrX0ViINfjqDeT8MyzgLFAhMSCbAplzvDDkWThtPE+uea
         Oz1Kfi6fxbFzyYQ6U75oz+mgmcRbQeV/dLL+5sfxOlO0iMDaAbFWS3RdGEMIHLfy2iLs
         f45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7sTPl2CwcyL7NYDti5yrOYtN19f0pJQ8P3lm7QlXrGE=;
        b=JcDO3OrFTVRMfFiCXwrvgvk/Rz0SLIn3pRcRboQ8+Q4znboBceGslDCWG9yZUR+ZMU
         a4vZ6h446K/VCYRk5FIRMInMRLWp6LNnt4Gfeq1PSrZPM7g5gWleI5uMhbX3flP5HOz9
         yFO5u2PcKprVKhGyBkltkVHLNuwomHjdEi9XuocvpyB0nDAM/KvFtM7+euclPaJrfJYx
         ktPAgjpJrSda//oZK6ndYxWapy9vl0em735QPPAaTDx8m673E6W39FweQmH7oIxMCn/o
         SLV7CVHcNf9y1ULoSz7xXlqQoB6/RphsnMUbBRCnT6D3ECkfE4rvE2tcctvzOhugIUaI
         f1UQ==
X-Gm-Message-State: ANoB5plxfj+jdLXvtxCD5nAYYSGMGI+q7uKl4GSP9uN8BuxYGLBc69Vz
        IBEBnuii4bS5Jld7KitrczXs
X-Google-Smtp-Source: AA0mqf41eR86n90vi85XZ/tia5ft6SiLoJDtjqlwmuBpw6BZ9gvkU/JXGBGtdHsHlXvBVdI32iAPDg==
X-Received: by 2002:a65:4c42:0:b0:477:f872:8b6 with SMTP id l2-20020a654c42000000b00477f87208b6mr39191831pgr.457.1670247439018;
        Mon, 05 Dec 2022 05:37:19 -0800 (PST)
Received: from thinkpad ([59.92.98.136])
        by smtp.gmail.com with ESMTPSA id x14-20020a170902a38e00b0017f36638010sm10515163pla.276.2022.12.05.05.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 05:37:18 -0800 (PST)
Date:   Mon, 5 Dec 2022 19:07:12 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: ufs: qcom: allow 'dma-coherent' property
Message-ID: <20221205133712.GE20192@thinkpad>
References: <20221205100837.29212-1-johan+linaro@kernel.org>
 <20221205100837.29212-2-johan+linaro@kernel.org>
 <20221205115906.GA20192@thinkpad>
 <Y43e9KRDsTCS5VI4@hovoldconsulting.com>
 <20221205122018.GC20192@thinkpad>
 <Y43jtpHqlyiIEZ0S@hovoldconsulting.com>
 <20221205130048.GD20192@thinkpad>
 <Y43uUA2X4Vzn+VLF@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y43uUA2X4Vzn+VLF@hovoldconsulting.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 05, 2022 at 02:12:48PM +0100, Johan Hovold wrote:
> On Mon, Dec 05, 2022 at 06:30:48PM +0530, Manivannan Sadhasivam wrote:
> > On Mon, Dec 05, 2022 at 01:27:34PM +0100, Johan Hovold wrote:
> > > On Mon, Dec 05, 2022 at 05:50:18PM +0530, Manivannan Sadhasivam wrote:
> > > > On Mon, Dec 05, 2022 at 01:07:16PM +0100, Johan Hovold wrote:
> > > > > On Mon, Dec 05, 2022 at 05:29:06PM +0530, Manivannan Sadhasivam wrote:
> > > > > > On Mon, Dec 05, 2022 at 11:08:36AM +0100, Johan Hovold wrote:
> > > > > > > UFS controllers may be cache coherent and must be marked as such in the
> > > > > > > devicetree to avoid data corruption.
> > > > > > > 
> > > > > > > This is specifically needed on recent Qualcomm platforms like SC8280XP.
> > > > > > > 
> > > > > > > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> 
> > > > > Yes, it would be a valid, but it will only be added to the DTs of SoCs
> > > > > that actually require it. No need to re-encode the dtsi in the binding.
> > > > > 
> > > > 
> > > > But if you make a property valid in the binding then it implies that anyone
> > > > could add it to DTS which is wrong. You should make this property valid for
> > > > SoCs that actually support it.
> > > 
> > > No, it's not wrong.
> > > 
> > > Note that the binding only requires 'compatible' and 'regs', all other
> > > properties are optional, and you could, for example, add a
> > > 'reset' property to a node for a device which does not have a reset
> > > without the DT validation failing.
> > > 
> > 
> > Then what is the point of devicetree validation using bindings?
> 
> You're still making sure that no properties are added that are not
> documented, number of clocks, names of clocks, etc.
> 
> > There is also a comment from Krzysztof: https://lkml.org/lkml/2022/11/24/390
> 
> Speaking of Krzysztof:
> 
> 	https://lore.kernel.org/lkml/20221204094717.74016-5-krzysztof.kozlowski@linaro.org/
> 

Heh... I will wait for him to chime in then.

Thanks,
Mani

> Johan

-- 
மணிவண்ணன் சதாசிவம்
