Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA94DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 02:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 984F8206E9
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 02:33:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RmSTRVCp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgFCCd4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 22:33:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46580 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgFCCdz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 22:33:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0532UMG6179593;
        Wed, 3 Jun 2020 02:33:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=v7slq7nogbFdY6anIseYYqTNcMjCCgPFuaiWRrPlhd4=;
 b=RmSTRVCplZZG7hH4oKzlD4CdgQl+lZtGOEJLWJHnap36bjgEKHpvZaDu4vvAIIwxQihv
 Ap3PflK9V+4GeOmmd24D82FTptVwPlFegJelVgKVR58tBAQKsab0mhdyGVw0Zvu0gTpJ
 HAsBbRmWeaq8rwD2U/jCkFSNWPjv4G6m+HqaWTOGhSNAiw+KLDqL+ThUKEXIPDr7DqZs
 Yp3lwUG0yo5Ps6M6w1+fBVH2qJ/zZ2HAaFBPx6e9q7Q40OkruVPuHY2hReIjouYSEhPg
 BGMatinBLLkYOWqDs9+5qO37OVp+Ic6ezu0GePQs5nGkHVOtR50qQ8go78Cchn2WWRNi qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31bewqxwcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 02:33:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0532S09m087088;
        Wed, 3 Jun 2020 02:31:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31dju2f0ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 02:31:43 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0532VfJe032603;
        Wed, 3 Jun 2020 02:31:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 19:31:41 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     robh@kernel.org, Alim Akhtar <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        krzk@kernel.org, linux-samsung-soc@vger.kernel.org,
        avri.altman@wdc.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cang@codeaurora.org, devicetree@vger.kernel.org,
        kwmad.kim@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 00/10] exynos-ufs: Add support for UFS HCI
Date:   Tue,  2 Jun 2020 22:31:32 -0400
Message-Id: <159114947915.26776.12485309894552696104.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528011658.71590-1-alim.akhtar@samsung.com>
References: <CGME20200528013223epcas5p2be85fa8803326b49a905fb7225992cad@epcas5p2.samsung.com> <20200528011658.71590-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=943
 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=0 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=984
 malwarescore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006030017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 28 May 2020 06:46:48 +0530, Alim Akhtar wrote:

> This patch-set introduces UFS (Universal Flash Storage) host
> controller support for Samsung family SoC. Mostly, it consists of
> UFS PHY and host specific driver.
> [...]

Applied [1,2,3,4,5,9] to 5.9/scsi-queue. The series won't show up in
my public tree until shortly after -rc1 is released.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
