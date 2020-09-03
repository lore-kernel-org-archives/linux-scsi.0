Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19D5C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 01:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 869D3206E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 01:20:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eFr3ju4Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgICBU2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 21:20:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40902 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgICBU1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 21:20:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0831DdNG017482;
        Thu, 3 Sep 2020 01:20:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=j0ertZsCwM1/ANvNsjalQbfqejdQR6X4/FoFM0pUEic=;
 b=eFr3ju4ZuQHJaBnhRyJ4TILuPXvGQmp1KY0EzOzyWM9pNTELIq9dW5T5SnF6dIEyMneH
 CEAV51kaXU3RSLdi9RT/w2RaJuSQGbFkBud+D/QBqrOGMwhKleJqYJSu1R3wiOtgxWPr
 KEcFKE8dbn8Z3ZAi1fDYdOr2GG97CSj9Gn9g2jUJ+4gNusirE5YQLOTuMLEqFCL6Ykh0
 Uz/34aSweloEL0Pw1f/u4dzvhYDQf+yCgM5jwnOuDPTpPbfB4AENE2n174+t/I7RNAuB
 3Ok11amXxDfbPVWlguuDy9OtMbJU3EhrXeukdzuXo/1UhouCTwlUkIzGz0S9vwBV+Vvh zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 339dmn4cmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 01:20:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0831FFio151098;
        Thu, 3 Sep 2020 01:20:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3380kqxttr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 01:20:21 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0831KKrk032662;
        Thu, 3 Sep 2020 01:20:20 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 18:20:19 -0700
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        njavali@marvell.com
Subject: Re: [PATCH v2] scsi: Don't call memset after dma_alloc_coherent()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kofejwh.fsf@ca-mkp.ca.oracle.com>
References: <20200820185149.932178-1-alex.dewar90@gmail.com>
        <20200820234952.317313-1-alex.dewar90@gmail.com>
        <yq1eenlezwf.fsf@ca-mkp.ca.oracle.com>
        <20200902160337.kvuujxodeokrbn4d@medion>
Date:   Wed, 02 Sep 2020 21:20:17 -0400
In-Reply-To: <20200902160337.kvuujxodeokrbn4d@medion> (Alex Dewar's message of
        "Wed, 2 Sep 2020 17:03:37 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=956 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=976 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=1
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alex,

> Nvm, someone's already beaten me to the punch!

Yep, that one was already fixed up. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
