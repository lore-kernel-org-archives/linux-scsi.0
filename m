Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE9BC433E9
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A4564E0E
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhA2TDu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 14:03:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49628 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbhA2TCh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 14:02:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TIx2iu074008;
        Fri, 29 Jan 2021 19:01:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=bjY0NPJzSsWK9GAHvRz11hKExB54SewEiJbzNxkbPvs=;
 b=QP8itFFRlyLa+oz8lEbnE2KOdArChxW6+wXe1bFbPYvm/GbVJmLD8Up1fRJmhNjRSKzY
 MDemu2XzKABBvzireJVSi1fRq2myUNeULIv81wnnWRv30PVJkpv6n+t7tjtCC+23m87c
 bOCzISqlQt7jNIMLaenYRI2yOqQObq9ngHGG5mTbYfn8qFvjEozSwC5lo+jzlt0DC7ja
 9NOBffL/32dVcvPUStxbVSTTsNUFgUrT4CMzF8QqOlQwmHTZZ1sIx8G385FCYSiRmEKv
 cSlMDBPcxBZogOs5tBvcaV9WClb/Z0h6H+pcf0/msJLiWmpl0VAA1oREqk7ghKFGlu6z qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36cmf894k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:01:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TJ0kJ6053055;
        Fri, 29 Jan 2021 19:01:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3020.oracle.com with ESMTP id 36ceug9n0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:01:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEunp/3gH5q6fH0A5Y3l3O75JVXG5SYqtDnUFQsuvWMl9jMAlF84WvVTXS4esVEdmPwODP42BvDw2FJ0DxKegf6RsPc/WFg2kFmOxJbTs9APqwjCPeGsm/km6MauDVcA7vG5YD7XuFeUe0XIdaJnlREfmxNkHTRdzpJXwqoXXfZoGjys+GC2qYfHKlt3jvjKA5V0l/m/r0WISlDfEyK8diohkkL3niLQ3IjStg7MSjkt8g4G3tMbqfelTVuHF9BffuHRGtCKZdRiI72YyyyYgt9xVmY0l4yCjPelSQJDw/kmmtS1cZY5rMTlBO7cl5Q/6TzT9xdHcJ+4Pq0mWHz1ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjY0NPJzSsWK9GAHvRz11hKExB54SewEiJbzNxkbPvs=;
 b=VvQmq1//C5PCc3W4EzKMVrL+jQFYYLuE1elC4sx1oVtGVSJD9xDo3aj16aFUgC96wTMr8lbQGbto4mZ2XhKvPvFm4TR6Necwh1DTqV8R6Q5hh15Dh5Gm5lAMekxUf/j53P2gKglSNYs3HMtiC0W2KL8pxT3OmKwDH1ArlyDRcS+6mbAX48oIgk/RCTYiPJRhFRDimbYBfdOCIQi8GjFSf7vkkoBbCFYcG4uyyHaSA6xo6wczCngFp2W/0YjqNyp2kxADEUR3dKuzYCEFVTZGB4arid0XbldGD5AJY1X5xNvUkmctgrEuFDV0YDULpfnZTWKOedhTac+Tq56hCIOpeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjY0NPJzSsWK9GAHvRz11hKExB54SewEiJbzNxkbPvs=;
 b=o1j4M2wfbynw515dJeC1WWt8DD6owR55vm0dS3SaubZiPFKgQr/MxzKp21QbQFyhaMFgZOMeqQiF80Pr9pFvMcKa60BILOZsE2pRZQcCbZN9yR9nNn1ixM3EtrlUQoGe1s1qm6Y7lTw+/ouEikQhJLzQFIxC60+IzPbFJnhqcEM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 19:01:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.021; Fri, 29 Jan 2021
 19:01:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: Fix EEH encountering oops with nvme traffic
Date:   Fri, 29 Jan 2021 14:01:29 -0500
Message-Id: <161194685556.3066.15743607296453448604.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210127221601.84878-1-jsmart2021@gmail.com>
References: <20210127221601.84878-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CH2PR05CA0018.namprd05.prod.outlook.com (2603:10b6:610::31)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CH2PR05CA0018.namprd05.prod.outlook.com (2603:10b6:610::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.8 via Frontend Transport; Fri, 29 Jan 2021 19:01:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d365c5f3-86e9-4632-d84d-08d8c4884c7d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4677ADEDDC10E48B3C170CE88EB99@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L+a5IdBYaQTVs7j20DEbBHQ9cAYWDa/RvWvAidu6qLKvN2ctCa50/h167ZewkMjHeAfWVO24fDR/bD7xRCSBVzXTxrAQC9a0iXOl7A8ybhNYhcjvY5cJ6FqJzf0CqB2TWRR4awRPohLPY3gWlevizE9JN6DLEXMkUtpdsBAqPaRLGj2U0ZECHeYHPvmpUapmEobOokLja4+xjqw3xcxu9BqsQ7FrAv6FermkrvX4GJmJL+Quq6HOn7JhK6F5ybGOjjEzctoQ5nns30F3uYwbTfKLOt8lhK08SxtgGyzA3SKjxnwxpgwI/a5NmTsPebDupPjGtvMaHR1+AR0enop4fY/Zb0ZjjHjjm0E4+yNl1NPJs9NX6HgPHa6/leCN2fbuYnnMdQnJBvF3T5DfwRcVqAWxJQMR3uTb5P1TiIrWE+QntlRbgdIi0omOhdbsS1LThPgstaQ/nq6OnNJ9P2w+fEAF91KLNpa9tCZsBC6sBNf8wC6Ssh4yf816Urn5/KDjsKjZjCz6XziBPEjoQ9WENSc7lITJY6whgk46kSTNE8OD55CJjTBIA7DVIY4vRtkY1+pInN/4Z1i0u8PToo+yoX/n3gpuLvZY2A0twiPliHI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(956004)(107886003)(66476007)(2616005)(26005)(52116002)(66946007)(316002)(4744005)(103116003)(66556008)(5660300002)(16526019)(186003)(36756003)(7696005)(478600001)(86362001)(6486002)(2906002)(6666004)(966005)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?M04za3Z1YlZlaDZNbVRKbnR4NlVDOVVrcU90S05UVnUxQmFxSmM4anRZMnNn?=
 =?utf-8?B?TVNydUR6aXVqeEV6WUlPRW9zNDdjZFh6VFlobTFzMTRLZCtIOURwQ1cvUFlo?=
 =?utf-8?B?ODcyTlVGZWlSQ012VnJVTU9OSklvaXNaK0JHeEJKc2F1YlNkZEVLdStDejA3?=
 =?utf-8?B?b2dFeFFOc1VySnZWVTVic3BteHdZcG10SjVKVlFTYkcyaUxOeUFKRFZTNGJz?=
 =?utf-8?B?Ymp5MWR4clZtSHNVRUdBV0ZzZyt3bFBZYVpMOFRqRjhmaWhBN3g2U1l0TXJV?=
 =?utf-8?B?cDVrVjk2b0U3dGNYTHhoWmFXS1FuUFY2UG92U1lLT3d2bWNWM3RGWjFXOGY3?=
 =?utf-8?B?WEo5YXkwaWc1S1Z2STVNcmUvN2FJZGpvYWRBNUdaUFkyRlJ2Q2pZdmJGWjlj?=
 =?utf-8?B?WHE2bis0N0hBSXVVZ0NUZlFSSFdEZXh3SnVRV0Q5QWoxakhmMU9oditKODk2?=
 =?utf-8?B?a1dzcFY2RmlMNHNyekNzYjRINTJ5d0xmQklyVHVtM1V2M01OaFhzaitOeW12?=
 =?utf-8?B?bVdxZmxhSmU1R1dubGNnNXlPeWllaVdlMWRJeUZNVjI1OThURU5xSUxoZlNP?=
 =?utf-8?B?RDVEazhaM05wY2k3ODM4L0UxdGFnOXk3QnpvL014dFIrRVRKQm9NVFY0VDdw?=
 =?utf-8?B?YmtkaUViOTBWVGNlMmtEcHBrVmsrUlFEMFlpS1lVdWJZWjF3Q0tGTE1NdHhn?=
 =?utf-8?B?WmU1bFRlZ2E1b2dNNitFeXIrTW1nYWZqRno1Z0V3Q2ZmUlZWUXVFLzlPZE5X?=
 =?utf-8?B?aFpYdzlxSFNQQ0VJelNWbitpY01KeVdKZHJ1TWtUSThncUhFYzN5SGVyUmVC?=
 =?utf-8?B?QlJ0TlJaMnpQWWhmYUl6dm1uSkJ6NnF0WjdpZGI3dzNjZ1BTRnc1MjlWdGc1?=
 =?utf-8?B?b1VLM0xYMFZpZXh1eTIyUUdxSkZVdTc1Y05iUlRvOEhxUVp3NW5zTUlyZGo2?=
 =?utf-8?B?S2RyYW9wMS9aK1VHUWUvUDlsR3BOUHY1cXAwNENlckNVYkFzdVNzOHBnS1l0?=
 =?utf-8?B?cWVxeFpOWHhjeUVyczR2TFI5WEpxYWE4MWQxYW5URVlpU2g1SXlFdXZPWmR1?=
 =?utf-8?B?T0Ywb3hUbC9xcTd0djlMSHVhdE9WdG15U3YwaDJXMldQOFB5V1RKOUNSOHJ0?=
 =?utf-8?B?MFRFT0k0ekZkTTFoZkNHRTJLT3doWjZiVzM4RGVvZk1ac3R3Yndud2VpMDRz?=
 =?utf-8?B?bkJMUkRHTlBJMTlxc0ZRQUpxWG5LVFFlcXl5RzV1NmM3eWxVODR5UUk4TmRO?=
 =?utf-8?B?T2NPRjdoSU16SFVHejRNUUwxVmY1SUFPcmM3QUp5QVYrRndhVmRaclZ2ZnpL?=
 =?utf-8?B?azJzWVUyemlKeEd5RmF6L25JRFB1Q2pjOGxmNmJHQlNOaW1EdE93VVg0dTV1?=
 =?utf-8?B?ZlRpOENwQ0dOKzJYajNLV1RnUmRzdFQwSWR2NjJsN3dhK0ttd0Vjc09Ebnpj?=
 =?utf-8?Q?iAV0vfWS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d365c5f3-86e9-4632-d84d-08d8c4884c7d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 19:01:35.3425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DmM2vfIuEMJeven6F4YQ2mtAYEwIuKSJNXqIp4OedVQMEJ3HbawM64wy3nqiEjEK3CElzaC+g8yaTL5M0qqsUX619LtdDKjPZOct35hVgxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290092
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290092
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 27 Jan 2021 14:16:01 -0800, James Smart wrote:

> In testing, in a configuration with Redfish and native nvme multipath
> when an EEH is injected, a kernel oops is being encountered:
> (unreliable)
> lpfc_nvme_ls_req+0x328/0x720 [lpfc]
> __nvme_fc_send_ls_req.constprop.13+0x1d8/0x3d0 [nvme_fc]
> nvme_fc_create_association+0x224/0xd10 [nvme_fc]
> nvme_fc_reset_ctrl_work+0x110/0x154 [nvme_fc]
> process_one_work+0x304/0x5d
> 
> [...]

Applied to 5.11/scsi-fixes, thanks!

[1/1] lpfc: Fix EEH encountering oops with nvme traffic
      https://git.kernel.org/mkp/scsi/c/8c65830ae162

-- 
Martin K. Petersen	Oracle Linux Engineering
