Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AC4C4363A
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 03:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C0DC2145D
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 03:10:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OijqvwI3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgJHDKF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 23:10:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55346 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727449AbgJHDKF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 23:10:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09839w1F148668;
        Thu, 8 Oct 2020 03:09:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=SDZqZ5Awk6Gu+NGJV4XP8Jic5sULMQpjBVTuLnEmjXg=;
 b=OijqvwI3u5XGn6/y7cEs6Adoh4xy0zBgIIQLYP+Z/zIwZR+hVS14GGBYpbQLo+mMYhMU
 k4cvq0Yx9QtpFDsFLfEDEckIgxi4tLaFsRGwzyGc10ORb5aCibmW3koejQjon0vWeGxk
 hBX2I7N4eOe3Qi4FB6w5yLxiJWleAYQMfD+l0uY5ZBmO11Ab00P1x3j6kIrYvsqT8wdA
 zDPuonImSwEnoWuMfeUp1La8bsHhN6mbvNV2yiAFCFQ/Nw7qpVAh/tEACIJzrnByyUSe
 St+g2igBpTsjU6bg+OQeiOcqKWALWmvgt8+M0W6yXNaqJzCgWFm2nGgdYnEsX3uJ9SRW Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33ym34tbbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 03:09:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09834t3q056358;
        Thu, 8 Oct 2020 03:07:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3410k0e61k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 03:07:58 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09837uY2002421;
        Thu, 8 Oct 2020 03:07:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 20:07:56 -0700
To:     Ye Bin <yebin10@huawei.com>
Cc:     <njavali@marvell.com>, <mrangankar@marvell.com>,
        <linux-scsi@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: qla4xxx: Fix Fix inconsistent of format with
 argument type in ql4_nx.c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lfghwh30.fsf@ca-mkp.ca.oracle.com>
References: <20200930022228.2840587-1-yebin10@huawei.com>
Date:   Wed, 07 Oct 2020 23:07:54 -0400
In-Reply-To: <20200930022228.2840587-1-yebin10@huawei.com> (Ye Bin's message
        of "Wed, 30 Sep 2020 10:22:28 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ye,

> Fix follow warning:
> [drivers/scsi/qla4xxx/ql4_nx.c:3228]: (warning) %ld in format string (no. 1)
> 	requires 'long' but the argument type is 'unsigned long'.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
