Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D06FC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiKDXYE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiKDXXy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:23:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD70C759
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:23:51 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj8Yv014047;
        Fri, 4 Nov 2022 23:21:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=dV79/Obc87tSSRQeEHmAoG7u6mtZnjlW29/zoqDv9y0=;
 b=N8AHiPlqw34QX4vU7iYFu83YB62PsY4tkxFen/KE7Bje7CTKwmrOJHANpf2+EEN1C2YL
 5aAUCQEOzLTvKHQtA/EFsmI9wNdc/CtztgVdeeVwFEmqHrFUiwZaJAAAmNSc8rdwAW1M
 lKfYPsVPcf5QChcvwOBN59/cfOIuF1QVf2RKHx759Rooq4TmLKyv2DK1bIDJQYsp2ioB
 WETOCWRfHzMsVnw0X99ObMtqhgHOnBiPM/c9S38ULUhFyEpsme/Fm2y71YpgDvs1Rtdp
 VAZRndt8xlQ+UHiOVHBRLsfisHLwiRqVdvZjFe2U8fZXVNEyvcQ2fF0XWQpqMDl81Dqf 6w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts1hgy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4N8CA6014069;
        Fri, 4 Nov 2022 23:21:44 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr4t9rr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jn64l9IkI24LkCBzhvBHrVgC1x2BhumchRtPk8WgJ1TaWrapwGRcoa9MZb9c7+7yCfErkywznTuIFcfmQ1kPdJS8PvWILaRo0784OeAjVDKxvkofqEITUaBXsuygOIUdpnAJD0P07OzGnHlDXDSfy16T3t88mn0AB9lxvQaGwi5oi6scnsobOfVGdIQMHI1AOf193zsJTd6C9EenJmXoW+rph1UenQW2g5qdD8lRiErSeHD4JFB/bsqlgPeWbgWDMOZP9+sXX6UlrfQDMActY0TzAknC0q+5e+1Ipiwfnwmy7edyJmLF4AklRFZUjOrRClVpmxgLR61NfizLEdCCwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dV79/Obc87tSSRQeEHmAoG7u6mtZnjlW29/zoqDv9y0=;
 b=Go0+O+JcV2KnXLDeGbq8dTy/opDu580lX252Bb5z74pJL+Y+4BRDBiF3DQ4uNQdYpgwHDXii0X/mSWfv7+AIsQ59WOcGON3sISCpFfmv5kH+PWNrvIayk0G2Exv6FVzmTUW+Ge8GLwTc5yO17HOYRi+PGyzfXD8Yln+moSoIdyBo/yTYBp/xRNcP/LudLV5XmN62edB6vT6UJl6iBWUkkVad17MPr0lAwQ2m6fp3MoH8+MJ2gyzZlZyhVoBbMhf86vjEzn08IR4G2JgkbgrYemLSYTPB+FcX7X8CbzO9Aia4plk4e6K6K6J5nDjfI8WrfTmM4wy0sdjlrsHdYbNK1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dV79/Obc87tSSRQeEHmAoG7u6mtZnjlW29/zoqDv9y0=;
 b=IWNnMJaTU2W5DbTTG3CrhmFVXfX7/6fwWo/PY5vaWH35A9fbYSIvz70dCR7sMjNnxCmIA+01sPuUFtUaF4ARa+jbtlbo1fLbn/3lOWInEt0/nOctDtQ41KkKN4l9py9cV9va2wMGD/FpmEzB9CjotX1vu1CjRqEo9hYhLBhU8w8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:21:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:39 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 10/35] scsi: spi: Convert to scsi_exec_req
Date:   Fri,  4 Nov 2022 18:19:02 -0500
Message-Id: <20221104231927.9613-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:610:cc::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: ae1222dd-0bd8-4adc-aa84-08dabebb535e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ccDXLJ0+Ws2nFuTvYVMkSqro325iaoJuODaBPbvaZiSRqRp0hrhGR+jfPUsEWPbh9sy2EWv+PXD9HFly5FSB+/jgrWB5qlcYujrlo4EA1ryGlGc2Groz+9HKnduI6okxQtOZfmh4jQ8uFAiHTKWD/FyDR3C2x+b0XyWr60LDMr/BximEGgBPbb4KkKjjpQWkfHTx2Hxg9Ccmz2kgqhD8QML8jkM2pY+m3S7QqYYOIWUquaDNLE8FsWwRCDmL8kIoihpqRNmzghIT4oVJHJ35bR6hoi4QC1t6VqiR7xqeKMweT2uy+Im9PHR/L6KmSbX9mjrYsYIHQE3an5iY9io4Sf5eUyMHO9Lm7wWKyO02JXOhLoHduxDTjvTWfLsF3oah6Vx8Wu+8lRKWtg9iUBNRIOwO1UfLaBih3ydYmqG5z6Ww3QAF5Hvk8XXQ3rI+Kil+tyF7rkitQ3N0IczjQuff/OvC7dJZm4/mdlvmSW5EjV1CbMjllH1et1DDbZNSlX+lubosu1d7/NeX1kmZMtcKcaAzulSCGzHGvfVlPNEP0d6b8aWA1uRkDSacuThQmexsZnhvZZkuZWYpK1qFroX1/+JWOgdXTnUZ5zjN7l1s3RqoYnCvog+rudg2QXzs2KF3OciFPUlM8YSnnMwo21TWawLwSxp6ikc+T9yo/pnbTUhOBeepQO39g5I6trYgA2j9qkd9Yi4oEW5N5S2nmSyHpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PPrqVwGToAO9M6CG66LbUbhwlvcX2jv8fXnWdvaS4iDuj1RF3pb0t6OWVzqe?=
 =?us-ascii?Q?yMqcs4WRpMoiHdBMh3smxxJIziUOluYhGXXsZleXdzdVKjvfFavfAFjRrd78?=
 =?us-ascii?Q?Q+8fJgkoKjv5OmMKm8iVZbolaPLOoemweMSfcJq7bVPYkMTsNL5hd1or4zuf?=
 =?us-ascii?Q?I8yiYI6K1ocyH4cfH2nC2vcx/BAEbl02WymbwBVBl+K2DE4wzSQJHkjO+bp2?=
 =?us-ascii?Q?GGl4OzDHT09xj2Xp/+gjmV14TI+gJwFA8Jn4Fy5qe1yDSjHraJXTmvEfB5sl?=
 =?us-ascii?Q?sNievtfh+wWq6+qFtpETbP85fK04DJpv2tCLy3k6flKTPAjQJj1I4PqV/SF0?=
 =?us-ascii?Q?s8xLFgZ7CWKzek8y5al21/3jYMwBmwum4SnGdkaeudor4AvA3KZNj20P8JcO?=
 =?us-ascii?Q?qW71Wsa1DoZNNlQj2EQ9t2STlgb5u1P5Ta77HsSx4klbOs/i2vQRT1VEtuAv?=
 =?us-ascii?Q?SNE2l6dzsNkSUFx9hOj9Goa8plNbM4SyXy34uzy5hVvMuPQwPgFUjPiqkvT5?=
 =?us-ascii?Q?Stm/0lNISpDO0g8fnf1di08GlAnq/eMNyFUmHs7gtpCxH4V9KX4rl1edVbnf?=
 =?us-ascii?Q?s3CbxF43Q3mA56DNRz0mFxkFzWOyJQHDFr7Gm3chBnPXfyPnkj4zUuw2I9i2?=
 =?us-ascii?Q?hFffviydUCOgDnV5JlrToSExEoLyVRCqfEwoyrsBdS1Re0F0yilkijiAF80y?=
 =?us-ascii?Q?KNx7RbB1e6AYNfe9hMLQ2LVebxpzzdzW6TWrGo8IsEAnHaLscwJWzHCQfjEv?=
 =?us-ascii?Q?a+A6mScZWaUItGw8tiPp4tQ99SdWAfOHlzeNuH+pdv+KQUFh3xTRd63jAG/A?=
 =?us-ascii?Q?HN8M58kpwNdf8goXsIhwFVl/BvCqOgsHZ51++oxZg2MVc6QUu0srwsORSwBB?=
 =?us-ascii?Q?CtBJgZiNcrCxQSIf1HRdSk+xJT2IfQceXyot6Dk+RJ9aj3BqaBLDCPRoBoAz?=
 =?us-ascii?Q?FsfVjy8SDXvbrzLSoLB5WFoyGqU8Pwa9yXb28PsG7ZE+Y6L7khqoeISiCrY4?=
 =?us-ascii?Q?Ajc5BlCppWU6guipRiC8D+mUXqGA2ZGWxrS7xA55nar4jaSX9HZK2pJhRAym?=
 =?us-ascii?Q?nZSqwMmOEBMVFsEqFhYRqlsbvBP5kPqcG2ny/4dLMMLUzo7h5IN0esbARBjF?=
 =?us-ascii?Q?hgRVo4nDuwmE923sTcDJkbgByoAPr7U84ROB99RXem6i/11x2zhVtwt5pGp/?=
 =?us-ascii?Q?yOSKe2D36VTvZx8JUkX+fOh2KIE/06O+jq21o8iFzZ6dwla4gRaRy68dQNK3?=
 =?us-ascii?Q?SFzifR+DfujuFallP4/VJ419mNXEdigcC1WsUoy3JC60HIWBSRxLTBr4UgAu?=
 =?us-ascii?Q?2pxt0EUVpsR7P4LpZqkgsiZpgOJkYfyuHjKLlRBnMWZyk3E8mUJ1QrYsXVBa?=
 =?us-ascii?Q?fvMJ9Yx3oii6uPYUsUs+WevOB3LdBbTY3KGNSif5pM0fnCOMGA8GhktNGnlc?=
 =?us-ascii?Q?PHzpM3mH1yzWMVTPXZjX9tGdsCnSQA/T6ymTJFocmfCY7L7yO6Pw8C8xKVcC?=
 =?us-ascii?Q?gozVMw6ctzSwWP5rQ5DFkUJe4P51ls9/F7weQnsWRAzbUQdJe1Zry5ROIIeZ?=
 =?us-ascii?Q?Gi65b9S20WRJspy+yBSDXc3EXyTLVHW98NJsSXsvyQB9HwCop0QJbA+P3Poh?=
 =?us-ascii?Q?bg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae1222dd-0bd8-4adc-aa84-08dabebb535e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:39.4471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P1rsWbK5fVaDWmOwK8tcbg9mVaNaOrsyif8JeBkKqLnC1YnnhtnbAhTm7gtGTu0d5hs8n0HZHs31g32VhiwldlpIRyQ2cdkEtKzBFzbj1Fo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211040143
X-Proofpoint-GUID: wpOPObsAZ3SxI58-gdgRDYMe3ZQSzDOF
X-Proofpoint-ORIG-GUID: wpOPObsAZ3SxI58-gdgRDYMe3ZQSzDOF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_spi.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f569cf0095c2..18a365c577ed 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -121,12 +121,21 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		 * The purpose of the RQF_PM flag below is to bypass the
 		 * SDEV_QUIESCE state.
 		 */
-		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
-				      sshdr, DV_TIMEOUT, /* retries */ 1,
-				      REQ_FAILFAST_DEV |
-				      REQ_FAILFAST_TRANSPORT |
-				      REQ_FAILFAST_DRIVER,
-				      RQF_PM, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = cmd,
+						.data_dir = dir,
+						.buf = buffer,
+						.buf_len = bufflen,
+						.sense = sense,
+						.sense_len = sizeof(sense),
+						.sshdr = sshdr,
+						.timeout = DV_TIMEOUT,
+						.retries = 1,
+						.op_flags = REQ_FAILFAST_DEV |
+							REQ_FAILFAST_TRANSPORT |
+							REQ_FAILFAST_DRIVER,
+						.req_flags = RQF_PM }));
 		if (result < 0 || !scsi_sense_valid(sshdr) ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
-- 
2.25.1

