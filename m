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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D28C388F7
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 05:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7316020781
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 05:33:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MlnoUwvE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbgKJFdi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 00:33:38 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51880 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgKJFdh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 00:33:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AA5JvPB151746;
        Tue, 10 Nov 2020 05:33:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=RudefRIfjbrIQVssdj3F5GRYZClE91ePmAVjyOIr8+0=;
 b=MlnoUwvEenGS31EjMt9ZUZji4WN1cNBbvp4EOPTi8YdAaoyGF+E4AYvQGbsl3duVWcE8
 G3BXTMgtsOMvrsXx0DyqE/xkqOAyAdr8/zjtXX0Od7P8540Vji1Wznzo90OCaXbqRboT
 FR7Evo/+8F3XFftxIcOrn3kHpd9+I5NWTi34oIXLNCnRbrhTzHRnqKYERp5QsWIBHEK5
 1bi3JSSqW7Hk4jQp9OXp3LjoL7Eb9AZ0+ckQYKZM0ABliqgtB/91SUY490rsiwLyU7kS
 JmN3FGd4ZdqZ9EmASCYJuyTAs2oZE3xqMuK677rjOyNkcNF+z1/inohN5G6jRKpRHp1G Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34nh3asuaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 05:33:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AA5Eoam125454;
        Tue, 10 Nov 2020 05:33:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34p5fyqrjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 05:33:32 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AA5XUZK027233;
        Tue, 10 Nov 2020 05:33:30 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 21:33:30 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Subject: [PATCH 0/5 V5] vhost-scsi: IO error fixups
Date:   Mon,  9 Nov 2020 23:33:18 -0600
Message-Id: <1604986403-4931-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100037
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Michael's vhost branch:

https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost

They fixe a couple issues where the guest is getting IO errors:
1. The admin may set num_queues and cmd_per_lun/virtqueue_size
in a way that allows the guest to send more IO that vhost-scsi
was coded for.

2. A race where vhost-scsi completes the cmd to the guest before
it's fully completed in the target/vhost-scsi layers so if the
guest sends a new IO too quicky we fail it.

3. If the real/physical storage (lio backend device) hits a transient
error then vhost-scsi would fail commands instead of relying on
the lower levels error recovery to do what the admin had set up.

V5:
- Bring back V1 but move flush patches to a separate clean up set
- Modify test in vhost_vq_is_setup

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


