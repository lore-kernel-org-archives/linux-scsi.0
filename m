Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F502C3279D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2C4820782
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:05:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sn+UK/KJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgJGDFE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:05:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51516 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgJGDFD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:05:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09734mEK110546;
        Wed, 7 Oct 2020 03:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=jqRdFRaTCRX50YLpfWUfCvgJZ+DcIQ09ZvdMuiM6BMo=;
 b=Sn+UK/KJujisWzLS1r7hxDORKd2qqAiBtWVZGBdnJ3iUcadX35BNNZDVB5oDpqLy75xt
 iTKgCBHCh3J0dnHOwJnYxTjIYWNhSiOrWjPVvnDDdLNsE7cgpoXgP69lLqEKWJzf1xZZ
 3vvpNkfLbbRbgtl1QIn6ddAU4bMUL92xp0M4441bmpszUHUCeyyW8oHzm2I3cZls0w9C
 bYJ79I9FbcjR70H8UtuCFeD5oHJlU6Ka4qvHZzbzO21GD+o6PCAR0AR6eL+LiG3ZvTRc
 E6cIJ0rwtuOscyfvnLBiJIVckqSt6EUaByBiWa5DhuJg7vLqK20ufDz1+D+QfviWaPPH AA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetayjg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:04:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09731HEQ166779;
        Wed, 7 Oct 2020 03:04:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33y2vnwv8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:04:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09734iw9006781;
        Wed, 7 Oct 2020 03:04:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:04:44 -0700
To:     bvanassche@acm.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        jejb@linux.ibm.com, martin.petersen@oracle.com, jthumshirn@suse.de,
        hare@suse.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: pmcraid: Fix memory allocation in
 'pmcraid_alloc_sglist()'
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1qa68lk.fsf@ca-mkp.ca.oracle.com>
References: <20200920075722.376644-1-christophe.jaillet@wanadoo.fr>
Date:   Tue, 06 Oct 2020 23:04:41 -0400
In-Reply-To: <20200920075722.376644-1-christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Sun, 20 Sep 2020 09:57:22 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=641
 malwarescore=0 suspectscore=10 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 mlxlogscore=657 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=10 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> When the scatter list is allocated in 'pmcraid_alloc_sglist()', the
> corresponding pointer should be stored in 'scatterlist' within the
> 'pmcraid_sglist' structure. Otherwise, 'scatterlist' is NULL.
>
> This leads to a potential memory leak and NULL pointer dereference.

> Fixes: ed4414cef2ad ("scsi: pmcraid: Use sgl_alloc_order() and sgl_free_order()")

This does indeed look odd. Bart?

-- 
Martin K. Petersen	Oracle Linux Engineering
