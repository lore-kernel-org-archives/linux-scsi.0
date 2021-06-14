Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDF1C48BE6
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 09:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DED0661357
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 09:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbhFNJy4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 05:54:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14009 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbhFNJyy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 05:54:54 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210614095250epoutp04a18fc66bb810c04208edaec0dcd40354~IaiSEu7kT0451804518epoutp04G
        for <linux-scsi@vger.kernel.org>; Mon, 14 Jun 2021 09:52:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210614095250epoutp04a18fc66bb810c04208edaec0dcd40354~IaiSEu7kT0451804518epoutp04G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623664370;
        bh=Jnba7HNp4tDfvtshitsQ9HvzTfYRmhGBL9/Zu5pNwWY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=fCcREFz2rh6xF9QgxfJ2uWfup/qloZkaJ1vTcigInZn/irv0DAwNUlJB/edSR1VN0
         xRqDcc8Qmum7lW1CNcrVSybQK140LjKIQDOBpPqiRh5wow0yyQXvYFRuhb5jO3JZRU
         KdT0hq0CIJV8+24rY3ki3G+FWVlha1WnFvgsxQg4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210614095249epcas2p39fa7028516ea8f25302566f651e163ff~IaiRIBqXz1377813778epcas2p3d;
        Mon, 14 Jun 2021 09:52:49 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4G3RZl4cDDz4x9Pw; Mon, 14 Jun
        2021 09:52:47 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        19.CC.09433.EE627C06; Mon, 14 Jun 2021 18:52:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210614095245epcas2p2e8512382423332786f584d5ef1e225d3~IaiNfeguC0182701827epcas2p2v;
        Mon, 14 Jun 2021 09:52:45 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210614095245epsmtrp16167d22ccfda9a9eff68b3718939d872~IaiNev4T23143531435epsmtrp1p;
        Mon, 14 Jun 2021 09:52:45 +0000 (GMT)
X-AuditID: b6c32a47-f61ff700000024d9-d1-60c726ee02d2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C2.D2.08163.DE627C06; Mon, 14 Jun 2021 18:52:45 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210614095245epsmtip2d9de53db206581bdc2cee9e66c190d8f~IaiNUQaUv0355303553epsmtip2d;
        Mon, 14 Jun 2021 09:52:45 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <linux-scsi@vger.kernel.org>
Cc:     "'Can Guo'" <cang@codeaurora.org>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Subject: Question about coherency of comand context between ufs and scsi
Date:   Mon, 14 Jun 2021 18:52:45 +0900
Message-ID: <000001d76103$06c3cb50$144b61f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AddhAwaH2PiR9/n6ThSsaVJwmtP3+A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmhe47teMJBpu+clu8/HmVzeLgw04W
        i2kffjJbfFq/jNXiyfpZzBbd13ewObB5XL7i7XG5r5fJY9OqTjaP7+s72Dw+b5LzaD/QzRTA
        FpVjk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0hZJC
        WWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwNCwQK84Mbe4NC9dLzk/18rQwMDIFKgy
        ISfj/801bAUfpSteXJnA1sDYJtHFyMEhIWAi8WlOeRcjJ4eQwA5GiR8vGbsYuYDsT4wSXy9P
        Z4FwPjNKTNm/lhGkCqThw6G1UIldjBLX3i9kg3BeMErc6NkAVsUmoC0x7eFuVhBbREBB4m/b
        IWaQImaBw4wS9181MIMkhAU8JLpOz2YBsVkEVCWWvu8Ai/MKWEo0P57JAmELSpyc+QTMZgYa
        umzha2aIMxQkfj5dBrVAT2La4bNsEDUiErM728CWSQh8ZJdYf7edDaLBReLv8h0sELawxKvj
        W9ghbCmJl/1tUHa9xL6pDawQzT2MEk/3/YN62lhi1rN2RlCIMQtoSqzfpQ8JPGWJI7egbuOT
        6Dj8lx0izCvR0SYE0ags8WvSZKghkhIzb96B2gT0+oNXrBMYFWch+XIWki9nIflmFsLeBYws
        qxjFUguKc9NTi40KjJEjexMjOIVque9gnPH2g94hRiYOxkOMEhzMSiK8z7oOJwjxpiRWVqUW
        5ccXleakFh9iNAWG+0RmKdHkfGASzyuJNzQ1MjMzsDS1MDUzslAS5+VgP5QgJJCeWJKanZpa
        kFoE08fEwSnVwFT5x3WH9LxdXaYxN4RKv/SvPZyl5JA1bb/EHC+vshaX7e9C9PxtdHUOcS15
        LNEmfDhf5Pllgbeb4vwVFD1kL3g/MV/Pc+Xwvif3mhV+3VJuf6e0zOvxRr/e+q8v7Qs/c8ZN
        0b/z6I2Q0qq/ORf3P59gFB0ddN04UnsPf3htw8qN/oe7tJ+t3ch6uymgRHfTT1mvlWfyv57+
        uObxobWuSkeKviyI6Is613br9cwj2p7HnRfpfNE/+sSFtduFffmB978c6jasNUzMKS/Ysu3u
        +i2z/S/Krz4p1yejvMgt+4bqm+CEI0V7tv5TUV8lUWm4ScNgc+xnh7kra6Y2Wy05aZSUsWHJ
        pUflL47XP+fKcj6mxFKckWioxVxUnAgAmipKiSoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWy7bCSvO5bteMJBu/u6lq8/HmVzeLgw04W
        i2kffjJbfFq/jNXiyfpZzBbd13ewObB5XL7i7XG5r5fJY9OqTjaP7+s72Dw+b5LzaD/QzRTA
        FsVlk5Kak1mWWqRvl8CV8XfjffaCZqmKXV0L2RsY54h1MXJySAiYSHw4tJYFxBYS2MEosXiN
        AERcUuLEzueMELawxP2WI6xdjFxANc8YJU5NWsMKkmAT0JaY9nA3mC0ioCDxt+0QM0gRs8Bx
        RomWec3MIAlhAQ+JrtOzwTawCKhKLH3fARbnFbCUaH48kwXCFpQ4OfMJmM0MNPTpzadw9rKF
        r5khrlCQ+Pl0GdQyPYlph8+yQdSISMzubGOewCg4C8moWUhGzUIyahaSlgWMLKsYJVMLinPT
        c4sNC4zyUsv1ihNzi0vz0vWS83M3MYKjQ0trB+OeVR/0DjEycTAeYpTgYFYS4X3WdThBiDcl
        sbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqaefTs33vL4tpnt
        ftNF8bUSHmyR+i+2xt+reKZRsVvjoxXX3ZxlS1g6bBfdDDHqU06N4j5/+Xn7rmObb37a5zVn
        Fvs5fol1U42st3Q3lS9zYXn6d7WuKH/1rJJU2w+dGRaGGhNFn3lcj3ql4PLrZNuDOcX3VBZ8
        mVnY4SghorInbfsmQa/CEx+UDxrfKL1f0Nig/eXevU4J7cVzje3qZom63v5fqeX0XvxhiHud
        bG909+EzNzpeZFxaEc2taVnY8cr9gVlihOrt/T9FD2g0pAp4ST3jfSzMJ7VEqNZx7pe83o2z
        CnIXK2nfUTmy72oZQ8taxqLi1BSt133P2O08IkPXfHB2u7q1XuJ/nd0JKyWW4oxEQy3mouJE
        ABL2lZ39AgAA
X-CMS-MailID: 20210614095245epcas2p2e8512382423332786f584d5ef1e225d3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210614095245epcas2p2e8512382423332786f584d5ef1e225d3
References: <CGME20210614095245epcas2p2e8512382423332786f584d5ef1e225d3@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear All

I saw one symptom and started wondering on how a command context is synchro=
nized between ufs and scsi.
In the situation where the following log happened, the lrb structure for ta=
g 10 didn't have a command context.
That is, lrbp->cmd was null, so it led to this kernel panic.

lrbp->cmd is set when a command is issued, and cleared when the command is =
completed.
But what if the command is timed-out and it's completed because its respons=
e comes in at the same time?

If scsi added it into its error command list and wakes-up scsi_eh though th=
e command is actually completed, scsi_eh will invoke eh_abort_handler and t=
he symptom will be duplicated, I think

Otherwise, is there anyone who know how to guarantee the coherency?


=5B78843.058729=5D =5B3:  kworker/u16:1:27018=5D exynos-ufs 13100000.ufs: u=
fshcd_abort: cmd was completed, but without a notifying intr, tag =3D 10
=5B78843.058775=5D =5B3:  kworker/u16:1:27018=5D exynos-ufs 13100000.ufs: u=
fshcd_abort: Device abort task at tag 10
=5B78843.058793=5D =5B3:  kworker/u16:1:27018=5D Unable to handle kernel NU=
LL pointer dereference at virtual address 0000000000000160
..
=5B78843.075421=5D =5B3:  kworker/u16:1:27018=5D pc : scsi_print_command+0x=
24/0x340
=5B78843.075436=5D =5B3:  kworker/u16:1:27018=5D lr : ufshcd_abort+0x180/0x=
674
=5B78843.075444=5D =5B3:  kworker/u16:1:27018=5D sp : ffffffc038ea3c00
=5B78843.075453=5D =5B3:  kworker/u16:1:27018=5D x29: ffffffc038ea3c10 x28:=
 0000000000000400=20
=5B78843.075464=5D =5B3:  kworker/u16:1:27018=5D x27: ffffff8934c0a680 x26:=
 ffffff8931560000=20
=5B78843.075474=5D =5B3:  kworker/u16:1:27018=5D x25: 000000000002000a x24:=
 ffffff88a0dd4910=20
=5B78843.075485=5D =5B3:  kworker/u16:1:27018=5D x23: 0000000000000000 x22:=
 ffffff8930f258f0=20
=5B78843.075495=5D =5B3:  kworker/u16:1:27018=5D x21: ffffff8934c0a080 x20:=
 000000000000000a=20
=5B78843.075505=5D =5B3:  kworker/u16:1:27018=5D x19: ffffff8931560cf8 x18:=
 ffffffc037557030=20
=5B78843.075516=5D =5B3:  kworker/u16:1:27018=5D x17: 0000000000000000 x16:=
 ffffffc010eeba70=20
=5B78843.075526=5D =5B3:  kworker/u16:1:27018=5D x15: ffffffc01187d88f x14:=
 2067617420746120=20
=5B78843.075536=5D =5B3:  kworker/u16:1:27018=5D x13: 6b7361742074726f x12:=
 6261206563697665=20
=5B78843.075546=5D =5B3:  kworker/u16:1:27018=5D x11: 44203a74726f6261 x10:=
 00000000ffffffff=20
=5B78843.075556=5D =5B3:  kworker/u16:1:27018=5D x9 : 0000000000000090 x8 :=
 ffffff8934c0a620=20
=5B78843.075566=5D =5B3:  kworker/u16:1:27018=5D x7 : 0000000000000000 x6 :=
 ffffffc0102a7d6c=20
=5B78843.075576=5D =5B3:  kworker/u16:1:27018=5D x5 : 0000000000000000 x4 :=
 0000000000000080=20
=5B78843.075585=5D =5B3:  kworker/u16:1:27018=5D x3 : 0000000000000000 x2 :=
 ffffffc0102a7d80=20
=5B78843.075595=5D =5B3:  kworker/u16:1:27018=5D x1 : ffffffc0102a7d80 x0 :=
 0000000000000000=20
=5B78843.075606=5D =5B3:  kworker/u16:1:27018=5D Call trace:
=5B78843.075617=5D =5B3:  kworker/u16:1:27018=5D  scsi_print_command+0x24/0=
x340
=5B78843.075627=5D =5B3:  kworker/u16:1:27018=5D  ufshcd_abort+0x180/0x674
=5B78843.075643=5D =5B3:  kworker/u16:1:27018=5D  scmd_eh_abort_handler+0x8=
0/0x15c
=5B78843.075660=5D =5B3:  kworker/u16:1:27018=5D  process_one_work+0x290/0x=
4e4
=5B78843.075669=5D =5B3:  kworker/u16:1:27018=5D  worker_thread+0x258/0x534
=5B78843.075681=5D =5B3:  kworker/u16:1:27018=5D  kthread+0x178/0x188
=5B78843.075696=5D =5B3:  kworker/u16:1:27018=5D  ret_from_fork+0x10/0x18

Thanks.
Kiwoong Kim


