Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FE0C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 02:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAE4064F92
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 02:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhCQC0C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 22:26:02 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52832 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbhCQCZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 22:25:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H2NIsB014079;
        Wed, 17 Mar 2021 02:25:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=4wkneazeRjRq4wlcAOI/O7ad8+OlmRPxS2mDgBuYF9U=;
 b=Q1WsTXNRRFpwrspID1P95IVZd6TeLDFAMzyiVxVReai0WCdgCArJApWRNJHEPf2G1z+Z
 y4szHcsl3YL2gD8Bm7X5dtHiD7Yzzl0O9ksb/xfDY1hplyof+rHgU0RiWj9Or8m5Uvni
 rQilZTIb3y4z7FBLy9AvPVVLFHbEryqfpepYJ7nwLoWDi1oamkFXn2nWLO995ObLUDwy
 ye965tCeadGkXLXwCgHOWDou88kGZZ7zUfqOZc1TIbwxVQrf7JpKoTyvHefbu3ozISeg
 4Rc+oqRr7wyV0sk0EK2isL23vo+egduvSAZCG5y9EFajRtiBc5nVfY0xjpDXseFvtoFJ sA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 378jwbjnua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 02:25:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H2Jkdj078305;
        Wed, 17 Mar 2021 02:25:35 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3020.oracle.com with ESMTP id 3797a20jr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 02:25:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXM8pE4V3Tg4J0DPboLTrsZzNjUqokmnVNA++HMXFCt8LJmbFwnvqUkKW30Q56Jek7m+D1aytDp5Zw3lKJzjg/60GVG1y/sn5Om0+eAA0IcLRk0tRGe2qmjnuQXeoKAJOHwP4HzgfycmMBDI6c3YP2kO3ppNJsSs6kQshy7GfSMocXge660Qa0iH5uokNAImBJ/I200go1/pgid6Xh9kckN3EmcvsOU11LGiJEbtcStej7NPs0yA43B8Dpu9bI1JztxQVFuueasqMrHddzZiH0I0nPV16/uakddlOtvgqFurZ4CJAfnD/kB3IbugbqahfqCvp5HFU8ncUroizWxncg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wkneazeRjRq4wlcAOI/O7ad8+OlmRPxS2mDgBuYF9U=;
 b=cpvkPV3C8PFgCRsOgUWvQXgT5UYh3ij4nGE6GK7pDlXfwCoTaYr7e6DYDhjRRgm6MmAw6AIl9g0iiPg4h72tKa66+ioxKNlrLqICL1hCa40HDMwyEqL5XIaTN8+XiH2TWzuPkeZ3D+EH+MorJQZzpcloWYpuyRnHD1YkVW88pQQ41mISb1xdx2rJqQ4wruyEW9F5MT00ezrfPATVVmHS7AEsXu07S8u9y1S05v/HuXWKHqmYlNwrHp7rlDLLKLGeqcF+ESvEWqJY4/0siLnbW9Myq92Rfsf/RlXxOnCJoBs+z7hiPU7IobXmbT1kr8jehRp8THRoXtTElG+S/7so3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wkneazeRjRq4wlcAOI/O7ad8+OlmRPxS2mDgBuYF9U=;
 b=JzF73pUNo85H1OIx9J/sVkHpsWUOQoKoJNdjMc+klBQO+90eeLYJW/GXZH9P3rTf5AlhVKSkBfJzMRhgc+z1UyE45JZ89bfCUidEYGPA9E4/DR59Kg8gYl4/uEvshWeKDL3l2vGmKBIODZN899lA0Ku2985M9wC8zTHJ5LkNpsU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4725.namprd10.prod.outlook.com (2603:10b6:510:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 17 Mar
 2021 02:25:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 02:25:32 +0000
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Don.Brace@microchip.com, Sergei Trofimovich <slyfox@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-ia64@vger.kernel.org, storagedev@microchip.com,
        linux-scsi <linux-scsi@vger.kernel.org>, jszczype@redhat.com,
        Scott.Benesh@microchip.com, Scott.Teel@microchip.com,
        thenzl@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: Re: [PATCH] hpsa: fix boot on ia64 (atomic_t alignment)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgz21rkz.fsf@ca-mkp.ca.oracle.com>
References: <5532f9ab-7555-d51b-f4d5-f9b72a61f248@redhat.com>
        <20210312222718.4117508-1-slyfox@gentoo.org>
        <SN6PR11MB2848561E3D85A8F55EB86977E16B9@SN6PR11MB2848.namprd11.prod.outlook.com>
        <CAK8P3a3JYmhbN3TXB2cWGfXGKgsUa9Hg=ZvWckTaL_31OMgbtQ@mail.gmail.com>
Date:   Tue, 16 Mar 2021 22:25:30 -0400
In-Reply-To: <CAK8P3a3JYmhbN3TXB2cWGfXGKgsUa9Hg=ZvWckTaL_31OMgbtQ@mail.gmail.com>
        (Arnd Bergmann's message of "Tue, 16 Mar 2021 19:28:22 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 02:25:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0004bc5-985a-4086-8f68-08d8e8ebf0a3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB472553000EF697CBDF03722B8E6A9@PH0PR10MB4725.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pp6Sl5tsiSXY9pZaEWsVyuXF2ZiWaK/XgAynWjrp2YquVvVIa4xEQfkN1qfeEnU9s5rWxIwWTIVOyT/XI77hsOK/VFl079IsFXSpm1o40Bst7R1tRHftnZm2cwmszV4l4D+K2se2q80aq44xWeYIbRvuXWACSGazjTCv5Efc69pEIAlmNcBVxXFYIMLpXehUnvk3mrF5j7fTjEz0wTnovNRchKpmRJG6+IdI9cwjCvwRrMGQ8GUG4PLI0i+G0d2BO2U29FiiKFAa75BoE7QihgRG12wyBBCZSMRyfRdJ+k4any0TLvQJ8X6eK2QvzvEKplXxLH6C4CZ+fltzukTMJaJiEmK+dYXn87lXUebD72rH1MGjchi3H3ttpaLW8AR1dQ+QwTXrHZpHdK9h7qWpWEF7KjXCbJ4cIkWbO19yoR4MS8+akyCULY5j/NRogrPf+OqdxbgxDVJRKO9b+DmSCyZ9mOrNezfalESYWHvMJspNW1jWwwoOFH4rDORUKTfW/MEM2me+03ZUDKOdeqOw4Q+SuBR/wAery6a3DuGUcFhaKrU2Fcr/k8zel6Rlmwrb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(366004)(346002)(39860400002)(66476007)(66946007)(36916002)(66556008)(83380400001)(8936002)(4744005)(6916009)(5660300002)(7696005)(4326008)(55016002)(52116002)(7416002)(86362001)(956004)(26005)(316002)(8676002)(186003)(16526019)(478600001)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rey8vu2GdFuP/V4MgfT1V4PuRW5BHLoz0AD/QOQid07eTZYV8nE7a7cRbx9U?=
 =?us-ascii?Q?YrkL+SlxEwSgyR/S7iwU1QN5+mNqYLti9pmZv8DYDGgn8dwsnBC1AmMLc0Zx?=
 =?us-ascii?Q?VBgCK88bSH/qVA8oUQ9E/xr8WEK37VCCQ7y0pZwEHHfwCiiDJ2SsObWloLDq?=
 =?us-ascii?Q?LQ1Vqd146SdWQfzlqo2a4Ca1Y/L/YPrVUUYEj/qlJKutlIfna7508w//qFn6?=
 =?us-ascii?Q?fwM+Wa+W7VWVAttKz+pP9v6QgIi1mXewcDsd7kJYuCIuLuEfX08UEZjGzElc?=
 =?us-ascii?Q?FmkNsBKGXG7CWS2GIzm9mzTk2euCC38bu2D/gOt0DYe9h3ZM+FKQIv/Hg5Sg?=
 =?us-ascii?Q?ynruUthwHHpOeRoNZubjSuVSjFbIFjTvViz/GSlCFtdAC9UESQ+B5/DQAiAj?=
 =?us-ascii?Q?oGRQQQLHJps7qDJGGA5I3+qMQ7VsG9ysE6/egBnKoU85fW5E+cy3v/hfVkK9?=
 =?us-ascii?Q?Vq/BnWaXvfKGoJ6V1ofeT6/YXxbLwTOSru7j35s8b77q4lOr+/RgtnV7l0Qg?=
 =?us-ascii?Q?5WwEIlwR8UDV2DW9lHJnVrNwD3yCBeAUw7/nASX5OVflKl73drpvRx80t/H6?=
 =?us-ascii?Q?4oU2A8rcUp5IkChoDkXOjuOtRSWn4NdlONzptdZshU9i5/lbCI1a1sDk7HY/?=
 =?us-ascii?Q?GwX60cRxtDY5BdhBVF4Sk8cFf84FWtujztDCRPyKZ6+b68V9GvwO3pf1Burm?=
 =?us-ascii?Q?+RJddTlKQq6sTqgeEZILUc9x/17tYooGDY6G6jerP07u5rGi1hVPtp3y69b2?=
 =?us-ascii?Q?JuoVcPaBPxNVR7ZfGukLbfWrV3wkAheHMLV4sVihn9Sjn45p8OQ+7cmSRFP4?=
 =?us-ascii?Q?h+tJ+p5ePtiC8Gj4Xo0w37loucTUako1U8LAFJCkmNl7KyjZgRDgVUWKsDdg?=
 =?us-ascii?Q?MPxziM6daIpBmvW4hciAjxaEcOB6G6ToQPY+vzYup4DXEkvo6uwBzmypwcGG?=
 =?us-ascii?Q?aUkNsta6t1IPyyJ6XR37YLG1DOEIpkwsOKmj6mRTsu7SAxvOaSrpn4QnIRXq?=
 =?us-ascii?Q?WXw8tGb+eqaTyplZRp8hqrbq3czH+YWvOdpEtGZfzrPbfigpJY6ULXNFs/CY?=
 =?us-ascii?Q?XXULa7zUCrstSzL/ac9ABeMVjWd9J0ahGEvjiyzbhT8mEsLBggT8YMQcN2sr?=
 =?us-ascii?Q?HubiD9hyA8pFK2SV0P2ZyAVkEfmpTZl2/bxV3A5wsXfjaTy5uTKReQWE5o+z?=
 =?us-ascii?Q?wdCxGm5xUnnKWpF4MPz1wJY2fmZtx0xAF3+qTR4ZLpPq2623/faeA+we0rIq?=
 =?us-ascii?Q?83w6ymQI+R+6570bANHDrdQPc0HL5cUCnQUPZPbl6l+NtlXUSGzdwz1AAhbq?=
 =?us-ascii?Q?3Y+S6BM2vGdpBrTqQFavf08L?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0004bc5-985a-4086-8f68-08d8e8ebf0a3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 02:25:32.6000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Id1HQ8OmXAGVeEBxJv6EWph8kpIuaAoI4+xR1F+uomg6MEih7Cy4XUIMdcrWQ7X7zCjei/MUFswMvUhnIqjV6OAmbdu3R5jFCCOSK4lHsNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4725
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 adultscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Arnd,

> Actually that still feels wrong: the annotation of the struct is to
> pack every member, which causes the access to be done in byte units on
> architectures that do not have hardware unaligned load/store
> instructions, at least for things like atomic_read() that does not go
> through a cmpxchg() or ll/sc cycle.

> This change may fix itanium, but it's still not correct. Other
> architectures would have already been broken before the recent change,
> but that's not a reason against fixing them now.

I agree. I understand why there are restrictions on fields consumed by
the hardware. But for fields internal to the driver the packing doesn't
make sense to me.

-- 
Martin K. Petersen	Oracle Linux Engineering
