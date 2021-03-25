Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17599C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E36E261A10
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCYDyR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 23:54:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhCYDyD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 23:54:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3mkTr192561;
        Thu, 25 Mar 2021 03:53:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=DJrej8egj11HuPfD48kLtU+OtcLW/hWt+lrBrLXihlY=;
 b=VsW/h2wNDPWWxKOBXlKWaD2HmzJwdpmKNl/UnHhR3YCuuLT1UXBZ6pSXua7o0g8QRjtv
 HMC9Yeqt4Yu5lWYQIR453DKiJD/pOOKTiApeI4PoidJ1nbalGbsfP3AmFahrZL/5WZuB
 fTuxgJl6xAzQ1wwgKJkOKQIruTeDiHdR7pkpATn5E/DqFXSSSYacqW0aLjPhqM/B6WPS
 6KkIGFx2DTj1Bnd2gns0m71LcXMZS5j5n01sw3/nXa7OFI9jUX+PSLgqZJfOLrT8u6Hs
 2uqI8uizFk0Mp9zzKeHvJKL3VDGe9HoIFkirNDego3FfS7JBQosI8v/kQhLAThuJOV0G oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37d8frcwey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:53:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3pFBT134352;
        Thu, 25 Mar 2021 03:53:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3030.oracle.com with ESMTP id 37dtmrmum5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:53:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpj6rmQPB8ORBNbRbTLX7Qu1AY7BnlKUAXaubKhx+WGHmDtcAnsL5LWjQ+pzFVjBBm7WpNOi32+2jmY13T3E1EoFW1dp6fQIWZQ94pj4LcKFUVuXoky+eFvcXQfYT4wHtMAUcn/1fvJnQQ/ig/WllrgyBKqMtQKwpBWlC7hrpF7zG9lZkwx71RsM/Ac3FwPOjEaabBalYxnUZTvgtip4Pd6jdl7XlUA5GifiDs5b8FzIpAIS/UjKWgkx3GeD1rxkz2zioVOPYbnr+BaF+qnOHD8yhqTCUsI/j07aPlDP+7y3LUOhAX4c89ACxwtcimyRxtwNi7dwPlhbXnXsRKcTRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJrej8egj11HuPfD48kLtU+OtcLW/hWt+lrBrLXihlY=;
 b=Tgwcxx/RnbO9eY34j6L1QrV5d7QsURs42MU+Lyf2SAdQ65QNniZ4wk0BrId9ihStqZQYpJ0mfSLeNvI7gAuFu3hN6LjwhBUC35qeieNv0QlzTauQJZBrDxCmesuTPxNkGqWz7eqCZpmXgEQHQ3pMBr9/ONOWaS9/20GnaUdFjQQ9y0J2eJjDmAi3OBOJtWnb96imXO/cxicjf7aIcQpncbCCY0uXZBuwSb3veXNUVjclbI0ftYwhLouswxs+3Fft/ZVbJX0gQfc984CH5OtJIRp3dy0OqqrG/joN5MhuaT9Xe2qgUn2mC0n+sHs5lJptcvngbSkVmJL2ENCouoOS7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJrej8egj11HuPfD48kLtU+OtcLW/hWt+lrBrLXihlY=;
 b=O8na9UoHWbfyNhD70t4ZYDdSptn1I19RKRVJ4kebbef7ISvddC4boT4vG3eypzgi1PIktA9W8Y6vjt/sEfUDyuhOn72CE3Y7TVZhRxfaJpAZDRXl27NPWL/58xn2mO/N1MYgG8Kqqu4HMxt5ljytQyYY8Rwd3J2zZmdtdczhcPU=
Authentication-Results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 03:53:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 03:53:56 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/7] qla2xxx patches for kernel v5.12 and v5.13
Date:   Wed, 24 Mar 2021 23:53:47 -0400
Message-Id: <161664413899.21300.1608307969736124271.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210320232359.941-1-bvanassche@acm.org>
References: <20210320232359.941-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: CH2PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:610:38::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by CH2PR05CA0053.namprd05.prod.outlook.com (2603:10b6:610:38::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Thu, 25 Mar 2021 03:53:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf9ba692-6d8a-4878-43c2-08d8ef419d69
X-MS-TrafficTypeDiagnostic: PH0PR10MB4774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47743D8B94095205CE7808B98E629@PH0PR10MB4774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mO/Xl5YgjQkJrD3HTnQk70CekngEQFRSqDvTkkVMKE7bvWwN4KMeSShoHBxBs+LO9makbArBihMrT47ZyH1OD4XhTF3DELPGnp6VELT8lAD8GCriuwToqCkgP+tBCwywve488hkQrLlSpXdETKXELs4FmN2lHfivLEWv1diSCAzNs6TI47fZXX0+fJusdGL0S142sQl5cpfxYAr4+f2R0XHv1glA6uj0El6AGfEkoZJY0sL5jzJB7nXPnX6aJIsVKn1RFbOwdPO6JBiNP7Q6aya7y33SFMfPM0LIASLsvi3TKdly13lu+B3i3oReq52ghf6vdsSkH1KIAP0Vu8UwAE0c5hAXCbD+phP93gbHPEC/wAkct+XnMtUuliIT6IgkcG8YLX7tnjDaO0agbDhvEVqbBud+YVNxUyi3hlWjgqu7zJhdVZm2NWoW2UwrT8ZYrIx70K3z6Sz4y875jyTAojkHj4yK1EEMkCqY3jTp75s73b5ljHL/eF5vJbiOdrU0doFCHLFQ9G2kqMVqkaDTS0LVgAeajO6okfJ4Y+wd8YqUIQf51cSs2aVe/IiOTKwXj+oJ2Yy+kGSbIAM0nljNdPvvWhO502iAT2eHv1k7uEN3qyjXXaDbJgHzJVI6LcBJxFnq5Kmx+SMbagryQPRaRawoxYaCn06vpnLVjJGBwVwS0Aca90vAT82VnLXd79ciirIFF421nPBob8B0e8MsW6KL46DWh3V0g5AIXUvW0UI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(8676002)(4326008)(86362001)(103116003)(6666004)(36756003)(966005)(4744005)(38100700001)(8936002)(2616005)(2906002)(16526019)(186003)(66946007)(956004)(66556008)(26005)(316002)(52116002)(7696005)(110136005)(66476007)(478600001)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NkhhV04vSmhyQ1hqMEpGQTlJdFlBeTV6cE9ZQmE0aG1iUCtNL3J0R0dQUS9i?=
 =?utf-8?B?cWVlWi93VnNIZ2xQdGZRUmxQTkpkYnFPVmZ6cXZxWTIxS2JSckFKSkJJaEJN?=
 =?utf-8?B?cWtFa2dvMzcwcCs1S2ZZbWh0b3lMYzZzSkxXT2JlTVVYK1pRSkdibGlqdXEx?=
 =?utf-8?B?ajdKRlR0VjhsNENXYkJiZGp2Z0JETVFCcmROdG16MSsyVDBrTFN5MGZaKzcx?=
 =?utf-8?B?UXdRRHJCSnJSOThDc1gzdVAvcEt5NWRTZSt4M1NBZWVHbEFUeE9TeEl2UzM5?=
 =?utf-8?B?VHJzRUR2aVdaaGtsM1FQZ0dHRmF0aXl2Vnh0clIxelV4S3VqV3grZTR0aHVY?=
 =?utf-8?B?MjVkeVpVR3hKSEkvZlQ3aVNuWSt5dThOOXRDUXpNUlRZSExiMllRbklpdnlY?=
 =?utf-8?B?RTJuTVBvbGpVWmthcHdwN1BiOU0vNE5qZ0NSbWR2c3VxNm5MYlFHQm5uTFVU?=
 =?utf-8?B?NXp3ODI1eDk0RkNvTW5tYTI5bzkyT2w1aGJRSEZUajFCeFg5NHNQZDZEQk5z?=
 =?utf-8?B?ams5V0ZGM0pSTVBjaTRMKzkrVkc5VnZkbmtKM1liUk1wREZ1cUNQaTZuUFBj?=
 =?utf-8?B?ZE40SDlGeWVPSlFOMUhpRXU3ZkxLb0d0UjFldGZuVDdOMnFmczBZQWhZTHZD?=
 =?utf-8?B?WmFoa3h0c1krL3QvQjFmbHFnSUloSmJmM3prdzlKM01JWXYzUlgyK0wrSXV4?=
 =?utf-8?B?dnNNYmdscWkzNERscXJRRk9Zd0VIQjFjUzRCb1o1Nkt2UzB1cXh2bTFuRmM0?=
 =?utf-8?B?N3BLVkI0a0MyNW0zV201eTg5d3ZaQU1hSzFwMlV5RHZJUlBtRE9DZ3lMNzcw?=
 =?utf-8?B?a3JOUDg2cE1UdXBDeTZhMFlJdUk5Z1UzRnQ2LzV6OG9qYjNMeHUxWThGMlVY?=
 =?utf-8?B?TnZ3NHhaUFVuSm9rZVdWL3BqN25hWUpJMzdHZHVzdHU5dU9WajM0MVMvZ3N0?=
 =?utf-8?B?QVdTR1U0OWN0WXR5TFEwQ2pPM1VoZ21OS3ZHc2FEclROTjhkdElYRkhZZUJL?=
 =?utf-8?B?Ty84Zll6Y0lLQlhFcis3NXZnTjErSTJ6L2hpOEM5YVhyTEVFOTRVMXg0Wm5P?=
 =?utf-8?B?SlF2bjdGYzVZa2Rwd2VzM1NmeVd4REdxWkJNaGI0UmtrNThVd3FvK3h0MUtF?=
 =?utf-8?B?ZU5BRU5VQjRiZlVoSzYwSnZVRW9zU3FicXZtQ2MvNnRXanQ3SVkvWFNBM3B1?=
 =?utf-8?B?UUtrUzQwb3dNK2hacHRib0xTYkplVGV6S0U2T3R3NThzUXVHWndLMnEwckJ5?=
 =?utf-8?B?a3NFWE04YUVwQzdVZ3YxcWZxVjFCcSt0dVBMK2JVTXRpRGoxbVRBQUt3T3dG?=
 =?utf-8?B?VTcraGZqa1o0VEVkbU9CVFpjU2ZEemg5QWJqdG15YkJUZXE5Y2xlMDFvcGFH?=
 =?utf-8?B?NW5KRWdILzluSU1neExEKzlWcEVnNllrTkY1RExFMk1ZSmhnMlVKTWh3d2JP?=
 =?utf-8?B?QTIrNUVXL1doeHVraklDU0NwblhIV2Q4THo2NlpnTlFURWJDOW9tTFZTams1?=
 =?utf-8?B?N1ptb1lFOTF2R1UzaFRmVkJySXZzeHlEVXpsMUo2Rkt1UG9LOFptcWVOSmE3?=
 =?utf-8?B?OWRDaVlHaUZpWXorY1d2eWw2RzI4RFJ1NURhT1NnVHRhdGhWUWkwckIwRmo1?=
 =?utf-8?B?eTFFRlNhd0gyVWMzTWQ3KzhmVlJVcHVyOUNkdUt6bk92a0JORm1CLzJQN3h2?=
 =?utf-8?B?L0pEdzEwa0krRUREcFZOQk05eXBYUzhGKys5SFU4S2FjakxpZUdwZEMyb2lx?=
 =?utf-8?Q?rXESWO4sZ6JiaqrTB+2/ttlFB8y2PHToQkLPdmZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf9ba692-6d8a-4878-43c2-08d8ef419d69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 03:53:56.7900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qILU9Cl/E8NJNi07rmRKALerOAnovbcUKrVQLRHoLQXkNvOqDOvhvBDRCDur5yguLo7Rr2/5TZ29R60phT5M0ylbjnlayHBScjGuhT0hwNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 20 Mar 2021 16:23:52 -0700, Bart Van Assche wrote:

> Please consider the first patch in this series for kernel v5.12 and the
> remaining patches for kernel v5.13.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 5.12/scsi-fixes, thanks!

[1/7] Revert "qla2xxx: Make sure that aborted commands are freed"
      https://git.kernel.org/mkp/scsi/c/39c0c8553bfb

-- 
Martin K. Petersen	Oracle Linux Engineering
