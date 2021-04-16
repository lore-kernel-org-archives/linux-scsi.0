Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CB3C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8AF56117A
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbhDPCwX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38974 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238248AbhDPCwQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2phae048366;
        Fri, 16 Apr 2021 02:51:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=umGs3l5/uPugBPJrNZooFKz+Qkcq2E3SLwx9K9wYVUg=;
 b=NUbaFwiYpRElENojQ9jm6KIm2J4YXf78X63Z2e/O1o+Ldwgg0NOyXf+fF87WabpmEiWL
 CLoTCa6CR3vfAa49V0Y9HDaSg9Cc1Os+j9Zubk6lHO78pkk8rPr3CKWuxj6MwezpSTmL
 WBTBg5JME+WBomh2Py4SbaspelibuS0eVBxW06qXQPRRH+pG1t1Z4FsQDQuWAxL6+zQZ
 6yVlU7jJK1KCsquDcxY6oRIOerJkKyeZp2NdLrJdfJZOakdT6p+3i9LyHRTFBOLnYZjA
 5kXt5MS31PPsVrv8HPIXwlnC21/qmSI3mP3TyKx0ZW/rddtRGztOvf3XxlaRA29mkSvb UQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37u3ymqpm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2oWJR160451;
        Fri, 16 Apr 2021 02:51:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 37uny1xe80-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhHvBPG2O7DOEUhruZ1NW8zlGM6fV/uIQKNIt8Y8XOXp1RVPEOZ4QPE5QPuZSS5YyO5tEvfnfdFPCfXAYrwNo7BkOQUlDnw9JiO8+Vt7Fd8ocpnux+C++4/PVUiT5nQWSm1npHqvSM1qIt3jpPm1a99hTWjBaQT2QdlM5VQBxFS/5AmQ84BwLq2QZTbgUn+bpO51iztPjbO/fw27SF+cpJ/4KjoMI+0mMMw+QTeTqsXWGDQST8ga0yV8HTiUGnOnnoH45yoiI7dh94Db78YRV+H/Ykf4rlopIwmwW5UiaFXChWKSU+tc6XBO6SBVuRbCJHZ18Ani5Ovg043393qqiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umGs3l5/uPugBPJrNZooFKz+Qkcq2E3SLwx9K9wYVUg=;
 b=Tv+sWsvvcQbRJflge9YlOOEd+l9EMg+THsEKn+UATCje/N3gTy+PyrNaOpJLt7XwuKR315kgdniwR8Z2pXjtvGxVF7DAbNhycRkpoOilIm6p5Lxj2Y2RZ1PU/Nas2MZQUBOF2BuyAeiXbFD8BgvcgPVDR9cVp/djaMb6Vixa5U3I3z9V3KBO7eP55A0fMmP6vpp7eLJWonj4WhUuPM7+uDfxgPqRg0lF0wE2a5VLrjNmRnzsiNfL5XuNsRu4ETewiDt75KykcG50JgohfZNA+i++S9CcBAySGIzcXQjZNIligfNu9XHKBepRq+jV/NzjoZ0V/bF9IG1vLYc55ajzsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umGs3l5/uPugBPJrNZooFKz+Qkcq2E3SLwx9K9wYVUg=;
 b=RYJ8Fd6Zg+p9AwrRiCNT3zXo6sRhvJQluFV756o1JlfXN4n/eU3S3CYBWyqa3OPM0BL0DjPQrzIQNFsavpZvZ+FXKmJwM8iDlyA7umrV3IeHjP7hk3qTFBEYiYoIpjbIvzJZ9VErgORf6hz+9l+il2hjplqE+yf88+kktW7mtsU=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/3] Stop calling request_irq() with invalid IRQs
Date:   Thu, 15 Apr 2021 22:51:19 -0400
Message-Id: <161853823945.16006.5434711347392208579.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <137b9e4d-391f-3163-2e6f-9e21aeb6bf34@omprussia.ru>
References: <137b9e4d-391f-3163-2e6f-9e21aeb6bf34@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5618a03-2f4b-44da-83c1-08d900828fd3
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB546668737FEBE9158C80FB0C8E4C9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3h++9cDnGyfS+45h3ZSO6npQuK/2Sss/MxoyD+jTz7vHYNW5+CQ90Xoq7y7UqlSfzGsoygbolq55ytQKjWypRo0Fi3HAX8z8j1alwUiXL0X9e21rveAzQa8rmLQfJquMGuVAQ1moPT+RZDu3oAc90s1moi3RiMoTqpO/rF9E8V+oZNEli8Ju/SzjuQaWgWXW4dyOCcSEzAtQZOQuUDRUmaxZj0JQmPTceXuOZYL+2bpimv8+xH+KZzzIiC3oS0qgvn4d69Rn2v0sBPyf9D3xggHwIfkHJYqlujXrdOg0kRWz4apNA8z4lbSOjB7u1zwhrwN5eT1ckTaKiWsDCcuy2J922JwzvTht8pO2Tt88Z74f248ugEV4UwWT9sAvuwgYX1r9yD+0HMYEDYS3JvgL7zgNZkCVFLTwHAJix+qHh2vVaW1iswoGZpyvS6QT3guW35sPKCE4LgJWR2P39hbJJyYDQX5KL06oegxclkB6AJUHS6o1vl7ME8cFQXIzzSOBQ/Ed/ShjDhkDsQL2dZn9vsgiCa06jgOwd2D4y9N/e9ZuGr8b+VBNkQ/pVzaQmPhwK9CYqcjRTni4974Cq1Jrmc9i+fEzVjjJ92j8JV4Bfc3IWLWdJ7gf4DBu/+SJO7PhhDTweZhiFNEwYhENoZSef8NBlWDGGL6gm5QIlbsWbNXFgwpWt4ZX3FSPbwATu4tjeEFZGq8JRKQ+CtSALG4cEQsgx/yO6EbhJ2t1oDaR8Cs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(346002)(136003)(7696005)(2906002)(36756003)(956004)(4326008)(6486002)(6666004)(5660300002)(2616005)(103116003)(52116002)(966005)(508600001)(107886003)(316002)(83380400001)(66476007)(186003)(110136005)(16526019)(66946007)(4744005)(66556008)(8936002)(38100700002)(8676002)(86362001)(26005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V2NhQlFHdE8yME13TTlJajc1TlBCbUZYU25LdE9VWWY4YlgzTmFaTk4xWWtF?=
 =?utf-8?B?N0hMdis0Q2VLazZlbGdLVm1sTWFtcjFrSzdua3BMVDFkQXh0LzB5VXRDczBM?=
 =?utf-8?B?a2NiejVpSlRDdS9BMHhHeTBCUVpMc0xvSThRcTk0ejZRSzV4bk9PaVhlTDJr?=
 =?utf-8?B?M3AwZXJDUjV4RW1qRVRVNG9WNWJuT09GVDJVKzJ6emxnQjRwSGtCQkpDOXNO?=
 =?utf-8?B?RXJ0L0M5NWFqQ1FMbGtTNUJzM202dEdad1g3bmNlQXZwL1EwSGNKaVREZExT?=
 =?utf-8?B?N0NHcG43dmNWSWN1SnFNRy9IUTc3OTVhd3Y2MFNIaHVMSy9JZ0JDcndScFgv?=
 =?utf-8?B?UFRSU01uNHBKM21ITFQwbTJVd0RTZ0pEdU01UVlFUUVFTlVJdER5VTdjMkgw?=
 =?utf-8?B?blhGRDhwMWlyRnRvTlhJUVlqU2tlaC8yWFVSSTN5ZUFOckVkeEcvVURoRGo4?=
 =?utf-8?B?T3FSZ1ZhT2FWNGF4bkRwVXNNeGRLWkRwWG1mN1JmSldCUkFJS2NuWGNvZVdy?=
 =?utf-8?B?dC9pTXRMVnlyb29OakdmLzVLRmcyNmxjSUI3bGJkeXN3RkZYM1JvTURzdElz?=
 =?utf-8?B?SDlzYisvWmltR3pXT0FCZXorNzdnOTljZXh4a213U3cvUTgzSVhFVHl0LzBw?=
 =?utf-8?B?NTkvOXplWXFVbVRZeEFpZUdob0Y2dXpmYWh4citmWk5Cc1lpKys3ZzFNS0NI?=
 =?utf-8?B?cXpJd0RBcDhzK0ZDcEJmMmZ1ZGRjZy9PM1Y4UUN4N3VEY1hFWTRra3h1TWhn?=
 =?utf-8?B?dXY2T3p0c0JOZk56eFJzUDdvV1VsVjY0azFhZW1mbkIvNjd6dUlYbWhMaWwy?=
 =?utf-8?B?Q0tIOVhRMVVaV3dBaThYNWZyVnZwNVgvNTdIMU1KSFdIdzE4T202VWU4Mkh0?=
 =?utf-8?B?ZVlYWnBsTHBiVDlXV25HYjk0YjA0MGZUL3ltQlU1MFRXNVZlVUlMQXpTWDY1?=
 =?utf-8?B?WVdlbGltdDE4bStZVnlOMHZWVDYvZ2g0eDVDdkdTUnpiNlBlczNEU3pXSUFB?=
 =?utf-8?B?TS94YWdqT2JPb0Z4UHcyalM3cXBielY4TExEcklvZGp0bWs1NTJzTnp1YkNE?=
 =?utf-8?B?MjZpSTFraiszV0NDWjRkNWVhMGZVSzRFWFpPTHVOcnc1c0F2VW5lVnFjMzdV?=
 =?utf-8?B?a3VWRTlrZ2MzQk9DRkpZQjE1VWpkYW5SZVRjU1FzN0F6ZUtwK25aNitxeUI1?=
 =?utf-8?B?U0MrRmNXNjdCVGo4RGpzdTVQRVNQZm9zNm9LbkZQM2RlTE9RNWxaNlF4UHky?=
 =?utf-8?B?ZEtvWDhURE1Xd0d3UVhITlNkRlpzWjd5Y3RTSEJHV3dJbE04VW8rR1pVVHdh?=
 =?utf-8?B?TzRncVF5R0dOVDNXQUN3QzJpT0I3dFlxekNuUDFtNEtLaTVmVzVvZ1N2MFBB?=
 =?utf-8?B?Z2xCV0RlSnFYOHk1ZFIrOE00M3dSb3dGYm1lV2pjRFhJa2daZ0ZRZCtLWDlL?=
 =?utf-8?B?RjhSai84bncwL2RTMDhVV2pMZHp0MmJ1ZndQT3ZDZy9MNkhaT2pML3I1R2J2?=
 =?utf-8?B?cWZBc2JQZjVoV2ZxZHZTVHg1dThxOEVFMmNWeThhTENiQ0RoM055VG9DdFRl?=
 =?utf-8?B?ZXoxOXJkdmx5dEJkQ0srZWpQUlJCRmc4Z0hqa1VtckF0YUdHeEk3S0ZySGt6?=
 =?utf-8?B?c0s0Sk5UbTdydlptRUJJSytOcEIyckxXSlRWemptR2JJT3lBaDNtU3M0d1Fn?=
 =?utf-8?B?ZHlwd2VVSHBNQWxwUW83SzFVTDFGMXdCOUZGY2lpUjlJTnZadDBldFVyRTBT?=
 =?utf-8?Q?e0D7JMi9Nv/ksJoLiZ9d86o4neEdMtxhGiyk+xE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5618a03-2f4b-44da-83c1-08d900828fd3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:41.0060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0by5DnvBzA8iU7/GQJneGrNnSQkTbhKUn/kM7p2MrdAq4gf2W/hyWTp24aGMfg7eWzxQCGUSTVmTBIkSclty0Irg3q55GdC3yiNfiPIf0Ow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
X-Proofpoint-GUID: bEU3sKziffzo8wTCqE20SW4R7L0dEkN1
X-Proofpoint-ORIG-GUID: bEU3sKziffzo8wTCqE20SW4R7L0dEkN1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 30 Mar 2021 20:40:35 +0300, Sergey Shtylyov wrote:

> Here are 3 patches against the 'fixes' branch of Martin Petersen's 'scsi.git' repo.
> The affected drivers call platform_get_irq() but ignore its result -- they blithely
> pass the negative error codes to request_irq() which expects *unsinged* IRQ #s. Stop
> doing that by checking what platform_get_irq() returns.
> 
> [1/3: scsi: jazz_esp: add IRQ check
> [2/3] scsi: sun3x_esp: add IRQ check
> [3/3] scsi: sni_53c710: add IRQ check

Applied to 5.13/scsi-queue, thanks!

[1/3] scsi: jazz_esp: add IRQ check
      https://git.kernel.org/mkp/scsi/c/38fca15c29db
[2/3] scsi: sun3x_esp: add IRQ check
      https://git.kernel.org/mkp/scsi/c/14b321380eb3
[3/3] scsi: sni_53c710: add IRQ check
      https://git.kernel.org/mkp/scsi/c/1160d61bc51e

-- 
Martin K. Petersen	Oracle Linux Engineering
