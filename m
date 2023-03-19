Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C3AC7618A
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Mar 2023 01:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCSB4b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Mar 2023 21:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCSB4a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Mar 2023 21:56:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7844423106;
        Sat, 18 Mar 2023 18:56:28 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32IMxwQs013262;
        Sun, 19 Mar 2023 01:56:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=RxhjsdBpZE/lJYRYkb8EdOpC1aFHuownfvQO9eeSD5k=;
 b=l5jsOH5OBSz5sg8LxN6BPxWvdK53RdRaUhhTtBBTgGDZyg/Z7wgQf+4PpZJE+P4e15Zj
 mg5NTCnDvNUO4ZeRvnylBgak1o6U0PCEBi2eDezuvPynGbtkJeAaYMeuIulz7MlSkvZh
 zIPQ/0bpQ7zGEWClxQRlbzHJhA0jzKbPD6O0FrJZClg05XtsQFKusqUwZNufGa0W1b4I
 R0ZeCLnNgnEMfW6qqKfLYeJiqtMmte57q3/KQe9E9DTOKz6wnKEi2wpTz/FoiHg7KGkc
 2mZ9nC90aO3g55x4qw4vYwhFXg7XwxjVN7Kp9ekQkkbREjv3ynb2bS7j9I2Aemz+/20O /Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd433h5hq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:26 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32INfJlb031053;
        Sun, 19 Mar 2023 01:56:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3raauba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:25 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32J1uO5E014254;
        Sun, 19 Mar 2023 01:56:25 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-118-173.vpn.oracle.com [10.154.118.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pd3raauaw-1;
        Sun, 19 Mar 2023 01:56:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH v5 0/9] target: TMF and recovery fixes
Date:   Sat, 18 Mar 2023 20:56:11 -0500
Message-Id: <20230319015620.96006-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-18_16,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=980 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303190014
X-Proofpoint-ORIG-GUID: dqkobbG25tgL1_wIWipCYtlXbEK0h2kE
X-Proofpoint-GUID: dqkobbG25tgL1_wIWipCYtlXbEK0h2kE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches apply over Martin's 6.4 branches and Linus's tree.
They fix a couple regressions in iscsit that occur when there are TMRs
executing and a connection is closed. It also includes Dimitry's fixes in
related code paths for cmd cleanup when ERL2 is used and the write pending
hang during conn cleanup.

This version of the patchset brings it back to just regressions and fixes
for bugs we have a lot of users hitting. I'm going to fix isert and get it
hooked into iscsit properly in a second patchset, because this one was
getting so large. I've also moved my cleanup type of patches for a 3rd
patchset.

v5:
- Fix
scsi: target: Fix multiple LUN_RESET handling
so we don't execute a reset before it's submited.
- Move isert changes to separate patchset.
- Add write pending fix.
v4:
- Fix
[PATCH v3 07/14] scsi: target: Fix multiple LUN_RESET handling
so it doesn't add back the bug where resets can wait on each other
and deadlock.
- Updated
[PATCH v3 06/14] scsi: target: iscsit: Fix TAS handling during conn
so it handles the case where commands have passed the STOP checks and
have not yet hit them.
- Added patch to handle another hang found while testnig where we wait
on the free_compl but never drop a ref due to being in the wrong state.
v3:
- Drop patch "iscsit: Fix isert disconnect handling during login"
- Add patch to drop cmd lock in completion callout
- Add patch to clean up recovery commands earlier when ERL2 is used
- Add patch to handle use-after-free in isert
v2:
- Fix wait/stop use during login failures
- Add patches to support isert


