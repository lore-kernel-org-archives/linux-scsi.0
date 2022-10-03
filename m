Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B91CFC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiJCRzj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiJCRy4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3533F30E
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:54:16 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOC62029461;
        Mon, 3 Oct 2022 17:54:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5VBOIbxCmCDCbH7p7/9/NxCP7ayVegHA6gbJGxtXhXA=;
 b=slKCx03cm5J8ReId3fYf4lpk0FmXNBoFBsPexcXxQAFtDWv6NJo9gM3bFtNlcqvkSNBT
 e58vmPSijBpAwJ98q/Wen9q1Kq2t1+/abwszcslHEq6u5mcbdvBDvKMpHiVhXbMXRchz
 onx6bI7Svg389XjvcISko984ONHz/VkHE95yTttgNfvW4YZOw8oeGWibmSIDh4CK/sCf
 xALePpNW3zn1KgunZiY76bBHCUYEnQ1N2nwC0+8e35iqvrMFM59QPoUzLLYtnE6CsyTL
 ObyEqLXdBn8/J9R2gm0OK5PbkGU+LfgaC2aIqxGVnv3M23YqW2OzQ8aphFkRXLFVMrgp Zw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxd5tc939-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FOpPp008261;
        Mon, 3 Oct 2022 17:54:08 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03q65n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDt1mRV7apm5W5+HR3Jby0omkN4ZJgDvtrda+7qcb/tMwVkHzthadGRPmw42B+aHGlmAYZQdj6MAZWDiKWSakEvcegjHhmGOkMNHLGI2NIMUO61KpaR8FbygIlEA2G4qYaYjOZ/WUVoNBOriaxLVLdtXIl9PGzxaA+u5jmWu+hW4ZC79t65Tuuj1VT8PDEN3JQwKH69adiyIr7j4NH1t2VtOQuu0g8fykF+CoqeqIInxK3v9HweGaw1PSKfYo1MTza7SlSeKrNz+0Jmha2B6RqsuJHmmmdb9Pfq+OifxzNVfRKkF/AZoGxoZYM2TLiKeMHncO7JsdTQu7LyZrN+6xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5VBOIbxCmCDCbH7p7/9/NxCP7ayVegHA6gbJGxtXhXA=;
 b=K19vVUNiOUfTxonnvCuOATMjFwA3qV1V37V8VjliHU7wHQCdffqrQAZbE17eZ7coLPvf7eJjxMDO3g8O6/0TN7ZnIBI2gmTxCRQ3fzFclUUffw30vWLRu+LGF1sh1+GJE3lXaeYOqCJRPq3XvZx90Shg9qzQ8V5CgWsgF75UsEji0kDgWVmi019o39LX27oxinP0xseqPjpTzoPsuYdK6Vols6xIPR+WxRW3+IDZ4CK2ZKQfBKTOgGZLKR5pUAak/8pbVX76D0752wxyBTkHvc3/YrDbCk+UKgkYv1Pu9Eveua2upZxAL5aHIJ+veyG+b5+v9OCC8r17ZUlorPf1lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VBOIbxCmCDCbH7p7/9/NxCP7ayVegHA6gbJGxtXhXA=;
 b=OjRxYjD8iPP34e70F/wB4mmozVd+ZdO9GLh0dGlkd3xQEqEedqDjaid1yl0rOpj4QXt4ylpcJMMUlLIEtn2xE12Vx68L1KX04kOegVzlZt409dNNdlgp8O1vTgboIdX9X35zYmIgo1gb2EMutVXz3IuwD0YPzfAXlG0G5kf4ULQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:54:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:54:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 28/35] scsi: ch: Have scsi-ml retry ch_do_scsi errors
Date:   Mon,  3 Oct 2022 12:53:14 -0500
Message-Id: <20221003175321.8040-29-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0050.namprd18.prod.outlook.com
 (2603:10b6:610:55::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b897228-b1da-4c52-b260-08daa56843bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QcoRYQdKmujcdfAX8exH0yV1jLU8sJiPiwj5KxYI30ABdelZyBxmcT8F5SEjTOq9Vhroo9xbKLmxk+SjxR/8t2eR8OLE//tAleH4UTVGLZYFGuQcPJg+YKWKE1BAGOqmJSqkS1bzCbXgJZZF8iY2Jpy39IT2KBVD+0zlkwhKziqCPeKtsfEJBu50ovqQzDl/ad7hYgvm2eX7Spe9Q3koo4Me4OtH0T/CD2fsTgk36D67XKl6mrqGGBzJAEnB66lLHs01VfETtqae2YScccxmgc8PTpmkL281T+4AW0qz+4iNcM743+G7mOgwu5Su4KyZyGahnncZB5AoKhsuEQaDAtwec7JaFbac5FHVLYHF13fccQBGRhHghbq6QKz1yVkAlfEm9NR+NyP1kYLbiDe9E/zhE9AQdqF8fLgUAJy9XXb+p++efY4W7aV0ZE+V/lK2zDad3AueXh2Av6NK2P5wDRHZY9HAOUMtHxcwsDr9P3qJXHVhpZM9gAtEm2J7BKmafngFaByek0CHhuX3WCLiOfz6aVzeVecdZhFjrdXuV7T6YCHPF2MC1ObhzaAZPhsTs2hoGzADa/bHChRuc36fgCf+1Rqqt1zhrVrdfRgLySdLkX5iZTflEnoTwLb7NHFVFuvpZs2oZ1wfpnu9QvVR5ip1Opz/mEM+qrONb6ogSK475BckZaT6P66dhHQlWzqaRpEwb+dVZhtShi2zKvqPvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(83380400001)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(6666004)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ADYP6zSvPdvgkyu/eNsZnWnZW1oowd7P079e7j/tURzp8QwwrN200mfdSecl?=
 =?us-ascii?Q?d++QH4WceTdNGPKrxIVL/hYsHwQYZrPHd2gYRDuuDiPhcG9MWraSRGeVcbbn?=
 =?us-ascii?Q?w4jzk7Dp2Zdfa5a/OF5GLoEgL0ToBDAo4coUIQolGHeHPHGS2zOQNqxBk21G?=
 =?us-ascii?Q?obTj+jwRifvUp6CSsbAguH/UAWM9rvif3Oz446j+6QLzmMTWozM/Phzu2+e+?=
 =?us-ascii?Q?bJEVLHEwTP7VLhtF150HPb++GH3WtLQqdoMlyAb6cjDBczu+I2ZmM0DLJNW7?=
 =?us-ascii?Q?wEARj96w0xu+KQIeuIBlnXgArfWET3Imq37KcT1smZQp/MHSfjtPOG4NYZ2K?=
 =?us-ascii?Q?XLW7eMnjWBM7vgWKp+VaTbZgD0bkn2XFE9wpEA5bF/XiBjmHU6hEHpBuPCOq?=
 =?us-ascii?Q?qT57XKhbvvx5xXpWExGcK7pEcpukz92K1/jGGJUA7OfLDsFfRdIwlWKGy6PQ?=
 =?us-ascii?Q?hh6z02t2enj7SXxs6JcTDRoPZSWzsgaQTKGTtQmK9b+x8bEjemRuy93KHEtw?=
 =?us-ascii?Q?V0JwRuTCTTd9/UdtUbg/SquN+qpwS84rrn5qQUSkVL1uxu48DFzjAEA7rA9s?=
 =?us-ascii?Q?SL9jS0xw1du2OrL9AmoOKaVau/73iZO1FtxflceL54XPp0l8s54ptreSV9sF?=
 =?us-ascii?Q?U/KFsx0jXIlFet9Ri91b2oqIW63UDolteUwiyXW6GiLVMowTmfUXKyDdfYwS?=
 =?us-ascii?Q?rGMncnf1r5R/PZElBAPhkn4vV5ZuPiECiCXr9IQHPexA+ISsmDx41mKfZqQU?=
 =?us-ascii?Q?8IEj2TARKtVbsH8tgbDvFfl6PcmEgdL5vHM5qyjgx54S0Bhv+L+DyevsS0mW?=
 =?us-ascii?Q?wg9zgTcbz3IFs7fhQqNLEMzicJeYINYlZuTgrwodgfp4nUT5DHzxkkJU8ix1?=
 =?us-ascii?Q?Ges+KY87Qnut+Ocog9XKJRsKfa/hO/utUpShwM7PRu2VXYL/Z/NdDMhj/nDF?=
 =?us-ascii?Q?LhQSIdRXTI4+VjZeCuJX44qRaIHV13n7lCYS16S8AMv5J6EF38XPgt6Y/NFD?=
 =?us-ascii?Q?YiEZDE1gsdIkz8NwCXdPINaJaj7oOAf0P9L2hJkbdO79NvirTuxaLgD/rKEF?=
 =?us-ascii?Q?OMfZqh/HMBOgyCYIMLg4U8OZAc0daSaIBc61YTCnmNHGvp8cYfxpCv458Ujp?=
 =?us-ascii?Q?f+l+oZBFNVdBeNlGXl2TClzPKykMnHGzX2Z8/6fXZtKvbwbl19h4vLWTU9tE?=
 =?us-ascii?Q?CYpVGvd82VRBOgZYm/iTZNlaMIpAMwpSIRU6AUGpK1OIRC73LpTXIPYFm4v1?=
 =?us-ascii?Q?oAh5wTyKrHpwsSFFyZsozg3XOTH8jP3uxuwvwIuhv3oJjsnzCDuxMHCkhA4K?=
 =?us-ascii?Q?+rhHZHc6ZjzHrTbndlIhAUULXUk4Ay0Z6CFjAi0FEL5Mf0CaOVwFtnKfyj4X?=
 =?us-ascii?Q?x8vttIwvodtdLVSof4ny8MKWMJM3G55MdXwQkDBDice8Hp5/5Kq7OBncXMZO?=
 =?us-ascii?Q?wwcQAtDhJRw8CptnqHiAw7Yi/g5RTtH7/prrDXOSQcFJ2o+GKl41oVPVJj3S?=
 =?us-ascii?Q?tTjAppsr/61LeT9eBTWjk/8yIZt2gvoDUXfdaT13obu+Lz278uKx0ONBf0Nc?=
 =?us-ascii?Q?S7mEsbNiwwlUpLYPfuYlrwOfreayBtzVzSHamkZknRd1AIXg7S64aK25OCW+?=
 =?us-ascii?Q?ug=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b897228-b1da-4c52-b260-08daa56843bc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:54:05.9061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +MhQeaV0RVE9kLfUy+p2JWmaWxmzVFO4cz/hi0d5FbyfL3IxJ1SL5i2KqEiJyJ59FIproKLD19JEyARLHYmLRFSIEcro09i99Q6a4wJNXTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-ORIG-GUID: UbpB0rmIvofUf1TUry_mlXq6lJlqUiLe
X-Proofpoint-GUID: UbpB0rmIvofUf1TUry_mlXq6lJlqUiLe
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

