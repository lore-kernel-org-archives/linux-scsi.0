Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E81C4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 21:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3CE721655
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 21:34:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q0InqFQO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389822AbgJZVeu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 17:34:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37010 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389811AbgJZVet (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 17:34:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QLExfe138082;
        Mon, 26 Oct 2020 21:34:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=un37n0FIHnFwbxrRcUkyNLtVY2ujGT6ieFb2n8vEiQA=;
 b=q0InqFQO7V/WzlyLzNhh+tnUVzugiD2dYBJatss3ayEXI9MMT0tlRcC1lZm8HM0i39uE
 tRTXIretAIvAzEnGmqws06I8dufwQB7zVFGQvMxvyflOlc6ZlQBNeoW11p4fEme6S2r4
 qh0SPQRU+W4fXInipbKggncyDrGWhwf4+Iy8YGYOjrEtmvVok91OSAqnV4LebfepxEMF
 3CTHfQICGBwP//KL0XC3Z4BX1inKvre77GGCbqywT2Y6dLyVa7ij36XiPWGP92Vcb6aC
 hxwp7d02EvDc4/kY10CvXTlvnNp8fDToXoJinlKU5Xo7cniqEP0rwYwmPE9AGZxCuNac +g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kpxac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 21:34:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QLUOFS168952;
        Mon, 26 Oct 2020 21:34:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34cwuknnvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 21:34:39 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QLYcXO016641;
        Mon, 26 Oct 2020 21:34:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 14:34:37 -0700
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH] scsi: hisi_sas: Stop using queue #0 always for v2 hw
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lffs8ye1.fsf@ca-mkp.ca.oracle.com>
References: <1602750425-240341-1-git-send-email-john.garry@huawei.com>
Date:   Mon, 26 Oct 2020 17:34:35 -0400
In-Reply-To: <1602750425-240341-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Thu, 15 Oct 2020 16:27:05 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1011 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260139
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> In commit 8d98416a55eb ("scsi: hisi_sas: Switch v3 hw to MQ"), the dispatch
> function was changed to choose the delivery queue based on the request tag
> HW queue index.

Applied to 5.10/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
