Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CF2C433E9
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4EC964EF4
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239312AbhCCMqY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:46:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60704 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1840153AbhCBXHu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 18:07:50 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122N3Sat085251;
        Tue, 2 Mar 2021 18:07:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=gmpbvxbo4cLey2rMQ4sak+ZhmhUX5jKWeOXZGGg7iO0=;
 b=RBH7tp48YLKIH4lvfJwWYr+TRl1erRmNeX9O61g9MZbrwb7bRrY2aWA2PhHRO1vg+Szj
 CClfOrrKtPjp/izj2x5i7gppIlVDBih4eXdqVHzR6PZnpOmwsKUZtCUdzoSTFR6Ic/Oa
 8KZcvW8j/qwok0IU9gWPPN2IW9bjnGW35ZZlc0TX4Yeeva+PEFPA/rpwanLeiwq0Scmx
 ItQTHc5p44IbJL3iX1Fa750YIotAWsYGVNXBQd/6zd+Y+QNNCc9rc+lr03Lu1cjfQcF4
 RUL30hteXEowF+RtrTmfNNLy+I5XhYk/RrlJWzigSDLQxpLYoY0zf5g9MNL6GoraiXPZ Gw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371xmwrfvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 18:07:02 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122N26Qc016821;
        Tue, 2 Mar 2021 23:05:46 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 37103w6raf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 23:05:46 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122N5ihq27984372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 23:05:45 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E19586E052;
        Tue,  2 Mar 2021 23:05:44 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78AEF6E04C;
        Tue,  2 Mar 2021 23:05:44 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  2 Mar 2021 23:05:44 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v5 0/5] ibmvfc: hard reset fixes
Date:   Tue,  2 Mar 2021 17:05:38 -0600
Message-Id: <20210302230543.9905-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 adultscore=0 mlxscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020170
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series contains a minor simplification of ibmvfc_init_sub_crqs() followed
by a couple fixes for sub-CRQ handling which effect hard reset of the
client/host adapter CRQ pair.

changes in v5:
Patches 2-5: Corrected upstream commit ids for Fixes: tags

changes in v4:
Patch 2: dropped Reviewed-by tag and moved sub-crq init to after locked region
Patch 5: moved sub-crq init to after locked region

changes in v3:
* Patch 1 & 5: moved ibmvfc_init_sub_crqs out of locked patch

changes in v2:
* added Reviewed-by tags for patches 1-3
* Patch 4: use rtas_busy_delay to test rc and delay correct amount of time
* Patch 5: (new) similar fix for LPM case where CRQ pair needs re-enablement

Tyrel Datwyler (5):
  powerpc/pseries: extract host bridge from pci_bus prior to bus removal
  ibmvfc: simplify handling of sub-CRQ initialization
  ibmvfc: fix invalid sub-CRQ handles after hard reset
  ibmvfc: treat H_CLOSED as success during sub-CRQ registration
  ibmvfc: store return code of H_FREE_SUB_CRQ during cleanup

 arch/powerpc/platforms/pseries/pci_dlpar.c |  4 +-
 drivers/scsi/ibmvscsi/ibmvfc.c             | 49 ++++++++++------------
 2 files changed, 26 insertions(+), 27 deletions(-)

-- 
2.27.0

