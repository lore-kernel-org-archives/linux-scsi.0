Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C08C5C49EA7
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAAE0613B6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhFPDvc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:51:32 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61152 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231186AbhFPDvb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:31 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3jelU005731;
        Wed, 16 Jun 2021 03:49:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=HnyHjpExe7DWWsnBpOiuSXOrRE8pkbKsoaw14g2bbBg=;
 b=Ex0Vk0Sqn2JVlDX54WJdQ3RsezlawFoTZQUoTJBe5ij/8gHNdp+d7XVxFOYaKI2D0tU6
 a4ScDIjtTKwHITOkoQLaOl9ivJV63QuGV+o1T+R/KMvZRDCuLlFBAxRyrsl/8mEQ+cI8
 di2i5CO8afzPYuADb2ejXyNKruZNbiNCNM80j1wgN//BDLVVkEFX1zIWKmjpOKBMYFaJ
 MzTdfZXo+mVzGp7ykbMTl6Cj+PS4STJm+/70mQyVWNKejbOEm7aqVz0mMjDT/psjbTUH
 tU1OF9LeVAOhEEz8qdQwWc6hc+oz5qSU4W1zR5jCoht1mE/XlujBU40NZdad1tz4Ae6j Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 395x9qstxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G3jFQw147408;
        Wed, 16 Jun 2021 03:49:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3030.oracle.com with ESMTP id 396watxnry-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+QKrOX3boUtULJLS2AFmJQWqxIbEVi5kj3OU82K2BE/9U0ewp2RqvY0jHeioHp+snNJ/FRl5LCgDmD7byhGbE44DbdDPvp8u1Yf8JYyDSG9xw1FCs7IKXx3NRcXq8NByIV5acYTocVsrv6/r0woHAx/lxFZl4d5nZrTrDx353czVJGSG2XCnd6+NRNC+Zr2OAzoczWArlG2Q7u83rRZ5PQotHihfHjc67j+BJrUJGi78vaovn46jD0wzbpHQvkR8/BWIHL804NE4XH65kKq7YIJMYBhap9EA5fN6mhDfJeM1txanrjB88m3xmS509/YQ0B7yRQrLIvP9i/yz9E2tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnyHjpExe7DWWsnBpOiuSXOrRE8pkbKsoaw14g2bbBg=;
 b=BipoRyOC8tMNgrQRCMkUIAqZK/yHe7Edz9AtkSNpPYuy4gsyvs70SIQNNfJQ8n5SaXA4YKTQMBDfYY8w7gOJUT7jrJQ7loliE+86hoAFETGx0mU7MrJSm1IpShJ1Trumw8i4E4ukeo63c0CjgcwyqmfcQIP97mO/9nWDpCzS7cd9kEAcP03W+xQo4T16Ipc0vPlwMEDRLrqvmBwPVjX0+I0PrufwrT9jopaIATO5sD/jncyoQNeY6eAgc72CHywxbWt1jWMKNymo5ZJ/cARQ4nK9tiJXJwmFCectp3a5vWWNwfbxx08u4u0rr0Z2lkcAol+kqyZJtwPf5/s9yvQ8pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnyHjpExe7DWWsnBpOiuSXOrRE8pkbKsoaw14g2bbBg=;
 b=rjOMDr0XDOwzEld6OKGooj/YTXj3XKwLE4JTQwClKhuQrvt7j5uNdal0L3lIYKY98smTnaT3riKPUKkUAWk27WlKEkGbsGBZwvmWmG8+XqjGWQx5A6wBkVWH4/jTyED28TkdoU1PsGpDjOXb8za6Nmn+poy7JFjnKyS9JtoM9pE=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:22 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH 0/5] scsi: FDMI enhancement
Date:   Tue, 15 Jun 2021 23:48:57 -0400
Message-Id: <162381524897.11966.974754694003436808.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603121623.10084-1-jhasan@marvell.com>
References: <20210603121623.10084-1-jhasan@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df91f073-cd9f-4eed-9d65-08d93079ba04
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4663CCEE3DF1F7595D52FCB28E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FPFY92rXp86B99ZE8UcuIIgxJzWq1GfZcfuYUEIZ1E1MFOwBlokRmD24ZxNSPfv5jIdH07CFMEEP75+6n1+07mmfUEG6gtbDSHgi2/M3AvgewwRRV6szVPSnG1aEmpakpdUl954j7d+g10LToIZbAvvGZdei/+Hd+415c6jUiYHlQdby7mjnvbMiV5/cY03QMCetgG02q07rm80w/2IthFzdYLeag9YCWZb+UUqFWj4vHZzP/1XM4Kj5XJA9kjpTGVYvsC5y6HZX5GZxSO8nIBi9X1Vnnukt72zSxM/LCVsWAFbVp3Aku0lWmcXg3bpRmRBPYBWVm03/sQwbkBzRsKmlN5k8wS5dwD4Dbxt06mQBSJB84HA+nnQ1tboA2WW7xcgOMELEc+oEpzKqZX6hSriiYapyJU0w/26PZpCMO6cekc5acE+3tRHBURjiFSp/bRECJsalWHT3u7z3ihW7549jXjAea6ZKx4dOTeDS9qoKL8Fk37j9s1FxoFburhuA9EPK+wa6Gy0GXeV6gjhtJlOMEHtEts1mZLCEgA0um/9YP+D+qJCbFtRst8IZe1Uz3M8G9MNgyVLolIKHOKxI+B9VHgSXZEMoB5PlIlFnNb2yhJilQ26b8p7S2tdV1ZcEN94GtB8jY1Af22Sh1a0jDobitDyT6ViAjLKw6AjA1bzxh6wEXhKXsCGXDoiMV2Bq/ORkUxtK/ugU/VjY2nvKKxolFFFs6IX320tTi4OZyjoRcTjQoBoCsIgHxS0Rp0HLR3VBu3VULCEH7kcCn95rjF3TIZ3Nz2JsjxJ7TgHgXwD64DVczyPec4c3oCzRnvMu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(4744005)(66556008)(8676002)(4326008)(26005)(66946007)(2906002)(16526019)(186003)(478600001)(66476007)(6666004)(6916009)(5660300002)(8936002)(966005)(316002)(956004)(2616005)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3E3aWFYb01IMy9tMERYL3FaNWlmY0ZMNjhhRlZxS0RYR3NxYlhEcXIxQ0lL?=
 =?utf-8?B?eThvN0hXZFAvcWVFTVRvTWJGdGtyN2c0RDB4YVM0NEFmenpxbjU1V1JzN0pT?=
 =?utf-8?B?dDB1Mis5YXNwMFVualdFajQ4QzJoZGhhajViR3U5eDNkQ0cyZHBubWRTQU5h?=
 =?utf-8?B?NWNpVnhDT3RROFZsUXBSTlBDR2JCbHhKbklFYm8rQ1hMOXh6cmlyQ2YzMVhW?=
 =?utf-8?B?V2p1eDZOVC9mb0s3UEkrQUdsYk5xWG96Zk9ueXA2bWdLSjhTNGhMd2c1RGhB?=
 =?utf-8?B?Q1FBNnhlTE9oTDVvU3BsTnFwNWp3OU92QU5CWEU2ZWhDaWh5bFVlWUZocncv?=
 =?utf-8?B?Q1I2YXBnb1VOY1RTMk5vc2FhZHJXSFdaV2g3bEVMTDV2NXdLalpTZVp3T0xR?=
 =?utf-8?B?bnY3S212RkREYVU0QVlqbHdDcW5oc09pOFNSMUhLN3Q1b25xYUIrRFZSaHpK?=
 =?utf-8?B?cnZDSlFKTlJuWVNoUVJaZ3pLL1hsVWhUVnpFdHRpaFdGZis2ZWlLSXk2SCtk?=
 =?utf-8?B?UzQzYWFFRWVWdXIvRzFGWWx3eFpuc2J1RXY0aDNEVTJUTXlpKzc4UFIxZWF4?=
 =?utf-8?B?ejV3YWszMFduMUwxbUsyTkM5aVIwMU9rL0hrODJjVkVQellobmtqOWpVdzk2?=
 =?utf-8?B?N3VBOWVYbVJobGhRWDI2NEw1eWpOaS9ZcUxXWUxXTnc5TjBsRDYybTZWQ1NB?=
 =?utf-8?B?eUdEMGRQcksrZEJMcHQ4dEhISTNIZlZQdlFZUlRPclRRcVQwRi9rUUVaR29y?=
 =?utf-8?B?ZlBOVHVSWnc4YThOUkJYSUErMmZ0anlnUWRodEkvR3dWVG5EdGoySEZ0OTN5?=
 =?utf-8?B?d01ITndic01wMGJseHJIa2RXc3BKVU10QnpWS1R6a2p2dkIyZjJHOHoxcVF3?=
 =?utf-8?B?VUhXTWQ2ZHNzY1h2M1BrRlFMN3NqR0VHMUpVTjdmSXpUait4VExodlI5dGJT?=
 =?utf-8?B?djVSbU1SalY4azg1b2hrMGhBRU9WeHU2VGpDSHgxQ3pxUzFsY1JjQTRtTEd2?=
 =?utf-8?B?SDJaeEZDY0l2OTBIci9FV3dRTWo5SVhvc1U0enh0amxPT2gxdk8vZEJjUjZ5?=
 =?utf-8?B?TENnY2ViL09aM1VuNkJZSVpVZXVadGxlblRaRkEwQUluVWRHTVdsR2ppWlIw?=
 =?utf-8?B?elZCeVhiQzA4TnBEZDdEd1dVaGJtY2RQNGJFajVCUVduaWRkOGlvN3hvQ0Vz?=
 =?utf-8?B?dzFybkZEelVHSlR5WkNLalV1UWpjS0ZUcWhWMTIvYW9WRmxXY2l5QXZMSDBS?=
 =?utf-8?B?V1c2RmF3YWdFeEFsdGR1REFIbDM4dENialJtdWlBdDJ1N0ZrVjZmSGFJRXFZ?=
 =?utf-8?B?dU5BUDE0V0U0dnJUVVAvbUlDR0FZWUlwcHlKYitBNXlMeGovQzZGeHl5Qkh5?=
 =?utf-8?B?bmFxQlNZODZSVWdPMkdIa2wwckQ1OXpSQ2RoUngwNTRZaWJPQmVSNDQ4dzR2?=
 =?utf-8?B?TDRCckJnVi9QdGVLSGVkTHZVUVMrTjBzcURLY2d6UlVWbm94VTFueDgrQkly?=
 =?utf-8?B?WG9aeTgvdm1uR2ZMSmpCVi93NmViZ29KRmllNEFJN3NYQUZtbENFY2V4c05p?=
 =?utf-8?B?WW1JaXloY1lQZmRQN2E2RFE3TTdHMGQzWmsyZzlLV3VXdHJJQnpTU0lQc0Y3?=
 =?utf-8?B?Y0MwU1BQMHZDRlVxVm0yR1kzZUJVQXRjRXRYY0tERThGWnlyWS9ZVmc2TTk5?=
 =?utf-8?B?dWw0YWR5WGFvU3RTcW5pMEV1NWF0NHE4LzBGNC9hYVQzQllZSjViYy9uNmZE?=
 =?utf-8?Q?diwRgX8jVahr+a7PQhd1pTt0OObD830y/RazEhu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df91f073-cd9f-4eed-9d65-08d93079ba04
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:22.1767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pF4O+Vg49a1wZ+GQOQAVrXaaSIial+HCpgnl3YIFoRSBImZLsQuljYYx4wwR/6k641kJMl2PBGF8TMD9syLMonNtMN6M1DexaguATMkscsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-ORIG-GUID: id05uJWm63gNlOiJNDVVxZDZnOGDv0l0
X-Proofpoint-GUID: id05uJWm63gNlOiJNDVVxZDZnOGDv0l0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 3 Jun 2021 05:16:18 -0700, Javed Hasan wrote:

> This series has FDMI enhancement code.
> FDMI V2 attributes added for RHBA and RPA.
> If registration get failed with FDMI V1 attributes,
> than fall back to the registration with FDMI V2 attributes.
> 
> Kindly apply this series to scsi-queue at your earliest convenience.
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/5] libfc: initialisation of RHBA and RPA attributes
      https://git.kernel.org/mkp/scsi/c/0726af6bfc6b
[2/5] qedf: Added vendor identifier attribute
      https://git.kernel.org/mkp/scsi/c/adb98ec72b72
[3/5] libfc: Added FDMI-2 attributes
      https://git.kernel.org/mkp/scsi/c/82897fefab68
[4/5] libfc: FDMI enhancement.
      https://git.kernel.org/mkp/scsi/c/974db67a518b
[5/5] fc: FDMI enhancement
      https://git.kernel.org/mkp/scsi/c/49d3e5996155

-- 
Martin K. Petersen	Oracle Linux Engineering
