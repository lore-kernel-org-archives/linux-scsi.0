Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74C8C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFD6461211
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbhIODnF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:43:05 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:38414 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230076AbhIODnE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 23:43:04 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18F2g7gT017546;
        Wed, 15 Sep 2021 03:41:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=zqda6JJ/D73mjCPn8y4ThqSN+mGgltnE9lanWCWAjYs=;
 b=H9eIECPgTu/vwVpveVgdSPcho6T7NQNvNiGebOSOobSpQ7Ep+GMw2gsW+EpvS7JzxQ2y
 AHwsr4dh5Cge1+kSUtx9Ifhgv08fbfTyIYljv+gMzICMlbI5s07wdeG8fJPi3GuIGZ6q
 EPuHJOdxzjqeSQY9vuXFC1XCg6OxGiWs9vGw7IhnksoK1v3xy0W0n47oZG8mvtTjvqQO
 R5JJsEP8VSJTUA1DhgXI1KBZfP7qi/PqaRV+qXxp/smWMWyAG7ChQZJrxCfRJgtH2mVY
 eHhtYUZQno0TtQdu1upQrboqxBPlub7mD/3p0WCALL54Yb5k8Bn2AUwYGL2KnIx4Q0MG hg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=zqda6JJ/D73mjCPn8y4ThqSN+mGgltnE9lanWCWAjYs=;
 b=BW85573fhgfdOYZcXKng8haGhgOgYFr5fdCMIjzJGZlAofFOj307wyRF1Zqm1fu2QjhD
 TWpSNw7Tw+bUVdePIFWp5TXVWxXlkLe2nevdEn3MnacoTLo+A1WVJ+qTeHBC5DRPHO+Y
 noWmZvVfMTBFafWxDHWjmC46oM2rS3GLhArJT9y0+47wBZw3T19FF6TMcHK/Gk+XW25R
 9wumR/hbzoVQuDScVPD5m7jLKHD61JNjzjxU/vTYA6ZYCa8PCKjaDOiWs+UsR2hTbiSZ
 DY7WkXfOKDDH7Q+D8zCw2659FS6hPwuB1Sz6c/66shk5YkCPFOUq7O9D0Xq88r3aEKcb WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2p8tbfgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:41:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18F3eYSr040526;
        Wed, 15 Sep 2021 03:41:43 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by aserp3030.oracle.com with ESMTP id 3b0jge0hbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:41:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJ8jJhUWbB/J9RqVa4LFxFiHo475MauIfPmIshHuzDo+qqCrofJImfo02My4wXREZSrN0tSdmymRgs6e4E9HlJ/iuCTxhdwnboo53+Z3qVHhyd/DoRae9kv4JlJ3+Dnj8AqWsgeUlvcVzWdzrtbYrw3+PjdwWwp5JfCVHisldwOnZqQvTR5haywwbOhXVPDi4GGm7tUnx5tOXbCQAay6lsPgbMy8FGDcMjcPkejB2Qd62hjZnIs5/5BE7xkbG412MloQESnlADWdMkKg7nj7dfJOHmQU7vjObvStwjl2MTwOQL0XAawden/qJs/hxBHdqGb00WBAdO0Ga7MTlyXB0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zqda6JJ/D73mjCPn8y4ThqSN+mGgltnE9lanWCWAjYs=;
 b=Mpvba88IbayMbUV5L43hZ18uRPVyArj/Ix6AmObJ3C9uQ/JCn+MkYB/ZDCagejpCtv6THMtp0NM19FhjqRx2IIL9KrYJpGgBdyAUEUBrSgRCiLUrAUgcaDMhONa5Wp+8UQGhM4nIWti5NNWDZyHOogDMC3KqKkFhbcJD0+Bwhx0DVrTQFTu4Kq5f6qPIILLfdKL6sRcmMNaqGw9Pqr3sLFmXutPRmKcj3CSPtUKMtyNjCkSXlG77dxFT0mdJ0SfG4qdTVy0T403xOQXCdGaR0zoUKo2c9qdUgkkgmvs6jtigRHsnEOCpcWOg6vadEiWjmpdveOeGBDrzxoTQCD4yLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqda6JJ/D73mjCPn8y4ThqSN+mGgltnE9lanWCWAjYs=;
 b=IHxxThdI41KtDSoXBP1W6P5Q3sJUyPe1jfMyMPMJdNkjv5rraN7GHB2UUwBp69E3+uux9XgTPldUFo4LP8buDXvtnQ3tREJT3IqUVF37OFXpnDKhUw09FiZWqDzuTskmWPc20JFPt9/Z4ZujPE+k3tdtxZQdjE+15K1HPqK5sgk=
Authentication-Results: smartx.com; dkim=none (message not signed)
 header.d=none;smartx.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4790.namprd10.prod.outlook.com (2603:10b6:510:3f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Wed, 15 Sep
 2021 03:41:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 03:41:41 +0000
To:     Li Feng <fengli@smartx.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org (open list:SCSI TARGET SUBSYSTEM),
        target-devel@vger.kernel.org (open list:SCSI TARGET SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] scsi: target: Remove unused argument of some functions
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0jiv72r.fsf@ca-mkp.ca.oracle.com>
References: <20210913083045.3670648-1-fengli@smartx.com>
Date:   Tue, 14 Sep 2021 23:41:40 -0400
In-Reply-To: <20210913083045.3670648-1-fengli@smartx.com> (Li Feng's message
        of "Mon, 13 Sep 2021 16:30:45 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0154.namprd04.prod.outlook.com
 (2603:10b6:806:125::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.50) by SN7PR04CA0154.namprd04.prod.outlook.com (2603:10b6:806:125::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Wed, 15 Sep 2021 03:41:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 506f1d73-ae60-4069-af2b-08d977fabb46
X-MS-TrafficTypeDiagnostic: PH0PR10MB4790:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47908D842996B4B641576A6E8EDB9@PH0PR10MB4790.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kSvzXHv+mMdOLaioyTYsH0kztYtT6+toPJ0CfqnuH9YoC5VRHIo6XkKGsXJd3h8SLIX6WjUs7p0s2jwRJzLhFFGVoW0CiF0FEqpusmWPCyZ6UpTE7L0uUTfKfCtYYgdgFB9r/b5tX21jgm2BqLmzQAazs6D7j/jVH7N72OW20h+swxUCaCGSaOv2whLjpRTfzW/LY+YHHY1djjbGM0ez6G3ihP6WrW6TDac15BX5EnCzOI3c56NCa9HEEk48VKa66+lh6PBW8qHhkxdPDckQ0YSv/+ViwlHgJiQqjkBiW7b1OSgOAEL8YVQqeTqsD4xoCVA5Bvwq53BmseVbM7S2JyZcMhpoHoMpqsLv1KfZ2diep/M1lK5C3+2s0jCH7QSjN/rNQNrmg+hq4CT6S5gH+IjeI7Iz6/vSvW0KHfrpgVLF5nkSEFSBrhB8eeaKtcowF5wYxpVDAmda5fMMjXO4ol+5yetuDTIjtzqhYCp4sFD7Pk5iZ8ZzsmoA9Yn+CXa7Pvin0jnpzNBh72XUuBHW8F9UJMx1Bo4UIuHTo+CxS8yTbinJmE380TV+4916niGbMEazupwI4NM8CeU9W28zFKFVUM18dpt2kGqUpGpHLD2KZaxp5UlYa6t/RqzI5IRm46NqijFq3+HmyNwHbnXd8yJwn3W0iguIVrEr9061CsHepIiFJwYXUC/ekXjc31oZY1+s2neAvBNvwOecfcG3gQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(136003)(376002)(39860400002)(316002)(6916009)(36916002)(8676002)(52116002)(66946007)(66476007)(4326008)(7696005)(8936002)(558084003)(38100700002)(38350700002)(478600001)(55016002)(186003)(956004)(26005)(2906002)(86362001)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TCalcdDNL4YXX1fGKiBwD5psFcPRfmwW7Dc3ma+USpykgowwZEH7PHdznsUg?=
 =?us-ascii?Q?m2jiDIz80YFNb6nwWDwph5SHqHzPBrbVqZOWzzi1qtOI6J9SGzWYrKOY6t4T?=
 =?us-ascii?Q?5Vj2sHAEe6jtFBsXulsc4u9SFrSHd8tCY59W/P1dlZxllMB9pOZnL9S3ZjKG?=
 =?us-ascii?Q?KvHeMsf13cCR5UmBqOlsDMrg6BL3GiNCeXPU75WcMF+ZYuMZfIKRYKUC7c5U?=
 =?us-ascii?Q?MIDVMGf6pgxWP2nPujTqwRPUsuo4yMdAQ5EfsJD8TY6HCAHxpwvw6OxY5wle?=
 =?us-ascii?Q?UgGOe5iig7J29ybKWU6TjOWNqJFgKCBkOCLDDrRSHjh82IRfnlcTtUuT3aXF?=
 =?us-ascii?Q?04Wz2NJLaNA+ZGtifXs6jpvTEfA7Z/ivZfD3e+nW/2Xl9xePGLAk8GUdjsLB?=
 =?us-ascii?Q?xNZ1xEhJL90oMTbAFZozhP7n1A8Fo06ofI/DheOfsN9ZF0WUKIHiBXkm72QD?=
 =?us-ascii?Q?LnOzud6nouPKZPw7wNvHUfnjCtsrsXpZJJU5HA4kEYX2QHwn2lVWEpuCgSS9?=
 =?us-ascii?Q?iUlXD2QLriVRfaXBhUfcbcRj7nQaRNHNa9U9K7dGJ0yMJ5N+FExNgg4YMEp6?=
 =?us-ascii?Q?LVmVzBaWCH5osOOrM0IsQuvMNpXvMeEgo9dQ377sCcS6ou6+SKpyEEYKpGGt?=
 =?us-ascii?Q?rQupu7kdlYp94Wz955Ct5NYjWhuFKFbjDFtZ/VUowRD4p3c06IPGy7zgqe4w?=
 =?us-ascii?Q?38jBeu1jaVbVUR43cS4x77hDE0c/Zu/HfPESFdt74xRELfQWqnf/rvZ7T1Om?=
 =?us-ascii?Q?SscFX4N/Nb5xU8rEFHhWT51Z++jqQCm/VCo6ITxlzgbh029wGVKEVLOglHBo?=
 =?us-ascii?Q?JZdZMQg4GA8sw4aanSyEZvvVjNBPQi9PMWVcv9vRdTlkJAXak8MpNIqgR1wp?=
 =?us-ascii?Q?uplNkV9nm9eAwNOcy0NUgOzVU68Xw2f5UzVxALcEeAhq15/6U3AFuspkqUhu?=
 =?us-ascii?Q?aqC/vXa5Oot3EfZQKoouM1es8UKk7CE6yU8LOOy8x4v2wQucR2dyRxorpvQM?=
 =?us-ascii?Q?QBakxV4fwZFEwKk4u5B6pNhsjRpPTANXsf9SkF2MIZS9BB1IutRyQmLal6vI?=
 =?us-ascii?Q?W/GZZ503377rwcWPqW9hMtYYh/yxQ0ecpBkIFYY+9SeNfbaAixCsVdd7GT4f?=
 =?us-ascii?Q?3eECVbR5OoMBE0cqwhE2aVUGtmSMeQltrOdFEqrL3zgDB2+Q93yvEGJ6c9to?=
 =?us-ascii?Q?djYazUHXtXE1KQ5Vfxjcm3Hu1WJZJ+ymx+IpvRoUVaJ9mCYTkDa2mi4AKmUQ?=
 =?us-ascii?Q?YfiZWN6qCWIVt/d1YAp00phiQGFBHnY0ZT60esstSpX+5uh+pYlB1PZ4u1lr?=
 =?us-ascii?Q?Sscs3TjQYF9WJ8kJraYM4uyv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 506f1d73-ae60-4069-af2b-08d977fabb46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 03:41:41.8749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZYUXH1DkzSqoKGL50vrlsMB6Z+1glyI3KPD4sl1m2zgx6OaGqGJldRhMCF+bujjl0EO599TUAB066Wl2Kmc1P63P94LQeOjngWgXWmdPzgk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4790
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10107 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=853 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109150021
X-Proofpoint-GUID: KGaumG0q6pT4inQAUyKGEsrLGrRa9Y_C
X-Proofpoint-ORIG-GUID: KGaumG0q6pT4inQAUyKGEsrLGrRa9Y_C
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Li,

> The se_cmd is unused in these functions, just remove it.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
