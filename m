Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A2DC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46D0C61584
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhEKD07 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 23:26:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51402 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhEKD0z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 23:26:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3E2gq071620;
        Tue, 11 May 2021 03:25:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7dck7mwi6pxDzqM9zY4xRkCLGWJ+A6oeuyWtlmPpHZU=;
 b=NTd8/6vMnbmky81GSI8QgAN+h6IYrcyEXelCvudSjUFn6WwOInoUyWdt2MK293R0qgyq
 l1r0Rdaa3QfZcvYhaYi8KuhFSDyJFs2T9IyBLVaxuxPOofrM+nciSWFR9V4nAIoPhbSu
 tEW2UAIiWcHRTExs66zX14jZfA6sdSQLTb2vR15zsZDZznETGkop63BOLc6SlvYAvGEK
 i+ObuU/GonxJ/UhYLAw7N2d7YEUbKrT8/GhWde80YylB2ntldIXtwh8dejLDF4ZK3tLm
 +umPuI+7Jt5Lb+7S3rJxUuPGCZcjHsAqqrbcPT6qxSQuKMCpi4LX+O5Th2hIKkFUyo4H hQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38e285cgd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3Get6153372;
        Tue, 11 May 2021 03:25:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3020.oracle.com with ESMTP id 38djf87kx2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SlK9zCwCFX+QIa5TtkkWV/CteYyfCIOc8sVZrL2GXMxGSrSfpzedSzVqVKBW2l/aLI8E+wBSeaPS6CQWDijMmWKgTGmVa0JtvI6z0ghBZg+K29UfF5D0eUlzQZk9/0m2dDm20JP0yXWHZunhV7Z0EC7ouVKsaxygY4jH184H4LHEM3n91oFRi2GEwu90GvNMy7F3DvuZ/+rrpMAXFllyN4a4xAWBsBSAErrQkMpm4L36vjpGlBPhx/YEetiRwrgj3RXNRhrz/yiJGjUKI2e60vB6zPWaKTnoIII227LlCQHdWNBVxCsXMyxaMmdE0O4LuhgnVmNHBTcYuWuR47Xf+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dck7mwi6pxDzqM9zY4xRkCLGWJ+A6oeuyWtlmPpHZU=;
 b=YAOD13I/oaTEV0XzAdVujTpdZYO0Z1a/ncf/zk9seAHtF/9tjaTmuYMiUFmBUIwVTvPSGYCWKBXUbNk95GmMbsSV2iBRmT7Hgzz7rs8Y85aFOj6CpXZWKcmSQYMS5oFbtgXACfni5nesczSkxQ7MWF3OaslEXi30T2tKzQtpGAW1K9ifxKEE0eL+dd0GTWTeRrq8jErNo1uTCRizB4ugqUqexHoDZIVQWlRPodGKDNZ2R6SgcfOzitLO59WvC7j1VxU6byMDEuR0W5NdXTJykRfIWB7xr+/gP5j7kclRma2784nkG0UmSt1f+14K2ysmtlBVgGUy/oWsDT9oEalEkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dck7mwi6pxDzqM9zY4xRkCLGWJ+A6oeuyWtlmPpHZU=;
 b=LCFvwqQ3WCgkmNhMXiFIsDg1XN7qB3RJjVpvvyieJ5mau7SKAi9D7LzgHCrgiJG8vQTeQACRnNbeK9rrKp1aNemVaVCz0X7MBQv+7xeObRDyUg9xnljkUT2pzdpD1fabzlZik8L0i3pdk2z759Nh8G2DGLsJp2lDHmLgBe0v0zA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 03:25:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 03:25:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ching Huang <ching2048@areca.com.tw>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: arcmsr: fixed the wrong cdb payload report to IOP
Date:   Mon, 10 May 2021 23:25:23 -0400
Message-Id: <162070348783.27567.9194132235667571393.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <d2c97df3c817595c6faf582839316209022f70da.camel@areca.com.tw>
References: <d2c97df3c817595c6faf582839316209022f70da.camel@areca.com.tw>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.20 via Frontend Transport; Tue, 11 May 2021 03:25:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 329d40be-71b5-4c6d-58f0-08d9142c72f4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44086E3D53983319B13572B58E539@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PtkuSgxP32MzyDRTsmKjoFMyCnqhMHQRvRSF8TDuQEt4f1J+DVj0Bx4kQjoyZDJ45XnXLkqzBTZNe9Ixe19wr9JeYNVhPWb0wuz2qtjSVS9jhtVS4sAKLXLFNdQhdL/66xa/GZu10LeuboNIFRSmdK3lAtlooAC/ITJoXrBMkU1FIVl5zHz59v4dhtKZ3z3iYPymsu9qm3whZRGr0G5bpH0Xlcogr1upFtdUSbQQzzqyEBa557ISffGiS0CP5dBFOcFhevv1XZM6XkEnMGyy1exVdEdFp5mgCTijsFrSwEoOTsc9ykBP4dWUc7UA2UuQnLZWYcoqywTO6/+ypsnZ8GRW51xSU59rMIx6YpCxamMZjw3LHzVdsMaz/BU/+X+ZEkO6o4bBoPJH25SqaN7FEd8moutE7AiqhrlLASyWBEZYN5ColUNqo5eydia0dvWyc55F41IOh0zt/jWCAEyoAdUqnz07zTusc1XVtUhLU1JdBWJrTRYqdXJKbXpZIC1XanwESwHAZ/BME6QMX65SLtl4rZEfkZEQ5z3c+kf4ce60TQcujhb2IrY8Pa4Q3GFlsDWWEw6QTTl6lhUU0jP2qVzUemBu6zCD17HW8Pf5huvD5tKf236pRB7/HKUUs1v5DupykHB6YlparvulSgDxqr4mOWuA6xX3XG/kRLesko+uMPRxL+7Uo4dXH14TDpZOlEBo5bcT0yXicnt1SWw85nHjI8OhV1ETmjP5yrOYRUg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(66556008)(6486002)(107886003)(5660300002)(66476007)(16526019)(110136005)(2616005)(38350700002)(38100700002)(6666004)(478600001)(186003)(66946007)(36756003)(2906002)(4744005)(956004)(103116003)(26005)(4326008)(316002)(966005)(8936002)(8676002)(86362001)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YVo5V2pWcFBZNGgrSDQ1bFBjZXpEL0Z5bjdhNDl2eFRMcHNEcG9uNG9OVHlW?=
 =?utf-8?B?d3FLWFI4YnN3MzhRR3A4ejdZSE5kWnFjdDY2R2QzeHZJNWhVMzg2ekhvYTBy?=
 =?utf-8?B?Y2pMR2J6WCtqOFdiZXFsYjRtTGRvM2h1K2J3N1hCV0dkZkIweVdoamIwMkVl?=
 =?utf-8?B?aThJM3dJNDlMcHg5TWhYQ3lzNERJRUkzbWhFd2R2UEYxK3ZoUklvRnMvUWgw?=
 =?utf-8?B?TGFuOG1ZT0Y5YnMya2EzT09mblgvM2lPZFZuMHNBUVZxbS9RTHl6VExwMmp1?=
 =?utf-8?B?cjFUcldLSGZrTkE4dFB5K2dUL1JNOXd2Nngyb0Z1QlNHTlI3SkVEc1V2SDlQ?=
 =?utf-8?B?azVUSWdBcmpxSy94enlLUFk0NWdLVVVjeC9HWEVPRWZqZGlGa29WNysxUlJs?=
 =?utf-8?B?ZDZ6a1krZGUwblBzdzMwcXVuRTFTblFpRFFBaEVSR3NuN2RnTm04aTNML3FZ?=
 =?utf-8?B?VjNVWmZ5TCtQZ2p5WWJtNXo1cmIyaHhuZFQ5c0JKUDNtMEdVSjRPOEhaWWlr?=
 =?utf-8?B?U2FIbjlwb0RIN0J3Ym1BVE9tOWFuTmtteWM5NDIzTGV4Zk1kTldHcitmTGFh?=
 =?utf-8?B?RnVkTzh1a2xQVXY5QmhRWDhsVFh1aXVPcWdnQkphY0F1UFFpMldmbkRBWHV2?=
 =?utf-8?B?YjE0YXFxK0pkbytlc1pqSjVPdzdUNzRNVFBPMkE1THFhd2U2Y3UxUTB3ZTA2?=
 =?utf-8?B?ajRINzY0YnBuaWIwQ09NRlIwUFk1bm9YMTlUdnh1NzRPYTI2ZTlRMkUxbXVr?=
 =?utf-8?B?YVgxYXFrREkxZGpHZyt5Rk40d29xMTlXQW9yQVI0TUNHUnR0ZGxPaGp6MzQ1?=
 =?utf-8?B?dzZnTUNtVVdnNTV6UThyU2NMZzJNQmhNWmN6WnI1bFBCNXlwaGNEMnJTVURJ?=
 =?utf-8?B?bjlkQlJQSUhmbDhjTDhtMEZaWUdVb093Z2ZKajgrSkJLN2ttWERLdDB1SC9i?=
 =?utf-8?B?ZUxwSDNHMDBqVE9lb1gyR05ycWhvSEpmZ0c0a1RPRUJqdFNvdE1HMlBnY09P?=
 =?utf-8?B?RkV5VFp3NnpITDZxZ0ZEM3BJa0J4UUgrTm81SjEzL091Zk5LVkd4NmlXckM2?=
 =?utf-8?B?b0hWOXZ0cFJ0OEdwS0NmMXVWQ3dMUmNuNkhaQjlpUm9mVmY1dHBrelJNa214?=
 =?utf-8?B?YktXTkc5RnZoNGJGczhpQlNYMXl3bENSWlB3eVVPTUFHenFVdDlPdFMrQ0JU?=
 =?utf-8?B?N0hDaFZOOUM3dERyRmU5UlNXb2tNaXFwRHhiRnVvY09aRTJMaDNrTkJUWjll?=
 =?utf-8?B?REIvUGpZNnB1MEd3elkrd0t5QVc5cUYvQ0pYY21jK2EzeHV1WWZPNDA5bWl0?=
 =?utf-8?B?cnhlZGJPTmJOdFdDbWQrcmRUT0R5WTIzY2g3Y2dBc3kvYjlwamc1QmVSdG9z?=
 =?utf-8?B?Zk9CRVd5b2xNVVJsMjN0OHNHNDh6d0hoZk5OenVQZi9ZVzI3b3o1NTdWRFhO?=
 =?utf-8?B?UzNNdk5adUJwMHQ5MGZZVWRFR3llWDUvVU9xWlo1SUhkdy9zdVlaSGRLditl?=
 =?utf-8?B?eThXOUxOY2J5eUhUTXY1dVlwWjYvRmxnWnUrdDRiYnNTQUpYMEVmUlZkTSth?=
 =?utf-8?B?MHRKZ0NxVU1JVk9peU44c2NzQlFLUm1ES2RHRXZTV2FWeE5wMGFPOW9RR2da?=
 =?utf-8?B?U3BGWGljb2RzNmJXT0tTeDY2VUgxZ1ZzNGhNMmlPMENEZFNJYXVZOHNQOVk3?=
 =?utf-8?B?dWpBd0JRNStpTVBTcnBzeXFhVlBxVk9CRU5uUi9uNXd4SmU3WVh2UFJLRmM5?=
 =?utf-8?Q?H7dlofkxDxm++7nsjxJS1s9vh5GEVf/S+5OmoKd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 329d40be-71b5-4c6d-58f0-08d9142c72f4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 03:25:39.0941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4LPnIpdl3MnHf3jDfIkGAAH1pkuf2jFF343Y41TMxHa0mjm8t5NOkf/8BYpHsEHuhfxz7Gm18vTX0Zwqg560e7csnoUNBP40GirYgTB4ewQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=979
 adultscore=0 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
X-Proofpoint-GUID: q5AOjb9NNYtyyiPMhxicClrLtRBQDXCm
X-Proofpoint-ORIG-GUID: q5AOjb9NNYtyyiPMhxicClrLtRBQDXCm
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 clxscore=1011 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 16 Apr 2021 11:44:57 +0800, ching Huang wrote:

> This patch fixed the wrong cdb payload report to IOP.

Applied to 5.14/scsi-queue, thanks!

[1/2] scsi: arcmsr: fixed the wrong cdb payload report to IOP
      https://git.kernel.org/mkp/scsi/c/5b8644968d2c

-- 
Martin K. Petersen	Oracle Linux Engineering
