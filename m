Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A5FC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B558821D7A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:43:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YwYfeOmh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgJMWnh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:43:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34472 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728963AbgJMWnf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:43:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMYXwe023482;
        Tue, 13 Oct 2020 22:43:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=MCij18FOUqt0qo5EwYDe2wedP2vzkbyRSkx10/FPu2A=;
 b=YwYfeOmh6BMP/EJ1vNxMvvDml/jolr6nT4qDmtk6XTemonu2k4VDlyGzSaaayGjimsHs
 hzdRirkcembjzi3Fi4aw+icUciAm5wtYol0yz6N52Gsk4mUex3UKgJPh/y+tXdfLUZRL
 ili/hdQnEUD7MB80LAmwKJsc/NUqO3zSupEi9/oYT9lvAvd9crj93AoWggQk8/ZMTJ/B
 evSgLuKiE8hD0/JHtLHsTV27ZnpY7oaOaMzK6UvXENyRpHkgV0tq+iiAr7BM1MjJem4B
 rXMIOn2K68MnjD5rPRoEw90K6lYCzNkCuqwzEvnIv5hKUIrSe3HTIK27N/afZ44H/qBt lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3434wkmr84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:43:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMZEBc155703;
        Tue, 13 Oct 2020 22:43:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 343puyjx3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09DMhMhh005844;
        Tue, 13 Oct 2020 22:43:23 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:22 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next v2] scsi: qla2xxx: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Tue, 13 Oct 2020 18:42:58 -0400
Message-Id: <160262862432.3018.1408681490032777581.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200919025202.17531-1-miaoqinglang@huawei.com>
References: <20200919025202.17531-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 19 Sep 2020 10:52:02 +0800, Qinglang Miao wrote:

> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Convert to DEFINE_SHOW_ATTRIBUTE
      https://git.kernel.org/mkp/scsi/c/5e7e6472eda9

-- 
Martin K. Petersen	Oracle Linux Engineering
