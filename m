Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08975C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4C4C60F8F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhHJDcm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 23:32:42 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55732 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230095AbhHJDcl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 23:32:41 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A3QmOS009595;
        Tue, 10 Aug 2021 03:32:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=W73F91mxEwdYTA3wKplRcCX4jWHYeXmQcoDHPYpvNhM=;
 b=tJArychSXD3RT7j5TklICun2QcaOmRh3/IfTljFz05Aox+0s1NQ91ke16cuq8p8Qxkkd
 YYdvtLbOEW961asage8jaR0VvQ44Xej3xKaZ4gEDgfeDSK0IiB3Hf3nmStVjUjoe+m8y
 90+uiZUJUKtx4KeJCG4wkIdJYPKcKo9M41T/ieB6XOQs4B2UkaEv/ReXI066JT6AWnMC
 4af3IDTIeiMdMIHQ/6laDKUtz6qb23rIez1hR91EcLizO/l8HS61bJWD8YXWJ37yESaY
 NSEPHtWc0z/5BlFQNgWJjSoCWiwpLIqJkS5281PmRsgDuFFDw0q6cYAaWSF6XVd9/ceB cg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=W73F91mxEwdYTA3wKplRcCX4jWHYeXmQcoDHPYpvNhM=;
 b=UpdUJQUFXmHfz2E0W3gPNcJnsIitZBChHhulsVTiX8UXzeQOzoQZ1Szujv4T8is+FXYW
 1mT+fnJG3pxN4v2zMqzi/Gy2YYmnoCQZJaCHpamQdlxADtHqc92obfavgjkfhSSr2W5D
 P8qHOWHB/0ABP21JbAcmzqWJAkWPen5JwbAL3WQ5pUq52vKP8UMeUE7RzYWbhQcGEWki
 hOrwOz3SzKYVGdMsjnryoe2w//+KKOFGTb3+geENpeOU3u2jVjtQitjgBQIdSR8BIF4K
 Elz9kPXxQEbu+8h/M/djHtrGfUeTZfuCQ7gcnGzqdBPl3TjaOaN2wEQB9ddW00bnTV/z CQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ab01rac3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:32:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A3Q6av088460;
        Tue, 10 Aug 2021 03:32:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3020.oracle.com with ESMTP id 3aa3xsax5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:32:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwSA/THvosqBztq3G6VBs8tXYQ1if1+AwVYJQEXNSggebn6eYnlHTN3ptvVT1zF/zZkRZIwwTKvQ/hwNFzzG50enz9viIVhlVdOmCGMKAVjgE8BGJKokqAaf+AfTL+EbTOZYku3lWeFpW+STyn8TYooEhJnCa6cgptY3h8yyBSUbzHVyXjT1S9JrSZF8d9Csm0DVirQZaxHZsqAlhSMTtt+uHzB8UbK6i3Ozgsru69jG9lizdC8vkFcXmPq9GPOkWPi8rJ7sOY4UdED847eOM5vo28vt6dJqdXf0uVcXdlz2Qyp125Kiv513MVEkW33XChMKoZoSiNldUSV7DZxHhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W73F91mxEwdYTA3wKplRcCX4jWHYeXmQcoDHPYpvNhM=;
 b=NErSV8qSENW4sIWw/VeSOIBmnOuvHRVJvOtc4VP2l6knXJ+TQ1wVQx+JWL/RBinok9iNyHOG4Lrl3gvSuKIBbmnd6mWAVs9n34KduvY7xbJ4ZVDYnkqIFX7dBgz58y733khV9W8fNRYyvNDeyowx57EyZXqORRs7RGPn0BMwp67wqm7e8zxEgsyYpRC2wYYZ9PLuy3HpXfbhlB41BAmgfIiDlMweRDtVtCZrych/CHOTN8ySHGwjZ1571N0fmBXI5YhL1TdbjasHOex951gZudFQgSuuHQPaVOwjymL8KXO5nKl+O/ZjqqRzXT0LIgk3nhcztWStjfS7BG4dyjEcng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W73F91mxEwdYTA3wKplRcCX4jWHYeXmQcoDHPYpvNhM=;
 b=BsLMET38rIQ5I6/jAxeg6VgKaiY9cR74hHuIX6L102IxVGyKxMsZh2fULtirvouKMT7OWfiQ2b5abawC2bpnGVr4gTccwhVOuJObEFkO0f408Oc6Wgim+HYa7d94yVIuiEbflzzVZUJrRwQ2QjHBtNkboXSIybdork1CYaWbqAI=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4534.namprd10.prod.outlook.com (2603:10b6:510:30::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 03:32:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 03:32:11 +0000
To:     Wei Li <liwei391@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ondrej Zary <linux@zary.sk>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <huawei.libin@huawei.com>
Subject: Re: [PATCH v2] scsi: fdomain: Fix error return code in fdomain_probe()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s1avuts.fsf@ca-mkp.ca.oracle.com>
References: <20210715032625.1395495-1-liwei391@huawei.com>
Date:   Mon, 09 Aug 2021 23:32:08 -0400
In-Reply-To: <20210715032625.1395495-1-liwei391@huawei.com> (Wei Li's message
        of "Thu, 15 Jul 2021 11:26:25 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0028.namprd08.prod.outlook.com
 (2603:10b6:a03:100::41) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR08CA0028.namprd08.prod.outlook.com (2603:10b6:a03:100::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 03:32:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62329646-7dc9-42e5-f021-08d95baf702e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45345D0D009D61706BCF52AB8EF79@PH0PR10MB4534.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IsTjNq9lDTsvqKoH0FtKCNepZ/9KWlWNJ6rwFd33IKAbF1SIiKG6Fv/i+5niqxBF18YoKUd6Ye3t54w62uaSyBPyEF6G3st2t8XlVirUb6MMeK2SgB+R1NCJhcFPIoaCnVCTuhD43cerCx37yFOYfeACYVTmaqNZIn+ka87vkVW8ob7qdXv1DDbpSAwsYJ2Td7wTlW90UWeigbicOusFFZSejF5N2d7dqJquIzbFJfBebFIv+Tm6puC/rOwf+enFeSl9DJSx8SDPlJPRAzp9XbDygf8/Ys9OJgpgIUDRtYiebR25Msr5vbY333y1SuJCQqsc1o9wij+wpNQTZYEkqh2sMzNGnW1fXieWtzI+30KsJ4Plw6efMV+WNYiZ3orSYbRUr0DUH/tTJy/cVyoq7RBKRwHtQUw3HB+ZY3MeuWmIT5Hyybcn34jWdn3G3K8iQG3gbm8/GH6iErrmJ0jrCgZTE5wXLRdEvc5Oezm9e3Nmhsz19kFA8xcd79PlgmQ0O0+K1+h+iJ9YvZUNMMtt7X2qDN//CgLATyqx67NP7vDP1y0X5/GqnN0yn1fK/35DMQwuKQW1xWTduGMUmhQ82m5Kt7ckjZGfHmZM5zfTsj7hErPCrm4ZWEUuIjlXUf+2coITLc7s1IM0bDe+1+Ko3GqKxpJBPjXJM+y5SnPt5ejkpT6sIYZ1OFN0t1vlEm+3k8GeLLmVJ8CoAl7FAs9wkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(376002)(346002)(366004)(66556008)(83380400001)(186003)(956004)(66476007)(66946007)(6916009)(2906002)(8936002)(4326008)(26005)(478600001)(8676002)(38350700002)(38100700002)(5660300002)(316002)(54906003)(7696005)(36916002)(558084003)(55016002)(52116002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RUFT7/Cnq8K6+JHLoX2C0ojTRx3PiGhoG615TYd9wyXfFpqUYixsiEl7004Q?=
 =?us-ascii?Q?n8SUH5aZ5KJvMs94U4Ouy1/MwxncqhrjnLHayiuiPNg+bi5VrjLZgUcnL7NS?=
 =?us-ascii?Q?9LIeYlp/iK6jbuWuEgf5vWm+42W5iSsI0V3KYvNV0sYyNoeCvxbbarBh4C/R?=
 =?us-ascii?Q?tRh92Nrw2nq1A+9DycrOSIcJkGzkEMsRYzpSR4eLci5X8c6Ur/0X5OZMCJkm?=
 =?us-ascii?Q?gbzqkPxFGIhFM7eSdy8cu3fumF747oo4T+C7k2x3GzLvQGDKFAtEmMA0Qs8e?=
 =?us-ascii?Q?c4fEyeC3w2RKB82o0uQbPBmPJNjCxYVAQMYsI4hg0+5minv9zgEc2tKtZ2jv?=
 =?us-ascii?Q?As6NswXP3kaKAN+PHRN5Lv4F2OkWS+EE0A7e04J7F4CsK2MR1Sq43vFrHFOy?=
 =?us-ascii?Q?RGlVfg07a8QBLSmnlmEArvSvJYF8Yhqis+KD74t6CRvy75GWG6WcEWmLMH58?=
 =?us-ascii?Q?K+xBjNe/32QNzq22g+7YOFCZzfEi4wNvJQ60A+CKsP9A59XIBW8w/i3xv1Wq?=
 =?us-ascii?Q?d7RzGraU5CIOX3O0rqNAeS8yKWjO8x86QjzfhelsMUcSD9sYfuwkNx1UerkT?=
 =?us-ascii?Q?dY2BfBqr1QbX4L7Q4/2FUhwZHfYBr76YEJLZ/QBLDcnFKprl9/Ac234guL2m?=
 =?us-ascii?Q?g4D+HoNMykBcNEDpOa67Kc1rCQlXqFe7bMxa5o5elLUBlMxZCzm0ZKgvCG2n?=
 =?us-ascii?Q?nfmM8kXq5lkEQ+snD/TbWVTn5zSpPUNk2eMQPWBn2OH1iU7ho/W4lGzDxiWe?=
 =?us-ascii?Q?VvMXs8ffXgOg9s8AgLs5mvvoWwIR0B8CA4+U9EiSxju003x+L672R4N1jGcr?=
 =?us-ascii?Q?bYKz4dHwE7ryfTAoBqY+k2ZIT73R3cglBD8ABIvwDVrUk/zOH3Sug2hncpYd?=
 =?us-ascii?Q?LqHNu9MA1UubKXk/KCxhqxrkl5fLGnjowuF+I9b6F4Q8CFJJkMbiv4vpCReB?=
 =?us-ascii?Q?gUyFBShxbqnWzPZ/ZoI8aqLWweFgvORAeJhIsIepVu1WPEK5rUX6/Gz3SxAm?=
 =?us-ascii?Q?ozDanWmablZpU8FfWrNEEiNQG4FZN7VqjEhGTrsZMmM/Iw3joG+DO3w378DB?=
 =?us-ascii?Q?rDORu0J784JEk7Fq1NKatJ9pAZpX1rf9AaSX9XbeTLHYF84vNj7+6yBqHgMM?=
 =?us-ascii?Q?BMvhDAbyrAN9vwTK8N4sF4xVA4y+0GAoLJUA3xchGXZTK/ZCg8+CqSMOIoYe?=
 =?us-ascii?Q?3j00JJ6L/5BVMOBrv5birYriqcGeQtuvzo5TnRWHl3Eosad0t5P7bMVE17Ph?=
 =?us-ascii?Q?oWNj0O9yOQau+krIAmxZgjQM7ctiiT7k6Svy1pmaAO/OI7DxR7ApuyqL3ozY?=
 =?us-ascii?Q?OM4tQ8CYyPgeRqFQDL1JefKZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62329646-7dc9-42e5-f021-08d95baf702e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 03:32:11.0010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMzqKP0e93NBqt4c+hcmwZUw/b9R2sq7poOFAvLzIwDG0pAxgL5PK4qcPEAZxXG9nVr1QDLud1oEwdSCqOLxa4gSmWj9GRk1sW+kd8aHsbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4534
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100020
X-Proofpoint-ORIG-GUID: 1CCLtg595_62cPmG-dGvfB9f2hMlVpxn
X-Proofpoint-GUID: 1CCLtg595_62cPmG-dGvfB9f2hMlVpxn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Wei,

> When it fail to request_region, it just jump to 'fail_disable', while
> the 'ret' is not updated. So assign the return code before that.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
