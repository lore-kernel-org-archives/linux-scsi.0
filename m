Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE70C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A7426117A
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238321AbhDPCwT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38948 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237979AbhDPCwN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2o2OB047446;
        Fri, 16 Apr 2021 02:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1sm2JslaCYT3HZG56NoG0lPZIPbeJQ5JbvB4H2BTZOc=;
 b=HjXhLF7As0LyK8iS5ihvbuKc6oqAunQO+ip2wXkEPJXmC2ZTRza/N9+XNACcYEUnQ6Qo
 fTu9AVLsFC/izmmv1dE3H+1BHqOhq20eIEP2aNJpf7vSmo0tXcYNAcwXO/UqU9fu+WeB
 YWRkOGWqUXj5/8zzN2N4sCqSzJwHopvdwGNKeLOKeGpAsqB707ou1nAKTZPHOZSCP3j4
 Lx2huUDAh0pBlC8aS1P3i6aJ/RYIWYpcQlou2Bn0RjCITvqKMdzeCsRAIj4Uu9mvo5I3
 8LV65bDad6uWNdab7sfrJsCFZitC1iilVLZ66BN5x/jkAh2Ti28ynTrKQbZ7r4p6CNvr 4w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37u3ymqpm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2oeFm162577;
        Fri, 16 Apr 2021 02:51:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 37unktgk4m-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AcWSnwtzPUN4B0c25pdjiPWCLbp2cTA8SaieVchbpgSCQ1b8AXvsyI2bR4dEB49pzug+G+JsSO+x6w5QrBRtVAaXOsADTHUbkQm4BBXknAOSfefwL2lWTvCcYlvKPf4Y5r9gv6UIml33ifypH5V3ZBCs6Pec+KINjDqzBAKuZpwNRVgIEAl/RFeKwfhU5EmaZCTCgV12vfk1aOEj5vIO8ybK75+BXNZS1zB/eOLVSLONQISfUrW8Xf2GLyPeziNdoOb8fFkkexIwnKTwFaWJW4e7/DKpFgR7xQkzQFCtWB0VF8lsgJrvhq8Rw2tjylnyd1O02CCzeH06HRED1LZ3gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sm2JslaCYT3HZG56NoG0lPZIPbeJQ5JbvB4H2BTZOc=;
 b=MbJVg0RI6dG2maDVwVTmeELFsPo2AEKacv6BQ87fP0QZglejfsu8iuHBDBS78uS5oirIbjYUNcGRCZfX0BzcSSt0A1ptWvWbnWy5KadHdAl+MzuXWb3r88WUOJALq/E5Pr5IJdVImmN8ckMs7LqaRfRd5JnEsP5aJA1aJH2NNt6VWTN9HWhkMtCZfxaYpxy8rjYshx7DgChSjXDoWZx5NkY75v1Udel/sDhZ4zci4O5CR1sQj8r4aUP+twr7CMcJLYq+BfUlR4Lxws49oiI3OdGuviiU2RK6orfOPCt136it8tLB4DCGR1qMEZY6+ZqQ7akM3ubaroLW4g1VPRGBYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sm2JslaCYT3HZG56NoG0lPZIPbeJQ5JbvB4H2BTZOc=;
 b=RA9Z9c3WjEG1Y+vqxW1bHHGqcYQLu+vIlPYFdYn/QPnBVm7x/McVpRkyY8RrTbUUpKTbHB9IWq/J1+zqsnc+0FYTF/BNLcvmhc3LcC6AkwLwqPrjME4IZ90twR9NlvrJ5N3uhM27wv2gLwsttEBNtdRkHbCqIfZWXcnFiGtY3ps=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Qiheng Lin <linqiheng@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, njavali@marvell.com,
        mrangankar@marvell.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH -next] scsi: qla4xxx: remove unneeded if-null-free check
Date:   Thu, 15 Apr 2021 22:51:15 -0400
Message-Id: <161853823945.16006.7771182124397291131.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409120345.6447-1-linqiheng@huawei.com>
References: <20210409120345.6447-1-linqiheng@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ffb4cb1-4388-402c-6726-08d900828db4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568E367017E42DE19AEDCB58E4C9@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7VHSxmg644Em23Y7Yjlp+tJfup52/kkpf42BsmSxmXETNB0CO+6EVLBGOZtvPeHzb7gzYGte49wQOAfE0t/Mvgm7BQeEzM5Q+DTWynREA31aTzF5k9oLHshXmai8CW6Fjq5BOaXQPotgIbvAeXjj+tSBRtlrEsbAVQCSSwpEes3N8/G0GnZ9ujvR/ZNaI7/tw63bBGMIJ+y9KIqvvYT4p8Wm5ac5J1PWEw90t/hQkJY8AoAFLDOzLvN835juHYf54BnD71INXQ8dmPWbGSFIipUuYFHUsWb3XYpvWDjCboZY73BaIirBtl8BzxVWIqxsAa7r1E1dIf2tFJ49a7ZLmlUclbYNZauR2PUcO8X3B875DBi15VDbA7iENPZyiSlccKrYwQzVO9HTixs9YpJkf6HajFbrlR3vFVDn8eWCnhjr4i+qQ+XWdshU2sPgaQZvSXYn8BLZbCCoeP5VSuJxewttiCp0hAq91ATcpFTgAJ9ILydZiJo0fFw67Oh0yPE9hvApRltkrNmQT+J3gCM0EmARzZsDNwTsfSW8uFLin2A++p+Rezw0E4yv/t5ZZzLNuBozF17Ucc1oNcL/X6VkwCUzphcfrXV0EUZ4Z7RIo1v6r/k+HUDSwDSVaJ5bAv5MWRu4xG7BvNHuv1YJjjIgBWAq1bUvd1cnyUfJ2RyAAUShgFQOCEOmxXws/DxeIrtujiSOIeVCM98vvvJsetRBXd66CMh+i4vyK5XM8/5qbR6j6T+rrNGxdPjlQJwg7O2M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(346002)(136003)(316002)(103116003)(6486002)(5660300002)(478600001)(26005)(2616005)(956004)(8936002)(83380400001)(16526019)(66946007)(66556008)(66476007)(86362001)(6916009)(4326008)(8676002)(186003)(38100700002)(38350700002)(2906002)(36756003)(966005)(7696005)(6666004)(52116002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c1M1Sk92S3dkYnJVQ0pHeGhTNGVBbDZnbm5qbFNLRlIvOU90Syt3a0V6RVlh?=
 =?utf-8?B?c3Jpc2pQM09WVzNQMjY3K1BOY2x5NHB3cUtadlFaSUFDVmJDdkIxNXBwL3Fa?=
 =?utf-8?B?a1R3RHlSQXk3UXhuUXBwQjJON01Dc1pDcDgweTBrbVVWMkw2R3htUllHZjdY?=
 =?utf-8?B?dFp0bFNBVklMelQ3eHF3OHVrWVgzUm5LNTNRdkFNVHpVdnhnYXcvcHhLWlFS?=
 =?utf-8?B?OExWZVBORURocmFWYzF4K0dQZjVBb2xMcUp2S0JTQmtUT3JyckhWajl4UmFo?=
 =?utf-8?B?MVJGSGJoUVk3ZWM4K012MC9XaDF2TUsvUExieWkxTnRMSWFIREduN21DRVNo?=
 =?utf-8?B?WUJpeGdGY3pobFdvN3ZKeHNGVzhRaEVqS1FNYS9tTFFXaG1SaFdYVWZza2F3?=
 =?utf-8?B?WE8zV0dNWjBEeGJrVjltVjlzbTc5WCtyMzd2MGkzOTNFaUpVTzYxWXRWVHFo?=
 =?utf-8?B?Qlc4eFVnV3A1WGQxVHlrOGpJRkUzMGtjQytPQUQ2bm56b3RDMUsxVnhDR0ZC?=
 =?utf-8?B?VEZ1RUpWc0NYZTc5RGtiRGxWRDVqZGNieExUTytGdXJHT2xmTFREVXpra2p3?=
 =?utf-8?B?ajdNTVE3cXp2emVoT0hZWm9aZU1lVjk2V0p5NmVnUkxBMlNFSlBpeVdqdjRU?=
 =?utf-8?B?YUN3UGRyNmptd0RDMDA3bzN2emVhTTl2TUJFSkJaMWNqRnc5WG1ibGI4Z1hz?=
 =?utf-8?B?Y01uQU45b09WTnlobnltVUZHc3Q1eGpYWDlnVE1XNk4vd29pb0dBYitOTUI1?=
 =?utf-8?B?dmw4N1ZVenJGQ1JoU2ZoNWxJUkpuNU85emUvZUl3VWs5RXlEK1JiTWdDNW4w?=
 =?utf-8?B?ZFhXYzNZbnE0TFpqcWNOd3FNTStTUEF3MkU5WTA4OTFOQ3dPTXVYSDAvKzBu?=
 =?utf-8?B?b0JnNnVXWVJQMld2TitPNTZlcG11UHFab204ZFJubWFUdUJJUUhMODhKTFoy?=
 =?utf-8?B?bTJnOG1wMjRtaGJiaE9UVytyb0NqclFqN3ovZlpqN1hwYWt4QXF3STNqMktu?=
 =?utf-8?B?VDk5bXA4SkFSZXJ1T1l4UEJVYWlWdzN6Y0JyWmQrOGNvdWF5a25HOFBSbTFl?=
 =?utf-8?B?eUFQWWtkREsrRzZqaVZHTFQ2SlZGMW1CelVZemRuYzdKNVhVWnZ0OGZ3ek1U?=
 =?utf-8?B?dGtHOWJINk82ckI4TWxNaDkzOEpuczJPSGcxeXVpZi9oWm1tZzMvcWlFTzYw?=
 =?utf-8?B?M2orMG90ajVoWWUvL29lVWg5ZU5ib2tGMHg1QzZ2REg1Ym1UblZpTmVuTXBo?=
 =?utf-8?B?eTYxUlhBMkp1NFpscnhqSG5GSXJXY2NrV2hvc1RrVFpVWjQ4clR3QVpDRXVD?=
 =?utf-8?B?NkRxamRLcDhXYUU2VDBMdGxEaGJ3L3RUQW4yWlRHbXNwb0RKWFVubkJjOW14?=
 =?utf-8?B?ZkpmUFgreWNRQnR3MXBtS2Vka0tqSTgxK0RjL2czT3l0bFpzK0ZYWGVoTUNz?=
 =?utf-8?B?UW1CcHkyMDB1UUhqSEFWczRlVnFjOFpOKzE1U2J0eUdqMWo0QkNITDBPRFBH?=
 =?utf-8?B?VFd3UVBMRnA2YlBEc0gvNHNDZVUzTjlMOGgzZGs2YlNvbzM3Z3NrdjNLREJK?=
 =?utf-8?B?RG5kTFIwems5NngwbmVxeWZHaUJqN2VmaWRJTDZtYzd2Rm1BRHRiSVJUWlNq?=
 =?utf-8?B?R2F6cStPRWkwSUErWHY5RHhuNXJJTEMvaXVIaHZLQkZKdzRrMVI3dE01QlNz?=
 =?utf-8?B?THVLb3VVM0xxdTlGRjcyWVNKcmNYOHFQTG0yTXlYM1RVUVl0NVZPaVkvMURL?=
 =?utf-8?Q?r8aE8zOSy5K7dQtdddv6qgaRjoXA742BXfbQY06?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ffb4cb1-4388-402c-6726-08d900828db4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:37.4427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UDIzVWTgk23vnmdNcSfoVFuNbU0ciNEJ8gbhQ5LpDcgzWE65b9JwsMQGKLuG3zLeRMTPztkfS6fld4898y/vAkD9iK+og1V3M+WUckljCbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
X-Proofpoint-GUID: Q3bGnUZ01xlSNIpHtpz7TP6jiVn8Iwdo
X-Proofpoint-ORIG-GUID: Q3bGnUZ01xlSNIpHtpz7TP6jiVn8Iwdo
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 9 Apr 2021 20:03:45 +0800, Qiheng Lin wrote:

> Eliminate the following coccicheck warning:
> 
> drivers/scsi/qla4xxx/ql4_os.c:4175:2-7: WARNING:
>  NULL check before some freeing functions is not needed.
> drivers/scsi/qla4xxx/ql4_os.c:4196:2-7: WARNING:
>  NULL check before some freeing functions is not needed.
> drivers/scsi/qla4xxx/ql4_os.c:4215:2-7: WARNING:
>  NULL check before some freeing functions is not needed.
> drivers/scsi/qla4xxx/ql4_os.c:6400:2-7: WARNING:
>  NULL check before some freeing functions is not needed.
> drivers/scsi/qla4xxx/ql4_os.c:6402:2-7: WARNING:
>  NULL check before some freeing functions is not needed.
> drivers/scsi/qla4xxx/ql4_os.c:6555:2-7: WARNING:
>  NULL check before some freeing functions is not needed.
> drivers/scsi/qla4xxx/ql4_os.c:6557:2-7: WARNING:
>  NULL check before some freeing functions is not needed.
> drivers/scsi/qla4xxx/ql4_os.c:7838:2-7: WARNING:
>  NULL check before some freeing functions is not needed.
> drivers/scsi/qla4xxx/ql4_os.c:7840:2-7: WARNING:
>  NULL check before some freeing functions is not needed.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: qla4xxx: remove unneeded if-null-free check
      https://git.kernel.org/mkp/scsi/c/eb5a3e3b75fe

-- 
Martin K. Petersen	Oracle Linux Engineering
