Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6833FC4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 03:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42F682190F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 03:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d29Ed6mc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732758AbfJJDhW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 23:37:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52692 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732252AbfJJDhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2019 23:37:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A3VJHb110124;
        Thu, 10 Oct 2019 03:37:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=TCEjn8oYX1fEF9LrIUxVEeOr26I0OGVyCgfX6rJ0FIM=;
 b=d29Ed6mcyNijJ6jeLZKFYfDUhnnml53Lswn5SN9Gq+FiW1hnEZZ0Q9fS152zWq+OLu3d
 ZC0jtq17VJaDuM2cuB+Tlmar0MfGenINdMfHoRyDo+YZ3liSZxWaCWp1N4cyD8xI/FVB
 oGkeTVOaUYaAJuxlsM9n+JZ4PNppMHG5xF9i3YPlCY96kqnR0gMm3hKV29BvXJkjk7qo
 bnTof7FoSSzBON7L2r0LlhrFP0T8phm1WnRp/VKvHoLUd3/INwKPoTTCEez/Z4l+Xhb7
 T9tVPv7iEuDvFQLoUiCxMVRY2AW1KylUK7LbBAFoFeG++m4dJ5tJ9pCh2gslcgE19Nwk ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vektrr5nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 03:37:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A3T3Db109516;
        Thu, 10 Oct 2019 03:37:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vh8k20cpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 03:37:16 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9A3bFQo008501;
        Thu, 10 Oct 2019 03:37:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 20:37:15 -0700
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix kconfig dependency warning related to 53C700_LE_ON_BE
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191009151128.32411-1-tbogendoerfer@suse.de>
Date:   Wed, 09 Oct 2019 23:37:13 -0400
In-Reply-To: <20191009151128.32411-1-tbogendoerfer@suse.de> (Thomas
        Bogendoerfer's message of "Wed, 9 Oct 2019 17:11:28 +0200")
Message-ID: <yq1h84hi846.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=695
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=793 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910100031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Thomas,

> Add the missing depends SCSI_SNI_53C710 to 53C700_LE_ON_BE to fix it.

Applied to 5.4/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
