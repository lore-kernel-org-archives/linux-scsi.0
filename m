Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0738C4320A
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 15:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C39FD60187
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 15:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237182AbhHCP5A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Aug 2021 11:57:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46416 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237063AbhHCP47 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2021 11:56:59 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173Fqg2M025272;
        Tue, 3 Aug 2021 15:56:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=Zc6DCyYAlcWFfanOmOdZwJsHTGiDfQQJn9c8sOw4k5I=;
 b=YQ2K6D5aeffxTQUdVK00qWd4Um0EEHK3dEB0rtJyOfvQjpM5CMRQxZDwAP9y1KZ6M+9e
 emDbf1k4HgqR/iokxWXe9PzRXbHCm7ffm1YaROL3LZ9wanvL8FrBqTMH1crP5FBJf2r7
 frbLABurLhymB1hEsJ/ziccv/9+nk1cPgloYzilKoqTG/zEu/RDlLg9ySuwtSbl342rd
 az4WFeRINQ+4TN8NfzBFEfOUaKEqpxLYB8otSmpPorFY12u+NBdeop9uD1DbTBqdrjPk
 Nx2BcLnajRgBnu1uESmh5Zs2jp8ITRLsRUmnJyBrf8NOP+UpXACvCS4069odneXYNexB zw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=Zc6DCyYAlcWFfanOmOdZwJsHTGiDfQQJn9c8sOw4k5I=;
 b=gQou6XQdNTxU0IWd4emtL9SMvm3x7SfbwI3G8B0I7Nc8GFfVfKi0R4b9SrveJHj0hESO
 b7sBly6AP0h7DhviIlLWvQwKSYEXiGzgXZC4m6UrwT5tT1TtKqmGYgH0F5vDOFfdFAYi
 Io92BK3SzfpSF91YHb4VuNLqK/DkYXJQ801/xP8HbwVaiKqRiyRqK3yLY9b9KX18bIsD
 M+PKqNKhpJzdKSxEgUwHGQcD/gDOu9Hm6hBVvY9eBHIJL4HaWiJF+EcAhyUKOCw4dEth
 bjJ2pHNipokf4/RFdiz5GMiT39g+6yyo3JHx1pIpScW3ECgKiRAdSM7IWfqVNOg1kRMu aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a6fxhbj9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 15:56:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 173FpPTu104477;
        Tue, 3 Aug 2021 15:56:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by userp3030.oracle.com with ESMTP id 3a4umyx5tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 15:56:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eh5faUZkLjSj9T61LPxQoo+mdJUHx9m5FiB0XN4EllHl8upG/OZI0aC/ZmBjHBCL6eB4/SOPEFaXNy0BI1o6Lh8JufAa+UXUcWNabc3NL0Nrl2+fW/u+wKZfeTVsnZ7MdiENS9djE4j1XMvNyGwATRl60JJsd4TCNapGc0nIIJ0xGt89YZOMp05TloAqKV33beHBN1wLrt+5XTunzVjp3xyibLzTniBm4i9tc9LPcIFao+s/pUFKsB5ma0OnL8sG8T652NvPBrJaJwArx9/qd5n3B6O9ih6605Qb3/y8cn+FPXvgsm8SBO6l5WKV0haZ/MAfopmiMIvw5unZHbv17Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zc6DCyYAlcWFfanOmOdZwJsHTGiDfQQJn9c8sOw4k5I=;
 b=leLcZB3qnyhRbzTcxHfdeqhq9/zAJPN1VBZ9AGszKbeGail58VXV4N5VFnCtKJAmSq58tcIRzBhWRppyrq3PVLEmacqJ1dBUtzSDalLvyTyMLDXVpco2j73OjkOkkM6WsisCpzRN/2bXk26r8OAhCeWgrX9y1WtIISVzRYQh8RW2WqPJDBGJtTgtba5xFBdQ3HAyfLzeM6uYijE7skHAbr2gC8AcYGE4aRi9is0rH3SI1qeVRgME1+LfetZ5p0JiMdHFPOMmt05TI1Aqn9uMrhu3DoqA8YTLnq2p6fwl2vtMtreqkfH1Wa4sDjv6RDsE78F7g/N9fZveEZoYdIcsGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zc6DCyYAlcWFfanOmOdZwJsHTGiDfQQJn9c8sOw4k5I=;
 b=kIrUxlT5cRS6qZu9d/mHraa3BifA0OqlLjKeBWBlHbn6pc9i86mfiSngPqC6SZdTxOD6e+58mLWexnEQkl7WMeW2BUwbT94xh/ygl41z/vdSZ/lrV6ih/E43zeuYxchjGITa7Y/WS4JTZQGxKyxp//osjPYKm+wyB5YY8AwD1oY=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1614.namprd10.prod.outlook.com
 (2603:10b6:301:8::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 3 Aug
 2021 15:56:38 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 15:56:38 +0000
Date:   Tue, 3 Aug 2021 18:56:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Larry Wisneski <Larry.Wisneski@marvell.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: Fix use after free in debug code
Message-ID: <20210803155625.GA22735@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: LO4P123CA0218.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::7) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (2a02:6900:8208:1848::11d1) by LO4P123CA0218.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a6::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 15:56:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98b3c9a4-16bd-4a85-ece8-08d956974748
X-MS-TrafficTypeDiagnostic: MWHPR10MB1614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB161480261854DAAF4693CB7F8EF09@MWHPR10MB1614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ijDoBrLaQ8tdnzbGyw3T0lkBbQ+2Dz37oa3leUI/mHnGaBJoAipyfEk6MoS7XZeXthCLWDwDMltcxliayNM8eEkpSBZXwDmpazKysoReKhR1y/Rzxnsxd+uqxrGlyggW6mCnan8jNY58/XZ78fZ9B99S0rtrOgU1VttL0K7tgTKSq2LAI5D5dwrtjHMhYhDLcfhdS79DWrqGZ+Dm3y8YebAGmpOem0vlXhywVAplIwcuvvrRosnCMpV/0yG7myHklDU+GnOL09vB0TWmQjfdhzhXtN6PiQesDCHmqND0CBmYuTd7J+VOIm6/B4/X/upNJmsU4VwN0W1xyTFcH8PHIiZ8aqDkjHdpj78VFSkGE1r1WqQOWO1dgOKbvRcYPYxn+5O2Bq4aci51BC9xhqc65N+ljEEdkgs+9yeboQBNDB1xgKVgToLxIA3tK9Wv7AlbRw7FmI2R27RMxiDSpIMzpBJZ5rG5xUKfsojuDcNl8p53KU6GpKb72AokH5Iz9SLMsDAtckpG1fTnMT1QFtNjcCDN9O/RT4w+4/PX9DOZReKaT0do21EgDG5HFT9E26SKeRkdXHoc5jvERMJ4Jo5lZrb94ovVWM9DQ4OUBMkS8ED10KEnOZxy3bCaNnxuEOEtzRPUT+/WrqiuWf5hzJ5dgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39860400002)(136003)(376002)(86362001)(8676002)(6666004)(4326008)(8936002)(9576002)(478600001)(55016002)(83380400001)(33656002)(5660300002)(9686003)(44832011)(54906003)(1076003)(38100700002)(2906002)(4744005)(33716001)(316002)(6916009)(186003)(52116002)(66556008)(66476007)(6496006)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BN1bWZ4ieRtBgEROTPHJkfQDLzt8wgqb8KYNNT+Qr6dKBdewQiL6EMEm6H4Z?=
 =?us-ascii?Q?E9hzHnatmfHmxDBOLm/2Plj66/vYWaMWTd5L6z5SVOT7KGYq5EnpKlixRLyr?=
 =?us-ascii?Q?1n6gVW2KwIArAjYh64b8IsVwotk23np0hxMC7lvvojnLcftaUXkt2H9a47wc?=
 =?us-ascii?Q?lX6AQDThCmmk0KccoTym3hfh9kOOgoXWBtRZSivFsUtFkNkX4HjKf8Bkn7Iu?=
 =?us-ascii?Q?BrkWd6hVKydPxr/eCCyT8ocRQDUb2/7J+hJTF7MqxCOFzZLRwqoIy1R8WCFG?=
 =?us-ascii?Q?b3dnfuhcyxLZZyhFMgtJhJZ2Fw6y/uS4obBJYLtABuG7pbmWBjfqizuGqoo9?=
 =?us-ascii?Q?e7PitbvKKyVsVvkF+tHhTXpoTjy5nJ7HR0l/gBJxgCyz3ta7Amll8I0IalwL?=
 =?us-ascii?Q?ZroYT+bwJGSggZRKvpaP8fAWFLilyLM2v83ejjftbfHvwgJVp+R3zlKls1R7?=
 =?us-ascii?Q?T2lX4ThO8H1Ll3XJgqju27HIlRS2lw7AFZT6JI1rqPe8Mgbpbp5AfBR06J0f?=
 =?us-ascii?Q?2GL7ivuhzKKGIlyBlmeUkVWGT7PyddZToI+acBmWuwyC7tMPNbbHgX5e3W0g?=
 =?us-ascii?Q?ryJdfmapv1KyTdTJIxIFscQCiRtTt1bY1TM4z3AZ0PZAxEZD2NVtexrTFlO1?=
 =?us-ascii?Q?cdHS2sunLIPeUphRZGWxjM7I26NyAB8HPKCAFu/1fbwgrkeXZxVeOvTTUXvN?=
 =?us-ascii?Q?ezuJFoWPyDYnmjQb4GisI4H6wtradzvwatS1heCB0A4Lk308fu6SKP/TVa1w?=
 =?us-ascii?Q?c5ac/PY8WHi+RUcfj9YKB0VKhAcvtQqXX4+bwXWfgoZAb0/anlrtQtlQRoeH?=
 =?us-ascii?Q?h8IYkpNp9hHlLeCpcK3OfGSbr6o+WqKagookrxMx3M4I3OAHfIYJpexvEOys?=
 =?us-ascii?Q?8dj32Ni5VFl4vuifH15/e+/mWKEGGWxLjHqeA5XY3wV+FHF/b1BmmuYmBJnm?=
 =?us-ascii?Q?fJAeDqYz8VG4bo2qUlJgwjdCQQbdVJ5Fd29FH/saObZXZQZUHh4Sl09/kz2u?=
 =?us-ascii?Q?v8SXQFqYdl1Z/CXkGZWaqP4BDdzamXSdb9jvwwl14SMNh5X1ZTSiT7LRQyKQ?=
 =?us-ascii?Q?9lwzX618PHPhf1ukg4MR3o+r5HEj1Th+rGH8TeZsIs8PkgJiY8pQ03juqWG5?=
 =?us-ascii?Q?ASZVKPcXh4/5JQd5jx/JI8n4c9lIgjD4O/I2dFE2fC2QFpVCe+H7x3XsSJmr?=
 =?us-ascii?Q?fqc2Hqz16tVLDeVmXQTDwMwBlys0VBfOYv86gdHE3EGBIrstaUZdkD3EpLQ6?=
 =?us-ascii?Q?UEbP3gOJyoX2/4cwThCaZjXKSBOpl+aAygGqqtg9HuEDW11BbrfrllaMD/KQ?=
 =?us-ascii?Q?VkMgp5OFk7Nyl0G7yylR5cVV7R0VO56iX0n2+GJgeIIlgzajlcUKe1zB6zJO?=
 =?us-ascii?Q?cejtq+0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b3c9a4-16bd-4a85-ece8-08d956974748
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 15:56:38.6717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ITff+d5E5B1Cumjby68JQl5zpKyP0qb9m3PPl+KXxqUOOzEzXVFF4FN+vhNXbvYAfA66Q9QyPzgP8FsWKFAxhOFyzgG0VuguFOfCd/vNXME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030104
X-Proofpoint-GUID: xUL3aL6qvOrBP4JCcvbRJIpfYK7uM5ez
X-Proofpoint-ORIG-GUID: xUL3aL6qvOrBP4JCcvbRJIpfYK7uM5ez
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sp->free(sp); call frees "sp" and then the debug code dereferences
it on the next line.  Swap the order.

Fixes: 84318a9f01ce ("scsi: qla2xxx: edif: Add send, receive, and accept for auth_els")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 0739f8ad525a..4b5d28d89d69 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -25,12 +25,12 @@ void qla2x00_bsg_job_done(srb_t *sp, int res)
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 
-	sp->free(sp);
-
 	ql_dbg(ql_dbg_user, sp->vha, 0x7009,
 	    "%s: sp hdl %x, result=%x bsg ptr %p\n",
 	    __func__, sp->handle, res, bsg_job);
 
+	sp->free(sp);
+
 	bsg_reply->result = res;
 	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
-- 
2.20.1

