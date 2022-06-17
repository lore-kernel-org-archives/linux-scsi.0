Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7DBC43334
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jun 2022 03:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379942AbiFQDE5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 23:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379924AbiFQDEx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 23:04:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5E06622E;
        Thu, 16 Jun 2022 20:04:52 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25H2C20M022339;
        Fri, 17 Jun 2022 03:04:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=G0dieYK4eQgE1JdoJzYibqzEQ4kpbttc6gg00fVgK/o=;
 b=VPCM0OKCIsppaD9NrldCXKzfMfr3sdgFnRAhyRk2CuewEdKZhJPJwwUM2fVUqQDwCbdu
 JsEpMLG7F+PlyywU43T+hf2PMl4ZWJjM3kXDpeN6TZM01BlRD7kerqGkP3CkpT75NZWr
 5bLl2RYJqB3ep37DhWcPoQVJc5PlONbSX4Vphs308mRJahd2wVVHkmfHClv4rSZmyB/P
 3QjnBn0j9EebEiqDee340OiJNPq/MJdX/W89LkdUfGstU2qr5BQasLQdel92xho64ChR
 g4cjYIC1DwPv32KtZXQYbP4mYay1DR0LqkRGMS++n3EVm6C3ku+iUJsXZlnZw2ZWDLKM UA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhfcvn78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 03:04:50 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25H2tlK9019489;
        Fri, 17 Jun 2022 03:04:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gpqwcq8hg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 03:04:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apJ7/L7f7k3mpRcM4H45z5VdQzd4vvJ41z7Bzaq200caaVFLH+bGnSkIv/eqZuHjcX6qGylThQRJdwONcEBANLkvJraGNkMgGFAXMryEhl3y/76D78Ren2dRvukspFMQVqtPxyNzZAimrzLQWLzH0FJcvnwINIfsAq1lKSrQ6dut8CFusaIAro5J8h97x3tskEJ1xKZQZitRBWR6yYFW856V+zSpeDVgNkQTttzqscCDklejBUSiobpbwQkYVBKfNQuHKmJpXOo02Y6Iez18qiiyOALCgEDjSkLQK50aIZ4z3Ro9rvwkKx3H6GbTGLnXUFSH3S7AnaljxUGe9eo2zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0dieYK4eQgE1JdoJzYibqzEQ4kpbttc6gg00fVgK/o=;
 b=gkFrVsXlcyv5jAKKgYZjpE2ffxk+Tc2xzBhbGm0pqB0ewqbBsgXLKET1oJbd6CnmK183SQs070O3byJWUtWN/dKRDXINXWht+rG9ids1OBz58qNKgJ6ALsPGMd3FL+tPzLkRywdypbhgWN/MuMkIsdV5pE8fYjT5KAPm9ogFKSB6maTGtn9KKKlDOlZal4GCC5dbNsXAsz1vWn/azdyeRIdhS1VdnSnTm8XdIorOZ+wbbgBQG8kT/WUQHFF/b0cPrXwydCTJDiiiKeHhSi8TtVQaYCZ1kmVzvx2RJW4OIQkrJXKhMBakoaCceA1JxSw/WThCc3g0sAErpblGqjwjWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0dieYK4eQgE1JdoJzYibqzEQ4kpbttc6gg00fVgK/o=;
 b=Zr+oC0SuJxFD1vPWvHP5chCw7RUrLj/rgmDhmPb/sv2Wrfg9u8ayT4LshcK+3sFy2eoCEuobOmlal5nZThtGgw1KUQIBKSvwl6QlPGup5/AJmM+gqnH1wP46z+ioAe/RPB7QHVsyS7MSH8pOwJd43wpnQD/Xl0KBLxmNzOAxBC0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MWHPR10MB1280.namprd10.prod.outlook.com (2603:10b6:301:8::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.17; Fri, 17 Jun 2022 03:04:48 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Fri, 17 Jun 2022
 03:04:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/4] scsi: target: Fix WRITE_SAME NDOB size check
Date:   Thu, 16 Jun 2022 22:04:36 -0500
Message-Id: <20220617030440.116427-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617030440.116427-1-michael.christie@oracle.com>
References: <20220617030440.116427-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR20CA0034.namprd20.prod.outlook.com
 (2603:10b6:3:13d::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2a32736-bda5-47e0-85cc-08da500e235b
X-MS-TrafficTypeDiagnostic: MWHPR10MB1280:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1280A219E3E74FC76A826E7CF1AF9@MWHPR10MB1280.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FLPKgeTrL7hovu+boDVbfN2t27qjTUprbS6+J2ub75AaxdIXeG6WWhkTsVWzbpGKche3GVsWmr65xNckzbA8KqCZa0YS3q3cB+sqS3wOU3628j4lqk7pvGm8/Fw0gloUr7aSL6fNzLQ2fO6myGx71dQi/LiBTNtoMuTsPi6800VeFWxOYquVWn4w8U+L5lGk0eby/z16Rp52XFPmQGmY5p/6K/irY5RDTACOGuf2Q9Oxv+eeOnCYN4NDT5bKvqc8ZIIUuNfAozQM7lvVTmdTDEEhvtKYye/biuPwxZ9Fi1k8jcCfYcD6zBNeDWI6B6tpUMte5fHq81yhW2XOzroqD7sdFwRROsUknJaQHNP9PbM30oG996GWKb07a1P9GDDtARO4TFlyAW2Tw4X6EcZUFEZP3iwAz1N+d2BczcALLm/pcR5Ic9jpbHSyDX7MW1OEE4Dd5eN3McK1EOXPbmaHSW+WX+hpbjOCPJ1h2V7JMoEGilZ35KkdJCgJIt1KWgC1qFxVWMe3EjatcTJ6lLpLId0lKsfmMpODlGNOYKXGbWpg4fjax8YGglseZf8/KMwz0BEizeGRaapDVOALZJ+PcZ84L4SsGg39I6W/ijPjD08ZT1F19QquIBJqFoUnZw1Y6p2TJpM+TEanRIdVSHKrgLptER1wwZaQ5ad9kTfdB9h2djN+Z1LnwEHORKJ2wWdNhZE9d+umaWWkWXlE3fMt+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(8936002)(6666004)(6506007)(6486002)(6512007)(508600001)(186003)(26005)(66946007)(52116002)(38100700002)(2906002)(38350700002)(1076003)(86362001)(66556008)(36756003)(107886003)(8676002)(2616005)(4326008)(316002)(83380400001)(66476007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c2PMIVCvRYqMbLH5L/hF6OIyTWjAB5clfc1taPEf7Nu6d+GD9p6mpMa4PNue?=
 =?us-ascii?Q?+0kZyUqngVHsThVuUbHBuEUGrGStlsGKCj+lNEk+8bXdPjRaxj6+njMb0fhU?=
 =?us-ascii?Q?Oi+nomAb+7oueqpBLk8LId1kafTLhUH+ooEpfb3wpSHsHQiUDPQ+uYQU9QJe?=
 =?us-ascii?Q?eOXuKbUoPbM1AynjrNwhe+MMoN+RjhZOgQxZ4cPJRuVIgL34oN0SMGnhIEpp?=
 =?us-ascii?Q?EcsxHaDpSFYr4Cqowkz6uiYvq2pmbs2/9j2nvhov/cPHDKem3ofZgdhKueaI?=
 =?us-ascii?Q?60VeSqcd217W5ack8k8r0ZX3cAcwXZfQpm6eka/IW9lyK5H9JkOZIoUzSzML?=
 =?us-ascii?Q?BCultgitX8fAtip0a00GVlQkMivPCJmsOzyHFcyDoWSKtJVMlIOoJ4zI9Yoi?=
 =?us-ascii?Q?ThO4BGocETXDbCQNjKTKpIpTeZ88fDPmL59hM5PY8gXL+D5DCG3PMlfbid/r?=
 =?us-ascii?Q?boTyowTyvcFRDO4LomQbDCCNPbUi33Zxw0CY0fpSry3UN1KlRusCh41cmCKN?=
 =?us-ascii?Q?Hi2I2t6UloBGuoOVEzywtYJf0me+k+x/zw4cmQNl4EE9K48UbTrUXV+/4E9s?=
 =?us-ascii?Q?UpU9GH29KDnKdRSRphEwY3FaelTs3y35d3bjFIANBMDZgKT8SutVjS6w5nRp?=
 =?us-ascii?Q?HnNzb1tokmo/fEtMwzTW5mFMrDA5dOHHhx22jjYRLvDjXJg7BAzzQVU+Nzjd?=
 =?us-ascii?Q?Q8T8u8P6UpPS3WdtrKeBuflQ44HndNMqxErAD4d5rgfUel/ctOyH0xqJWI8j?=
 =?us-ascii?Q?7cpDQ9BUGjaIYhS1H4umXqLv8rCbD4GnECuIlLKNeTTp31z8mu/lTCJay9E+?=
 =?us-ascii?Q?NtWh47IdcdrL1nsITdfUohJedipPdMx+HlrOYDDCK3/0fTsFyDFR5iGSZL1Q?=
 =?us-ascii?Q?dkMNPBwMq1EVCtXwTHk53wsTegyqozFy58PdrckaopTS6BfQVYrlkYQd/xC/?=
 =?us-ascii?Q?19XapcxDg4LfU4DdyA5j+V3N2i5XaNe/lCv+OBpYz6G7RtZZxMEcHiDctSWF?=
 =?us-ascii?Q?xbzw1OlYmqkK3idjYhyZTMt4RWsQcnDGcAq/MyvpbsoSOB9fbmT9bHds2uVV?=
 =?us-ascii?Q?nxJlRrD/7rF1FI+GfbEZJHXhDb1GkXJO8yjSgevPuNXSH8lKwiL0vaFzQFoC?=
 =?us-ascii?Q?VqDQeliEQobZX/k0CDePtIgx6lx0cr0+OWKIblQvo9cmCTy2DeSsqEAR/R48?=
 =?us-ascii?Q?QAgUl9bfGfME59VFZdRYA6FIOyDJm8pkncWH4Yc23hG+2RbiQ/aB3EJu05M8?=
 =?us-ascii?Q?7MSkMBtB1AIS350ecmaMHmJvX4ugHACrG8rraeHmlk4faxLUyomZCM2r6uQ/?=
 =?us-ascii?Q?pt/u/zyfzjNFxMWfTU+izK3YDuv3rZGGB4A8HAcv6bbuYOKqBvfLo7Nzra+1?=
 =?us-ascii?Q?LfQGsKNT+P+hZIssSSeGzPWDjLAJ9ivKL+ASgQOu0eCMgvFmf/Lgq5Rydw7C?=
 =?us-ascii?Q?EmFyiPBs6SozIlpVrzkaPAlW3TC3E3gDSuvtO1Ve69YKfRnMiPrezhWQycsQ?=
 =?us-ascii?Q?GxscMKeAYt7EdcxhuiYbh63K4Glhz0mQIrc4G9nHXtIknJBE8F9si/oz8UTy?=
 =?us-ascii?Q?pY+7BACYk05AgHOZNdGt67pydSHZ97+qt5aeBVUF+bs7toOcNI77KUxQ0fdF?=
 =?us-ascii?Q?Jetja74FxFlaCIbMfDWc3uTxApX1ujOFNCz5buZPnP/dGnJBOXjSzfHUHX2+?=
 =?us-ascii?Q?ccaIvAqL4aQvK+6bM43/9UFD0splmnxWyIWtq2pQnUcXFI4jsSjslz8YovY7?=
 =?us-ascii?Q?G7N/NVssMNjlxhBqku2YEv3sZGOn704=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a32736-bda5-47e0-85cc-08da500e235b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 03:04:48.1186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lHacwmHPEXW/jkEM7suqUhkOgx4jHjVXHEfHz1/tveJRKZcMKb0mUu91VSvdjwBswPCt75Uhelq4zG8UBCdkIYl7NKYCQxep5VmQ4md8l5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1280
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-17_02:2022-06-16,2022-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206170012
X-Proofpoint-ORIG-GUID: J0ovvXEkYUy9rmy-X3lSlTTlPJB9W3Zk
X-Proofpoint-GUID: J0ovvXEkYUy9rmy-X3lSlTTlPJB9W3Zk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the WRITE_SAME NDOB bit is set then there is not going to be a
buffer. LIO core will then complain:

TARGET_CORE[iSCSI]: Expected Transfer Length: 0 does not match SCSI CDB
Length: 512 for SAM Opcode: 0x93

This fixes the issue by detecting when the bit is set and adjusting the
size.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_sbc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index ca1b2312d6e7..6d98b016a942 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -976,7 +976,11 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 				return TCM_INVALID_CDB_FIELD;
 			}
 
-			size = sbc_get_size(cmd, 1);
+			/* If NDOB is set there will not be a Data-Out buffer */
+			if (cdb[1] & 0x01)
+				size = 0;
+			else
+				size = sbc_get_size(cmd, 1);
 			cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
 
 			ret = sbc_setup_write_same(cmd, cdb[10], ops);
@@ -1075,7 +1079,11 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			return TCM_INVALID_CDB_FIELD;
 		}
 
-		size = sbc_get_size(cmd, 1);
+		/* If NDOB is set there will not be a Data-Out buffer */
+		if (cdb[1] & 0x01)
+			size = 0;
+		else
+			size = sbc_get_size(cmd, 1);
 		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
 
 		ret = sbc_setup_write_same(cmd, cdb[1], ops);
-- 
2.25.1

