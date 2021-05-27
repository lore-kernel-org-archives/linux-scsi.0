Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEF4C47089
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 09:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68333613E6
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 09:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbhE0JyI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 05:54:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12365 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235813AbhE0JyH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 05:54:07 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210527095232epoutp032d0c1365750c10aac13890e30359eb7f~C464bm9yk2960529605epoutp03J
        for <linux-scsi@vger.kernel.org>; Thu, 27 May 2021 09:52:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210527095232epoutp032d0c1365750c10aac13890e30359eb7f~C464bm9yk2960529605epoutp03J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622109152;
        bh=7WfbE81SCMyMRVK7lE4vZ58sZIrWai68dvEZTsZe7lA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=rlhxC+uikGFetnWqF+yj4PE2VYqTBVcjTI4xofWLfp6wdNbeCt7IqRHmlBOIX6bWh
         tbLthl6grmFSmrc/TVdg1VIOJPV3c55sA8jEBERSMApqy5cE0APtxnj40rwNj3Qmm9
         JCj6sYtiIHLZtjqivtIhfoeV5WjHxUJluFt2hmvY=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20210527095232epcas5p29baa6a33b5c47f2476e2989b37465fee~C4635VkfC0914009140epcas5p2B;
        Thu, 27 May 2021 09:52:32 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C4.34.09697.FDB6FA06; Thu, 27 May 2021 18:52:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20210527081709epcas5p3435cb22c0f50ff9bb334f03da6d44899~C3nmJB9jo0946709467epcas5p3F;
        Thu, 27 May 2021 08:17:09 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210527081709epsmtrp12ad81998305d193d3bf2b3338550bbf2~C3nmIQtbu2919229192epsmtrp1y;
        Thu, 27 May 2021 08:17:09 +0000 (GMT)
X-AuditID: b6c32a4a-639ff700000025e1-3b-60af6bdf9167
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E1.BD.08637.5855FA06; Thu, 27 May 2021 17:17:09 +0900 (KST)
Received: from alimakhtar02 (unknown [107.122.12.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210527081707epsmtip212be513b26f135089ab2a8dd68f9c186~C3nkKUb102365023650epsmtip21;
        Thu, 27 May 2021 08:17:07 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'jongmin jeong'" <jjmin.jeong@samsung.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
Cc:     <avri.altman@wdc.com>, <cang@codeaurora.org>, <beanhuo@micron.com>,
        <adrian.hunter@intel.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20210527030901.88403-1-jjmin.jeong@samsung.com>
Subject: RE: [PATCH 0/3] Add quirk to support exynos ufshci
Date:   Thu, 27 May 2021 13:47:05 +0530
Message-ID: <36eb01d752d0$b0146200$103d2600$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIDHayZR31s/4hAgTEw4AxRKtdh6QIoW8PMqo4hsrA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsWy7bCmhu797PUJBgseW1mcfLKGzeLlz6ts
        FgcfdrJYfFq/jNVi0Y1tTBYrr1lYXN41h82i+/oONovlx/8xOXB6XO7rZfJYvOclk8eERQcY
        Pb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnNySxLLdK3S+DKmLnyF3vBK9mKpb0N
        LA2MreJdjJwcEgImEltavrN3MXJxCAnsZpT4+HA7G4TziVHizI/ZjCBVQgLfGCW+XeeC6bg8
        8TU7RHwvo8TB5cIQDS8ZJWZMWAuWYBPQldixuI0NxBYRSJXYeK2bGaSIWWAxo8Sl7eeAijg4
        OAVsJdZcyQSpERawluj6dpUVxGYRUJW4uHsBWAmvgKXErokVIGFeAUGJkzOfsIDYzALaEssW
        vmaGuEdB4ufTZawQq6wklv3sZIOoEZc4+rMHqmYPh8T3P24QtovEys9TmSBsYYlXx7ewQ9hS
        Ei/728DWSghkS/TsMoYI10gsnXeMBcK2lzhwZQ4LSAmzgKbE+l36EGFZiamn1jFBbOWT6P39
        BGo6r8SOeTC2qkTzu6tQY6QlJnZ3s05gVJqF5LFZSB6bheSBWQjbFjCyrGKUTC0ozk1PLTYt
        MMpLLdcrTswtLs1L10vOz93ECE5YWl47GB8++KB3iJGJg/EQowQHs5II78HmtQlCvCmJlVWp
        RfnxRaU5qcWHGKU5WJTEeVc8nJwgJJCeWJKanZpakFoEk2Xi4JRqYFpk76z88/3kVlZe9a/6
        3+bd/pD0yya79vH70qsvoh1T191cfl2/qjolJfD8du/0BsNsK64uNu/PNzdWS2/VL2e3X17M
        M+9v05uktlCt72odunfPXA/tbTeQ3DCl4YZQmLtylnfBImanGYbL4p/L2Gdu2J07lzm4YebV
        l3OunJ77NZHdW6Iv4+y3yQF+n0umsISLdTw+n1Z6sjs/bgqTUtjNWTVqCoElu7ZoR1xe3FNr
        eyx8T8nUPKX+lVxR9yepubg7x6lNOaQ5Y8f+AKn5kpYbpvY4pms9VdzY5Hxv4gmbygNm7+t0
        f2Vsk5Rcb1NstVtoIkdkv+k5kyWrQmxOtArP8rTUWJ7V05nTu41DiaU4I9FQi7moOBEArq5W
        DscDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWy7bCSvG5r6PoEgxe9QhYnn6xhs3j58yqb
        xcGHnSwWn9YvY7VYdGMbk8XKaxYWl3fNYbPovr6DzWL58X9MDpwel/t6mTwW73nJ5DFh0QFG
        j+/rO9g8Pj69xeLRt2UVo8fnTXIe7Qe6mQI4orhsUlJzMstSi/TtErgybk+7zFqwWLbi/96f
        7A2MW8S6GDk5JARMJC5PfM0OYgsJ7GaUmHy/CiIuLXF94wR2CFtYYuW/51A1zxklpiy3BrHZ
        BHQldixuYwOxRQTSJe7cv8vUxcjFwSywEmjOoztsII6QQB+jxLLzi1m7GDk4OAVsJdZcyQRp
        EBawluj6dpUVxGYRUJW4uHsBO0gJr4ClxK6JFSBhXgFBiZMzn7CA2MwC2hJPbz6Fs5ctfM0M
        cZuCxM+ny1ghbrCSWPazkw2iRlzi6M8e5gmMwrOQjJqFZNQsJKNmIWlZwMiyilEytaA4Nz23
        2LDAMC+1XK84Mbe4NC9dLzk/dxMjOPa0NHcwbl/1Qe8QIxMH4yFGCQ5mJRHeg81rE4R4UxIr
        q1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgunKx3eXhcj3HVkm1
        2+uWS2dfDZ22Srqs+7ZO9J3T27JeOmwuWsPz8ovYE4cjkXceK3rsdD7ANj8ka/nv7pMbgnVa
        H0wPNslRvRX0cdGHbSsKDxxNs2Hsf/7diXUB16b2qqldbM0GqlGFCa/Fli1nyVRwbhPKbZ3z
        bGNW8Qax7s7/W3b0PGya72TvNfEj+4ZpwSujvPMOifsuWxjtlMl+S8bYSfrXtM1unB99DL2s
        hVf4r52kco6x//fy3DmaC5UON/7u+HCwUlmhaVLYoxd3T/+O23dXRH1/jcLz+cY+/4vOVZp9
        Dg60U2R/s2COZKuv1jzvCw5x1xi+Hfd+0exba7lyizBfplWeyGrLFY2iSizFGYmGWsxFxYkA
        8Nyi8SwDAAA=
X-CMS-MailID: 20210527081709epcas5p3435cb22c0f50ff9bb334f03da6d44899
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20210527031217epcas2p44b9d999edcc55b345dfd0749acefeaec
References: <CGME20210527031217epcas2p44b9d999edcc55b345dfd0749acefeaec@epcas2p4.samsung.com>
        <20210527030901.88403-1-jjmin.jeong@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jongmin

> -----Original Message-----
> From: jongmin jeong <jjmin.jeong=40samsung.com>
> Sent: 27 May 2021 08:39
> To: jejb=40linux.ibm.com; martin.petersen=40oracle.com
> Cc: alim.akhtar=40samsung.com; avri.altman=40wdc.com;
> cang=40codeaurora.org; beanhuo=40micron.com; adrian.hunter=40intel.com;
> linux-scsi=40vger.kernel.org; linux-kernel=40vger.kernel.org;
> jjmin.jeong=40samsung.com
> Subject: =5BPATCH 0/3=5D Add quirk to support exynos ufshci
>=20
> In ExynosAuto(variant of the Exynos for automotive), the UFS Storage need=
s
> to be accessed from multi-OS.
> To increase IO performance and reduce SW complexity, we implemented
> UFS-IOV to support storage IO virtualization feature on UFS.
>=20
> IO virtualization increases IO performance and reduce SW complexity with
> small area cost. And IO virtualization supports virtual machine isolation=
 for
> Security and Safety which are requested by Multi-OS system such as
> automotive application.
>=20
> Below figure is the conception of UFS-IOV architeture.
>=20
>     +------+          +------+
>     =7C OS=231 =7C          =7C OS=232 =7C
>     +------+          +------+
>        =7C                 =7C
>  +------------+     +------------+
>  =7C  Physical  =7C     =7C   Virtual  =7C
>  =7C    Host    =7C     =7C    Host    =7C
>  +------------+     +------------+
>    =7C      =7C              =7C <-- UTP_CMD_SAP, UTP_TM_SAP
>    =7C   +-------------------------+
>    =7C   =7C    Function Arbitor     =7C
>    =7C   +-------------------------+
>  +-------------------------------+
>  =7C           UTP Layer           =7C
>  +-------------------------------+
>  +-------------------------------+
>  =7C           UIC Layer           =7C
>  +-------------------------------+
>=20
> There are two types of host controllers on the UFS host controller that w=
e
> designed.
> The UFS device has a Function Arbitor that arranges commands of each host=
.
> When each host transmits a command to the Arbitor, the Arbitor transmits =
it
> to the UTP layer.
> Physical Host(PH) support all UFSHCI functions(all SAPs) same as
> conventional UFSHCI.
> Virtual Host(VH) support only data transfer function(UTP_CMD_SAP and
> UTP_TM_SAP).
>=20
> In an environment where multiple OSs are used, the OS that has the
> leadership of the system is called System OS. This system OS uses PH and
> controls error handling.
>=20
> Since VH can only use less functions than PH, it is necessary to send a r=
equest
> to PH for Detected Error Handling in VH. To interface among PH and VHs,
> UFSHCI HW supports mailbox. PH can broadcast mail to other VH at the same
> time with arguments and VH can mail to PH with arguments.
> PH and VH generate interrupts when mails from PH or VH.
>=20
> In this structure, the virtual host can't support some feature and need t=
o skip
> the some part of ufshcd code by using quirk.
> This patchs add quirks so that the UIC command is ignored and the ufshcd =
init
> process can be skipped for VH. Also, according to our UFS-IOV policy, we
> added a quirk to the abort handler or device reset handler to call the ho=
st
> reset handler.
>=20
> jongmin jeong (3):
>   scsi: ufs: add quirk to handle broken UIC command
>   scsi: ufs: add quirk to enable host controller without interface
>     configuration
>   scsi: ufs: add quirk to support host reset only
>=20
>  drivers/scsi/ufs/ufshcd.c =7C 13 +++++++++++++  drivers/scsi/ufs/ufshcd.=
h =7C
> 18 ++++++++++++++++++
>  2 files changed, 31 insertions(+)
>=20
We do not encourage adding QUIRKs without having actual code that sets thes=
e quirks, so that we understand how these are actually getting used.
So better you post the all the changes, not just quirks.
> --
> 2.31.1


