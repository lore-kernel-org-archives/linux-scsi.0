Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDEFC4363D
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A299207C3
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:13:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RJXCBbRU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgJHCNQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 22:13:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53386 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbgJHCNQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 22:13:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09823U7Q174732;
        Thu, 8 Oct 2020 02:13:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=fKGpwbpCUrO7poR5kPR53uD17H/Na+4QP1jfSojSiHY=;
 b=RJXCBbRUshXl3o4xApOq0CU1fcZDBdKuTRc4Lcc9SePdZmrKEnBmYKNHFfmldeI6ePAy
 1CqSF4d+EYHKab5AUWm53vH+bJkJ+pwai3Oj94DmfKJaslg7V9kPQh5sJvgCB6PJeu8C
 ZZdafPkLIw7KN2SHC1g569PPJUQO+v6jBN+gR/h2IU2kSdT3JTYwXmDA2zEY+um9qIaX
 2kgouNRwg2uAWXNpVHhEo0dIA8T2nTfdAP5kpYNbGO3ZjO0/rTMJlt/gn7JE59HHiAKY
 FFeyMG6TPRIPOcVyhLVzYJRBLNl7lR9estHrIVbk41C/Gzhv0n+LcxrKA5wPsB3mPpIi BQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33xhxn52bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 02:13:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09824rgA114571;
        Thu, 8 Oct 2020 02:13:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3410k0cpcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 02:13:01 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0982Cx4r031199;
        Thu, 8 Oct 2020 02:13:00 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 19:12:59 -0700
To:     Pavel Machek <pavel@denx.de>
Cc:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qla2xxx: Use constant when it is known.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8ldzcrg.fsf@ca-mkp.ca.oracle.com>
References: <20200921112340.GA19336@duo.ucw.cz>
Date:   Wed, 07 Oct 2020 22:12:57 -0400
In-Reply-To: <20200921112340.GA19336@duo.ucw.cz> (Pavel Machek's message of
        "Mon, 21 Sep 2020 13:23:40 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=954 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=968 adultscore=0 clxscore=1011 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Pavel,

> Directly return constant when it is known, to make code easier to
> understand.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
