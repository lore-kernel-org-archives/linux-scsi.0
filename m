Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1108C4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BDB620B1F
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NZXuk4p8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgJGDsq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:48:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36342 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbgJGDs2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:48:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973j63s045452;
        Wed, 7 Oct 2020 03:48:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wsE1/MNDyjUCvvmOIi6L1OuamYsld/LapsWGPILEX/E=;
 b=NZXuk4p8YMFnzapk8OIcJK0OaTK8lW7jOqXcQzfx++U/e/0qvAkJVh/wtCbxNazx2n5B
 nGkURqUputvmaSAxGKhYm5Ls4pVRd1yXHaW5Zvo+1UC51B2BKjL0CxhQB7Cq8SqKs3z+
 qdWX8TiB5p2it1mavcUbtelTmW73hHeSymkp2j9ztPYQfvCBUlKacEXW7FV8BVHzN/Sq
 1r7HZcWXcGsYjBj6PUl6WSJ1a0IviQSImQdTLoE4gTXqAHzrRdT132lD9w2i3QCnz8KU
 vE3dU+RLxd8ojQJ1mipcL/oGFrDXSELQfuHwE1sjoHGrm+c1YZziBxZ7jUwd9w/mxZLf Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33ym34mjy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:48:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973j9VF041264;
        Wed, 7 Oct 2020 03:48:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33yyjgm87f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:18 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0973mIcl012540;
        Wed, 7 Oct 2020 03:48:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:17 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Liu Shixin <liushixin2@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: use module_platform_driver to simplify the code
Date:   Tue,  6 Oct 2020 23:47:57 -0400
Message-Id: <160204240580.16940.1304940981080248041.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914065403.3726462-1-liushixin2@huawei.com>
References: <20200914065403.3726462-1-liushixin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 14 Sep 2020 14:54:03 +0800, Liu Shixin wrote:

> module_platform_driver() makes the code simpler by eliminating
> boilerplate code.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: sun_esp: Use module_platform_driver to simplify the code
      https://git.kernel.org/mkp/scsi/c/ea0dc2002ef5

-- 
Martin K. Petersen	Oracle Linux Engineering
