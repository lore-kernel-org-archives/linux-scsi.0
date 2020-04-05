Return-Path: <SRS0=3U4t=5V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD40C2BA1B
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 02:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99D5D2070E
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 02:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586052134;
	bh=owsYX0CKuVeeqB/rvClTpw5x1mx6Zy5Im9lldwCC0DQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=tvYTgvCioSz2RQpdr9CI4XJQijpOi9jy7xUsBSNmrCywYgWhzPo7gs7KEHrL1RJ9G
	 cnpBvNWEEPcwDD/uTg89nTObxsO927Djd93gMPR/klB6i24aAH5Fo4ZPOmMOuxfx42
	 DgohbIquBlXL0meFE0Lc6mv30Fvib5OID4u/sVQI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgDECCM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Apr 2020 22:02:12 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:32781 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgDECCM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Apr 2020 22:02:12 -0400
Received: by mail-io1-f67.google.com with SMTP id o127so11993786iof.0;
        Sat, 04 Apr 2020 19:02:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4KE1ajm7Pr9JZRShONsIYV51HCcbzA2Ep3Y98R0uXF0=;
        b=p2kaPmcAldHpOL99t6U+L1FwDAnTlKtTVOZUQPej+Za9wQAKU6qrbVZcKuRsYqLoy7
         78HNHhRcQ3zoDHbUSSZF2+zjqwMlGRsWx6qWtUpStydriP31CVqTMHVvxZBFl3NQUg86
         Uq/d7rR2NTOFVqnbyXoUa8CDrSb5+rz7hoO5z7lW5tYjyxTgzHbd8ZnB4x21eRgdNX6E
         Lm3++nASJe4mt3q0km/0uSVB18rtOgCRifDji4wlapIGHeHTw9FiO9serZ20mDlry10h
         4du+fHR3+/9GlHGAAe3dbsRhYPaQK9x+THWqvN4P0xz6Zlb5m2dvI4Og7WR5ynCd83Hx
         em9w==
X-Gm-Message-State: AGi0PubRbhCNjYaz8HnpuyocGDUkznu8dMYpq4Uwf3AOtF1mUwuZEDqw
        PekQwGA2xQPjJGcpiucfqw==
X-Google-Smtp-Source: APiQypJBAkbiTizGN9DKt26SkLi+oMNVXz4uYVjtoFP0Ee1EplO0IkrN+ydU296Tom/Bm7vDZfPvpA==
X-Received: by 2002:a05:6638:155:: with SMTP id y21mr713152jao.79.1586052130726;
        Sat, 04 Apr 2020 19:02:10 -0700 (PDT)
Received: from rob-hp-laptop ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id r10sm3871386iom.42.2020.04.04.19.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 19:02:10 -0700 (PDT)
Received: (nullmailer pid 536 invoked by uid 1000);
        Sun, 05 Apr 2020 02:02:08 -0000
Date:   Sat, 4 Apr 2020 20:02:08 -0600
From:   Rob Herring <robh@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/5] Documentation: devicetree: ufs: Add DT bindings
 for exynos UFS host controller
Message-ID: <20200405020208.GA22609@bogus>
References: <20200327170638.17670-1-alim.akhtar@samsung.com>
 <CGME20200327171418epcas5p4b85bea273e17c05a7edca58f528c435a@epcas5p4.samsung.com>
 <20200327170638.17670-4-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327170638.17670-4-alim.akhtar@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 27, 2020 at 10:36:36PM +0530, Alim Akhtar wrote:
> This adds Exynos Universal Flash Storage (UFS) Host Controller DT bindings.

Why the inconsistent subject. 'dt-bindings: ...' please.

> 
> Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  .../devicetree/bindings/ufs/ufs-exynos.txt    | 104 ++++++++++++++++++
>  1 file changed, 104 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt

Use DT schema format. Not sure why you'd do that for one and not the 
other...

> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-exynos.txt b/Documentation/devicetree/bindings/ufs/ufs-exynos.txt
> new file mode 100644
> index 000000000000..08e2d1497b1b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-exynos.txt
> @@ -0,0 +1,104 @@
> +* Exynos Universal Flash Storage (UFS) Host Controller
> +
> +UFSHC nodes are defined to describe on-chip UFS host controllers.
> +Each UFS controller instance should have its own node.
> +
> +Required properties:
> +- compatible        : compatible name, contains "samsung,exynos7-ufs"
> +- interrupts        : <interrupt mapping for UFS host controller IRQ>
> +- reg               : Should contain HCI, vendor specific, UNIPRO and
> +		      UFS protector address space
> +- reg-names	    : "hci", "vs_hci", "unipro", "ufsp";
> +
> +Optional properties:
> +- vdd-hba-supply        : phandle to UFS host controller supply regulator node
> +- vcc-supply            : phandle to VCC supply regulator node
> +- vccq-supply           : phandle to VCCQ supply regulator node
> +- vccq2-supply          : phandle to VCCQ2 supply regulator node
> +- vcc-supply-1p8        : For embedded UFS devices, valid VCC range is 1.7-1.95V
> +                          or 2.7-3.6V. This boolean property when set, specifies
> +			  to use low voltage range of 1.7-1.95V. Note for external
> +			  UFS cards this property is invalid and valid VCC range is
> +			  always 2.7-3.6V.

The supply for vcc-supply should be restricted to the valid range and 
this is not needed.

> +- vcc-max-microamp      : specifies max. load that can be drawn from vcc supply
> +- vccq-max-microamp     : specifies max. load that can be drawn from vccq supply
> +- vccq2-max-microamp    : specifies max. load that can be drawn from vccq2 supply

How is this information useful?

> +- <name>-fixed-regulator : boolean property specifying that <name>-supply is a fixed regulator

No need for this. Look up the phandle and check supply's node if you 
want to know this.

> +
> +- clocks                : List of phandle and clock specifier pairs
> +- clock-names           : List of clock input name strings sorted in the same
> +                          order as the clocks property.
> +			  "core", "sclk_unipro_main", "ref" and ref_parent
> +
> +- freq-table-hz		: Array of <min max> operating frequencies stored in the same
> +			  order as the clocks property. If this property is not
> +			  defined or a value in the array is "0" then it is assumed
> +			  that the frequency is set by the parent clock or a
> +			  fixed rate clock source.
> +- pclk-freq-avail-range : specifies available frequency range(min/max) for APB clock
> +- ufs,pwr-attr-mode : specifies mode value for power mode change, possible values are
> +			"FAST", "SLOW", "FAST_auto" and "SLOW_auto"

Anything before the ',' is considered a vendor prefix and 'ufs' is not a 
vendor.

If these are standard UFS properties, then they should be documented in 
a common UFS binding. On the flip side, none of the other UFS bindings 
have needed these properties, so why do you?

> +- ufs,pwr-attr-lane : specifies lane count value for power mode change
> +		      allowed values are 1 or 2
> +- ufs,pwr-attr-gear : specifies gear count value for power mode change
> +		      allowed values are 1 or 2
> +- ufs,pwr-attr-hs-series : specifies HS rate series for power mode change
> +			   can be one of "HS_rate_b" or "HS_rate_a"
> +- ufs,pwr-local-l2-timer : specifies array of local UNIPRO L2 timer values
> +			   3 timers supported
> +			   <FC0ProtectionTimeOutVal,TC0ReplayTimeOutVal, AFC0ReqTimeOutVal>
> +- ufs,pwr-remote-l2-timer : specifies array of remote UNIPRO L2 timer values
> +			   3 timers supported
> +			   <FC0ProtectionTimeOutVal,TC0ReplayTimeOutVal, AFC0ReqTimeOutVal>
> +- ufs-rx-adv-fine-gran-sup_en : specifies support of fine granularity of MPHY,
> +			      this is a boolean property.
> +- ufs-rx-adv-fine-gran-step : specifies granularity steps of MPHY,
> +			      allowed step size is 0 to 3
> +- ufs-rx-adv-min-activate-time-cap : specifies rx advanced minimum activate time of MPHY
> +				     range is 1 to 9
> +- ufs-pa-granularity : specifies Granularity for PA_TActivate and PA_Hibern8Time
> +- ufs-pa-tacctivate : specifies time to wake-up remote M-RX
> +- ufs-pa-hibern8time : specifies minimum time to wait in HIBERN8 state
> +
> +Note: If above properties are not defined it can be assumed that the supply
> +regulators or clocks are always on.
> +
> +Example:
> +	ufshc@0x15570000 {
> +		compatible = "samsung,exynos7-ufs";
> +		reg = <0x15570000 0x100>,
> +		      <0x15570100 0x100>,
> +		      <0x15571000 0x200>,
> +		      <0x15572000 0x300>;
> +		reg-names = "hci", "vs_hci", "unipro", "ufsp";
> +		interrupts = <0 200 0>;
> +
> +		vdd-hba-supply = <&xxx_reg0>;
> +		vdd-hba-fixed-regulator;
> +		vcc-supply = <&xxx_reg1>;
> +		vcc-supply-1p8;
> +		vccq-supply = <&xxx_reg2>;
> +		vccq2-supply = <&xxx_reg3>;
> +		vcc-max-microamp = 500000;
> +		vccq-max-microamp = 200000;
> +		vccq2-max-microamp = 200000;
> +
> +		clocks = <&core 0>, <&ref 0>, <&iface 0>;
> +		clock-names = "core", "sclk_unipro_main", "ref", "ref_parent";
> +		freq-table-hz = <100000000 200000000>, <0 0>, <0 0>, <0 0>;
> +
> +		pclk-freq-avail-range = <70000000 133000000>;
> +
> +		ufs,pwr-attr-mode = "FAST";
> +		ufs,pwr-attr-lane = <2>;
> +		ufs,pwr-attr-gear = <2>;
> +		ufs,pwr-attr-hs-series = "HS_rate_b";
> +		ufs,pwr-local-l2-timer = <8000 28000 20000>;
> +		ufs,pwr-remote-l2-timer = <12000 32000 16000>;
> +		ufs-rx-adv-fine-gran-sup_en = <1>;
> +		ufs-rx-adv-fine-gran-step = <3>;
> +		ufs-rx-adv-min-activate-time-cap = <9>;
> +		ufs-pa-granularity = <6>;
> +		ufs-pa-tacctivate = <6>;
> +		ufs-pa-hibern8time = <20>;
> +	};
> -- 
> 2.17.1
> 
