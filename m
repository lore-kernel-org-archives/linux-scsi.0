Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5C9C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 08:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B302664E22
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 08:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhBEIhS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 03:37:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13712 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhBEIgL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 03:36:11 -0500
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210205083526epoutp0257fb72e2610aceadb5b900f70185c080~gzQ345zAq1005310053epoutp02-
        for <linux-scsi@vger.kernel.org>; Fri,  5 Feb 2021 08:35:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210205083526epoutp0257fb72e2610aceadb5b900f70185c080~gzQ345zAq1005310053epoutp02-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612514126;
        bh=roCaxw1TIraQlxmt81EOnbYmX7cIvpUTglhwhX1swBk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=kvsam9xXlvpVx37hXXm6Xdx+VP1MGPiOdPyleW8jx1ZVhRtuhink6hc4yjvVfl3Xt
         0tKbeUXLIYNXEwZAEsZaXERxFLCMASYCFpL2oozBiAB55FUpJxf8awi6GYjif8JOS3
         zAJqEPsxRUTEFbfIjeKTfgUMiVG/nvYsQERz+tNA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20210205083525epcas1p3792c41b7c1d03851811512d93dd9829e~gzQ28xlTJ1051410514epcas1p3I;
        Fri,  5 Feb 2021 08:35:25 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.161]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DX7z06L8jz4x9Px; Fri,  5 Feb
        2021 08:35:24 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        15.D9.63458.C430D106; Fri,  5 Feb 2021 17:35:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210205083524epcas1p3cd8e72a69a009b698bf9a9dbbb01f9b3~gzQ1noc6_1052610526epcas1p3W;
        Fri,  5 Feb 2021 08:35:24 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210205083524epsmtrp1dd2f4c42024662c73cab1fcc30b7dcc7~gzQ1ljHZ40038600386epsmtrp1g;
        Fri,  5 Feb 2021 08:35:24 +0000 (GMT)
X-AuditID: b6c32a36-6c9ff7000000f7e2-7f-601d034ce870
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6F.E9.13470.B430D106; Fri,  5 Feb 2021 17:35:23 +0900 (KST)
Received: from dh0421hwang01 (unknown [10.253.101.58]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210205083523epsmtip1f77b74b9aaeb2a8d52de1cbf2883974d~gzQ1Uhki-3111031110epsmtip1F;
        Fri,  5 Feb 2021 08:35:23 +0000 (GMT)
From:   "DooHyun Hwang" <dh0421.hwang@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <cang@codeaurora.org>, <asutoshd@codeaurora.org>,
        <beanhuo@micron.com>, <jaegeuk@kernel.org>,
        <adrian.hunter@intel.com>, <satyat@google.com>
Cc:     <grant.jung@samsung.com>, <jt77.jang@samsung.com>,
        <junwoo80.lee@samsung.com>, <jangsub.yi@samsung.com>,
        <sh043.lee@samsung.com>, <cw9316.lee@samsung.com>,
        <sh8267.baek@samsung.com>, <wkon.kim@samsung.com>
In-Reply-To: <DM6PR04MB6575691082B0379B9B238B4EFCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
Subject: RE: [PATCH] scsi: ufs: print the counter of each event history
Date:   Fri, 5 Feb 2021 17:35:23 +0900
Message-ID: <000401d6fb99$d8b77c80$8a267580$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGonOmpGA2Fw1RP91jP5BlOyCodSwIzgKWKAkwINgWqgfuF4A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfVBUVRjG59x79+4CbV2+4rhgrHeM0lzYZVk4FGCAo1dAJZnGagy4wR1g
        WnZ39i6SNBFisyAgy0eNupBDGDgCgsOXQK0izYiQfzSQkE6AJsRHSQgmkEntcnPiv+e87++Z
        533PmSPB3VZImSRDZ+KMOlZLk85E53fblIo4fHOysqJOhQYmm0h092wniWzmG2I0u3qLRNfu
        nSDQYku9CJ0eNIvQX09bxGiyxYqjwo5KDNX+1ImhrumbYtTz9DiGhnuqSVQ82kWi8/1rGLI0
        jpEo/+8rBBq5eUOE6jpuA9Q29Jh405MZLj2JMTWtWcy5b2cxprXhBMmU1fYC5rOBqwSz3FJI
        Mg+n7hBMaXsDYJZaX2IKeouxeJf3tGHpHJvKGeWcLkWfmqFLC6djE5KikzTBSpVCFYpCaLmO
        zeTC6V1x8YrdGVr7prT8CKvNspfiWZ6nAyLCjPosEydP1/OmcJozpGoNKqXBn2cz+Sxdmn+K
        PvN1lVIZqLGTydr0r87/ghva8I8umF/NA7exIuAkgVQQrP/nDOHQblQXgMcuZhcBZ7teBLDp
        fhsQGo8BHFzxfGbIn2/GBMgGYN7CWUI4/AZgd/lJsYMiKSWsvP476dAe1BwGLz7yckA4NQrg
        6vij9Wwn6n04f+fzdYM7tQd+030ad2iC2goLhorsZolESoXCsUvxjrKUcoUDZybXR8UpX3j5
        QTUuTCSHq1P1IiErCvYXrpEC4wGrTphxRy6k2pzg1P12QjDsgu1NX4gE7Q7n+tvFgpbBWYv5
        P10MoKUvQjCXATjcX0IKDTVcXFoCjuFwahts6QkQyltg95MvgRD8PJz/s0TkQCAlhYVmNwHx
        g+fWlu2I2K594DGXMkBbNyxm3bCYdcMC1v+jagDRAF7kDHxmGserDIEbX7oVrH+B7cFdoOLB
        gn8fwCSgD0AJTntIWbMs2U2ayh7N4Yz6JGOWluP7gMZ+0+W4zDNFb/9DOlOSShOoVqtRUHBI
        sEZNe0lZ5d0kNyqNNXEfcpyBMz7zYRInWR5G56qfK6gY95s+vmSg2ywJCfUXLqdumk70laxU
        Rms/+d4mt03EjPr4TOesKCwDPxzcGpdyb2aodiwk+uqaqnzNwz0s2qNewVvfvuXlne5Wt2NO
        NxaJDp1KHBxucI2tds01hmY//PWN/AjxuMUy8fFg0LsqU+XIQf7AQurLzhNzT2x7T4mcvUsb
        O2tm/HyjNNkxtj++3s/nVrSW7jg6wyp2S6w/wsADypHpxtfC3OvKOt7xjTpiLk48vK+9OaZk
        1WVn5CVJcHOvYp+ca05BJfmbcjbT8ejazrdeSZddH96z/1M+oO9w1bg7Hb0YuZd5oXf5Stpy
        VewHPy8fKhXVeCcZCA+a4NNZ1XbcyLP/As9B0fGLBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsWy7bCSnK43s2yCwc475hYnn6xhs3gwbxub
        xd62E+wWL39eZbM4+LCTxeLT+mWsFjNOtbFa/Pq7nt3iyfpZzBYdWyczWSy6sY3JYsfzM+wW
        u/42M1lc3jWHzaL7+g42i+XH/zFZ9K++y2bR9Gcfi8W1MydYLZZuvclosfnSNxYHUY/Lfb1M
        Hgs2lXos3vOSyWPTqk42jwmLDjB6tJzcz+LxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAHcU
        l01Kak5mWWqRvl0CV8bC5Y+YCzYzV6xs02hgvMnUxcjJISFgItH0bh2QzcUhJLCbUWLnok+s
        EAkZie77e9m7GDmAbGGJw4eLIWpeMkpMe3WEHaSGTcBAYvKxN2wgCRGBH0wSS38uYgVxmAXu
        M0os2jaVHaLlAaPE5clH2UBaOAViJd7dmgLWLizgLrF75wxmEJtFQEWi/VIXG8g6XgFLibsb
        AkDCvAKCEidnPmEBsZkFtCV6H7YyQtjyEtvfzmGGuFRB4ufTZWBXiwg4SRzv+McGUSMiMbuz
        jXkCo/AsJKNmIRk1C8moWUhaFjCyrGKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECE4K
        Wpo7GLev+qB3iJGJg/EQowQHs5IIb2KbVIIQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OF
        BNITS1KzU1MLUotgskwcnFINTB3BV1IyGLL+ylkGG3//wmNc5bHBe7rngyyR/lf5cRP0fr17
        152VKyksErS7N5dr0c1VW902HPQN2/1zksWeveKuTJ/ZvH6fu//BbeuS+TeOHm6wM1ssxX5r
        inscx6wDj7lSFK++euBdH6YmczSEm19g3VzxF9vWP/bz29VtueT9lxVHzVQuZ0l9+3xu4kzj
        d4E/9CICOMKFNr71Pda3grnyVLy9x45tv1YHvJx88PCRK8+VnROtvq2XdhK8v62rclOUYPP6
        jZnnjB7fi7l55R3b7ok+s2RLnFNz/6z/lSBZrx0wo18w0PHmvzSBvQ/m1yX7s6YJ+jFX/TZJ
        mRmrN+2S1fPX7N67qpfH3Gc4UqnEUpyRaKjFXFScCACx2D1HeQMAAA==
X-CMS-MailID: 20210205083524epcas1p3cd8e72a69a009b698bf9a9dbbb01f9b3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210203102752epcas1p16713d977a1a679cf641894144d8f299d
References: <CGME20210203102752epcas1p16713d977a1a679cf641894144d8f299d@epcas1p1.samsung.com>
        <20210203101443.28934-1-dh0421.hwang@samsung.com>
        <DM6PR04MB6575691082B0379B9B238B4EFCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>
>> Since only print the recorded event history list, add to print the
>> counter value.
>>
>> Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
>Reviewed-by: Avri Altman <avri.altman@wdc.com>
>
>Btw, You have the counter now in ufs-debugfs as well.
>
>Thanks,
>Avri

Thank you for your review and information.

I hope to be able to check the counter value in kernel log as well.

Thank you.
DooHyun Hwang.

