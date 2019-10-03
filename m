Return-Path: <SRS0=749Z=X4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A96C32792
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Oct 2019 21:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 685442133F
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Oct 2019 21:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570139809;
	bh=a0zhymasp/hcnWziFjewvLwlQhwUUnZXeZx7TlhgjFQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=sRW5EEyhu5LB7wkhhknM/OBP1F4+OhMFE88MU3nf6/50lGbomZt11j8TNSHnAXlRL
	 1iG91VS/iq0q9xQ9d78naMbaH+oCkhztWdukJ7Dc8zr9M/M18vi4Md6UFzrNQg+WAS
	 R52avLyV649NTtgfgxtAbOTiUPrjfVx3PRai1WIw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730403AbfJCV4p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Oct 2019 17:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfJCV4p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Oct 2019 17:56:45 -0400
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9895221848;
        Thu,  3 Oct 2019 21:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570139803;
        bh=a0zhymasp/hcnWziFjewvLwlQhwUUnZXeZx7TlhgjFQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IpcCM34itfN9W3MKuCyJ/SlZLLHX59Rc0SEDmM/VcBzjlujAttBsOEWT1Q5++P6ix
         aCfyMUefRnfgY2WjwKNVPASpsAk76I/4K7Mu/dOK3OKRPwsEOzJb5GH2NOa0tCjW7h
         dNhCJf0OxOOM5fRgzpTxVi1OtfnsUufQHZp2rIKo=
Received: by mail-qk1-f176.google.com with SMTP id p10so3951602qkg.8;
        Thu, 03 Oct 2019 14:56:43 -0700 (PDT)
X-Gm-Message-State: APjAAAWAJeNgVXOkzIZEcqJwbZP2pBXP8JXlCjHnS6bFZjLJAZUm8Fif
        PGDQVNZ6YUPcW+UD+HBaFKWIMb4a1PfNvMgaew==
X-Google-Smtp-Source: APXvYqzkCkG9sTUc93JQfOkxaoIams6ADVfZwuYaOyxkHS+6SnSz1nJtjdqbkB6SH+yWk1CpAWOxH0uhNL2yeuI2j38=
X-Received: by 2002:a37:682:: with SMTP id 124mr6718413qkg.393.1570139802662;
 Thu, 03 Oct 2019 14:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190918133921.25844-1-vigneshr@ti.com> <20190918133921.25844-2-vigneshr@ti.com>
 <20191001120826.GA4214@bogus> <c3490572-8230-3e41-0916-097091386b21@ti.com>
In-Reply-To: <c3490572-8230-3e41-0916-097091386b21@ti.com>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 3 Oct 2019 16:56:31 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+=8Xrti5FQ-Tmdivb5QvXxBzNxgbYiU+KChiNjkOreaA@mail.gmail.com>
Message-ID: <CAL_Jsq+=8Xrti5FQ-Tmdivb5QvXxBzNxgbYiU+KChiNjkOreaA@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: ufs: ti,j721e-ufs.yaml: Add binding for
 TI UFS wrapper
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Janek Kotas <jank@cadence.com>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        SCSI <linux-scsi@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 1, 2019 at 7:18 AM Vignesh Raghavendra <vigneshr@ti.com> wrote:
>
>
>
> On 01/10/19 5:38 PM, Rob Herring wrote:
> > On Wed, Sep 18, 2019 at 07:09:20PM +0530, Vignesh Raghavendra wrote:
> >> Add binding documentation of TI wrapper for Cadence UFS Controller.
> >>
> >> Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
> >> ---
> >>  .../devicetree/bindings/ufs/ti,j721e-ufs.yaml | 45 +++++++++++++++++++
> >>  1 file changed, 45 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
> >>
> >> diff --git a/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml b/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
> >> new file mode 100644
> >> index 000000000000..dabd7c795fbe
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
> >> @@ -0,0 +1,45 @@
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +%YAML 1.2
> >> +---
> >> +$id: http://devicetree.org/schemas/ufs/ti,j721e-ufs.yaml#
> >> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> >> +
> >> +title: TI J721e UFS Host Controller Glue Driver
> >> +
> >> +maintainers:
> >> +  - Vignesh Raghavendra <vigneshr@ti.com>
> >> +
> >> +properties:
> >> +  compatible:
> >> +    items:
> >> +      - const: ti,j721e-ufs
> >> +
> >> +  reg:
> >> +    maxItems: 1
> >> +    description: address of TI UFS glue registers
> >> +
> >> +  clocks:
> >> +    maxItems: 1
> >> +    description: phandle to the M-PHY clock
> >> +
> >> +  power-domains:
> >> +    maxItems: 1
> >> +
> >> +required:
> >> +  - compatible
> >> +  - reg
> >> +  - clocks
> >> +  - power-domains
> >> +
> >> +examples:
> >> +  - |
> >> +    ufs_wrapper: ufs-wrapper@4e80000 {
> >> +       compatible = "ti,j721e-ufs";
> >> +       reg = <0x0 0x4e80000 0x0 0x100>;
> >> +       power-domains = <&k3_pds 277>;
> >> +       clocks = <&k3_clks 277 1>;
> >> +       assigned-clocks = <&k3_clks 277 1>;
> >> +       assigned-clock-parents = <&k3_clks 277 4>;
> >> +       #address-cells = <2>;
> >> +       #size-cells = <2>;
> >
> > Based on the driver you expect to have a child node here with the UFS
> > controller? You need to show that and have a schema for it.
> >
>
> Yes, Cadence UFS controller node will be the child node. Its bindings
> are documented at: Documentation/devicetree/bindings/ufs/cdns,ufshc.txt
> (which in turn refers to
> Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt)
>
> But they are not in .yaml yet. How would you suggest to reference that?
> Or should I just write plain text DT binding doc given that subsystem is
> not converted to yaml?

I guess for now just define the child node and refer to the text
document. Or feel free to convert the above 2 docs to schema. :)

Rob
