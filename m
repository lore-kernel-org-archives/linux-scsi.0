Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1232C5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C7B822249
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:20:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rMywTK2d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgKTDUl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:20:41 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52252 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgKTDUk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:20:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3A1LL128995;
        Fri, 20 Nov 2020 03:20:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=omJLj0DD2AsFNAloy7K505800YqgGixhD72DShy+WmM=;
 b=rMywTK2dXmAC3To/xVODbWJEW5wPFTR5y9sTpXDFaose12buMZwl9GlwASHM8tOMHfvU
 cC9R+jxiAXoeSBjL73E8Ij9OqfgC9pVjKJD10A1gbd10BEMtm0NYGTWdGqEoVsbOjYbV
 NGPd+yzYN59wR6qB+iW4O29QoHqLX+pgiB6CD+TBfdRsCSrhzF13jcKDmtLaTudDL2aN
 903UlWkj35zyCMq/dLwb2/jRZnRnZLhqgpYaEA8vpaYK4qsu8zLU95rmnGUDMpyz+Iuh
 l8rsMDnt4RM8Gn0DuUUU82lC8rk9lUmLiKhSf4vXHWZVuqqmihcWp5BjUr+qZxzA2Jfb NQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34t7vngnj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:20:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK35bKa027904;
        Fri, 20 Nov 2020 03:20:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34ts0uppy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:20:37 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AK3KaYL021245;
        Fri, 20 Nov 2020 03:20:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:20:35 -0800
To:     James Smart <james.smart@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] lpfc: Fix set but not used warnings from Rework remote
 port lock handling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1d008ww77.fsf@ca-mkp.ca.oracle.com>
References: <20201119203340.121819-1-james.smart@broadcom.com>
Date:   Thu, 19 Nov 2020 22:20:34 -0500
In-Reply-To: <20201119203340.121819-1-james.smart@broadcom.com> (James Smart's
        message of "Thu, 19 Nov 2020 12:33:40 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=1 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Remove local variables that are set but not used.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
