Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193F7C48BCD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1C7960FEA
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbhFIDlk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41974 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbhFIDld (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1592fQXY020270
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=IXdz5hHDNm6Es04nsJLwjaVtabeiytPOEdJ5hAYApO8=;
 b=riAWP7WXFaeNUVEdp9QHQq9GZbano3KYPbcyh3Lo356SpXC/obke6WZT8fKcNU76b9Z2
 EDMrrQepUzgurjk0vzq69L3Gzn2VuCS7ZC5+jbT3Cmt9/CaLgBH6HxqC3wigJ7HqsbYE
 bS8SY4CCjKsHNga5pqILCgoKcYU1qP4BIB0DODO1MMYJ0VT1HTxV95ivb+JJgddwjRPP
 NnyM0G3H4qa8MTHSDNLKyFwJZX/XOUWD1GA7CGgF0BsnP/sq7nYU/rayGcFi3y5qYMJx
 rKUBLezeCvcnOuOxl+cKMDs+hdqW4e3T/6q6tYXy/xoB1XwGX3hH313YRMpo5iyob7Do NA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3914qup8ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z3rf082718
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 390k1rhr1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBS3azoqHy80dw6RYbgRJhNxjV6JeTcoQIJE0YmzLwZVE/vprTFU9RHQV+bvlulhfRqpuy0gO2AA+I89g0wDp1dgALf7YHiaYHtxTWXllnesTi9AmNYr2T51rDLYz1OLvl45tlgEFY8asZeQm4oV+ZcIp99YSJbWSTiPVjdB2tZOLTc3EpAWA4szv+XbrWxxEFs4CziFJohlohtjjJ9oWx0SUABBTx/gCQ+mqQjFLGmNetYYJOFXxlXqbrJo96LJiZq7THjq0b1h263nAC1qjX9gnBXLqGIMbASgGVwxWhwas8jK3hc4QONd7iB0A1uy6eLW4rtmP6FJ6in5T/sAqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXdz5hHDNm6Es04nsJLwjaVtabeiytPOEdJ5hAYApO8=;
 b=a2ExwFYtaB8LKknUJoph4tzQ+xJYdm1WHVJpA6uownhL9UjNgAFTeYy63FCZaDLJ+YE93u5P7ZojOKZTazwD4d8YjRXsVCwqqBslgYDlitVMiWuNvoPYn4w7oITQAjpa/uLQ6xQmtmFuppiiozB8OMf1VqMF1Ctq/yOkkAGCb4350Yk4ispPWwP37u2+j7fhTIexcvamxu4IkeUBj57oA86yfRW4OZPzu/tE4adZA8b4CU1cbCN0r6hQg+hdmCKTwzDT9j9gV6qGlHowApxYDHKDCYkL9dWHBuDUcjWH+cFO1l99nDEUZSNzL8gkggRA4OYgD7fInUlSKSlVZrG+eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXdz5hHDNm6Es04nsJLwjaVtabeiytPOEdJ5hAYApO8=;
 b=h38K57xs7RFMApqptNnkRRAW6rz4W4reBBeaSkgQqvX/HEo5AI0/8B1uzIrag5EqmU5p9FXQGlX/HUGKQ7bA1yshHp/SZ9mwmV9222RpOZ5TQinXJE+vketdwGIF3rZpQV6fkNMjgHDO8nsyvms4Va/E77BVgTP7oKm/C0eOgg4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 06/15] scsi: zfcp: Use the proper SCSI midlayer interfaces for PI
Date:   Tue,  8 Jun 2021 23:39:20 -0400
Message-Id: <20210609033929.3815-7-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609033929.3815-1-martin.petersen@oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:806:120::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27a8cc64-2f75-4cc7-bcb4-08d92af83422
X-MS-TrafficTypeDiagnostic: PH0PR10MB4421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB442183B31654FE6716F37DFC8E369@PH0PR10MB4421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xaCgYUjjrETesdlKb05rc/xGtP2QJV3pSywl/AVwLfISnSuHCA5wn/04vqZXvMq+SMzCKyi2UhKDfhLKNq0o8hA/bXvv5gBsHCl8vyB9rRopOkw73sJW9SH9+5DQmhANUvRwpBBZ/7/58pWmG6se8KUgyYYGZIOKdlNy+CogCBhY4VGRnF95GueSc9zQSKKRS+lmx0L/z9RGETb2Tw9FHbyxuHSmvHUU7YTyAx5ax7EAYH+58j+czMwYJZMOAEZRAzHqq6MmFl5yA4H3cKyzd8euBp0Sb+HO/7VHesLfH9KJOak+KoxPcVRXVhEPHxFQn3MmjjIr4jeROb5v2YSJU6oti9zawuIChKh3AYctTrwjxA9l/Dh5ETF2mMwDSHUPdkTkSo33HLBbhmJOSIOd+BtM8frlW+Slipz7vnD0cbJVgDGvS/xZ46f6hdS1YueeO5CfU1vLrfTpawtlP0U3KGERTo1EqbumDTRA4m8pg7gaxNh427JhQzQ9gcnZiqQoI86a9Vy4gzoaAfyhIR0fAVqG3sURzJnBnK3N021Bz5TrW/lN9Nr7GovKzdxkOgwj0FmtVGOo687UQpbIQduVSqhiYpF8eD75ViXuWlPT9+5k883TM/Bl6HNP1slgXrdMvwA++kB3faR1DttBL3Mhgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(8676002)(956004)(2616005)(8936002)(2906002)(6486002)(107886003)(4744005)(86362001)(66946007)(52116002)(16526019)(66556008)(6666004)(66476007)(6916009)(83380400001)(478600001)(26005)(186003)(38100700002)(7696005)(38350700002)(1076003)(5660300002)(36756003)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M30FYvX6jjvdwWF+hENNoeQUHSufg/Y8JTnzUlJMvnUgf6XzNPDu2hz8EzPA?=
 =?us-ascii?Q?Z72wgg2NGXlxrQBddMFEXgIgx+geTe6TrMXsUoOqnzZm9I8vFxevsD326+eZ?=
 =?us-ascii?Q?NC+lBbNctNgAFyuop9SCaLbNLl/t42gXlO1ubbbw8plB+PZHzQmnWGDV/MKr?=
 =?us-ascii?Q?FHKcutLUV7nXp1HWqFloTtSfpo4FamE4p2rCCfHpSsElKq99ngnIP+ZlexVR?=
 =?us-ascii?Q?f4qF9rqdrUtPqd+DbGBgBJDA6VucaAXIqRJLviHHaOFVhCtLEGmc/uAM1D4I?=
 =?us-ascii?Q?wND3efOFFQZoL/R+rT1T6Ggct/QUgWBzJa6Islfm7eI17WnGYa1nnKQJtWp4?=
 =?us-ascii?Q?KbRExSsFEHDCY6DCcVJjPRxXAyAB0Z4KbJUSp4R3oO8oJ5DrIJAiT/FMQzi2?=
 =?us-ascii?Q?PzQbmdFV+c/D+0drcH+QO02t1wtnxKQv0v8F3zciIj+1VzcWsPHljBwPas6y?=
 =?us-ascii?Q?WdyRCNdKXtsK4vxymln0mSc0lMsEKY0z3srGaXeInrLQL9zVLjjXX9aKElu0?=
 =?us-ascii?Q?Cwkh+WiUAzz41RlAlGr48wKytevaukbyFDSip4PdpxZSIAw0y0RstrS3bGd1?=
 =?us-ascii?Q?0Om3d17TTNqLndo4z4qYVxzyHZ9Wkh1MzvDpIOVrT4dmQZeEPfZpDswdfEuC?=
 =?us-ascii?Q?r7OhOzsHiX7RK+hKWdEqS3MNGF8ZG3RY6lDq2t2S8mdRWM8y5OUlwx8o3gTK?=
 =?us-ascii?Q?n9IAJi/CgpqJVXr2/4T4We2QGNJoW9TMW6cuc9rrgmbUhWI1UM4xXhL6WL1g?=
 =?us-ascii?Q?jd4JffxD8ca1PgzTNjCeZQTtqT/WXi2eS/71jtOuILvQY/ylldlFYy1/zg2g?=
 =?us-ascii?Q?zGnC2scjwAXZgqtLlSWfTKn8q2YGL6H30dZKr4iIOiwJOB/SUbUpzNVzxQbN?=
 =?us-ascii?Q?j4K5E1wYOnr6cdiFBQF1xBTLhrtDDjAknwP4OZTltUgjOVP81/kENgUExc24?=
 =?us-ascii?Q?IwrALV3jJQy3Wn+PFc22kNPJrP+NLHYttx8wqR2ezvUCS5WE9Tm9aHnj8NTV?=
 =?us-ascii?Q?5S6P5tRiq4djZCwgvtY4H0955M1sIS708azgbms8uWgBhcmO1za05q7AsMnA?=
 =?us-ascii?Q?2AiaIEQ4EG5R+yq6RixytA5OMQw4791bVN9LL1g3nGBG+8GoRQhkn/La4FW2?=
 =?us-ascii?Q?LQIv2b7xjYg2VuVmp1n8bQj8UJOTZQQFSN0h3c0dvJfDFHwwy31aTYIu4stU?=
 =?us-ascii?Q?NIJ0j1/w7fkojYhC8cwHK5pcd7udt3AQcoyomv+5bppOP7NroKiYqLnlXa0+?=
 =?us-ascii?Q?HKPhQuCSTcae3F8RiQJizJdorkUER+muhb2zLaOlhR6OGYg36/IXqH2Yj/MF?=
 =?us-ascii?Q?IKwv7mMB9hR56x/N7BgmciXH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a8cc64-2f75-4cc7-bcb4-08d92af83422
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:36.7162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6hOyWW2VDZSDesX26LfHQFKunGzJ5qDns62K6tTvkTzB97mAhzEaZo32lTGPUNlOdRLigyXFy3OsE82PKgtDKoGBwSRJ2/BTmUzhBOi3WN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-ORIG-GUID: 9VpiXhVNuzbdTJrN4GJzKL8cv5Gak32M
X-Proofpoint-GUID: 9VpiXhVNuzbdTJrN4GJzKL8cv5Gak32M
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_prot_ref_tag() and scsi_prot_interval() instead
scsi_get_lba() and sector_size.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 2e4804ef2fb9..1990216cf289 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2599,8 +2599,8 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 	io->fcp_cmnd_length = FCP_CMND_LEN;
 
 	if (scsi_get_prot_op(scsi_cmnd) != SCSI_PROT_NORMAL) {
-		io->data_block_length = scsi_cmnd->device->sector_size;
-		io->ref_tag_value = scsi_get_lba(scsi_cmnd) & 0xFFFFFFFF;
+		io->data_block_length = scsi_prot_interval(scsi_cmnd);
+		io->ref_tag_value = scsi_prot_ref_tag(scsi_cmnd);
 	}
 
 	if (zfcp_fsf_set_data_dir(scsi_cmnd, &io->data_direction))
-- 
2.31.1

