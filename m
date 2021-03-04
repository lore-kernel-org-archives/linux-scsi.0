Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5AAC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 04:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D691664EF6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 04:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhCDERq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 23:17:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51172 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbhCDERa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 23:17:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12440dhO050190;
        Thu, 4 Mar 2021 04:16:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1pYKK0SiAEXQXIL6LXQBRJMEDcpxh+zLyGxtywZNoOg=;
 b=iMpQvntGgkqREcbVxvzW4TtWUTnlT1xoPPcUK596/GglVsDbBwbMsU1r8PKY1kw1+UZ8
 dlhFaeOodP4kkSZtdlfIbhkncKvUV3zX6IEJ67UcMT80mG8E8w/bls8pbnnxaPbgrloQ
 r0LCQkessVf4mdGeA+CPGMGYfKTtJdCjfSTVRTYWdfvC1rTht/IGZ07Yl8ODEDynMfe1
 qjV95iXtvxRItL627oGzVMeomPv69Vcngj9JKmC+NRMbC26m8OMN2WNoAbihLTFayZfE
 Z8wjMWvgkkFAtGwtUPEacYrn8jGJzFaSvmwlvIykIVaFMdIXPaJdF8xV3zaBknf+Acjl 3A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3726v7b7qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 04:16:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243sdKu058393;
        Thu, 4 Mar 2021 04:16:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 36yyuuarf3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 04:16:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GyHT0DQsI49d632yrtvoVx9xONQMZ7gr8XF9DIvYDy+yozT66bfFY+hFrobXfDE5f5OUZ7tMm8QK9iUG+lvQet70BIQLoucnih8Oy6R4l21RItkvc1nIBjWEVIPdnUTG5wxSuZ9U3dEvNzUIxOnKbAdV5uQNxtbT3F6vY9yNomQWetGYWm2r5henwMuzoZRLXhQ7KXwO3EZkNHbk1m6Fn6FJUs8Ga3ETZ57WZBweh/3+GT86/xTX31yCNvE0P5HxClXxUMS17/VwSGFYx+btuIPv12ZrEvuswU8HI4DzpnWrC9VVmfGQff4Rx53+oUohgBPOWLvQg7s/qzi8rl7D3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pYKK0SiAEXQXIL6LXQBRJMEDcpxh+zLyGxtywZNoOg=;
 b=YqS24d8dmbt7MlS/x2RhJdrvmQXV5l3oDV0WRHoqPB8QGn6dR+4mTZ47AZZm4juV2BI16eUTnXVkMCnEWwENZR9HsyMYpyEzLO92M77m5qr5cBN5UyBrB86Cpa5pWhZmDXWS/JO7dbJ2pVVFbs3K4E9BPG55sysbPQfN8STPVmt1oGaxsgGwkGms1rTIkNJE7nBMN8p0FacJnBA0FaVWUVlgA/nUdKMV8/qme3rxlCQSPS5naDQ0eoB2t/uSHEvQzKSRkWiqU/8tgr560x7cT+LvU+QVNpzVRYBHwCoca44mEKEdVaCIZZtpHVfrhlmjB+x9IQ/QdI3OZxwx6ewtXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pYKK0SiAEXQXIL6LXQBRJMEDcpxh+zLyGxtywZNoOg=;
 b=vQeVx2ASYVt814BUEC6Hbaz4cQjzPlKXUvJ85wzJm5kT3p9CPw9o9mVXFMYiD5B135IAzjWsKl1slL+jg58EOWDlujffqnx7q8xagvO4zBlsPWAumvV6cT3FGAPBiQliYcYXU2E3I4L/NVLlUbz6Vs5KHcsa7tGb5qZBuWWk1jg=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Thu, 4 Mar
 2021 04:16:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.018; Thu, 4 Mar 2021
 04:16:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        hongwus@codeaurora.org, nguyenb@codeaurora.org,
        kernel-team@android.com, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/3] Three minor changes related with error handling
Date:   Wed,  3 Mar 2021 23:16:38 -0500
Message-Id: <161483137624.31239.10249562654506643374.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1614145010-36079-1-git-send-email-cang@codeaurora.org>
References: <1614145010-36079-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0007.namprd05.prod.outlook.com (2603:10b6:a03:33b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.13 via Frontend Transport; Thu, 4 Mar 2021 04:16:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1133c018-c4d9-4f37-2ee9-08d8dec45279
X-MS-TrafficTypeDiagnostic: PH0PR10MB4552:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4552A2E329B084C97AA8B3A18E979@PH0PR10MB4552.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +2s7JGUOgHkQdaxVPcyNQEUFecvo2b5dL7S9RIP+xCvjl9e8/EI1kcDHBa0Bf7ZyEoAIrrQBxGYtQag5KDAKCnlTF5vEV0koM1uIiz2DxABUkQd+7Nek/juGzsYQr99HCHTjJcjjFQhqlhEU0LyMUlU13MYchIyf1dI9JFKd9nLRznUfHMrP0csTpfXyjk6NZLKCKkWnQGZrNCk6TW6lPkzZoZ1xl4QEp+Oi0C01/eMw8Yp0hABCCRXfTdN42P4brvYe4VvtO0udru3iQD+QzvHJE7/yM0lf5QEVc9aVpZyB+4sOwUV91NU8CWGrITBbiRmqcvpyL983tT6RtU10qiHakfUQNu6F7TZQPmTfxSCJouQjWGWNhpxRFNm1AJ7k/Jrue4mgwxmif09l0vChRBkskE38yjc+R4UQFjC8AngqABmNNcbC4KNHikOMUi82COJqvJyfQhnis1gnhZgkAUZTYvOsSXLXe+RDq4ckp+46QgHi+OUof1pIajloqRyf1LKnDVGxB3Elvki4aZWy4u1puzzMVRMr7klZEdveyqLqm13c2Tfh6ooWNhsyXOSal9qmvBnjTP8dydI0Avvt6j1bujqeTcCcaxOLKFcErLA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(346002)(376002)(26005)(66946007)(6666004)(16526019)(316002)(6486002)(66476007)(478600001)(966005)(7696005)(66556008)(86362001)(4744005)(2906002)(83380400001)(186003)(103116003)(956004)(2616005)(36756003)(8936002)(4326008)(8676002)(107886003)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L3lDS3QrNHZReXhYQTJIVzJRaCtvVFNGWkEzM2M1QWV5YnpndGROYzB6T1pC?=
 =?utf-8?B?YUxudXB5dHVTM01EcU5GZ0lZcU9RRTlMZWNSUkVsbVZ5UWhDSERjcGYzZFpn?=
 =?utf-8?B?djhucmIycExHMFdFS0dzYUVwMU5ncHNSd1VWdmRNdVNXR0FwWVdQcUxVbXUv?=
 =?utf-8?B?TndPbWZBNS9vOUdKN3dYNWdvQzhWTHBxandnMGt5T2tNVVIwV0ppSERMTFp2?=
 =?utf-8?B?YjNwTlpkQnBxQnoyUC9BNW52YlM4ZE4wMmk3VGJVRGZFWmVxVzlZSTc1OUhj?=
 =?utf-8?B?b0NNZk1aaVdaUlJPNXB2UndSSDZsSnZIQXNBM1hld3lqWCtkTlc1VEZKZ3Zy?=
 =?utf-8?B?a2dwQ1R1WmphZ3VvTVFhQXZvL2hydTl4V0F4QVpMbkxwYUYvb0svRUl4SG83?=
 =?utf-8?B?NElkRTduejVMN0dQeVBZS3ZhQ3BoWnduZ214dC9vdGtKa1VxOHp4T29tK01U?=
 =?utf-8?B?M3c3V3pjeXlXa29mbTVweGN1MlYvbWE5SGVVVWNpbkIvV1JLOThmOVIvZXlO?=
 =?utf-8?B?VWhFYkd3QVVXRHVjZXg3UVgxeFo1T0x3dVJ0QWlvSitjZXhCOUFaNjlGU2Vh?=
 =?utf-8?B?cjVGamNPdFNZWkhibWJGTUZsQmdiV2w4Sk0zc3F0SUwvTCs3MUt0SUtiaDVm?=
 =?utf-8?B?a0d0dHZXMThnQXY3b3RZbm5IblByd1RscXpIa09kMEt3Umw1amdsakV5clZS?=
 =?utf-8?B?ZHp3OEVOcU9pdGJldzVXQi9QK2c0aERoU2ZaUDA0QVpRSm1ZbWpZdVJBR1Qy?=
 =?utf-8?B?ME1DckdYbXIyWmV3VXhVWVF2Vmw5clBmNis0K2dMUk0yVXl2RzA5UnRqQ2xV?=
 =?utf-8?B?dDZxcGM2dUFRUXpzVVB3dG80TUZSQU10OTgxaStGKzNnckt1OUh2Vk43eFdZ?=
 =?utf-8?B?OTF0dnRWSkZBY0FqV2JkSVVIcTZpa0xsNzBjTFB1OXZ3ZCtRRFU3eVN4MUEz?=
 =?utf-8?B?bmUxTGkrWnloZ3NHNE9oWFh5VGJMMEs0VEpCdGFRRUVUdkhpei91cEtTSlZh?=
 =?utf-8?B?dDNoR3dvWVAvencyWnp0dFlzK3E3Q2M4RjFIaVhCeXBnQWgvbVE3VWFVbnIw?=
 =?utf-8?B?Q0thdWFMa3NJeUdtb2FXOUFjczNsZVdOOHd0bTY0dUUyUTVMSEFHMGdpd0sw?=
 =?utf-8?B?SEZjTEZTV0ZybGlCNmNhbFRocXlXeERSWlhsR21Va1ZRUHZUWDdzRXkyZEJj?=
 =?utf-8?B?Y2diOHJCV1hIa1VBZWVFWGhESWE0dE54eGNsVnp0dTQ5SkZ4SzJsVExWR21F?=
 =?utf-8?B?aWpTVWxZWEF1ZDEzY05wSkUraUQzSjJybUhOaTRKU2duSnc5aFU5dkhzL2Fj?=
 =?utf-8?B?b3k1ejJMTitQYTNtL1EwOEpBWVZ4Y1VLNUpRemRVejc4VWl6czBOaitMUFBq?=
 =?utf-8?B?UkN0UG5HOEJjdFJrVWJRa0Z2MXAzWmQxWTViUDB3VnY2MFREVTF3OWE3QTcy?=
 =?utf-8?B?OC9HUWw5QlpBM0VQeFdGL1AxQVVRWGhEYW9FRmx5OVVTTEtNc2c3TDVONys4?=
 =?utf-8?B?VXNiVk1laHBKWXRZRkJWR2Vlc0MwTUhSQldDTUpta0NGTmhvb1ViNXhLdk9v?=
 =?utf-8?B?djhQbXRYNGliazluWVk5c0tBTm93enVHZTJyMDc3OVhMVW9RUEY5Wk5QV3ZW?=
 =?utf-8?B?SE9NblpCQTNaYjY2WUxRVU80dmtiMEpXTk4vOFd0RzhEbndDRDIwOVhFVHhB?=
 =?utf-8?B?ZVB0bXEwU1g5VjNnQ2RaRUU0ckkySWh2VDQ4Nk5yc3ptK0ljSERCamh1eWd5?=
 =?utf-8?Q?t4eV4KZOhE7yzN9Up9JVFx9AoXtSw4uATIWlzYt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1133c018-c4d9-4f37-2ee9-08d8dec45279
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2021 04:16:45.3108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MARI+OkW83aFPORxU7A8Ht5gBxgCwBE2OVfDzpDvyX/l9URWwSp/LyUx/gIW7qv1xx/LKWb51pZ372IgSs1nM0Z6XeOdyqIHyOoDaFnHG8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=805 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040014
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 adultscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=976 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 23 Feb 2021 21:36:46 -0800, Can Guo wrote:

> The 1st change is a complementary change for error handling.
> The 2nd change disables IRQ in host reset path to avoid possible NoC issues.
> The 3rd change is a minor cleanup to !hba checks in suspend/resume paths
> 
> Can Guo (2):
>   scsi: ufs: Minor adjustments to error handling
>   scsi: ufs: Remove redundant checks of !hba in suspend/resume callbacks
> 
> [...]

Applied to 5.12/scsi-fixes, thanks!

[1/3] scsi: ufs: Minor adjustments to error handling
      https://git.kernel.org/mkp/scsi/c/5e7363b98e21
[2/3] scsi: ufs-qcom: Disable interrupt in reset path
      https://git.kernel.org/mkp/scsi/c/51d31ee8de31
[3/3] scsi: ufs: Remove redundant checks of !hba in suspend/resume callbacks
      https://git.kernel.org/mkp/scsi/c/8514907e4f64

-- 
Martin K. Petersen	Oracle Linux Engineering
