Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF34C2BC11
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F94620936
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:17:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hHp8lfFu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgIICRy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:17:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46490 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgIICRq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:17:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892FFiq110820;
        Wed, 9 Sep 2020 02:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=CVdQHv9EJQ3jnrL5a737Gb9IIaDwPBpkj2Q5APh1M0Q=;
 b=hHp8lfFukehY15Uxzit6VGjSzDRVSS+Ga5HLA1/Vpd+auGZqi0pEkLULd7PcwCipINYn
 4m8uRIJvU9Myn77F3Nrw2lSYLj2hEFcfU2oztLdoFetvSs477W6AuhVuwE3k/dQ3939o
 QgnDm9nIUHLXjpiSIOaVrzI/OpG5hLjVE7t8Y/FHvrmlzo+npLFlrJ6MT8aWXUp2Wmms
 I260y2Ql78thIUvPB0vs2FPXlOy2SNiFGgsa7h2b8B0AONOQPVScJlwhUJYthobPMSJI
 LxabBwlImYtZMuuIuuxUxsOw3lX2UzwHMd+4JpgbNJcWL28pUaiuTRmek1m6d/0rLFFl Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33c2mkxw9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:17:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892FZQ2109538;
        Wed, 9 Sep 2020 02:17:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33dacjqc1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:17:41 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0892HblV009581;
        Wed, 9 Sep 2020 02:17:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:17:37 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Raghava Aditya Renukunta 
        <RaghavaAditya.Renukunta@microsemi.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org,
        Dave Carroll <David.Carroll@microsemi.com>
Subject: Re: [PATCH] scsi: aacraid: remove erroneous fallthrough annotation
Date:   Tue,  8 Sep 2020 22:17:23 -0400
Message-Id: <159961781205.6233.7483987254461010117.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200825112003.GD285523@mwanda>
References: <20200825112003.GD285523@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=780 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1011 mlxlogscore=806
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 25 Aug 2020 14:20:03 +0300, Dan Carpenter wrote:

> This fallthrough annotation is unreachable so we can delete it.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: aacraid: Remove erroneous fallthrough annotation
      https://git.kernel.org/mkp/scsi/c/cfd3d2225aa5

-- 
Martin K. Petersen	Oracle Linux Engineering
