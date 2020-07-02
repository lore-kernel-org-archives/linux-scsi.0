Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5372FC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 287E4207F5
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:43:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qRpwpQcD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgGBBna (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:43:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51516 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgGBBn3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 21:43:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621cuOw153886;
        Thu, 2 Jul 2020 01:43:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=Sf60kWglAVOIdJNSQSZtSpBbPeQNurDYKnqxdzAH3+Y=;
 b=qRpwpQcD9Mr/2ZVJZyY+34Uuqo0dmYrbH+6V81m5cW97WVdHGOofRzceeqRuTgtWd7oJ
 VEEzMMlDGmA+QKEwydAhp54y9LNo0Z/K1D4tAg4E4yXaDergPYG7ASdFKZf0MT4pJlbQ
 dhji+kRUNt28Ie4ogyxxWO+RVyJ+XzxTzZn+vE6WYrdBOq7/heC1PzU4WSR9bEyykWrI
 s5RV/FQQJGs+PUk7Ml7E5s8Ea7BMLF/F3Cequ8M32O0QZz+zmxMYs+aTPSCiBUicGxq1
 BsB/xOFZEZc4Mz5wbXm/DL/fXDdhZfvBASxQnXWpY0SFgro7zj9mEafmvAuhRG/H/rcJ wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31wxrndng2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 01:43:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621bqTs181538;
        Thu, 2 Jul 2020 01:43:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31xg204txp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 01:43:25 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0621hN1S010391;
        Thu, 2 Jul 2020 01:43:23 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 01:43:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, bstroesser@ts.fujitsu.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 0/7] target: misc fixes for 5.9 
Date:   Wed,  1 Jul 2020 20:43:16 -0500
Message-Id: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 5.9 queue branch. They fix
some bugs that intersect with the sysfs/configfs patchset I've been
posting

These patches are not critical so are best for 5.9 or later. They fix
the SPEC_I_PT handling and how we report the iscsi inititor transport id
which seems to have always been broken and I do not think anyone uses.
There is also a fix for a leak during target_core_mod rmmod which is
rare.

