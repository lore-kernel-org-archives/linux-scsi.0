Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FCDC4CECE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D453420815
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:57:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rehVNLGb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfJAD5y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 23:57:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53630 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfJAD5y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 23:57:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x913sb61162142;
        Tue, 1 Oct 2019 03:57:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=mTtT8v0Eq1mrMxsbhFG7LnhoqwohzqjpYP4K7NENxz0=;
 b=rehVNLGbGVZDuIDQKuNJCa89y/M6bZFUyRXlsndEjHApSHJW1NBuwaeGCERyv2JAWT/g
 iZnVln9716MVM01FGMKHGfu7ZID+tVgA48EiVgblkXUAQxBN0z9viFe2tEm1t2KWIzZ/
 oMu4iinyx+HyjdNqy8fPhxqZoSotXT8glEBmaU7OmtMJ24oBGyR7rxpTPAMgihVNJL1s
 lALcHKmHxPtgPE3Fw9BZijzMQ4FoxuYlOiv7RW2Y6y9RdKahIADbVWKJkXB1Y42T+Hkx
 WNmXdLrKkP/B2tBUubJtdMLvwwxRoActj2hTIDmdE7pHdh5F09Ly9/ZU8Xj4hRnOdHnh gA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v9xxuk21b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:57:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x913mwIo005571;
        Tue, 1 Oct 2019 03:57:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vbqd03n88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:57:37 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x913vVfx008436;
        Tue, 1 Oct 2019 03:57:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 20:57:31 -0700
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, <jejb@linux.ibm.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Janek Kotas <jank@cadence.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH 0/2] scsi: ufs: Add driver for TI wrapper for Cadence UFS IP
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190918133921.25844-1-vigneshr@ti.com>
Date:   Mon, 30 Sep 2019 23:57:28 -0400
In-Reply-To: <20190918133921.25844-1-vigneshr@ti.com> (Vignesh Raghavendra's
        message of "Wed, 18 Sep 2019 19:09:19 +0530")
Message-ID: <yq14l0tw21j.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=776
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=863 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010038
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Vignesh,

> This series add DT bindings and driver for TI wrapper for Cadence UFS
> IP that is present on TI's J721e SoC

Will need some reviews from DT and ufs folks respectively before I can
queue this up.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
