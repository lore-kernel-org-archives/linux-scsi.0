Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA1BC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A91582070C
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:10:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xPUzIA5O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgGBCKM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 22:10:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48600 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgGBCKM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 22:10:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06228URp007015;
        Thu, 2 Jul 2020 02:10:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=/qt6JxeEjOZwsytjTEnroK7ou0F2WgyJtuYnT5ompZ4=;
 b=xPUzIA5Orrp6EHZtZZeT3f+m6Sv1bzuUBLFfMV7eaTeR+ni3X1BCtX8H8s49me18hjDP
 K4l60D9R/lyVNsBEvoTL80RS8k0p3qXPFYhpv1o08f1bh/tquSwiy+rT1cob9459RzP/
 iRyApxX/pMlKppQb/bbfyMwV7DO7NnOq8bEbYBumAqyZoebHE7jhhMVNAWFVqjfRMY77
 mVl2422iagBDENGWlb/9qACStlABkC231v5ejbbin5Hw0tF/xlYsLqC4EVsMlMb9WdiA
 EcwCS81WAAmEjkbrlAF0kp2XALnClKZbyfXsnPkDBhgV6ifncD1FSEBZ7xi/XdM10WXf sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31xx1e2krd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 02:10:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06227paE159840;
        Thu, 2 Jul 2020 02:10:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31xg205g3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 02:10:05 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0622A3jk027516;
        Thu, 2 Jul 2020 02:10:03 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 02:10:03 +0000
To:     Andres Beltran <lkmlabelt@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, t-mabelt@microsoft.com,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikelley@microsoft.com, parri.andrea@gmail.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 2/3] scsi: storvsc: Use vmbus_requestor to generate
 transaction IDs for VMBus hardening
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tuyqacrb.fsf@ca-mkp.ca.oracle.com>
References: <20200701001221.2540-1-lkmlabelt@gmail.com>
        <20200701001221.2540-3-lkmlabelt@gmail.com>
Date:   Wed, 01 Jul 2020 22:10:00 -0400
In-Reply-To: <20200701001221.2540-3-lkmlabelt@gmail.com> (Andres Beltran's
        message of "Tue, 30 Jun 2020 20:12:20 -0400")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011 adultscore=0
 suspectscore=1 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Andres,

> Currently, pointers to guest memory are passed to Hyper-V as
> transaction IDs in storvsc. In the face of errors or malicious
> behavior in Hyper-V, storvsc should not expose or trust the
> transaction IDs returned by Hyper-V to be valid guest memory
> addresses. Instead, use small integers generated by vmbus_requestor as
> requests (transaction) IDs.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
