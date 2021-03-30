Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F83DC43381
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05A926195D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhC3D4A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:56:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43680 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbhC3Dzk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3isE8110521;
        Tue, 30 Mar 2021 03:55:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=O1W6WREK+obO+LujZSQjceKKY+sAaShlYMp0wsZSYg4=;
 b=XDqmYZfAOJ1ScxHKcW9AJVNQSd9c1oFxEoXxN6gj14J9j0ULBmPvbDWGnO3v2LK7A6yJ
 eHiR5Ur+7rcCaaqj6pVTmjSfkimfXDtOGe+8NtUWyTvbbpDcm+Z0Cdls5NeQrpeg0Qns
 8PZlc99UXncxDcCt6vH0lsh46UXnycL44n3GcsaRiPiTIQ+U8Bt6QBaHVBle5GIN9o2h
 wZxD//cwolVJeJdNTK0Yj2PxOEnKtRE+oC/Ro5XGa9AcQQvwZGz9YZA5wX+yj9LpAjDL
 xi7AzwckFBbYHU6T/uXb1s1f4mW7upk8bMBV6KlTti+sVjXMTXMMsMet/hmfktWK1sA4 pQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37hvnm5kbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3iXIl039560;
        Tue, 30 Mar 2021 03:55:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3020.oracle.com with ESMTP id 37jefrktpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aye3h/NJnqaCv/iMJSTAPAarYSQe7K1P//avgWLem7J3Re6AgnRgfIbWX6Ya7cf6OS/2yA78NpbwIfTfJ2ETEns611CczJnMdqZyw5ZZFOpsh3/uZNOHZDq6Yx83hJgbg3+tKnnnBSimVEATr+PoghzChTBp0nR2bqEsOXwoE3zj9Ci+fvNIjt4LTsdhtd4kJCWa04gteX2U5sdzexwsAaaHREyG+O+ckb1ObEwyhi69R2Trf2/mfO9N0aKLkUf+fFwG173UKW7eRLIr8MZF6as0XCM5DAZ//mfY1k5+cjWRkhJFbrd5qkglFfF9G7fdnwU5XGaILLcF5sUqj8i3Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1W6WREK+obO+LujZSQjceKKY+sAaShlYMp0wsZSYg4=;
 b=j9wIrsXWbd5MbL77+PfhR2u9NbraWV5zNatJJ/X7RBUhTo2YXnyEHMwrxfX2G8OODdmYGU9JkikjKQcSYxwsT8Zxe7PHcwsR+VnDKc9uVcC1EABkXs9YGTzn1U6wjxGahvPCt8CjiG86xoEQYaDTPA4SSb9O6BgqSJr0wt6jgDa5RUwxvtxIgjxkYJ040Gt7aLVgYDDFc1Cn4XyqJDoeTp4wlmyUwvk8LvYizkH4nvzfdvQ0w2Oc2sH06rIpDfq6ICEp1nVNjDyTJdHzBWHmTjLXkSqyeolc5Y3MnCPzBIjnvfWiWkIvQMqq8YFUR5CWEDWV0iBJH51I5saZWvPuvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1W6WREK+obO+LujZSQjceKKY+sAaShlYMp0wsZSYg4=;
 b=NLT+T0S9jRorlLgaPF/JwsBqXKGmfydwPmx715KcwPbp7J3Ih7NdBuYXmndoLlyef39guc4geMqzjXFikiyx6Kh484W5CqqFnCtUFVIcf1oxJOgsFkwe0h1nEkGJsM1aqrEnKix2il35kJfdL4/+cgUh4El1v4yH7zy4ArxRxAw=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4760.namprd10.prod.outlook.com (2603:10b6:510:3b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:22 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, beanhuo@micron.com,
        cang@codeaurora.org, Yue Hu <zbestahu@gmail.com>,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        jejb@linux.ibm.com, asutoshd@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        zhangwen@yulong.com, huyue2@yulong.com, linux-scsi@vger.kernel.org,
        zbestahu@163.com
Subject: Re: [PATCH] scsi: ufs: Correct status type in ufshcd_vops_pwr_change_notify()
Date:   Mon, 29 Mar 2021 23:54:50 -0400
Message-Id: <161707636879.29267.11163435698107903846.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210311040210.1315-1-zbestahu@gmail.com>
References: <20210311040210.1315-1-zbestahu@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4ebacd1-8b02-44c9-eecf-08d8f32fa479
X-MS-TrafficTypeDiagnostic: PH0PR10MB4760:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47602B21B3FCF77CD2E97C138E7D9@PH0PR10MB4760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sJMoVJ1J5a53q3tzBnMQEm0iT4XYPispgwoP3FJekY3vb6vhMdOWZvIQi+wfeoEccdmIl5OF8cHUstcuPeQYwWUSNR7TPumg1cuBL9seP0cUNFp4Vd0jRlNWiEHliu1zHETW1O++WFwXW20S4zXSlIm9IVKvvi0xHhYb5VDahedG6u1xJfYbAcWtq/0N+wUJUtHjNlk1SSIVrVB5pohV59KlyiKOXwbJywD51g4pz7knT11hDnyuY6qBaGlM+gUhMeA1Mg84sRsbcTH7ih2EA3lcBwTAFh4PhACtlePEQpNp1+1SjhF3l1EVL66r6Qiv4FWNJlqFRtix7nW0mtiehAnaNSeMq/H2oX6IZ2x3zFUC/3FJ4vStXSWpoydvvzxPO30rXA1/EdIo9Z3lo2S/INNsu1P/lnysSVHka7pBJfNiQsDcjVgNg5Aw2tGfQBpBujk/NSUPwRp/rQ2zuzzN3rDnU3scwXKD98/BOo7O4Feu6d1hoEZnMjP0o5zHCZ9ClVbgsLDmV+8CLGUH3ZCQU0/ny4PT2d0SrGatJjLLsN+SjKzjPACBEYO+cfKA2AHPimX9XO14Elen7nptF3UGUictrcXfGNZ8t6Or1me5RJIGoB0IKGwZml5zgAU5S22vRp36hkdk1RELG87qAs9kzrIPhaO74wV/VVCpZqYTZV2EZkgEjGrNduxyZ0WET7SeF48s2ycLRQIIL0mNw9uEiS5Bu++DZpuqoZr+JDFIgrs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(346002)(376002)(66476007)(52116002)(86362001)(4744005)(66946007)(66556008)(6486002)(26005)(8676002)(478600001)(7696005)(186003)(36756003)(956004)(316002)(966005)(103116003)(16526019)(2906002)(5660300002)(6666004)(2616005)(7416002)(38100700001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c21JK0pCeVNvaEhzSWgzOGtCYWZTa1N5dHZSalYvSlAwQmFWSXBBRWFPWVI1?=
 =?utf-8?B?K1k4aTRSVUZOcFZpa2tFN1h2SzZjMmduTDlvMjUzZy9nU1FTeXZ5VGQyTEI3?=
 =?utf-8?B?N0RLTEJ0N3BJM2tMdXdRekJsNXpnWk9qK1dCUHVwbFNnbjdvd2lCcXRUUVdN?=
 =?utf-8?B?ZDlOSmNQOHcyVy9wRlJOQXpqb2pFUS83VUpPLzh4N1lpYmJDeDdud0gxQ0lI?=
 =?utf-8?B?QXFYRnY2MWdQYXF2Rm05RTZZL2pTNGFWdWp6aHg1bUE0YzJOVDR2bGxDYUt1?=
 =?utf-8?B?REFDM3h1c2hCNkxSV0FoZTZzdGhEOWpBL3hqbHVpRnVDR09ITHM2cVBxVmJP?=
 =?utf-8?B?N3l3cGdnYlRIc21aTGVJL2RCMytSamV1ZFhKcTFNdUxKd0dlbTYwNnRZaU5a?=
 =?utf-8?B?MmhCanR6MU90YVpUc09USUZINmRPQm9EbVUxMmpUL3c2QXBSclBrV0VMWC9U?=
 =?utf-8?B?RDdsK0NhU3FndU5icnYweEdCSFI4VXU3NDJjRUNydnkzS3ptR3dTb1pDTzBi?=
 =?utf-8?B?VFFlL2NsQmxVQmhzdVB6NXpPYjVIaGFrVFlFZWpKd2Y3SlRTSUtxaFg1c0Fa?=
 =?utf-8?B?ZytqTWlzR0RHelB2OGpDVjI2VnJqaXZ5QXduQTFuazY1cXZCK3IxM1p1WlVi?=
 =?utf-8?B?SGtTd2pCZHgxU013OVZxYm9uVXM5M3lMdHBWeHRRb3UwaEF0dlNhQUpXazdX?=
 =?utf-8?B?ZjM3U1ZyNm4rSXdFS09IRmJlZXVsMThUbnBMMXZLSnF5ZW1NTi9TbkRRNE5F?=
 =?utf-8?B?S1h0QXJIWjBudkE5eVIvZzgrK3ZXOERBb3lsMlluVThleE9RSXFqazdpSDhu?=
 =?utf-8?B?aTBCbDArbzB6VUFvdVdQTklvMnByU3E5Snp5czZwK2JJUUE2L1h3VFFWSnRL?=
 =?utf-8?B?K1pYZ2g2ZjliSmV6UC9GcCt3TlNnNXR5cksrc1Z0V2pTdHpTcWcycWdVUndS?=
 =?utf-8?B?REZ3NkEvOWFsZ2g1elNLWFBrWW5Tb3U0a3pPcmdBRjRRWUlPdXVNbDdRZHBa?=
 =?utf-8?B?eEI0enZYcGxIOGFoWFQ2bzZYZXgvRzV6VlJrNmJnNEhrTVBoeEVLaWh3bzZS?=
 =?utf-8?B?MTcrWE9Ccm80RXhzdkdVTlNhVEo5WGp2cHFrTUJFejA4bXc2YW1FWllKL2ps?=
 =?utf-8?B?WUkwYTRNVm1Pekd1bnZQVXdNNFMrbkdOS1Y2SW5Zdnd5VG5IM2Z0aEFrZFJT?=
 =?utf-8?B?aVBENTl5bk5leEhvQXZxM1NFRDlSTW1JUUxhZXVuTlA2Z2x5bXZIbVdXYUFz?=
 =?utf-8?B?U3NwSkloMEFXcktUZThMamxDQTBLV3d2bTh4QWp2Y1Y4TXlLSHU1Z0o5L09Z?=
 =?utf-8?B?dEx3YWNDQ2dOOFNCTnNXc3JEMmdsVm5lOFZWUFRXR05VZUF4VVcwSkQxUFQz?=
 =?utf-8?B?UVBjWHV3NGFKRFFrTk9qdzl6UWFsVzVWdUdoZWN1cFFUR0RFTEZGYWlYcHl2?=
 =?utf-8?B?VmpOam4reGNFOURHcTJneFU2ZUkyait1ZjVyVGt6M08rM3h4YzJhTUN3Wmc5?=
 =?utf-8?B?ZFByVGJUSHZ5N1lpMFVQQXhNY21hNFc4ZkVER3h4V3Z6d0VWY2lNcVpGMkVp?=
 =?utf-8?B?MU5pTFE2bEZodW1nN0JSanZaUmY0a1ZUZ1JralZ2K3VGMWZ6bklVb0NrVDZi?=
 =?utf-8?B?b2EwRDNPTkVmYjFXYmRYc1VBU2lTcGxJV25pL05HS1drQkhoOUZ0UXVKNk1m?=
 =?utf-8?B?M3dnbnpOMWdrR3lST2hVbFlRNUtHbjhNU09GVUIzUENIYTdyUng0Wmx6YS9a?=
 =?utf-8?Q?VrVskM+F1w4DqTwo+iRxWgWgyqz7gi6Pp2pnToC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ebacd1-8b02-44c9-eecf-08d8f32fa479
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:22.4388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RUaA6JBjUzp1jxcXM9vjmq0HVao72WxipWBZm0Sse0NQAraoiNSGgQZjFxfmUTi9yeKEpGjNazQ6CRbkd27bhCKDzCrg8IqQyjoSzPKHWM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300023
X-Proofpoint-GUID: VrmgAiZapO9aKT-2w6Fmq07JVc9QS3ck
X-Proofpoint-ORIG-GUID: VrmgAiZapO9aKT-2w6Fmq07JVc9QS3ck
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 11 Mar 2021 12:02:10 +0800, Yue Hu wrote:

> The status paramster's type should be enum ufs_notify_change_status.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: ufs: Correct status type in ufshcd_vops_pwr_change_notify()
      https://git.kernel.org/mkp/scsi/c/7a0c0e6ce130

-- 
Martin K. Petersen	Oracle Linux Engineering
