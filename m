Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B591C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 386D761369
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243613AbhDFEsx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:48:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50150 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243599AbhDFEsw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 00:48:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364eaU0061403;
        Tue, 6 Apr 2021 04:47:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Q/0FwLh1DqYp1KMfC68vnzs5eELIfMqic8K+PwIxvA4=;
 b=qRMUrZAcWZyTNCsBObsqH6t4T7fd1KTv4tJw5efYas44yLDKDUMcHcQHaXOvlX4ieQH/
 ZZ4RFrcQs6oird21SymtqhzK72idNVxUS1ISfGykCOP7x2bbLaHfLsUSfbF0usg6fSTF
 bfNe/+fO8pKHqPxLxaZWzePD0aA9FxcuKy6+gWvNXEKPaAtRRN2zUUfwnPiuukmJiYuv
 tC/9t1QbArwdflY+8C+OIWX7M3gRxgN4DkxqNtwYSIMHyvqVrVyAH1m4qu66g8AjyyRD
 HjDpiPXikFobUNvPV0bh0uwo0Fr5NrhNcVZ2N9WVSIWKx9BNgzGd0SX+RIU7nkvZKOEK 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37qfuxbbmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:47:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364f0um037740;
        Tue, 6 Apr 2021 04:47:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 37q2ptrd9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:47:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lupQZCluSDN15BpLMKLBIQK7te80muLOC1Z/7vRSJgvaIWuuJccjbpq/d4LA3/enC62FJ+Yi8OYQo1Odo9ie4T3csn+ZoDJV8GTnRz9jM4MT99MY5XRK0ZV71IJKg8wemLADbt4X7VitYymVsR4w7xFPK2Dgc08j1fEuEEhyPQO0E1nFO8CIG1H9D0LRPesNDwSrzGSWBe+cl8mT/OKVuLLLwbfCSK/N3mSky+TexLxXHOSc59zQIZLkWCxerLY2N46eWqxdRfjI3nTOBRI4lhPhBmxbgGc+XteymFmjrZ+I/ZRITy0NYvl4J950pSSamgy1nsj89MK+Y0md98sq9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/0FwLh1DqYp1KMfC68vnzs5eELIfMqic8K+PwIxvA4=;
 b=M1o7Z6rhQo0nrFq8EGTYBYFK7A4QS6cYjYG1+e6uXuu6W7lPG2K26YfGIt0n69eTlIifev+O0k5pRzOPsYsFlCgQnabG/u9D0cfdPXAvdPCww5FOT2uZG1ydvwD7Gxrf4El4vjgwBbDXBDef6TuRLdrf6Ta9b4hWmCwv/8z8Wrvk6DFI11UOaP7VTn5Vrxf3XUgqWMUsQLjacP0nozhmH8d8PVSa11KRfw89yT155XhhG/GdP0uZ3j7xf549ULWowUYVlALCbzzdkCJCMU3RhTxA6mnBE+EDBGttZSQ9hIpaVi6BqY3OXVPBRDwz0Kplai16iPOK15PrfxkCO7QhjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/0FwLh1DqYp1KMfC68vnzs5eELIfMqic8K+PwIxvA4=;
 b=Eh2BajR4PZCxxRIwis6rRbMDceYh33q59KsGyPs1CtgClTuVaX+If8zGTFMCcjY++rNGdI0VkR/SSIqWzqtWLUA3qnQEAJOicGY/NuUG+X5au110IKleyA6QbjeigYqThOdlsKGgD8nVsaXOiROVbmsiEqEsn9HflY9h7YH1B+U=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 6 Apr
 2021 04:47:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 04:47:20 +0000
To:     Martin Wilck <martin.wilck@suse.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "bmarzins@redhat.com" <bmarzins@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: RFC: one more time: SCSI device identification
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
Date:   Tue, 06 Apr 2021 00:47:17 -0400
In-Reply-To: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com> (Martin
        Wilck's message of "Mon, 29 Mar 2021 09:58:49 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0701CA0020.namprd07.prod.outlook.com
 (2603:10b6:803:28::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0701CA0020.namprd07.prod.outlook.com (2603:10b6:803:28::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Tue, 6 Apr 2021 04:47:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d128db98-ce30-4e0b-1703-08d8f8b71026
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45027DC13CC0C854932048AF8E769@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jGOmVYGwuo04DnuiIHZpZgLOouiZ3Wvuk2XY248Y1IqaboxzoBXaTFS4adBIJOrhXtAvK1m04tWuDFg5uAQbEcINNsdnazRS+W5KKDMKtsxVNl0WNQn51QezF8a7n2DdYEK9Sp7Y7Ofqfa58zbFOEFF8xR/fj9usv9c1nrq1gJ46bO7gPRr7VqjLDieIpP3dYLawff4YS5WRq6UjHt4oMWXjP4oPslsvq0+jaFV7XmmYV9yK1t2+vqc4DbUrg27zFWGiDLu2IFq7o5qBF5JttDqFb95tjQuuNzaocTRSlJOxuxH4kISTYLaPBNQ06qgLvbRc9OhZWaXglACgsT2rVtEQBQBoW+nxJ5gzDqEiLjrwndrqF/lI1/3GCWiMAbIKHwL28TgFkq1k7t0TydswJDQx0eEMjk8XIWVWxNNcD9FFaORDYuKV5fRN3WRqPyEezk2gqWNckz+F2SD1DwOXt3+SGfIfHKzlhNOApSfDD8byrlPkVULWRUIcA+OITUj7eJUL5luVHDpnw3y/MDzsrBSOcOwPyelEoHCGiPCgYwRPoHGMKU990DHWbMfci/q0wBSHdRu6MUHoKs47uMXNZIh2B2uPQmWuH0mDN8F4xRvaDHtFsnbU9l4XfV8jkpC4VYhtY2KSTCxnt58yCpFdmicmfWWPW8krSxDLMnkdhw+kVbhyOqHnS3J+4QagbnBe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(39860400002)(346002)(396003)(38350700001)(186003)(8936002)(26005)(16526019)(478600001)(66476007)(66946007)(6666004)(83380400001)(86362001)(66556008)(956004)(7696005)(52116002)(2906002)(54906003)(36916002)(316002)(38100700001)(6916009)(8676002)(5660300002)(55016002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4NvH6nrB4aEZIGV+V4p6ZIQ3e9IAJMknmWpWckJRoJlUdcxXJ2oQcj3v9sGY?=
 =?us-ascii?Q?rMgIL+T1d9ZB54Pr5AzdWDRMBYvbhe/l1Lwqp4BrtwHdJbb/3aKxe0Bl1bk6?=
 =?us-ascii?Q?uqb3/kclycRp0iVYBzVHilFMw/L0q01lWJJPjBF+rT0/E/a6UoKPcNArIS/L?=
 =?us-ascii?Q?WwRYRMd1++/V0cEk+nIV3HpOtxHsLVL+LoK7yI6hEZKPbybd5kPxDXJS4lrh?=
 =?us-ascii?Q?+A4Ib6m0DGZmDbAmXvfCsqzXvJ+M+27amoQ4BvGjno3j/VfiqcM8D40AnCKl?=
 =?us-ascii?Q?aiOflhk0K7DnGziRKLkxVjaMwxfvl9QzVhWUxX3Dzve7q9ojfjfTdf1c92lw?=
 =?us-ascii?Q?QqYXbJXG2DMiINt5M6iuzYjNHWSAFSJJu0iN0eTsMNn8SABUdnwzgJd4jUQM?=
 =?us-ascii?Q?b3LxDmfJPksaopntqYx3YUw0eTxL6Q7QmMqPyB8Vr5sTUziQnvV0aNONg1Mh?=
 =?us-ascii?Q?7o4Q3i20KJQXDZTtJTIv5dKzDkq94JXn7rBHFfm29wQZ0Kj3GFOalrae4iPw?=
 =?us-ascii?Q?su0j8PNT/+Gv/WKaV7t0A4OcQu1Qy1ImcMo7YkwfXi/f/+JwkCW1CjFFsV91?=
 =?us-ascii?Q?3ryit4odJfchJKVAB3TBPdj0Z79iBWxO9N5c/kMsGfJZT5bSgNDNN5cAKERg?=
 =?us-ascii?Q?rxCocQu4hV0Oj/w8Ng8ocUu8VqhY4UNA0tEEBiG8rjl1SkKMTocwIS27SMuI?=
 =?us-ascii?Q?cEcdhb8m7vzZsgNP3cM5cKdiur01+ybYwfBJHaQ/nPB8Hxq8ulcEFzdxP5LX?=
 =?us-ascii?Q?+2uYXh9C9HUq8aTQwWshYUQML1/ayettpn6pzQj6SiGE/mHReIJj5ukr4SBd?=
 =?us-ascii?Q?3PdGiRl3TSgvcZiFvUp3FmGRJ/Gnl98zBlaZ9VIIlk6jhU9Vmy36NlJ5uTyf?=
 =?us-ascii?Q?ABcUn7xrS/yytNSmfP6P0/JApFdXsZobwRDOnlrHTziCkSxOTnd3ode4jw51?=
 =?us-ascii?Q?+VfuZoqXzbJMZrcSJls43fTwWCxnZn+Jo+jMq/qngZi1q9h+rOAWOzTmT5KM?=
 =?us-ascii?Q?amT26pC10Suc9CZi4s0FJJRrRVp+3LhxBOxQxTxkrHo05JekU9+uluAx/eRj?=
 =?us-ascii?Q?fW7HDD30WuxNiaY4NEOXwsIXK8YnsuxTWJFnCiYUY23F5EIk+zJ1MxeDT53/?=
 =?us-ascii?Q?ZLmgHO602GZRM1dQ/MplTIJV18vN4fEK9idhYcidg6OM+0mL3E3RaPbn8SPF?=
 =?us-ascii?Q?qBQOitu9wA6qpja7yzhE8Dq95PN0RiHjhvoNewLApdq36zl3l5qeyBNL3mV7?=
 =?us-ascii?Q?drCuUoNmC5J24+cTKtp1uBTcd1T4YrVVIVdhJqVQq7tsVLPOHGxD0ooWAMYY?=
 =?us-ascii?Q?FlPQSNiCDxP8CCkq7hMeahjX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d128db98-ce30-4e0b-1703-08d8f8b71026
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 04:47:20.7994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fz3cvtuLsz9OwBtStBgo1trFn952jijuz/HysbS0SPiOS00ghgwXYl7v2lLnGZI2xnh86SIZnAAUtrPGBE2Nm92UshQVo+a/vw2mkMH/vDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060029
X-Proofpoint-GUID: bJ8vv5zmdageLP5oEEXj_ofLUj3-YnUM
X-Proofpoint-ORIG-GUID: bJ8vv5zmdageLP5oEEXj_ofLUj3-YnUM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 malwarescore=0
 suspectscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060029
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> The kernel's preference for type 8 designators (see below) is in
> contrast with the established user space algorithms, which determine
> SCSI WWIDs on productive systems in practice. User space can try to
> adapt to the kernel logic, but it will necessarily be a slow and
> painful path if we want to avoid breaking user setups.

I was concerned when you changed the kernel prioritization a while back
and I still don't think that we should tweak that code any further.

If the kernel picks one ID over another, that should be for the kernel's
use. Letting the kernel decide which ID is best for userland is not a
good approach.

So while I originally liked the idea of exposing a transport and
protocol agnostic wwid for each block device, I think that all the
descriptors and ID formats available in both SCSI and NVMe have shown
that that approach is fraught with peril.

Descriptors that provide "good uniqueness" on one device may be a
completely sub-optimal choice for another (zero-padded values, full of
spaces, vendors getting things wrong in general).

So I think my inclination would be to leave the current wwid as-is to
avoid the risk of breaking things. And then export all ID descriptors
reported in sysfs. Even though vpd83 is already exported in its
entirety, I don't have any particular concerns about the individual
values being exported separately. That makes many userland things so
much easier. And I think the kernel is in a good position to disseminate
information reported by the hardware.

This puts the prioritization entirely in the distro/udev/scripting
domain. Taking the kernel out of the picture will make migration
easier. And it allows a user to pick their descriptor of choice should a
device report something completely unusable in type 8.

-- 
Martin K. Petersen	Oracle Linux Engineering
