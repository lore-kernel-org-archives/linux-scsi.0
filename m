Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD07C2BB55
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 05:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4996120692
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 05:42:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQh/QZ3N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgDLFl6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Apr 2020 01:41:58 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:38366 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgDLFl5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2020 01:41:57 -0400
Received: by mail-ua1-f67.google.com with SMTP id g10so2057877uae.5;
        Sat, 11 Apr 2020 22:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XMvROckWSzZfp2JUvr5KET2psvIF8ZxdMVepuEQaA4s=;
        b=PQh/QZ3Ntpmm0BQVcIAg+kDDuZ9M8adW+Sux0XWnEYRhMuYFvX/+o0hdOiBbociQIH
         iddxcqiUXIcylhnDmNw/qOxMAmfEg5v7wwpXFw/4ZUzN8QtLf9UxvWQ12EME3TooVT+a
         m+SORXmlAlP4gLW9mzh1Ze3p/c6m8zBECVIDDwkQq+Xl68dPCAEg+M7lyujU8DDOjh+5
         /FQMfzu4sI+8JKIwsJYtnLhe6KVUlyXfdSo/ByQzljBnHaENkDOcDTNk21NerMBKQ1As
         GOu5xyDi9FaZZiUUuUudfUxQiUD0ZPDdEOB8ilSAIJoiv2xpR/dxwUg9SEKUELN8OzMO
         LYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XMvROckWSzZfp2JUvr5KET2psvIF8ZxdMVepuEQaA4s=;
        b=ewWaatCt3Y9YPF9TflZpgTIYImhO7kMJSgJF6dOUMO1qYxRM9heKju+uUiEL32yN6S
         h/GwKoazgwshFPn9kByM1tFKVRh0mBrqnfWQ+wAMPagQzvX462o70CmEZAOEepFI7taS
         X2AmUw3d4K6dkHyCsnobRJAMWVQDelw3F2Spq1sqbbSKLBqzyH3vpGpGTuwr1ar7hSsj
         Xllu8JXw9hd2K7OZpN7rOIvvEkdppv+sbhzJ0M+i9daN2SlTHrmpoI4+zFVvYJGAdCRh
         kKS21Q5t266DgGwXp7a7AZlhG9G3LlfT9GCD8a+d9PZPMzneg8v9Hu1rPUGwHXv8yWpg
         1Fng==
X-Gm-Message-State: AGi0PuYT+r4FbHOguGge6A0Z4b6hX+5FGu28d47HvLGVpZSQQk7YDV+f
        wuuWE75HZvf51/J7ayZ3w1arsJg4D3VxAR9Dm5lDiA==
X-Google-Smtp-Source: APiQypKaKILu/yYi19LBLzQbWwiJVhXP8pRWBBkZ7RYj0TWODlXX/ZismC6P31jZPZPtZW3m/h/S8zEQwC1eRu4SlDA=
X-Received: by 2002:a9f:27ca:: with SMTP id b68mr5443180uab.8.1586670115689;
 Sat, 11 Apr 2020 22:41:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200327170638.17670-1-alim.akhtar@samsung.com>
 <CGME20200327171418epcas5p4b85bea273e17c05a7edca58f528c435a@epcas5p4.samsung.com>
 <20200327170638.17670-4-alim.akhtar@samsung.com> <20200405020208.GA22609@bogus>
In-Reply-To: <20200405020208.GA22609@bogus>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 12 Apr 2020 11:11:19 +0530
Message-ID: <CAGOxZ52nCF92adSk3a64qjZfMxXd3qHRayWZzuTRwNjcd2cC1w@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] Documentation: devicetree: ufs: Add DT bindings
 for exynos UFS host controller
To:     Rob Herring <robh@kernel.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Rob

On Sun, Apr 5, 2020 at 7:33 AM Rob Herring <robh@kernel.org> wrote:
>
> On Fri, Mar 27, 2020 at 10:36:36PM +0530, Alim Akhtar wrote:
> > This adds Exynos Universal Flash Storage (UFS) Host Controller DT bindings.
>
> Why the inconsistent subject. 'dt-bindings: ...' please.
>
Sure will update
> >
> > Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
> > Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> > ---
> >  .../devicetree/bindings/ufs/ufs-exynos.txt    | 104 ++++++++++++++++++
> >  1 file changed, 104 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
>
> Use DT schema format. Not sure why you'd do that for one and not the
> other...
>
Yah, this is my 1st attempt to write binding in DT schema format, few
things were not clear, now with your review, things got clear. I will
keep the common UFS binding as it is and change exynos UFS binding in
schema format.
Will post the changes soon.

> >
> > diff --git a/Documentation/devicetree/bindings/ufs/ufs-exynos.txt b/Documentation/devicetree/bindings/ufs/ufs-exynos.txt
> > new file mode 100644
> > index 000000000000..08e2d1497b1b
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/ufs/ufs-exynos.txt
> > @@ -0,0 +1,104 @@
> > +* Exynos Universal Flash Storage (UFS) Host Controller
> > +
> > +UFSHC nodes are defined to describe on-chip UFS host controllers.
> > +Each UFS controller instance should have its own node.
> > +
> > +Required properties:
> > +- compatible        : compatible name, contains "samsung,exynos7-ufs"
> > +- interrupts        : <interrupt mapping for UFS host controller IRQ>
> > +- reg               : Should contain HCI, vendor specific, UNIPRO and
> > +                   UFS protector address space
> > +- reg-names      : "hci", "vs_hci", "unipro", "ufsp";
> > +
> > +Optional properties:
> > +- vdd-hba-supply        : phandle to UFS host controller supply regulator node
> > +- vcc-supply            : phandle to VCC supply regulator node
> > +- vccq-supply           : phandle to VCCQ supply regulator node
> > +- vccq2-supply          : phandle to VCCQ2 supply regulator node
> > +- vcc-supply-1p8        : For embedded UFS devices, valid VCC range is 1.7-1.95V
> > +                          or 2.7-3.6V. This boolean property when set, specifies
> > +                       to use low voltage range of 1.7-1.95V. Note for external
> > +                       UFS cards this property is invalid and valid VCC range is
> > +                       always 2.7-3.6V.
>
> The supply for vcc-supply should be restricted to the valid range and
> this is not needed.
>
For now, I will leave these common binding as it is.
> > +- vcc-max-microamp      : specifies max. load that can be drawn from vcc supply
> > +- vccq-max-microamp     : specifies max. load that can be drawn from vccq supply
> > +- vccq2-max-microamp    : specifies max. load that can be drawn from vccq2 supply
>
> How is this information useful?
>
> > +- <name>-fixed-regulator : boolean property specifying that <name>-supply is a fixed regulator
>
> No need for this. Look up the phandle and check supply's node if you
> want to know this.
>
ok
> > +
> > +- clocks                : List of phandle and clock specifier pairs
> > +- clock-names           : List of clock input name strings sorted in the same
> > +                          order as the clocks property.
> > +                       "core", "sclk_unipro_main", "ref" and ref_parent
> > +
> > +- freq-table-hz              : Array of <min max> operating frequencies stored in the same
> > +                       order as the clocks property. If this property is not
> > +                       defined or a value in the array is "0" then it is assumed
> > +                       that the frequency is set by the parent clock or a
> > +                       fixed rate clock source.
> > +- pclk-freq-avail-range : specifies available frequency range(min/max) for APB clock
> > +- ufs,pwr-attr-mode : specifies mode value for power mode change, possible values are
> > +                     "FAST", "SLOW", "FAST_auto" and "SLOW_auto"
>
> Anything before the ',' is considered a vendor prefix and 'ufs' is not a
> vendor.
>
> If these are standard UFS properties, then they should be documented in
> a common UFS binding. On the flip side, none of the other UFS bindings
> have needed these properties, so why do you?
>
Yah understood, these are not UFS common properties, I will change the
driver instead to handle them.
This will also simply exynos UFS binding.

> > +- ufs,pwr-attr-lane : specifies lane count value for power mode change
> > +                   allowed values are 1 or 2
> > +- ufs,pwr-attr-gear : specifies gear count value for power mode change
> > +                   allowed values are 1 or 2
> > +- ufs,pwr-attr-hs-series : specifies HS rate series for power mode change
> > +                        can be one of "HS_rate_b" or "HS_rate_a"
> > +- ufs,pwr-local-l2-timer : specifies array of local UNIPRO L2 timer values
> > +                        3 timers supported
> > +                        <FC0ProtectionTimeOutVal,TC0ReplayTimeOutVal, AFC0ReqTimeOutVal>
> > +- ufs,pwr-remote-l2-timer : specifies array of remote UNIPRO L2 timer values
> > +                        3 timers supported
> > +                        <FC0ProtectionTimeOutVal,TC0ReplayTimeOutVal, AFC0ReqTimeOutVal>
> > +- ufs-rx-adv-fine-gran-sup_en : specifies support of fine granularity of MPHY,
> > +                           this is a boolean property.
> > +- ufs-rx-adv-fine-gran-step : specifies granularity steps of MPHY,
> > +                           allowed step size is 0 to 3
> > +- ufs-rx-adv-min-activate-time-cap : specifies rx advanced minimum activate time of MPHY
> > +                                  range is 1 to 9
> > +- ufs-pa-granularity : specifies Granularity for PA_TActivate and PA_Hibern8Time
> > +- ufs-pa-tacctivate : specifies time to wake-up remote M-RX
> > +- ufs-pa-hibern8time : specifies minimum time to wait in HIBERN8 state
> > +
> > +Note: If above properties are not defined it can be assumed that the supply
> > +regulators or clocks are always on.
> > +
> > +Example:
> > +     ufshc@0x15570000 {
> > +             compatible = "samsung,exynos7-ufs";
> > +             reg = <0x15570000 0x100>,
> > +                   <0x15570100 0x100>,
> > +                   <0x15571000 0x200>,
> > +                   <0x15572000 0x300>;
> > +             reg-names = "hci", "vs_hci", "unipro", "ufsp";
> > +             interrupts = <0 200 0>;
> > +
> > +             vdd-hba-supply = <&xxx_reg0>;
> > +             vdd-hba-fixed-regulator;
> > +             vcc-supply = <&xxx_reg1>;
> > +             vcc-supply-1p8;
> > +             vccq-supply = <&xxx_reg2>;
> > +             vccq2-supply = <&xxx_reg3>;
> > +             vcc-max-microamp = 500000;
> > +             vccq-max-microamp = 200000;
> > +             vccq2-max-microamp = 200000;
> > +
> > +             clocks = <&core 0>, <&ref 0>, <&iface 0>;
> > +             clock-names = "core", "sclk_unipro_main", "ref", "ref_parent";
> > +             freq-table-hz = <100000000 200000000>, <0 0>, <0 0>, <0 0>;
> > +
> > +             pclk-freq-avail-range = <70000000 133000000>;
> > +
> > +             ufs,pwr-attr-mode = "FAST";
> > +             ufs,pwr-attr-lane = <2>;
> > +             ufs,pwr-attr-gear = <2>;
> > +             ufs,pwr-attr-hs-series = "HS_rate_b";
> > +             ufs,pwr-local-l2-timer = <8000 28000 20000>;
> > +             ufs,pwr-remote-l2-timer = <12000 32000 16000>;
> > +             ufs-rx-adv-fine-gran-sup_en = <1>;
> > +             ufs-rx-adv-fine-gran-step = <3>;
> > +             ufs-rx-adv-min-activate-time-cap = <9>;
> > +             ufs-pa-granularity = <6>;
> > +             ufs-pa-tacctivate = <6>;
> > +             ufs-pa-hibern8time = <20>;
> > +     };
> > --
> > 2.17.1
> >



-- 
Regards,
Alim
