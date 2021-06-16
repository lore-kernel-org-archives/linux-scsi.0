Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218F1C48BDF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 02:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0452761246
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 02:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhFPCu6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 22:50:58 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:42274 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231494AbhFPCu5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 22:50:57 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G2fhBc001082;
        Wed, 16 Jun 2021 02:48:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=To3RRqkttAQdPgLCKZkvucgzi09MdcpugTzvBFU8qqg=;
 b=V3F401Y/0Ft7toG8TX4aUZB5p4keh3Q6LXmbtN+/zFLLdSgbRevavUxiS3ra1piGN+lv
 HgZzn11/ngqKgA06bMaaBNz5BAsFnsxYn8rV4MULc9f60KfrT/SCZ0zMYiNz0cpKagOV
 TjKvibuQYqOK5ChraG68eF3w6uUfbzO92lYcCxMSg1eJIgoQGN5ji3oiJ/XmAQzT/Av3
 kWhEHIXZjD43EKaL4hF8LWCslmxaHYIm1oYL5bb5vOub2glXfeySdos7scKwgHafx73V
 bCzNFA44TiejER8JGB+qjm+77i1xwAZbNLuU7f2QiEnJfehxqk9yJYoT0nBBlS6Hy2cC Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 395x9qss7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 02:48:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G2jF0l193798;
        Wed, 16 Jun 2021 02:48:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3030.oracle.com with ESMTP id 396watwmns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 02:48:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNexfLAd94cw/zfpQPEQbZ2y+GoKycIiZBArYbLu9/b0ueSP5cZq+1tFEriOv2DNC53B/kDjpYKcbcjFhBFlvN81mvjsmSxzUswqaYNAzziwOqtB1c/xMPCwW4j205JmzjnNw28C7tuwZN5YW1yHgfQF0H1qz/csDXTp7OTcnp3pf22hMPtreNghYzEfyUKZRMCMb7OEvWmDksPZYcbSS+NDIGs/Gwnbyet8TtKDiLPZmHdCX0VsLVLIRfoy/VrcpgO7B6LZol+WDiWcPtqjxV7gG4EopGobeehqEjyo/NfVsuUXdw8XGsKLH7ayTxafXPHnAjwegexpdBYu2hwrNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=To3RRqkttAQdPgLCKZkvucgzi09MdcpugTzvBFU8qqg=;
 b=VF0BM79/Kv3A5R/OyvdO1bbV5+Jui7Pw7D8VoQijM74u/indEcf6V/nnf4GHbh3TU/UA1Y42tiJzt1HIMFkvKWZEVU7ZVclRhtnQw4NYf4tkgpQ6hHiL2Ac7llFQTRp9jMAl+PcEsF5yj8y+qWq2Km/qJnjWEOb/fhH/ahSkkJHKDOGVo5vDs6tnEuE5l6NHA0iMjktPxN1Pg/KuKCtDpwEz0KglnGUOfOWWJkaDovFtZuWH3jHLLx8PjuGuLT2QSN8DnBQ58puThgYmDKr5eg2fPx6gFZbgrIujtKsmne41xCBhLVGGI2iyWSdhQqY1XtCad5VHUClUUziWjQXoAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=To3RRqkttAQdPgLCKZkvucgzi09MdcpugTzvBFU8qqg=;
 b=aGzy/O2is2+JyXEbThf7z8vMSczYrOl15rxSTGOvvu/Kildui7yu6Wm3c7oisyLqVLT5CKjEvDxerPeycnVzlL3tztsVfqno/f1VA1IWTxgifTsaMw58PGcMKSi2kjf0ZRs9yDVyuTcPKUj/uCMwUR0CnJuix8yvBYjiLk0z/GQ=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5419.namprd10.prod.outlook.com (2603:10b6:510:d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Wed, 16 Jun
 2021 02:48:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 02:48:41 +0000
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] scsi: pm8001: remove unnecessary oom message
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6nq5y5u.fsf@ca-mkp.ca.oracle.com>
References: <20210610094605.16672-1-thunder.leizhen@huawei.com>
        <20210610094605.16672-2-thunder.leizhen@huawei.com>
Date:   Tue, 15 Jun 2021 22:48:38 -0400
In-Reply-To: <20210610094605.16672-2-thunder.leizhen@huawei.com> (Zhen Lei's
        message of "Thu, 10 Jun 2021 17:46:05 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR12CA0007.namprd12.prod.outlook.com
 (2603:10b6:806:6f::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR12CA0007.namprd12.prod.outlook.com (2603:10b6:806:6f::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 02:48:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bf98fa1-35cc-4f05-e3c4-08d930713fde
X-MS-TrafficTypeDiagnostic: PH0PR10MB5419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5419CBCE39A5BD9E3BB91B2F8E0F9@PH0PR10MB5419.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xsVg83gzY+C8Dm++PlkB/Am78ICBwIVKfGYcyUoUpZLXRUteagdt1/16NgKbHQPZVgLuEAYawasoazKVKrqASix1zk4V1redJzsQvunbeSepWnHMStB+GxD5fI/R9RlXGdsd1E0AvCcwfRGdLBBdRpe5jY70PDR05bbQ+6HoJdGreJzg79ZSl89sEUWNvFj2hQ1cC5VzkidM4kG5nQa7+zWsL1DGrcp+yuYAMt8qJcOFKUc9hZexV9C/oDxGV+n+IhZQSOGn1gNRA1UYSCt1sEf8y3e6cig4N2w4c2lhN3iXJYOHRaKKSaVluVbvR6p3nGFqE9hwbat9gqUedX7Tn2aiupJdzTlZBdIX6TlXTbg4fhRAAFKmxraYC8A7/xE22vBu0aHF5aTMsR3VMFi7GQNWz0Kzt09mqQG2lkWUClzwQ+NJiGHJpdCp4TEzeK2TM85EDVZ2GvtQqG6MUrSA91JqWJ/0x4zCs0GmQgowAElK/TNEIPgGM2LnV7MdpaMB+s8KEcv9/7bGviDNz7hUHPC4f7GQS+m8Nx+7clbMTV80094bFcfTn5I6p9w5zs79ey37kW2xnarIe3TORvYFcDltWQEAXuriwH2yzOjPbKiSdQtePcSDiYmoEKi7WhIwp1kwWdO+zY/JdbXlbozvAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(136003)(396003)(346002)(4744005)(66556008)(86362001)(956004)(4326008)(316002)(36916002)(83380400001)(52116002)(6916009)(54906003)(5660300002)(16526019)(15650500001)(186003)(55016002)(38100700002)(38350700002)(478600001)(66476007)(8936002)(26005)(66946007)(8676002)(7696005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zUFaX4oPvcl0dVqmIDT51pYtIYCaBXHXvh+2BabdRgFftZPFEYLjRjl/O8uo?=
 =?us-ascii?Q?qwmCQ3xG73Ah/WBlYbUjjPNgDn87UMViOuyS7SQxeok3P58X2bZmKvURz0OW?=
 =?us-ascii?Q?y5mDFxjg85pjnjoBawBiPR+vqIkmN9J9DBiuaQ8Lq6cY7tMpoD9L0uy6ZoW+?=
 =?us-ascii?Q?SbD660p/aMPXseVZbMrGG+BfKHPyjEUcUlPlyw/K42HDFzAeQefDsbdbPpy5?=
 =?us-ascii?Q?enGPXF3Bo6BmXtmnAR8ptu3Xhwq3EGlUDqW3BvG8S/MKze+KNhw1JGiAuuHY?=
 =?us-ascii?Q?/9B9YZfnS5gsWOQ58Ln9oPAEKB5XEz5yZyM3rfrCkzzrbhMU1EGpdP5ALF7n?=
 =?us-ascii?Q?a+oKFwqom2DdfWLz0x1MvZc+QkWLEGqD2Nb3P52KufoLzWE8M9LP6uNJBQoC?=
 =?us-ascii?Q?Beu3W1CW9fSvCK3OBed8bxltCKOteGtx1Vprhc1NS7QgLoaSQMTJD4wA/Ynm?=
 =?us-ascii?Q?y0uxi3IalyhDEwazMrWbBgXDQbcylUokUjhSLk0K1v3hi8jfSc5kWcfF3qpS?=
 =?us-ascii?Q?/S/oce+O26+tcD5UL9ZEmD/LSBRe20mZexVXbglMRqnt9jyYfm9Jf0Bq2BaF?=
 =?us-ascii?Q?jPAm2x1xP/db+aVFLUruuve2OKFLJazUToAP6/4bsNmyqEOh5AKQBwTgLnE5?=
 =?us-ascii?Q?nGfqihdk4CPAN9qFwMqSD5qNueQqqnUmP98HEgGkHQv0Ryx9mYLlC8Spfu+R?=
 =?us-ascii?Q?Z4Qnr0z1uQGUJVMTLrXxaVPu1jpXL0n1UjN+VNiHGLmoukfJcxVh6L3fQfVC?=
 =?us-ascii?Q?RKBhL5GMg0f3LrmcXUShObJmm4bntP1OQ9KHmbUnUmFmX2NUF+4hqUtAqhlO?=
 =?us-ascii?Q?pwBdisEBT3tP+ScuJ7wfd3xd94BkVOB14dAm+OjhPyXMw6YPhITtAv3Vyc6/?=
 =?us-ascii?Q?MEED7fqDq7Q9I0mAmqqEy3klXdinVpTRxLLxOyGsUrTgrNZU5xuepYC3KJKc?=
 =?us-ascii?Q?4/SPecfeV3xpxlcb7JIzxMzHIQZvvthJwJF+1DfcnczT/VGJAWdvPeEtNVl6?=
 =?us-ascii?Q?Awy/kVYD5IUXwWqCMGlJl+wOsXRV/z4w+1G6KEOxqh71qBaYM9SuU1nEnk9r?=
 =?us-ascii?Q?LMpyPwY20yI+vawfURDfORArkZes1jirItLhqkK5qVp4oR2AbEUpL83ZRGnX?=
 =?us-ascii?Q?TiM5NIF7gVPE/rcV5/ak7dqC3Hq3sB5+uJYZr3OH+RFDsvGnIiKIFImIKHOM?=
 =?us-ascii?Q?iWE7mwszWcKiC9ocp5PFNsMiGZMER0F5+7ZHoUz+nIbC4Wstq6S6o5kZBgBF?=
 =?us-ascii?Q?tUsTgkS6Ua8VfEFqhaGBvQShTLFMiBmB5FaWmQ2QdeUC3kcucx31g2mG2jgW?=
 =?us-ascii?Q?xo3MzdPLfwMBTfVkweEnu7Ju?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bf98fa1-35cc-4f05-e3c4-08d930713fde
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 02:48:41.1551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EHt2eA/Vf3VxMbpxBzWHw1pgcc90iy9QLjYkHbSxwZW5W87H8SYCBuzMFnNZk1D14IF8ar26bS5ge1XcyL5LiOTVN+EIzHRCj2GK/v7KhXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5419
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160015
X-Proofpoint-ORIG-GUID: kglkEcmcZDH4wgTs8n9DKaXc-wNDnpS6
X-Proofpoint-GUID: kglkEcmcZDH4wgTs8n9DKaXc-wNDnpS6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Zhen,

> Fixes scripts/checkpatch.pl warning:
> WARNING: Possible unnecessary 'out of memory' message

Applied to 5.14/scsi-staging.

Instead of sending 20 individual patches to address OOM messages, please
submit a series. That makes things much easier to track in patchwork and
b4.

Same goes for the DEVICE_ATTR_RO changes. One series per logical change,
one patch per driver.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
