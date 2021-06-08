Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29120C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F8FE61278
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhFHDHc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 23:07:32 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40934 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhFHDHb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 23:07:31 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15835MCf085523;
        Tue, 8 Jun 2021 03:05:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=nCVayOuz4+qSFAdEf2gTHfnkMaBUPEePKuzOgjc1Shk=;
 b=r7phKtMeIhn6aIHgy8qkXPwiIU7wt6ajYDtKG9qEHfABP+03Z4xL0evjs19fEZlfDGL/
 ovrYSWcATI/VY0JzX45RQUWMllMatHFp7wBgM5PgwZixGSUFR0fzOdcmTWAFM4D40wgU
 2uVckrDJVsr6U5ynOkbCLR8KjRdTlzKv+0HyBzU47lH1pcVAIMUOmXhnFn0tXref5Qs9
 d3xVUG649pgHbUhnVzqkrOqOcND3tusweunbBZwMKHmPv7TiymXMNzPa4ukm9rx0LwhA
 5cTltYnqwUPv6BPaz6PYlvMRa60RZvmd8GPuDeh5uNB0E6vQBQaxQMN90CN1cQwlvq1D sA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38yxsccn8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15834pCT084953;
        Tue, 8 Jun 2021 03:05:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3030.oracle.com with ESMTP id 38yyaahxw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bs49Ux+wrR9JV1xJE3Gf2g8taFshIpyIKnuRA44uD6LSfFtGTg5B7Ang6Bc80JNWHahwDw8WI599r3zke2gEGkD6RJ8LVwHhvNUCv1icdaDjGl0VszSU9bi98RIBRxwK/vtaBKRw9Xu8xHT4p/ZTyLcLoTtsHvpMRBEZ+3vnteMkmMBJe1Z1pq9AXd4B1EHRbim4pg6OZLLj/Dty4albvnVKu4Kl3tOxkz1ROVzl7DwCe2Gfo1coJ+Qijig3zxNfMA9zmWjOD3pxK6qWQz5qRdRJDd1WnwrDOftkTbFfpcSt8GbAwQBbvDQdEVQy1xJT4qpu4o/o/On3xSfjZgBodw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCVayOuz4+qSFAdEf2gTHfnkMaBUPEePKuzOgjc1Shk=;
 b=aSWHeInaS1ShttvmA/xAHap1gW6SHritoJoSV3b3kooJPZjsNGmTe7IS1j1yeWPgfY8U5JaPuk1zmoSpX759L11bCuqCtwAPw3TVVCCkv9FAFB9kBHXlGZymn5P/rs1OdaKPY6ZSQhAGrzUx/BgFIsP/ygdmrFhPLxhjEH4CY07C49pWsUs/Iby7tfiT11dnQRUZaL1d8rFhV/S1yFuMmKwARk5OHT8TlSg4g9hTb2jC9d7uHNmMueW7oj1QZbFUQbmy5rLXDuxo5iwwbUwWJhQv5qcN9gu6ExKTMyJ3Qb8vBvXkFHxyeiY1pRrkAprAnbYg/pWPssXFRw5b09iXoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCVayOuz4+qSFAdEf2gTHfnkMaBUPEePKuzOgjc1Shk=;
 b=PGdCr3QKUp+WeVZmMcxFrF/Ikqz4kq7k5evCLEDIsQV0r/YthkXHuv1i2ZG71BzXHlTJmyuLCEuk//qXlc0HgaXINGHcBnp8pjfvKYtTFwSoDtBinIuAM6yyhh2X4e2vxD48DgUxTVIRzonvWKXg91gnn/8hxsVj9ikbG1/whKY=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:05:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:05:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, stanley.chu@mediatek.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        Alice <alice.chao@mediatek.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jiajie.hao@mediatek.com, peter.wang@mediatek.com,
        wsd_upstream@mediatek.com, cc.chou@mediatek.com,
        chaotian.jing@mediatek.com, chun-hung.wu@mediatek.com,
        powen.kao@mediatek.com, jonathan.hsu@mediatek.com
Subject: Re: [PATCH v2 0/2] scsi: ufs-mediatek: Disable HCI before HW reset
Date:   Mon,  7 Jun 2021 23:05:18 -0400
Message-Id: <162312149256.23851.11477766299673059113.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528033624.12170-1-alice.chao@mediatek.com>
References: <20210528033624.12170-1-alice.chao@mediatek.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 03:05:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5462ef6-97a2-4b52-05d7-08d92a2a4588
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44700636C7610049BDCA00818E379@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jA3Hc5+adsmjS9yHeZyXZXF7A/fv1pRM/ZAhgge6HuuAv+PVN9DdCNshvTqBipcsiWezAmxz64bvsOM8Kzj9ZAJVyDGRTOHXSFWAMDgxr201yAqtKCVrc+S+jWTwjvh1OB8DKwdbSgwVKlUzKenQWkGc3rsBWLdEGytCGK89bWjcHvpm8zZSdXRMkLjRtOBt9ErK6aVLF6iWInO59OyqSMQduwRElgL0uI6fjQ4ruBWrb9OXT8sfA4DR3KReS6PResquYpcQd3LTw37LOgQRHtj8NRGiEvXOczS+1MIdp4y0Z/JkKRqPc7yhsmEYSxnLJyc4OerPnU/Kurs3ka6SaCoDYj1KwNhmH0Kw1+hCVEnzbshkCd3R3gsWFad5B0DbGLlxiHmg9rXXNjAkBftMRcpqeveg72u14TVGu/LlmZ46GPoBwlHgUtaMpHSCF7kxPTlrIJcbVTvRoyWe8FHUMND4I3bLk1RyDQfYfjava1jqX5w1nk8wHLNgo46Yg7uROhE6xCnCXrJPD2K7nkcrWXyioqrwJBBt0C0kHY9M8k2AeLuSyXl211pq6XOo/ltKXp3xavw9JXT/LhrLhJ8eqXM87KAsUG/0C2USiiIl1fNpndhANTHxQoyCQGQiDOdTwvc8igaHNwSEtrE27wqI8N/yNdtWB84W2vvpsIu0ZBKaEPNmDU7+V3bFXyvNYbji73BOVVBPmAFy9kgS8MSFqMAFpsk0aibK/9oMXAd+lNhkUTTdxoy/jbm9RNg7aOwBlqWsrefDh275Ri/oYYNpEWq6u33Nw18sCzzihUan/SWfRN06AFlW852mnAAQFyVY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(396003)(376002)(103116003)(83380400001)(966005)(478600001)(52116002)(7696005)(8936002)(38350700002)(36756003)(8676002)(316002)(4744005)(2906002)(26005)(6486002)(5660300002)(956004)(2616005)(66556008)(66476007)(6666004)(7416002)(4326008)(66946007)(16526019)(186003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QytmRXZmT21VamM2ZW1EQkpnV2lYT0RJV0VCcStmeFZ6RE0rU2NCTEprQTFk?=
 =?utf-8?B?a2dJUFN3cGt6S3plTk5pK1JmUUp0cy9XK0xEQ2NQaGNjemlWM1BWQ29qWlR0?=
 =?utf-8?B?SzQ1Mm4zZXFSc0hvdUljYUU4VkVZeXdxVm5YblJ1a3NxWFJNOE93eFNpNTRI?=
 =?utf-8?B?NVpiREI0Q0Z4VU9jWXArM0JRRWJpdFJ4ZHZmeUV4N05UNmRnNC9vQ0pJb1lO?=
 =?utf-8?B?N21LOTVibFdjVWlyeWl0QTRZRnZDSkVZejVtS1VqWlBPOWhuNHRCdmhxcUo1?=
 =?utf-8?B?NFk3RHdjU0FYRk8zTWo2aFFGTmFvREp2STRuNkRsV0R3SDdmK0NIMmlPM0kw?=
 =?utf-8?B?RGFSYWcrNnVBbE1MYUFuZlcxcHpRbjlhR00vaHllWTNIZUZPcDNjMUxWaHV6?=
 =?utf-8?B?QVNCRVRDK05ZOGZMaHVoVGJhNDFUZzVGeHgzT0p4cjZLMGtoWnd4TmFwTGtM?=
 =?utf-8?B?OFdTY2dSSllaR203aXg0UTJVRzBuR2Y3TkNyay9CVU1RaGJTeDdCdDI5U3Zz?=
 =?utf-8?B?dFFMaXNMNjdYMG55ZEErS1ZGVUpBNVRibWlkT0lNTlBhdytTQjloMHNFV0hL?=
 =?utf-8?B?TGo2S2d6MkVhbWcwMDl2OEZlcGJzWVFRRUJ5RGdxaFd2dnU0YTkvUnRrZjU5?=
 =?utf-8?B?VHZvRlRlcmlaWDNVdzZHeWtrMmhWTkh4ekZXbDFHOURTR25kcEgzSUlzWWRG?=
 =?utf-8?B?bkEyTjJ2VjdVamY3b1FCeE5SYThRbDFBdWpqZlBmMEdBTjd5Z09mbVc2MWdq?=
 =?utf-8?B?NWozQUFoV2YrcmlXMVdKUjhWMmNsRkU0R0t6aVBOc1diczJTZWZVeHNZc2Jl?=
 =?utf-8?B?MDVVUDU3eGhmMkt6cnVJYThNMkJxbXBpWlBLSldwVnRVZ2Q5dGIwakw3Y1Ar?=
 =?utf-8?B?ODR4dGVLMU5OSVc4ODRVMnpCdzdvWWM5NFZDVklyMjJwYmxGMDFEL1dteDFH?=
 =?utf-8?B?TkxMUW9ha0RxQXY2Smd3b1dUVHhzVGVPM3hYM0QrWS9CT1k5ZTZFUDFneUpZ?=
 =?utf-8?B?T3BwRXhmWTRJUTBhTkxJeVhoVyt3Tnk5OStobXlrZlhwckM4M0RPVVNvWGc1?=
 =?utf-8?B?UE4zZXQ3cUtjVHZXaWcvN0pMWVhmaVJoRG1Ta0k1d2kyRkhIYjEzYjNOU1JM?=
 =?utf-8?B?dUJtT2tkK25CbkRabFJVR1c3OVdzZVgrMUpYY1dsQnJPbldEWkN1eUhieHRK?=
 =?utf-8?B?TFJlNUVRc1RGMHpiOFdDUFcxeitTSHNnYUVoMUZJWUJVeHA1TVE2dm1td1VN?=
 =?utf-8?B?MjVnT0FMK0Y1aEhtL3pvcC9FcHpJUUYyTi9xSjNGNjBBODhtQW9WMlZXemlF?=
 =?utf-8?B?VXAyRDRSZ3Z5REV1MXdFZlU1RTVmOCtET2I0TFRKMUJaVXVMbGpRcXFhNjZP?=
 =?utf-8?B?OXoyQy96dFEvUEhMUjRabDIweXRIcU4yWkhKdUZZZWZ4a1U3VVhWU2dIaUNy?=
 =?utf-8?B?bjJiUGtTcEFiR20zUm5GdGRadk5TcHNoaHBTR2Q0dVNCZ1V4cnFYeStKSDdq?=
 =?utf-8?B?UHJ5d0Y2anBNS1pkS0cxZmhNMnNUWFRGUnFTcmord21wMVRCYWRkUFhlbGFG?=
 =?utf-8?B?MkpTbkQyNjVQaFE3Q1FzaC9sQVJJZWJNeDN3NmNWWlRwNGFPZTdqaWtibDFh?=
 =?utf-8?B?d3dVNy83QzZVT3poMTVtVU8wdVU5bnZMTWt6QzlSVTYrYXI5Y0ZyUGxYWnBF?=
 =?utf-8?B?NS9UVUxsS05FSnd0SGRaeThEMmZoWWtqQXFJQnlUUWM3WFM2Zk9iUmhnT3Rk?=
 =?utf-8?Q?GKspfsU2AVWHIBVmWwLHNObDTySo0EAO4ZUvUuT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5462ef6-97a2-4b52-05d7-08d92a2a4588
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:05:29.5222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gpXBvxbBDgUWV8FwH7R/ozxh7biubjoIquzqaDgzjfwKdj+/CVDPDVm58/gUiGRbB4XK+bZjZg/bZRAQk/rNsiQUgI0Dn8/ai5/t08KasFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=913 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080019
X-Proofpoint-ORIG-GUID: c5Ken1mUI4nTLWX8c_eN66puekjik1CP
X-Proofpoint-GUID: c5Ken1mUI4nTLWX8c_eN66puekjik1CP
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 28 May 2021 11:36:20 +0800, Alice wrote:

> This series changes the hw reset timing to avoid potential issues in MediaTek platform.
> 
> Change since v1:
> - Fix the commit message of patch 2
> 
> Alice.Chao (2):
>   scsi: ufs: Export ufshcd_hba_stop
>   scsi: ufs-mediatek: Disable HCI before HW reset
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/2] scsi: ufs: Export ufshcd_hba_stop
      https://git.kernel.org/mkp/scsi/c/3a95f5b39254
[2/2] scsi: ufs-mediatek: Disable HCI before HW reset
      https://git.kernel.org/mkp/scsi/c/f9c602f3bd9c

-- 
Martin K. Petersen	Oracle Linux Engineering
