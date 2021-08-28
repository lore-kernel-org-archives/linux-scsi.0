Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E667C432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 535B06023E
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhH1Cda (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 22:33:30 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3264 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233174AbhH1CdZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 22:33:25 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RLCfFo028965;
        Sat, 28 Aug 2021 02:32:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=vM6bnfVGdTy5a1wCWs/vC+/23hbbBfXJ+onLviTx9/k=;
 b=EBD+gN2EBbskJ71cZjvA6BptxLnGkDXnmQwsos5CanOGHHageJxQiWNtlxdydEgBqp8n
 0EUjik1NHhOedNkmXWy+Gpui6DtDjExbn/EC47y5u+acPWb0MuACW+85PjBaMXFvuZQq
 vJWqyzClG6GaVF7R8Gs8dCuFXwDVmpne1mxY9rkWmdbrGErK2ExHYW8qZiOdoS2q4S4L
 3zMQOUV8XqS2mLzPEjDotG3ReKFKw8ehQrDd/imZv4jWYr3X1ApfIbGjh+yu8V6GeBfp
 aYWnjG/BJ5RQP2+xL06xeT7lGVg2YTGCG4X7bclrh+dm9alU+i4yrVJXDHEyto9V9vI1 dQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vM6bnfVGdTy5a1wCWs/vC+/23hbbBfXJ+onLviTx9/k=;
 b=Dp9L805sIrQ4Y+z4q4kcpXow07t0jpqIsmlNDxla5eAnveYqFNSUMx1qkP3QUoQu/RzD
 LOBvTExU/79wyJIu8EsljP3IXWwVsp3Tymh2tqaHtAGAhqQL2QlLwM1aoGon0uHf5If5
 1FiQ/4FBp5qsbMP9/BVIG/orVPFiEA4ScV8EitzkUuv/wB7E7fJBSiYMboXNSZ43Tr/U
 1vuy9vZ+sWd6U2V5A0mzHuHpZVwvyHbbjfoAc8xLaW1fBNtg1Kjr4ZcCLVmgShnXcAVa
 c/bB+DTXXwaJnWUO1Jm+zM/nyPpn3YaU4z3OblfcS3Calz6sizOmQFlFtxyPn26dclpi fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aq7s0r8m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17S2Hwng169952;
        Sat, 28 Aug 2021 02:32:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3030.oracle.com with ESMTP id 3aqa8tnj6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQqD/uqG5UqBp+ypmSCpQrQJ+5edKqhRyH/WNYO15xGfqY2HBf6Ypoo8xIDz9Xo7KRFE+Hnt0aYzZnx1f7l4ErjT1Cbj8sfoQ7rkO8/qewDeI4iZ3I4Bn11wdEdHKsPVEwV/8s65wjm3m+ne4Q49Ghw1iVQ8+PCxO0WGX928X6YspU0DCjQC2VCaWktl9vvV3WQzzGG2Wez2xlRQYtugjHoWo+gdPb7VSQHyOAt08QlmEmy9XqW6HqjF6/ygb5heFEI2bA1yHGgnkWS/LvsIewqQAi0SiApBYI0MFIID/j0H3JdL7MiWM/JDYv141GPj/D9bvNzfmFJ3qHPc7eIimA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vM6bnfVGdTy5a1wCWs/vC+/23hbbBfXJ+onLviTx9/k=;
 b=Piob667wIKw/sIx1sD5G+T7uX5k82pBbseOtENlt9C1+hh03dO/VG3rqX44sSenTla8faE0j++IXXzbIsjvRqSRXNvigrg/S2FgGirXt/eev2K83u+MjaDWGFHJr0MNp/OvpqYPY5BVm32q0s4VCP7msQRPAuwqITNTd7aFQuT7LFATDlTnu5jkE4P2eTwSfZUYFZ4C38d7Yxvf8YcEJANTUIsMAfmFbwhIINPWP23PYeBmCJnA96X8m0kwBRA6SRfRz6bNuAjAivhNDWBGq4YLdp6edAdsiv6Q+O/V/PtHTHj+BM3Nim3qNby5m5spVpaRCwfBmrTHq+Kf3GMUIUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vM6bnfVGdTy5a1wCWs/vC+/23hbbBfXJ+onLviTx9/k=;
 b=GMCufRzjNpa6ZxRe1ytNU5ngt0HblGuYEXZfd7ItG5MkjAYSYnDzTGXRPW1AukuzJQKyPrcakxJqVwa0UtdTzVx3tEmzyTVAC7ZFi2rVbE/JU7rm8y0swtjao4M6HBzUS2wUKMJfrSNEMIIrXZgIqAPqiwqzjTNsr+Sgrag5SYE=
Authentication-Results: sgi.com; dkim=none (message not signed)
 header.d=none;sgi.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 28 Aug
 2021 02:32:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.027; Sat, 28 Aug 2021
 02:32:21 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     mdr@sgi.com, John Garry <john.garry@huawei.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org
Subject: Re: [PATCH 0/2] scsi: qla1280: Resolve some compilation issues
Date:   Fri, 27 Aug 2021 22:32:03 -0400
Message-Id: <163011776500.12104.6025187367242838866.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1629294801-32102-1-git-send-email-john.garry@huawei.com>
References: <1629294801-32102-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR17CA0025.namprd17.prod.outlook.com (2603:10b6:a03:1b8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 02:32:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74132c86-e2b4-4b9b-f98d-08d969cc103f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB551581B046390881B3108B1D8EC99@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q58NWZAg8YrcEmlwXGUc6U1HcmlIXB5dP8eyfc/JDwD10okSC+y50pLDJK1ex4C/L6R3Xe1pfW0rI0m3qmhGAVRP9iuPkt1zGJz7DAzeBFhcYVEnITrTj1vnaGZlrHvAS1PyMLJvnLghTOCGAjC+u4+CDgtajpDkVX2KQzUqVGw4RG/eXJGlHNOFKZ1jD13rMX3ooc3rM8q0Wx6X+t8/k5O6AEmlzjCbnx8vpiiGl+LGwqzNICPpwExow3ih5f1Y3b1b9GGeGSjv2rz/vd0rs/CW5YqBWpZivl21qMLqCnQwYw+uq9MF4UHdkZukpilotb6sol2/jGP413Ztwo5hwDvw7S8KlHawXxKUNC3/B8aesEjImROTbs++VxGTBOvj1a3pCBnUoMUb8hBF9Z5QnZ0scuyKzqiisPtG0OXyo4ktqgI+1uvsBE62j8lOdWNM2kWKMCfjMffRA/noLZVwFyWW3UDAugWOSzYbAABcxzaYfylAVc2JQXZIVfXEwUnB31Dhhswi44GVMQPLjrV9zURUr5u+s0IYkrtRk9IP/zun7dUPrdXNo7p4mfoKxzIjOXeT3BMb5girVwdhXMKqmu7u9rLpS4RIrIxxia6QT5GqPiTlkbWVDr/Qva514bR3GQrHfsslKsU5u76wj0zt7YI+67UqjrRnLIVrnUZdvcEz8KIOC5jKM7tl8oxDzHyQGn7K7Gi0KIR6B3Xz2zLkar5Sr0weMD+FCm2CmVTQTyzEX22OFafmvuyDEKFas3AlEJASPPpV89UnbKnrE6K9NgCUiwwXPNLDY2VWEXFq/ySugo2IOpRr9ggXmakSt0PLETX2xfrJ27NoxJc0snH87A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(966005)(5660300002)(2906002)(508600001)(52116002)(38350700002)(38100700002)(4326008)(7696005)(316002)(36756003)(186003)(956004)(2616005)(6486002)(26005)(8936002)(66556008)(4744005)(103116003)(66476007)(66946007)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmFyWUxVQUNBK1hzYXNkVGxuTmtmV3dlbGRqWFVCNlJldStOQVJiZjdQVW0v?=
 =?utf-8?B?SjNpODI2c2hsWDFtcTJyVDE0b1FPWlNnNmoyRUFOcU52dTdxVjlxY1hSRkRt?=
 =?utf-8?B?UzBhT2hzUDhQWVFKamdQNWtITXphVHVtOERhQU9JUFhubDR2ZWVobkZ4ZnFo?=
 =?utf-8?B?SzdaQkhiVXdLRHFJTkllS2crU1ZZRGJxbUJKLzZpekFBZC9VRENOWFpVZ29u?=
 =?utf-8?B?bHdUckMvdU5SUDZBTitrOUhzQUlYNHAyYVg1VHdMNlo5eXFXQk9uZjhWR1RZ?=
 =?utf-8?B?RVlvY25hUXUxME1xdDNTLzJBZEx1VzdKNDdIeGlDSjN5M0NWK1k3OXVJcUpi?=
 =?utf-8?B?RlBJRTZtM2MvaDNSZnI5S0NwMzFoRTExWjRxS2x0WTQ0Y3ZsNGliWnF6NThq?=
 =?utf-8?B?SERVU3VLT0ZhbHRoWTJSRjZuS1UxVGpZR05rYWoyUys2MmtzU1R4bk5jMTVZ?=
 =?utf-8?B?MDVwS1Y3bHN4SmNhZHl5SGpjZFlTQURsRmhuNjhpZVovVzIyOWtPRUxjWlJz?=
 =?utf-8?B?NUpDRWMrQXliTE5KUnhDTHFYdFB2UDNqL2FSUkJLNmlBRDZxZTBaRUFvYmc3?=
 =?utf-8?B?bUpORXN0QkRNUFBOYUcwOXNURHlVLzN5SHpRY0lXN1hqZ2x3dHl4OTg0SitS?=
 =?utf-8?B?TC9seDFwZHhJQWc2Z055a2JOT3VsSFRaZzBOalJhQnlrcndVeHYvRUREYzhv?=
 =?utf-8?B?c2NSd1c2MjFmUHRyWVpVWlRXRnpKd0tFTVliMmZGbkw0KzlvcTFPa05qZlNl?=
 =?utf-8?B?WVIvRjB5WnUwVmxvTlpGTzVFb3luZVhEdFB1em5UUzZrMkJpMXJTVlUwbmxG?=
 =?utf-8?B?Ym9wN1l5U1ozOENzTjdaTUFmSHBvQU9aaHBLck9oMHlYMmY1S21GVmFtbVZt?=
 =?utf-8?B?Ull4bmxGems5SVQ3REUzZStzckZ0Wm83RDMwZkhoV0RaKzd5ZWJQRWprOG1Y?=
 =?utf-8?B?NFdJb09FOGhyVldweGtGRCs5dk5VUmRnZ0pBZ0F5WkRUUGdiN1hGUnBpU2ll?=
 =?utf-8?B?dXFPOVNlbUxpamJOTWdtVnd0YUZDRHA5S0JUOE5ueTFYK1RVS0VycDM2SzR0?=
 =?utf-8?B?YlNha0d3VURycW9rSmlKL2twRVNJZ1NRQXFVYXh4Z0tSRHJqT1pRa2kwTlhC?=
 =?utf-8?B?SHJ2T3UvdHBTeUdpUkpxMHNyN1hVY3FGaHc3YUU5TncxYTk3N3dvaDNSdDE3?=
 =?utf-8?B?cy9YaG85S3ZtVExHaTZrc0tQSlA0eG52ZmhyWXJiRlhQMEpoMEtmV0RpQ3VO?=
 =?utf-8?B?R0hEL1doQThISEVmMVRvaFk3SGdVc0taM3d0QnQ5ck51TlhQbmJwZ2xwNUh5?=
 =?utf-8?B?K08ydzEvdGhIMkZ4L0cvbnN2NlpWR3V2akd6a0EyV1FEZm1LV2V6d3piam4z?=
 =?utf-8?B?Si9LY3RLT0NqaGNGekQ0RDhka3lmcVlYRVp4ODZJUXRrVFplRVNMakF4RHlB?=
 =?utf-8?B?UU9jK1hzRGFnSXZIb05kNFdsVGRHSm1TcGp4dk9WeUJwd3RDbEtkL0NZUzJI?=
 =?utf-8?B?c2xncnduK2ZsK0NjVDgxU3JWMGM1T3l2V0ZraWJHVkx4TCsxV3JCamxweFVD?=
 =?utf-8?B?am1EUjdqN3RhMDgvU0RBQ2JCYmFDUzdGTERtalUwY21iNXFkc04yVjJnekhJ?=
 =?utf-8?B?cTJkY1BWVVNkT0xSbk5UNmhESlZOeXZ4NkpaVFJiTXNxRkUvVExWY284QlZ2?=
 =?utf-8?B?VExzMnQ0U1dldkQwUTZDN0FuZ3puQWRRNXJySGFNM3Q3RzJqcFM2TnNZM29n?=
 =?utf-8?Q?i4zf76TFpNzQ7qWSK3gYkO0aYVT+8CS6FWiruW5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74132c86-e2b4-4b9b-f98d-08d969cc103f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 02:32:21.8619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNtklkLo2DaJSxBZMvFE9zOQLWhea2BLVBscbGQ5h0bQzGa6z5ZjeuEy0gnFxQAt8KX0grKLq31YxQMIp9u9SZy6m7nOFiRhc/JdrLeISD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280012
X-Proofpoint-GUID: voyeeDb5tqjM6jqdeM4Itiu0LDB6akj_
X-Proofpoint-ORIG-GUID: voyeeDb5tqjM6jqdeM4Itiu0LDB6akj_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 18 Aug 2021 21:53:19 +0800, John Garry wrote:

> As another follow-up to removing scsi_cmnd.tag in [0], remove its usage in
> the qla1280 driver lurking under a local build switch. Also fix
> pre-existing compilation issues under the same switch.
> 
> Based on mkp-scsi 5.15 staging at 848ade90ba9c
> 
> [0] https://lore.kernel.org/linux-scsi/yq14kbppa42.fsf@ca-mkp.ca.oracle.com/T/#mb47909f38f35837686734369600051b278d124af
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/2] scsi: qla1280: Stop using scsi_cmnd.tag
      https://git.kernel.org/mkp/scsi/c/c563c126e293

-- 
Martin K. Petersen	Oracle Linux Engineering
