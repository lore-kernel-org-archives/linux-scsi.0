Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C899C63777
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4A6F2085B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:48:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YJjuMS4G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgKXDsY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:48:24 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43872 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgKXDsX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:48:23 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3T03n039012;
        Tue, 24 Nov 2020 03:48:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=P2tdlic+bz9rYgNxW7PiBXNicBQRSc4EaMXcKO1dJy8=;
 b=YJjuMS4GkTCgTCiUXhCQbOuxrjfkjBvUkqPKiMTzeZCY0b9t9ZGtKFaN1k91w8vkW22x
 ZL39D+Wfc+IBl3yrElHH2PZtmFeu/onsDbCwMnXqgazRVtrRAuPGN6N9Y5lzlZUk0BNE
 ZnBg6XR8E+qXIyKLEmf+WcNBzPBClol52+ESloOBjKPOLfN0C7wnY754ReEtGk98Lwlh
 jrwI3YOQJ52gbeRE+NRZ6mfsOsABHJ/C7y1uDEJuP3Ore/DmhrE7goKdsK1Sg7xVfW88
 znbfZrtjOSdaLIbRMe1R7dMjgGeq41owehR0K1ROCOTFCXm/3uD58PXPJgR/PEcIYs6o CA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34xrdarkr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:48:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3itWH090772;
        Tue, 24 Nov 2020 03:48:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34yctvts0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:48:20 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AO3mIpZ031081;
        Tue, 24 Nov 2020 03:48:19 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:48:18 -0800
To:     Karan Tilak Kumar <kartilak@cisco.com>
Cc:     satishkh@cisco.com, sebaddel@cisco.com, arulponn@cisco.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Avoid looping in TRANS ETH on unload
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6v7mn48.fsf@ca-mkp.ca.oracle.com>
References: <20201121012145.18522-1-kartilak@cisco.com>
Date:   Mon, 23 Nov 2020 22:48:16 -0500
In-Reply-To: <20201121012145.18522-1-kartilak@cisco.com> (Karan Tilak Kumar's
        message of "Fri, 20 Nov 2020 17:21:45 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=1
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=961 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=992 spamscore=0 phishscore=0 clxscore=1011 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=1 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Karan,

> This change is to avoid looping in fnic_scsi_abort_io before sending
> fw reset when fnic is in TRANS ETH state and when we have not received
> any link events.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
