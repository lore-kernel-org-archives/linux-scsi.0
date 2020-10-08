Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF97BC47095
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66079207C3
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:32:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N9pjtale"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbgJHCcD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 22:32:03 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38196 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgJHCcD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 22:32:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982Ufo0006183;
        Thu, 8 Oct 2020 02:31:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=bJ6fW6B98Zvkr9sht1F7HPr3oF3sns7Es4BDcIoh7Tk=;
 b=N9pjtaler6yLqJQ4Qqu/25O0c2d4v6SDbkyylMS81woWYD+T5tTGSlF2zXsAKPDNRPaw
 ukEtCzI3lxRRmKuT4R+ratzwIlNIqSJ/nm0QPeg4fg6jfhNXe8KrdMT91ySgvyNy85zl
 Gfa7RaVaJ3ng4PKAGXxyFn87m4k6jWJDF+i40Z6yerjk8YXmo2nItHCmbcqn9eXYd9fE
 cC5AePpMg6jEJNJ/zXpOUjfrRoKvreKt/GlmSzT4uc2Tuz+tQosoGSZArg1OQ5MZTpVE
 igFkWzYMduJn8YvhDBwrXPXHPFcr34s9sFRBjFrd+VRsFIai3hd9A9FExj67sopxeRM7 xA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetb5avh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 02:31:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982UsvK183631;
        Thu, 8 Oct 2020 02:31:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3410k0d72x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 02:31:58 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0982Vt6e012384;
        Thu, 8 Oct 2020 02:31:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 19:31:54 -0700
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] target/rd: drop double zeroing
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11ri9zbvz.fsf@ca-mkp.ca.oracle.com>
References: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
        <1600601186-7420-3-git-send-email-Julia.Lawall@inria.fr>
Date:   Wed, 07 Oct 2020 22:31:52 -0400
In-Reply-To: <1600601186-7420-3-git-send-email-Julia.Lawall@inria.fr> (Julia
        Lawall's message of "Sun, 20 Sep 2020 13:26:14 +0200")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Julia,

> sg_init_table zeroes its first argument, so the allocation of that argument
> doesn't have to.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
