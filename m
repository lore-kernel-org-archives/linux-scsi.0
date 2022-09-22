Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEA3C6FA82
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiIVKIS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiIVKHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:07:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7FFD588D
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:46 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3qY9017964;
        Thu, 22 Sep 2022 10:07:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Qf7nxRVLDhPB41ucZUEAf4m16opmeW1VHb17f7VDH2o=;
 b=nP1HEi0b1HrXYieIZ5Hiti4OjQLZ//hAapdyQpdnayfdJjchOvO2N4KRYCCf9xtNN3+X
 jr0q2s/G1kYBI8vG6oYxydFB3cwWmx/b7Wn2KhLl93uVytE7xqDmB21Pj1QaFAb+axH5
 in5Hkxlz884ziUvPkZHP7zC8HjQ38CXHdBusM181r4MoFTBhiqyur1C3oU+lFPj0fH68
 3L6KTSHUmjXnFd9Ov2Rf//6aRntdpIm/29tCoZg5dc3PpIXxnDo+IUqoGnedjJPkiQ3Q
 N6nDmmhhXZcH37UxeM9zJ1DWG/Sgv64dLgrsbUUzkXvBHBBeJSEeDeEW7miwMIz6C7AP iw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kw1s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8lVeu033819;
        Thu, 22 Sep 2022 10:07:32 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39nedy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akJPMsVPkbRQ5ApuEMT9qUFEgnBXvISHpdqWvJyG8Eh5sxB6ep4Ff3FzbfJCW5yhJKmcPu7/y9hCxF0xB2CgoWaBuMAB1xYmRLxtXjVxbs/7X+FzrWL2v5ZZR1ticfsKKq7n5rbdZCaLy6GxaB2lPXQyb8TxGlQhHaKpG3HoTCmR7hNAKHayetQYgRhgJ6RI5H+Ggu0kXseF5RIRgDp4QXcvhGjxU9AcJTOn7IDbe56Yi1N9NHf7OG/ZO0URx3o+GddKYhTz5Mtf3271qwHm/LVAtP3ClzMcQey1CMIzPmSVsRSY7NB6as0o5Ieu9HGIXHaK+WWswja6Xsj+epO1HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qf7nxRVLDhPB41ucZUEAf4m16opmeW1VHb17f7VDH2o=;
 b=GKNErYSgQlhqVU7TNrn9G99WQHsCizUil34NPFibPxZ2oYVkZfVqN9H7vrYUtgzY+JHUIJzDShzWKXsJ4NE/tDIrs9q/B0CzgwvS5h4A4ClYjhGxad9I05FDK3aKj9wMFxsifL64Y+rbs1NiRwd8gC5IpXm4zc0sQOs3OrUjCHUkQKOp8aTo3ZSKfGvszVhCxKvwBYm5HCH/XpWWiOd9wmtUuM0icm89t8M3nyzrH5zUHZMRkYvKVT7xNejwwWC+td7ayY2E+0/jALRzfsybTDVnFEkFTWtDiVnpxPRUFsK69B3DzPiFTFWCL+W2nZoAdUnRPUwZyPZSg3IbevP9yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qf7nxRVLDhPB41ucZUEAf4m16opmeW1VHb17f7VDH2o=;
 b=xSwtHKTflSrdccG9poJPcwvwRXyiTVr/F6mgjmtd0snkHhXiF9PaHdrHETZgED3M5uMpHSjXX0Xjp+0RW/bpQ3LGAkK0viLE1Go3Eci0VI5Rv5oRmyE/7xrelcMn2uZmO5CLFkHOdF8b/50PXfvaA1/fENeEVeSkJ+DA7qfJn4U=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6528.namprd10.prod.outlook.com (2603:10b6:510:228::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 10:07:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 15/22] scsi: ch: Have scsi-ml retry ch_do_scsi errors
Date:   Thu, 22 Sep 2022 05:06:57 -0500
Message-Id: <20220922100704.753666-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0026.namprd12.prod.outlook.com
 (2603:10b6:610:57::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: 007ec74d-5a12-44aa-fc76-08da9c8242f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wFtKiqhMsSJu5QsHs+qwWOiqQdfCPYodlDqP6wm6sHRB4FXNQyIt6TFhuzOwwwdi3aaF/R0ezmDsY+tXTizRjUoUE1bjs7RlYwiuvp2m5ulXIvt8WU9vX62qZCyQ24cWIdDLDydB4tEozMkurtDfD1BCFq5fOP6zR+NXt/FZaAqDfdMMYFhuiEziM+ompPsIS2CIu6rITftW2pGFlkRohnt/5W4XNjSuE8FHt8YvQwk74AU+AbF+F4vnhj2Rc+Xcf2GAwXWUB7xxyu5fupSv02gUPYMSOC7immOpSqvfbSxrk267DJqDOgArQPKerGG7ExpIaVQV1zt2R+9n4/By+J63WtSATuHshn1qzoMBoBparqkDudimVXkftz8eh7h9ZeYRjRlZR8zx/S2ZBrvqnRwbbX5GRrCy2IHtWS8F6WlCVJzKKcv/XjpnkWGpG5xWYrCdu+aZZapNbdZ+ZeERnI3MysLdZ1fNh2qhavbofXLNZjQku4XxsCz7hJl2jHLViFNDz8vMRfLwj9PM87ddfu39PcsiPvs953XxcTcwPFNtPhFp0QQEP+ispW0uItScXG2ovckBGNY7RstI3QoCVTtscDw4agOzkp3ZCQE8jbjIKiw68qulbiJpkJPk4Ukql5+FBUCyjkuFEFsqxW3o2j04+CwvUFYXk5cBWQNskrH+Yqa1S5ZOEDIlxFejXheeY4vSBiP+F1VQRv605RJwTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199015)(38100700002)(2906002)(6486002)(478600001)(8936002)(316002)(5660300002)(4326008)(66946007)(66476007)(66556008)(8676002)(36756003)(26005)(6512007)(6666004)(6506007)(41300700001)(83380400001)(107886003)(186003)(1076003)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dE/W8RvzdN1u67h7aXMnaRFNoR+1XlnI292XBKp5aZfg4UpNi0D9zmWWanP3?=
 =?us-ascii?Q?J4ZFmPZAYPRzt/LZpKxraoXTY5wACPnUrPosyVStXDNppiBWD4KYLI8XHaDG?=
 =?us-ascii?Q?iuaERTWFtkidZLt8LcI9jZxt+rVDe0NMbDsxu5aXyqO22sjujLxvHS5X6Yjy?=
 =?us-ascii?Q?NGN7NrDnoER64WtVE6mXpNHjwdKZ/PRDgwWoXtnOKhhMeP6snOjVfAQvfAB3?=
 =?us-ascii?Q?f4Ki+qwb7OPlqnbSzYb4E+NilpJKIQZsWPTkDrvySiRILxRm6+aScADG9QLg?=
 =?us-ascii?Q?6TI5k3EM3K4UmhUxhFggqlVfsL2IFs0OW72QTYO28EOiL4StV1oXbeBcGyQ9?=
 =?us-ascii?Q?t7IN4JMoqIS6E78e6FIk1JQYinY2wOHAVKfGxiAyZaHfuit4qJQniT3YP6s9?=
 =?us-ascii?Q?JYEhFDurEmixiu4Nkilqp/uQhIXe1jytlVua3GCtdPgVGHvN9lTQOJhYGE/1?=
 =?us-ascii?Q?t0p1niw+dMmNaCPDBj5SiYv1cEv8XnYiT1mOiuLTTsBdFu/l/RhAvNCbDmNc?=
 =?us-ascii?Q?c5jOUy7zrPcI7LzEvklZIzXEHqewJ6J9jUTAT07uKOOLj36mWzZMWYWYCg0n?=
 =?us-ascii?Q?d49kshPQc9tsd//Y4Vy0GWMwVJgKH8lXzGpGX05+Uk8bGFe5/IiXvPYokGLC?=
 =?us-ascii?Q?SZ+hGTBswnyzv7CKgXb0zy/5FHiksgE9fTMnn4E9mZIcOdEgQPOTdY9YWy8J?=
 =?us-ascii?Q?LWR7pVVrbrwr46euAhyQowmetMCifTGkuJiH1aWGaV6JhLowlZ4JjK5J5CTG?=
 =?us-ascii?Q?tVF+J25MknKTZNmR5YdsCHFKtFMa/6LPQuA10RHkfAw2NXdMA94UUX7MppY3?=
 =?us-ascii?Q?A/Opq9j54MN9tL/vS7dCY8zhLY7626MiEMkotr5cHky3Iz7CwFBQx2pYnNgA?=
 =?us-ascii?Q?m5cGzyzvvfNimuGtepXWx9EkiHD4bViZ9qVbD4zJuZyzTkOBKnBRHJ0X+2fb?=
 =?us-ascii?Q?8QOLUiG/PMcW02DPOX4U/+76tJtWmOb3Fg91RN6ky21zMpHBHcBzX2o7UWxx?=
 =?us-ascii?Q?zuvb3aOKH98tFRvVvrqfZTGSQA0CmAQftO/4DI6ZzDXElBR0mjYsIp0tvS+P?=
 =?us-ascii?Q?aJeQGQ/4oBpaW7Giyk3teD+zEbQP0LPfAHBrhGLbrU/PquXYM7lJKDVDRgm+?=
 =?us-ascii?Q?WcR/XlmZ3X+P2cw/oVDTRtd5WWx+kTN6iEJ0vGqmA/NoFth20OqXRd1AcHw4?=
 =?us-ascii?Q?sI3z68tt1S9QuhFYgn966GsNUnkI8OdhDq23eKT/gS6DjaUb1f3U6ebtZiDQ?=
 =?us-ascii?Q?C07tv6n/ta3dddr7gAThpp9TVWepEfDJztiujqP0Z/Qlob8KNIkDVAuYzRF4?=
 =?us-ascii?Q?oG1WN3Q2en9sI0SE6pmUh2FTjM0Wef8Uw22dDjKoFzDprSAmYVqN5g0v9du8?=
 =?us-ascii?Q?358uik8z2bmQhg4Us0ds04pBvKbTjueUjcs7WH0+o//wpQvdxRvwn2fWtqPS?=
 =?us-ascii?Q?mC93w0MU7A1keL0L7Lr/Hbk3NrByiLVTV2ZXHK+1Atupaa1zuCHaD8JL1Hyz?=
 =?us-ascii?Q?omEV49l6K2Y2dS7twQ8quK0iJd22BcOj8veQ9zk+NhLP0Fu8eOGYqdNG97mc?=
 =?us-ascii?Q?h1BEQy1IpQyrGRMJ9AL+S1hwgtczEjAYRI8M8GSBL//3FwH3z9bjhHtrbWlA?=
 =?us-ascii?Q?VQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 007ec74d-5a12-44aa-fc76-08da9c8242f0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:31.0679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dTFiLLd496cca+y7297ZMasX3q/yYebt3b6s5pPLbUUaI/wRh7IBbGNF7ws/POc/uGd6qxpShZ7sabaHqRzFPm6oATc8B0TBD0idNoOzhkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6528
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: gpr-Uy0ZJ9kRermuk_WVnUjY42p7SWaj
X-Proofpoint-GUID: gpr-Uy0ZJ9kRermuk_WVnUjY42p7SWaj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ch_do_scsi have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ch.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index cdef392be5fc..683389acd870 100644
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
@@ -187,31 +186,32 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
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
 	result = scsi_execute_req(ch->device, cmd, direction, buffer,
 				  buflength, &sshdr, timeout * HZ,
-				  MAX_RETRIES, NULL, NULL);
+				  MAX_RETRIES, NULL, failures);
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

