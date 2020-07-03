Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F74C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 13:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17DDE20936
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 13:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgGCNVG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 09:21:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47414 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726382AbgGCNVG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 09:21:06 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063D3TBb120040;
        Fri, 3 Jul 2020 09:21:01 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32121rd9um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 09:21:01 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 063DJPSp013738;
        Fri, 3 Jul 2020 13:20:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3217b01qaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 13:20:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 063DJZ8O36897112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 13:19:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96D1BA4062;
        Fri,  3 Jul 2020 13:20:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FCD0A4060;
        Fri,  3 Jul 2020 13:20:55 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.150.95])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  3 Jul 2020 13:20:55 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jrLcc-005ou7-8i; Fri, 03 Jul 2020 15:20:54 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        George Spelvin <lkml@sdf.org>, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH 0/7] zfcp: cleanups and small changes for 5.9
Date:   Fri,  3 Jul 2020 15:19:56 +0200
Message-Id: <cover.1593780621.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_09:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 cotscore=-2147483648 mlxscore=0
 malwarescore=0 clxscore=1011 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 suspectscore=2 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030090
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Martin, James, Jonathan,

here are some cleanups and small changes for zfcp I'd like to include in
5.9 if possible.

One of the changes touches documentation in `Documentation/scsi/`, so I
put Jonathan on To, hope that was correct. I hope you can still pull
this all in one go to minimize work. IBM did retire some old URLs and
content from our public website, so we have to clean that up in the
documentation so there are not dead links. I changed these in the hopes
we can minimize documentation churn going forward, just to replace URLs.

The other changes are mostly small cleanups for our driver that make at
least parts more sane than they've been.

Most of these have been in our CI for quite a while now - shame on me
for delaying sending them upstream so long -, so I am rather confident
that they don't break anything for us.

As always, feedback and reviews are appreciated :-)

Benjamin Block (2):
  scsi: docs: update outdated link to IBM developerworks
  scsi: docs: remove invalid link and update text for zfcp kernel config

George Spelvin (1):
  zfcp: use prandom_u32_max() for backoff

Julian Wiedmann (4):
  zfcp: fix an outdated comment for zfcp_qdio_send()
  zfcp: clean up zfcp_erp_action_ready()
  zfcp: replace open-coded list move
  zfcp: avoid benign overflow of the Request Queue's free-level

 Documentation/scsi/scsi-parameters.rst |  2 +-
 drivers/s390/scsi/zfcp_ccw.c           |  7 +++----
 drivers/s390/scsi/zfcp_erp.c           |  2 +-
 drivers/s390/scsi/zfcp_fc.c            |  2 +-
 drivers/s390/scsi/zfcp_qdio.c          |  7 +++++--
 drivers/scsi/Kconfig                   | 15 ++++++++++-----
 6 files changed, 21 insertions(+), 14 deletions(-)

-- 
2.26.2

