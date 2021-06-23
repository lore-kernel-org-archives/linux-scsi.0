Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA14C2B9F4
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B8D061361
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhFWBMp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 21:12:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43512 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229775AbhFWBMo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 21:12:44 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N16r3K031947;
        Wed, 23 Jun 2021 01:10:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=YB06bBAqtzovMpZdIY4+VUswKitfBkL3ww6lYJBPQgQ=;
 b=mvJ75zJ5ALFI9ILUyQJhI1kR+1tncwG9zJuvYkXUA6JWw8i1PIEtBhuig0faSm+fix3J
 ypE5oMf+J7L4ONY27lDRle/wX4RTC9QPsjAl957tdPm+p36FITb7sGObS5uL+vvaQ4aF
 x9FGbtUGN7onISDQ5hNfVIB4Pq72fnHYcjFtlNZa8fo2ggiCGsj+6Mom22B0vuND+HyP
 nU2qK8GabHTONpsa9qbUuxLjH0brX8ycARiyoMqmyvdJU2VQim1gxpCPsaeyeTZ+TU++
 VsN8elJ50uUcLWqzZUzdvT9bGnL3ZAbCp2C4HeEOBwJcISDYiDl2hBa6T1kEmoWNp4p5 Ww== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39anpuvskp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 01:10:26 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15N14gBY046719;
        Wed, 23 Jun 2021 01:10:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3030.oracle.com with ESMTP id 3995px94jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 01:10:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHMDVDCgBqtAh9Z1QDHAdhRvpfuocN0mVA2CJMrQH3afpfdM05mx3kgMWLFirH50/JC+Q/mJrf+9jZKoRbrmWlw8YoNYBHDkuQjF+BqdO77JhS5lcdKwJI2BZayMmQR/PQp6LK0VDSv1i7R3kO96HSyrXnVBE4wyUVz56Cik3dK7PRsFRHfQXSseO5O/vE+w+58ncJL//LpR5fKLJip9hsr4PlBjkMIJbgP+orY93hP+SbqLm87Z9mmzT5P9/pwSljBSNWC39ZHgdPZgRg4Odd/UzcbsiKQUtlaqvlOUg30TsYXgWg4awKyq4/lFjtv6iWc2QZ/Ns0rhIWGCfYETtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YB06bBAqtzovMpZdIY4+VUswKitfBkL3ww6lYJBPQgQ=;
 b=lT05wAcDortxVwf1D7HcG9YIxXpvKXXo7cc12lD7Q7hf5GVdQzEzhWT95T1CbJHThLyFfUArQ6MQyfAdg3lNc7M3Bk+RCoJ33mq9lZoNF0ZZGEqAxYJeV4V5jcLujFuwQuKUwf25Vd6rAXtOEtXhDfrEVlWCIqtz7ei23wCUtLGs8b9oYd17jnQNZl9vMNZAe+o7Ldf13osnXE6lOZONY2bB08epncinm+5qWDkj1FfnVs+dWlgpQrL9xj6u5oAq/2gGL91o53ipRIFBskDR/+ZrNLc4xxEpx8q/pKTVa2niND4F61uwU6Kvct71ocDNACUeGghJKAIWOuo/rZlm+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YB06bBAqtzovMpZdIY4+VUswKitfBkL3ww6lYJBPQgQ=;
 b=NKi/q05rZbTxXe/HUIu9d+TGLNwqysxe2BOSWMkxMdgu4AvNXzHYpfXNkjOEBtE/GlPaGfAe3ULgFWlHiP/PEcM/F2uwFRMkoXe/hEwg+acxoAiA3k4bfoaB4EXwYDNC8pn7PTPsfFTA9yBWCEM1yr+gcRGdz9J+Az/GjCaZsLQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4648.namprd10.prod.outlook.com (2603:10b6:510:30::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 23 Jun
 2021 01:10:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.024; Wed, 23 Jun 2021
 01:10:23 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, ram.vegesna@broadcom.com,
        dan.carpenter@oracle.com, James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] elx: libefc_sli: fix anding with zero bit value
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6nhtmh7.fsf@ca-mkp.ca.oracle.com>
References: <20210619155641.19942-1-jsmart2021@gmail.com>
Date:   Tue, 22 Jun 2021 21:10:18 -0400
In-Reply-To: <20210619155641.19942-1-jsmart2021@gmail.com> (James Smart's
        message of "Sat, 19 Jun 2021 08:56:41 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7PR04CA0195.namprd04.prod.outlook.com
 (2603:10b6:806:126::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0195.namprd04.prod.outlook.com (2603:10b6:806:126::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Wed, 23 Jun 2021 01:10:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 696426b2-7dd1-46b6-93e7-08d935e3ad34
X-MS-TrafficTypeDiagnostic: PH0PR10MB4648:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4648B6CE0269744DF2C919998E089@PH0PR10MB4648.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s6PdYAjYdJVtN9n823fEIxN20vD+xdR9lOi0ltkshg5/y4zyLx/7sxWy16a5cRe2r7HPQrXYVnFAyWW5bx33KSouAHxxkRKsJNo3FHY6u9Y1jjpjd+5hbWJJEYJqpegYnKPSGxeDTbNNT/YawTlKIfPr+sNLQJzdD/EQjp1OpIqMClqQtFss4MWDYbo88ol2znh79DFRk9QK7oXN8gfdrtjmSmsZsOeADSSDoNLSld3geY/W2mfgyjX/+jFm1usrchUrd39sGb6SPD9XkOXjsqAl2/+birqVc0fWOOBNbpCGpw79jSMk6mr4plIjDJLoM1ujL3KjcNCQ2BE9LbFmQomOXs99sllYEqXjpN1WTuLcClHOg1onxBLsCc11R8UNdRcv08LTUlbPDifPGOlQL2qNHP4osxZO5EdAjaQWwOULSxj8bMz9AARIbnuARYa7RuenMDdSl0lmgMPb+Yiyu24aVOxg/+d9aM5f4qckTP1xhSjyOJuK3kSxEXe1020215XlaGfXtDIkpLel3MP55G5CDqkynawtRJk+/VFuj6h6mFBDqN9MoPWxnYvM6cx1pgGo3E7WC799Y397cF476S6JI05vuf8X/mPXyXwoxU5RXRrnt/xpyZLZaXA9HTPZX7v70vyElNQw0ZbRcmPvKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(136003)(366004)(396003)(6666004)(86362001)(38100700002)(66476007)(956004)(6916009)(316002)(558084003)(38350700002)(66946007)(66556008)(478600001)(36916002)(186003)(26005)(52116002)(55016002)(7696005)(8936002)(8676002)(4326008)(2906002)(16526019)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aMnilU+qo77B7kBvn/Gc5aFCALzJM6N1AJhFJgzPTwK7Hbo1D6NkOSZUHlNa?=
 =?us-ascii?Q?g5fh+sUD6KjtKECJGRHOg21nNrPpTK/k0ZL1ker/UHh1BrAG+WKfJRc2T9c0?=
 =?us-ascii?Q?Jk0BnHylJOVFQuSOPSf/3gCTuFErsn859JSSVL7/a7HLPfCy8HuEcSNLE3kG?=
 =?us-ascii?Q?966JRnfdT1/CJOVHJtgZ9cSZTP3i0NLaDQ+IRGmwDI9bDPhH0qkaQ0KOF7kj?=
 =?us-ascii?Q?Oiu0aF4MDVja9TP2P+xwSNxX/kXZy4buZO2IOP0pvUsPgzSvR0qTb/fTfMmp?=
 =?us-ascii?Q?s7HXFPDTIDG1g5W5omOCa3qIAZIMThQ6Pk40uQI8GHp9nmVY002jTgUY3BCn?=
 =?us-ascii?Q?4m5Cufqt1wx+siYAaY1CUYAVnm47iYdh/nldecdstUtXjdD0dfwNwZmTGV4z?=
 =?us-ascii?Q?WT1zTYmW02fPzJHZtdQOQ0N/yWRhJpiPHR9g/3byaEGCEvsgOULZ76OlJlyk?=
 =?us-ascii?Q?A3ha2cdtqAbY5NHpEA4tT+8C22cHTQhhR/m3pXyujBBFitqq31pdrV5xN64L?=
 =?us-ascii?Q?6KwXR16mWQ0WQvwZhig6nIjeLMS8bEUYukAWWRS1fhYr1Xfl4wQZryKBYeos?=
 =?us-ascii?Q?cmVXhoEmaBOq42J85mkcyhqiF3mxDfkW2ER/BwaQDtWDebpKjeF9HLn7m8rY?=
 =?us-ascii?Q?292b7k6nsfEX+GqSONTd9aPWMK3y6TJXEqOIZmAWpqFyrCF2ARA4XbwEc68s?=
 =?us-ascii?Q?M9WMcpYQfPEVgV72FV/3wl3QnsAtEvttopSj4/v61HwW9Ea62dwUDgmTDwir?=
 =?us-ascii?Q?BPU05kcf4Hn+dGVkjLrOvTFLhUbLVENCUc9xA7GgreslcHI06wuYmffPjCrp?=
 =?us-ascii?Q?D9fmb+oSFDo/FkSsFaU13ZiEuXhMVxWEGn9ux2DiCLdt6fRw5KXG/icymr88?=
 =?us-ascii?Q?pU4EI5SGmLFkra79byF2du0zXbZ9nlkcByb5adexpNJeK8K0fKi5hUsDF7NL?=
 =?us-ascii?Q?Am81ORi4IxnAPEeAgoBncdhzXJDcMq7C7dQubFWId6uWGgKa+aF+p9MC7Fxj?=
 =?us-ascii?Q?vkM2Rprbspa0qSUlh6Mp8Kn6P4FudRfN7s6mX7Oe/PzJMworMMBPLVa3Empv?=
 =?us-ascii?Q?w8JtF9K6rGem6+7pjP6fTRMiYQcmSUQfLJ7FNq0s+FYunCOUbMeMX290IgYH?=
 =?us-ascii?Q?d4vCfBB9RM1WVczKpoFH8RoLdk050iCuskJUHEsB4ZcnpwN4dauWsRw6d6Lw?=
 =?us-ascii?Q?qZxT17C9x+JFKu3mvqPUC10Axgkjgejsl178VvVzcNzIy2UgW+sNlVrS+9hd?=
 =?us-ascii?Q?5cbPDnWYRaRX8v4oOnvH61WYXbPqBSP6BzA/3BdFLxa2f1cjFQqqUP6c5Sw/?=
 =?us-ascii?Q?YW2UrFSoWvkUyu29Tb/ipjFX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 696426b2-7dd1-46b6-93e7-08d935e3ad34
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 01:10:23.0881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aMMj6m+dLZmQ6tFEgNPLcSFUWZIjr1uZSpcRZZxMN6nw2dc8H49Mb/ph90JA9OoTai6xxgW/LMJEEsgy+WVppmi56ArQBFGgplemCvELkr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4648
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10023 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=810 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106230002
X-Proofpoint-GUID: 75LqrkmeWf9Pf6tffRjMkecaaAffxbRZ
X-Proofpoint-ORIG-GUID: 75LqrkmeWf9Pf6tffRjMkecaaAffxbRZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> flags value is being set to constant and'd 0 which always results in 0

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
