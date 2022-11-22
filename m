Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CFFC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiKVDkr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbiKVDkp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:40:45 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F6F27DCB
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:40:44 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM2LTfh003182;
        Tue, 22 Nov 2022 03:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=o96c9B1ORIi5xeS+vGH5gIYW7/shNAE7U5CfPs7wBDE=;
 b=poQlJ6UJ/kKLwDYaWASbzOYRt+BIrx5UffkRs1joLHZvbSr9mGyOH5WkxhRxtmlwJj4D
 2ZfBuJWJEWeOyk0YPvZuM308lj/fHHAh65YcKgjt0s6TnO/PgLZ4No/NavnhM2VaKir+
 IDs0nBkBGeiAsG1bFGIx2qAaCxUa+I1mv0Lc1BPvoUwUu9FWjxsyQ0RzyEK1ndVi24r+
 1ABbkVEqzgtcqpK9g+iAdHRJaNIYptepdwvOE8MFwXahBw1j3Ls6D8sEzbyE1sHqmv6g
 yHBREObtoBKI5ra9aLHz6LugOrwsAZmR7upvez4tj9yHzrNIVHqB6LYGcnkNIR0apNoX Tw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0gas0xya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM3ZkVD039550;
        Tue, 22 Nov 2022 03:40:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkb0yd9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zh7HEFNna+6OdpjxTOrXvyCYpkNgwv0iauEzdIBmBJN4OYIap33rEpFXDyo6pTfaosr225kxLw+r7w9K5yg77sapx8x85ZHkxvl6IhRb3GNEo0+ogE9cdhuoi09dyvy2KtNV1NHAnkZnrh5kVq+DccE5p4ZH8uDNSMrqsyu0LoZKyhB8ctwhGOT3EcYiypTpydcGOLauM3PT/5RlaSLlw3LOFm/a/KrN8QlFbSTqysUMs5CpiuGO3CZa4NPYZoeqvbH5G3oALiBnf2gZXR/jioTAM6WZ5VuuK/y58LEk2/Lm4Gpdiw6rcAARH6CMv4XbcPruee6vF8hjXaXI1HEelA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o96c9B1ORIi5xeS+vGH5gIYW7/shNAE7U5CfPs7wBDE=;
 b=ThQKVjPrhThRKEq02YPQaIh3b5nwrKJRaEEfNWDAsbesXBjs9ZBhcMQQg5kmx1vbkmwI4/ZfARhhYlGn4zd5ViPCZDvOMjfvTomTdPEIv5AV81Q4M+5J/3bpvtDw34YDvz+GiAf5Adpn142XL+/ILqKn3WQNos0r/+ZFifPHCMNnebkptcAUJK5vfeoAWjAhsFc2uj2JDAnv3VAcXOSPvTwrIZ87U3coziIlk8Zk/a5+UJSVROpKDvPEdiW/xa+DYqJcZsDlLGn83Mk4iCm4sIf4PtmchcB6qVaoM/RaL5vu31jxQDbV0zIthke2STWvhmvHVMfPv0I7RDoQCM6lhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o96c9B1ORIi5xeS+vGH5gIYW7/shNAE7U5CfPs7wBDE=;
 b=bmFe4NreaCFLYXBfy0sKPTH8vohdrZn9myWbEPXUuzrlIn/r9jefXdY/biFqW+m1sGpyMqViVzcfOrlg6nGyD27KrFPFrKOF+ZF0U7VgDucx8ncwW/08NkrrpMeeTDvsGu8rCvstEBgB9CGhYbi5j+abAcmF0NjNy01GfOZRIzc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/15] hwmon: drivetemp: Convert to scsi_execute_cmd
Date:   Mon, 21 Nov 2022 21:39:22 -0600
Message-Id: <20221122033934.33797-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0415.namprd03.prod.outlook.com
 (2603:10b6:610:11b::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ed68c79-ac60-47e4-5b24-08dacc3b4d5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/fQavs06H415GNEwMeBRNMNkFhNBsjbiczDW1ijchMeROONZMl4BktCyIZp1DCFZIzwIWcFNb1Eb0TNOTYYeQvvSHM5bdd3t4IXFP9U2R1D21ocubkXOEzV6ENgpF60UPbXdhSilUB+Y7aY2c8Vb7tKp2C9Vvahbcj4nYe6ZvjMEPRScClU0Cs1FZESkbbUNEiHBVmm8jT8XUilCieb61KgXazhURsV5zUzHdwJZs8oUjkYxsuNF/lTty4Hrn3aR3V15Ygp6CyQ/cXWvt9matxWJV3En0cmd6joHj7wLqzb+EU7LvTbj9f20xtNH6M2znaui0lq4XCvEwfU5X9vmsEd8wwPZ0JT6gqZpeoYdlKV15q0Jo2m8TEmHyR6JyEIHI0TSWS0qzm4DceZuKcTq+jvVif3nqxNtlBQYnSQQrhKHzhD/UDXdY1fQunLNbX3GC4fcWPaH2xaeUtHXhOeQaOI3H9DZNdH3Fimb85FlMIVPNPgNpCUVNb5x8TYPcz7NO7/PZvNxHyQUdNLSLZ/DgE13ccdL1uFQprI8xJUYtHnMNa/a2Hz/hemUMO6WgQ6nzVj7M20bYkYNrF50UM7Ka+Eqw6aX4qjNiS2vcQ+Ah5cnJ1Ml0L+ryzdjG2qFjcDEE75uYdhrAxVkqzx7YgJ/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(38100700002)(41300700001)(2906002)(83380400001)(86362001)(66476007)(6486002)(66556008)(8676002)(316002)(66946007)(4326008)(6512007)(186003)(26005)(1076003)(8936002)(478600001)(5660300002)(2616005)(6506007)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?swfLKfaPB1lp8H2ssAVE9hMnqaaBoGL2hOs1zKx1sRKVEQ6SP6KudKGPKyB1?=
 =?us-ascii?Q?EwZZTC5tcqseuJnPEVkKNpeGlKJ6+EgfKbTswpLpQSYTzN/SZ1NR3rsx8UL2?=
 =?us-ascii?Q?9i6NkUn6dluvEF0JqRp99hGL1BpYYjG1wHEtgZYqu0R4H44X30KWsGLaykNh?=
 =?us-ascii?Q?nDA/Bm4kFHYYJeQlUNI1idYO6bgLWrK96E74YQcuC585jozFbnM9SjzOshy5?=
 =?us-ascii?Q?BNeZQm119qbk7WyBbm/NoCoycX+boU56JyVGbCrtw9x2nzooft1mPhcwdjZx?=
 =?us-ascii?Q?B3tMd6CMrgDjgmQV7StyjC5UZXfJJ50Dm0y7ENrfWjEzzXQD5BZByMgpwLK6?=
 =?us-ascii?Q?Z9dewtmNHYANG/Sewnf5CtE5PJnfy2L5sw0+jmLP+/C3wOeuyJQpAGH01hHv?=
 =?us-ascii?Q?GZIf0OdVpH6Ag/4deX3sMbbVfaMwRZHZE18+vBJoN5kE/zqazj7xs+/a3Cgv?=
 =?us-ascii?Q?k2UvxspbrWVichNkVKKMSp5Qy4n//eK/Y4Z4S/oH/oI4l3rXqnUDnyUOC7Xp?=
 =?us-ascii?Q?p0sfXsbGmpWffcGINGhho7hiZeZ/kZRAgMkwlqk9n3HKH3O3jgYn9GpP/hWs?=
 =?us-ascii?Q?u4Lxd16TBp2cuGdC5ojnZBJ+L31G1eqBXAIb5ez7/q58kf8lH9KuOagHU6PN?=
 =?us-ascii?Q?CWF3gGIpNyITWqnimam6DSs6jbANUyXdJCZG6EF4sWLbRxmpLhcQCpGJw/gG?=
 =?us-ascii?Q?RiRKsuwO439f6Z3QEt0FFTCiqeXaDHOR8FRlE0i4g00rGjBsRg/LaVq0Vcoj?=
 =?us-ascii?Q?/rXzlyOcZGqRmDuTsuhLNgZK8pGHwWHB7LeSW2b+JdfrBQeWY/bjP6aUwnnJ?=
 =?us-ascii?Q?a6EJq9HvH5sKuCHA5/SVbHvggX++yRH1UbcE2ZvSGZwmR3h/f1ajLJATbjZT?=
 =?us-ascii?Q?6/eDrTsZugnk3lLU5iwtLFW3sG8iEx87Ix0+OGLT8ylWeOppFxHDzkoYVgiY?=
 =?us-ascii?Q?Imfvrm1j+62oeETvAumFvnShiwMV9NBtp038s2vhChTSgx6oiMXdNKszJVH5?=
 =?us-ascii?Q?Sr2zR867yN+u3ur2F8QOK6epYQqZ4Vw+fnUvh5zAlOIqmmauzT0ksiPbP7KV?=
 =?us-ascii?Q?PMQOUDHuKphTtB4PAyBkP9pW/wkMhnbAka2mTL6RXQWa9H+zXY/g/foZftLy?=
 =?us-ascii?Q?hQamx8AStg49lVcwzeFpudOnVj/sXDQ/IOTUGwzwBcIJiWudBbmWSWTJM/O7?=
 =?us-ascii?Q?/T7acbg4zpKyggA7dSL+fik+TkmAGPbznxgqZF5Dx06fdJJ4WXrGwOQ9NlsY?=
 =?us-ascii?Q?rgfCmtXrWuLTp5YnN7KJMqCsr098L3Pr2Wep24gPyGPwPP+nQFIMsbfCNakn?=
 =?us-ascii?Q?5EjnEKOJyo4H7lHjMAxX4gHqXVyLjyicIC3z2FoCEN84yOS83iMBMP9NMZ1v?=
 =?us-ascii?Q?Q/0LvEC2rz1xyOQvoh4ODvuPTLsJoZAFB7hvV7vXu2rqmYU3bgCiMQijEu/Q?=
 =?us-ascii?Q?MRqvt2w8fRN8P9IZ0AMQaDHjwbr3RNUd3Be7FtbFMzeqivSicCDp4UszT40w?=
 =?us-ascii?Q?Zc/vkLfJB1fUIxf4v1F6ybOKF2ppiZgC95cYsynfSpFSb1nKG6ywUNwel2La?=
 =?us-ascii?Q?SPLF0FfaSlp2Thy1m7fBZsGWju5XrwyJ5MNOPdBP2SHsH7xpNyMyG8YPfooN?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xbdgAlHHSmCvvwtxm1SiPq2ceatzlWm9fQcVI+Pk2QTbm2abT/qFNnLQ1gdnpYFNdg6QVPh4fD9GhQEdI7jtfKljPRyZDPQcU+MpDrNvWIw8CjZJJya3gia7MlZ5GaDQmhafVc3q6MCY0ggQ7QuN5ii0zXmeOcG83xVRwbYZWaaGauPmNJTS/puVGgB0hC/E0ayIzRE2nTnbMVdCUNSOLfwwR3NjXYpB/9J/1TWyKdH4Y/ZBwsK+eZghzH/BL5kgYAodu8hsYSqAf/jklSkLlqzJ/nhUq6/ZZnnUkhzYtQWK0zLuWZRcNAhngcizZKgwC7fOxFluIEIHPltUSk7mWuTxEurkUXURFUaqStLUhk5a9gQVh0jts6tMbZZa4QrY+7S4171CXp/LAi2vlf1c+dbmE/N2pqOnb39BSaOsfTPRw4qfw5HShj9WuY5eAZ3E89US2z/B9dKTPiTT4YBNyDpQ9oOBqSB0riV8cvq/mzcZRizovPmjCtilYvfTlFjcEyaTA0aCPI0mDsxDq2BBd0hSVjcIcCXnCCXfoA+s+MtneC7t1orD5xuiZI3R+pj79z+iB1j+4ilOKF0JQjzyNj7afi1cltjn/hcbI6AFkq/uNoCHIew+kKQOvEaaWlzXAnjoNYhfS+qpSvaa4QP1HCTvFMv9RkaaMpsOiifEoQnCA8d10346+z4OzCOVRbFqH7DxrRXcezOWS3C5hJiv8/wI7LDXtPJ8/Mn35BAq+dG4Xbo1kTAiI9wN/SSBPwyAPDJCALaGqNnuzoAobVoY2uXBlFpVDSjhl+bxnLWTSGKDx0YVwz9t/4cuZrcimqt9Gnv5AQYB7EJrSRPUBfOx5h27J/xtBYN7MvsAvdrZuuN6qwkZdqVNTuxn0diTyJDu
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ed68c79-ac60-47e4-5b24-08dacc3b4d5e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:30.0450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vqN33OC/iYZrz7kor417fDghwEKweylrmnBnF+tV0Scf61H11oTGCaD3slNaFeliGq0nV45SKtbRZwcmqgBhnKxSOeMgFxvbeoN9Rlidaa0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220024
X-Proofpoint-GUID: ublkMOss7RqlGK33P12PWr32TBXMhbql
X-Proofpoint-ORIG-GUID: ublkMOss7RqlGK33P12PWr32TBXMhbql
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert drivetemp to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/hwmon/drivetemp.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 5bac2b0fc7bb..015a16d6b007 100644
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
+	return __scsi_execute_cmd(st->sdev, scsi_cmd, op, st->smartdata,
+				  ATA_SECT_SIZE, HZ, 5, NULL);
 }
 
 static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
-- 
2.25.1

