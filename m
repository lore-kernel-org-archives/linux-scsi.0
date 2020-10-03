Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08021C35257
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 03:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE014206FA
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 03:27:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="icGZpAuw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgJCD1P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 23:27:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60758 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgJCD1P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 23:27:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0933QdHv011976;
        Sat, 3 Oct 2020 03:26:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Q5gCUNUwVNp18O2aAI1zS+Go2N/xwygxM1Kh8DxytVA=;
 b=icGZpAuw5+GfeKdPLVaRNCo1MSOLoh2bbRz73bBgupdJQnoofInec6jkUPKHtZeKBBM8
 kLQhxvn/3jnEbCKP7oNLVewCZwxSjcyrjIFev847fTDQwvaibB6osgt1KY/EiurbrCFN
 oV6kHYWtA0ent+Ym40IQVM8izHw1kC4j+5vKi/30wxaT32le1Iao+WsePGk58cUCzbsI
 uvN3XHsCLzH0cHQHqqfHZrXTm+Hh5qAEtWEYW3sgf9rw23lMadDO9cqEVJWJn9E1QByP
 O+B035qa4l7c6jS8uUlMXpz+7oj+ogiMn0xhEMm3o+XwqrDYZg1j6E8k+CgtqLfBebkU EQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33sx9nnj61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 03 Oct 2020 03:26:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0933Jtlf025445;
        Sat, 3 Oct 2020 03:26:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33xeds5get-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Oct 2020 03:26:38 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0933QYaB023427;
        Sat, 3 Oct 2020 03:26:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 20:26:33 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     stanley.chu@mediatek.com, cang@codeaurora.org,
        tomas.winkler@intel.com, bvanassche@acm.org, jejb@linux.ibm.com,
        asutoshd@codeaurora.org, Bean Huo <huobean@gmail.com>,
        alim.akhtar@samsung.com, avri.altman@wdc.com, beanhuo@micron.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs-exynos: use devm_platform_ioremap_resource_byname()
Date:   Fri,  2 Oct 2020 23:26:31 -0400
Message-Id: <160167976617.22934.16539006538891779539.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916084017.14086-1-huobean@gmail.com>
References: <20200916084017.14086-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030029
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 16 Sep 2020 10:40:17 +0200, Bean Huo wrote:

> Use devm_platform_ioremap_resource_byname() to simplify the code.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-exynos: Use devm_platform_ioremap_resource_byname()
      https://git.kernel.org/mkp/scsi/c/2dd39fad92a1

-- 
Martin K. Petersen	Oracle Linux Engineering
