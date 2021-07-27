Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F3EC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 04:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6F0860FE5
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 04:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhG0EPR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 00:15:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:60854 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229954AbhG0EPN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Jul 2021 00:15:13 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R4C23o027252;
        Tue, 27 Jul 2021 04:15:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=VbBYHL24MU/sBLvuv271kV3McXH6nwuiaa8Ud6gw9Cw=;
 b=ZEhTgrWzgkcsa6KuwhHiESLUNYuzR4yX+jMsh+SSjr95Dj5fISfsTgzJdOhA8o3+b2tu
 y5T5D+qgzE1HF9ioKYv0SfEbRHHG811zKnUu+DzwuVoexpKTMzX59QIN4ssIbAlkBu2d
 z0Pk1NbZPwT3WdCvkxeOT2KVvjNX3Tz+ix/VigcnLUvJIEIfCU4epV2IJmcXLBWifz2g
 VkuPsm/wxE77itUUqybDTIlOopiJJCh4xxQUvLzcOKtgjuNR/2rqxET3DSRVwAJQdjyz
 Tbu/d2oliYMpEy7z+o81JcIP/5aB0vJvD4U+gbneNF/jbt1JDoZZsHyLJdJj19fj+Q2Z UQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=VbBYHL24MU/sBLvuv271kV3McXH6nwuiaa8Ud6gw9Cw=;
 b=OgfuzxR9GBirvxph2ATxeq04JCFAr4PC17rMnrgwU43r1osVIdlMdGzisW/MBbZitzNW
 xgkEcPh7HR8M8RLJtJzuNLT74w8eV5zholLUuwbjRDqwXK8SK7krWj10sMsGsh7RtVeX
 PsY33u/U4ENU9vZP0kP4ZC4xywHoPcz8T6MOPVQ2PkxOt20GXCl3X8acT2Q7iSlet3z1
 yC/qVv3g5xVLNllSBgYy5cydZCMAtYx6bSPKjGzzh0e97LCNq2YHO635a2//rv7/4OZ5
 02A7prglQcxxmEsJmuqghUiEauVVvyD6MZwPEXD24yOHNOdaePZMiPlroXPlO50AP45i iA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a235drp5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 04:15:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R4Ah82106793;
        Tue, 27 Jul 2021 04:15:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3020.oracle.com with ESMTP id 3a234uq4ja-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 04:15:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6ziAYJc7q/Uw/DKVPwMbkbvk30jg8I62FFyim5sV331yBLhfO1icAyCpo4Us6mbCW6e78nWnjtEwzO22iElgGSSu6QFtAfFBAHB/q64hcM5w/M/Xc7Nm5z4UoDIvf6CY9FnEXfyZGnJUsBjw6ltYRiwLB8UCf5chUNd+TkgUPcxJ7jp4xqi98wzXUAhyU9VP2lhTrle2LduCDjAaoySYUtscKnjK4AW0CqayeHmIMI+12JcfYOuyw0z9uHPe2OymbMqLW/fY0m5BieeOcSISdJQIhKwVPNoNYwH3jal9buuFU+i9iw6RWW49RCTEZOPBcxM7INtTfzIs7HHqTvZtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbBYHL24MU/sBLvuv271kV3McXH6nwuiaa8Ud6gw9Cw=;
 b=e9r48fzV+9+Gqyy3Kb2rfadXil/WW7d057hpzuhaL2gWg/F3rEKx1U32QNE5RnjCREITrq95OhAAlY56ZNos10DPErFfIjlvBIrDihxD3dKgERsS5TS7RSJGUn/nNr9rOo2tQCXPhU76qZdJe6RQ8UgUwu60tW5cRbHpaM45b9NsUdUd5TzYCIyCImWTeF++fHTf2BDLek+ZW+XVA2h3H+HYoc1u1lDxjvrccgiNQ/8h8a8d7VGhUSDMtYY5cpiu/5i8n/g6Yng1U22JqaOcb9KKrwBhmvxPCuOMiYRXVf9sh8rGOGrKMVssszC21LM84MiwPuF5nHDQphsdR+yD3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbBYHL24MU/sBLvuv271kV3McXH6nwuiaa8Ud6gw9Cw=;
 b=eXe1mgcJ31s/M1Kg9WBI9kwscMySw6FPrfdBSDU8NeDg0pllGFSXRg41gKMYw2EYVuUGGIPoAOtM+aQSkNpoKqzjJ53+T5NJDjtzTrS1GlbzWqr4zzYjk0UWd4n9Vb/BdWigpy1FT1141My7E1x8vshpvdi9c5ooFLVPOa9iNbY=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4776.namprd10.prod.outlook.com (2603:10b6:510:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Tue, 27 Jul
 2021 04:15:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 04:15:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jason Yan <yanaijie@huawei.com>, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: libsas: allow libsas include scsi header files directly
Date:   Tue, 27 Jul 2021 00:14:56 -0400
Message-Id: <162735928262.14097.16860899910174896696.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210716074551.771312-1-yanaijie@huawei.com>
References: <20210716074551.771312-1-yanaijie@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0102.namprd04.prod.outlook.com
 (2603:10b6:806:122::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0102.namprd04.prod.outlook.com (2603:10b6:806:122::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 04:15:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96c14000-ecce-4b35-8fd5-08d950b51abc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4776:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4776103288EDE665A49168CC8EE99@PH0PR10MB4776.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /eKH8YT0BDXtmEfNIUUCJgIQcjt0SQ1+VaWQNtAnnuq9lXbZRSTgWASkECn75ii0bZcKYuevy5tmrrzqlxAQ0MHzNkLS2yQ9WCcK0jQPjDxJjT1liu5XPLJ19yppdzX4JBXQ8ripEjymoqfJh/cOH/wvw1bZjhG6KF//SP8bvUeI5Pu9mkTFV6AYueXQbW0h7jzzoVSu4x5vpJxKsCSr2VGz+NA1cUgjTkwlJJvkhM68IWeBFyyUfp/emXxMm6+jEa4T7FIeK4u+8rjN6cV+ADfXKWixYJ72GhzdKtRImM2KlPdfj3MS6f0FBZ0CN01bW0+ycG7qF+49GZYLsN9lUJpVa2rGELMLs3Wa8n5vfL9yg+wRuvk66e0+sHMtmShY6OjxgU4IjBUaQlc+V415L6PurqeQS8DDlCv6pZuOuO4xR1F5olcduMqJRYfEwmtrSB2G2EJFu/rnG5UxblUQQd3q2rVLspjnMOTqV8cUP1txan/5ushtO1FS9vmBP+SOcwVO6p/heF1aizRONBr9O6uPiKXv8StjIPyRZIsEAsgMxJNp1nBwvzb3NVa4939Fb+9meff8Owvot1QnLV/rC7y9X+o2juVn6rPrsWfULeE95Q8PPttiz9AJ7zRfxk5KuglXtl+uKZLQMbPuwCqQWBcAQ4gTToIZLs5DWu0zdfd4Vp2AWTMqEkvLIqz+DkRflXFrD0oNSCniZQnk5Lsv9BNP6M6URONipMBWduD6JXvC2SpVs9JvgMKjX6LCsrxV7uBES8nRf4xwIVi3+kwWuKTWm3IeNcSAnQ17vEEqjQo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(396003)(346002)(376002)(38100700002)(86362001)(26005)(54906003)(38350700002)(4744005)(966005)(6666004)(66946007)(66556008)(7696005)(52116002)(478600001)(6486002)(4326008)(956004)(66476007)(8676002)(5660300002)(2616005)(36756003)(316002)(2906002)(8936002)(186003)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cllZdm4xVG9IUkoyRmtEcTYzcnM2QnBKVUdTZHVkcDFJNTc1emU5VEtCUXhl?=
 =?utf-8?B?N09UazF0RE1JTlpjczJBcXlnVE9DYXo4dUE4L29rNi9pV2hFZDJVaDJ4MU9E?=
 =?utf-8?B?YTRDd2tUemMxYWx3ang4cHRYZ2xDNWtTR1ZCY1B4Mi9iU1Z4MDc4RWthN1Rj?=
 =?utf-8?B?aGpHOElDd0UzUkkyWUNsMkd0N3NFc3RzdWo5KytEUnNFeEk1YURUb3M3dTRC?=
 =?utf-8?B?UnJCVktycW9QcEVNSGU1eGh5Uk51TkVkZUhTamhEWjYxUVJRa3Y1TkxvZ3hP?=
 =?utf-8?B?V1hXd2ZwNCtrdUJGd3doRTRva05CRU5VV0IyL2gvS216V1NDci9ESmlkNm9M?=
 =?utf-8?B?QStpR2kzU2RtTEt2MHdFd3pGRnlYSWVMWGRER3NjeWhadjVSWm1tbnhYM0N0?=
 =?utf-8?B?YThkSjdtdWZ6TWhQbTVHQVBaa3lNalpaOUk5NVNLZmhUNU43TWtjRjd5NGNC?=
 =?utf-8?B?aHd0ek5oaXVUaEwyVEdsWDU5NUtWb0NIeHFwOXRsK0xpT2tSelg0blY0UXhS?=
 =?utf-8?B?bGNYWjdhbWVEYTZkMm8wd0pBSTE4MGNrMFpHMTVGVk1jL1YzZlg2MmNMTnpF?=
 =?utf-8?B?b0hGeFpYaloraWsySU9hS1NwWHZOOURieVJHUUlEdjlqRGV5REhLMkJCVUh2?=
 =?utf-8?B?aHhhejNsYy9LT3QwSEdhU2hZbzgrNk9ySXFsNTB0eTBsZDhmSGtBMEhScU9K?=
 =?utf-8?B?QjJqRTRJTHRvQWZnWmJpZ292L2RmQ2kvRGxiQmwrN2xabkxqbitKcWJrVC9l?=
 =?utf-8?B?WlZycGF1RVBEUGVETHp2WVQ3Nms3OU9STm5RRlVHY3ZGTjhUUGdpYUNlK2VN?=
 =?utf-8?B?L1dETDlaWnJqbWFjZWRPNEo3UzhsVUJJQWt0TGFOd2lJd09jKzhqNHF2ZTV1?=
 =?utf-8?B?d0c5VnZ5QzloY0RVNXU0RlJ6cDFLUXBUSWY0N09FRE54RjZLN1BVMmpJSmRR?=
 =?utf-8?B?aGxZUEZoQjdPVFduWWt2NTB6dmNwZlpzWU0xVDFjRXQ2dVFES1pBL1VlOTlM?=
 =?utf-8?B?OEZYdVJteVowaDVYL25LelM5OU1GRVFaOG52ZDdlSmZxWTc5MGdRWFVNRkd0?=
 =?utf-8?B?T2Z0aFZFVlF3NjRrMXVQdWZkM3ZlMlFncmpsRDJ2NEdzN2E5VTdrckUwOFQx?=
 =?utf-8?B?bXVZcXpCMFNqQVVubFl6Yk5QNlRVSFlaa09hV0Y1cVNFUVNNSUlKb1BuTDhm?=
 =?utf-8?B?dklJaUVkMXlYdFdHL2oybmNOWG9QWHluOUxmOW11UEFLTm5yQnpkeFFWendD?=
 =?utf-8?B?WXc3ZFpzNEF0VSttbnFZazhjUW1oYTlQWFRhcHNGcStxT3NuQ1g3NzdsYUlr?=
 =?utf-8?B?L2JSY0VJbW42Ti9NejhZN3dTRW5YLzByWitXbHpsdHB1QVhibXN2enRKVHJM?=
 =?utf-8?B?SWtTV1pBaWRpVnhKeGU3dy9ST1ViYW43UVJYNzZUTVdUUWhXT21vM1VDYVFp?=
 =?utf-8?B?TDBvcjZiOEltVnB4YWFvbEVad2ZUczRKQ2tyWFNySHBoZ0xKd3o5U09aaVE0?=
 =?utf-8?B?Qk9PWjRkaldSNnNYd2xLdzJZdDNtSGlsUkxEY1dPV2ZFOG1rR09rNy82QmZ2?=
 =?utf-8?B?Nm5qeWR0KzM2Tkt6aWFCL292bTNjL2RnczNnczZZS3BzaU13bHhRWm9IZUk3?=
 =?utf-8?B?MWlUUXlndmJodHlyRkhYU3FWNS9HOFdTWFBMRGo4QS9DSHhtVEZxdUc0OGh5?=
 =?utf-8?B?U0pEQ0FLOVg5eTFiZ1lVbnFmMDNlL0VqbzA0bDgwdkl6a0J4cVFmWVlKenJm?=
 =?utf-8?Q?AYfSy1XvRXNW/5KAkOZYBlcq4NSmjKFL5CQPPLW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96c14000-ecce-4b35-8fd5-08d950b51abc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 04:15:01.9385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6C85egZ8k7MpZ7v17Jmol53PuO/PDP5bUULT2W+J19R3sbM7hF5THkdeCCBx7T7tJ1RLPmhOfpbi8+mKnr93bIiKi2St7aZDIDCuzjktM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4776
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270023
X-Proofpoint-GUID: HA0XEY12__lguCP6SIiPMvz9tjCGbeic
X-Proofpoint-ORIG-GUID: HA0XEY12__lguCP6SIiPMvz9tjCGbeic
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 16 Jul 2021 15:45:51 +0800, Jason Yan wrote:

> libsas needs to include some header files in the scsi directory. However
> they are now hardcoded with the path "../" in the C files. Let's do this
> in the Makefile to avoid the hardcode.

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: libsas: allow libsas include scsi header files directly
      https://git.kernel.org/mkp/scsi/c/e15f669cd996

-- 
Martin K. Petersen	Oracle Linux Engineering
