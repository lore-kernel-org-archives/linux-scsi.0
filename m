Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73DCFC2BB40
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 412FB2389A
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgLQGnR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:43:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgLQGnP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 01:43:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6UL0C135139;
        Thu, 17 Dec 2020 06:42:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=SIIF9YGqi1RQkg3FP8eRC5MLJVW3aqdS1KQCsPxTg1A=;
 b=C2WrjbKbtvks9PlxoI8wAOxgg/vQrdWPBqQgblC7vEQORqQUzy16tcUGAC1G/6PGikyU
 RLw577eGTFKtgaBKrkCF1QtYhnwqrL3XNQn6uKw/qDpQYb76dzENjtF9o6itYQOyj7ZU
 +tvwi1XG8t7piEt8k3vYS0TDBPj1YLw1qco+AR3Hx7doRQkCvc625qTGWRubC5c10uJo
 RD7PBs6x4+6usmRoGrb+zY9WPP4odSC7u8gL45ix6fPOedXBZTnY1VIdPS3hAitQeq0P
 5Q/QqXyqeIUMaPAszHG0cV5fzYzsZyvJKH0zapa9jpjshB+M4hMbQQ7fdTEmm+GipFZL hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35cn9rkvq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 06:42:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6VHTb143569;
        Thu, 17 Dec 2020 06:42:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35d7eqfaap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 06:42:24 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BH6gK5F006504;
        Thu, 17 Dec 2020 06:42:20 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 22:42:20 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [RFC PATCH 00/22 V3] iscsi: lock clean ups
Date:   Thu, 17 Dec 2020 00:41:50 -0600
Message-Id: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170047
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Linus's current tree cleanup the
locking in libiscsi so we again, for the main SCSI IO path, have the
frwd lock only used in the xmit/queue path and the back lock used in
the completion path and no taskqueuelock used in all the paths. The
EH paths still use both the frwd/back lock though.

These patches are still not ready for merging. I have now tested
iscsi_tcp, ib_iser, and be2iscsi. Manish tested qedi but it failed.
However, this version should work for qedi and bnx2i's normal IO
path, but there are still some questions for qedi in patch 18
"qedi: prep driver for switch to blk tags".

V3:
- Fix iscsi task double free that occurs with bnx2i and qedi.
- Use blk tagging for scsi cmd lookups.
- Rebase over patches that fixed the timeout/EH use after free
race.

V2:
- Fix issue where we used the back lock to make sure all recv
completion paths saw the window reopened falg.
- Fix ping_task path, so it accounts for send/completion race Lee
had fixed.
- Fix bug hit with qedi and bnx2i during testing where I forgot to
allow this drivers to preallocate mgmt task resources.
- Tested ib_iser and be2iscsi.


