Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE55BC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 14:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99FA82080C
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 14:33:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o1+Q0KlZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733276AbgFSOdB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 10:33:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35970 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733089AbgFSOdB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 10:33:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05JEVYcK140893;
        Fri, 19 Jun 2020 14:32:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=0a0jfa6ndZYP4+GPbWa68eEdOsgS9W5sVAeMAk3I0v4=;
 b=o1+Q0KlZH3M2mRp3tG+vYQ2FJaRCyzH4TEyKGTCVngzWD/SQ5U70/YDW29uG+ZhmBtrW
 u9RW0LpiZF6vp1UhtId4T/rt5ivsqxLy9k0evoxi86YpArxqckKciyYO5QndIAxLvajV
 b/Bt377CRr7I8BO0xMwv2vUVOV9z2v0ihYzc4lKG5UbT9DhSJGBQBTD3/NwIQynH7dpo
 7nHuycfpsq60NBWavK99AtUJ9PgXuR7pkdBBpN3+cWeppam5B9UhDwogeH86Lw2g2KaY
 lWwRUuQ7UdS7lqbyOOw90ZKvrTU1y+zNub4H3DHxK/IM5HMc0RJW5PYuHPCmOo9ndK5s YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31qg35d03s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 19 Jun 2020 14:32:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05JE9P1Y111498;
        Fri, 19 Jun 2020 14:30:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31q66vm3ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jun 2020 14:30:51 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05JEUnOp008628;
        Fri, 19 Jun 2020 14:30:49 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jun 2020 07:30:48 -0700
Date:   Fri, 19 Jun 2020 17:30:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Darren Trapp <darren.trapp@cavium.com>
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: Fix a condition in
 qla2x00_find_all_fabric_devs()
Message-ID: <20200619143041.GD267142@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 clxscore=1011 malwarescore=0 impostorscore=0 adultscore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006190107
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This code doesn't make sense unless the correct "fcport" was found.

Fixes: 9dd9686b1419 ("scsi: qla2xxx: Add changes for devloss timeout in driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is from static analysis and review.  I'm not super familiar with
the code and I can't test it.  Please review it extra carefully.

 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4576d3ae9937..2436a17f5cd9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5944,7 +5944,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 			break;
 		}
 
-		if (NVME_TARGET(vha->hw, fcport)) {
+		if (found && NVME_TARGET(vha->hw, fcport)) {
 			if (fcport->disc_state == DSC_DELETE_PEND) {
 				qla2x00_set_fcport_disc_state(fcport, DSC_GNL);
 				vha->fcport_count--;
-- 
2.27.0

