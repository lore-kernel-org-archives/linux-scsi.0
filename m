Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEC8C4361B
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF34E2310B
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391814AbgLMDMB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 22:12:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33722 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391366AbgLMDLu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2020 22:11:50 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD34sX4176477;
        Sun, 13 Dec 2020 03:10:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=7nDMjDNV9fpMEfTyH+z4MxJjnrlyz+4MuWonsyzOW2w=;
 b=g0+qiq0lKxwHMbf5Rf1azZc0r8Fmgr0dJh4h/Bk5onjTJhHZryCjMdJN+3hvQRd8PCFv
 kH6dGApJPnNtobQxyQZrPIXdWZ9DdxvSdn6LEhM720uwnwVNxO4V+h2bOEys8/2Txcb6
 UQi6hig+grNlWjBsmICA+rUDbE/gXgDPhS0Pz3O7cnkvvXwal+jhnKuOUJ9YU7NWiQpC
 ZT517PY8VkOuABGtM3YdBgB6qrKQlnTv20TOHF4Mcu9qOOJCxuPVnEF3DyZIOM8au/xQ
 DnrhSms7VuPTqHs0iDdxZl1KVpFh5AtlUJPyBwVL4NAeTMf12of+YTULm31sji4Af2aD YQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcb1pka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Dec 2020 03:10:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD351aM107909;
        Sun, 13 Dec 2020 03:08:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35d7ejakg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 03:08:59 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BD38uDm013810;
        Sun, 13 Dec 2020 03:08:56 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Dec 2020 19:08:56 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [RFC PATCH 00/18] iscsi lock/xmit/recv cleanups
Date:   Sat, 12 Dec 2020 21:08:28 -0600
Message-Id: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012130023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012130023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Linus's current tree cleanup the
locking in libiscsi so we again, for the main IO path, have the frwd
lock only used in the xmit/queue path and the back lock used in the
completion path and no taskqueuelock. The EH paths still use both
the frwd/back lock though.

These patches are still not ready for merging. I have now tested
iscsi_tcp, ib_iser, and be2iscsi. Manish tested qedi but it failed.
However, this version should work for qedi and bnx2i. I had forgot to
convert one of the mgmt task paths those drivers use.

V2:
- Fix issue where we used the back lock to make sure all recv
completion paths saw the window reopened flag.
- Fix ping_task path, so it accounts for send/completion race Lee
had fixed.
- Fix bug hit with qedi and bnx2i during testing where I forgot to
allow this drivers to preallocate mgmt task resources.
- Tested ib_iser and be2iscsi.


