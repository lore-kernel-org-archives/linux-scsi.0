Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76F4C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 02:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BA5564FD4
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 02:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbhCJCuF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 21:50:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53316 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbhCJCte (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 21:49:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A2j1wV021945;
        Wed, 10 Mar 2021 02:49:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=4S4p/34TDGLQFszeh7bzfFouWypr9J3aEEJ4BOo9abo=;
 b=uFF0Njtuvp5RbwimxhAEed3Wqq+TfnNAkUsGxUM3tHpvP+ZhHSfxHlBbtMThHMCxPho2
 jt+Jn0JaMDGFBHTIIvKpqNxNCvUQb/bdrZIoWM/VhxtiP5UejyRyIQx1P/TFcHKJ1ccQ
 p8lEiCdBpg5O5By1/B+ZVJ2ezSsdKfLicGoBTMCcUMuelh61c6wmjoLRIiQtbWosZiF0
 clgowKA134g+nxL0vCv+DjXIkFvay2Q1VW1jQnowif+dNt/uvr8UjAYcTQXNu2czem2s
 fFKsYZ4T/70DSdjFLrEqa3rI8V9gmEN26APS8KkNxamAAbPODezR+KTOvDhpr+DIXuV3 6g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3741pmhfup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 02:49:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A2jQmC171203;
        Wed, 10 Mar 2021 02:49:20 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3030.oracle.com with ESMTP id 374knxpreu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 02:49:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dLnSCz1tg07L1V9U4SRc2YXAhx3VwzvCUtCWtAIfgTKacX0Qk3XU9T37xFD3DF9TsCEBgNkAamJiNHQ0pxsrRQ9TSz3TNrAqZh96MvOcbDnQwYrP5kNA4I1gRKdBsvh5yci1kq3JlB9FO4B35m4kh5cdzcFE1mB4pOJBRTeRDlTIHm7mgmavUi7urJ2AJXbGNrYXQSFyXqc9JRaSVYhpLvL1lg6VBIayyvu/NKBvKpa0rtV6ePiE9p63sf3cwgazg5Kz19i4jzc3Vc4fUB2e8JYLuyyHA/li5LNIv3vah5Apt85Ea4m4DHjaNTbEN/3fMs/chOp+da6WLyyssOHurg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4S4p/34TDGLQFszeh7bzfFouWypr9J3aEEJ4BOo9abo=;
 b=Oj50/fWyIjhSUlqwCs5VQ5A6qbLBWB2NFYNtr/9Pd74z8duNcPaH3ErHAIk6HPmvwLSQDAuylFYiulU/viMJR04Ofw3TEIKYjZ/SOIiOcsPE7OX3FRvCm8jp9dN0ODkjmzYVnFDkkJB3+m0Yi4qCqEgPmKu081rh9m2k2qjhnbY8/6aoClM1Xj4HSE6vVy0Y4vXoeNeHIxbrjxjvhsQMYhxOlIfJZmcABCaAOIHI1RDVWaa4zEBpADx4lGNz9NyyuLwBKK5Aq0IWGvKQtPlKn8DzDPQxX/rdwSH8/+2KystEJCxXa2+pHAe6phLB9juvGGoVsDEDE1bD+YPek+YLew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4S4p/34TDGLQFszeh7bzfFouWypr9J3aEEJ4BOo9abo=;
 b=aE32g1+XkIAi4l7WxOCkUnjD5UVQL1K5Jg5DQrmVASoEU9DTiM6AityoaXHtjsJ+yNeaWKJLKV6twc5yQh9a7mQyCJns+tMJAnVoU/LtoCQwXNthvzcYrbjKF7ewVpEuBvQ2lB3UgqUagnEsSeROV47fw+CjmsjmOsb1sQD2J2E=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4792.namprd10.prod.outlook.com (2603:10b6:510:3d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 02:49:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 02:49:17 +0000
To:     menglong8.dong@gmail.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, beanhuo@micron.com, jaegeuk@kernel.org,
        asutoshd@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Yunkai <zhang.yunkai@zte.com.cn>
Subject: Re: [PATCH] scsi:ufs: remove duplicate include in ufshcd
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1blbrbu5a.fsf@ca-mkp.ca.oracle.com>
References: <20210306114706.217873-1-zhang.yunkai@zte.com.cn>
Date:   Tue, 09 Mar 2021 21:49:14 -0500
In-Reply-To: <20210306114706.217873-1-zhang.yunkai@zte.com.cn> (menglong8's
        message of "Sat, 6 Mar 2021 03:47:06 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY5PR17CA0057.namprd17.prod.outlook.com
 (2603:10b6:a03:167::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR17CA0057.namprd17.prod.outlook.com (2603:10b6:a03:167::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 02:49:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec80aa04-17f6-41d3-bc59-08d8e36f1909
X-MS-TrafficTypeDiagnostic: PH0PR10MB4792:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4792F27376D6F998065C5BF08E919@PH0PR10MB4792.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5IO2/8GiLcuXEf/o+rGhYdiLIhuDBe9w2AbEUQBCm5U7EYqo+qheY1bIVLC4RDqrAnf73mZ0L7xstJF8IW5EnMMnrRbXpvoVcV03ICee1JrMiXCDLDmISYRjhdaSgDVzQdAaJALXPIQeeeCKrSBG563DXEKu5+7cjy4NZQ+jtomrcxEi0Hv12xkhI6/5Xqug5FWnC7AXbSnrUxNVa6B1Bnhc4wxEz9l7pFOtNLGg/GiSvQrSDWofaOosHAW6Hm8c7DPZy6RadRjFz2v3jz3kB3Ps4b/yIm2dA9fEPvwx7pbSq1Ojn8WmOy5pO4YHkTxmds3wPUZaqEXfFLkdJHmOkPESlvr06VbFydcZq2KI2BbQay8mCkSQfLjnWHRLfRkoiAaN1Lwn62+/LsHLKKMkNvLzeQ8cF8T3DL/QrsPqpJA3hVZ5ujLKOKlUbfDqHNJ794rYYeV3MsJr3s0Pyy0vuDD2ufE0wmG6tPRjII/eOe28hqT5Ct9xXGipN74bC/g6bw9PUqYxuxxYwGzvYcm+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(6916009)(6666004)(2906002)(956004)(4326008)(7416002)(66476007)(558084003)(36916002)(7696005)(66946007)(26005)(66556008)(86362001)(16526019)(186003)(5660300002)(52116002)(8676002)(8936002)(478600001)(316002)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3AdgKR0ym6jM1cFsDq0dDYAJnYyXjqdZOU4yqL5xklRl2QQU36y7u1FvJl2W?=
 =?us-ascii?Q?Uk6xsjtdKU0o9avSoavyjLd27cABOxHX2CZWWXrnwRlI1vrIfg92SbN8C4ra?=
 =?us-ascii?Q?XlY1dBD2wgX4GuIu7DEovmO0WYBR+6IaadcpxotLMi1y3xKsvyWfjCc0CnEp?=
 =?us-ascii?Q?gzFSoi8is6W7QK2TnCgE1ZgjQ/MPAG8n6jaKJY9IR/PDwtRJ/5YeaDrpAf1B?=
 =?us-ascii?Q?FRtSFoBK2GF46lsDy2shOCZPLm92ivjCbhcF05v6/80BN5IOngHAwwJO4H2G?=
 =?us-ascii?Q?hOQbqrJx7PJZxa9QcZLwgLjHZkf54qqcyzFU2VxnIhdPl6EG8pndf2ZUx5G7?=
 =?us-ascii?Q?TnPH9GwBDpdd5jrq7WWB5QR9f7iaUDYeOyHDdFbfRURtkK7G/8aA4TBUDmFA?=
 =?us-ascii?Q?E+giLGRjueyGPyLz0MU8MOWL0qxUxyU0ZRiO3AbA3r/rj7sgt1om4Z4RRbNb?=
 =?us-ascii?Q?xKh4JvVFWTAmSlBDFUCaOE/zlkLKAfRriFEquS6MF1oJmgRnx6sayfbg5sgc?=
 =?us-ascii?Q?+t1zJp4PhTec4em7NrRYnFz6sOi76yc5TVWWi7gfc4rLvZ0F/GN36SupaWiW?=
 =?us-ascii?Q?8/8jpVVo/nvPAc+1HlvxqqWZ3YLQLpyTdIv86kW3Rl3RwJGk4URdsnUut8H6?=
 =?us-ascii?Q?mghpmGJVIorzbmzaWAtSQ3bHRLSNqMBYU5XSI8bf7OR/sU41ryZcAPmgEz+o?=
 =?us-ascii?Q?3yq7+8zBXAbC56nI0dpPxbJjern0fhLwWTK6UfRm2l0DngGuLNgFrcHBDLiH?=
 =?us-ascii?Q?gBWjp+ocSPcfVKywT4Ej4rzcL6AzOrVOzIgTZVfekWk+d2ZtChEPvS7/JYv/?=
 =?us-ascii?Q?mM28irvBo43K5vO3AmaPzqXy2Z7i6vjbnJYpUIqrkUQvDzLFfxGU+cQ+7uBN?=
 =?us-ascii?Q?kIjB3kjmzQEXHSlmZudAH1YQy688nFHxBcBwQHjcaEaooWNj9cW05T1AWl2M?=
 =?us-ascii?Q?pWPX5aSeTpZ54SFK6tIl63e/kN5aZQYYeIsxigQNALNsuCtMxjbKLnv/FK9r?=
 =?us-ascii?Q?0YPTemGyg66nUOWEXkPZND+RPY6junmNJKSexRZGKbbt5TSzQT9dugiyHuXV?=
 =?us-ascii?Q?jNyLo8kxQ0V29CYRwT9hqkCoAWSy0yKQ/OMuQlX6Zhb4Lz8eZfEaJeUyt+Y+?=
 =?us-ascii?Q?zpnmjTrlFYOmA7qX9mD3xkrSLeshs0wXayJNogbJiwRIt9O51pBF3dDh51in?=
 =?us-ascii?Q?+HjjsuzuUXPiRP4vwKM7PcW8tghKjJbACgncuFGFaSPtZ5Km2/4H9KwEA86i?=
 =?us-ascii?Q?vbaHTqJgGr5vVpcP7DKYVfAvtmn+I+Iz8TTIZ4GxPbNoeDdTfT3dy3AG+aSE?=
 =?us-ascii?Q?DaxlXsPJXeM1z4XmvmR1IU6M?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec80aa04-17f6-41d3-bc59-08d8e36f1909
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 02:49:17.5013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xjWxKcAprv+0u1sQc8Ug7oAGNmhMyyKp64cwzlVsw63HzFSo6Ya5IsC541mHRQHCryBXgl0Q+lq7qD9fTgHF5YZXLHKlhTbRUqPZ7Pq0Yk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4792
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100012
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1011 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> 'blkdev.h' included in 'ufshcd.c' is duplicated.  It is also included
> in the 18th line.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
