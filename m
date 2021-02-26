Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97259C433E9
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B80A64EF0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhBZCX1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 21:23:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51366 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbhBZCXW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 21:23:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2JMho027021;
        Fri, 26 Feb 2021 02:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=h34HPZmXFfGoKf0JsxLUCHkQFZv9nT4jBuEya13w++Y=;
 b=fCyzmzBWMALkKjYfuyfOhT8fsKYtc5HoJ57SvDWeY7Jk1sQ/V4pBngyEQAXPbqIrWJrK
 ThYP1b1GsVonIQ/51yUrDKhTS48wv3v6htHGAtovRG9ykdhP3J0XVlhvthpOXdW9WxZh
 yOaB0GJ9tn+NfSx0J2VW1DLVkOWCwr+WuSDfNkNLYTblYQXQ5uX7EsAUpTixn+mLCPZH
 22rHZQVwhEj/IZBFLTOL/wrW6/h/ZaJCWfxda9ZpP0WXTljC12pV2yxp/xYVOAMIKnNu
 Jt++YIM1NeH6eB0hOcE9NEEcNkJ8IUBEwxFzgArXj5uVRWV5q6Ui//JV0BxV6go25BqU kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36tsur8hjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2KjX9083209;
        Fri, 26 Feb 2021 02:22:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3020.oracle.com with ESMTP id 36ucb2uftt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VoOHh3uWhAhksCofh0hXQ8nG+fb/IRbrCOsq4bPUwZqcKl0rctQ739zQmZLqCN5guuFhzh0Q2SdPugwN+Rfn2RAdhzKnBhq20rpUxWRJPISsVWdhvPb7AtaVK+iPMaARX+38O0oec2DeDE5ck3VoCorD9puRZDMh4ZDCiKvOu93NhIRKojTYdF1BzNvnIC1bj3WN6S6X5eJ76RIKUEmkgcTuVhN1/CRjC8B/4ic8Ipa/JA9+PkI6R9nHU89ntRcvasYbse4JpPAFIK5903n0UKhf1XlpyxkNUkg7hvM+Dhy+UevJYUDJQuFbCpZ4D9fioB6yc1aIe5/niLNBNBH/IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h34HPZmXFfGoKf0JsxLUCHkQFZv9nT4jBuEya13w++Y=;
 b=gCTNmXTQ/lKsVyJCam9Nc0Xd88gI/ituix7iL8QCnNgfORUYzFYazAZ6mLLz4HyoFK91gN1VWStjzdz1DZMNJ3tcoDdTZZSi9QWntv+gDheo3zB1ZqIsZqVVSntqc7zpMCDsYrkJnYkihsprkAS9w3Axw7Zs8jry545ova6PI52KFebNgqBVTyEffpsse7n8O3xX6SvBSevvnw525cKM2XSgHrd5RL4BDKxCDOLyUivk5fTN0GQ0LoE0e5+1ufCDSdV2baRWPJgB5Eb+rynQO2gJlJfRd0B8xUh+UyC20I5Iru20+jeXkU9K0ZkyqPzT79vMV4z0Ua8ackh1LxPsbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h34HPZmXFfGoKf0JsxLUCHkQFZv9nT4jBuEya13w++Y=;
 b=jEO+OFjGRDpxQgRrPOlBOA4qigF4IjQSsMhI4f5vZ0Vk1x3wL7FclLmwx1L9R+QjAUcfuQK7JzFClfJDOoGvWqBmMZaicgUdbhM9XlrAHE8bTk3G/T7n8ihZNx39EMydJqb0RjgdfRHiT3Rkf+3LvEEEFC5nF8/v+r1+hBEAZdk=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 26 Feb
 2021 02:22:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 02:22:22 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     hare@suse.com, Chen Lin <chen45464546@163.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Chen Lin <chen.lin5@zte.com.cn>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Remove unused function pointer typedef ahc_bus_suspend/resume_t
Date:   Thu, 25 Feb 2021 21:22:08 -0500
Message-Id: <161430583251.29974.3277105701263033834.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1613389249-3409-1-git-send-email-chen45464546@163.com>
References: <1613389249-3409-1-git-send-email-chen45464546@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN7PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:806:120::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN7PR04CA0031.namprd04.prod.outlook.com (2603:10b6:806:120::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 02:22:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3551a555-5a18-4c7b-1b3d-08d8d9fd5981
X-MS-TrafficTypeDiagnostic: PH0PR10MB4696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB469606AAB1C6B5100A30926A8E9D9@PH0PR10MB4696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: adaj3u3LwdSAFv8XQesdnAeA+fixS3ZBpfbFFULXQWvcv0YuJfY35MZv0lBgtf46yofSh96Mu0uhFP5tKTVXhcNHqbKRBL1KInZsyHVe0jjhwRlWb+fMx2u0KmkKNH5BZ4B5IOIFWZ/cgseuLrgVxRliqaV5YTZ5GzJxuN47wuT/vPwPK+tFbjcYuDw+hAIWXbZQEsrCWOIH97ie0Ot5yxKT0mwtsaiS202AHPlTijJ9LUnzu3VO9W8gqdin5R9V/jnB1hHK1X2sUiTS83ytYC/G1lGrSNzMqdScbshjdA2AXqkaqDyNremjMIspMpRoF4AVE/jQ8g+n7Cn6wON2gLl+8SRCb02EfBpvxDwvtOfH4JnDzgdU8mcga9D2l3TF8gyxKk6d+yjMRcTC8oDmKufghQUSqkvHwl3+vOQCoD+dUkHiKcS5FaSxdyvZ5hKN17bTLNfY5EnHygRpfXuaa57HmbloHjW10h7P6LW8a+NczFMXqZeXaDYiWkoiiBrZctnmIbtFGf//zTNrDJ6NfEq+oeTBs6PImVHwqTIdGPo+kAx0s8GHtZ9myjzhbaUTf60ayLIL1/VDbIqhy4XuiWlWyoWrJZjEU6/mHZIaRL8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(136003)(376002)(36756003)(4744005)(8676002)(2906002)(7696005)(52116002)(2616005)(956004)(966005)(103116003)(8936002)(478600001)(26005)(316002)(6666004)(5660300002)(66556008)(66476007)(66946007)(54906003)(4326008)(86362001)(186003)(16526019)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?amt6TFppcEl3SkwwUHpEYkh2K2tSNkp0TW5ZRVZMOHNQVEtITE1IV3ptNmZq?=
 =?utf-8?B?OFVDdWdVT21XVXVZQjdRL2tCQVJKUUhXa0ZGZkw2NFh4MDZMSXJBazR0bGFP?=
 =?utf-8?B?VHh0ZkRIOWhRaU1TaHpEeVRaZlljTnFOemhlSFJQWjJoTjRYcnNPZlRkMlJX?=
 =?utf-8?B?KzNnQWM4U3BwdEx1SlcxdDBjMXZjZmhrUWlNeEx5Z3pCV01HVXUzcks5d29Z?=
 =?utf-8?B?ejlNbUQwR2RHeEJjWnVsb1hqbFBwa0JWOGVZbkVOd1EvM3hnM0l1K052eDJi?=
 =?utf-8?B?MmNpUkVrSGtOYjRaWnMzeUE2cUJ5U21MdVpReXBBa012aXZDblkxUUhZa2Mx?=
 =?utf-8?B?b2pBTWdkQzRwL2xOckQ2RVFCNmppT21rYzZXVVlsYVIrTFAvdzVXbmoxclcx?=
 =?utf-8?B?bDVmNDc3QlZjL2V5ZnpjS3V1UG1xQjRiVVJ0Z1lIN2htcHlqck04eEt1c09X?=
 =?utf-8?B?U29qUWV4V09nUUh6SGNRT0c4R2xBcjRYYzVKdFB6a01JUTNRK3lPRHplaUpt?=
 =?utf-8?B?UFdCMVUwMHB0eUpyNUhXOG9LR0ExVGZPd2tyVlNDOW5vSjdEWW0yRGJHTGQr?=
 =?utf-8?B?OWJCYzBLa0RoUTdWQXoydFRLSzREdmRNOVhqTDR3OHg0K2M5aFF3M2dtYnhl?=
 =?utf-8?B?QlZtVUNkVnl4T1h2bHZlT3VlMUV6TjllUlpueE5OOEY2NS9LT0NNYjYwN0U3?=
 =?utf-8?B?VWhNaTBVTTdscEs1Qmg5VUZmaFRpeC9BWmVyTWJtWHd4bHo5aWZrenBPcWVX?=
 =?utf-8?B?dlorOXQ4UUxNdzdYM1BnSWJSV2Fzbm5KNjNvZmY3eFhybTNQVGVBQTZqSmJW?=
 =?utf-8?B?czRSaVJKRG1aenZVL2RDT3lTSS9paXVGUDZ6VW9iTVh0WnFqTzZRTmlxTlcz?=
 =?utf-8?B?NmpqVUs2ek1NNi8wOGc5UUJFYUpPWXNzVExONi9tRHBuYS8rMmF2OThZZGRi?=
 =?utf-8?B?TDFwRkhzRlpycjAxdjQ4Tnlid211UmFZVXdScXZsaHJGWERUc1JZNjBlN1Vm?=
 =?utf-8?B?aE1PTjZpT2hlVzEzWGJIUHA1TE1kTHhGSERka1lHdUpxQlpCR3dQcHZKaWxB?=
 =?utf-8?B?U2huZ0w4Mm9uOElKcGdFWWxKNW5iaUtocmpqOWJMYi9RMWxOeXNrM01LOWJK?=
 =?utf-8?B?ZkdVdUNzSTRiRnYvbjU4UW5XYXpPREJEU1NqWTJJU1I4OEFzSFMzTFAyMkdS?=
 =?utf-8?B?N1gwZW9NUnh6VTI4VlhqT0swb1orVGJkaHY1dGQwcXZ5OW95RmFwenNlRWlM?=
 =?utf-8?B?dytnUklxblA4YllDL2ZIbHBxQUphbDR6SXdDT2Z3MlBGWnhWb1JWTFVrQ0Zo?=
 =?utf-8?B?UVhIdVRPbGViZ3lSSlo3YTNOTS9Idk5vUGZDZ3ltaFBMdWFZNjJrOGRiam9E?=
 =?utf-8?B?QkdzdmlBQTNJclE4YXNXa0V6WE5lbnhJNG9TQzFPYUtqYmtyaWc5SHE4c1hx?=
 =?utf-8?B?NUsvUTZCOHRIL0NSRUJ2aHp3WFVUTDR0MXVzeW9WNXJGQ1pxVUJua3NOamxi?=
 =?utf-8?B?aEQ2WldGY3doVzE0MUc4MUdWS0toTnk3VDllb2JGMTJsdWNrSFRHR3FRSTJu?=
 =?utf-8?B?clAveS9zQzgweVRldFpnSWkwNnRUUUNtSGhBL3VYSVhSemNHSG5UWC9FS0pM?=
 =?utf-8?B?Z0EvWkVFV0hsbFc0ZDR6SjR1SWtGOHUyMzQzVitnU21TODZtbkkwT292RXly?=
 =?utf-8?B?b1ZtcVY1WTBpZUtpZ1U1SThKeTllZjlRdFBrLzNsaTJJZkkxMHR1SjVqTEJz?=
 =?utf-8?Q?vexlrX6+yM40bgfFfM3W2Zpqdn8P7WvGA5atkYF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3551a555-5a18-4c7b-1b3d-08d8d9fd5981
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 02:22:22.6831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vaQq+iyHl6nzv+AF08rxYd1JSOVh2njzLmYSjzKiTg4GIrTqo13ppWTPdEUdZ1LfT3hEpWpYCerrFjdDe+Zde+hvlYd80aQ1LY19hv7BG/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 15 Feb 2021 19:40:49 +0800, Chen Lin wrote:

> Remove the 'ahc_bus_suspend/resume_t' typedef as it is not used.

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: aic7xxx: Remove unused function pointer typedef ahc_bus_suspend/resume_t
      https://git.kernel.org/mkp/scsi/c/c2f23a96c6e2

-- 
Martin K. Petersen	Oracle Linux Engineering
