Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D417DC43217
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiKDXXu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKDXXq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:23:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A6A267
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:23:45 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj8Yu014047;
        Fri, 4 Nov 2022 23:21:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=w6ze2qNHltbPDGym7a+87QbyUKKhBwuwBnx4llIGzf8=;
 b=lFwj2kX3YG7AFv9B1nzpVt4GtwAOTksxgTUjLnP2Zq84KW9IH/7JzVSsQjnyio8JNpCw
 Hfal6L0atRPv7vGPa/tIA/RteujpWPCZzmB2C10K1758vpKPgGDNGAPk3YYwDF+sB3WP
 A4dnNopPtt8oBafRoU0SD8SFKi3+iXJtkRVWpWReekdl8xFgHK1p/vAnR3XRg+3Mc0YA
 qLC9jUgU2CjiiswRSTQwhr+lZvkMh8+eTeWrG7AqwVxo6goYdi+jAC95D1r0LNyBWFWq
 QXXg27E533a6stvKSaW4PpEcXWniZYMSwZH0tO+aIydkJerXBa7PZhHRD3mJq4TfBfLJ 9g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts1hgxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4N8CA2014069;
        Fri, 4 Nov 2022 23:21:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr4t9r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfZcefyO+7IfdRgx48NhBYg7vFzqz1vOToLTHZKqhJqBnaBRtNSkBBg/ClVBv1tMYb/bFgtHeIFVgwT+QNqgYJyo8RfTdisZkac9IRzgOTq9rtk09/aB5xjA4gQcxMPMHKH7knUtCOHXyLl5qpAUSH2sQm61LWmyfCtXJrEBzTlKtN9YKPePHkCb9ZYiiMsYo+T73ixIB5ovEwn5aSTdhZHdqANX4V7IkYAPq5T7H39TBbU+xxdYmorhs4bsHD9cuAaJsY8uTNmsJJ7YmjoDWuGgVwN8qiutxQiLT2p8saoWz82AKof3r1at3aEqJTpzFg5QZyvArDfHOXtauhrsbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w6ze2qNHltbPDGym7a+87QbyUKKhBwuwBnx4llIGzf8=;
 b=TaZHTK7MVqHTbS9JIcdoSlvuE1wl1cQgoO0StsdO/jrb2LhwUeuU3OgZCccEO90hDJe7OiNJG7cxdDAwFWtW06xS/O/iTNRlBfZoN/wnkhJru7NfYx1fFgNq8bbrGexqsdFUes18dATxYMZJpQtHG+RK/U/MzvoVGnSMb9qWR4teu3egRevNEjfuwDe6owY1xAU5RrmA1/lnK+S0f2rQws8zVleSm+recQUzgm8XP9Vbuuiv03FwvUI6zRuM/Io8cecN1eroX+TxDZrxTsR1R2xHI8U7iRMD3Oiq5/gyFGMGTZXmzCv9VRb7xHEK2eYvKIYV7UuUGtN4VnUB91JgCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w6ze2qNHltbPDGym7a+87QbyUKKhBwuwBnx4llIGzf8=;
 b=IdTe93+s1FB9hQNdLxR8sTYcE7v2pflUJVrOndzaPyD3mlYDHziFvAesedYp+wP0Yjn7VroVlfOGsIaJhkPLFADUSWj25Vp7xu1UiA6v4/+VyE5D09L1/oRCEwsRuOCnmu0vLFeI0P7IfaAfei9e7K0F8cuYrAF37syoaBZIcvs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:21:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH v6 06/35] hwmon: drivetemp: Convert to scsi_exec_req
Date:   Fri,  4 Nov 2022 18:18:58 -0500
Message-Id: <20221104231927.9613-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0087.namprd03.prod.outlook.com
 (2603:10b6:610:cc::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 23d814a3-c1d4-4982-0b8c-08dabebb5002
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3OAA/muXzjLkFlRh78l4/ahxKyt9oitf5s6J/Q0fzTtXC/Fv0hQqEQAqhH3o56RWEZJqxjp2ett2eizpS0YwYmwjBn5nKZNIL7Bdj3xnLTP2yxrk3SVVwyRd2ztRTU4bjSz3WLmHp43+VHhbqEjpdD8yNnC4ldzz1IT4C3lcf4rpaLdFRuaGHtglPcdeYJTNtMIhCKI7xFelyPGr69HuuXtR//o0vDAfqgeOsr0SQMKbXBbqG0gwrPk69lhHESUzEe9OlCyASFawilBgQh6uxrxYHAb2fevMicHZKa113nkEjWjVmeq8ZfHXvTIL1V3LAH2Di/VQbSGa5QSSXWLDgvQmDGHf4K0jRYvLcIHxydLU3xXE2vMtrCdOXOrdV95Br3oK7/VxXtj52ONL3jCDFMqdh+afcH7fuPWqBV1u7do4raTT5PsTwxmlywUYGLOGUme0dJ2Q//5mP7eRqR9sGE/sv1uNNSQlFaB0BZr1wcJ2EpBaiXPe4EnHZ+WA7CYbuiqVFVJl8mfNpk0fgqgPezDxPD0iy44eSlVB72zsJdbzTd3SF5Ie7z0wegK3rLiXfjyTqwyH1UqalrZn2/wSKSwmdju0x8XzoNr9UffpWSRLYxSJDJNQx4OCrS6pzV5uGu+5IvTQrxymCOX0Tc/zKp671nsTplITF4JFpK+xDICO85liYX3zZp1N1h/StmrkhULEamo0OsVsoEtDALNeGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(86362001)(478600001)(8676002)(36756003)(186003)(1076003)(2616005)(4326008)(6512007)(26005)(54906003)(6506007)(316002)(2906002)(66946007)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ES9mBI5pNmN4HRTFSQbqYoJUP/7HnLLtXsC9N+TqDAb7ydl9zf63faa9Z2Yi?=
 =?us-ascii?Q?QOzGGRwwBnlsiTDAPx31IUKS2Q7lKqryidSuGJppxlkbasSgboJj6kx7cXKc?=
 =?us-ascii?Q?j4txnMi/ZLTKqwDXh9xW+QEigTrggHZfQ2suS/fTkBd+SOSkKwO5a0Y/sc5n?=
 =?us-ascii?Q?/whQI03WAZhvNSzsFr32Xbfud8Xw6WGTBTtQOYpeoo9ju1ah9fArl+ofWuBb?=
 =?us-ascii?Q?BGAOBN/YQOajzJNH9NPmmiVyQ0Qja94ZmbAAdDTgkW8Rk9T5vse+QqIn+jhb?=
 =?us-ascii?Q?zIhh+ZYHNXW4VND8hf8qSqxbMEhYoCkb6F16aVXZomvBrPbJUF8e5KWGoszr?=
 =?us-ascii?Q?CcEM51extib7PE2Niri47PTDaQ1Hb4Pi3h8BjHPos5GAuhfDbv2dc4VIAUcH?=
 =?us-ascii?Q?VsrLhN0X8BRf6c+8wwjTtI/IkfPv7wqD99RHNZ4dp4jhsdagbsZvSD1L8gEr?=
 =?us-ascii?Q?2AlqObWq0hSZYPPMjaJNcnRPaUfOJqHLpSz7b66YpSg8d8G95y6dgGmCTgsA?=
 =?us-ascii?Q?wDsjZykGeyUujg4mujS6fKz3D1vxVb3fuX+iiTUvggvrry56jwe8NpAgwqBF?=
 =?us-ascii?Q?NV8xdIfUjNr/7aNtbm1bLyBcUrPa6iNgmsytqSSwZyCs9Jtnm0lE/aIP+JZj?=
 =?us-ascii?Q?5KEpwa2dVyBZtOqMuyhwgp9nmoHXRKJcOfq8IKY7c8lqF0b7eXZxp5qR2Qoi?=
 =?us-ascii?Q?3XRigWUTUGGfuggmaKtnOOJ6lYcE6Bv5iWyF28eF4q4m5Z1E8rXRPJV810cA?=
 =?us-ascii?Q?ST68rzEVH+8++be++FvRpe9T2MgEFVCZ6skEG6kUSeN7brcWLdhOuNvbJtMD?=
 =?us-ascii?Q?64gc185md62X+Z7qdeB8Eo4Cn+LFlPam5FjfcwOqEn6BlLJdCS+hUxrEzjSw?=
 =?us-ascii?Q?7nYqmx9bf4um1n1pOZnxSPronIQUhHTdCrtkuRdv5l6eiSbCqsAdtOGPFuLO?=
 =?us-ascii?Q?Y1zwQFarT/nJdwqwOxrB6bUrNuEEWAMXu/vZJfByAfqx4Mm7PgRdNKfNTHjt?=
 =?us-ascii?Q?IqBVC6x9JdwRORsJsKmbDeAnQuFw6Yj9szIb5AVOhNyRkCUMgR+8sW199aGT?=
 =?us-ascii?Q?giVU3l8+UsUQPC7OR68O6wXwSrXpcxLauojFNGhLhldg0HjlnZvchgVo3qGJ?=
 =?us-ascii?Q?j7RwwDVdFQgeg+fVnmTZi9/iSMmGmLq7MaWsmtBcF2181/YJG/GIBIa3Jo2n?=
 =?us-ascii?Q?cGrmiVC3KkPqLB5Ps9K3MGqFIFjYyASxy6+NaOGZXXOZrqhrjkL7sE89Os0e?=
 =?us-ascii?Q?0/CdSUcHiBDP8CaKLK7kJvQmqreex33se97p8YNA7fD01MN4f6NVM2iGfPmz?=
 =?us-ascii?Q?Er+jfXPBg4wEx952i1ZrRstKEFimW406bL5VY42piZRHaAtxo2EfEgMN6II+?=
 =?us-ascii?Q?EfmWx7xVjx31u7kWwLI/LfXdmkU0MyAFGhtnRDOVShSGOeOlWcDKqq2oUa8F?=
 =?us-ascii?Q?ioejjUusDAPepFIxcbH75X1kRXY2mz6lvpe6OZh5BdQUcWOZxkzlEIDuzlaL?=
 =?us-ascii?Q?jo7G6npodnwW4aQAdvKQd4LPZTFW+LiZaF4I6ZbUFeUikxIddvBpjxb/dhTz?=
 =?us-ascii?Q?/lxsWdnP91dpuvjAPkpTzirE2IpOD5I4hU/Og0RFWG/FdzO7vXOBZneVpU9I?=
 =?us-ascii?Q?YA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d814a3-c1d4-4982-0b8c-08dabebb5002
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:33.8069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3FiLXPdcg+MA/D1Eck6GE9XRv5pSFfg6jXO8PM1EWqyQbq5y5X/F+rToMRebS+XMOmz+V71j8VC4Qmajncr26VwfiZm0dStoxDAtUd8/Sp8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211040143
X-Proofpoint-GUID: duA7kDOnNWJtsxhg0Xn1y8S63KtKhRlY
X-Proofpoint-ORIG-GUID: duA7kDOnNWJtsxhg0Xn1y8S63KtKhRlY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/hwmon/drivetemp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 5bac2b0fc7bb..ec208cac9c7f 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -192,9 +192,14 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 	scsi_cmd[12] = lba_high;
 	scsi_cmd[14] = ata_command;
 
-	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
-				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
-				NULL);
+	return scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = st->sdev,
+					.cmd = scsi_cmd,
+					.data_dir = data_dir,
+					.buf = st->smartdata,
+					.buf_len = ATA_SECT_SIZE,
+					.timeout = HZ,
+					.retries = 5 }));
 }
 
 static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
-- 
2.25.1

