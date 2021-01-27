Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70627C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A8B22070A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238449AbhA0EXb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:23:31 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48858 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238005AbhA0EDf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:03:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R3tIpv144695;
        Wed, 27 Jan 2021 04:02:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=n9o2WcWeYSDOH8+G80VFWqf4/HyFcqdb8nyDU7l3QlE=;
 b=Bif8ndLkGpDCPZF6veB70Dq49plTy9VLMFDlVMquet2XFxs5ujySgjCf8SiteHPWZDko
 37CqLFi0lzbf2qlngjeTN0MBs2nBXLsr8wRi6Bq3JB7XlfxlMzEfdFyygodNzgp61cPC
 bwZKsfKH39VtsQGOnBF7yDBQIp8PCIbCYjDi5ehDZUfAlaWMM3D1HBkF8kPA0ptpm0Zt
 lNWcFICwySiQmKzosdz5JaDBEZ582rjq3SJZp0N/fP6m3yiwXrT66VLm+9vWESS5/40J
 3GFPnx1POIszOToHtv8lLEwMBduJb2/E/UfuIv782cBHwcNtxarNRlmzE1vPBydPnQ5u tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 368brkn103-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:02:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R3t5c6039773;
        Wed, 27 Jan 2021 04:02:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3030.oracle.com with ESMTP id 368wcnrcg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:02:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kl7yoZs72unLB2bqUC4Ej7vM0jLPfmErZ4uCrStdsk9zHatU85dhbVaXJNuBEF8iK1MIlqLJXoGX9zf8E+uyfbQFlhn6rslt4DvTl6l4qubQSIb5KOBLAbB8Bh5tHSfcmOz/scK/HRT8+F2pdX9YQUgafgTvsuvlrRQpjVo2DtV3n98HTgeFNnr1uQJZiyj4R/r7dft5j3htc3duZoP3epPpCiTfakO8atURAaDXPVHcHLvfnjaqWf2QXrM/ziZ9I8ZEmjdnkVmiuwy7NpkMjXJzF2oIckqDs2rIz5MohxrdmAsjO0nsJHRreJS72AhuzueYZeUXRvyOQxW9fHCP/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9o2WcWeYSDOH8+G80VFWqf4/HyFcqdb8nyDU7l3QlE=;
 b=oJ8dGH3c0l8pk33O/EwRR+YHTkEfI0wI0DT3oz5Po2ceC2w46Dg2Gnhp6nfw2k/R+W6PfBTM5DjLmXy/46kHJudecja1dOevzZvuz6kw65G8Ft6XZ4gpNQxBqOO3hnLUDMtJ/FBBFqP+hZLhKWmf07c8juvK2DCydShGpiIi/wD89gVOTQTWChZPEluAevInuFeUM/gfGmJUTmG50R40MJsvnVroOtGhNdoiNv8Nm67cWNqHtAkIyZbfba/ShXmL3GcL0KyeX88lGafYYNZ1V3fJGovMpwmlaOnB7CTjZON4BgekU1Eq4+hjitKAqfUQniiqA/jsPEMyEWVRnV+K8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9o2WcWeYSDOH8+G80VFWqf4/HyFcqdb8nyDU7l3QlE=;
 b=B1iEIGm9EpKgR8v6AslM3bu8OG+kH2ja17vg03M5+Ae70afC9XUFxk5v0dKpIY554SzSnYWFfpLV5SLn07wTsXPe7JhaG94r/HyYSB+Fgr5Ve81qYb3Q2+OYz/4oHTwMtB9GcD/FZOpaov7tG4rsduzKAUr36qE2EJvh+MeSpPI=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4791.namprd10.prod.outlook.com (2603:10b6:510:3a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Wed, 27 Jan
 2021 04:02:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:02:35 +0000
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
Subject: Re: [PATCH 0/5] hisi_sas: More misc patches
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7n3rprn.fsf@ca-mkp.ca.oracle.com>
References: <1611659068-131975-1-git-send-email-john.garry@huawei.com>
Date:   Tue, 26 Jan 2021 23:02:32 -0500
In-Reply-To: <1611659068-131975-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Tue, 26 Jan 2021 19:04:23 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: MWHPR12CA0061.namprd12.prod.outlook.com
 (2603:10b6:300:103::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by MWHPR12CA0061.namprd12.prod.outlook.com (2603:10b6:300:103::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Wed, 27 Jan 2021 04:02:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fc1f584-9dc9-4461-fa19-08d8c2786140
X-MS-TrafficTypeDiagnostic: PH0PR10MB4791:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4791AC9C0EF7DDC477F6C3BD8EBB9@PH0PR10MB4791.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J6kZHy849mNsIXJMUExOA6eQhbHyJJckiUjnQKxUT/jVBfs+UqInsVQb4nqdjv26g+OcTqzF6irvcX/qv0Nk14ziz/d1yiBdOKCcBwwba1pJlAH9HMIY01sV248GGVNtrYJ8zmPdVzTg9RqYC4alOuHZFcXowNe+1qLNKhck7j0gte3/iDUTyA7Be8w/6shopG4M8d+hkgupVHfjeTZZlEUzhv9rc2hM9OQmHs6acZQ1W9VT4321WABtreD7UKCWCZ/onpjXHaIQdvFlR6Bd7F17twrWbzFmXvvK3YlKk2wTdyw0NOPUIHxvGx/jYSNAxsgyQ7lGEsbtu9lqzz/Aka2strCJ7Uu3L/grm4b5vH6UI6vfIwFbTCfc0GeLRUOO04jyQ+7JaZYppyZ2av86Zxn61AL+pyLURAuK5HDY9yfgj0TJMjkATDs9mL14ZBVpE8IhRe+ndhyJmKXTCemnqeTlphGZP8IVSx/rcqwK2axuC4j6P9xwKAH6TGlHomUzf9KztxL8CdOHgZC5c07KLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(346002)(136003)(376002)(186003)(16526019)(7696005)(5660300002)(36916002)(956004)(52116002)(86362001)(66946007)(478600001)(54906003)(66556008)(4326008)(6916009)(6666004)(8676002)(4744005)(55016002)(2906002)(26005)(8936002)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7BrThg5qUUcg7zRgYtMQrXS7G+7wDgEumMILHD9p3afJiR7feMqyr1n6F7Fz?=
 =?us-ascii?Q?SaqgOw3XIgfxREUjEgBhD8GqSiv5691oCMBdZSaqsCPh2YSaRZQY5l5oMMIA?=
 =?us-ascii?Q?0qkcQ2hPzkw+g54T+FDyV6enIU66bkZMBcz8Y5oLQ8oBZzrduNhDpAMQdrd0?=
 =?us-ascii?Q?eRuuIfucTMXAChRvvn4oRgmbKdo4pujOZVdL7FN6SVi40X+Im7XLFIxni/UY?=
 =?us-ascii?Q?MZaNAkmf9J2tWOAgMxivk+fo5jpZ2E9kZbbNeLRB82D+vpSxNklT5UstSWUO?=
 =?us-ascii?Q?bYS7yuYRrH/PemLUkd4kgyfSTLbS35sOlAATIWOc/HtcgcX8Ma8y1u5LPkaW?=
 =?us-ascii?Q?i/kpRt4DGhhRCGyTdwkzLDWBkT7pQcUgiAVEC0E2gDqArSyn5z+NXSmHDOY4?=
 =?us-ascii?Q?rLF+dW/+WFw0XOFae7moE8U/KuDyTaxPFEslI3YhqSF7Gm3ugSogzi2PK8vP?=
 =?us-ascii?Q?iGDMp9+3eLUl6Y9jncpqaNij2FfA69G1VgUuRdZmoif0RqQI8Q3CPNzd2giD?=
 =?us-ascii?Q?Eh5FG8LfPRee34pZNJLDZVh9Pq6hd0XA5xlCtvUjf0lLxProjvl4fHMEO/ga?=
 =?us-ascii?Q?RIibEB4N5QP8yhkfKWBMQJu7sIGfg3uN6EbWH+3TNdpRqV4kxHygDjCCLliC?=
 =?us-ascii?Q?CZ2RbuodJ3465SoZO79+1OEC5xaZ2xS09xMAe9AO7wCS9C/Juxb7Oz63HazK?=
 =?us-ascii?Q?hM2V1QO3QhyKhAoybKAX7Oa4Qa+50ljtDY0lf2hcxRbZcwPDtOnLZBVo/JvG?=
 =?us-ascii?Q?IKUT7fwBhwydHCFCMxzpSilkTdL4pSvpSeMi9wXMxdD8CVyP7yUdSoz7mlZQ?=
 =?us-ascii?Q?R9QTdiROscKrLKWSq7E8x8JEsfKRIeRFNQFHR2bLRRbTlhjKs4TtQEiYi7EQ?=
 =?us-ascii?Q?Mg1hIiFWIGVBW9goM2KuJw0GF3onVkmbw8GHoZ46+pJdPGh0IHyW6+QA0fe2?=
 =?us-ascii?Q?Dr5cIMPXfOZNz1wCu8BcDqYt9mEM2zc0UBKGxcIht2EXw4qN2ibSKu0Innr2?=
 =?us-ascii?Q?SrzCk5WORBk62dBgQfn4yBE1dcL0r+12py0oADlO8yYPPyQhtXp+jwtZmbnC?=
 =?us-ascii?Q?gKAvvb8n?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc1f584-9dc9-4461-fa19-08d8c2786140
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:02:35.7632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hs5XaceCiwa3mtypZQl05ogyY4Iyu72UxonGMbNKp4dhyfrzGFUjUQoheebCQUchDBSh1pk7tg29uOqm/1hQPSPFfe47SC+afbg7sz+G8R8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4791
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270020
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> Features include:
> - Some tidy-up from after recent change to expose HW queues on v2 HW
> - Add trace FIFO DFX debugfs support
> - Flush wq for driver removal
> - Add ability to enable debugfs support as a kernel config option

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
