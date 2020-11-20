Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EFFCC388F9
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA9B92145D
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:11:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Eezvf13V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgKTDK3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:10:29 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33140 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgKTDK2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:10:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3ALn2044782;
        Fri, 20 Nov 2020 03:10:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=k5PrlrNf9KVSXrtPPxRSQCrygMat3tBj7bkQkxUI7FI=;
 b=Eezvf13V1TteTKxp65OxlPzH0sq5wDJkLaBOMGS0SMv6A09ppEhTOw9utPBVGAZTWi4w
 JImYvL8rOyMHGyQzRAIJ8SIsj9bP64smjvdIr+D9ODhXcFBC1ZcY/4LNQJeWi+RBtN0x
 inH+z5PQzKUa6Y+/4/Go9USY1W0HKZ2wpZtl0dnI3kmTEPcrDW2YN2rnJARvQG7eUsYK
 spVAHKDfRHWiYgxGCO8eOgGKULd4Dlxu1aIO2HqKMDPjJl2k+zidTvzNdV9/3oJfexQr
 Iwekv3fM40iQKoqFPviOMY9KN0vODvNLHLaEFPRs+oFBgx/rXo3ZPdls2oFBYz4/0458 oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34t4rb8sry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:10:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK35PO1166904;
        Fri, 20 Nov 2020 03:10:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34umd2v7v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:10:15 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AK3AENR008048;
        Fri, 20 Nov 2020 03:10:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:10:14 -0800
To:     Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com
Subject: Re: [PATCH v3 0/6] ibmvfc: Protocol definition updates and new
 targetWWPN Support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z60yb94.fsf@ca-mkp.ca.oracle.com>
References: <20201118011104.296999-1-tyreld@linux.ibm.com>
Date:   Thu, 19 Nov 2020 22:10:11 -0500
In-Reply-To: <20201118011104.296999-1-tyreld@linux.ibm.com> (Tyrel Datwyler's
        message of "Tue, 17 Nov 2020 19:10:58 -0600")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=898 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=912 adultscore=0 phishscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tyrel,

> Several Management Datagrams (MADs) have been reversioned to add a
> targetWWPN field that is intended to better identify a target over in
> place of the scsi_id.  This patchset adds the new protocol definitions
> and implements support for using the new targetWWPN field and exposing
> the capability to the VIOS. This targetWWPN support is a prerequisuite
> for upcoming channelization/MQ support.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
