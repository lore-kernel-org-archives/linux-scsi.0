Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B84C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 04:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CE1F22319
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 04:42:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="saGTKEbr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfKSEmq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 23:42:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33906 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfKSEmq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 23:42:46 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ4ces9087184;
        Tue, 19 Nov 2019 04:42:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=+SKByJjpPczR9OjtP27nypcjGz1JFMJjm8W5Fenis5g=;
 b=saGTKEbrNlt/Xdx5Ps54s+mQGmYQWwJzRjkAZ5hb5W5c/HAb05AkE/sYPSOJGx9jVDlS
 5HHbA4OAdnZIDVtSDnRmR3HAGvQ7XfItcXYClu1oOO2dZXTbctzNaGrFUihK/IpnWRY9
 i67MySxEP1ueSBHWS2VC3KwD2l7umRdiMxHUKWcUJgje78MsYxmkGAJhGWsMqryal15A
 OY8Ip3OhYXeP9bYY8/+HKCF1IRzHcre+Hgu3qMeyZSfaszuSf/f2K9BgEfzktczLALB5
 pbeQmHVLuBPnM3E5RxBlES18d7mUOpq6XLf8LoOtbCxML8blurZbVyD4oj9HZjTf7vz2 Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wa92pmbyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 04:42:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ4gdZV021654;
        Tue, 19 Nov 2019 04:42:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wc09wqe5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 04:42:39 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAJ4gZO1027197;
        Tue, 19 Nov 2019 04:42:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 20:42:35 -0800
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael Schmitz" <schmitzmic@gmail.com>,
        "Ondrej Zary" <linux@zary.sk>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NCR5380: Call scsi_set_resid() on command completion
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1f26ead9dd0dc053fcd27979d69a7ca74b6589b4.1573875417.git.fthain@telegraphics.com.au>
Date:   Mon, 18 Nov 2019 23:42:33 -0500
In-Reply-To: <1f26ead9dd0dc053fcd27979d69a7ca74b6589b4.1573875417.git.fthain@telegraphics.com.au>
        (Finn Thain's message of "Sat, 16 Nov 2019 14:36:57 +1100")
Message-ID: <yq11ru4jx3a.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=883
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=971 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190041
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Finn,

> Most NCR5380 drivers calculate the residual for every data transfer.
> (A few drivers just set it to zero.) Pass this quantity back to the
> scsi mid-layer on command completion.

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
