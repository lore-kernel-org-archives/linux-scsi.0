Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE729C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9294611CE
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241689AbhDMFIV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:08:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53084 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhDMFIU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:08:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D56QFc007542;
        Tue, 13 Apr 2021 05:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8PEx8jT/qQPNO8AUkyGQuXuLzK3MDzi6d/5ub9ojlW8=;
 b=tctiv7/pay7Ndk3JZbXzv+FxctOwXJkxNzTyhpDbFjbfJEfUA+i8oKteg7uVAMcSOhdv
 GzNjYmkqgkq/J+rsOXs6JXa2/Ye0G2cGJzNjD+fUcWNJOpAb9ETt6jGzESlAatHA339d
 P1qVNxXumXRnO4bHLD2ZwHmVGUyluYP9tPXdUhyKIwAi7LF1ASKaAG7JBJyc9JeaFfZB
 66U87duCywO21MgLvtf/ocAFmp9SzaoATehlb7MLsacqswobCuaeVOOg6Ev4eRVFVi09
 p3plUdXJg9EaPNeRYmpR0HWT0NFBV5tiZcrOw2hIfRk0gquyMCJk+mdGu7Ufva2oNu1u 3A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37u3erdsya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:07:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D56PD7153425;
        Tue, 13 Apr 2021 05:07:54 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2055.outbound.protection.outlook.com [104.47.37.55])
        by userp3030.oracle.com with ESMTP id 37unxwcust-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:07:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BR7YO8KJXPiWFCEeMYJ4ZUGolAbCxtYjdwHbbrQtJTY+GqyZNQv+6OMylp3KQDCZu0UE6zNZxDF0M3S6ixh0L0qq3dyeQHA8uS8Z1Di7QP9WUzDbaED3Y6eiFRVAPIrY0SwHclB/4LkubctbFI6cDZZkgOnW2JS4kT1lXwWNTQjn68T+1jJb5WfD/mYhDOFoVCbmdPA0A3nJtRt3m8N6Vj4Cd1/dTHDRIwUvUUx4TAp+OHbWBkA8irAgPeRfRFD39swjxhZkTFgYyC8vas5CXJdvGlAucZ/82O388YvG70MRJVdcfPpTMaNHL2IyWlNk5dPECoTZIgcG9mhwUx0ayQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8PEx8jT/qQPNO8AUkyGQuXuLzK3MDzi6d/5ub9ojlW8=;
 b=CtNhivWoW5QRolS86PlecOLvw0dqFAVHCYvAUS4IPwpUicXaVg1FWC9fcXapsFUMPJa/dD3A33oBIOsjVxFpp+naAQhWFSTfa8AYI188fSecIUbW8H8/9B9yqArH4YXNg87qZju0qiGhe1p7Eui8AsJwH7S+ytILmoGPtf0qa1Y881iOmY8GLrmktp1jC9Ez4v8kJBDS4hRMB5JhdKklBx8uIGjjdJiAjqDTdefoBNXADOFGKDDipG91yVQs/UAosBi8PaoJ4EYeCZEK0YdqbU7N9Ct7NOKSBdnPb30RPUDiAWfLShs4GXvi976tj2M8zu5TvU+0iDCKibYcetl3Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8PEx8jT/qQPNO8AUkyGQuXuLzK3MDzi6d/5ub9ojlW8=;
 b=O8PUjZAMzXgZc8tPrBWjZLfI0Bo2dKk80E/10MS7Ihp5rxz6fiiUb/3Kw8um3btELsmZfy2soS+BKbKpdZgdjB+tvUAxloUqrvBDU/oGsfuFTLmr7MvM+h5PPcjrI7ZpxbTwDF57ANDPEisl7VK7G0vE38y56HPZ0geAd+2erQ4=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4424.namprd10.prod.outlook.com (2603:10b6:510:41::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Tue, 13 Apr
 2021 05:07:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:07:52 +0000
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "MPT-FusionLinux . pdl" <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] scsi: mptfusion: Clear the warnings indicating that
 the variable is not used
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1blai7p1z.fsf@ca-mkp.ca.oracle.com>
References: <20210408061851.3089-1-thunder.leizhen@huawei.com>
Date:   Tue, 13 Apr 2021 01:07:49 -0400
In-Reply-To: <20210408061851.3089-1-thunder.leizhen@huawei.com> (Zhen Lei's
        message of "Thu, 8 Apr 2021 14:18:48 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0148.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0148.namprd05.prod.outlook.com (2603:10b6:a03:33d::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Tue, 13 Apr 2021 05:07:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05667769-abca-4882-4dfd-08d8fe3a170c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB442432BC1F47324AF4D207188E4F9@PH0PR10MB4424.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JBLtO6E6EcKTI6tPcBc5hvL9xdRuOJVyimyUMaELubw9Nmk5dTy8oANXpCSgwC3ngFecNPFb1cukASbNTvZolHdhcTtrVYv6XzHHEV6YeWgVKuWostzMjMVuNmHMK2NewW/ZBQcXc5N+6UxyyIsPl4XwG2vOfecWa0OF6YRv40NLeH0Wp2McOVMz/vFxjEeTr3w7NcPx0+aKEE0H2NsyLGwC3imEtZwDO3Yq1i4ib2vwEoPW8y4rDxsLypI5e/RreXNfJocl6YCQQ6cJfkFv7x0CZMJCZ3bjd64HysspJBsyVbxQU3MSf+e6IIYMpQcI5hk4EHTZ00MqCPwm13ze4WKCY82Qaw0+X+l6CPlR1EqGjTgGDVN/N2BJiOy9Y6BzJ0Y/voAd5AUZ+RV7JK54Pq9rQ+hdZ4FhpSLd9zRF/FVluecNHItWD/aWVxiKqKIJR5+BgOSGOuNi9unpHejw9ZsZlePFG6kEcX4bv2vpOH3zL4z/Ls03PwvN9WadBnObT7sPKW/kL1OdY8P2M2bMpX9TktL7TaZkuCWiJIJXk+8SxfvHpGv6QBTH4swqAz3MCUN+TnCdzoddCQK4Wlbn8WOHX4ifTqKjaF8Opp/Qf3BJB393fRAWzoHH2vJTWtZrrU49HTE80JKSovZvxIkeLK5U5OOctCanVea/xW/SxK8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(366004)(39860400002)(376002)(66476007)(16526019)(38350700002)(36916002)(52116002)(7696005)(186003)(86362001)(2906002)(5660300002)(6916009)(8936002)(8676002)(66556008)(4744005)(55016002)(956004)(66946007)(38100700002)(54906003)(26005)(4326008)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LVgAhNXXpEzwe8IAS9LHQbK3a9qkLf0dLbukcS2Ld47uanI41T92ch9+EJTu?=
 =?us-ascii?Q?EcjgTcsP882nqnAhmNnsqMAcF71QAN0Tegv26JUcirijYeWaLsPRa85KswIh?=
 =?us-ascii?Q?GbT20WfI388L8cz4R0Yd9R33V93u9q/QdyPgkZ5reUch4eb+Gn/kRqsfFW6l?=
 =?us-ascii?Q?yRYN0IndL+S5fw1sSWoMvMUwDnDWMTaHSVY1pC19msCJCKjBcmCQr5i79cTR?=
 =?us-ascii?Q?Rm24D4l9yHDPOvOzL5TNM30TVGM1qhygBQUrf8uGlt8fgPo/ZVCexs6JBzDT?=
 =?us-ascii?Q?Bt5hTAr6oLVE12HTABVXipm4b3SjOU08ZV5quuW6W0Z09e4cnZgwKBLjXGXJ?=
 =?us-ascii?Q?J7tvKqtDN9hOzilFCaDWB5GfJxeoRquj/YiWmT9LdP3jhFY2/vyqm/4VuQkL?=
 =?us-ascii?Q?3Zl4PE5WofGxhvhJwSyGiRbJ6UbiPZemoIIc9fK/+NK2eqckhfMCiBi3FZBF?=
 =?us-ascii?Q?2hm1z0QxfdjyLVjRN8IaPP+GRqswCoM54Cry4Ob7coSj+uFktIonxHpPux1k?=
 =?us-ascii?Q?hKUXZOW/bkYRaYiErF8yt1wutSvVQCmsOQKhT6ziiCYguxlX3GqLqrP17LPr?=
 =?us-ascii?Q?6xZ4x4jtfJn5zcuw4ALTQt1Ft3DZNwPwvTFq2B6ERv2/KBCQCqS/i7sqIHF0?=
 =?us-ascii?Q?0M2hdnv7dMVsYCLt5KZbm9UijFi/8oG4XRk9A5X3eozYBdHA7YZNmqQZrKYY?=
 =?us-ascii?Q?qmE3sA2ubxB6nM6b/kOpxAnphSoLEXtOp3/j9CcrePaBCpY0kPHT4zcwzU3U?=
 =?us-ascii?Q?prgn9pDlBLS/lPMngxPx208sKG0nH9wI3EynwNoUeetymZzgl3znWjbPg/SB?=
 =?us-ascii?Q?AuZcbcnjLxpMx01TIekiwyf3GFzRn0y/Pfh4bIqCzybPETE5nqfflbrbplLj?=
 =?us-ascii?Q?wdHrFvUPLYuSYfE5JfCC6QemqoReC4YNbqwyOMfs2uHwN3iYDMfg8YiMR266?=
 =?us-ascii?Q?1QXTGlJiQqKNyS7b9HuhIgXwqJ9Y/JKLD5c60w1z1fzjJwzylS8np63b22PB?=
 =?us-ascii?Q?8XZWV880y3XltojvaQBd+ayceK6rmKeSweprFxGggu0NKvx5nUoy0beBg3rh?=
 =?us-ascii?Q?UPY0DPL+bZG8WsvY+DeoCPbmwBLG3U0v0U9Aclh+aACWS4pUeHfOhf02OaQR?=
 =?us-ascii?Q?Jq+0vS0YiyfG5Ee5MMnDZHgje2wG21/YbA68GEX+OMORXhGvDQaGefxpaF/u?=
 =?us-ascii?Q?P43pp6TOl6b7PvlOJ4QBnjgtw3as+iHpLz4pSFjJVQPOdafENzgu8aXSbrr9?=
 =?us-ascii?Q?qsk7il3s+CGyJp8lZSWKp4GS33q1C/NPLMqPk32O92SRdUmGJ12ngFrJZWdK?=
 =?us-ascii?Q?ytsC2ERmv5rkNjefmsRz3P1L?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05667769-abca-4882-4dfd-08d8fe3a170c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:07:52.2251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PlzVvksbYz/iVl1m1d9T8BjCqMdewJFzsHQ+2S/P7eZ54z4Q43N+BJiiekOEOo29r2G33ap2zApH685OTs9wUJjMvdTiPYnRpFkBK210gAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4424
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130033
X-Proofpoint-ORIG-GUID: k3ExE0JK47QC9UD8cFU7ibEi398UW7tf
X-Proofpoint-GUID: k3ExE0JK47QC9UD8cFU7ibEi398UW7tf
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1011
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Zhen,

> Zhen Lei (3):
>   scsi: mptfusion: Remove unused local variable 'time_count'
>   scsi: mptfusion: Remove unused local variable 'port'
>   scsi: mptfusion: Fix error return code of mptctl_hp_hostinfo()

I applied patches 1+2. I hesitate making functional changes to such an
old driver.

-- 
Martin K. Petersen	Oracle Linux Engineering
