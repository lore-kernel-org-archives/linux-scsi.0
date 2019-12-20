Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FF5C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 03:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F113206EF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 03:44:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FPNlO7BL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfLTDoa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 22:44:30 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43300 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfLTDoa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 22:44:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBK3iKVx065254;
        Fri, 20 Dec 2019 03:44:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=GxrbypKJ7u4bYWHSxbaF1KBUmRXsfaM6J7sXR2ZDJ/s=;
 b=FPNlO7BLM/ucNXiOniCkCXdlWRCMp0l3NheUYjqGeLhi4SlqpGPCkIw8jY3fokmMI+QV
 wO8j+JqYbDLIcAKVm8UxQNwoxF1Lq/2l3w7DQH+exJEhj2zZNYDWDNm36lf12U+5qCG3
 OZjchiSUoCHbC++BlTMVNQksnRLSYYmeg0ssQfdeGEBKxOtREy9St/tUL8pDVYwgowcP
 k4oF8QUKWnezCQgCT8zmF2d+UhtnNEtGFZxbF0zpldxBjNY8C5SPUrP6Y8l4/o8as6mL
 2g4yzWeV02KY1rqoVsMe+D0Cys6PEhUKKWFwEeKa3N8vZS/b0UwnClayD8k6e6RJzynP GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x01jaedyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Dec 2019 03:44:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBK3huNd064526;
        Fri, 20 Dec 2019 03:44:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2x04mt8vb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Dec 2019 03:44:24 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBK3iMxY013293;
        Fri, 20 Dec 2019 03:44:22 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Dec 2019 19:44:21 -0800
To:     =?utf-8?Q?Thomas_Hellstr=C3=B6m_=28VMware=29?= 
        <thomas_os@shipmail.org>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com, Thomas Hellstrom <thellstrom@vmware.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishal Bhakta <vbhakta@vmware.com>, Jim Gill <jgill@vmware.com>
Subject: Re: [PATCH RESEND 1/2] scsi: vmw_pvscsi: Fix swiotlb operation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191203193052.7583-1-thomas_os@shipmail.org>
Date:   Thu, 19 Dec 2019 22:44:19 -0500
In-Reply-To: <20191203193052.7583-1-thomas_os@shipmail.org> ("Thomas
 =?utf-8?Q?Hellstr=C3=B6m?=
        (VMware)"'s message of "Tue, 3 Dec 2019 20:30:51 +0100")
Message-ID: <yq1sglf8xv0.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=965
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912200025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912200025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Thomas,

> With swiotlb, the first byte of the sense buffer may in some cases be
> uninitialized since we use DMA_FROM_DEVICE, and the device incorrectly
> doesn't clear it. In those cases, clear it after DMA unmapping.

Applied 1+2 to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
