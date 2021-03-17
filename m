Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97767C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 01:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 746A064F97
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 01:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhCQBmQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 21:42:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33200 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhCQBmH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 21:42:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H1fTUS098968;
        Wed, 17 Mar 2021 01:42:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=nP8msNNNcqdSrdR6gVARRpraW5SZdFMwz4SkxyMm6ao=;
 b=OC27S1QrYlQNyVV+rrInjFXVRN7aZUkj1+fNASZZn3hPIoZkxtbv5PsCv7xg2IRBRysw
 i66Ku0hPRigOb4QY6ZOpRWfU20NPOp7cnLBkKUu0gjViQDoEYuFHoVvGNmAktdhnsvDo
 TMyLI1FbFACMO7IdLmIaV/aEg3AJ/jq+b8FAJWLz2AZ4D5EzA7+mwv9YaLHJG1PAbwHB
 YGop7SjVrlJhZCD1OoPxBsY2WcGJO4NcoL1mceUErHzEBtFgL5QJUyW5j1RCu/G+duC7
 hqWfkMxWVlXFQcLwAcFHNL6P0Z2r70fJ7Hy79tv5olkdcVNnj+1n8flJY9JEcBZqGD+g ZA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37a4ekqepc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 01:42:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H1duse082479;
        Wed, 17 Mar 2021 01:42:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3030.oracle.com with ESMTP id 3797b0v1kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 01:42:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EP2JvsuBadRexQHVCfwreeiSYunRn70Oof4DBHwl4AXs0E0iuuDXfVcj0S7Q5veZX58alvVjp4GOVkZbJZgyavp9ISd6FI/DpcUF70d08PS7lVvc2Pn4le21/3UdIsrfiTprA7GXQYVpnUMQstGEY1j3pTN4qGVZrwg8Z3XyYcohdKVdjYZf8MNytWR4BsQrUROjyNJrspmoF7E2VCUbt2/FOtZFZ/uLko0vTZnQUkrfO/v4Im08ML7aOkaEvzJ9NP0+4EuYE7zhNYCF1DkiIOa9DhLYspjVXAsghoUrWQW4m0eC4SieO8R5zWjN85GAM8yqsLso+UHSwg9q2G4KFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nP8msNNNcqdSrdR6gVARRpraW5SZdFMwz4SkxyMm6ao=;
 b=k/8Khk5c/Z/DaAmMXXJFo48A3hgevx1t/6pl4Kh9ZaH7txVNFNC/ZD4AbCSMnLE7cSBUjN/26Zz6BYN0+2XZsDoSrGjM4/c4qrVA0gGjhPSLcYFVXxzpZgXq+z1fWGUYGmnUD5MW53mANWq3CG/KdHTOp5zFOLgC2N5aBknmhoOYoMwHpBuQch7I/CDUW9bg0Ry9KsbxJS7lknsDvuC5GWDoMQGMsnKdkwHl1/w+w8UfqPC4rIuRcgRSlgxp+DWMJKy5ZkvYZJj3USvVWIEiaECumBqx3g7xBNxSOG6aeUwCs2jMHVgVFcLUtMNdTpAz8B9bu1Jss+QI3/r+Dgelww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nP8msNNNcqdSrdR6gVARRpraW5SZdFMwz4SkxyMm6ao=;
 b=hnVQW+BwW+00DBo+td9XPfErk90omDF2S29IkEJujo0kekzqiwnOTPeliPfUYgEH3Ko2gENFCuNM0j73B08KyXQyuXGq7heFK9VuB3zEPfnuWRJmPHZnrUR3gp8KDxfgv6cjQHUoZgjUb0gPDNW9Nnxwf2FMgqpRqqRz16J//PE=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4743.namprd10.prod.outlook.com (2603:10b6:510:3e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 01:42:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 01:42:04 +0000
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z1q36eh.fsf@ca-mkp.ca.oracle.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
        <PH0PR04MB7416236DBF6578C221CC65319B6B9@PH0PR04MB7416.namprd04.prod.outlook.com>
Date:   Tue, 16 Mar 2021 21:42:02 -0400
In-Reply-To: <PH0PR04MB7416236DBF6578C221CC65319B6B9@PH0PR04MB7416.namprd04.prod.outlook.com>
        (Johannes Thumshirn's message of "Tue, 16 Mar 2021 07:53:24 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0007.namprd13.prod.outlook.com (2603:10b6:a03:2c0::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend Transport; Wed, 17 Mar 2021 01:42:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dda7fd35-a5b7-4228-c206-08d8e8e5de30
X-MS-TrafficTypeDiagnostic: PH0PR10MB4743:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4743FC31FB51B5F4CCD941218E6A9@PH0PR10MB4743.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WSoyz0x3mdU2tIqgAHskTUPRbwnyK2NOlhngUKG8IZni68W8ujNNIlieFSw4CIn36hZCB0mMHDu0riVkTm5nVQnbCSoFF4LaFy/eR9FEoAoQpPdb1Ow67DwbW13VMtXUDsDhEs4vQUmuRtFAF/z4rmVtLxtZr3BQJwnoKMGmchQYo/i8ZBwtBk1+9MXpqtVcpQINl6SAf05k4z1rX5CHUQ4frlILWc1gtw7YK1g7OKjKNWgahKUwznNVLeF+mfe45s0+TGwE8uiGFhUEQplyMCRXX/hRWYnTuDcyuDMASqKlENeRVO0qMWDSvXe9DqQhPSaOgj+M3XXk1JRklSl2CoNJ8VQaWuPcvnNMlWt27IenOdy1BQuBmZXpHIaE3i2wDvvg+TfYNUGIP7GZf59MqitBhXri8trgv2Ad28WKSK3UCt27/VWC6AhDhiguVG0aPFN0ct3WvyVuIyA7WGLtIS5PilXZtJVzoxlIiIza70wZyDh7IU1aFun9ibNHjCGrbDppKfi3FQbiQpfUiueNCne+dL+PM/UPASCvt/FbHB+gS6F2wwbO1J4MgLy3/BtW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(396003)(376002)(8936002)(4326008)(26005)(5660300002)(7696005)(2906002)(186003)(16526019)(54906003)(956004)(316002)(8676002)(55016002)(36916002)(52116002)(478600001)(558084003)(66556008)(66946007)(86362001)(66476007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YQgbB0S2lNXKNzXBRcVu4YW6GrppMurRYHuU5Fhq7lS8CnNkIFnIXJHzW4jr?=
 =?us-ascii?Q?SUGfEfINE9/YfssQVHU7cCJ1CvRbJrct6StAo17P8+JIEHIKcecisjoKBOK/?=
 =?us-ascii?Q?7GXF3sYev0FBTfv4t60iMiXTBdW6rZ12QDHEKaIf7T6rxpcWEaNVvzzwKGeR?=
 =?us-ascii?Q?GnGlgAXx8jaNX28wEc6gMonbBsZcxLiFe6F94F4MAukuoYFMNPYgJuAw53Lz?=
 =?us-ascii?Q?wLZMaE91TNOMYIuWN31K1YTrkeSFv2UDRmz4zU4YRnxBkdFdHtCqKrG++gSN?=
 =?us-ascii?Q?b4SmTWpP5K9vZ5Jk08RkmVwFxKmFDLP2uWSdzBJQ0h9AmT8mvsIi+UIVkxbh?=
 =?us-ascii?Q?JFxoWK5KDbb3Gq8fxSl+KeEYu7SIpex8RSVfj6fBEyRtw2f60LHsRWDuUnoz?=
 =?us-ascii?Q?ju/gJbBxpfxZWewM6LZdNm3oVOWS5rBrnUdUlT/0isQR2pWUpXwkXjrWPv5g?=
 =?us-ascii?Q?VShPZyAf/JbrPbVPhqjrQmkCav+2F7A2qpbzCyWAa1sBTJ+4zbKuc2NRv3se?=
 =?us-ascii?Q?GgDGSO0f1YlpwDuY3xG/0f7YXTGijZ9owjgleZFWbYp8p+Bov+V+LUMnM7bs?=
 =?us-ascii?Q?V/GTXa/zl9mc4Ep0dMmZKG9Byt7idSNqMjIhpwzSWktCOxf8x9+v0Rd8qqZN?=
 =?us-ascii?Q?XLNSbrjGZQyEY9Du9Q/QkHN75u14jBPeJGR1Bqf8I3vZ0/cHRQAlpQDQ7Tpl?=
 =?us-ascii?Q?RRY8b43z6tUWtcLqapWvpl6fGJIzAXzAKoqcYm0qq/QA3R55kbfgE9I1mLkK?=
 =?us-ascii?Q?8EbVGRobQyn+/M1Qeexl4Ohg/ST/H3bTkGi7qad9IMeWwGb7CnsVm7x1p4+/?=
 =?us-ascii?Q?sKxXKIw5ok5SYs0rBe1KMqI9L+yjsGN6pdtV+n/PLL52VJlVhYH/PWm6dUCC?=
 =?us-ascii?Q?ZdrgR5YLBRFfEPwAh2ygG0pmu7iCRlf726w+G5sgHc0YFvb4iULS3dIyLfid?=
 =?us-ascii?Q?nSmhMv2fNPlyxtJqMLQXQE6tfpKavnrLHbqJv4PFtrEhH5VBaB/ARH/BagJ6?=
 =?us-ascii?Q?MJ4oItf2FPoq5PD9VBT9sNrbEIjUfs8RhNH/83EJovyHTGxOntOR+iRBEgEu?=
 =?us-ascii?Q?qQkGYIHF4dL824PYxhv6GCPQmJYMSsFyQbfxuSCrVj+ghltJyYvMO80aWYtw?=
 =?us-ascii?Q?EPtjM/1rtuWk/yu/7zGqYg8VUYlFQOW3+MRxKWB6x5wqjzaf4rdxHw07/qM+?=
 =?us-ascii?Q?ZJ2gDs9VfylzVakvTHCUanYNZp3UyId1iDdd9c80zKR4g4CgOwfiJG9QxoWU?=
 =?us-ascii?Q?sqaotGJ3lm0H+cUGo4OK/BkZNoaTxm/+B7Qr9mBHNLCcHzomk8IDwef3KljI?=
 =?us-ascii?Q?uIDLa8585C9CJukl5DrPQIry?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dda7fd35-a5b7-4228-c206-08d8e8e5de30
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 01:42:04.6972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 503I2kznYs2DBAAZ3w1pQelXztVmnsNatHQpL83gmOTuLdoz7u8RcUsPTi+EBlQjs60anHiQOXC1i/GOZlwpJGZr9QlxZPzxxoz8+vo+lx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4743
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170010
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170010
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Johannes,

> Martin ping?

When I originally read the thread I was left with the impression that we
were just papering over an underlying blk-mq issue. However, I read the
whole thing again and feel this fix is acceptable.

-- 
Martin K. Petersen	Oracle Linux Engineering
