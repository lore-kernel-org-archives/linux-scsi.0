Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89CCC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 00:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbiDHAQP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiDHAQH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 20:16:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F7C14B84E
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 17:14:06 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237LOlUG024505;
        Fri, 8 Apr 2022 00:13:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=kRmbCquSf+yQslvAzTBagyoROYOlLf8ap5p8EmNDY40=;
 b=p8VAqHmyQDofmFuV7Ix0oG26mOAXhZW4VTz4PftOWcaaN0fiXNVmhOSA0/rTSnEdz2+w
 ySrhn0Bpx9fXB1TxlbRMy8OynNPK9DyzK6jpmqCH0oZ9EbfK27Lq4Ed8yjubE74f+5/L
 xRsAdJcp4WGAwZ1lCcbbWoFnTyKaWSPf2wGPuN77K8gpNxIj9IKd1ZUxekpzBdzx11W0
 bNGQStL0qkBrs6CZDm/2IaT8Q2wz9fYSaUdpajlNzNj1MdmJOWeVrc6SMrI6GGyTzaXX
 +LKpOvln+yeZ759tjohg4OHcnYW4XaHsKzvblj/1rUoN/98q4xweEe6q+GPb+7qHN1A6 9Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tdnhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237M7smk029005;
        Fri, 8 Apr 2022 00:13:30 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f974erfry-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LU5n16jjz5LNkuAm7XVv+c7dsRRERci+Gox79G5TGCUhj/mWhfcw+PPyxJVxfKeJc48n5W45FnseJ04W4W5YeaYdvBo6te5vb4OAT5Hn+cszeVTQ2yOKbbyJS1SiZiZTUNblwQI1ozU9AWzk3WhkPb8Ym2RS4Y9OB/sKMqoMNzZXA6bkYNo+B7Iicpnc8myv8bb/+jBseNxdfIu11vEAXoqY/9KPJ8pDiMdKkmYU7ZzwCvfmJfy24aQOHQyA6aRUizM8iEM8LGDBTlh1eC7WDtN5c9wTBSUxDIv2F4zpic22QepVZyaJMHHpNrlflB34JqdEKVXMgOmCt+ByCJcSyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kRmbCquSf+yQslvAzTBagyoROYOlLf8ap5p8EmNDY40=;
 b=M/Vlym9WImBT+vmjDisA8NGtOzs1vFsoOVjzxFIuCvBCrIvjUdHwjF4sgLHzH/OhmLJ/71CuxY4+M0HQWO3DBeFcRLcuUET0EB10XWLzQgwFkc/bdfP+crSmMRojx7jOR9k2OsJ4v/DX1fQRB5y1BKdfaFD0z/R7K0kOF4r72h7bHyJpiPpaaubJxO/ysotQH7WPWKKyHA/sKRFmQCAPGkP1E8q46w3rRG8Rl9uUivgfOxZ9d/WuIcBhPxbNPmQzFo+IOykkFHA8p6qUc0rOiB1zVD85oWYLXM+5q0FNGxHxmXsGQ0ahIzn6ePBzc/nmX0woZ5FstsyIbNFZsyLZ2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRmbCquSf+yQslvAzTBagyoROYOlLf8ap5p8EmNDY40=;
 b=gELbOApNRZL+vQa7Bgd+J5T40dFyzJd58n8mlFXkgAfXVnufyviwXWYAxXOGuiKDwGTbshMCjAoDl1kHLoVQtHRe9oujy+l+HE8QGtRBkyG4jaOV+JqeU2QuCtQQAT4gmWN66NUsSYqS+0DdeZOprile2MVLz5z6b+NrrAGGsaQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB3762.namprd10.prod.outlook.com (2603:10b6:a03:1b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 00:13:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 00:13:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     skashyap@marvell.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 10/10] scsi: iscsi: Add Mike Christie as co-maintainer
Date:   Thu,  7 Apr 2022 19:13:14 -0500
Message-Id: <20220408001314.5014-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408001314.5014-1-michael.christie@oracle.com>
References: <20220408001314.5014-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cdb4c81-2403-463d-b3dc-08da18f49adf
X-MS-TrafficTypeDiagnostic: BY5PR10MB3762:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB37627B4C6E1186DAAFE9CAC7F1E99@BY5PR10MB3762.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dm1XBXEh6MZsS1pTUWMKz88sZyfwXvzHH/DYTCIWhmAiGXR6EkFgyTGvzWxf0Bwf+ba2d1mWfsQS0Y5ngRrG5iLiZRgqipvYTVC5ZYZppxafnpuCg5kFuic3qEoKyZMW6aOcRgvnbNFdKjHXerIf7vq5M10aLC9WOAVcWlto3PRASs/42oHQSD+eHEyLV4lMFua+rItZBWl51puXlCyg1YpV8VC6sgGwMxJqdfcOKW5HFcufElo9WODC1t+U+Iw3Mh6yYVycmhTA0VGzw8TtPS0UYasKN1oKSfkqHKgQ09KRb7hL804HuuHSOEmJyPhS5CIGYvrqma3nssCKAi3tdzEpRFNZe8o5zchyun2bZIi3tIXjdMibPvJiAFh/7FlmQPCmY0dyuGR2AiVSsDnNhFyb/KhlW8E/gD7aJ5Lfu8x3QxD1GVr2MiXhx91DuFIlrW/4CWzc69cy4s/u3GLS6jlO2hkcbcV3mpwv+ZW91D5WnSljHVnq5P4aR7nF0K6r5xRxzQIFc0iykgAMjMlY4ibNftHUyugGZoywq09dYEdD8wLSpru1jcV10TnUp0Xua5GRsiNMRCmm+mOKiOBzawQTBLgNbWZANK1xdDnDpBmXVUDy2MjpXW6vEYzSYoG20eJXD2v+rfyPJMm35VntYFaDCd6OW2xVGiIu/YrDNWgl0lxVm3lQnS47sL9GEZvcZsbco3Vs3fQ59lgawMOnzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(6512007)(52116002)(5660300002)(2616005)(508600001)(6486002)(107886003)(8936002)(4744005)(6666004)(6506007)(2906002)(38100700002)(38350700002)(186003)(1076003)(26005)(66556008)(4326008)(316002)(66946007)(66476007)(8676002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QpyjlLi6ZbWD6/neCiATowA0RZxqvgrjGr6hCYO6vsd9v2VFYwrQ6tPYRCdJ?=
 =?us-ascii?Q?ksyUwKdaboBFLxwuiDd6uPXhnCu8/fWV9kp/Dc7OMi/mnoGwBpDEWOZNaJpB?=
 =?us-ascii?Q?OuXVNsDp3llhhoqOsIZ1InoKS+DA7wmrj79PHGvyNhaiXfBadgsGRlE25C8Q?=
 =?us-ascii?Q?mEveqq1o+bDiSP2K5Tl/AVJ1Nri65pgsyz1CrW24PuZJuG9A8sqUSp3REOcF?=
 =?us-ascii?Q?N2l4ZP0c6i3smjDHUDwOzCMVaeady2hJFM6U0sP1RRSf66/fvwnk2Bd07Ar6?=
 =?us-ascii?Q?LTvZYuNWHOCN/OzbbzLIXgbFn9Qc2a9daJuhPHRAKUb6KWoVG2kO1/X4KVgR?=
 =?us-ascii?Q?WbN5M35IbbLm0Z7hRrjnBaamEq9CDR3CVNsig8bQTJ1IjgjTODlw9iAaLGFN?=
 =?us-ascii?Q?VPxNaKZj/oK0gr0epKGVaatXl4i2VsAxm+G9C4Imx6/fa+NBK5D2m0UexP2I?=
 =?us-ascii?Q?hC6LHg4gUwJkmnbkeecszvHyeU8fhJ/8KYWCggNnmXN65hMhc1DqnaUoSbQx?=
 =?us-ascii?Q?+lmrNikUCG2cgl8iG//q0hvZtDBmDrgfKfyWiv60Q0YfjHLHO3UmBsf46z6F?=
 =?us-ascii?Q?GeWvQZGdzdobH7Qn6lEAinUENJ8Zs6Noi4jCw1LPvN0vI/lppf4Q+FpcVMGd?=
 =?us-ascii?Q?q3FdIUrJi6lQZtJwv5Ez1VaKTvgPmx3xJ81HQgMVp/NmHLYP6R4k9jVWi/He?=
 =?us-ascii?Q?8EFpbjRbNUSMxDJjs5ntxW9UjenJP00kRgGFT8cLHDBmA7+HsB+AYpXylTD3?=
 =?us-ascii?Q?L8svznemfQ6+6vZ41U1oqbMPD3tO4eRhZCLaqhlTeBtmBy0oK3cxM+99Scl+?=
 =?us-ascii?Q?kwM6cvKaLpnOHaeGmqeiaxIGv+I9uMez+mKiMM/HGDPcsh8qMpLRexoozV+9?=
 =?us-ascii?Q?5ErKu1anJ2aMx6or+CJf01jSGPAFsiKoQWYExcCRjuDcLW/B+Pe8NlQz5jJC?=
 =?us-ascii?Q?rmiIBv0RrqkRfqPr/E7iKK1y7C//Zr9HtZK1/TGv+mJUdUMGUNTb1p/kHQdI?=
 =?us-ascii?Q?awuN65cd87w6ERKMb2sLWStRPuxrxs7c17X/AMU5b9tXmG4s/EBOthZOjqcd?=
 =?us-ascii?Q?Gi4Zf7v7Nd0zweKnTL1CczGNxMJsGWiaDqSkavKxcH6qrHTG6/THO4MuM9TY?=
 =?us-ascii?Q?uN3tq18npNqg6jx/WKk64n8ETmioyOZuysxMYuXEwmsVw1N7vZ+iRTchsTmn?=
 =?us-ascii?Q?GDh5dA4pDIM+rWm8l9f3sOvV8malbFt1TYme7zfvA/r1ubpSfa7bFuFyHRBx?=
 =?us-ascii?Q?VUTD2RQ12iJN9QKb5xgafnKhYx6ln+VY4X6HQukKOcQyhmtmxzm3A4f8Xu2w?=
 =?us-ascii?Q?zqkSC4ChuhtGtiCzlBvtBuNJ8loGyJkJ8lpFB2/RPtK8AeCSeQ1p+YDhMK1C?=
 =?us-ascii?Q?CGjfadbOjVEz1BR3ex9ZIDj9f/W/7y+YWHvzKDRlQOgWvi1PxGc+LpRUFNCE?=
 =?us-ascii?Q?BM6WQvkDT88sPi7Pzz5iHr9eKNqxBspjeWb+YO4wftBH2EszE+NA43q72S1z?=
 =?us-ascii?Q?DxczoJF7kqEebhVykHSPlDOTE3bdrUWVBPPBsZkuY7OBDGYvMm21eEFcdo1Q?=
 =?us-ascii?Q?Wz+NGpl3fQ902GZgwoY60tR7TpJb+EZmeQgzuVeuR/r4eT02nfF3kM21zIja?=
 =?us-ascii?Q?w6WBwQBi8msLVhQzyEn/KVJwPQgNHAzHcoStEWj5Y/UuqiUrbWN90C2qTGMO?=
 =?us-ascii?Q?qV7dy9O8+iI630BcrUqTfo/rOo8o9BsUJoX2ORsYFeX6+XaAx8maD8MNxQlf?=
 =?us-ascii?Q?Gw6AFDuXMvc58G8IwIJWfUbbs8G+ALA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cdb4c81-2403-463d-b3dc-08da18f49adf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 00:13:27.7035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fmQhMK+EGvAxYC5dMtUJS7cNT1w+gie/tgld8QsMBkMHb/6ghjzqIlgnmgn+kX22X2iObSCDdU+POTQIOMYKNk8uOMQcq1posbDnHmfGh3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3762
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204070064
X-Proofpoint-ORIG-GUID: byqYYCflTz8sHjuXqckRIUc6qFTGvEz_
X-Proofpoint-GUID: byqYYCflTz8sHjuXqckRIUc6qFTGvEz_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I've been doing a lot of iscsi patches because Oracle is paying me to work
on iSCSI again. It was supposed to be temp assignment, but my co-worker
that was working on iscsi moved to a new group so it looks like I'm back
on this code again. After talking to Chris and Lee this patch adds me back
as co-maintainer, so I can help them and people remember to cc me on
issues.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fd768d43e048..ca9d56121974 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10369,6 +10369,7 @@ F:	include/linux/isapnp.h
 ISCSI
 M:	Lee Duncan <lduncan@suse.com>
 M:	Chris Leech <cleech@redhat.com>
+M:	Mike Christie <michael.christie@oracle.com>
 L:	open-iscsi@googlegroups.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
-- 
2.25.1

