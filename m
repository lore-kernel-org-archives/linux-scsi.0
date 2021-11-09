Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614C8C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 04:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 421136113D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 04:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239925AbhKIEQc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 23:16:32 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23864 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239883AbhKIEQL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 23:16:11 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A93lafH005907;
        Tue, 9 Nov 2021 04:13:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mpsCT4ohjEjJcQdvUwR3yXVeuantobt+25dpL/3wtJc=;
 b=thIUpH+5MkMmxPK9m45EDD5CR/kzFy8m6a+UEoKgWaY20b+RSCAz9dO9xsYwiR/jcm9/
 kYRsI49BZ4CdBP6Gqf5g7KMvoCpXn+lw3g0JTPCL5yVQkjP+lOJNvjOFEbB6RLyZMxez
 kVUwSnuZtgRKX65lR9v7muPRtGoMlLzN3QpSki+5MYjCMSTBirqV8k4aj8Lr+R2YKeLQ
 wuwgDUdXMFGOw+gBZYEkqZ8yd/IBsB2Vj8hVhGIFkEzqRbtRzgVGac14vz708fr0xWUh
 ICwjGZJhhAlBPQNd132nOS3mDA30m7jnmYNGLNyId7M7VUQRK1IsdRE281GfMlCXiteK 4g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6vkr0uuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 04:13:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A94AcF9122403;
        Tue, 9 Nov 2021 04:13:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3020.oracle.com with ESMTP id 3c63fsb6b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 04:13:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Co6w4FENrlPTFEk8zljGJqJ/bZVH779SVRuU0Cr6UEqd4zNi6YkQcvg/cWQhK970Ot8FqHMwZqU7uuDNnCy4AyCVajL9gVKagX/RAhg+ABs0+dEoCzWwv337o8/yWFn2//LDuJCWA+2T6xQGHvbEJoAV8i5TxS2dUltnL4z17W1bKbEwjacRAdNUm74sLTyzzKnYemWetCb7Ff9o9tmghodeyjhi61OQbnWooVM8UVhX/KBm1HBjMsuH5TUoym51Ryx5Ok2BXKJBzulHDF8O3ZdlqVkraGpsSPnwOKl0hfnipluoQvdLHOCLvfS2IpPuBO/9yEZF9NrQZIJPm6/7hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpsCT4ohjEjJcQdvUwR3yXVeuantobt+25dpL/3wtJc=;
 b=ahGf4rOoA4AL8P2V/CX9byUckrzTnveHG6UBwqeBVa1iax2F7Ki+5VB7VyZwZEIfuixBiH42KIphYCjsrQCY7bMhfupEoM/H/BYKsFtvHwkvN3K8t/k+yRDddNxSIuD+VCB871PmHFlsTx2ysQX36f+h0KA6m4XBY+jgPB9hE20q1VjsDDKKDXjPanVndmJAMNkguaYMBDYle1kK4kjM/G9t/9ooIzlrmFAsgM5SSYo+QXzeOGvHGOvC2GEEtyeMuI80bg6S4j0SAocL76YIyWEBEVt+6GWtvUUZWtDTm4Ez5t0yKBdmz+4BkRQNKF/y5d9QSliU2Ra7FUxcClo7PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpsCT4ohjEjJcQdvUwR3yXVeuantobt+25dpL/3wtJc=;
 b=S5qJ7DvK5rPp7i7fDg7PvN4FTWBCKVE7djUUEmCuFcvTz/LvahWj3tylQU9nBRJYkFD30thFjNWKn0gOatxArnXZ2i8+7Ukujfq6DvTPq2Fe/K3EHXuisMJC4oGr8l7kOAVWvpz+Y/zPrQmZrGpjyPAFr7/O66tVKtqOJGMGcQA=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5813.namprd10.prod.outlook.com (2603:10b6:510:132::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 04:13:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 04:13:09 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 0/2] scsi: ufs: core: Fix task management completion
 timeout race
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y25yj7at.fsf@ca-mkp.ca.oracle.com>
References: <20211108064815.569494-1-adrian.hunter@intel.com>
Date:   Mon, 08 Nov 2021 23:13:07 -0500
In-Reply-To: <20211108064815.569494-1-adrian.hunter@intel.com> (Adrian
        Hunter's message of "Mon, 8 Nov 2021 08:48:13 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR2101CA0009.namprd21.prod.outlook.com
 (2603:10b6:805:106::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.57) by SN6PR2101CA0009.namprd21.prod.outlook.com (2603:10b6:805:106::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.3 via Frontend Transport; Tue, 9 Nov 2021 04:13:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd9b90c4-d930-49de-36c1-08d9a3373d5f
X-MS-TrafficTypeDiagnostic: PH7PR10MB5813:
X-Microsoft-Antispam-PRVS: <PH7PR10MB5813442B89F991D88B97106A8E929@PH7PR10MB5813.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vAxdRqrwnxmGQ8Z0a97/0TTBTVxLnCmEMbM266h6Ja14faD26LCggIEKdSgmc/zw6WTiaIon5yhAYMGBH/EkXUoyzLtJhupKLB4/NWLYB63cn0v2w7J1tVhX7XPS7bVS9A+Bq8nQD69hsQ1LLbkLztLOOsx5MjcBUlfwYWCPBT7O7nGPn1j6meb/gVyhS72OeqtF+jfpv8mmedr8tNxisNW4VDbo/cnzZ1XoFak5Dkpxi7A3vNqxPuzVnXbykd49ski9vAYDvU3qmLVtJ2UklcaeO3qax4n5gj/Jgt4Thx4qn9vn73jC7Rwb8cwnKouUhg6/kFKNTZSX4mmTg4zObg9qstNdWzNA+6hG0wLg9xYcmEzaaKqsTC3qFOj411HWhNkwOWNxTKNCM+8Nl8vEPrrSttBAj42svBcYHyXiBR/tzfTMo/T2E8lgL3ydk542O7V0wp5dsVABe/Je0O2w60uHRMBfK5eNfUFfYRbDf/H7XeADdgXRP3Rdux/m1724lAxRfjID8H7tuWh6bMT/T3XXHZkEFCksAI54hd4LY8l93QiTV/uPC3FKr9sPqvLbItWAxnXxoml3xDo0D6BSUaWsWmHPxBGr2HdtR6Ag7Q/AzrlXxTAFl+yilyqMgUrY/VpdKg78VDE8+pOuWu8tHJ+ix+vDZTSLy0tSwjA/AVBFQQ7STVRiAuzutRIH9gW5CUCCv5VBZ4ORgKjWiBpi1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(66946007)(8936002)(38350700002)(316002)(6916009)(956004)(38100700002)(26005)(52116002)(508600001)(86362001)(558084003)(66556008)(66476007)(36916002)(8676002)(2906002)(55016002)(5660300002)(7696005)(54906003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VK4ieEUotLp0q3eRu6Mz0O/5htpf2WpsJc5aksl4PuNYhJOsilagEbi1wmJ+?=
 =?us-ascii?Q?E6Apnz/PWmlMAXcBxLuc/v5OOLEZttQAdIl0Waa/UHPQOWB+mX598nZ7juHE?=
 =?us-ascii?Q?y1wnAZ2CxNwmaQrqtQwL/K3XyQi7q0qutC/M+mnv4VB40qJrBWZpwmA6mX3G?=
 =?us-ascii?Q?3xoi+Snppv0crNYVX8qhW9ILxxu2v92ReI0VXVbfFe0lWcY6iYApRiR2WY0Y?=
 =?us-ascii?Q?V9oiHcisyJjw6KKbO25SsdnBEpFOkHZMqy1xxjomzImE4qLSIP9NE00bEazV?=
 =?us-ascii?Q?KRXGS+Am6FW6BAYN6SrRMd05/ytR3KVytMduWAFeF6H406oXpmGL6UT8JezA?=
 =?us-ascii?Q?j7vb4xzAV5/QQbD+JT/niBiCCO4P7xKGtp4g+6xEuwyGki3HnqlTBojRJUJK?=
 =?us-ascii?Q?VuzSyGwGS4bRGvQhg/rY8HcDd7FQbX+uaKMPtOw9k0B2zzFeJ9ktJJMGsjzB?=
 =?us-ascii?Q?HVuzt4kn5yOBVEGyLxTlrxvvnX6BRxs2zcnxqcGg1Htn0rMFo9rYltHnOsAx?=
 =?us-ascii?Q?EX1lQt+xi1wCH3ruqJceCCJ+V1KcAaZAoKZXTK96w/0hoTVmIeGOL/XEQht2?=
 =?us-ascii?Q?1TtbKmC19bH6BpgznzjExX+g5nMdjljqYWPyqZsjuAlHjtFVhU2L1aj3cPhZ?=
 =?us-ascii?Q?Y4/XbVbgjEIRKDwijBrUGfJGUIzqSGHaLtL/flhaW1Ro5N5CUgzAjZQ+IU6u?=
 =?us-ascii?Q?MB/K2vaH2+jkMLrX024ZqXAtFChaCFqTWugLKUxMjhJS3p3xv90lGNwucO4q?=
 =?us-ascii?Q?19Yt+vrQOlEqXpQ9QltcBB9t8sMFusaPMs5GETkSpQmzZvvd9qQ+gwsQvLRN?=
 =?us-ascii?Q?+2QCmabawIzeNFpYoKr5AUahUihdoMxKG+UYJVRtK8ezq9wOAIbswHFnvD1p?=
 =?us-ascii?Q?fDjwG7FFaqulrQWWFS+QapNlVQzfUxaQXDlvk0vluQzryd3H5LRWx725Z5t2?=
 =?us-ascii?Q?HEdenoFbF63O+8zeAo1crIl7mgvMgVHJu0s/T7iq/X9v3jyTeehWnvhTjMN4?=
 =?us-ascii?Q?a91IxqfGIo7c+F6sLEp4pmnjD6LxoWUKqB5fxo8ixQH5YqJ7MXbuhlO3E6x7?=
 =?us-ascii?Q?jogo69n2X2n7rytRujPRXxVYGNai0EvoNScstjNRjzAN1W+DxQpBOly2sU4d?=
 =?us-ascii?Q?NyF8Qr6Fisw6e+st1J1YhE9ikpSmYOYqicp96Tb0XVSthiFeC/QRKTleQOyt?=
 =?us-ascii?Q?z3ljwt/srO7o/mZcbbc0LL9uIOzFuXfIuKyGcnyHhjZ/4DYPdgxOzSss9z0U?=
 =?us-ascii?Q?gDTf41JI3oSN7hZyN8MNSfwl/KjI0DLpa0Vk8enBxX/18tdfKmodjU08IhMz?=
 =?us-ascii?Q?NxvCPsk0ahV8CGQB8yI3FYv1t8uHRvDnRec413KgYephwoJrZgDmij90vdWk?=
 =?us-ascii?Q?OeEEIZiVl2gG7ngvX74uWC5PjSr05gHPehh699ZoNoWu9QT8z1QGbioSc38t?=
 =?us-ascii?Q?rAUDC5La/pxcbDZRgKWr9jqZVFcQotke8fMDenA2blt6kgwsXpol/Q50b3Z+?=
 =?us-ascii?Q?HIXQhpGwTAZWzmUFG4FUJuPwOycTOV97CzDyL7C/7qxPOVN/0a+Xo6+fbT/H?=
 =?us-ascii?Q?CR/SQ7ABb27ai0cJsCrAS6Yn9sZMKBs3j+3mZ4UI1u8UFhs6HTtW6fHHRfKW?=
 =?us-ascii?Q?+tvQRBqKCjpG0BAOZ2ppE8/7rhGSU0CQ/tV6Fjf8DCYAIJ42Y7ILUXkHz/4Y?=
 =?us-ascii?Q?yTJ/3g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9b90c4-d930-49de-36c1-08d9a3373d5f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 04:13:09.8611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RvW4yfpbv6M8jbQxGbqpRjnkapdzN8t5r2GNKkIQXKiUbv9FOSYyV5fHnMJJJDbTgQNnzzShTz2Ao5kHTeBAHzBnBNSbLaBhLSXZURG4fEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5813
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090021
X-Proofpoint-GUID: g0PzcBu6Yka1aweuxv7jh_qzpv14Ay_Y
X-Proofpoint-ORIG-GUID: g0PzcBu6Yka1aweuxv7jh_qzpv14Ay_Y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> I though I sent this back on 15 October, but apparently I didn't, so
> here it is now.
>
> Please consider this for fixes.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
