Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D28EC43461
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 18:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA28C208B3
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 18:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600108523;
	bh=VUl4gr+GBHQ8QonHrrEGoUZ63oI55XlYf/tQtCnBn+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=HQyyJ2sLz+psyJS3J57Mt0mTtHvzrr86EgXR4Bej0V+VIEX2kB2m8liEGncgaazyz
	 Y89rfYUtz0RiWsOYH74E63pxB3XJ6kg85wUpcBoIKqWrABjCHfH89pATUi1fS3WQdi
	 ywfgFnd8F+SPUoAjbscHBKaAAoBa7Jp1bR8PyvnA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgINSfU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 14:35:20 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:35359 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgINSfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2020 14:35:08 -0400
Received: by mail-il1-f195.google.com with SMTP id y9so560837ilq.2;
        Mon, 14 Sep 2020 11:35:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kr/0iYbSBTjl5HEsBr9lRARUT7uhou4qJ8/Qjy30PVQ=;
        b=dj56JEffJu9UHzZAoT7eiyx0qI/RjgfIQYHCYmP71D+y//BYFAIjZchvK753anpye4
         NXyLLQUeeQivFdSKecRls4+IUby71rVhZ81FdIvPXb1bGulpVFRlD7XDl5WXfpoQeWbP
         I9BtKWFvoZ9BmiOQv/HBuI6B8YcvYSCNHSmK3PL83sgbMYgHPDsnLL7OQUWpFnWFyLY1
         cuJIWmY0EJQVFFjA6+3snmc2dVuzm7WnfW5Jmo51KBNQ1CVcE8K4+DnIv7eAwaZQkGay
         GhgVjqY4JurlqaY1p47d56so8zGNWz3wyAvrG6Jog+LgpoTVktZIlT06qnVJUp4rB+lk
         nKhw==
X-Gm-Message-State: AOAM533Xizz3WC3lkDM3cPHE0GW83jReCFd+x6xh85buGqYJeWs9CFEI
        bODc+GVCdYuitP+z3FYoxg==
X-Google-Smtp-Source: ABdhPJwKuxW2v7Tvvdsia63gcfapU/VJH0B7ub5zz3NEZOsoQZMWHods8LNIVCEKD9nD3HjQNpVBsA==
X-Received: by 2002:a92:c908:: with SMTP id t8mr12197926ilp.60.1600108507593;
        Mon, 14 Sep 2020 11:35:07 -0700 (PDT)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id t10sm6452117iog.49.2020.09.14.11.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 11:35:06 -0700 (PDT)
Received: (nullmailer pid 8850 invoked by uid 1000);
        Mon, 14 Sep 2020 18:35:05 -0000
Date:   Mon, 14 Sep 2020 12:35:05 -0600
From:   Rob Herring <robh@kernel.org>
To:     "Bao D. Nguyen" <nguyenb@codeaurora.org>
Cc:     cang@codeaurora.org, asutoshd@codeaurora.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        Vinod Koul <vkoul@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/2] scsi: dt-bindings: ufs: Add vcc-voltage-level for
 UFS
Message-ID: <20200914183505.GA357@bogus>
References: <cover.1598939393.git.nguyenb@codeaurora.org>
 <0a9d395dc38433501f9652a9236856d0ac840b77.1598939393.git.nguyenb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a9d395dc38433501f9652a9236856d0ac840b77.1598939393.git.nguyenb@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 31, 2020 at 11:00:47PM -0700, Bao D. Nguyen wrote:
> UFS's specifications supports a range of Vcc operating
> voltage levels. Add documentation for the UFS's Vcc voltage
> levels setting.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Bao D. Nguyen <nguyenb@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> index 415ccdd..7257b32 100644
> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> @@ -23,6 +23,8 @@ Optional properties:
>                            with "phys" attribute, provides phandle to UFS PHY node
>  - vdd-hba-supply        : phandle to UFS host controller supply regulator node
>  - vcc-supply            : phandle to VCC supply regulator node
> +- vcc-voltage-level     : specifies voltage levels for VCC supply.
> +                          Should be specified in pairs (min, max), units uV.

The expectation is the regulator pointed to by 'vcc-supply' has the 
voltage constraints. Those constraints are supposed to be the board 
constraints, not the regulator operating design constraints. If that 
doesn't work for your case, then it should be addressed in a common way 
for the regulator binding.

Also, properties with units must have a unit suffix.

Rob
