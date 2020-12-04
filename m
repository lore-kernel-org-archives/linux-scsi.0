Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C691BC4361B
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 07:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80D2A22597
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 07:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgLDH5b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 02:57:31 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59604 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728504AbgLDH5a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 02:57:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B47n3wj025329;
        Fri, 4 Dec 2020 07:56:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=/IkvsxgKtDG7G77mi39un+hOQiCxxrJGsS+Plwpl5C8=;
 b=skSCBoQBhbz+sP5vJHOVpVVY7f9Qoca60W7JM/28CTV/W5+lBzbPexdvyOaEoo+tieEi
 V3554Z3VO0StNv1gR1WYwRtBNXsfWz4tzMGaBEPbm4nTMBH3jNWo7zf0rGMW70m+9gvV
 RYPg++Usjsfb6f5esTD+CZ7QAT4I7OCuYvLs/8lgfN9cIfEsfrzgy79fxxedGmN9bHdp
 QEVK2HNpRXSndEnb0zC3/1bzGAZe4Anl9CSc3mwUDqktXmiUnR5VLuq7n5DkzeND40zL
 /IwUM/SP81Vdf3qRqV4gGyGPorKZMdllKf9v6kCzqqbCfTr5c4lH3TVK+wrEVXtOYeeL rA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egm1u7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 07:56:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B47oP0j083639;
        Fri, 4 Dec 2020 07:56:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3540axn8qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 07:56:45 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B47ugYP007223;
        Fri, 4 Dec 2020 07:56:44 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 23:56:42 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     sgarzare@redhat.com, stefanha@redhat.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [RFC PATCH 0/8] vhost: allow userspace to control vq cpu affinity
Date:   Fri,  4 Dec 2020 01:56:25 -0600
Message-Id: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040045
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches were made over mst's vhost branch.

The following patches, made over mst's vhost branch, allow userspace
to set each vq's cpu affinity. Currently, with cgroups the worker thread
inherits the affinity settings, but we are at the mercy of the CPU
scheduler for where the vq's IO will be executed on. This can result in
the scheduler sometimes hammering a couple queues on the host instead of
spreading it out like how the guest's app might have intended if it was
mq aware.

This version of the patches is not what you guys were talking about
initially like with the interface that was similar to nbd's old
(3.x kernel days) NBD_DO_IT ioctl where userspace calls down to the
kernel and we run from that context. These patches instead just
allow userspace to tell the kernel which CPU a vq should run on.
We then use the kernel's workqueue code to handle the thread
management.

I wanted to post this version first, because it is flexible
in that userspace can set things up so devs/vqs share threads/CPUs
and we don't have to worry about replicating a bunch of features
that the workqueue code already has like dynamic thread creation,
blocked work detection, idle thread detection and thread reaping,
and it also has an interface to control how many threads can be
created and which CPUs work can run on if we want to further restrict
that from userspace.

Note that these patches have been lightly tested. I more wanted
to get comments on the overall approach, because I know it's
not really what you were thinking about. But while I worked
on being able to share threads with multiple devices, I kept
coming back to the existing workqueue code and thinking I'll
just copy and paste that.


