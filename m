Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B16C07E96
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E400610A0
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhGFSmK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:42:10 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14354 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231208AbhGFSmJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 14:42:09 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166IWKrN023178;
        Tue, 6 Jul 2021 18:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=0EJJkXd6CLrTBsOf421Lr1BEBzGuDx/I90k2m/dXZm0=;
 b=Iy0O2sngPRKIAjgt7d2guq/HgGLGCH9SBihL5WsdPTFq2uaeHzUJy2kXrhryTLqXDwUs
 emHt3TaWu7Qk/QbuocH3kdqLqYBUIXBCNhgU0desVIUcRaF9icyZR+hxYrJX07AjXf3R
 NQaWnTUlO2UV8rn4UuXye6JCBS3g1sCpkXvprfzTsQPGhEMudgYt4Lh5C3Qof92PDbPS
 aCYiPb/rSNAybj1oiuiqcv2IMNUs1sXZHRb3KJO6iKZMTs2YeLGJ+xtBZmcC5f25IVCq
 qGF6GeyoxxdxBifaZdZmyGPwLUPwFXGOq/PANXoT3CyFd0sGq+NFwIIoC1T3YMmKwsKy hA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39m2aaahdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jul 2021 18:39:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 166IUook008736;
        Tue, 6 Jul 2021 18:39:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3020.oracle.com with ESMTP id 39k1nvj1hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jul 2021 18:39:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cD6Lgw+nsxCAylWTN6T/8rgPAs8hWsYITEXg+IX9TQrgz+H/DIcXhekT/VXYfkILqZvi2m0/wXETK7+FxbXG+YzSPB+s1+dpGsI50B41djrBFw0G8Sv/t0UujcxSItv/No6AM5A68BIwYd8R/yMvCAFUyVm3GA2xy4M6xlvZDDoirPVLUwVZSRvZ8RFq1tTmPMrx3VwHQfzgvE8PpYFGvsapVY04cohTLSGCqh0imnZqbGXdiiF7hzhYzWMszp1emrl1IqKuMgolVurh/w6oySydIjLCM9M/mMAnlNRigrdWjC71vGulK2VuvoxBzbkBql9gsTDBQob0Wm+/FKrlTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EJJkXd6CLrTBsOf421Lr1BEBzGuDx/I90k2m/dXZm0=;
 b=hWNp7fQD/VsAJg2hD3+bvUggjaouGHS4R3hQsdWUOL+WTU+eoTb4gfdR76lIcWH0Ce0WzHzZ89uK2C8NGSbbEuvhWllBqOIIqEG4RA0OJNIQ20ss1VGRbzxZ99GzW/X071LrW+0/1C5A6tPLB4zxfRHZeOIzndwtK9DpAaIdxt0xfjn89vG9KzfvaFKbA2rt/dMkbsgmkBxnRJR8MtFLxWghxRTpH7EK4UNFpI41MBAec/x5HSjtG15JWIUS1xe62ogf4MPsergZzW7KdItXyW9nOdmBvLz5h3jZeF+iOZfsAuOvJkkdThw0khdCPdpZGsSKpGx+fKtGiFszDi4ewA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EJJkXd6CLrTBsOf421Lr1BEBzGuDx/I90k2m/dXZm0=;
 b=Qb2bmMjXzv0EeqBt+8R2hMIiWAEVyJtafxHWjOYMIVik1YSrdESg0BGtvHCgOiMeFGNNKdXcdX4QxHmnUXPx9/B+2WZtltpQS73eFCtzuECsYg+Yv+0xs+RLCcqHI4V3LozS4cMxZuqv4ElETk390QkaYzrrsr86cuLwAAYLLu0=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Tue, 6 Jul
 2021 18:39:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%7]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 18:39:22 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] mpi3mr: Fix W=1 compilation warnings
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf6je1fa.fsf@ca-mkp.ca.oracle.com>
References: <20210629141110.3098-1-sreekanth.reddy@broadcom.com>
        <yq1czs4jvul.fsf@ca-mkp.ca.oracle.com>
        <CAK=zhgrV4BwY2VzhGN=BbFj_2DutUUnD+33dmGqbN_ivz4-0Xg@mail.gmail.com>
Date:   Tue, 06 Jul 2021 14:39:19 -0400
In-Reply-To: <CAK=zhgrV4BwY2VzhGN=BbFj_2DutUUnD+33dmGqbN_ivz4-0Xg@mail.gmail.com>
        (Sreekanth Reddy's message of "Sun, 4 Jul 2021 22:39:37 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:805:66::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR08CA0019.namprd08.prod.outlook.com (2603:10b6:805:66::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 6 Jul 2021 18:39:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69cce786-aab1-4088-7b34-08d940ad5f69
X-MS-TrafficTypeDiagnostic: PH0PR10MB4727:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4727CC0BF4CAE4DAC4169BA18E1B9@PH0PR10MB4727.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aqgnsPkpRYq6Cx8jUhLzXOrQPtn2uZ4GdAbEzrmBTrdjsOU9itZDcrhcVzh2PVV9SEsdzsIjSh1Exh5VXxsoZlZn42uFPDmxfgm08XGMoUc0Jbv2Pcgkcd8w9xUfU88DamIX27N1OkAcElYnI54IlcIbffZT+a1Rgs1Z4j6JplNroKH5HQgfN70v19PB6/r3H0WqcKATMy4ZY2XuKh2/fhFsZhU17KWJ8BbkXEC6hyFt/XmHopv2gh60AyMFehiR/uI6epgS8N8089mMCQ5ugD63d8t/bhKTLSJyO7eW+L3PvAJBH2b/akq8DjmD/oG8iRGWWe26k0BqwF2CRtBuVViw6lv+IXb/rfgGqHqlpLPt699FHEKQ3YZWn8GHY6x/YpGeUDxmiZFHr91FohRy34i9GPtiurAR4Wf8VPJ6pqVF/Xj4r4B1/KimMUEkMBAiNC/D935Wy2zrhUE3i7V6qDL5Cu7deiYfCy2ti75LDRTxxXW5OTHUnf3y0dljOZ3n9ci3gyMg7419gw14nQD1fsD6gA41rAV27qaIHxyiKh6gvE5QLoElJZAf0fdegrtzHyaKzl70wL/vEenn8FcRdghVqKIXk+GWN4W42ADp4/D6/wfTdm+OkpxJLUxVP6yqjN8tSgnZc9paCRjdcyaERfl84qEcxkha6N3Qouq7Em1knbSDjVK5jhqvh6OphR0lkwenrnC1/hoKmk0rzeJ6h0KIqcC/U9K4gJgzEzc7wuM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(396003)(39860400002)(346002)(55016002)(83380400001)(5660300002)(36916002)(4326008)(8936002)(316002)(66946007)(66556008)(2906002)(66476007)(7696005)(6916009)(478600001)(4744005)(956004)(26005)(54906003)(38100700002)(8676002)(86362001)(38350700002)(186003)(52116002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6tZkVFwjxSX4l0+dhGZWcuRt7WDDwcxjAWUmao7qSDhTUtUrr6zkxaeSaoY5?=
 =?us-ascii?Q?RiqRa/ALbXBTXA8WRIFtE36iIUBzavcVN6vb3XWpBdq9KTezuH5dwb4YISBh?=
 =?us-ascii?Q?wf69q0Qe1Idi6hybRThwsuNCtJxjS/RRqpcoi97HMVJmM1CRzWcGcEjeUMD0?=
 =?us-ascii?Q?M4Dy/gyl5xn5prRUcQ8J9T2W4/v58Ryb4mM/uIVUEUM8OR0gYn6fiKp1QhtS?=
 =?us-ascii?Q?S15eJ4Au2jkywPJbvkmWADVrA6QMpB18SRepeJHHCq/uwo38k3l8XIp26BfJ?=
 =?us-ascii?Q?IbyhWm3ITs1tTwvAiO2BZIMylryu0XQVlvZdG9ErurWMD/Qe26YA0KtcFNYg?=
 =?us-ascii?Q?LpoeMcK601rb6eNkfU1Exc5nCR9t9TyGNkhUADoM+6hiGd9oMktd/KtATGnd?=
 =?us-ascii?Q?KBBacSRr6B4iOnNIuzvMnshy8TkIkJGMUhabG7iLvFzkLIg7pdqHR+8PIXLg?=
 =?us-ascii?Q?QEhNXa1FVlf3ALOVayVIrOBfZG1/ndT0b85d/XdJLP4dt7ipNAoBDNcPqnTA?=
 =?us-ascii?Q?ytPOOHvuo+EoG7gmATdwox7YT4SclducFywUNDdb3Edro3NSLNAkG8Sn6+mw?=
 =?us-ascii?Q?vzKisQzDR2msbM/h0SSEAgc8+m0ODCPlJjw5dEGHDahd0SRybkeZwGVAuXuW?=
 =?us-ascii?Q?JclQNlhRTMWPO2FRMNYTPEUdYyE6CgEcC7CuhkswusllzbX+eR3YIvQ5zILo?=
 =?us-ascii?Q?fDy/dCIHz4LakFyL1pogWnCJ/OHxPWGSN49ff+LcIVRCerN9CR6xaRgbQDyL?=
 =?us-ascii?Q?umIRJdLbBbKgAicfsEExBgHNyPZvD2LiAv8y41OU9bxSczQNh/l54vTD+862?=
 =?us-ascii?Q?qG58Kj/YbrLenO9dapfA5CBxPBbeWvaIx4Z40+3QeO7ZkHoBX9rpMKkjBjve?=
 =?us-ascii?Q?X278h8qAVXkzNngAA6cpkKljTt96O1iub7PUR+71SPTa6ahf6EEC9D0UTkd1?=
 =?us-ascii?Q?VJH9wotRVqvOEIh6pKkueZKRr7gxYslM3/aVXLDtn/dKmjGIJPx7g1e9WHkx?=
 =?us-ascii?Q?MpJmZ8OykT6oeACcakQqM/piciizK+gERWv1SyGvy5Toi+kJNX/LxNzUQISO?=
 =?us-ascii?Q?E/1aMIwkFUpyJrCZqRAzfn8GE+StKwrDcB/Nede3hCH8Q/M5P0K37MkPiLyR?=
 =?us-ascii?Q?XYwt0vjA9joa4aNgeCxId/mENHZDraowilUPlaYs1c8ToGvdPDJIkrxAfB+4?=
 =?us-ascii?Q?QMbcKbB3p7aJYevJgnwtcqj8QfgdCHVWqTRBBuFBS/PxUlcdReBZwvkjkwkO?=
 =?us-ascii?Q?4tUsPPWjz0PMuAcGjicYQheZxeVvx7d/AjwPjYbNFCoDohpNlAap1SSR/I3r?=
 =?us-ascii?Q?DPtRkhfR9bKBW6EBTEgNipLz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69cce786-aab1-4088-7b34-08d940ad5f69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2021 18:39:22.5606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tkiOO3nlxLfqcFPBfC8I1uT4iUtKwtj6z+jIFRO/r/HyCgJWbkU8r/EcXZ4Qp7oiGa7UFxvSzU4oCtFgrYQBH5XzHLNjrLmL0Qs2FvPGuLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107060087
X-Proofpoint-ORIG-GUID: wLYKKgi5ZoljLvHrm5HvXI5Bb88lNND0
X-Proofpoint-GUID: wLYKKgi5ZoljLvHrm5HvXI5Bb88lNND0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> I verified strscpy() is not adding any null terminator when source
> string length is greater than destination buffer size.

That's odd. The point of strscpy() is that it guarantees termination:

---8<---
/**
 * strscpy - Copy a C-string into a sized buffer
 * @dest: Where to copy the string to
 * @src: Where to copy the string from
 * @count: Size of destination buffer
 *
 * Copy the string, or as much of it as fits, into the dest buffer.  The
 * behavior is undefined if the string buffers overlap.  The destination
 * buffer is always NUL terminated, unless it's zero-sized.
---8<---

I tested it and it works fine for me.

-- 
Martin K. Petersen	Oracle Linux Engineering
