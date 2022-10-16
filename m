Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C6FC4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiJPUJ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJPUJZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:09:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBB4E28
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:09:23 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJlr2L004935;
        Sun, 16 Oct 2022 20:09:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Ny4VT0kwLgtNnv1k8vwa3rPPMHTsSpr3Xikt3BRBKkY=;
 b=vQSjiKBK4f49xV5oDt75kw9RWHXCWRETzdyeIl8HNwDtVz7GScARKELbUwKOGGYf9q4f
 9kneKMwupNQaQusQEMNQTjjALqLfCMJ73LrJ91B7f8u1Uj7MXKjE0xJ3Q2nCq3mTmqtt
 5zY3nskskiltmNpg2/31A/nI/3WH3iw6tHIiBH4+prapEpY+9kJO6/q/UXbSpZxFk3Q1
 UnTbaH7oC2fV83pJoxJ+avFiapmgu2vXJOESZ0uwL+OHSkVUe7bsBRQ0zLn7aVRnI6UQ
 3sULIHQC87eQSIQdv8lO8MPbNU06tCIOavWwIDFbWtoraLXfFYlVJDLvTHgHFVu+lDde kA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7h5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:09:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCBkcq029571;
        Sun, 16 Oct 2022 20:00:17 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hr84jf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtKF/8rLQ8rDfhwzfKtO4kdNpU7m4jIx6fpa1RhzOclzbX3pNmtm5H4+kt5fd9Elrx0SVK8/0LacFtGfVQ2uMmrkqAHJWdIN9hvMiN4qQ5q3S7OpmAOxzK0HEGN2LciKsjau9MLIPuTiwYeiY9oKsnnlJeKyqMNL8IhHgdYWmKGDd8Ax5agaMlupxGnbvZeggLbr+Z6rpYpWFkiOxrhyf6kCm3Hoh5pgyIkIQfiWoCpuiRKshzAHyzxg5KuKyuN1XcnyMffXt4qHqCFfoYutP4EdSXEGKVZPTxK8Cob8E6wv6GDGyMAvPCH0ax7vjRY4mkihlUg447h8oHZ+htOh4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ny4VT0kwLgtNnv1k8vwa3rPPMHTsSpr3Xikt3BRBKkY=;
 b=bNxNUKHvLuQJ/I/Rssto3vElOIVuHYL44EZ831MsSGBSbzrC0xvC5mygU0TQf5wEtEJ0cQX/5nwyzZUkYURGOnEHMinv3pulCYKZS+W2pvel+69LSj0dbMSIuJ3sB5/QUB9pMLg+CPMBF/L+udfgi0nbM76nSWaSltummWEAuTHVxglfkaYSUqmz/yFN2FjhioFKALVAXMlQgrs5QJbzY2LvPOHGs+pMnI+moXVd1HplteIxEM77vqIFIVE2+s11npnIfHQ468pfyU/869vV7Y3TLTntVc13ApnMc2JFNHP5J4n/w8xClnxgl5NZuVx/yMHbdabXUuiTCw4lF76c1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ny4VT0kwLgtNnv1k8vwa3rPPMHTsSpr3Xikt3BRBKkY=;
 b=L/pNLh+wklqNjlEiqJRs+E4vpRfA6Ff0IBBTTgdGujkO01WeNl+CHNHuVrqjKKiROaznD1/0bXatYMaZWnOnAtGrXVA8esnLs/0ZtwhKXBZT0ntzjAjqL21nB8op6CsEBGY1A7l5viGttaUrd8/Gd+JIHekWbiTxbTVKyPoGjXU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 17/36] scsi: ufshcd: Convert to scsi_exec_req
Date:   Sun, 16 Oct 2022 14:59:27 -0500
Message-Id: <20221016195946.7613-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0051.namprd07.prod.outlook.com
 (2603:10b6:610:5b::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: 12b4345b-bf81-48b1-81bb-08daafb10b4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HoW7aGnc0z582NialLnPqP/Q59VY2kLEHWIivX5TA56rnUPdMQltORJOXjsUmJ53NJGChj/vWqryu5vi7FCv0YXMWAQQqFDSFslYCkJf7w8U55ci42Pa0+Q2oa31O32U1FknZ8ct4GzfpCjp8pFFOcn1tfjxX1qftqrSBI0lbcoLIVVrE/5HXKGnX3XoUpBApOAkHG4bCl+LIUiZ3jCcbyAvQWeKjA9cEmITINOhtmbmLZWWa38p71Fe80+eMwJutfu/oXOvzqoSBDzQiZ8mKoKzdHFV8L0sxgcboKlYgxzo9eYtnRtY/jr00uoMRc4X3VsjqRKz0Bwj1lMizu+RBHdfwUsbLEAk4C/FjrgkrsJZADlKQxoFJKxHbs12hqLXijT6+HrDfCXOPgyoxyB+nw6Q7kjeYp0p+lPOqOmoFQ6Cf1Z5zrHVUdAQHoDogAQy8byC+QscoUhgGHKpxuIMgxYq4UG4N5ggOekWzbCBLjD1v8PrVCxYCok63gUHRvcqKPtyorAy1XnDcjgbUybURZjk+puriehvGfR74jUZ3nx4XoW+b9h+ubfAC8K+lmoFxv0hTeSRbbYnzj2Xiyza248vc8Y0OkrlirRed2u2teu3jpS2M5Fs+hF4jwrRzQiAFF1ndtfWHqP19gTF0SuQ0ibLaYz/+VnqL/pBqw6jkIGIAsbSHtHgBY9Y1HiJ4Bfs6yo+BT0NweFfZLILntObug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZyvUit9zG9dP5L3gNFw01l4oaKWpiS/r7KyXB6aSG3EShAkG+bgPfSHjvj6K?=
 =?us-ascii?Q?sVgKw7L6vv7Bjc7si/rKlo7Q0ofncAhaxIXrs5SQKkO0YUfFYnbKC0HKbJ7H?=
 =?us-ascii?Q?bGRARADbLBF8eDx6y+7XNQp4I8+PfRuoCYFCGJSTR0gP24hDeBQ5ZlEpuvQi?=
 =?us-ascii?Q?oOCKJ3eAXDIXUizzTrBNfe3opfpr1l+8paQo1yMgdSU/X+VIpW/wbGhNJdH3?=
 =?us-ascii?Q?jCG0u0GWAq0GIvnqrPSSnVUx6GYVkVlBN+XrNyLxiY62IAmriC2IzykDQ+39?=
 =?us-ascii?Q?hvUJ3JF02DXnT0/sZRQMdrpkeT1FtHr5VvCNT1ca5pUKIMhbeSRg2gTwUWZt?=
 =?us-ascii?Q?PI3gsG+GaDZ+pv9mJ7nM+V9mtUcefzKhRVFjMvanKkZ1b9yIpfu3Hm1zJgK5?=
 =?us-ascii?Q?6qARkcKp7oUsx8DSAj8M6g4iZ4Qerbg4oWhVadUR9HNd4ilmKf0D44CC6yAO?=
 =?us-ascii?Q?8N8Mrwhd0gbiHlhsiRNqPkLPA3kmGmLmu7TXz/T9Lr1o2R9DJ024zvmn9wWd?=
 =?us-ascii?Q?KjAGf/u+r7rAcFIx6SWPOEVht0lWXHfTd9pBNiJrsTzahlTLpKdE8AsJ0IHJ?=
 =?us-ascii?Q?5niXCaSmRcrc/rLH0CWlTbV2jfLWGNYKmH0G2gI5lfVySng0yHA6rXPLDIeS?=
 =?us-ascii?Q?5g8g/IHVs1N6ijT5HdK+rGLXu/dDNBE8w1UrvF4XF0HESjJc+1/HuKIyFaWJ?=
 =?us-ascii?Q?OiAu2c3Si29q3KuRTGXdjTQgoLei+ZMzXBSzi4/0OMSEBg2T5bq00P9Qi7oa?=
 =?us-ascii?Q?vHAWOsDyX0nfphRQDV2H4n/H4QhEJAzvv/k+VPX8hv/ws1ajYuaRSFFEevO5?=
 =?us-ascii?Q?iLnMR3zLYQcejdORikx5PQAUXO1391u+t1GChzoKE3mHG8TeEbIjEb3IdACq?=
 =?us-ascii?Q?cGSa3zNGtk///R8Fo5kBy2HlIvp++c9e+NRQpc3OX9xumtYddG4bZ9Fxzk6c?=
 =?us-ascii?Q?N2NdtjFceQR24nfB5JTVcsfOl8c9pXvOazlk+yxLdqMiTq5Fhp21e1XbBoWC?=
 =?us-ascii?Q?qZ8PDY5Tu10vvqyR0+AT6FIUcKBVJsp+AhzdKkJnaAiYeKJuYd2q+PFo3G6H?=
 =?us-ascii?Q?8KDKNRTarCEA3vQy9/jTg5oFcXQfOfBZSnxJpgNcek7lJUdYGzWkYUVPWzlT?=
 =?us-ascii?Q?eKswY6UV/n4/CV697FTVf06r1Ly8H0IT+iRqNs5SMMhc2FU+9LvQuPJjmSJ+?=
 =?us-ascii?Q?adJOq3AY+fLD8Ojmf+cy7T47qq8LZaimzOxT51NxsQk1gZSx4Sn3XcqHe1IE?=
 =?us-ascii?Q?ojsR/je4sFT7Owkjct/9hqQ7Aru1FVy4BC394ePO2jmFpl5NwT9bu7j9m6LV?=
 =?us-ascii?Q?kkGqbY2Tq40oHr/XqMVMsaenYHoWeaxqz6dh9KGkZIEbCL/NCdDbmfBuKuqu?=
 =?us-ascii?Q?OH7FE9aL90215Pvsl0DY9QhXg1EAauu5ZqAs120voN/pp6u4k33V2tSwo7L5?=
 =?us-ascii?Q?Yz1HldSevYjbonhr5mSQZ28PHGpDcIUkbx/Smjj7/FAe9tdEJ4aZywz7PgDN?=
 =?us-ascii?Q?/jRBt3w1D0icv+0r+zQGTPu8Mz1uba74tzx85L4QQDOa/eeWrOSYIN2jp+rH?=
 =?us-ascii?Q?VgzewT8HVvg+EKVpLPY3QyHjJ1n6UTp+qEvLYFGxxuRXTUd0roYbnXGdiR4g?=
 =?us-ascii?Q?UQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12b4345b-bf81-48b1-81bb-08daafb10b4f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:16.1272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v23Q4JVnztipD1qy1fKTFzb1wcJiksATUmLIQYnFYa7kPxFAg6PPOR7dZxdmwaVwrjS6AqO0eSaLju20X+xpkf9EiGEC6N9HewLy/6ksKsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: VRAWK90wqAPw5baa_AaN7DaxvdcDtXvR
X-Proofpoint-GUID: VRAWK90wqAPw5baa_AaN7DaxvdcDtXvR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Acked-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7256e6c43ca6..8ae51ef66b8d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8787,8 +8787,13 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		remaining = deadline - jiffies;
 		if (remaining <= 0)
 			break;
-		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				   remaining / HZ, 0, 0, RQF_PM, NULL);
+		ret = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.sshdr = &sshdr,
+					.timeout = remaining / HZ,
+					.req_flags = RQF_PM }));
 		if (!scsi_status_is_check_condition(ret) ||
 				!scsi_sense_valid(&sshdr) ||
 				sshdr.sense_key != UNIT_ATTENTION)
-- 
2.25.1

