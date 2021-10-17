Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9772C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95B9861027
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244901AbhJQCtw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 22:49:52 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43990 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244888AbhJQCtv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 22:49:51 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19GNgwdx014083;
        Sun, 17 Oct 2021 02:47:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=o/ogPQdw/xe+M5neYa1K7+H4mHVi92DNemhVNkzP+iw=;
 b=aMmM7c0R2RHvM7aQpZKU7iTWS37kc6dchgrSHlLGPzC+w5Y3+EDf2Jkj77P/uX+hn/CG
 I8gW5Lau00eEL/MrwI1pT4WPJhktmuUEx06JvCyT2u9sfhgwZ1QfY4ro1BhCGF7WVQGX
 SRVFAdsx7YB5KZGeuXEr48peBFmorxmHmNGNr+3H+jB2lwY/8WqLTnAhT61e0yX31Q93
 dihmvj3io8+1sWN+SgGnB94lIJ7fCkZarzICZpGRooU+amuzASU/pLABrDEcTD6txyFy
 vUHxxeQNHVNvwMpHojDvDj9tIbmLm6Xhn7N8kNIIvjgErf1rnIx44KjoCLvIzlF+t8Ll Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqmasrg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:47:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H2jMLL060004;
        Sun, 17 Oct 2021 02:47:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3030.oracle.com with ESMTP id 3bqkutry2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:47:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYroTG7QAG49QBb/mk3aWGVWzNHpnHNxxyNnl+bE3FWPZt/hLoKbIcuomI2EBQzAcxwC719VQ5QhnBDtBLsP/byRHpDvDGkR77UKLngIj4lQ8EPohEI2c/qpIqUdZFFzaCLD5ZUudrLPDHQcvPcn2WY3Fq1oAb/IDcI2FjPssVZmUkyOWv/IKI03tHeTHkI35MggC83v24Hi/0FWUK7acsNfsev5vaP89OtacKVQDyR3OZ7qh7CXk/OPZItnXfBGOGrVTE1GfuqN+Dzkbg4y0sELLSAYiDNlvrYIAV3/7BB9YIDciZKOGncDeqLhK8ELja3ky/v5Q28L/3QHsgB7og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o/ogPQdw/xe+M5neYa1K7+H4mHVi92DNemhVNkzP+iw=;
 b=kl6g3DMBaDuVDYo+PR2KDex7lef2GkmRBT4Wo4el+zPVA+cZucisIigijvbDloJqyBcR28gx2C1Zzn4zast3ux4Ch8Zkl57oeoDL5CtLAyYnNta56RgH9DmRe2lbtRkHSSMtOkJg6dKE1nVNsJLTif2GXGs41P6rbsWknRlzN+x+LL2qQ7jnaCZ7m2oqGi/LVRM+jwpgE968Sd+6zbqUgtn3K8EpaYcynbnBrU2X0g/xvTsLPfkIBDw2NJMly895Ly7/fWmyehzuh+XG3Azjt53PvBFVNmYzTB9K9Tje5hP47lc5g8aZErsv9c7tORRu9PNEKuHA//SLndLaHGKtng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/ogPQdw/xe+M5neYa1K7+H4mHVi92DNemhVNkzP+iw=;
 b=ozB7VPi5hXcAykL1S9vtNtrRhhRSXhk56ml9FcJbyeswmutM+A+cq35jTXQwLYBhpXQKKXB2zBUhX6FbS3ik7ZjN3PmPMTN6m4diwM4pmWnRJNLG2nzRFwtpQ7ejUsGnEgp/1zOXY/71gAC+gFx65gtPUjVA9s8yrQQK4ZodM/w=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5530.namprd10.prod.outlook.com (2603:10b6:510:10c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sun, 17 Oct
 2021 02:47:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 02:47:38 +0000
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: tcmu: allocate zeroed pages for data area
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7dgfjuo.fsf@ca-mkp.ca.oracle.com>
References: <20211013171606.25197-1-bostroesser@gmail.com>
Date:   Sat, 16 Oct 2021 22:47:36 -0400
In-Reply-To: <20211013171606.25197-1-bostroesser@gmail.com> (Bodo Stroesser's
        message of "Wed, 13 Oct 2021 19:16:06 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:806:20::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by SA9PR03CA0017.namprd03.prod.outlook.com (2603:10b6:806:20::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Sun, 17 Oct 2021 02:47:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95b25ea1-3cb0-4c18-5533-08d991187b28
X-MS-TrafficTypeDiagnostic: PH0PR10MB5530:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5530157539D004D6C61D93378EBB9@PH0PR10MB5530.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oZaL/e06IPTSGwVbCEz66sLOon43DLI9bmdvY+y653KoV0Ctw/ldPjNPb9NLxLC5FLqj7aVyyjtpa4zg5+vmo9h85oINhNb7Z7BHbzCEu7c/+HbgJdVwsV3W43iHdYm1Fz/7bOLldluLUDPJ8+R773qa+XmN97sF5evQJpqHVDn7gtQv8vlOQbGOmtJUITYJne7Fp4Yv630fwdWJ6upciAMYnQU148hpULbKTQMd/6QQM2+hYTOzp7al0cXHMX/TFxQBZw81n4LBOgh3jt5YlrGqy6E07pQj5HDF9XtFMJ+gtLbsex0VpOjWW5NNXn0zxhs8Iu926I3uWIwguASu5LmXJ9X5mEGSc0ZtyPlfgu9hPiYrayYU/fdxPqVl1RnGTsIMcrjgbs4NTMRXedSFnt6UlJMQwhqTxGWb7r32voVbNK3HuQran9TPKqnf+lhXEELBQt6fD69CV9BOqUZHL/p8+v42X+3r335kc7m5ESxJcRU5uzMkzI7LBWKVt9lm4GsVS7OpdwsbgeM5NS48F9yRMVrkU5X+jLJyNOdmuWsylnSnWaURQl2TvmbfA39lMfI2NYIASdfzI3PQqZLLOwcqEWTXzy6P+QHmV1PmvItFgyN09b9AA3aAH5t82VD0J3yOnSiXICoBgAfHyF+Zgk/bSN8/XPjm9W9jDcOV+2BmQfBci847l2mfKQOrG6Kpv8tBEv4MYKFNpi3TaxJEaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(4326008)(2906002)(8936002)(186003)(54906003)(55016002)(508600001)(8676002)(38100700002)(66946007)(4744005)(26005)(7696005)(956004)(38350700002)(36916002)(6916009)(66556008)(66476007)(5660300002)(316002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/3rkRPKri/6r8XIoBgiyejMV8a0QXl96Pd/rzPi+mwJv/ETcWBn2nHSRHown?=
 =?us-ascii?Q?5z8N21KVzRpvLs+KShHallJ6giqdYNCFnDRB1aK6lhCjequxhuZ6zBbnUBWl?=
 =?us-ascii?Q?GGDF44y0MWubkC4XW7Hu/EHlln7roNMlobUmEP/ALHxuNv45HV/YuoeGoAnU?=
 =?us-ascii?Q?xUEIj/drjd1V9VV4PU78EXa7ad0aCxoGKFaTJNzpp8txTXH0mitKrI6lMayS?=
 =?us-ascii?Q?bFMp6LBhZCDDpKzy6Cm6iURUm7kZSgFTZt09lgsiqgPfADoM0FhhIYb5WVo6?=
 =?us-ascii?Q?8mvOW1zgomHX5sUyseYugN0rkXCaHc/XAz+NLg4PA9MO/QMO83t5x/gUh6rL?=
 =?us-ascii?Q?/WyFNTD9LNolHMKO0cuREaTvjVCCxglAqrGIOEUiekA//k7e7zgQRA6xIpJZ?=
 =?us-ascii?Q?2E9NfI1jUurXtnMo4W6Mb4+y2z1rZ0SpC0/WUYgUVik40zqMiBKjrS7mD1Hd?=
 =?us-ascii?Q?HsZzpciycx8/LibfxEeWPbPAtSBrxgzZsSpPfQn9ES3DTJePowHqta0KxALJ?=
 =?us-ascii?Q?v68VQlfjRhWZ3Hksf6w3jvSz79tx5dkSBQM2SV4e6jJJhNGcG6Fo6TQdfkLq?=
 =?us-ascii?Q?bEG6bso1m8LQqDXcUVSsTMZF0u1/by1WM4bxCGmCkeaRNsjesmNq42iYUn8S?=
 =?us-ascii?Q?t3X0Afdh1KYCQVnRwUQzonnB/qP9CXwBLw7KsQxAxAAw4ihuN+s5X8O4PJID?=
 =?us-ascii?Q?8cU0clOGGwweWtmy26P2Gd5Bi6ezwWWObjW0PvfPYhNkI1lGJJS7efoc6VNx?=
 =?us-ascii?Q?uz4ua+lDBAUHyD+R3pfM5hsFnJhC5Hq08snTw4Z/FwDWX7rBh0pwNmLL/Njf?=
 =?us-ascii?Q?/5lfhXpFApawkY+0uXT5gJANU7UcwrsW+jzYZMkTnJ6GUqhuofDQJPT4ZKOW?=
 =?us-ascii?Q?PgeMZqmDzqavHD4PeUCb54rTWpsAKbY9HnWuGuEbntCXVV+bO0Rjjlc552vZ?=
 =?us-ascii?Q?WEDTMYwOqa+LwKpU2IsmXbd39lZ0fwdUdfIB1MRWQQOPP3zDI4ZsBQGWxYSP?=
 =?us-ascii?Q?TFS1kgMeh4codHFoYVK0E3jotvahDKX6FbWayghZivi3r3atbDxkogvd6G/0?=
 =?us-ascii?Q?vcy2KqrM9udhglkG7kNh/3CtHSZ6zqi5dvOla2Xbfgjyd/9IkrDL54l7xoln?=
 =?us-ascii?Q?P7GGapuf8uo8PPqfwom9AgN56L4u6FR9YvHiweI1MuWTR4lMjKcZlHIq+g1U?=
 =?us-ascii?Q?MQYCAo/II+Ip/BN1uaC9UfmCs7RWUAwGF/LUwN2gYq4Bw4AcwXp281Z3a2Ew?=
 =?us-ascii?Q?AMSCj1yDe+35203gJgKHP7kNBTl8YDQgXcY494YMxuJyv3L/RP5zOyiNCDiT?=
 =?us-ascii?Q?KYgYymlbxtBpq0PVp3JaRBqq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b25ea1-3cb0-4c18-5533-08d991187b28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:47:38.2144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1YJfPLUeXq0OXuJgQI6/5tv4+Mlp7N/e7v0Nc+Siz2ITyUmgYC/NaELv5kgAdTRJXw/aP5ApasDcXn64dsZ7x6ZHaZy7pKP8V6CLL1E6fZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5530
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=846 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110170018
X-Proofpoint-ORIG-GUID: xVbTlxRUmFnv5NmJsilTIGdCP1D-8j5O
X-Proofpoint-GUID: xVbTlxRUmFnv5NmJsilTIGdCP1D-8j5O
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bodo,

> Tcmu populates the data area (used for communication with userspace)
> with pages that are allocated by calling alloc_page(GFP_NOIO).
> Therefore previous content of the allocated pages is exposed to user
> space. Avoid this by adding __GFP_ZERO flag.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
