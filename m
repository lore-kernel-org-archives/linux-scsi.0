Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4513DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 13:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 286F76120C
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 13:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240044AbhIPNYb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 09:24:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22506 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229474AbhIPNYa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Sep 2021 09:24:30 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18GBNfut008814;
        Thu, 16 Sep 2021 13:23:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=7jqazhfrsIOwk9YfmhqKSZWjk1+OpPmCmhaex0DoZf0=;
 b=KgcXRybcf2W9M+2X7IbDlf8g91aTNO5bpAfOT6lOOnOSPvy06miiHUuFC4V8Rg6ZmjZp
 jaKbg/4tccjML56kK9PLJKjuZXzfz7UgswdVqt9JOLFEXNuH3biLIB4GAidoDosPh28Y
 RAPcW+I4GuMmJGHu/hKQbtgsAFrGnM2mS4VEYYGKuPO9G0/WyFim9S8lbP/TrzbLVmyv
 CkBgpHE0Fqxx1kIGXkCC9FqQq9BqD92ifXSF/6tiLELLNewtW90uilQnY0IjDSgKd8eh
 E/tQo0Kt8HoTHXn3oGXnEKvRQR9gVKyuFEBSYwxFaV3BGYQDKlvUWydcRIcackvo7M1r TA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=7jqazhfrsIOwk9YfmhqKSZWjk1+OpPmCmhaex0DoZf0=;
 b=yV4evFf+xEEF+MgpPUspRY83uqg73xMrta8Ovp4cA2lyxPkep5RbQwC5RvUigNu4o9Pq
 X2b1+PWY4mO01JZTdCXMWHfuOFf22jS9hCtGMDd5mo3XM0CLfcjikDGBgZLC+7FpR1C3
 P9HmvlQHgJykhvWpljf1CVmXWx9G/r9dpJ7AzApQUdNDCDKOLdjBvqfFzAH6B23Cs6vp
 mqe3xF58Sh2ixS/kidmoZjbdFFTW7ghcQIcabuLBuoc0eIctOKNj0CIdLDMu+EzSwxwb
 VIq2Xf9RUKFQwNRowmonFoZ3JibmgioIC3b8yLCQuVA/qUNVmASgguqCdpeMpUGLXBlC Ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3vj11u63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 13:23:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GDLHt3031427;
        Thu, 16 Sep 2021 13:23:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3030.oracle.com with ESMTP id 3b0hjy7xma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 13:23:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1+eD8kG1CeMGTH1LUFxWgLz4dgsF8X8BEGeZNlTL+zAVAqNE2xI3qAv65+VmMQl1x74pvAWiO520d+Bbx2COawHSlkorz/nMyqP0gXq9J/qkfIx4LPW3Im9cRNlRUGZlU4UMJmiN90GaUFkc/3nejDR5G8ls9M8uItA4YOKWhgGSqY7qMTSXH5ENf94vKEOFOObJ2HR5HDKleT0/661/yrM721DJaq/I1x5cC+BOoxizj8k/dGylQRngymUb7SKgSkSSA5XtPib3ZXNGu+6mGF2WsPYzEb38PKU74DhbPgb/YTZ+/pSu1lO1H6VOewomjCA+AxtuFnR4DyvazeiBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=7jqazhfrsIOwk9YfmhqKSZWjk1+OpPmCmhaex0DoZf0=;
 b=XPAPRhlQUKry+C+VZ8EvAJ8AZ5BHeep4pq1MOcykwQ9Oem2m8rClBA8T0budlQXl3/1exNhXlsf+E5mSTHzOVZchnnpEb8iyfM+rMiWwq9z4AYEbPl2gkyWY5xccXiG3NPnNW7HldoqF9RqS5yI3tQFS35nCeSzwxh7TydsuzeAkMigx6W+jl3NgwUAmz/+G38trzjRm0qQ6YYRWd7DWpNzes1SL6VjwR9CJyneehoO3yTqEUIXo/rejkXst+zaKz129QoxYY5E0Vv0EAVQcVdZbPwRRefQ+CM1pJdS+UyKS00P+Eol8Qpi5AYl4NXjAPuaCNd70r/3Mzk6Nzm8q5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jqazhfrsIOwk9YfmhqKSZWjk1+OpPmCmhaex0DoZf0=;
 b=DtPRFCNCJmGSGxT8ZxdXxoz2WlZfII+VcIs+OOizGIPwSWqkNosgMouQkbbDOmzra9vX2kNf3ajBKe8J91YbbN45NC082WYt+mGXcXYUcUedzQRDVKq6oaDjOxsIxzEBaM7XKiazRjzyvUDeXUPGedkMmIgwoVRwyhBUrfub2f8=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1615.namprd10.prod.outlook.com
 (2603:10b6:301:7::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 13:23:03 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 13:23:03 +0000
Date:   Thu, 16 Sep 2021 16:22:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     James Smart <james.smart@broadcom.com>,
        Justin Tee <justin.tee@broadcom.com>
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: lpfc: fix sprintf() overflow in
 lpfc_display_fpin_wwpn()
Message-ID: <20210916132251.GD25094@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0106.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0106.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Thu, 16 Sep 2021 13:23:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94eb251a-d44a-41ab-0604-08d979151cdc
X-MS-TrafficTypeDiagnostic: MWHPR10MB1615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB16156A4F7346A3E3876FFFBB8EDC9@MWHPR10MB1615.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xMK2w2ka0U0hY9ItlX3flOTbPsOTNUVNI6QsGC5WqI427gQm5NeUrYWyZELMD+W8Cf2H/f5h3Dd/+pobNkMvg9G36rtCiL54WkvKqNmRVLpwOstacwvbyxCZn+H8epgUJmo7k69xVB6QWXgIrSTaarAATFZKe7ctkTlQK0Gah6hSgXK1lkCPoq/ASKYOyW5mcVdo9q3UgxZ0+Bl67e7g/v+zrwLWXR+cMBp1Ifh4ZZvAYefRQfCVS3an+UVryEbGeEjQu2Sm1OYri07RiEvhX+lUqUTRO0xV9GVozQP0hvMnpu6bkGgk3VOk2fQOdRvn4/gOAOS7F5j9ZUIFqc6Yqt30utOA2wAp2K5rSbq8PuM2cCKEE4oXXXYK4ptzm68SdstW1FuEjR9y0+Ip7Bqmrxpn+1q//B3hCQNM5qyPfjJVnvgEhYkbbH2ChMVuJkIlTSklupcG7pzctmpda03pk8tnaK2p8q9vuECKc2fD923qhmV9j93hKSWMwCMHn5TtGZgA3S466EoDdgBvHVDoO1LPhBkEA9we9mZS/FSzbWKuyYGxbU+PWa24+tNJ4ooKDqMYAKRToZPKg9zXCb+GPftzOb7blea3zUIdKrUnsRPthB7hve/CT/mcPknjztdzI6/Sfow63W8955Zoqnn0mgBsbGIv3rW8RWivIcsq7Ym23p2ijvkvI/vXfkJRhubIUxw7FLvTjX0f4h2ntGcOZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(136003)(346002)(66556008)(186003)(8936002)(8676002)(1076003)(9576002)(4326008)(4744005)(9686003)(6496006)(316002)(478600001)(6666004)(86362001)(33656002)(5660300002)(54906003)(2906002)(44832011)(66946007)(110136005)(956004)(38350700002)(83380400001)(55016002)(33716001)(38100700002)(66476007)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bnejPVdP2RQYHGj2I+QYABXdI4fqvnjGJubRUhe6VyynFrcpyY8+PRfctOKt?=
 =?us-ascii?Q?H2lxQSDAISDuNmogqN/lOihupEJTIwptmLn2sYsNocv671X4IlAZXB0n/U45?=
 =?us-ascii?Q?gs9cBPHzugUtpl4xCGoAOYVWXqbejMm/Ka+WjRO8IRWMMJ6hhLCJPyZ3pbKw?=
 =?us-ascii?Q?k0KmzfuYXU+9caMUP1gD86NphM7a9PE/Y7Nqgsy/csBkIjWcJQotLQuT2k4k?=
 =?us-ascii?Q?Cx5kGqd6ffo4vifnHZsAKBEhMLCaoHLRNW7gBXJxflHNvtj37x6JISktlQTi?=
 =?us-ascii?Q?IgdaYr7YjaAqfAiwcLrXyDBpNhKprXX7QjMwptoHWECPNPyKLNsChcPts75m?=
 =?us-ascii?Q?/VqM1yPkUq//IGKUPGZmzy4916WmWNwRcNSC+gRApl6EIeq2ZRNa8KB0kahJ?=
 =?us-ascii?Q?PK1HBQ2vtJJ4+iwmefPUaS7vTNBcq5sEewMZ4HKcxWN2oJUy1hiHYC/kIRzd?=
 =?us-ascii?Q?9tmmNd1ZDM9VgcdM5C2Q4PsEZQmjjPlNR97+esSdIoMXbHDL6vJPNQGCBR3f?=
 =?us-ascii?Q?c5skNHp5rG2evCxjfgLHctc0Bs7zVW1HU/x2jjQdSDE0kl/LBFNNwHaMFRlq?=
 =?us-ascii?Q?gkb2NM8lIZisKOT2aKtC2QSNhev7S0f1WQTMBvdzUD0HxRCbWxtBmi14CPLA?=
 =?us-ascii?Q?Vx8YmFeWbRb9TSDgaGYKyT7v5fisW0udxj5pae0FgDISA3vu/O89572gPNB+?=
 =?us-ascii?Q?Scxptjv8INty+2Zelb52jPgRX5joko5rQe0h6WfthZ6I1Sjz/DDUHsYNxJMF?=
 =?us-ascii?Q?C9PSJXzVy/AO1UbHWGl1HCOrMh+SEbTIhYrE/j/M2mko5gz0EI71EIwbcsy1?=
 =?us-ascii?Q?a9WZQGu+tMhd1VsH5BxTmzTBZgVZajiqGcVvpVc+jqAbOa6Aq8JLTI1n8aL2?=
 =?us-ascii?Q?OQ1dvjiyXq2WSlDDny3Kdnet4jdSps4PqFZzIRr72yWtd7Y35oEMdaTwP8Fi?=
 =?us-ascii?Q?WOUKzR2//zR0hpe/2pHZL2YSPYKI4HJgzQ/Kh3+sWjZIXl+/CfY6tQ8w4KQt?=
 =?us-ascii?Q?3IZ2tDoXiw6NzJVTUiUKnut/7BaJUJPkOZKcsNWN8DgPt6nC5JiNtO4IAO7f?=
 =?us-ascii?Q?edX9AjbqKuLkJH7O8q1xGdrc0rm0PFWdcAXwoRGpV6tUxoAAFfb8g8vLWGth?=
 =?us-ascii?Q?KBtulVytt6yytxflPoQLWNH15aZrqryZebM2uIvks1Vq2B1Ta28V2upRcFMI?=
 =?us-ascii?Q?76PJIw6XXsnqgoOD2/07hD9KeVJg9FB9uAVQ8pIGChC3Dm5azEQyvqhFJQcA?=
 =?us-ascii?Q?fjRD3SyS77bd+s2in04E9TaQw379x8HdagjBgKHEZzRaUMBE6FAv0fT6vDvX?=
 =?us-ascii?Q?ynGXDFlF3pKvzRdoCUV1sCp1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94eb251a-d44a-41ab-0604-08d979151cdc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 13:23:03.7550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tNEZREdxyf9UkcJ62LPWFqSeta5ERbiI3DnAQmccJ7OhxfgEo+1LugKyQe70nq0w+N9cgAkkiPei4/yzo82abch3pW8w7o46p7fWGzYgUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1615
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160085
X-Proofpoint-ORIG-GUID: fa1jz-586WuphuX6m4kJ-ETdHFGYsamV
X-Proofpoint-GUID: fa1jz-586WuphuX6m4kJ-ETdHFGYsamV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This scnprintf() uses the wrong limit.  It should be
"LPFC_FPIN_WWPN_LINE_SZ - len" instead of LPFC_FPIN_WWPN_LINE_SZ.

Fixes: 428569e66fa7 ("scsi: lpfc: Expand FPIN and RDF receive logging")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f3fc79b99165..052c0e5b1119 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9387,7 +9387,7 @@ lpfc_display_fpin_wwpn(struct lpfc_hba *phba, __be64 *wwnlist, u32 cnt)
 		/* Extract the next WWPN from the payload */
 		wwn = *wwnlist++;
 		wwpn = be64_to_cpu(wwn);
-		len += scnprintf(buf + len, LPFC_FPIN_WWPN_LINE_SZ,
+		len += scnprintf(buf + len, LPFC_FPIN_WWPN_LINE_SZ - len,
 				 " %016llx", wwpn);
 
 		/* Log a message if we are on the last WWPN
-- 
2.20.1

