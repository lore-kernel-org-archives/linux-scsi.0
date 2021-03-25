Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA9BC433C1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 02:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D542C61A1B
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 02:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbhCYC07 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 22:26:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41214 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbhCYC0r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 22:26:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P2OsQp067995;
        Thu, 25 Mar 2021 02:26:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=j0A5T2WQ0Wu5mzARg9KwWKCH+By9PABGuikD8BFccYk=;
 b=P+krkXay/wV7XtBQYPder4zFY6m3AixaEBm9+YR2INFUhktAXV4Hq3P8g/8hDsQcgcM9
 qN5K/xXLajoO1ezukkqlqq+5iA81cfms+mFCX2sXm6la3/T30OZOSwwaL5wJpvQ6h5uD
 23xj4pqBz6Laleimc6b16juyybPQkNdUCK4pCJ15zViTBYxpRkAVoIFnWWKotfXJiRbz
 JLrZGHSlCcFNMiH+T8a2mW2yztb7gk8HT2XPqnnk3kc+zfzo8NK64VDIhMmK4QK7F1GN
 z1OCVK2+U6KNEP7R60lBYreRJM8T+x3v0w/PZrYp3AvL4EO10l1RicJLkkm/mQzrIhzW RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37d8frcsrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 02:26:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P2QSvs162178;
        Thu, 25 Mar 2021 02:26:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3020.oracle.com with ESMTP id 37dty1b3r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 02:26:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F//ZAo06nR2WLhceAyO65iJ66E6yQ/EwHLZtAHSKKrJFIVfvEUD074pON3Ci+WephtTs2JjVaFSHzHZHyFgJnUpUC8+Cz7ZeQunTKIW+Dn1IJMdB3IHgdgygqnMV/GPuhbhXcymzuPs/mWeU0C29t1OJHqGrZIEUAAkNMwSGYIKH0WKQRi52SiLXH2pmmCvprhwynnSVtMwaVcI7uUCeFyONBZ/ndsfkJofEHYUnEGD9JORir49zG6VoClmFJDiICZd6DbamqeEENql46egTEb2lKB9/7GuRv2LzGJvCJWHpgDEXrqGlAsaBRK3nivewDOPHBzMflATpon2weVb1Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0A5T2WQ0Wu5mzARg9KwWKCH+By9PABGuikD8BFccYk=;
 b=OlrZqJcThFEEtf7BBTZv4aXowOR7oR4mV1VIKSyztfI1GJAwmL3EXcB/rRfdY/MEcMWSd7wxLWSgmB1EufCEZqzOt27ZVWS0LvXb7ToXwB9j/C8YzmQV1FY5k5GE+z85VdxV/ePspCHPs7c3aSpQVo3lVmPVq02TtH7GI6S3rg8LfunxodtAGL+Q8OzhsvqLf4wCwkOhCnc79GBCs1a2i3nZgDoPOTTpJs3udPvYwjetznDD8d+uCUIlHgn4RJYzmNLVYT0d1wlM2cI+gBlLRRLFyAQuiidnPOCvVtMo+KbKsrvExzKBsjLFISteI7rq4yZFlUlh+OD2wBYJp65Hdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0A5T2WQ0Wu5mzARg9KwWKCH+By9PABGuikD8BFccYk=;
 b=n0qc7263e9ERxqdfodkCowXIAN30lguVr5b6NUZnZlHsql/qNlQs+ryHn08dNJS36U1MZnSS27Bmz8owHhWuI+/y+faNVjzwhK+QNib0KkyRSj/eGZORyfz5NcwT93TrFcNL/PBTQ6uvHOsJobuzo4wfIuMKdCMyAUqL64OCZoI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4695.namprd10.prod.outlook.com (2603:10b6:510:3f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 02:26:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 02:26:19 +0000
To:     Yue Hu <zbestahu@gmail.com>
Cc:     martin.petersen@oracle.com, krzk@kernel.org, kwmad.kim@samsung.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        huyue2@yulong.com, zbestahu@163.com, zhangwen@yulong.com
Subject: Re: [PATCH] scsi: ufs: ufs-exynos: Remove pwr_max from parameters
 list of exynos_ufs_post_pwr_mode()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ft0kklz2.fsf@ca-mkp.ca.oracle.com>
References: <20210311042833.1381-1-zbestahu@gmail.com>
Date:   Wed, 24 Mar 2021 22:26:15 -0400
In-Reply-To: <20210311042833.1381-1-zbestahu@gmail.com> (Yue Hu's message of
        "Thu, 11 Mar 2021 12:28:33 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR07CA0102.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::43) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR07CA0102.namprd07.prod.outlook.com (2603:10b6:a03:12b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Thu, 25 Mar 2021 02:26:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0119e3b5-2978-4675-21b2-08d8ef355fa1
X-MS-TrafficTypeDiagnostic: PH0PR10MB4695:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4695681C0884CB02531317EE8E629@PH0PR10MB4695.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u7s1wSfaxzkciScsLYw9sXiclaukRqspXe5H/bZ7WguiE/qNEIibbfooQRPJRcsXpm9yhgVQdHaPH0PLcTYhYhQNOHRU2nxMCJYdtHrl++KvBuU3WvfbZK4q51udrWXa7/j5Ldz6N+nE8WlQHF8VgqGieLs36qkXMvskzhMDZnyjElzIgEk6SV4fMkqpr3am3xCjE7cZV9+2QMqAF/x18i5sKEpyrmdPvxNY4ZWApIu8kW6dM0TYiV1IGJ5oD+JZnYIyIu/WamzaDWSvFwhaqY48Y43A3pL42p1dRDQE5UGnvgrTo0VKQhj0iZhj2ilQyCkWG4m1qIFWkLnK2Crf+RVRc22pdtCvkwZQN4LTgR8+Zzjm/AmBc1J+qBFihEZt1u6LiqaFmiEAvVxTEh0lshLzVeyqo87XHeoycWr6ecpjyL30ndtkvFcT0Tr588msF18kKlKS73uVqNZdMuphYjYa2XO/hx8rvbSDS+r0nIU8kIgQGRzoSTG2K9Gy+l7qs/WX7M0CPD2SxaOLigOJV7d6astoyAV6ZNoVUmpLhCMHh6fKroQy/j3DuO2a7AXGOwgcKZx0aZXeBmpQhufUlKfYNLmkgNHaa1VtPQydXWyPLj/IhlkMpBFockUs49l+LoH6KHstWMwJMR9tlmUlaSvHV9qj9wiG+BwMQnbHm2w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(376002)(366004)(478600001)(956004)(86362001)(26005)(316002)(38100700001)(55016002)(7696005)(52116002)(7416002)(36916002)(2906002)(8676002)(16526019)(66476007)(186003)(66946007)(5660300002)(4326008)(66556008)(6666004)(8936002)(558084003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?X/CAghEgC8tefcJWTkFFY9tTnTOEg5af7NAaZv45AWXYJpRI92gYYsmqlxA/?=
 =?us-ascii?Q?ZXvxS9G7q64yTkULZr3UX5tLiQGxOjUvEPuLuBxSaPN028bRqWNSPnD3SWwl?=
 =?us-ascii?Q?g8zRoF+hpEo8SS2jcQsQTL8mDNkWBG/vSIeCN5eSs972edhNSxHgyl1t9/y9?=
 =?us-ascii?Q?Q6OZzMkctDNqb5cfmAE70phe0y8WVwqGO36BVZJbyfeWUBmEugEFvLU2cL67?=
 =?us-ascii?Q?lSpcGwPHhvjmMpgjwYo6Ax9OyfP27HCqxxCyNA9MdtCGwvOCB45bWY0G7Urr?=
 =?us-ascii?Q?HUAN+IENMsloVYc/xqTmswcfE7O0qNo40NKGd/otfarnrAcP71+PNvk6Wdhg?=
 =?us-ascii?Q?P48SPZfF6oL6YVfuZVruztArX9kELLZFcY9VsMBuqlxHuItsi67VLRaUUsLG?=
 =?us-ascii?Q?mc7UBeYxEMWstIXO1XkcypYqNSTWPekJdmgLfoN81v27VlbH2F5kJKdU1CGC?=
 =?us-ascii?Q?qu28u3y+gSfGX/LN9yO6kM/9owIDzhLrUCYnKp4TZo9u0csO95wAt2dv2aYl?=
 =?us-ascii?Q?7nfue1BqMwEt0VeCMMBne4LseVZOAj9GEduea0rwhdELR8dUpn3fkshk6RkE?=
 =?us-ascii?Q?A90GI4hp2n1tl8mFMgPZuyOeUnNUwX/DQTgMDDUA13ZPKVuKozBNdPT6vC9K?=
 =?us-ascii?Q?/GQas0h4YtIqWcmg9kTeMgfNNZhZQFvpolllZMEWTNrQ5+WS9c83PafE9ooQ?=
 =?us-ascii?Q?0N4kxh0r6a7pJC3ibmZaOhKGRJWKCRGh83FWtrxC01cHW59RwvT0MkfsBuLi?=
 =?us-ascii?Q?eFDaTKlqlb5BhiVcIl0wej71SC/QtJNGL1ZGQ56dOhmGAwcuNCB7YT6SA6s+?=
 =?us-ascii?Q?WtObFGUW7BqG0KA4hjqn3wodElKcM5vvUDreGnb2SkHyo0oC+K6P3iXrwMAc?=
 =?us-ascii?Q?KR1d+SygGkBndvWKlivudZPwoFM0WHmQOKyCZRj55WCUql6unRxxF0O09y6j?=
 =?us-ascii?Q?/GWBIo79XOB2+QcITHdq+5qdLpJglh4pMvJywn6NYhA6DwVzKnZtyZ6Ua0io?=
 =?us-ascii?Q?PICaa2ZKxH+XL1ULV9ikUCkgcrvf0WPOnkTqerZ2xfnQpuMc2W/VY9G4MITD?=
 =?us-ascii?Q?JzUdbsDzhGAB63GMDzz4y1N1UMrh8qqvbPO14VK7CU2hkqAvzOgubKDo6LVQ?=
 =?us-ascii?Q?jTWOr5PoGSx47Mctvlvl6754tUkRDy8ttaFcDh7GNnikrRQPEz1VtSwNAPMG?=
 =?us-ascii?Q?HzMgtN6JGyRwkFPxRGM8TMfGy+tnlqsI+wbIv9CPbbBUpnVRxSYTC/KF64Ee?=
 =?us-ascii?Q?xpo87YbfNvS8nzGQM3y9D63Zod6OJcY+je+5c5KnZDy5FvMHAmLE+SXGErlp?=
 =?us-ascii?Q?MK9Ftq9YP0m4n6y/RTDRdGxp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0119e3b5-2978-4675-21b2-08d8ef355fa1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 02:26:19.0372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wCg2bBzFpe59uVB2J8XCTGi4XHo6wF+xNHueQ2VlxBU2R6LSoF6DGCcFSC+9wklTfuAI4BmqMxDOBhP4ReO9Zc1EHUbXFvUfSrH5zttXRfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4695
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yue,

> We don't care pwr_max for post change of power mode.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
