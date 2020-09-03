Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F0BC433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABB9A20773
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:03:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TYvN+7oV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgICDDP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 23:03:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52292 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgICDDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 23:03:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832x75D043607;
        Thu, 3 Sep 2020 03:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=DHIv540gw4Mf5lVmKtu6J6dBZp6rujPll2HYobVi+ZA=;
 b=TYvN+7oVQTVaUx13KopXoDvqJ5qszXl97wb8H4OsNd9QDHpa60AcqGxf4OakI7/W3yuo
 z5GgKg0kk2tXAsoZSd57gZGMzxy2vkQlHRr0Q/ieOyP0Umbhjc/dJZF2AWTrcF2eGxpY
 hxeGbiMTh/ImqFfuUzS116+RBorusYzjA94ofWD9EilxSQEmt+EuMaKKr8sFibxPC6rL
 E6nBDs1lUNpgB4kN5elrueMGswGrMt8pRdYHrzd6IqV8gCgiMbxqN/SAijib/UDZqngS
 EbRctTSJ7eKkOoV+Bbrd2zx5Q2lCdDNrU11UkrfpxTRKEvXq+RGhNlAMhE1HkosBeWAh 1g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 337eer67t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 03:03:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832vIcL122767;
        Thu, 3 Sep 2020 03:01:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3380x8jf22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 03:01:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 083319HU009106;
        Thu, 3 Sep 2020 03:01:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 20:01:09 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH] libfc: Fix for double freed.
Date:   Wed,  2 Sep 2020 23:01:00 -0400
Message-Id: <159910202092.23499.142074792501094831.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200825093940.19612-1-jhasan@marvell.com>
References: <20200825093940.19612-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=895 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=895 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 25 Aug 2020 02:39:40 -0700, Javed Hasan wrote:

>  -Fix added for '&fp->skb' double freed.

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: libfc: Fix for double free()
      https://git.kernel.org/mkp/scsi/c/5a5b80f98534

-- 
Martin K. Petersen	Oracle Linux Engineering
