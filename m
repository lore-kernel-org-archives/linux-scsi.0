Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B3DC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AFCD6102A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbhHQDSm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:18:42 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51144 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237099AbhHQDSd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:18:33 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H3CC2O032606;
        Tue, 17 Aug 2021 03:17:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=uOlphYwCU8cMfTR+h6EzFlWDSkeaeQlw2OB0VfD7Z5U=;
 b=m3fspvLhJSCPDatBf2+OYmCjCv1U3+9fZH/G1+jDifwgp9dvmMuTNuAA57Rl5Oj4yVLy
 rVkDPV88wbx+iJdViWL/XqSy26ILOw01oa3jOlDYInjVpbBNR4RqENA17gR8B45QfcFM
 /BlB0ejVK5d3WJnG2hqBbwqCUvq3pJOi1HoeGbe4+XaI4cDCsFHcq6R1aJ7VDml+wZWY
 8G6t8D+wlodQ3u0ncuGyyp34N8At36iq7L8gn+Ahw144BZ5iCtjN5icUcOn262+ZB/2u
 DKEpA53egcBEjFAQx03AqdyvKUtnO1vjnquET0PvyVIVdfJtmOxdv+3PeA43rQiIypW2 4A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=uOlphYwCU8cMfTR+h6EzFlWDSkeaeQlw2OB0VfD7Z5U=;
 b=QGZyz9vvFgHdOSeu+01AH3fwb2oAZCbQcN4YmYd2rjOi+uL0xFCQfqOBHbQxI/QtK2yh
 B3KO59FQurtBfMH5rW4tDb9oTsCVSJfsLq3S/uP2x4mfcnUtbClz6fYK7HCUUU2hchl4
 59wRBMCOwFIKX06XJf2DnplH64XWcukGRjkjBty6UWnN10U7zAQX0goIxc2evmFV7ARw
 ubizwsP44iRPawUmClqBWT7Et6cr8bvepRMhENJxh9ALxk5XNty8TImRZ+f/DqTCCAb4
 jQxag23gMMIycAov06Qrk6PNwKxtdFT5s3nxDWwzqaiODWGz/8Tk8sdbKdlTk9D8C3pu nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3af1q9bptp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H3ArdX184253;
        Tue, 17 Aug 2021 03:17:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3030.oracle.com with ESMTP id 3ae3vetn7c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OonkbxbomqIb10+CNN01Ap3x2fQXBSy4HuHIwF6yRk61K59Glje/TucuYRj4vUGCtuMJ0Gi2mbsU9TiMubv9m9wQO/hDBs7ck7G3nX3WkkdDlr5SP3/1XepiEOgHXfQgfdN3s6EvExHDqIas23+xhr6MgsVghcJTed6knEkT+YzqeNOp0DIBCE1qBo4ZTjB2IREh/zZKA4cohaKRYAwGCz5k/OOD84aFV62zVK6A3uKEa4GAAavHqnZhA+FsjUHBngZZo6ZKd2MRCuPF265zqx2Hyfcm3CKCn1w2YI9GCVx1+SiStK6uAeNlF9cdkjDOnRvDuWnIdS4s8tFw5nbEpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOlphYwCU8cMfTR+h6EzFlWDSkeaeQlw2OB0VfD7Z5U=;
 b=CPIoEXCE4dn+Fnc1UWdPYCEQhUgCuJ+DzwEFTUs63B1e6U9WWigrIymY2xNGNtR2x7bkcVzhGNO8mPLFbaosioCumUn3DrwOGmKeS6Z6mwzUQgNawcloL86DzyORbWFnKzXhUV8FBftFZ4HdqBsOKx4jRIAWfEyKMxqRHt8KQFyGnwR1d4Kn3v4sE1PXMzxqp7LAc6bJj+5wn8/aKEnRemspwmo17MKI7SB/Zf714tYJMl5/iGdWyQ7qnZJ+zNvIMLQr9D0xyiL+/gn9PyBdD0sxyqqQbSjc5KS+9gLYH1u/LpwP1NSb6wnB4+3NDu1kef8arDyREyTifsMV1ALYRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOlphYwCU8cMfTR+h6EzFlWDSkeaeQlw2OB0VfD7Z5U=;
 b=Y5wD5IROk/6CzkvSFRo+9qYvckU/LLNYnZm6otGThA9R0aDMDJ7R4UWzFa4UkmK7kvNCNuy2VecCVi5C3xcihIEC05qh2aBrmwGGgDXyjJb0F+W/9+MEZ9OgwSjo/mscoNDyHaHjZAz17DCq3VVZL/OlNBZkuEVjR0BP3W8GOQY=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 03:17:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:17:54 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ondrej Zary <linux@zary.sk>, Wei Li <liwei391@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        huawei.libin@huawei.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: fdomain: Fix error return code in fdomain_probe()
Date:   Mon, 16 Aug 2021 23:17:39 -0400
Message-Id: <162916990042.4875.5046983665520581228.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715032625.1395495-1-liwei391@huawei.com>
References: <20210715032625.1395495-1-liwei391@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:806:125::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0178.namprd04.prod.outlook.com (2603:10b6:806:125::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 03:17:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d2b0573-cf53-4f82-55f4-08d9612d9a54
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB459772927575CAFA6F3428FC8EFE9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 07JmDRkKgjdHEFzCu1UixYvARhueSS9BtTx6j44ckVnhJe/tx035b9tN0b+BYuTTxYCFfl0rnVMqJ7LsjLfd6u221w9FivGdb0zxq0xgEantcAcTbqUutNfm0nTffn5uW5YWDSuXxafATBIYwW2j7gynOHatdUELGOLAKHoutz9Pof37pPMgxtv/oUeamHoU+tS1vfb2VhMAcagSzrevG42a5D6QtTOvxUtEKuHy1xGygJIoEANqGsuzcGCMDeg0Kxo5sS+Ue08ty3/ddijxc02WXX62lIXhQ2e0mVR6x/k53m6GwEV9sG8RZoGDi84d4XhOuzuJel4hKp6/V4WoGymmge8+nHYtHiVsx1funacvW/90C1QjsR/hfAnwiYXco2j88u6AuYEPqfzlTMa0oqrUWjazSnUpSt4TJKjWMGh1bDb+p8AFOsLyDCLDXVOoZ0JYgYHjkuMyReOX5TFKzMjFMatR9EpD3cXaf0wa/5/qW1OqtCzKNtz+A/TuXlQzMhxrTbgrV4H9J8RQ9wa5Rn53RFdyEh+szHC0S3jOhoo/NQ6KRbKuTa7Qrh+jzL/5EXjqSyEaTMXGLSGVsd51UHA5+qoW4cASHn1YEDdazAbLuZE4LAnG+tPzFc+lNMdcEaU3SpePors/gXzyAkAZzQjc2GD1OaOp4FCI5xyqwgV/8RutnZmNwzrsbe8ONd9mtEjk9eHQIPeCJS7++81RrgA/quJD5mIe7tKmevju8zpniY+4c2+rkPAzebztK5fCHppUjGQUIwtwW6UEhi1siA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(36756003)(38350700002)(38100700002)(4744005)(66476007)(2616005)(316002)(66946007)(8676002)(956004)(26005)(6666004)(86362001)(6486002)(83380400001)(66556008)(508600001)(4326008)(5660300002)(2906002)(103116003)(966005)(52116002)(186003)(7696005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXZUcGl4RG1aWUtxbmlpK2VCOHhxdEk0ZXhnZXpLN3I5czlRYWVYR21RRXE5?=
 =?utf-8?B?NkRIRjI0U0hURHpPeUxhUnRPNXk0NWFxL2twaHNKdVRINGxYWnBEbU9TMW1G?=
 =?utf-8?B?Q0lrWXY2Y2dVT3dFTHFUVzU2Zm9mcWtPZlBTcXZtY2NoUDJVaEV1bWxJQVNO?=
 =?utf-8?B?cDlOTElINnVMZkRmYUI0NDV5dDVhckdDbUtHZXhVN2lzUXFyTWRremN5ZUhV?=
 =?utf-8?B?bW5ReWtYUEE2QTc4RFNxSTcrc1g0MmZGbkR0ME5id3F0blpMQ0ZTSWxobkpF?=
 =?utf-8?B?bUlCRDJNM0dTSHFUUEU4SWs2Nm1UQitONmx1K0FvZ05scmRHYTk4SGZvRWtP?=
 =?utf-8?B?Y1hXQUNZQTF3REpSNDlmMEpOamZLMVdob0pLdjVqTHEwVlUrWkk4Vm9ZcnJW?=
 =?utf-8?B?UnEwdlZyOFA2WnlrVEFVSG85bTVlYkh3dm1PMDBTN3ZMd0RLT2IrR2pIUVh1?=
 =?utf-8?B?NUxSd2E2RGlqMFlURTVFa3BRMFlwZnRRQm5oaXFQQytqaUJ2RndWbEVFYXRY?=
 =?utf-8?B?ek1BT0Zid2lySmtVR2ZHc2ZBcG9SUlBIVDI3L25IaGRaNExDU2EraFJCTGxa?=
 =?utf-8?B?eWNZTU1Zbzd5QzV6YkhZekNvT2U5VEVvL0ZBUWFTNWxjTExmbEhFR2Fxc1lG?=
 =?utf-8?B?YjBuTlNGSWUwQ1B1MHRRNTRMVmRqUWVjVFpFN0VtNzgxKytPWHlUL1lmWGdG?=
 =?utf-8?B?N1BzVHp4emNlVXgyNnJpNURJK0JmaFJYOGdPNnpuNmY3Z3JqMSsyeWhMYjZ6?=
 =?utf-8?B?UU5JRTJTQlkxZElnNGEyWTRTSlp1M3lHdkcrTXNZdm9nUDFIeVlHbS9RNURs?=
 =?utf-8?B?My9jc3VqS2hUOWM1czVKenhIckJMZDRyK211cFVmWHU2NmIwcjBSdXVweWVU?=
 =?utf-8?B?ZUwybGZEcWtPMUxWWTg3WWZFNlBaclVFZFB3UHJxbnB6K3hUdnFxaGY4ZDhG?=
 =?utf-8?B?cFZta2dCcmtnQkM0OHlwOHhqNXVkUFM5T0ZaVnZ3SjRlaGFneWpOdVpWL1Yy?=
 =?utf-8?B?eTJaSjhjUjV6Z1VyTnNEQ3pvcXAxQlEzNjlGUWZQWE83Q0NvbUJya3I2RW1s?=
 =?utf-8?B?TGZKNUhHOUFKSXNlQ0VYeWhzSzZsbFRYOFhXMmx5bFRXVCtFREVieVo0Y1hQ?=
 =?utf-8?B?Wm5vQk9pNmtMOEtGeU9qcnFHQ2RtaXpYQkN6VFNFR0xWTWtwY0pzaTBoTS9i?=
 =?utf-8?B?Ull0ZTlrNElReUZVS2J6VEhuaGk4RDl0L3Z3KzBBZnBvMjZZd05abGNiTFJL?=
 =?utf-8?B?MEpTeWM1UEppYkRSdDVjZjRnTlRnSnlkdHI5ZzlBSmMySEhDTVRFZ3dyNE9M?=
 =?utf-8?B?bHpjZU51RE4vb0Q5YVF3L0JKZk40YmExdnJ4N2FvNEdHZXd6Q2pnOXNid2Fp?=
 =?utf-8?B?cnRPb3NWSGpIYlpNa1p3WHJpWnpTeVZhWEZ3VFgwc0lCclU5Zjd0Uzg2K25F?=
 =?utf-8?B?ZzhCZkUvWXo1a0JWcW5SL1IrYzdpcEFKeWk5UkloUHVZekl4MWxJcGlaOVYz?=
 =?utf-8?B?RWNWazFvMENLMUJRQ0JxaCt2QWwyM004TElwWjdCSHZZa0hTTEpFazYvUFp3?=
 =?utf-8?B?V09NR1BjY2s4R2NYOE41b09vRmlDYkJkZTFUZTYyRnFDZWNwSFlyOWN2VTNq?=
 =?utf-8?B?eEVtU3FQdVF5aFlPMlNKYlpjdkp5M0ZWenp3akJLc1RNck1BdUJXVTVKTi9s?=
 =?utf-8?B?c0lTd0Z0TDJYbXErY0dBQ0xHQVZ4Y2FqZ21mREJOOWVHUWU1VHVYT2d5WTBr?=
 =?utf-8?Q?LXnd+ZF3w32hhL4x5BgoZF6UvI29e4dDYeE6nya?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d2b0573-cf53-4f82-55f4-08d9612d9a54
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:17:54.2178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nDbKPM+mLmHUAAba2krSPYz5ZyUjKE5ABTDHvGhO8NwLLtbVtx/eTw1UHCfonG+uBb1af8N1SH0/AqmKgNq91DYYwuOYcsHateSlzeW0nVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170019
X-Proofpoint-GUID: RAEBje7VML0ic3j0c1rJ1mv03Ua2_yCk
X-Proofpoint-ORIG-GUID: RAEBje7VML0ic3j0c1rJ1mv03Ua2_yCk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 15 Jul 2021 11:26:25 +0800, Wei Li wrote:

> When it fail to request_region, it just jump to 'fail_disable',
> while the 'ret' is not updated. So assign the return code before
> that.
> 
> 
> 
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: fdomain: Fix error return code in fdomain_probe()
      https://git.kernel.org/mkp/scsi/c/632c4ae6da1d

-- 
Martin K. Petersen	Oracle Linux Engineering
