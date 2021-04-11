Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F9BC433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 17:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3D1A61028
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 17:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbhDKRp0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 13:45:26 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39640 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbhDKRp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 13:45:26 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13BHdGZJ107820;
        Sun, 11 Apr 2021 17:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=VEh+Ax7hYEnmVC+/zMXGmPpdgOCQPDEMp2pj3CrKi30=;
 b=I8D1cYnNYqriCu2PkI+rFGMbpkb3C5VtnJcluEemsgBr7Zmvp6x+QVw5/83iXK+Mbsb+
 yx5EFNPcYPMdrcDlFkrRWf+zo8s+5ikGMzRTfxuuIE90gcJcYGks52Fz7mqaSpT1Y5VC
 ulEhynkNSUtCMZmRIQ2tS9jw7VLImbCYyIQle61joFTr7yg2EJLkKcQvJiCv68hd0/6w
 ITlcSG7s2aEJdPi87HzL4SAw67OiFpCX/CH0LCHDhYD0HSHqoAB+wk+fHLUdnvXE2C9y
 pLpXhixFXQvgGIEsrP7MnGBc9Xb1Y9ajy3jnUfO/9US1a608B/XsBBulfwiLDh/ulwvM Dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37u1hb9x6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 17:44:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13BHfKo4061475;
        Sun, 11 Apr 2021 17:44:51 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by userp3020.oracle.com with ESMTP id 37unsq2b2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 17:44:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QG6LiAL534qKSna2/XWM94D/dtYEjqjxyyw51xbMXBabObxRkJ2vEz7JeMLurbra+IkrjpNpqNvvjmO+7ak1KOAymIEygOl1GPimPnThem9Uxg0kIv1iy/Mn3w8OhnnepogbXsIHTQKgfou2jdQT1CPpUxKcnIhi9OFJ01DTdWhap4bkKcIuyiuwWrt5NU05iVupvqrHE+R2CutoRrl8iXi/C8Xnr+W8EiMRNzRRVPJXorGl2nrYmYlNDGVty2k6XFsXGXfEU65/CQpO/TNC/NveP6YdNjkNeTkOfm4ScIWWkjooWipPUNlj3wsPpWrcojyUKUnynyuSvoQ5WWllBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VEh+Ax7hYEnmVC+/zMXGmPpdgOCQPDEMp2pj3CrKi30=;
 b=gBIT8VrW9o3NTvO0JQL6gLgp2htppBLE4Gr+PyNmLIXkBgS/WbMc7AqvhOuPkP8DkcZuTRCuD4wxJI4Shv9LMWiQ4N2ZEOQBMDOmPCGWXN2mZdm8K6M3h/5isRJw/SU6KNkeWmFbRcb5wfjDNobWUpOORjmg7dxfd0suea4Mz8YYzLrOF9BcoRMFzSYWvI4zA/wbc8tOicRfAhjugOE7sNdbiZ+N03ENrHmp1b15DefYULNuMcBrsPIliL1Rha16dAVyFK1ZP5+Llt5Y8uFx9xG7/gnnPgpQnfGhVGTC7g32qYDvPqSIyikmINp531xPVB8n84Hb5EtyciY0YTioMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VEh+Ax7hYEnmVC+/zMXGmPpdgOCQPDEMp2pj3CrKi30=;
 b=D16Lkz3GafTyfBQceloMLKbeckWLqlgSo9S53Bs+cHNOxQ9qNRl4Euhj4Gfq9P0JzZNfvJqsycBGPvvA1VTnXmO0fW9uAzKN/m0vT07KYZqebleGSyqmZD2+8Dh9YPTkQPj6jSdKR0SlYrzHGh6Q6w8sOkK0XXRsOoJruKaHp8g=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2632.namprd10.prod.outlook.com (2603:10b6:a02:b2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sun, 11 Apr
 2021 17:44:49 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sun, 11 Apr 2021
 17:44:49 +0000
Subject: Re: [RFC 0/7] iscsi: Fix in kernel conn failure handling
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210411075545.27866-1-michael.christie@oracle.com>
Message-ID: <6c42a160-4369-95e6-68e0-7df2603bba86@oracle.com>
Date:   Sun, 11 Apr 2021 12:44:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210411075545.27866-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR06CA0044.namprd06.prod.outlook.com
 (2603:10b6:3:5d::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM5PR06CA0044.namprd06.prod.outlook.com (2603:10b6:3:5d::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sun, 11 Apr 2021 17:44:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9044f77-9e17-4c60-15ec-08d8fd11810c
X-MS-TrafficTypeDiagnostic: BYAPR10MB2632:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB26324D952515063DFA2BECDBF1719@BYAPR10MB2632.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3MHgdT11u7MiHleU9EfW/vvKV2Ng5LKHlNP7bbDlU49HuSk+ohB5zAp/OsnnIzbiwIB8fIi5Q44QV7/yGo3XHALlGOwQsruQnXt4rsbMmrg9Ye5nL6QeJtKMDZk+/RyQ4QRj1mHbz6RUiKQMcUVHTayya+4ZtHUxNLrE21df1q9TnRioFKMu40nzqxGfCBT/Z49LYiECuHJokNVhSykQOO7WZI+GNmumr6luGcNHC87serDuq4DnGXS5l/JLIpaS6ut7/gJB6xlyBXKTw+qpVhf1b0gG/JuzvxmljgVz+06D/ijwdOIb15rPyTSvos6CN3Gn9Z4AFKu7yXFAbsTU0qhc0yC4SsRJmzBYu+6EnpYaU0uL/9pXS3KWpCiKQtREIyoF1MkYTtfIaro/ugyV/YvfdcvhEcS6CBm5+I5z5xkYxKYzaxW4nq9ceh4rrDcot4LA6jn3h3w2hlyX27DlonAB+xDxEb12i3bRwZPSbJlO7RVS1O02YZo6kH9IbvIkezOV7zTWXmdzEYS9GfxxRzOfkrvF2THj74scokPnkTsMn5UMnX9I41k8pkp5LMLh1k88RSUqQB9rcGsVELz3ySU+YovNiKl8AvKSfLYji+DJa9YoP++RgbCzvQ19zpsV8C17932299dorFbdnZyODmSx0ragnAJ68E7XG2+7FkH0TnmAmXMV+r6X5s2GYzEIM5UbEaTn3v3EWjLj0GmHhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(396003)(136003)(376002)(36756003)(6486002)(8936002)(6706004)(2906002)(66946007)(66476007)(38100700002)(478600001)(31686004)(66556008)(86362001)(4744005)(2616005)(956004)(26005)(53546011)(186003)(16576012)(16526019)(5660300002)(316002)(8676002)(31696002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dlp2dFUxNFEwRmlaWUZVeWFDRllGOTA5c0hmZWcwa0NrV2JUU2lmbW94K3hi?=
 =?utf-8?B?VWFmeVFYTFp1YnV4YkQvTzYrT0pEWGxWUzNUbXBVMVhvUWJkeWJtNm85TXpC?=
 =?utf-8?B?WmdDenJIc3NQQWtxRUxvdDFab3R4c1lrV3RyYzcybk1HeHFXSzcyZzhUcHQ2?=
 =?utf-8?B?NEQ5NjFxSW1KZ3hhaGFzVnRDSHBIaUlwVUhGS2o4d28yL2QxV0RDTlVXTEJR?=
 =?utf-8?B?cWRFMWluQmt3aGVaaVdwM0U2M3Z5bkdyOW5Lc05NZmVMWnpsNHVWdGl6QzBm?=
 =?utf-8?B?cFFYNVlPTEk1Qi81SUF4N3ZocTVjLzNlWUdRcnRFSkY5YjRWZEErSTVTTG1I?=
 =?utf-8?B?STVHQ1dBc1p3MU1BSDNaYTJDMzdtWkNIaXlyVytzWjZvcHFKZ1Q4NlpZNm5j?=
 =?utf-8?B?RVF4MHlOWXo4T25VRFFxdXZaeVU3UXl3bTJEZmNqZ3BxZzdBRlJDR3RxUGJn?=
 =?utf-8?B?TmkxUXFTd3F6RFFzMWJFQWZXTnBmWEF6c1pvcEhZQTlTNyt6YWMvbGVpT1Z4?=
 =?utf-8?B?L1JmamloNnM4bFJGMXlDSmd2YkhsRFVEbWE5aGY5aldOSjRrSXlrNWVNUit0?=
 =?utf-8?B?NlBEQnl5U0p5TkhrM1l1Qk9weEozcEd5MHc2bnpROE8xSmFiTWtET2lrUE1a?=
 =?utf-8?B?RW1UOHhKVU1xM3BXWFJUMXJlZWRHNW4wWldxdVc1SkhOcHIwaVhsczJlZzJw?=
 =?utf-8?B?VlhoM0x4RGpvL0tDR1FzQzNYamdySGhVNmxMVmtOeG5zdU1ZNTZhdkFjQXVH?=
 =?utf-8?B?Ym5yZ2lINTlhL25zeFlhUTJ2U3RONWZWNmlLZjZNd0JqTzF2Nko0aFRLeUZu?=
 =?utf-8?B?RHBHencxZDY1VlpNUEFLNlNjOXVEb2N0cnpXay9ZOVV2T2owRWJ6dDR3MDNN?=
 =?utf-8?B?cUdPSTdUU2JUQW41bzZvY1UwTXNncVV1cHhYMFdDeEMwSE9yR2pzc1JzM2VH?=
 =?utf-8?B?TDF1MmxwUTIrZWZod3BtTFVIZ043L1hHU1NjdU04azV3NTBTWlRzSWhCQjRK?=
 =?utf-8?B?MW54MzFmbDA4eEtRVVorS0RUN3BOZmN1RlV6YWdvTFhpYlNZeFd4amtoZWkv?=
 =?utf-8?B?UXlXK2hKUmhQTWdOcGhLdGJLM2VHVUtpTUlkcjZsa0xxSTdhQjB0bGV0eEdM?=
 =?utf-8?B?MzdpK0dFM3hLb3Yybm42dU9PcjJNTzdGalVhMThocDE5Qjc2ME5oWjZiank4?=
 =?utf-8?B?MWl6am5YOWlXMmhXTi9ubnB0VUhBVUlBVnNYU3FxcEU2VkNCaUdTMWdKcTdE?=
 =?utf-8?B?d1h1UHlBd2lIOFhCZjNwd1pZNzRKa042SWI0Mm50ZUg5L2dYc3lmMnkzQTJM?=
 =?utf-8?B?dXo0L3RYRlBONmppcVdnTUg5cFhBeHZNYngxTFBBRko5ay9wM2IyeWtuVlNs?=
 =?utf-8?B?TGtiQ2pNR2VUei9sWUZGWFBRTm5XYStGQUk5TXlXOFcyb2xqNFQ4Y3pmVlpw?=
 =?utf-8?B?NmNadGthWEpTTkZtVEpCQnhZTmxIYityU2h3alRDYU5DUGh2SnBIZVJaYmVa?=
 =?utf-8?B?Q3h6RThKWTZiREdXMllJSk1lSlpqdmFjTVg0MnIzS0xHT29Ua1QwbFNRdWNa?=
 =?utf-8?B?dkdndUllYkw4aXBEL291MndQV053SUVvK3dDREd6ZllpUy9rUVRvL05JY2l4?=
 =?utf-8?B?RGMvM3M2S09aZEhDS2VqUlRmc0RaNFE2ckNUYXJlZ3NEQWF4S1JrTnpJbWZu?=
 =?utf-8?B?ZlNJMGREWDlERCtDQnE2SDBNelFJaEt5ZkRjd1lTTFZSZmZzcExLZDNOZ0x2?=
 =?utf-8?Q?Ozce5wNRbWpFRkPCevEdjnr6Xq5y1tJxSJZD78X?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9044f77-9e17-4c60-15ec-08d8fd11810c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 17:44:49.6078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VFN85u56FTXf+iGGGZKH3OMhIWSm0hBbo+D0uDQ35J/BElu6GtWgIcZuVQAvEsGs3X57r7cn7Dpg3KnfPkV1f9MKsX50b1OhngxDVCnkzsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2632
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104110139
X-Proofpoint-GUID: AL2dxS1bEeLsjncs96WL1p3S4FxabAoP
X-Proofpoint-ORIG-GUID: AL2dxS1bEeLsjncs96WL1p3S4FxabAoP
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104110139
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/11/21 2:55 AM, Mike Christie wrote:
> 4. The stop_conn_work_fn can run after userspace has done it's
> recovery and we are happily using the session. We will then end up
> with various bugs depending on what is going on at the time.
>

Ignore this patchset. I have to add another change for this.

I just realized I handled the case where the in-kernel stop runs after we
restart the conn like I mentioned above, but didn't handle the cases where
it can run after the stop and before the start so we leave it in started
but unbound state.
