Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F9AC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99F3A61878
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhEKD1K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 23:27:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41712 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbhEKD1D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 23:27:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3ELYh073504;
        Tue, 11 May 2021 03:25:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KJURQ6magmVMKKyv8/ZcE/mRcpxrZ5y9wHFDux9RFbs=;
 b=oLakiXFKlXuRLqlqn79cckM3enzZpr1GkD3XfsRsE07FYnCSZ/bFIsbdubGly/0RoS0d
 pAbtLHkIMlioz0wyVr172I/kjm64ZC4YJ5tDWGtmF+hzYL8IMFz6Y6B8Ck/bx5Bi1VWy
 HyfWFHvryKlkJ/NtzeoPsw3haSLFlJLYbk2eNyuTIxVxlwW1ZcaZ855rNclsJgwtazyX
 YBkL8yQBsag5s4lHgWVyOi+nj7zAID0+YQ0/3jo1JySiQuUcawwcBMmCpCQGobBB9gPU
 +ISfeORu7a8c9WADCMzvhXhs4D0WHzJ0yVMxzUQu2PJO8uAqWzNo7pwNNVFfd0lMQXrI gQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38djkmd7vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3FvE7152680;
        Tue, 11 May 2021 03:25:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3020.oracle.com with ESMTP id 38fh3w1u2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZWMU+IOl/Ceeg01NhT4HQKiXaDb2j4ADA5amkcQOZ5gx1U1WhEyD4TVwd8QCEqsHcfTbA/YHWOQFUc82VyEmfyJdHbWIBhEK7WVrotzDkjgjon06rFl5U3sYm2UcBZaMcTLrIkDbwsKiDodQyEWtGo1K0G4a7FlU5G7amiEtNaPcM6JwlFaM62MULgxVqbkRE9eJ/8pQZR9uOMMdGPvs4wUhVmmsN7+T+duq3i4+H0DddEWmVQ/NxX67Nbtz/QOXXp/Q/zg+HeXgDJvBAvLwALCsowakM6Y2waAD35K9pDOLurFsBvpAceN/wK9Y7zphwRkaL5GaoAG9EELL9sG2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJURQ6magmVMKKyv8/ZcE/mRcpxrZ5y9wHFDux9RFbs=;
 b=D6wlkPFExEEw2ADbv5ZjbtoHLXqWxQS0bxd1LofA5pz9z3nVCwIRHx4YnSniX9PdCWb17A1Oaaq1rHm4KVCc1DKbeaxI35UOlUD8Afq50d4CgJKGDrfZDP12mR+x4Ei32zcH8TVC7VI2DUPeYM5OGvwEfeZl0lK2heX6DZ/wtU3minqq0oOC94yo9n2iXkwbDp6ep2yT8Oa7mva7hx8GDTA+EiEhgCinY6xI5j8NZZF8hpAzwEsgXD0yWG9PZx5bRN590SbdN7vst/TeIPMfTW58ZTF5DFE3ap64or5XY9H58f0pIbk7HVREYMFCYt15u9btuVkwwEwL5zw1VNkgJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJURQ6magmVMKKyv8/ZcE/mRcpxrZ5y9wHFDux9RFbs=;
 b=Vk0QAC/QVtNePhKESSsDduFArXw6+nZjHRbds/wjZSpquaRgmyNX1LH+x4exvdnTmx4yApvOQ23rty9MzIFFyDzLpG6qld0z4d4DNBmhAMc4QRWbVDrq+wbeZ8pLDGRXLsJQPhjVTHGgOEtfyxUPnkoJDhAXvKxtHjf8E082Zdw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 03:25:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 03:25:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>
Subject: Re: [PATCH] scsi: mpt3sas: documentation cleanup
Date:   Mon, 10 May 2021 23:25:31 -0400
Message-Id: <162070348782.27567.11658422532606245436.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210418203246.782-1-rdunlap@infradead.org>
References: <20210418203246.782-1-rdunlap@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.20 via Frontend Transport; Tue, 11 May 2021 03:25:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ef2c9c1-57e1-44e6-b243-08d9142c780e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB440800B8A6ACF59D00F4BF628E539@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:110;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bIozBEHloVnDh2xvOn75FbW6HGSE6EVUMjL9VdhEvrgqLOHONsTSFGYMLQmrgIOeWeASKVHOHOr1lsTVf010wOZxtetwMrXHxeRmM6VaUmpXkujE8x2DNiTzWdlnuMO4LGpx3Sn1ExPYIQWOnvFFl5+rGHTetjUmA7C8o7XW2MunnBPTnTDfQvrXJgi2jfauDI0ALrPtRwQdwngHI5vZ7xtqbdSVDfdUnPfaF+7gU9lhZToZ1ulC+ALHU5l9/rCNMjZRRWgZA4we29NxgJE+leaQyNt9epxvZE/oe8H2F2RHQ+cAKMa6KZT1P/CtNm50oQzd/owTN5EFfX80BqSm0Kvbi2fTty1tmqG/ke+4tX18kZ0AYUcHJ7kW1Db4ZIBnoeKECX0Eon7YOGmWdSII2/YlxJ9bLBhID4pqb/mCCBENfP/avbMC21Dq6lsQPLrqdtjQ+6L4q5ynCnLI7V2PevlMtz18/PqcqOR2N6lniU+iV+LY+fe8SPR5Ti8E9Z+CYvIO1HBLNx86lm7oZXJtHloXaQ3HErcf4G2UQMtETTn9LidESu7H16xpmgZFb8k7MX+r4DanlBRaFDWpIxtbTGztbYmqMNpVir+E8yHQu+C0oy3KJO+RjWXqUG3LcTyVR1djGzRbeK4cc9KtA2JaLX0f9O9allXljjWRNs07t6ICEwdQSAC+JW8qw85fpG2i+i6AmWiZrj9EqVcxES/ZsxKRJKumJ/+A33yz3C4zOW1odEh++zSmtYyeJn9dpisb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(66556008)(6486002)(5660300002)(66476007)(16526019)(2616005)(38350700002)(38100700002)(6666004)(478600001)(186003)(66946007)(36756003)(6916009)(2906002)(4744005)(83380400001)(956004)(103116003)(26005)(4326008)(316002)(966005)(8936002)(54906003)(8676002)(86362001)(52116002)(7696005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eDdqNm9hOWh4RVowNW1YQmt6S2JaY3M5TjdKTTdHRkU2cXhrMG84ZU9xY1cy?=
 =?utf-8?B?b2Qrek5KRHQrcEwySGVRalNCWG45OFczTGtaQzdnQjkrMTI0T1VkaU9jR0dn?=
 =?utf-8?B?R0RpM1pLSkxXbWR1aXBkZ0Q0NzR4dlduRlhYSjZZQ2hJTEkyYmluZlI4ZjAy?=
 =?utf-8?B?dWREenhIUGpNVDNBbFg5WGxndWF3T2N3ZCtmZHpWZ2IvMWpiOVBSMVNRR0Uz?=
 =?utf-8?B?WlI4MlA4dzYxSldEQ1VNYk9tWHU2THAvbGc3aWhZQmVkUjlCaURFQ3RuRXh4?=
 =?utf-8?B?RHdncjB5UmVqckVma1lLSEJIbnE4LzRCVVM0bXp6OTN6WnhrRlVlTlpnZFQ3?=
 =?utf-8?B?a0VQaWkvcXZ1ZXJDTk9aMWxFMjVQeFNiUUtiaG1hV0swdHVtaVdpbEQ5aFdk?=
 =?utf-8?B?KzVvdlNBajNrayt5dEtsdm9Lc1JKdWQ2VXNweklTWXBCMkp1azFIemxEd1lM?=
 =?utf-8?B?OHA1QXVlK3NGTVI4ODdEa2RTTEVzL1VleEhuRWJKWTJ0cGlHSGFpYU10UzNX?=
 =?utf-8?B?WHc4cVlsSVQ4T0VPSTRiS0NTVDZlTEltOHA1L2FrUFU5bDE1TFpwNHVsZ1hP?=
 =?utf-8?B?OXMxV09ZdEZVZHhuYzdIZUtVUEY1MTlRYTVpRlhYVDB0dnAyREJ0cEQrTGxT?=
 =?utf-8?B?L0QrSURHOFFTakFUUm5qakNabS8yK1lsd3JrYkJ0UFg4L2FMVGxaUnNMM2cv?=
 =?utf-8?B?ZTRHRU9jM1V0TE1NQmdvaFdjZWI2RFlEU2RqdnFTVVBLWUFhWnRjQ3hjWjNw?=
 =?utf-8?B?MVN6VjlaRGQwMWRVNllrcW9kQTRvR0NLbWFvbnRDODVXcGVUa3huV05SZ1VD?=
 =?utf-8?B?c0MzWDRTbUhRWkpxY2pQZ1Y4Zkc3bU9XZmN2aTRuVUE1UWlwdjYrY05RaHIr?=
 =?utf-8?B?OVNiRkhCMUR3M2tIQ0Z4WUtneUxnNHpVSVkzVndZRTNST29MRG5kTmh3S0Zn?=
 =?utf-8?B?a2ExN3pXc292Qm11NUovNE9qR2VCWjQ5Y3FJRXYwTXpjck9vZjdtcEpmVjUy?=
 =?utf-8?B?NjluZEdlNU4rNWpvMDJDMk5hWGFjOTIrVUlGQ0NWc0VWT3BESG9ZQzFpVXl1?=
 =?utf-8?B?K05jd2ZmZE1DUXliSW1OZ29hWktvT0FWd2pUTUZwYXpFRkxlSkNuaW91RlMv?=
 =?utf-8?B?WGxDaXNnNjYybTB5RTM4SzN1VnViQ0cvKzhMS0h2emlTd1J6OCtVYkcya3J5?=
 =?utf-8?B?RWpETXVxUlc4elNVWjVXM0Q1SXdjdEhjbFhLNzZIelJaclM0Y1RKcHRKcGRT?=
 =?utf-8?B?c1k3RisrNWZJaFRTUXRrUkpGZEhId0xFMUlZdGNaNzVFTU5CUXRKVWlDcmkz?=
 =?utf-8?B?cDFENGg2bVcvbXd4ek0vQllPdko1c3NnbytweTdWZ0l0S0FIbmRrY0JuV0E0?=
 =?utf-8?B?Z3hTS3FoV1JnLzFrT1Z3dTFza2IxMFNsR0JVbytKV25lMGxXT21YcndQU1c2?=
 =?utf-8?B?b1NURDdYVTVwTHV3TXV4OGtQRmFxT0JlTW9ETlp6TUF6ZWtpS0Y1ZXdvRTN4?=
 =?utf-8?B?UlBYMjNydVZBRU9EQ0xIN2JQTGlzdTVDbWhVMndkOHRtWDZqTDR0cFFjRStW?=
 =?utf-8?B?UDdPOUVTQTZkVUhZN3cra241YVZaT3RQNTcya3VRUnJxNnRhcVFNdUdJbEx1?=
 =?utf-8?B?WU4yaWpobXJxVjZGT0lKNU1iR28yUm95V255L0VYOHVZRlp2eEFTUHpkbDBN?=
 =?utf-8?B?SGJHVmhDTDdScDJISFE4NHl4M1Z5MklKbTRuWHdlVElDemJ5eXhIc2NSRWNJ?=
 =?utf-8?Q?1wCBsbi914xNzTnRule8v3dS2QrBfKZOclENcIf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef2c9c1-57e1-44e6-b243-08d9142c780e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 03:25:47.6763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Jm1rMNuHgJ4NWLny/qR3wMtwVmfPW0iyJ8e6TRd9u2M/EHWIyuFI47ZCREJ5xK09YTQNd79zoFDO7VxmVCJb/WQRmDI0UbKMbNfTgFKASg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
X-Proofpoint-GUID: VvWKLBdZVNjUL2Opmp0RWEOG95UQnE9h
X-Proofpoint-ORIG-GUID: VvWKLBdZVNjUL2Opmp0RWEOG95UQnE9h
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 18 Apr 2021 13:32:46 -0700, Randy Dunlap wrote:

> Fix kernel-doc warnings, spellos, and typos.
> 
> drivers/scsi/mpt3sas/mpt3sas_base.c:5430: warning: Excess function parameter 'ct' description in '_base_allocate_pcie_sgl_pool'
> drivers/scsi/mpt3sas/mpt3sas_base.c:5493: warning: Excess function parameter 'ctr' description in '_base_allocate_chain_dma_pool'
> mpt3sas_base.c:1362: warning: missing initial short description on line:
>  * _base_display_reply_info -
> mpt3sas_base.c:2151: warning: contents before sections
> mpt3sas_base.c:2314: warning: missing initial short description on line:
>  * base_make_prp_nvme -

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: mpt3sas: documentation cleanup
      https://git.kernel.org/mkp/scsi/c/2910a4a9e90a

-- 
Martin K. Petersen	Oracle Linux Engineering
