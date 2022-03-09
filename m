Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25C1C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 03:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiCIDcL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 22:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiCIDcK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 22:32:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660D715C644
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 19:31:13 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228M8nrF021319;
        Wed, 9 Mar 2022 03:31:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mbg1P5BuQu0ufv8iMIqwk0dA3Q7MH1hQYVF066fmW4g=;
 b=JXO7/wDyzR457hoZXDrg7xE7kZquaJ8ZuNKEGQ7GvfsDTeGsy92g9eVIJzrlwLWNNW8D
 9/zMA58HW6ThZ1vIT5XUXzprYOdFxrrEQyt0FfqWsKjw8VpAOzkye47OXRxVJYatJbA1
 gZnZHrY0tWTQ3mCqaB6XEOCVBFh2oELD5eIsjBgfl3JVk3UC+jcs8E5LoBXsigy6ZrEU
 5d4y5c4F6Mkoue30eUS64eU5vPCywDYFEf4GHVku6ynZ93NCqsnLWgzlayAQ0azC5wOX
 iYG6F4FvRyEzcLlFZEHj4TuCGUt47JTLF02S+1h1fDmW5yGhymwgIFXlQj+I/dyNDbSR DQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfsgs38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 03:31:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2293UPPj047214;
        Wed, 9 Mar 2022 03:31:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3030.oracle.com with ESMTP id 3ekvyvg0g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 03:31:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZXYMz27b/0H7Sp+3rD19Snr7+jTPtgrAxzHwMIfGAgp8+FiaoHqTzRYmg0K9XinpkIgBi/dedGMdOHDeUOOdVtoNeD2pJuvvJ7kwLKlgjfiqXM35jxoFYZVSrdmEeBcWmTP3pwuPjPGCitDzPXNoD0hZ6Uw7TMOuzabQYkEzhALp7OVs6rwsFAU+qUS48o8zx56elmRd5CFXaS7OxhyKNGs5hXKhjMW88duPyazfkmzz8CQ80H8hDtpizq3WYH96sbR8FO5PoNkhGdrBHgM/uyPjAGJlbEWV3dJw3qlncd9BwQu0haY3QqeIJLUHnm94/BPZHA7ng0bbSDc++SIcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mbg1P5BuQu0ufv8iMIqwk0dA3Q7MH1hQYVF066fmW4g=;
 b=jWI2TwV5aoVtg7dQOR2rgX7+YC04H1MV1xKDeLAkn6k1k19XBKmb+xUTCA0W+l5uVZT0AxGAAjrvM/WTY76QPKTyO0cqSIV38IZDd1swER792DtaI3r5jOTu6MblB7ozJVfleost1tPon6+XxUwc8GHRUYkd3ABAtRMsixs52yUUMyD0L4o5xYXlFTHgUluIgw1rrNMmw0eaKqYxwrpoC5L779aIC+Roqgb3z7j796N/YCJiDvObL4C2xvKqXmngH75D9yZ2cqZIz+yz2mkfmOaBMIPZdhNX8BnLwylverriViRRsF3ZpuDhs9+f5V3ME2MHZYGe1irnMbzA7iTeIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbg1P5BuQu0ufv8iMIqwk0dA3Q7MH1hQYVF066fmW4g=;
 b=XN0rcRYUB3JJ1WJR30H9fAydXoOgQKZwrDi0H/FjkcLisUlxwMIkljcTwh/uqJkvCUTYY2S9uwN9Sn29Rp9fMxIg1JgGPk//t4LCwSxrBvrilG5qnaxXQPCzJnH9ODtu6NIPf0ng+hvkvXHvlF+YeM4zJkKLxjpj6X+TzhOdkE0=
Received: from SA2PR10MB4763.namprd10.prod.outlook.com (2603:10b6:806:117::19)
 by BL0PR10MB2996.namprd10.prod.outlook.com (2603:10b6:208:7e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Wed, 9 Mar
 2022 03:31:07 +0000
Received: from SA2PR10MB4763.namprd10.prod.outlook.com
 ([fe80::a045:e293:518:7604]) by SA2PR10MB4763.namprd10.prod.outlook.com
 ([fe80::a045:e293:518:7604%3]) with mapi id 15.20.5038.026; Wed, 9 Mar 2022
 03:31:07 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 0/2] Fix sparse warnings in scsi_debug
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18rtjls40.fsf@ca-mkp.ca.oracle.com>
References: <20220301113009.595857-1-damien.lemoal@opensource.wdc.com>
Date:   Tue, 08 Mar 2022 22:31:04 -0500
In-Reply-To: <20220301113009.595857-1-damien.lemoal@opensource.wdc.com>
        (Damien Le Moal's message of "Tue, 1 Mar 2022 20:30:07 +0900")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0025.namprd21.prod.outlook.com
 (2603:10b6:a03:114::35) To SA2PR10MB4763.namprd10.prod.outlook.com
 (2603:10b6:806:117::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5448ee46-698a-445c-191f-08da017d3f34
X-MS-TrafficTypeDiagnostic: BL0PR10MB2996:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2996ECF473D478D484836C868E0A9@BL0PR10MB2996.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XVKf3pBpbQ0M9wo/qDGgIEGLXKicUtma9Jo036lEVdP/IeXkQRM+YeWYmpKMvJvSI5PdRoJXSlLCta20gaTHdm3aTXaEVIRCjIQwe+5j1cr5ZHJcZVFH4UXzVIao2BL8C6lJuufT81Ews7WFdkhQoDT+QesboBJ3euPrm62v5r5o0+rNWNhP0phyYltQDaJufpauuQ27VRdTfOchRz5jeWHVyVVTPkXDiFO6/dvDhLPc1qqsFWUd0Mj4cjvM2JgL8Gdfnb9rLr8nxlj6a6zCXuZzQDbAKyXgVsmBLRZm+5td1//8kWlbJKA+2h4SwQHR0AjWApOkPDqyiz5U9SIcCKyhJfhYDssYgPwu2bboAXji6BTLO2BfSKGqpXFJfP54vwSPKoiLnrm5NhHrA/arCYYJY0JSeULZu/zm7BHtpoKRvIB6PMwKjEbA5O1uOYaBYXftL1lICM+0FQuhyz12+uC3anCkQEgUmWCHR4euLM18/RZHAew9wsdkRP3M+KpDTRnKgewm2vWtYQOdv7u0CZ1UHPaYuUjigcxNnr8Tje5Op1qiQNTvCvmLv4Pc6NmvvYVKVx7Y1xvht+bZvwgCB0GEBF/9Vz8Tw+IVY5UzdmLI1jPrT8TaUJAOF/ix7lc6q40lRDoUtzXaFkXHopSxoCcAlOY3c+V/crRHf+89fPM4nURhzKqxJO2xie4MlbR4v6+zaw9tEXGvl4oVKaV7pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4763.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(186003)(2906002)(508600001)(316002)(6666004)(5660300002)(83380400001)(6506007)(8936002)(86362001)(6512007)(36916002)(558084003)(54906003)(52116002)(6916009)(38350700002)(38100700002)(6486002)(8676002)(66476007)(66556008)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nJAQ5jFsmDPTNWSf3nvROtMBEdb6UnHcRcXQtec6p7EOPDbkI/scpCxDyCOH?=
 =?us-ascii?Q?OGEtxLUVXV10c9R+KUlLTUHZSbnORZOVKtfJX7kpyeSaxxHMNFYUx20hw8Dq?=
 =?us-ascii?Q?vAtqWy2DIx6BTIUOYTrGSzGEf69MplLxF3XxMzhqN34ilY0SmvYH3+Jj2zIN?=
 =?us-ascii?Q?xrH4uibQ8IoBCeMY4Pj57VQqhbGcCYQBgmO3Kq+iUGQbpEA37TG7/ja5/ygr?=
 =?us-ascii?Q?2s1lZTjpXnLdBYBULaqqu2rMGSZhFMC/H4FbFbEfSPo8I7jRzwfNtzimnPFt?=
 =?us-ascii?Q?nOVaS2cXPvzAxdcquprrjAAE8RJUnigMNLhzZhz8LGYdbHWuxu1AuSRowywZ?=
 =?us-ascii?Q?MoOYRh+WP8Mpd/K1CYhVQVa+Scg7FeUh9KLQrsvma432i/U2VNEQQYR3MaZY?=
 =?us-ascii?Q?EoIdoACAPeJDoFBZLol0ETTHH1PFDeP8V33FUUEOVudLB5dlwjzipH28rPa+?=
 =?us-ascii?Q?BiQY6Yw2ilQg2/DeI6liBeHYuE2obqdf5t345ZeibWA3x/s6yPqVGRcwvJP6?=
 =?us-ascii?Q?bT3aLKKZwFmds1TLP8h7mMnOWAfXkBM4t0hbr2VbuC8VwK5Ic7rD9MZW/iL2?=
 =?us-ascii?Q?wi2M6zaPjQ45cF+abHZ1AI/E/PFExgrmYuDr4OacpwWzuFG+bHr8FljQBjhf?=
 =?us-ascii?Q?yWIBj4xCLx4T8beVtUEO7b1h8MYM5Fp+FcvgVfnjOW44F5UVh7RCZmm+uZH7?=
 =?us-ascii?Q?MZDkKdSQrGmVpDEP1LTS171u+zTb1Lx+ymCpWdo9dnz3pr0k0gmoY1GkgLxn?=
 =?us-ascii?Q?5rHz9qhqT7oJrQY4c+O5ABjqdpJ2Jjbukg9D97d3x/J6By6njLVuNU5oWnmJ?=
 =?us-ascii?Q?4h7IRv9Iv2U5X8I3kg/Vqsa65hLyMl8URz8nTTPFFSyhVDC4JGCIwk4oEmmJ?=
 =?us-ascii?Q?5QHzrNnNrZYxQ3yBCT8Z7rh/UvvYW+MWEmyIEpvuXt48prxH86kivcKRRXtQ?=
 =?us-ascii?Q?P3WsP3OaUU522CLz+LdLpl0DEPGk/NqHALsi3rrMqYBdnCl91GouXh9Q4j49?=
 =?us-ascii?Q?PO9ElcdhfhmpyPMz9OmHxHgKlW8UzCDI1crtuP3PelH4Z6uUYHPP904UNHeH?=
 =?us-ascii?Q?Ut/BVrVOz5uPUldiiZFIpDwd5zoz914gfm2kd2QxrJvESDwaUywkoNgLNarI?=
 =?us-ascii?Q?FPqHsKcPA5gVIVsi0dnkDs79PPL/eHMrwndjA8Z09cNI1V57F/kggGP1GJI9?=
 =?us-ascii?Q?awGPnXGVvPmINt0aeuVLSKBzrc48wtFSeXQtzXBkBHxhDki+jOhG7kX1XsQ0?=
 =?us-ascii?Q?e6jFmS5+he7LwMFNz4UVoHL/5jtu8oMbb2ozoFVGszL7jOikYdHGXYCqFVIl?=
 =?us-ascii?Q?lcrQFbq9L1F5zari8fCumoJKK9BkQSOAWBp4EWV6efVCD+oORHzVK6hauEq/?=
 =?us-ascii?Q?4iObjKrKBaUmyud4pAChQXqiI1f362x3r8On785FJ8gpKRde2HmPFqYYlA5k?=
 =?us-ascii?Q?LSpNMqBYoCu8Ca9e8N4YAUFDTRHGd8k+8Xjznqc5yXMmBbTX4ApdUxqjSCQg?=
 =?us-ascii?Q?J0XrWMWRaiSjJiksF2KJhpfGFUSgFG9Tz+j6yowgGluwRDs2yhK5o2287FH2?=
 =?us-ascii?Q?y0fC3cTIqRtlfePL9W2JfyVVItKhoa08vYudaOhNirleXOS+gyjypip8c4t2?=
 =?us-ascii?Q?LIAUFuzA5QCelhM+iEhlUULuz8CNG0lOgfgVj0IoAnJJC0B+A99WmHmn1QgB?=
 =?us-ascii?Q?sF3/Cl6Pg98mvRqRXNPEgIdTUF8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5448ee46-698a-445c-191f-08da017d3f34
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4763.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 03:31:07.0984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yDUxhngXcHaLhKnBiBwBdtK9bxEwWENovSx7uIo7uBbSE/iLjdNeNmMEIqq5Bk8AAuTlGXMb8J3RF37zwKqIDXkpu/UnlOoX2p7vxCNYTjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2996
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10280 signatures=690848
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=876 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090018
X-Proofpoint-GUID: fRrSOyHnRR6_pMvGNSuVtc0vku3gqvoV
X-Proofpoint-ORIG-GUID: fRrSOyHnRR6_pMvGNSuVtc0vku3gqvoV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> A couple of patches to suppress sparse warnings in scsi_debug. No
> functional changes.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
