Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A42C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 03:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83FDF60F9D
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 03:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhKEDfl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 23:35:41 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61602 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231834AbhKEDfk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 23:35:40 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A52jM61032481;
        Fri, 5 Nov 2021 03:32:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/SyeGIj6eNAQAnGM1g22xvSrHsaK7rarZJnoJVyQP7w=;
 b=zBfDeDqxm4gOiH0m+4pKQI+Yrhs1mGMAeDsLtXMluwhyeg4SBooNNdB1IOCfkyZd9ugD
 4QVunqMpu/iXxmDPTcqnmxGENNGQ3rm457hzNl1EKdRHsSwun2K/Zj2QOLLI2dOy/TaZ
 4ijKW2Mt53mxVQzfRS6q8EvZgxSTI8nZH8lqOg3hociGYLOHglZxVmqY2wd5lzdVbkI8
 x5kNFvifp8Us2FGaZR9l+ymKCFDw9eaAi/fZWe/MbMk9bG0trprOWGBeip2KfPJ6ZPro
 xrFCO1IKOJKvru5TW6JXRIzgkjOyNatPZA6DYNry5spJgJ3tO4qIKaidjwCE+ftHjme8 Eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7q0hwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 03:32:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A53V8vG149961;
        Fri, 5 Nov 2021 03:32:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3030.oracle.com with ESMTP id 3c4t5cdf6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 03:32:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADsI1dQSKyQdO8VM6zfw1ZrCyYvD9TDdy/ELjtXTy4ecMpkOg20TOcEQa4Z9ybGPQayY4i9pXXtxu5/LbQxPkecquFHVYPeTZDB1qBf/yFlz6heSQRoGUkJczdRbhd/Dh316C+f2NMftba3HQG8G7IEPhrsRxm/9ZadUY8WOelSlX1IgZzchZWQ0Ba8U/RJGISUEGL/jBq86a07Ph9+iGGlxQzw8D3CYGhSBaBAWcDsljMKWMivTbBaQXrbIsaP68zuJZNZKkKqF6jo5iZYn+FAFyST66VDR4VPjazYRNsEXLqDBZpkPHPvlzE1GOmQE6wwilHdlCgHAydrsRZjk3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/SyeGIj6eNAQAnGM1g22xvSrHsaK7rarZJnoJVyQP7w=;
 b=Dl24X2sO4HqoilRzLhJ41Ilk6mS6mFsNzz07IZeXDt9bHGN8xe8L8RkIPiE2/TRPS8ElkCbBqhCqNxgJOYfmJ9uXhl56784c2QL0vorsZo7wdFtNO3hcezHLWmB1T0s0lRQ0VTqvLvYqzO/BR6pDEloWbXwkeQL5vHogSte2hdW1FDxtRopmuaeUwlMsLhBfJxZSGWvSGXOEkqGa1B7wcp60vek/1Iu7hIzjMl78fqWSVPIBGMjxs4FYN3sCIT8rL1Rote+4r/9/qCURrQU6brtY3WHu4gVsHNZViHj8/+mEbdLiponEAT2WOVVOkeupoyOxnIWrrJphRKIlYDNcwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SyeGIj6eNAQAnGM1g22xvSrHsaK7rarZJnoJVyQP7w=;
 b=dA9GM2sMelhz8TdqJUJEkYdFvX71NcA2cK7AQvvBVCiyRFr3nnbMbC+UmqJoc+eQmREhot1NvBsoEY420wfjK4ZvEy6HgaE0ndt0eS4My9sc4c8L0LNyjd8nxu7TUlc5r3tN6fI500G2BU+SQfSb0t075hvsUXgIB1UgUI0xkgY=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Fri, 5 Nov
 2021 03:32:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 03:32:53 +0000
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH v2] scsi: scsi_debug: fix type in min_t to avoid stack OOB
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r3vp9fg.fsf@ca-mkp.ca.oracle.com>
References: <1635861997-987-1-git-send-email-george.kennedy@oracle.com>
        <yq11r3wr8ck.fsf@ca-mkp.ca.oracle.com>
        <70683ce5-cc77-ebc1-b534-7c2d3a92d715@oracle.com>
Date:   Thu, 04 Nov 2021 23:32:51 -0400
In-Reply-To: <70683ce5-cc77-ebc1-b534-7c2d3a92d715@oracle.com> (George
        Kennedy's message of "Thu, 4 Nov 2021 09:54:22 -0400")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0070.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::47) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.40) by BYAPR06CA0070.namprd06.prod.outlook.com (2603:10b6:a03:14b::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Fri, 5 Nov 2021 03:32:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 355099eb-76e8-4b6d-0461-08d9a00cf379
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-Microsoft-Antispam-PRVS: <PH0PR10MB44699027CE0EB102AA3342B48E8E9@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nn28y7DvCTJbyEgCX21/QO+ENeX6a+R07TO7UAIbaNvn39FN1KCuWoB9IP8HOOq4RA+RIbKZqSRaw6zB0qc4QZNTl0Nc5y+f8zZITRCqMu86YtTS3mR3Ro5K4v+xzeUInyKPIntvazFV6kfmTJO2UM/vXszvosiBdHDUgamE/Z1hJwWPegnfSvhtmRtW4p4Ir9A0vAoXGWkJZ7pC2MoutgHcty2mmkzQiUdnJ7uZHiAB0R4l6u62Mb2nTCV2DAWr5m07Vp6FqVX3UtrbU/S3iCNXV8TLVtMq06QUGC6jV1iagzz7BbcRiH9WqUHYUiWuFLSYCr25n8Aue2IOJxaSrfPY85sZqJrTNr5HlrQGQIb8HXxyNoG7x5oQrnsTMJv+AibYhXAeZepwNAyTrUJbc0no6EG0XXuABVAPQryux/vs9sfMUpiTaX6HxqI7UD50OQGB3NDW+qJ1KZ42lTn+uJy5DPe6fO2Rs3Gpuji8moSQbnD89Dxnt41VDRaQzT/gk47B0tD8PLD6e2bJ1/2xyue3FSAupOJdxSU3i0MyUi+IbTnC3/owmcwgwxXNhkJK7UJzpdD4gmpc8HliRw3XFilkXKNGLAz0UneZ1FreaLoNo83eG2Uv3amrkgrkPU7CeeVvGbTpAviQx1l+fNYYnydnPpr4OFDCDbe1onnrYxdKxXTWAjwCguItEthhSgy0++7q6U7bTsmgWQUSwzhr2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(4744005)(107886003)(36916002)(66476007)(8676002)(186003)(52116002)(38100700002)(38350700002)(5660300002)(8936002)(316002)(7696005)(2906002)(6636002)(956004)(86362001)(66556008)(6862004)(4326008)(508600001)(55016002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bxnGqPgs1hyOwP3HZv+sDSckHwz+NeJXJbh2DStiXbeJXT7BO3xZSvKO2ArQ?=
 =?us-ascii?Q?19TEkpk2nQesjCHEvnGHWx6+HfFOesUor1S4GP1/V9IEP052kWKU5q9BmWvt?=
 =?us-ascii?Q?nozG3pu6OxFyzO9TiPFgyqEFG7dXLa832ghiIRmxntuaUNlvPKzH+kbpCPUv?=
 =?us-ascii?Q?TYTzFkjv+xqOIgIta3yPGhwJdrRWiMbrLiINzo38AYuC6KObXq2rGx5u9Fg5?=
 =?us-ascii?Q?xOTz07eyEsGk6IVoR2wIxoqyBFWiXRDLz0t5a24TVeVyaF42/8WDb4HXh5dM?=
 =?us-ascii?Q?7huIDWAgFJUqXDCZw9ZU2QFLsZe7jFJqC1G4J9bxOcrXAY0fFOKihrQa25Af?=
 =?us-ascii?Q?pKSrmVa07ia5dKyywflfrlw9cYLrF3d6cjqk11CvPrJUSC4b+JopKdI+TXgo?=
 =?us-ascii?Q?MBThTUsQM9zGC9UvOwmPwXo6+8GfhnMezpVc5mq/UVthUPu+ZvVZ2qHE8yU/?=
 =?us-ascii?Q?7u7fYCI27l8ZeEFabv7l7uPo7WQ9vbDSviq6DRJKZeDFRkOg9k1gLPXcCT2f?=
 =?us-ascii?Q?7hCOuFYaCw9D9MA9ZjVGpPgf12ej0Yf99uZ3OsZp5ibmuQOxNr9VbUGVQzN3?=
 =?us-ascii?Q?mGfgFVUepGiQiLfRnWSfu/wppA96l5QECq7VYO29uW6hUYba6gzVAJPP8eTL?=
 =?us-ascii?Q?58yGlRlo9NiK5192/aIQBWsb1Rw1NimmaoW+cluVv6/JlGBgxbzr6zQIN6B8?=
 =?us-ascii?Q?bHV44uwOx3nbVw6mOa1h1/xKtUMW4lufNOyb3p32kD8AYJq2dLxhaLFInqiL?=
 =?us-ascii?Q?xbZ+WT7VkKCOVchBfrZdn5bErqG9+CTksS9YXDvbwliHUq/JPl+sOEeLO6zW?=
 =?us-ascii?Q?khba9OGohC8Mk236oaBIFki0DK17Y0k11z1psehmAFGq1H8Z2t0W9YVKPI05?=
 =?us-ascii?Q?wqCjNecVG7snrDlva/783zqFyuxlmgubF0XPQt4VNepGmD3nA8sAeElNHXCP?=
 =?us-ascii?Q?WJfYkIaUYZtzqfBtZ5+kaq6W+hKb4GiKWi8/HyO1hCZzAcMttXDfr2Ar1BLc?=
 =?us-ascii?Q?2ko6McN7CD3wlwwhIoiUJIczEpn5MKFi4biqyz3jv1CNuSuiFTfxm4XREvXm?=
 =?us-ascii?Q?wNzACl9mz3x3lFWQIACaEi3Th+RSJWU+/VfA5px+EvTECVpvlO0mOr1KuiSI?=
 =?us-ascii?Q?F8si3Y6c+U772Xnz9URtpBwgGrj1k0bCMYSDiUKW2jdwqIP+3I2vQTDS4dYM?=
 =?us-ascii?Q?0CEqpIBRtfEC1vFEwb/jO/LvWjpaBvsdcDOs8zNer6CRNGLcwSH7CQ3Caf0o?=
 =?us-ascii?Q?HKRQKSQUPsbKgOzruCzoQvpRnvq71xHzW0+cx+yygWf0WOr4/Mo9cFi60fOh?=
 =?us-ascii?Q?2W5389ePZLeEwgGjaKfsatP0Dc+/I8tZUevifG8wE2z4NAMT8y1K/MKPokFj?=
 =?us-ascii?Q?MOFIDTpaD4mjOrtafWnM12zoukKYiMsdAjjxbDk992T70PtCX12WiWJTGoaE?=
 =?us-ascii?Q?+FgJBiM+iTfS+CjpDxQl8Ly8tD6hCspY0a5l7amNJCRV8cUmXir52gQmyP+K?=
 =?us-ascii?Q?7j/bzyGa9f/B1CtH+NSfipbuhElWbEtNoO8Jwkr60e/VJGK/oK78cW/eRdcD?=
 =?us-ascii?Q?LtlqVoRU8VEhQMkuVCRw2KVuasH0Eu0gGLE8FTok+DPZ5Fl6/4vQgV46ODyS?=
 =?us-ascii?Q?zgWfo+AETpA/6Bw5o5QMEqzK4PRLB5jQMiXzWxTvWVk0ALMOd1rEOwyVnae9?=
 =?us-ascii?Q?3I5GYQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 355099eb-76e8-4b6d-0461-08d9a00cf379
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 03:32:53.6075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: libkOFopUY1LYxX4LRQw8FUAQBu9ieQjGmS1NutJwzy3RvNDFGt6rntcq+A8J/ja4VZ0vYtj//yfBDidAvVIymnSIR/UNv2NDic5IG7lyj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050017
X-Proofpoint-GUID: Vz4A3uX-Ddfr3tnc1bZypVu23SRKCUPj
X-Proofpoint-ORIG-GUID: Vz4A3uX-Ddfr3tnc1bZypVu23SRKCUPj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi George,

>> This needs to be reconciled with the following commits:
>>
>> f347c26836c2 scsi: scsi_debug: Fix out-of-bound read in resp_report_tgtpgs()
>> 4e3ace0051e7 scsi: scsi_debug: Fix out-of-bound read in resp_readcap16()
>
> The proposed patch should supersede the above commits.

Those commits are already queued up for 5.16. I can't rebase the tree in
the middle of the merge window so your patch will have to be reworked to
apply on top.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
