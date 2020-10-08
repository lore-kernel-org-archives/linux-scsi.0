Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEECC433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 03:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B381C21527
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 03:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pt/zjM/V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgJHDOu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 23:14:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58502 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgJHDOu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 23:14:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0983E0NO165781;
        Thu, 8 Oct 2020 03:14:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=iG8bFON8QypxaJ6dwgl1a7kKVGtwb2SD52jllewelG8=;
 b=pt/zjM/VbQzUE+IKz4UzyADVA+qYy1AlvLizqDfRQdXB89kHCj1xKNd4dYGYBvjaIm/b
 bszCVy4kE2yJmd1BESMgvXq7iG3iwzJxl+eGe8PVVTpplTivKwOhOqZ70pvQrllzC7gO
 wyfP5BdoQfm42Q+GN6TlajfCdNgK2IOouWyDoaEULmsIx3QbI93/aVo/YgPLUImpCgD1
 K+DVfukL0AXdZe8xnC7K2FxMYYrHciAyhzaPc1d5gcrfJQzRVqAha6nbs4Y/QD6gBOMF
 iyiafi9asKV3MfoSrsyJHf0AgPykP+2PZFMOTqjNwpIju13hE11FBw32IHzA7maL1YkC pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33ym34tbqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 03:14:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09835LDt098343;
        Thu, 8 Oct 2020 03:12:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33y2vqagaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 03:12:38 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0983CZVd003579;
        Thu, 8 Oct 2020 03:12:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 20:12:34 -0700
To:     Colin King <colin.king@canonical.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sym53c8xx_2: fix sizeof mismatch
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6wxwgva.fsf@ca-mkp.ca.oracle.com>
References: <20201006110252.536641-1-colin.king@canonical.com>
Date:   Wed, 07 Oct 2020 23:12:32 -0400
In-Reply-To: <20201006110252.536641-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 6 Oct 2020 12:02:52 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> An incorrect sizeof is being used, struct sym_ccb ** is not correct,
> it should be struct sym_ccb *. Note that since ** is the same size as
> * this is not causing any issues.  Improve this fix by using the idiom
> sizeof(*np->ccbh) as this allows one to not even reference the type of
> the pointer.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
