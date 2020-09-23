Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EF9C4727E
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 00:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 830DF221E8
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 00:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y1BcM9Nc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgIWAaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 20:30:18 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48280 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgIWAaR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 20:30:17 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08N0TlIr162312;
        Wed, 23 Sep 2020 00:29:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=PEFV58UGy2QfwixXMWPDSa2Z2Nxo9LcgkAGEPp0JT9s=;
 b=Y1BcM9Ncp5O7V1nFGXx3O2xRdwfGuJ0hZQHkXa/cFNfNhLKgyqTfOwdvr/AqSJcFs0Sy
 DOjs7kp7lK9BlAGHWRBKQt3de7KssWDX27bXpUt4cdz3Y9lDgrMN9A7hd6A0AyIa/7e4
 0Aeibd2U61sR+J28Wn/E3p7ndJ6s9h2beztH9mVN1YUCAF9UhMpLhJAhl/xmpeuZ6w/q
 cB5Rs9meMlZpoZxNqRfr5fBjsxXCZlCcuJz7KmLyykL5VwjU4SfNAnFdp2CjO8JjGwP0
 S+RQ3zPJ4xhjP8il25iYrpV3I9Qwb6KJj1f2jAuhi/VYo/LA73PyF8SeN5/1FNSlxYKC aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33qcptvmsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 00:29:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08N0QY2w163057;
        Wed, 23 Sep 2020 00:29:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33nujnwetc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 00:29:46 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08N0Tifn030627;
        Wed, 23 Sep 2020 00:29:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 17:29:43 -0700
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     <fthain@telegraphics.com.au>, <schmitzmic@gmail.com>,
        <linux@armlinux.org.uk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: remove redundant initialization of variable ret
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eemtnxn7.fsf@ca-mkp.ca.oracle.com>
References: <20200918090747.44645-1-jingxiangfeng@huawei.com>
Date:   Tue, 22 Sep 2020 20:29:41 -0400
In-Reply-To: <20200918090747.44645-1-jingxiangfeng@huawei.com> (Jing
        Xiangfeng's message of "Fri, 18 Sep 2020 17:07:47 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1011 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230000
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jing,

> The variable ret is being initialized with '-ENOMEM' that is
> meaningless. So remove it.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
