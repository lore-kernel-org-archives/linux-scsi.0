Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F14FC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07DF761A12
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCYDys (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 23:54:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57530 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhCYDyV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 23:54:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3oomI098765;
        Thu, 25 Mar 2021 03:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=OrQEDWXBx9fH5c4CKFqeR4X+uun5Ndi5MQO9MBI9FmA=;
 b=hKIKYB7AYnBhVio//KkiyetKhfX5MebHn6W/IqCwK44ypLiO+KVAp6vfdIJYiC1c7tuG
 FGR1p4p3cdpdNHwlEqQgWYim2WXzUyZZaT6TDiE40XYZLodhOk4AfLjONHhcawnOI3R0
 c33+hHd6RS9ab+ZcYXmBBE6l6K4sKIKiE4x07nIlFVUL0szdBtH5vp4mr/zSnKuFufUW
 aAKxhl/L0fJsYDNmkIC/vwWtWqiHy63arbxnmXzw1uXJqYh1JUSzvr66B+ntfNUPceQh
 2jWnxIgpRYhMvNLcnP+XOb9YtIF8A8pzaOcRHS5zzebrFkB6qLVm6izQIoc6y47SH/2A Vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37d90mmvpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:54:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3pFh7134348;
        Thu, 25 Mar 2021 03:54:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3030.oracle.com with ESMTP id 37dtmrmuua-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:54:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Opn/eJ/CLfpt1PApXz7g8qKytrFPzvtMXnvvruTootOHeGJCgF4hzHOkR8zMPJ6s/+1Kf8/W8JTvYyungu4Pod145wdXDZxh1x7qgKCaYEr5clsTqqzfE0B+Z3QEX8oKKpjKxfHDJNJ5gL44X0T7ndd9Zt8bXRtM18iM8ApYfZ5caBX6yrrZ4JTUF0I5o7Bibw8QUCh/35Zvw7bCsRTE2S8zcNK2wLUBfkvOnEafZhQpJT6braVT6j2PFIuCof5/45xh7H+vFHq56LiTiZQj6PuqjCTPoo1Yx3k7jLJJUZOXUQLLP1ELV0yF9Mej9Ww79Ji0a3tyDa6MdBWrcCXtxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrQEDWXBx9fH5c4CKFqeR4X+uun5Ndi5MQO9MBI9FmA=;
 b=TnGpcXJ6onzhUKxYyLBgHxc+1GS/Cj+S3+WEGFIM5ovhLOm+JK4KG2D3cn9YbeHHh2cA/R6KIjEshe4wUgcyNb6ywOsJufDWaXudHKvMCRTdrC4V7ZJMzKVu7jB5wXqFTuFrtzsvCkgBpI+v2dvifkz0TlD7ZrH2nlJbNIsbmKd3XEk5WxGBOdT5Qoq+H/nH+RIMCsnCPz9nVdaqqil2p7zHjiNizp1brumW920ESjRqqQ48jrg+7cije2t4Xbu9GsYmdw+fC282k4WdOcQ7DTQ/H865MYnhlWi55Hi5n1ZIO1wXobkqgbacSvOV/kdsOsU11dQovUCySQAUILAd1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrQEDWXBx9fH5c4CKFqeR4X+uun5Ndi5MQO9MBI9FmA=;
 b=arCzO1DXvXJXW/oL+EP7C3AxnNXjDye+BQsusUiT2gigr8fg9h3ln3mUIJZk0tV2wwyZO41N/ALJTsgXa/wryydadfZxRxCUzcD6KXqzk9ruHF5A0jg8Oa2mpPPPmf0/I3uneGMDSwn4/rXF+3hOpwuOeJlpTbkdkOiC3BozVnU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 03:54:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 03:54:18 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: target: fix htmldocs warning in target_submit_prep
Date:   Wed, 24 Mar 2021 23:54:00 -0400
Message-Id: <161664421198.21435.9632245153495556621.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318225858.11863-1-michael.christie@oracle.com>
References: <20210318225858.11863-1-michael.christie@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: MW3PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:303:2b::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by MW3PR05CA0029.namprd05.prod.outlook.com (2603:10b6:303:2b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.14 via Frontend Transport; Thu, 25 Mar 2021 03:54:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5696c1d-e4b0-40fc-69f4-08d8ef41aa16
X-MS-TrafficTypeDiagnostic: PH0PR10MB4774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4774A296EE6993BB6BC1D8748E629@PH0PR10MB4774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uQhX8iTveONkGDx+gHLsSZiwalLr7dtmu35KMEotD4iAzG4/aiSrdD/BlDTnGO1u9WIhPKWiVbJb2w2yvgVNn8fWB5UzA+ekkhKFgBu4hE4Q3TPAItmIk92PMZGT4SsJcE1fgRDJ7NHmg8TDnaVi7pQdd0eyAuzMmmcpnfTX/QYUUajhKllhYHxgEBDatzoKcLT/Bbh8L30m1tdphwgSEy0iZUBYY8Hh7oKjtQ6sIoOPgwpfny1si9mNtwtkC3HB91K1MV88bRH3YMD6QtvjW+HuLg/DVgr0s+q3ZQar/mZpxwGYlP/KfKNjzm33PBQoJ4YKHO7CQW4G0bHDIVqfSfPdpCjXr5Xh3grUVrAo7o5H0bMGnnjtA4XTNJ1pkpceg3BqflvjI2v9tJF3nkqKZiHMxqehgY3nG5UyaR+XWJ8EHHyyBpuB12nxnlLbatcTzy99lSBbvjZRCDatAt1830/PD48VdTcgjpk7qHg/8JNVf4dHGQhCIeW6YlbZBL6Yzq5x80cNDzzp92Hwrqn5Jm+A8tfEa0/AxNuW4nUZAH1KgOUEbaLA8HpZojTg7zqy5R+Xlbosy2HSXTIg7PxzD8E72DuqyduGuQz6+mOG5cOxPa/iiNnDvTAg1lv+/tc31i1YFUB/JX4hXNn8UzgJ7paY7eEBA+Lz8cbcd8uZVc7a920w+rKLQzQ9vXR/yNM+8/FTsJs+wsILp3HECr1VuphiSz2AE53jbc+4hk6DA+M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(8676002)(4326008)(86362001)(103116003)(6666004)(36756003)(966005)(4744005)(38100700001)(8936002)(2616005)(2906002)(16526019)(186003)(66946007)(956004)(66556008)(26005)(316002)(52116002)(7696005)(83380400001)(107886003)(66476007)(478600001)(5660300002)(450100002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UDZibmYzK2hRZ1N2ZEpPWmRhT2JaK2VNV25raDJUL2VCd1c4K2Y0V0dRdlJr?=
 =?utf-8?B?UFVGVkZjWjkzQlFaSjM3L0xld2prajRWaVlJd2puWHA1WDVDQ2dwOUUxNzlN?=
 =?utf-8?B?MitTdmw3ZE9PcFhkNkpBRWU4M09lcXNJcFRCYUI3UzQrYWpNZ3RjSTRrLzl5?=
 =?utf-8?B?ZUdsTEdzY1FsenF2b2pmdDhVb3A0b0MvMVcvNHNENUp2S0hJcG9Ua2VNSEZn?=
 =?utf-8?B?eWhlZGh2dXRjV3ZpSmFQa2xvcGRGVm5UUm8xenh5NkRZY3A5MzJOOWUyL0Jn?=
 =?utf-8?B?YU5OdFh2OTVsaFJBZzMxUUx2UFdnMGI4bXFlKzROV1AzYWszdWFoS2pTTVRp?=
 =?utf-8?B?RDFuT09VbGtxV1NFdndXVlh5MzdBeHlRRXJMbStBeDM5aGxtZmhuaXR2SU1U?=
 =?utf-8?B?aURDUEVyaVhPWXVGeEpHVGR2Z1dhTjN3Uklaa1pyWWtKMzBwRU42WU5MZlg5?=
 =?utf-8?B?dHNyaDFYc3Jxa1BWSm5wYitLU0xTV1BFSGQ2dHBaVjJxNVFqZFk0N0FJMDJB?=
 =?utf-8?B?SWM4UGlmRzZtc3pEUjVZZFVVaGlnSno3RzJDZDgwMngzbEJCNzNxVmo0SU1q?=
 =?utf-8?B?d2dIdW5DUWRObWVaZnR2WVJtWm9jRHBBY1AreFVNNlpZUm1FSTZvdlNDNGZw?=
 =?utf-8?B?aWkvRUwrWlhNTnc3WTNITnY1WXdCeWZLeCtWcW4zL2t4VHZDY1p6Q3BpMHFs?=
 =?utf-8?B?UHFGdSt6RW5MUlZrNFFQSkt1U2JyTzB2TDhOWW90Q1ZZUjUzeFZYa1p5aHRE?=
 =?utf-8?B?SnVXNzVGeW5KTkFMSGFlbDRobGVuV1AvUWR6SzlTSTdURnJ2SWFRQk9YUkRK?=
 =?utf-8?B?c0dSQnFzeG9RL1Y3K1ZjZGFKVkdEYldhaTRwYlp5bnFtODJFbVlHU1FscHhx?=
 =?utf-8?B?dFc5bVlINC9RQVQ3Vzl5NUpwNEZkcVhTOGYwWUxaU2pkeTAyM1BQL0JtZXZi?=
 =?utf-8?B?dzA1VGlGeURmcm05Mkd5NHpNOExIZWljV3Iva0lTWGhJWXhvb2I3RW5LZ0Jk?=
 =?utf-8?B?VGU0bHE0cU9hZ001Mm96b2pYaWU4WHFUcmE4ekY5WjV3Q1dZM1laeGMxRFlK?=
 =?utf-8?B?V3BaR2pOc1Q1Nmt2L0ZXS0Fqc05ua3ZQODdFakxpaDZEamVTZDVpSVNBU1o1?=
 =?utf-8?B?dGZkVnlMVU1lMk1rOXdFRmFKUFI3Z1VYUHpKcG9FQ04ySTRvTWZoN3FUTzIr?=
 =?utf-8?B?UUJwcURWTWpnTnpIQ3d5a0R1NVZOVVpveHhCZ0l1bE5VV0FZV3F4Q2ZMbElq?=
 =?utf-8?B?RWt1ZG4ybVBLY0xMaVgzWDIwTWpWMG1ZdkFwMEVZZU5xSUZ1bk1ncWFFUWxo?=
 =?utf-8?B?eGJWM01UNVJDRXFqc0Q3ZXNIU1RZNEtTOEFieWZKMWs1aHgyL1dTRzhNS0lP?=
 =?utf-8?B?WGlUcWlRa2ZzeWdqdlB1MjJyaWRXZXAra0Q0SGtzazhRdWFqNkU3bXUwamZq?=
 =?utf-8?B?b1JtanpiVHdpWWpkUGVCVmN6N1NudWhUWFJoL1Y2c29nY3oyblN3akFPRFl0?=
 =?utf-8?B?ckZDeE9uUW8vYTRhVUtCWmtqV2o2UHpIU0hQbHZXZ2l1ZlU2dWNCTTdIMHNM?=
 =?utf-8?B?a1pod1U4ZDNPcGlKN1Z4TnZOQXhLRnVjdGdVQWhKM1RTZmhLOGdMK0RxYlBJ?=
 =?utf-8?B?VVMvb2VEK1U0bTNGN0tRL1d6UlBqREJ2aGdkTVlkRE8xNDdRRmQrMi95ZUNS?=
 =?utf-8?B?a21wK0lJTFFrTzBNSEdzN3N4VWV3YlJXSVNUUlRpVStCdmlPSk1hUTZoazZL?=
 =?utf-8?Q?r7Y2VGQjq+T6xcbjWFzPch8AwOxrwz6qXjpImzM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5696c1d-e4b0-40fc-69f4-08d8ef41aa16
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 03:54:18.0623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aXB8R7wOEDngjwjf7g7FDjNIimtPirnBeoO3tDds4cDs5j+kTWQUJUkisgijd7K/g8NLegIFVZ/oHZbsqAK6iU+zWLr7fqb5eRSAlDeNyWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 Mar 2021 17:58:58 -0500, Mike Christie wrote:

> Fix warning:
> 
> drivers/target/target_core_transport.c:1661: WARNING: Block quote ends
> without a blank line; unexpected unindent.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: target: fix htmldocs warning in target_submit_prep
      https://git.kernel.org/mkp/scsi/c/b1ebd3b0e466

-- 
Martin K. Petersen	Oracle Linux Engineering
