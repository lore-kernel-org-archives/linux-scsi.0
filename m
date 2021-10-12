Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D1AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 275706103D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhJLUhg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:37:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:43802 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229771AbhJLUhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 16:37:35 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CJjlEZ002221;
        Tue, 12 Oct 2021 20:35:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=AlGy5T7fbftkE0yCfghlYefnOlsXNsT0XkL0HMOzbQk=;
 b=IxIL6N0SiN5iusNFwoEYz5SrUfS8fZ9BGkttwWbQHgeFGJmdky7KQ3L3jH+PCnjnOAcN
 jVExH/E5VAFiatUDdRWwhCPHB0GUa8siMu5+X0B70DKllF3C/G+WheG3MWEyVfFPYwsG
 CwQo+p+qgpov/dSTBl0FQdLm9HLN6jGJ8ppy+hPmizGRG5BC/QJwesw4ZIZwcCnN7LY9
 Mph+wCP0oeJI2l6bhQ1K38IJDjtke+qt3svOxT2yL8EO34Ccjgv+3pY+7dTQW/tzuHM9
 6IPMNjhf+XyiWH9pk3NXOtaNw2NLhf0hs5p1E+zhreLgxjKPlEmrVhLd+f/Xa2kvnIzc CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmv41ru5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKZ78a009550;
        Tue, 12 Oct 2021 20:35:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 3bkyv9jpxv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JjTVITcTvAUQBLU378UPxaNqiRzeNLfSorsKJIq7OiRQP4R9UhQaNcRjrpMIt9oxTTWjMDDbHNhos6NuXkBZ2vbuBazuwhWvLgK9ZKbOSphFxhX7KMnsv3AOMU0yfKJWTW9lcvWuxAdK1whVj9eEJd0aIQ/zcHHw7ytWyRj6PQh0/wiyPZOm1rOzdTeWQ9sPbLdn+Mi9dr7jKWShkvtq2sgvTcTkedpIE4gTOGwTDJ/7fr/xB9R/NEIXy024V82n4lnyLhVOqtVpYQgId3ozmXnS/M4nETyCU8ELhUUMxsFsNOx7CzUhyoNE963tJsbXtrJhqoQh0KyqYYBlIw+cIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlGy5T7fbftkE0yCfghlYefnOlsXNsT0XkL0HMOzbQk=;
 b=kEkJ7UYRmZrtypv9c/wAnWq+5OIegM04gOJnNZZzRWAupHfbtJekS/9Zn7jkWqIN/GCfF/vZzFtjlsn7HZHeLI6jfaKI7kLqKIWV3q+DxShMXPBMRNOVz2hSQfWTzXhubciUdkWGK9vKoWqXIeLtXMdeQ7vuvqnyudWIfagsESXv40vsaeRnuiYrfCHXCM55m0khwvhoBNqaHaPnZdzalljM6UXEunXAiApOT2kr9n7ZP9KE1qXzNTrdFTBdh/TFDDngwrUEkedWQ81DTA8hd9esNFbqziZeEE7uTowzKh97sPqdcVjwtK3Bk9KCemhFBunOtXPJP9BoOUbr57OyMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AlGy5T7fbftkE0yCfghlYefnOlsXNsT0XkL0HMOzbQk=;
 b=nWcNM+4UPk1Zv4XIB2Wjw5BUFcjnmJhn3ikwzNC11tK3ikh4S+we2eq8NcrxxYQj2vkPmNN4QjicssmPUhldzD7it0sWG+X+a4KHqF0VLuVaeAcUE7+46EBRRFVNDPiV32D0rWNn0EVI9CVZXRURP2CAn24y5t7BuBd4OeWU9uA=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5514.namprd10.prod.outlook.com (2603:10b6:510:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 20:35:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:22 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: core: Fix spelling in a source code comment
Date:   Tue, 12 Oct 2021 16:35:06 -0400
Message-Id: <163407081302.28503.8143964513995286214.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210929182318.2060489-1-bvanassche@acm.org>
References: <20210929182318.2060489-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 20:35:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d089e14b-5b60-4faf-e0a5-08d98dbfd060
X-MS-TrafficTypeDiagnostic: PH0PR10MB5514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5514D841298B829811CB448C8EB69@PH0PR10MB5514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ezsEpEpJVmCSloJistuFox9rKIcDiMZsNGbLOGZ4loWmr8KqFm99ZHstHK1/bdf35FErBVYW/PXCOrL2m9wZ055Cq9oyr436sY0l0cBS0Hwz/hfFT56KcHwen2DNlOIxH2NatigPB0U1Q2Mg/ilMyjCePLSovd9TjKfVwRyGBPbvZeim/JnbKEPhmVtHC2vw+6rXn44knSDgWHhsZjFe6DmyF9DExw1NqrWkNSTzLapPqAG/I3OR/PKXP0ZLv6g31/Qp7wXc6vfiPABSEda/ivMiMRg7lHPmJbTnES4jLIrExpJJKpz7cWIsZUe0kYjfWokdO0ThV/Ac/36pzOh17B3tBVCt0zO36VCTAhDl32IaE98BVSpb9o9EmygtoZB9IEYzC6+Y80d3OPVEZUiU9J3zWSXyFV2IUsHsCUn5hweXD8yummAiN/ESlHXowp3U3/9JMeD9ytRMr0xok4JPRsfI2QIR6EfLZ3LOQPNLONVJbq5nPjuaEGxAtbPPuu3JmXCqfrRpfAFs1VgaB78SOyHJ72d5YpCjAMkMYGP+mqWtHRj2HlnRPwPunyJct8MBeeNGo6GyD1OeXDBcE60Ko5w0DmZ+fJtpRJw3OlK3JE8il0FpyirEcyYVJhwXqG08U/jQVvkHh9n8Th/qaL+9Q5WkGW03CQbtkOaLL2fNbIikJcYihFTYUJif2HTTwGD4SP956CeN8+Qpw6SAFJ/A+tVP4TqKsx5NwhNx0WoUz8R5gPAcoWcXcq4H4QQwuKU1cUVCyUT/DjWjp3PRPVcw5xzJdBdC/UvzeWGsNc61S8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(5660300002)(8676002)(2906002)(6916009)(52116002)(66476007)(66556008)(7696005)(6666004)(956004)(66946007)(6486002)(38100700002)(8936002)(54906003)(4326008)(36756003)(186003)(103116003)(4744005)(508600001)(26005)(2616005)(38350700002)(966005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVhKMU8vTnlLYnh5NERHdXJvbW5IaEl6bDBvaUJodFA5NXpDdFlpNEQ1dEVS?=
 =?utf-8?B?SWZ3NTJtMHpNUHI1amlCNUVoNTJxdm9UNkZVaEE0RkZPTFpuM291SE5YZjlD?=
 =?utf-8?B?aDc5RGJrb0pQMVhjZEE3NW81Z2xuVkRMK1ZpTG5WMVVLdUFpWkZYaUo0NkMy?=
 =?utf-8?B?Z1ZGSkZFTUoraWZ0N1NEcy9rbUJIazgydldhdit1Mk9vYWxoZldkWFV6V0Vk?=
 =?utf-8?B?RU9iSzFDZ3NIeDhEcnhoVEFkL3dkU0pESEhJc1BtWU9VK2ZPV0lDblI3RWJF?=
 =?utf-8?B?a2MyUmJrYjV3Wm9NSVZVV2pWNUZkYWJrYVJiQjRZQUtVVmtUSm1rZC9DQUYr?=
 =?utf-8?B?d2tFdWw0ZitXYTYyWGtGNUtXbWw1WmFyZzBSZDNFdElSTGoxMmlvSXAwMDl4?=
 =?utf-8?B?ZzB1SExJTFJNVGpyRm5BWUtCWTd6K2h0enBPZGlKc0JXV3BxUXJtc2ZUL1FZ?=
 =?utf-8?B?ZjVzQ0tsUGhyb0M5NklzMngxUFhwUjM4M3hORXZGMXo3Z1VDZTgzTHhHMEd2?=
 =?utf-8?B?UUh0L1N1Nk1KNUJ1NkdxUzJFTC9oTDVhTUhCTEkvWG1vS2h3SmhoaG1odW9K?=
 =?utf-8?B?Rng5dFhiTVlqM0ZsQ0lsSW4reUF2Y1BnS3RDN2VNSkZ1bUtoNmZWZDZpS0Qy?=
 =?utf-8?B?VDlxSnpBV2p3Y2Y1UmQ3WGM3czM2RHJ4VVhBZFRvdVB6V2ptVFRibThjY0Nj?=
 =?utf-8?B?UkdnZnlmZVhwRVpGUEFpeFpGSjZZOWpjNlJ2WnVIbGR6RGVrdFFJbHVpckp1?=
 =?utf-8?B?OTdubk5WbUNtTUcycGxGd3Y4V25wVUNQOExjek9lQXdaVXRnSHo0TFFmekJh?=
 =?utf-8?B?OW9vQjBWOWltV2JLamdGcm5SaVNBekpzUlFwdWtGQm1neTU0cTVEd0RDNUlM?=
 =?utf-8?B?dnJTYUloSk9nM1pvUHRVbU50ODllYXFMcmdEeWF1UEU5dm1VdjBxcW92ZzZv?=
 =?utf-8?B?WkVydFM4bWZDMEhBQmdSdUN0Y0U1YVVSUWgwODE1c05laE5QWXFnVTEvZ1FC?=
 =?utf-8?B?SkpKSjd0cEw3aFlqR21CNWIvdTFKcmg2cFVCY1ZkWE9iRVEza3ZXZFIxcVVq?=
 =?utf-8?B?aEFmbnlGUkV1T016SGxWZGIxRWRDcmx1d2QraldkM0kxN2pNYmJOaFc5b2Ny?=
 =?utf-8?B?aDVkSDJSaWRiclpLVmt2eEdZK251b1ZqZUdMbTBCQTFNSGR0S0JjYXVMRlNl?=
 =?utf-8?B?ek9vSUNjd0Zycnd2bytlVjNUQlBjVk52Y09EdVMzWnpJaHpUdWhrNjBJVFVz?=
 =?utf-8?B?MEphcTBKM1ZPcWJQck5EcG01Z0c3Z1NXWVZkWTNsRHN6K0V3MHRITEpjTjBE?=
 =?utf-8?B?RC84a0h6c2lySWIxQlVpYnVFOFV6YWtQR1N5cDc4cHhETVFUeEczSjJCTUJJ?=
 =?utf-8?B?WU16NVRnRXJXRTJURC9hZ2d3MFJnQzNJdU9BK3huQy9FWWROTmV1UzYvaVNK?=
 =?utf-8?B?czJETTFYazdiYWp3ZlVuZS9WZVhEZ2tWalc5VFNVMUtqSjRnNTBjRmtsUkxR?=
 =?utf-8?B?QlA5SU1INDdPeUE5d2tsbkxkY1ZOMzd4WVFrMWp5WGxZOFZPS05sRmg0YWFQ?=
 =?utf-8?B?RlgvamNrU3NvdndGU2JSbHJybjd6SngwdFFqTy9uNE04c2I4ck5WYXRrZ2dz?=
 =?utf-8?B?dlk3amY3dTFEN210L3dHN2JubkVIVTJYdzU2T29uWWQzQlg3QlIxZGJPSlBQ?=
 =?utf-8?B?TkJtalg0NU1VNCt3eCtWS1R3aFBlNFNYNitOTkFhMTQ4V0lwekN1dzR2cko0?=
 =?utf-8?Q?RmRnYg/a54gLi6dNqPtqeodlM/qKs+JQ0rRj5ge?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d089e14b-5b60-4faf-e0a5-08d98dbfd060
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:22.6135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7aOW6JOeagLVZ8rQcSC32dBJmee3uQyOxdNrqycO6QvrcyIvpgfxzyRyHWQIrKwMYNhu42DDlTZELZ0jlcrbc7ATRA6JpupSfJleWXYxGEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120109
X-Proofpoint-ORIG-GUID: JhD2UHmjt7eT5AhtTKQlpX0JJtc4kjAm
X-Proofpoint-GUID: JhD2UHmjt7eT5AhtTKQlpX0JJtc4kjAm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Sep 2021 11:23:18 -0700, Bart Van Assche wrote:

> The typo in this source code comment makes the comment confusing. Clear up
> the confusion by fixing the typo.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: core: Fix spelling in a source code comment
      https://git.kernel.org/mkp/scsi/c/e9076e7f23aa

-- 
Martin K. Petersen	Oracle Linux Engineering
