Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1186AC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC44861954
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhC3Dzt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60872 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhC3DzU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3kYqP142286;
        Tue, 30 Mar 2021 03:55:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=UMgmNIr2VdXMspFCxuvPajyg36HERBZc9B7xq8F31ho=;
 b=ht9wywvsrY/ef9aYDQrU/C9+Wpu5++HJshx/eNDlzEn2CjErx8FghAE02UyxvuBQrcCM
 OXWIBqOzS4HC2M3x5ySS3F0DIEh9V+XAW3ZdCi/PI5ojUa+TrExGd2jvbgRxlXxLEuDb
 05rw1KFv0nli98myXHZlXsOrxOcvE+T4xaJlYMbaLyeg271X377JpTreBMiZTjbw+nj9
 Oou+sphme5bXKrSJV0LcfE7hqoQjmyiAqdbPYmUMSYHErb13YSHNOV55sfhw/cKqzYyK
 CrwW70LNqUbhB9gctzKop8nBchC7iFgJ2/RfUrrk8mhKs3+n6VSz4Q/W67GiMxz/X2d7 OQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37hv4r5k3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3ikqO193057;
        Tue, 30 Mar 2021 03:55:13 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by aserp3020.oracle.com with ESMTP id 37jekxyv9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ll1KfhfK4+Lm80L3n4KMbykR3xA/5yUmSpIUSVUYM4agPZIdezf9OQApyGwNGFzOgh+4U+LGtBNLNOAXy2hwUd5eGappWSPxp9YTW4C/ZVCOqbHhryi5C9XLXQ7O0FJuHn68sB5zY/fTXVKACtonZE2fXPmZLpGOuPSWUlDUiYIuPuRC68LfyX8w1uW7PJcWnhjLXR/mVY4o/rpd+zXlDnYpu/Kifx9Rk0bex+qmyWvvLiXks9l7xbQzSH9hPD1o5Gk4yZCx57stXGXlPRkUOXZ8NsmZ8fa7Gb7LQitg1FR0ajR2Oxlo7xJ8qOqRsso9reeMcmOFQXKP23u1QERYIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMgmNIr2VdXMspFCxuvPajyg36HERBZc9B7xq8F31ho=;
 b=K+JGhZufEm5Shbb6I12E8SeHsZrNbEo4mUJfcbztemi3a8NJEZ/QqlqI7zxMnIV2OLmYkEuO/B7sL/7WITC7MLZbdwr8eZbjofbKnQzptzcsXjf89S6iF8hpG9AsjJvJ37AhuR0zZ6Dr1SfPw05FZnNx4TWTl2HL9Cc/A+OgyPAlAbfkB6SxMU75ww+TNpH6AW29e+QHJwqqUoQ7H3grbWwkQy2/zBL9wXJhUVDsDnFtM+NWhHETM43lU5ZdAX8MJMTsThXAw6Bp1+aEhFmyrwwl14Zfczf7DtVzVMyjll+CKOjevTrYzvBIFZZRhEM76FeVUDgYc0voAMWvo3yHhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMgmNIr2VdXMspFCxuvPajyg36HERBZc9B7xq8F31ho=;
 b=oUNOH/GcSFUnkaSSkZq0mXFRvhxb9HvIuQAJ3RPmXb43oYkmKln5vt0aBUM4kGBZoN9H3h23pXYwh4bRA39jUasJGWJ2waR7Lj/jV4/WdxSgI9ZIJra3D+/dPZNaQ6qd+zQP7GifyrpY2jjpzEKApMO7PhHPr2rALimjKjVGK9E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:11 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org, dick.kennedy@broadcom.com,
        linux-scsi@vger.kernel.org,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        james.smart@broadcom.com, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rdunlap@infradead.org
Subject: Re: [PATCH] scsi: lpfc: A mundane typo fix
Date:   Mon, 29 Mar 2021 23:54:43 -0400
Message-Id: <161707636883.29267.1635519910068540605.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324064829.32092-1-unixbhaskar@gmail.com>
References: <20210324064829.32092-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec2ef9f1-daa5-4bb2-8352-08d8f32f9dce
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4758E68A79D6A9947536C1FA8E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ocycuspdnXu0CBBhdf38dIIY8QXmg7bON8/IVZgrty2NwDu5Vwrudnj3AsdKqvDkAvaxZZfMD6uOiFjFUs/y4WV0I6hHa47FJK5m2c2VVm1cIsqiA0+dYOGWv4rW2bm0wyypDx9ODhu2Dh/toc0lxJI8yZnf5cEMlfcQmydhQ/9SOh9c7ldFG6ve0GMGjm3cqJ7M7tefOBGwIowQ2wmH9j2nIOmJrCepeKi7BM5SZAN2l2sPf+8rhe9sBchJMGLO4Gm0ylo71SWUiXeo5aG7OBBSkGPAkxATTUVHa049nbGQiIEZNJfB8gkgyEk6rMi70ogESg8zTn1JjeP3HC4LvtErXcAQbDqWUGO0W2FQI73KkcWac8bH3CpksH5b9ly40kDKNdDt3seyFCVHmy49kHVtK1Xya+5imyGD4HUo4UHhqY+gZTewu807Fz6axcnKPy0g616Q4k2oXwnfR2kyzus+aTIh2ik6WZJi64Yig70YsLkf//ZINwA77+yGRz2E0q4FpSn41EDjt0DPvg6R22J211zWbGbi0GjCuusSTqtyhdaUO7A4G2kMnWMfUSs3/isdJ9NTZo0pdvx+glQy6AWGKBD0q4g3Gtf1onabctEiKBaBGoBAPy7pvQdl0hzpd7A7H0xl8X0uQqpgrQFmSkgyNXwtWjMCkMMIVeXf1zseaJSqHgHDNfLJYNgNhhEmKBt7Tl5LxPncK3Zn30luVAuY3Ota2FYwkLpYSZtgoR4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(2616005)(16526019)(8936002)(956004)(6486002)(8676002)(966005)(4326008)(66946007)(66476007)(36756003)(86362001)(2906002)(558084003)(103116003)(66556008)(52116002)(7696005)(186003)(26005)(478600001)(38100700001)(5660300002)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dlRxMkp0eUxwRVNBemFEbHpEbUZWcGxxRlo0UDNGejdhWGVTRWJ0NnNHWXBX?=
 =?utf-8?B?VVVoRktrM0lyQmhjQ1h6OEVnZmYxVTBZZm1TRjlmRzBFYXBFTGwvdTVBOG9X?=
 =?utf-8?B?STd6L0xJRHM2V3RyNUNqdFRmZVozZzFMMDNaaUdDRFRsemdRQnRYUk9yWUJw?=
 =?utf-8?B?a0o2ZW5uTHE4OTRrS0FySDlRaDFrOG5vN0xURkt5dmprWi9NdTBvaSs3WFdu?=
 =?utf-8?B?aGFXa2thZ3k1SmN2TVA5RjBaWkpIbXB5bmV4ei85MnAwYWw5R3BuWlRucU1t?=
 =?utf-8?B?V3Y2R0NQSXpFMmY3TXBpNStYa1BHMm1XQ0doSHNNVy9WZytUWERyU3JpcElU?=
 =?utf-8?B?SlduMGhJUWoxWStWTGV1aUhkR1gwNmFLZThnZ3ZydmJjK1RicUpCL1pmY3da?=
 =?utf-8?B?TXJFMlJDQkxYWTVaTTIrR09naVg5ZGdaTWFEWW5MMDVUUHJWSTJHYnRGNVUz?=
 =?utf-8?B?d29OTWJjRGMzUGtzckR1bllBMFZYcEZvOWNpdDlWQUdXUVF1VCtPWlJSOU1j?=
 =?utf-8?B?TFZXYi9IZlRTVVVuKy9wczRzTjR4aldWYlI4NVExVXZCOHVzcVF2WG9Pblcy?=
 =?utf-8?B?UjBYOERWbXh2V2tlMlYyTUhFWXhqdnN6c1d4TDNVZEhGWGZkVFVRS2hDc2pa?=
 =?utf-8?B?MVhEWW1YaDRua1h4TFl3WnN1RERFWnA0R1Ztc0Z0dFVmanNoRlVRVzFQL3BG?=
 =?utf-8?B?Z2taZENBSFFkNmFITnFlMEVSUi9Ba01GNzZ0SFlDS2RTWU9qNXhEZU5lbUlt?=
 =?utf-8?B?c05DcWNtWU1CZ1JXazJUMXlxcWdVNWwydG5NUEFBM2NtU1dwRU1JZ3BGTzgx?=
 =?utf-8?B?V0QyV1NoU3pLTVRnQ0psMDNYZG9lUkxPYm4vcGhkL3JkblM2UWkvY2tnZy9V?=
 =?utf-8?B?OVFwSXNhbjd1bVVtQ0gwb1pUOHlYbDdPbXNVc0R5czdkajJCcUE4cXpwa0dq?=
 =?utf-8?B?ajd2YUFTQTdpMW9JQ1kwSXhCeWszaEZwdkgycVdneUtNMjg4ZXhBVzl4djdo?=
 =?utf-8?B?NEUrTkhUaVcxVjAvTEV3aTU1NmcyNXY2YlZyQjI3V0ZwSWFwNGZLcSt5VGZN?=
 =?utf-8?B?VlNJYWZjSmMvY1dudUtmNnloTTFya0ZQZGllZFRjYTFCYzVYZmk4S1R0SDY4?=
 =?utf-8?B?RDNtT01LQ2hWVlZ2Z1hCT3ZVSlcvS0pFbWp3L1Rkbm55MUdERXEzdndRTU1L?=
 =?utf-8?B?bFZlWWJzNHJzR0drQ3lVYnRaUitEaWhFZUVxelZRWW84Q1Vic0hjOHFJOFNT?=
 =?utf-8?B?MGh2ck4vNnlWL1g0ZTZSQWprZGJQL2tKNzc4c29YYjcrV0NKUXVLVEI2L25z?=
 =?utf-8?B?Nnl4WkEycmVWOVd5V0dmYXRualUrdHJJZEc5VEpyZEI3M0hwcG9yeXZ1RDNp?=
 =?utf-8?B?QTNwZllPUlFVS0RtRTdDNEZHVlFwMU4wWWcwZ2U5dk1jYWFQNUl3cGMycGZL?=
 =?utf-8?B?bWdIajd2QmkzTjd1dDRsY0thZDYxTGZBaU1zN1ZPM3VRc0o5NlNiam1nYm5I?=
 =?utf-8?B?YzBCTG1aY0F4alRGdHJiQlFNNUx1T3J0cTdxNXRyWFhjWUFSby9pbnMxYlQv?=
 =?utf-8?B?UFMzMXFDREtTOWVaMFo3U2ZnU0Q0QWx2VVdkbHE0b3RZUXdydFlFT3dLWnEv?=
 =?utf-8?B?ejVUdWRncVZHUVpyQ1pnMnVWMzU2VzFwYkdCSXRJYjBvc3hLRTJoVjhxcHpG?=
 =?utf-8?B?VkxUa0UxNllicU50WTlFMnFRR3p5RlhCMC8xaGs2bW9PYmYxUUlXNnplbERT?=
 =?utf-8?Q?4/dyg+GYyEntfYh798dkOt5265g0AQGSrvVjHVq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec2ef9f1-daa5-4bb2-8352-08d8f32f9dce
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:11.2063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ilVu0Hw0h1s7SdAFT574A9uVwPXhc9zDP4t4rsxJPNE2Si/R2kAIbJbtD3AyDxvrsjlV/mEiTT/jDAZpjZC3/uyC8LxupiswKlj/JOdHQxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
X-Proofpoint-ORIG-GUID: thbXilMaBLvv8a-vIJq52sSkTASvh34e
X-Proofpoint-GUID: thbXilMaBLvv8a-vIJq52sSkTASvh34e
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 24 Mar 2021 12:18:29 +0530, Bhaskar Chowdhury wrote:

> s/conditons/conditions/

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: lpfc: A mundane typo fix
      https://git.kernel.org/mkp/scsi/c/f1891f9bbc46

-- 
Martin K. Petersen	Oracle Linux Engineering
