Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81737C48BE8
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C7C8613C7
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhFPDvw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:51:52 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1538 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231282AbhFPDvi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:38 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3kkYO018170;
        Wed, 16 Jun 2021 03:49:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=NhHIZXKLWurbKnodXE7PhEfLqmpP6FrNnfQOp4NDErg=;
 b=Rfqf+wmH7l8G866ZXK+Zd2XWUFvAsElqmjkrF4rUHvINcB4Nt7Z71xMpj4KHBnBn/HnT
 GXgD4ezw4J9jVi5wTmfjCNTvyREvAv6wx8UbGjhFT7cqe0W8EDCEGxKQkARK30etyxPS
 RS5IkUvwqq2gfLB+jtwULXV/WScfI2CglDErrMHCS7IY0Ai/P7KfOy3cWGwhzWQtyjWA
 lt/+eNjFbjcv7Ysn/P9dq4ZGXlnm9flbElRyHVmcHCpIKeBRTrgLR9bELtU25M48oRJ0
 WKytyaisM1KvI+AspaQf9zMcAgv3q8L4nsDPrFOHXeo2jocPtHB9xcocXWJH4VjTGtir 8Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 395y1ksuc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G3jTa7109480;
        Wed, 16 Jun 2021 03:49:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 396wavsm6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcImSNCqmAfAbK1t81vnZ0yGOAq84DQ8r0DbeVO9ieNWYs+A7HqJSYq4/fvciHmsRYBs+W1ijHKR9jO1Kt9+5Rzrk74bnP7vcNyJhf0BP0D/VrXOT1fhvCxc1hQFeHePp3SUSXeQnqfPgLIDZj2iV1Jngzg8ZbI07MLA29Fdy/jafw6cqyxiOWhLyb/fttt5g384YNY1tmUVT4N2mKB18cfC9KNWhfywu04lDIldHLY2HW6tZgk7Jm4Dei3obRi4tFfx1tT9i8SX7eNO2h5s35VKGhMHT1q0X549Kbbk+7XTM+8+WUEQ6quLeyAKsavpIwdP1+6P/36I8JSv8QWELA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NhHIZXKLWurbKnodXE7PhEfLqmpP6FrNnfQOp4NDErg=;
 b=kRssIX01gFPWVbmPcguQvEZHBpoVW9QWszwrVLGSndHMDgz7BGBgI+rgFekSgHxPpnWGy5JJRTbPSqKRm9FNQfjoT0faso+hrCUCDRQgSqTRcaCIGPdRP2As4d/FmHF9VLpfFIG9lr/vNPadNpDbKmUAhkG+0acaYUlAEQ+m7pDlgtMH8dwHYBaabQ8+vHp63KGt/fyu7mDtVfNJSKigewrFNk5tJkQQ+SB+EoOPWbFRLkye2s4cbcjGxLWyGQfmaGk/iPLX3fC1ZwHvCSZ49ocUaz9z6D1xqbvVoRg993G29wdpckHFjxoPXhd5CTeqCJ4zQqhsOuq/tuSpeGkPrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NhHIZXKLWurbKnodXE7PhEfLqmpP6FrNnfQOp4NDErg=;
 b=rrety9zjbBxHyLcNf7px3wSSDBceD1woWDE8AILb6nQDn7zURvHLLHDenh3pQXyGn9Yip9CaGP6yNhrND4IOzRX3Gx5sbxdavyew7PHni1xUu/Eldc0fHgP/TmsG1HbcYGWzLdgAKu8mgUQXH3dONivbqno25u31dqqiCChwRTg=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com
Subject: Re: [PATCH 0/5] hisi_sas: Some error handling improvements
Date:   Tue, 15 Jun 2021 23:49:00 -0400
Message-Id: <162381524897.11966.15868092812656796267.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1623058179-80434-1-git-send-email-john.garry@huawei.com>
References: <1623058179-80434-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c398a4ac-82d2-45c3-1b55-08d93079bc2a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46632F7F8F3BB79880D1D0838E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3qKTnFJqsJl0xpZdyuXlQbw1RZbZSNTJS0SbWdP7OSOb1iTyPeOO8O6MGCH6YgmsfYWPh/UTtRoL4fdbAlE/3XIHHriLVlUVXD6pSZg/D7COq6f4fmCCCgD/TQaplDsiFeacm/oso8ph9lrKmi+NHHLKpKqd9U1yP1wfJspKEPVvZTk7uqqVVpzkHJVZj+4U0/R71EkOTWe6WqRaYDvU4U0sDLv6rafdAAXUAREQggYm1dLdJx6IWORgCVSlE2wkPrrxoBnmYdii5/upvSokG4dl7RX2gBCoEAS9TaiJ+kUez/EU4PkjiUxJ9cIqhwYJrpYVqcL362SQDkBBWeEaJy9FlI9UsTJW7UA0HuAUVJb1URYRDacPUHX2YVWEou67oQRvO2DxX6DTkhDbYojmMcYqKUuNSMygOij0dE+4FbeyRIduA/PzXNDxhpn702T276kzfsnEj5B/2qEoV9qa6PNOp2PWOqnRosjG3epFf62wGe7kxMlo4NlZznnzlWx9E0x71ftNCEA9fmOpi5u1z9uBh54t9hIz9OXv1i1rPhRURA70cUhDsvFAjEgmnVALKvcgg0G3kLiPjnXnq4h7eXSwF/dakVOSTa4Gifbxjdtjtpw30kFcuBklO+Wovlt2PTmHqNdiwikyGrqNnCJqKsxtgkkFqVdcTadwCL/N7SnL4gyD3ckMISvwZLTe2G/Md0ajO2o7XjXWGUTTpyzFzbtYKe+q2bgZ5KkkCSQ7isREckWhmvkQLEu93fFhByeXhbJh6tHtnkftfqvL14U0ale5MEjtyMx32ZYrBqNAYa5eHZyhTuy05uTNF+ipqOVu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(66556008)(8676002)(4326008)(26005)(66946007)(2906002)(16526019)(186003)(478600001)(66476007)(6666004)(5660300002)(8936002)(966005)(316002)(956004)(2616005)(83380400001)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVBNWmdPcFFxR0k4ZGFzZ0RSWHR3MVp4Z0RBNDNuL21XeWhvc2tPR1VxaldJ?=
 =?utf-8?B?M1VEUUIrcGtCbmdCeWMrUndpdjlMT09VcTlUODFVaEVIdkZyRXNIeVdhMU5Q?=
 =?utf-8?B?QUVQYzNsZGEzd04wclo4STBWZ05JUUZIMjJURjV6Vmh6TEowYzFJZlpDbVVJ?=
 =?utf-8?B?SnZVY3oxbW9JOWVxQmRyVEpLZ0VUOHNlcDNWTnY2V2hkTHdvYmpZSldCdktr?=
 =?utf-8?B?OE9iUUR3U3pScEZTUGVBNFlGcjBFM3hUTGYzd0taa2Noc2ZYREJBWWQ4eEJn?=
 =?utf-8?B?Mm1udmdtTDdtZ1RhQVlwb2VIMFIyT0NHSzFGalM4SENPUDAreTVPcllQY2xt?=
 =?utf-8?B?bHdueHVZeG9JcXdVTGRpOGZMVFphNkkxZ0VsU3pMWERjcG5TTEJBS3Q4ck02?=
 =?utf-8?B?RlMxK1V6enBHM1FFZ09YNGJyemFnZ1RtZjg4bEJxQ3RrbThSQ1ZHY3g5YkVv?=
 =?utf-8?B?NTN1bWpiTzhUb0JXZGc5YXJBQ1BObmV6eVRLSklaa3BQWW5Yc2gyRG9hdC9M?=
 =?utf-8?B?MS96MU5JVWxLalFMdjRVTis4Mjd6T25EQm9MbWlkNVVLWXF2K2pTYk1qRGtl?=
 =?utf-8?B?M0tGWVI0cGZpVithS2Z2MUd3VTF4cHhlOFI3QjVpVFBKZVcrbmhSUkg3VS9k?=
 =?utf-8?B?MEVrNWZ5WEFURGJ2YjBRajlZVkJCSXBzekppNWQ4dno5M3VmMERlK3dBN051?=
 =?utf-8?B?Wk5TUjRUSytoVHJZUTBqQ3lsNE1OallRaTl6ZUl3ckw4emVyckFlTHFFSUlr?=
 =?utf-8?B?R0dnVjByWURmc2RrZHU1S3RGS2N6NkZRWG83QXNodVNtcUZlb01kaDRta2ow?=
 =?utf-8?B?cWhmUzRjdS9KV01JSnVRZlVoVmRiaklXdHAzTTFEZ2VITDdyYlkvUFllVHZt?=
 =?utf-8?B?SzZHSHFUWEdrc3BOS0V6clFQbGZzejk1TmVLM0M4cmNUUGtnSmVDWGJiOGpm?=
 =?utf-8?B?V1Q3SGMwQ0UxYTU3TGoyMjdodU93RUxZTmE4d3QwZXUxNzg2aUtsNi94S3JU?=
 =?utf-8?B?UlZKRjFqK2NrdzQ2Uy9jMkUrL0JxTVJzZ2hsMEtzazNlYy9WQXh4SjllNWRU?=
 =?utf-8?B?QktZR0k1ayt5L1VLakhpRGR0dGV5UEN4NDBtNFBmdEw3cjBQaW5hVXJ1SHFV?=
 =?utf-8?B?V3JVMVFtZlo0UlQ3eW01ZjhGNGVsSWVIYWlqMTU2TTNYREJQNmQ3Rk5vTk04?=
 =?utf-8?B?dWQ4V0kwRWVBdHpJRmVZYmRjTzF4NW1oT29FVWdhY3BvbS9WU2RBTEsvOEFY?=
 =?utf-8?B?elQxaVhuaUgyaFRsSDFhK25VY0UyR2xQN0dwcThLTy8yY0o3THdYY1VJalJB?=
 =?utf-8?B?YzN4K2drNldod2JONUJxTStIN3dGRkRGeVpRTnFiTHV0UWYzdFJaR0hWdEQ0?=
 =?utf-8?B?ZWV5T3ppOXdReGxwdmJIcWZRVDdzUGVUbGh4dllBSnk1K0Y4THhIZU1aMG5W?=
 =?utf-8?B?dkl5SVVQNGNWY2NXUk4vbzhadytXeGdkRDRINTJoN1UzT0NGQ0NyRVFQQy9y?=
 =?utf-8?B?TEJqZkIvQjV5VlhweThra2hiNlBCUXJ6YnlWOXZtajVlSHdTajNCSHZ1N0NH?=
 =?utf-8?B?NVo0cFRBcjVsMGJoaXptZmc0NU55NXJLSndPQW9EOFYyZndsMy9YYU1SWkNK?=
 =?utf-8?B?UFhIYUx2S2taR29zVUhaRHdWUk5jV0lQRUxxVXFDQ1RSMDQvTzNtdmpxdzFN?=
 =?utf-8?B?M3VMUWRkc1YwaXMvNUc5dklvRW03TWY4QlZKSW9NUUZKV1hPTWhtQmJxQTEx?=
 =?utf-8?Q?YAXLx0Y079N6lza0fzp/rQTg2a+8utinu5hVu07?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c398a4ac-82d2-45c3-1b55-08d93079bc2a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:25.7490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O4mzFpfKRjeqozVsbquWFtlbTkcy2Az7+RwcS7SVsu2p1Km2E7hlC4FJPaZpBrraCdPXxg5Zmco4nddqAMVYlHx79v1kKpD9CUudiH7HeW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-ORIG-GUID: iWZp_3tyfU6FzNfUDMCYRMIxXo6ivn1u
X-Proofpoint-GUID: iWZp_3tyfU6FzNfUDMCYRMIxXo6ivn1u
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 7 Jun 2021 17:29:34 +0800, John Garry wrote:

> This series contains a few error handling improvements, generally
> speed-ups:
> - Put a limit on link resets retries
> - Always reset controller for internal abort - it was only occurring
>   as part of final host adapter reset in error handling process
> - Speed up error handling when internal abort occurs
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/5] scsi: hisi_sas: Put a limit of link reset retries
      https://git.kernel.org/mkp/scsi/c/366da0da1f5f
[2/5] scsi: hisi_sas: Run I_T nexus resets in parallel for clear nexus reset
      https://git.kernel.org/mkp/scsi/c/0f757339919d
[3/5] scsi: hisi_sas: Include HZ in timer macros
      https://git.kernel.org/mkp/scsi/c/2f12a499511f
[4/5] scsi: hisi_sas: Reset controller for internal abort timeout
      https://git.kernel.org/mkp/scsi/c/63ece9eb3503
[5/5] scsi: hisi_sas: Speed up error handling when internal abort timeout occurs
      https://git.kernel.org/mkp/scsi/c/e8a4d0daaef6

-- 
Martin K. Petersen	Oracle Linux Engineering
