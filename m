Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C56CC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 00:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 255DA61261
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 00:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344856AbhJRA30 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Oct 2021 20:29:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28090 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344838AbhJRA3Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Oct 2021 20:29:25 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211018002713epoutp0116260da9165913d3450cc9d23e8c7dea~u_GZVvEAL1334213342epoutp01I
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 00:27:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211018002713epoutp0116260da9165913d3450cc9d23e8c7dea~u_GZVvEAL1334213342epoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634516833;
        bh=xC624nBKRidp3/1riDc6c1DQFeTph5U6pLa5y0ntTD0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=CfK0uDncSV++8XaW1AYTeBCzSWcDj830jwc45UTfSroCkuPEA6EtLoDYIkaQYGM+o
         bNhLGoV3sViDuSSw9I7wZQFfTXu75Gp5+83E60Zy44Tpj1jH+16dB5AdEtRcMW8Kd3
         qx4tZ5baxnOzzfXK1i3qEOLwh7Rt3p9nnd1b5P9U=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211018002712epcas2p145213cdeadb3c2e93dc2be51dad8c873~u_GYjn_Uy3244632446epcas2p1y;
        Mon, 18 Oct 2021 00:27:12 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.98]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HXd3s59vXz4x9Py; Mon, 18 Oct
        2021 00:27:05 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        AA.7D.10018.45FBC616; Mon, 18 Oct 2021 09:27:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20211018002658epcas2p2c0901189d4f522dbec802cfe43de3681~u_GL-j7Dt0356903569epcas2p2Z;
        Mon, 18 Oct 2021 00:26:58 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211018002658epsmtrp157d49200e2d10fff99ba476aea8b08e4~u_GL_juX-1087710877epsmtrp1_;
        Mon, 18 Oct 2021 00:26:58 +0000 (GMT)
X-AuditID: b6c32a46-a0fff70000002722-c6-616cbf543990
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        41.D0.08738.25FBC616; Mon, 18 Oct 2021 09:26:58 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20211018002658epsmtip2736d9e575f50760fa695563a4f426531~u_GLtNVdH1855918559epsmtip2U;
        Mon, 18 Oct 2021 00:26:58 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Rob Herring'" <robh@kernel.org>
Cc:     "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        "'Sowon Na'" <sowon.na@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <devicetree@vger.kernel.org>
In-Reply-To: <YWmHQ5CVQd97JzHJ@robh.at.kernel.org>
Subject: RE: [PATCH v4 13/16] dt-bindings: ufs: exynos-ufs: add io-coherency
 property
Date:   Mon, 18 Oct 2021 09:26:58 +0900
Message-ID: <003d01d7c3b6$dccac760$96605620$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQL83TaU2gFk6OcLuUCqdNaZ93XEzwFG39bFAmgxteoCt4IMOKlae17A
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxzeube9bWGVa0U564bUq5uDBGibAhdDGSprLkGyGszcK2FXuKGk
        T9tiEPdAHeUlCLrBLI8pMkaKswpY0KEiDwlxYxmPaRwhasANMhYec1LtYC2Xbfz3/b7zfef3
        +86Dj4r+wMT8LIOVMRtoHYH5cVw9odHh+27qaGnndAA5MHEBIx/UuTByyj2KkbceFnHIylk3
        Ss47G7nkV72DXPLE1d3knfJ6hJxw2lGy/p4LIe89s3HJyzOLCPnljzcQsuRuB0Z+07+EkMud
        HTzyubsbSRBRwyPJlD2vFKOGy0oRqrUpjDrfOYVQLY4ijCqv7wLUU2chRs1N3udQZW0OQC20
        bKYKukoQ9YvvaeM0DJ3BmCWMId2YkWXIVBLJqWm706KipbJwWSwZQ0gMtJ5REol71OGqLJ03
        HSE5ROuyvZSatliIyPg4szHbykg0RotVSTCmDJ0pxhRhofWWbENmhIGx7pBJpfIor/BDrWZs
        yIOZ8v1yrn7Xh+SBYn4xEPAhroC1NU2gGPjxRXgHgOM1XQhbzAN4tOQJyhYLAH5/t9or469Y
        rjv8Wf4agKcvfcZji98ArB2fRn37YngknCp0cX04EH8VHrM/4PhEKD7GhacuPF4RCXA5PGd3
        rOAN+H548XYj4uvA8Rr+Gjf7aCEeC7s7C1AWr4cDZyY4PoziIbB9pgZlM0ige7JxtZcKepa+
        QFlNIKwusq0kgHi1APbVFyCsIRGOekZX8QY43d/GY7EYTp208VhDCYD5j5ZXF5oBLDq6h8Vv
        wGdVbVzfoCgeCp3XItlT2Qp776/Otg4W9vzNY2khLLSJWON22NVexWFxMCypWeCWA8K+Jpl9
        TTL7mgT2/3udBRwH2MSYLPpMxiI3yf+77HSjvgWsPPwwVQf4fGY2ohsgfNANIB8lAoV/ynS0
        SJhBH85lzMY0c7aOsXSDKO9RV6DijelG788xWNNkilipIjpaFiOPksYQQcLYjVpahGfSVkbL
        MCbG/K8P4QvEeci79b0pl23ti47s4KmDn85d+nW9//5deAJXcyvxhYFhXoQi4/i855PzT1p/
        qWhy1+1VCg7sTP46R/eBfmy4P3id8c6OATlM6vn4WLnqYupD2UnDNmZoc0r4a1sESUvxr1cg
        20Nu5Cdw30p3/Zzbryp65WVHban72yTicbiGcSJqYV3qyPUTIwbd1psOxXHFO2L74dCcCsfT
        0tzbrUHquJ/2Vi6QsjlV6XDQrk2xVVn+V06HOtuOhD5S9l1xDgW82ezRL57tD1BHdgT98FJl
        ovbQ7LmDnn2DZvcc9/2G4COSyZ2Lqc25itGqhgNjIXlgWeiyNQw+/0g+8fbvZcr4bSAF5JcT
        HIuGloWhZgv9D4xtfCaBBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsWy7bCSvG7Q/pxEg4NPtS1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWsw/co7Vomens8XpCYuYLJ6sn8VssejGNiaLG7/aWC02
        vv3BZDHj/D4mi+7rO9gslh//x2Txf88OdovfPw8xOQh5XL7i7TGroZfN43JfL5PH5hVaHov3
        vGTy2LSqk81jwqIDjB7f13eweXx8eovFo2/LKkaPz5vkPNoPdDMF8ERx2aSk5mSWpRbp2yVw
        Zdy59IetoJWrYufuo0wNjF0cXYwcHBICJhJ7V3F3MXJxCAnsYJSYtrqBqYuREyguK/Hs3Q52
        CFtY4n7LEVaIomeMEnt+X2YESbAJ6Eu87NjGCmKLCKhKNM16wAJSxCzwglXi69TPTBAdbxgl
        jm6eAtbBKWAksXDWKmYQW1ggVKJh0j42kDNYgLq/3SsCCfMKWEoc2tPODGELSpyc+YQFpIRZ
        QE+ibSPYFGYBeYntb+cwQxynIPHz6TKoG9wk/vybygxRIyIxu7ONeQKj8Cwkk2YhTJqFZNIs
        JB0LGFlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIER76W1g7GPas+6B1iZOJgPMQo
        wcGsJML7xTAnUYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5O
        qQammVInj90L9qy9Ynupe7PCjC1nT075tvdmZ4wVy6PDajKbi3bu/2bjWcs8pck72jh295Uf
        ZfMu9J59cnLDvs5Ijpjo+Xw1LCnv5dzbQll+/9iQ4Po7vPxzCsul5/ZpK57Z2rrfWlClNPnR
        12tKjwoWM1guP6XIx/RIQ0/0gnCuad+6vqKmyMJ1E5LXfL5z/k/GaemzVl+5271lVZImTZkb
        H7YmOHOO95Gd0SU5Gvs93rz1XPPkx23Lw3NSMh57yGrW7tT4r3Fc5Oya4iuyuXrMK6d33/Rr
        rN+2WOx++fZ9178asb5N1PAz21C/vPk7g8L3Vfqb7+0/cOx2pcqy2n8xrmuLTld/ME619Vbo
        zj46VYmlOCPRUIu5qDgRAAi0bBNrAwAA
X-CMS-MailID: 20211018002658epcas2p2c0901189d4f522dbec802cfe43de3681
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081135epcas2p2d577fc8dec75471cf42024eda6a45690
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081135epcas2p2d577fc8dec75471cf42024eda6a45690@epcas2p2.samsung.com>
        <20211007080934.108804-14-chanho61.park@samsung.com>
        <YWmHQ5CVQd97JzHJ@robh.at.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +  samsung,sysreg:
> > +    $ref: '/schemas/types.yaml#/definitions/phandle'
> > +    description: phandle for FSYSx sysreg interface, used to control
> > +                 sysreg register bit for UFS IO Coherency
> > +
> > +  samsung,ufs-shareability-reg-offset:
> > +    $ref: '/schemas/types.yaml#/definitions/uint32'
> > +    description: Offset to the shareability register for io-coherency
> 
> Make these a single property: <phandle offset>

As I already mentioned previous e-mail [1], I need to support two ufs
instances for exynosauto v9 soc.

syscon_fsys2: syscon@17c20000 {
	compatible = "samsung,exynosautov9-sysreg", "syscon";
	reg = <0x17c20000 0x1000>;
};

ufs_0: ufs0@17e00000 {
	<snip>
	samsung,sysreg = <&syscon_fsys2>;
	samsung,ufs-shareability-reg-offset = <0x710>;
};

To be added ufs_1 like below
ufs_1: ufs0@17f00000 {
	<snip>
	samsung,sysreg = <&syscon_fsys2>;
	samsung,ufs-shareability-reg-offset = <0x714>;
};

[1]:
https://lore.kernel.org/linux-scsi/000901d7b0e0$e618b220$b24a1660$@samsung.c
om/

If you prefer them to be separated sysreg phandles which directly pointing
the register, I'm able to change it.
But, the syscon_fsys2 can be used for other IPs as well such as ethernet.

Best Regards,
Chanho Park

