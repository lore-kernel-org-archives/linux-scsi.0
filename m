Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4D8C388F7
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 23:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45A0C216FD
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Nov 2020 23:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NFV3M+9X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgKLXTk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:19:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33614 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgKLXTk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2020 18:19:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACN9sRO118600;
        Thu, 12 Nov 2020 23:19:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=zkd61/tba/h2odvP0fuyY9lA39g2B4FPo68/2n7cZQ0=;
 b=NFV3M+9XhIfMAGZwDUA+eZc3za2cVBT9z/U9iR+cXh3S++ZKGSTGipMrKeK3ACyL4k2H
 vukmoxPsuIpor1bVPxigI7Ga4xesUwnOcvOjfGsvVm9ZtOk1zxS5WDnabmQweX1L27r0
 CH/koP60dwqgV9U1pwBAnQkiZbJQA2zybkzX9SOAm/TmgdUhbWOdGkiKocVxVMJlhXOq
 /TFmaHT8+FE8yrWVmMeuyTjS7nZyUVRXMyPM1um4SzNFHhu7FRGNiWvG/h1GgS0SZ0AA
 fkDqYJZhzS/5DdmM+CZeEmEweh3oFoShItgh2xNvjxbXI3QU67RhXLaFojriaSlO9SKS NQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34nkhm83v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 23:19:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACNAH2k075845;
        Thu, 12 Nov 2020 23:19:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34rtksk4xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 23:19:21 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ACNJJwk011448;
        Thu, 12 Nov 2020 23:19:20 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 15:19:19 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq 
Date:   Thu, 12 Nov 2020 17:18:59 -0600
Message-Id: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1011 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following kernel patches were made over Michael's vhost branch:

https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost

and the vhost-scsi bug fix patchset:

https://lore.kernel.org/linux-scsi/20201112170008.GB1555653@stefanha-x1.localdomain/T/#t

And the qemu patch was made over the qemu master branch.

vhost-scsi currently supports multiple queues with the num_queues
setting, but we end up with a setup where the guest's scsi/block
layer can do a queue per vCPU and the layers below vhost can do
a queue per CPU. vhost-scsi will then do a num_queue virtqueues,
but all IO gets set on and completed on a single vhost-scsi thread.
After 2 - 4 vqs this becomes a bottleneck.

This patchset allows us to create a worker thread per IO vq, so we
can better utilize multiple CPUs with the multiple queues. It
implments Jason's suggestion to create the initial worker like
normal, then create the extra workers for IO vqs with the
VHOST_SET_VRING_ENABLE ioctl command added in this patchset.


