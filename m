Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8863C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CBB0611C8
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbhHXDTY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:19:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45030 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233885AbhHXDTX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:19:23 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0x9ou013542;
        Tue, 24 Aug 2021 03:18:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=OyPW6Qp0ig1OS+77PtG7sq7nJx/A50Dn4oKeefMUGJY=;
 b=ferDiunIJzv5ZpF0ptdeDhsGl1aq3eKS/QyVN+rTdPupgxNQiZ8Fszn8pOR8GKWAop28
 4VqNZwIrHkZ0Z+Zmbkyb5/OxR19hj96XFr4/yd3E50m2mqfAtMvZB753L6oNfuKeLCpA
 Q5t71E8ShfCInQvdOjpo5serGxGPIsck0iExF21j1XD4u40qlyOqjIcKkW3CTWX7QwYQ
 FNVXxjDtXsvOqP0cNwid//Q8P8P/dQtBtCG5BKk9D+Vv3FVMESW4zICqCnH+86d66E95
 cFdbSz7zp4FnnUHxy77Wr0yXlscxQMuTi82DA/dYvL1V2LGxgW0jkzSSsF9MKbKYuQpD 2A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=OyPW6Qp0ig1OS+77PtG7sq7nJx/A50Dn4oKeefMUGJY=;
 b=CcWYCCFKhz5YCIg3OrpdRPwd0ic5RQsowLYVc8o8isG+v3CxJ/MBlGJWNBT9prHk4YZp
 L4Vm+cJ06rIafVBTIyecmQk3kuRMRqpaxMuqbEEhv4osnQmVE17Nro8VBbMT9bYyc3Q8
 xAvLmNrcIXqhrZM0NuuFpKeZpRUIIaQIkJKBZ39/z47uDED6qhgfXTvie/vgBJ6qOkYU
 Jmr79Nzv8Rbr3usvovyXfo6Ok/EdoDcpeEYCDzPk6iG0VIX9f8CJXpii7g2a/d2sGgTJ
 +CwbnyJd1IfN2yia0si2Ff7LPukBjPIJjnphjUjso4EpWUIgyHisQo+mk1yg6zOwEwnT pw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akxreb1fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:18:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O3BI6q030153;
        Tue, 24 Aug 2021 03:18:33 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3030.oracle.com with ESMTP id 3ajqhdt6xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:18:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/0/5Xd7l+SmMOk/ncuvyAItGJQ3Uuf0pUNn+9bwtr/4NQMMgXN6+bWBenJbJOddWX9oNqdGKYIDEJ7RWADobsQFMvUlJnbl44ow4CFCkBG5S/AVB53VPD4dLkw6moD5QUm/nj4QruLotQdoIUTygaOEWdwJweZwWuqH3v5TCxb1jpKV2DkD5HmlWmeupTWlqQKOPRu/7AiZ5yRNp9tyRQ1+AxLY13ZKW1+AMaZLy67HK5t8UhhP1E4XDibooXKBQf0DKb3sT7BP1m2pFvHOBl1ufFKIlkqLatKb3UdxoHVGJ8WBzGi3LMFdV9tuzAAOLFw9WPnPLho3HUzLgyUR9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyPW6Qp0ig1OS+77PtG7sq7nJx/A50Dn4oKeefMUGJY=;
 b=nBk7B/tBreXGQTTj+naT96ZATd+so2mfC9NYabuEpW3yICE1DCOKzGX1VO8S7GOlykjSg9yLPIlafHqYumffMRrHAk994NsWt16g3m4DBSWMtNDtuZOROc0PIG8rSdtT0K8esGuf3NDgcOocSHWm13eu3QwJipn8/3zqZl3xmH7DfH747LZQMP/QYp+wH3xLZeb+iS2zdCcPEvaD9p7odIPrTEjfebjYbp2N6kqPYcqnmNkrXC8Jm4hlZnX1Z5kpXwA+y3+YEEOEDO14Y12QXCHNxUl7fmkYSAEw+Q+nWSG4HeYWeC+ZTYSPB4Hy+GPoxn9DMFCfRo6Xgk0oByKKUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyPW6Qp0ig1OS+77PtG7sq7nJx/A50Dn4oKeefMUGJY=;
 b=m3bo6/gWSxLGbHL1I979L/x7wDmZNykvOIZTrNZP7U/xR5YjrBVD+JcSKz6z/EjS5MYtoY6zh47iy8s6TLIXSPZUfwPREbrQa1d4cHmxkJGhbqdlnZ3T10VOCw1iJIW/YCmZKXjQu9rLiefjPC/NeIBq/SmaVm4fURPynv04hwI=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 03:18:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 03:18:31 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/3] ncr53c8xx: Fixes for SCSI EH rework
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kbffs3o.fsf@ca-mkp.ca.oracle.com>
References: <20210820095405.12801-1-hare@suse.de>
Date:   Mon, 23 Aug 2021 23:18:29 -0400
In-Reply-To: <20210820095405.12801-1-hare@suse.de> (Hannes Reinecke's message
        of "Fri, 20 Aug 2021 11:54:02 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0182.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0182.namprd03.prod.outlook.com (2603:10b6:a03:2ef::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 03:18:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dd24426-10ce-43cf-472d-08d966add979
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4422CEE561F9B3190DE7586E8EC59@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3nR2RUXeXX0Z9vDVyuagBxmEwxlhexTt4mN9x1zGM+F6jWgPL2xX8UwHjTVgw/Q9ViUmxDd3gXn7mmO8VQwymspAyfzz69CH7L+BxMeXyUvZcC3ziRqpZgdWY4zfvrExx3D0y7XrpROAqoX6KJCyM8907g4Oa+yjXWpMF3bdXryKmQGrVFqLVP52oXvsBQns0Xz+xlcqPH8zjVj63qXp2TilVgRUgcixDyzXq3CQqw/ZTpQrHntuDvu6vG1bIedG7faJVY/UbUkiLZgJmad8NJGUHyXkIk6HsFwgn2mRh2/RbWG6v1koJMs3HUcRmoc/5hWtweJV9+mdJySiNLryYramoLR0sWCOtg1+Qo+3MPYIp3EV9EFQc5sk+MVQNM78VZo1KOjX3XjQwNffG3sx5kAWlYVoRPhxETX1U72PSFYraofXzrfXMaTuF37gX7pMcdOuS/LDXpuiouk4TmFEVHNwdeQHyE+MiQNmrYw8gm4DoN+phn9M8fNPZ7+H46nL7osM9QebIzwN3b116+eajVPA0LKsf1o7JZCiYsug/SY5SdiXDvZJLeUzFmEV+25RvfB/CqJA5i9KhojwtNmVYl1QKKZqCvig4mnATjFp+2G3ASMQS2uSmmSNSjHwoxMpW7KDROCO+CElUbrQD6Zi8eXCrgB0U7+rG/HAvFCs33nEekFviYTXVXIR2FphPnSkNpzKJJ4SulWOgB2Y2Pi1lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(346002)(39860400002)(136003)(66476007)(66556008)(4744005)(6916009)(52116002)(38350700002)(316002)(8936002)(186003)(956004)(4326008)(5660300002)(2906002)(66946007)(26005)(55016002)(54906003)(86362001)(478600001)(8676002)(7696005)(38100700002)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q2kq7QXtQXM11kayW8VP+0y1rXdN6u4Qt5c4oOFjPx/5xT2BB6BPkoHP2/0m?=
 =?us-ascii?Q?WMHz21Je7yZhk6SxKNq7nbp0lFKYwjX/eC6J5cYgeF9GN9x7TpCDLhGtaMwT?=
 =?us-ascii?Q?fUi3xp/mnJr6ZmTDUZDgi7WKgIg9gLbMF6nBvTiPtuDHAXe6JFA07pXAQ0lN?=
 =?us-ascii?Q?5pGStwGHa3ZRMJvIWET70VdGIc4kYs6QJyUf0k6C386xFStaC2TXwkrpdxzL?=
 =?us-ascii?Q?uLlxmBz2e39osYn86CSKpkP0cjNS5UMXBYzfTiLWxY+zD/ReXvfazbU8Iy3+?=
 =?us-ascii?Q?M/lCaHOVkynGngEmby/vv+3l35cggDz2hYpGVCamR2WRYfYR+zpVZahiStdU?=
 =?us-ascii?Q?Ecq2/jVO35x3jARzWswEEjsmKposAHGiTeT/nAwWVGOZhbBbgpWj3DrmHar/?=
 =?us-ascii?Q?DfXR2mCWppm+dw6dQ8ak11Xe4NZ0Yg0hHTUgv5RGOZZXOEo003XP61LgCyuU?=
 =?us-ascii?Q?md2/4R9dvP26jZbyGdKctP7c6dygHHBvDtsPgpmk27w2O4nV0JgLpO720pb4?=
 =?us-ascii?Q?uik+Zg4gOMuPEvcEwShUD+pCmdhllE8FIcI8bGD7hvD7DIXdhJR9a3xCXbhK?=
 =?us-ascii?Q?KJunha1drSsx6ZqPyzSGes/nQtYNPOY/kjLW+MFLswEf6FZrV+YzDcLc9cXl?=
 =?us-ascii?Q?jH+WxnNpbTnvJ1TnMBCAC58Cc+GoPYehs0OCIpfdT2ip4oFrj59+cOYoi7b8?=
 =?us-ascii?Q?zBN9dI2ZwwW/50gy1X64/dtDEhJ4aBAph8RhejttudvXUBS/KLsFeD38+GjQ?=
 =?us-ascii?Q?zsAjABo12kF/PmBz6UR7AKGhqGqpQn8+za+HEUq4QfPB/nyLZLNjwoNsIy/n?=
 =?us-ascii?Q?JBEmPg2Pd9ogF8UAzjBJZfTXkYjxtFWADiJgfUgN4UVPHvd4gdvuVqwxCInp?=
 =?us-ascii?Q?jIDB0YO0e/1AxHXEAWnCf5IzkM43Cvp9HNhPVi0bkgoo/jIKvFwg4dymlz/M?=
 =?us-ascii?Q?2vUv/qcbbQSHVLPIEjsWROMCZ7Qbmvy9SAZOW4XJj1dUIXT30id4+5RzbNX6?=
 =?us-ascii?Q?LcsjFSnmCV5zJD15DMzc/knwVl+FS9WFQ4GbF493KrDtM0OsfSyNj5aJtG+6?=
 =?us-ascii?Q?i1zgldZreCsEiDAeabt/+Fubb+GaiG9PMvbPXWJ5CF9pRHaAWpTGHA8KoMN0?=
 =?us-ascii?Q?F9cYhCfXufMUrHcvB/Ld9pxXGcPdJrR0q1W5dGwCApM10juGnOflDLtainET?=
 =?us-ascii?Q?QCWc6yYruy1l67wPKh8F/PwGrxEEGcSF/r6+H6FaWMy1JoDzOgJWjl4lcfPb?=
 =?us-ascii?Q?zspEQ2O88r2iLGZ1ill4sY9i3F78LP5YKtJhjQn6goUdfmVF+ut4EEHuZjYU?=
 =?us-ascii?Q?uanZ2oUZjfALNixUOM013dAQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd24426-10ce-43cf-472d-08d966add979
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 03:18:31.4421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YNuHZIwIQwkhTLesQSZ0MyE6PsMikSm5ZIYCt9roWiDI8WBwnImcrV+t97VR9KHiGzZtSY/SFKkEx3vUaSK4isIxl7EjAq8V4+l7Axfemh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=946 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240019
X-Proofpoint-ORIG-GUID: 8MzoGhk4lrqTqmcuUKoTbud1zIOdTbB4
X-Proofpoint-GUID: 8MzoGhk4lrqTqmcuUKoTbud1zIOdTbB4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> with the SCSI EH rework the scsi_cmnd argument for the SCSI EH
> callbacks is going away, so we need to fixup the drivers to work
> without it.
>
> This patchset modifies the ncr53c8xx driver to not rely on a
> specific command for the SCSI EH callbacks.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
