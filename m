Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D00C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1AB661263
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbhFIDls (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44746 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236538AbhFIDlj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1593C914147476
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ASIcYKM2snx67b8AE5XDXbZBb7vWyRvLgJiSNPLlz+4=;
 b=XObSlaUynGe2eHrzz+0xgwNW+5FYscoxGuepC13avxG5yQBkJ89tIAAIRHAQ8N2SKEWz
 iU4T7WD/crlD09IyrIRxtanSjnkmxT9+y30Wbn9ab7L3vWi7Vf+X/YDn1yyZdO7abbp2
 Anju/LBlexcfw5j0h11RvyZm8WZxMp9LVxXKr7yxTot/2A5A2Ede1WA2H1O5el0h7VSd
 7E/3JdgEutjjdqBgmQ+wf0eFYF/LI773wDSAplaB3zO37QUiUhijDyKseWOdtf8jcwTw
 MDRj8L31o1ESnR9Tuy0wYukkzmMWDyh30VEbp2WWg0ZzqChjHM+ARuJ7rNaajDgrzb/F 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 39017nfrdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z2Ps082696
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:44 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 390k1rhr2k-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2chyyt3X07Z5llxHjhKIjghYKX2LvX8OdHlIwUP4043BBpfWI+eJJ8GVfFhdyQDbxw2IcQXOr9qMvBUAwtP3Q/HmGRK2w7FWJ2gOHqBzqNu5KoSvu0tcR2vDgmwvxBt1TG9AP9MRyaMoF+3IBI6UGDYHwARJOC1xvU1O5RgdRzduJ7mgmiM4R/qn8IWUG8x3USPzgEunOxI0pbC/6D7pxb8H887x6/SRgWJanYuKyxLjDZ5ZN6bNMpbKzM7vkiPKOxtDUIpVgkBt3v/2flgnoL3NrHWLKfg+NVBbHkybBA5wLQblzYQ0GoHpWDzt0Q5HC+1S3N9iNmLcccNzkrf5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASIcYKM2snx67b8AE5XDXbZBb7vWyRvLgJiSNPLlz+4=;
 b=bIDk+GkOOL52tCYtmIlMZg4o7+TIe17ZGbrr06v86r8EE5cAHpLJY7N26VtiGxzHE6iqh5g1dl5VFteT9EC/pcCt735OxnuwRZ9XiMWwAeK3yhIRJO74fdmk9BBcssbA+TXBhr7eAnYs9DRS1ONmzi8+U1Lf+t5ZInMWhFQm0PLc6VV/0KhaOLSHLOBTqK0M77Htbh8KTPB+TeLXjyng4FQ/fscSfkC6dL6NTIbGBLr1FuN9JszpYFhptCPj7bQb53YZRvkrSDYxiW/H0u6GqfMC+XDr4nAlltN941qSTHDYCUswfKzbuC0KXRcq6248NE0EwxdjRHCo1jxpnphGhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASIcYKM2snx67b8AE5XDXbZBb7vWyRvLgJiSNPLlz+4=;
 b=jsZZV7QDoyyPZYP6klW069CcSi04KXuNWtkTewmKyGWPA7UkjSRDYtDpqZtPoPafa//26iV9C0bBm3P58eug4qy1+NFS3eho1L390b5nvMupqhC8mZ/XZV3hyUvXD5Au+EVckmdVMPYRYYzFh/+wrEWyC0JXWo1xpUvdW3U8r78=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 13/15] scsi: core: Add helper to return number of logical blocks in a request
Date:   Tue,  8 Jun 2021 23:39:27 -0400
Message-Id: <20210609033929.3815-14-martin.petersen@oracle.com>
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
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49facd89-b9f0-4ced-206e-08d92af8387e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4421538AB9D993162D9239C58E369@PH0PR10MB4421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:561;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Tb+fqdhxFwJb6iR1kcLJcOAxo4Jezb6Pbhs1jZ5QsGxde+ZojgsA69ZOhXsRH5HgYGBWxqRLXltsUZEOGqde4ukavQXQqmv71vkyCg6Q9VhaHL21YGur9/diKemkQiWLG0AHRu72KDSPcMlGb+fLTzhMynbe3PLuJT70KhJHVByFo/SPCpyHluih+tCq50J+h17a81fDd+UB0+nC/+imxW/QSpLjBousKvwd5/JbK4XVxp5D9GDzgVnzGP8TmhetCpFdaXrSvfCoC24wFHea5p4/g3LgZjgoWgWrdFWQ35vRC7DNZqIUpWM1p32aXmw7zLJO41TUzwGajf8cA8Cbux2ZcMeNPqehbnqg0HvzkBDUK8epNcPLieXF30y9e7hHw7kjkK/PQ+p+G6U61py0OEnKPD9GC3C9IhGuc8UL081udiD/HYglDFsBVLIhKmVgzX5vEcK7EOZXvSOZ29zRCVFOa0Am0xn6RihzW4lAXcmBaJuLAvvGaPKY6eFPMKDBUwlj5cAMWjIlDxX541vEsPJDwJFIu9LdG47rSWTm84piN/SEX7CekBhMf03ybmYTaEL0zlSzymEBhdD3qf7Nq8hDC0PuvkDO3siTjGqVXjiqKQWTG8mVx8uLvqAnLVjnF20NeJqSU8WsnCOJKrqaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(8676002)(956004)(2616005)(8936002)(2906002)(6486002)(107886003)(4744005)(86362001)(66946007)(52116002)(16526019)(66556008)(6666004)(66476007)(6916009)(83380400001)(478600001)(26005)(186003)(38100700002)(7696005)(38350700002)(1076003)(5660300002)(36756003)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GGkW06hPaHlJthn67IGfPxak1XApLbLcYb4y8BXip197s7Xmccv499tKWOPr?=
 =?us-ascii?Q?ZE9dCTz2CZ2t0eZuOZJ14dUDRghsXf4InEwionCZUZFuM3B7vp3+GvqBx0If?=
 =?us-ascii?Q?HMXpJi8uQMbIJRf7eNKgviHSAXXOZMVlIPIbUjoFhYSsV22NeINZPnVZsYnn?=
 =?us-ascii?Q?bknY/cTGGPXyYTUdpqgQRKk5uqKZ5FH5xIePoXQ/KLjQLJWz7LKX1d2iFYHT?=
 =?us-ascii?Q?vs65jxV58AyJhwRQtlDLP+LJnnF9WlxlT3UYsovv4iAQfErgwcSiBwhIzfDJ?=
 =?us-ascii?Q?+hy/eYS/291+AuLdndzJH1IW/lAVe2iNtoNY/LXg/U5IZ09Mf9i0rLDByzqZ?=
 =?us-ascii?Q?P5kpqDIfDmcSJ1v720stPwftuU4FiI+gHnpVpp/rea1hfD+RZBVeG2dgPx8v?=
 =?us-ascii?Q?C9lW7GBID/y2m1XQV2nb0foarnhWQikh9l9aUJ8iFXiIPk5t2RMrNHQqlD1z?=
 =?us-ascii?Q?A4g1+R1pK6EW2ycpKjSYtxgfB7Gh70O7uWXGa8F3xf+quh+DDSJPnwLciWhW?=
 =?us-ascii?Q?jzSEh/TWGZ6csVamrmjhcdpdRvUaete189As/FrYk7RABuNOzOAAmpZhNAkc?=
 =?us-ascii?Q?wELvXfvzqTLzfvbkLEj9LDpUTYTnzXTjpbzPb2PZj3wXbSlQbjxNf3pCotAh?=
 =?us-ascii?Q?zx0DQOzAfPNM5o7LoE4ks/qK/G0w1YvpyPth5Lgyjd61FcE9yS3NKl3tqleb?=
 =?us-ascii?Q?fWozvHWsRWrQS6TzGLFaAJsTJ93ldrMyj64UI9/ynN4Tozc4x08cTwH81iMg?=
 =?us-ascii?Q?XhqW4ShHraSkKgLiqD31c3PJgFavPaXn5dmChWcqXtDs/BMQj7UDj+qyM7/6?=
 =?us-ascii?Q?P+KncJbFtkaMu401bFZbZkqAcyTP4bihj/e845v5fI9UTzSxcGeEOB1xen0S?=
 =?us-ascii?Q?cCh7PZeEZA+/mgJSIBqAJ9V26BNzDQ1V4Vc/3+y4aPnfMJv4eTp1uShFM5Fr?=
 =?us-ascii?Q?5lQ7b59Vhk9zet+IkVGUgWhHEqBr1PJv/OxYKcDqkK+I7BaJTX9HVHksppOS?=
 =?us-ascii?Q?8roPeg/J1XV6dA159CLdBFMBH0uenB8bomjjPhgi//lUEA98CXie3UvZMkeW?=
 =?us-ascii?Q?bCYhZdAY2tDhHrqQQSbXXxWHnqsBjRuhaNLOTQqAZwkZLgVYBKSM+teSn1B7?=
 =?us-ascii?Q?E1Fsl3+FDQ/Muh0N/19LjsGNWDYg9BG6Aah6DFLHa5bklyQH3MbnSC1wBPY7?=
 =?us-ascii?Q?oyNDIWAGUPovkw3Lzl/MTs9JXStIHsLSi82rYIOJTCEeYE43ksA1Las2Lu4u?=
 =?us-ascii?Q?pXuXSjzWig2EviC++fCfYJhHq8LHHWTXBnv5YcNIlDw31+BeYNDzKgqDq6CV?=
 =?us-ascii?Q?UZQvvxyZ9kSkgTHm0dxdMbHn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49facd89-b9f0-4ced-206e-08d92af8387e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:44.0350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KXKXfao1FvuZCqvbl0ZR3AvtO9agADTwGkcljoJQLJBuvvVWagz6zAf4ZwZaXcRY0NGQY8moL/2G6DMoE/UunpaUJVo03ckUpHSciy+jJik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-GUID: DWLQQdP-6rnIehQqjUi5yk3kX-Y-bu0t
X-Proofpoint-ORIG-GUID: DWLQQdP-6rnIehQqjUi5yk3kX-Y-bu0t
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/scsi/scsi_cmnd.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 90da9617d28a..570719237f23 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -232,6 +232,13 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
 	return blk_rq_pos(scmd->request) >> shift;
 }
 
+static inline unsigned int scsi_get_block_count(struct scsi_cmnd *scmd)
+{
+	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
+
+	return blk_rq_bytes(scmd->request) >> shift;
+}
+
 /*
  * The operations below are hints that tell the controller driver how
  * to handle I/Os with DIF or similar types of protection information.
-- 
2.31.1

