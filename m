Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0431C4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65C452087D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 20:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e9NiFsTA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgJGUzY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 16:55:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43274 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbgJGUzX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 16:55:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KnSPi038239;
        Wed, 7 Oct 2020 20:55:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=5maJtZ5Qqi8YcG2Pgsbhr+lhhOjLigFAU3RBzOM0cvA=;
 b=e9NiFsTA/HRevMPXChAKjsL6jXV8+CExxg9iD54kr5tKvn9S8HDZg0KWWMfqKcNzXN4P
 KX4MDNrxTqXmsO1yioElOxMXwTLeDFvPBeuIbuqU39kingxJmDZ5Rd8CsYBhtIHx5lfn
 UccPlQDZjOuDpE0Ql/hFRbPXuMQMpcUp9oYrSu12+xz+VpEpbbJbCfTcoWWn1/pzRGF5
 C4SF0/nCmU4DcOnOfIkqETT9y6WCMa3vtWMiLkf5LA0ZNEM8j52LFkvC8V0b24YvNFKZ
 1XiY14OIDBdlmjYf8Mp+bC+oJE7UVGZ8P58BBnM4+BA+WL97gDVg+/xWD4h7/ajH5gMU pQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33xhxn475a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 20:55:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097KoDgd151578;
        Wed, 7 Oct 2020 20:55:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33y38025ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 20:55:17 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 097KtGgd009040;
        Wed, 7 Oct 2020 20:55:16 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 13:55:16 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 00/16 V2] vhost: fix scsi cmd handling and IOPs
Date:   Wed,  7 Oct 2020 15:54:45 -0500
Message-Id: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070134
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Michael's vhost branch here:
https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost
 
The patches also apply to Linus's or Martin's trees if you apply
https://patchwork.kernel.org/patch/11790681/
which was merged into mst's tree already.

The following patches are a follow up to this post:
https://patchwork.kernel.org/cover/11790763/
which originally was fixing how vhost-scsi handled cmds so we would
not get IO errors when sending more than 256 cmds.

In that patchset I needed to detect if a vq was in use and for this
patch:
https://patchwork.kernel.org/patch/11790685/
it was suggested to add support for VHOST_RING_ENABLE. While doing
that though I hit a couple problems:

1. The patches moved how vhost-scsi allocated cmds from per lio
session to per vhost vq. To support both VHOST_RING_ENABLE and
where userspace didn't support it, I would have to keep around the
old per session/device cmd allocator/completion and then also maintain
the new code. Or, I would still have to use this patch
patchwork.kernel.org/cover/11790763/ for the compat case so there
adding the new ioctl would not help much.

2. For vhost-scsi I also wanted to prevent where we allocate iovecs
for 128 vqs even though we normally use a couple. To do this, I needed
something similar to #1, but the problem is that the VHOST_RING_ENABLE
call would come too late.

To try and balance #1 and #2, these patches just allow vhost-scsi
to setup a vq when userspace starts to config it. This allows the
driver to only fully setup (we still waste some memory to support older
setups but do not have to preallocate everything like before) what
is used plus I do not need to maintain 2 code paths.

Note that in this posting I am also including additional patches
that create multiple vhost worker threads, because I wanted to see
if people felt that maybe to support that and for this enablement
issue we want a completely a new ioctl.


V2:
- fix use before set cpu var errors
- drop vhost_vq_is_setup
- include patches to do a worker thread per scsi IO vq


