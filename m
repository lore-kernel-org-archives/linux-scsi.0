Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C08BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 17:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 154E560238
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 17:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhJLRoC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 13:44:02 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16934 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232231AbhJLRoA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 13:44:00 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CGnrdF016792;
        Tue, 12 Oct 2021 17:41:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=H9C84P0qbQxeyKTW3tN2L9SuFSvJcdQ7vOTbwTPyut0=;
 b=ug3KsvuLfBkILMmqzHtWboO7HR4hVCsUqA8TvunZbqVJIHaGQ+j9ob2s4L6DeuMVeoAa
 Q85/EUvc2PzrTtgGDcSdwG39pusvbK33PKKFHf3ltzG+nEvxCdrXDu7BvzOrhulfA/gC
 9mnqCjYtzzaHaRi/U5bajrJY3eCwrQRzRL5cNeXfC8lAoAW6PBPCuIow9t7mEI6B+ggN
 /k1U1Z16b+HdbtC1ZJ64N9FLRezvjHaZXGoEev1CFCuZqg9Bi7zGUY/UnnAdt/sEmAMD
 eOsPRYjlPs7JB5m+OWrcGQcX5CBc34yqULmr88jo6yyKFmS8fmoPsEtaRCQY3afZpQVs yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmtmk88wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 17:41:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CHeR34094382;
        Tue, 12 Oct 2021 17:41:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3030.oracle.com with ESMTP id 3bkyxs2sap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 17:41:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZz00PvZWVbRMAirMXP/lba2MXn29Z2fy6pliOaQm4IGqk3Hc6KnFRP7mGsnQkRLYacUNnyEXoWjU+5NIUROcTv3c9HpSi9AQE49zWSJ5x0jlClave2dmO6GVXkKhkXyUnKVhUsiFShUhckiwAK734IVp+KfCMyT3TWIVdVvrHauLGELSC3RTlI3Y55WBpWmgF4ylT3iSL5fj3JbPNfY434O/EsOuLDLdZtNuSbmL27m62W4FkAe3ayXCzq21k0yIGoDf+wP9grhXShQC7RYrgFkAldaKgaIvS2Bz1ymSC0p01/WSgOo4JpCUyrzpIGgoT826q/i2opptJWNaMSdGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H9C84P0qbQxeyKTW3tN2L9SuFSvJcdQ7vOTbwTPyut0=;
 b=lrys43pi30PuP9mv5sDbBhQMzLvKfoS18FmYM1fLnjdcUp1EN/ZGttUbGodLJnADANuyBf8MpHF0P4Hazt5fFWfBcNMJNt8fCtq1hVIHIFAjgzUR9Xqk5gkJ/DeiSSm4GMOg5Ti0yB535FDeeQnWrLpFUbA57O/GlZ0s64SWfT3UEmqy6jWny+mhwHn5wi00Osyu9bvHDVuDMmkgT7uFGq7hO6gas+58PKxoZVhrxYRPwIES3QvjSZKC0DugKErIri/15t8K71KpGpBdHGl7TmmJ8AvPVIHFw64Ft+mwoQNTfgTX27CqfZcIWAc0ECLmaBp5eRCxdm5ena+C+q2AtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9C84P0qbQxeyKTW3tN2L9SuFSvJcdQ7vOTbwTPyut0=;
 b=DV2jZrA2DV3TNdGVjA99uiBOUMOmqMM2eqC8zO1bbWgzgNlgEUwjZLYQFEkGaBcus/Up9L85ZP2+9FTWbfkN6S3LwaSSRlSL4MB0d5stkbRPHRp7O+//YEp5yBAHTePyHr0XV+zVVGdy8MldHpODbl+RhLbVH4s++DwPI0/Pewc=
Authentication-Results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5404.namprd10.prod.outlook.com (2603:10b6:510:eb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 17:41:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 17:41:22 +0000
To:     <peter.wang@mediatek.com>
Cc:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <jonathan.hsu@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <mikebi@micron.com>
Subject: Re: [PATCH v4] scsi: ufs: support vops pre suspend for mediatek to
 disable auto-hibern8
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ee8qqgy2.fsf@ca-mkp.ca.oracle.com>
References: <20211006054705.21885-1-peter.wang@mediatek.com>
Date:   Tue, 12 Oct 2021 13:41:19 -0400
In-Reply-To: <20211006054705.21885-1-peter.wang@mediatek.com> (peter wang's
        message of "Wed, 6 Oct 2021 13:47:05 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.12) by SN7P222CA0017.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19 via Frontend Transport; Tue, 12 Oct 2021 17:41:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c0a5369-08bc-4d23-ee9a-08d98da781c5
X-MS-TrafficTypeDiagnostic: PH0PR10MB5404:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5404906B59CC494ED06D71298EB69@PH0PR10MB5404.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MmO777fWFEyzsCWbPPix7GboCLeLvTjnWQCscFd99fWdLHo4DjvwMMh0SrfxUbOMjkAEC3mLJapZUOWDsLvbdONhtPMvynSfbmljMpVOZxPSGwXoUWC5WOYSF6gDqtuwJUGYWRR37BFmS8houwyPNRkmzNW2Ni+DDvVxMR33QhNRpYAPPBKH2U/aufN3IzPlGsRrr5zIx0FZ9gm6lvRpPavOtQnIz2b2/h40bj9Y6yLTVy3PmXYDpTDCNBXpD2lbWks08xY5kFl1KOgWEK+ALOOevNY+BBTWEGuL4TWwBGBJczSizx8RYj+AzJCi7fubesPzrCo96W6MDnpHJnpnA8kSuKql3+SviZaEcTJ75XWpxzlSylUoOqX6Q07r8og+ANU6DXNQpbZg117qbk2HnT4tSWI4RM/P3gq+WuCaL5M4Dgdg0UPaafctGjYrmAkHM5iLE/5w1oeQtlrl0asw8u1BFIrF+W7pF9IrSRE/NikoqGwtOi3U5GEGXQDc8WF8t9Q+j9rkH/cfedbDPXvwxQHzLqHsURIQMN948MODyndpuq9hQVp3zVLf94cm0qKlZJbqXRnLfbGOd7VBXKa6WvF70gv13KrK6H/bh8OzhOFO8d3iMVNJrM34Odt65evII4vQmzEdSX6T4ALcPXH59BLduG7rhTGlYHZXh0oh1fLnmiRhMTbRClIqZdZ4ASIsUALJ11o0+kPGnuCuXPHzUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(55016002)(6666004)(5660300002)(54906003)(316002)(83380400001)(558084003)(38100700002)(38350700002)(956004)(2906002)(86362001)(4326008)(66556008)(7416002)(26005)(15650500001)(8676002)(508600001)(66946007)(7696005)(186003)(8936002)(36916002)(52116002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EaOLaDcEys/NwH7/2HMMRN9GN4r/9m0y3cMK/6SekALGrpdT32Q3u+mMrcLn?=
 =?us-ascii?Q?ug+snTtZshY3qi3kxd98k9s37yphjCiecfYb/HNu4ukoLex34XwdJcoWR/wX?=
 =?us-ascii?Q?0q2vxLWpani6GWyUagDEbrdN91pxD67REyReG3twKY4NH4+uZGBtSIkvC1LN?=
 =?us-ascii?Q?cQ/lAza+HBX3oP1OOGbVwnwWt4BSfm3KgA6lqqhlq7rvyBdc+nVGfcUDC9c9?=
 =?us-ascii?Q?AhEvFmtifAaBVzLRKjd7Qc0ETdjFw109rPVxjQUkQWaoBxNX7fz3G4KPbXYn?=
 =?us-ascii?Q?09mbBSuqzpG28H8xu6LGmqXKJ2sznMGZf+5+m51L2Ozb5oINXEKu/zwplnDs?=
 =?us-ascii?Q?rmG2F40yz6geqaBgRSsJrGqXXrN+rMdS/zJgranwAU42CI9RgoUhL2COvEUp?=
 =?us-ascii?Q?mXZ8q1jAqZLtzBInYe97deg04hABob7lWd3O2m7BcUcRxFntpGvRdooqm3VE?=
 =?us-ascii?Q?qPFaHXmMw2fIZdzTGNga361BPmMxlAL3W6uuqy/va6L9p8wmt48/ru4lu8Co?=
 =?us-ascii?Q?zKMgxgI+jb2Gop02tMw74bL7i8Ry4O4E4LRdxW7fe/4dHCgK7JFZJejA4VNq?=
 =?us-ascii?Q?6Sl4ma1NSuqLR1SeC0bFYYbXLkY3ZGdRe3xzaDB16ThZ8hsY/BC/nraQpZq0?=
 =?us-ascii?Q?12wnQ8rDUlDTp16jYYZxUfzugxyFfTveE6EbUk4GPO8LuZo+l2BSeyiL83gV?=
 =?us-ascii?Q?/GIo4YihAiCMTuyQs0H63GRMbVlde4xAC9Qk/rUs6iWQsEu1tm5EpzNRFBbM?=
 =?us-ascii?Q?YZB7ihpokKEViWTA9+ncU7pT2k3kkEpiM2kZVvQApT3nirnVbJ6hwHPmbA+h?=
 =?us-ascii?Q?3+1ZiARc0JlSPoOgHQ8dwkt5QznhJ1iROkyw3/GtKC6m2MZCpBf0GVGEQf2K?=
 =?us-ascii?Q?3WdGh7/HWy5FtmG+aLlia69ny1c/5Cic7TRWxq9q/CBqo130aHXYSzAcHM+T?=
 =?us-ascii?Q?i6iZx0xypxIvw90u7LkJvu+yYStqWh7RYhdZg1FFKKAs4gwaWkSR7aUYBm6c?=
 =?us-ascii?Q?lGvvAmE9Ej7LBKjlscaMYnySBXrk8EYfE+EK1ja6Jzb0z1tUO5CwE3Z1KG94?=
 =?us-ascii?Q?JRs+Z4241+uCJacKoCBxQNfzR+X74pR/6fAkvhSdbmgNHVAmeUYxUdDZh+Mf?=
 =?us-ascii?Q?YYcfvVhB9gCY58VmyIc8U2nZyayBWOlXRsVehWVzwVxrtVCtzDgGxk32K844?=
 =?us-ascii?Q?z4uh+OuUlghPtE7r1/1INqWN1rBlFnwrRkj4DxEP1fCvoBntXpOdBhc9wfDE?=
 =?us-ascii?Q?qTACpn2wfw0bXDNFeUsQLuVMWCEe1WcEMICDKE0oxpRzLVqZMe49id6btBXe?=
 =?us-ascii?Q?CLLN7g8DhoLV7ssBfpg4Wf3P?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c0a5369-08bc-4d23-ee9a-08d98da781c5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 17:41:22.7526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6s+9qKpjMxBM4POc2MVXQso1+h9nzVVMurLxJTCwHYMUR+gQy6Z3jPynrlLLFL1VXiMLE5ck+8b5CfUQrMScz54jGjCqKDoXXe5rrmpm8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5404
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=830 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120096
X-Proofpoint-GUID: Teo1Zg1tLxJDfgR9WErTec4AKKSyMMG0
X-Proofpoint-ORIG-GUID: Teo1Zg1tLxJDfgR9WErTec4AKKSyMMG0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Mediatek UFS design need disable auto-hibern8 before suspend.  This
> patch introduce an solution to do pre suspned before SSU (sleep)
> command.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
