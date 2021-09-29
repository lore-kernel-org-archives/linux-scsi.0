Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E788CC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D19BF6135D
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244101AbhI2EWJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 00:22:09 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13740 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231405AbhI2EWF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 00:22:05 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T3GOFC017401;
        Wed, 29 Sep 2021 04:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=oBRHdwkfRalg0cyyxywf1WfitP1opDYvTxlQEQ3IDws=;
 b=c92oORB2yfDxpvvAfNY50yJsSwIPIp6VK3oA1lqwlMRAMix6X4HFaDra1nNphN6i+aB+
 HYmg9NFeuwBlrBYMHvfJhVtnlwlyoq+22cWhi7GfzPGwPkvcxvC8/bgW8Kz9eAWTsfPm
 VOW/JlukZ9Ntd977r0Aijt+uQctuSqLbvQZk1VDYypZ0e8jqow1JwJUHtRXoJkWXIRCT
 d2NPvOoSoWRX6xC5wRC7pW4kWEaNVZxZcatCw15kVi2NKidwzvLkHo+KS8nY2Kjz+0Zk
 MHqje0vvNgHhgUhuHEbWPkKibWkm80eDT76HD6q/hOeJrCu/xy+Lbg325WqgJ+VL7E/9 lQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcg3hg7ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:20:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T4AUVB030883;
        Wed, 29 Sep 2021 04:20:23 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3030.oracle.com with ESMTP id 3bc3bjb7h0-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:20:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxVqdALGkRb4AR3kPHk95AV+DOWqKXc1qKtLCbVxKAEeBzAaErJm/cfbAnY5NhFAk69SKTSjLCoHIPN9HNRy3Mfkm+EUtKYVsQiorlBQXQATV5FK22X5zSJos7zn+CVqihtQCfPOyPBbtwj0xq3/igLhOECXnJVHCJqtORrBYVsRRWdFZjesP3MUsFwdiQeCmIXwYw6pl4l3YOaVe03XWYNNDj+qzn8HPHGU657oHuNGFJ9a9rpKX6OXvXR56JUt/Fyw9jraAVhJjmm8z4It38v3+Hjnf8ArCN8gHgi95Blf/ZWxJcgpYdNb2vlwwGLiE81+m/WuzriGd6YkoLTAnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oBRHdwkfRalg0cyyxywf1WfitP1opDYvTxlQEQ3IDws=;
 b=Q1bGEronX2tTndpkzFNX0KRVXvFJ45AhNc0WTlk6nAgKfCLOcGmNrFoX6FbNwK7PWkG0/zZxJW8Zsm/aBpsXn5uOV7TIbK6BPBPv7gTmN3njalYDuICBqc+tcA2sQ/7C/VS2QFkZkawKUzZfdnxVYsF4QHeDSyWvcsGj9s2gkfaZXqMNwAxjCBYqnEjiDVzacSAaxSKio6cvtrO7dBKfQ8qHUlyEQPLJ+RJbRZoOv668MGyIR2jkmGElAmwyi+WC3wGQhpMoGbqdkK/A5OCpL5nSvZhI5ZWPQFgK6GvrwRYBGJhkjd6aS0rUddnkMgW17Zt5jw13Tol/yrtCsoKoSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBRHdwkfRalg0cyyxywf1WfitP1opDYvTxlQEQ3IDws=;
 b=E0wRzyZKlf3xtdNxSqcXndzCGHaUetJ3ZKho7tIPi5kaTaPOy4b3/qfGdi2rJ2z5d7nOewVbjTNHPJHDE0D+GuUbnnhWiZjam33TMSfbp52NkvCf7AVbMU1W1gxrMIxrI0TLyX6CtXTGKFtA75mOPgXWVAA4x/AeX5H5pWAGlqk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 04:20:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 04:20:21 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nigel Kirkland <nkirkland2304@gmail.com>
Subject: Re: [PATCH] lpfc: Fix mailbox command failure during driver initialization
Date:   Wed, 29 Sep 2021 00:20:15 -0400
Message-Id: <163288294653.9370.2089338782373821326.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210921143008.64212-1-jsmart2021@gmail.com>
References: <20210921143008.64212-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0056.namprd12.prod.outlook.com
 (2603:10b6:802:20::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN1PR12CA0056.namprd12.prod.outlook.com (2603:10b6:802:20::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 04:20:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 725a9f4d-2cf1-4127-8141-08d983007392
X-MS-TrafficTypeDiagnostic: PH0PR10MB4551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4551087D7277E4F72FC00CF08EA99@PH0PR10MB4551.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aAo55/i8j9nEoVT9hn0mQ3ljYu74yxTGlHKPDSZd7Cd2FSUIZYGsPr6AeEYXu+A6HzbeJFrESMnW6eTiIQ2dz9Iv7ta0bLGSCvOXqHrigkczU0vhJGO5Fot7hzP/8kLR6TQky/Qqr1SCviOjZNJwsn5/ppgNHiuGK1CTppAzDnGV5WUILNDncsbEGz8/ybv3z8e34Wuh93m/+u6Q3pi+4L8JXNc94zk/x9QDk/NCIpwBORNCOy+BPiHSp3VhYIlfxcCEubXYAF68R6LTRPpESPzumhoKOvcQH3uIi1kf6d1BOCySYDqJnhMqSTpvSne/mxB5t6sGFyRjBMs2qC1qllrPigYYCVlaGeXyUVk29Zj5y9hVwrvpMuku8tyibiEuWF8o2+zPHFaFvdyt2ofGTZXYic6pcrMeOJo8OEY++d33OQOv4CJQJWDdPPc81HO7vzmBhnuup1+K+A+SvZcQ3CPPhYcd652v6wwTNtlTes8zRlWfi1dTCOYFO1D9DDuvQfFXbW1Q6/gTPmBisDnlGYVqZqimVHQtqvom8CpKDB6B0DRIYFH2GNJWkjdDpGC+ZWp73xrECGjRcvlb30+pz+pDIpKrCaWEqkncazxvyztKZ1+sCc9sx8TOpkTxvU40bQ2fARKcCVK2A3ytu20FpUCcx+Hd5B+MVtFbq5SxVuaQZcZ6hyJfD+4PACUgR4nednNHAWH1ozog5dDNL/Uy18IVItDrbTowy6Ykmuc/KKRaZOuKh+6apQ84Bs7tFyrLZudIoiqFDGLF4+ZBy27vIp6fv9FWP7nVTm0KTxsVnWA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(4744005)(966005)(6486002)(36756003)(103116003)(956004)(316002)(5660300002)(8936002)(38350700002)(38100700002)(6916009)(2906002)(26005)(508600001)(54906003)(66556008)(66476007)(83380400001)(15650500001)(186003)(66946007)(8676002)(4326008)(7696005)(2616005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDVBSEovS3VJUHZjUGZsVEFnSklQMFNRdHRmMkZpSVZHTFJXNWgvMTExWTQ2?=
 =?utf-8?B?WnZZQ3ZaSUEwNVlIS21zLzhGazRrdFR3ZnVvWlpyU0NmM05jVG16UkpNdkNS?=
 =?utf-8?B?UzlxWDhJaXJkd1RUMEJWalc3Rzc2aHdEamxENEgxTERMYkF3VVpTMVJqQ2RF?=
 =?utf-8?B?OG1STHV2K2VXTXZhR0hSNXpuR3FPVWhQVU4xNFlKYWxGMjlMRnFBOTJKbUlz?=
 =?utf-8?B?c0xsQmN3R0EvV1A1MDNoSnllL0NubU53cUNSQnd0RnQxazV5RXE5U2psMU1Q?=
 =?utf-8?B?WTBHMmNHTVQ5Uk1nV3ZUWXh2Q0g2UWFpWWptWWZ2cnFqbWlNdlIxeXNOQzNa?=
 =?utf-8?B?VUw5VGlzaDI0NTA2ZUMyeEtqeGZpbEVYZHgvV25JZDVicEtGNHdJTFBpenNO?=
 =?utf-8?B?WnpFMDBwY2dvSU1zdkV6bjBCcFJQclo0ZE9ra0RFMW42RUNVL0NXV0c1TnUz?=
 =?utf-8?B?YldCR2FvRkpPcDFMZFFobW9EMHZlS1p4VW1XL1BFMWt4WjBsT2prYnlYU3Vi?=
 =?utf-8?B?WWhVaWx0VDhuWmFkRnlnNmEyT1pDbkN6K3VWQUFER2hqd25LVEVUWEtwT0M2?=
 =?utf-8?B?K01sZUF6dWs1NmhaL29zMXVnYldRV0pYSFhhSXphYzU3U1g3WnhwVFdHc0RZ?=
 =?utf-8?B?R0FYQlh2elBPMzdSZGVieFdkblVFcmZESmhiclU4QW5TRjloeHpST0RLYjV5?=
 =?utf-8?B?OHpxQ0tpdzgwL1VPR3BhRnFFTmlJT1cwdVlKcUhsWW1wU09mYkZjQllZa2Np?=
 =?utf-8?B?N004WjU4dGZ1Qy9XUTA1SU1yc2NtSlpDeDZVSWNxaHJSakVzdENGeWxSb3Rs?=
 =?utf-8?B?eGYrb0ZYbFp4S3FwMGhYSmVaSHJKUTRDNE16SUZDN1pKUWpxWmVVeGt1RzZI?=
 =?utf-8?B?cjVwandzdlNYVEx2NTE3Y2ZRTlprS2JVY3UxSk5MNVllbzNJclp0ZDdVeVZx?=
 =?utf-8?B?SjFDRVphVk9qYzZFUElaTWRQLytJL0pGa3lCSnZKWkQ0aHBVU2lKL1JhWlRL?=
 =?utf-8?B?S1MwZkJodmR1QWdOL0NkMXJlNE9OdVJkOTV1QWRKY0RTZTQrVW1rZk85bU9s?=
 =?utf-8?B?MWhJQ1dXZUQzZWsyb3pGbDByQ0gwMkVjUEdhSTZ3Z1YyaG5hTjAzRC9uWmda?=
 =?utf-8?B?dFVrdTh2eFFoV1dGNk9udmRFeEF1c0xHYk1HL0NxdmlsR1crQ2k1V3BZM1JC?=
 =?utf-8?B?Y09FRlFmMmVOOFgzUGdqdGdMcEZLd1VYTy9IZ0Y3STBUa0lZZ1pYbk4xbkcr?=
 =?utf-8?B?anNiMjlPUW9RemNKSTM2VVEyRk1EV0QyQnQ3Qk1EWXlSaTBjVGJKZGRwSGV5?=
 =?utf-8?B?SjBFcVpOajNwelhaRkE1NUpTcjJaVVdpcnl6dFU1TlM2YzlpQmVxajRpSEcz?=
 =?utf-8?B?dk1LN2JWWTM0ekNVamZMYnBVcTZqUmZSMWZUWnRidzZwRkczeTNFYUtYM0xk?=
 =?utf-8?B?ZStqWFV0eStpZUxsbXg1Qm1GS25WVmZlWlcvTlhtenpPTGR5SXcyeis4c1h2?=
 =?utf-8?B?V2NyTlEvcFBQVEE4Qm9vbjYvM1U0N3ZWMXAwT1R2V21jbHZkZTdvLytGaGFu?=
 =?utf-8?B?S2VsbzNET2Vxa3h4QW1ybHRHc0E2UkEyYkU3VTJFdzVzdksvYlVFdWRjaXFz?=
 =?utf-8?B?dVZ5Q3NiQmdUSzJNTE9NUDVGSXVDN3IreFhUeWpZQ081elJKM1lEVEgvOEhL?=
 =?utf-8?B?eHUxalROTmxkWTVyc1UxN1lBTmdUR21EcmVKTjdHRUNWbUhKRHBRakNXazh4?=
 =?utf-8?Q?/FAHuYt5PWDPfJ2L++9UwtdWeqM6NFLJMdRQ/WG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 725a9f4d-2cf1-4127-8141-08d983007392
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 04:20:21.3398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQ04hRzjGobokLAu1k2xN7UEj1HY23TVIoMrYPG3/d9/B+zzpjQZLVdjNX+OZJrcI+aODJJhPf7Sb89CB8jQVf5+zQR+MOonc2wdkVqcUfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290025
X-Proofpoint-GUID: VVyobUisA0-Mvc6PyYPFFIfQvtKJcw83
X-Proofpoint-ORIG-GUID: VVyobUisA0-Mvc6PyYPFFIfQvtKJcw83
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 21 Sep 2021 07:30:08 -0700, James Smart wrote:

> Contention for the mailbox interface may occur during driver
> initialization (immediately after a function reset), between mailbox
> commands initiated via ioctl (bsg) and those driver requested by the
> driver.
> 
> After setting SLI_ACTIVE flag for a port, there is a window in which
> the driver will allow an ioctl to be initiated while the adapter is
> initializing and issuing mailbox commands via polling. The polling
> logic then gets confused.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] lpfc: Fix mailbox command failure during driver initialization
      https://git.kernel.org/mkp/scsi/c/efe1dc571a5b

-- 
Martin K. Petersen	Oracle Linux Engineering
