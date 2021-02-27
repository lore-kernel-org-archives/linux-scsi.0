Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1D6C433E6
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1400A64E86
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhB0RIp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:08:45 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47930 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhB0RCI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:02:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGxaKH178656;
        Sat, 27 Feb 2021 17:00:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=YifcLh0il3TAoAtiSTT8Q8kHskbGL/+3duj92Vi8qB4=;
 b=o+Q820ZqLyxC7aZuLCN+2ue3erc6gnL6DulMXD9iyBephbfM6HwuI8O+cnJkSK1OATs9
 sJGDgWbXuGLYyhyRfTHic/hXUh900wkgkj5DvSh9Qj6W2wgDTxdgAzYmKo8WuH2mrb7N
 kzbsGOg2gQcxE1VK7ISk8m0BgYis7rVSXpzgXY6V/vd3MSpqfVKlA+E19SbPFKUz4FZ6
 wbQJ8FbRLz7r2LS4zkYcC46OeVpgh6A4C3rbqP1IFq8tiTHNG19ZUY8ctEBK6m62Xegy
 s7G5OwiOKODqsaafQIFt8h1rZHorr00kzWNDXvFmLSwHnBppn/YoDxqKw43eKTDKF9EU vA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36yeqmrpsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGslmV115709;
        Sat, 27 Feb 2021 17:00:18 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3030.oracle.com with ESMTP id 36yc4a7jaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3P8qiXTPqupabMoHkplUaN40vlgNWBW77OxAbBmtvDalWdsZdDklBtMyaaa9eXfow4sAl9oDyt9z8zVO3hrqZbC1ivvoir7E56HjQ1+ut4AtSstlPPA8zIfZMtRtEJv4s0Q5UG8HLRqPn1fSLpoXXrNojkt1oDHP42cGmRNpyNxtzfAbDuZ8+aontJm9Vg9/NzxVc5VnOqEsGXcJ3zKNcBLENYKXAuZrVwfmGUvg5yh5BrIz0P5YWRTNjlVfWvVdOQDPnczNPnRkM6mRK/l9CG+zPSruCoKJdHZwlFgp1kwITJ57Tg936UMpONVopsBEvkVS4La9+XzfvDaqBhjSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YifcLh0il3TAoAtiSTT8Q8kHskbGL/+3duj92Vi8qB4=;
 b=J4iNC+V1nLUZDD+bK+CNvb1LUYa/caghpXjaLCaBeiq4F929MCXGdMfVt40HuPztXT566Rl49VRrzNpv2lvRlJgs5YX0RdnXIfWTXP3Z7C/j6DqbQmRgsdN4O6bqVkewBWBXQUq2ByjFMea7USbBvvjQ0eoaP64sIasU4NE+r6yagmk4XWWHClSiyEBjQEtDW9bORkW0QLutxTgkWXBsuAQjBMXlO8rUM+Bgx7vKlGoqRzY7DQcVSIIPRO2eWoXJXMsR7ugp5P87dC9OCy/ik0JzjeMEyUwVORjljrnc+5PiAcZXxxQDO6vWXdV8HgtGaqj70G5aAZurB0Kh98yJrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YifcLh0il3TAoAtiSTT8Q8kHskbGL/+3duj92Vi8qB4=;
 b=JJEnRfHTcx4p0cTEhbiwWV6soF3NiiSdJnSqZyfestQpjrBBxSFG0eyx8XhAlFb3AO8lQtB8d8z/MBMSJ9NxN7E8nKhuynCWvjY3+UTHPyVI3ErihD6zQbVMg9vm9Kh2uo/v+G63dFJvDgxdoDBerC23KrPHNeieHQs2eDL+sc4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:16 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 01/25] target: move t_task_cdb initialization
Date:   Sat, 27 Feb 2021 10:59:42 -0600
Message-Id: <20210227170006.5077-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39d8bdae-a000-4739-a7bd-08d8db4127a2
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3499319489F956066289489AF19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z3bLMhVYftVUzPBHV6ObZWaU2AMkdzz0NvvYFtA6+tbmeWsgP50bA6GbuBnmgnNCScqUoPaBygIkH2oINvL7RPjX7zZBbRo7Ms7k+2FFIFQupv+0I86wsrgciCdp3h5Jp9IZpJ00gGYM9bbWeIlgQN/P4GGTIc/XpSdFmluPSSGHGJcbiiSzvARbqHUOLcB6ejsl2XjHUuL3rLtUsMZhAOgDWZPtqKJuaOrBnDHGIYAvhfSesvIFSbXLbjUcAadULRtYEk+OOIJe6vn+tJMeEPUwmnceF0uqmkLlj7eXqTsRIYuE0/XERjGWyrfX5swhiQVzvoaKIQLtCPLVil4wUAjjyHqPumvQLmN2ZUloiwO5NhVMToWf+xbqvgieuLpcDr+/yBT0KuC8uT34349x1SP3As6+kwbxQVuCBIxztNlBDZcoEODCteRf49Cj2qtfCMuu93L2Th+6OQ0MwW7DIUfhcazQ3aFzUCecJvax9IwhgdV9j8+EkcK5M7DW+jmai6MmCAfd6w3WHYaLRllFuME3d663J8U+DzhGZyfCWViuMMmIZuwkMqJULckwRqrBWegNYfyU+jPjtnIeY+8T0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(54906003)(8676002)(107886003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+kenI56dpK9K/BEtFd8BST3xHA6ZRxGShMMru3lu/RmU8tdEBgVOv29z4DXy?=
 =?us-ascii?Q?edA5iJiN/JEJYlNUOUjTzpXxPGOIeVue89KqP47FRJSmorCmd5ttghlKGp4W?=
 =?us-ascii?Q?Ki9Aae3IuHQrrOkzqVC1Rm0dN7ZphCdp6N+DT4lAUlQx6GKFmN+UE39QKSO1?=
 =?us-ascii?Q?sXeNmTtXEyJFHqXFXMu+o6aJ9sJQYPLF9ZaBe3Gsg4Kj2tvpNqNTe7kmx06b?=
 =?us-ascii?Q?aUvuBX3961sFKOU4cb0yTfVEgMh6+Mrlqy/fJGLgB0RWsAFo0B8hfNqXIDz3?=
 =?us-ascii?Q?TVHV0VJRtCo/StLcBtx7YTVgKrBmPMEVufvYEHgrPFaR1OY44FUyBNk3JAvH?=
 =?us-ascii?Q?lT5hhkTL1XkweEfnLO+8wEkJ5cbSf3USnzc/nIinZt1k1GCx0kwmVQrkw+oo?=
 =?us-ascii?Q?5r4Q83yWVrA0DzveM6JXGg1ICOhMmEXJvmAy2Z/YDTegHQw2keQEs/i55WM7?=
 =?us-ascii?Q?BpqI/gLdq2/3CJ4MP5uyGSIZpCG8+alNCOFOlzKrCItDv8VEmI+jDCrLqYWq?=
 =?us-ascii?Q?Rt64pncydxVKYPfyGaprNadkeG1ANGRRj8qPR1e+vaP8UaY5XbOVZp5YHOWo?=
 =?us-ascii?Q?b0yC+FrWuXEu1Gjf117yUmcQQ/Ko9N5ZZQc/jt4OcUkb3WV+n0LB7shu+71X?=
 =?us-ascii?Q?UFqvW5IMNZ7HivIYfBJmv02OOCWtrWGEY9BcAlohe3DfPXeS+66dyqvoZLES?=
 =?us-ascii?Q?Eqv0k26gIl5zL/X1MC7QSfj6N5UAyfZ5084GF2tum3N5CDJ30x7Wt5lnVTQN?=
 =?us-ascii?Q?tTYIG5qBRR93OILtiJnMWNhjY1bax0BxA4ZCNVxo6owkjQCQs/WuIS3DRu16?=
 =?us-ascii?Q?fSlAwVm9e3Q3t32PWaaTl3GPQOleYtyzy6yqsJu/cCYEn30H1ZHAdf84wirM?=
 =?us-ascii?Q?s3sOaKt5jbtdy7zbjTmn0y8XySRY/20z460M9NspOLKecli7LW6p2dXGAo4B?=
 =?us-ascii?Q?VYB0ngH1MN9f8XDQy5wkNmUBBIknI6NCZnbbK/w0Psguh3OoRMo0VCoXHST5?=
 =?us-ascii?Q?SvJDmGcoe6OEw+FIHU4mJYfmMjTScz1AlkEUA0KJSRC52ZLUPKWdM7CM4b1z?=
 =?us-ascii?Q?UgZxmENhyt3US+iIhnvSRfHt81YFBFygQFBVnv4bKHsUetlxDid8BYDPonkM?=
 =?us-ascii?Q?gTymoWetefQyc1kNEmyJOgIg2G3zFlsOTJ6xdd/H8aKTD33CUKLdtY770RA9?=
 =?us-ascii?Q?iDI5jqLz/fTp7b0vOag/z+iQmwewZxsll5ZjeATGOFtmEBnimlCYXGiB40kC?=
 =?us-ascii?Q?UwcDCv25UkorBT7WDUn+OlwybhAODs0mY4zvJOJN+WQVlWbXS3ZwYVf7XJhk?=
 =?us-ascii?Q?PulLiM1CjTf28j6eg/juzc0V?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d8bdae-a000-4739-a7bd-08d8db4127a2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:15.8952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OseskYHd6ZFHQ0weMeU0dC7NL2rFX3QVn8vJX2rh90ve9xPi2KlnqZCEarnA/UegXL9eiYkIw70QppnIJBlIkHzHHusgNzfIPC94eadxu9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch splits target_submit_cmd_map_sgls so the initialization
and submission part can be called at different times. If the init part
fails we can reference the t_task_cdb early in some of the logging
and tracing code. This moves it to transport_init_se_cmd so we don't
hit NULL pointer crashes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d47bfd8b0f87..5c4adde96d5e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1389,6 +1389,7 @@ void transport_init_se_cmd(
 	INIT_WORK(&cmd->work, NULL);
 	kref_init(&cmd->cmd_kref);
 
+	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	cmd->se_tfo = tfo;
 	cmd->se_sess = se_sess;
 	cmd->data_length = data_length;
@@ -1430,7 +1431,6 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
 {
 	sense_reason_t ret;
 
-	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	/*
 	 * Ensure that the received CDB is less than the max (252 + 8) bytes
 	 * for VARIABLE_LENGTH_CMD
-- 
2.25.1

