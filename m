Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 428B7C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 19:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0446D21D81
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 19:50:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S6EQHAlQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgIJTuX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 15:50:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29244 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbgIJTta (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Sep 2020 15:49:30 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AJhCs6053099;
        Thu, 10 Sep 2020 15:49:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding : sender;
 s=pp1; bh=qDbVFJgJ+GdW0qVOLAGOfE3qlytXLeZIAagCexA2y78=;
 b=S6EQHAlQMNz8LTZTNXslGQiXNdQu0/ItyaN6ciJw/0t0ODXRCUb38snCm6bi621Bus0j
 rNmmlDPv7dFEtQCTIjvrUntUw+SttZ5swuFexq01Rs0KsoOC8YI4lxgsTeUmDPhrZXxq
 BhAVJ/nwuMCSDKPpS4xYjFMUCKRkyAG1jIgI3GgvYDx5ZAs+Rb7GaEhaNnYKvKWuyinW
 vtF/UOQurxD/UTPvF0YEE2UEJQW9n/wxr8vB2IlagTGus6Qo2X2huo7DXkohwyGF2Xh7
 RWa3QJV8wkpAynsvGtCsbjMqEG8aNQ2Anjo3SgQK1uqXsClCh/l/oP1z4X2PWBmp8jN8 8A== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fthtr52q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 15:49:23 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AJn0TM001912;
        Thu, 10 Sep 2020 19:49:21 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 33dxdr3ke7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 19:49:21 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AJnIEd24772954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 19:49:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1485CA4060;
        Thu, 10 Sep 2020 19:49:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01557A405C;
        Thu, 10 Sep 2020 19:49:18 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.32.17])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 10 Sep 2020 19:49:17 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kGSZI-00AF9y-Re; Thu, 10 Sep 2020 21:49:16 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 0/2] zfcp: small changes for 5.10
Date:   Thu, 10 Sep 2020 21:49:14 +0200
Message-Id: <cover.1599765652.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_08:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 clxscore=1011 phishscore=0 impostorscore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100173
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Martin, James,

here are some small changes for zfcp I'd like to include in 5.10 if
possible. They apply cleanly on Martin's `scsi-queue`, and James' `misc`
branches.

Both patches make the driver a bit cleaner, and hopefully easier to
maintain.

Both have been in our CI for quite a while now, running every night. I
also gave them a separate regression run just now with I/O and
error-injects such as cable pulls and other external error sources. So I
am rather confident that they don't break anything for us - apart from
that they're straight forward code changes.

As always, feedback and further reviews are appreciated :-)

Julian Wiedmann (2):
  zfcp: use list_first_entry_or_null() in zfcp_erp_thread()
  zfcp: clarify access to erp_action in zfcp_fsf_req_complete()

 drivers/s390/scsi/zfcp_erp.c |  8 +++-----
 drivers/s390/scsi/zfcp_fsf.c | 10 ++++++++--
 2 files changed, 11 insertions(+), 7 deletions(-)

-- 
2.26.2

