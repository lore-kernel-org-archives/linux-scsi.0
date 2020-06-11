Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47C1C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 15:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7C3B206A4
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 15:53:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JPkBygnh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbgFKPxF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 11:53:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17733 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728553AbgFKPxF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 11:53:05 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200611155301epoutp03516624165c36d86fc966d95070942066~XiDtF4C911513115131epoutp03J
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2020 15:53:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200611155301epoutp03516624165c36d86fc966d95070942066~XiDtF4C911513115131epoutp03J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591890781;
        bh=kScEMlg/rRuMIFdvPxw18pdzY4zjXG3Ibn+nyUpH3Pk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=JPkBygnhf6KcbG+IF1dUJlkVxq/f3v9DYfRkFmwqDZt3MX/lvcM7XZZYFfImalNnX
         6WtaHAmJC3RyVUEtktb+aDezz5Wbxd9l6ESExT1XBAep1eVmKq/sxPbwv6Vf8HPzED
         TGGLvnUu34CKJIRS8zEaCQFBdyURKXvsqfzD/W+Q=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200611155300epcas5p3b28afdd84d2039d5ca6516f162c81e8d~XiDsWetr_2999629996epcas5p3g;
        Thu, 11 Jun 2020 15:53:00 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        14.40.09475.C5352EE5; Fri, 12 Jun 2020 00:53:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200611155259epcas5p3130585851c1ce740180396752739f567~XiDrrK8Ln0174901749epcas5p30;
        Thu, 11 Jun 2020 15:52:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200611155259epsmtrp2f491078c7ea3c0892e7eed4c2d59617f~XiDrqXamv3106231062epsmtrp2s;
        Thu, 11 Jun 2020 15:52:59 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-83-5ee2535c10ef
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        28.0E.08382.B5352EE5; Fri, 12 Jun 2020 00:52:59 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200611155256epsmtip20f35d45dac1b74f4d415fcd0b87c1f26~XiDopjw770150001500epsmtip2U;
        Thu, 11 Jun 2020 15:52:56 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Bean Huo'" <huobean@gmail.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <bvanassche@acm.org>,
        <tomas.winkler@intel.com>, <cang@codeaurora.org>,
        <ebiggers@kernel.org>
Cc:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20200605200520.20831-2-huobean@gmail.com>
Subject: RE: [PATCH v3 1/2] scsi: ufs: Add SPDX GPL-2.0 to replace GPL v2
 boilerplate
Date:   Thu, 11 Jun 2020 21:22:54 +0530
Message-ID: <002201d64008$61837710$248a6530$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIGk+PiZ8drLgZOsw/xGQ6ddVivTgMdI2NsAaiy6/OoTLnIoA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsWy7bCmlm5M8KM4g+/LFS32tp1gt3j58yqb
        xcGHnSwW0z78ZLb4tH4Zq8XaPX+YLeacbWCyWHRjG5PF5V1z2Cy6r+9gs1h+/B+TxdKtNxkt
        PvTUOfB6XL7i7XG5r5fJY+esu+wei/e8ZPLYtKqTzWPCogOMHi0n97N4fF/fwebx8ektFo/P
        m+Q82g90MwVwR3HZpKTmZJalFunbJXBlrG6Zy14wg6ti94sfzA2M+zi6GDk5JARMJLbNWMXW
        xcjFISSwm1FiyZ/DrBDOJ0aJLVfuM4NUCQl8Y5Tou1QB0zHh73QWiKK9jBKLLvUwQThvGCWa
        3xxmAqliE9CV2LG4DWyuiMBiJol1C1+CJZgFHCROPtgBZnMKmEtM3LUAbIWwQLjE0ms/GUFs
        FgFViWdrF7GA2LwClhIH2xvYIWxBiZMzn7BAzJGX2P52DjPESQoSP58uYwWxRQScJH6e+sYM
        USMucfRnDzPIERICHzgknny6wgTR4CKx4ddZqGZhiVfHt7BD2FISn9/tBbqaA8jOlujZZQwR
        rpFYOu8YC4RtL3HgyhwWkBJmAU2J9bv0IVbxSfT+fsIE0ckr0dEmBFGtKtH87ipUp7TExO5u
        VgjbQ+Lep0bWCYyKs5A8NgvJY7OQPDALYdkCRpZVjJKpBcW56anFpgXGeanlesWJucWleel6
        yfm5mxjBqU/Lewfjowcf9A4xMnEwHmKU4GBWEuEVFH8YJ8SbklhZlVqUH19UmpNafIhRmoNF
        SZxX6ceZOCGB9MSS1OzU1ILUIpgsEwenVAOThlSdx9YTnmodS0/dbjrydPmr6EyNrWveWmkf
        Oqr5Xy5tRYbhQellR+0mzVt7N/32xR3bu0WtNp6yjGxjL9ZkqXdffCn0n1Gi56+AuhRe/cAd
        9buvlk+6ZPl5+pJblswhK6JMWVfmsv+QcnndmS15loO/YgFz/syCyxoTYz+dbmi7tUr6jqnr
        pjs9FzxnsViH74rZIVR01PvNxFZP3gfOe3SWeW6asqj184bj/nNkbVS030bOmdykkqiYHdMv
        /06y6jKD4aaWbdNTv4ZLz35flWf+XDvSv3n+5FOefw/eDHx1rC9keZzhthMPlgoe37tmzk2X
        6eciM3gn79ZUOXLyM3Pvpcv/Dv28MuefcsHFNCWW4oxEQy3mouJEAMN1nPrsAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWy7bCSvG508KM4g/MdBhZ7206wW7z8eZXN
        4uDDThaLaR9+Mlt8Wr+M1WLtnj/MFnPONjBZLLqxjcni8q45bBbd13ewWSw//o/JYunWm4wW
        H3rqHHg9Ll/x9rjc18vksXPWXXaPxXteMnlsWtXJ5jFh0QFGj5aT+1k8vq/vYPP4+PQWi8fn
        TXIe7Qe6mQK4o7hsUlJzMstSi/TtErgyVrfMZS+YwVWx+8UP5gbGfRxdjJwcEgImEhP+Tmfp
        YuTiEBLYzShxeuFPJoiEtMT1jRPYIWxhiZX/noPZQgKvGCX2TZUBsdkEdCV2LG5jA2kWEVjP
        JNG4ZzZzFyMHB7OAk8Sem0kQQzczSkz5/YEVpIFTwFxi4q4FYDXCAqESm6dJgIRZBFQlnq1d
        xAJi8wpYShxsb2CHsAUlTs58wgIxUk+ibSMjSJhZQF5i+9s5zBCnKUj8fLoMbLoI0Nafp74x
        Q9SISxz92cM8gVF4FpJJsxAmzUIyaRaSjgWMLKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS
        83M3MYKjV0tzB+P2VR/0DjEycTAeYpTgYFYS4RUUfxgnxJuSWFmVWpQfX1Sak1p8iFGag0VJ
        nPdG4cI4IYH0xJLU7NTUgtQimCwTB6dUA5N8eamGU+vuRLE6qxu+2xWOCheqzvMUXF68i3F5
        h6yQ9PqPPZoiH/a67nEVUkkuDBNx/GC42ru5yDOlQzt/2tc3S3qn3L4U8J3pkIFL7rVHfKWS
        On82zW09Psm2WM7l5lxpz7q7s/l+bMzqnHz6y3bFJ8qz3ld/Wf96WWAFb/fF20bnvvnusT8T
        0peRM+nm0sfNAmGyE09OWLNp54Eji9aciv1cGnjl1uLaqCcz5Cvsdu9ZclDBMqntRvnN8/Kz
        /T+Zv13+Ks8v6lHG2fe3X55/6GHiWmDjYfSl/9vRZIEj9oueO7L/PHfs0aG55ru8Nh5rf7Bt
        fVVUzSxH2dblwapGtrxrTHddrj+lbvPsa7SOEktxRqKhFnNRcSIAh2WL400DAAA=
X-CMS-MailID: 20200611155259epcas5p3130585851c1ce740180396752739f567
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200605200556epcas5p2cff385df792c3892885192e51b22530c
References: <20200605200520.20831-1-huobean@gmail.com>
        <CGME20200605200556epcas5p2cff385df792c3892885192e51b22530c@epcas5p2.samsung.com>
        <20200605200520.20831-2-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean

> -----Original Message-----
> From: Bean Huo <huobean@gmail.com>
> Sent: 06 June 2020 01:35
> To: alim.akhtar@samsung.com; avri.altman@wdc.com;
> asutoshd@codeaurora.org; jejb@linux.ibm.com; martin.petersen@oracle.com;
> stanley.chu@mediatek.com; beanhuo@micron.com; bvanassche@acm.org;
> tomas.winkler@intel.com; cang@codeaurora.org; ebiggers@kernel.org
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH v3 1/2] scsi: ufs: Add SPDX GPL-2.0 to replace GPL v2
boilerplate
> 
> From: Bean Huo <beanhuo@micron.com>
> 
> Add SPDX GPL-2.0 to UFS driver files that specified the GPL version 2
license,
> remove the full boilerplate text.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs.h           | 27 +--------------------------
>  drivers/scsi/ufs/ufshcd-pci.c    | 25 +------------------------
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 27 +--------------------------
>  drivers/scsi/ufs/ufshcd.c        | 30 +-----------------------------
>  drivers/scsi/ufs/ufshcd.h        | 27 +--------------------------
>  drivers/scsi/ufs/ufshci.h        | 27 +--------------------------
>  6 files changed, 6 insertions(+), 157 deletions(-)
> 
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

> --
> 2.17.1


