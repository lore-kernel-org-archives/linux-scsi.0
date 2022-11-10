Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA17C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 17:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiKJRIy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 12:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiKJRIw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 12:08:52 -0500
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3787221E0A;
        Thu, 10 Nov 2022 09:08:50 -0800 (PST)
Received: by mail-ot1-f43.google.com with SMTP id cb2-20020a056830618200b00661b6e5dcd8so1460028otb.8;
        Thu, 10 Nov 2022 09:08:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RK6cieWUBjU53ENasVzxcAGzPdncqeleznzBvg9eiiw=;
        b=vOqH0mLlmwh4Vk0Smbfbs2tsKwtzykynQYqU5Myxv4xzSo8X0x5mKFWxzZZcfh7yZv
         QC05XIBuw2RYGgcYANsCi8hLCWa52gBc/uYSccU/pxBCceRxCY5UzSK4OBnl0PprHf9j
         iHqeIl4njZBbsZT5O3BcXczZP1t4wOkoTyF4AGmg/SZa4FN69BNEMqmlSF48SxMw3B09
         E6jH2vN2sJg2ArMcuNmbYG8Q42jaNa6CeX/nTVrvLfgqFHO6vojGz0hi43IRG8ecbdxF
         rJoYGMUPj9szLqwXnCS2LLUrJdnAFXa627O5mNkmc68djVqR7O9l8JOqwqArqJSN7E4x
         HiaQ==
X-Gm-Message-State: ACrzQf0RtChiAmrJ50E/lSKdYfUyffAzIFoRWeKtr6AFuXyIq9AFPujf
        yaBMnSjnEyorDWzVXTMERQ==
X-Google-Smtp-Source: AMsMyM5fVNFouRQCC5rTi6TmBh262yO91Ir5VrD5lq2Em3gv5625avkvlSP43bN6hl4Y6JPCtaeaqA==
X-Received: by 2002:a05:6830:1656:b0:667:9a03:a8a8 with SMTP id h22-20020a056830165600b006679a03a8a8mr1564325otr.308.1668100129332;
        Thu, 10 Nov 2022 09:08:49 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id d74-20020a4a524d000000b0049052c66126sm6209oob.2.2022.11.10.09.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 09:08:48 -0800 (PST)
Received: (nullmailer pid 566771 invoked by uid 1000);
        Thu, 10 Nov 2022 17:08:50 -0000
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Zhe Wang <zhewang116@gmail.com>
Cc:     robh+dt@kernel.org, orsonzhai@gmail.com, zhenxiong.lai@unisoc.com,
        jejb@linux.ibm.com, devicetree@vger.kernel.org,
        alim.akhtar@samsung.com, linux-scsi@vger.kernel.org,
        zhe.wang1@unisoc.com, avri.altman@wdc.com, yuelin.tang@unisoc.com,
        krzysztof.kozlowski+dt@linaro.org, martin.petersen@oracle.com
In-Reply-To: <20221110133640.30522-2-zhewang116@gmail.com>
References: <20221110133640.30522-1-zhewang116@gmail.com>
 <20221110133640.30522-2-zhewang116@gmail.com>
Message-Id: <166810006939.554384.11975846813296132046.robh@kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: ufs: Add document for Unisoc UFS host controller
Date:   Thu, 10 Nov 2022 11:08:50 -0600
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Thu, 10 Nov 2022 21:36:39 +0800, Zhe Wang wrote:
> From: Zhe Wang <zhe.wang1@unisoc.com>
> 
> Add Unisoc ums9620 ufs host controller devicetree document.
> 
> Signed-off-by: Zhe Wang <zhe.wang1@unisoc.com>
> ---
>  .../devicetree/bindings/ufs/sprd,ufs.yaml     | 72 +++++++++++++++++++
>  1 file changed, 72 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/sprd,ufs.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Error: Documentation/devicetree/bindings/ufs/sprd,ufs.example.dts:24.27-28 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:406: Documentation/devicetree/bindings/ufs/sprd,ufs.example.dtb] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1492: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

