Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75B3C07EBE
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 05:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7313229C4
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 05:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387711AbhAZFag (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:30:36 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16922 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbhAZEPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 23:15:43 -0500
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210126041459epoutp03c64733fae53cd36d504346453252f9d6~drQncXHJj0643006430epoutp03h
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2021 04:14:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210126041459epoutp03c64733fae53cd36d504346453252f9d6~drQncXHJj0643006430epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611634499;
        bh=hAQ7FhiZ1JZFqagmbqbRZIMv0fmG2NAsjmCKv4BvjQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7/P9o8fPgAMsF/FIDOHv550wvU7/mldpoRKlWzgSqCbOU5djWwkv+EHSbXexIKbS
         hpXSbopR5sbCMclUvT6xGdrrTDzt/uqqxv5ML4uGLm1K0VvsdD3coSmsxWt3YH8clV
         PTYg0zhQ/gTw5YdnEMYufvFflpGfr8beu0XH1s+U=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20210126041458epcas1p3d73bb188aaafa2edd0444104ded26a67~drQmzBl351969619696epcas1p3X;
        Tue, 26 Jan 2021 04:14:58 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.163]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DPtg41kjGz4x9Q6; Tue, 26 Jan
        2021 04:14:56 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.2F.09582.0479F006; Tue, 26 Jan 2021 13:14:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210126041455epcas1p2c38ddc3bfe20bcf10217956b47096a33~drQj3KSZj0618706187epcas1p2x;
        Tue, 26 Jan 2021 04:14:55 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210126041455epsmtrp12a2a8edff2a6b5b451291a4b5dc759e3~drQj2MjtO2957929579epsmtrp1M;
        Tue, 26 Jan 2021 04:14:55 +0000 (GMT)
X-AuditID: b6c32a37-899ff7000000256e-8e-600f97408c5b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.19.08745.F379F006; Tue, 26 Jan 2021 13:14:55 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.105]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210126041455epsmtip2ae4bdd25ecef58635dbe56f808bb33a3~drQjjPh700268402684epsmtip2W;
        Tue, 26 Jan 2021 04:14:55 +0000 (GMT)
From:   Changheun Lee <nanich.lee@samsung.com>
To:     martin.petersen@oracle.com, Damien.LeMoal@wdc.com
Cc:     arnd@arndb.de, hch@lst.de, jejb@linux.ibm.com,
        jisoo2146.oh@samsung.com, junho89.kim@samsung.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, mj0123.lee@samsung.com,
        nanich.lee@samsung.com, oneukum@suse.com,
        seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        woosung2.lee@samsung.com, yt0928.kim@samsung.com
Subject: Re: [PATCH 1/1] scsi: sd: use max_xfer_blocks for set rw_max if
 max_xfer_blocks is available
Date:   Tue, 26 Jan 2021 12:59:27 +0900
Message-Id: <20210126035927.4768-1-nanich.lee@samsung.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <yq15z3o9vod.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmga7DdP4Eg8sHuCz+TjrGbtHa/o3J
        YuXqo0wWi25sY7LoedLEavH1YbHF5V1z2Cy6r+9gs1h+/B8TUO0NVovpm+cwW1y7f4bdouvx
        SjaLcyc/sVrMe+xgcWrHZGaL9Xt/sjkIevz+NYnRY8KiA4weu282sHl8fHqLxaNvyypGj/Vb
        rrJ4fN4k59F+oJspgCMqxyYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
        VsnFJ0DXLTMH6AslhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToGhQYFecWJucWle
        ul5yfq6VoYGBkSlQZUJOxsHp3AW/+Sv+Hz/A2sD4iqeLkZNDQsBEYufEu4wgtpDADkaJx0ek
        uxi5gOxPjBLvP01ihnA+M0rMuPKADaZjZn8/O0RiF6NE19E3CFU/jswFm8UmoCPR9/YWWIeI
        gKnE1D/TGUGKmAXeM0l8//8EyOHgEBZIl/j2G6yeRUBV4tKs80wgNq+AlcTaze2sENvkJZ72
        LmcGsTkFjCWal+1nhqgRlDg58wkLiM0MVNO8dTbYERICRzgkzq7+wgjR7CLRsH0V1NnCEq+O
        b2GHsKUkXva3sUM0dDNKNLfNZ4RwJjBKLHm+jAmiylji0+fPYJcyC2hKrN+lDxFWlNj5G+JL
        ZgE+iXdfe1hBSiQEeCU62oQgSlQkzrTcZ4bZ9XztTqiJHhJHju5hhIRWG6PE039LmCYwKsxC
        8tAsJA/NQti8gJF5FaNYakFxbnpqsWGBMXIUb2IEp2st8x2M095+0DvEyMTBeIhRgoNZSYR3
        tx5PghBvSmJlVWpRfnxRaU5q8SFGU2BwT2SWEk3OB2aMvJJ4Q1MjY2NjCxMzczNTYyVx3iSD
        B/FCAumJJanZqakFqUUwfUwcnFINTA5dS+70MP49qLxKRnv60aaybX+9g+SEJztG9qZZxPIG
        NF1c0x9/6v9p3wecnSsW886L2rrscd7JpbHbfmZMyom/FCgi3HBHvWODULf1FTODFy4/jP+Z
        zim7xCp2rVUgvdY7jzOoqG3F2lux99lEZHYzsfJfZJT7MnfvyZcLgiRO1qr2bM/fHP6Yy9PK
        6zAHG+v7GJUrMX6avrJ77qzdXTj14LOAmat+iadeb07SWrLm4DFV/YT7fO6Sk2e0c/44rBkz
        Wy38FPtJJdXbK6zjT7y5uO9IRazeHT6PUz+v+Kv1cGvtevTodcWREm/+iY09ZzSs03onrWSZ
        xCR/lfG+ZOGLd1tmlPOtStpVMY3DXImlOCPRUIu5qDgRAOpPKWhgBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJXtd+On+CQdMMOYu/k46xW7S2f2Oy
        WLn6KJPFohvbmCx6njSxWnx9WGxxedccNovu6zvYLJYf/8cEVHuD1WL65jnMFtfun2G36Hq8
        ks3i3MlPrBbzHjtYnNoxmdli/d6fbA6CHr9/TWL0mLDoAKPH7psNbB4fn95i8ejbsorRY/2W
        qywenzfJebQf6GYK4IjisklJzcksSy3St0vgyjg4nbvgN3/F/+MHWBsYX/F0MXJySAiYSMzs
        72fvYuTiEBLYwShxsqOHCSIhJXH8xFvWLkYOIFtY4vDhYoiaj4wSM9aeYwepYRPQkeh7e4sN
        xBYRMJe4c2IB2CBmgUZmie41t5lBmoUFUiX2zrIDqWERUJW4NOs82HxeASuJtZvbWSF2yUs8
        7V3ODGJzChhLNC/bD9YqJGAkcWi9I0S5oMTJmU9YQGxmoPLmrbOZJzAKzEKSmoUktYCRaRWj
        ZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnA8aWntYNyz6oPeIUYmDsZDjBIczEoivLv1
        eBKEeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYGorMLl7
        8XCAJRvHxZf5niFrSncosSzbVVOjMPt73pLF9u9PXXtT++fuRxF/h1MP9T6dbNf10JpxmMmu
        MVRvu2xQbpJuY6fywhMdTzrmBL5iZ45KqtZ9bf3kEEvlShczgzVWZ4LdrifpFh8Sn/ThVflL
        1ylFiU+c1hjlb809GKvCfuOCjv5llzjT/sCdnT6CnoVLuAUuLojumeMn2uUx/UmYmOcd1xtf
        nHYYbVPUL6zoPN4TrR/2cIZqlFKc5UOWgLkPr1f5X5I4+3m/f7VC12NjH+1DhTuCzod7fnb6
        de7uqZlXrabUc5d9nOuiGSHauv3AdRWm++JXrp8Q8skJt4t+K39WZ7HVro1TY3dcV2Ipzkg0
        1GIuKk4EAPpE3j0WAwAA
X-CMS-MailID: 20210126041455epcas1p2c38ddc3bfe20bcf10217956b47096a33
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210126041455epcas1p2c38ddc3bfe20bcf10217956b47096a33
References: <yq15z3o9vod.fsf@ca-mkp.ca.oracle.com>
        <CGME20210126041455epcas1p2c38ddc3bfe20bcf10217956b47096a33@epcas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Damien,
> 
> >> How about set larger valid value between sdkp->max_xfer_blocks,
> >> and sdkp->opt_xfer_blocks to rw_max?
> >
> > Again, if your device reports an opt_xfer_blocks value that is too
> > small for its own good, that is a problem with this device.
> 
> Correct. It is very much intentional that we do not default to issuing
> the largest commands supported by the physical hardware.
> 
> If the device is not reporting an optimal transfer size, and the block
> layer default is too small, the solution is to adjust max_sectors_kb in
> sysfs (by adding a udev rule, for instance).
>

Sorry, I said wrong.
As others mentioned, it's device problem if opt_xfer_blocks is wrong.
kernel modification is not needed for it.

I want to discuss using max_xfer_blocks instead of opt_xfer_blocks as a optional.
For example, device reports opt_xfer_blocks is 512KB and 1MB as a
max_xfer_blocks too. Currently rw_max is set with 512KB only.
I want a option to select max_xfer_blocks for rw_max.
Are there any historical problem when rw_max is set with max_xfer_blocks?

How about below approach if max_xfer_blocks can be set to rw_max?
It's using queue flag as a option. Do you have good idea to suggest?

static bool sd_validate_max_xfer_size(struct scsi_disk *sdkp,
				      unsigned int dev_max)
{
	struct request_queue *q = sdkp->disk->queue;

	if (!blk_queue_allow_sd_rw_max(q))
		return false;

	if (sdkp->max_xfer_blocks == 0)
		return false;

        ......

	return true;
}

static int sd_revalidate_disk(struct gendisk *disk)
{
	......

	if (sd_validate_max_xfer_size(sdkp, dev_max)) {
		q->limits.io_opt = logical_to_bytes(sdp, sdkp->max_xfer_blocks);
		rw_max = logical_to_sectors(sdp, sdkp->max_xfer_blocks);
	} else if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
	} else {
	
	......
}

> -- 
> Martin K. Petersen	Oracle Linux Engineering
