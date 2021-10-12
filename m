Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7035C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFC80610A2
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbhJLUiD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:38:03 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22786 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234895AbhJLUh6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 16:37:58 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CJjn9i016788;
        Tue, 12 Oct 2021 20:35:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=PcUwQCi3BPuA09nJrn5UPE4WG1iLKtAWG2YmD29Dfdc=;
 b=QJqXCuYfbduPV/af7SPdn4y7gor3QOzmQFw+2McVAnADscjTiz83hocOoHuKQ4bf8pE/
 fADfUwQ65yvE2G4o2ke+zoLBVGleQO3Fw3SpiRhy4MF66CEeGtzzMcFFUkqh9/uz6eoC
 SSRnRYJNQv/AfUdD2SrVltKYE27+NzB1fVdjBHgHfI10kqGygLnTRTjaEcE8BXb6aQKP
 GuD8KT0RsxbFcAOhbSRhTW14d6M5NHyUW6aL4qKjkXJpX7JRkLr3GNZ26aSscuioIW5H
 2n8jMt+r64WrZ0DM7WAZO2We3uoSDAi4vva5uWcRexJ1iofiT9HJRv0evVfWwsQuyEhW jQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmtmk9gnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKZ7M5009545;
        Tue, 12 Oct 2021 20:35:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3bkyv9jq2n-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDd9GSY1gAnxrYLc7HHLbjbxH5K1kms3iBR/ChvKCgwTh2i5UY2nn3jJjmCiM9WLxSwIxXzpwMifzmaYEISydhA7qd7nPA5iSZkxMyhP7ai0LH6HF2KmDb31r3nT/0Sy0Qzm3eiX3omE/TSBe7aSjAjnQvPnOvJ/8vD7edBL6PVH2sAGlw4FJ2gTk1FFVuBSW/+nTlJYAkJEoQ0iWd+gPL/KSq0o4k7zQWBwJOj6yQ1FW05gxbKm3DNyJVBY3dtQdmAWQKgwmLbIQDhycWysfc3t/b67A1Jm9GTZhKwIuNB5dPO4HChHrBN3KdC/T8ETeYsSNy6ZgfARav9yWxvefw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcUwQCi3BPuA09nJrn5UPE4WG1iLKtAWG2YmD29Dfdc=;
 b=Zxbh5Mk44SHNu+pTujfI5H1RtgV4EeTwSisBP+4SQcpxZmLG2nYV+cb3EdhDyA4GnUOg3KUDIiakgOpKWyRn2sI8XroHtYeQyPgWEvmUwJDaThwgmv8eCdvfVKe84LVK7Eyhvg3fGCkuTzC99vAGnABvcj17ilYhgRhikpxXOe8cLoJW2stJ/grfjhO+zdL9z5tBi/dcgoGCqS01YzS4ya/ZhVrVHOZ41vlwiIpQcZ3AGHDns4bzqNUJDcQZK8zyZgw8z0E0AjiRT4xT+ukYYhgwsuIMb+DNbhxhthsnbyOAM+2VPiRX7qFy35k6VGHiFF2xFmzbCSzk/mKPpI1HQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcUwQCi3BPuA09nJrn5UPE4WG1iLKtAWG2YmD29Dfdc=;
 b=VgeftBJK5GPIIXkJnNPjVHCYksP0p3SRComT/HLdUUrlG9UwwTS/qh8ZWnVjHsE19jsqfex0wbEBrWL71lojvapFXeASo+X6h7wcbHUU4A69m3UdJDjUgfZW84dt3AlOgwAvBCqgA6Yaegcea7k7UScwckjF8VE4msW7CMfJYec=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5514.namprd10.prod.outlook.com (2603:10b6:510:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 20:35:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     daejun7.park@samsung.com, jejb@linux.ibm.com,
        Bean Huo <huobean@gmail.com>, cang@codeaurora.org,
        bvanassche@acm.org, asutoshd@codeaurora.org,
        stanley.chu@mediatek.com, alim.akhtar@samsung.com,
        beanhuo@micron.com, tomas.winkler@intel.com, avri.altman@wdc.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Two fixes for UFS
Date:   Tue, 12 Oct 2021 16:35:11 -0400
Message-Id: <163407081302.28503.2529179953085901549.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210929200640.828611-1-huobean@gmail.com>
References: <20210929200640.828611-1-huobean@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 20:35:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f416751-10a2-499d-5312-08d98dbfd48d
X-MS-TrafficTypeDiagnostic: PH0PR10MB5514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB551441DF31F97958F29226BA8EB69@PH0PR10MB5514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:597;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NPSfMXulHPLfjajvmru/ELhD/jl8VqEt0DsQF1cY1+Yc9UxcJdp3/PMAbxIl0taC3ncj9L8PZRUis7HaEZzweVQ8dDWdXNem1HwHT+BtP0R5KVrI6V+xvohwWC91vfY+5tu9f0AsS+UFNxinnnVbK9b3dZi51URFLAFCcQ5/z2s3MEpdTY2bNiu9NMb4WOS77h8baaO2GqeOnqiQyTu1CbydFSS+jmOW5C0ive8KSCNi6dl1EYA4QeyVKzba/+8th6MqJQXIs3j9RGhp3fwO/gNO+R/sSYJI+w/O2mbB8qG4xYeoAyME4FuNQDRbQNE5Ap/p7l2gxnUZyTR8aJ8RhaZeYXb7xaRJHCYpcZJGELZoCN0vrMW3QwPKd80PP15JkyqzUw8KHthI/xzvZjdc6PPCSkSh3NtnnBT0Mpzw+KrnLO5wEifoLgMr0pVPgBf/aEH6y8dx521MIeW6xC0OEAssXPN1Oxff/gV50HoIvJ/osycl+Kq+OP93U/STVz0bUrty6KFDh/Knp1eKjVsU50dtD2ScVNg3ROuCqTy+tj2ovZpILKScnbI1W+9OKMk3OhM0bt1DKr1Xyd6R8+1eAmGpEjPRkBF3KZ5b/mnvmwLqSc198OquyoLLlJl/FKuBQyFA+cN9HbLq5hXQKcrjyl65DRUXVanZlWYH1Qe2ioCB0P+wE6QE87U11R+IGQQ0y1Hnht/nrDyoEpD+XZizvvREEEbOAtA9XTKxXkkSxfJSTI5+4sTMNZ4C5Hwn285lxuwXI6I5BKl0FdMOQPnI6s/4URantflOIy41FZBShIm2DcCkb1UOdUTFpzjynTXDSGAVo9WjBy+wVxfm3soJmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(86362001)(5660300002)(8676002)(2906002)(52116002)(66476007)(66556008)(7696005)(6666004)(956004)(66946007)(6486002)(921005)(38100700002)(8936002)(4326008)(83380400001)(36756003)(186003)(103116003)(4744005)(508600001)(26005)(2616005)(38350700002)(966005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1JtdjEralBueWFNUTBwNDd6VkpHeVpwVFhIb3FuK2VLTkQ5TlM3ZEg3b1NE?=
 =?utf-8?B?ZmVkc3VFVDU4YW1aUlRWaTVEU3d5bElnKzRpQmw0OWtWTDdDM1dwaXplSUc5?=
 =?utf-8?B?K1BYWG9WQ0dWTGtub1NDdk9vWW9uZHpYK3pqUTJUdGJkZWROZXcvOVZGK0dM?=
 =?utf-8?B?WWNEeUQ2U3NMMU41bHJ4OFhzTjJwYW8ycjNkU043d1p5V2JkMUl3ZjlwV28z?=
 =?utf-8?B?ZUJ3RUZUV0xRUDU3WFVvRnFkOHhRWGhRcUFtMHdrWWtFTnM0cHpmVzNmSTVE?=
 =?utf-8?B?dzhSQmJTUmo4UHpkL1Z1T1lpWDdnUE9UTjU3OUJhZ3IzOFBpTnBrVlUwNEEr?=
 =?utf-8?B?WkpETXJGUHMxTDN2Mit5T2ZEelkrREJvcUFDWCtqTGp0SUNmN2d1UTh3dkNx?=
 =?utf-8?B?QVdYZnpzaUR3Vm84alcybGJPb0FiN3RjcDk3NFRyVlJPM3VMRXBBMDJ2a0ZD?=
 =?utf-8?B?c3I5SUk2V3BXNWFHdVgrM2ZXWk0wc2E3VUR5U2ZuZ204TllzSUsxK1BoNExO?=
 =?utf-8?B?dzFSZGVEdUdDQ1d0dUtERTBBeThTYlNLbkVueWU4dmhxMGRDRkVML055aWty?=
 =?utf-8?B?T3g4Ynpia0FqMnd5SkZlYWdxV1VJd1pUdmVYdFBKU0RvQytCaVlkcG9weGtu?=
 =?utf-8?B?dVMvRFhzWWV4cElOWi92Z2VpYW1iZ3FyWnMyeEpnZmd6MGdSVGtEUHI4MXZr?=
 =?utf-8?B?K3cxQ3NlY0pDT1h4VjJySkZIeGpxbWxLZVhDRFMvMFFKUFlvbmZsbWk0WFpQ?=
 =?utf-8?B?RjZrb1p2MEVLcEZIZDFDb1A3anRyNlNyTFMyWVdLeVpzWTZHaXN1ZkNWblh2?=
 =?utf-8?B?ZWxZN29IdWFmRVI5OU5VZWxsb21wb1VXSjdYVWxMS2tWTVMrdllIeXk1T3lH?=
 =?utf-8?B?VTVEVVlrMEgvY3gxSnJFai90N0RWQnNRYzArV2o2NDhEb0R4bnlZaUF1MkIy?=
 =?utf-8?B?NFA4MlI4MFhOeS9lMFZVbGQwSzVKMXdEWHQzVGIwZ2RQd0dENFU3OGhTbEFY?=
 =?utf-8?B?QzRXRjBGUUxXNWN4ZjdUU0R0WCtUT21GNGM4ekt6bnhXdGRZTjd6S2pBbUNp?=
 =?utf-8?B?YmU3MGYvak1zcHFBTitFeDlDb21sZ3htQ3RxbWZsRHI1Nnc4WEk2Z1pZcG45?=
 =?utf-8?B?N0FLVVRQQ29zSVNOK1ZwQTdMeHBuZkM5dFBVV3U5L3pSbDhXRVlUYU1vNmg5?=
 =?utf-8?B?d1BYNkZWVERVcHlwOWx5MDk1UjNpc21ZMkdQcmlvN1dsSlBSR285cWdGMS9u?=
 =?utf-8?B?N0Y4NmpQTkVNQS95d2FJZGN1NkV4bjF2a3NyTlh3UnB4M3lIV2M2NFp4ajM3?=
 =?utf-8?B?S1J3RkpOWFJDRzBidVpvQ2NxSHNtWmtaWlJXMWZheDl0eG5CQ2xSb3dzZWx3?=
 =?utf-8?B?VG9pbUhzTVZhbmorZlNIM2FENXdObzJDZEZsdWhVUHpKb25RSnB4QVlQNTdU?=
 =?utf-8?B?bC9YcEJSZmkrNFRXRUVtd0ZJS0RFRkF4dHRkNTNuVG0zZEhDV0RrMGlTc0Rq?=
 =?utf-8?B?clZ5MGsxU2I4MUMrZ1FFYktBOTRVTm44MGpReTFRbUNuVytGVmJWdHRiWk9G?=
 =?utf-8?B?QW1xVDFGZUEzWDRPN3Vqd1dIQ3dMa2JscVk3RXRMNTNWWEgzWTFJejM4MTJm?=
 =?utf-8?B?d091bFNmeDY3eXIyTDJ4THRmUVBVVVV3Y0UwWW9aa1Rjc2tvY3p6N255RkVn?=
 =?utf-8?B?bGVpSElTYkF1OTNyWDBWVkliU29rb1JTUFZPbnBJR25QR2hXS3kzUXg0L1h6?=
 =?utf-8?Q?6zMfe952xEGlR37KwEpQObQxWJlb1gxH3DUS6vU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f416751-10a2-499d-5312-08d98dbfd48d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:29.6555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dXswzRd8hcTBkoVuNPgAbWa3mPTnm/7QABiRm7feXsyVzG7Hnx7QTeJn9AGyLSE5ExMZDiXMT9d15K7DX7w67cY7mHlpe97/7hlrgLkshPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120109
X-Proofpoint-GUID: ck2SDbT5-zqBaFXwvzn_OeAVEnepqHpb
X-Proofpoint-ORIG-GUID: ck2SDbT5-zqBaFXwvzn_OeAVEnepqHpb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Sep 2021 22:06:37 +0200, Bean Huo wrote:

> From: Bean Huo <beanhuo@micron.com>
> 
> V1--V2:
>     Fix a typo in the commit message
> V2--V3:
>     1. Change patch [2/3] subject
>     2. Add new patch [3/3]
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/3] scsi: ufs: ufshpb: Fix NULL pointer dereference
      https://git.kernel.org/mkp/scsi/c/1da3b0141e74
[2/3] scsi: ufs: core: fix ufshcd_probe_hba() prototype to match the definition
      https://git.kernel.org/mkp/scsi/c/68444d73d6a5
[3/3] scsi: ufs: core: Remove return statement in void function
      https://git.kernel.org/mkp/scsi/c/f44abcfc3f9f

-- 
Martin K. Petersen	Oracle Linux Engineering
