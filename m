Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9852AC04FF3
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 20:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F261613EC
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 20:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhEUVBV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 17:01:21 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:33780 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229457AbhEUVBU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 May 2021 17:01:20 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LKeTb4000343;
        Fri, 21 May 2021 20:59:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=b83EmVlCoRrMSuETMEZDPMPp0kKfcwbakx80CX0pG50=;
 b=KK8gKx3EyVHpQksthH3X+ynlaDlfE95vY+pNZYdM9Io6h7fBowesHFfopuTnay0tlWJT
 D2WGanEyP9wRFwy9QzkPoDSBKZitUFldCOB/S9tq6QnjQJqWdLaC9NibP8nasAkYIWO3
 1PKSFKq4/Ta2GJSPbIAJKzn6dEtgUelbj4A18rLKHtKnZl+LLKhRxvHsqlzd7C1I2Rq4
 5/CoMgZ0co+a3/zLN99mGbIb+FWGor16pQr3y0UulLew6kTQEQ2pLlY94BkhrZwPT6LZ
 N7cHhMkryTZAYJLwPa7q+vaf86iLD+N8FhNDSXNi8II9IvkVVJ4Vidp5HUcaz2MnQziI hw== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 38n4u8s2fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:59:52 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14LKghNr049656;
        Fri, 21 May 2021 20:59:51 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2041.outbound.protection.outlook.com [104.47.74.41])
        by userp3030.oracle.com with ESMTP id 38megnwgkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:59:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AT3unvB3E/nMp4g18x/ytKEKC37ahvn0+82s7SmN1nax6nRxXDrSVajlKD832ahtNWokMkBvo9vQyTjMhNxlZpg41IxyQ3/NIKvocOWjPH37Xven8ySLGgpCNK45pA8iv5Us2A3NuL6m14kPTy4x+0iQuDPexmNhQvu5YD8IvIf6VGS6C1ByF3fFhLypFUOJsJWuEhCBx2y0N/W6Ydw0CZ8fIjVy9HyUcCchHOaSeSSRn9KBx8rW7bDhYyCbBUf7VwKM/v7AXzyoXHdYZ4S9pliMef8NR8GxXM2910atS+aUXpPEDPSTH3mj8oYD/g13JefnKO+X61loJUU9zz814Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b83EmVlCoRrMSuETMEZDPMPp0kKfcwbakx80CX0pG50=;
 b=gqJBXrhHrh0ky+UuyexH7RYoDnxh/3iRl0T/CapciXUGDSLaLg3khkB60VwkGHDHEn7C4XOai4il0ZC2wsrbHB4SUsGlYk9sJvLI6C6+1Koiodw1lioejZ2a/9mAe54/2n0/0G4yyds/ivP80I6/AegQ1enU4naMrYgYb6NVyGQbjgVx05T1v1e/XPraSSTxAxIyyd418VtKuzXdnG2s4QexARltecTbx7euuut/i2MxOoPUHdU6ANE4iw5a9UjVmYY7DL4nCRzfhla/AXR2yAjQAtlV3IdvqWYnjr2DD3oo7ijbBnHPj9WmCxKAxG8h+R1GzYPpts0S3Jcii/zOBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b83EmVlCoRrMSuETMEZDPMPp0kKfcwbakx80CX0pG50=;
 b=hKCTG5gtiRIKPJJJUb7fPbLhJaRXcsmvQE6aHpEicDzxjQ0Nd4UqzWep1CEF7IDIWdxZxfvJkHSzcUcn0Ok07j7RBMV/SuQKRTuGzy7Ww1gx5F4YUbJxEZTyYulynPpRftyX5rZdPo1EgJtMilTdN8Q+jsChObpb9ENRAFDHSFc=
Authentication-Results: 163.com; dkim=none (message not signed)
 header.d=none;163.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4709.namprd10.prod.outlook.com (2603:10b6:510:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Fri, 21 May
 2021 20:59:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 20:59:49 +0000
To:     zuoqilin1@163.com
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        zuoqilin <zuoqilin@yulong.com>
Subject: Re: [PATCH] scsi: Fix typo
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtsn3iro.fsf@ca-mkp.ca.oracle.com>
References: <20210521082808.1925-1-zuoqilin1@163.com>
Date:   Fri, 21 May 2021 16:59:46 -0400
In-Reply-To: <20210521082808.1925-1-zuoqilin1@163.com> (zuoqilin1@163.com's
        message of "Fri, 21 May 2021 16:28:08 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7PR04CA0053.namprd04.prod.outlook.com
 (2603:10b6:806:120::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0053.namprd04.prod.outlook.com (2603:10b6:806:120::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 20:59:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ed0f2a1-b494-4850-adc2-08d91c9b5f5d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47097D163DA1C56DFDC9D6BD8E299@PH0PR10MB4709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /YAvolylsdLU41H44WTdwBj8LDaFxyQqpGsDDUQP+hUAcSRz4Wlf/xrl/aoXjGiBTSNIQD42fMHyCmTvQYD/SST9cl2pxZsZdqPxjdLP47TIPLgDT5ouf2i+KvbpmT+0DKdoxWjhrhDPYTbrQIsOlwOYYfN+aZ6FNX/MVsYpAvWjHgTbB7naFR4AQ1vNoPZELMgmx5JB7Fa2SruaK8ztJbFHmJ5FJvL+EBZTUXFwwlJkZrHObtQkeLBgw97r1UEiWDBr+07k8qzy8PVR+vsrf2kYJ0FDCR2ipr0h8M6myaXcLmSDInZy67g/k1bZmtl0n7RA/+jwd+7LTFiowFAbyoF1yJgd3oKsytAnzJGBQf9Qw66veU4YPscNCibf8/T89Pt3M4Q4vuaRo0UBoPgivvGbxBSGYCbyS++FrcEEy3IelXF+Cdk3aXm+01a7jQ2Ucshr4YkS+8hn+c4ixLUgFku94DO8O1UhmR/I6KD5l6q1hRgtaW+QB4Vo3r0FXIOt0l6Pa8g61l+ViHurnCl4I7LS2jk4T8j/ubdnJO7DEKrLeUQv9wmjFTudhXi62LfB/HRcXXdg4pQ92CGw49esqnYDhA2D0lldL/O5MefAZModbaW3XLmZJjLSL+2uAssEvwN+0YnEWWpHrIAJNP3gx/qBIGQ5VrKTo+1KZfpb0YzfyC5ywp5qiCzF8HkhOQUn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(316002)(66476007)(36916002)(7696005)(52116002)(16526019)(8936002)(558084003)(956004)(186003)(8676002)(66556008)(66946007)(86362001)(5660300002)(6666004)(6916009)(2906002)(478600001)(38100700002)(38350700002)(55016002)(4326008)(26005)(1491003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Su3DHONoh8k8eAdnp9E+cMYFmLejVARbUGd201fmMLQz0Rjr5k5MSzGNI+P4?=
 =?us-ascii?Q?bN/d/yeCQc2a8rph5nNH6dlP4obaAmYxNp1eNG0gVCQw8Dce8Mq043Y8XpBu?=
 =?us-ascii?Q?jHhAz3HLE7kBJbj1lP9SlluNsBdHzs8A+fqv7Pachu+i/yS8nKqFBLeMW+BN?=
 =?us-ascii?Q?dIRJzM7JOfgZnAkGzi0fZ/CrsqAzrNQsmQRd8GcchU0tLzFU2QGYYRP3nHZG?=
 =?us-ascii?Q?wzblpTgiRQ50nwVLQL5R2oD23/VADBj86NwWUXnz93j1rwYBCXPUZbsxS/ql?=
 =?us-ascii?Q?jqkFJKnRvwprguJ8H5dJYjWuv8kBJ89DJHrNgaFsEoaEq6vlhiB9oVs/HVzT?=
 =?us-ascii?Q?6oh5GshxygU7llwnAqwAlrJvO2uEDVifNfF86K3MxJ+WaI1lAljA/766vIGj?=
 =?us-ascii?Q?SzSvB/Ttee0r+/Z9mqHTpfUQjgiY/8VDHYhiCYPdUdT4Re3+k5mUqVvBS9Z4?=
 =?us-ascii?Q?jeyleQ0sG8s84e6y7HKABfq/N7L/y8hul8z2I9AKpaKkcxoiaim4DQYkgicF?=
 =?us-ascii?Q?80kyyh3LuCO6EU44eeui/cTWI5nm5u+qdOGnLcAgxBRQ+wm55JcyZG8Ae2Ss?=
 =?us-ascii?Q?2DzsoStFdd/ovVK9L3kauySMCK0uwp1IU0x1QP1+QySge/p5e/nfo7jbnN6J?=
 =?us-ascii?Q?PnEGmgcI5R1z3yAN4Z5YOSpCCr5h6Iy/dvJ5uS6J8SjyhoOGvcMeGoC804CL?=
 =?us-ascii?Q?GUrJT36fNE66Gf1Z2ltF69HB3rJCrzs1hStCTGuXymOBumZi5/MPryza1/Jo?=
 =?us-ascii?Q?OALX9jeo+XwPMUsZqIdC07GkQxzO4zn5H5uebF4I5qNQAoIwE1fyCtAEwzph?=
 =?us-ascii?Q?VtUTpvonBg8cFCwPRxUYWdwBp/F9NngAoMkY9D1Okba6G+UZCZc2YSGo2aH9?=
 =?us-ascii?Q?FcGrETqgVDCtW+8TMcKD9khqwE2ZxU2w5aNjLM0DR5ma9ifyiW5QWp7WuS9g?=
 =?us-ascii?Q?xmmu6gOV4MhVzf3egyQjHm5ZQWvFCUJlUjXJZfnaLU7ZCStF0vofTzKjOZs+?=
 =?us-ascii?Q?FuvhWEgzNuEa5C23gYAD4Uy3SFLNYPnHXD1s9yDLxnsrcYDNNXPhuzMSEBMu?=
 =?us-ascii?Q?J2a3FETq+kxgaL9iVxdcF/d2rOSrvbphcEGtdUMaz5IKpTP3OborrxAVYxZ9?=
 =?us-ascii?Q?ppVctycOu4MQQsw7oS/wrZ/yxT33sGrNIa/KgbOW3JrkMFFR3U9A8XQZUWY2?=
 =?us-ascii?Q?AuVBGYz01EiIOBa8B7zc6TRAE0ZNQfZnVHJgKIjthoYTuNR0B+fba77JXYqh?=
 =?us-ascii?Q?quQp0cRwKQJIaKaDMd1lzZLhxv+/kZ/dtDSpMlIxPbCOCJqrOqfUd2FgsyBY?=
 =?us-ascii?Q?p6bHKphVlE9aSa4H5qQBbH7x?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed0f2a1-b494-4850-adc2-08d91c9b5f5d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 20:59:49.6234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ne/ojOomOThtZxLxOOtGdGAJlXNjIV1n8dvfo9lZRgHLpxRgH2CAdy0E38JO92IFBIr4+EtOmYf/zaAtiwNc2QxkQjF7uIosbHwZnAYmLko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=842 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210113
X-Proofpoint-GUID: romnY-yWdQDlWHrWKozH1QI0GkOdk-C6
X-Proofpoint-ORIG-GUID: romnY-yWdQDlWHrWKozH1QI0GkOdk-C6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


zuoqilin1@163.com,

> Change "avaibale" and "avaible" to "available".

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
