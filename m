Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2468C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 03:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 884D461B29
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 03:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhKSDHx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 22:07:53 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:29756 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229909AbhKSDHv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 22:07:51 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ1oRqr009988;
        Fri, 19 Nov 2021 03:04:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tLtLN29WctXoRv3jHRUxApt31htWwmyN4qEVbzf5RKk=;
 b=Wdz43lAV+QI0LztN5IVa+lNpNst3bU3XG/4oprXe70pRTR7HXbQ3dS1gMVrO9oYyp56f
 9LEVByMV/XswcJul0uxWqlcOQMjIGUN40+mA/xlrnocD6FWjtRRNV1nFQg4jw+mqApjX
 XrKQxXgJjnlB6D6/PcuSe4Hpqp+nsxy85hrEzAhwP9DN9PF/mY3qsjELahQfww+n+5/O
 Zj8Mcu8EDZsQEkF4aEkql3spxArx15omV/OK4IOx93Yn9D50loYZ+9eOPcDU32IRvt4D
 jhz92NXckqPoEkp8AG8lVrxembpTNp5UDATt9LKmm3CkLBL1RlLrvTlCXau1NQh+l7C0 ZA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd382mpd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 03:04:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ30llH059160;
        Fri, 19 Nov 2021 03:04:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 3ca569kt22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 03:04:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6flhKEvvcgf7nuK6Jzf1wHVzBQYdVt57a0XOrdQtEHXh2g4RsGFmnNgmIo1E+RbmZev8UnyjfKts2NhJxrYKeyiZa9CQBpXijSjrUMi6+3ptjMlOFN9Rdc4HHCPWlE8gxxjL1XJcHfiMr4nMRzSH3LRHAzUl8Lb10J6/cd4E4Iu54ujOucJDvdJ3OGy9/+ThSRH//f4gvj8bfOJ1K8RJYYCMJtuDmuk3rLY/1bmiRSyXZWSpQoLZYjRO1BSzYXxW5JkbT+eBjMg2PEKzdw0bnIvm9OrAvMBliULmeqr5rvGEllznFkcZ7Z47UZ9oV7U1KbTw+W8f7yb2DIw4EB8PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tLtLN29WctXoRv3jHRUxApt31htWwmyN4qEVbzf5RKk=;
 b=BL5LRRR94p7g6NlYJSuwUZpjvLKqvuZ/LyafOR4nFWbTmOP0jJzYDqZvNFXcWAojWYABwdS3jA9FjHWBR7YUFSECux1L5PmYtgt81mnpWmYoJ5B1DMFDBF3CJfpByiDPG4+hSLOiwQ5g9OQUNN/jBXopGnntjrN4oPh+KY7bEAOI4LDpgN+4EFSHbuwjPuqPp8mE4yN76NnvXlck2PPaMWBsIPRWvyun968gW3hYyUDwSUYYjJ1cDHeElfCzuMoT3f56sfN5ScCQnOrHVxQhsOjho2PeqjuR7Wmd0f/dDECpqG24fvySHZQc8TfxfuQZnhhhRyoUrXDA6h1yb63gIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLtLN29WctXoRv3jHRUxApt31htWwmyN4qEVbzf5RKk=;
 b=vIIld7WRomAh91lvjjqliipqXX2Lripzpr1AHuqEZDDJ07w2lPAkxna644UPeziSFu+UoY8AyCPAHMKN+tbwjoG/A+AkfpNauHzXI+0jMx6hpEDCHxAFeRGrR4o2tIbelISNzxRlTk+j6B2vnUXMEAL9AVW5gBCC3H2h8PJQCBU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5816.namprd10.prod.outlook.com (2603:10b6:510:127::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Fri, 19 Nov
 2021 03:04:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 03:04:36 +0000
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Wrap Universal Flash Storage drivers in
 SCSI_UFSHCD
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14k887snd.fsf@ca-mkp.ca.oracle.com>
References: <20211106164650.1571068-1-geert@linux-m68k.org>
Date:   Thu, 18 Nov 2021 22:04:34 -0500
In-Reply-To: <20211106164650.1571068-1-geert@linux-m68k.org> (Geert
        Uytterhoeven's message of "Sat, 6 Nov 2021 17:46:50 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:806:f2::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.14) by SN7PR04CA0002.namprd04.prod.outlook.com (2603:10b6:806:f2::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 03:04:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 962a6633-8781-4eb4-822b-08d9ab0951d6
X-MS-TrafficTypeDiagnostic: PH7PR10MB5816:
X-Microsoft-Antispam-PRVS: <PH7PR10MB5816A86FD68D8B87B5C3DB6F8E9C9@PH7PR10MB5816.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pOQI0yeKzg/32LCA09xqUPVsjVubpLM5Z5bUfoi1jM6Sd/S5X1OKtGpfjBFP2c3o9TYsMWzydjPAMD79sr/b7LB4amlu46JKAU0CJkeQ2j/56/eraQM3L+R8zMMT6atfOdBA1f4qmbzgWDX1Rvt94r9b8fVInM1TmtlgvXTtrmj6+fxIetSI0Mna13SavfAkgcadVQdQQVgbHOkUfU19PcCdQAkqJ0pcB/plYEuj8C9TQzqc3PyxphhVA6bCyHdre2VyeqzLB79J7AcOu55Nm+nFbqMN1IzMgbt/0xseA11M1Eg3pHz9lJQ798CGQTi+h7T8bt7HPQ3T775d1O1YleGaAfdye6tU7odUZ86FJVzMdKolkHje8xC+RBn0RaAHHxzm1B9GejXH/iByKk8/ykjtLLWtbQ4raixhnaTpKxnerA6n2vq6/DRi882uzKO1nlfrtzmGLBNBBPZJMzCIWfmMw+H/gvZTSVmuv4fEkxoYaTydneTJaAZfm7fGPZZhmOYcHAiJ3pdZviLdgmEa4HW9t4a174xSNGDqzgVZ54sl7xtlYOaFiVOZbqhKPNuxhdRUbeGCOQ9P34WVEcyqxsZT6CDZtrstMHCB62SHhfdIzbIHH5mfvhZhMXR+WaEY/Fn1i1y4XiHydkWN2enKmXiybMG7yQJDQgBHzZHo9g+8fZeP6YqrJIA29rLBo7T7iemaSA2dJ6acfllLQTG25A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(38350700002)(36916002)(38100700002)(7696005)(8676002)(4326008)(558084003)(8936002)(55016002)(52116002)(26005)(316002)(5660300002)(186003)(86362001)(54906003)(66946007)(508600001)(66476007)(66556008)(6916009)(956004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+PaN4sF6j8X4jKPaH3QYP+15i6kxx4oe7NJrsorh+/Af6m/MIh0DkOfKeCLf?=
 =?us-ascii?Q?paIfItThgdXGPviTF4VOSkGYqnx8GLD3siewA2xlUz+SNa6p3MK1jKF95eAq?=
 =?us-ascii?Q?YPF21Tkf6MAuKHszhgCCUQvYhmOErmwWc9aJAEYlsYB/BEAjFVedt/tJ2EX3?=
 =?us-ascii?Q?VVKBTllpnwqViwohuf+ZlXiIOaLfDeuAFHo35vbXJX0sQxUO7wA7yXTJD3Ff?=
 =?us-ascii?Q?2WjtBOU/ft/rSHPJ8wH4fpHAWa1kZPhzW5PdUDWzAA8rVh3C9BAtrCGTpH10?=
 =?us-ascii?Q?MbMMJIoMdNYnY/ebd8pY1ImLxytqlQ6NMNlj7Dzk3e3lg9gjdGofy8dhSc+k?=
 =?us-ascii?Q?AoQLOPRBXM6ZaI3GXgKzOCmYk9axgPcE/R3zE+2ivrsLWoI72w3rBWdE6mPW?=
 =?us-ascii?Q?7OQgxu5VgryWz2iAyZOOt+kN03As2vThs1VUy2PhAprr8vZtgcingPGqgG2Y?=
 =?us-ascii?Q?6VHz3klUc8GKGHGdlxAJwEeOJYTZi7bSqUQnb+LdxKDyP2dDX6iNS7m7jEBq?=
 =?us-ascii?Q?cTLc56EZ0r7ZO3jKRgwljBvJmVP+StwE7ikdnFsZUZblgGxiaBAplujorcdP?=
 =?us-ascii?Q?VpP6SgjjCPmviYULmdnvMuQE6NcMG80x7F1EIFV0GQtFGVAtdJhd04rHlxTg?=
 =?us-ascii?Q?qDXodpekqePmmSzZgoPiPw22/CSExrUK7hieo8tv6O+Vp2pj6OJJAU8uJe5n?=
 =?us-ascii?Q?essilqWr4DSFVRLBQww5Oimiy7GDJ39Aj2u7NFG+HSjTFhGDNM55hS0l9qaR?=
 =?us-ascii?Q?PgxdzY42e1+5am5x+67oham+jZ5bIQfmw+cGLLnZnDwU8nUtGXNCeufcyI47?=
 =?us-ascii?Q?GcnJvq7EO6BxORdrdn6suCB6gNkDgjDAbJJDzYzNTftj1vQk0ah+lm54qer9?=
 =?us-ascii?Q?AU0pVMi7M1GYv3JgNLoaK+inHlB3Nr5+a1SW1voLMim28JZNY7bBlMAhn9IQ?=
 =?us-ascii?Q?hJsiLHBEP8MCR13Tkj7myiqga5kIJ2aXRPsDfxWu2fSr/Zw0bdmp5GE0qy/X?=
 =?us-ascii?Q?7zLfUGA2h4REsgimS1hNZUH3bo8KsYGHdZoWzlkwmP0dJmdbVFEoKahoAiSG?=
 =?us-ascii?Q?29EocxEvQ4nWYEaathrnB5uNWGLSz29+5KlZAykOPCCaBUY3rubqN6FxddHP?=
 =?us-ascii?Q?ln46W3DDmUkGz7h0FsSzDU5OljtFL0cxPjMCuRd2GuCXhc2FoPkkl3gL4VdT?=
 =?us-ascii?Q?HIHEyk+PmUZ+RcHHsBwwl+ixcvTiEjJubUPRHIAmzgk0PjsQZnjrU0uqg1bX?=
 =?us-ascii?Q?vHQXs95Y+K3+a5c5hc1iCh0zuYNndK9kktXVA38ZEFbDFhhJHHSKj4neBSrT?=
 =?us-ascii?Q?oFGOU4EuGAA8tw+Lo6MeTy5/wtJXYq+qxDPEMGwqdTdato5qux43hpnn8lkX?=
 =?us-ascii?Q?6GW0YNiMDFHsUMer0j1ocIK3dj6s+hHnCFOvIIDoaZlBktkLPx3rA3B7ZK5F?=
 =?us-ascii?Q?UgcIAJMBKvHybKGikMdLvJwf5kx9Dvy8oNo7HhYzl1RX/GhZKbYDcsdlQrC8?=
 =?us-ascii?Q?5dhLkcvpj000NUOwUmScdg2Q+WBNzo98HXHjb8QQBCV2GUZsuimBMptxgC5x?=
 =?us-ascii?Q?jqnYRtVKkkKIQh5zPVHUGGNV6DTqalJpA9GyITHTIvac2YWOsd1uwLnIQFzd?=
 =?us-ascii?Q?odDDugYkdBeERw52792V+HMcxFg4XD+Imo0kDvxue2rBTqJ1ztv/iyr1eUM6?=
 =?us-ascii?Q?qMgg+A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 962a6633-8781-4eb4-822b-08d9ab0951d6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 03:04:36.6888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4XvEPoSnEZC/at8zWkbJ+2xQ8M7DGaxLOMP26kaAg5eBfjUwrCAdTkANtA4cvLPJVNiD+Sbx8kWrZnwYuMQXMQysfeWgbTP/3tHCvv3uN2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5816
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=526 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190013
X-Proofpoint-ORIG-GUID: R4mSh-nEoqD6sjuZMwRFo6qXJvUvHuTS
X-Proofpoint-GUID: R4mSh-nEoqD6sjuZMwRFo6qXJvUvHuTS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Geert,

> Fix this by wrapping them all into a big if/endif block.  Remove the
> now superfluous explicit dependencies on SCSI_UFSHCD from all symbols
> that already had it.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
