Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8052C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 04:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiGNETr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 00:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiGNETq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 00:19:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F6A25290
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 21:19:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E3mxpE020551;
        Thu, 14 Jul 2022 04:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=aZ0ZzO4EZZ4BuT9Q+DT5urB4Ihi+YFjasZxnscjza0s=;
 b=D0vlVJu3pTshmhjMS2M5fUvHHKAyR4ghMvre4mlJxazIXg7HM2h50M8PbJybNs9fd7k8
 oXUaydG7jtGtNmvEvBEphCJvJcvkkICLTxy5EpIxmJfMW9LHRvd81Eq1+K373v3EwI8e
 TnpRGwaOf8hrquoeWVQxfjiXNps+bJlpgo/wqGJotjZ0qSiBLZr7gUZZKrpAy3BDv8rQ
 hKoM/KJpN52D5jXT7sohrXO4QfW2+RpbRCRWEsG14eFd6lCyhOOII5GDUFc7Dmrmcjoe
 NjlQ5ZZ7Li1RYW6OXQi8tfqqNZX2aqa3lfK6cejg01CJBCkElBX1Xy9eMVUcrtsAeLWE Aw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71xrkxpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:19:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E4Bo4j026927;
        Thu, 14 Jul 2022 04:19:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h7045hpdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:19:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gch356P0pX9h317ncutDWVjubEs3NrIaauUKiXwUVb+VRQXBqVrxjD84lmh/7qyttXRP5O4bScAnefTeiZO3ntoOlmQ/K/YQe9G8x+6+Gf0sr78bCXVaLy7Zz0GOSdffTm6pODBxoWoeVCp+QvZAe2HZ7VyDgpR9NEg9ktJWJur1VU67OWXRQiqqsLLT0qZvdTIlPVdeYgN9MfYNPMewAOrnMoVoeFcik+qafVac5noJPzWmqzwDmT6agzQwM8FLgPHK3I8vWdeR+n6pQPXm9utU9o/WQpHyA2L2wqSSdcOHXuI8r63HDyRdeFj5C5oAUfct3f/ZCOL0D4AZSMNCPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZ0ZzO4EZZ4BuT9Q+DT5urB4Ihi+YFjasZxnscjza0s=;
 b=iOFTEDSuWJnEhPmW9+cwNiBgDbVpj7xA3tyaTfzUF/aYd/cx3CoArHJAce5OI/R1mU6H8fSxoGujxBQdQi47d4wRWncgtXfwrAfQuznJGZGywwhhAvhYGYKgfY+S6Hpa/NDpaAIl9NvdO4mldLrH5ELv64amchj5IftX1I1Mft88cA/Wh+TW8ObzuPRbD62/1rH1886DlWS3Y8DbZNzFhpk4YtE4eXqBvzcdZANkWJtjtcB5RuCMfLZ+UDPtBjz8O5wxn5GZh+nw2WRIShMna27d5c+kqKYK1tj+vIEfmfCH5jMbMGJy7ZLMKf6qmafbd6L1XyaWhNsddUkQ5DyKnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZ0ZzO4EZZ4BuT9Q+DT5urB4Ihi+YFjasZxnscjza0s=;
 b=vGtm5aiIVbS5OrVNLG79SAxBdyAgEBmgOmTrR6A2hGLr+u5jTaHU6npoUaxfUYfSSacm8Hla3w/rDHO7X4b1fAXrOA2M2dv7f6xT4n9o5qQKY+Lh7SzKOZ4nmLmZ+vZcGT0YkGBz+ji0xOE211ZfG0hTBrciKhqqnHrQ2QvcJYo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB2425.namprd10.prod.outlook.com (2603:10b6:5:ae::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Thu, 14 Jul
 2022 04:19:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5438.014; Thu, 14 Jul 2022
 04:19:39 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 00/10] qla2xxx bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jzkwcl7.fsf@ca-mkp.ca.oracle.com>
References: <20220713052045.10683-1-njavali@marvell.com>
Date:   Thu, 14 Jul 2022 00:19:37 -0400
In-Reply-To: <20220713052045.10683-1-njavali@marvell.com> (Nilesh Javali's
        message of "Tue, 12 Jul 2022 22:20:35 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0097.namprd13.prod.outlook.com
 (2603:10b6:806:24::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 949644eb-706d-4fc5-0d81-08da655011bc
X-MS-TrafficTypeDiagnostic: DM6PR10MB2425:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lA9Diyv4lYgfWvk/2Wb3XcZBemHOgEaK3N1d5zZa2e6YA6WcNzFF9d/krDJ2zEjD8RvprxN3MAIYZCXIMtxQwoC6tL0QKbQDkAdpnDut+WuwhBgQX20xBDVPMEKoM38By1OI6hAFV+JrypUvBD9peLbBCQ/DZwQop37DSFtNPedcuA61YmwL9lb6Axfhzf6jGVC2xRJPK9jN8Py8CYTiC/PrjiMdtAlMxT3eNH3a7kYAVsHQoBq+GoggWte/OqLtSmTy8XWy3JwijmYququSN7F3nu6JJzMwErNm6XfaBQ4Tryuc5Ob7OiX+8OvPBX7d/C8whu8YeA4gqiK697q16nILd+I/GT2PYsyWRx8xz/3ePFlxf7s7NFKcXPJML6EJQ4CMwqLuf8DXMw8ExXR5pKOXEVHmnMHxSuLte4DLS92x68a6roL4AEIB1+un+SPcbrPZL6y1C3r9dgELQlkCx9jjlBVyFO1hKU+DKlDEApJSZNUbnXKG0xh8xxDWW6RRIwPR6QPS8lsBICqjc2nDxx9My0UmS4KAiL0k1gDNf9giDZf+wwbPnmOPjDcl623It3lqZBDiczeAN+VhAVVWain9IOvYrQZLc+3PLsPxKiJzfyGfa8AuvyoWflghFHTZNtzWxn0HXHQfxVDIjoZIH3Y4LydfLuWC+pdITlhBaaJwxmaskyeLTLuumECCjD98Z4jHeQuCyX40XG+mIO0MTJ50TRJwBy3SUHRMslY2W7k1KQIi/i+i4sw74n4Va157O3qRLSMCJxXlvNM1gQOLX91im19u6pkyjJEp6hS1aGsA3l5ZCZLvtl7OXGY3Fv59
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(376002)(136003)(346002)(6506007)(38100700002)(26005)(2906002)(478600001)(38350700002)(66556008)(8936002)(52116002)(5660300002)(4326008)(41300700001)(558084003)(186003)(8676002)(6486002)(54906003)(36916002)(6916009)(66946007)(6512007)(66476007)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SSFu0++v2DrHkj6frSWZEFDanis7pn/L5DDXeaXWDInZQvjZsSWFkz6cCSXY?=
 =?us-ascii?Q?78kkok5t9l+BFKBQVtRJS/ajifTVSRE344DJ49nn6tm0zFi7tX3+zg4jzoQ6?=
 =?us-ascii?Q?cjIrOP9nEWJoXdh0PMn6TgC8affVhXqnWtyBktAmydim8eo3R88cJS0T4b0q?=
 =?us-ascii?Q?YcPQrGj9LujZJw9wJ/sghY9moHg9eAo65/Hqq4gwUbcgYC3vrR9UG3lXroqL?=
 =?us-ascii?Q?Zitxrj1YqMlem8H50IZutxoTN2xpX9/fO+utkJCoS2iLGYMhuXWvH+lTcEFZ?=
 =?us-ascii?Q?DjGtM9TB8SMaAigGaQ67BNQcHfX9iKqwOhD38FgY4iP0bTAnwLVJ53rUtGIf?=
 =?us-ascii?Q?Vob2dpyH78eGNp2+mhbjyYrqYg493CPDmQfF1uV+QKtpbQQTdHJxqnmfLaRP?=
 =?us-ascii?Q?uB6DgdVSFtrYdrvZ1JOBSw9xK/yHRiDqf9mG2H7RdnonIQuxpe3FqmKn7RqK?=
 =?us-ascii?Q?t/e+mftIN2dHtfY2kuVQEdlYdq6yhoBRhGFa/FkAhBdXdQ9iOu7L68e+fY0J?=
 =?us-ascii?Q?TI80YzJWGjT8tH38GzLVwvgFYcaNUUvb8hucg2wGxQ6JG+sJNdsfXRs3cr1Z?=
 =?us-ascii?Q?duVkA5wnkgPrCoN0NwqAci1BnHh+t+TDX4mz82neRerQopsIMUSKq56QWZkb?=
 =?us-ascii?Q?BdithrnSxjkJ6pfQihvMbMLk3hKtZ4btLnQrTMgCUxPhLS0P6yg+bx06zi9u?=
 =?us-ascii?Q?SNPo6Lpjou6oryM+1D8JRNX/lEg8+V6xTqZasCToj1hTHJZtNpzoaydQhaC6?=
 =?us-ascii?Q?eunVCrwhqyIfx1zLT4L62Gyzk1cmJHB29vF0p+pHssFIGJjiMYA9id1qLtHT?=
 =?us-ascii?Q?bgIsT49szsk5fkcxzaD3jaSDC3i7Jsqr7emFxaMubbr/MfutoJJMXasM4KHU?=
 =?us-ascii?Q?c1eupxtGI/SYrAv3WnjBHud7WXu3r10YRKDR2Fy9LTyLJGv0QonCSf7Iv6+x?=
 =?us-ascii?Q?ewFR5/yCE1v2PuW9Q5A47wWKI8ttr3KH1C6wE4JOFKPAMeHfoQ0VUElaMt0l?=
 =?us-ascii?Q?iU3jbQH2TsZBbTt7F9YrbFOpmrLa1D6NQCY85+LjAMzRYWRtMKMCYJT0gMj3?=
 =?us-ascii?Q?Ky2ZsJDJhgcRA60TckwvmiC/1qt3vZ1Aw4jb6r1AKL8Oz79jqyYUZL2xU/5u?=
 =?us-ascii?Q?FVfQE40xw5AvkHKdEKXXhqgVz0TEEVySzdIF2hTQKvNzjaaksTUN0gLL789Q?=
 =?us-ascii?Q?50idGoLDxB+EZNAysd/aRF73JTXmmzgrn89KIObegs5dfLgYERS9zq/PMG9d?=
 =?us-ascii?Q?m6/2Ir2BVqk/SPrel3PnVuOvxRz/+ta/l+A3B+fuGZs8LqGlXXugMbXHPLCc?=
 =?us-ascii?Q?6qmLDZEPgAYEL0QxesFTs92DuqS6UQxBWRtQy0NihxMQV7uKrEkqTAu90Bjm?=
 =?us-ascii?Q?JF/8a3DBkZB6Ukm9VB9LVQ+tJED4ZqTmRHi+ZZXbyNJp+IgfwBbQjppO0zuy?=
 =?us-ascii?Q?vsaAk3UAruTTFClrvedjtVcnp2ewE7izqmq/ZwC3ed47ORBaXaj8m2DOpq5T?=
 =?us-ascii?Q?Lj/9dW6LNFHVKiJZJxL7GUcYabcWTeyIYKcDe9aJHpAthdgrXfs6RVTfKCtX?=
 =?us-ascii?Q?eRdgCn9slaj9tNO8IrBLJZ/moy4ObgRLMfhDu6L1n4SNbL2lwSAr2qVYkEMj?=
 =?us-ascii?Q?ow=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 949644eb-706d-4fc5-0d81-08da655011bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 04:19:39.7390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dYt6EXnSo3VivKzmficxXj5hfjaC0CuEtkjkD3u7+l8HO2ksm9p1PMKZs/3pIy+iFC/xcfznk/eQndNpV8MAen+mjRZ4IHXCd2w3bZ5+/hw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2425
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-14_02:2022-07-13,2022-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=752 mlxscore=0 spamscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140018
X-Proofpoint-GUID: Rn78SGx5L6cGkltbIQY2nA3vOGDkH0uj
X-Proofpoint-ORIG-GUID: Rn78SGx5L6cGkltbIQY2nA3vOGDkH0uj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver bug fixes to the scsi tree at your
> earliest convenience.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
