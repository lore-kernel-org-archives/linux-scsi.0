Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAE5C4727C
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C12523A5B
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c0KJGBjs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgIVD5v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:57:51 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42196 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728891AbgIVD5t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:49 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3nSEs149212;
        Tue, 22 Sep 2020 03:57:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=x9JRrfUcXk7KlTZmWd2ZaPFAS9WaJRk1wl5mIH8dNOk=;
 b=c0KJGBjswsvhAyT7YHgieKxaivzLPIQ6RySKTn7gnZHqbosHeLD3gX/g4OLp5ER/5G/p
 b4dVxGUnYHH04Dyj3BlHnkExTfgKz8v/IifovEBSEgIBDdFfv6hAo6D3mW01zf0wCM2y
 w+DHnukc1yM/pL5aF338d5WtTDS1CbKQvf8zEWcWR9alAJ8yhcIHTTzUlKdxLzEQU0Mw
 T7pv0xKcz/hM7XFzN0qmwPPiRAAvH3eRejgjxPKBrn7GRS2S+G2pmbuS9Crjue+neQI8
 Rr0Y3hRSxC9FbfQEIzs4qAc/JiEb/6q4OHNlUHt6fTeaHRb75wn4PARuA9yiy0Hhk4LY vA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33n7gad5t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3tLkw020862;
        Tue, 22 Sep 2020 03:57:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33nuwxk769-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:32 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vT4I032617;
        Tue, 22 Sep 2020 03:57:30 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:29 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, intel-linux-scu@intel.com,
        Jason Yan <yanaijie@huawei.com>, artur.paszkiewicz@intel.com,
        arnd@arndb.de, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: isci: make isci_host_attrs static
Date:   Mon, 21 Sep 2020 23:56:59 -0400
Message-Id: <160074695011.411.539058009142903175.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200912033741.142415-1-yanaijie@huawei.com>
References: <20200912033741.142415-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 12 Sep 2020 11:37:41 +0800, Jason Yan wrote:

> This eliminates the following sparse warning:
> 
> drivers/scsi/isci/init.c:145:25: warning: symbol 'isci_host_attrs' was
> not declared. Should it be static?

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: isci: Make isci_host_attrs static
      https://git.kernel.org/mkp/scsi/c/7867c549d574

-- 
Martin K. Petersen	Oracle Linux Engineering
