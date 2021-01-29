Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3F4C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 18:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6044B60C3D
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 18:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhA2Sfo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 13:35:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56726 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhA2Sfl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 13:35:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TIYrQL016760;
        Fri, 29 Jan 2021 18:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=vSgBfCkD4k/+Jy8LqcKSazbf/kC56CWz6Tnz27cqdE8=;
 b=df4LLm8gzwrMe2KFy+tQah8CDLUYKM9edTCJossITawd26egV55toHqTSLCvRl0vROoJ
 WSUSuiVSXnhFepWBIpYv55iQemRZEBr1TxN58MMcbrJbN2uO9LSnZNOokEZxAABjs7Hl
 8ZW5H5O/DSNtyFu5h5A0nit6pG4xGwP1+DABVeNsxGjP1rYkHFYDakKm8stq1ySPQ3bo
 JealkAqm2UL7CRn5GDh9jZi2ZXFWY3IKfKeyMlffQ6ksB3/96kUSFqdun9xq2/YC/tni
 1ss3TiMgpga5z/I1Jcj+1I4IZrQDZ04ChBrccy1Z5cstLOHUCKvPfJ90ZzHbembnnJLQ rQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36cmf891ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 18:34:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TIVGcD186036;
        Fri, 29 Jan 2021 18:34:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3030.oracle.com with ESMTP id 368wcsjks6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 18:34:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8pXUIsHZ4hbmJSLwlndOf1+tcIIgQqBVOMBH7wXvsYx30Q7/r/neMMl6huA0/Rs6yJFgj92QG1FuUcKChiKhNVon/kNw4n47ZKYEYabhZya0Ux01khQBRZiaiZbIeoIa0AhtXGMAnB9Zg0Ely8urUkUFqaz9d71AU96hZmVYzRe37UV+526fB7f+/O9uj6w7/eeoy20OQYWlmrAElwgf6cet8Bwcv0D8yJ/XPwE1C7x6ivbFfCphR223ABDctUUXeCSbA6k5ZtZ883g+oSelDJbc1fGAuDpUPLBqPNHy8l1ju8mTje2PDgwQU+fmIMDx0rTIhIZEPkQp3f3w9d6kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSgBfCkD4k/+Jy8LqcKSazbf/kC56CWz6Tnz27cqdE8=;
 b=QmJMAcNqSEr7L2uxlh8zPB9siKsTPg8NpbyMKjSkyCWu8x0c5ILZ+Ch79Pg4POspq/3X2iadC1cT7yx9CRs0d9ktCsMU2Eb6myD+Q5gOeOmrQvVVdG47ynSTMbzhSMbDKUV2xui/9AU2iP151rSPjNHIxs0FVSQdPp7Y2KRrikBK47Mhxe7KLUDrtn53zC/mgHBxcjUT3srL57S7SyaQulynT/ekKJ5dEmZLawMyIRjT98c/Zv9vgxt+q3z1mNUJ1yhAdI/sHdu+CHUBHYNT2Pg4zkpY7Hoc4XIFFwaQflbCw8LjBsfx70V2GM+aSkR11NQPbfx1S9gtMh151GKK8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSgBfCkD4k/+Jy8LqcKSazbf/kC56CWz6Tnz27cqdE8=;
 b=HlUm0YgGzV4KlKuuTyZMN2rrAO5rraUrikS9MFNqZo0QiHq2sCi32PMwGhwsMm6G9LpTTPF5QlNjQEIXCy01sA99xGFYg7y11VnYkfWpVDHuG6Zb2JPvwZx7lAjO3pK9b00OKB0H4p/TOLhsIz8oZTQr2ZB3sIB1OzEtCIoQdP8=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4773.namprd10.prod.outlook.com (2603:10b6:510:3e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Fri, 29 Jan
 2021 18:34:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.021; Fri, 29 Jan 2021
 18:34:50 +0000
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Simplify the calculation of variables
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v9bfzj5p.fsf@ca-mkp.ca.oracle.com>
References: <1611650554-33019-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Date:   Fri, 29 Jan 2021 13:34:48 -0500
In-Reply-To: <1611650554-33019-1-git-send-email-abaci-bugfix@linux.alibaba.com>
        (Jiapeng Zhong's message of "Tue, 26 Jan 2021 16:42:34 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR06CA0068.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::45) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Fri, 29 Jan 2021 18:34:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86cd4e16-2150-4dfd-a7ef-08d8c4848ff3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4773:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47731B8393992C3E091C0D668EB99@PH0PR10MB4773.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JK025NlNFVmKE0vdLFI4NXYhqdJEjLAdid7JLlzMmuIN5MCn5KlJUTZhQhTSdYr1KRhr0NsByjZuHNP1/V1fUTELgvqkSnRifN/W+8QiCRrXC2JSzujgOP/T4nqFa8c+Cmy/vHc27vZaW3mVBdGZDyCfIZCIbHXXQCdvBu+wF8+E4XCRMS17ZDhNwUgCXNvDzWSAWf71XNwMbFktXQiJXc99IzyrXxHcozlQdJgR0s+yPYMZ1HoE8LDSW0bDLxYPJwhg8/IzmEujOvtFYL5qsWEzkyFl0nLSfpwihNfeDliB2dteqTyo3fY58cc0EjyuQnWbIN6PIBl2MFbZe/4DtxWSZDYSHzD/QnDoeCKhq6Nd5H+R1nwzwB+0t4PfVNsCt9GjlwzJAKtd/l3TIKYd/8Sg7B0ChslRVjKa7qd2ba86y3zOeVyetniKBT5GqTTJiii0NR4DcazXBEBdG8cc1od0oDJOSFEYtUYc3SC103rgG0+w5i257dw1dWRdRfiQ3SsK1N3Ff5UaL2OR50JBqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(39860400002)(346002)(136003)(8936002)(86362001)(316002)(55016002)(83380400001)(558084003)(956004)(6916009)(5660300002)(66556008)(66476007)(478600001)(66946007)(4326008)(7696005)(52116002)(36916002)(2906002)(16526019)(8676002)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?b6yF23gT4EKsGYCc2MWc3gt0y1TCAGM+N1pELogaq44MRtbPmd/T672r3H3Y?=
 =?us-ascii?Q?PLuq4Ycb1Q7+Sr2ASE7H/BhIyjLy6lsfpmwc7wmBQk5UO0Gn7k9VbFrp4Yma?=
 =?us-ascii?Q?sw8j0FfAG/N1jrmTniq5uoi17olOLR8g8P+Z+XWzMVO8L1xeMOl5KoxDE4oJ?=
 =?us-ascii?Q?YlM7BFwa5YKKMz5dgjDM9ouZi+D5amTq2eni45o6ox9vYlaxRCWs/fJwLlbR?=
 =?us-ascii?Q?7szmoCFEWz7SexKG7+JUf0hznLPPXQBebThW5daLHgtC15/G1HNmnB1kp830?=
 =?us-ascii?Q?u+Hyt08f9pkFnsjiMFbYjvqrWceRAqeB4t2y1pM3Sdgn0QUmsrn2UPP3+fFt?=
 =?us-ascii?Q?nH0VE+x5ABZyyFKtkLjLixXOFIQpuijVmkqBzCNXIzgKBQPc4e0MmfgTjS/B?=
 =?us-ascii?Q?FEhR1pJhV0UO+tTn4nT/4f7fVyhLMkLuyKZTdvImBs8OmfBhiU5CChi/b0dw?=
 =?us-ascii?Q?pDj+tLUoXWnTre+DKsBzVB5fTBFOOB1Yi4yqaNBBpMPzToRdO2/rezJpdSHD?=
 =?us-ascii?Q?qK+0uw4TMQDKb6uAhfaeTkitusj9MNt69kvFCo6z4zKiLw/CcYhfuFih3Rz2?=
 =?us-ascii?Q?/i72nRyD1HFfgSuZYirncTW3WFigmGv3xOPOoCuiVxIAPuuVxH4H0ac+1OuS?=
 =?us-ascii?Q?WA5lfVhFfKB2Y83IiuML+/vfBxZcfZQ7ILCsKm14T3Lh+9vSYmVFraFk2IDH?=
 =?us-ascii?Q?pCujeXBCGXmzxn4Y5y3Cv1FpOybCW3a324I0Tdd19SRQF/jPLuce8YFFezmk?=
 =?us-ascii?Q?yyz/mZ2LZq1obBHCm+rEzOfTXi/W9BK4ruj0W0+OxOb+9USNkTieVK7oR7Wu?=
 =?us-ascii?Q?EHGHsAPnecXuJaDDKW82hrYxtRVTsS9w9RX5e0d5SS08Y/Vn1OqRDb7GwsLh?=
 =?us-ascii?Q?EsehPKcdHUSegWnzzrx2xoytZ8ugVa9ZqWnKOH5x+JpbchUSGKVcijiGwO4l?=
 =?us-ascii?Q?jChZsT5i/It35qowCNZLKKJXfUYMLce/sufEh3qAMyVMzyRMASTK/ondWZhX?=
 =?us-ascii?Q?bEVj8Wpe9mL0aKZiOkqDPxC8hMu4q7c9N17Lgy5yPBYlpKjThbvyljCQrKa/?=
 =?us-ascii?Q?PAWpe5k/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86cd4e16-2150-4dfd-a7ef-08d8c4848ff3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 18:34:50.3987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5s80iq4rumZWo+KbyGEmvXLOkF9J0/icXhzyOF0nBeQ8usrT0t2083BgtOhTB61XnB3zRXWxEXGayZ2OlYwDJNvVTL7E6vCu9DYkTQMf2U4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4773
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290091
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jiapeng,

> Fix the following coccicheck warnings:
>
> ./drivers/scsi/qla2xxx/qla_nvme.c:288:24-26: WARNING !A || A && B is
> equivalent to !A || B.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
