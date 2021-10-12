Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BC7C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AD5561050
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbhJLUho (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:37:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:13326 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233308AbhJLUhn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 16:37:43 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CK6C9B013002;
        Tue, 12 Oct 2021 20:35:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=0g/nR2mhI+bIl5bCS85k4ZmB6AUCICHliXYmJXGM0+I=;
 b=M05t8JU+/pEcT/sC2mjcqzxVufZzoPrh2ovCtL/W1qp4WhnubIBmpLbYCyQJKtcLqaHP
 pnsuzEJp7YpBMzMYynb1Rrod0bkGAaxYptlyHj+yOAXQm9tQUiLCZywZ+i4AZQwt7M83
 olcXP3A0p0Z+Z7YTxRuHozucYzZ8eIvd8DD7z5b+/FdPbm3q5ZONTKSL/rAmGUSM4zjb
 Vc/JdVUp60MBKxBY7nNNJoz0SSGV8Ri9EbPofSM4WR+029SooZav/YJZ559EYWar25Qy
 w5g19KMjy2mWT20C4RiAtQ2eAQx+UwMl5HEngfDHmVYQKD6IdjTnOJvho+OLUrpQBiBO FA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmpwnb7p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKYits033790;
        Tue, 12 Oct 2021 20:35:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by aserp3020.oracle.com with ESMTP id 3bmadyndj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YugevE/hEec9q0u1PlOYOJ1ivhp8Gx6fhmRX/HTiN+pbauJOv92sdwdZo2HkdBCj4h8KAeOebw+sXgTxhWGlLft5myB0CtZzseQ5SQ0NTiWNXONMCpU3/dAPkXTt4owO6DaGqAEB5cusUAQ8MBDZTDYVymjOjeU3IiJYxLP7uBAigaUwtB6/MOWbMBnDT/Aur4NYTsIv8VPhVFsVMlJdcFi2ioMhpXyji1LutHVW/OCOM9btdjwAbyl52f36sEpwYwRJtkC+ZT06zG/3I8LI7JkLxJIifIvEscQOoukzLc3U9DWSN/3slgn0BYVM2FDW7x1FFYRhYThkHiiZCMCoCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0g/nR2mhI+bIl5bCS85k4ZmB6AUCICHliXYmJXGM0+I=;
 b=h6Z0dHZuCRW3adJ8IeA/KNnu0qwpP4v3LGDB69SIPlFS5PYzdZrsgIGuXe6i15b0Yqr4a32qJ3l7SoM/htavBHEAvoqJQrPb05vclepAmcbtliL26m9N3E8evDVle/ctYs+eCVG/QHBqgPrLB0n/DX152X6gJNKzVRbitMHT+pvYnZeL7itS7XP3KRLb3rAgAxeQjOYnVyeLyV3r1GH9gJWlCXsvJkdtqQ2I/uL9I1Muad1TiK8SytlcSxXeF3L7H2JzzHpjq+KxS61u5NANwdSPYCF5MsxWHwUfpg+1MLadBLU9fFzHgXmc6u4y2FtlXnOXN2YzqcpSjQppuz2GDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0g/nR2mhI+bIl5bCS85k4ZmB6AUCICHliXYmJXGM0+I=;
 b=q1M1nvTIw+picS0m7meotiN/KTFdfe4l5M2uxOg67uNzpkkxK1eTLqGhq96nhHKClemMd8GbDZ2zuiQSUkvAbormv0IlJq6sTuN3EdeiF+kR7Yk638J6EBbSQfk4kMZe2JZDLTz8G5S0d05zPDaQ8pN4ZCx12xkG5ArAIGmrLdM=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5514.namprd10.prod.outlook.com (2603:10b6:510:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 20:35:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Akshat Jain <akshatzen@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: pm80xx: Fix misleading log statement in pm8001_mpi_get_nvmd_resp()
Date:   Tue, 12 Oct 2021 16:35:13 -0400
Message-Id: <163407081305.28503.16472329776703654868.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210929025847.646999-1-ipylypiv@google.com>
References: <20210929025847.646999-1-ipylypiv@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 20:35:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d00884d8-d3cc-455d-dd22-08d98dbfd5e0
X-MS-TrafficTypeDiagnostic: PH0PR10MB5514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55143F4C7C5F45AD1C2E79CB8EB69@PH0PR10MB5514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2bM3gdIixoS9HvhZLzXk3eN8rkvuT9P1A8nD5ki2Ipa/PdHuRsMpBSSexrfeWxLiqYrZstGyQwja7MBa+T6GrF4Bz8apTvaY6CxVjmHprwHJQUBMMy9tCTKLTRGv+mLUbhfelvAQBzmV7pKQ+hAf8PTROQZq5MWjN8yFhnsTe5NlmblviAJF1qIZ16OXhl63wTB9CB+7xQN7xee0CMV10I/ECedKmpIVCyF7gDkZpA/9BG6ItfepmQO5nkOUClpI5sjeDfMxwpfL60BbtnZO6kTzkr2gV051HjHQ0OxPVER+bc3sGnWWVVl1ODJUjtcTQwkTPAFv/0M6XTHmIEBII/dmXOx/mLzlG7l6LKq+lKZdTnR8y3STNMnpuPaVY2nNCtme1fA+UYrojh9F+5ujjBiDaqKAcvtqWs1QJ9tyF2nQOZSwbphJw1USaLQd9ccqz7oQkwTeV2Re8rcE0euhEvY4heG5KDYDNaPjQG0b8cgnXXCoSeMSiUjOJNRdVHCQhGmkrkhBdM9Y5Q8OyqMBPw9BZjFat7CGXQvpSxRqF4GXwKAJdvxvONCM6jl17L6RuujEJzxbsg2qLJs2KD6ZFUZ+ppolmWWEZ9Cbf3ou6HJ1Za1VF1H+ncjMRynF7mFuYMgFPWVg5gxnYvuVZKnc1hb/Pz03jFpkSDwoVg6GODA/gCnQUkgqRlL/dVg/dZuTBviuCjQxwFsbjb4dKmklsfFPoxVYmPQP3jC1JtL6GRwkdSEnkiIejrLT5z4vEFMGPJ9ByW3qOKInEMUFv5P1EEo3pOl8yWhvUQqEcvPcxvs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(5660300002)(8676002)(2906002)(52116002)(66476007)(66556008)(7696005)(6666004)(956004)(66946007)(6486002)(110136005)(38100700002)(8936002)(54906003)(4326008)(36756003)(186003)(103116003)(4744005)(508600001)(26005)(2616005)(38350700002)(966005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sk5MaGgxcHhwL0g5VWc5N0JvcDc3MktoMWJVUXcya0h3U01LUllBQ0loTW1F?=
 =?utf-8?B?RWRXNXQrblRIcnhuU3JiemhyRGoxT3pNZkFNbmhFa0N1QlFXRm11SkZxS045?=
 =?utf-8?B?K3NYamxoSnJmT3gyclFCWHBXMXJnSHkrZkV3bFdJQTl0SnRxbnZTNGVWdEs2?=
 =?utf-8?B?ZDZqdUN0Z3p3N0xTWk5HRThwOGxsOUhZZ3hVSHg3c3l5UjZhKy9XQTVhcmh5?=
 =?utf-8?B?MzZMM1VVZ1crS0JDQ1p0S3Z1NVNTRGFYSUsyQ1IvR3NvekhPT3JpbStqZ1J6?=
 =?utf-8?B?aVRJNXFsTzJoYXdFUkFUYVJhUEFQbkVnZWZtakY2b2Y5TENqdWgrMit3OGhh?=
 =?utf-8?B?R1YzNXNod3dCcnBRMEhCZE95WktTUGdmWVM2c28xaExGZWp4RTZjeVRqRWZG?=
 =?utf-8?B?U0NDNmk1dlJGQ3ZaOUFJTW1SWFZFTm1NNW1ZN3hpbFZLaFlVTEM3VXFHdE5S?=
 =?utf-8?B?bTlTZG1qc2tMWGpXbjRBTWFMbUJzMVJqWUhFTmVySGhPalJ6TVVyZlc5QkUz?=
 =?utf-8?B?MW8wblh6V1ZCT3hRSVhvTVZYeWhBd0hoajRKbEF5WE1tc0l4T1ZOdnc3VW9S?=
 =?utf-8?B?cU55WUNiUnlEcEVDa0FGT2lhWVpNVjF3MGJFZDY0U0dPM0IwZUlhM2Y2Z1Yx?=
 =?utf-8?B?d2lNRFZTVTNVNWVMaGFnbG8wMFptZE1xMklKczhBV0FTVnEyZjRHbzZaKzk3?=
 =?utf-8?B?SndJRWpCWHcxcm13Yk4yUThRWElNeENyRVBjWENYc3RiTnVOOWwwVEVzVG5D?=
 =?utf-8?B?ZmdTVVlRZ3p3bG1IWVppa21Ldk1oNHRGd2ZiOGVnMW9Ua0M1dzl6NkJSRGNj?=
 =?utf-8?B?WllRdXFwcUNLUkV3Zm5PVEU1SGxqeFp1ekpKNEhReENNWThHaGpnby80eDhi?=
 =?utf-8?B?Z2ZqNGdUOVdQWGhDeERVOHRKUGs1b2wyREdnTDlwbGlrMFFJcWRsekp2VVdG?=
 =?utf-8?B?bVhrTzAyV0syWEpXTi8rSGZOWE1FS0FrdDE2WVYwcnBKS2UrUDVYbDQwK1Fa?=
 =?utf-8?B?a0dWMlRmQlN1UFN5bFZlYXczRjJQZWpnQ3k2MjN5aXhrblJtZXU2NGpZdTBj?=
 =?utf-8?B?NEhzVUVYdURQVjQ5STI2VmVFTDNPTFI4Q2x2M0wra1NwUlhNeXFYcmZLc3B4?=
 =?utf-8?B?R1pMZGRpbnQxdjQ0VmlQeEVoeWNyeUpOVGtRclVMMkF0OFJqL0R1a29oNDZk?=
 =?utf-8?B?RnRzRWVkSHJmRHFGU2ZIdk03VUV5NTNwVXJ4YWc5a2tWRC9JaGQ1em83RWFm?=
 =?utf-8?B?d2VINFZKK2lqeUxtdSs3cGNzSThZVUdha2RqM0RmTGlCeHNLejZJeGhrdTdX?=
 =?utf-8?B?ZVdMdHExRVA1bkJ4WE1TSm9WWFRKQnRVbU8wc2RPKytscDVMelVpZktHWGRV?=
 =?utf-8?B?UTJLTTFXYk1QeHhmcnhoT1lLNXJmL1lVY2t5RWhyWTdtOUlOd1RqbU9vNHhK?=
 =?utf-8?B?YUxDUUl3Qk50Yml5MTYvcktyR2tudVVHcWtCcVl3RGdyN0Y5OHJ2WkNJbXpz?=
 =?utf-8?B?dkNGWXFRRzBBUGx1UW9RWit6NEFuWlJBR1dnQ0NRbHZ6Z2Z1aUpIdVNQK3lT?=
 =?utf-8?B?UTF1eXlTbzdkWXdCQmlkR2ozanNUNXBQYmdNM0YzVFNyU1pCMDZpcm8xMjhB?=
 =?utf-8?B?TmVyZDhEMlRra3N0RXBXMGRkekY1M1JOWmlpZkVxaW1IM25YTWIvekh5UldT?=
 =?utf-8?B?ek5iV3k1aE9xbmxxZGRZT1dEOUgyWklrSUZmd3QyUWlOeU90aCtIMFRQZTBl?=
 =?utf-8?Q?XivRflPxJSKAcK2DP6c5O579QqsTwEiXKljI5pv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d00884d8-d3cc-455d-dd22-08d98dbfd5e0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:31.8001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rN20iXtFexiWEMGdw2ppHwx2mnq5Vddzd+YxUxfCUymvoKUDyH7ZLDhs3HYgD/zeZZUKj/c2ZV5c1bNxrW5lD2WekbO4DIsDUk6mxWrMBBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120109
X-Proofpoint-GUID: yluugm0jcsWhfoy46ZJwQ8Fp2bDE8KRD
X-Proofpoint-ORIG-GUID: yluugm0jcsWhfoy46ZJwQ8Fp2bDE8KRD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Sep 2021 19:58:47 -0700, Igor Pylypiv wrote:

> pm8001_mpi_get_nvmd_resp() handles a GET_NVMD_DATA response, not
> a SET_NVMD_DATA response, as the log statement implies.
> 
> Fixes: 1f889b58716a ("scsi: pm80xx: Fix pm8001_mpi_get_nvmd_resp()
> race condition")
> 
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[2/2] scsi: pm80xx: Fix misleading log statement in pm8001_mpi_get_nvmd_resp()
      https://git.kernel.org/mkp/scsi/c/4084a7235d38

-- 
Martin K. Petersen	Oracle Linux Engineering
