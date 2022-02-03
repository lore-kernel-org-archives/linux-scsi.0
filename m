Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92A4C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 06:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242445AbiBCGk1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 01:40:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18216 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231539AbiBCGk0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 01:40:26 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21323otJ005603
        for <linux-scsi@vger.kernel.org>; Wed, 2 Feb 2022 22:40:26 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dyutd5d9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Feb 2022 22:40:26 -0800
Received: from twshared9880.08.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Feb 2022 22:40:24 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id D711F2947D5CA; Wed,  2 Feb 2022 22:40:16 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <linx-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>
CC:     <kernel-team@fb.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <axboe@kernel.dk>,
        Song Liu <song@kernel.org>
Subject: [PATCH 0/2] block: scsi: introduce and use BLK_STS_OFFLINE
Date:   Wed, 2 Feb 2022 22:40:07 -0800
Message-ID: <20220203064009.1795344-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: WiaH14nEhkDkyM34mVR9YWGNo06mUnaE
X-Proofpoint-ORIG-GUID: WiaH14nEhkDkyM34mVR9YWGNo06mUnaE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_01,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 mlxlogscore=518 impostorscore=0 mlxscore=0 bulkscore=0 clxscore=1011
 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030038
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have a use case where HDDs are regularly power on/off to perserve power.
When a drive is being removed, we often see errors like

   [  172.803279] I/O error, dev sda, sector 3137184

These messages are confusing for automations that grep dmesg, as they look
very similar to real HDD error.

Solve this issue with a new block state BLK_STS_OFFLINE. After the change,
the error message looks like

   [  172.803279] device offline error, dev sda, sector 3137184

so that the automations won't confuse them with real I/O error.

Song Liu (2):
  block: introduce BLK_STS_OFFLINE
  scsi: use BLK_STS_OFFLINE for not fully online devices

 block/blk-core.c          | 1 +
 drivers/scsi/scsi_lib.c   | 2 +-
 include/linux/blk_types.h | 7 +++++++
 3 files changed, 9 insertions(+), 1 deletion(-)

--
2.30.2
