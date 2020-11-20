Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C3FC6379F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D9E2145D
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:10:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QsSQLvHs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgKTDKF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:10:05 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:32840 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgKTDKF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:10:05 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK34W9B040618;
        Fri, 20 Nov 2020 03:09:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=lLCnPs3Y88E1DLLJhdWCcM4wtkjHToEze7h1vCE4g/o=;
 b=QsSQLvHsCFYbv5YnpvgoXRF1Z2M8NKs9UHPgzXS3Gd2Ccv1xrba6YymT+HTcA8e2A9s8
 Zklms5pYC8CS7QuB2KUsqN41tE2NJPBr4o/Ax93rL5WgzpxqrX2JcJ8JlgiY7pCFayNw
 ET58pDC5234x0US4OaSM/D1LzngwId+j9FaRR9e2WDXjPlP/geO/wYIIbYUU3WFp4JL5
 CdFTTy4Va0BneGty9D2uldEzCMe+fKxluPqLopf7TOB9it+BE5PKY8tqWhlzk7aoZW4x
 cyEuiDWkLs8kf1XziawbLFelYREkApsXNABxAMkBmzgb9mtfPHlJVgyYGX1QmJEcyaoV Lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34t4rb8sr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:09:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK36eWd160659;
        Fri, 20 Nov 2020 03:09:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34ts60vr31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:09:55 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AK39nTv007582;
        Fri, 20 Nov 2020 03:09:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:09:49 -0800
To:     Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com
Subject: Re: [PATCH 1/3] ibmvfc: byte swap login_buf.resp values in
 attribute show functions
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1blfsyb9t.fsf@ca-mkp.ca.oracle.com>
References: <20201117185031.129939-1-tyreld@linux.ibm.com>
Date:   Thu, 19 Nov 2020 22:09:47 -0500
In-Reply-To: <20201117185031.129939-1-tyreld@linux.ibm.com> (Tyrel Datwyler's
        message of "Tue, 17 Nov 2020 12:50:29 -0600")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=1 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tyrel,

> Both ibmvfc_show_host_(capabilities|npiv_version) functions retrieve
> values from vhost->login_buf.resp buffer. This is the MAD response
> buffer from the VIOS and as such any multi-byte non-string values are in
> big endian format.

Applied 1-3 to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
