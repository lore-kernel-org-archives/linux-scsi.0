Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8576C352BE
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 01:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B799C206D5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 01:42:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PiqH2kwK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392687AbgDOBms (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 21:42:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34722 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392682AbgDOBmq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 21:42:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F1etqq081738;
        Wed, 15 Apr 2020 01:42:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=We7twra+M/AqhTpKdnHa8XK/Ft2tmzo8bPTd18eDRG0=;
 b=PiqH2kwKHAK5+zMJGWZmGOzLKAhtQW4cQwjtRpXCccajVWzGfrLar45BrovJy4P3KPWN
 8M86eLq6hSZyrWRaUSMLeuhKIomREmwGuWe9pRrKkZuSoJZx0TkCuJbxOcJYyRrD8SRE
 n4k5qMdh6UVhoEprIpIbAl5+LpyWWwo2RvLuoqV2RmM+azjDUsOJ5DkL/jCHzfkGZXOr
 JnjVgyghWDnHES6itDeu31djun7a6QAkw1SAIk8aQio4I4DjBpErFtK9b5ibfe05wqpM
 tzd1RU0iRCutk5bj1cm5InD6qhLrzP8PlWxVAXrCtAH9EG0Wr6/aQUx2JDWvD/h+YlId vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30dn9t8kvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 01:42:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F1g0RB049942;
        Wed, 15 Apr 2020 01:42:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30dn9a1xy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 01:42:37 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03F1gZk7022584;
        Wed, 15 Apr 2020 01:42:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Apr 2020 18:42:35 -0700
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <mdr@sgi.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla1280: make qla1280_firmware_mutex and qla1280_fw_tbl static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200409084910.44336-1-yanaijie@huawei.com>
Date:   Tue, 14 Apr 2020 21:42:33 -0400
In-Reply-To: <20200409084910.44336-1-yanaijie@huawei.com> (Jason Yan's message
        of "Thu, 9 Apr 2020 16:49:10 +0800")
Message-ID: <yq14ktlr0c6.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004150009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> Fix the following sparse warning:
>
> drivers/scsi/qla1280.c:529:1: warning: symbol 'qla1280_firmware_mutex'
> was not declared. Should it be static?
> drivers/scsi/qla1280.c:538:15: warning: symbol 'qla1280_fw_tbl' was not
> declared. Should it be static?

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
