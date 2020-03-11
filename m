Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30ED0C10F25
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 05:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECD22222C3
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 05:42:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NNYP+gTT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgCKFmj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 01:42:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62501 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgCKFmj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 01:42:39 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200311054237epoutp0293a04320dab8eda3114c64e2c5b34281~7KYfTBrAr0599005990epoutp02N
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2020 05:42:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200311054237epoutp0293a04320dab8eda3114c64e2c5b34281~7KYfTBrAr0599005990epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1583905357;
        bh=URTHxXXLdSOI3IYjX5rBfJl3mt+HD+35gyGMY9ctq7o=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=NNYP+gTTFacTMUMkdbNqEtGiAf/hb1DH2+CpWOLqA5BRCZsd4a2xRPiZuyD4Co7/a
         aDP5vKIq1T/5OedI+TIFz+WOUH/5t9s+gUa42V1IYnYuO8fkUK89aigT7T95gk0g0o
         3/05hqU7UDlx6JkcxW5LpE1dqAHE/a3RdVuHhhkA=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200311054237epcas5p42858581c843557b89e0f5f1bf0b0d4f7~7KYfB3eNn1294512945epcas5p4D;
        Wed, 11 Mar 2020 05:42:37 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B3.B8.19726.C4A786E5; Wed, 11 Mar 2020 14:42:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200311054236epcas5p2b0c96fbf447a118332a09fd4801e6e95~7KYeUkDbF1698416984epcas5p2N;
        Wed, 11 Mar 2020 05:42:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200311054236epsmtrp1cc5e50f06f3151443da1d3b7a1a17014~7KYeTlPLE0046300463epsmtrp1a;
        Wed, 11 Mar 2020 05:42:36 +0000 (GMT)
X-AuditID: b6c32a49-7c1ff70000014d0e-db-5e687a4c6c6b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.58.10238.C4A786E5; Wed, 11 Mar 2020 14:42:36 +0900 (KST)
Received: from alimakhtar02 (unknown [107.111.84.32]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200311054234epsmtip1ca2906d51d31d6d3120b3c4ea6221d66~7KYcQGY3N2720927209epsmtip1R;
        Wed, 11 Mar 2020 05:42:33 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Rob Herring'" <robh@kernel.org>
Cc:     <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <krzk@kernel.org>,
        <avri.altman@wdc.com>, <martin.petersen@oracle.com>,
        <kwmad.kim@samsung.com>, <stanley.chu@mediatek.com>,
        <cang@codeaurora.org>
In-Reply-To: <20200309181035.GA23663@bogus>
Subject: RE: [PATCH 1/5] dt-bindings: phy: Document Samsung UFS PHY bindings
Date:   Wed, 11 Mar 2020 11:12:32 +0530
Message-ID: <000001d5f767$de478960$9ad69c20$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGcomJoogAapdSxIIuFJfiljU0eNAEtLKvsAhEOsP8Bi2EW5qiPPYAA
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRTHe7Z7d6/DzduUPKlkDsRUfCuja4ZG9LJgH4TogyLa0MsUnY5d
        X9JKxHzLqTM/1dRUhqYGGuLL0Mxxc4pRGtRMJTRMw7fELAopNOed5LffOef/f875w0MKZVbc
        g0zNyGJ0Gap0uUiM9b3y9wtS5qckhHZORdIr2zYRvdXVitONIxM4PTn5nKBneqwYrf9oFtFP
        x3YEdMnQCEHvvjATdEvvDLooVryvrhIoujseiBTF48OY4vvSLKao7ulAih/dJxRlFr0ghogT
        X0hm0lNzGF1I1C1xylZ7H6Y1SW8XL5uIQlTrXIGcSKDCYafhHVaBxKSMGkRgGGhAfLGFYLnD
        QPDFLwTcmoU4sMytcQJ+MISg+tO8Q7WKoI3TC+wqERUEZlOpyM5ulC8UGT9jdhZSGwjm6grs
        7EQFAjfci9vZlVLCV5tp34vt6We5QaGdJVQEtL0dFfB8FMYfLzre8Yb+b/VC/qKTsL3UivO7
        rsJwZ5ND4w7W7Uqh/TigDAQMtS0g3nAZftfvOMyusDrW44jmASuG0j0m9zgNKgfO8O270PJk
        FOM5Giwf6jG7REj5Q9dACL9KClV/FgW8UwLlpTJe7Qv3N2wOpyc81OtxnhWgnx4napCP8VAw
        46FgxkMBjP+XNSGsAx1ntKxGzbBntWEZTG4wq9Kw2Rnq4KRMTTfa/1wB183IOKHkEEUiubNk
        uUCdIMNVOWyehkNACuVukkTvvZYkWZWXz+gyE3XZ6QzLIU8Sk7tLanFbvIxSq7KYNIbRMrqD
        qYB08ihEVmmxy6nypDuztiXc02sLU+rVsxGJUpeJUEvy6Ud0XxZb09i0bjpi7F/30siniwrg
        WFTTQvw98wiVMBDbXFOTovnpX1a22eyxHjf95nzs/JW51M5Iv2devcrG0GBs92Z40Gvp1MuS
        5UvXuC+T524YfAJjVjLxv9bcwOi6zXZ/OcamqMIChDpW9Q+oklMMWAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWy7bCSnK5PVUacQVcHh8XLn1fZLD6tX8Zq
        Mf/IOVaL8+c3sFvc3HKUxaL7+g42i+XH/zFZtO49wm7xf88OdoulW28yOnB5XO7rZfLYtKqT
        zaPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYA9igum5TUnMyy1CJ9uwSujE8rt7EULOaraHmx
        mL2BcRJPFyMnh4SAicS914eYuhi5OIQEdjNKLNm3kAUiIS1xfeMEdghbWGLlv+fsEEUvGCU+
        fJ/BBpJgE9CV2LG4DcwWEVCVaJr1AKyZWeAHo8SPaUYQDXcYJU4v72cESXAKaEsc2r+VFcQW
        FvCReHZ1MROIzQLUfOvQbmYQm1fAUmLF2WNMELagxMmZT4CGcgAN1ZNo28gIMV9eYvvbOcwQ
        xylI/Hy6jBXiBjeJ/esWQN0gLnH0Zw/zBEbhWUgmzUKYNAvJpFlIOhYwsqxilEwtKM5Nzy02
        LDDMSy3XK07MLS7NS9dLzs/dxAiOPy3NHYyXl8QfYhTgYFTi4X1Rlx4nxJpYVlyZe4hRgoNZ
        SYQ3Xh4oxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdp3rFIIYH0xJLU7NTUgtQimCwTB6dUA6O8
        pUTOurPWMrz8S0REWmfyHrj9SHThPOn4CfZvHNSsNXfqR+qJb9h70W+JaKi35OlTane+b97T
        +fKv8fQtqfZBGysu/QlVmHQ8yu6nWsbuX5M/BiSsWTqjPHqivt0SD7/C6LUXP9XflnLmk2Aq
        1G0+3rhM+fyO9ltPj6tsXrv55IWDl79OXbxciaU4I9FQi7moOBEAjuRbQrsCAAA=
X-CMS-MailID: 20200311054236epcas5p2b0c96fbf447a118332a09fd4801e6e95
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200306151021epcas5p40139bc39ddabb00f054f872c2b77db8f
References: <20200306150529.3370-1-alim.akhtar@samsung.com>
        <CGME20200306151021epcas5p40139bc39ddabb00f054f872c2b77db8f@epcas5p4.samsung.com>
        <20200306150529.3370-2-alim.akhtar@samsung.com>
        <20200309181035.GA23663@bogus>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Rob,

> -----Original Message-----
> From: Rob Herring <robh@kernel.org>
> Sent: 09 March 2020 23:41
> To: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: robh+dt@kernel.org; devicetree@vger.kernel.org; linux-
> scsi@vger.kernel.org; krzk@kernel.org; avri.altman@wdc.com;
> martin.petersen@oracle.com; kwmad.kim@samsung.com;
> stanley.chu@mediatek.com; cang@codeaurora.org; Alim Akhtar
> <alim.akhtar@samsung.com>
> Subject: Re: [PATCH 1/5] dt-bindings: phy: Document Samsung UFS PHY
bindings
> 
> On Fri,  6 Mar 2020 20:35:25 +0530, Alim Akhtar wrote:
> > This patch documents Samsung UFS PHY device tree bindings
> >
> > Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> > ---
> >  .../bindings/phy/samsung,ufs-phy.yaml         | 60 +++++++++++++++++++
> >  1 file changed, 60 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
> >
> 
> My bot found errors running 'make dt_binding_check' on your patch:
> 
> Error: Documentation/devicetree/bindings/phy/samsung,ufs-
> phy.example.dts:23.36-37 syntax error FATAL ERROR: Unable to parse input
tree
> scripts/Makefile.lib:311: recipe for target
> 'Documentation/devicetree/bindings/phy/samsung,ufs-phy.example.dt.yaml'
> failed
> make[1]: *** [Documentation/devicetree/bindings/phy/samsung,ufs-
> phy.example.dt.yaml] Error 1
> Makefile:1262: recipe for target 'dt_binding_check' failed
> make: *** [dt_binding_check] Error 2
> 
> See https://protect2.fireeye.com/url?k=872f213d-dafc7db2-872eaa72-
> 0cc47a31ce52-
> 327f14918e272963&u=https://patchwork.ozlabs.org/patch/1250378
> Please check and re-submit.
Sure will run "'make dt_binding_check" and fix this, just waiting for some
more review comments on other patches in this series.
Thanks for feedback.

Regards,
Alim

