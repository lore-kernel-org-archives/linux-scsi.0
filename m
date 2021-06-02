Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51621C47080
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 224D1613C0
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhFBCz2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 22:55:28 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:17572 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229631AbhFBCz0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 22:55:26 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1522r6xm029828;
        Wed, 2 Jun 2021 02:53:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=oUGvvAbGlqK1i+rq1vCIUSrfT1oTtZTBMN9pw3I1/QY=;
 b=i6DOu0P1koZO2RceQ/MKyDBMZKLt/q4rDugn49QGKz4NOYpb7XMJnhtDYsXyTI5gHVoO
 uWmM60/x6Yeu9jy9zAFvRH74qaKzVkFVEMy/p2M0M66/P2+B2ViHaWklx346B3tBHb/5
 JODYcXji43sgH+NOXl/RzECc6hBgFSZ0xjL+K/ERvhqKm0cDz7DHDWqA9vGE5ahEq3uU
 5Q+weoeUGntqjqjfj8KquIl2bn0nIoZJHot+oHcZsQ7eA0GcM+rTx3VD7ASkts8jGZnP
 3osc6+BhNBEc5asyXOygatd2hk+0vEK/X8NocN7qaHdago7rbPOJ0Uc1KuMizt/2TQCU 9w== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 38wqjf06qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 02:53:41 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 1522reSJ096007;
        Wed, 2 Jun 2021 02:53:40 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by userp3020.oracle.com with ESMTP id 38x1bcg9nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 02:53:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaFWSK4a5VxxWdPo56w0fhQvkupiXDB3ULYUB9CgToqOAUZgSZfkJaJbTXO0fvHBrEi2nyOaV770Px/MrW9I5dYxp/CudMoaG2t6NMBQ10469CA0WcEM5Pe9b07keFPvpI0Os1MMsL3yJhhS+R48mhJ0wRZqNdHF78oy3Cvab+vuVMZWCYDCQV3MYnOWeKPdXrGq0ljMrUkA0zyYovjSt3W9BgpeihVB6VctPWXQur2hsESB49GEcr4F2NLFiiMWf+CF6l+a/y3HR9vkslLZD8OpydKBZpivRpO/1GokEui+sYR8Qb/U08hBFh/FvHzVI4L26W5xtHyCmPS7cezBWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUGvvAbGlqK1i+rq1vCIUSrfT1oTtZTBMN9pw3I1/QY=;
 b=ZNCX3zHbZhNLbi++LCMVLfTVusTu7QHVR0sK8byivGkpvytOTwHkgRik0yaJr7/0ImADztRZZLu+iuXofey5fLZYV1sxlUYaca97I/TLawwgsiGabkWQ5m2S8iavNhoru4JGRpx1yiIZIl/jLNE0IyvhyVzFdZNRKASnVjCK4hDCCsvNdjNV93K6FzJl8wJraXlqlQQSMg8LQuA7EfL/jqnqo3HCe/zPTpaQEKeO9EQHC8tf5lBrz5ZiX0SrK5uzeAGddLQjqIbl4j0Fw80YY48uMSPHMtqFK5lQHTykoRAIYL8kOkvAysAbFPODG7EzFAif2dcJgpIGRDLOuYNG2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUGvvAbGlqK1i+rq1vCIUSrfT1oTtZTBMN9pw3I1/QY=;
 b=eXT/Kk1mtF17dgdv+lph5NUBXExlLPKl31FhgUyq5LxDBxbijSCdPehfdopmIa2ZSUXKlQZIZCKBaR9TrZ4uUdr3032vtt7rvt60PcJOrWywy2U3VX2zOH0a+/474ImdzBpTfK/dbuoPJEvsXt88C9JF5ri0RMIpLJFh/GHjAUw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Wed, 2 Jun
 2021 02:53:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 02:53:38 +0000
To:     David Sebek <dasebek@gmail.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Set BLIST_TRY_VPD_PAGES for WD Black P10 external
 HDD
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czt5q8wu.fsf@ca-mkp.ca.oracle.com>
References: <YLVThaYJ0cXzy57D@david-pc>
Date:   Tue, 01 Jun 2021 22:53:35 -0400
In-Reply-To: <YLVThaYJ0cXzy57D@david-pc> (David Sebek's message of "Mon, 31
        May 2021 17:22:13 -0400")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7PR04CA0221.namprd04.prod.outlook.com
 (2603:10b6:806:127::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0221.namprd04.prod.outlook.com (2603:10b6:806:127::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 02:53:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 633b48db-b831-4ba2-b56d-08d925719f40
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4502E73CF6E70B30D8C5E7B28E3D9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aVfDXS8eIbJH2Inp2tIC9CbtDSymOhCQEn/Na89GJeZApJe0d9dhgqUOfboAdu8X7dBdZjhUZSSBI1xBunCfCftS/kQf/s3SMgLBSu0JQddF62Jz/8cuWhVHsxwSf3m3iNX2pgRVBr45Z3mhhGfHKCyUJfxA3TPTPNbY+8oko7CYoBKQRq1zIp9hKQkjz34SapyVTWb2DQrHx7Ij15ZJHZGLYyk7n43OuMd7bjuOhrWMlxpHkL6/zbCdEN3tbPV+voRnMJ/JKqHUhZogFO6dFjCNdkNb+bLgnBVdm9cHe8xbKpowGq4/CaM0KxkcYa4ORKVqFLs6qNJfl/iyw1vKgB1OesBNAqrin9RvpqYP2jZdgF6vvkjnpGSQn9tuhqMj5QqWAt6jm32QfGLe/48965gvU+SCEe1AGdm05wFluXA4l2cNGGjQYVkf03xEJ76QECYm8TguwPBO96jGQ4WwNe4SXYuuBLIWZBkq7uTRv3cGosCqdcvT1Bfg25/sZ2FK3emIGN2HRjxHXL6f0YgCPEtErORW7aP4wNLaBuS4hE3+z/3+FoehN3BR0AHvrF1XI49sVU1ERuHYRqGak9eaarHsjbB6ykaMZoYhC2OO8VD1QJfeNQlKygMZSCQcjqIw5iLkkpoVsqyTJVG8PlkQ/u3bafmYB9NehEFfhD0Yijk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(376002)(346002)(136003)(7696005)(52116002)(186003)(5660300002)(36916002)(55016002)(26005)(86362001)(8936002)(6916009)(2906002)(478600001)(8676002)(316002)(16526019)(66476007)(4326008)(66946007)(956004)(83380400001)(38350700002)(66556008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?f4r6vRslY6axfOY5e2GXzE5zCdN6+lscgwOvFRbwfE01z5H3O+IxQ7LcnFKl?=
 =?us-ascii?Q?XSGEoKeGGgR95/e3dZXlpLJlw/ucwEhyCDN1pMeqeuSOW2jYKT/jy1+istLy?=
 =?us-ascii?Q?G8w9skUp31h29SMzf6RjErPrqL9Lw5wqMfTjElmJAcCEKm5WuuKkF8ocsjCd?=
 =?us-ascii?Q?kjS2vlljsNFtDzPH4C+QKzJREqVmLRQ2AC2l1TvX3JCLDYLK+AaxHm9EWEBu?=
 =?us-ascii?Q?r+uGk+Il7YEKJa2EIt3KHFxtIQp5kMwQZzhrnSV0JUDA8KPE8gkFvVN55AtG?=
 =?us-ascii?Q?0mvwgN4MDXDD08UOy9/NzXwUJeCdyhCLwHShn9N0RX7JzPy+mWaPBzBk13/U?=
 =?us-ascii?Q?jIVduGQr9Ve/6MJCqnZakjxYbS+CkqG55pxmnK3vOyHx/K/vDxSzFmjziCNS?=
 =?us-ascii?Q?KXGgV5Kf5/8oIelc1VVDXekcpF4/Ry+mU12WhFkK4jXE4yFnacfmZP+SFaIv?=
 =?us-ascii?Q?yfbO2G+6WEzMnfAD1M6C29sGn7yQJTcDfFYpz6dmXQeAZzKbhghi50J5MTuS?=
 =?us-ascii?Q?CrRYc8ROtbtFKvVP3Anf5RpWkoPyAcDwHiBXsbLmUIuH94CGORD3kKh5VRrR?=
 =?us-ascii?Q?Rplk1ED3V3SJg7zvtS/puG7vKQSxBGxxrSF8MmVisGhBC0l7OhiNBu0U7uPc?=
 =?us-ascii?Q?Uo4rGxTyLbVrUFQaEA8cymCDnnrt2wu/36SAHI6N/2CKjeT2dlv0c3k2Nh+6?=
 =?us-ascii?Q?roNidZepUw6AUNeQa7n1l2tsESPzSy/efFcnffCVQ5K4oed5iPjdyjNHOfMd?=
 =?us-ascii?Q?954iPoU3k9il7u1WUSWjPHPWHNsaRUVs9lCZuMtMEXdwIrZHyZCe+7MajMvC?=
 =?us-ascii?Q?8RZDmoTRDKqYGrmcLLbkAEW9yo6Jb6fdeIB29x/0DxGRha3D7x1aEJcBGTkq?=
 =?us-ascii?Q?5HCbWqWe5gJZYhGcKxa8XjseKIKQLX8W3nmqSUXHNnrBZZfGGMGQGkwHOqVD?=
 =?us-ascii?Q?lqVHLu2AmzFdP7agjNmA6Ki+Xyz1iP2nY96Rar0V8JlpeAZAr3LOglgIgS2y?=
 =?us-ascii?Q?KcvGZQzS9y9prn5d7TXVDPNxvxlbMT7KoPsyLU08VhXWAVjPspCyhym6uvZv?=
 =?us-ascii?Q?WU2aBdUOvHRgS0lRR/LVIhEE7HcZem/pEUY0gDVQRXRb4nit0gpNsPArjjme?=
 =?us-ascii?Q?dgR/iiNRa0J1Da2kxX77fHMPji+EjMyyEIPmBmDGyFVuaYcJyR+EtTGOPyFQ?=
 =?us-ascii?Q?HZxdaCa02PQGGMFKKxoSVQrmMn1ZkcpUvOmW36HYHBr2QK852inzZdmR4a+V?=
 =?us-ascii?Q?L4bk0RU32Fuo+rYVba2wQlqrcwGtqvUAp6W1NiRgKgKhXoPG2lLOP1xBXqBz?=
 =?us-ascii?Q?39hy/8K3nB6q/vAqvk7JpVlz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 633b48db-b831-4ba2-b56d-08d925719f40
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 02:53:38.3882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rMiGsoTxNa2nh02EcdCryWN7lGqXmtNNldfR0YTRBtPvKWFJS1hiurGI2NQAu8eAiua1V4Et0wt0ZT59Ig0LpaRYO89MtKKrNPGqui61WUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020016
X-Proofpoint-ORIG-GUID: PUVf5Fl9d6rL0oiNziG-oknInlK_kNEQ
X-Proofpoint-GUID: PUVf5Fl9d6rL0oiNziG-oknInlK_kNEQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


David,

>(Currently, there is a bug and Linux incorrectly enables a writesame_16
>TRIM operation on the drive

This is intentional as we support devices which conform to an earlier
version of the spec that did not have the LBP VPD indicating which
command to use for discards.

I have a patch impending that postpones enabling WRITE SAME until after
all VPD pages have been queried. That gives us a slightly better
heuristic and removes a window of error for devices that report
conflicting limits for UNMAP and WRITE SAME.

> This patch adds this drive to the scsi_static_device_list
> with a BLIST_TRY_VPD_PAGES flag. Although there are comments
> in the code indicating that this list is deprecated and that
> 'echo "WD:Game Drive:0x10000400" > /proc/scsi/device_info'
> should be used instead, I haven't found a better place to
> persist this information.





Moreover, the list already contains
> a similar entry for the SanDisk Cruzer Blade USB flash drive.
>
> Signed-off-by: David Sebek <dasebek@gmail.com>
> ---
>  drivers/scsi/scsi_devinfo.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index d92cec12454c..3ed558c168be 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -256,6 +256,7 @@ static struct {
>  	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
>  	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
>  	{"WangDAT", "Model 1300", "02.4", BLIST_SELECT_NO_ATN},
> +	{"WD", "Game Drive", NULL, BLIST_TRY_VPD_PAGES | BLIST_INQUIRY_36},
>  	{"WDC WD25", "00JB-00FUA0", NULL, BLIST_NOREPORTLUN},
>  	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
>  	{"Zzyzx", "RocketStor 500S", NULL, BLIST_SPARSELUN},

-- 
Martin K. Petersen	Oracle Linux Engineering
