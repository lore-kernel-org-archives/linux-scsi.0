Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF6FC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2DB1207F5
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:43:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NoVZYboF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgGBBnd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:43:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33712 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgGBBna (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 21:43:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621bSg6037913;
        Thu, 2 Jul 2020 01:43:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=WEtz0vycwnjLRrbztQ5Azf9829l7tpkmZQIWHv3V/BY=;
 b=NoVZYboFXgHyKnhrdmMGD2o0KGH5fI871oGT0SjZEcNn647A9u64eUN8JBtGW0tXmr85
 /J0INtWscx9ccnJurVpEsKugQl22glP3fhCjfPUBIYNIe1bS2wOBkqy6TrJYjHn3ESAI
 CRic2oF+FQtR1IRuwy1Erq+hvOXck5QIV50SPfNf8uFFWUAAhtPYVwGKd6UZCeZHVnal
 IrN+QQOpLUrGlt6QejYXtbxBpwDFUtuGXbUbsIOUNv4Kftr5zM+9DpIAj22eFuab7Ths
 lpB1ewLYxLM0eDPqfhIPT34v+eaI4tbALx9158TthQ5yi/dEV61i7skZZBlqjgx+zbJ/ 9Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31ywrbuwb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 01:43:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621gfVD145889;
        Thu, 2 Jul 2020 01:43:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31xfvus3fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 01:43:26 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0621hPrL022105;
        Thu, 2 Jul 2020 01:43:25 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 01:43:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, bstroesser@ts.fujitsu.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 5/7] target: fix iscsi transport id buffer setup
Date:   Wed,  1 Jul 2020 20:43:21 -0500
Message-Id: <1593654203-12442-6-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
References: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes the following bugs with the transport id setup for iscsi:

1. Incorrectly adding NULL after initiator name for TPID format 1.

2. For TPID format 1 buffer setup we are doing off+len, off++ and
then also len+=some_value. This results in the isid going past buffer
boundaries when we then do buf[off+len]

3. The pr_reg_isid is the isid in string format which is 12 bytes, but
we are only copying 6 bytes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
V2:
- Drop chunk that dropped format code.

 drivers/target/target_core_fabric_lib.c | 72 ++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 37 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 81bc8ec..428e5a1 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -136,29 +136,22 @@ static int iscsi_get_pr_transport_id(
 
 	spin_lock_irq(&se_nacl->nacl_sess_lock);
 	/*
-	 * From spc4r17 Section 7.5.4.6: TransportID for initiator
-	 * ports using SCSI over iSCSI.
+	 * Only null terminate the last field.
 	 *
-	 * The null-terminated, null-padded (see 4.4.2) ISCSI NAME field
-	 * shall contain the iSCSI name of an iSCSI initiator node (see
-	 * RFC 3720). The first ISCSI NAME field byte containing an ASCII
-	 * null character terminates the ISCSI NAME field without regard for
-	 * the specified length of the iSCSI TransportID or the contents of
-	 * the ADDITIONAL LENGTH field.
-	 */
-	len = sprintf(&buf[off], "%s", se_nacl->initiatorname);
-	/*
-	 * Add Extra byte for NULL terminator
-	 */
-	len++;
-	/*
-	 * If there is ISID present with the registration and *format code == 1
-	 * 1, use iSCSI Initiator port TransportID format.
+	 * From spc4r37 section 7.6.4.6: TransportID for initiator ports using
+	 * SCSI over iSCSI.
 	 *
-	 * Otherwise use iSCSI Initiator device TransportID format that
-	 * does not contain the ASCII encoded iSCSI Initiator iSID value
-	 * provied by the iSCSi Initiator during the iSCSI login process.
+	 * Table 507 TPID=0 Initiator device TransportID
+	 *
+	 * The null-terminated, null-padded (see 4.3.2) ISCSI NAME field shall
+	 * contain the iSCSI name of an iSCSI initiator node (see RFC 7143).
+	 * The first ISCSI NAME field byte containing an ASCII null character
+	 * terminates the ISCSI NAME field without regard for the specified
+	 * length of the iSCSI TransportID or the contents of the ADDITIONAL
+	 * LENGTH field.
 	 */
+	len = sprintf(&buf[off], "%s", se_nacl->initiatorname);
+	off += len;
 	if ((*format_code == 1) && (pr_reg->isid_present_at_reg)) {
 		/*
 		 * Set FORMAT CODE 01b for iSCSI Initiator port TransportID
@@ -166,8 +159,12 @@ static int iscsi_get_pr_transport_id(
 		 */
 		buf[0] |= 0x40;
 		/*
-		 * From spc4r17 Section 7.5.4.6: TransportID for initiator
-		 * ports using SCSI over iSCSI.  Table 390
+		 * From spc4r37 Section 7.6.4.6
+		 *
+		 * Table 508 TPID=1 Initiator port TransportID.
+		 *
+		 * The ISCSI NAME field shall not be null-terminated
+		 * (see 4.3.2) and shall not be padded.
 		 *
 		 * The SEPARATOR field shall contain the five ASCII
 		 * characters ",i,0x".
@@ -177,23 +174,24 @@ static int iscsi_get_pr_transport_id(
 		 * (see RFC 3720) in the form of ASCII characters that are the
 		 * hexadecimal digits converted from the binary iSCSI initiator
 		 * session identifier value. The first ISCSI INITIATOR SESSION
-		 * ID field byte containing an ASCII null character
+		 * ID field byte containing an ASCII null character terminates
+		 * the ISCSI INITIATOR SESSION ID field without regard for the
+		 * specified length of the iSCSI TransportID or the contents
+		 * of the ADDITIONAL LENGTH field.
 		 */
-		buf[off+len] = 0x2c; off++; /* ASCII Character: "," */
-		buf[off+len] = 0x69; off++; /* ASCII Character: "i" */
-		buf[off+len] = 0x2c; off++; /* ASCII Character: "," */
-		buf[off+len] = 0x30; off++; /* ASCII Character: "0" */
-		buf[off+len] = 0x78; off++; /* ASCII Character: "x" */
-		len += 5;
-		buf[off+len] = pr_reg->pr_reg_isid[0]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[1]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[2]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[3]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[4]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[5]; off++;
-		buf[off+len] = '\0'; off++;
-		len += 7;
+		buf[off++] = 0x2c; /* ASCII Character: "," */
+		buf[off++] = 0x69; /* ASCII Character: "i" */
+		buf[off++] = 0x2c; /* ASCII Character: "," */
+		buf[off++] = 0x30; /* ASCII Character: "0" */
+		buf[off++] = 0x78; /* ASCII Character: "x" */
+
+		memcpy(buf + off, pr_reg->pr_reg_isid, 12);
+		off += 12;
+
+		len += 17;
 	}
+	buf[off] = '\0';
+	len += 1;
 	spin_unlock_irq(&se_nacl->nacl_sess_lock);
 	/*
 	 * The ADDITIONAL LENGTH field specifies the number of bytes that follow
-- 
1.8.3.1

