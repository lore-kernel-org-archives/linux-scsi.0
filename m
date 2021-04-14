Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28F5C43617
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 17:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9791D61177
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 17:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbhDNRIo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 13:08:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233842AbhDNRIn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Apr 2021 13:08:43 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13EH2VAE163422;
        Wed, 14 Apr 2021 13:08:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding : sender;
 s=pp1; bh=9wef7EhNu925iPa213WShIPG6W+5FDUpQoWXK5i75hk=;
 b=kEXK5VX/QEwHji4LAACuWxf1eiNZjPexrnl9HAk9v6GVDWfN/lzCkWkCg/DcKIiHxIp0
 xsF39hR1AW2/ghkqf5IRAxepJI+5BuhVlzUiTxCq/92leFr3W+NKfBWCLSuN772PnZGZ
 sHImgtUyGMMHr0HBY44aPQk9mo36Pq3RroxQtQTI6xaIy8N6XyZtqP5BUI0Dk7Z9ibi+
 eO0ISllX8vN41QZ9ufSrKikhFVYSTl3k551pblCSvXZE1dh2zwr1a8fWRd2J7NEJpIpn
 hKQS0YFsvdZ9hdOe88DCWRMz93O/HlGpe+Cev/qm5U50OIMf+IEzX1vle4WdNzUZaFGc mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x0n7qrge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 13:08:10 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13EH2fo2164830;
        Wed, 14 Apr 2021 13:08:10 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x0n7qrfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 13:08:10 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13EH2YLc007946;
        Wed, 14 Apr 2021 17:08:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 37u3n8ue40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 17:08:07 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13EH84MD39387506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 17:08:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4560A4D6D;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6925A4D66;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.18.252])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lWizk-002b2n-8Z; Wed, 14 Apr 2021 19:08:04 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Sumangala Bannur Subraya <bsuma@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Yevhen Viktorov <yevhen.viktorov@virginmedia.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 0/6] zfcp: cleanups and qdio code refactor for 5.13/5.14
Date:   Wed, 14 Apr 2021 19:07:58 +0200
Message-Id: <cover.1618417667.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QSqU1CXWoBh2PpTWm0c2lRMNizFeMCiF
X-Proofpoint-ORIG-GUID: hEDcq9kCAQeJOfMkEJbvsmi_mdIOWacJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_10:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 malwarescore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James, Martin,

I know I am pretty late; we have some patches queued that I didn't come
around posting yet; its nothing world-changing, so if you don't want to
pull them for 5.13 anymore, no worries.

Most of these are cleanups, apart from the last patch from Julian. This
lifts the handling of our outbound queue from the common QDIO layer
(common for s390x, that is) to our driver. There is more details in the
patch itself. We already did the same for the inbound queue handling
some time ago.

All of these have run successfully in our internal CI for a bit already
(most for quite some time actually), and so far nothing came up. I also
retested them today with our regression suite on top of 5.12.0-rc7. So
I'm pretty confident this should work without problems.


best regards,
 - Benjamin


Julian Wiedmann (4):
  zfcp: remove unneeded INIT_LIST_HEAD() for FSF requests
  zfcp: fix sysfs roll-back on error in zfcp_adapter_enqueue()
  zfcp: clean up sysfs code for SFP diagnostics
  scsi: zfcp: lift Request Queue tasklet & timer from qdio

Qinglang Miao (1):
  scsi: zfcp: move the position of put_device

Yevhen Viktorov (1):
  zfcp: fix indentation coding style issue

 drivers/s390/scsi/zfcp_aux.c   | 28 +++++++++-----
 drivers/s390/scsi/zfcp_def.h   |  6 +--
 drivers/s390/scsi/zfcp_diag.c  | 42 ---------------------
 drivers/s390/scsi/zfcp_diag.h  |  7 ----
 drivers/s390/scsi/zfcp_ext.h   |  4 +-
 drivers/s390/scsi/zfcp_fsf.c   |  1 -
 drivers/s390/scsi/zfcp_qdio.c  | 68 ++++++++++++++++++++++++++++------
 drivers/s390/scsi/zfcp_qdio.h  |  5 +++
 drivers/s390/scsi/zfcp_sysfs.c | 14 +++++--
 drivers/s390/scsi/zfcp_unit.c  |  4 +-
 10 files changed, 97 insertions(+), 82 deletions(-)

-- 
2.30.2

