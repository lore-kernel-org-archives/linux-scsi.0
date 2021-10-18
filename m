Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F15C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 11:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A6B860F11
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 11:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhJRLJ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 07:09:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21873 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhJRLJ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 07:09:26 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20211018110713epoutp037b63ee4a41292427deab8340b22fa979~vG1MA1blY0811608116epoutp03b
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 11:07:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20211018110713epoutp037b63ee4a41292427deab8340b22fa979~vG1MA1blY0811608116epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634555233;
        bh=A/dUew/0m6/p42js42mzhiPmTLpYJBiKwSk+vqXNOzc=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=uLU/7R7xP9NrWMllQ+VM4MruRiPC9euupMiWyKOo5KJgvEAGz3OQ1408e6/5Qhj66
         5zTNDpkncSkAfaeZiPz+RjQ9K8TMqs6J0El5BfYAOowJVsE5sNBkhjxpi0jleidjjM
         tqRxST8FynFGS3I8IInyFEozsGv3oaqLi2U6Xzd0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20211018110712epcas2p4fac7cd4c0f64ebaa86e66b461207e418~vG1LKwHuo0168801688epcas2p46;
        Mon, 18 Oct 2021 11:07:12 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.102]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HXvGN59Vxz4x9Q9; Mon, 18 Oct
        2021 11:07:08 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D4.B4.10018.C555D616; Mon, 18 Oct 2021 20:07:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211018110707epcas2p3fe47df7f957cb4f0890c79187874f0eb~vG1G_4do50354303543epcas2p3y;
        Mon, 18 Oct 2021 11:07:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211018110707epsmtrp2743702753da6d454b12e7c665b3774a7~vG1G98RqF2483724837epsmtrp2T;
        Mon, 18 Oct 2021 11:07:07 +0000 (GMT)
X-AuditID: b6c32a46-a25ff70000002722-49-616d555c9e39
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B0.2C.08902.B555D616; Mon, 18 Oct 2021 20:07:07 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20211018110707epsmtip1b0a4042f0cac5b996d15985ca0823063~vG1Gurzph2206022060epsmtip1j;
        Mon, 18 Oct 2021 11:07:07 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Rob Herring'" <robh@kernel.org>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>
Cc:     "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
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
In-Reply-To: 
Subject: RE: [PATCH v4 13/16] dt-bindings: ufs: exynos-ufs: add io-coherency
 property
Date:   Mon, 18 Oct 2021 20:07:07 +0900
Message-ID: <011e01d7c410$4a420340$dec609c0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQL83TaU2gFk6OcLuUCqdNaZ93XEzwFG39bFAmgxteoCt4IMOKlae17AgAC0YqA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJsWRmVeSWpSXmKPExsWy7bCmhW5MaG6iwfWzqhYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLeYfOcdq0bPT2eL0hEVMFk/Wz2K2WHRjG5PFjV9trBYb
        3/5gsphxfh+TRff1HWwWy4//Y7L4v2cHu8Xvn4eYHIQ8Ll/x9pjV0Mvmcbmvl8lj8wotj8V7
        XjJ5bFrVyeYxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkCeKKybTJSE1NSixRS85Lz
        UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAvlNSKEvMKQUKBSQWFyvp29kU
        5ZeWpCpk5BeX2CqlFqTkFJgX6BUn5haX5qXr5aWWWBkaGBiZAhUmZGc0dZ9hKZjAX3Hrm2gD
        4wSeLkZODgkBE4k3968xdjFycQgJ7GCUuDZjHSNIQkjgE6PEnXdlEIlvjBLXd11h6WLkAOuY
        clEBIr6XUeLX6VnsEM4LRonDMz4ygXSzCehLvOzYxgrSICKQIvFzfiZIDbPAXFaJf0fngg3i
        FOCVmPDPGqRcWCBcYt2xZWCtLAKqEg/ap7OA2LwClhIntn2DsgUlTs58AmYzC8hLbH87hxni
        AwWJn0+XsYLYIgJ+El3vpzNC1IhIzO5sYwbZKyEwnVPi9beVjBANLhIr7l2EahaWeHV8CzuE
        LSXx+d1eNoiGbkaJ1kf/oRKrGSU6G30gbHuJX9O3gD3GLKApsX6XPiRQlCWO3IK6jU+i4/Bf
        dogwr0RHmxBEo7rEge0Qb0kIyEp0z/nMOoFRaRaSz2Yh+WwWkg9mIexawMiyilEstaA4Nz21
        2KjACB7Tyfm5mxjBqV7LbQfjlLcf9A4xMnEwHmKU4GBWEuFNcs1NFOJNSaysSi3Kjy8qzUkt
        PsRoCgzricxSosn5wGyTVxJvaGJpYGJmZmhuZGpgriTOaymanSgkkJ5YkpqdmlqQWgTTx8TB
        KdXAJPxr8ZmXNcuikwoc9bbuF54jJaijbtt0s2eZsH0hw97oF4k/GDVf8HguYfJY9E9YsODB
        JzctQ8m399xZyiR5HAtk5ZKcHrfUN0/S7WLSZbS2m7BdLvC+YcmvjDyGkpqm+5dOpL/NWl0W
        uEGJrTfimam9zItJSysNgtqSgxeU3Zs15dDBaGeGJ//kxd6LLiv4EhIVfoNVSmzSos9tNR5d
        DLtfG1SmzTp8LnlWGNOSR2UuMVb73ZaJTJDYqHs3uXvBmvqJn5+oHH61xmuuzvEvc3aHzCtk
        n1F3tbbEPrnSk8XjkPuyb9LaMUsfqwr3p3toifwynzB5g0HQhXMnD6v1f7LKDTWZOUsymfNJ
        9EslluKMREMt5qLiRACWpqShfgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA01RfUyMcRzf73meezx3Oh5XzY9CnbdkpSzbzzLvzWPMe7GynUc9LnR1u6cU
        lt2wri7pESs9JMt6cUyE67wsddrRMrRYJ1mHrq2Rk3LEhKtM/332+X7eti+FK9qIqdTe5FRO
        l8wmKUkZYX6onB4SF61hwwRXIGrqukoixwUziXoGX5Ko4W0OgQo/D+LoS3WFBJU2PpWgE3dW
        oWahDENd1SKOyuxmDNl/ZEnQjd7vGDr7rA5DuW0WElU+GsLQ7/uWcejnoBVbrmBaX6xjRH0e
        ybSezMOYm1XBzKX7PRhTY8ohGaGsHjDfqrNJps/ZTjAnb5kA018znTHU52KbvGJlSxK4pL0H
        ON2CpbtkiUdznxBaYWJGu9tXDwQvI6AoSEfAMy0BRiCjFPQ9AK+9qyKNQPqXnwa7P1nGjWBv
        2Hm8UTIi6gawqOrB8IGkF8CebLPEg33oBDhU/3xYhNOXJdBZK4ARRy+ABls56amT0nIoDEV6
        DN50NNQX1A23EfRs6DAUER4spxfDx2b3KJ4Em4q7CI8Vp0Nh1g3goXF6BqztPY+PjAuAg86K
        0Q0boNFVNKrxgedysnABeItjksT/SeKYJHGM4yIgTGAKp+U1ag0frg1P5tJDeVbDpyWrQ+NT
        NDVg+PfB8yyg1vQ51AowClgBpHClj3x3lIZVyBPYg4c4XYpKl5bE8VbgRxHKyfLnxiaVglaz
        qdx+jtNyun9XjJJO1WNs0J0MFVtpCHFf8SsKKT0mph96/0NVQE0Leh0VmCofv+3X2lex822m
        w2En8ia0bLkkbTrYnPg2Zmb1KVadvrVvtjnxjetKAfe1eOuXWyUu38dBcedO7an0n1fgUNyt
        6y/N7Fi4psNfmjAz4uZEP+ur/NYjK0o2dhhEwje/LL6wLaDdufNJZ/OvZSt7dmTErgf2cjF7
        7Teb+HXAa8+qAZfaf1axc7venTZps8NYIqy20R/r6Ln8ypjv7NxYraN7vLq3f8Ymhe10xcN4
        mb0h7syjp/s6NYURt+nO6JQLUdfmNESGCTHuyB12dLXv/dHMgYsW02vVh0x+kZZoS81vbCm/
        riT4RDY8GNfx7B8Z4L6fagMAAA==
X-CMS-MailID: 20211018110707epcas2p3fe47df7f957cb4f0890c79187874f0eb
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

> > > +  samsung,sysreg:
> > > +    $ref: '/schemas/types.yaml#/definitions/phandle'
> > > +    description: phandle for FSYSx sysreg interface, used to control
> > > +                 sysreg register bit for UFS IO Coherency
> > > +
> > > +  samsung,ufs-shareability-reg-offset:
> > > +    $ref: '/schemas/types.yaml#/definitions/uint32'
> > > +    description: Offset to the shareability register for
> > > + io-coherency
> >
> > Make these a single property: <phandle offset>
> 
> As I already mentioned previous e-mail [1], I need to support two ufs
> instances for exynosauto v9 soc.
> 
> syscon_fsys2: syscon@17c20000 {
> 	compatible = "samsung,exynosautov9-sysreg", "syscon";
> 	reg = <0x17c20000 0x1000>;
> };
> 
> ufs_0: ufs0@17e00000 {
> 	<snip>
> 	samsung,sysreg = <&syscon_fsys2>;
> 	samsung,ufs-shareability-reg-offset = <0x710>; };
> 
> To be added ufs_1 like below
> ufs_1: ufs0@17f00000 {
> 	<snip>
> 	samsung,sysreg = <&syscon_fsys2>;
> 	samsung,ufs-shareability-reg-offset = <0x714>; };
> 
> [1]: https://lore.kernel.org/linux-
> scsi/000901d7b0e0$e618b220$b24a1660$@samsung.com/
> 
> If you prefer them to be separated sysreg phandles which directly pointing
> the register, I'm able to change it.
> But, the syscon_fsys2 can be used for other IPs as well such as ethernet.

Finally, I got your point. You want me to drop
"samsung,ufs-shareability-reg-offset" and put the offset like below.

ufs_0: ufs0@17e00000 {
 	<snip>
 	samsung,sysreg = <&syscon_fsys2 0x710>;

To be added ufs_1 like below
ufs_1: ufs0@17f00000 {
 	<snip>
 	samsung,sysreg = <&syscon_fsys2 0x714>;

I'll resend the patch with your suggestion.

Krzysztof, could you please hold below on? Or Do I need to make an
additional patch?
https://git.kernel.org/pub/scm/linux/kernel/git/krzk/linux.git/commit/?h=nex
t/dt64&id=31bbac5263aa63dfc8bfed2180bb6a5a3c531681

Best Regards,
Chanho Park

