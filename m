Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16CFCDB465
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 01:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbjJQBDF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 21:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbjJQBDE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 21:03:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6066C9B
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 18:03:03 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GKO2m8011094;
        Tue, 17 Oct 2023 01:02:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=CjYDbwpqZ1X0FZSwMglE6oYK4owQjyIoi0yM0CcB95A=;
 b=mowJEw+s/Z0qi4qvh8LBuN/5uYmko+thmkOX5dD3rLLZWQzzBN4zRtJ2Yofh2jc2ex1p
 /uy61RR/n2+M9ZF/fP/fs8LAf1X9QA6UXBi4kSAVR+2bfQgMMaQHKgiElj/mDn79XRew
 pjwLVjJHyBVXauwv7Wq+3ZHL8iCOxOZLi/TP4PmsyVoQZv2vcrZTXhzkpExUAc/MzCCc
 qmTsAa1aIJJGbpysOEzxZ89Fkgw1siWxWH4j9LQ5TaG6yVU3PnfAv4d2AVxifXvOOjvE
 pKTH7XXbCJWYW2XbhqujNjQ7b6RJasfgXxSvx/7YJp5EaqN31iNWgCzFRX3hU6ei/pqp 4w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjync0j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:02:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GMk4f7028202;
        Tue, 17 Oct 2023 01:02:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trfy2wdrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:02:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZTv9+iwFYwhK/6qliogFgi9xRFGKvyS8ism+rXiXX7w5l3SoVAkIDzDaZRE5YMS5vnSZ+hBfmQMXjQEp3jjmLo8frOjrfVo3XjKjYki2DnVx4Zml36YnG1DbRS7DKg2CT1uX7DMxH1jmIQgrmDvdHQyIQ3riPjgk7MrlHS8npxUlFe6aKBRb8kf/+V4EKzk2tzXjCUtrg6RXhGchqqAQh6phdyQk/qzBTvRtFwUeDPJne0/9186hm9lknp+e7Rd/HVidUAbWMXLJOqmJXVtArt3miIsZ8KOT2p2op4bpVCnNCXXGjSBRLRJ9E409xrmBb6Ce3FU8sU1Qe3UnNiuBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjYDbwpqZ1X0FZSwMglE6oYK4owQjyIoi0yM0CcB95A=;
 b=AKWf0kbEfBdK0pki92qxj9/agtHli/zH+38OZffu16mTX+ezE/SGpGo0E6xDxNhxG0mn1fZ4JwABmAAk2dtJtk3ItO4EanESdnvQHVTR0qFfvY99uQKL0/7sbjFqdpfMEOZslyQ0vX8RnYjY11tsxXfxFgsxXW6NkmzbYF0FzIz3w1d1jHagFNJDkSftjiOa4keIU8EZNjzoKl2gs4GGFp5YC5POlot1figYjxyH4vSew7yS5wCSZnRjlkZB2XHaudVcxd7KYiC6Z6qeETzAcGmrN2efXQpMrq88/oj5sCbbOWN9UNQ+38E9pxu+CM3jMYM5XOY/QIxyJESFfgcROQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjYDbwpqZ1X0FZSwMglE6oYK4owQjyIoi0yM0CcB95A=;
 b=W4lz48g1ODfCfi9mZVbJdZXplMLmn+JwTob8lJH2DmWHhMB0C0iXixcz388AhxxAHdE1dWdrJTZoZVitLsSpNbJDHv5ZdbUMT1Q1CuuuYSlXsfaQ68KjkrwbFC97UbUXt23SyX8AtMGfMkOuiBCu4KOhqutlvwpffD1I0wlD9dg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5008.namprd10.prod.outlook.com (2603:10b6:5:3b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 17 Oct
 2023 01:02:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383%4]) with mapi id 15.20.6863.046; Tue, 17 Oct 2023
 01:02:49 +0000
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
Subject: Re: [PATCH] scsi: depopulation and restoration in progress
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1edhuhxi4.fsf@ca-mkp.ca.oracle.com>
References: <20231015050650.131145-1-dgilbert@interlog.com>
Date:   Mon, 16 Oct 2023 21:02:47 -0400
In-Reply-To: <20231015050650.131145-1-dgilbert@interlog.com> (Douglas
        Gilbert's message of "Sun, 15 Oct 2023 01:06:50 -0400")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:806:f2::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5008:EE_
X-MS-Office365-Filtering-Correlation-Id: 64e733a0-7cad-4ad6-8965-08dbceacc82e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WmAIEyzQ3PCT1GdGxaR9dsHRRXyuyrcLJYDAqR1x5hjpEIRxMEOM4PxVDp6jHHPPuVXP061F8fwR6sJAphMOP5wm9/zzIhURpSUL8Vc2Tu7KhZT8AUiuwDlgR09HGhfZK8GabqXf2MmDplgiMFT/f/ad7RTjQslEOUgdqDMc7CQo7N6Gf9RrkRO6RVbZkHjyePL8kFBRPvDzwOUiuxIShMCYeJR0tRKdlMWWyKr+6sPg/SSq/yt49RGiI8qwscrInbP+jJo3tgk52sawxVm/VRWjXCQ2aKi7rQm01fLLVAGiujzpNvxb7x4V1v2KixpXmB8oTf9YkUT2YK2pKuo4AuTxYJJSPRuPtlmvH1OHn2uhfTRUhHsQ5qjM209X2cHpJcfYYDXscgB205FjCGTUZWBZQNVcXe8bZsGoI9qt7nRR9X4lPz/MCGwxYmHX6JTtbK+XolLANfIgeZeNqYxFnG8RZYgtAvCdY3rXA1hApHPQDsgOZj0B6hFQrIffkAJ27CuRoIN2zIEVwev/CsYa/RODju8TDdJm89afciZj13wydEvcH84hgjs8KUbIJ4FJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(136003)(39860400002)(346002)(396003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(478600001)(6486002)(66476007)(66946007)(66556008)(6916009)(316002)(83380400001)(38100700002)(86362001)(6512007)(26005)(36916002)(6506007)(41300700001)(4744005)(5660300002)(4326008)(8676002)(8936002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ba/zxfONdgozKO9Mg0dU5jf6VLWejAakIrL14TNEPM8ArxzQo8kUPW+twYDt?=
 =?us-ascii?Q?gVPzaVd3d6hImlpzoxBKisdWhlwcwEbFF73XuSb6TqixR3VbXS8yi5MK9SjX?=
 =?us-ascii?Q?xHo5wZGeaD5ZOhIwvSAZdqrzfHTi+vp/0mh+8RoaL6Xl2hAo3JIjlr/5Fvr0?=
 =?us-ascii?Q?JYw3UfeXA7QeBOoe4wMcGsq+UoINfDBAYwKjbSTEIAPOm9jlOYhsAH56hTbY?=
 =?us-ascii?Q?KfK4IG1yvLcBlabXylqbG3/3AN427Wxg+oaVmiO5VNl2y4J0ha+ncgXrNP8F?=
 =?us-ascii?Q?+J7A4BDKN7DIWsYQNug8s/+zhEPddlmnvg9DdCkEkpGn5iwrZSSQgncARrJZ?=
 =?us-ascii?Q?6OPO/EsVgkmBXAhwtHJsTGyyV1I7zEyotMbIkX4pKpJbhV3K7blTYH+SUmPt?=
 =?us-ascii?Q?BuMIdAyoFg2f7E3Pt3S3lBi16+P0mnZxxYDm1IqSBpdsDk3jNbLYxvaqf6aO?=
 =?us-ascii?Q?LoP0TsuXj7vtvcY+WHpUQxbFtDcrMA29jyxjalblEUjiEOVX3bFmGOkIx0Lw?=
 =?us-ascii?Q?GDUrRklAPOWrHi3918xr1i1FjAWOGA5UbIUl2fq9Iay0ALOi+77ra0umY65A?=
 =?us-ascii?Q?LaXUPCJUa+Ywdx+n7i08EAXnbmbvRY05YzSx4bQyg22AHOKJsuTqfNFeg/YW?=
 =?us-ascii?Q?D6nb4PCFpbDq4Szg270e+UP55+/AG9+alALcn+v6Luy2YvBkbowLduTidqFx?=
 =?us-ascii?Q?LwsWTMn6YXyXlEPrn6ENEao4OnpKf4vtVxQFX1BpwpISTWQt46fx8TAHbXrj?=
 =?us-ascii?Q?V7wTTCwVL3XMWG/Gqb/f+3dsFjwaKlrlXKvYrFY/3iV1TQktYc5uMu41EeTp?=
 =?us-ascii?Q?7gxEuMogjymJKPK43ATyeB3o8R7Jac14VhCB7AWL8NoYC/9SNZ82s6mEtVsm?=
 =?us-ascii?Q?ynJm970OcX3uCeF8+Ewr3aBSM2njReM/Ab9n+kyXsNEY339gOwAKddcSkqot?=
 =?us-ascii?Q?GRr0ElqwWCaZAurybDZBr8mPG4CYHossXSgz9iCsoHN62Uve+MGEar7knNOu?=
 =?us-ascii?Q?LmiHLWoIo381t4UljnpG0spE/Nzhmb8ET+kKiDguybV2df0XYR0Iso8TbORm?=
 =?us-ascii?Q?voZ5B9jc8c7XEPmcB04hx+Q1kIH25yAPhP/mY8gj24VATe33hI14w0qwCYSy?=
 =?us-ascii?Q?B+f/jrPz5ubVr5UkWIcP6tzFj3yOcapdT8HhLjxpIoNKHi9IcaVeBdETX/E0?=
 =?us-ascii?Q?6Fm+wxtlmggVZN9mA2XPd6ZZgdvs2jBYjJ0JGWrs5f1kpxiMK+wKGvzPrXvl?=
 =?us-ascii?Q?7FVg0lPH4xcdbFhD5R6XcISIerKbA7f6a88uYEQ9oonuSjowgg0llF5YnNVp?=
 =?us-ascii?Q?2O29VH9diX6ra84WhoMKFEzHGv1pvr32V8XTqUymO5bDxzHrg3RUP0+WEXim?=
 =?us-ascii?Q?IPaWc3EVNJoQHtquBt8xGFN2zstUw0fMDEJc8Z/BTj8G83PMyRuzAdIy7OxQ?=
 =?us-ascii?Q?++sk1FklC0TGVwzhl8NJ8T0lpJy5x6CwalifK1Og9cqJN0oAgpFp96NBkrY1?=
 =?us-ascii?Q?O8R/TzzmTQAJYQrsE8k3inUJybTJF8CU5Cnha911Li9vXta/HilcMss766nf?=
 =?us-ascii?Q?n/kzB5A60wCstZlq7FNAinM0ICbLeN8PvqyqWk3O4GBxe3z78o4MEnZS9GVZ?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hlf0i4HYwTz5+fHW5PNhfHz/B1R0MVweRPoVV+xPphzdSNdcQ4INOvp29VWs8hzNfbTazt2sVhIXUUANGDkKvjjthW9ZL+NgQqm+yL5c736O697yKuuksWP70pUf5lwO8AV6yp/o3YZW0RKjukJiIdJDjFix2NSirOXJAOI8+OaBAP29O4jP/l/s4S9Av5IWGRfYs8j/Xz/lEF0NGigGz7p7XpZzR6iaAtNaXnAA2BCJoTvQmIAOLTQQXuAxahwP8RkgSoErC6nJyZ+FGEGMgoAXgRgc3NzBXhMSkFJJWGPTB3xYrW3Y5FLXW67EauXLgUZ9afbZKO/73CxnWvq0EpHMdnnvVVjY1170yWYDWvPNKvztOtF6sKq/WchZmRvVuMSfI7I2799QdBseF/BD13kRXzYuqBAx88G7gFKrG6SSMwsSvTRbGIOOol1oeGVKfIYfTaenGxh0BYaBRp7Na8cGxtCOzBEMMIPfpfoQ4sy0BcG9gX34r0PEzPuOkmH7fm6dsFk57qrHDTiSXbWTgqNzKlgkluRyOxdiUkOEyMZV004jwHNRyZ5uTC7nwpKjfAB9Ea9yfOpxxj3OZkV6dcOvycv6wvT9gd3HHGvUDn2vGx7xROTmglczfDBd6aba2NLbKX3xqVl5q1hRROpFLFBfnPgp/P+3tG5vaKRwASFfPhfuGkI5dzwYPS/g8LlF4thPqwMxGHp7ETpGohP39926NjoD96JTW8/oK2WV2euu5HsCgpuMgro0XuX7rOs5iLdNp/CpMj9uLFh9nSFV3/hxDOC+YUC2u7s2taA8DvYivBf/hs3nooyXedXsnrOdLLqfm/I4ZZKo1YQDdx4a8ndxxXExBzt1aGp9giJXeeqqeT74P37l0f2dYVZZls09gr+546QjhZLo5HKRXefCfA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e733a0-7cad-4ad6-8965-08dbceacc82e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 01:02:49.2178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3eCfwdtJ0syS9GM/oEfzqc6TdLYXL8MWdBwmTicMKgfYur1NQyWPckh6lInO/ja0nL0829N3p38IH0Wkof/Q+JcmuF1RNyL+Z5GQGPwQ7ZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5008
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxlogscore=900 mlxscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170007
X-Proofpoint-GUID: aqoC7wD3kLfjFzfK0UsTPX9wTLL9r8iP
X-Proofpoint-ORIG-GUID: aqoC7wD3kLfjFzfK0UsTPX9wTLL9r8iP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Doug,

> Add handling of asc/ascq: 0x4,0x24 (depopulation in progress) and
> asc/ascq: 0x4,0x25 (depopulation restoration in progress) to sd.c .
> The scsi_lib.c has incomplete handling of these two messages, so
> complete it.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
