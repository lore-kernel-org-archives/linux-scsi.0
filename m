Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040D0C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 07:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A247920734
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 07:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhA0HJD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 02:09:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14103 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhA0HFY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 02:05:24 -0500
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210127070441epoutp04d3537f0139c4179d2a9a9bf01f6fa214~eBOEASbx50474704747epoutp049
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2021 07:04:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210127070441epoutp04d3537f0139c4179d2a9a9bf01f6fa214~eBOEASbx50474704747epoutp049
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611731081;
        bh=/9GXwtk+Q8GHQwdg9UnSZMO0QoLlwz57chrmsVfWQNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOAs4G62ZSFlIC3EHo86of9Tt1vckdYuquQEzQ375TR/7snjdPaVdhCtAdeqJofoY
         gQ5MJD9MV0UbAdtRbM45uNP1DbfIkviKy9JivgII6lDj845yOY/XRJ8H1B3qiaYfV8
         l3adg7Evd5BW0JvZuc38fp/Vyv2y2zpPya1meD7s=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210127070440epcas1p2ed4265e43fe14f38a48eaa4b77c82bbf~eBODKy6pX2500625006epcas1p21;
        Wed, 27 Jan 2021 07:04:40 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.164]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DQZNR0pFJz4x9Q3; Wed, 27 Jan
        2021 07:04:39 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        A7.F4.09582.68011106; Wed, 27 Jan 2021 16:04:38 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210127070438epcas1p417a8c9288df420b0af1ed9d185c87a22~eBOBhwOAd2976129761epcas1p4-;
        Wed, 27 Jan 2021 07:04:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210127070438epsmtrp11b07975bee6c1e8030ab2cfd88a99d91~eBOBg4km90481904819epsmtrp1k;
        Wed, 27 Jan 2021 07:04:38 +0000 (GMT)
X-AuditID: b6c32a37-899ff7000000256e-d2-60111086bd67
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AD.D9.13470.68011106; Wed, 27 Jan 2021 16:04:38 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.105]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210127070438epsmtip2934a782075884d33a8cfa3cb852a3267~eBOBP7WJ52627226272epsmtip2C;
        Wed, 27 Jan 2021 07:04:38 +0000 (GMT)
From:   Changheun Lee <nanich.lee@samsung.com>
To:     martin.petersen@oracle.com
Cc:     Damien.LeMoal@wdc.com, arnd@arndb.de, hch@lst.de,
        jejb@linux.ibm.com, jisoo2146.oh@samsung.com,
        junho89.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        mj0123.lee@samsung.com, nanich.lee@samsung.com, oneukum@suse.com,
        seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        woosung2.lee@samsung.com, yt0928.kim@samsung.com
Subject: Re: [PATCH 1/1] scsi: sd: use max_xfer_blocks for set rw_max if
 max_xfer_blocks is available
Date:   Wed, 27 Jan 2021 15:49:08 +0900
Message-Id: <20210127064908.13571-1-nanich.lee@samsung.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <yq1tur3vzkz.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmrm67gGCCwWkji7+TjrFbtLZ/Y7JY
        ufook8WiG9uYLHqeNLFafH1YbHF51xw2i+7rO9gslh//xwRUe4PVYvrmOcwW1+6fYbfoeryS
        zeLcyU+sFvMeO1ic2jGZ2WL93p9sDoIev39NYvSYsOgAo8fumw1sHh+f3mLx6NuyitFj/Zar
        LB6fN8l5tB/oZgrgiMqxyUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVV
        cvEJ0HXLzAF6QkmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhQoFecmFtcmpeu
        l5yfa2VoYGBkClSZkJNx++xbloJTfBXvnu1kbGC8wN3FyMkhIWAicWfdSvYuRi4OIYEdjBLT
        e98yQzifGCVWnl4O5XxjlOi8vYQNpuX4vqOMEIm9jBJzmmeyQDifGSX2ztjHCFLFJqAj0ff2
        FliHiICcxKTX35hAipgF2pglWtpfAzkcHMIC6RLffoPVswioSnxa/pAJxOYVsJb41f0Gapu8
        xNNekDM4OTgFjCWObH0FVSMocXLmExYQmxmopnnrbLBTJQROcEhcvDWbGaLZReLygqWsELaw
        xKvjW9ghbCmJl/1t7BAN3YwSzW3zGSGcCYwSS54vY4KoMpb49PkzI8ilzAKaEut36UOEFSV2
        /p7LCLGZT+Ld1x5WkBIJAV6JjjYhiBIViTMt95lhdj1fuxNqoofEq+2XwG4QEmhjlLi22W8C
        o8IsJP/MQvLPLITFCxiZVzGKpRYU56anFhsWGCPH8SZGcLrWMt/BOO3tB71DjEwcjIcYJTiY
        lUR43ysLJAjxpiRWVqUW5ccXleakFh9iNAWG9kRmKdHkfGDGyCuJNzQ1MjY2tjAxMzczNVYS
        500yeBAvJJCeWJKanZpakFoE08fEwSnVwPTYQGSTv1L0zZMfyjsqjP6ecTWeIv+x4qzWlSC9
        omyH6R9vpy+2fy3DKrnl7ux28V8epkkdrd8kpl/Z5zs/orruqHEFW0Ts9Ru7r16Xd570OTdl
        XaFqjr/Gvfx5z9gVk9KrN1gHTDyqIu94bNM36fU/F55Y46rQyv5/yVG/r64fDFw/eEo45WWF
        BypsdK0s13qs7Ri0YtLFZf0+kixvnjoHhjRfk+M4uPrG/4MxytWLps5Jzo2tOvPml2X2uoPT
        l0w4Fcm7fXXK9l/RGorrLthkr7q443Df97cxrFOaQte8OpWg9ShwhqbJ3ti1R1ewhmt3sJY0
        ak3tubvjmpcVl2LgiscbFD94fTspNvXB5T4lluKMREMt5qLiRABXtSngYAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42LZdlhJXrdNQDDB4NU2fou/k46xW7S2f2Oy
        WLn6KJPFohvbmCx6njSxWnx9WGxxedccNovu6zvYLJYf/8cEVHuD1WL65jnMFtfun2G36Hq8
        ks3i3MlPrBbzHjtYnNoxmdli/d6fbA6CHr9/TWL0mLDoAKPH7psNbB4fn95i8ejbsorRY/2W
        qywenzfJebQf6GYK4IjisklJzcksSy3St0vgyrh99i1LwSm+infPdjI2MF7g7mLk5JAQMJE4
        vu8oYxcjF4eQwG5GianLNrJCJKQkjp94C2RzANnCEocPF0PUfGSUuPP5HjtIDZuAjkTf21ts
        ILaIgJzEpNffmECKmAVmMUs8+3cOrFlYIFVi7yw7kBoWAVWJT8sfMoHYvALWEr+637BB7JKX
        eNq7nBnE5hQwljiy9RVYjZCAkcSNrsNsEPWCEidnPmEBsZmB6pu3zmaewCgwC0lqFpLUAkam
        VYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwTGlpbmDcfuqD3qHGJk4GA8xSnAwK4nw
        vlcWSBDiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qBaeoF
        lsVakhXrFhy/2T1Ba81uz37HhTMnTdn+MSONdw1D06pzC9xXVHq7fmv8NXuJoe+vmq+susv0
        XLa0sj1Srv30c853/Qzj9K6lpa0OnRON+nRt255Ef+tcM1Odc7veu7hX/UrbH+s1OT04kX5F
        /cjm9IVlGwMCS/3757jeP7hzTY1j9RH95SwTplYHXHYynJ7jGbn6rJ2ZhqY304y/OrEXS0P+
        T/YOnykkxTH7gdK+gJm/Zj35vv/VC41sNaOiiGC7O+7xrYWcz6s3LpzAIGzPmzE797iNX/M3
        D+vtJ5Z97Z3Vtynz4uSLpyt2f3jEPOubQGXrI5NJKSt2c7T07ZN9/fM18+FLArY27tqK65RY
        ijMSDbWYi4oTAQvoXPIYAwAA
X-CMS-MailID: 20210127070438epcas1p417a8c9288df420b0af1ed9d185c87a22
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210127070438epcas1p417a8c9288df420b0af1ed9d185c87a22
References: <yq1tur3vzkz.fsf@ca-mkp.ca.oracle.com>
        <CGME20210127070438epcas1p417a8c9288df420b0af1ed9d185c87a22@epcas1p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Hello Changheun!
> 
> > I want to discuss using max_xfer_blocks instead of opt_xfer_blocks as
> > a optional.  For example, device reports opt_xfer_blocks is 512KB and
> > 1MB as a max_xfer_blocks too. Currently rw_max is set with 512KB only.
> 
> Because that's what the device asks for. If a device explicitly requests
> us to use 512 KB I/Os we should not be sending it 1 MB requests.
> 
> The spec is very clear. It says that if you send a command *larger* than
> opt_xfer_blocks, you should expect *slower* performance. That makes
> max_xfer_blocks a particularly poor choice for setting the default I/O
> size.
> 
> In addition to being slower, max_xfer_blocks could potentially also be
> much, much larger than opt_xfer_blocks. I understand your 512 KB vs. 1
> MB example. But if the max_xfer_blocks limit is reported as 1 GB, is
> that then the right value to use instead of 512 KB? Probably not.
> 
> If a device does not report an opt_xfer_blocks value that suits your
> workload, just override the resulting max_sectors_kb in sysfs. This is
> intentionally a soft limit so it can be adjusted by the user without
> having to change the kernel.
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> 

I understood what you said. I reviewed meaning of opt_xfer_blocks from
SCSI spec again. I think below is what you saw in spec.

The OPTIMAL TRANSFER LENGTH field indicates the optimal transfer size in
logical blocks for a single command shown in table 197. If a device server
receives one of these commands with a transfer size greater than this value,
then the device server may incur significant delays in processing the
command. If the OPTIMAL TRANSFER LENGTH field is set to zero, then there
is no reported optimal transfer size.

Thank you for kindly feedback. :)

---
Changheun Lee
Samsung Electronics
