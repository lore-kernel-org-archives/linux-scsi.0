Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAAA7C43462
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B935161158
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238070AbhDPCFr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237979AbhDPCFe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G24CcZ098785;
        Fri, 16 Apr 2021 02:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=q+ZU0Em1wAO9+sQuST+7PsE/cBrnnPmCbzDa5O0c+FA=;
 b=jstFed2chgNKHMpm5E45/ivONVLe8iPYY4f4oPgXm+Ovfk8qfre1JyHpByAnKn09AO+a
 LrJxQ1p7qE2eEI6No1F9jqvxcJl8lmZU5mUO3co7xKE68wON9ivn9C2a1+6tz1VrQU8z
 X7sffuETpfN1rP4ZEkhvo7hYT5MXYM1fr/cF7jnSZzcUf/MpjhOFtfH2TQT+0LyFYMJP
 ITVKwbZOhXoyzUigSp3ZUHZiARByNcB6gIDCKjl2DeJ51nxqO3cbFl1TnEehO053sFVg
 gxX1/HAj+x562l0Q7N1rNc+0Zf0BfzewzX6FxYuJZkzkMAtboQFSjRtkR0oQr3ybDvLL 2w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3erqpec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xoR1008624;
        Fri, 16 Apr 2021 02:05:03 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3020.oracle.com with ESMTP id 37unx3sp1m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chB+Q6NuLpKQEksjW8mkflSWkC/ZDVyaIHm526UEOcxdd3dZ0qfc8BNIVs4OFE+KnMIjDJ9usTh9PixNKB8t+xSPaNhW150tmV4yhMN+iXhnhBHOUPv69rWyISYFA8ajx1HgJrDl7cpqPyEwPNhxYq32hIm5Y7UYnLkJyrMg664pn9hfMjdKx5zqvHViz7kkKAoyfQ0zp1/oyih2dGPvaPTGqZN9ka01DdJnCORw9wttTVaY65sc6VVJjraTi4O9rA6X8tLkqaPIb0UxSMVuVSW/RHNbZ9F78IUX4zZJ0nFKHvR/xJOBlGIBm+sB8JMumDNkVq/MSHIBR4nuFXDlaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+ZU0Em1wAO9+sQuST+7PsE/cBrnnPmCbzDa5O0c+FA=;
 b=cRMqzBB/jMXZsFkoFnFY+UGpO8KNSvXUsZzihkt1jQYBfil6qXvpa50e4SK4alpUz+fmnNwLyPESeWzhz3hwoyvt+7o7+8apU9A2zBPMfccPWbMsZJGctG0n1wgCb83gtDzB+zbCR9iC8YVm5VUrZ0rCKW07UtyUXWxVhIk4dk9hcBgqcBXgoQt8JJ8tGJhuypBFXdz5akTQ6aFu4sQH0W9In4H7Qthcoin+9T5JMsuzQTxKIRzlBiAOspDR70CzS5CEUo4db25kRdObBzEs/h8o5Lk3nSHyLp3TUFktBrO4et/ypmOdJxwg9U6WbRmhAmYMyfs97yYfSpIf+BjBAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+ZU0Em1wAO9+sQuST+7PsE/cBrnnPmCbzDa5O0c+FA=;
 b=YWZEpwXv66oPFfnkdFWeIJyFy439Ho5iGLVZxyI+vyKgfMrgfkxjyEk+HS8kjDKANd3tqxomSNKEM8jEosQHYscRAmAV/lM7nOexHV3WsoeXTV8CHMx9uuh3lDTLiNJpDKxSnS6F673tFvlLnXDCWzviCo76gDY1J07SrWQpwlw=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3318.namprd10.prod.outlook.com (2603:10b6:a03:15d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Fri, 16 Apr
 2021 02:05:02 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:05:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 12/17] scsi: qedi: use GFP_NOIO for tmf allocation
Date:   Thu, 15 Apr 2021 21:04:35 -0500
Message-Id: <20210416020440.259271-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416020440.259271-1-michael.christie@oracle.com>
References: <20210416020440.259271-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0100.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::41) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:05:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6990fd4a-d954-4132-e337-08d9007c0b95
X-MS-TrafficTypeDiagnostic: BYAPR10MB3318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB33183C9687C43775DEF42308F14C9@BYAPR10MB3318.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:404;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g2y0SBMIWelMn03+4MSGJDCwh2sktxjMCoOcduR1kytwWivtjQyoRz28pl+uVhRr25LPjG3xDV+ZeYgWJrwb0fvQgW10l9NOLgiwVufvT/IO8EfoJJVEUbs+DB/iV0B7cchavUk2TkMzcAy5osOr/ckzY2xD5ve7gCmWw/Nqb+J6ZN3b3C9N0rQ/fT/kVekCnc+1vPqSqHTtPSbf6qKHHMbhYU+tHRYZq7+XTK4Kg51NiX4MXsElVYVrZpHtFK6IwEwVsG5XmBhlp6U7M6ZyUuYJL5VP9P5RBWI7pKrIMB1MShu1NT5E51a4T9eaZmMewBRVPrPdz5uCRs/UAyIQ2YfZ7YAJpKiRNPwC+3ypHVyWCff6os6GcB6ZZwsYuF1yymUqoI3TkKFiorUV0Xk2hJWTgxZDIPwmgiGpPWUzQqjlbO5SAiYkYXS6TX1+xEI4BDjqKcduT839cp2HADZXqIN7itdIUg54DcfPOecJVd/jSDVbfprs3MnUhmTWRw6GKS1dv8KGw/Uuv2HMu3RHKchdlgJ9HYjuCtVLCJ0M/pVSzDU/5gpQG+FHjmeJSCOMuzcrMLk6g+9zqKNoxBuwtYcYLqI9S9U+F3CV9Lhsj+GHCqNv7eACxL9Rbj/PuxSWYusR80ixBEQ0mOYDU2YgHnEhEdpRn7mDG0VMhtH3L1hOyHDeNyDiq1SxS2wff3QN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(366004)(396003)(38350700002)(38100700002)(52116002)(8936002)(6666004)(2906002)(107886003)(26005)(186003)(1076003)(4744005)(36756003)(6486002)(6512007)(6506007)(8676002)(86362001)(69590400012)(83380400001)(508600001)(5660300002)(956004)(316002)(66476007)(66946007)(2616005)(4326008)(66556008)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Hmig2sxtO7ncYMB06CP4uqCTHujU3ICSRBrF6AB+qp84/ldSh/tRDCowJA6B?=
 =?us-ascii?Q?9RcQVFzvibkOd6Jdas1e9XiBnbf+sc4JTZtT6vcyNsOnji2weqUu8gE4KG/t?=
 =?us-ascii?Q?e6BnNoVRD7e0bJ/L2btdLlOMxobLPvY9PvGZP02dFr2nvV5ZGarveO/1dgYW?=
 =?us-ascii?Q?QQ8bs/kMCfE3wU6mymVVQf2cZjcQjfuXR+1zLrKmn5Fzr8sDx4fML0qO67Bn?=
 =?us-ascii?Q?/6wxGn/EV4EaKpTNWfCgW3v9IFyr/WRYlMISjbA9A3iSa5pcmD9vgsFQy6j1?=
 =?us-ascii?Q?/CtBAvMM9UQ8jnweJZbUVvfdQqvlJsZdm7F3HGjkM7oiuFh0DSjAMxu9jZOX?=
 =?us-ascii?Q?qekIeBxwuCYZeWK8dt1uzSSLwp+GnUjULIp4Iy5m9P5H6RqyXj1gj4XVTVxC?=
 =?us-ascii?Q?xE6lYNrRr72eSE8o7GQp/OOCuIgrGuIdC4TBUbVC9pXuATOqnuuafAicVA4b?=
 =?us-ascii?Q?XXbx8Pw+tLStQmy49T6dlIj3KNAbQ05hk/5Xr4QvzoHxq7KTjfTv9tDVKqHc?=
 =?us-ascii?Q?DWS8j7/PtvWHEqCI2m3dP9SCjsF6I+ah9T2CoTSVdmqMZm3xggvXDbZfv838?=
 =?us-ascii?Q?5XSnKASmWKTZ2GA/csKwyPv6RuWYgPCExSAcYlagxkN2nceNltIn85CjS5ez?=
 =?us-ascii?Q?B+JHk12yF3Oh3oOpkNKr5y0OKlN1OdXq9tLtj5jVjOI4kH8SSuMDjzPYCztF?=
 =?us-ascii?Q?C/4k5HGPSGMaSh28YsuN2MKqh9Vagvxfbh05iRBAQcCId2k1cz2MDT9o0vB0?=
 =?us-ascii?Q?OrCnXh5XDP+svxpmu/UmQGv6T3x3YY4bvHCOTFx0k4TGjheSa90NoLIJvmJ2?=
 =?us-ascii?Q?BebZQgLLefZhkWwHZfckm6T2+SjwBFkTqjo/OB7OphJhHpOBERDQVFWjrXE4?=
 =?us-ascii?Q?EMdKtWnFh2s1nePdZnCm3twm3RWnCHo3fMjPtoNv6TNZGVnpsvPId57Rj6F6?=
 =?us-ascii?Q?jeDFzq2b+sMH3tOiKULjaoheMsS+IDGvvgYfj7ErS5/X/c7JViiWJsVd5F/z?=
 =?us-ascii?Q?4ES97ksDxffz/BXsUYvfuCO0Hdfe3yt21AJPdir7LPQrwg17ef6cXZIja/ne?=
 =?us-ascii?Q?iqH5y9F8uuaUSsmNZoDxySD5tDCCDNsP+vdGENRJ2jT8OkfMWblCbGzFT1rW?=
 =?us-ascii?Q?aPlYPcrGoOgHQcVSvVEVTgKKW6kruZfaq4y0liKBSfXPeezfzwVxgbZH6apl?=
 =?us-ascii?Q?NdSWZMU+4HaKQUIJ+vhAAybQNHGXKyP9RsQHkuHej8MBZEmQPu0+Gy7SvVG1?=
 =?us-ascii?Q?pcrsG/JeB4Y7Xc/XQx8RPmWOoHMeIjDHQfDlru+gBhuCYNcwEwYDrzEuQret?=
 =?us-ascii?Q?hVqZWYcGuumChgv4FeOdk82f?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6990fd4a-d954-4132-e337-08d9007c0b95
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:05:02.2441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xuH4rAUnewmLF2Wv/V1mSMwVB3lvz1DLqUu2vGDufMTiwHnYN8+GDsSS+79qglxIOoq2GJmpR/WpFvOnPB9/B2ausvBU6y1lHpqn9siL00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3318
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-ORIG-GUID: Z6zD0mAs_x7MB_KKgDCF0dAVJGyVTNQS
X-Proofpoint-GUID: Z6zD0mAs_x7MB_KKgDCF0dAVJGyVTNQS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We run from a workqueue with no locks held so use GFP_NOIO.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 542255c94d96..84402e827d42 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1396,7 +1396,7 @@ static void qedi_abort_work(struct work_struct *work)
 		goto put_task;
 	}
 
-	list_work = kzalloc(sizeof(*list_work), GFP_ATOMIC);
+	list_work = kzalloc(sizeof(*list_work), GFP_NOIO);
 	if (!list_work) {
 		QEDI_ERR(&qedi->dbg_ctx, "Memory allocation failed\n");
 		goto put_task;
-- 
2.25.1

