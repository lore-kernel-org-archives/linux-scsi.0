Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E137C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B41A23A5A
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732164AbgLIRYd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:24:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60296 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731346AbgLIRYV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:24:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HJWlv111588;
        Wed, 9 Dec 2020 17:23:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=VnN6soBlGi/0SCbEGBCIPTtcbq0lk8ftwSQHlFY9W2c=;
 b=bdiS+b4cqUlD4wyfQqnFY5YvZBEbEoh/ZZGJ6+URhC8NQhdy+bg2hFbd8/VJ+ih+D1Qt
 oDbydpYRZrTKIhgfrMl/XVE/mWsOM03iQ45AP0mcQ2WPhvS2keZ/XyL69of7Fg2j/rqp
 YlD7KtUIEPNkhxX9d0ul0KeUpOtVGNWMoBSoh0juoUzWFP7tSQooq2Rb6ueuV/7xqK+E
 bKnqy2qLzU4ZJe7KVlTZuaFpUQY8u9et3z0hodsV+560nJgV7Ba5xm8aVLVIua8BgmWK
 necrH5Bs2Q+6m83Uuca2cPcARWI+o5fJ2BarwULvLZ9TivGIZuqk/4prfolcHtHhHcMF hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35825m9ct1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 17:23:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HKjkd142185;
        Wed, 9 Dec 2020 17:23:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 358kyv0gr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 17:23:33 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B9HNWs7022582;
        Wed, 9 Dec 2020 17:23:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 09:23:32 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Colin King <colin.king@canonical.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: remove redundant assignment to variable rval
Date:   Wed,  9 Dec 2020 12:23:16 -0500
Message-Id: <160753457756.14816.15596316150027507404.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201204191810.1150995-1-colin.king@canonical.com>
References: <20201204191810.1150995-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 4 Dec 2020 19:18:10 +0000, Colin King wrote:

> The variable rval is being initialized with a value that is never read
> and it is being updated later with a new value.  The initialization is
> redundant and can be removed.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: qla4xxx: remove redundant assignment to variable rval
      https://git.kernel.org/mkp/scsi/c/3a5b9fa2cc5f

-- 
Martin K. Petersen	Oracle Linux Engineering
