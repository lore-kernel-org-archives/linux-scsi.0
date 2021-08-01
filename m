Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D715C4338F
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Aug 2021 17:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E73A461075
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Aug 2021 17:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhHAR2Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Aug 2021 13:28:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:10406 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229592AbhHAR2Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Aug 2021 13:28:24 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 171HH11k018094;
        Sun, 1 Aug 2021 17:28:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6bfpDpsqgxzqF+lpFlxKao7qHdcrZ4FWd6Pylie6450=;
 b=VWk6HeNVP2OJrILwmmYFhgLFXHIo1e441RFsishqtXNU+e/1z5wTX3hsQFvIcd7S63kh
 8B/kj4Pan9WZeeWpm0LYogvOdkPHNC5Wk1fVPW0P1D4rifgntBziY8ImWjzNWS1gnfS2
 4hl7Ovp6ZjBSXBVwUtkjulVAdRpMAdTaM7CWEkGQLWn6HHsS5opdgafadJdpMLBklU+k
 39Nfo/uTSxDNmMqBtvWQw9YxZpgwiELyhmm4ejmk8rCrC5ej8ONWo6kISS78dS8gIyY9
 fsu3z9wvo2yFm9fdohtYbS2yIH8vjLXACPxAUNu6n4JiklNSWpD2Y2LGme+AbRAIqEOo 2w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=6bfpDpsqgxzqF+lpFlxKao7qHdcrZ4FWd6Pylie6450=;
 b=Wah7Y9glYqUDdwSdGkZmFXfxh1tkfjP5MCvBQJhcIMuOdwhi894DmoT/y9WlsBbKm171
 Q7Se9eH8sacbM2wjScBpCM7RBZJwCPJs1o4DG/pmpGZoMYV2LhW7heDrO47Aam9JDbb1
 TiZeWxQsGRTpU9/ZqqBiOR2xQXZl5YenolmsC2/bMwGy8RmlAt9N0izWFZFv6KxDemYA
 Ix2fL3NsWSYA/qSjz5o8dsyVzR2POXXGVc3Q1EH4SR2M/yzjkWP7v0nmL0qyv+AIcweT
 0kXcw0VtFR5THdb+USeDu4uXJcDSDtTAptEusb2nMggHlt0jwce9WmeF3fowEUQiwey7 yA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a4w419q3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Aug 2021 17:28:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 171HFv4i041837;
        Sun, 1 Aug 2021 17:28:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3a4vjatajj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Aug 2021 17:28:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZELerkr8FkS7xpzR5gclM2fZHwDdEYWN/dhh5ilMmMOS2WBZnDVaSwB/H0qWkMvQlUfptJnCRrHdUlLLOWpr9vqp1TUS+1kLcUZf9cixh15J57PBH09ah9j3N6NZFxgK6gSjvUMOI58bjQUIhEelJM3hqVtf6iBjQbMmhVJzu1SvWRZPvQyKQfKUk2484p0+QjrRknyFCP+uJnHndJGWsy90EL7Q6WVAQTbVIgz2JzPwUIU9UZoyG6hq3krbvmmBpQusr1aEPF3lRR2FcOWspgLz6tg/YPFw87HdSniVZR1FaCW1gNQMZIFyA0l2wik5I8D9dBy51mdjUqQU1VJtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bfpDpsqgxzqF+lpFlxKao7qHdcrZ4FWd6Pylie6450=;
 b=QEh/MajwajGwhIVSS9YRSsvvKtApt+0xjFSuG+2RKnRX1IT7Bxfxtam97HCukkXfePsRS1ArEskXoGDJ+hGf79qvz731ubR/K/c76fZshsb6MMgmuvNZF6D8hRqbJAGBgbgeo7vXHELC+Igzy6OtuY/g2+dGAam0xTA9hEl+kUEgiP+YhbixsrEGL0+d6N2OKB383bbO3mkUA1gs5Lict91Glv/DRh6oJdWzSrMnB11LWMdYVeCKo+wvLLAT+Omqpi11Ll27QwObZRLpKUsLNWfJ5Zdt7Iq9wE+ZfcCDFHp5bfWIvDXdYXX+/+Z/Ltelwr+LD2Rn+rmrZD4qc6t78A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bfpDpsqgxzqF+lpFlxKao7qHdcrZ4FWd6Pylie6450=;
 b=R7kzf3rbUEoUJwohQmS8rjEtWcJgSzDgj1H8WpfBg378s56aPLPotRwTW8V0zZ8NGQqE/w7sB+UHhGEfPEm3r1QVInwpP4aLh3BFuB6ODW2X6Xnb6bXIRLoLVeddF6uhBexJdO7mmeJRDJJ1FJyB95+rlT1l01/TJ62U+7P+VQg=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5449.namprd10.prod.outlook.com (2603:10b6:510:e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Sun, 1 Aug
 2021 17:28:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Sun, 1 Aug 2021
 17:28:08 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Khalid Aziz <khalid@gonehiking.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: BusLogic: use %X for u32 sized integer rather
 than %lX
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtq1krc4.fsf@ca-mkp.ca.oracle.com>
References: <20210730095031.26981-1-colin.king@canonical.com>
Date:   Sun, 01 Aug 2021 13:28:05 -0400
In-Reply-To: <20210730095031.26981-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 30 Jul 2021 10:50:31 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0173.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0173.namprd13.prod.outlook.com (2603:10b6:a03:2c7::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.8 via Frontend Transport; Sun, 1 Aug 2021 17:28:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0461da15-7422-4d17-8159-08d95511ba97
X-MS-TrafficTypeDiagnostic: PH0PR10MB5449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5449FB037F8614ABF275F2598EEE9@PH0PR10MB5449.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hr+0jJtPOc2BpbNOTg5CJ+uR9d7zTLj83pP1jP+E3z6ZwE/Wl1cXb1MqKP0yoFORoLCy28UOrGjYJwU46omuXp4Dgn+3woPm/E8hjV0wQkaHQ9stveffEy0aHD4l3Onap7kHMzLlB+os7oWFRERvGFD/rv1NWK9nGBODmzFx9kt9V+VFrWqdck11I6jL/W1z6wW5ylQWK1PuI+aWUxKuquCHfUj/4OjwafeqgYT6nKYAPhd5C3zUEIOzhWulerITeqXmq0A3by4ccvB62radQ+oYCbQ1EthUjtG7MgRt6bhQyvlIGl+Zuberi55fzSTPmf6y7zGcK9rr1MpFFJKYyBlje7KnppzLC5ZlZ/H3N+qoPlIRNyC8GKX23fyH23B4yUBjFt+oSwjgKji6DvFMW8IY2thIBB8uwHZr9Ve4Aw9ggTqPD6KmBihZwzCd3zPDycKOsnrfdbS+CJ8YW1FcVIMgvK++HP3l8kMVQtXD6QeqTi2Xx/prfkllBVoh0llNahi9ZRc9Z2gqWZCqK3yQ5zTioaxDS0qzyud2SPztS3+dj60TgmLSEvONrHaFGQxdAxTyk9CcIb+/PqNKcROsYKbN9YWUtRyBKIiieVNn15V/BfAoQZ1g5He8mnE4rSCsl285+pp8YGXQnTw59yqZGFxVSGCYMDqReTc69W16HVOOSzJ7jV6buyeTaNGo+scIhWSvPHpaHoMPro/hCJMSpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(346002)(376002)(396003)(38100700002)(38350700002)(6916009)(54906003)(956004)(316002)(26005)(4326008)(8676002)(8936002)(2906002)(52116002)(36916002)(7696005)(186003)(558084003)(478600001)(66946007)(66476007)(66556008)(86362001)(5660300002)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W9aHw9jcz36c4+G0r7KjaSKhh2Z/OZ5MrfYJb6zgSiGwIKTCw/R0ADQYRySB?=
 =?us-ascii?Q?tcvjaJz5ZPdsdNpbC0rTteOr3cGkKflnikQoSZgxZScLcOHkUIOdls0fHmIp?=
 =?us-ascii?Q?bduHQZ/AVlWxpRTHDAIR24oovmnV6N9KAlUunwUvZSEK3ipwEza7GLb9PuR5?=
 =?us-ascii?Q?+4VlEyqnLH7Y4LJ1DBeDiA8Vu+7H3dP6gyD1LWQ59ftPGYexWOmSfA8+gVY+?=
 =?us-ascii?Q?pzz2v9FB69kn3g7TRMwZXpv+16gPqPtLUbk6giZmIep2FXC2Ja1DIl0lWVEp?=
 =?us-ascii?Q?s3DP9+k/xTZ9YI76jLGHbO3LWOBwAdeUnTD0M1+uLxL2cl20d2DP0lBVaRPt?=
 =?us-ascii?Q?jcceDQPcuK4DkEEUoI3Q+YwTRU9bd7wsgSgD95HUm5iwQpcXWmda2ZMhNVKW?=
 =?us-ascii?Q?1pMgq4sHxInnfggfPRRvmbrvHM1vq0bbr3GnOZTXJghQLb0GG7sqrpudIivc?=
 =?us-ascii?Q?xGbEPale13D/d/75UButhqqdd9TqNp8g9+QIQLm96Z9ZogTS7g6Nk9pkP9TF?=
 =?us-ascii?Q?SWWVlEvTcH7PphFEwG20FfKWjn0c4ZlAasqp8WnsT+CcmiSsIvqGfViU8224?=
 =?us-ascii?Q?s2M4LqtqIXQ3uqvRZ21ddCih1jCBnNe9Y8HPsMnWLtJZcWpcOl5y2+NTDO2H?=
 =?us-ascii?Q?LkKgHfFmZWP6Utv8QZHG1kRJnWr9DZC9TaJvtwFAMazi7jhrUFgFgwHhyPIe?=
 =?us-ascii?Q?I+QySVWw1eqlufPGYUWyATCtE4OaCznPRSJtFqsHCRa9IBuAYjquuKDIpWGs?=
 =?us-ascii?Q?a2EopCkpgYVUlf/lvstEhMOyuq1PsBd8iqkMqMFMuxw+QZr8H2Ujr4VIJH69?=
 =?us-ascii?Q?ngQzrosNNM6TXeGo6lIKHMhYRkFCpkRZvOM3a6KRwrB7oxYRrgvLgJkrfEPx?=
 =?us-ascii?Q?LqdqXjeo63eCSbpcY9amyi8LWSLPek2AYawTftBNIPlNw5+n3rgs5QyAnbIS?=
 =?us-ascii?Q?1EzSBzGDBs1QEnR++9NQKK4go+PLyRYzSij5aav3b6Ns1IQjwD3crD5sYNwc?=
 =?us-ascii?Q?WzhLFMzpCXlbAoeYxbYk5LQwHtLyr6B3/YtvQW6JhpcCtqp22tJxi8keq5xY?=
 =?us-ascii?Q?J3kFaCxOmdg+aWf6mwWm/IWSWIKdob6tTZwS/vp24N2VTjHjAnsGI2kgmsiy?=
 =?us-ascii?Q?Yg8jj+KVak78xWyveoiseK7cl1pAY7rYiRn+Vj4kEn8HAa+Y1oqC2hnFWrTK?=
 =?us-ascii?Q?2XJyLuGGl9Jkng4DKiQldwEo1GvPpOxS55J5eEkDKyxUoaxmE9PWlUtb/7M8?=
 =?us-ascii?Q?0OXX06n4PaMeVfbRGhRWw66m9qKPBMWd38pYNljSOxxZaqgN1BR/U5u/Qhvi?=
 =?us-ascii?Q?6mq8SoT1MP6VEOz5e73TuJUs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0461da15-7422-4d17-8159-08d95511ba97
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2021 17:28:08.4027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJoHaE/cxiyp1V2uIylMTfvcRmPyX5uXsXAxMr3z/cUy4rnAqxSVDWV4ESpqT3Gw61noWsD/WgoT1mDi2aBYmBi5/hLcpD4sGCddq3U9whI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5449
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10062 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=883 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108010125
X-Proofpoint-ORIG-GUID: 8wv8q9uN42mkazCunVbf_AyLgBjX8T52
X-Proofpoint-GUID: 8wv8q9uN42mkazCunVbf_AyLgBjX8T52
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> An earlier fix changed the print format specifier for
> adapter->bios_addr to use %lX however the integer is a u32 so the fix
> was wrong. Fix this by using the correct %X format specifier.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
