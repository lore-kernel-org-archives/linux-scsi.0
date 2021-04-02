Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F66C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9315610F7
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhDBDzA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:55:00 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44760 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234405AbhDBDy6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:54:58 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323p0Cn144763;
        Fri, 2 Apr 2021 03:54:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xB+89cDOHyaspyyTJkR04fqs0XF4Vaaif++5Ys04INY=;
 b=aF9dZV/RrWJqhJGBfKwQFPmkpzKb5hCwDOu6JpQr0en91g1PPSpltsx5lOO0Mn0RHdmZ
 C9k7HqqyCM3B/fwXSlBpCKBBYzSaMnWc9CKxm0/MERkWsGzX69TeH6Q5KfMxG5usyNMT
 BaWhofoPc/M4Eu/vzwE4qpdbmRF+ZLgxC2vwQ1YHo1tPpadQUit54SohkmOptWp+rYyH
 rqLfDNGq9yEv4IZmoSMhVAq3zmxv2+zEH/QWS1/z9YfWTNaAJh36p2KYHt+gUjaA0tV0
 6sjCXnTqIyEXLWq1TTDO9NPgkbPXQNfzdhT80LJ81bVwA+9ldCXERe2asSY5Sp5X5u9h kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37n33dumsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323pdTN101578;
        Fri, 2 Apr 2021 03:54:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3030.oracle.com with ESMTP id 37n2atmxkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tq/r3rqveBB1fyP6Adn/oxUwfRv9S56hD3ukGDZY4FY9W8FP8pebIhmUXvvIo3sQHMnQM13OMnzXXCBH45tJ8n5JOUZoBgLttclyQ4VCGVRi785F4hMs8nej2Y5aQD1XDDs9zatD+2uzkMXY3C7m53bHKiFIEme4fKQWD5R4q5kqYgSgLuONiMOu0K9wqn0kg/9KL8AckXZ1S9AAyrQuLriiHS5fUjz8K6WDUbQFkG5NhXlI3WWgPwbkaBxrzoOVHaaNszW4o2hqXP8ADHnIpSGtusd3sj3vxvrlNkmenkIyIEm0GSeVPWUJjVwezPzpFb83pgusmflzMWBlNnZCgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xB+89cDOHyaspyyTJkR04fqs0XF4Vaaif++5Ys04INY=;
 b=QyAsWgGCrQ2Z+CAP7bsCahS4qVWCrQO9wp76k9uezOxlO3uOoWzf6FlV8KvlIgXkJpN6NoQawV8Ki9Dm7eV6qIBDSqAq6Qe9bIetIeztCXKyuvip4See3b68TwaqnE6NQkZ1eDpIBB/9NKo3P+SMocYpZwJU4F7QtYC2aHmwY2e1hrZ4UJYmiQnqsllHzoFX4nOOWJgI506iwtGb18wTKJpg3JKzvW1LayUyP6m7qFAdJjHTAMZ/NfpUOuf9HfRLFR4jwC2BliUB4V6f4lkAsGmsIRodFKeLvoO6vxPWJma3NCiOvwcjCoYlyJYg/8xsH4u4meMQG1xypt2y0sNorA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xB+89cDOHyaspyyTJkR04fqs0XF4Vaaif++5Ys04INY=;
 b=Nu2ViixRM6BQWWBRnnp/gvNdcckcGhhlwld3ZNBNZ0GRTgx1drp21vFsZo0ZnUUeYn+tTZKQcFX7lLp/xd8EFbEGjlIrbz29+1RFaeU6tjtS0Tq/ZW0v8ZPyJqWf/Ac1/b7GOQARlOImaA2IhKj5J3ev4kOVWp/ErFQqJ/E2/Zk=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4680.namprd10.prod.outlook.com (2603:10b6:510:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 03:54:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 03:54:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        nguyenb@codeaurora.org, asutoshd@codeaurora.org,
        kernel-team@android.com, Can Guo <cang@codeaurora.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 0/2] Two fixes for task management request implementation
Date:   Thu,  1 Apr 2021 23:54:47 -0400
Message-Id: <161733538518.31379.1318106844144695949.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1617262750-4864-1-git-send-email-cang@codeaurora.org>
References: <1617262750-4864-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY5PR20CA0001.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR20CA0001.namprd20.prod.outlook.com (2603:10b6:a03:1f4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Fri, 2 Apr 2021 03:54:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 796d4b57-8cf8-4ef3-0f68-08d8f58b1126
X-MS-TrafficTypeDiagnostic: PH0PR10MB4680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46802709CFD7FD4184DB23C78E7A9@PH0PR10MB4680.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bmHxyf57qdx85fSrtZe1+uiUP+5hO+eM9ADU3xSdRTlK1LYgwed5q6m4EBHwnyZEZci81FQ3jTLT9455SKFxxp2WgSz2XdmKzKxKusjLGhbZ1cxWhS4qG6MA9iy6RY0WwyBRGEf6WVAau6P8x4oU3F3iZYIWBjdqg1yhCBS8Buw8n4QYvx37byjSVS6+uOs8Svarlb82iSORjP443Icy2NS4OqyS5pbcILj3hZ5OUqv3iwToaOMrWNeyRLsOv4xenl/UMaFQKcjXBaeK/5wAw8kZKsfcs5T/CzcilBpREIkeXFjRGXrExqYJ+eKUPwIyTsSoQmAmHyk+tn/JlXJp6WFE2e9kCKIxa2i/Ii3AwhmwJ+M7yQ7TxGNbw5owTbovRg1JafNDVEeAQsxSAD5YXS1SYEFJrdWqljKPio2NZdruVEvRq/JWmUNhHGLnPXd5n6CBd7ZGBlYeJH/yKnYlEAQ6hkYQ2Y6xn5QSWOfdf40PVPwyycfpKK3s4FucZRveogu+bTVdlgEtYP01DFcRDam2XrOu7GvD+Dh78y82Ts0C/cec50InBDuxaWQAbqqsNPLGa4ZDjgJocH6KVKU9oQOUt5bt0P9fMB8VZtUiVDU54FV351juwGm86nTGuPntGPMH8t5j3ORNpeqYKV03RBBdoHg/jLpXgbMRAJX240FGIzStYScOUh88avaMmoKAVRzuyQPARpbDUwqzydvaWEMxNusT9cDiB5wLogpAfQ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(396003)(39860400002)(366004)(26005)(6916009)(2906002)(2616005)(38100700001)(956004)(16526019)(107886003)(186003)(8676002)(36756003)(66476007)(66556008)(66946007)(86362001)(52116002)(7696005)(4744005)(103116003)(83380400001)(6666004)(966005)(478600001)(4326008)(5660300002)(6486002)(8936002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OTJEeUN0Qng3MVdJRDBodlNRajFsMXhaMk1KallrMGtRMGY1R0FENHA1M01C?=
 =?utf-8?B?WFF2eU51L3JYR0pHS0dabFVHM250Y2NsMElodXdSUkladE9oUTYwaFRPVFZ6?=
 =?utf-8?B?c2xkcmNyUkw4QUszMVRhd0ZZZWRzV04wbWt4MkwvRk9EN0c1eEp5RFgwL0pt?=
 =?utf-8?B?SThnYUJtWDRHV3pUaW5RR2Z0S0xSajBSZEM3cGxwN2xpRTJibTZienBZNjYx?=
 =?utf-8?B?cVlEZE4xc3hDR3oveVdrSDlIekx3dnJZZUJ6QWg0MG82MHdlM3dxSktnQW9M?=
 =?utf-8?B?MlptdGVrVDU5VE96YjY1NDRDZW5iYUNJQlpDWFc4bVk0Q1hqR3h5Q1JaaEta?=
 =?utf-8?B?TmcyZ0N4RGs5S25PNGVXcC9ieUdKNkRvZnBqaU5rdm5oR0FaTUZ5UVZSTXFW?=
 =?utf-8?B?Z2VRaWhqTXJibVJrVXBrRllOQ0NkWStzK05yOU1IeFlablhCSHc3NWZPT2Yv?=
 =?utf-8?B?YlNjN2RrR0NoV2FJOFRJNzRSQzNXekhSNCsySEJDMVVYN0o0MjBvZTFuK09z?=
 =?utf-8?B?dnlFaG9GdWM4MkFIQkVzTjZNRnhudjdzZ2tzSEMydjZMUWY4R2hDcTVXcmtN?=
 =?utf-8?B?a25XcFU5c1NJWmwyTGRjbkhUZWFQMTJvbUsvakNGV2VzTjVwWXdXR3pjWHI3?=
 =?utf-8?B?V3ZFdncwUjdDY0tRdlFORWFrRjFVTWxBMWZsVklITEpLdVVTdE9UYlpjazFp?=
 =?utf-8?B?V1ljbHh3UUNSalpsb3pPRWpadU1sQnp0SjZFbDRTeC8rdER0dk5iOHhQSWgw?=
 =?utf-8?B?bllxc3pnYTkyQ2d5RS8zMTluUmdlelVzSlgrbURHWXVqQ1h2b2xFSXVnUlNL?=
 =?utf-8?B?eGdLUW84c0pYblpXc3RRdS8vRlcweXk4d1JyekM4Unhmc1gvbmxNM2I5SGhO?=
 =?utf-8?B?d2VTU0FtZjEycjU0eWkwMStIMllBV1VjTjg0eGxJRVBDREI0aWQ4aUFOTU5B?=
 =?utf-8?B?UVdvU3Q0TmxtcHdjSWdnbWJ4a0IvdUhueVBDTGhTNzlwc2xvR0xrUmJkcUd4?=
 =?utf-8?B?MmxHSzQ3dlc1blJpNkpZMkJoWndBU09Ybm1ibWQwbXU4M0NaR2g3NXEwYm9s?=
 =?utf-8?B?enk3TkdSSEZBbnZpQmtNVEtuOG5NbDNOM0Q0SFMwMVlSbkhGaUFFSmtQTTdT?=
 =?utf-8?B?RnQ1WkRZRGw0N3hpQytUZXZCZFoyZldPTkluWXNSeXZ3VUFrb2RZakVjRmR0?=
 =?utf-8?B?SXo4RGh6Y1lKRGNnSWtrS2FOMkpIaDRPMUVqcW54MU1XV2dxMHdETlpIc2tx?=
 =?utf-8?B?eFUzWlphOVY3RzhFZm94ZjhaVkN5eWNMY0tmQmtURmVJRmxKTGxIZWhIK011?=
 =?utf-8?B?RTFoZ2xUUGZBZ204WXBsR2hXWXYxbkRFRlI0Zyt3YTFHNzdDWXpKNVJWckpv?=
 =?utf-8?B?a3NJaHMwdkxHdEhMdnVqZTU4a3NLeDdoalJCajU4K1Zqc3JaZFZ5M1NBeEk3?=
 =?utf-8?B?TVZNNjlJd3Y2QTFRMUQzcEFCci9xNDZkVTJSMEdnOUdYZFpDMWRINjFkT0Nw?=
 =?utf-8?B?ajdxbVpPZkV3cng4ZWxOWGxIK25XZXFRVllHWlRVY1NrZUNPOUF3N1FaQity?=
 =?utf-8?B?ckkvMEY0OFZYRW1WYXRIeVQ3RjlTSWdFY0ZHZmc3R1FrY29JS0ZaQXdiNlk4?=
 =?utf-8?B?MDR0czNUbFR3MVVWem5GajZDbllTM25EcTNONGVlVXUrbHdpNDdreDhLVFNQ?=
 =?utf-8?B?MEd6TDZxQ1FhZkNEY2gwcjVsWG5EM1FFcUFLUUs5MjVjV1pKbjBsa1Z5dUU1?=
 =?utf-8?Q?QE/kxkvpof6vW0r+n4pCVzfrpX0lQLZKVphUBn3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 796d4b57-8cf8-4ef3-0f68-08d8f58b1126
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 03:54:51.1723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7xDFXDngkT/zQrhmbL96+WsUEoBe08OUOYoqfRqR6Vtbpnl2D+fuQI8rUSme/Is81kumM1x/LGl/mMg6VWaJGkpSwKRkVp2KGDn45hT+sXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4680
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
X-Proofpoint-GUID: WPoIlg25VMGwTWSz42_ZVL8KBCS8vGku
X-Proofpoint-ORIG-GUID: WPoIlg25VMGwTWSz42_ZVL8KBCS8vGku
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1011 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 1 Apr 2021 00:39:07 -0700, Can Guo wrote:

> These fixes are based on Jaegeuk's change - https://git.kernel.org/mkp/scsi/c/eeb1b55b6e25
> 
> Change since v4:
> - Incorporated Daejun's comments
> 
> Change since v3:
> - Deleted the 2nd change
> - Incorporated Bart's comments
> 
> [...]

Applied to 5.12/scsi-fixes, thanks!

[1/2] scsi: ufs: Fix task management request completion timeout
      https://git.kernel.org/mkp/scsi/c/1235fc569e0b
[2/2] scsi: ufs: Fix wrong Task Tag used in task management request UPIUs
      https://git.kernel.org/mkp/scsi/c/4b42d557a8ad

-- 
Martin K. Petersen	Oracle Linux Engineering
