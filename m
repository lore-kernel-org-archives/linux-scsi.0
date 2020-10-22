Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E769EC388F7
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 04:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DDE22244C
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 04:59:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bFo2olMs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507662AbgJVE7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Oct 2020 00:59:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54494 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507659AbgJVE7Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Oct 2020 00:59:25 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201022045923epoutp0252217d346ffd091e388c6c98309216bd~AN7_f49VU2311323113epoutp02S
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2020 04:59:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201022045923epoutp0252217d346ffd091e388c6c98309216bd~AN7_f49VU2311323113epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603342763;
        bh=muG60whWZBs/6Uyti1Bh7sClEVmMd1x+Xw2mM+LqJ7A=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=bFo2olMsRGpf2OHlUqj84XsbGUdfkmX6SIAXfxKCUSsq7WLiEnRcLlw7JfDuwMi4e
         HXcB9cKXEuFHRvxGXF/ig1useUnch1ybplb8l/aWtR3mFiaXAY1qJwuWOOPBIV0hFG
         B/OXm3FYI7vvGlic7alkR+/DzAKHpLF1tNTpP590=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201022045923epcas2p1131a31caece21ea14b7117e6e4c3b417~AN7_PNk5T0402904029epcas2p1r;
        Thu, 22 Oct 2020 04:59:23 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4CGwBd65mczMqYlr; Thu, 22 Oct
        2020 04:59:21 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        9A.F3.09580.8A1119F5; Thu, 22 Oct 2020 13:59:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20201022045920epcas2p43fd9b42fc8effa8c93460a0cd2195e37~AN77rDbW70458904589epcas2p4L;
        Thu, 22 Oct 2020 04:59:20 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201022045920epsmtrp2c9206b0ad8dd4688356b84f1b5a4601c~AN77qQNpf2508725087epsmtrp2L;
        Thu, 22 Oct 2020 04:59:20 +0000 (GMT)
X-AuditID: b6c32a47-149ff7000000256c-00-5f9111a8604f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        70.26.08745.8A1119F5; Thu, 22 Oct 2020 13:59:20 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201022045920epsmtip10a9e145ee43d437496fb90edb3042fb6~AN77fxCL-2415024150epsmtip1d;
        Thu, 22 Oct 2020 04:59:20 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
Cc:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <0a5eb555-af2a-196a-2376-01dc4a92ae0c@acm.org>
Subject: RE: [PATCH] scsi: ufs: make sure scan sequence for multiple hosts
Date:   Thu, 22 Oct 2020 13:59:20 +0900
Message-ID: <008a01d6a830$1a109800$4e31c800$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQE8rU9GG02+1hbAo1p5qXUnN9CPVgF+Wj0dAilh/bkB8/KS2gLgSNF8qpLsV7A=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmue4KwYnxBnM7LSwezNvGZvHy51U2
        i2kffjJbLLqxjcni8q45bBbd13ewWSw//o/Jgd3j8hVvjwmLDjB6fHx6i8Wjb8sqRo/Pm+Q8
        2g90MwWwReXYZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
        5gCdoqRQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkpMDQs0CtOzC0uzUvXS87PtTI0
        MDAyBapMyMk4e2AiU8Ej9opJnQcZGxgnsHUxcnJICJhIXJnaytjFyMUhJLCDUWLD6YnMEM4n
        Rok9E2+wQzifGSWmtd9kh2m59/wUVGIXUNX6bhaQhJDAC0aJxdPAitgE9CVedmxjBbFFBJIk
        pj6/wQhiMwuUSOzYN4EZxOYUsJZ4e349UxcjB4ewgJdEw1NHkDCLgKpE/9XXYCN5BSwlDmzq
        YYewBSVOznzCAjFGW2LZwtfMEPcoSPx8uowVIi4iMbuzjRlirZ/EzAs7od6cySGxYpUAhO0i
        sWdBHyuELSzx6vgWqL+kJD6/2wtVXy+x4lETOCQkBHoYJV5O+we1zF5i5tOlYDczC2hKrN+l
        D2JKCChLHLkFdRqfRMfhv+wQYV6JjjYhiEZ1iQPbp7NA2LIS3XM+s05gVJqF5LFZSB6bheSZ
        WQi7FjCyrGIUSy0ozk1PLTYqMEaO6k2M4ESq5b6DccbbD3qHGJk4GA8xSnAwK4nw5olOiBfi
        TUmsrEotyo8vKs1JLT7EaAoM6onMUqLJ+cBUnlcSb2hqZGZmYGlqYWpmZKEkzhu6si9eSCA9
        sSQ1OzW1ILUIpo+Jg1OqgSkjyjW/dYPmR10DJhmfPBn2pyJXnjP/O9Trs+lud9r12mnFDEtv
        i+7r2yPr8unVp8yFy74+epXksC/R3vJo2PncsyUzWLU28x/J0txkuN7WUG+dW1fTJvtAfQ2V
        vHr3SfvTdlWEzzOd3spndttryS3vlLM/j9ncDIu2jjX+NClK89O1DFPXQ+127eueael4mG+w
        bnwvO+VBaPpeptLdORwCTWx7Jhl1zhC+3FBoEXv7wfsDd9oUNQ6cfyjTeOl9mMBhDvUUSe7z
        i6rrTZa7Ch7gkbtxQyPiQoBXvaTtl5krTzUsk5jf/Im9R/q4uU56fuRtQY8Ih+PZBam3mRSD
        UvPcL9WyH4qZ9/Dn9YuPlViKMxINtZiLihMB0gdT5S0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LZdlhJTneF4MR4gydXxS0ezNvGZvHy51U2
        i2kffjJbLLqxjcni8q45bBbd13ewWSw//o/Jgd3j8hVvjwmLDjB6fHx6i8Wjb8sqRo/Pm+Q8
        2g90MwWwRXHZpKTmZJalFunbJXBlPJ98jrXgAXtFz+4LbA2MXWxdjJwcEgImEveen2LvYuTi
        EBLYwShxaP1CqISsxLN3O9ghbGGJ+y1HWCGKnjFKHJhykREkwSagL/GyYxtQgoNDRCBFoueR
        F0iYWaBC4lDnU0aI+rlMEjNmHGECSXAKWEu8Pb+eCaReWMBLouGpI0iYRUBVov/qaxYQm1fA
        UuLAph52CFtQ4uTMJywQM7Uleh+2MsLYyxa+Zoa4TUHi59NlrBBxEYnZnW1gcREBP4mZF3ay
        TWAUnoVk1Cwko2YhGTULSfsCRpZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjBUaWl
        tYNxz6oPeocYmTgYDzFKcDArifDmiU6IF+JNSaysSi3Kjy8qzUktPsQozcGiJM77ddbCOCGB
        9MSS1OzU1ILUIpgsEwenVAMTQ+AWydqDHUuEi8IOvE9aclQly0S4LCf+0Vyz/FeXbEWCu74v
        silpzpHh7+2YPnPrzN4GddZIg/Bd3+f+brHkmb3o+Cf1DLHza63kIg9K/1t7qHOF8vUlb/Wn
        N+yR1751UrnS0elp+lfmr3MK2fcG9SvtC3mcXffgS5tE6ZItrftOxOxMWP19XvOcTOE2t6fh
        uzy9s0KdDtxlqCpbNG168Qoph9OSHQasK8p9U4tFTu0wTuS0ON/69ijLoh6V41+udSgU7LSo
        6gkOKr369bmeYevS+eumMbX/VFu14b/VtSix6+5zP6689mbzskOxq6ZGv6gM2H5e/87zZ+cX
        bqlz+rzVu6uFY35P+SfB0+qNSizFGYmGWsxFxYkASRhY2RkDAAA=
X-CMS-MailID: 20201022045920epcas2p43fd9b42fc8effa8c93460a0cd2195e37
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201020070519epcas2p27906d7db7c74e45f2acf8243ec2eae1d
References: <CGME20201020070519epcas2p27906d7db7c74e45f2acf8243ec2eae1d@epcas2p2.samsung.com>
        <20201020070516.129273-1-chanho61.park@samsung.com>
        <7fafcc82-2c42-8ef5-14a6-7906b5956363@acm.org>
        <000a01d6a761$efafcaf0$cf0f60d0$@samsung.com>
        <0a5eb555-af2a-196a-2376-01dc4a92ae0c@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Did you mean /dev/disk/by-=5Bpart=5Dlabel/ symlink? It's quite reasonab=
le to
> > use them by udev in userspace such as initramfs but some cases does not
> use
> > initramfs or initrd. In that case, we need to load the root
> > device(/dev/sda=5BN=5D) directly from kernel.
>=20
> Please use udev or systemd instead of adding code in the UFS driver that
> is
> not necessary when udev or systemd is used.
>

What I mentioned was how it can be handled when we mount rootfs directly fr=
om kernel.

1) kernel -> initramfs (mount root) -> systemd
2) kernel (mount root) -> systemd
 -> In this case, we normally use root=3D/dev/sda1 from kernel commandline =
to mount the rootfs.

Like fstab can support legacy node mount, ufs driver also needs to provide =
an option for using the permanent legacy node. If you're really worry about=
 adding a new codes for all UFS driver, we can put this as controller speci=
fic or optional feature.

Best Regards,
Chanho Park

