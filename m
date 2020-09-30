Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C5EAC2D0A8
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 03:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 349B120773
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 03:35:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VFW7x9MT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbgI3DfG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 23:35:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41930 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbgI3DfF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 23:35:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U3Nvsd178163;
        Wed, 30 Sep 2020 03:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=0lAZefPejvx3i2yeQDgX9n3qJOMlUXfHYlX1NrDj5k0=;
 b=VFW7x9MTn+3NeOZkf4XzWvNNNDeqNWFm64WljHlDa2893M8Jly/sRYI4mh0Xip3MS6TF
 otst1LHYGmxtRx8pLeo4VkPZSoZWbUxW3BmhzDEMfOqZTHa15b0nBdvztxD/WV0LZjpt
 vRF0wE39JUj/NxDqISyPB508zbCeDab2Tq2g0X/71oBUjDCNGLYagYUg9VDEfpBVqEVa
 +qTDCd19WwpykKveV/+dcl8GGqSC7nIdGNPZ1MyggynAXgJg5crJ7BRF5U4iYuY5n91M
 5z23miRmxt2gZ3lzWww9eyYgI4MEzu3x4+GHvgqyZkEFjq7rjjLJ1jC9tiWF/O06NqAH NA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33swkkx9pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 03:34:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U3OqNb032210;
        Wed, 30 Sep 2020 03:34:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33uv2er5kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 03:34:57 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08U3YtiE006032;
        Wed, 30 Sep 2020 03:34:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 20:34:55 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Liu Shixin <liushixin2@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] scsi: libsas: simplify the return expression of sas_discover_* functions
Date:   Tue, 29 Sep 2020 23:34:48 -0400
Message-Id: <160143685413.27701.15097360698889605973.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921134558.3478922-1-liushixin2@huawei.com>
References: <d44beaa3-6338-9188-7cf3-338cc0120305@huawei.com> <20200921134558.3478922-1-liushixin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 21 Sep 2020 21:45:58 +0800, Liu Shixin wrote:

> Simplify the return expression.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: libsas: Simplify the return expression of sas_discover_* functions
      https://git.kernel.org/mkp/scsi/c/3d1a99e2b540

-- 
Martin K. Petersen	Oracle Linux Engineering
