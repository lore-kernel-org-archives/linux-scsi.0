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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B22C433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 430812225E
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbhAMFvj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:51:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48984 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbhAMFvi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:51:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5jQbf130857;
        Wed, 13 Jan 2021 05:48:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=r2rtWbXj971eyIQw5ArGeGHMu1GGTCgz39vo01Wh9jY=;
 b=US+42WjJy5IHG0xWrYdyg87NKgzHjhoAfnvwxAntx4O3qSKq1ZOXI3AS46+vrMxTnY7v
 qx5xhRX2Fj7IiXTIWcisPGYVog0PB8wnd0RGKcSMOTkVDWpT3LF1O09fLPuQQ3Ua+7dC
 nbtKP3Z35xVqa1SyRw+iiNJPdZLxI6l7HeqQQFuVPvB1C517n5SBNIpls3D0wRRxI01z
 7cmUwN1C7ZHegAfhu4b2oUpcjIpdgeG2VURuP5s0DfXKJpUIS03HjwXX6dDGt/GINOce
 ubWCdhuzUlHn5uVdwOtBqjtGyASAmSAneTINc2iY0aOVzNXOVu7xT1vHt8AHdzY5D343 5w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 360kvk1k49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:48:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5e5Dr133924;
        Wed, 13 Jan 2021 05:48:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 360kf00pn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:48:37 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10D5mYpt023666;
        Wed, 13 Jan 2021 05:48:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 21:48:33 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, maz@kernel.org,
        kashyap.desai@broadcom.com, linux-scsi@vger.kernel.org,
        linuxarm@openeuler.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] hisi_sas: Expose hw queues for v2 hw and remove unused code
Date:   Wed, 13 Jan 2021 00:48:23 -0500
Message-Id: <161050726820.14224.8904013687589214502.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1609763622-34119-1-git-send-email-john.garry@huawei.com>
References: <1609763622-34119-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=800 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=811 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130034
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 4 Jan 2021 20:33:40 +0800, John Garry wrote:

> Patch "scsi: hisi_sas: Expose HW queues for v2 hw" was not merged for
> v5.11, so resending for v5.12.
> 
> Unused module param auto_affine_msi_experimental for v3 hw is also
> removed in the other patch.
> 
> John Garry (2):
>   scsi: hisi_sas: Remove auto_affine_msi_experimental module_param
>   scsi: hisi_sas: Expose HW queues for v2 hw
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/2] scsi: hisi_sas: Remove auto_affine_msi_experimental module_param
      https://git.kernel.org/mkp/scsi/c/3997e0fdd587

-- 
Martin K. Petersen	Oracle Linux Engineering
