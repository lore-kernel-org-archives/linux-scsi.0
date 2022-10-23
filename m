Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A21FBC04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiJWDIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiJWDHQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:07:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447CD72ED3
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:07:02 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2sTZj006519;
        Sun, 23 Oct 2022 03:04:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5VBOIbxCmCDCbH7p7/9/NxCP7ayVegHA6gbJGxtXhXA=;
 b=Cga/H7kuQZNeZoAmGC5+K3WJUFKzVRf5AucG5TaZqpNW3y9ISgOqNc3Q45OylwGnlYUw
 s/HWugz0srO8kVQK4HLo+8FMp+aRLKyw7Ys3/XWyTjlCfUKvfQBnQoeyUWp9zR0957Z6
 sK1eXwocMkjuScwMPsNXzysU+6F0DgVhuQ8+4s4wk4k1kXpivs7e8X509xVoqUKC7+pU
 GoOaQEpbsosPJ/fPDlTXl46F1Jio3PrVa7nVOn2x6gwvpObS7OLLJmnaG7PPH0c3F979
 rN1ILxwaZUAoYs4/knZZYpymw5VqTY/9p620yiKpmRNv6srdL1Rc89+4d1RztnmG3aK4 Ag== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xds4vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MLCO3B003613;
        Sun, 23 Oct 2022 03:04:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8rhpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kS0gCUlNDM5DSvC4Vn9GOyqByPndTF6UHBJyF32xahj7HK65mj1o1/3rHve5+NLAtz0iMg5g5GVrAZ4AjzYOAErISZQc5ZK2bjRmqXym74tc0SqxoN+G6plVKH6cRkp39Ou/ZbpGWx4KsqiadDugM6ZZg8HQphrGD42RX6fmyQtBs7b8NR1WoOr5m/d5q1T9zOYFXbFcNX2siKPDNs8y4rKJ+mHnzkadJKSrYG7nvfkG0YDlSHDYjAgOTNXBCR8wC7S3v5aJkHzymYENE1jMKOuCxQl3UQWpxOpo1SH1C2aAfUUiTElA4PmENid28o9Z0quoMAugYPZtWDyX14Akog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5VBOIbxCmCDCbH7p7/9/NxCP7ayVegHA6gbJGxtXhXA=;
 b=QLbYmR/9s7+HTIDTHC9TyYE3JOn9VgeCaJgvrfTNAg8WXLNoArNZeHOTlpQ+nxBJ+VATYonJz95K9ILDLo9ueR1wwxxuesbQuZNz4205+sQKrmVJyMEpCty0X3NlEIYjzAAcBScc8r/sCqh/pUa1CSf0126ZjKnEm3iV3jwgt1hX5eUpApnCM5wTpxfcGroUKA4GdeNeItnUF1UZvuUE5JOtuQrBWY3u6yvyfOFCi0nJyvPss9W7515sbJnY5qAPAzOSUdHhnrlbe2aEVopX2fzq2JY4vRhAAHBDVVCe6dwIcUJ+APag98Od53Mw4IZF+3OeFEeYvFKG0scK1LyyWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VBOIbxCmCDCbH7p7/9/NxCP7ayVegHA6gbJGxtXhXA=;
 b=utc6CZsZ8IVt0L2MUvYpVPF2h+Iusfb8Gj7pM36DMRQtks6ozmcZiAtPoYBE8pVNCNikAeNGkxBMEVkIkoAybjPi/FD/oPuylY2YkuyNzGyKGHD3W9w2ndmRr0bjjbF1Gp/Ct6tigbCH6JgzNIPeu3xg8rGoebpwtOVTsDaJS4s=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:04:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 28/35] scsi: ch: Have scsi-ml retry ch_do_scsi errors
Date:   Sat, 22 Oct 2022 22:03:56 -0500
Message-Id: <20221023030403.33845-29-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0090.namprd03.prod.outlook.com
 (2603:10b6:610:cc::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e4f8dcf-2748-40e6-1663-08dab4a35a33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4M1UxhLYGGs09Z1tsxodobHfKlUolXyHgbtxFBUhzh81FOlGojG/tknDJLIjbIw63ePFl3j4alFQ+HUzZXbaaoBJOVMDQaOTuW1QG8eM0W2BcFarAb5emRgaUnK0GrEyQrXy7gKc1i+Qs6zZRBRsFJD1O+6Y6Y4pxTuAodKKA2bwTpRaWIDUa35/w/QPhF5QODE3tsPL/crInVlJ5h2SSKpR149LdIC/uNMEIZQ7xo8FSp1zxSLWDzKoE4KorEHf5/C6pC0meYHOYITo7JwBWErHfH6hEc6ddJ1Jpyw0hJPH7DNRhJYwF8ORncOVqF4HawEpoXVVgHnoE9HnDlXBwkTu3iCCuF5ZWPXHtBY5JP9eYhuXeMug/FYNfyyHze5gLXD5rNebzNuXnJc/wvcckWy4nAo5dAednTs4cwgrHOigX1YS7YErjqq1MH8NJ+sPRUfh51ubamSv2HmKUlYlK8NZxwYAOvbYaybtJcWSJAjfBI2GFC4H8lvKyHRGiwHe/J/lfDfgGhVZViB/+adpIS7/LzQvegJerSSKBZUSCbvrINpSoj1f/a1owDwQH9pZlvXN3dP6dE5tx3Ox23qhq5kAmFn+7Oy1uAX3QJHcfL+wTLOWqnL2FtObapN8zdno/px5HugMEhuk593VGRC9QEkMxwb7fmbtyiVul22rQ+8326qRoIv40yQwoq6qAVIVISAI9lOQuam5TBI5TJXugg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?61CtyXbKSRe5fhRI2vIyQMcZmEyIIcu+ydbnQUWHj7yDujohaBEsKWqjoXjY?=
 =?us-ascii?Q?kUbrVltZ0+Ome9hdcD3rwI4pwksn8skooS44aqYHlUdyunm+lXz2SfFUI6Rz?=
 =?us-ascii?Q?rDRefkbmnZuJxkrF18QOVExeXpzxw01jt/Kpl5kQhpjFtNZMiR4kV0HOsRu5?=
 =?us-ascii?Q?qVw2dqte4G1N9YqAkWapZiOFPwdvpTvnx8UiQcfDdpGuiUPnv0mgHfXoZU2p?=
 =?us-ascii?Q?ikrVDicYfbpeLAORIsXBaDBSvTSmVrXFh8XDrTiW8BthXLm8JcLV+MRbIJjP?=
 =?us-ascii?Q?Rn0mDgN8SkzGHTZCvexjL51LubyBKP1qN2u74U1aTWxTPXfxGoyyNv5Gw2E2?=
 =?us-ascii?Q?6kwIHrj708PvbWct1Fw1kPp5tcAvSnwACF7KuHZyyZh8smJiyQl3oCAe3v3M?=
 =?us-ascii?Q?yTsiIqUt82yYe/yizwudF6bmFxMwCmVL2aAWv+EXcJ49Qtvs+NYfgNba3TKb?=
 =?us-ascii?Q?0+WK6gJfQkZi1osxBjXfVYtWsKMjhrdOre55KEQS8RogETdKkZykY8oSIFEh?=
 =?us-ascii?Q?0RLXJm93mtAzdHtF4LAV5QJUlGy5Sf0YF06wxWDILACiDqBkb2O80cYCI9By?=
 =?us-ascii?Q?CanpxZsYb5qkBxMkAxy/7HyWhLy37/RG6PMzNpDfgR+nFf34XGXawzDL3E+D?=
 =?us-ascii?Q?Qi4FkjPMJ60LGIRnA+UolX4XtgL/Ajkle2CH6bcHDz9A75tXiz4vjMnkH8X9?=
 =?us-ascii?Q?cZnO4lKyRwiNE60tDZI4Ua5sEvTGO7dvA1JHfZRJEjjDi9beIetqlKN0eu6P?=
 =?us-ascii?Q?JX40BZzsgyoDYtIhAmG4XbXvtlDl2vRzSSmVQDNgDmfOQ0d74q0TdFBs1uNl?=
 =?us-ascii?Q?ZI4W7BEM2CdGS1PSSdtIOFtrQdiMHvP2gNqCOWpMO8f/kcwujF+BnzNOEQuS?=
 =?us-ascii?Q?5y4gSXmed82Hyid9Q9yz0sRfNG1Ux0LiL8uZECE5CrgpeyTx9nV2xSjeWSKU?=
 =?us-ascii?Q?OhUgPyoxobuIMtJnZEDLJsT0YSF4qCD20+xQPLlYbH0fVcUFKLju4MOcCiS7?=
 =?us-ascii?Q?b7vGV8jWTOcTp2ow1vYQq5xHqWsCYKqfVKYDUY2tsN9VZssBYBAc+Wt/MTrn?=
 =?us-ascii?Q?1l/aPzboqIHnDGEJXg4eklQemsMAcLWN/fyiSAA7H4lFTG4U5oWEcVh7+mWg?=
 =?us-ascii?Q?ZkbmsHFRSIIax0PI1/G56Kxk++6bRZebR5/WXzkky/USsEPy9yQPlnkmjMgm?=
 =?us-ascii?Q?HCYjuBAEgpodEBeaZxQTAAzYCA7mrA75dAmDQWaGgWPNK+nrEzY2uzQFpHSB?=
 =?us-ascii?Q?uUJb+9AImUe1aF5jQZ6GWZqNkEKW3aYsm1/LB5+EJVp0jE6EaW20hiL3FD4w?=
 =?us-ascii?Q?JuKCWw0Nso9phaOm+Csj+CaHGqXXYbKMmLuBVGCqa+PaOSDYdP0nrd/K7ABu?=
 =?us-ascii?Q?0Zsagv5OChmWSBw+WL+CWwAN9hDBczdokipAjDyT8Gsl+ErqB4ohKNwezYEX?=
 =?us-ascii?Q?yGQ/5NZ6eOMAiSzDwUSX2wyD3ajlYBW16Y8caKVjVcyA6jgzNKhlp/er0SVA?=
 =?us-ascii?Q?1M3YV+eH8VN9W3G+PFL1+JUVzZd1vgulhYL4i8lJi9VsP1cs/cZ/QldmR2Vi?=
 =?us-ascii?Q?Ci/ZNZjXFeCcStn/cObOSkSVJ2jTl7Kyd11YG/MGVVffuw7c/f5XIrmu5RfW?=
 =?us-ascii?Q?yQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4f8dcf-2748-40e6-1663-08dab4a35a33
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:51.3250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +L9tX9fezMjvdhCUe80XXcXuInMjYgZmHW0T2aygbA07IgOJ91sgNQaGVtlCmVIM16qxi3AFGWc+tAtVkZ2epa+Myc47BQAAxL8aA8qujSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-GUID: R3aZx4y3gKdhbtyJw7DWRbhkipTlym1S
X-Proofpoint-ORIG-GUID: R3aZx4y3gKdhbtyJw7DWRbhkipTlym1S
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ch_do_scsi have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/ch.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 511df7a64a74..015cdc0ab575 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -113,7 +113,6 @@ typedef struct {
 	struct scsi_device  **dt;        /* ptrs to data transfer elements */
 	u_int               firsts[CH_TYPES];
 	u_int               counts[CH_TYPES];
-	u_int               unit_attention;
 	u_int		    voltags;
 	struct mutex	    lock;
 } scsi_changer;
@@ -187,13 +186,22 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	   void *buffer, unsigned buflength,
 	   enum dma_data_direction direction)
 {
-	int errno, retries = 0, timeout, result;
+	int errno, timeout, result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
 
- retry:
 	errno = 0;
 	result = scsi_exec_req(((struct scsi_exec_args) {
 					.sdev = ch->device,
@@ -203,21 +211,14 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 					.buf_len = buflength,
 					.sshdr = &sshdr,
 					.timeout = timeout * HZ,
-					.retries = MAX_RETRIES }));
+					.retries = MAX_RETRIES,
+					.failures = failures }));
 	if (result < 0)
 		return result;
 	if (scsi_sense_valid(&sshdr)) {
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
-
-		switch(sshdr.sense_key) {
-		case UNIT_ATTENTION:
-			ch->unit_attention = 1;
-			if (retries++ < 3)
-				goto retry;
-			break;
-		}
 	}
 	return errno;
 }
-- 
2.25.1

