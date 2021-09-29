Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ECC9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F1856135D
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244070AbhI2EVa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 00:21:30 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:21732 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243971AbhI2EVQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 00:21:16 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T2ECIv013625;
        Wed, 29 Sep 2021 04:19:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=GvNDwleLTU4b/Uv8ES9fFtK8tN7fNOuQ6oNh9hdclmQ=;
 b=Ys7qIwwiweS7tgdK9ppIpJc2nGZUsWQn5d1ouev/k+IGw7MOAJ3J2mgYLh6mUj7P9LCo
 wIDRQCOVEQkrmLxlyLW0C1ndLe5Tje6P7Waml409F8Zsx55wJNmaqowrkIwHg5dnyKBA
 YvSyZWix4gy+3YM/oOSS4hyOPiu0K9H/cjGpgea6sMaWy8UU5qo6Ow34Z+ijHDrrAoIu
 sxHaNXtgEmUVHa7C1wX2EumLZtE9CPQqjy1EvvVKt1ph15KCmUBfhSMJvQm9Z+Kl7cbU
 mnPr288TpfBSQuNzEFnu941/F2szVWoxgnT4x6Ro3Q7/EVENR3TFKEcPxBP3PdBhaRdE /w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcf6crd3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:19:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T4AUvn030971;
        Wed, 29 Sep 2021 04:19:33 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 3bc3bjb6tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:19:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wi4vk9Pk/0tNgVTkbTuvTlhqWoUcRdUcEfkTDv0zAmgYA6rP+vgsBG25IYmswEpTmg0btclMZuWRLuvNelzp+ORZjRnD73zKo/YF1CE80n2+fMJq2UqaB1RiW3BtjiUyByMuYyK0OX9ziuSgfaodIFZQM4A9cQ++tMdEPTOhEzH4P6KfGf2IY3ZhiLXZQEoCBsPEwQ5VJeUdJqHgSAkIjdYDqGNyTaUJ195pEH13cUKa3QOxTXr8W0HXx15jUtECw9QreeQjRufd/RUgucvg8uOK85ZljxDKtUF6RircyZnTR/NwO3AykH8mBXYAO+pAzXYvap7SKwlcObMKThTZeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GvNDwleLTU4b/Uv8ES9fFtK8tN7fNOuQ6oNh9hdclmQ=;
 b=Kx+W06U2QH/H6jZQAcERTl2XYffW1u+E5zEP7OMKfmaRwG5iVZqFwM7MSCmxsttRr3u1FSNtWsgJmTGbevN5Nop2FTw+VPIgzv8PrEzGh61LRvCqKdSnVmkquIVakfaRC3+RVXr5+ZrJOOrwVKQqzJlIoqG7WIzjYW5/S93N0BkwnUnpfuVv2nnXewtKxa6LnAbQfulQxMoQT+iKPUdQxAx5vQ1GUuhs0110HzMfuAKkx/OnNSrXEYmgIoTVSE4ox67kUzpqaw9PIvzrc1KPZeP6YVQBAAaFDoGnPeSCYNwUye+gwZp1Q1WR6avtGfOANRc+VCAOoaA2DT0a87rxkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvNDwleLTU4b/Uv8ES9fFtK8tN7fNOuQ6oNh9hdclmQ=;
 b=JUE0jzjlp8/G9iPMdFgCJPwmhFOQjsV8l6pBhJgn/qdDljqh+cxM2oemqGAri/ckldKbe4kIqWVcv93HtT7XIvC1xU42UU0b8mYd1wXwkTwzUmWPUGH65aV3eFnN8NxXTc6sFpcbDhlm16sdh/jFgTFupEm+rtrrDKSxXBDxzog=
Authentication-Results: chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 04:19:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 04:19:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        varun@chelsio.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: csiostor: add module softdep on cxgb4
Date:   Wed, 29 Sep 2021 00:19:21 -0400
Message-Id: <163288913991.10199.10380850948332750484.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1632759248-15382-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1632759248-15382-1-git-send-email-rahul.lakkireddy@chelsio.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Wed, 29 Sep 2021 04:19:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d40db2c-9f3a-4949-17ab-08d9830055ed
X-MS-TrafficTypeDiagnostic: PH0PR10MB4551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45517BF03F5793DCCFBAABB68EA99@PH0PR10MB4551.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EeRDOwkugq6Gif7PNQr1kwMjTRG1LIMFCz020tdnRsdH2F+steSL+Bc51VlVueU/VM6Lx8xyxES4/6vMO0BZZPN43EFUCRGDf3Anx8DpySWdxxUjPnTB4o6lKK62r2Q4bAjMU226T3aeZI00ZBDfhdKOefKyvTmzZADQbf8eU9zJep0pxVTFuOufGmMg7wqtCD5aE9QYCITT/A/pGOe9wigAJZAJ3JRHD/uUYcOZjbW4oy0WugqxgMspzFFaTleuAtNlRswC68NWKIdmxaVLi8kW4S2+bOvqNeqvvdm/BXf45OB5JCTuad/2xoxBAXUVTfmQIA5J5IoWg/8DWiVB1IlS7ZxXpHz85bBj2HyqQH+wY/T6uczrtSHRYTGlqXNS5cfWh7cBcSzOmO/qbBxmt9QuoXTpbjbGSAXcLRMPWrKOzf2SaZZk8Pvif/V/DzVQRGlXPRKZpuTvJW5TyJ+vz7Tgxk4U2XmitOip9WnoYaEzGPfJtHaAx+pdKox+5nIxWYCn8WqZozD0S4SoE6BqOVQQyGAF/1bSfkx9XNC1wcPmYfMWtFdGPbTkihspYuFbnLBH8NddtU0Si9dbrNRokiuMi9kNLou+ja827JJadJzebPrXhVmKZ40LgQAcIIRDd+AmNfHGcgLt5WjGMM+VxjK/jsZEbZuRl90JN/f8/6yMghc9AGy3qhlVZiEn8c3YSyS+Tj1CbipdhYrG7/Z3ao1ZO+fxLUGY32GBh5Ztpsb4rc304YQYKb3zQhm+qhvoaK7BPOVLvf/lSTSI2o+T9GSugELqXwEPgm7d9y/BNkk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(4744005)(966005)(6486002)(36756003)(103116003)(956004)(316002)(5660300002)(8936002)(38350700002)(38100700002)(6916009)(2906002)(26005)(508600001)(66556008)(66476007)(83380400001)(186003)(66946007)(8676002)(4326008)(7696005)(2616005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2RobUZNbFJ2TlQwTHV0QUgzcUZWdS9DRVBzQkVERTlFOFlRM3BhNU5qalZV?=
 =?utf-8?B?c3FCTnAyUzhOaG5qS1VSc0JOWXkydkY1SjI1cVJZVEdiaGpvTFg0ZjgwWVBh?=
 =?utf-8?B?OVI2SUsxc0N6M2drUWh4cWphaC9OQkFtT2tHL3JOcnVsWG9JZ3RwTHpzeS9L?=
 =?utf-8?B?QkRVZmxCWUdHUzFFQTlIVW54SjJUSDcyMzZCMHZsS2Q5QUxkTFVLQStwb2Jo?=
 =?utf-8?B?SE9wOGVZcDJoNm1rMDFESS9LaUNaSTl1ZXQ3OUhONGgvUys3bzd1WWQ2OTNI?=
 =?utf-8?B?R2VEQUpRTlVPTmFVK0phMXVQWk5QSmhEWFpZYXNMZXhtem9vd2JTZmRmMGJq?=
 =?utf-8?B?S2JHR2FLaFZydVBhdVF5V1VxSXJoYkRFV0hJN2FQT05xVGcrbklONjUyeFV1?=
 =?utf-8?B?QW5mY1E4QmQ1MTFGOENXM01OU1ZlSXZycjV5UDBHODZFNjFtSmU3dzNXZ0lV?=
 =?utf-8?B?RGlOVXBveEZONjQvelBDUUw3ZVZsd1ZvdGlsZk82YVJySkwvSVF4WFdySmRl?=
 =?utf-8?B?L0xyeWZnbHphRFZ3OFpoTnlLclhzVi93NVRQV3c3QTlraVUrM0lXckR2ODYw?=
 =?utf-8?B?Nmx4TDYxbGtCSUwyanFiSVQ3dGwveDQvUVVCR2RnMWlxYm5odWJHSVIzQkdl?=
 =?utf-8?B?dTBtNmlBeUtzcmFrdXlxWmpTdTVwUU9hQ2FxejdZRnR2emdhSUtDbWxHalk4?=
 =?utf-8?B?V1Jha3RRRDRBU1BiVVdaM1grdW5kZ2d2NFZFa2lqeXJ5OXFwZmQ1cWxMaGJJ?=
 =?utf-8?B?czZzaEJXVStKSEkwbnlJdzV1NWVWRk5zUVBId0t2MjZpWm50bVNuVjB5YnZz?=
 =?utf-8?B?SnJBVkUyZFNxTTdRWDFIS1VZQ0pKUW90a1JnOVE5QXhFaTd0eXd4dkwyOWtZ?=
 =?utf-8?B?UER0QU9kdDdMazl0R2RNdXZGOURHVkNLNVNtemloRGdJUkRDcFZWVXBmR3BX?=
 =?utf-8?B?V05LWENnTkFRMnlVZ2Y3bmgxOEI3eHg2WUtVMWJCUTlYSEhiSndhTlBQMVVV?=
 =?utf-8?B?cG9nNnA3SUlFUjBiZDhFbG1OdnFGcHN4cVgvQk9ZaU83UlVKWWkwb2JvbXJU?=
 =?utf-8?B?Y0hERWZEQjZjT3p4NHoxZXlJTTltK0UxU2o1R29jQlQ0MWFIS2QrMXYzaUUx?=
 =?utf-8?B?T05xeUtuZ3lpb1FMeE5CVmwvb0FhV0pvc3diV0grZklsOEdqS1BzeDZ5NjJ6?=
 =?utf-8?B?aG1tSWRsOHJiam85TzcrQ3JJM3ZHL0lXcGlFaThkS2VmNG1qNVNPbXhVeGNx?=
 =?utf-8?B?azNGMVlGUDR6MUVrVTVqdUtjekRWdEdiVTdPQ0N4YlhGTDRUVVordWIzUGg3?=
 =?utf-8?B?L2llT2xyQmpYckVENENhVldSTmNXNEtLQ1NURWtIM1lmZWhTMENwWjh4clJZ?=
 =?utf-8?B?N2haQjFReXlqeUUyYUpMeXhUV3BjOUpXZ0tyaXZqdjA3WVF1VWVvSkM1WHNH?=
 =?utf-8?B?aDNheVhYMzJPR3pObDFJckU4QlRWc2E1WjBuSk5kcDBSYUlKNHl1QnV6TlNn?=
 =?utf-8?B?U3gyczlpVk1ZNE9LTXZocWlNWEg1UjlzWVNEU2JNQXlNOFhKanhZcGloQ3VW?=
 =?utf-8?B?ZkozY2p0MVJWNjRJc0ZGUFZJdE1yN05YZmp0bHdWTjltOHpjT1Vpcyt0VXMw?=
 =?utf-8?B?dHlWdVU0Q3NzUGVWalhmUk9JZktiSDFDdERrdmo4UDR0dFJ3ZEgwak5PRTFD?=
 =?utf-8?B?K3dLRUlmK0hUVUczcTNEejVTcXUyS3VlMFRpeGVPTmJYNy9naGppRjJmZDNp?=
 =?utf-8?Q?buUEJ7nKAQjTYSj5Cu4MtCNCv81TjMajj11XxMX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d40db2c-9f3a-4949-17ab-08d9830055ed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 04:19:31.6278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XqNtxOPQfyZ8yYmUUM7ctHj8ZevpF21fzsYSWUuC1kEC1mHVG8pu968IfWwadw2YM76YfYl0eBHEZ55uey1i4t5G6tptbNwxlr00GSaQNUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=674 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290025
X-Proofpoint-GUID: L1PdMi8fIcvoRPEVOGUH9ucRKgbc_iHL
X-Proofpoint-ORIG-GUID: L1PdMi8fIcvoRPEVOGUH9ucRKgbc_iHL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 27 Sep 2021 21:44:08 +0530, Rahul Lakkireddy wrote:

> Both cxgb4 and csiostor drivers run on their own independent Physical
> Function. But, when cxgb4 and csiostor are both being loaded in
> parallel via modprobe, there is a race when firmware upgrade is
> attempted by both the drivers.
> 
> When the cxgb4 driver initiates the firmware upgrade, it halts the
> firmware and the chip until upgrade is complete. When the csiostor
> driver is coming up in parallel, the firmware mailbox communication
> fails with timeouts and the csiostor driver probe fails.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: csiostor: add module softdep on cxgb4
      https://git.kernel.org/mkp/scsi/c/79a7482249a7

-- 
Martin K. Petersen	Oracle Linux Engineering
