Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22605C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 00:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09B7461153
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 00:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238631AbhIWAtV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 20:49:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41535 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238696AbhIWAtV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 20:49:21 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210923004749epoutp0490d72d297bdbefc2424e32b6e1a70118~nTQPmN47I2986929869epoutp041
        for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2021 00:47:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210923004749epoutp0490d72d297bdbefc2424e32b6e1a70118~nTQPmN47I2986929869epoutp041
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632358069;
        bh=MyB6OdmybLyf267TIf7iS1VVSqdpAxqYVcIPXV9QST0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ecTlr0BqRfili271w58R3gTb4GbyQhSvE7xCJJahMqCJ1VmXRd4qKJ3YJZvvDAcpu
         dSC8Rd/cqdqPv9cC+eXPZRHlXekBeaUyX5RbUqvUnyYsYwUGxqku3ZwEJpFSwvVBVb
         viYKfxPhLdyRWAGJyisSZspEqOA8lPVNPM0xMUCE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210923004748epcas2p3af0e7eb1c7b3648af2b191f95ec63c9e~nTQPM4s5s0497604976epcas2p3u;
        Thu, 23 Sep 2021 00:47:48 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HFGjG1tDnz4x9Q6; Thu, 23 Sep
        2021 00:47:46 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E2.D7.09816.1BECB416; Thu, 23 Sep 2021 09:47:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210923004744epcas2p2bbff0cfc43afad8dd60f5df925d66b92~nTQLeQfkk0159401594epcas2p2q;
        Thu, 23 Sep 2021 00:47:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210923004744epsmtrp1c7867154491897d6dacca8b9d5dab0c0~nTQLNE5KE0894208942epsmtrp1E;
        Thu, 23 Sep 2021 00:47:44 +0000 (GMT)
X-AuditID: b6c32a46-63bff70000002658-22-614bceb12f49
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1D.6B.09091.0BECB416; Thu, 23 Sep 2021 09:47:44 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210923004744epsmtip2077dfb36bb1ac3af73be9c2647ee6dd6~nTQK8uJzL0448804488epsmtip2z;
        Thu, 23 Sep 2021 00:47:44 +0000 (GMT)
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
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <devicetree@vger.kernel.org>
In-Reply-To: <YUuKpSPgdKl2CiSy@robh.at.kernel.org>
Subject: RE: [PATCH v3 05/17] dt-bindings: ufs: exynos-ufs: add sysreg
 regmap property
Date:   Thu, 23 Sep 2021 09:47:44 +0900
Message-ID: <000801d7b014$9ed9fe40$dc8dfac0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQLrZ3V1AdZHg9YCn30eDqnNeWNQ
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUwbZRzOe9dej0GXWwH3ikHqbZOP8dVuLQcBQdbgCcyRLEYx03qDCyUr
        bdMDv7I/uk4YpWOAGqAVNlYVlI0QaoVuorJChDmGyTbcVjOdWnQ1Yw7YYJAItj1U/nt+H8/7
        PL/f+744KvFhMXilrpo16hgtiW0SDI4mKlIGpoqY9MtWEXXRdxajbp8cxCj/8jRGXfjFIqBa
        7y+j1Hx/t5A6NTYlpI6f20NdanYglK/fjlKOG4MINTD7CKHav/8aoazX3RjVM76KUGvDblEe
        QV+9VkTbTY0YffVEI0J//mkS/dGwH6GdvRaMbnaMAHqpvx6j52a8AvqEqxfQC84n6WMjVqQk
        4hVttoZlylmjlNWV6csrdRU5ZNF+9R61QpkuS5FlUhmkVMdUsTmkqrgkpaBSG5iJlL7BaGsC
        qRKG48i0Z7KN+ppqVqrRc9U5JGso1xpkMkMqx1RxNbqK1DJ9VZYsPV2uCHS+rtWYOt1CQ5/w
        reFbGhOoFTSAMBwSu2H78CLaADbhEsIN4He2swI+mAfQN2PD+GARwMY/vP9RGoZ/RoNYQnwF
        4FH783zTHQDvrS0LgwWMSIP++sEQjiJ2QLP9duhYlLAIocPnCRXCCDm0ei6JgjiSeBk2zXcG
        5HBcECBYJjOCaTGRCTssXhGPt8CLNl/IBErEwaHZDpQ3JIXLM91CPh8FP7TUobxuAfxsvDuk
        CwlrGGwZuIDxBBW87voE4XEk/HPcJeJxDPQ31YnWCQDW/rq2XjgDoOVIMY9z4UqbSxg0ihKJ
        sP98WhBCYhsc86572wzrR/8W8WkxrK+T8MR4ODLUtr7DWGjtWBA2A9K+YTL7hsnsG6ax/6/V
        BQS94DHWwFVVsJzcIN94104Qeu5JBW7wwez9VA9AcOABEEfJKPHCjUJGIi5n3n6HNerVxhot
        y3mAIrDqFjQmukwf+C+6arVMIVcq0zMVlEIpp8it4s7VfEZCVDDV7CGWNbDGf3kIHhZjQiyt
        5XPKra5vSruas/uXonOvWetezYse0kfv246ZVWXmgXBfbPGBldpn7YXec/OzPZdzR5Yjtn27
        snly8qD/inmnM7G28i6e/GZX053w5Ex8i21f49wLfS1eXStnfvEHm7+g8ejvnlWH77imNPYp
        1YOS5EPxvjSJEz8ifW91Il/tn+r64oH04EKcKvFdpOjLR6jtr7zDMQmOmoTw7mNZO3efarny
        MOJkT+T4/vMDI6NVv926qXpph2n14eG+uN5SwxOnf/wp/qYowdW+N6OkY1flPfVzj3+snN5b
        OjG9pH3/6QOixXyzVlQ7N7Hr7gQ6tljY5nP3vWYak7r86JmO0bKswsEuUsBpGFkSauSYfwDo
        dJcOdwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWy7bCSvO6Gc96JBjdn8FucfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtZh/5ByrRc9OZ4vTExYxWTxZP4vZYtGNbUwWG9/+YLKY
        cX4fk0X39R1sFsuP/2Oy+L9nB7uDgMflK94esxp62Twu9/UyeWxeoeWxeM9LJo9NqzrZPCYs
        OsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBPFJdNSmpOZllqkb5dAldGw9wdrAVrWSv2
        3M1oYGxl6WLk5JAQMJHo2nOfGcQWEtjNKPFrNztEXFbi2bsdULawxP2WI6xdjFxANc8YJX5P
        vQ3WzCagL/GyYxsriC0ioCrRNOsBC0gRs8BkVon9q9oYITpeM0rs2TuFCaSKU8BIovvQaaCx
        HBzCAmES+3fYgZgsQM2dZ8xBKngFLCXmdN5ih7AFJU7OfMICUsIsoCfRtpERJMwsIC+x/e0c
        ZojbFCR+Pl3GChEXkZjd2cYMcY6bxMrjy1gmMArPQjJpFsKkWUgmzULSvYCRZRWjZGpBcW56
        brFhgWFearlecWJucWleul5yfu4mRnCEa2nuYNy+6oPeIUYmDsZDjBIczEoivJ9veCUK8aYk
        VlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwLTF/bvu1a2z4q/3
        6l+wnBD55PyS55O1fj2ZPCfyz6rFVtvlWUpKL9VMDzha8UdowzdTPbYJnEqTPBPfvLwjMys2
        Id4/5tipz467NggI9UiveNn4xtM6bOmaR6zBdR7Xj1o7npzTMrfSXcIn3l0w+nrd9mM7dXKf
        NNqrKXzI9E3rdHX5svxo//beVbl63qxKLN9eTprI//Fbxa+zzjs3GWimpfK2TlZecLpuX/CZ
        X77Nx1dOmjH/65lUM+d1LasteG+sXvfg4eu4IxHMM1clyYu/ePWVY++UbcL33vd+c3x0/mrR
        mplNvmee19i4BVX7rZH4dcXvgx9nDufXp8xbTsh+v/bYYbbQD62ZFycwrb/ZpMRSnJFoqMVc
        VJwIAIaKxEZfAwAA
X-CMS-MailID: 20210923004744epcas2p2bbff0cfc43afad8dd60f5df925d66b92
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p3ff66daa15c8c782f839422756c388d93
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p3ff66daa15c8c782f839422756c388d93@epcas2p3.samsung.com>
        <20210917065436.145629-6-chanho61.park@samsung.com>
        <YUuKpSPgdKl2CiSy@robh.at.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +  sysreg:
> 
> Needs a vendor prefix.

Thanks. I'll use "samsung,sysreg-phandle".

> 
> > +    $ref: '/schemas/types.yaml#/definitions/phandle'
> > +    description: phandle for FSYS sysreg interface, used to control
> > +                 sysreg register bit for UFS IO Coherency
> 
> Is there more than 1 FSYS? If not, you can just get the node by its
> compatible.

The phandle can be differed each exynos SoCs, AFAIK. I think other exynos
SoCs since exnos7 will need this but not upstreamed yet...

> 
> Also, what about 'dma-coherent' property? The driver core needs to know.

Yes. 'dma-coherent' should be listed as well.

Best Regards,
Chanho Park

