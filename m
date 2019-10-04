Return-Path: <SRS0=tG2Y=X5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95EF4C32792
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 01:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D12820862
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 01:56:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r40pwOBo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730903AbfJDB4n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Oct 2019 21:56:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45520 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbfJDB4n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Oct 2019 21:56:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x941sgar046492;
        Fri, 4 Oct 2019 01:56:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=z0WaPDfidjEpxZMspmeDv6FD6/7TIl0mI3WRlHLb3KM=;
 b=r40pwOBoOd+J/t8/IsPri7oF7i0KO3H3fp0STmlfuDclpd5jTsmr7u1DxA7cjxRVdkmZ
 GBwmwNXdiyOOsndtRjQrOTslOjdDqXkSPK+2Y6f7AJPeUbgiyOD07UK31NdJ9MamB0bk
 bcwhXaZGij3yzl7gS8eiMv9MTkjHCYytxxDQz1AnVAV4cyBz7B7OvF/EHhhO8Jmpmydo
 ZPZbQyB8EPP8rtrNovNdpRTyk0P5JWuNXK8PaX1/X27DRO5d06HqFQAMiddUnTfH5V0y
 u1BoRdguhrjc+4Gq6YAWn4uOYXFa5zWf/0Gkd4L6JjA+i6bgTA3enYTVeJH/mHYKL7YO jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2va05s82k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 01:56:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x941r2Zt118062;
        Fri, 4 Oct 2019 01:56:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vdn18kwe3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 01:56:38 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x941ubIA020126;
        Fri, 4 Oct 2019 01:56:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Oct 2019 18:56:36 -0700
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        Allen Pais <allen.pais@oracle.com>
Subject: Re: [PATCH] qla2xxx: fix a potential NULL pointer dereference
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1568824618-4366-1-git-send-email-allen.pais@oracle.com>
Date:   Thu, 03 Oct 2019 21:56:34 -0400
In-Reply-To: <1568824618-4366-1-git-send-email-allen.pais@oracle.com> (Allen
        Pais's message of "Wed, 18 Sep 2019 22:06:58 +0530")
Message-ID: <yq1h84ps27h.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=768
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910040012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=866 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> alloc_workqueue is not checked for errors and as a result,
> a potential NULL dereference could occur.

Himanshu: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
