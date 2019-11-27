Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47674C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 02:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DF012071A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 02:30:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O5px3CgA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfK0Cau (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 21:30:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48432 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfK0Cau (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 21:30:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR2TIVC024463;
        Wed, 27 Nov 2019 02:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=JrGo/aJN1mHO7VqhwYPgcCJ1sYT7BsnzcntD5cWkBbM=;
 b=O5px3CgARI4MisIKP4S7176PGnbI4gAJu45IxJfj8iU5Z2mQovu8FNcaAemuhcRHlouP
 p5x+EKF6noEVQ1BU1UQ8TtUPa/Fij62/k+GpLETFZYumOCWXU5rnuOdxgHHRX23iQfna
 9OIGJpPOgsl6Santlw0uTvKPpnWu17F6TO6hyVq4KDC+cwAHN7iflL81Vyvr0mHgXw3q
 ozqulC5L+5eAH00xijaMJprY/Wq77M5getG3oungIrU9yu4MHAr/JBBIyA4oQ7nUqMXm
 1Jxc5Xp5NBeUKp5UEoOfw6sL8DCMKyDolBBo9Cksnf796galju9b2MlTZwfiB+aA3tWS GA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wevqqag1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 02:30:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR2TBGT151171;
        Wed, 27 Nov 2019 02:30:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wgvhb8da8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 02:30:42 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAR2UcuK026703;
        Wed, 27 Nov 2019 02:30:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 18:30:38 -0800
To:     Colin King <colin.king@canonical.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Deepak Ukey <Deepak.Ukey@microchip.com>,
        Viswas G <Viswas.G@microchip.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: pm80xx: fix logic to break out of loop when register value is 2 or 3
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191120135031.270708-1-colin.king@canonical.com>
Date:   Tue, 26 Nov 2019 21:30:35 -0500
In-Reply-To: <20191120135031.270708-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 20 Nov 2019 13:50:31 +0000")
Message-ID: <yq136ea9hkk.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=975
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911270018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911270018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The condition (reg_val != 2) || (reg_val != 3) will always be true
> because reg_val cannot be equal to two different values at the same
> time. Fix this by replacing the || operator with && so that the loop
> will loop if reg_val is not a 2 and not a 3 as was originally
> intended.

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
