Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40282C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09B9964E57
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhBLH2K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:28:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37192 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbhBLH1t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:27:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7PwOk142740;
        Fri, 12 Feb 2021 07:27:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=vBjYjV6LypMJ3C33QDNu+kzrUouI2yGUbgo7dSVDRUQ=;
 b=eOg/95XOa5maLOI3HYY0zBjGB45FATCGK8rCCqxpFo8uBBDSYu20TDqDgR+JYMdkMvqN
 T2dr9z1lGkb+nHzVfTmT4PUjbGjhxHFEHfqr+CeJpj/nT5opWusVxhrq488NYTlgaC/P
 2RE5zMMVsNN/py9Q6iFR5DRLz1+L2KmqzLc7yMba6Yx3rZ+Tsl6if48TW49Q8ZjhqdO7
 KRss/8Q2L1WUCXHEsY1QPtPr8kv1FFczWBIoX53czEPOGOKNzSy4dLv1NMVUUnM6PXzR
 F094yGBTbmxAscYPOZVW+AEyAtrK+ozfLnHpIKXWgeKH7BEw8p5rLH9GaLg8Ed2FdZLd BQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36m4uq0qm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7OnuO012963;
        Fri, 12 Feb 2021 07:27:00 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by userp3020.oracle.com with ESMTP id 36j4vvcbub-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHsdjsrBSWxeNkcr/KigpBcrpgak01CpYL8sALi1D8/RigfLBwxQN8XbrnM0pkNNA2SA+lY/dcDEJFh9fIhb5C/0mZ8d8HbBnZGxsdSytem8l/3Ylq38bui2pQXu87atNetSRbz+h58ou+seqrI7Tw0gyj6agKSHIGtd7kCJkewcmXS8mIZ/gpByyYrBurkK24qdDEv/fZrOyUPZQ0MbmU/fp/EdHd2qP26gnXmFh3hE7U+FuhBszDBYckZZ3BQJml4C/RUudvFhEha6z2VEBq642HdK+g7PXN9VS7nomahXOAysYeuUayNTawHTqTRfdzK1iVT4b+8eqYi/78eZoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBjYjV6LypMJ3C33QDNu+kzrUouI2yGUbgo7dSVDRUQ=;
 b=bEIPBNWGGUkJyJpCAxapO7TIuuPU6uplJkEmChlxDzQWm4+fOErMVoK+J6kNDlqlHKiyQRKtL29SuVVBZ9/HvHlwaOwq1yg6ogxYgGAgsPuXjt3cYGqJHxWiyMXA9tc8jQyjS2PoNUdHduFIxl8uOKMcBMeeiZnXkKKxmdT+DptkCbZ3xVvyPWsvbb8VqQiLTWe3Z5DbT7XkStKofS2jEtCy+8gGNvtAl4iMXUAITStkYC3OHHg8zUh8b7qSEib7/dtIlQ/JNRoLOKdjNdejXkxULYJZh2bh3s8EUnI5S4k9r5KLA42+0Q2S2M6IgwU8VtH7/gMHDwA6tbU6II5ELA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBjYjV6LypMJ3C33QDNu+kzrUouI2yGUbgo7dSVDRUQ=;
 b=B+dmJ15KhZY5Y8eoiPzAcxr4iTgclGZGkUOL5/1dh4805FX8Iw8nnoOYmj1hf9Qn5mijzJg8X9LCYX2/ikzqQY0ancZzQx0CTPS13EEn/OhSchbhZQatAUJNCZDl5XwVsWiwgiFG1yYWhC5p+N7n2MZ/KC0iJwjg7JfpB4eJJAg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:26:57 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:26:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 05/25] srpt: Convert to new submission API
Date:   Fri, 12 Feb 2021 01:26:22 -0600
Message-Id: <20210212072642.17520-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:26:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13c3db89-9a97-48db-430c-08d8cf279479
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254A96A73D1B2C0B4CA8A7CF18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9G9T63d4p3AlkDFC4ggFw5S/neohV2fquLz+sAEhAVlcANx/DYIy18dFBcBq5D0SJEjPdqOQ45CNOzJcWQOIuf7MkCZgFRXx/Ec81+KoV4faBKggVwaj1ynfcOx1cjoC/c3iWhHHOmvnw6Q9INT65+5yGR60rngv7Qi7RuPuC3Je/DCOOQcHmqu89kXlMCbtdWKqxQzjuqrSvN+kkCTmaCQjWnd6y4HR37g9EOLY94TvYLZgI/r6EMfiVktJ9Pn/i3qDKE6KhXZC5LMjdmT65gpGigGLk296bYZQNl2uNqUlZ1dlmkAqsAudwa3k7BPZ9xRzhrMB6OS5e7nzI1zhKcDEYz4dfAmzBYvYkYyC2DYiBGyra5lCirJyNLRaT0TrQHYjoiEkv9Hh/jW8Y8jQqyagXEMrC8BKbsLypy2XxvUnKTxlMAMqU7KeiKpY905XZS/NOu4yw4P/mbcdHF5ux+tj6/RzkZ+yHcG7lJEI7IKZN3/87qwh/EvPByYZocrcGQuGqTK72HGJNZvkv9UVF3dfs0hxTvQ8qlTYsB1gNxsTQ3+ycxDTBz1gJ9b3zw5VnAP24YaPKKzr+xxFwlUXPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(26005)(956004)(6666004)(54906003)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DsPqbUphN+r5rErralaH9Pm9moNle31uwCp1Dhw3pLZUbce/cvRWk+JgyGaT?=
 =?us-ascii?Q?YTO5+XRk0BSBfFIyPxfRmlIfkSjRYwjBg6xp3mqHi3yicVsaOWPCebGNK9zx?=
 =?us-ascii?Q?MX4NUyCBAvp1ZGKaZpkYzacVnuUhwX6h6TcKXwBR4dijak8eDb5QbiMedErv?=
 =?us-ascii?Q?Bqs1BLOKpn5qcEFNAu4nerFfNgTD3y2Ky+RKwH1doojW176xZTNDBjdx55zD?=
 =?us-ascii?Q?S5zvNIrcTEW4hYZJdM11QRsG6wS/J0PIbS3q9upPnBgRna5/ZURI6bwLxqbu?=
 =?us-ascii?Q?bgvJMhWaXKktp5rHrGsNof6LJyqP08hW1TSn4pks1nDxIR3Awk1KhbfPif1W?=
 =?us-ascii?Q?Tdwf7tBAifz6xATQNsDOGNIpU6SZ9/9HsFJ2iQ2Tfk19LXgvSrat0DsQRmIH?=
 =?us-ascii?Q?6LauH/tDpiDv7Hb3e3sG1zqwFxA1+V+og8zJXEiwPjMqNJ1gTIcGDUyYXjEp?=
 =?us-ascii?Q?wPWmSzCUkHCbM38+5RJTyb6MrzIIEb1rxbzDjiySOAHZkAXRJQx4DX/NPTUc?=
 =?us-ascii?Q?ZAkN15PnE3z6GoOCX73B0fevuOxPFtcOfZzzYt2wzz1FLMHBCBKH/nJMbMBv?=
 =?us-ascii?Q?6oKSy0uvktgsUjXcV6SdpUd5P4++cJRcc+yRXK/NYtPUo80Bi8bWPvPG7e01?=
 =?us-ascii?Q?F6nJt18X6UiZpUG6dF2nqXPhrmXgf7FGNyhRhJF2pVcJlGwr1U4q25CjO9Hv?=
 =?us-ascii?Q?ehCPVRWx3a6352pQQj8nhYGDTvAuS29Nn5/Hyu/3he3AQyu8gJ/Ar00a7FMc?=
 =?us-ascii?Q?encJdCFRrNZsxG6trM2s7ScxrndZSWR3v5Leb9JAP5Yk8cCWV1z5fWVPnu7o?=
 =?us-ascii?Q?VRHufyvbWPkqbIhRcctDSGeL0Wld5JQuQZit0ECZP/yffxyjRqsnaeMeOg1d?=
 =?us-ascii?Q?G0CksH/iFnMyvsYo+YYKgvPL6vHaPm+S4bWR2Zq8IY1U1aE1ItMw0f1h0eXg?=
 =?us-ascii?Q?uCNfWC4QS2LB9HyP/zNU0ogIZIpVgxM28BYkr1viXEuv+z8NLExVnzaIcjui?=
 =?us-ascii?Q?KfCYOutG8J9iyo8YsgcyWZd5bqEwhzYToWZa2qm27JGWswqnH18p6INoXbkC?=
 =?us-ascii?Q?5kLVhuFq5MDREWd2RCFAlkdAFkyavX9/Z7YTowuj6296TOqk3QihOIvQd6Wh?=
 =?us-ascii?Q?OuGIezlvsXGVu5UtiZ+u3cK01TQKB6X4I6UC1bnyFEpVLBbWfCQkOYeGxOVG?=
 =?us-ascii?Q?+lPIf5l9U4UPuf0kwr6DQf/LbD418Qk+IEFfFRDlEFcPxhHSKBzzV5KR/QG3?=
 =?us-ascii?Q?E5jO6AE3LHDSFbUHUiCP+T6pbuTGGtP/occnsrNXrtEn5U8M2ukitpp04Rg7?=
 =?us-ascii?Q?rx1nYbgomkXmZORZtcZkMYKq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13c3db89-9a97-48db-430c-08d8cf279479
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:26:57.7032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T1O9MPl7yFQTM+pceZUEzbdt2inEZKOP5qZlG/JCxsWBPh8FH4mGxpwLbrp7f8HLJAIpNcY30KQE8oEnHT8+oy49iVWNWBg2fwOWCHARZds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls is being removed, so convert srpt to
the new submission API.

srpt uses target_stop_session to sync session shutdown with lio core,
so we use target_init_cmd/target_submit_prep/target_submit, because
target_init_cmd will detect the target_stop_session call and return
an error.

Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6be60aa5ffe2..87741e0b4bca 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1528,16 +1528,19 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		goto busy;
 	}
 
-	rc = target_submit_cmd_map_sgls(cmd, ch->sess, srp_cmd->cdb,
-			       &send_ioctx->sense_data[0],
-			       scsilun_to_int(&srp_cmd->lun), data_len,
-			       TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF,
-			       sg, sg_cnt, NULL, 0, NULL, 0);
+	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
+			     scsilun_to_int(&srp_cmd->lun), data_len,
+			     TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
 	if (rc != 0) {
 		pr_debug("target_submit_cmd() returned %d for tag %#llx\n", rc,
 			 srp_cmd->tag);
 		goto busy;
 	}
+
+	if (target_submit_prep(cmd, srp_cmd->cdb, sg, sg_cnt, NULL, 0, NULL, 0))
+		return;
+
+	target_submit(cmd);
 	return;
 
 busy:
-- 
2.25.1

