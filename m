Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E02C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 13:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05B2261360
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 13:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbhJSNFD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 09:05:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230097AbhJSNFC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Oct 2021 09:05:02 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JCW7lC032484;
        Tue, 19 Oct 2021 09:02:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=BEYA2FHx+bxhouW//MiueuLYrq1GxGRPlQD8mwmCvuQ=;
 b=XPLZaDVQYrwC/TRJoCEkYxR8PpzGsDaAbLWAu6yMvJp/bvXPxmWheplyKYvbHUb+fvvm
 SueI00v5uWE11GJ2/7k4x2nYq2Q/oL0LPZj6lMibt9Vr64tE1LANxiE7ZMBiWKvppzqJ
 9+fix4Z9yDuBALqdlXwHHNELL8JnzMeyEEZ0/yKVp/RX07l4EthtZCSxiUMDkUMa+OPG
 QPYdZGxsVeuAKz0k6EF0cA89RsMwUke4Kb6C/w9OBnKd5K1Pm0FoLHSAYcjMVyfEAViA
 zlqEI5I9ktDlIGBrTpW+kcPzTnE9TrjA6el5ag4u97a++M0em3Q/tZ8IWylUovg2hb6j aw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bsvkg2q23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 09:02:40 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19JCvSY2022210;
        Tue, 19 Oct 2021 13:02:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3bqpc9g3cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 13:02:37 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19JD2Z9564815578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 13:02:35 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 007E35206D;
        Tue, 19 Oct 2021 13:02:35 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com.com (unknown [9.145.18.150])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6FD5C52051;
        Tue, 19 Oct 2021 13:02:34 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Nikanth Karthikesan <knikanth@suse.de>,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH] block: add documentation for inflight
Date:   Tue, 19 Oct 2021 15:02:30 +0200
Message-Id: <20211019130230.77594-1-maier@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tX2B34PwpCTHNQgorju_mtGkvDAiVnk5
X-Proofpoint-GUID: tX2B34PwpCTHNQgorju_mtGkvDAiVnk5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_01,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 clxscore=1011 malwarescore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190081
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Complements v2.6.32 commit a9327cac440b ("Seperate read and write
statistics of in_flight requests") and commit 316d315bffa4 ("block:
Seperate read and write statistics of in_flight requests v2").

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
---
 Documentation/ABI/testing/sysfs-block | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index a0ed87386639..b16b0c45a272 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -28,6 +28,22 @@ Description:
 		For more details refer Documentation/admin-guide/iostats.rst
 
 
+What:		/sys/block/<disk>/inflight
+Date:		October 2009
+Contact:	Jens Axboe <axboe@kernel.dk>, Nikanth Karthikesan <knikanth@suse.de>
+Description:
+		Reports the number of I/O requests currently in progress
+		(pending / in flight) in a device driver. This can be less
+		than the number of requests queued in the block device queue.
+		The report contains 2 fields: one for read requests
+		and one for write requests.
+		The value type is unsigned int.
+		Cf. Documentation/block/stat.rst which contains a single value for
+		requests in flight.
+		This is related to nr_requests in Documentation/block/queue-sysfs.rst
+		and for SCSI device also its queue_depth.
+
+
 What:		/sys/block/<disk>/diskseq
 Date:		February 2021
 Contact:	Matteo Croce <mcroce@microsoft.com>
-- 
2.27.0

