Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67765EED611
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 02:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjI1CJZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 22:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjI1CJV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 22:09:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991C7B3;
        Wed, 27 Sep 2023 19:09:19 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RL7T2q005172;
        Thu, 28 Sep 2023 02:09:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=yN9n0XboO6sXrc+xTkp6zQZfm+oW2/DJLqsqYyjEoYc=;
 b=s+w9bfQ7XEgtcuzwMOIDy46nkPQzLea2gSyTjNjMYGJBVdzLjMPLHpbAPyz/lvQpA8wk
 MEuqMjz5swjoCnO+a4zwUvhkiuKTsrxiGJoTKkjIniVrJCExZdbGhfKvVJ+xsg6mF7Ep
 Yeq1+NEu5r8fGQSgNQ8Msi5cJVVRLnWXVFSOx7hklbQ8V494aeiupnAsGs0kmk0MYHV6
 0WJC6iPE2Wtv99JhfnRoHyqsrdDlGVIpQsAc9/HUO4my/X9YdKjYVR6zSCbYri7D2/TR
 2vjlHIX9sCCley1xKS7IXP8PNOKY0UtR/rsFj3KWkyv3telAMy78xPT9vcuAvgqOM7xT YA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pm2b459-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:19 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38RNWBJT034921;
        Thu, 28 Sep 2023 02:09:18 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf9784a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekpWEK5LmAep4dpLi10ddQ9zUwJYcwiYw+07MbNGhkJBiLZR4ekueCwRJswdeKQu+Xv4zW1mJeAhaTOeRYVG+Gz7ObO8YRpWPqdoHmSe73pvd4+J8dXca/g7Q0ehrZedATm9HCCSKBUki/8uIVZdijnC1JgzoIeTE/V4oyfKL26iuMtcvbWK9Xpg8Qaed9hjrbWdvCLBRxQL4+Xl/nOp1BYnGyyaNCa8WxJZNNNAkodSoTj/JDPWmhwFeTp15ik/PTg9msonrHOh3tmf4BXCIfEvP6xTZA3ujTlY6Z5XgADn5nOS49gnSnTbwuXaICDGuYr5MW4HJjx4Yy3ps67syA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yN9n0XboO6sXrc+xTkp6zQZfm+oW2/DJLqsqYyjEoYc=;
 b=I8SJbohU1aQDIQrsrWPpnKdmvJve/E6wziVlgzDs8OMZEry1oKHauGw9YxIVk5QAHrRoPScdbd7f8/VfGFmrP+mcoAXrZd2EYGxdW2eozbMl66W//lx6NBoqGB73HHeQthMIAoxol0Tzyt9AL6GQ/QGHsnEPiWW2/RKwRLTr7ZZyDSb3dTxW1XYK5lBXu8Ws7Gy8nZwjHEiGpJECPQAyQMlMxEsAz6Hok5FJYr1a7vdSfAoca12WhUD1K6ix75Bi5ZH37adJhgKU8Jmlhqxu16dKpKPcobAfQDy9gEvPjuPn5IzVab8tYkEb36hOn4C/gqT9ai3aCbGtbtbTirwVDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yN9n0XboO6sXrc+xTkp6zQZfm+oW2/DJLqsqYyjEoYc=;
 b=IlI3D5CMS7K6gHiQWLs7ouKnwjv34RjYl/5TlY4QOajJiOm3Yne3fCJJECmf0/iw8OcWjouMtwgDCA2aDUnEiNsWV7zKLhVDGyzGAJ5mcRdeMDwBhAzyjl47etK5VwLCOQ+n/qcP84OOrcVWuGAA5LVe2VE7NiKUmk4EPiWucm8=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 28 Sep
 2023 02:09:15 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%6]) with mapi id 15.20.6813.017; Thu, 28 Sep 2023
 02:09:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 5/8] target: Kill transport_handle_cdb_direct
Date:   Wed, 27 Sep 2023 21:09:04 -0500
Message-Id: <20230928020907.5730-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230928020907.5730-1-michael.christie@oracle.com>
References: <20230928020907.5730-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0077.namprd05.prod.outlook.com
 (2603:10b6:8:57::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: 76fdf04a-dccc-49ef-43e5-08dbbfc7ea6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MTibRdJAsecwXkC4a4n4c2GNAZv6gQ6C2oLf7Y4z1fE1LdKNckqqJR0S/uyw1I0ltuiM/AF9n/DIYvPw7B//CAbDwJQlsQmn8dfxIUNDQe1GZSl0gbYgVwYftSKMqo1sEAI3AX+zbiw/OCDglmC8EQibsW8Ck6WqO0xD7ItJHT/c6z3hnK8Ghs5HsJuWtcfYvGjafVhX8V4uJnahukN2zoKDG8T0Kh9/KRdW7ZhAwq0W08eZeeBDHJ+oW/fVeXNS4BA+FUWd3sFaLNtUoJif2QShgM+mGnThWkFHGAD/xEnjQJpWFWuU/cJqvMqlOSHl9OJ9Fw8sJI/7uHOnYN4RNbV50WJ+5sAkw3nmogfNYGwge5xz0gpJDMHcylpzXKpG50V5T8j6B1jl+YhI1m3lZyV7x9OsKpAIVR7kknB3G65GL8WczTL0vjE+F5zFyGl1HRrdCGjrUhRcbHnC9td4b+zXE0VpZQM+QEC8USuPoEFs2h5PnwKpiROjfjjZIep7AougdQabBpALHoDs4fLSY6k2uP9iN1KIn/ZRurS4nbzRQF4n74TvCAFHhyksyBK3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(346002)(396003)(366004)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(6506007)(6486002)(83380400001)(2906002)(478600001)(1076003)(5660300002)(4326008)(107886003)(66476007)(8676002)(66556008)(450100002)(66946007)(8936002)(2616005)(41300700001)(316002)(38100700002)(26005)(6512007)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zuKlqd6/OWtef49GrPdAmjI/zYjSzB2etFyINK4pN/F7ecoYjuppkiWJd6KG?=
 =?us-ascii?Q?e4i+LMMQmx+YoVOmhKJFQ97ZLCWiqnrEkaTQNCMzZxWupBAZCDafBNCmETfi?=
 =?us-ascii?Q?Lg469IpMeF/yZ9UDLXsiJTj8/tvQuOgPygy3SbfuqAvIaBX57GLrTXJ2p+1h?=
 =?us-ascii?Q?+B8hUP9Drpghy7LxqnAwi0BcJBlI7MmMwYFzwN+d0stRIPLJw2Qdoh9tYKY8?=
 =?us-ascii?Q?9vWXMW7VKhZQtLinkpX+PjJncRTaOIxu4k9hsMotWsSCqeGzz/6CR3SXmk2w?=
 =?us-ascii?Q?4STjTpb35FEv02OTwHL86EEqDWFeQffZag8v/l1S5Y7rrM7of5tIKsC7AIbl?=
 =?us-ascii?Q?pfICVb2Rh8DyT6cnynpWf7m0mJdFqgbog43dlO8YZ6XQw4KDhQUFBsQJLGOq?=
 =?us-ascii?Q?vi+KKP/P0wxhbzDapB6xwHbeMV58aMFCfBX2rQr2NSm3o5rgSxn5HXdd3b1e?=
 =?us-ascii?Q?qTm24VYVnbnETu1t73/yalz3PszysIKjJjHxQtczQyKE7CsJDk9idvMg+ztp?=
 =?us-ascii?Q?uY5t71AkENqgv029wpmWW9HzDAexcDH0p/NlJZhz68i/Ri3VzCkZpyqPgWc2?=
 =?us-ascii?Q?3hU5c79bZ4SC+D3aHjpxJJv4JbxYY/QdFz87dtnbAgzfGO2kF5MDJebdQbB4?=
 =?us-ascii?Q?NmhwDHPji6M4EhpY4AY3Xcq1uFdsqY+hvDUdymFhRbeR1aT6tv8fcm2O2PeG?=
 =?us-ascii?Q?mq4lJhCXNT+9iK+qGFROFxDXBq4qHCr+xNwYReOLi47XCob2DBkXbi2otT2t?=
 =?us-ascii?Q?9DPYMPu+KvWl1FJfKDTG0NeE6fbIDsqCB/ZrHDjjPJLwMmUrkWkw2ArmvMns?=
 =?us-ascii?Q?JRYprMu5VGWPMBeFYGTRjNCvZMxPQ4xky7saodyZnvh3u5YsuW1lmSjrSm0f?=
 =?us-ascii?Q?iMujI4KfSMSAXMJ2hzIoUHMqnIsVMz0SOLfX4NaYSaVg4DshwaJhDXRProQk?=
 =?us-ascii?Q?wboA0O+Xr9MstkV+a/ZlouLE6C5pSWRN4Uo/JdAnbMJe583rAMUjqs/LGtIk?=
 =?us-ascii?Q?R29B79Iy8/MmtZSiNof4ET8zWJl0nhWPMmBZTQdO8Ogu9ajPsGKhoEQtQubC?=
 =?us-ascii?Q?aWkHKcdU9pZUwbR+Ge8rzLpGS5fBY7XK0aCoN6NH47w0xrbfiajPcBe0Tp2k?=
 =?us-ascii?Q?jZBEyEClkf0tKxPHU4m2jq1HiGq4ysu5fAGE/6B1gJvyCKOc7W2PZs3hTZ6n?=
 =?us-ascii?Q?I4P2q4GUEkiT1dhZeEZFKtVOB6IrNoZxo+mnQ3u2+DdXHFpoxKwu5GyEbbGB?=
 =?us-ascii?Q?GW1sRPasCTSW4j5Pmg20iHD8ndQgwUhogWghE1gSo0HpWnkoeujHEHUxww8d?=
 =?us-ascii?Q?kM1N7D/EtSQcdGWovzKAfHliHAtBrYDLuagff6mJWaIzAwLwt4hAiAgygMX2?=
 =?us-ascii?Q?G2YyXylT/bHlFWVSKVGjfUmD3OV6rDwrT17rRGDvzAt3p9e8Che8g9WDyHjT?=
 =?us-ascii?Q?sglfbVLCUqfW8NtyzmFAxI4RQNlIFqgnZtDhAAhpt08DQ4i+63BTlSiC+NH8?=
 =?us-ascii?Q?e4HCh+IWXtVxKpuj16VSqzokQvBAh7NDY5TjqIUIucRcuHqxbxtkuZYzSwLQ?=
 =?us-ascii?Q?5RWD1Px5SroTMYe2JqFjSlKpOPbnrEz4StW+Zx6TVGVdO+x0LDFpMOtR8pwt?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OnYvJ0d04h1Tg78ztSYQwv/R1xG33oNuoxoSN5lyZftoqWa/gAiU1//F1ZQ30Wpl3A9QEseSij9ijjVx+NWdXt7cC5wzdeO4jrSvmOMKo5c7BC0rJUaTWl6Ue4g1Le0UX6l9YsQlpJKjHx2JD9FxFiaMKQUugBk9JJ7UVDXKQCsAe/PdY5YIAwEzDQjioOBDzADN5LulM7z2OBt9YwnRUaxdMq5rRJTohQjfcaQffKKEUo8f0gftG7vDEaa8cj5/nroYYu/i7S3Ws4UtD+ItXq2kJ/P8iWN+I2OF8RP8yPoN+bBubcws+RMQ8tJ76Y8DJFCC6UCou3ndjPw7xH6jiXPKg0OTPel+oDE4QskKbPxsf0wMdMCTnTaEbR37U44ddBtoXdyNyrjbsr/o+iJAoekHgIIHDNTEXnnwYcqyM8IKnMuDcPeism6PQ25+k3vsrOU1gD+VULE1iymNT46oHnver6RMiCe4FA4PoLykii/1rcbd38NTploR7UAyVP/G0xvU53+i7DHI+xy2MpWPLwq2BFgq+KG0tGhVFthfpJRDy8MbYhZq1z6wwEpqRytJUjBzlvIpA2MTLea9gC00frmerVIY5YTwLOmh9pgOQNjQCVPVxqJIU/kGs7iMMOLeeJGOoj04/ZF5bK+ieBcK3eZdEgpIqnxdWH2Dl5FhrOB03z7pmBJ5X0HdvFp0sZ88ArMYzE0mhpUwrBgVhqOIT6jDY58bKTs8suQ5ZEsUD+gZmYRZa0IU6Atxu4mZs8Db9zrMmUJ7i4JuY+TJ2PKYHw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76fdf04a-dccc-49ef-43e5-08dbbfc7ea6f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 02:09:15.6750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3NaXbkMosgYfacLBM4NZTre/up/Ajy1YQahKKyZyDdK/+EUuQFR9aI7/gANa6dJH9FuJ3+2NS96uF1mlwMLkKPOe0OSCwgG6dRZpr26C+XU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_17,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309280018
X-Proofpoint-ORIG-GUID: B9Ea5KwENR_tIhyA9a8Ec27Sq1srD87L
X-Proofpoint-GUID: B9Ea5KwENR_tIhyA9a8Ec27Sq1srD87L
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This moves the code from transport_handle_cdb_direct to target_submit and
has iSCSI call target_submit.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target_erl1.c |  2 +-
 drivers/target/iscsi/iscsi_target_tmr.c  |  2 +-
 drivers/target/target_core_transport.c   | 27 +++++++-----------------
 include/target/target_core_fabric.h      |  3 +--
 4 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index f460a66c0e7c..679720021183 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -948,7 +948,7 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
 
 			iscsit_set_unsolicited_dataout(cmd);
 		}
-		return transport_handle_cdb_direct(&cmd->se_cmd);
+		return target_submit(&cmd->se_cmd);
 
 	case ISCSI_OP_NOOP_OUT:
 	case ISCSI_OP_TEXT:
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index afc801f255f5..9c4aa01b6351 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -318,7 +318,7 @@ static int iscsit_task_reassign_complete_read(
 		pr_debug("READ ITT: 0x%08x: t_state: %d never sent to"
 			" transport\n", cmd->init_task_tag,
 			cmd->se_cmd.t_state);
-		transport_handle_cdb_direct(se_cmd);
+		target_submit(se_cmd);
 		return 0;
 	}
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c2ddd09051e8..d78f24c2dfcf 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1576,12 +1576,14 @@ target_cmd_parse_cdb(struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(target_cmd_parse_cdb);
 
-/*
- * Used by fabric module frontends to queue tasks directly.
- * May only be used from process context.
+/**
+ * target_submit - perform final initialization and submit cmd to LIO core
+ * @cmd: command descriptor to submit
+ *
+ * target_submit_prep or something similar must have been called on the cmd,
+ * and this must be called from process context.
  */
-int transport_handle_cdb_direct(
-	struct se_cmd *cmd)
+int target_submit(struct se_cmd *cmd)
 {
 	sense_reason_t ret;
 
@@ -1641,7 +1643,7 @@ int transport_handle_cdb_direct(
 		transport_generic_request_failure(cmd, ret);
 	return 0;
 }
-EXPORT_SYMBOL(transport_handle_cdb_direct);
+EXPORT_SYMBOL_GPL(target_submit);
 
 sense_reason_t
 transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
@@ -1808,19 +1810,6 @@ int target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
 }
 EXPORT_SYMBOL_GPL(target_submit_prep);
 
-/**
- * target_submit - perform final initialization and submit cmd to LIO core
- * @se_cmd: command descriptor to submit
- *
- * target_submit_prep must have been called on the cmd, and this must be
- * called from process context.
- */
-void target_submit(struct se_cmd *se_cmd)
-{
-	transport_handle_cdb_direct(se_cmd);
-}
-EXPORT_SYMBOL_GPL(target_submit);
-
 /**
  * target_submit_cmd - lookup unpacked lun and submit uninitialized se_cmd
  *
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index e5fcfb845529..a808c3c32004 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -175,7 +175,7 @@ int	target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
 		struct scatterlist *sgl, u32 sgl_count,
 		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
 		struct scatterlist *sgl_prot, u32 sgl_prot_count, gfp_t gfp);
-void	target_submit(struct se_cmd *se_cmd);
+int	target_submit(struct se_cmd *se_cmd);
 sense_reason_t transport_lookup_cmd_lun(struct se_cmd *);
 sense_reason_t target_cmd_init_cdb(struct se_cmd *se_cmd, unsigned char *cdb,
 				   gfp_t gfp);
@@ -188,7 +188,6 @@ int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun,
 		void *fabric_tmr_ptr, unsigned char tm_type,
 		gfp_t, u64, int);
-int	transport_handle_cdb_direct(struct se_cmd *);
 sense_reason_t	transport_generic_new_cmd(struct se_cmd *);
 
 void	target_put_cmd_and_wait(struct se_cmd *cmd);
-- 
2.34.1

