Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D10CC64E7A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4207520866
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C5WaOft0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgKXD6T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:58:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36268 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbgKXD6S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:58:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3tiwW078846;
        Tue, 24 Nov 2020 03:58:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=UT1q0ssjr3ASFBM7Q8x9Xmg4gFYhYnL1VbvfVxfMkx4=;
 b=C5WaOft0oQUomsIrVXh6cBW8UqeAkux1AaCNbOfrCfKsXbv5prH1yt/I8mtqPeTwJ3zc
 kdiTG6KVlEHBLxkf5lLQxKybKezFFCYyig6n2E9Lav/S08emEMiEJwpcVh6bD68f0QJs
 iKpHavyiFeSKsTLq9JlaKjNfzLbABwTMZZRqdWPyoilY66ELQM8brBNSmNEWkBuygTxd
 V+9ZOwordu/TXKys21X6rjHJUJ1eQPjK9jMYnPsNIYu994UEaRr7pZhrGR4vU9Wjx84v
 jLzK0ybt+wL8E5ogQBauWirzMmDRhcqUGaPCzoJ5z4Fh75v8+tFB1G/WhYNAwLa0TaJz lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 34xtaqkyks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:58:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3toB2080899;
        Tue, 24 Nov 2020 03:58:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34ycnrvyy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:58:12 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AO3wBZ5009620;
        Tue, 24 Nov 2020 03:58:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:58:11 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][next] scsi: lpfc: fix pointer defereference before it is null checked issue
Date:   Mon, 23 Nov 2020 22:58:00 -0500
Message-Id: <160618683552.24173.13742714512709142456.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118131345.460631-1-colin.king@canonical.com>
References: <20201118131345.460631-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 18 Nov 2020 13:13:45 +0000, Colin King wrote:

> There is a null check on pointer lpfc_cmd after the pointer has been
> dereferenced when pointers rdata and ndlp are initialized at the start
> of the function. Fix this by only assigning rdata and ndlp after the
> pointer lpfc_cmd has been null checked.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix pointer defereference before it is null checked issue
      https://git.kernel.org/mkp/scsi/c/1e7dddb2e76a

-- 
Martin K. Petersen	Oracle Linux Engineering
