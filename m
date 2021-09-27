Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 092D3C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 07:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5F466113A
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 07:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhI0Hll (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 03:41:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34875 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbhI0Hlk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 03:41:40 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210927074001epoutp03ac6dd642c42fd3a44b0e8ba7e9a0f666~ondSuFNw60146601466epoutp03s
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 07:40:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210927074001epoutp03ac6dd642c42fd3a44b0e8ba7e9a0f666~ondSuFNw60146601466epoutp03s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632728401;
        bh=xNSq3lH+dbm9kZvf2WbIfZN/ruJ82mv82+DcBTWbBVE=;
        h=From:To:Subject:Date:References:From;
        b=K/voMAOMZtnDXUEmyWHlnkLQYgisqMk4bDZ+cXPOHaZczqJHkzXF01PASWIfx3WuW
         7mgA7XYx/S2Z3HcPYxOBKFLEhRt01vuvpDF0c3bVS1c/lJH1tPxMLesI5QKok+aoc8
         HULmjEhZs93HqTgIt5jbdFSk/NFxncsFZwSCeKS4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210927074000epcas2p15017578b4c3c0d744a10b5da08dd2eb7~ondRvuLLU1011410114epcas2p1O;
        Mon, 27 Sep 2021 07:40:00 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.186]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HHvg15drMz4x9QD; Mon, 27 Sep
        2021 07:39:57 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.3B.09816.C4571516; Mon, 27 Sep 2021 16:39:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210927073953epcas2p26eeb9e4fbb86bb54d7dd73acc5beb28a~ondKtzDps3126431264epcas2p2_;
        Mon, 27 Sep 2021 07:39:53 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210927073953epsmtrp181cb7749773ce203d2d02477ca7e6657~ondKs4f9x2010020100epsmtrp1r;
        Mon, 27 Sep 2021 07:39:53 +0000 (GMT)
X-AuditID: b6c32a46-625ff70000002658-cc-6151754c5b2c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.0D.08750.84571516; Mon, 27 Sep 2021 16:39:52 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210927073952epsmtip291c934f25b5a35666f7ef620a545f344~ondKewdGo2750327503epsmtip2M;
        Mon, 27 Sep 2021 07:39:52 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <cang@codeaurora.org>, <adrian.hunter@intel.com>,
        <sc.suh@samsung.com>, <hy50.seo@samsung.com>,
        <sh425.lee@samsung.com>, <bhoon95.kim@samsung.com>
Subject: About ufshcd_err_handling_unprepare
Date:   Mon, 27 Sep 2021 16:39:52 +0900
Message-ID: <005701d7b372$dc01ad20$94050760$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdezcO/tOenqN29yQP6xfQrYSaVskA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJsWRmVeSWpSXmKPExsWy7bCmua5PaWCiwdNlnBYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8Wn9ctYLVYvfsBisejGNiaL7us72CyWH//HZNF19wajxdJ/b1kc
        eDwu9/UyeSze85LJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5DzaD3QzBXBE5dhkpCampBYp
        pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2rpFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQwMDIFqkzIyVj+6jRTwXq2
        iuszb7M2ME5n7WLk5JAQMJG4u+oFUxcjF4eQwA5GiakLJ0M5nxglDi/YzwrhfGaU2PNmGQtM
        y9s1z5ghErsYJb6cfs8I4bxglDg6/xMbSBWbgLbEtIe7wdpFBHYwSdyb8IIZJCEsoCNx7Ntd
        sO0sAqoSh38sYgSxeQUsJda8380CYQtKnJz5BMxmBhq0bOFrZojVChI/ny4D6uUAGqon0fA+
        AKJERGJ2ZxvYRRICSzkkFp17BfWdi8Svo5MYIWxhiVfHt7BD2FISL/vboOx6iX1TG1ghmnsY
        JZ7u+wfVYCwx61k7I8gyZgFNifW79EFMCQFliSO3oE7jk+g4/JcdIswr0dEmBNGoLPFr0mSo
        IZISM2/egSrxkDjxWRYkLCQQK/Hk7TfmCYwKs5D8OwvJv7OQPDYL4YQFjCyrGMVSC4pz01OL
        jQqMkCN7EyM4KWu57WCc8vaD3iFGJg7GQ4wSHMxKIrzBLP6JQrwpiZVVqUX58UWlOanFhxhN
        gTEwkVlKNDkfmBfySuINTY3MzAwsTS1MzYwslMR55/5zShQSSE8sSc1OTS1ILYLpY+LglGpg
        ign0942MfdMWGqFftu7S+Se367zX596et2q39p9AN56vLdNj9G5cEDKJ6v6xanJdtfC9PZXB
        z2dblG0ya36Q9mtiVlsobynrJaZja8tu3/jafmNNQ1rLOesNTxljtY4vM7xzdaOLXt9Nr7dM
        z6/e0C8R2dbF9dv2uYTvQdZ9Eb/NnBx+zL791TxaOURiasLqn0vKl81nv30v996u9e3nupae
        td44c+GSkMw5Ycp/X0zPUbu591ZTv2O8eeJ8rhlrhXvD3PY0uzRd1Tvz6omHTDH3yZ2BK6fV
        c9d0LSzIZfjkusV6RU99XMLSgH0xHP5nZGzY2AXqtHg38c5aeO3LieLyOnndI6J9y54sq2y2
        UWIpzkg01GIuKk4EACt2zxdTBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LZdlhJXtezNDDRYLW2xckna9gsHszbxmbx
        8udVNouDDztZLL4ufcZq8Wn9MlaL1YsfsFgsurGNyaL7+g42i+XH/zFZdN29wWix9N9bFgce
        j8t9vUwei/e8ZPKYsOgAo8f39R1sHh+f3mLx6NuyitHj8yY5j/YD3UwBHFFcNimpOZllqUX6
        dglcGWd+vmEvWM9WsfzHG7YGxumsXYycHBICJhJv1zxj7mLk4hAS2MEocXvuWyaIhKTEiZ3P
        GSFsYYn7LUdYIYqeMUr8vtXIApJgE9CWmPZwN1hCROAYk8TRO1/ZQRLCAjoSx77dBVvBIqAq
        cfjHIrBJvAKWEmve72aBsAUlTs58AmYzAw3qfdjKCGMvW/iaGWKzgsTPp8uA5nAALdCTaHgf
        AFEiIjG7s415AqPALCSTZiGZNAvJpFlIWhYwsqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dL
        zs/dxAiOKi2tHYx7Vn3QO8TIxMF4iFGCg1lJhDeYxT9RiDclsbIqtSg/vqg0J7X4EKM0B4uS
        OO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBibz2e0brez0Dj1vkVe2FY/d5i92rPjY+phds6+Z
        P7xqF3T6Zt+qW5Uasgd6VHeflvZfy63dtZvjl/upp8+OLdfad9pqB6PtF+enMcW21+98WNSS
        UPco7LDI4kUN7GtZZLiXxfo0x184qzRpeVHCU6U5JZd2vyo75n6Lv7RkXvYGA+0lHnZzKxaW
        H9nw9ssrNdZ3enlbP9uGbf201LYh/cEUjx2zszcZ3nEvsNGePO9p9BK7nbuN+Eoqf8RU27aU
        mjdecP67daPJnFJz4fw/M771VB6LnMu4pGOy194QPu/m47nzHicXi9w8n3Kl8+G2VROnr04y
        1dgs/eWqGPOXlykPqjw5+2bNO5+x2sx4es1qJZbijERDLeai4kQAxwBniBkDAAA=
X-CMS-MailID: 20210927073953epcas2p26eeb9e4fbb86bb54d7dd73acc5beb28a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210927073953epcas2p26eeb9e4fbb86bb54d7dd73acc5beb28a
References: <CGME20210927073953epcas2p26eeb9e4fbb86bb54d7dd73acc5beb28a@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear all

I have one question about ufshcd_clear_ua_wluns in ufshcd_err_handling_unpr=
epare.
You probably know a scsi command (request sense) is issued in there to clea=
r UAC for W-LUs.

Let's think about a situation that a read command is timed-out.
And then scmd_eh_abort_handler is called, shost's state is transitioned to =
SHOST_RECOVERY and scsi_sh is waken up.
If this is the case that the scsi_eh goes up to eh_host_reset_handler,
ufshcd_eh_host_reset_handler queues ufshcd_err_handler and waits for its co=
mpletion.
And this function can call ufshcd_err_handling_unprepare at the end.

But I think, at this time, the scsi command, i.e. request sense, could not =
be dispatched because of the shost's state.
Is it needed to be fixed or did I miss something?

Thanks.
Kiwoong Kim


