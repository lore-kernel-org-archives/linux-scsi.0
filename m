Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29FC3C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 02:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7A3E2087D
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 02:01:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VzU+tqAA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgIPCBI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 22:01:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50558 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgIPCBE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 22:01:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G1sRI9004551;
        Wed, 16 Sep 2020 02:00:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : mime-version :
 content-type; s=corp-2020-01-29;
 bh=YzaglPsjt4/JTPJfQ2xWXePQIqkgW9AqHUCvoonbdnU=;
 b=VzU+tqAAGyKIdOz3LgZXlo6gvVKGr/NhckaaMqijgiZnAUFeAqUHLVkYkpfVzcOOGXmv
 PJO4BG/4zgPEKAPjrplO8Sy3BAKacZoTbvGCHrbsO3Mkc5IOTwThRROCOhkIivsoJ74b
 utIX/uccLen1tClly6rA+RlZQx0qV5tbPcLvUpy+k9dwikLZJgi/mkGbzqsyndTTl0r0
 DWY/PTIlAuheW3hOYA84VirNaSmtFyuzqx5+CBAM7tA7MZnG288jtk8ZtjSKoJ9tk9QO
 QhvOVtcN1q21svKyHPzKs1ce3h0nyMqpxEynTvUaD6oxlskLXLXmigxy3f7pjA0TfuqP 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33j91dhyx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 02:00:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G1trQH126201;
        Wed, 16 Sep 2020 02:00:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33hm31nvkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 02:00:57 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08G20tsx023420;
        Wed, 16 Sep 2020 02:00:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 02:00:55 +0000
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Use kmemdup in two places
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20200909185855.151964-1-alex.dewar90@gmail.com> (Alex Dewar's
        message of "Wed, 9 Sep 2020 19:58:55 +0100")
Organization: Oracle Corporation
Message-ID: <yq1v9gexz0g.fsf@ca-mkp.ca.oracle.com>
References: <20200909185855.151964-1-alex.dewar90@gmail.com>
Date:   Tue, 15 Sep 2020 22:00:53 -0400
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160011
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alex,

> kmemdup can be used instead of kmalloc+memcpy. Replace two occurrences
> of this pattern.
>
> Issue identified with Coccinelle.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
