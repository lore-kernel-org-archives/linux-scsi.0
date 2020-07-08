Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CAAC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8511206C3
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:32:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TMocDkac"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbgGHGcv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:32:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51704 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728544AbgGHGcv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 02:32:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0686VjlI041063;
        Wed, 8 Jul 2020 06:32:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=aSXAm8atLrOwBA2HH2qKiIi3wCqgqf1pZyBTn7Eq1Hs=;
 b=TMocDkac633YLFhurbAcmIbaR1rXBDYGiZE+GOUEJmyHAreI6YkNqBHKzfEfNLDdG5OF
 sEe7dJ88qBM9Qt4JSK0E3lYLx+b2P29SSOzJC7pcjyX1RUfV/w/cSxk9QCigmnc1pYZv
 nJRL9wfgPDNvZZ0AnHQznBaiSiXgZSpMvkUz5mkJHWE4q1yMj4P5wQh3D6++kgN+fvqh
 ivEtC1ChHfIJXdJRb7dVMLaHMggnnoZmgNjErDLB9IMCSkn1FsePsLmAshvB4C+TwKnD
 bcBfAxECeszyr3rxFItyDWYPNwjxCA9ZlAGrqINbUQaKilOgigzEPH8VTyEeIFKwk0g0 Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 323wacmcst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 06:32:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0686D8aa016418;
        Wed, 8 Jul 2020 06:30:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 324n4sf76d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 06:30:49 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0686UmsD008019;
        Wed, 8 Jul 2020 06:30:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 23:30:48 -0700
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH] Fix compilation warnings
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15zay1pvi.fsf@ca-mkp.ca.oracle.com>
References: <20200706123344.451738-1-damien.lemoal@wdc.com>
        <159418844430.5433.1895709179695846503.b4-ty@oracle.com>
        <CY4PR04MB37514AB91F1C8EFF3411AA2AE7670@CY4PR04MB3751.namprd04.prod.outlook.com>
Date:   Wed, 08 Jul 2020 02:30:46 -0400
In-Reply-To: <CY4PR04MB37514AB91F1C8EFF3411AA2AE7670@CY4PR04MB3751.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Wed, 8 Jul 2020 06:24:32 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=828 spamscore=0 adultscore=0 malwarescore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080043
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 mlxlogscore=848 adultscore=0 cotscore=-2147483648
 suspectscore=1 impostorscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080044
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> By the way, the patch mentioned above is not part of that series and
> should go in 5.8/scsi-fixes, no ?

Oh, sorry. I replied to the wrong ty email.

I amended the offending mpt3sas commit in 5.8/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
