Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE38C432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 03:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E8B760F58
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 03:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244068AbhH0DEb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Aug 2021 23:04:31 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:45812 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231607AbhH0DEb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Aug 2021 23:04:31 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17QNrrYv026893;
        Fri, 27 Aug 2021 03:03:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=7qKZqkBGVlFdpnFnzNITqNMvrHEpkJYhEyR9Yk9GtQE=;
 b=uVvZ/mavswKp/BMzMpb3y77Nw1yJ1TX3VMy9MIIwzZgFDPutZ489JBgUxcuijVX3E3Dt
 +aDPRejl4U51w3Rcxwh54IFCVNIqy8fSKiANK0lGOaJaJh9UOmLsFq0dw21W4Evl8erS
 b+r4KKunHNeG/A9VkEDxzJ3KIcsZ06z9jHpW2p78vbnoPt4I3TEe6mmSNAfFxm6Pzf6k
 Gy+9w28VHWopqqRIAOcRslrmFTy5mkHupg2Rq3ZSfoArnItFjsOmnYS9hdYSIMXD/MXj
 zvCXRyxrX+4X2mvxPIQ9R5GWTIjANpZjY8kSh4sXAI4DYpdlYh2u18l+nNi7o/8anLUV wA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=7qKZqkBGVlFdpnFnzNITqNMvrHEpkJYhEyR9Yk9GtQE=;
 b=SymcCGLdXiiQgS5Wso98KLqa9T3M6XHz19mNTlYNDWZaNIix4iinyieNScazIt3RUflV
 NyOeKDsnHe/vUkyl85Mv16rM+hbkq/H8X7oRBzh3kw/zrtn+xrbTpI/cTgjZ93MxFSTC
 5S67BqFhyCaxzfPPWueylMnl+aJT8KHnjclOo4RdvJdtrDxv6PJUbSqA41W0mWq9rDf6
 VQpKjpjLxb/cbV34T2Pa7Raz+2SOjmia0FE/yD3N0G8Nx4RYRQM3TW4H+o02EKv0DPe1
 +OEcBl5V5xqV/d8s1szzFsilmBbnKlSo7Mo6khmpbQXM9Ug6xcSf+EtLilflLvlayGk3 /A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ap3eatmt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 03:03:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17R31gEv082650;
        Fri, 27 Aug 2021 03:03:39 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by userp3030.oracle.com with ESMTP id 3ajpm3udtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 03:03:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6ZIimJX2P/uxgshW6IW/AdYHLOOhOa0KUzyaxz66ScVZDaUDRrHS0/H1YZRrFdmvZ1LUspXSPAigG4yEmHo7kJNy0+d6Fa0Y0g9COEk/0fW3b1UvUV9XRtpwJAUg+c1HQEyHkv8u7x/Zwp3xtIvXzgYDbnLvBhSEdOa+fWSSvFrfLVH9+LK7tP9iRTrEQ4sPuHbT0ARpt/9NSGownqW8wTxbOtWmb5G1HzPN668a0SeuqOzGijfE76ARdAxg5KR6iVZ0uSD/yZVteQ5DyJKyzkGNDwUx4gdcjy3N3rb4OHMyS6lrhFeGAC9wbIPrJoX8Rr0GktpakIa1TKtVkdtFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qKZqkBGVlFdpnFnzNITqNMvrHEpkJYhEyR9Yk9GtQE=;
 b=YaKmhxS8T3vS7yjWUDHw47Bp4qkm9AgAb+pjlYL+qVnjxvmBWzx0a3SRysyhbf6vVIlTyzETUWuL1utffDSfrb80MWnnSmSFrrWT02u2NYprBAn+iSVimac9nObfiPAyTf5Sr+RXPk6VTiuSxP2Yl13MEjbCKGy2DbCesqOLglrsArWPWMESC+rpL1thd2IMsf6gQjBTXGQnYkavIsIAOCMZW1Bn3u1gQafW5S+Rl2UDsctr5ZgXPS+D5wiccxTRFwpqVGGzE4UPY2lfR93B2/Q+Fe1h+TWdk3WpT/UZ1DpmmPnnuNH9lzh9EGG7W6klM5nad+uQvLeHGmECg+kpIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qKZqkBGVlFdpnFnzNITqNMvrHEpkJYhEyR9Yk9GtQE=;
 b=See/0WUIREO6hOfAOXwLJNviAgVWz+0t6vZMV+ynoo2MSdZcx+/EZoZirHqms4P5iKg0hCpbn8Go036x10/Q5YrjBgz9aD+3oEkTTuzdQuhnhMD4ZHxf+uYCPPAD+6IL0k+NdSD6KVhsfQ97Mv3EWhjRg3+JRTJ03H8n9Y6znks=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4757.namprd10.prod.outlook.com (2603:10b6:510:3f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.24; Fri, 27 Aug
 2021 03:03:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Fri, 27 Aug 2021
 03:03:36 +0000
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r6f8wkf.fsf@ca-mkp.ca.oracle.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
        <DM6PR04MB7081E6B85744B1F86AC5E7CBE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
        <yq1tujd9bwg.fsf@ca-mkp.ca.oracle.com>
        <DM6PR04MB70818AEAA6539E3834519E9AE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
        <yq1ilzsannu.fsf@ca-mkp.ca.oracle.com>
        <DM6PR04MB7081B82BD60E0C96F31C84E7E7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
Date:   Thu, 26 Aug 2021 23:03:33 -0400
In-Reply-To: <DM6PR04MB7081B82BD60E0C96F31C84E7E7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Thu, 26 Aug 2021 03:50:15 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0080.namprd11.prod.outlook.com
 (2603:10b6:806:d2::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0080.namprd11.prod.outlook.com (2603:10b6:806:d2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.21 via Frontend Transport; Fri, 27 Aug 2021 03:03:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5082b236-fb3e-4986-ff9f-08d96907436f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4757:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB475741E58D61C32803ED82218EC89@PH0PR10MB4757.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Np8VkU89kik2soJiaPIZWKQMpeo261uAb4OVC37U4Z1mAfdR/D+04rE4PaZrxS/c2+0AYHyJVawXhriV6yiUoxhNmdvqQXZY5A8MzXU0VtKFdRiwQPq7W7l9XafWJSCqRdOu2l2ujC29rtDZQLpend4yCUFTHdPZsfBGHOB9WDuXXoBQqzPuPSQp6gOj3P+MRNPLefl+jzXDR4dFvBj8zLWVUyOxepByK6GCreobD5CPDUHn7VAqbUiZryoxtlFpn4DwOJU7xTmP6La9ESuMfwrWNFuzxjwRZOPJ1UpEOIdIxXeJE9QYP0PskvZbwBFOcl28IqSiBtYNjZDQ/tgxfOTYEVugYSNB+EPeydQ4hKv7Gcm6JxoD9S8tBKkbO+60d6ll+SJyKJp1VXxr06gYFtMkG45Lvjbf06OUwXFzDDjMSXd+lPy2xlwjlgqFigcML868BuDT1o14T8sD3pKIwUAoS48JAiY76Yc8LyEFZWFotxs2yNG4NRuAMCgZyksas3mHL6kXsSE4Lhip34RXrTuv5dGBPP+TVeWGYxrycw9pDF7MP71U98PabJYIefVN9VPSbyC0tKD48FnXvBp2zl9LMvtTbjvCScvOGsBOUmD6go5C/ZrAHliPZ6LARo1Z6mJkp0sSZWAG2/wMS4UeGDrwZYbJrveZ+Jq3R8W7IFcecKZDSQ6bFB8jRInaKxRNZLhEYDhkzQEm1Cf/bJ7pSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(346002)(136003)(478600001)(83380400001)(4326008)(6916009)(55016002)(66476007)(7696005)(86362001)(36916002)(66946007)(186003)(2906002)(66556008)(5660300002)(26005)(6666004)(316002)(52116002)(54906003)(38350700002)(38100700002)(956004)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ev3I11qxg2/t9NqdfBFHEixiz6+uyPVhwabvv93BzRBUNfB7bexhYt3n9qB+?=
 =?us-ascii?Q?aPzPXxncdMePBZj1n6JENgUtFkbbGC6Jj0ytq1/VxlIHNaQmjEVlyLSeUYcI?=
 =?us-ascii?Q?MI12hFYi7TpguBNZYAMGBxlLmVIEzP7v5Wb+WVDO9lmSIv2gfAYBTW7cCoks?=
 =?us-ascii?Q?EYV4OKIEEvXURK2Cczh05zs8rNf6DzSJC2Hkrg7NPIrOADzBSDITPNYD02Dw?=
 =?us-ascii?Q?i/EdKPqWrfnWbhjQdcstS2oNrpj8BWSDZSdT4MGB674hCQ4wmBiqqAuHzH8G?=
 =?us-ascii?Q?qqBcQCcvZoLtOPAg/20Arla5vX2CkUKYZZaBUo9+8CcuiAUlueFhhIWWruZg?=
 =?us-ascii?Q?cIjzDzV43UdwyAZ3UMLqi7ERH7itnmN1LRjuMzTh7L7xMfGG1siXtzNtt4Yx?=
 =?us-ascii?Q?OJmoqAS3Th6e9DSyCXZ6fVkDmQ3fZCsMe0q1l6aE+wbgQxRuLeU0/oRE9Dj0?=
 =?us-ascii?Q?/RF8Eq1q9IhmS3kBSwGU7arkJcKa+jGSmeweUFIM7XRVSGrRfYdYNrcdJwKb?=
 =?us-ascii?Q?qcw7q0whX+dLC7GAEhbu3JXPsR8cu3IyyOTxggj/m4Q7/buwIZ3UnUQ3N5LG?=
 =?us-ascii?Q?96Zq7iMeBDJOSqdGILNF7fmz7tdEPkZ33f/YDXs/8XB148GCXi4/DMxLxvQj?=
 =?us-ascii?Q?ixKj+O8JqroxoFS61UdqsuonNG7i2wN4KSlroCfYOixYUwOU8piQbVyS+0EZ?=
 =?us-ascii?Q?1n/6A+T3LX7iMlviDNslDedsc7PzJ0P5QxFDqkdoez98rC8ki6fTV2YJGzUt?=
 =?us-ascii?Q?aOIeTg5QoVE79dJh1596R3iX8WCdJKkVNzrC1Bev41bVDJ0XVv30YiKhJmIF?=
 =?us-ascii?Q?YqLi5Reyv3OZHyDNUFnOpucwne5r0OL1+p6PjzUkNOgLUkCvIxc6EZWnDGC4?=
 =?us-ascii?Q?i7651y65UhEvDsZdySkWxDI06xkU1DfF5LoK5Hf8EH6iEreKeDYmv4Rn9KrZ?=
 =?us-ascii?Q?WltE8rLvjbPjoIo9J5qUYXAkocEyHRBiwTrQhLfsfEmBxSN86VW8sZN8c6cF?=
 =?us-ascii?Q?5JV6ANEK6CJGYB8FS01azNRsLJL7gvaPjP9MfH7v2pNiCvK8/tDhpB8ym2VX?=
 =?us-ascii?Q?u9T6+pPWphLqGJNndZcGdzmlYZRPyKY8k/KBRsP5JYF66J9/LW/mDZ1EyL46?=
 =?us-ascii?Q?m7SiwUP7iZKMnhXvLf0Fsl0jF6UN+QHh48zdW0OUZdbtYb1iu5Eldu/WOTjG?=
 =?us-ascii?Q?KJ4FZwAOIc5caNO2F8yRdj+/oO1Fp2llAqfg+ce447CUzae+qDFbsrPdKB8O?=
 =?us-ascii?Q?z4FNPGWtcgOGVtW5US3/DRsCc3uUjsf3mjuyGDthosi7B9vswUk+lI5lKP/N?=
 =?us-ascii?Q?YttAksqBAnwBlbBmOp9EAyJu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5082b236-fb3e-4986-ff9f-08d96907436f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 03:03:36.7891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vwvFlid7kHH93aGuntjkBAk1wUGhz+QmBiMIsteWDskOR+6pbC/CCrq+l51te7S16oeKvrWoW+KiQY0A8wHdnyuqkjD9WUel7MBaPnmR9ds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4757
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10088 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270015
X-Proofpoint-ORIG-GUID: pyg7rUbj7_kv4XAXTKF-2Kic79xAyjjV
X-Proofpoint-GUID: pyg7rUbj7_kv4XAXTKF-2Kic79xAyjjV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> I like it, but a bit long-ish. Do you think shortening to access_range
> would be acceptable ?

But doesn't 'access_range' imply that there are ranges that you can't
access? I think 'independent' is more important and 'access' is just a
clarification.

> Adding independent does make everything even more obvious, but names become
> rather long. Not an issue for the sysfs directory I think, but

I do think it's important that the sysfs directory in particular is the
full thing. It's a user-visible interface.

If the internal interfaces have a shorthand I guess that's OK.

> struct blk_independent_access_range {
> 	...
> 	sector_t sector;
> 	sector_t nr_sectors;
> }
>
> is rather a long struct name.

True, but presumably you'd do:

	struct blk_independent_access_range *iar;

in a variable declaration and be done with it. So I don't think the type
is a big deal. Where it becomes unwieldy is:

	blk_rq_independent_access_range_frobnicate();

Anyway. Running out of ideas. autonomous_range? sequestered_range? 

-- 
Martin K. Petersen	Oracle Linux Engineering
