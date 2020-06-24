Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC63DC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 04:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C4812078E
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 04:32:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wpUACspt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388665AbgFXEcy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 00:32:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44968 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgFXEcy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 00:32:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4Vm6V056465;
        Wed, 24 Jun 2020 04:32:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=U60Q9wYO24Fci/rjHg9RVDkxJHrlQYSoiIaxIYBt1/c=;
 b=wpUACspt65cGWE27HfpTBArvU4DH636FwnMTPZU44HkREVz5S42J0y0jHmV9E15Us9zq
 IwFxefBAa4808mG2PbdGH4JrlIqye+JgvjRIY+9vV3X//0eO7SOtQAdFE0PJ6rpF+wb9
 XcF8e9EWh9i6zFaeKYEdYcSDgMAwVM9K1NbU/lXgR8evo9LDtaj7GRYpRdi9xe7v2O4c
 gKy8lgkFkqm/d2ofsqkAGcpauUsb30SuwrBRtkxLDXEx1vsohbCeIB/+RT+wk6EFbZhV
 1U+kx+bx4cYej7NJ6RFPppQhNqxaQZhcsiTvBW9GBm6iV2tRR9US1qxqI7dkWqTD5qeT pQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31uustgm4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 24 Jun 2020 04:32:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05O4NmPk086138;
        Wed, 24 Jun 2020 04:30:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31uuqy7egc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jun 2020 04:30:28 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05O4UQ7e031513;
        Wed, 24 Jun 2020 04:30:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jun 2020 04:30:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Seungwon Jeon <essuuj@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Wei Yongjun <weiyongjun1@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH -next] scsi: ufs: ufs-exynos: Fix return value check in exynos_ufs_init()
Date:   Wed, 24 Jun 2020 00:30:22 -0400
Message-Id: <159297300656.9917.6717865886612566021.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618133837.127274-1-weiyongjun1@huawei.com>
References: <20200618133837.127274-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006240031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006240032
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 Jun 2020 13:38:37 +0000, Wei Yongjun wrote:

> In case of error, the function devm_ioremap_resource() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check should
> be replaced with IS_ERR().

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-exynos: Fix return value check in exynos_ufs_init()
      https://git.kernel.org/mkp/scsi/c/b2bc2200e89b

-- 
Martin K. Petersen	Oracle Linux Engineering
