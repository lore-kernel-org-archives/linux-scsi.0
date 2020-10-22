Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC02C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6FAE22249
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 00:35:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q7bfWFgG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507545AbgJVAfQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 20:35:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43236 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507540AbgJVAfQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 20:35:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0SlLW075809;
        Thu, 22 Oct 2020 00:35:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=xZO6sXSUGrbotVqe6sTF20rhHgGPdjRsDlJ9hEpE8yc=;
 b=Q7bfWFgGayE+oquvWccKfJP0HMAFXbLQxY09eSszxik+GePuKNhrvKOWtqADac/Tj3az
 ZkPuCwFze1mXHlrM7MbeKfnHj9x8FqbXoc2rXoIsbZtnAXIoqB4olRp0aJ1GGpwMFcqn
 HE0M5C87sLA3XC1ts80foBzirvaCpjpVffU9QszzpfNL3YaBHxcCKkgSM3rjGJBypEMt
 6Pp0XM00vGG3coZKZ7lzDa3ynsyjTPqrhHAQG+Z7N375d7FsTL8JPfMgxnYQwh903bWh
 1SSFZEFKT/qL9BUgtUWDjcLym2NVekm9o4HT3HS8bln5N4GbDHeQneSFHcsLpgtJcO8M 8w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 349jrpufsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 00:35:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M0TepE186110;
        Thu, 22 Oct 2020 00:35:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 348ah090yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 00:35:11 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09M0ZAFw029939;
        Thu, 22 Oct 2020 00:35:11 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 17:35:10 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 00/17 V3] vhost: fix scsi cmd handling and cgroup support
Date:   Wed, 21 Oct 2020 19:34:46 -0500
Message-Id: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In-Reply-To: 

The following patches were made over Michael's vhost branch here:

https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost

They fix a couple issues with vhost-scsi when we hit the 256 cmd limit
that result in the guest getting IO errors, add LUN reset support so
devices are not offlined during transient errors, allow us to manage
vhost scsi IO with cgroups, and imrpove IOPs up to 2X.

The following patches are a follow up to this post:
https://patchwork.kernel.org/project/target-devel/cover/1600712588-9514-1-git-send-email-michael.christie@oracle.com/
which originally was fixing how vhost-scsi handled cmds so we would
not get IO errors when sending more than 256 cmds.

In that patchset I needed to detect if a vq was in use and for this
patch:
https://patchwork.kernel.org/project/target-devel/patch/1600712588-9514-3-git-send-email-michael.christie@oracle.com/
It was suggested to add support for VHOST_RING_ENABLE. While doing
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


