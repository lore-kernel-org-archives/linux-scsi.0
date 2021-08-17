Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A91C4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3673660F14
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhHQDCk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:02:40 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:58050 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233800AbhHQDCi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:02:38 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H2xwFf000733;
        Tue, 17 Aug 2021 03:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=u12kJNG2ufPS1VfPKFTxagq16Dr+lYPKj57gXHAP/R0=;
 b=oQlPDqPL7xcbToTUPsTrV5rG5rsJwCejK2XohJ/HXncCo3D3oy60gPzTzs707N2QvWPc
 MXADr7I85nHtrHDU1Zby0Dw5u29uwmCV4kdA8zL5drc5vyWSXWGsxxMLNjseMHbzYYwW
 jC56wf3Ia7l17fdG69G+wHcPL1z+RA8DfLX77p9kT2upi0OAZSZVSqxBHVNX+Mp7DJ3B
 wAyO/MFQLN7Jrm69F9l6IPLlvpw1X0mus8j8Q+0H0LjhVj+fgwfysvmT3gZ4FqZxQm8g
 Pb1L/kYc15kqxj2o74VlHTtD24kCiSLGvd+6DlzQPzlJRiSCHeS3JJUa+w86OV/iiB90 ag== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=u12kJNG2ufPS1VfPKFTxagq16Dr+lYPKj57gXHAP/R0=;
 b=T9r9013+pcyEFK+4CpYbICW61PZ87a4IXu3C87Su98DE9fNf91INQ36oSPxpV0IT9+Ij
 GK20Ctbr+nE/BlWG4O0D74T8sdLLxRm63/e9Hd4RsMRDyyYW133sUAtLSGP3EPVRZxDY
 40jXpT7gtIla/Av9GoB/BwfLp9xQhMPtlYavjqXqPEFv7mJnsbKY7d9U9AFqVTUkQsp3
 7i2aUIK6mfIRXI/SLSiF65fhWFuaAI+2fB7HG4y7otcxEbgBw7CTtRiLDzKdtMWnXtCa
 IzpDu1tAyr+YAVtRK1yWNU9VBw0Tbh8q2Mx9o9Xu2JrcS4MktBIVQkkwq9sem6GLMtWu Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afdbd2xkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:02:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H2sum9193925;
        Tue, 17 Aug 2021 03:01:59 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by userp3020.oracle.com with ESMTP id 3aeqkt9snm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:01:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DF0Mpy2s0rJLmxv5RWqjaNlerHqwCnFhhb8cjHgrz2d8R0skdgYmtbosJMv87HuvhrXyRfskPaUHAppEUurWwkkm9EFtrQkg7Uu9knTzmzXNEf+dVNBT+1gvV1qSJL4ts3ljiyYg7xgvzxqbJy4+ntUhD8SF/p3JfBbYmmayEmdFd9xHfBpgpHshvBTHQ1Wr+EA2nrH7nxzjDowIESJ0FcapzjBfzbHBJdfYCxOLPA+dA+tIkWADGhm9E/+68gPSa4xmwMo8fyb7VviFLr0/j2ruv0XCS7uRPCROVOKNBCG7Te18KxicEavHyZGqGDI2KyMK6g1ku3hacFLtQBlB4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u12kJNG2ufPS1VfPKFTxagq16Dr+lYPKj57gXHAP/R0=;
 b=RhxUXmXP9Ou1lHvJrn+TFacqd+capdnECDXhM2MesiuJmB0HWWF3qp0wJhwUdb+6AmQpeL/gfZxXFB6ATkDeCR4WVJtvluNhfY7wTguqtaaoIYVMPD1Vyv0OAWICtawzqRWT8p19nGwhTF200/PFbxhwznqTHm12OSAkcjy+F1zcoruvJUrFSUUh4K4qEti/eA273o9CDBn2wcTWmYJXlA1wfu0rq1xwHXoY9adWTPzhPmnNBtDwbO+QMtkJ2M/ZDdQvtmyCElSx2p3qktS5UWLyQb9yI+GXSmwbemHdOQbSUvbyZUYPwBsVmetkD84YWVUySHdNxg4QuZvFIOqOVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u12kJNG2ufPS1VfPKFTxagq16Dr+lYPKj57gXHAP/R0=;
 b=Fknpes0gDqEM3BOafJx1biLNpRcPG91zWTbT+mXwh/v2QxDMtfy5vSO78fjgJhSkxVVDPNa/ewaBD121hi3gNW6Eqe/W35EC2T9NUFcSNH+ybTGRQPtfg8dkT86AKJ2X6y/p1w91Xuus3Fq0M/J1n/kT0vqBkxia/AB4ApwQts4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4728.namprd10.prod.outlook.com (2603:10b6:510:3b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 03:01:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:01:57 +0000
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: smartpqi: Replace one-element array with
 flexible-array member
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmucojub.fsf@ca-mkp.ca.oracle.com>
References: <20210810210741.GA58765@embeddedor>
Date:   Mon, 16 Aug 2021 23:01:54 -0400
In-Reply-To: <20210810210741.GA58765@embeddedor> (Gustavo A. R. Silva's
        message of "Tue, 10 Aug 2021 16:07:41 -0500")
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0251.namprd03.prod.outlook.com (2603:10b6:a03:3a0::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Tue, 17 Aug 2021 03:01:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9d3c60c-176e-48b6-58a6-08d9612b6049
X-MS-TrafficTypeDiagnostic: PH0PR10MB4728:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47282D346F0BAB5C7E9BDCDE8EFE9@PH0PR10MB4728.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eDafS1/BEplb8+X3cccmXI2nbO1HBzs7RB86+CjNcrp84fi2wx5zD60d6s8Qp+ARqfDq8Ciu/SoUqM+iCM/sJKqN0B1HFN1LX15mMSl1dnlCDmpEhxeJlM1bhxC4pxaQfy7NuS9OexUWIYnUOWVri3CTnXzL/uMQops6IlmKCUlVKLazj1OFWTIGFAVqbjuW0EF78+t6BNyGADG+Ljp6xijuPxMst6NDHAyLL/JXjo9Nbyu3mzxZgQ7WUEkWNo+typJe7PUFX8m0dZC3Jhtfs756Gw08u7nsa9hUeEKbnBgzqqJLfAALu3fFJuBNlZG5SflWodk6qk/7Oi4jGF6bXUHpACsyhRT20QMuPwaFNMUnvmKy0P5z165WRL8XamSojKH1F6XGbpyJHzOr6y1TPq366qKi38CDflD11ZgppVfVc6bigVO94YRAuZEppMmc487VpM7ifSo4S0et6oCSsRljLXyfzcEkt1Eh4REK9SOwNfqAdXUvdkKGiyCT5qm7/pzUaxEOx0X+zgMYFYlvl6JrasYA3NizAacYdXW+jnnxF8qvqr+AVKBI8nNiAIPviQLnlId1nQYKwtybZP2JUDBsHSt9MDlUNKbI2DSW8UYkWjrXkYcXovNvrkvXVYk1qcJAphuFOIaC9SpDsG5qiHhoWFYB8K5t5a9OKgNUxbV7jGio8yTpy59T286fBs2dqxupea5dcYXGfOuVyRe2SQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(136003)(376002)(396003)(52116002)(66946007)(36916002)(8936002)(66476007)(66556008)(86362001)(7696005)(6916009)(2906002)(8676002)(956004)(5660300002)(55016002)(316002)(478600001)(38100700002)(38350700002)(4326008)(6666004)(26005)(4744005)(54906003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVJoalAyZ0hsdzBpd2tkYmFSdkJEdHEyU3pmOHYzK2lYdUZHaTRjK0JGeHRM?=
 =?utf-8?B?WkJkOFB2S3gvRFR2aXAzRDFaMDZwWCtRNzVrQ3ZsdTJGVGNBOVhWZ3VvTVFJ?=
 =?utf-8?B?Mis4eWFKNnlVa09yRDlMMzNKQkZwbkQ0ZlhaZDJVMUVtMTQvZG1ZN00yTnJF?=
 =?utf-8?B?M2k1Z2E2UnlLOUZWRzJvUnk2UVRyQzVreDcrbktwUTV2TUFlTTBXWERTVUVH?=
 =?utf-8?B?aFF6SCtQS2c2dUZRQlVFRTdGMFJhU1FnQlpEWlVJNXZkZnB6VmVYMUprajRP?=
 =?utf-8?B?STQ0Q3k1UGQ5N1l0OTNZS0o2Nkc0RlgxbmNPU29GVFdzQ2FpQW1BWFZNNEUy?=
 =?utf-8?B?ckdxYWIxeWxzTVdhU2ZQUHJ5a0VVMTRiUjhRSlRPUzJjT2RGU1RpV29iN1V4?=
 =?utf-8?B?S3VBTDkyRG1DZElDTmNuTmhsZkdpdE1xc08zUkdFRWRIc3FXaHdTdmNZQXU3?=
 =?utf-8?B?Y3ZGMHUrVklLQkFmRlEwODF0QTVwMVVsazhzdmVvcEpVOXJ2MkhlNU1oUi96?=
 =?utf-8?B?MGxzbVFsOEJ4cEgvMWhZZytGVVdEeXJwemwvZThiUGJoOThpNTdQZzR1QnRD?=
 =?utf-8?B?d2ltelBFWElUQWxZKzdzUklWdTRaczNUaFR0OGFtOXlRMXdlN2FFUVFhVENZ?=
 =?utf-8?B?K3BWaDVIVXNmQzJNaVU1RUtPR0NjVVJkUm9ZcWV6NmNadFhFajlwK1h2b3E5?=
 =?utf-8?B?UWJNekN5czRjampHd3BzY0ViV2dkUVpkN3E5VGk2WDNJQ01pMHgzb0YyMUMr?=
 =?utf-8?B?cEIzK2w2U1BDaFA0eWg1WWQ5cWRkRGxKSzc0My9ycVh4Z1hyN3FvWjdrYWVN?=
 =?utf-8?B?QUpxR2MwVTlhdEthQWh5SmRqd1VjUVRSYS9YU0o5RC80L2xMemRrYnJFUEgr?=
 =?utf-8?B?STV3Zi9lclVWemZ5TFBSdjZpS1NHbWJ2OEY3WVROckk5cjNneXVkTHJoSDN0?=
 =?utf-8?B?S29Hd0tsUFk2VWZJWGgvZEVja1hqLy92eXcxbFRUdm5ZLzVsbllKMFVPUmJ1?=
 =?utf-8?B?U0l2SFlwUG9hN2FxZDlQc3dJRjk4SWdHK1ZhTEs3dUdiaEwwZ1JuUzZoWVh2?=
 =?utf-8?B?WDRUNkhLUncydlVRUXNqT2RwZU1kNjhMV25xZTRUdEMxc3BoTVVHbHlDYytx?=
 =?utf-8?B?eFBHMWUwK2VDcmY2Qy9oaE91T1JYOWNKY3FNS2NlQml5N0NmMHZVZ08rb0tS?=
 =?utf-8?B?UWFNM3pYZHkxZ3RUWSttK1RseXQwZCtNc05HaE12TXZOeVdzZGREVEUxWjVi?=
 =?utf-8?B?VVF3SkhXbmVOdkVhMHdSbGZYZ2l5SGJMVUNKYTJjV1UraWFMdm9kMTJpQmE5?=
 =?utf-8?B?bVU0TnJ5cTM3SHRkQTZ5MnNFWkcrTldyaXhMY0FQby9QTGtuL1FtdGk1cmRn?=
 =?utf-8?B?NUFEZEpWclZCYTB6a3VxQlpYQzFCY0FLZEhRb2NCUXJiYThQc2FuTGEwWENj?=
 =?utf-8?B?MlpUVHFmTnp6VkdUb09tbmFsUk5ySXpsTkhRaHMrQkJwNUhRVXFTdzFpeGZW?=
 =?utf-8?B?UjlEZnFnQUVyOUZ1Z3JOUGlpb2hJZWdpdk9rbHUwZm9GUUVrNGRZd1F0aUlP?=
 =?utf-8?B?VnhKOHIvVFFoV0pqZmdBTjd2Z0tsc2JScU9wTGI5SG1jM2s1aHMwQWR0S1lO?=
 =?utf-8?B?Umg4Uk5YQjRyWEpNNDlMczVYQVE0WkwxNlZzclIzKytWRmlvZGhGVmhLMEtq?=
 =?utf-8?B?WmlrU0IvK1lNZk9pMFQxU0ZmUDYvU3hZNStrSjBVb1BTVzkxUnVsMUx4WjRZ?=
 =?utf-8?Q?fpl7GlR6JXADM59C6jvLRjLX3W4P/IrbZxnNXuf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d3c60c-176e-48b6-58a6-08d9612b6049
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:01:57.8464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XODdEh/dJk5WIZFT/APswo6qBRNRPnRAM8c0xzY/Cgwe0Gu189iwDcZIsWssQKK5SCxtcmzsfBY4HC9pFM1BLlY0rw0Ml93iWTefZ5xD3AI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4728
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=748 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170017
X-Proofpoint-ORIG-GUID: ogvqARrWT8WL2xUHdNxQ-iDaJkVwfNO5
X-Proofpoint-GUID: ogvqARrWT8WL2xUHdNxQ-iDaJkVwfNO5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gustavo,

> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a
> structure. Kernel code should always use =E2=80=9Cflexible array members=
=E2=80=9D[1]
> for these cases. The older style of one-element or zero-length arrays
> should no longer be used[2].

Applied to 5.15/scsi-staging, thanks!

--=20
Martin K. Petersen	Oracle Linux Engineering
