Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C850C63777
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 06:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 095AD2468E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 06:08:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q1kTGWeJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgKQGIP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 01:08:15 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:53280 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKQGIP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2020 01:08:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH64C9V126553;
        Tue, 17 Nov 2020 06:08:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zgz9mGjjFGXC+9K5Rjw6jCZSEu9wykPvK+YXEgxlCvM=;
 b=Q1kTGWeJFOVilOOR92s0Xxxf2abwIzxQ9h8AKkMrA238h8HJNShrXQzUXKgvi+Nt7g90
 dEAMHj3PN1ZgTYOL6i1Y64h0+FsavUlukuzwTg5ETi/4RxFnXTZNfC/XgS9XtvTe1MPB
 +L5uEwnqWrnBPEbaSDAX5MrPJDv1tLgdE0FZNDAJeWUg8kVvT3Hm3HW9tF5RLWI4kJKM
 gn/TOti+q5jXDYRsZhox10RFKqh/m+OFQaTg97b+S8NZPIQRw+cfoI9FLdd1zTlQiQd1
 a48nlUSX9ICJcjwqmXRkU4SP0RRbErxJVn/MqsyUbKgeRXtsOVwK6fZCaq8p7oPvwGjV ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34t4raruby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 06:08:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH65YaE088956;
        Tue, 17 Nov 2020 06:06:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34uspsxedu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 06:06:00 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AH65xNt028347;
        Tue, 17 Nov 2020 06:05:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 22:05:58 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Avri Altman <avri.altman@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufshcd: fix missing destroy_workqueue()
Date:   Tue, 17 Nov 2020 01:05:57 -0500
Message-Id: <160557971776.26918.17217775965885412857.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110074223.41280-1-miaoqinglang@huawei.com>
References: <20201110074223.41280-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=889 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170044
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=916 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170044
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 10 Nov 2020 15:42:23 +0800, Qinglang Miao wrote:

> Add the missing destroy_workqueue() before return from
> ufshcd_init in the error handling case as well as in
> ufshcd_remove.

Applied to 5.10/scsi-fixes, thanks!

[1/1] scsi: ufshcd: Fix missing destroy_workqueue()
      https://git.kernel.org/mkp/scsi/c/2e6f11a797a2

-- 
Martin K. Petersen	Oracle Linux Engineering
