Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE22C4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjKNBiU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjKNBiM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:38:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2B01BC
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:38:09 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNsDm0000855;
        Tue, 14 Nov 2023 01:38:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=94JLefK/6DJ2NlT2IQT0LYlfk1Gea7MNrYbFixqFQMY=;
 b=yQh3wQ7/fojH6zge6+lMXFfISGgc8oZSkE0LZnvPdcGi6ymny8zOW7o8jQlxNuIkq+WT
 bOBWvnIyRcoTmUV15KhXp/0U5CLe76jADfRIG9pEzVMeRzjG4nVEeBL5ckpEKdlHgNJx
 Sru3cEMfP7JwssM00ix/kubliGmAqZz4QPuFEUzNJrO1SoAB/JKG4g5JeaUMv7sorJ9K
 e8zhdQwCOTYOLIg/fLT+zGpN3QfErX9NlYfz0VEdbwZS4Aes9kmtayU/c3dFdCVZqcrk
 eoqrWltLZyGokDA83OSZZyFjfMwyk7MWsr9XIhrCMY+Im0pBYnQxpnYfATChES50Sg+7 3Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2qd44ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:01 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE1ECRV029776;
        Tue, 14 Nov 2023 01:38:00 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxqqsc4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+JU0A8nCA88bXWRQEjDbtC7M2IoRRFDqwzny58zDc6joyWYrqxt8MKwEJqXwTg3R4cgm36MtdKVOSjvwoFPMys/GKPBLL0euMqjdbMW5BtTRBPHlDJ/g5YNvl8rUJwNmN2tuDrov1X4JIOqxX9C0BJQWGB3bWt52qXS6aq2ZauYwO0+DstwK/w7eQkjdWroa+7k30lJNW6WtLWrVO0XyiKtMVYCPO5GxWp6jsn/sO6SPyOGIQ/RdBFbrD0lPjnDd5vnGlSQ8tRPtwgdSnpkSUAe8jBYT6wARWvrd+OTcH+WushIUhwIBEBb0AF9VYXwQN79VjdhzzRruYu/y/nLmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94JLefK/6DJ2NlT2IQT0LYlfk1Gea7MNrYbFixqFQMY=;
 b=kY5eWaCZL53I3cbCwX7A+ub7EDhE3Zy1IAFfOTfyUa/trjthajVnR3RWYE5uX9c7tU9bcbbpzHty5acXpDjO2nKsifeYOZ2RjTFrjb2A0m/syFQyjhwtN9T5EqwhmBLm35P0IzTTGNYkDpHZCZCdauOBT4/mtIPS1R+e2lriy/Obd8s6vM5I0ZDnf705SdGmpBOJoTy7S/LrHQ50UdPJN+faEl+FbvvJSJWQ+r1/9P2V8mi0nCUx1tDUG94zB5bKQDOTHMj+Ulpovt85SwuyW469e+5gUIQu1Xbtz4G9zHGhLfKH4oz89/9zE/pdPQyOFcRo1EnzHOyofxa1BywgZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94JLefK/6DJ2NlT2IQT0LYlfk1Gea7MNrYbFixqFQMY=;
 b=XuOo8J6n+epxoAaFij9MNDVVs5kBz5r2gdOgEkbIvimm1js0hGSTM3RNpaAQ6rhiqxSg4CjU9jD2B7sV7SWBVMB0iS8zjEhzl05IW2F28MJ2dZ3TErfFaPbj6g/WemWrGC2HDZBPoeKc1VIJD4o7F9tRzBlsRE/PYUXL8LQQxp8=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:37:59 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:37:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 05/20] scsi: Use separate buf for START_STOP in sd_spinup_disk
Date:   Mon, 13 Nov 2023 19:37:35 -0600
Message-Id: <20231114013750.76609-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0050.namprd05.prod.outlook.com (2603:10b6:8:2f::9)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 28e16c9c-30aa-4054-9d14-08dbe4b25537
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wDEwIOMJ2zV9W+GTx9rj+VfkYMxFyVlFzX9dSTFq+t+gdA2Gm8irX8VsiqefznXwIyvgIZVq7/W3F541cPO4l/Lzk9CF7Fangn8IsBT4ku1SPC71wQtVmdbfBkHnY6Tmk1ShTdTlFglJ9Fmi1BrenPBWyLYE0p9JK8tD3VR/6Ev7oZAPHqFy24ztCMP0VSM/co8WHUaTTO6UzHfEdiYgdAI60XpW8rm6j9cBU3FKiXYhmZK1dBCt1UQglPY+1RuX1C9wwqDqgofzys7Qz3ZZx9SsT4XTGX2FPutwfI4UW8uHLS+ySCZK6aHvCwN3b4N3i32M9Fz3hD+A4Z09uXdFjdbSWXcASx3iNAC4qN0Ggv/teQmmK1fTJXOS1yn7rresfyTjC6dAyAjVqIz8zCcIE3ZG2ZPlZVEVtESLG+sNg3XWvdnInvaf1YqGY5eWUDbO4c+jcaC5lQLix+povg368t4VtaVHQTcocIoJmWYRkbc5ht2RLOZpEDHS6WTWilSrzcmjWC81qDjjlkV7+JktICNJQ7FvMCvzkIfw8zluIRW1r96vO7WfTaPweV28AEHW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IY5TXhhN+KfnszIr5SPdSuif9YqO2s2JZ054w1sBi81vLxcueK0rJLQM0X4O?=
 =?us-ascii?Q?A9qwnGuRMFjHTQ2YKNb/zjcvizxaIJeO6t4E1aaBXuRlpcG9YIgWQbntHVLP?=
 =?us-ascii?Q?Ws3DAk1eEsDpXzTuindpasw++BjaH+H/lNpwr2sZMjQ3BudJ1/Lgb4oEQkEu?=
 =?us-ascii?Q?xS7O2+4ndI+dA1AjK2Pg1jhN5gvcRmTwwcqIXTMiyOqcpVKByys/gGKIUiMz?=
 =?us-ascii?Q?P/alVZzTVXHOw/BJ9IgGYg92mCOq9Vg1RG7bCrZRPQNOCMUNQam/VbGCljk4?=
 =?us-ascii?Q?JnGYRIUGBJGJCH05qd/ZgOJs0yF78nDY4tSJ/XwrtNnB3CAQZucbFNKOkz/1?=
 =?us-ascii?Q?GsuOMWDtFrCDJ/F4P255tP4y9xxhv/+6+Ul6kfP2ornH/RWlHhb712ZU6v/q?=
 =?us-ascii?Q?nlUkFN7m/8kXlXTsedEPwuMsEtKU8CLbM0/8iCupYoP3ObqA1Ez0kmaUYCT5?=
 =?us-ascii?Q?ClohTLWKiHjIgf9ps91CyYfmM2kSq+VdXl8ZSjQwIdJ9jtEd/uLUuBE4KK1W?=
 =?us-ascii?Q?YrDUgR8dl4UGIBAW/u4be9/DhEfOvSd7ixVSduAN1dY2VhUvWppPBTzxmDTX?=
 =?us-ascii?Q?bRaZlfwWwXaRoAB2BvZy+VT+D54vmrojrKR5qgWgM0p5W/tUOlVK+M5Vt6Cs?=
 =?us-ascii?Q?jrYI47iqZjUivJTKGPBkCLXw8RCghuvcRwjjvBWs04KEqSFq3jEdJjaA/jG0?=
 =?us-ascii?Q?rk/Eft65YcC8NSSpXcnSUwScPzM+lLWINWNJM/p7EFIAVT8hqOQ4g/QSfopI?=
 =?us-ascii?Q?iPM7JrItxoWx2dIR/PG16Wl/MTbTXfv6v75OwFCDS0ehAApNkTEl/8wbzs3F?=
 =?us-ascii?Q?XnBMgKhBMlxPeSekNoK/qmvUMk7Z+BAJnJ+Y0YRk8sRFhxs4Vo2pEKiWOzCo?=
 =?us-ascii?Q?MASLD/I9XVIXHdjmPqNfX2B/3UY2qvUPLMJsFB5Nf2J8WywsYNcELKCi9sen?=
 =?us-ascii?Q?s/2pOu1yUE5yXxl4jt02XfyR3RyCUTN16zC3hz2ke7G8HTnCBNdVCnYngP6x?=
 =?us-ascii?Q?7b+OO80gwIvEq+rmGQuurexD4XcJ20eBeIr2rXa9Zkrcx1RsjbK5MAJCb5+4?=
 =?us-ascii?Q?4NdR7GRs4eXdbTCpAxbby4iJNgOYZsOB823Ot17y0ZQK0Nbieye8ZPPsOwe8?=
 =?us-ascii?Q?qvB92hwkW9GT73j/x8EeLiml6G7X3eo6H7861IcTJ8KxnUYjZGudpCTsXFdY?=
 =?us-ascii?Q?tqxerH2+PLRozJJhz6e+xHMxmMOlY9PkiNryyYqzNN+jIC32Ysy+zaDtfXhn?=
 =?us-ascii?Q?qX1phoq2nzxqoAZ6j+NQhAjOiS8QjR8jTVEYdjeuRiND5h993QJ1xYeJGbuS?=
 =?us-ascii?Q?TobHk273qtpKAMWfvNKSm8715EaDluOEKaA8yyltalDwKTkS6y4cYgfESpHr?=
 =?us-ascii?Q?ThMTqoSfXvqZ9YslmG5/rQChLgp80oIMOMsmXmdefe4g5CHemGMOc3wNIYc0?=
 =?us-ascii?Q?ppWW5q/6kPzlRuRSaYOg3LQkQHXIf6+nL/9O2X838L3bEl4BzBVWgnnXvUQe?=
 =?us-ascii?Q?BD5d30TAbGSfDfJWXiAvXa22c0n9ycWaCCllNqixnfe6FdKCJSM0/sCvSbxE?=
 =?us-ascii?Q?l3wSMrLxBFFzM2xO1PBEQfDbMyAhydtujHPdFnkgkTRvGJO8rFKbAJHsPMRN?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ygcDd0eniZdN4GHKrXqPY0YlvdD4RfaWuX33etCxFrlGNpFDqBVg7xuIoaS/rf5dSxVMcKxD/cRR4SuGD10PTm/hpOj/WGf6mYC5aPdAl1DbgHOjE/dlFNcfS3Uq+wG9YbSyiL361bpR+mCT350845AjAMz0BgwrguRx+AFh8HGeUXX+B4SBDuaaum/MB/pxahYToZhv9x4jaxO/i/DXT/IBmqBPrZyZ9kLo5yze/rk9U0NcE0ZeNFY9MOC2G9DniXAkxb19R+WbkmSzYNlnqxmnZWtC8hMORxvMGOoMq1qdztrWrFnK56t3MoXmaPR6/fPYxcikWpaBMLRkEAAAYTwca4pGb9jPumFh8czyTxyge7VG387F8/BBXPye1cweouROdOUVSj6jyJ6k47OIGeVJ6gNZ//NLzat+CvnzrUrhqD5pXKRW7bCku63VNNow9FHviM6VdvOa0Mvb0lDP9r0xZXCPdnYhvxLQ5iRcsHeV+zqFk2mGYiR0QCLzYLiqfTY93Cyl28XbDyXJ2HDzM3rypmE7+qsLOlPm7hkZL67DcfvbLZTAP5YY0u1WEfCxd8s8sUtS8UC5v8tZtGkJH+F+NkhlO7A6EvNJqz32i2mwk5AvEPo8sdzE9WpCOrnitYvRnaf9ZzWeIezk7MX76HBKolawm+JITJ7pGzCX5UyfSftgNvAORdJ6f9/UJZiDB245bjS++FKkQjBF3+lzVppEPwIoteyGK0ky91xh0d6eWWFqQkRJrtcAYOTmS3fI9DQ1mWfhmulm/wLdl2uIkLf0/TZO5DiJ1bcqTCeWaVUQ5YrYG6x3ONa4Za6rcJMm4mrpMPFtCHq9UjO12VK9W0uX97hSGtE5T1N9jbANwbYOm3sDlTp2DAwX/ZggwGZ3
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28e16c9c-30aa-4054-9d14-08dbe4b25537
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:37:58.8888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qb9LyzmFzKO+29cxAmbmXqW1Ormtla71R7LpiJL2451blpg1CwssgA0LyKnVDFtl3NIWzpPMO394Vz9htSDyzcyIcL0Xrfdg61kBfg1Tn8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311140010
X-Proofpoint-ORIG-GUID: IfGD5Xm-dsJWqIXXFyHOwMizZRwBb6fy
X-Proofpoint-GUID: IfGD5Xm-dsJWqIXXFyHOwMizZRwBb6fy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently re-use the cmd buffer for the TUR and START_STOP commands
which requires us to reset the buffer when retrying. This has us use
separate buffers for the 2 commands so we can make them const and I think
it makes it easier to handle for retries but does not add too much extra
to the stack use.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1af04b01e1df..641f9c9c0674 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2318,14 +2318,16 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * Issue command to spin up drive when not ready
 			 */
 			if (!spintime) {
+				/* Return immediately and start spin cycle */
+				const u8 start_cmd[10] = {
+					[0] = START_STOP,
+					[1] = 1,
+					[4] = sdkp->device->start_stop_pwr_cond ?
+						0x11 : 1,
+				};
+
 				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
-				cmd[0] = START_STOP;
-				cmd[1] = 1;	/* Return immediately */
-				memset((void *) &cmd[2], 0, 8);
-				cmd[4] = 1;	/* Start spin cycle */
-				if (sdkp->device->start_stop_pwr_cond)
-					cmd[4] |= 1 << 4;
-				scsi_execute_cmd(sdkp->device, cmd,
+				scsi_execute_cmd(sdkp->device, start_cmd,
 						 REQ_OP_DRV_IN, NULL, 0,
 						 SD_TIMEOUT, sdkp->max_retries,
 						 &exec_args);
-- 
2.34.1

