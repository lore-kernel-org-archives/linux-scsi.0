Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D622C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45753611C8
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhHXDV3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:21:29 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:28764 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233681AbhHXDV1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:21:27 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0xE6v011513;
        Tue, 24 Aug 2021 03:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=eun4OliDq9PjJJuhAxhk8FZm7/syZe0FupPa6glyCQA=;
 b=L9evOn4g3utUDeUrh1vM1VZset+89DHxLJpqrTNuXyat0MziCLXWNXVRGX2BSvFcxjyB
 N8JWdZowkoAhF5ys8enOO6OAGtizZhsniLaaz/yfAJ8MPySgLHaoo+XVegFiakV3+MBU
 HR72aYDo976qqGv5rwZcIKrq7X/JPN+QrlUtABjbnUm5DmoXZXSaUt3+BDGK2nAjDPO4
 ISSyMMizxIjuMrF+b5nfPFmMUcFujZrodTXodiiF7cBXDcwIrHAFm60dupfbUBAtvwuz
 7gFP8/KI/uFwn3DGAxIRlccPIke3D5RVaaJLeUIbXCMmaJ+V2EB+F/LZBBvNIBSv3s5k Bg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=eun4OliDq9PjJJuhAxhk8FZm7/syZe0FupPa6glyCQA=;
 b=LZqSvoNYFArRSbiQ7H7YmDOJjq+yeBnhtyB6VCm99Ue4H2sqdrxO6Up45YpeWc0KuPWD
 MD5W9Qgtpev4CbjkzA6FA0E6nBYpLlR2K+RydtKT9i4VPmlk1EC58SUHDgKqso+S6MrX
 ntg9aohX/33aj4kGOWPH4lEO+RqVi/35KG6KSenJOrY7VmTWVW0RWmPZejal2GhY51MM
 I477AGROp5+jhbX5M9/4kbbVQfD714bQGBangitHd2JJv9kAi4zqnSIZoglX57uvbl68
 SuL6zqs8HyvJPPbIsUT9O10EFHmY2LR9SRphUwmD02vcO3y/ZYrSzvbtZVwrBjeuwZGv Cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akwfm35ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:20:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O3BUIg145476;
        Tue, 24 Aug 2021 03:20:38 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by userp3030.oracle.com with ESMTP id 3ajpkwetxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:20:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HbYS801ZkCBiMDnWhDV9Q4rWwd9RZaevyE0ZlkIiwkznV/Dffl8lM4F1umU9Yehzve2d+tVawzNDFmywy1iXaweaqzDXI+Zf2O9B4JWu8GnC9hY8TlkP7+0xwcf59Cskln0e74aREGzPbWsLOcSg0Djn0hm38+DCX8MxW3e8bgC+AdHbgsGgKfZlQTiuAZmWotOIYXeXpWMpEoOiCgjI50ZtwqIQmtFfBWuZqVQ/WwbKH7k6ICI2f7s7CHhTICQvyuJKfOOOqy7IC3UySooN/wixI1XWeBNsHgOMq2f1x/zxZuXGHomQjJjdYyaUPDAv+RwAtL6af62/y7pWHkLSQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eun4OliDq9PjJJuhAxhk8FZm7/syZe0FupPa6glyCQA=;
 b=VyMBGthWzwvfte/i6/DRk2prbyBhtu27J9Rq8Tg933fMtwXMTI7tYJv7Qov/ArPq6buwu8Bb2Ph8NqixSr52aG0d29Vjz1l5/bTrIu1COkHDmstMwEcRExBj3qsPXibS5QW0x76+fx3L2JyOk7/u+bF+18XRTJY+YC4f41dFzcD6KsfHa7ynAEmOrjdn+we7+hDcysqmOWD+6C+IyCWcVjiVJxX0FoN47jNRV5QiFeEuqrLKK5uKpvg9YVCt14LbvaP8QaorcASCdorwurmu/AX61jDRPC1DwspsSleJ+mEdAuO3exqXfkBXI7A6x1fuvlSo3z1Wk+iKJ3XUroKjzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eun4OliDq9PjJJuhAxhk8FZm7/syZe0FupPa6glyCQA=;
 b=ydngH6p57G0PCFYL/Pl8v7ohTGBcEhq7q4eVSc3J3Agfll68sufySMQmLkxsEhQqXDvZgrKau0B8jXVyXuihAGsu826HK5xQhitLTCbRIadVcJ75uC7ua7S+QZ7kmbnz8ld63q+pyhoUgAdGqybpHd35nATuscj0G1HYbjip6Bw=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4566.namprd10.prod.outlook.com (2603:10b6:510:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 03:20:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 03:20:36 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: Fix spelling mistake "progres" -> "progress"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y28redg4.fsf@ca-mkp.ca.oracle.com>
References: <20210820151835.59804-1-colin.king@canonical.com>
Date:   Mon, 23 Aug 2021 23:20:33 -0400
In-Reply-To: <20210820151835.59804-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 20 Aug 2021 16:18:35 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0036.namprd13.prod.outlook.com (2603:10b6:a03:2c2::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.9 via Frontend Transport; Tue, 24 Aug 2021 03:20:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6356c33d-f181-4557-e61b-08d966ae23fa
X-MS-TrafficTypeDiagnostic: PH0PR10MB4566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4566FAE8804B678C091B10EA8EC59@PH0PR10MB4566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xIUWy/hE0OUm0SY3NkgaYXmaexLots1ymGI7TA43frD6s52yitG/xwpGbgnGseF9tx6PwE3ddw+MgBDdBqW11h/PgRYG0hTojD+obNbl4skz8fDmQpHDA170ueqTytEmQKBSxweanMyM2dWsANroZwSQr30kHXAx2A8MrL3y1NGQBirW9XsrisluFo0QsVyVEtlbWwLatZ+T++zhYtwBRmgezUCKltGpqWh13HTewCdKmztQNUoNhWt6zs8gX5VQD0ABj4c2eZr3LHGKY6ffsxschYxEy7gvp3i5WQKT1qPAKic+U5AUyjB7vth2H+6qHfHL50PrN6FqL27muK73j00EuuasNR6UfFKFMdyyRkbjqpIr7LKmzCxROatgAW+vrIVrqFb3cJdqGmFCmC9oNXA6ZyuhesNgapZFkJYpz6v5xe8hZ2EFgVpXy6O7irj/uklAQ+jPuuXV+NBb4un0G0C07iJXjnBu2Yjl868W8e0nsrEAA4ke9iwHOP3UJVHBvFaYviYcWEZs3ohstlGigMohXEhQ9uNlJ2ivZTha9HmjhPVhThJxUT/HrvQneZC8606WRhgMbwlNpbQqiMNeU7ast3zptOzUUYfTi46xFeS5gNFR8FZVHHTDX+S5uttyjLU6dHCNT8tN+DumI8CpfCqHZE3s2Z0DjZSROv22oFcQWcg8gZlNLSebw2PusjBSCvZkHbtu8QcLowfOgmhwyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(376002)(346002)(66556008)(38100700002)(55016002)(66476007)(52116002)(38350700002)(5660300002)(26005)(54906003)(4326008)(86362001)(6916009)(8676002)(83380400001)(6666004)(8936002)(7696005)(478600001)(2906002)(186003)(36916002)(66946007)(956004)(316002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?spp0HxmpqHKbM16pGPFrQWF37tE5c8KKhhse7UwNsHFaNdCardUfumvxXuJg?=
 =?us-ascii?Q?wfm998P5qKDs0Oz3OLdjx1EII/t2k5dQABZG/zQMvgkcX/rYBjVjWF/T7VsB?=
 =?us-ascii?Q?FLE/99vX1hz3wSCX68VzXIjH5UCUcDaYpjbNz0BmsCitBgfkDUGEbo982Kk4?=
 =?us-ascii?Q?oS728346BWtK94pQK4Np8qmIOK4y0A9wX97o8Dzw21xMGkTbGFlM1eF8fcbO?=
 =?us-ascii?Q?hPrYUjU8jnnAjd2PJhHjyTgHVM8LmpFnW8aZ2goYeSxpYvU5xQy1vu7u3dNq?=
 =?us-ascii?Q?qfA/+W2CMsJExpIimKF/fzvnmB+g+31LjI3Ek1hTu4C/JN+3GBNk3EAp9DER?=
 =?us-ascii?Q?YKMQD3PSYgpcoWLo/a++Le1Y/5g47z94QAICi12YBlS16qEUGirFHjWbaayZ?=
 =?us-ascii?Q?NqIUaT/z9Wd2LVBq2mguPDM+6xVU0BUSsxtNvDzM4Ihf0wYd7bOCd+ArX5E9?=
 =?us-ascii?Q?cFx3d5HWkndQrnwCIxXVpdrIVGvnQqGKDkGwAwLUTREfRvdEROn2k/sPBs7d?=
 =?us-ascii?Q?HQ4wDOzb86emVmxCP6WEeJm+wkyhW8ShxM4X2kPG3C3DUItD77qIO0PbS+iZ?=
 =?us-ascii?Q?eGhPyz5DYRjl5VB8kPrmj9Zu96zS+4JpnXC+RKbVuHp6rN1NgLCPXrhqu4sR?=
 =?us-ascii?Q?8udByEIgOCXxwzAjmuLLYjFGVQfcTMJPwx0/98n1jax5jvnoG2N+AwLQnid/?=
 =?us-ascii?Q?0s4Yape1n4QNKG+7slRwNrtqdrPQo/rvBhlCspYYSTlQnvG/9BOoAcb9El2k?=
 =?us-ascii?Q?+KGxRpsNuzE4bu0WNeUYWx9joSdnStlhciTua0V/FLIDEj/Up5CE9BqOTzPS?=
 =?us-ascii?Q?vtJWCSVKiaI5P4/LjoMeVCQiI8f4vQCquxYzZmZjW6psh6Deq8EFIthX3Ymh?=
 =?us-ascii?Q?jAlUMHV92NCdCUfvKbHCz4FEzMfdEKstYxnyVLkeT9Mfr12rA6Ak38+1hnLj?=
 =?us-ascii?Q?4+HLuB4F4pS3lguvGnBeFgkfoPA44Z40BxhIAlO4EfIdiPuMiK3Y6FgU5bMu?=
 =?us-ascii?Q?js2BrArohQvWZMqhNwLsGVgz2DEbahonRFs6C7kU4kAxDoFv0e2LBlVdGLtL?=
 =?us-ascii?Q?XHSHaNV+Oona0dv/pTe4hFmdh670qKuH7o3Xyp7Cu+xpWcO+BkMIQIsP5xtb?=
 =?us-ascii?Q?MMPzctIAuasDhFUTzpk32UwqkW2m6N9VhtVmQ5/BW5dnwhPXlYLnzTLbFNLx?=
 =?us-ascii?Q?+XUuLvGWPH0Fmfu/klqTRiSlQQ1g5rvGn8V194VPESxL2WEZGk3Ar2i8TFBG?=
 =?us-ascii?Q?C2GcZga63Gzs3GJ/EhbaQhONFodaNOxh4E7kP40ZoWtJtwz/Vy49UTX2Z5lA?=
 =?us-ascii?Q?1f5vhIZiaTx6zQH6Xi3u6xMA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6356c33d-f181-4557-e61b-08d966ae23fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 03:20:36.4968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WL71EUDL3+YwKoo1pdBiiOMTK/Z/8sCLgolRXyqNsFX8In6ZG0Rw8IwMutS7ooKX+Zi3jnrS+CytiMwffrydj9vDIc4kE9enpB+h90aaSVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4566
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240019
X-Proofpoint-ORIG-GUID: eunoCjPvZp756kBBGoDm1AkheCrkQLVg
X-Proofpoint-GUID: eunoCjPvZp756kBBGoDm1AkheCrkQLVg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> There is a spelling mistake in a SNIC_HOST_INFO message. Fix it.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
