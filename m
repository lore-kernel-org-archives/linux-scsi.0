Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CF9C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 16:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F134A20890
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 16:23:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ElXYH25s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390965AbgE0QXX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 12:23:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13876 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390963AbgE0QXV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 12:23:21 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200527162317epoutp04a5279402ed71c88ca3390d38ecc2182a~S7y2Ch-_E0213702137epoutp04d
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2020 16:23:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200527162317epoutp04a5279402ed71c88ca3390d38ecc2182a~S7y2Ch-_E0213702137epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590596597;
        bh=E6C5JdDusssLS9ZUn+02HyqSNQGx2ow3WGDvhm9rlac=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ElXYH25swRx5Jjxx7K5j0giuOLPpF3m+vz0wnhWxP6WISaaYkE6+2rzimUmWR24Bv
         sO6QTIfmx1VJQgnmcYguo44ThsSmFcob5iu2RpKU7EGEopqQu4gJfY9gnIoRv81vzK
         hVju6VhmIuXJYMmlz4eMgi6SphY6rvRg060M6uD0=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200527162316epcas5p4fc7c7244b52b0887f1924329b32b084e~S7y1fyWV22884528845epcas5p4r;
        Wed, 27 May 2020 16:23:16 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        63.A8.09475.4F39ECE5; Thu, 28 May 2020 01:23:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200527162315epcas5p14b54605df93060ef66d08b7146473cd9~S7y0q7zGL0106701067epcas5p1R;
        Wed, 27 May 2020 16:23:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200527162315epsmtrp28e58c59e464d3f1c0e2961f94572ad1a~S7y0qL9cj0573405734epsmtrp2V;
        Wed, 27 May 2020 16:23:15 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-b9-5ece93f47990
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        25.D3.08382.3F39ECE5; Thu, 28 May 2020 01:23:15 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200527162311epsmtip1896f4a523f40b1664bbcdb53d4c74a5c~S7yxAUtXj2854928549epsmtip1p;
        Wed, 27 May 2020 16:23:11 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Rob Herring'" <robh@kernel.org>
Cc:     <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <krzk@kernel.org>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <kwmad.kim@samsung.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20200526180843.GA81537@bogus>
Subject: RE: [PATCH v9 08/10] dt-bindings: ufs: Add DT binding documentation
 for ufs
Date:   Wed, 27 May 2020 21:53:09 +0530
Message-ID: <001301d63443$1f9f6000$5ede2000$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQDj7nWNOwhaAxvEU9bpCgUI3fQKTQMZxyl4AceFVZcDJl9ydqpgaYpg
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsWy7bCmpu6XyefiDOaulbF4+fMqm8Wn9ctY
        LeYfOcdqcf78BnaLm1uOslhsenyN1eLyrjlsFjPO72Oy6L6+g81i+fF/TBb/9+xgt1i69Saj
        A4/H5b5eJo9NqzrZPDYvqfdoObmfxePj01ssHn1bVjF6fN4k59F+oJspgCOKyyYlNSezLLVI
        3y6BK+PTuY1sBdfVKhZ/amNrYJwn28XIySEhYCLxZuZ0ti5GLg4hgd2MEjO/PGOFcD4xSuya
        84cFpEpI4BujxP1H6jAd/9bOY4WI72WU2LgxHqLhDaPEy3un2UASbAK6EjsWt4HZIgKqEk2z
        HrCAFDELHGeSeNxxi6mLkYODU0BbYnUfL0iNsECYxL9jE8HCLED1azeYgoR5BSwlnm84wQhh
        C0qcnPkE7B5mAXmJ7W/nMEPcoyDx8+kyVpBWEQE3iSXzkyBKxCWO/uxhBtkqIXCDQ+LpueNQ
        9S4SS//tYYWwhSVeHd/CDmFLSXx+t5cNZI6EQLZEzy5jiHCNxNJ5x1ggbHuJA1fmsICUMAto
        SqzfpQ+xik+i9/cTJohOXomONiGIalWJ5ndXoTqlJSZ2d0Mt9ZDYtmciywRGxVlI/pqF5K9Z
        SB6YhbBsASPLKkbJ1ILi3PTUYtMC47zUcr3ixNzi0rx0veT83E2M4GSm5b2D8dGDD3qHGJk4
        GA8xSnAwK4nwOp09HSfEm5JYWZValB9fVJqTWnyIUZqDRUmcV+nHmTghgfTEktTs1NSC1CKY
        LBMHp1QDk6jVQo0JmlUfTq3pueN9NZ57j4yxZ/SrgIn6TYwP8zVWJi71mbJNKTQkblvbnXvf
        FKclt94QsSxuvLN+UdhExTb3qikaHZ5fQt86sJbaa15fJ7P/W13gzD17m6ujuoxb28qvGx/v
        2aoc/aDQU3FVe8qE1BMVWlHM21NO8Tp85qldp7R3m9zS3uWb1R7ouLGsadapW7AkY83T0pin
        a2UeJ+s+j72w7IeVutIlH+kJl2LKdS/tDbykcf1Rq8Xr8KRzQl1d2zbHP+s+e/I5j+0azjcN
        qpzX5KoMphZdPNRwSW+CxO5lgRN0MlUnPC+ztd7GOZWnRHLX6pYdlqV7Mjony4bk2Cx50+Ry
        KO9samq7EktxRqKhFnNRcSIAlIUcAdUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWy7bCSnO7nyefiDJ5cVbF4+fMqm8Wn9ctY
        LeYfOcdqcf78BnaLm1uOslhsenyN1eLyrjlsFjPO72Oy6L6+g81i+fF/TBb/9+xgt1i69Saj
        A4/H5b5eJo9NqzrZPDYvqfdoObmfxePj01ssHn1bVjF6fN4k59F+oJspgCOKyyYlNSezLLVI
        3y6BK+PTuY1sBdfVKhZ/amNrYJwn28XIySEhYCLxb+081i5GLg4hgd2MEgt6NjJBJKQlrm+c
        wA5hC0us/PecHaLoFaPEx3dbWEESbAK6EjsWt7GB2CICqhJNsx6wgBQxC1xmkjjy5gUbRMc9
        RombM5cydzFycHAKaEus7uMFaRAWCJHY9WEHO0iYBah57QZTkDCvgKXE8w0nGCFsQYmTM5+w
        gJQwC+hJtG0ECzMLyEtsfzuHGeI2BYmfT5exgpSICLhJLJmfBFEiLnH0Zw/zBEbhWUgGzUIY
        NAvJoFlIOhYwsqxilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAiOSy3NHYzbV33QO8TI
        xMF4iFGCg1lJhNfp7Ok4Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rw3ChfGCQmkJ5akZqemFqQW
        wWSZODilGphmFbebf1bP5ikNmrWGxfBgCp9ibxFP9O8pW+acuJv2IfPRV4dTi3/xKe7xbbjJ
        +eB1eVPCS+vqqvVPJrsavWs2npC19cQmN5fPdr+2qWo0Nz68+0dozWfpLWUvMh9mp/12mDv7
        HbsU4/MPH69ev/l87oU2ngqpb4sMRF9Luh2d9tlj9asXgsJ/bWaxNu0rmJeyzvjZtqzy53N8
        JRZsdzE9+6hZa1pkupwAv059f4tig1+Y+YR9YusYpKfJi/2Se5Ox52n/5xc75oo+kt4k4LZG
        uvTrQadZl19Xh62c9ujOzTucM7uPvWE6EbX7WHX0nOve4ouc0yIakiYlfxe8rJ+y4e+ihgux
        j7vX1j4S378sUYmlOCPRUIu5qDgRAP+Qsc06AwAA
X-CMS-MailID: 20200527162315epcas5p14b54605df93060ef66d08b7146473cd9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200514005309epcas5p3ccd2b44c1bf20634eea3e232d1c2b62e
References: <20200514003914.26052-1-alim.akhtar@samsung.com>
        <CGME20200514005309epcas5p3ccd2b44c1bf20634eea3e232d1c2b62e@epcas5p3.samsung.com>
        <20200514003914.26052-9-alim.akhtar@samsung.com>
        <20200526180843.GA81537@bogus>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Rob,

> -----Original Message-----
> From: Rob Herring <robh@kernel.org>
> Sent: 26 May 2020 23:39
> To: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: devicetree@vger.kernel.org; linux-scsi@vger.kernel.org;
krzk@kernel.org;
> avri.altman@wdc.com; martin.petersen@oracle.com;
> kwmad.kim@samsung.com; stanley.chu@mediatek.com;
> cang@codeaurora.org; linux-samsung-soc@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v9 08/10] dt-bindings: ufs: Add DT binding
documentation
> for ufs
> 
> On Thu, May 14, 2020 at 06:09:12AM +0530, Alim Akhtar wrote:
> > This patch adds DT binding for samsung ufs hci
> 
> Subject should indicate this is for Samsung in some way.
> 
Sure will update the Subject as suggested by you.

> >
> > Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> > ---
> >  .../bindings/ufs/samsung,exynos-ufs.yaml      | 91 +++++++++++++++++++
> >  1 file changed, 91 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> >
> > diff --git
> > a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> > b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> > new file mode 100644
> > index 000000000000..eaa64cc32d52
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> > @@ -0,0 +1,91 @@
> > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause %YAML 1.2
> > +---
> > +$id:
> > +https://protect2.fireeye.com/url?k=9995443c-c4461d82-9994cf73-0cc47a3
> > +1ba82-
> 2c9d6322e4bc35a5&q=1&u=http%3A%2F%2Fdevicetree.org%2Fschemas%2F
> > +ufs%2Fsamsung%2Cexynos-ufs.yaml%23
> > +$schema:
> > +https://protect2.fireeye.com/url?k=70bd56cd-2d6e0f73-70bcdd82-0cc47a3
> > +1ba82-7865215595a4146c&q=1&u=http%3A%2F%2Fdevicetree.org%2Fmeta-
> schem
> > +as%2Fcore.yaml%23
> > +
> > +title: Samsung SoC series UFS host controller Device Tree Bindings
> > +
> > +maintainers:
> > +  - Alim Akhtar <alim.akhtar@samsung.com>
> > +
> > +description: |
> > +  Each Samsung UFS host controller instance should have its own node.
> > +  This binding define Samsung specific binding other then what is
> > +used
> > +  in the common ufshcd bindings
> > +  [1] Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> > +
> > +properties:
> > +
> > +  compatible:
> > +    enum:
> > +      - samsung,exynos7-ufs
> > +
> > +  reg:
> > +    items:
> > +     - description: HCI register
> > +     - description: vendor specific register
> > +     - description: unipro register
> > +     - description: UFS protector register
> > +
> > +  reg-names:
> > +    items:
> > +      - const: hci
> > +      - const: vs_hci
> > +      - const: unipro
> > +      - const: ufsp
> > +
> > +  clocks:
> > +    maxItems: 2
> 
> maxItems is redundant.
> 
Will drop it.

> > +    items:
> > +      - description: ufs link core clock
> > +      - description: unipro main clock
> > +
> > +  clock-names:
> > +    maxItems: 2
> 
> Here too.
Will drop it.
> 
> > +    items:
> > +      - const: core_clk
> > +      - const: sclk_unipro_main
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  phys:
> > +    maxItems: 1
> > +
> > +  phy-names:
> > +    maxItems: 1
> 
> What's the name? (Though a name is kind of pointless when there is only
> 1.)
Not sure are you suggesting to drop the phy-names completely? Or just keep
"phy-names:" only.
I looked into how other bindings has handle it, I will change this as 
   phy-names:
       const: ufs-phy

Hope you are ok with this.

> 
> With those fixed,
> 
> Reviewed-by: Rob Herring <robh@kernel.org>
> 
With adding "phy-names" entry, I will adds your Reviewed-by tag, will post
the updated changes soon.
Thank you!!

> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +  - phys
> > +  - phy-names
> > +  - clocks
> > +  - clock-names
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +    #include <dt-bindings/clock/exynos7-clk.h>
> > +
> > +    ufs: ufs@15570000 {
> > +       compatible = "samsung,exynos7-ufs";
> > +       reg = <0x15570000 0x100>,
> > +             <0x15570100 0x100>,
> > +             <0x15571000 0x200>,
> > +             <0x15572000 0x300>;
> > +       reg-names = "hci", "vs_hci", "unipro", "ufsp";
> > +       interrupts = <GIC_SPI 200 IRQ_TYPE_LEVEL_HIGH>;
> > +       clocks = <&clock_fsys1 ACLK_UFS20_LINK>,
> > +                <&clock_fsys1 SCLK_UFSUNIPRO20_USER>;
> > +       clock-names = "core_clk", "sclk_unipro_main";
> > +       pinctrl-names = "default";
> > +       pinctrl-0 = <&ufs_rst_n &ufs_refclk_out>;
> > +       phys = <&ufs_phy>;
> > +       phy-names = "ufs-phy";
> > +    };
> > +...
> > --
> > 2.17.1
> >

