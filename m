Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83ACCC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29FBE64E0E
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbhA2TFg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 14:05:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51730 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbhA2TE4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 14:04:56 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TIwh6L073598;
        Fri, 29 Jan 2021 19:04:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SzE+XuAFrU8/MaSJjlPngMNhjYCRkpFys29DySabf+I=;
 b=xbe/yeGD+SHx6HySyJCirdmG4NEwD4l+o5jj7oYSLeOYPYTScH6keah1HZjlgkn2f0eY
 fcDsevTO7INAs9bV0mXfQknm2/Zj6Mvkp0jh44rGweTYKFgvb5J3GZTfNl/vKXUo3SD0
 vs8IwAwCNV2uoqELcyMRFrc4ehRRMkbw4C9X2hck7/v+sHZp6avcE//s35WMloe+9Rs6
 Ordbh7pvS6X1fMNcFrM5uoKQksDwSv/OyTE0x0G1HNGmoPqfnlhGwn6BM4L4FLQvRKEj
 OjKjvAFVjqwr4rUHObpJ78baABO6fP4bRrwFu1pgCG5j4ntl+o3p2OqXwS0xAA1KlUHP 0w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36cmf894wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:04:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TJ0ih2052883;
        Fri, 29 Jan 2021 19:02:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by aserp3020.oracle.com with ESMTP id 36ceug9nrg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:02:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJ/n2xAgqMwp+vDy2G8DBoTszORnAafRzwS0VDLhje39aSpr5DGee6v1piluWM6Bj87U7kegWjF+iuZoh8HOjqEg1B+rlo3MNeHWlTe7om0fou4513FajiUAmx7F2+WiOAtpb/YA+gzUpFUpg6+Kiy3RJDCrVFIjF4nfxU6XKquqfXhsgu8KTHVamCP/pv59svK54O21i4C2cU0Dor2/HZ65li24yRkDbsZrmTJqj24Jr3io8umjukxTSlqbQQ2ZZ6NNUs5KSmI+8KxxO2DVzP+rTksKaPgonVsQm6j+VAu0ij8r1p8KOTYUnUqJ/vWHfb5HWVNjjfXFGgA6f2MSzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzE+XuAFrU8/MaSJjlPngMNhjYCRkpFys29DySabf+I=;
 b=g4z59DyAhQiOnMtQ7dBQfE7fs6PwpGEzdrnk3A1seQxsUHnTMDo55R3DLqu5MD5VXClA0qNsXNV4bifOjEcuWsLUGRRwWEbm/m6pwmpnPdazLE9gxxDns5hRQAUsTx4dbkMca9mTMSZe16v+VBKhLZlQEg9yzxHsiAfsOi24TVUo4NBzceAPpEEyMeHPYOskLdHWrSNlff7TD5NnDKyIt5FNWqgalMmX1Pc5oC4f8FLANbQ8F12A1HFKIiwD/BEAYJDD2TGXdFg52WZiMArVcxo7GBnGMY/YgP3DNDbmVPtYM3go2jnv/bEb8ZVxOMedEsGUKY6SjUR20Vldy6mCsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzE+XuAFrU8/MaSJjlPngMNhjYCRkpFys29DySabf+I=;
 b=KqMK9PVlh07H1YfZB1FuiePjPJq+KnInZUDE0OldGkEhNuctDKo4vlCCu+60RVboJhQe2BLos5Kn27ASymKZ8UY77QaMi5w1EHrikA6IonuHw9vWxBjvkxrUOy8il8obB/V9KaGwY1aEuLcayzVkvSoRQVpcMPYpZ50nqPI+DXw=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 19:02:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.021; Fri, 29 Jan 2021
 19:02:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1] scsi: lpfc: Add auto select on IRQ_POLL
Date:   Fri, 29 Jan 2021 14:01:53 -0500
Message-Id: <161194526371.12948.344774339686178151.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126000554.309858-1-ztong0001@gmail.com>
References: <20210126000554.309858-1-ztong0001@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CH2PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:610:4c::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CH2PR10CA0021.namprd10.prod.outlook.com (2603:10b6:610:4c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 19:02:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dda73a2-b370-43a6-7799-08d8c4886172
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4677B70ACDF6B3F2FD60AA508EB99@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mdQOSDGrct7B2FRYINsbnCjyFrWjuVNc+BPhHY7UbeJ6k7xf0jMJvH+ps2K4v+v7znhEMeWvL1O8IJINzwVbvz5VRymV2uxzz39pbEtI7PL0olfErBSnUiLuvAu7SmWx3UOi4ZP4Lqj8TsndPy8Aoh47NS4kOb3byGAb2OarxuICghV8u8NHoy+jVigioX8wo9mWWk9Jrm9qzQdcQFzGFHvgyrduwHdQGDzagmelP2Zs0HnXcEdZuR1dOblc+rOVwR6AhCqV6gy2Q96JPNs2J17KxIj9qylSPZIjCQsA95ajJcerQzWGgVcCqGBOjq6C/oCFWXyxkXpkCB+OFTbaHdH6eUZQGGyXt3Tkruz1VvNDw495+wP0tRTEyw0ilXSnTH0t7B5/v/wZa4/ZASJclYxoV9x1vR/bIpPTXrKZmOlYEFGAWrbjqZUe1WHjqonqCV1XUc00hjtg2h/OAaVLfYtu2I26kQtNlQ3F4R0OZOMQrz1HzmIEHLbwPjJ208NY646YuL006UhFHqNQ5sEbJtIH48MHqta+DlceC3ksQ86RX9Z/VNHk+gTXikJ9+NdbNiCSDkJJQyZDLE/tDXaxrAW9dIfNtTCVneNP0OztmzI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(956004)(107886003)(66476007)(2616005)(26005)(52116002)(66946007)(316002)(4744005)(103116003)(66556008)(5660300002)(16526019)(186003)(36756003)(7696005)(110136005)(478600001)(86362001)(6486002)(2906002)(6666004)(966005)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TncvaFhhT0YwcCs4ZjVmSFNKVnFBdjJrYkl1aUR1dXpUdmx0RC9vaDRVMHRT?=
 =?utf-8?B?VjlGR0ZJeDlITFNveHZvb1R4NytEY0psMFZJMVJrODZpREFJanlLS3dsbE9U?=
 =?utf-8?B?N3l4bkVIYXRpVW5MZ3VOQnhkRnB2L2h6YlFvRkIvN3lxMFZYK3pzalJsdmlk?=
 =?utf-8?B?TlNlYUhRczBwc1lydDlsWnMwN2lENGljRVhtclNMbFU1U1lxdE1rVTRUUlNF?=
 =?utf-8?B?OGF1RUc2S201d1ovbm9CcVpiSzNGMk5WQi9OZzVHb1FCRUwrTG52bHhNT01n?=
 =?utf-8?B?WFB3UnRTZkgzRyt1QkdreTJlV0dVQmxuS2g0TXAzQmRGbE9lbWpRalB5WXVz?=
 =?utf-8?B?aloxVjJyYk5VWUtGWVZIQVFVczJpUERqMldldzM5R2pLMFljRmFxVEgyZ2Zo?=
 =?utf-8?B?UFV4R2xvdnFkQk5rUUMzS1BXNXJUZlJrQ1FnLzkyakduSlNXa3hhcm9VUjhr?=
 =?utf-8?B?Y1NXZkZ5Mks2U3AyUHdNWkpleTB3b1cveHd3OUhKZW5UOXI0S1krT2FmWmhY?=
 =?utf-8?B?YkRJSWcyQkZDRjh0U1FhUHRJNnNUWnBOcG9pQWpDSnhndlg1RXJKSk9oUm9Y?=
 =?utf-8?B?UnBSRGdaUzJ3anZ6blNPS0dVaWozV2Qzb1BudU9jS0RZTytzRXNrankwb25G?=
 =?utf-8?B?bTFRTU9CY3QzWWVEaU91MGZrRkxCOEQxYS8vQld6U3dzU0VON1gwSk4xUlYr?=
 =?utf-8?B?RkNnLzVUSUgybzViMGVWYlpHRmhkSWJLS0xyZkwrWStORUJaYXBBZGI3TnNP?=
 =?utf-8?B?RDM1dzBKNytrM1pzOGdYZHlzV29XdHFWN2tVb1RhYkJQdGxJNTZjU1FaZ2xQ?=
 =?utf-8?B?RmhLOCtseHUxVmdydXFOTlZZUklSN2dtVTg1OExUaHR1L3dqTmZVa21menFO?=
 =?utf-8?B?UG12enB5KzRhLzI4REc2MnFvcGh4UzVJcTR2OWl6SzRUN01pY25ySmdoc1p4?=
 =?utf-8?B?dUpieCtzK0RoMnpuNWFpQXdsZmYwdkEveC9nL0xhMll1QVQ4dUgrREFOZmta?=
 =?utf-8?B?KzU5SjFBanVYc1ZrNkFZVmFiTG81SFhGZVNqYUJjMUFoZFJOeU5CM09Qd29Y?=
 =?utf-8?B?WGZHTjdxbWRXSkduRUdUWFVOaUZpS0FCWUN5eXRGaWVEU0g3d3htZVV5WFUv?=
 =?utf-8?B?eDBIRklEUWMrWmhDVmZXQmlkVjl4V0x3cEVuVVJKS2dtVHNTTG1mRHFpTUFo?=
 =?utf-8?B?Q1VEZDM3Y0JBMDRBLzhJb2tnVk1uK2dZc1VjS3NrZmJmaEc5LzJ4K3RqTFhq?=
 =?utf-8?B?SEhGTG5aTXRTb3RjVVhVR1BCOEFoQWlGTlByMWlFbmZsREl1aE1raHZ1S2xI?=
 =?utf-8?B?THVzMzhtNHRkSkRrRUVXNHpha1RoWXVKdDJmUmRabWpTczBrdkhGUUVwYzJD?=
 =?utf-8?B?TEpmTjlYQmE1eHUzemxPOFVobWNFcWJkMnFVaTBEZzdaNC9UOGtqQTljaTZk?=
 =?utf-8?Q?A0CRNguv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dda73a2-b370-43a6-7799-08d8c4886172
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 19:02:10.5091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /HFjhPwXM1BNL0LhFQgcAddOrLs72NGY8pWEo4comJuH8G/Na12BF8bZU4aAPJyFgOGAGt2MwfWD8i0HJpekswR+OZqJdZR1L4T7NdNsE78=
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

On Mon, 25 Jan 2021 19:05:54 -0500, Tong Zhang wrote:

> lpfc depends on irq_poll library, but it is not selected automatically.
> When irq_poll is not selected, compiling it can run into following error
> 
> ERROR: modpost: "irq_poll_init" [drivers/scsi/lpfc/lpfc.ko] undefined!
> ERROR: modpost: "irq_poll_sched" [drivers/scsi/lpfc/lpfc.ko] undefined!
> ERROR: modpost: "irq_poll_complete" [drivers/scsi/lpfc/lpfc.ko] undefined!

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: lpfc: Add auto select on IRQ_POLL
      https://git.kernel.org/mkp/scsi/c/fad0a16130b6

-- 
Martin K. Petersen	Oracle Linux Engineering
