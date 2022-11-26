Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07FDC4321E
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 02:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiKZCtS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 21:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiKZCtR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 21:49:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC752FFDC;
        Fri, 25 Nov 2022 18:49:16 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ2AOsv016817;
        Sat, 26 Nov 2022 02:48:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=zEawhvA7LZ6wK13Yfhfeo1c3RVm7SadK5DWrIprZnEs=;
 b=aoM1Vl/ZjYaak4i+iJCFZBacvziCzVKxIdsdZtsuC2ZCK4qAbNhilHKkqigMi8CFT2v7
 67Wop9I2vyrTsCM0MiPLiS/anuR3W2I64H527FtwIugxsAfnEBbhHVJd0QkeNQgK5VMo
 qR7uxQGEBkRZ+2xN1AJlPhQ4/SwQq/1JoS/D1hiH8Ww9RX4wEvgmCZy6rn2vK7qm0SrV
 RaWbkTXe2ktNjWGdTa+1LHWC54e7hB5H0S1orjQHX8ELJDOS/OlJsqXjbTuLTtmH8/4t
 s8bBCCc2mqL4MpLN4KnXOkwELZWm4VeOYynN4a6arQqhHYfisodr+k+aP1KcFst4PQOg AQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m39dfr16c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 02:48:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AQ1X3go032163;
        Sat, 26 Nov 2022 02:48:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m3982a14y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 02:48:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCx3JfQ1stHCviY2HYxfEbDShwTU9YF/3b3h/tNnSpXK4ap0rux6aUHzxlzNK5tDeRDzJLdf3JRDdVpTCysc15DGy9rOf1NjJ6K81zxiqzr+Jz1qoOhSPNGhuM2Bk7EXI4ZDktQXN3LwDZfTEtI7EqgU0DboZ3ZL8RTJOnrV4X2rFgkwVfFFo0OgQs0EhMZUXpiQrukeXXLFsUz6JcsWc751nSvcz5JVp77NfFhovjNOkdxsr9sUvYl4ZxueMEg/lNK7wUa67XUPDa1CNlmDpEys9is0IfIA8RtVyv/MG5zEAKtn0KxdJzLWvxV2Fa7A6nVkiai4n9qrDMG0ht6WpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zEawhvA7LZ6wK13Yfhfeo1c3RVm7SadK5DWrIprZnEs=;
 b=DpntxnRWWIK0vOxxacIAX0ND8ifpPEHHeODx3+/k4bju5Zbv8LKEwo/Wmyv6v9aD/R571iMzGGzWJtXbCCH2UGgXMCPjj4sGeExRowZZoGj+nmbLWkVCP1PzxNPxWQLnR5XsA9A3fZOWspNamYT4wfAlEbZCPYeJBpKb7PloEOzEUkD1Spa+X/dEWqNyfcPl2s5jzl/ohUijp2Fy0fE+GFPOEPI4GY1JKMujfwwcfxgAS0IxcKVOExXTByku07P5Kdd5kSybMRAjVL1bySbIvZLF9b69tr6/+Z/h43lm8b+dDvtFwC07FgTD1OSDL09CZuxXog0v7Xp9U+OJrUmlyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEawhvA7LZ6wK13Yfhfeo1c3RVm7SadK5DWrIprZnEs=;
 b=B1EJ25okHqWTBglyBpLara7A+k0nAylF+V2Do1L4uzZObj5ARDTFr14mrj5YKTPbk2e95W8YXtjQg1OFkf+Dm9XaUOkcX4lWFCPT/aCo4LXJUdC9HoupIuN6Va60QUdoZCIaxr8M86SFfzKqVZYsK+aWdFZSAsD7rc2fR+auo70=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Sat, 26 Nov
 2022 02:48:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 02:48:55 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     chaitanyak@nvidia.com, kbusch@kernel.org, axboe@fb.com, hch@lst.de,
        sagi@grimberg.me, martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v3 0/4] block/scsi/nvme: Add error codes for PR ops
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7sumo0c.fsf@ca-mkp.ca.oracle.com>
References: <20221122032603.32766-1-michael.christie@oracle.com>
Date:   Fri, 25 Nov 2022 21:48:51 -0500
In-Reply-To: <20221122032603.32766-1-michael.christie@oracle.com> (Mike
        Christie's message of "Mon, 21 Nov 2022 21:25:59 -0600")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0207.namprd05.prod.outlook.com
 (2603:10b6:a03:330::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 48cb84b3-9d9e-43f7-0e52-08dacf58c216
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ajbPX17NS7GPQ598PfsIkRxtxusp6NktbAO0TinHh9Hs42myFH7DQEAoqeuz707WYeDWKroIdcrqgm8rpSaVNa/7MPtgVswWs8kd9HTA42MIa1lspUBf9DEMX09alvGoXsda+YSBpKgwZGIHqKYG7UEtbEStAq9sJwhSV0rBeiWpbZN715oKf+g1xo+mbxxGJimvFaiRL54bzh4o+N9I30+hUngecxa5bHvjAutp9EbFuwpjX1Ey3MGV6U3hooYvtWLtu0MZoEVH3fzpJcI5ABjKqTJrWLIiDwgN853HAb7ZTdAkToE6oX+tt9BgwhXfM4vY9dhWRgs6Kl76JRIaOKxyNro9sj400jl9bKtm/tWQ8H/kBDKfI/+osnKEMqJnOnEhaYMmFcojZn/YjRj5HY3wjnXLXGE+GhwSOjHkXlu15vQn7nYv8C8vi5uhpxOFUlEBq3Of86oKqdfiJhBSK6viWa1Es0cKBza0iKR0vI1CsAm8/I+KkZH+amPoP43zBOz1HlEsnRaUIyTlH/ooWYOyFwXVCagN5LKPBLHzqy5MAe2OuPP4hJ3NC/CvTsbxlr4m6C4FWFtyRQBlBwIxOaxbdRVs6bP16doOJXd2bbGWgrwFV4IlULsEQGfJ9Cis/04Uzba7PgP/cqmMAfekzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199015)(6486002)(36916002)(478600001)(26005)(38100700002)(66476007)(66946007)(4326008)(66556008)(8676002)(41300700001)(86362001)(316002)(6636002)(5660300002)(6862004)(4744005)(8936002)(186003)(6666004)(6512007)(6506007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nnMk+gY/Mt/pL8ANx07fnVP9qgqANJikaAEMMMMRZnNbFA0kndMEbcuEQ1ko?=
 =?us-ascii?Q?0nOIozN7CWqz22hi2nmWsPLDGtrUSW8XScP+CoHQgyZRrNnqrGwTOWCAPMSQ?=
 =?us-ascii?Q?3zXyuuwiD56dIdUAmgY2/pKt7G8YN2mf5tRJBPdstE4jLE92WQmbYnbWRl8v?=
 =?us-ascii?Q?/9/BHEUjsXsmVVKON/830b8bMa0ZWCo02N02wMrNrCNSjStMakZTgm8GPXCt?=
 =?us-ascii?Q?hEmGQUUnWxQlGQ3U84dWCmc0+Ux9j+NTLiCxI6STpB1qYE+9bInbermzlYUm?=
 =?us-ascii?Q?d49XbW0DblaKQd6OAFCTUA30xd0b26o7ZzzkxEyV3odMfCUM/yja8YKOGtJC?=
 =?us-ascii?Q?w/KRjF2dm5P+z9yOQ8/7DeAe8dl6MEvrQHDmAgcVQRKf+eqVpM0Vd7+WbPYF?=
 =?us-ascii?Q?5AlQrgwOgdCF3SdGNSo5ph6Jr+Bo1Rr8F3C8pjJjnRgqWrO5zVw/gkL1YYrY?=
 =?us-ascii?Q?MXMpzbasnTMfhmojGYKyKhNHdap6C2TqtUhnNvGbisf6v4ywDVlFgAYymK/C?=
 =?us-ascii?Q?NxAlMz0YMqCBnjynoXxBkAI1HiMpkIdj5fgKiJ7OWR0mthG+pkf7HgW/xA2Y?=
 =?us-ascii?Q?LXVAoBrlc12barcivuLgDE+fcfHn61OVbhKfQjOhB7affYp/EgKhIa8xbU0i?=
 =?us-ascii?Q?dKSufCVX2hSBZ6B3kJnJynJWpawbwBfkyH4H0t+GUPLAbFkzIK59r6wYXbe6?=
 =?us-ascii?Q?azJexkCeDIeMsWXqlNIMytNo7Pl9lv14oZQG3Bdsn2vTiMG8f7Qc2m+x0Pzp?=
 =?us-ascii?Q?vkZGCE19PbhngDb3j+3gwa/b+noC/6tNLzNCjIjWRrVIxiM9XGA3jJc0yMLX?=
 =?us-ascii?Q?IZApO11WLHnd0zQcrXYRrmUOctwXFmONbLNZ4IrQ0suMSJSDMr2diwhlhoGF?=
 =?us-ascii?Q?Uk8JPQPD4X74GT39dWm75FUELPmUop5cAXxfWpsxsOn1HbZ1Gvw+/eUI7d5G?=
 =?us-ascii?Q?GG6xBn+vbT2UkwdNf855u8J2ktu/OJRAC23DgxCmP8VHHUJ1UrpfKwWaO/a4?=
 =?us-ascii?Q?RsGM7v/hTtppaYfImcCCm8gxGQaMnBPh9tNBACLuRLaCcgir10QsIVCFYuKw?=
 =?us-ascii?Q?2+IrqY5XnNxmPhxEvcxVkGf9Nnx8k6jfOTshy+khy/b5zVoxeA5kIKB4fIwi?=
 =?us-ascii?Q?hqF2zvtvJpB0bvCjJ8WqdwdFSxYElW5vj1J1bYy+ZjbILMDhDcmUFiUhOU+s?=
 =?us-ascii?Q?cxMBM/XZ04oun/TECVoiJciMAhno3o2KHXe/789g48ittLdP21CUNL10yHzZ?=
 =?us-ascii?Q?S71VjVOe+RQeuPlwlUkzinz84R45BHNMlvdI0Ru9QaDlbw2aTBSeDE5w5reH?=
 =?us-ascii?Q?nZXOPoJBvEhj12BPAMpDisWqncZ6Srty7u9qHdOpgRl0VArTay7M7NUZ9Hg1?=
 =?us-ascii?Q?l4HrQqTXT09WeAT4UxShl/Wa8ECnK8Maw43xUGl4bQD6mnnq1jNZ7nlo3sKP?=
 =?us-ascii?Q?bfpoLpmVSZoxzOyWGwrGCvkvEuPHenLXDMNKD8dybadG/a3vh2gqtL5ZnvC7?=
 =?us-ascii?Q?8PQhuurJewpsSz7aN9xMbLNNfh4aNp83zKFNMEVQTAjlkSD2cSG99dieMkI9?=
 =?us-ascii?Q?0hVV9J3Xr9fnnk4LwCZRoFQC3EpMJOpedSYGJFrWzf0IAhKtGGlUVGdDYaVQ?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?1Vaj53TR/NIP5gpS89+zjc6hhiziey2cH0Zki5xNhX/Umyr0nhcDnriFkMEZ?=
 =?us-ascii?Q?giOreU2azRqWBEbMTsmRtyIDKk6TnVzJ+GhGwr/ddAPxOB0e+OY/e6DgwCcA?=
 =?us-ascii?Q?rZNsFuIdQbVD3LzNFVi64EQOixzSeJQ4hkOXckPgWpZRm5g8fFuj0wbtgjtK?=
 =?us-ascii?Q?YUduqv2zMW8dXVk5fBT6ZmPdeNF5PW1Sap3QlzIm5Pvgn6VINOso67DVJr1E?=
 =?us-ascii?Q?sb8tJwRLvsUwjBgDqozLZBKCgKisI8mcaZUVhrYyBhkv4qOmHoqXQeI4Qvuu?=
 =?us-ascii?Q?DxdaFB6h5tUAuzf+PGG+f/NuZ2PQ7bdXpiyzmpdER9ys/+6QYePqiPpXW3mO?=
 =?us-ascii?Q?WY+wmba1ZWlAF6ZtEVWsWZKcPeFr9ijW70XR4ys9B8YIOL2AECh5FtxK5IRY?=
 =?us-ascii?Q?zyiPqZtd6Hq/GAcbEAgIsKMOCROkAzRo9SFhWcSFtq4vsa8qfhGgHB6cGw2f?=
 =?us-ascii?Q?Pwc6UD9U6PDN/gex/TMsDwbjQNjxCow801eRnM2osuRE9GFfnbY7Lw2ivjla?=
 =?us-ascii?Q?7BNShgYq2BCvUvGtb/ObGg7sRje66js4+8bZXLb7F8pD7ytypUXfTYMXn01t?=
 =?us-ascii?Q?bFkII2HUyaPKsvYPa7RomBzg1S7hDAiP0UXQFMSjo7tGSAqSE0PwqKN86fhl?=
 =?us-ascii?Q?sXzZanwDkzMMGwNj+uMjd6BGWTlJ93iDDxey0Oci4plGyJ4OBVznMGZB3Elw?=
 =?us-ascii?Q?TjAXg6Y6XHPYx49jr6/PyfmX1WKEDipCtGYvxn0UUyVIpi0LMpbSjndQY7gP?=
 =?us-ascii?Q?VJ9BwELtMkX/F6ZikEp1avyeBMnKXmonUqdhTuE9TAduoCW3VUUwzllHn6L3?=
 =?us-ascii?Q?HGeMBuBUxLfGZ9gPYoduE9PPPQxW0oiLm6744dhScPtdTKw/T/9cA1wPN11u?=
 =?us-ascii?Q?pLRnZutsbBnxnyaEKc7Dvv9MJ0qJBK5GQo+5bXm3aM/lzkp7IxnRcQ86toh5?=
 =?us-ascii?Q?/iI8RFrLHdgBxYGhgo4MrODLXL+6om/NPkYpjWK2vGO1nJF9koVUw0pONBBE?=
 =?us-ascii?Q?irAFhz3Px3awd9tNVbZ9Z5/e9A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48cb84b3-9d9e-43f7-0e52-08dacf58c216
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 02:48:54.8050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FElCaxvwo4Z6X+Mj3ITPgWeDRn7frOs35fwOeP5kD2b9bk5sJ5M9oCVXUFkTD0Z0SYW1RpQaa485eSbP5E8PMLLxEBkvzwoEKr8/wtXue1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-26_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211260019
X-Proofpoint-ORIG-GUID: Qa-jKFW0SgVAvA2i78odkO647WTp9Y5Q
X-Proofpoint-GUID: Qa-jKFW0SgVAvA2i78odkO647WTp9Y5Q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches were made over Linus's tree and allow the
> PR/pr_ops users to handle errors without having to know the device
> type and also for SCSI handle devices that require the sense
> code. Currently, we return a -Exyz type of error code if the PR call
> fails before the drivers can send the command and a device specific
> error code if it's queued. The problem is that the callers don't
> always know the device type so they can't check for specific errors
> like reservation conflicts, or transport errors or invalid operations.
>
> These patches add common error codes which callers can check for.

This looks OK to me. Not sure which tree makes the most sense to funnel
this through?

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
