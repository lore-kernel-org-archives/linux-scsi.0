Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82DBC11F66
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CEE061D4D
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhF2EMx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 00:12:53 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:54300 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhF2EMv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 00:12:51 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T46xAK025143;
        Tue, 29 Jun 2021 04:10:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9YdYt5GRkgJh/LSJGfgLiU8FyGCxfSCWiT0slB+ZazU=;
 b=FeeYSKRnfjUuJgSHGbKPnAhMzq3uGsuGjT+c9t/vMPsWzkDMYATRs4ha1bQXwSDTH/p7
 W1s9akkIjCzeDK0aBXY3+hjPvBjJCVEEUCZhwnRjxjMY3+f2tToww9xBKJeqDslT2AJh
 XOyJ6UxTa0NWB+4k8htNTZ8tPukK3tW9xlMSgytmh6N0mb7Gy4GFGB/BcpdgJgBzxQxI
 09YPcx/weIE/uqB2YK2YnKd5LPoikt2IUm+cop//pBZpoC1GTFVww87ktU4+tnLSXXvT
 a124b46Ja0C5FWggcEFNSCU5+eZs3ehJgsMIcxqDKd6mXPkXc+rc7X3/fszDrslnW6uT Qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f6y3jfg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T49pBm150664;
        Tue, 29 Jun 2021 04:10:21 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 39dv24tfen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXRnitjX6xj/Elv/ByXdqn1AsPUIz9dPbJSOdQBxICRXegdd46n/N6IBAQ+ciI5/ODeVfnNhgFr4zyvIzm2ONfiRGG25/fQec/nHRxfn+hlKnpCFo0I3/KPtdPgfF7Zxwhr452JCvnBmWmfBnqZLHBmstbBN3cA1DT/RS+nZ8dJCcTfbNbADM/hCWcl4oKbO/4f1oYl7+m/KP23FvAAg/O/RU3FIAKSujhtydzy5taOI61N/xP8OPBsM4B0LrEk3+Wm5DwZ7l1krhuTaSiwCevVAhyHmn84SVJGtFCd2Mw5JjJ28LBo2nX04rtW3dtvqf2uE/Xkb95sqpAjgGJkXYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YdYt5GRkgJh/LSJGfgLiU8FyGCxfSCWiT0slB+ZazU=;
 b=inPb2mySsEdjICzPiPAHcJDzlmhCHGZyLitHmJoDgi99jq8xn5aRuyhEJOWmGSKNG7CpSmhXxrP08DLGKcUvyR7MRNi0LDCoCiPu0uJs5jAADvQcPItaoCYqmI5jGZ03OtMH5gVKCT42fMCPa/aohQSKvCr8iSfUXC850JhJtXkn/2R56cS+pRbubXcAmQnKY6YbvchSDMOizMC+ISPWw0KthQs9G5eEi5YQJAmD7HU9EYYVfKtXt4BOVCF3YNCygD9//fxH3XfvE/oK/+qHMkGtx5FGsCjgIPuK2Bxdw524ESFs5LMRaQb4q+8JMRqTrv3wnzidwdpa7eQNnFHIuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YdYt5GRkgJh/LSJGfgLiU8FyGCxfSCWiT0slB+ZazU=;
 b=Db9HgD20DBzZ4FlC/Cbc81aUbkI0o4xQ1Sj1eC2RJ15wum3dEfS+VB+WR5qu4R+YMCnXXTg3FUdFY3Z0sMJvf6n0ULKU64VijX2dfwpI+O3lyDiFfff1ZhVtHKvQ/IRwh+mX93a30VZ7c8YYiymZhT7RMVpJf//0atKyEsA9oOg=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Tue, 29 Jun
 2021 04:10:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 04:10:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     sreekanth.reddy@broadcom.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mptfc: switch from 'pci_' to 'dma_' API
Date:   Tue, 29 Jun 2021 00:10:05 -0400
Message-Id: <162493961198.16549.9309389123422129556.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <95afc589713ade2110e7812159ce3e9ab453ec18.1623568121.git.christophe.jaillet@wanadoo.fr>
References: <95afc589713ade2110e7812159ce3e9ab453ec18.1623568121.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:806:6f::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR12CA0029.namprd12.prod.outlook.com (2603:10b6:806:6f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 04:10:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2189055-98cf-486b-95d1-08d93ab3cee9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4711B75A944FFD53DCD71BED8E029@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qigLIqUFmqLGbz7URgHeXuHQvKAD8e7yZelgru75sQ+FekRQIj+0AcPHVMMU1gXrfL9fQmQcnbHP1o0DbZQ0ONCSEuoEQ2A2vPQQw53LKEc3vPELY9BzhDGdNlKz0qZ1k3T5+72bcEenMkKQUNlcoZDllmlsaQP2byB3IMmsQFWkfB9ZRRflffSn0gde32spbHQH4laHnAvdEZy/DaxZ/C6Svebq8ezD+Mhtgt0V5VNeOw27IpPNJbhqklVOx6GTCBM4ml+tbruQqLsNcNCvHM0+9cOqZAT/ld6kpaYdnvNuVuhTo9phWnZPmz8cJZRKG5aTP4pHE8fPR9Gvi+BkFWBJrJAppzoXSeL+Gx/hV7u2dHe+JdKauO0nRRwq6OKTh+sDL9Dqy1xBLCHZOXyFhfSjY4P6fDiSQoqClRQ00pPZAefAJ35AtOfqOJB94AsCXPRVzqovKY9ij8yZNy2i+ZPyW4KI/RknQCxCyiFUxZLuO3+MjhnDWmLYSEBRFtAyZpT9B9CMNzoPU+fIWEJUVpqk97mYkQkL0R8ZKc2lrSW+/Hdsj3QEvbbw/HmUTcmO0L5cwhfAejd5JMLWRteJXthmQBMk86RmBAai8Vye3JDh8wjBUe5sK3v22tS/6EoPGyq2pAs/ZKQcxsepWx3AjLTOm0ra7u4HQTw0BENOmep0rwD49dhbw7LeH9/hxye3KGEcxIVeNORSu5i0qL5WcFXm1AjzFT2gGXMhIAjb3Hdrct6yyKg2CFT4U2CnhNPAwHE3AfFhocHOiz/5Z8/ym9pHWsiymQb7yQzN27kjzfZnZPPnG2GJyV/Gr3XXuazMom+FujbPeMOpWa6PwA61XQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(6666004)(316002)(6486002)(966005)(26005)(38100700002)(38350700002)(16526019)(186003)(103116003)(4326008)(83380400001)(956004)(478600001)(5660300002)(7696005)(52116002)(2906002)(2616005)(66946007)(4744005)(8676002)(86362001)(8936002)(36756003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnZsSTc2OERIbzVCNVdENndiVmdkZHhFTTdkQVFaaTlMb1ExVThzZFRWZnND?=
 =?utf-8?B?SzNUQUZPUEtSNVZoQVBkbWt4K3VtNnl1Q3YvRHV1aDZNWGc5VVlkU21pb2RO?=
 =?utf-8?B?b3p4UXR4YjkrU3dTdkNOQURXTitRZGVtcUNpWWF0QXZCNUJUZDJjS3NKNGR0?=
 =?utf-8?B?ekliNW9Tb2NTenVUM09CRU8vcHBsWitTc0JFL1UzNkNGbDI2elZsNXFaSmU1?=
 =?utf-8?B?Mm4xMDlRM2piZUo0NDlmYVVuWWtoRGgySGVxZmxxTHlGUUdVa0xqdGgwMmd2?=
 =?utf-8?B?b2l0NHgzOU01aktPS3VianU2eHlBY0t4Zlp6eGoyTkpkb01QdklIUHpEVlAv?=
 =?utf-8?B?dit2UTVSenhGYmlZTE1pL09CU0FwYW5jemNINXZEeGFZdEswYUYvTlB0bDRK?=
 =?utf-8?B?WU53Zk1nMlVvOWpoNUFRekZkS2RVRE42dHh5TkVhQ2c5QmNjbGZ0bGRUZ1dH?=
 =?utf-8?B?NW1XNjVUT2hocG5QaVFNOUtrYmh4WFk0OHV1anlndmIvaVVVSml2TTZuZEVv?=
 =?utf-8?B?dktBMVkrQVhMbEhMUHd2eC8vZGw3RVp0SmNrL2RoV2ZwTFM4RmtQRTdKOFBZ?=
 =?utf-8?B?cGpOcDNmeW9KZE9pNXZIcnplWnlVWVBWc1FpOUF5Z0tLRlpTczY0SitmMzF0?=
 =?utf-8?B?SFFNMWsxT3FLcW5INUs3d1djNEZNTkJ0enhoY3Zyb2d3UTlONjZIUk1SMEky?=
 =?utf-8?B?QkRhMWFqMXR5ZTM5VHNyTFg2cTd5eFJ2YkRDL0N0bGNVMlJrOWZtcWMwamtQ?=
 =?utf-8?B?Y1dvWnZ2YmJZRXQ5L0tYa05LWDhheHNOSHZqcHA3QU5sb0FoZE5TdHdxdUZZ?=
 =?utf-8?B?VlFPRE9LSFVFeUVqb2RjTHdib3NzdDExa2oxT1Z6THpQb0tTQktzY3FIa2Zl?=
 =?utf-8?B?dEFQczkvVUI1M0kxZ3BXVmZ4UVZMYzJDNGh3OEdKMC9DM0lvRnNIb0dBc0lh?=
 =?utf-8?B?WmxEeUFqeUZmaEI2SzRseW45UktZTTM1Z0tMVzB4OWdTb1AzSVYwU1Y3WUtK?=
 =?utf-8?B?cVc1UkFTK3J0TDdKOU03MEF0c2xOWWhjcjFTZEhCOVIzTWZmL3pwS1BteUV3?=
 =?utf-8?B?M3dPdWxSVUdWbzhqWGt6dU9xNHNKcE9KSm43RTk5alpqb1NJdVRIbUpMMXVs?=
 =?utf-8?B?L1pNclZ5ajV5YndXUlA2RnpFNElyWEwrVUZTMzBhNHZyVmZYQ1U4QlRBQ0Zl?=
 =?utf-8?B?ZHFSMTM3VW51UGJKYm1DdkU2bU8xa0NkM0dtdTlGNExaUDRkcnQzVDl1UHhL?=
 =?utf-8?B?ZndjKzRybVkwbDltNG1xNFhBMHVkQUQ0SnVTZHdVSkR3Q29aREF2d09kTjdt?=
 =?utf-8?B?bWZxaUN5d0VpYjBqY0dQbG1EdDVzK3R6NlJ6L3RsaVdwV0E2TndWNktvaFJ0?=
 =?utf-8?B?enY2TzBWNW5Ya081VWVmTG1xZGN0UGgvOWc5RmdyN0NlUFVJd2oxVHc0dmJm?=
 =?utf-8?B?WnJ0VHNES3R6ZkhWVGp4Yk41SnREd0NWMHFUTkJKUEJvUE9tWTZnQlBrZGY5?=
 =?utf-8?B?eTFVcTJxRjNuZ0xOeG9PZUh1amY4eG1LdDhXWE1yWTFLM2FRWGNpOGNaQS9q?=
 =?utf-8?B?SFpvVWJzd2c4TWhuYVI1VnJ1aW1DMkVaeXdaeUwySUdRaTJqbENwcFhTcHNX?=
 =?utf-8?B?SWZBcUlyOVM1dnN2bnIvL2Z3QzB4WmV2TkdCMFBpaWpZRHhQTmo2UHhqcUZq?=
 =?utf-8?B?U1FsSmtBamZXWWlKWTRWSmZ3SWR1QzZDR1hxQjVWREdFWnEzL2lNajRuTXBv?=
 =?utf-8?Q?WRE1xRuGmDrx+gsL255S8VLNeauv1lOgMwigJCr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2189055-98cf-486b-95d1-08d93ab3cee9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 04:10:19.6668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c7EMDWZGIxPyo5msAiMY5twRDuAEFcNDBUXcM+4gU/amjQhABUJlCYaTbDkCCsjxeNhmbiaY7uCSjrXqgZXqOEhMPto3frdC/nU0tBrGjBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290029
X-Proofpoint-GUID: m6htUUpQ0AEC5NYmupUDoBtz0hNa1IcN
X-Proofpoint-ORIG-GUID: m6htUUpQ0AEC5NYmupUDoBtz0hNa1IcN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 13 Jun 2021 09:10:16 +0200, Christophe JAILLET wrote:

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'mptfc_GetFcDevPage0()' GFP_KERNEL can be used
> because it is already used in this function and no lock is acquired in the
> between.
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: mptfc: switch from 'pci_' to 'dma_' API
      https://git.kernel.org/mkp/scsi/c/1897c5c75975

-- 
Martin K. Petersen	Oracle Linux Engineering
