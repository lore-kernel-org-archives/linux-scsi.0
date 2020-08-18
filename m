Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78AE1C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 590FC2078D
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:15:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IHpyIqPT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHRDO4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 23:14:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49172 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgHRDO4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 23:14:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I37PQX032310;
        Tue, 18 Aug 2020 03:14:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Kd7SEbp6xVkboRy3/s1AZdE5Hi4WqV6wT578QIXfx+U=;
 b=IHpyIqPT+PoRmGW2R2RxV+fm8D4ey7oIodV48BoHyrMBExFazYwSO5u3avWFxMzrIs6w
 6GXivp10xDuVFg3nmpsXduzi7b/GyntO02UfRJuyZe6fOpKIdz4eBdZPWDSuSCFxN3sH
 TZ+gd9bhLfB6nVJ5Y7EnTK4iZdEyYVE0LFR9eBSPEkMgnY2pdXpUe1x1+UBfQUo+a4eq
 4o2wgskP6xR389uR9VCKwTYGs6gEHMgAgJinPFYlGyiFW6HX1E+pcIP8oMcc+RT/hQQh
 UVf7s/++n5nJhP011898e+awSb389KAiyuMuTbWn39UZW3dseBKOHR3/wpQ+Cq04K8am mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32x7nma5md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 03:14:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I387MQ131444;
        Tue, 18 Aug 2020 03:12:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32xs9mf4eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 03:12:45 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07I3CgoP022603;
        Tue, 18 Aug 2020 03:12:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 20:12:42 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>, avri.altman@wdc.com,
        jejb@linux.ibm.com, alim.akhtar@samsung.com, vigneshr@ti.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: ti-j721e-ufs: Fix error return in ti_j721e_ufs_probe()
Date:   Mon, 17 Aug 2020 23:12:27 -0400
Message-Id: <159772029325.19587.17678238508267776207.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200806070135.67797-1-jingxiangfeng@huawei.com>
References: <20200806070135.67797-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 6 Aug 2020 15:01:35 +0800, Jing Xiangfeng wrote:

> Fix to return error code PTR_ERR() from the error handling case instead
> of 0.

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: ufs: ti-j721e-ufs: Fix error return in ti_j721e_ufs_probe()
      https://git.kernel.org/mkp/scsi/c/2138d1c91824

-- 
Martin K. Petersen	Oracle Linux Engineering
