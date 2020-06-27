Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41300C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 03:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B7F920675
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 03:11:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZbTbhD9D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgF0DL1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 23:11:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38864 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgF0DL1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 23:11:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R37v6T140505;
        Sat, 27 Jun 2020 03:11:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=65tMzZGkpgU13g+QkF5YudnfqI5t4N1Mep/VGwF/5h0=;
 b=ZbTbhD9DHPaRSQIZT6hBBGeb6NE1RAN/HhaPHoF8t2AtWgAabCa0lqYai4MlQJadX4/H
 O1nRa/s7hQ+623MsvdC3igxdmAKB2im7tPeXb44/4XoVfJ7glm7HbKd7jKQglgZlUGET
 YtcgynnX88TQCm0fUXeGdA1+ySkpfQ5CiHaXb0ppQ21CwEjYoPgZ2EGoRfRvr3H4h/il
 ZlsLVNBZ8nYlWA5MvmjFMWIMoGr8ZcRA4m/s7pghDyNTBi7PF+75PIf9Y42evsL2PPlR
 OrSVrIqDN212tO9rjjYKFbLOPiYDdpjFTL94wzKZq5fyZ86rOr9HAUjSjONcnfSJspDu CQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wg3bkcgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 03:11:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R38JvH151041;
        Sat, 27 Jun 2020 03:09:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31wweh0vy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 03:09:18 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05R39Cur023857;
        Sat, 27 Jun 2020 03:09:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 03:09:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Darren Trapp <darren.trapp@cavium.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH] scsi: qla2xxx: Fix a condition in qla2x00_find_all_fabric_devs()
Date:   Fri, 26 Jun 2020 23:09:09 -0400
Message-Id: <159322725421.11274.1151779103436589073.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619143041.GD267142@mwanda>
References: <20200619143041.GD267142@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=989 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 malwarescore=0 cotscore=-2147483648 adultscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1011 mlxscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 19 Jun 2020 17:30:41 +0300, Dan Carpenter wrote:

> This code doesn't make sense unless the correct "fcport" was found.

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: Fix a condition in qla2x00_find_all_fabric_devs()
      https://git.kernel.org/mkp/scsi/c/1fc98aaf7f85

-- 
Martin K. Petersen	Oracle Linux Engineering
