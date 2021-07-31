Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F26DC432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 02:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A22A60F48
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 02:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbhGaCcq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jul 2021 22:32:46 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:51066 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231335AbhGaCcq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jul 2021 22:32:46 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16V2Vwgt031539;
        Sat, 31 Jul 2021 02:32:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=NSUqhslpO97XwGrlFsyRQsbOK+8R1pW+AdM8pFWoSnI=;
 b=ynmNsyPmAyXPxXsNaheu0iCyUBttumx0SNmlwVCJKV8XB/J+hC4wTBhdmseltriS/zA3
 MHOWEtjKj5WbB7xY2/dvud71B4wTikVdYY0t138p88nIzAhUKrtkH7tprOxvVb+CAgOt
 ZIfxaVUU6mpLu4ZE+CwZfqtaXmnyWcru6t2qpvIa5BwiTJhjld0rWsmlyF7tMrwI2/5y
 7E8pgJWlZd1yiK3njsqTyAYxGKkDmmnmemFOWQVVOfIfa/J/BNFR7NxeZyLwH30mdl5M
 s0hy0M/UjiggHnExN1YKfTpEFwIJAeGkIU4NbdnvGdEf7d+G2iuf2E+BJ4x/fjK66P/y SQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=NSUqhslpO97XwGrlFsyRQsbOK+8R1pW+AdM8pFWoSnI=;
 b=el3JdQIQGc4+bj5xID4t0QgDOJK1RdPWM1nRX1toKZ5Hd3SigCQ9Lgkz4A3qjasWUQnI
 GkyWo5alNeycRlmjmNP+x1ZifYqU3SUKu/xbEDv9eGvgToeLv5tn4Mrd7RbncD0UXF56
 vUu7JKQMziQyWg2E+ORdHwlssw9gU4QkrYwhgBfzhmI2h2YVrqsEo3Up/SqqbHLsZJl2
 1KlloXoLd0W41omE8RcGWb72NxifaBRuRRiXd2RdLA3TrgNBZrDm98u0eefKdV+4pgWB
 JeQwWfhrCVGORMe/ThncrwC3mQ1u5Jol9XkYOsO7i/5BHuWwSpeinCl3jn2aoOzriL1l UA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3uujc5qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Jul 2021 02:32:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16V2V2D7012043;
        Sat, 31 Jul 2021 02:32:30 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
        by userp3020.oracle.com with ESMTP id 3a23542rgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Jul 2021 02:32:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7y/wQWq/lACPBKR3S917YKO0xslhyQve9lCY7Vq8Ws6tLN+Jq4TaKI1MHnMdUTB8WTiLL23v6OjDGStinRPkWqW83wYho42/yLhRZL59rDZhsMJmOWSsjn+0CXEKDgPM61jcad1crMScwvo2pRoCH3EWP9cJcsikB/zidB9eqJnfPF/kH0jDwmB0pyaBpx4Wa7zJsuA5HZ8k4Cf2/JKLiq/NcJ+zTXSOCKEqgEC/3UmuQ54PsKji8rW8oaXA2xeuYccVHG6WfIopPZDDPQEI84Ioek/M9XuVZRxFFhyaROycohVBUrYCmMgv3jsdfKqRbMiXiVTKJGIkFshGTQeCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSUqhslpO97XwGrlFsyRQsbOK+8R1pW+AdM8pFWoSnI=;
 b=PeNnmbmuDtx2DEpQ6knCVeGJAjk/Ew9sha9C1F8wYppO+rv+eBRHTN27Wqx1VhWwEGfxzyM0Z093rzlHVcgy50prim5HWP0nx7igW3LV9RclEolrWWLODfi5TOUO572gLCYZH+5jTVmix5T8MeLLQ4Wvn3DPETUo2d9VIkFfOwkttwwc7zaKOSQY8V9OCOkKTztupxGVrijEtMadMerf1Y9cHbTMsfy30rAzfGTP9AelUmM6/1/asCiBJAvK4SVAGpaF9EtExmitMC5jIwRFBbhcBnY8xhvnbUvr6FpQrzCk6/Xa4OKBIjpl+i6Z9To1FdMiPM9hKdrAfiX7Zh8i1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSUqhslpO97XwGrlFsyRQsbOK+8R1pW+AdM8pFWoSnI=;
 b=uFeh5gwrKLHHHN1tHJMm/99Lqo6ANsogW0QTbKK3xArLiFbZ8gOcKE/swv9Hf2SWGaBxflOU+ppx6KhawlX2eUrsrt8hXhFbSgk+iA/fXWhb0aCQ4sfvgbwwyjCvFyQpGHfpbLsTT2sBY1QUFJsgCROu7sUrJmEF+8LCqD3pJow=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4535.namprd10.prod.outlook.com (2603:10b6:510:31::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.22; Sat, 31 Jul
 2021 02:32:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 02:32:28 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: qla2xxx: Fix spelling mistakes "allloc" ->
 "alloc"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8ajmcwf.fsf@ca-mkp.ca.oracle.com>
References: <20210729082413.4761-1-colin.king@canonical.com>
Date:   Fri, 30 Jul 2021 22:32:25 -0400
In-Reply-To: <20210729082413.4761-1-colin.king@canonical.com> (Colin King's
        message of "Thu, 29 Jul 2021 09:24:13 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR10CA0002.namprd10.prod.outlook.com
 (2603:10b6:806:a7::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR10CA0002.namprd10.prod.outlook.com (2603:10b6:806:a7::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Sat, 31 Jul 2021 02:32:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 916d9e26-7985-451b-32e0-08d953cb7093
X-MS-TrafficTypeDiagnostic: PH0PR10MB4535:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45354177EF47F8FC8102C60B8EED9@PH0PR10MB4535.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EMn6D2uL8zE3IsNa63kXiBWvkuE7czn2jAlQqrtM36OJ7LEg0mjaraPSp3x7m/da5BOD3/n/iETDqIjeK8FeFmPzzJ0okpp9/dKCIRiROEcZanBi5mlWmatsvavkURpBP3vZ7ErxL7UN3MIHG2Kdyva+62OER+T+eLLZ9r4ouarb5MqTVP/vO+A3H+OnvpE1xbtkH4JmkIOm/th8dHQK2unP4PgzimyCSzMRnxdRvY+KlydvWcjEqcxCGMVufIup6n1nUP8cbF9Lfb/jzhnIhUQ/kDjjWrZCP5mH5dA1hhLAJm38hS6NlUAoaO/NP/RK7CFVrcbtVQ3Mp0vAnAt7arVS4Fs5omZ5A798/MCx3lxhTawjRmSXGnvYLucTyn8XzGdohPSTtprfua1YGLmc2+gV5DYACRmI3VFN7JgfSU437jn4vUNCG2zAi3y62IGm+s3iuzAagW9qlYkMRlrXFvoVuhzTs0K9EM8CQHcujQRGOD0DQ25RRZjTBmO4Pb9P5EHVZHk3eMdzJh/f01B+Chr3JJ0XPa3rq0vuSICiiKsPBXFe0tQT1OkuOqZSRv3gIk2QLXIn1M6l7pLTWNQyPWODt/LVR1wunlJ+vx5MC/Tun0asHAXCePXYsupWy+aFSuzoFHKgQnH/aaaDl1teiW6DqD2Z6UZr/jD2hq9RxZPpBX6VAjplbD+FcQ0kn27pxkXcNm6F0s94ytQU0b3/NQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(376002)(396003)(136003)(2906002)(83380400001)(186003)(5660300002)(36916002)(956004)(8676002)(478600001)(6916009)(55016002)(8936002)(7696005)(38100700002)(86362001)(66476007)(66946007)(26005)(4326008)(66556008)(54906003)(316002)(38350700002)(558084003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j46Ikl0hNMndSRXK9a5PagZOYvNz7TEzwWQz5HXPcLGXJZbV8d5YbF4oub0v?=
 =?us-ascii?Q?h8RdeDbrYgIWOYcMEsDtOUoQDp5EbWWHQ2806K2xKpfdKFkNIkCoJq0wsKcM?=
 =?us-ascii?Q?6rcYYdLSX3pxpbEY7aZ3nlZpazFRb2Ufkt8yfiSodJcmqiysjgjNFDkjDN7T?=
 =?us-ascii?Q?ZzxNp8ecJtvjOV5v3yMbUqt+S4A/uTeKD2uqDDxPf2xgPQZMH+VyuMmJEVTK?=
 =?us-ascii?Q?hGFZqwiYzOLmNMwGLjVooI0XLLkYOtKldk7LghD+8+N81gM3RQubzJ/RHgoR?=
 =?us-ascii?Q?cIQ+t/4+hf/XNQ0YNqySeLHeWmAu7bqdQEmGeKBXmEPTgSbIDd4fl1Rs/Lcq?=
 =?us-ascii?Q?84NCAxfyKU1QxuU9x1ehmt6NQMylLFXmwM3ekMIHByUddKsbcu7gXrYx0ugp?=
 =?us-ascii?Q?5WQTtgeFNu9qur7dCB4YWcm5nJqSfkOwWorzssdnMIvXXdSmtODsQTkuP96g?=
 =?us-ascii?Q?fM7h9DM2nGbQ6aNuvX0Rl6TUq0zDOa4oo0d4cZnIokCJNdc3Tyzkkrg0mDTh?=
 =?us-ascii?Q?L5Nj2SG3Wz5G18O0IRjjRGIJPfFvRzhBJABzw/wcchZCcOL6iK3m/UDKn3dL?=
 =?us-ascii?Q?Qib6sfQvIjlqTQ3EkliJFVErxAGUK4U7928rUqY0ph/oW3UNOCuP6ILTXqNa?=
 =?us-ascii?Q?qdVzXPZ4aQwyeANbjuJRCweweOvupI6SxSoqo5807NGlEvp3MPx813NYFQ4T?=
 =?us-ascii?Q?miy64fkgFFk+3GmMOarATILIZilXF1RbltLdRW4DdOar+MgBqE0vbrjLZUJV?=
 =?us-ascii?Q?IeZFHLdQWyQR2EY913bt8T4TCM266DkWk95T7yMWuB+YTUj4p0W554/Pdqdb?=
 =?us-ascii?Q?BynMAGEBt/W0qO1jCgqshu9QOshisJb7/C2kOP6oHDpCqQMviPxn8Wbm8mvq?=
 =?us-ascii?Q?IkBcFqEkHjse2/WwH+k3Befw5GkWuvha51IhzcKyy7IXdPye3ac5+npOtIGk?=
 =?us-ascii?Q?ny43D29sTjX5uxuMg0t6mP2TPp/GVKFKTQUu5RcLFo/B80SoD5U+TTBLl2Gi?=
 =?us-ascii?Q?w6rxNhO1Fu215BjkBTzbtTTkaXD0b3IwUedrhpxLL1JrHiJNFcrLoKQ+5HxE?=
 =?us-ascii?Q?ZdYM1Fis5mzs5004yOvA+3faL/uQpe78f892ZRVlpaZPGox4Q/RfFaXTpDau?=
 =?us-ascii?Q?lxWOOeQeA9RTWlHFZ2da2aTWrN+XlmEK1aqlL//siHwLWs0zeWZt7jFCnNUz?=
 =?us-ascii?Q?YwOnLd3+8MymuzOWU/tC6qIyYDEVK6N+wXbYUIHtoHI5BSIeWWmrZMleMwoJ?=
 =?us-ascii?Q?JlVKqJiu6Nzs4duBfXmNy8beD0VcmmAvLrjP1MOepUpZZ/13rT75ccjZX1tn?=
 =?us-ascii?Q?hR0bJgXQFY0ORozv8E4BDbWh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 916d9e26-7985-451b-32e0-08d953cb7093
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 02:32:28.2653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XcTNxdrP8vCJgNa0vg5YkTk40jh0/KE2415J/GRMsTzKex+5jdrRTAd7Ug9BrCM0BpMYI9S/wmCus/6/lHhpb0o1TdCq5NHGaKgBiFTNsXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4535
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10061 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107310010
X-Proofpoint-ORIG-GUID: -SfkVnAwJ32o8O-dS2vbe4pCxohsnFRU
X-Proofpoint-GUID: -SfkVnAwJ32o8O-dS2vbe4pCxohsnFRU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> There are two spelling mistakes with the same triple l in alloc, one
> in a comment, the other in a ql_dbg debug message. Fix them.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
