Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E217FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C86436136F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhJEEhE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:37:04 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43684 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231462AbhJEEhC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:37:02 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19538v0F010243;
        Tue, 5 Oct 2021 04:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=XPKoqmGp0SW+Bf5GfeEoSWJ9SyI/R25ecDTk3ts/iMo=;
 b=eO7n8FSQOfMyyzxAiHLOOUcITzw7aGqEBi8QEDB52UOGEOVncweqlTkeVxjG+IAdvlDC
 BDN2iby4LO/limgmjjTdfG7GigeU4GKdXHCd9SOCIeBrC7LnlBH5AgCwq6U8oN8fl4MT
 T1/NTSKD/56ZDMQWi10rZUvfDvRVkJbCIxvKC6OOK7LMnwXnJLDVuDRE64N6b/TwCnfT
 3XtZ5/xDQVT8hej4U9Fwpa9bmKhEuJxMDAl8gPfrUgKB98CsZsE9qa/Rc9lyTdM7LgXv
 tQ7ZPXmJKGuIfjmtn/yiZ36C9N9eCBZ3uwoJL+7U8J8hEXiW7uZcr4sjn88fRxuHsSTC IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg3upvr1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UJMZ054346;
        Tue, 5 Oct 2021 04:34:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 3bev8w4hvq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENSOOPrSK02/BVy7sxV6edQkaF6L0V7adnuRa76lIV4dvwYwNBikg0wVsatnFNO3TBltmlKrIYbsQJocXHd35hPAjzpR2yiFYQxGizal50Or8YFdzBsnvkc3aXFPjOUBOfrI2t053G+JabhPctHXmYCIuzpuZsBmdkYUuwam4HqPkvAyREooOiDDAf9vs4dxzGjLkMvHTwMtdmuGy142RngGm40xbXPcCCZX2YmDhnap3LoESsMvNKEcNpbvmhYQoYFB5IhxBFiuJpsIerhoOSKgMtSeTPhpVNqgsa8ZqJcX3Ccgzj2rA+ce/t9b/AgVli5EeehJdsvVhV5zPGMosw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XPKoqmGp0SW+Bf5GfeEoSWJ9SyI/R25ecDTk3ts/iMo=;
 b=dJP/9eT3v7S1p6Ucqz3nPSWJOQ4PpRF15q+sSKWDPskRIzFI++kAHTeAbcRilH/fZrt307v34tTzqxmdI91+nbc5/KXjYBRb/J6id224RQZtBPFpFOsYmZgt0TzqdJaENEu0xEbXiw1SScExNZ6POHpvuV1YANL+sr/Y5U8uiQYhwsMhRhZp1M+7B1sGxRum4fJilM4oVavTzLTCw7+iyhNaPJQ21c5DJPdcbbVKd6AFJh1UIyb/ZhCKsHkOpdkRyHZBQBP3UxZ0YsTIZqCs5fubmuWqjThofxkSaeoKBt3jswfb/9JXKZlVD3/jysu0XCIMfAbx6o/XH+zvhhhY8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPKoqmGp0SW+Bf5GfeEoSWJ9SyI/R25ecDTk3ts/iMo=;
 b=rSdmYx57y9kSoOkhrHSp50Y3/j097mI8vJDxe6qA/Ut4AwQH451ES+D0HRF8keSfvvkB9wxYbSanpp/cYUdzxcAsKI0jxRG2Xi/ltGY/Mh+8xyWZhlNYob/KDSRSQqrST9rRBDNeyMRFBNB9wlMVtWGY4SmgPCUzkZq4Do5LnRo=
Authentication-Results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1950.namprd10.prod.outlook.com (2603:10b6:300:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.20; Tue, 5 Oct
 2021 04:34:48 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:34:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        james.smart@broadcom.com, ram.vegesna@broadcom.com,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: switch from 'pci_' to 'dma_' API
Date:   Tue,  5 Oct 2021 00:34:32 -0400
Message-Id: <163340840530.12126.1336869064595467674.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <3899b1ed4abac581c30845d82f33ec6df8b38976.1629633207.git.christophe.jaillet@wanadoo.fr>
References: <3899b1ed4abac581c30845d82f33ec6df8b38976.1629633207.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:6e::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0001.namprd11.prod.outlook.com (2603:10b6:806:6e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Tue, 5 Oct 2021 04:34:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c530970b-d7da-4758-8f76-08d987b97689
X-MS-TrafficTypeDiagnostic: MWHPR10MB1950:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB19508AAE59E14A433E43EBB98EAF9@MWHPR10MB1950.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lsvsZeHHxaEIS8xWQQTCQeM5cegwcsU4CYW5tp2DU2qEZbN7qLNv642OAMXuWTJTF7ZBSKUdsZ+n08ibrXKJESavqcXizvckY/lLRMh1cK/YHWczEqbEYiNAvo1O8V/XxFVm5TiLlsw8W8excHnWdIgQN5vxb8HpiGutPtXj0mT7D/zpIoLSIX5ZXONidZNcaFJi9EPa5OzdlGS+nDQMK0q2d8pkrLsRcwHx2y0WDS2d1079EXJCPXnV4nuU4rGzc5M0c1i3xUYxWD5gJdZ8ad1Tk7awt+dvZzJffqSVcdmllJBqwHEtW6HabCBuTpSrePDSQIw769Bq2jzB2XcO6rZ39pBeYxBCL+o0CGL/JjyrwJx6kyBIPb8EnNuAgFOpdr72Yeug0ZGrvu3LjsMVGsdKtTpJZ1Ejlfz6NGX0Wr8Rl18BPsJQV6U6rfYyuF9OSSKBHlUSfaYxus3Lt8RWNnRaHj6fin4gkRmRh0fla/kiQd98kuLuDjl4U8x6C4Al+4yq1agyTK0ZfJpkNvJcI7y/upzWLlTr57iiiXvJYVAnV3oQT2SvFU/M7+p9FuVMOwAx+j0DBscJvrmKaixzxsjQk2lcSCNW6PwA5++h0sh0l7q0q6Xtn5EK1xxrL3o1HFHm355ZzDw/8r75eOqDIUTPQVM3BMlklkS4DjUs/cMK+b389UQgJRezc+H3NPIKsbQedA9LMOsjE11A96p7ApVWVld9+KvpQdGZ8ywmChF7Mkta/JbCag3SaqG6MgUbaScpzGnm1Plh7iWQCsRJaCf7LVxRKL6MvSu6/PPr0Io=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38100700002)(6666004)(956004)(5660300002)(6486002)(36756003)(4744005)(38350700002)(186003)(26005)(8936002)(8676002)(66556008)(66476007)(103116003)(316002)(7696005)(86362001)(4326008)(2906002)(966005)(508600001)(66946007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2NLYnN6ejJFUUtRd0NIR2xHQXlEeDdCdW5GcHEwNnRHR0dnNmxkS3cvZ3dr?=
 =?utf-8?B?cGVLbzlYSGRkWmZWd25oRmFFZ1o4YXI1d0VHeFJRZU0xdzY4a0tBY2xFQkxt?=
 =?utf-8?B?aUpiY0U0a2Zwbll5dGxHc2JoWW1CTjBrQlRxb0dKUGJvbVVJWktFWElVVHBK?=
 =?utf-8?B?Qy9WcnQ4cW52SGY2TzNLQTdiMVhMY2hlSE1wWG9sanRRRFo2enh3bFpwZTZa?=
 =?utf-8?B?K2lDV1dFQmJZbFlUUzdnQnRpek9rOEdxOC9NdUFNK011QTZHVlRRdmZoK3pp?=
 =?utf-8?B?M2N5TWFpbzhNY2k0a2E3UituVVNiS0MvUDlWV2RsSEQ3VHNLc1RiU1g1Y2ZP?=
 =?utf-8?B?MVNKdkFYRnNRbU4yZDNkdkRpYXI4ZlVncnU4V2grOXNrL3FoL1UzUHBsVFRQ?=
 =?utf-8?B?UThncW1TNGY1aVp1NE1RSWpvaGUwQXAxZ1pDTWRDN21lQ2gvVUY5a2syRjhP?=
 =?utf-8?B?bE5TcGxRNUszeHp5R29uV1RhVTNlU2RDSU0yaEh3OUFkb3J4S2tmWDBTWlNQ?=
 =?utf-8?B?YURzSG1zWi9hTTdWallzaVFFZ3pBMmlNaHJmWFhMN0xTZDl1Q0xJUDd3eWJJ?=
 =?utf-8?B?SEkyM2QzQUVnMXhQV0tPSm9PTm5ZNnJ6MWlHLzJtUUZwUmlIMFpmMUdTK1ZL?=
 =?utf-8?B?dkxKZUJoWUVtV0FUQU4vU09EbHA5WVpGelRNN0xYaU9KVlplZ0lLLzJwMVhK?=
 =?utf-8?B?L2lLb1BvcjcrY3hyTmRQQ3RXclBnSUV0cnJsK0dsclA1MEU3ZDN5dzd6QjhV?=
 =?utf-8?B?Wkpudk9IZHhwY3JJV0NpTktrOWxXWmtCVnNNcld5bUl0dHdXUUFwTWNFdC9i?=
 =?utf-8?B?YnQ2eTBoTU5id2ZwbVdRRjBpWTBzTjlCZ1lnRDlVbTE2U29Gdlp2RjVTY2xo?=
 =?utf-8?B?VmNBZVNkZHJCVzlJNzMyL2gyYWZZYnJZWFc4bm9JUlZnbktzOFhyT0t2eWhR?=
 =?utf-8?B?S3BQM1gyWHpCa0FwSkMraWtzdGt2RnpJRUVIS0hna1pqUE9xSENjeWFZT013?=
 =?utf-8?B?azFUMThOOXQxYWg0RUYrWFVRN29odTdzQU1CSkIyNURHWkFhZHhkdURxMjc3?=
 =?utf-8?B?anZhOE9WRDFESnpnNEQreWY4Qkxib2pqMHFReEVGcXBvVjhHdWNzNmlGZUVE?=
 =?utf-8?B?Rk9ud0FpVWdZQzFNaSsvbWRKQXF3QnV1U1g4S0U4ejVBL2JiY3lOWGpCVU1C?=
 =?utf-8?B?VFFkSUdFTzB6L2k3OVZGVTJvck9LWG9OZE9LMUE4Q1F2alJPd0Q5Y1JEMHZX?=
 =?utf-8?B?U1BkMGR2eDBxUnpLeDBMYUtNb1ZnNnZ3QzhTUHMzaWhSOW9razV5RXovUEJm?=
 =?utf-8?B?THBVQmFQcmRWZDFsNE94MGVaUXlSeFMwWXI3OXpCSTlVckFUSXE5T2VGd09y?=
 =?utf-8?B?TlU1UlowaDZOdXZIUHE3eDVxUVhYcElza2Z5b2JITkh5d0lhemdOV0dTZlFE?=
 =?utf-8?B?LzlaaFlGTlZpeXo5R2dWV3NycWVCSkhsbisvd09MVHczZldrMzl5RmdwcjJY?=
 =?utf-8?B?eVhiSmxGV20vdEYrMnhCR1JHazE3OUVUNzZwdnUwWDlZc0FuRUdNblFpRkpx?=
 =?utf-8?B?VlR3aVMwRldtQWtSMWVPdXBsNVg3VlAydlFsNURMeGlqVEJRMVRPbVRsSGpt?=
 =?utf-8?B?U3F3Qmp3OVRjbVQ3eElDS2o1RWJzazRhejFMM2k3dlVoa0RyamxCV09KamRJ?=
 =?utf-8?B?UHp6TFk5endPYXArWENPS2lvM2U0eXBFWktEMkRHcG1udWJmNE10N0duSDdw?=
 =?utf-8?Q?TVWXHYFjjJmC0SWyLuQnv0aokBFMoWybZSvxG7o?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c530970b-d7da-4758-8f76-08d987b97689
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:34:48.0407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qT4PSFwa+1KAxcBqfHRMOAqGiEqxorqcY1MU2iL0qGFRd/TOl6r2qLNmuMmKqfz+qkgcaiJZ2QMnDJFzVn6tgD2KV9xSgL3pAvVOyxd9xsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1950
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050025
X-Proofpoint-ORIG-GUID: E0VAdB9l4WvFJEKVHG0xgaRMD21nSrCa
X-Proofpoint-GUID: E0VAdB9l4WvFJEKVHG0xgaRMD21nSrCa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 22 Aug 2021 13:55:33 +0200, Christophe JAILLET wrote:

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below.
> 
> It has been hand modified to use 'dma_set_mask_and_coherent()' instead of
> 'pci_set_dma_mask()/pci_set_consistent_dma_mask()' when applicable.
> This is less verbose.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: elx: efct: switch from 'pci_' to 'dma_' API
      https://git.kernel.org/mkp/scsi/c/ca4ff9e751eb

-- 
Martin K. Petersen	Oracle Linux Engineering
