Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B18CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 03:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C13E2075F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 03:40:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WftVZ1kT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgG2DkX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 23:40:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35776 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgG2DkX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2020 23:40:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T3VrQH132304;
        Wed, 29 Jul 2020 03:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=1eFxcB4ZGcIFpWJLUCrzXySlH1jF2pFkipIl2FijrQs=;
 b=WftVZ1kTVXs6juAmcsdZCggnWTB0ajiLGTj3gWZNy4laxBs+zk32anr3FGaOjcWGJH51
 ax89hwglHe5z0dAmZ5X5Wj7GBYNL+ienNIEkOHDGJkZGGolUrOeqFuT2JagN9BoxZsCe
 JV/pIga/x7ycQD5a5LmvB0RzyudfJXPJyn41QWAU3z5QQjUh0Vmsn9lNuWYJWtueCsBk
 gsMzPn5Dykvnp6/20vSFCUhvyAJ4LPhAySlceMgEuBruPb1hRaRI9TeXq7dL9x3f4jHj
 G8QVMhqGO0gbZ9vSAOocD/Rfgtyw0HAgAWnewxSEQuB/5PBgQpLRC07pEPRjFjjHNSHP Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32hu1jk3qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 Jul 2020 03:40:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T3WgSH003067;
        Wed, 29 Jul 2020 03:40:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32hu5vpunv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 03:40:16 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06T3eFuC012160;
        Wed, 29 Jul 2020 03:40:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 20:40:14 -0700
To:     Suraj Upadhyay <usuraj35@gmail.com>
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2] scsi: megaraid: Remove pci-dma-compat
 wrapper APIs.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7tr80ij.fsf@ca-mkp.ca.oracle.com>
References: <20200727140826.GE14759@blackclown>
Date:   Tue, 28 Jul 2020 23:40:12 -0400
In-Reply-To: <20200727140826.GE14759@blackclown> (Suraj Upadhyay's message of
        "Mon, 27 Jul 2020 19:38:26 +0530")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=1 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hello Suraj!

> The legacy API wrappers in include/linux/pci-dma-compat.h
> should go away as it creates unnecessary midlayering
> for include/linux/dma-mapping.h APIs, instead use dma-mapping.h
> APIs directly.

Instead of all these individual patches, please submit a combined patch
series for the changes under SCSI.

Each patch should fix a single driver. Please don't mix changes to
completely different drivers such as hpsa and dc395x in a single
commit. And please don't split semantically identical changes to the
same driver into multiple commits (megaraid [2/2]).

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
