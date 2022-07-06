Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A575DC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 16:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbiGFQAA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 12:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiGFP76 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 11:59:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7680220F4;
        Wed,  6 Jul 2022 08:59:54 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266Eodaa008359;
        Wed, 6 Jul 2022 15:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding : sender;
 s=pp1; bh=v/Y26GgveLsFvEWSO2N9c+SHM8FAT1jXHDpq+NuHPZg=;
 b=S1M+gxzs/cvXZQQYGtr9zuETXWto4ZRXm/Dn6sLXOTsdxWUwtDXcWK6g29y9B/IEF7q7
 f8BVJVgwhyustUynHh7yqCqtAj97xU6VbP2u/K5rcUf0IcvI77cDFX4vn8OaDyHSR3YJ
 kpwG8PwD5iH1T6C5i0WNZRxzjEj3PuaBgKHdWWe4ZHF6bLHpoLUGi/MQ7iRErdX3A7R0
 xgtQqvTSZVC1R+2+xgiF2HuTaFzxK2I36YHira2esqArR41Hz/yZ9/ZkSrk3wrBoJC3z
 UMSkml9PSkl0+6nexR03W1JURVfhV86wbT512uCqci8nrCR1jokldIQYky5QkC1+rcPR ag== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5as4davg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 15:59:46 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 266FqStj026006;
        Wed, 6 Jul 2022 15:59:44 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3h4ukw0ytr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 15:59:44 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 266FxoPU16056698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Jul 2022 15:59:50 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6766952050;
        Wed,  6 Jul 2022 15:59:41 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.72.132])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 53E185204F;
        Wed,  6 Jul 2022 15:59:41 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.95)
        (envelope-from <bblock@linux.ibm.com>)
        id 1o97RE-005M3p-V6;
        Wed, 06 Jul 2022 17:59:40 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Steffen Maier" <maier@linux.ibm.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        "Fedor Loshakov" <loshakov@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev" <agordeev@linux.ibm.com>,
        "Jiang Jian" <jiangjian@cdjrlc.com>, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 0/2] zfcp changes for v5.20
Date:   Wed,  6 Jul 2022 17:59:38 +0200
Message-Id: <cover.1657122360.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung David Faller, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294, https://www.ibm.com/privacy
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IeNuG14OzvO7F57PIDchsQlrgldA7S5A
X-Proofpoint-ORIG-GUID: IeNuG14OzvO7F57PIDchsQlrgldA7S5A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxlogscore=730 lowpriorityscore=0
 bulkscore=0 clxscore=1011 priorityscore=1501 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207060062
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James, Martin,

here is a (very) small set of changes for the zFCP device driver. The
change from Jiang Jian came in recently, and Julian's patch has been
laying around for quite a while now, so I didn't want to let them linger
any longer in anticipation of any bigger change that might come.

It would be nice, if you could include them for v5.20.

Jiang Jian (1):
  scsi: zfcp: drop unexpected word "the" in the comments

Julian Wiedmann (1):
  scsi: zfcp: declare zfcp_sdev_attrs as static

 drivers/s390/scsi/zfcp_diag.h  | 2 +-
 drivers/s390/scsi/zfcp_sysfs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.36.1

