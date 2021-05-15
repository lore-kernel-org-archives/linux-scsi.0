Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F114C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 03:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CE9F61428
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 03:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbhEODP1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 23:15:27 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33018 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbhEODP0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 23:15:26 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F3E5TA157579;
        Sat, 15 May 2021 03:14:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=mRprE4uUWesY2cjab9m7Md1iNeoeFem1zSvUW4Gigy8=;
 b=hq26weF2iczqhxSp18eVdRp8BIuAQ2qigiDgXEJC+T00pAUGVpzK0y7Wsr/quHAdyoRx
 iQ4R0rd/GANkzFgCFwNN5GEyo5RqZI4bSmVoHwpCS2ZvYAqoMinMF1HF+7M8L7/MMZCM
 xsAwpKbc1bLGaFysTZtnm1beBercmM+mt3OeDspLGhDx9whg60Da9W1+xwtny1Q2+0IX
 0QV/a7fYdbhQZrBuGCGigCvhUb43KJdh5MSrMg+NJS3ztfMppPqIBdlCYBaXIeareqWK
 VjY7z6bxOKyPpV+HGGe4BPU5bD+4ECG9Pc3jhDg1E1unPYUqjSwTJAgpTjbEj810MnN8 3g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38j3tb833n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:14:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F39nw1079663;
        Sat, 15 May 2021 03:14:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by userp3030.oracle.com with ESMTP id 38j3dray2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:14:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ivy1MxBQ1ueMEYxnT0pSAVvV5JxdpPzbfX1LtuosQAI+iC+bvVUiMZjb+Y/Q+sP7mjrXPABdyZc04oEraKz1QMDp3KssaNAK4wW6avis3j9SeYntsZ37NRTDZtXeEg5PJWfuGwYbMO3oNXJtw2hpS/yO9LUZ33oODQdRf6FHMvFH8M4IEJ0uYePIayJt1M6cydwPaYRqt59ik+84BWG06IJtO23yndsCTQ+PqmRNVkY+qxGtA3/QTwN54J9BqF5vbL/hMU27CBnOtgCNNqQQJcyglYBIgsas0hXWNEg9+qpg8viZhSUIH5cMuedB69gEVwnrADrhL7bxN9aweES8cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRprE4uUWesY2cjab9m7Md1iNeoeFem1zSvUW4Gigy8=;
 b=XxMkgZD3TJdUz6F7OUZb8F8bGhQXwTO6FJGoE6xFjuTZ/RZkWZXtoTA/rT6ToZQo05p3cCebGjQWtw50l+/xKHt2B5LZUA4DqM9BmNydL4sJaWxhr89oSLqWRU2FnEqW18hhoCjmmhMV0DLYyj2kb88BiMHr5OjTpzAeu3cHoKXA6gBgCuhmfs/Qf3CzU5L6WsP3cy948RfIwYcu1B8lhyLp9e6jnTG46UpFJ1t5FQvWdHaxZbfpb8YobRslmKhZthzI4ZwZUAFKpM0D1GjCyTXUum8n1yKJ9A/D7eVj3BZntE+L3P1DTq4HM4LzXgxwa3D49FjG4gpMuGnDbgRHxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRprE4uUWesY2cjab9m7Md1iNeoeFem1zSvUW4Gigy8=;
 b=lJCQT1DQWhrk7vvnGZOmgzW/NU9dw4A6CR4JomklbbRxx6oAa5rtPW5SlYfZxnD02RY8lvR+M8N5oax9CVRXoWmkW6Iu+FrUs4TlipTVHboB0HVc6zn4PgGk9J6hgzP8Vzhdn4Dv7p0lQGgA0Eayml4tBT9oXl2sEHy/wNpZYpM=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5452.namprd10.prod.outlook.com (2603:10b6:510:d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Sat, 15 May
 2021 03:14:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 03:14:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, stanley.chu@mediatek.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        peter.wang@mediatek.com, avri.altman@wdc.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jiajie.hao@mediatek.com, chun-hung.wu@mediatek.com,
        cc.chou@mediatek.com, wsd_upstream@mediatek.com,
        alice.chao@mediatek.com, chaotian.jing@mediatek.com
Subject: Re: [PATCH v4] scsi: ufs-mediatek: fix ufs power down specs violation
Date:   Fri, 14 May 2021 23:13:53 -0400
Message-Id: <162104840194.20119.14495605358253459911.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1620813706-25331-1-git-send-email-peter.wang@mediatek.com>
References: <1620813706-25331-1-git-send-email-peter.wang@mediatek.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR13CA0226.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR13CA0226.namprd13.prod.outlook.com (2603:10b6:a03:2c1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Sat, 15 May 2021 03:14:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 201357a3-85e0-46c7-9365-08d9174f7ce7
X-MS-TrafficTypeDiagnostic: PH0PR10MB5452:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5452B05B47A5C3FB34AFE0808E2F9@PH0PR10MB5452.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9D0DwLYBaAknsEp5KNQK+oMWXdMODr7EbtEui5KhEXyNJLeYkRmbU8cOoIyZcQnbFKPp1gPSeBMvizsvEby84SUsAEDiLzYK1a4COY4PVyC5o9Q7FzXBPXhpXM0Y1tlanuVLyXOe4gvQdU2ruzlG/+0pgD24zpWjb70d+l4yRf9z5eEG4f3P0BbHmL7HZBOMcAVRczz5olS8qS6Wv5X5NH/rmx6RItSvbRL7HQFJTngu6vUtd3LLAdUh5oza8cSfvxC4A/T6l9C3PI4If+odDU2QNy/A3kqQecW8tX+ovs9JqJiVqa5FESbFzPU7pjAycrAW6oI9yVdULoRYk0+TvWb5hivImLP8lZ5bsVxJxhOdSw4ToJBfo2k3ZI3GzK0yaX5m1hFagiauTamtzs6M3U1lvjWj3QjOUUBYnL24vXd30ZxvBQXm6ckp3OtwswF78wJALW392jPx+TkB23ShBv/7ftP6fTFBry9O22hZAX4wSPqLsLacjm2EytnA9guu3eHeUJwOZCvsoUXMB2xDbxazjZj1XrVg/f0lBk56ggMUEyGi0fL7i3pfsuF3rEvBEcnbzT3pUxoFgDxxSDAOxQVzDb9saR4hkwsh07nZzMnXjRAYxucjq3OHWGJCccPpI8MVJdIVRTOgm9yRvlpQphsDRQILuwSJ9/CNU0x518wj65btpTLkuegGc4oeQ8zOlEebhCQT5HUsAkaZ6uuQX2b9kXtVHb0Be5ktgTm6c0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(39860400002)(346002)(7696005)(52116002)(8676002)(2616005)(26005)(4744005)(6666004)(7416002)(956004)(66476007)(66946007)(36756003)(2906002)(6486002)(16526019)(5660300002)(103116003)(478600001)(316002)(38350700002)(4326008)(966005)(8936002)(86362001)(38100700002)(66556008)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T3hnVVk5R0QyaTl1bmNNcjBUYXpYZTAzaHFLUWgyN3d2TnQ4cGF1OXFha1lL?=
 =?utf-8?B?RjFjU2VNM3RhNEtTTCt2Q0gwR0liMHIvcWdXLzFmdEYzL3YvTFhlcmozdGlX?=
 =?utf-8?B?QU1ZbjdiVHZsVUEwWnh1eHRrcmo1Sm80bXBMMFZjSS9uWDNmbUd6Ry85REoy?=
 =?utf-8?B?MUtXMGN6M0hKbE1iRktsSDc2MExrQ09EZnBVQm1qR2loK1R0M1c1TXBDQ3FD?=
 =?utf-8?B?RXptSnJVRndkdlRBYUpzR0hvSG91OUxNNlRjN2RKYVMvYUthK1R0UzdnQnE3?=
 =?utf-8?B?UGxsYzlhbzR2ZDk4SGZDTjZ2NlliSkd0NFA1TTExdWx3cDMraGtHS001Mmll?=
 =?utf-8?B?MmZaTUQ2czMrVGtiTHU0QlNVd3hlNUxkRnFDVFJlYm1SSitOVU1iRmFFaW5T?=
 =?utf-8?B?WXJmdzd3MEJVbFpDUGt4b1lNWXBkOGhqd2VFaGE0TXRnMllObnVRdHM5cTFC?=
 =?utf-8?B?U0J5cDlOMk16UURSUXZuTm01ZXVtd1NXWjRzY0hlUjcyWE9ldm13RUhoQndO?=
 =?utf-8?B?aFh0d3hzS1ZScUFoZlNWQzR0MGZqd1kyaUlvWXJLYXVVQW12VEJtbFd2ay9E?=
 =?utf-8?B?TlFkOW9FcWVLaTNOL3pjMlBVRE5QZ2R3VkdaTFJERW9iSXpJc2l5SWFMb29w?=
 =?utf-8?B?SHY4UWM3ZXBTVkhSY3kwY3F5c2M2SWVwLzdQTHJFZVRRdXlYTEdFaGw4bUNI?=
 =?utf-8?B?aEtCajM4Vng0S0NqREpNSHhUdW9ueUlTb0tzdGdvYi8zbEo2RWN5TnQxaXpL?=
 =?utf-8?B?Wm1Cb0tGcTk4MHI0Z2M0R2lvSzFNWUF5NzA5bGhKMW80bnBoRGYzTjZEL2x2?=
 =?utf-8?B?T2RXZkIxWG5BRFZUVDFDMnpKV0EzMW80Nmdyd1dNaW9jai9xNmJtVDJlYkMz?=
 =?utf-8?B?d2JVK0taUkxYVDJlQU45ajUvMWYzb0JEcjlhR25leW1jdTFmS0FmM3BQa2Ir?=
 =?utf-8?B?bXEreVJoRHNIdmV5b01zbWZKWmZRMmxSZ3ZDMG1qRnlzZ3NmOE9ScWpXcWdU?=
 =?utf-8?B?Z3o5K2lBYTl4dlZGaGlPSFpidndRTHpPd0Z0cy9kVnNpU3ZPQUc4alNjc3B1?=
 =?utf-8?B?dTBGekdQVlJhdEY1N1JqeVBteERtT0lySkRMaEdJTkIzeU1NMzFsRzQyU2hN?=
 =?utf-8?B?T1o0djJ3czR5c25FOG84OTN3YkN0VWkyS1hUUVFNd2tGdFFPNlZrNkE2dXJZ?=
 =?utf-8?B?WnJxOU9DNkNNeEtEUHg4YlRNUlhVUnkrd0RraE85K09EQkNUWkZVWDFZQVVL?=
 =?utf-8?B?eVYxSy9vR1dFb0RHaFAyYnowczJzMWtQZ0p5NyttNGVWS251M29UNFBkT3Rj?=
 =?utf-8?B?aDJlaE9GY2UwSm1Wc0lyVmhBcHQvQXhiQ2VhdEFYU3B4RG1saFhvWjljR2hw?=
 =?utf-8?B?RnE0T3ppZGw3c0JSN3dVNWRTRTRyOHd0NHRuWDhLZ1dqRjRpSEpJR2hyWTZm?=
 =?utf-8?B?S2Q3a3NNNGhla2VBUk41dE1mZXRmSEl1MEY5UGpSVEszR2s3WVdWUVdFUEh3?=
 =?utf-8?B?VHpkb29wQTZOcnpiMnJrNlpvOWlkSU5nWWsvZmNQWjc0NFBXMHZzaWJnckFT?=
 =?utf-8?B?Q3FSNG9FSjc4Tk1kOGd2cUh4K1RDQzlQMUYxSGdkV1krVzMvR0pVWitObVRq?=
 =?utf-8?B?OHV3aWV5RkxOU3R5d1ZRaEhCeEpKU1BvclZ3YWlVUjFDb1JPZW81aHMxaU1R?=
 =?utf-8?B?OHVibjFvaUxPVVZCK3dzYy9zcnprQ0J4eENvNmN1ZEluMFFyNmd0WWY0YUhQ?=
 =?utf-8?Q?+036ugGXwfKecvmG09qnzKHHpFPdLgxWoiI2Qkb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 201357a3-85e0-46c7-9365-08d9174f7ce7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 03:14:01.7232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pm/OSf9jlUm1wmrCQBoAyZ66bYQe3IzgXLEToZFC4Nb4lHQpLDOOHiZYeXQTNEuqtK0hF5sLWgiobfu6Q7s++bqQNWGcqw5D35ptTawU70g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5452
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150022
X-Proofpoint-ORIG-GUID: hvio6RpSauQMnVoUG253J-xArav-MMHO
X-Proofpoint-GUID: hvio6RpSauQMnVoUG253J-xArav-MMHO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1011 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 12 May 2021 18:01:45 +0800, peter.wang@mediatek.com wrote:

> As per specs, e.g, JESD220E chapter 7.2, while powering off
> the ufs device, RST_N signal should be between VSS(Ground)
> and VCCQ/VCCQ2. The power down sequence after fixing as below:
> 
> Power down:
> 1. Assert RST_N low
> 2. Turn-off VCC
> 3. Turn-off VCCQ/VCCQ2

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: ufs-mediatek: fix ufs power down specs violation
      https://git.kernel.org/mkp/scsi/c/c625b80b9d00

-- 
Martin K. Petersen	Oracle Linux Engineering
