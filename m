Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592DAC47089
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D1536143B
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhEZEJ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40200 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbhEZEJY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q47edC146438;
        Wed, 26 May 2021 04:07:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=e7W5SB9AmOQHVlNBKE2pxSltfBg0Gb6m/VdlPtxZmKs=;
 b=Eou7NjAvsUTP3BrPYc7T4/hDx/x2IYD4orkMLE7rJR9Ie69LpyCiO/V1kpgSU3scOqq9
 vgWT0vcVWejT1UcM0Wg+cBFMiWKg6G4MOTmu55MSCz4otHOSqfilvSERPIgkXZtuLpJo
 FXjAQlYDSskZc/dJaE010UXOocOZJTE0XpD7P63gl7tp35pWurkLOiVkzSthkmb9phDU
 c6udIR0OawdDz44RO3z5FIo7ymwUQnQHAkXN2gtokAYH7Ir0hTA785rTnMfDPTnaW4WH
 2U/Ml/IC//rEbZrpRlRmkAKdjhx3Z65fib3UJwWx2uaqA5nDyk9srgXeSgYiqc8HVchu wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38ptkp7pyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q4645S164092;
        Wed, 26 May 2021 04:07:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3030.oracle.com with ESMTP id 38pr0ccmej-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dc2viem2arztn4JzCFEVwcQQVprzut8MM5TYXRI7SZ2we3cNjOqAx4MEv76h3p/7/SqJr+OCD3lUIVa5i0M+iUxR6c053NyHbTART8hEfVx3uF/vFgkvydkzINOQQlZ/Gbf4UttXIq1PHTKGXV0VVnbld9GHhwBwiXrbF3enQYQ5t+oVwnYzYjcG8I9vK5r3HeQMxjca4oUHeEkXxsKNFT8BwGq68tFS7RhmYIOX6SNdsPeQRQJhXOJTqkirFTUx1B3HQK/eVILqsNNz96pNKMS+mzXkxmUEHynyrVh79Ux4AXa0J/r7Tjg8mZ0+3nTpc3XwhYJpXfcOLM9ggzWEpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7W5SB9AmOQHVlNBKE2pxSltfBg0Gb6m/VdlPtxZmKs=;
 b=OJmNtYyt9ew+Jm/TKSy+LVBJuI0iCtizxIz5rpIZI9wkXLY481iLAHPkaMNmDrQTngbWC61ZQgtpp5kfp1lUvISy3kPjGYvwoDLDkiSEuvsauKddkN1XHtVB39ZTO4zc9amFIDs4/Cijll0CVWyGrfhQTQv8ZsmBY3RXTrsLk+qahExj0XyYUj2HFbQkycD8anRMV2ozEfmSx8Wtm2/x1AHfumUtEOwkCe8rkxk2GWhtBl2VsNLbju1dDTIyz8ZFDsoUR+YkbV5JuvBY1EIyiN6nos4baSDDwJJmnBVfTTrdJ/aDr/yE6r/IeAiI4kUrJRL/rvMH4FQ6PjUxtDn6jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7W5SB9AmOQHVlNBKE2pxSltfBg0Gb6m/VdlPtxZmKs=;
 b=YOEs4vLC+9nhEowdnLfFZRurJuxulN3/aSf1DFfiL8HbBxzqo7fQNtf4h4ivV1SP88VvNYXX9RlO/bbyIkNQSNSELaXgJeb8ZvcoI1/DORJoFjsfvosCDRlW5nnmArIOhq3qIFiNdKNcq3VufZkrgWJq6DZBmToBR7AJfy3t+Vw=
Authentication-Results: qlogic.com; dkim=none (message not signed)
 header.d=none;qlogic.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:43 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     anil.gurumurthy@qlogic.com,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, sudarsana.kalluru@qlogic.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: bfa: Fix inconsistent indenting
Date:   Wed, 26 May 2021 00:07:21 -0400
Message-Id: <162200196242.11962.8097326516312662118.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1621590368-72041-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1621590368-72041-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd5d0c29-4e6f-4060-b90b-08d91ffbcfed
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44693F09D21EBA71DD77F4CD8E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3SL/YDJSVn/eDlAJ8JEFe+Cg/5tMcqoLBmchdNZw2IYj36nwrwW7jd2TS0/ekHFbLgN7g/hJl3nkxGQ/sYJ6cbKMaU4PQ6HEcmSNvCsnysMU1t6WxHMjT0PAm3qD6r1w4Qv4Pd4b7iBOsVO1OUPF1/1FfEfFrGSStMT3NrA4kAaqhkZN5lZFsTtfqSv8O7KqE2Ti8a/DKnOA2xfXp0AklGN/Hnrwxy+G6KPas1huxdGHwCwRCnQZTGIuLRcg70EfFXSh4WQRePy6TfmDnG4SJshnMrumk74jWN5sm7fPmfZiKg2xkRcQvrPz87tY7P67xgqeSuuicnKPCe67U6BOh2jFQEdeMlvbRxP2YHu23ezlC+gIik6St+lEvFFmM1Jm2mQV/K95JOxoE03xdtfxZLfkqd0FVlRgvDlMn2UnobWx+AfauLVkDGIsp8a7qBDZRiSaW29lECgGwbAEnnJrrVOFnD31eC6qIX3YwEWfpSS44YIduoCCYNtn0pXvP/fLaFpq8rxbMC9rSz5OuvjCjfcVhLtIa6GgbLt61KSTgpVK/gZ9DyFUA1qBveh2U2pDj1+T3Md4m8m5RZlSPzwmgWkihimIAUoxSp9b3yFeS3YrKFBU0F6gfNJ0BYwJSMmQQm/3fDK/jZL5KhauGFfG28FRV5T5GCfTZUl9Lgp2yxD+NsP3i3QrEyTO9glGPYcRZeRO5fICJB6CrzpkvQU/wHXF4K8JxonF1hLT6o+Xe/Eli+fQzGPWbXzYsp8Jb+sx1pGcIeW7ltmuCTcp924VjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(16526019)(186003)(66946007)(4326008)(103116003)(26005)(2616005)(4744005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(6486002)(86362001)(6666004)(83380400001)(478600001)(6916009)(966005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Ly9HblpQYXZqRG5lYjJmYUw1YUdtdUxsY2dRVHNjMFpZRFpOa3R2M1dUeFhk?=
 =?utf-8?B?bFVrRjFmdlY1YTN6TTFMVmllNUFzbU9mcng5Tll2dzREcFBEeWJyamE2TTJB?=
 =?utf-8?B?QXRPR0ZMdTlUaTF6cjlzd09pTzlrbytyV1d2Tzh5bXh2MUpxaER2WGE5TVJQ?=
 =?utf-8?B?SjA0SktlVzJRcEtiSFZ5Sld4VFB4RG1yYXRGdW5HT3owcmd1MlRnR2Z1ekd5?=
 =?utf-8?B?eE1Qcm1rMW41UXpEWlRDTjJqUWVEMWJPVzh0WkR1R1NBWm9zeU1Yc2l5VU1Q?=
 =?utf-8?B?dGZwWmJENEwzUlZZRUZEQ3I4YzY5dXNMdjdzOE9XQzM4UkZuL3FFSVVCcTFk?=
 =?utf-8?B?NFBHZ1ZmeW9sdWRDRS81OWVVYS9TQzV3bG9lTERJTFRYeDVVamdyOG52K0tD?=
 =?utf-8?B?VW9EL2xsaGRjWWxiZGp6bUlzb1B5aFZmSW1CNjBFY2p5OEpObTU1eHBpL2Na?=
 =?utf-8?B?bDN2cFhKcHAvRGR0VU9vUHFRenlJaUF2Mm1LT3FRcFpGQms5UWdsRUpFS1hB?=
 =?utf-8?B?TmpIc0hUMVNJSXVhMGdVM2xHbDdTVldKanBldDMyWmw3ZFZRRG1SQkJTL2I0?=
 =?utf-8?B?ZDQvajlQRC9rYkVyY1czVE9iVUk0VjQ3RWp2OHdqL1R0aTF4SEx1L3hvSmd5?=
 =?utf-8?B?TlAvaGs2UUtDamJLVTI2Z3h3RW11WER4ZWFscldVb29JNDh2Q0FrNVJOaXQ0?=
 =?utf-8?B?QXQyZ1NhUUxPeGgzMDVCY1h0N09WbUdEaGxNdWhUZmNFQWt5WTZweEk3QUZ3?=
 =?utf-8?B?YkNSRy93WHdkUjh5ZWw0dVo4aHlDa2VkUmlIVER5SE9vMVovTks5ZHdRTkVC?=
 =?utf-8?B?TmI4WTVKL1BadXBLQ0QvNDZYdi9TNXVCK2tqTVZpeWxjTFRDcktjR2VYUUE1?=
 =?utf-8?B?a2pmQlB2MTNwM04xZGxwWWExdmxzLzNkbFp6L0VUK1lmOVhtREFHallSdk1v?=
 =?utf-8?B?aUUveEphTEJzRjNYNmp1eGk2bUNObk41WitFaXhvOG44eVZFUDZrbVpxM0xq?=
 =?utf-8?B?b1JqRXZEbkxTUWFzSFgrZmdsQ2FzWGtTcGZhTForMUR2am9RMHdBaFBPQWYx?=
 =?utf-8?B?OGMxR1BtajNvRnowOE1pQTl2OEtmRGhJQ3htU21QcjNFVmZWam11c2t4Yllt?=
 =?utf-8?B?djl1ZWM1dVcyRkVJNG4vYVBNNndBeHFNdUt6eTZhMk1WMGlsY2loSmhvVXB2?=
 =?utf-8?B?Tjd2Zlh2Z2lvY3dEeFlTNVFrYlREUmtCNzd6U3djd0M2cDE1RXpMU09CQlp4?=
 =?utf-8?B?cDd1OWQxZStvblJIRzM2bzlzK0I3VkZUUzJKNE1aMzNyYlkycDBqOXlEOFAr?=
 =?utf-8?B?bWxsYlBhYm1nRUtwdExhWWgxczlWalRaNS9rZEJjalB1T0dhNkNiTm9LR204?=
 =?utf-8?B?ME9LUlJUWDRFcXdMRURIYnJQM1JHYWluMVNEVWZLUFRvNzdiSGVsNmJzNmJi?=
 =?utf-8?B?NWhiNlZQYVpQL1ZEamtJSEFBY29iS1NXbm5XM0g2L09POGlibWRhQU5YSVc3?=
 =?utf-8?B?M2x2OGYrR3poNHBsNGNabTRTWGsreW5oakV2QTZxbVRYTDRLbFo3K1Q3ZUQ2?=
 =?utf-8?B?OVRGMVNrK1lEdnAwNGJDTmplcTNIYzk4UlFxUHprRlNXVktVTjN1RkhDbXBi?=
 =?utf-8?B?ZjMzZGhaZDZLRTVSSytKTGwreVVXNHFiVnF3cVZHNEh4RkJUelJoa2VjNlBR?=
 =?utf-8?B?cFlBcmhhbnpJbmpXUmRKbjl0RFZUNHp6aGYxcE56K2kwTi9qaEtKa2J1YUxy?=
 =?utf-8?Q?SSrE2BDpTG37HR9dO2AYT7F3QpgZcnzlwmbHQxh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd5d0c29-4e6f-4060-b90b-08d91ffbcfed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:43.7342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sdd9NW1J40/6puHAmkONw1ch47m4To+0lgKZ2GBxxSRkbS9qllMbMtv5iq7ZHKxu75RLwKBIlj3OXCQQ2X0rGtwuvgjp/RRJg5DJ90/WrsE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-GUID: Xmlvg9791v42X6tRRBAw8d4z707s-y9M
X-Proofpoint-ORIG-GUID: Xmlvg9791v42X6tRRBAw8d4z707s-y9M
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 21 May 2021 17:46:08 +0800, Jiapeng Chong wrote:

> Eliminate the follow smatch warning:
> 
> drivers/scsi/bfa/bfa_svc.c:3176 bfa_fcport_send_enable() warn:
> inconsistent indenting.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: bfa: Fix inconsistent indenting
      https://git.kernel.org/mkp/scsi/c/8f942f9d4b06

-- 
Martin K. Petersen	Oracle Linux Engineering
