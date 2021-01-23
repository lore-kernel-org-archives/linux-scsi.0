Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29725C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 02:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D32D723B55
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 02:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbhAWCSU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 21:18:20 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36616 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbhAWCSN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 21:18:13 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N2FEam144586;
        Sat, 23 Jan 2021 02:17:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=z07VeFp/83aNzneiComknmuzOQw/7tYMP2dQBy6wBsg=;
 b=lNKnL+hZS+adhCwOpEozaul1fEYXMnTmFCpyWglk23AXhrpSZn9ewcB6tWkIN2CmQNjB
 5e5cAEQikouCgghY8hj7wBOVqlsHLANZXaJ6eFG2DHnF7hjYinKyGby0RljC8neeMoBc
 oSz628UVfGW2NBx++5GjASpA7niunlTDEAoVN6Lcr0xAcvzYVyDvnTKQMo2wLqn4bDIQ
 MUp4PPRHZSpagCMzLmfXkuEJbCio9ivrveuOhI5mA+YprKYswSPmho11R3rNjTmYWeRn
 j2YBvkj8fuwzBLXJDvUF2a5EFL/Vx+3AurcmDwZa5fzuyUEvgwre0ErVmHjkFO2/FHik bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3689aa84eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 02:17:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N2F1EC120145;
        Sat, 23 Jan 2021 02:17:13 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2052.outbound.protection.outlook.com [104.47.36.52])
        by userp3020.oracle.com with ESMTP id 3668r1vhhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 02:17:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=El5mQhhNT23PKhNJ93ANdHgLSHq/t5Nin6ZKi6DLd6bO4HW2V1SdvhkDIfxF2ufzqacYt+O6iClsM5kvNzF5sfa5khldlRMR+yNNdBGgN/9MyYanKs+p+mL5jSo/nxgE5q9aqnCpEJ+7/UiJghUi32lS1GYUPIVRxsKekQehGwphJkyG+vhbifO+7AaknIczpnsw1uYhRIJSt5XcDJ6Pxj8jdNktMz6dlZ/7+wFhf/M/HmfvO+HsQkm7Hokn+zV6Sb89o37CK8i8wdJCeDgEpVvjKyAMeYDdwhB9ZDPRJR6heddjfP4ueAMAXi8x/mxE1UkAO8AYWr4WcE9CLUKOoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z07VeFp/83aNzneiComknmuzOQw/7tYMP2dQBy6wBsg=;
 b=NEDhiI+HOaojcExeLRUU/lMM7VhSv85JoUW+4PhWaesjMtS8/WWZISlWvocM00roVvVHRlCeschUTkAWHHrxkDK7tOEiq3rhmkfB67RP/nMi3KDe9Ykc2JtOmtoaGKcEDdRvJrOmr/PtTg7s2GViTWNt9gioPP4Jc3OLIMxBtDLR3z5F9EOllmOBzjshX9ielNsgf1VMa4AIHO/ta9Rk5kJt2hz60n7EFxVUIdZPIT0IfSl9S1oN3idvXJ83DlMFKfSUZnT9UfJbAkLo7Dx9ogDkTpuK0/npKPCspPaNxvB7Wng+vgswrBWzZRPPGcFH6V+4sY9EG/RK+rYHiehNiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z07VeFp/83aNzneiComknmuzOQw/7tYMP2dQBy6wBsg=;
 b=KmCd+XmbAxS9kO7wD+4m0a5s50jKem+f2Et+MCJtRbCF2PzlWpYpftW+SwavJqipmqetDymdxwkpxscqNMcu/L7ljGNuFbF48PwTJSAJ+3e8+IQn5WXWhenhtf1GaAKTMcwJMZuMCj7vkQZex2aQ19OH2cDEycDBQb8wJLr9q2Q=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 02:17:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 02:17:11 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCHv4 00/35] [PATCHv3 00/35] SCSI result handling cleanup,
 part 1
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17do4cs8e.fsf@ca-mkp.ca.oracle.com>
References: <20210113090500.129644-1-hare@suse.de>
Date:   Fri, 22 Jan 2021 21:17:08 -0500
In-Reply-To: <20210113090500.129644-1-hare@suse.de> (Hannes Reinecke's message
        of "Wed, 13 Jan 2021 10:04:25 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR07CA0085.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR07CA0085.namprd07.prod.outlook.com (2603:10b6:a03:12b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Sat, 23 Jan 2021 02:17:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ead5573d-a842-4948-7912-08d8bf44fdcd
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4759B6E4E21A331C257A85828EBF9@PH0PR10MB4759.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pelQMRg+kL/hgC6BFCu9HSeCO+AuZLbu56TvcBPTI+zFpykpD4Qhn4ek7kg18fK2O0px/dlMfK5WVWYewedYyfsUcrDeUgrD5BEDvHkZMOhJczb1glAaAlOYMRYr0OxE8MiSBsT0/VE5FpE+fJ2mP+bXlXxZy0aloHitCeDmBP8HAJ3/uXY1+OW33RY8Kzoli5Ya+E02wKwDvQfTY1i179snbw/o1kruj37Rcx6+UHhG6Y3s4vt/Jr/KYxkL/h53m2LY2hf2Vd8rQg6Zi3L7y0NQdlWRP6u7xSP0UUPe1P+1sc67cqYlD5pzVlJOOJ8ql6u3t4z3YAdJOOc0SVYv7pYvNyuJ/cUPg39qu0b2cJWyjSXnfrz8oTWq+6r38kE2GMkYkjcWs3niaau5joNmkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39860400002)(396003)(366004)(66556008)(478600001)(4326008)(956004)(52116002)(8676002)(186003)(26005)(16526019)(55016002)(36916002)(66476007)(7696005)(5660300002)(2906002)(54906003)(6916009)(86362001)(4744005)(8936002)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gGHvkgvqMWiU64eM7ldHoCq6WnA4yf6YZPwLHJ8w16Fpo3VYAkZlKujm5QOR?=
 =?us-ascii?Q?IGw5Z0Txft2AMGZW8vxw2AXeUhwOqz6Sm8u4JuD21Do8oHgoNhgiYt4A3tfs?=
 =?us-ascii?Q?GSJq6MdqQHnSxTqJtgN/mZnew5t6QHMgeGx5C48bboGlNkR1BE1jEHAAB44L?=
 =?us-ascii?Q?EOS6OrVQaHGEVBbARjb6pOvLL0gMRy4kUYkBwlsXWVLXTd4Hf4jM/XGWuR3g?=
 =?us-ascii?Q?U4d4Ek2j2Pz68IVBlxK8iij4nx+Mltau/wB4G49ZBncuha0cPCKQd+nvPyX6?=
 =?us-ascii?Q?ry0TgfK4eNidLRekF4W1KI6Ym+rZi3xctBPyHOvRQK1euH1IEEoRWewc8b8i?=
 =?us-ascii?Q?rzjGRXaBv4ZXYdRI8WdZwTtUvMfVF6ZFrtz/dQgPYQpCsdjTaNf9oOAzDqqh?=
 =?us-ascii?Q?bXUhHjBc28D3e+SQ3FFIaqctpZph1bZXSwhMbKHtXtOGn4DvbeJ58b+cmThg?=
 =?us-ascii?Q?NVHXWN43lUj77YkOMVD/KWKoZAldQhc78kSXk/lqTCey58/mzjvSyUWby3Yp?=
 =?us-ascii?Q?c3OzsMfGkLpgEu6pI36QwUldw2NXsYRORGlXhe7nlBKUX4ajtO8hFAkKoSRR?=
 =?us-ascii?Q?4fA3orUbKdLiRsrK2L0ykRJTaIJoNrCGtAaEE62cUCaWVqGDEjydw/YBqeDf?=
 =?us-ascii?Q?XSjTVziCG2o7vyWP2Oila1ujeP1CIrhW7vVm6DkkALbLUx6kUz8xSHGSGnvQ?=
 =?us-ascii?Q?85NFxGCMhZDsYIztlwh3O6MIWQ0qmi+VYcOXtgUe55btvook3Z86Tu/xGGDZ?=
 =?us-ascii?Q?8zu6qAHBhWR/OWOIoOzvmrENdylz3DgVQnh188is4jPCdiUsmD2JYksVsRLs?=
 =?us-ascii?Q?D0Ndozbz1lgSD4VGZCk5r+siVo1nYvBnZ1r79llTnkssjyfA9J5MN9a7NY4a?=
 =?us-ascii?Q?IjLZHnwdQO8SeSHhCRbsp49GP/jbirre4hzsgRbOPJF7GebbdvJFH2Qo/1Lf?=
 =?us-ascii?Q?eXs8cce0KYHJRXPv/K9hDpQ82gekdos+Z8KrLVeI1jLRwvOZn8tWMZeF8Aql?=
 =?us-ascii?Q?RqHiE0FLrexJVgK372IpdQn3XmyUUvXorxrsqPMh/LAoqARUrvKckI7867UG?=
 =?us-ascii?Q?sAUZn+p5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ead5573d-a842-4948-7912-08d8bf44fdcd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 02:17:11.0753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /6tJwOAPL/Qki27OzNsQ/Vn0G7LnIUcc1+H4gUt0pfN8s0uEZmaseom9qrnkyvr26HUL8Hgx098STNTDbKReaTo0VqOPhcxMny9xyS1eoCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4759
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=939 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230011
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230011
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> this is the first part of an attempt to clean up SCSI result handling.
> The patchset primarily cleans up various drivers by fixing up
> whitespaces or move to standard definitions.  It also fixes some minor
> issues in some drivers which set the wrong result values.  And, of
> course, another attempt to kill the gdth driver

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
