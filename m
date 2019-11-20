Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04FE4C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 03:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C70172245D
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 03:32:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lmNI6N1i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfKTDcY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 22:32:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33118 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfKTDcY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 22:32:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAK3Se0v028019;
        Wed, 20 Nov 2019 03:32:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=LkGa/yDyfpIKFvsapM1L/USebKst1grR9YNsRkmj7tQ=;
 b=lmNI6N1imw60bOp93olLi0t/a/MqH+pSThXa7REfqk67pi7NvUpS3ynKTNwUbVf21HP5
 V5ILvGXuiDml3OKrcI6Zcg7HOtZ5/lJ+GXXP4oD02zR6MXmZmLYlH4o7Q0yQ3DvJy92R
 UUbVzb+trUQGlcQc4W5K7JxM6KXL8ZlQ6DXMejOC8iAX7ihbc0vGkTKcd1F73i2i+3hm
 +PxdJFDpQKvqT3ucbfNzXcwSplPrR+XGimErrOYbWaAzS0y/MyZjBNY6pcvT+ramBWji
 oe0B65Wt1gSRpTM+Ki4eKBDDphljYQWLvnidWtLvSmS1uSOPsv+To5rqc0GwQN/mt1E6 kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wa92ptv0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 03:32:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAK3OA3D030912;
        Wed, 20 Nov 2019 03:32:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2wcemd2waw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 03:32:18 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAK3WDni005599;
        Wed, 20 Nov 2019 03:32:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Nov 2019 19:32:13 -0800
To:     Laurence Oberman <loberman@redhat.com>
Cc:     QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org,
        djeffery@redhat.com, jpittman@redhat.com, cdupuis1@gmail.com
Subject: Re: [PATCH] bnx2fc: timeout calculation invalid for bnx2fc_eh_abort()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1574178394-16635-1-git-send-email-loberman@redhat.com>
Date:   Tue, 19 Nov 2019 22:32:11 -0500
In-Reply-To: <1574178394-16635-1-git-send-email-loberman@redhat.com> (Laurence
        Oberman's message of "Tue, 19 Nov 2019 10:46:34 -0500")
Message-ID: <yq18sobfcjo.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=700
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=786 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Laurence,

> In the bnx2fc_eh_abort() function there is a calculation for
> wait_for_completion that uses a HZ multiplier.  This is incorrect, it
> scales the timeout by 1000 seconds instead of converting the ms value
> to jiffies.  Therefore change the calculation.

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
