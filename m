Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080F7C433F1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD40E61929
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhC3Dzz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60876 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbhC3DzV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3j4q6141734;
        Tue, 30 Mar 2021 03:55:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=0mNVO2gQVdSUui9CWdcm7JNY1ZEpC5REG9fxKSzCQRk=;
 b=UxEXP1/PB1RA+rqkWMVGJeYELtO4QpFwkDSc9vgv3fsFKH6yOoEQysa84PPjDWeg6zWC
 24kdS1T6zxImxm/A6XnOyd/aWWT9SlG32u4CsuSkbDxMi+bJJI9ASdSmBiXWtYz4X29t
 NCoDmHUcQWSKKmrqHsx6VKXThlqNbFbsCUTmx2MoWEBmv4mJjVTRKQ7oe1HhqER2KYn1
 04kMpve1OT1MgFP0Pr8NfhQmm8pjFFoSUa/SqNTKUxarGpYAaelMvjU7d8yXPNxGG/fv
 cYl3lq+6MyMCCRvcxGWgRlLzbAAvvsZnqjB9vBJWut+k1VQY8A83SJd9jebfy0dT5dsi KA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37hv4r5k31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3iXTS039487;
        Tue, 30 Mar 2021 03:55:00 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by userp3020.oracle.com with ESMTP id 37jefrkt1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qn2paTpV1g9Rar3jzOisYsSevqY/h4fNlIDDw/Ed4O01HDxJtCOGrlimhMlC3df3ERhDXVe1CtJ7a4hZZ1tSvuou4JqM7tzyBGNr7XnodHhOC5yBDaogv8aZUv3z/tkhH7LUMpH6oDcnCx188rZll+4U3h2nDIi7S96uGOxlqWwpUScLpyKU5wSZ+2sqG3CCrcDK2Ixz46awuPydzuVSR0dE4nnmh2lK0rM2MF1CsZpzmInjlZNoTO4Ro0BHB/4VvCwUwRHZo2LCKNdT45+QUEIxJom14INLFgquYFF+5IQElgpYRhInA72nLxf1c55yfEhiqZckibC2SMi/2FX25A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mNVO2gQVdSUui9CWdcm7JNY1ZEpC5REG9fxKSzCQRk=;
 b=AvfFGks+0Enn9d7wYKOtm89jB5PCx1yYjY397NFuLluAR0fEAGW+aLbC0iimMONJIvU6TBxKyr7+AUbcKdg5TxAhYRHgzdJAuoRw1bZcR7LMcl924Q9FAJtcj+fsOFPDTX7Bln+nUeN+cHtY1F4HStNXwLzI0KBKIJmlj1ibqaX9xkZEGICwRLqsFjGB189QAeoeYAMEHYDa4PY6jOgWVrm0ZMwzbTZEdnR9HswKjaxSXuoQXLH0OCDktbpF12i5ux8hg9FSGAkKiu5ABrs2W8A865LK0dOrCyVpisoww7l4LGXdDQ6rT//2/3KRES3wTQ/zNCEb86B1N7pLimEZ+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mNVO2gQVdSUui9CWdcm7JNY1ZEpC5REG9fxKSzCQRk=;
 b=yhZarx4Dj4CjcdmEdugUrnSTsDBc5eaXyuEaDTIcsJkBHjgQ40dpaI8Kei1DELYKRzrQmToN7griLo3iMRagOo15Kw+iG3cNkUIFrv1BpLCCVo419VF8NNmrBdp6PwQBhgF6HLfa+2wi9ACtToNUF8cr0d/fpXwuJY7tV9NueGM=
Authentication-Results: neukum.org; dkim=none (message not signed)
 header.d=none;neukum.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:54:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:54:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     oliver@neukum.org, Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        lenehan@twibble.org, aliakc@web.de, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com, dc395x@twibble.org
Subject: Re: [PATCH] scsi: dc395x: Use bitwise instead of arithmetic operator for flags
Date:   Mon, 29 Mar 2021 23:54:34 -0400
Message-Id: <161707636878.29267.14628600051488313821.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1615261153-32647-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1615261153-32647-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:54:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9454562-1965-4ae3-4d0b-08d8f32f968d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB475852E5855452187542B2B58E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E2QKSO/Wzb6I17e69lfU1fuenVeIlaH9vXKUy6ItuGNMR4Up4GRKFOETcPM6baDByK/9/Yx8gNgAjCLFtFDRrtxpx5Sv28O6NYiVDjANR7Kv8N+3urARrEcXvRPrMSIxBXt5bYLM/XXw4Iso7t4PJ9/yVP38su/qF81HEN74pJXWSxFJPMv4tYOsofSMEbMyHJ/YXDtuFY02eIl8FZLXE5DILU2pH+Pcg9KG6QSjH7r1GolMphOqV8BOsIK7/rBR8ZlSRQqFsgUvA3hLcUC00m6Fte+P5dub892mOLT7K1+PthvmAIlQonBLdZnw2+eLZDICGV3LlbRpZgI2AH9teFKrZI+jqynzPOQeuTQ7JDXXcpugjpUQdt/HFydBmZ/FNHDiLfHOZl+uAchvIHj/S+rd3rbdun0IyoFch6WyNL9U/rvm586nFDtDhAtkH06IvJvDNB5iOMejhhlEW+t+/3HEFQj8OF4nN+RE6+Zg10PMCEThVSe31O1VVwCoFdaQehKE0Vua2MMA3rYoVHlay1Zb4B7PtKjIaJcZzCbYt4CeFpoDcaMRE3Sku+YxZiF2oGgFnHijHdS6a/1zaUA8IkMMtIwbhckaeGhl2J+jb9Qek1H+w52/uuzk/6M/qbT9D6vfTP/m0nfleD+f8qfF7FtmFsBxlowO8Cq0YVBIBG4vML14fqfwHIyOR8CmV/JUGLS4TLfQ+yFzhuhm9IHigGL/bqlvt7S9e3uqJUQ24HQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(2616005)(16526019)(6916009)(8936002)(4744005)(956004)(6486002)(8676002)(966005)(4326008)(66946007)(66476007)(36756003)(86362001)(2906002)(103116003)(66556008)(52116002)(7696005)(186003)(26005)(478600001)(38100700001)(5660300002)(6666004)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SldtOXdFOWZoM0xOTm82aTQ1amdNb2V5WnlMbUFtemdxQjN1MEZBQVEvaDgy?=
 =?utf-8?B?OXBnd2ZNZkxXSlYxajJEY0t0d0NVRkRsYXFldnVGaWlTVDR2TStnUVBrZklm?=
 =?utf-8?B?b09HWFhmQkhHUVJEUUQwNkJTMmRhSnZMT1dIVEM2UUhWaGdud2FqTmN2eHdU?=
 =?utf-8?B?SnNTQkkxTFZWa01xa1R5bU1XZkJRV1gzNHRZWGFqTEc3RStWTkZ3aWRrUmlG?=
 =?utf-8?B?MU1tc051TmZnc05DWDZBZWZXWnNaVkx6cjhYTkZPR3FDbkZoOE8zY2hpYWtI?=
 =?utf-8?B?Q1B3c2xIaERacUNEM3d5U3RFOUpXRkM2TUYvOWd3c2c0amsrVEg1d1ZmZGR6?=
 =?utf-8?B?RTUwemp5eTlWTlpNeHJubmVUMFpDQkx6WE9sRUY1NTJ4YWlwWEpFZEVZNldp?=
 =?utf-8?B?WTU5TjFYZFJ2NDdRZzMybVNPZmZ4VnZCNUtYVVczaW5YWVpMRFdZRXZ4SVFi?=
 =?utf-8?B?ZFFjUXpHWWxPbm9pR3daN0N0VEJGT0t3ZUhlVW05TnVEVXM2MVIvalgvUHRQ?=
 =?utf-8?B?Smo3dnRTTDJpVWRjZDY2N3BidnhVUEZKWStUQkdKOTNZcDhNa0Zib0xjOTht?=
 =?utf-8?B?cGxNV2Z3cFBPWU1MUVZGL3puekRJeVQyZk9LZWNxVmVZSE42WjlrQjA0VXdK?=
 =?utf-8?B?cW00Nk45UDNZdVVVNTAyQlVOMUhNbUxTVUo4MzF2dDIwZGxvTXR2RzUwYkZI?=
 =?utf-8?B?cHNBY3UwUjBTemRkTUpLQlRCamI1TVpxZ3RyWGlKV3RiL1hvREhEZTUwVU8r?=
 =?utf-8?B?TjhoKzcvOEw5cDBoOHZXV2tmU3hKVmNJZElmVytJUldxSWM3S3NNMEdqbXlq?=
 =?utf-8?B?cnhSWUw4cXFreEQ0a1dNK1lmcjhHSXF0RDIrNWJvOEU0REFHWkRPa3ZkK1Vo?=
 =?utf-8?B?WTcweU1zWHpxcGlNU1ZBOG5EMmdCVGphMitDV0JFT0hheEQ2L2FIT2cxRzk5?=
 =?utf-8?B?ZEFpTE56cDRDYnZTei8wZ3E2anNxT1lObHl4R21XRnROOWM1cnV4R2RoeE83?=
 =?utf-8?B?TENRdjhqejMxN2NxNEFhUVd0VjBrQ1NPcmRyeWNoV1d6c01FbGdiMDI3Nk9q?=
 =?utf-8?B?RkdaSHkzNnhpZzduVzJuSlc0V2RFck0yK2Y1MWZiVWp3MWJwYjZGRFljMzU5?=
 =?utf-8?B?dFZRRlA0UnhSNlJWRWsya0lLZFdWWUZISE9hUVFrOWJZSWErczlzZGkxeGE1?=
 =?utf-8?B?Vi9sUlFuRDAyUjVoWXNUQlRxMEVKcHlrcVE3RDhHK0VMbWsvMGFFUDJsZ1NK?=
 =?utf-8?B?MXRhQlF5UStSUzQ3TkRjZkZPdUNWSm9ENVYxL2hOVEdrcmVVMTdaWW9xWDhP?=
 =?utf-8?B?bDZzczlkUmdEWXZLcDR3R3NXVDlDL1lsM1I5eHFTdFhQMlRpS2liK3Q1d01B?=
 =?utf-8?B?OXFqMytaRHVxdjZnZ2VDalQzMlBxcitLd2RObGdidnQvcjEyTUoyRStVTkZI?=
 =?utf-8?B?bmR4U0dETjI3cjVTREVuODBEMS9ibndxY2h1RERSQ1JvQkdsTm80ZE5yRXlU?=
 =?utf-8?B?NWE2SXZSRWpMU3UxWEQ3bzZ0ZlQzN3A4Q2hQRUdYakpLWVV1WUlWQ1pESnV6?=
 =?utf-8?B?VnBGczNZSXBzZWE2dkxBUWc5TjQ3aTRMckI4V3BJd3dwK290MXY2RWU5Tldy?=
 =?utf-8?B?Z0JENmRLYTNXSytBRVJHUjZ6NWo3Qjl0YWlPMU1ZbzVvaTkxU1RpNHRIeDRL?=
 =?utf-8?B?bWNCd1R2cWljbjJtSlVIOXMva0lkUzVZVzF5K2IyMDZ5ZVZEZEVVT3pTVm9S?=
 =?utf-8?Q?nUy0gf4r+T4F9mVUzmtUyCiXKE3hZeGewjah/oV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9454562-1965-4ae3-4d0b-08d8f32f968d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:54:58.9920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K+rlQPmWmMJzKXKrcHWQolnsKa4rFrgzv/BQH+y7XHn/XBHyhOpWbhIoLRtf/nAhYMg+RXfdfTfYYvB16E+a3vVzbUpe5Ce2EbQTJ1hYiC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300023
X-Proofpoint-ORIG-GUID: VRi4SDLTsSwxFLIbvZIGv3Q95uxULHdh
X-Proofpoint-GUID: VRi4SDLTsSwxFLIbvZIGv3Q95uxULHdh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 9 Mar 2021 11:39:13 +0800, Jiapeng Chong wrote:

> Fix the following coccicheck warnings:
> 
> ./drivers/scsi/dc395x.c:2921:28-29: WARNING: sum of probable bitmasks,
> consider |.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: dc395x: Use bitwise instead of arithmetic operator for flags
      https://git.kernel.org/mkp/scsi/c/973c920811bc

-- 
Martin K. Petersen	Oracle Linux Engineering
