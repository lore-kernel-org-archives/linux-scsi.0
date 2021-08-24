Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA99FC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A22B4600D3
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbhHXDIc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:08:32 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53186 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235517AbhHXDG2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:06:28 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0xtpZ031037;
        Tue, 24 Aug 2021 03:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=e+TI3L8gkxlNjPCHXsgC8zxt/NLAToctSf40EeZexSE=;
 b=uax6fUb5NMLmQimmKhGcZPMQs6/V0O7LVdA6nDXoF519WjFtjesQnPNr5Mz/sESU46s3
 zbeKHsg5Eta/7WAZtHO666TrlD95Lu0dzUudl/yAF1tdp7qZ6VMm/3Gp8AVBzwfUJmqr
 kIZP6TAibWQsxk4e+gZBCxGA5WDgc8cUO4MqXO+th9R73W3mFZ+SSZwokwUMvFjdOpUX
 qFmjwO5d+3BoOt5bykKW1Ec9r6W3s316rGKGiOG+xyfOK+aBAx5DFy1WKeJnAsWk7xkM
 X4wqSc8Bv4kw1UiSWwqYNUWJoJ2MHKbGdkGXzR7TkvsczowXHMi4fmNFmTkNUAluYxLo ig== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=e+TI3L8gkxlNjPCHXsgC8zxt/NLAToctSf40EeZexSE=;
 b=iLAwwAhJKdaVaRu1mw1OywiMH1KRJhB+BsP+WdCq18bX26SFq7KTwdsmfU53euhyyfmy
 BosCEigP734tavEitjOETu7drCRw09k0sEpaPzZbZaRmtJiDUq8wdhBV1YCndp9f3vc4
 526jEdJuxeUaqAdzhoU5lYzo+S2Ht3zhlBzXWxNqfWPtqonLqV/6Y07MRg6VN4Szmn6f
 Vo5MMY82GEA3RzJOK78LHV/E9Tzq3D8+pQBS/YTxYLblj171cyHyhSNd46AKIpdsKEqb
 sfDG477pz24D84QfxrBMpV0AwtFRogC2XpfgBwqqolhyWFoqBX5Zt6b0Gc33d47m8QLF AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aktrtu93h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:05:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O35IaF012482;
        Tue, 24 Aug 2021 03:05:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177] (may be forged))
        by aserp3030.oracle.com with ESMTP id 3ajqhdspyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:05:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQBpqjaUEFJHZweJEk0PBsjE9DNyvpuc1MJARQt9MWjJShaFXEAj/tUpJDxbJKZjJeZ0r+t7GhIkulLvIdIrXP7DrHLqHzmjsssNQUkJFh6AnPBhG3H9TbbGnaUv4w8z9BvrjumVB6USsuhOXy7sv5Gy8mM2Q3XJ3z+elhfng6EIBluZ84R9fyTiXfl6nt3H/b4hg1gmFtcp5Lw2GbY4mfhg3EPYc6YlQGjlS8/MtuusAXeqsXAgnUPzSnegUim7Lhj2VpwQErPKtj8ERO0WmTOZiKFZ1iFtPje2t+0gjxwLmK/WzwdU80fYQiTtUhHra5fkm8KIqw9LVhhYh/uiaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+TI3L8gkxlNjPCHXsgC8zxt/NLAToctSf40EeZexSE=;
 b=F7YWxp6RuOmIwuyoMvdrQ8Ez4508wOXoI3fS7KBE/BVjkphcS4FFUSLlM5kKHjbY0NC1RXvdl9/A8A8X1hMhnp2KGQvJbsDydlTgVHM9m1TteQUI4yV9fc8wt1EeBI7ltxhTHtau/NCbp/x8etX4aLz5T9GnnL8MAZH0h3rQp6/reMLH4y7IWHEuMbr6VMP5T0ZDsotzwJgCV47/XDjv/thciskmsLOnHStL+8GbeiTAdL2AFIOedQEVvbZ+5AsaCOHBoRl9taMq1dCoYh4BHO+GQ4niiBNjwRvsHqd/zumRYuSU1h1ruSHDxDlTgFl8qbd+4ik6IbfaXsrIFm07Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+TI3L8gkxlNjPCHXsgC8zxt/NLAToctSf40EeZexSE=;
 b=WREkKTAlIIfMNTImD47g3+aJtzkmC6WdxqeqXRaba0+APns0+ml+P6sDPlQZiODUplSGAJdy2hW4/S/pHFAE2kl6f6Hx//4nGnZZ97ioG0VrF+IocLgVfn0xuKfmFV3IQzuT+fQo4H6wn6WrBHRmiLS1RydK+jPwHzYtaLGS3NI=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Tue, 24 Aug
 2021 03:05:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 03:05:41 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 00/12] qla2xxx driver bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v93vfsp4.fsf@ca-mkp.ca.oracle.com>
References: <20210817051315.2477-1-njavali@marvell.com>
Date:   Mon, 23 Aug 2021 23:05:37 -0400
In-Reply-To: <20210817051315.2477-1-njavali@marvell.com> (Nilesh Javali's
        message of "Mon, 16 Aug 2021 22:13:03 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0701CA0003.namprd07.prod.outlook.com
 (2603:10b6:803:28::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0701CA0003.namprd07.prod.outlook.com (2603:10b6:803:28::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 03:05:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a629cd2-7a87-4882-34dc-08d966ac0e3a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46642412ACEBDB3164A234EE8EC59@PH0PR10MB4664.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GLYjmCEGufdeVblWOx+5DpqAYZpa6gGzXAEdRQ35Q8FvvD9MKbOyT+3R7g4wV3nQ5cRb6Io4/OeV0COEXpDuFsudt6qRoUCQ26IGB4s0ZeEgZxGkQNdvdGh/0924kJBRI4SkhxkcJmxXOtin6TPrKHS3nPAzQpyG/jbRSH6+KxkNl7JoJsSLjPVjfyKe0/ijTzil9X2ZUGrIeX62d7oLAZ0C9qPhPrbj9Omi1QM8ZRQvv6h7TNE3olO0tiiV5DkYszBDXEZArRik2Sr4HuQ9S+oXLKis4c2USO9i/0NNqickuEYVMlMidaLJC8DZPqToTuFJoqrzGUlblHwhRgzcx62vCuEMeXQWjZRrGJse+rVni2RDmHZ1A4Gwhj9PGF4RhKPUAOXuhSmTOn2upfs8hLqICoDRex+IJOIhHZRc/oZhx6X59l8qu0oOFKrfo1pfRSJDTN/CGR+FKdAxnFYdQ4CTUkBvKgpWgh3rOTdNKHFAkg31WbCZa+AN7T5NHY1hcoCGYOlKAF3OS8meNAmEVqebN4z+vhipcmwfGquGsKQ9zBT0F8v+EwlbU8qbatsBsMICoW0VlEfpi04duNV/akpsbLUNAlutj9GRUH2wVT/KI0tLJhSYWcRVt7MVHXSJpTp6vn+Yk+oBga/AHE2I4YoWuOp2lPVkSe9jcH8F3KxKqqz+yMk/zyZpqALd6FgpYC6a1KHAvADKtlowHr5WdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(8676002)(26005)(7696005)(52116002)(956004)(36916002)(86362001)(66946007)(558084003)(4326008)(6666004)(5660300002)(508600001)(316002)(2906002)(186003)(66476007)(8936002)(66556008)(55016002)(54906003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KZPVVr3Dd5VkXH29J8rMc+DjkI3v8eqAEOHZojjrUGHlvfaCU5FhKALJf8Rf?=
 =?us-ascii?Q?T5+IVs+ywtbhw/owrd0Jdyc7cbeEHo5WA+E6EqDpqGX9gNVJa2oKHu/hnZ+a?=
 =?us-ascii?Q?OaTm8m7TmNbXlKuK0GD+FwHhT0jwkFk3EZTip8s6/b3v5aZyWpm2qlaroQyZ?=
 =?us-ascii?Q?CALKmsECMfC+ScS5oIjK6xfjkw9EQEKrSDH0aHyEtkrugOsh3QydceVFEMln?=
 =?us-ascii?Q?GLdelUQtuHuEWAu/R9ej0ek/vccRwg5uyq43wHFNCvz/rlypqXB7NkSrEkmQ?=
 =?us-ascii?Q?3Q9UhJWP3w89tABuUXH5Qz0ycgbJW5vyUT99ErXO+hDPs/G+pmFkryRtsdU8?=
 =?us-ascii?Q?iTUxHq0GPjIDc5Akt5hm8Z5m1pMk/pFd5c8WAgs0UfHo4VHJIjm+Dc9fhVCE?=
 =?us-ascii?Q?7qdFinjbnVGCb54EMv3FkxRnyv7c9sRVHopiz59bOh2bty2b15HtecoHQmqL?=
 =?us-ascii?Q?3pSpwxEVnBXLfmw6dqx3AzHJ6X9nNXguwWxzxP9yyhOTqW7oHGWqjQNQv54D?=
 =?us-ascii?Q?vfOUcklOS46RuuR0Jp0MdZxWgiqULYp50/354zofamITzxwGDfLruh0x1UoE?=
 =?us-ascii?Q?kMtlBIwYW6lC9dZLol2BCZrmkCBsDFMc/P8n1pTFggYZirU74ruhR4LoiuvT?=
 =?us-ascii?Q?jkvuPgIIveY+Wwak5l6yC7FGNEf22otOrXzO9YoOaRv0xOC6y0eXPeb+wldO?=
 =?us-ascii?Q?ONNVEwRLxj/5wjJqNQJEqRYkR8oEQYPmvPsgHG1nyrJtMtu5MsD2YDVZgF+d?=
 =?us-ascii?Q?YLU75fzmszA4mMaZbi/fGrKpuFcGPSiQYSbKysc83GYpzB2vutZuRJGEWKPn?=
 =?us-ascii?Q?meDOT8smnxn+bIArh1DXLnXc65iSL/ZKvEkoipccIOqfCZg1X2CqfmqZvCoU?=
 =?us-ascii?Q?3+l4oJSWeZUlo59Dx2WesL7DFRJRwR+D0rx4gzEogbBleyQifq/5HuNL0aif?=
 =?us-ascii?Q?S5vPh8X/R8irdRxrUXbHVHJBp0jvZ43IXI0NShSVY2Wcy412A2/psTT5F2CN?=
 =?us-ascii?Q?hwGeosMsHYGDvY84+wFoE8Q+9O6m6yXsd0RmYFr3OmdBX/VpUxWttqJoMsu8?=
 =?us-ascii?Q?7rbxQ8ZVIyZMUwZiQ92EO0Kp0C0knyHy9K0V/lUHUpFaJRnG7hKR8VjGyO6g?=
 =?us-ascii?Q?JvfR1gGvziv5slkWyiG0EGIyy5/O3wqR6WAZTUDkJA+7QPGamOAe2zFPQ/hZ?=
 =?us-ascii?Q?fS5Rs39A1eEmnvg5qZnBF4ExUNyBNo40loL3CviFiw548U7nZI7qx/Ycgr/T?=
 =?us-ascii?Q?BLMm1Ld1kcIFo1NaacTNAK569uMaMdltfZ+m8YltSni2Hei57jvihMvPRfkp?=
 =?us-ascii?Q?0mTh3mMyXe93QvCl7l/75Fpe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a629cd2-7a87-4882-34dc-08d966ac0e3a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 03:05:40.9506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yeyKOqzc678k7aQR1Byg6PCOb44wg/9kv4ONMsYcJmTg3+N6A26ecEmECuVStioHgBYwgnWXU1Ryh1nacEonfAncaYpO953S8Gk7f2PPpEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4664
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=971 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240018
X-Proofpoint-GUID: ISKbGy_6sZNAyuoV3yJq6RhqNxDUNRXN
X-Proofpoint-ORIG-GUID: ISKbGy_6sZNAyuoV3yJq6RhqNxDUNRXN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver bug fixes to the scsi tree at your
> earliest convenience.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
