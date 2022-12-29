Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA4CC3DA79
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbiL2TCm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbiL2TCO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:02:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB10D9A
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:02:13 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIwukR001175;
        Thu, 29 Dec 2022 19:02:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=t1+yz0HnVE9Q8IIwHFqzvAu/rq3h/1oTObmdxTCS/FQ=;
 b=Ya9aIjlA2YX40InInYy86SOKUJ9cqpzexQZny7/HXD2zTAMv9cbuEhvMMTfw1Y7kQkwL
 xNg8x3WXgFsX5vtQ6yneLUlN+pdy4YmZe+hIGEzupGBJLY6UoTgmSKLDNwesZc59d8uA
 tp7sl/1ZexQBgXl7fF2ZvkGZa+bghShB5WzyBKVFVR0u8gVOZr6xyD/xFcXqpLsL5Hma
 +z4sVaC8jSi2wI24NwgBv67BVo4NiOVkVIoahTI+8jKIo9KPWkmONjlw7sgX3DUCYSY1
 GsdHgDDHCNfi7Ie2Ajlmsvg/StIIP3hRE6Ehh1dIdrbhh0EHLwUpJGHKTBzIj4yKhdjV Ow== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnr73f7qh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTGRg97034219;
        Thu, 29 Dec 2022 19:02:04 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2045.outbound.protection.outlook.com [104.47.51.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv6s0g9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6BdSqu0Qib/HmL8cNbzmu1Jqs49blOg6R4oEWcUUDa9wilvhG/YY2xDExh4PH5nnI81vIlNDPZtSUrOcBKhWT3ZlI9ZjX+km6peC8PariWLvm9QhtZEq5jwwAQNfmxeADeot6gOepZ65BzW+EN+W4yRil45PHpr2mozcIxNIB0hj095Z5pRsRyBilsgHJp/AV4Z4BoCyvIYcwJy2OmWwPJkIxW3bQeZt7Y1WkVzDjs2A8ihI9BVTTwwwnSqAnzE5kG1ra6R5vbU+TCUClAYrmVo1joNGp3d83Kjvwt4RFXnUTO82NoGANAvNeIT3d+hn6it2U83zrdDL1Ejx/lpQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1+yz0HnVE9Q8IIwHFqzvAu/rq3h/1oTObmdxTCS/FQ=;
 b=EfAz1d5l34Liv0VsBVtRiCZrGdec2yDXel977F3zZ4yGM5k8Hi2kA2bCx6jYiYd+9qyiDm6qf6l3WimDKlFAGnyCzwtadhmu3QLZHAmQFLjzX/M3q13Xc3VDHnMK8+X+MoYAFG3lXSHc4ZDJZ3iegyCz8IfxY45JlA5pFF3bwidzxdUB9ogXQPf3gr2uP148O4y+s6MDwjaY6PQI8hc2AGMbbAlKp35N0cVcfG+JdOdbQbeaZPiJPjzEx3LX+S/rXeyBACGI4A8vghl+zJsWGsFREVluB5PlNyUd/cTuXtP+ctHeUDNPLb25mbv3BkkNMS61qnHhWK5awOouGclBUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1+yz0HnVE9Q8IIwHFqzvAu/rq3h/1oTObmdxTCS/FQ=;
 b=GLawXc8/ImC3JtDbqTzVdtNUdLkVlpuYpzf4elq+vLXklkDdTZowN8V5z6SqpZ1QSBQy57sZLdEkDbe23zqZ+qY/+66tgOUvFARfffw5z6kB6dA0JHgD1motvdxf2F7/+wVxOEpSlG6QiHZaTPsj8R7hDkeMR5wVHwI5lnZ2dBE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:02:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:02:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 03/15] hwmon: drivetemp: Convert to scsi_execute_cmd
Date:   Thu, 29 Dec 2022 13:01:42 -0600
Message-Id: <20221229190154.7467-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0445.namprd03.prod.outlook.com
 (2603:10b6:610:10e::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: 550aeda9-71bb-454c-aefa-08dae9cf2b92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UunTVGXI6fAj+2NE2NTECj1w2uVHkYg162exAjMJuOCaWJvaWJm+89HCyWS5L9KXrf5MI45VoUFFrtlmLHgL3vb+Fk/N1aDGTdt4OzFoJxAWjqJBYZrFdTldxSBmJ3iEUQhAfmhE8X2aw6z3qDFLKKZV15SXCmwi++Yq347ExQEQ1QNerjttbKcyqYpLLxz9ZlBlN/SD545ogplDKMBMEiBee/C443o03+SdUZPiLBMDMYtnLsoetMko9HitSKF752MgaA+o3EyN1t4ONmYEJAxkziVaPa1AEHlIkc0UtH6Be3qXcFFbotYLypuTWKOm+DHpicSTOPhIoXoWEJH3YRtWxH068ngmtCZTzkLniu6bDzGdguqxpgx20zJMnmtvhLlnduPP51hJ08iI8rgnTwXs1R5Gxo7qOloTbL5Zs1b1/0ZyF6F/8iMtb7ygV5YtHEZEJtk4tkzlWrYZ4zds6nu9kkxUTn8+uL/pzb9aeMxEGSno+GcTcYfeVZ2+qPCPyfkYKEjHdkskJq5/VOIXTur+ixPxczHufj1wlG39/wDzjYALNICRhQZYI5g0hqCLATMRD/SkiLDje5oKJ9pyCrzQ9+0T2+KVCYiFC/ZRjGneey+YWzYKhvDpwzLGGxpV9qLyVAkeLKpqGgB+8SNlEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(86362001)(83380400001)(66476007)(66556008)(66946007)(107886003)(6666004)(478600001)(6506007)(1076003)(4326008)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bswGPBraDTCiPgI34ur6YZSl9vAEfrfBAXHc7wy+ttLfoa3powxvXli/EyHy?=
 =?us-ascii?Q?A0KA71Y/9bsQbhMjqi+xVKRYphYItzfdow2MMm+HiK8ShBJoL6g9A/5BV5AN?=
 =?us-ascii?Q?bCIozI070tyFIw6R6G/op8gu3V4UlYYqXP7Kl0330hsP8t3qdcXvWc4RGCy/?=
 =?us-ascii?Q?sr1FFepfGDu7j3xT5d7zRr5WaF+R9Lut51x5zx1Cu3IvK+ANVXW1CiYLI60p?=
 =?us-ascii?Q?ROPTGyz9NP3kxS3XkHmebSmCw+LwDm6kxtY+C0w5RDCCYJ+DI6YLw6gjdIX4?=
 =?us-ascii?Q?B4e6OBYTunQQQ7aDlVuDNLd1UU1T+nkdYYP036jmic8Y7lnuNVOWnyPuoo73?=
 =?us-ascii?Q?pXgVpCXGFczNfN7sadN5dN4Fi8se6IxBPTHFQ6K3PBz/Geal4PetcSqxZhQB?=
 =?us-ascii?Q?GbGrCNIRRkkt0MSHqPIRrbX+yU3J7mwYzRdYYRVueuSqNrFV9v/0TEEC3QUB?=
 =?us-ascii?Q?WylzBvr60CncMiiF06yontUy923NPwJZIx1bLUtb8dyaghJDymdmuVcepT5Y?=
 =?us-ascii?Q?EfDmW+KLQigQp0J4nS9348LgKV5XIu3om2Ab/MYsakWzA53i20sVi5MVajBK?=
 =?us-ascii?Q?tbTt+wiqzkb3OM5vIW6HeQP9E4dVEz7lr00ctE5yGV3AQ9/9it8GusEZTzA5?=
 =?us-ascii?Q?wYvWYM95IGtEWq72eC58B4qcvgWAgxS86/ra466JJs8vHFtZAj5Q4Fejn3ne?=
 =?us-ascii?Q?JXHrakqoZkKwZA9osmDpspgiJrNdKpqrRHh3S+8e73BnbqXNL7xzP8L/+pAq?=
 =?us-ascii?Q?cKBKBZKIg/bFbyk0xlP9XAL3XsJajO6wd5wSJzEj1HzGZzzJUrLrgPJaDOeX?=
 =?us-ascii?Q?7djkqSRLqwQntG6PLmC7KEDkGAUEwzWB4draz71XBHE+CdEQw5JPwHQ32oBe?=
 =?us-ascii?Q?d2jrQhmLAF4BV4wAfXZ6qme1sQv6OkhN3Avz74p3VicI1oThMCCyxMIAaOai?=
 =?us-ascii?Q?GfACOsWZpHZ8JeDiOh+0Wqp4bMx8qOAX1Np9kklUfMSPfZ9F9OF9bTSGlT35?=
 =?us-ascii?Q?6Ct03SpHX8ekKkdLaYLmIOLPV1AnRZ5Pjk1OsNl2/FQfJ7wOj2uLMzexfUcZ?=
 =?us-ascii?Q?PHcq6yowOvgp6I6152vch42tkiZ2gMzDdU0DaDwtF6+/jOfV9EtkI3HD71v3?=
 =?us-ascii?Q?Iq6eG4HMNf0PvWwGyuHtnaaosGv0nN6dhDa8moKui+YYq946DeuckYpZTm08?=
 =?us-ascii?Q?0hIlJXzXEDetvZvPL/limeI6AXcHjtgF7vebfKqTT8O0eIDBpoBdn6Zy/Y2y?=
 =?us-ascii?Q?bpa2KrH+b8kWFbMvKnx0tXVqE2dXfVGrozY9cr+WH8ElAJzYRsJGNyfEtfKn?=
 =?us-ascii?Q?f8+krLrwFChACZzyCfGm5I5T4Uw3M5EVud0D6qxgMmZvQjVVNthEADr6J97d?=
 =?us-ascii?Q?7hwdm6NsvPmHdd9hMEoKRVZgQ1FGkPwMpnBtgC3drakEMI1+H+J6yp2OC2lm?=
 =?us-ascii?Q?yZYecvLOtwEMCVfe/EnU0QJQ+VpLQq2bmmaqXYu/5hqS7T6dkyqB5U0pvhE0?=
 =?us-ascii?Q?cjIIS/W+EweiKmT0wY1p4VA5z5Hcj1rI+MeGSxw51H06/n40kFSpLemjhosu?=
 =?us-ascii?Q?8n/Ytynb8fVzpoA9y+GeHh8m6yuVkm5cqMUDxuW+YbOu5T6OgchhuREBXanO?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 550aeda9-71bb-454c-aefa-08dae9cf2b92
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:02:02.5663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ekzGJzjy6rnt7JzKWU6b4c8UEN7xA947LlLVDflPaZ8eb+oq6pv1/vSR4ez/F+/LEgy0U9V/eYrSr8L4Uvk8s0Se2/WVM1U5cyqdBYh2ZGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212290157
X-Proofpoint-GUID: NMpr5PQYTHUnxXbnRAFjMfuu0qrCQ-_h
X-Proofpoint-ORIG-GUID: NMpr5PQYTHUnxXbnRAFjMfuu0qrCQ-_h
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert drivetemp to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/hwmon/drivetemp.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 5bac2b0fc7bb..8e5759b42390 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -164,7 +164,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 				 u8 lba_low, u8 lba_mid, u8 lba_high)
 {
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
-	int data_dir;
+	enum req_op op;
 
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 	scsi_cmd[0] = ATA_16;
@@ -175,7 +175,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 		 * field.
 		 */
 		scsi_cmd[2] = 0x06;
-		data_dir = DMA_TO_DEVICE;
+		op = REQ_OP_DRV_OUT;
 	} else {
 		scsi_cmd[1] = (4 << 1);	/* PIO Data-in */
 		/*
@@ -183,7 +183,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 		 * field.
 		 */
 		scsi_cmd[2] = 0x0e;
-		data_dir = DMA_FROM_DEVICE;
+		op = REQ_OP_DRV_IN;
 	}
 	scsi_cmd[4] = feature;
 	scsi_cmd[6] = 1;	/* 1 sector */
@@ -192,9 +192,8 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 	scsi_cmd[12] = lba_high;
 	scsi_cmd[14] = ata_command;
 
-	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
-				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
-				NULL);
+	return scsi_execute_cmd(st->sdev, scsi_cmd, op, st->smartdata,
+				ATA_SECT_SIZE, HZ, 5, NULL);
 }
 
 static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
-- 
2.25.1

