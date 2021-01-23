Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07EEC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 02:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C74523B5D
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 02:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbhAWCoB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 21:44:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54544 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbhAWCn6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 21:43:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N2eaPB177972;
        Sat, 23 Jan 2021 02:43:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=kmBJ+jdpt2WVkfHM2gCCt5gITW2rlR59T3KA8pXemuE=;
 b=Q9goJ+E45cY2ejOIkQIuQvB5gIq32iPm43sBYRX/cf7ZMKcyNVP2CQdnEJcLuA6wjbhA
 e1ITLJiUmNds5pjvF/wnaQM2UEwti8HN2T51AIRY2ZtTCf8Uonq7OQa+5h2TRw2SRLuq
 2fI7D14Pl9Vk6pg/v39ydmIyfSQhPRFuYefgUPkVhOLWqCt/jGWHVfLS/egIiUbWyx3g
 4lLIKE/cextx/XmRoy4bDRyzn3xiKRA6gNKFJ4VtLfDD9ByoEVlRwvaKsJ+rAGA+bGMZ
 c+lOmI/LpqQpkQFqgyVHRVcjwVw/9qEXrSb8UdbgOhkzSbnhWKHKbmPIKiby27HHoUas QA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 368b7qg037-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 02:43:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N2a8e8144711;
        Sat, 23 Jan 2021 02:43:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3020.oracle.com with ESMTP id 3668rjdv9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 02:43:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLsIsKKSlotUWXKvzTE09Ote3e1kSj+2CmR0eoN3jEOx3e9xLZRLQQLFZq7HC0+ZCE6uDjGPuwRd8H1756kcvbEuj8kgyafiqZCL8ew491SVWXhu6bC36NunmD7iJWOjfS6jz6B1G439/HltmYM8viZY4oFVaZi2d7myl6dSnN/ejdvh2ZqqX5F5D2osNU0qJu3aAnAm388Dcpxcy2Wb/N4s+p6d1o0a86NgE+8DPCrqRNFLmkJFLOMN2CBP1ckTO5bGkIDvGMEjdKllKTRTYsyzpGD8+iJ3BEy9vapWJ/Frlo9DOoWRbdsmDyRCDSAPN0shU6gWnqQdboEz1l6eaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmBJ+jdpt2WVkfHM2gCCt5gITW2rlR59T3KA8pXemuE=;
 b=CGug7WpEP8oCwXUS63m/egy1DJMPMcYSI7VW1gLIrSCubNWYUpAIFdM9VD7Wbs/GVoVf7f80GFZkdO3S5569CzJlofiz7p395dp4yxDsweHhgbHu5g+qCQQedTeVDOA1byivopqOpAAhfWBFU2MAk57gXXfb2B6A+rjN+Ma+wOLwiCZ5Xt2RAbPGFFmX08PLkNG9zl5Ha4AlVvGJUlMfffFw0yMbZ5tgMVZye9k9brYyY+x9m8vpctCOicLWjt1fw/zV/8m6qOSWre7VlIU+y7TN7YwM+j2ifk0X4zAT3ye53rErouTDmIZsZ/RmZa8hsr3Rk4PeaM9NtMuA/b2Xsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmBJ+jdpt2WVkfHM2gCCt5gITW2rlR59T3KA8pXemuE=;
 b=neZd+SqdaLLh6Zkb6HKaMrm8ygVZvcSFgl+1VaHSVW49HwvnpAxVhq5SAkL+mUyQEtEIextbFxw1St9CNTPD6P94IchQt1eBX6HvGc7rKIXflIQvBqfy4Q3VTxAX08kAUmGjX0g2qRgc5wdRd5luTx7lIIWIuW5MPf0qUgxtvpM=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 02:43:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 02:43:06 +0000
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>
Subject: Re: [PATCH v3 1/3] block: introduce zone_write_granularity limit
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
Message-ID: <yq1sg6sbche.fsf@ca-mkp.ca.oracle.com>
References: <20210122080014.174391-1-damien.lemoal@wdc.com>
        <20210122080014.174391-2-damien.lemoal@wdc.com>
Date:   Fri, 22 Jan 2021 21:43:02 -0500
In-Reply-To: <20210122080014.174391-2-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Fri, 22 Jan 2021 17:00:12 +0900")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: DM5PR06CA0057.namprd06.prod.outlook.com
 (2603:10b6:3:37::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by DM5PR06CA0057.namprd06.prod.outlook.com (2603:10b6:3:37::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Sat, 23 Jan 2021 02:43:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f7d30cf-cd99-4765-9388-08d8bf489cbb
X-MS-TrafficTypeDiagnostic: PH0PR10MB4536:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB453653AF6AE512C1386CDF898EBF9@PH0PR10MB4536.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pm6QGZ4tH564vw2lZNS3ZwPx3zvXyx6Wk46FV6v55jW1oCHAbE/i8TVG+yxnmRUMT19WTkzmyWPXDCnGT9JA7xtS30ALHe5+9uM5JguqCd07RgJnB5Lt+Z1d5bSW/HhE4tp8WNtVqwRdapOSLDctbY9pGvcuBjxG4Yw0fVfsCMUFldrcu0gcKYXCuTyoJVctQvpbs3Ip4zlOcBsshgwr0LFmmVAOy9lFVsy9lzIpTb2Pr3sjqZhn3dGw3G8kDAS0ofc4vuxQvbvPxGLnbkTpIgJ2ygZtcZ7klkRmBJE13dG5HAPPYDG2nMdnjsw/+waPX50VmZn2rPPXwZYoRDGe/eYCRP4kFaAbc3/D1rQFvsffLYA2new6H9H2VSlCQxbIo3fWssIypKnN/ERnd8ejew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(39860400002)(136003)(346002)(6666004)(54906003)(478600001)(66946007)(66476007)(66556008)(86362001)(8936002)(55016002)(316002)(83380400001)(8676002)(5660300002)(956004)(7696005)(36916002)(52116002)(2906002)(16526019)(186003)(26005)(6916009)(4326008)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eRqdyddfGjGu/G+LNnSEQcICcqSB4oUTpknq02BKS5AtPX7KWulSh6bfmLxu?=
 =?us-ascii?Q?HVsaWH8EvTVfOfah35qrUM4ySyFczZ4XB3bMeVhklDDQOSQjxhbasI7CVIU/?=
 =?us-ascii?Q?n6VvyXO257Ja+lvYyyF/gefdwfFbaa/ceXY+Z6ICJBOEEPFc+JGTVOnnQFO4?=
 =?us-ascii?Q?Ptbp7nmJW+wEP1blKJ46t2TDc02YfCYvQn6z07KCFBrHQcJkthozLKSzso4o?=
 =?us-ascii?Q?qH+7+UbAmVDWXExLSRJ+w1DojOtCRGZRneGH0UOPZapX9zuVP6vMiruUgs9R?=
 =?us-ascii?Q?G5XJJgICU2c6MupIpi244qdyjj2ZNP4HdrQFV8LHM2A4T19reis8aLqZQNUp?=
 =?us-ascii?Q?3QQSEQUrV8MDMlLEDQLOpCs/uT97OQef8Je96bdsuBuGKmTNyHgPwRvYjH3C?=
 =?us-ascii?Q?sIW2vIUNl6DQnFL0bc7+paFnXZmbRwFTmLgJESqQj0RXI9DUH0cmm7ov7XoH?=
 =?us-ascii?Q?iz3V71IpywyCJg5LxNMkiHGHRRg7J3BFHU2rXXTfL3H+dNkzovXVqIpSjgg5?=
 =?us-ascii?Q?B/zfaFmmvmf9ZL9IDzRymDBifJx80dAjtsu7Xbxr420zC9VLDbsY+Goh9pyQ?=
 =?us-ascii?Q?fmw4VA+Q/u4rsb99/DVe+uEfJTowTZmgqtbgfRX3Wc6aSdaPs/M6KANohR4B?=
 =?us-ascii?Q?5B6bDLi95PepsZDpBcafZLBQK9T3I+kZV84FxjCiEujSQdmOcb3q3LsFdw6a?=
 =?us-ascii?Q?NjU/ekQ6HvxQmWBb3GnfcV1whnnJ2gmu5h9FJcFj1ruEpyJMriINbVQFNIOu?=
 =?us-ascii?Q?xYJsto0anSTX4hAqibkXd3lDrt0jXzSv+u0b+edDaDTqbQ/+KGkzm2GwUNT5?=
 =?us-ascii?Q?YR/bW4D4NqOmF1SLhzuzdv0TXrKS4nF4vW86ZRVkdVHWNIlh8luyFxy6lE+D?=
 =?us-ascii?Q?pK4IDoXCelh/JYK22Uf6wl6FWosFYN8b3DAE8oPr9+jntILdBzlfIjQ8VX0C?=
 =?us-ascii?Q?umNARe7vDtw2MAbCSH2ZZKJa/2lS1j3d4UgdmZmDGOxdyengawpX/j/HPeox?=
 =?us-ascii?Q?8+bhRtjsk3bzQBZY9L5vxjDV8G3u+2YL8y9kpbjotI/G8AQb9r27N99rdHj8?=
 =?us-ascii?Q?gfZM0lxw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7d30cf-cd99-4765-9388-08d8bf489cbb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 02:43:06.2856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NcVrDf6B8QWUKN0jxRbQgSugRjdldSDmEmEN1qngPAXkcW0Wgi8dJYNz/4y9D0ux9O8FVmIcZuwGevezABjgntO0U9f/EE6K5NkLa7cK3Y4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230014
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> To solve this, introduce the zone_write_granularity queue limit to
> indicate the alignment constraint, in bytes, of write operations into
> zones of a zoned block device. This new limit is exported as a
> read-only sysfs queue attribute and the helper
> blk_queue_zone_write_granularity() introduced for drivers to set this
> limit. The scsi disk driver is modified to use this helper to set
> host-managed SMR disk zone write granularity to the disk physical
> block size. The ZNS support code of the NVMe driver is also modified
> to use this helper to set the new limit to the logical block size of
> the namespace. The nullblk driver is similarly modified too.

Looks fine.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
