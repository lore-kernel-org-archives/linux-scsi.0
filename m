Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88488C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 17:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6909D60F38
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 17:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238018AbhJ0RCz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 13:02:55 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61888 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236648AbhJ0RCy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 13:02:54 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RGaH7J023023;
        Wed, 27 Oct 2021 17:00:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=d0cJ+wQ4lb5tqKkU0TsTOFP+2KDu6ioBq9evPzmvW3E=;
 b=ngHok51KC1u9zBqNLcNNDs6kLPEM8NuzCxTLrfhasV72VWDjY/bLZoqXxzO7tebkBhAb
 gJ8L2emNL4TNtVi+khSw4yhnfsxFFx+zAz5/8YkguNxi7ieOPjSr/whNDxL5e6nYJ5pL
 u8x2UcFeP8QftNjT7qYEVrwmB5j9W6cSU73SVee6a0wjN60qC5BsK4VqayBvrTCuP5yI
 9CYmnyqlYloQhhfv6i7N2uuJsEL8Ji6IGiU3XicX/1DHVKGy+Pil0maTsONYppCHb535
 Ta8zIf3dsNb9N8+jhNviiHm+k/eGb40Vl2/ceZdAXpmrVw/MLoqBSpUCrruGJA6VZWoy og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4g1b3xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 17:00:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19RGq1J9042511;
        Wed, 27 Oct 2021 16:59:58 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3bx4h2pgr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 16:59:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mugvi/8/nTLIXfZSQGTE/T6ot3UNNUL1gTouQ/+NBWjDS9mTcQaZO1i0OKlVMgrRHH+uI5Lc0cJ65e/5R9Fu0pYvD73egxj9pY4BzlT5KM1eENWIkPYVd5lfSPkWBVJES8W+m408Q/FPsam5BStca+8kqt5NNGzEVFXYSbKBYZ2BCvi3Y28v5i1dguAevS0FxAn3nd95f9OBJyszV4gKsgzgjvFGF9Vq6wZ0853vEhVLEn84XkM3VNKI3GrQsefQtysh9/QG+YbLX/t/P3/5YFGNgeFKFtX80be+ohG8IVoZLkTIlRmJllyUy9bvz+IQP7WYgVg90Oo62drTxIJkuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0cJ+wQ4lb5tqKkU0TsTOFP+2KDu6ioBq9evPzmvW3E=;
 b=OF68aD0H5NsW90+6dUiAM8F10Ytq8pmi+4oPa5/CnxLZE55By8PWRlHNgO1iYMf4ysWJI8G71zVdldcExHuqj6KUaBqHdOALV7R493lq5YHEc6DxdOEz00Q2/1m7g2q4nkd2W0PIneHXmS6SG4UROQA3J9w2Bo6+EaWuYR0BopIhrzAGerxhnjpuuMvJeNQvq79ubGfwXKMUvvGEqLyeOOQxY7MOk8/rgSbj/9k1KpJSmFb7MaVS1jypfKOiekGngPaCmFt7SgvCtFdj3qe9iI5KX7gluKYcJy4CoVWv+KMwt+D1Yoweni17efEGmGaauIr6qA8NQE83kr/o0zwIIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0cJ+wQ4lb5tqKkU0TsTOFP+2KDu6ioBq9evPzmvW3E=;
 b=U5bpdivBPaaprIRDvHfL5tFbpkasR5f02peJco+30o/GCpgM6vtPs5FzqzpdJzoBcg6oAXc+KPKtxltJWwm03xJuRs94aMXOkN/ERFoCm7koqP/ZLhPVGlQIXPZ8Q/+hLkd4zHHjBiste+9M5zptKfH8otHrxf6mfZV+tuSdhrE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Wed, 27 Oct
 2021 16:59:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 16:59:56 +0000
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf2ezbhp.fsf@ca-mkp.ca.oracle.com>
References: <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
        <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
        <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
        <20211027052724.GA8946@lst.de>
        <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
        <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
        <YXlqSRLHuIFiMLY7@T590>
        <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
        <YXltPgRTxe+Xn66i@T590> <yq1wnlyzday.fsf@ca-mkp.ca.oracle.com>
        <YXl3H39vHAj2+SSL@T590>
Date:   Wed, 27 Oct 2021 12:59:54 -0400
In-Reply-To: <YXl3H39vHAj2+SSL@T590> (Ming Lei's message of "Wed, 27 Oct 2021
        23:58:23 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0085.namprd12.prod.outlook.com
 (2603:10b6:802:21::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.21) by SN1PR12CA0085.namprd12.prod.outlook.com (2603:10b6:802:21::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 16:59:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28fd93eb-ef9d-4aa9-59c0-08d9996b3418
X-MS-TrafficTypeDiagnostic: PH0PR10MB5848:
X-Microsoft-Antispam-PRVS: <PH0PR10MB5848E1B0311B482B100657408E859@PH0PR10MB5848.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iQ2flBz4cjAUP91mUDvwSB3hFKUEfoKlJc4zxB+6Bj8pdih4jAJSwwgrn5ZrMQl/TM0B/Z0Aej/gg9rvVhtW4vm6LEIqDokIhwxuLz27cxaWdaU2HEvMjP1Hp3l4xXyF7iokdmDyRU5/zYVUiGscUTDlVybd2PO54X982LE4FczliL13q8hBPoPhlX62blyovqIRmYb/XgFUk3n7mM9WoZ0h1PrGzfnRJFrWqxKZQyx8s7s32NlHSSw4s4lZl+Nfvs8rQfba8JvsDOBTjhljnJiEgmxLeCzsZXcT7n+c1f5f3aMO4YHunmxHqI/3wCzT56AjQBV6ecpJ+5of7mvcoFtRpvnZO7Mhb3r+dOo8DAwf31dxd+idUaEvowwNAZkLfnAOP4JxkyBOdi8y1g3pEoCvYTliisiBgRreTgjJCadYqJwppae+HeYNAy4DiHvBzKOqLPYnLWlkQisoQDAKFl4a6mRR0YEx5BsRHDT1gEtW42sKd1HBd4npyubnXDryk7H+YVXNbIMuUV47a7sDRH8ZDcwfzvxHY/dOcXuLEhhdAHwjAyvq4GM1CtBvVuL/uT7mgS6jwLal+xw50arGRoVkA/KQlbcpp4FMmGvKa6/MOBqPzC6xnn/yNzQBy5PiK0lw3LGuLJ0w05C7BMt4FIGQ+KP0FdclZEDm2VDOYDHrMzge08UE3N8726oeU4asJuW//6Osc9GsoPyFZMUMdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(66556008)(2906002)(66476007)(26005)(66946007)(55016002)(5660300002)(7696005)(54906003)(6916009)(8676002)(316002)(4744005)(508600001)(186003)(8936002)(52116002)(38350700002)(86362001)(38100700002)(4326008)(83380400001)(7416002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XLuvFvfSRTzmq3jgqbzxvcA4JBnBQxeGOuW7Nxg8k6l9blhTQyGL9PzANT3o?=
 =?us-ascii?Q?emFAsxcqOHZ4vux8e64fMkmGY0KX1XNFsgfAHVXWTMLVthkxsgq+uLKQViRP?=
 =?us-ascii?Q?c7uFosCd2CGmj4Ao7J5AUgnGg/2eN8PyGIY9LsbCE1LUa2I9dfZNeddBYvcE?=
 =?us-ascii?Q?84CVqF2PI137HPXAKJinvJZxnQtwhBhz4MeZ1Dhuf+eBA4Sa3CiCPhpthr3v?=
 =?us-ascii?Q?diXmhROQ59DuCXuJxg9P09ksjWasFSb37RoYd+SlpvfohyroIRaIXRIuuf/k?=
 =?us-ascii?Q?oiSNNKLIYXV9+b+pldJnFKSw6PpD1Ta7Kdv3chgV/JXPDV51N4Edm80Qt+Hs?=
 =?us-ascii?Q?A9iSn+r8ZQt9igL6h3uEVftSLFWA0HOZA+TJU08U9WIHZBxytC2Ld5gzdzM9?=
 =?us-ascii?Q?YHe6akQlJXpQagM8QiMk1NqVqBQkgUi10w2H/tLYDWrAWMYzyunH8WYtC9QS?=
 =?us-ascii?Q?sVnq39iNAAntirWpbFR2mUT0KX5LEkc8BDypY76AzcYi8wjEWUtqQm5dZe7R?=
 =?us-ascii?Q?IQzgKk4deaXDBAAouIYJ3oTuJ8lLrCza9+G2lgX3Ey/eMDno2ERCNbE8zABL?=
 =?us-ascii?Q?i6YfhkXv7pDgfpSE5A9nh8SjP+F1YFDVoBYJ1e8K1UUJpyMX17rh9svgFtGG?=
 =?us-ascii?Q?7I7EylXmyewGvNC4guYh96UKfAt7V+bPaSKG16K8B5RFhhOsfZ/I2vs3LbJv?=
 =?us-ascii?Q?MtlIRxY3UcHRFNBPkxX4SqKB6SDH5r66FKjoQXAY/Css7jlBFj1qY2yO+Z26?=
 =?us-ascii?Q?HiCGKupBTzqmwiDy82rE5HTEVkfE0pHFIllNr586shLJWwvATvefgsFNF3KI?=
 =?us-ascii?Q?b0XPaUm6sxrKdj9WZg08BzwmGvzfCKr0pJgFU+1KTtQNNHOY1mNGTmxJ37l0?=
 =?us-ascii?Q?bXkoanq1ljUllwimqIIzCZZJx4hyt7SWKGT9JgbC9fxG0tcLs4z5PMR8jUsr?=
 =?us-ascii?Q?sKUCp5n54rRH/a43NVzONqaHe7woEgErslTKdSynCN0hb8nbdyl66FrQvcQo?=
 =?us-ascii?Q?mvYO4aA4aQYvbxA9iQK45X8gld/52ECPQYAeO2lhIS+UPJKT+4mo6cGWluUL?=
 =?us-ascii?Q?JTJUKDYU2G/6ChbSfeqgk5jJtV48suz4vCaA5XqoOifMmuITe9H6tzQLKHLu?=
 =?us-ascii?Q?DbvLBPvtSBZ6hbO4CXuMFPWZAZ2GheKBhku5S9t5Blula+ods9u0DsU6sgeI?=
 =?us-ascii?Q?W/jBsQyFzib2As0zjiGTStBLjMVKPMz0Q/A38kqSfsPLTbZdKf1KBh5VMFhd?=
 =?us-ascii?Q?2JgYhUFRsne7Yt8h4UH3XeG2FUiuM0l42tYM4CSQleWV47cg8tOmq/sXh94U?=
 =?us-ascii?Q?0T5lVjbEbZOfw+BehLfN7mKkVp/2v4g/xgXV8p0aGGSRY4xVKwXiZCne8loN?=
 =?us-ascii?Q?DLt7eH29J61N1SxIBiNU2HRi1UgxvbDxVRdGT5fFId+osF1gxHoHglBba67X?=
 =?us-ascii?Q?eCGKdFZvrSiklUQt0aRpUK/vfzp8jT//u42NoX7ikDhc9mbBPC2XW9In/mcp?=
 =?us-ascii?Q?0+KIi97LMp1bQav9eIv4eU16Yau9QploIzvdkAinVX4BzixkRHZNzwpTB7MB?=
 =?us-ascii?Q?4ftDUJbJ4g0UBH0x90BjpgH1M6yGZYKwv1BeLChZQgtyFIKj+Fvre1RhrIQ0?=
 =?us-ascii?Q?Q+4oSKrhFUDk+bWTU9CK3VJVyu9TSeaKZZ5jshiisM6/ai+MpXYENdwV82VD?=
 =?us-ascii?Q?WxrooulvWv4R28lqrYVBMePZxwk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28fd93eb-ef9d-4aa9-59c0-08d9996b3418
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 16:59:56.6118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZlwtR9ndyUUfqMV/KQ7bLpt3o+EKTdxITZ8CG2xyg8gg1CKecadCiGG8vLuyVNPRbvrFw08LC+g1qfdJV/vVyvCz6ihe1WLGgDwH5z2LBk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110270097
X-Proofpoint-ORIG-GUID: PhuqfrXPhVuCQx09lfAKtO39zZid6dGf
X-Proofpoint-GUID: PhuqfrXPhVuCQx09lfAKtO39zZid6dGf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ming,

> What I meant is to use one totally ufshpb private command allocated
> from private slab to replace the spawned request, which is sent to
> ufshcd_queuecommand() directly, so forward progress is guaranteed if
> the blk-mq request's tag can be reused for issuing this private
> command. This approach takes a bit effort, but avoids tags
> reservation.

Yep, I was just noting that error handling was a better example than the
ioctl given the context.

> 1) how many queue depth for the hba? If it is small, even 1 reservation
> can affect performance.

Indeed. But there is no free lunch.

> 2) how many inflight write buffer commands are to be supported? Or how
> many is enough for obtaining expected performance? If the number is
> big, reserved tags can't work.

That really is something the UFS developers need to work out. I am not
sure whether permanently pinning down memory is a bigger problem than
queue tags being a finite resource.

-- 
Martin K. Petersen	Oracle Linux Engineering
