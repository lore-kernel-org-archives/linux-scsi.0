Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6725DC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B467207A8
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbhAHEUl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:20:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52452 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbhAHEUk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:20:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10849f67096788;
        Fri, 8 Jan 2021 04:19:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fJtX/x/q0BSrKpHUkhYtCo9igyPNRl3G/Q1ztLnzj0Q=;
 b=U9tseGlUFLP/vvV2g5YoM4hATBWrA6QsJ1ETiKTLhDA4ZDRWzTfoS69owYthMgcXdgH2
 RpaeGs2Hq18+aCNwITJFr2Ka8cr/nEOICBZoAPFo5F8Tg1wmWlq4HnmaFBUi0oxKVl6y
 olA0JAzLykgohFEwBgQh88jAExNkJ46u6u5rbpBy66qlfaKlhWDD6iLhq0uz/G7DHJzh
 xYS3whqhDP+oKgxRk1ARZ2NIlVLJJretuFKO/BYqUQNhbPGhRjnc4y/43W/ufoZh69J/
 MxKvk0r+Gee3Ofhax2NC1u7QDWwVPmEyfmKPGyoxJ43pLNR9WongIDvlZRM1Gt5UBJ/G tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35wepmfd97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 04:19:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1084AuAi079282;
        Fri, 8 Jan 2021 04:19:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35v1fc2x8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 04:19:54 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1084Jqmp018065;
        Fri, 8 Jan 2021 04:19:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 04:19:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] scsi: sd: remove obsolete variable in sd_remove()
Date:   Thu,  7 Jan 2021 23:19:37 -0500
Message-Id: <161007949339.9892.18140869017043061616.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214095424.12479-1-lukas.bulwahn@gmail.com>
References: <20201214095424.12479-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=850 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1011 mlxlogscore=859
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 14 Dec 2020 10:54:24 +0100, Lukas Bulwahn wrote:

> Commit 140ea3bbf39a ("sd: use __register_blkdev to avoid a modprobe for an
> unregistered dev_t") removed blk_register_region(devt, ...) in sd_remove()
> and since then, devt is unused in sd_remove().
> 
> Hence, make W=1 warns:
> 
>   drivers/scsi/sd.c:3516:8:
>       warning: variable 'devt' set but not used [-Wunused-but-set-variable]
> 
> [...]

Applied to 5.11/scsi-fixes, thanks!

[1/1] scsi: sd: remove obsolete variable in sd_remove()
      https://git.kernel.org/mkp/scsi/c/be2553358cd4

-- 
Martin K. Petersen	Oracle Linux Engineering
