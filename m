Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0687C433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 01:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B32D1206C1
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 01:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aDDxWTIn";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="minwhby8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfHMBzW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 21:55:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40300 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfHMBzW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 21:55:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D1rXGO036396;
        Tue, 13 Aug 2019 01:54:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=SYAQIRoMCOUWC/dnAEtYfhr7+UppLGKt5YYkaWCo30Q=;
 b=aDDxWTInuti323aiPo+BAVCOwDreT1zgEK9gwstr2Mc0B9MoW3KtA9l9bFE6Wlsv8in4
 mS6kGiOGM2O9sxabXIqsVfmUhUPkStZpkqFetNiWG6uuk+6qDb/eI8M56SsqfiDeHLEw
 9+j4peLEFZMqDXbyxeREukao1SS7Dopa3GkDNBjdPzoZPg3j3vxSDp+KFc1Zp8IA3RRB
 SF2jAMzy2LAWXxMr9TFK6mH9BGGp6RDVZUaVOUCmBwjWkAjamRq5g1ux41qOv57MphYF
 Zw54dG/Y2OhhnGbhC+mL7gVlfGOpg0Q8yCot8GaqNuLUUza+Fs+aePL/BRGMIkVFeU4k Sg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=SYAQIRoMCOUWC/dnAEtYfhr7+UppLGKt5YYkaWCo30Q=;
 b=minwhby8GEz8P5Fp95/9QqKztJ1Ut3jEMr8eo7I+k/kt7gPdKBmajAz2O6nuh435oyzP
 qOL56hk+rKRssHdVIIZvwp1687WK5Oy9Z5QJOMAKYSqr22ChBji6WiWbcdjkW/us1J3T
 EHBGvWq+yvok10sRCqxdcBBKXdSxkMvTqb2FeDZYYPOXJViW1qGHILyEu1gTm0z2X5mW
 E82bYfjZ6U8K3VQkaNK7V3dADoSQbovSOTWRTdaVl61duiolGuSeR9meI/PesZtTi16B
 UnnVV383APpc4mVYPiR3aoiEERemss8U+82qPRMx4fyqv3Q7YJzHmuiP/UIWv+PVV1u2 rA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u9nvp331s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 01:54:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D1rWik166526;
        Tue, 13 Aug 2019 01:54:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2u9m0asjsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 01:54:44 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7D1seFW023232;
        Tue, 13 Aug 2019 01:54:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 18:54:39 -0700
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fas216: Mark expected switch fall-throughs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190806082902.GA11122@embeddedor>
Date:   Mon, 12 Aug 2019 21:54:37 -0400
In-Reply-To: <20190806082902.GA11122@embeddedor> (Gustavo A. R. Silva's
        message of "Tue, 6 Aug 2019 03:29:02 -0500")
Message-ID: <yq1d0h996ea.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=773
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=840 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gustavo,

> Mark switch cases where we are expecting to fall through.

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
