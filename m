Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D75C83013
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5158C2085B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zpUeM56E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgLAVbE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:31:04 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46718 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729347AbgLAVbD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 16:31:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LTN7a018840;
        Tue, 1 Dec 2020 21:30:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=7EgUkcoHKcec2MRQDgbuTkzcavb0i9ajumZYYK+MyDo=;
 b=zpUeM56E2dvusRAKcSjlaeX7Jc4Wvz5Ljfq26TO3a4hah62HXdHCruELgeVj8mIHCwFf
 rUtBfgKsisr/71cdtg7j+V+O66KuyJ1uzI13qv+8a3ou0LZiZN1O0jKRtyfyrgzn1L3h
 q7CXWaVSr+mwzGnt1L3crOv/dWEa5EPhNsf5zumaLsq6+IClDjxAz7XE8cmaFDJQRGEI
 7nk4xIZVbfSl7IZRBMFFdrqc0YJ8xf66m2X17yak0ws3hxdCdwsR74NGkYySVkXE//sN
 qd1q1KNsLjAof+U9M2K4eFpIYgj5LOAKEGfWKC+JVj51arOrEXAvUwP21drEwbXEVewI SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyqmy25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 21:30:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LU7oA105721;
        Tue, 1 Dec 2020 21:30:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3540eyh8tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 21:30:11 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1LU4Dg020956;
        Tue, 1 Dec 2020 21:30:09 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 13:30:04 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [RFC PATCH 00/15] libiscsi: lock clean ups
Date:   Tue,  1 Dec 2020 15:29:41 -0600
Message-Id: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Linus's current tree cleanup the
locking in libiscsi so we again, for the main IO path, have the frwd
lock only used in the xmit/queue path and the back lock used in the
completion path and no taskqueuelock. The EH paths still use both
the frwd/back lock though.

These patches are not ready for merging. I have only tested iscsi_tcp.
Also, even though the changes to the offload drivers look like minimal
API use changes, I wanted to try and get some tests done as the changes
affect the main IO and error paths.

Also, I wanted to try and track down any offload maintainers that are
still doing development on their drivers. After this batch of patches
is merged we can go one step further and remove the frwd lock from
queuecommand for at least the iscsi xmit wq based drivers by switching
to some per task locking or lllists. And if we can figure out if the
offload cards manage their own cmdsn window then we could drop the
frwd lock for them too and we could do some optimizatons with the back
lock for them.

