Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7244AC47082
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 500B861431
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhEZEJW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:22 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51694 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbhEZEJU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q3wuKb183681;
        Wed, 26 May 2021 04:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6swRCPojOjykxtkwk2QkygB3QkgBiNyu+dOHUiZos0A=;
 b=eX9Zz1V5N0zgbs3dC08ob65cDe+5bOD1waJ6gGSG6Q2j2GCsNnIo/lgUd01HUUTO6J/x
 //h3HYK3srP0N4JnXrrzSUkEXEeC3nDMlrzmwxAOl/ow6SvwxmjhUSiQMf4EBk2xBRp1
 +jbT2NquUAyriOWKRScKr2EKMgnhzoGeRKjbZNwLnpjZ2pjamHEt31pi52hBcc4BmS3v
 RJ+1tYtvrGKK8E1OGzou/7IatGGjTVRZ12r9csqJwpQwEj4PoGkP02/oCHmoPXPkTPvk
 2hNBiZ2T7Iu1rG40nHeJ43DHgRJ5OZSpBS40de9qJt5WsRq2SEBhUYZlfFNHrUe/N9Ht Ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfcftek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q46Eqo028010;
        Wed, 26 May 2021 04:07:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 38qbqsvd80-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWjj08NzQ1SUICyiXtyXq/+/reySntKwcS59xCvuLt195aygglpu5HFu0QvsPiT9dHfN63BvCd7/gMq5O99JEQ+vC33ks7pz9RzjeaiJABGkNvzMBBk4orRL4YcGzb8DsnqOC8B8UEr9/uN5yOt5hRbfNZyETsNfIx9w/tKq0iobHf+5YVYBXBV023q2zaVG8oF7ejU5EK6T32y5518joQrlHje5UAkn9sW5rLKlln3RaVX8NSfH0LvdqE1k1M2UKty0R7dfO9qu6DHN/+yK6D+iOVURCqAIvXCGBoY4ZA8cjy42muV+NqE2NZ9btjdIFrgR+YljLkxLPnFxwzPsEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6swRCPojOjykxtkwk2QkygB3QkgBiNyu+dOHUiZos0A=;
 b=SCXHxVLig7HAApcJnwG0mFNqbloCHP2PHC5X9TTCLw+dmbLDurBBcmfZBiInVaN7JTUzX2mLhwkSmsu1g2rvNfZXbvU6DsaVl8PPE6aMPuJGpA/FO6EvDdOmDRh2EjWkSNDt5/mkeJalzpa0sJNog6/uS0kRySJ2y8UL7jb97faZDsAs8F9enArgKxPh5k++K2C5tJ2vYKX+JMjpiFvdUGRF3gIM8rSye0DNr310Zxdvs2fpqjF94QXlsENKFp0Glfzzr/TGUWqFDFgtRrKJMwEsQJUJPHWF6/gJa2+CRQAitoGKw6MOPd1fRH8rNl6tkx0WNgyXoY+bXPzbDkRAIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6swRCPojOjykxtkwk2QkygB3QkgBiNyu+dOHUiZos0A=;
 b=evkaYFbJ1yPUqdUNHSCecdvB2USrsibFbSCz5zUmCXtuz+L1S8KZo1B/WwUx2jnU76xP/VRaACYIL9xvL3uOdMNhicNEpYQmknIE8GABgKe33qazSj42Wkig5GE7jwH71UgtpsD/nhNcQ/Yl7Xm1S1LTaUcxlNFGBodaxjY5kZo=
Authentication-Results: HansenPartnership.com; dkim=none (message not signed)
 header.d=none;HansenPartnership.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4549.namprd10.prod.outlook.com (2603:10b6:510:37::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Wed, 26 May
 2021 04:07:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ching Huang <ching2048@areca.com.tw>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: arcmsr: fix doorbell status may arrived late on ARC-1886
Date:   Wed, 26 May 2021 00:07:17 -0400
Message-Id: <162200196241.11962.9216962573840297115.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <afdfdf7eabecf14632492c4987a6b9ac6312a7ad.camel@areca.com.tw>
References: <afdfdf7eabecf14632492c4987a6b9ac6312a7ad.camel@areca.com.tw>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: accdd08f-726f-41a8-7765-08d91ffbcd3c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45492FF6ACB8EB8D32D203CA8E249@PH0PR10MB4549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hpCRs2mOn2XmK/dmhZyOHFmrGZkMNHxASn+cG6QXhh7SGVap/hK4Q3NGGTLC2jPHKMaIoRDvVemUkPPedxmsjfJC9jkrrorScnM6wjWkSr00EWvO4WHysJ7z1iwFall6/Kuj6Nw6axUiNWG2oYKY6l6HiHDRbWFDaL/JHRtlKf01dKZGFDLNLkQ6oyibdTAJ/JIQEkX5u57is26/QbQWmT7vx9NOkQAQ8tBg6o/b6TWK84EEEYY+v3DmK7jcOMV/dxWVSlFvN1dVzqZe/FWOR+VmRtNjuf0DEYyK5uToB8po1xSj1bLvpu0XJ3xvl2N+fiDSRCZX6aPn1gNLK6sBTXt+zGPN5swArHeEguI20T65WCTupSfNi70nt+IAlacg6S9tnqgpfU22LniUV4zsfQQSYIlIu03IV0aqvyLJD8d/fED9eY3aGP+B1eX+POALFoqJPTaObznWc1P0HKsbPbYJtapQ5sD6h+X7tEYAxKORVgWS4SfglMXDZrGtUcvUjLGcC5d1IUDgYJAigXP0oACl8W9eShRbwjoqfxT6/vjEh4VcC3Y0kWJG8wJ4Aw4uE6dP/BDafDEgpjxTyUIo+0EEh2wEwHWmPJJhhXrrWP+EQXYDl0XVC6j28LkNjrHzo9wZbeQyyfYw6Oydo35XTNw5GZhrYrpnfq1CIgUwa+h3MhU+wdh8n1lq0CWBVC9KW7YNXshFTInIHSOoXKLM9IrPa7ANdGqf9SnRaVH56YdfPoXnokTKuKsuqJAu+3VdedH5kP12axqmk+pYzq66MQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(376002)(136003)(478600001)(66556008)(38350700002)(2616005)(110136005)(38100700002)(86362001)(103116003)(4744005)(52116002)(66476007)(66946007)(4326008)(956004)(5660300002)(107886003)(6666004)(26005)(36756003)(966005)(316002)(7696005)(186003)(2906002)(6486002)(16526019)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QTJKYmJPM3d4emtXeUVIWE41eHdMN0dqK0I4d2JJcFNYVVk0K3h6MEp3KzNJ?=
 =?utf-8?B?Z01wRkdKcTFZUExqc3h1YnovaDBtdjdwZnhUMzlzeUdVL04zTlhRWnpORVQy?=
 =?utf-8?B?cWdBRFlWRnRMNHFVN2U2bDU5QnZQdk1ueU9OZCt2aFgxMENEeXJQOW5lLy8v?=
 =?utf-8?B?ZVhJUW1lTnViRWVRcDQ3SmVkQ2l5YjNWVlZoQ3YwY01WbUZvUDdvc2F0SjZ5?=
 =?utf-8?B?UFlYZlZ0dTUyVEErdFRZMzNKZExDbUQ1L29Fd1VKZUtGOGdmK2JVLzBSM3ZM?=
 =?utf-8?B?emF6cGkxWFROc3RMSnhKc1lnR0w4dHlYSWZnK1gza1pOaVU3TmxTYzU3VEt5?=
 =?utf-8?B?dVNmUStJNURNLzloUzJLbGpBbmZWYk5DRlY5UG55RlRDZHllR0U0cE1Tdy9m?=
 =?utf-8?B?RkwvS3pXQVFRRmV0TzRBc1dJZlhZVitndDdVREpXWFFVRFJJYlNpUVZSQXNi?=
 =?utf-8?B?cVA4TkcyN25yNzg5ZTM1ckdmVVRybXRVVDk0N01wdmJmUkxPTUNGcVJvM1pS?=
 =?utf-8?B?VFVOVGZJb0hpdlNOUFl4bXE5SXdxY0xsMzd6cFJ6UzZZWTJYL3NDak1EamZs?=
 =?utf-8?B?OXN1Q0g3UndZNmQxYkFrQUVBUjJvTEl6V0cwM1VyTzJ5ejBIT0gxVVhNL3d6?=
 =?utf-8?B?M1QydFJjUnJxOGp6dE43dmtaNFc3azB1YWk3dDM4akRFZ2l6d1lFVlFRdzFU?=
 =?utf-8?B?bkcrbkRDb1djbXY1azR3S2l1WE1uZ29Wb0R2VTRUNEhscmVyQVlNL2lvYmpB?=
 =?utf-8?B?U0lpbDdqckJ6OHhoeEdWdUNZdm5yRElrclF2ZE5wcGtremlINmVsM1N1V0Yx?=
 =?utf-8?B?RFZPRXB6N3FreTNFNXhPYnZvcXZtM1E4S21hS3VvM1BVamxBS0J4VmRWOVg3?=
 =?utf-8?B?aVVJenlZV1BWaCthK0NqUGRyeHFLSFpLaDM3R2pjaGFBS1FhSFBIYy9lVDNE?=
 =?utf-8?B?WkZjaU5oQWtWVkdBdGFDcmFrcmdsWWgyOWlKUnRmOVJHdVZJVDBPcUZ4RHJ2?=
 =?utf-8?B?djJHUU10SlIzM214Ylc0Qy82QzEzTjNsQk1sSmtKOHIrZ1BqY1YwTGxWTEh6?=
 =?utf-8?B?bkQ3UDBBcjVvRHFVYnB5ZWsxbkZKSWpnRGtTYjd4ekRGVldUL1Z4TUpuNncr?=
 =?utf-8?B?QVhPNVhkVmJia1hzSEh5MVArTE12Z1I5YVhaRU5lUExLSGVrQlVLR2FJb0NZ?=
 =?utf-8?B?NzFYZjMrMW9LUkFXSzJtNkszU0R3aXV2QWo0YW4vYjRJYnhYcjQya0xkbDJi?=
 =?utf-8?B?ZncwTXA2RmdReTdmclpmYW9KVzduZEU3aGhnQnlQSjdhQzBtdnJQR0FOYjU0?=
 =?utf-8?B?enJXc1Q0REVwcnlSa2NLQ2dKaHRJVkUwV3lYeG4wMlREZHFsMzhkdEVOSFls?=
 =?utf-8?B?Z2g3VlorcFoyejZzUkRjR1ZFdFNZK1RNdFBydldIMFFEd3dkU1c2SVNreFJa?=
 =?utf-8?B?RldBc2E1aFdMOGRwSjFOaTJEWS94MnlvSEI1RlFHcUpyd0JxQVJCUm9ldzBR?=
 =?utf-8?B?WTYxckhtanVYN0xiNnYyWWVqUSswOTdubm8yVjRHT1RnRy82TWpNTXowNEJt?=
 =?utf-8?B?RnBwSG14a08xU1dvdFVhTHZ3OWlMK2hxZUpZb28zekJHZTV1MGdtaW8rT1Ju?=
 =?utf-8?B?eTJDRStneDJCZ014Nkc0dk1NaWxlQ1BnNHBTTnFjbzlEQnUwNzI2bnhnS0Fs?=
 =?utf-8?B?akNBZ0NSTWxwWFdIbTJsSSs3bnl0bHBlN2pOWmVVRjlhdjcrL09Wc1lRQk5p?=
 =?utf-8?Q?LJhDfB3/+gi8Ww83JSva8+JSqzrPuBG+YI3RpEy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: accdd08f-726f-41a8-7765-08d91ffbcd3c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:39.2290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7mfGe+IlM6/DUl4u11QxGP55SPkup7d5SiCMN9BOASN8w9e12Ywo2vs9iRBm8tAFYBZCa8v+19CW4fsU0/r8clPI5EhrerQDJueuB0tvA+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-ORIG-GUID: LkpJZ9xG9avLd-owyOomW83YLaV7h8CE
X-Proofpoint-GUID: LkpJZ9xG9avLd-owyOomW83YLaV7h8CE
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 20 May 2021 14:55:15 +0800, ching Huang wrote:

> This patch fix the doorbell status coming from IOP may late.
> The doorbell status value should not be 0.

Applied to 5.14/scsi-queue, thanks!

[1/2] scsi: arcmsr: fix doorbell status may arrived late on ARC-1886
      https://git.kernel.org/mkp/scsi/c/d9a231226f28

-- 
Martin K. Petersen	Oracle Linux Engineering
