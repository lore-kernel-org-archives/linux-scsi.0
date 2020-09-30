Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B4EC4727D
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 02:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26F1620773
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 02:50:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b2A9mv2T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgI3CuI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 22:50:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47866 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729446AbgI3CuI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 22:50:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U2nnO5133024;
        Wed, 30 Sep 2020 02:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=KwQiQIwTAXLr+1n+aWIWws/1PILAcOzTg3nI0UQjT/k=;
 b=b2A9mv2T+9PLd3fxhH+9R2I6n7rXnQjbgfNPMoyXS349twxQ/HJ2+qpRL8QWdCwZU4A0
 Q1bdTMXp1xAahHcNj0x3b1dGy5zrsh3WeamsLsq2jWayQNehAAFV0OHs3EbX87E2HTCb
 ckVndrI4kO8HbVq4dkAck4vyTFcU94bFX6ri0/2D9aNAizXb/Q1SSHtlnAGgKaZSNHL3
 fMkarEjp6XbreFfUl9lnAY22X1aLRu56859wedJs40BclTWn+7I3ZeQ4qremC4+i04FQ
 Pl4X3N1mvKykffWGTu2zNxtRQEz3DooUbqgkRgrxjm6VR4cXCgVKm7rUR4NFEITm777d IA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33swkkx7bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 02:49:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U2irZF139962;
        Wed, 30 Sep 2020 02:47:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33uv2eq6uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 02:47:49 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08U2lgAl003532;
        Wed, 30 Sep 2020 02:47:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 19:47:41 -0700
To:     Hannes Reinecke <hare@suse.de>
Cc:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/9] Rework runtime suspend and SCSI domain validation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sgb0gf6e.fsf@ca-mkp.ca.oracle.com>
References: <20200906012219.17893-1-bvanassche@acm.org>
        <f4ff6be8-84b6-6f08-8657-21238c99df9c@acm.org>
        <ab848686-fe88-7b79-f75a-e192f3e3f3eb@suse.de>
Date:   Tue, 29 Sep 2020 22:47:38 -0400
In-Reply-To: <ab848686-fe88-7b79-f75a-e192f3e3f3eb@suse.de> (Hannes Reinecke's
        message of "Mon, 21 Sep 2020 08:00:40 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 malwarescore=0 bulkscore=0 mlxlogscore=827 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 mlxlogscore=840 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Hannes,

> I'll check if I can resurrect my setup.

I'm afraid I don't have any SPI stuff to test with and it would be good
to get at least a basic smoke test performed on this series. So if you
have a setup to try it on that would be much appreciated.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
