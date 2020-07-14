Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75DF4C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 03:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F2C21D95
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 03:09:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kl3CPKP6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGNDJb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 23:09:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54942 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbgGNDJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 23:09:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E33PAg139186;
        Tue, 14 Jul 2020 03:09:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=9WiW7AsKpg074xTxZcX/lyrAKBNFxZx2MiLwH/8n4gQ=;
 b=Kl3CPKP67RDRBquktsRxl43yHzk8RsmRat0vtrpt5e0H255Sazh8BIcdf0vrq/hPYB/s
 bjOCl4V6seraEy4RA7SVhcTZ88fiLOMa6j5Xwe8Rgdz/AqhAq+k+085D/BBFZy5dJoKW
 7nZwy4dcI8uNezElxLYt1y5tFHsJpyJluPuar9y3Plzy+TgCkiZeiGebgm2Ej8Aggj+n
 VO0N7VBKfrlLrsQDDftMm2OQlUF4PFafKq/4Hm0gfYUn2dRm1UgM7EEuT2/Ss1AOefmi
 tyZbnfL9JZhOVUmmLUsMW4Bmmtg1PgT+oEGbodZLHVdBo0Cnf6om5ysFlZLM1tE921Om yQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cm2n3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 03:09:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E33Yss018722;
        Tue, 14 Jul 2020 03:09:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 327qb2ewgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 03:09:27 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06E39Rta015950;
        Tue, 14 Jul 2020 03:09:27 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 20:09:21 -0700
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH] qla2xxx: Address a set of sparse warnings.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dv6ssiv.fsf@ca-mkp.ca.oracle.com>
References: <20200708162515.29805-1-njavali@marvell.com>
Date:   Mon, 13 Jul 2020 23:09:19 -0400
In-Reply-To: <20200708162515.29805-1-njavali@marvell.com> (Nilesh Javali's
        message of "Wed, 8 Jul 2020 09:25:15 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Fix sparse warnings,
> drivers/scsi/qla2xxx/qla_isr.c:881:23: warning: restricted __le16 degrades
> to integer
> drivers/scsi/qla2xxx/qla_isr.c:881:23: warning: cast to restricted __le16

Does not apply to 5.9/scsi-queue. Please rebase.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
