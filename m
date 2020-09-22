Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A92C4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49F3B23A32
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tNKj2lu3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgIVD5T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:57:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48334 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgIVD5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3nRe3077435;
        Tue, 22 Sep 2020 03:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=SsXjOy/jJseEV++jujGReWmRvmZ88GovLw9CCSmqYG8=;
 b=tNKj2lu377zLcyvc95cJhaYKNEhTppNOY7Fmy/epeq7Fx79x8RYBn4cRX5Ds/e4vrlKe
 JnpYvLc02+jqUUhBeLwi04rODPeVZjeQbwsf4sy/ZX1POAGaO8+1hp/v+oj3s+QNvUTl
 v9/22YHX/nVZVSQxmQ0aqiuUCx/IbsbG8/3UroCLlTTx0baWdLjx586CsAzIdmCe/C1g
 kLWc4dwaZn8gmEtPrhY706GaojkQc3bgnzautn675oJrJhm6nn6/fhBQ+FFYBltS9NbJ
 01w8pc9yVR5D/JlopQ2v9PY+dljRdnNHkCLwTnHhhKNB1pJ3cNu9LyOGWj6IXEgzxyah bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33q5rg8t6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3uIwW149668;
        Tue, 22 Sep 2020 03:57:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33nujmm8mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:12 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08M3vCHF019100;
        Tue, 22 Sep 2020 03:57:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:11 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: aic7xxx: Use kmemdup in two places
Date:   Mon, 21 Sep 2020 23:56:44 -0400
Message-Id: <160074695012.411.2547601275803463095.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200909185855.151964-1-alex.dewar90@gmail.com>
References: <20200909185855.151964-1-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 9 Sep 2020 19:58:55 +0100, Alex Dewar wrote:

> kmemdup can be used instead of kmalloc+memcpy. Replace two occurrences
> of this pattern.
> 
> Issue identified with Coccinelle.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: aic7xxx: Use kmemdup() in two places
      https://git.kernel.org/mkp/scsi/c/f97e6e1eabbf

-- 
Martin K. Petersen	Oracle Linux Engineering
