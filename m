Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D02EAC76195
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Mar 2023 02:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjCUCGg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Mar 2023 22:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCUCGf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Mar 2023 22:06:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67952305C3;
        Mon, 20 Mar 2023 19:06:32 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KM4f6v019786;
        Tue, 21 Mar 2023 02:06:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=uDozhA7V1smowI3g1F3OEZAT8u+ulxze/ZDZDIWVI7Y=;
 b=vAet4OwebMkJ2Z+dTZNSbdcdjDVRcP6pPKyd5lF5nC35XXw3hdYm2lZrPvWfNd6OESWP
 l0JN/JJuNRt1qV56q8TdR44IUhO7wA4WCdZ0iF3tGHZ4qZPoZThvbcyPp+ddN07CaZAa
 mbwTNN/bWgWZsovqMpRlO5ZwFHHjS03wPLwRI+73NBG8eSOKgkc5rB/DgLzOD/orn3px
 G3uPoJHVpASarDbsUcaYf7QI5DAhKfOYNcBN6XamijHUM3QmGY8L/jq/Xn56VdIDIQd8
 HIHd1nXleKac6g8dIibnzhsTQ4YjndArWAvmHS1RMxbeV/zBQGRIHfn3lc7STadvq0E3 MQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd3qdmxc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 02:06:28 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32KNKX3m010787;
        Tue, 21 Mar 2023 02:06:27 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-165-250.vpn.oracle.com [10.154.165.250])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3peqjn4c0v-1;
        Tue, 21 Mar 2023 02:06:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: [PATCH v2 0/7] vhost-scsi: Fix crashes and management op hangs
Date:   Mon, 20 Mar 2023 21:06:17 -0500
Message-Id: <20230321020624.13323-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_18,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=783
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210017
X-Proofpoint-GUID: zUr1oyX4b65z71HoPqIzudJD7zoLqRa1
X-Proofpoint-ORIG-GUID: zUr1oyX4b65z71HoPqIzudJD7zoLqRa1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus tree. The patches fix 3
issues:

1. If a user performs LIO LUN unmapping before the endpoint has been
cleared then we can end up trying to free a bogus tmf struct if the
TMF is still exucuting when we do the unmap.
2. If vhost_scsi_setup_vq_cmds fails we can leave the tpg->vhost_scsi
pointer set and we can end up trying to access a freed struct.
3. Management operations like LUN mapping/unmapping and device addition
hang for 30 seconds or up to N minutes depending on the device.

The problem is that we use a global mutex to protect the list of tpgs
and for accessing the tpg, and to make sure they are flushed. We then
hold that mutex during a lot of management operations. So if you
are just trying to add another device, it will have to wait on another
device if we are in the middle of clearing it's endpoint and it's
waiting on hung IO.

This patchset fixes up the ordering of how we flush IO and release
refcounts and how often the global mutex is used so we don't need to
always hold it

v2:
1. Added fix for possible use after free and merge with a locking
cleanup patch.
2. Added fix for LIO LUN unmap during TMF execution bug.
3. Fixed bug where we needed to hold the tpg mutex instead of the
vhost_scsi_mutex when calling vhost_scsi_do_plug.


