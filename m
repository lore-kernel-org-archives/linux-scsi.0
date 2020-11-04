Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176C9C2D0A3
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 22:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF4F920825
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 22:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0D6DpQJ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731414AbgKDW05 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 17:26:57 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48466 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgKDW04 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 17:26:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4MPWVT178794;
        Wed, 4 Nov 2020 22:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=tTNnVnp+XdTImqrLS0WLlmWMJi1Zi9uv4dziywxFHZw=;
 b=0D6DpQJ3llVTc4DLbAkuTbzJLWEjSntmxNC42ZjQQHuv1lLAH7RvfG79RaDU0waE5/uB
 pTlVtWZ7VqffWbTX4gqMNT2JPK/sok0kDCak/Qa5WvJnp32bphz06hHU96hYJKDvNs1c
 DtO4xW0Rh9N17nAzLQYDflRbFjKfi8eam+MKPY8e+AH6Mea+GUGWNeTGtx689puOexQ7
 w2Xx8Xe7ZT1wCFCRvjzw9PS8QgFSsLmFqrZsQO8AVn1nk3QmlO/lQoA4Gr/jo3nqQjUu
 T+nVRzrtm05pltyLimtQsRuZSSfFTi5ZfhFJmII6a0XxYWlV2rmWktSMUgtLNTD4UkAG yA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34hhw2s6p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 04 Nov 2020 22:26:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4MJnVC082840;
        Wed, 4 Nov 2020 22:26:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34hvryj70u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Nov 2020 22:26:51 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A4MQohg027558;
        Wed, 4 Nov 2020 22:26:50 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 14:26:50 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 00/11 V4] vhost: vhost-scsi bug fixes
Date:   Wed,  4 Nov 2020 16:26:33 -0600
Message-Id: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040159
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Michael's vhost branch
https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost

The patches fix issues with vhost-scsi's 256 cmd limit
where if the guest sends more than 256 cmds it will get IO
errors, or even if exactly 256 are being sent then we can race and
get IO errors. The patches also add LUN RESET support so guests
that do not support resetting command timers will not get IO
errors and offlined devices when the physical device hits temp
issues.

Jason, you reviewed ever non scsi patch but 2 of them. I was not
sure if that was an oversight or you were ok with them. I'm sending
this out hoping you were ok with them and forgot to reply (or I guess
will be ok with them if you just missed them last time).

V4:
- really really fix compile errors
- dropped threading patches so we can figure that out separately.

V3:
- fix compile errors
- fix possible crash where cmd could be freed while adding it to
completion list
- fix issue where we added the worker thread to the blk cgroup but
the blk IO was submitted by a driver workqueue.

V2:
- fix use before set cpu var errors
- drop vhost_vq_is_setup
- include patches to do a worker thread per scsi IO vq


