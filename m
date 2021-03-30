Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D92C433F4
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBE1861955
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbhC3Dz5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50872 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhC3DzW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3iQN7084661;
        Tue, 30 Mar 2021 03:55:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=31hN5ysQ7/cABmBFcZfZuNY3SPLVR0mp6QVzrZtD+lU=;
 b=uCKhItYRxqu3NnHe63A/6OBXyNuRK5yawszYhYjymtEFpPjl9YGdHZvnoVNGFISNDnRT
 jzdTolH2u9L+ldJhyBHjkL+DMo+otJ0yM5Vc40NarBR136l/KJRKqHCOgFE99AZdPvK1
 yBiWthOgCHFzv1QlXAJgDFxatYog/jQ38CjN44A0eCIg/Dk4qEYNdYyi0GscQe1zIN8Z
 I0gJ4hX6YIOFGPMnVvZesZkQlkdRC2LehhCBrqvRh23W/URJsvTPSKCH3XP5MXr+USum
 eYpD1y3KgS+qN7yQs6b2JqVmQJArFpUPUQ+/2Ge2zjeSO8Ojb4dtOv5tlaxqHome4Iu1 EQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37hwbndj63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3jRVT187820;
        Tue, 30 Mar 2021 03:55:07 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by userp3030.oracle.com with ESMTP id 37jemwj7bf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXDgsv9+TMj9d8p79mrVO9hBDZ6Z1OWWodD68EumZtMYZ/iTcDnW7SwvpOE0z9BfonaxwfkmtZHu4GAmLU/3Ep2Q1vmpQBCDW1pbQdOsRxEIX1l8FNY3R0HxeklQcGlto6eHAWieJRrAJsjKIFHDuCQySe2R/bcqg8AvmKo7TZ3ahyGEoJP1gMZ7fkicM76GLwceGQqapK26MnfHTGd38Pf4TDnOeXbZestG5dmOZJusUQ8qXhVnElSn+g+qWcOgWXNjsOu/yr4MilD/d954dEgO13Zt9G9etEZG8OyjR4nQsmIDjlSwy7555hfbVi6LodQJCPWs2j6Qg1qwgbG8Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31hN5ysQ7/cABmBFcZfZuNY3SPLVR0mp6QVzrZtD+lU=;
 b=RiX+SmqFMQCaxvZpq3iEQCprSLaA505LssGOAno07blHk1/dnmdnQg/WvQL6sq9L6eDt609pnI8ijSpe4lX9UZ5dWETNSfmn5na667s3UIHTuj/A36onibr/7DAiV6ka0DoFFEJ2eoGSWeKDKIBsZH8DWyXUpPyrbk7jcjiJCLZ+T82kIgC9I8iL3sPlHSXxPO7NvOHLWyKIyB1hWfsFpwNEQPKEuWWU3nvWmgsQjlDNJnupCmEJS+IWtqvcWqjNItIkxG4clwIvexz7WLcBCDdHZQCuvjhOFCa0ybL/2gqaLeRKH7tswcymo525ekn6N8fxLuUm95QxAkgYTUl2RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31hN5ysQ7/cABmBFcZfZuNY3SPLVR0mp6QVzrZtD+lU=;
 b=K88mGUBm2oYOTb+sfHjiqljJVNGk52SjbUcYV9mEAzNXxopHacGQxRhY+tjfR4VJ/sDnimJBtYt1xJwW7r0ozV6zqO+4WqI63ElFQk2X4oB9+p2A7+40Vp5ywL5bKQlqBggp2GJKu8d9vQ1l9nZxpSiUUNtj6zYgfTUTcdyRB4U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org, anil.gurumurthy@qlogic.com,
        linux-scsi@vger.kernel.org,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>, jejb@linux.ibm.com,
        sudarsana.kalluru@qlogic.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rdunlap@infradead.org
Subject: Re: [PATCH] scsi: bfa: Fix a typo in two places
Date:   Mon, 29 Mar 2021 23:54:39 -0400
Message-Id: <161707636882.29267.3251879578326229894.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322205821.1449844-1-unixbhaskar@gmail.com>
References: <20210322205821.1449844-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5678ddce-913a-4b7f-6d2e-08d8f32f9a90
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47580A095F01787B998CB4A48E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zhvNE9g3gmg5rvAipStPf4Vj1DtJiTGh2h3XBUP6fy7gqa6JYMnhH86nNgVTqU0SO0e7DvN+Jl+UKWmaDfQhGBNggQGq1eLgX50h4CI2jIq2aqf+a5FI1GEkOetKmrfXgye094yS9xOsibgEyJMfD9M+Ip+qYiYjI5Ae3giYNWjxhTfqk9GAjjxjxW+61IiA5SPiCKyIrZzQsLLlz9E/ufllKzIHBEp1qYIl7ppc2Ke9wsPfTWfPGM2rIget5jLsx0EjaQP7v/7pVR8wXJdcdapFmIje5Pt3fbUU2fctUljOu9KK7uyr9WaOL3abmClc9lZ2kEjiDylx3F9RyIzzglnyPNP75qYPSlt2HeMxaqyLKtvqPWwyjxnizgJOCY4t2YY5zSnQuk70kKGnFhGX/qMh32yjk7tHaBdKzFSzckDGPjodBruENTHtsbJy++wOqwqGu+DHGO11IxtWXZtpThTQ+O3kuZIPcl6a0vWf0wYpz/HeLxuAwR0VXXVgVLTL+LLAHOA5yWOOJGXtyXDdUVPBA4dDqqacBoDFoEwwj88/AUYvs1nVGskJb5KovcKYdt0fn8118NSaoerLdUYUpFYdV+lIO2FexJx87dWOd/kloHwOrOGijTCljgcHrJKoLL0XT/hNURKuR42PPf3wcmmoeYZs2rU+kLLpFviyLDLin/0UwXELJcmgM7bOFNPq7LXmvLL+jeHu8CGQeSExQFpdlN6WXRHi+YQPBg3N+Uw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(2616005)(16526019)(8936002)(956004)(6486002)(8676002)(966005)(4326008)(66946007)(66476007)(36756003)(86362001)(2906002)(558084003)(103116003)(66556008)(52116002)(7696005)(186003)(26005)(478600001)(38100700001)(5660300002)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z3dIQ2UwOXRoR0NRcElBdWRubzVTTGtiSUgwaktMMWhwZlNaN1ZsRDJqV1pn?=
 =?utf-8?B?SWVWTkV6WGRQOGE4ZDhXQ2ZwWkJIblpZVmYxTFdYcWxCVGFlWlYzY2NzNFlt?=
 =?utf-8?B?dGRPdFdQd1pySktnaEQrOVpDUEZzTjlXRmowQy90dE5tNUwxemU5L1dXVUZX?=
 =?utf-8?B?OGJ0eWdCVFVPaENONzR2RTRrc3pENnBoSzRKNUVMaXdKc0JldmJHY3NYaWFQ?=
 =?utf-8?B?ZGJoZnhkNVczb2NpN1Z2cWIwNUc5OGEzUE5LcFZscm5LK3dJdGcySmRWYXVp?=
 =?utf-8?B?ckdHVTMwQlE4KzU5QmFQVEpSSEdlN3cvS1BidnZzSGRNc2NzOTVMSWdLK3FK?=
 =?utf-8?B?MTNYN3FaZFZxVDlJc0lGOWFjVGpIV1doTGZJZlp2MG9VNmthbkFTWTluMkdW?=
 =?utf-8?B?cytWU2w4UW1BOWFnSlZPWHNnYTVRbkFCZXRKeTlKMVh1SW1ISW5EOWhubGdY?=
 =?utf-8?B?bG9OWkJDYWJXUnJWZklkdU1QaEtSb3hhSTZMYnZTSUMzdUpVRnA4OFJROWtv?=
 =?utf-8?B?N3V2WmJ4UmRGcnp0KytUS3h6bDY5MzhjZ01IZWRSN2NvSU1WOURmVktpcHpr?=
 =?utf-8?B?eHBnUXJ4bHJZWlI4NzhzL09JamNPVzdhWks0cXFWNW02Qld4ai9XcUhIOGEx?=
 =?utf-8?B?b2pvOEVySFI3Q1pkUDFiMlhTeTBIL1V4V0NJWGpkNWxrVUI0akhWNURDbFNq?=
 =?utf-8?B?U1g2N1hhSnhnOUNkYmM5NUdTT1RoalY2NzB1V2xFQlZYaG1qM0FYZlZmd3lU?=
 =?utf-8?B?YlBMK2VMK210SGtSMENzZGdEMEsyMUpGWDZGakVjQTJydHExTU9kdjB3ZDVk?=
 =?utf-8?B?M3RENFpuV01lc1FaRDhOV3N5c2x4Mkc3cUk2Sm94eWVqSzYwS21SQVNlT1ll?=
 =?utf-8?B?ODd3b0FkNEE0MTdkcFpqWlYxV0hVRForZzNnMHFzUGhTV2RHMVZId2RRbllC?=
 =?utf-8?B?ZUNWUUVmV3phY0JNbGphVisya1NpMWR6aHROc3EzYmxMQ0lTM2VwWFBSSTV6?=
 =?utf-8?B?VGxqR3FNODJpZTA3WXRDc0ZIMDg5d2lDcDVIdFVCVC8xQmJTSlh6N0liZzRM?=
 =?utf-8?B?bUtPeVVHTTh3NE9GV1c4Qzd2RlR1a0NiRGJHS3k5Rm5leEI5aGpNb1h3TENU?=
 =?utf-8?B?TjR2aGl1STlsRWxGcGVkSGtFbHZDeXIrdXoxMzA3dUloc000MmlzWnlLc3p2?=
 =?utf-8?B?OTl2dG45aThSdlVHMGhTZi9Ec1lDbXpaMUVIZ3h5T3pwMVg0c1lmTnFGWlAx?=
 =?utf-8?B?ZTB2dWxyVEpScTR5KzN0eFhhc3J2aDBWdTVQZGMwdmdxcmpBMURFQkhTb2pN?=
 =?utf-8?B?OXc1R3hQMTg5WWIrTE81aThWWWNuL21ZWTFoSXUwTGhGeDdhSWRzd3ZBRnFp?=
 =?utf-8?B?dnhEdDlTRCtJLzY4OTVaSmZDRzV5SVAvVnA1c0hvQTZjUEJDSGtYdHNmQ3Z1?=
 =?utf-8?B?U1VVOVQwQTZ1REN0MEdyNWdtdG5zNE9kazI4b21malZaMWtmdzdOZnJERFdD?=
 =?utf-8?B?YVU4N0JNMWdBZWZUTGNPajhtM09uaXUyTnRZdVoxSkh6TTBtYU9IbTdETDBx?=
 =?utf-8?B?bmFaNlpzWmgvSDZxR1lRVkVYWWdLaWJCbmRjcldNSlVidk9vQUFrT2VQenJa?=
 =?utf-8?B?SW8xTHNpRWVqcFhBRjR6V0VjN0tkY3hGZGlyNEV1UlFjQ3RzSkpoVDdsb3dG?=
 =?utf-8?B?UXRkSk9jOEFIeXFXTElLNENZektlZitGcDFuTTV1OW02S3h2MkF3akU4bWdj?=
 =?utf-8?Q?boq27uEM41h9qfnnLCseyjxsu/5c1eOkv0eScK7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5678ddce-913a-4b7f-6d2e-08d8f32f9a90
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:05.7254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: USzMhI9vxhWkMU6W6l+rAEi7suRvhRe5ElpCr4HaFVGCUx1uWOFeVcXnAJ71SsHWk4qpAoQ+l1XbOqy5Pd58HtAAdZGNi3t26AvnIk4gGTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
X-Proofpoint-GUID: oJYehzwQVU6FZWmqeeM_4DHbveUqfocu
X-Proofpoint-ORIG-GUID: oJYehzwQVU6FZWmqeeM_4DHbveUqfocu
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 clxscore=1015
 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 23 Mar 2021 02:28:21 +0530, Bhaskar Chowdhury wrote:

> s/defintions/definitions/  ....two different places.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: bfa: Fix a typo in two places
      https://git.kernel.org/mkp/scsi/c/9991ca001b9c

-- 
Martin K. Petersen	Oracle Linux Engineering
