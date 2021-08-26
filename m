Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0526C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 02:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A48F6109F
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 02:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbhHZCm4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Aug 2021 22:42:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22490 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237840AbhHZCmm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Aug 2021 22:42:42 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17PMBXst010083;
        Thu, 26 Aug 2021 02:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=f1ToW+VH5+lnIQXA3KBLVKcJInLeyqFrfRRDmX4+qDU=;
 b=D22xH8MzoU0RWpWBMDX9usvrU1QcZiWwG15IZIn7flwmxreURbwA9xpjgAOYxOIIuPb7
 9WwftfZA64GzyL5cYSSt8sM1secb2NKf0nC3s7sJvXWNERy1ieRrryuurdTEGZNRVCrm
 9osxV++tk7TWdfbt9whO2pImfMdn1jW3vvn3qlj0ct3XQ58pN1uXiZZsnP/xIWa8W1wh
 UeP4TGGfnuqnC8Ywt7t8ABFfMuZMyHB/cH93oqQxgD2A4C80Hy2m2IndUzfC4Q7CAQpG
 7rpyie1oEdyljeFm3k0Ryt2dP22+mv5/+msJKozgPHGIU8OZJYazs66B3uzLTkSw4hbJ 9w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=f1ToW+VH5+lnIQXA3KBLVKcJInLeyqFrfRRDmX4+qDU=;
 b=OemHs/f4htErQk4PBrnSBHuzKRW+pbCu0kV6a0FsJ8xNDSli8PFSm8ayozjv++VvKHMB
 nG9NYAzQQOINuDHnTkWmnwcM3hZ25HToaWa0yHgL0ds7USChiTin/3mjXBpqx7niLVrv
 Cdemt2FX2p9Ik1NLtr5tnwyEd+E3MetNFqydzPBJmeVlBbwHCpYbaerQ0X6aNtQCZ734
 aNdllW1idkf+RQoefXEptMCwKl/4AQn6LIdSxva9oXqjfz0MAnq2cWlVoBzo40S9sXaA
 9XNApuKCYfGvf1qSioyTUfMdqh18ocGVpxO2rrnLfOb4Y4tujLZ1p0lnUscixV4JaRuV hQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amv67daq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Aug 2021 02:41:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17Q2ZKjc003762;
        Thu, 26 Aug 2021 02:41:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 3ajsa8e0kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Aug 2021 02:41:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2onzVvNVVoHca85iQORJOOQldA0n7ciGh39AEBxNn1DGCvGZyOuuowHDmEGiwz9UVPYhJsi0xbtGtSKVZZj6+4nHXiPsMne53MOVbegVIhh0uMXRaGnv/ORyy1lPUR5lf4+23UbWG5yRDf6R6IDNdosZodtjNYoRAAQTKBLfSTNRPMxMKSJFSWrTMeo5UlQMwUCJ4hJNBCkfULVbtuwFak6CcXJDzh4e4l7gJzMKacVGo3zpj5laekjqVk5luj/s00IiSIpsfnIREqdGQTeC2Xsx1eqtqKsE6flXa/hhIkE2YXijr2ey6Ce767TDiSqVwOjhi7jMfVZXlmlpD7H3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1ToW+VH5+lnIQXA3KBLVKcJInLeyqFrfRRDmX4+qDU=;
 b=axKl0Ika5Fn+o+iDwMxEwbWVdinU+QjH/F2tKBmblSy29t7WKiLN+WOb4364dVR2Dah5nexdtMZ8r8QlSYM0vC6iILKLAlJ3ElipPdTsFzEvDKfyYhkss4rBNrYRT7u5N8fzmDjOvDpE8zwLhCQan9RY5JPr9ytQ1h30Zq+pc1EMmLyDhjyxiRWRje++RKc1tvUXAsXGnru1Iv8TqyXrChcpTm6TRCfZflfJJrQJUoBm+rq5+g/a+pdQ90V2fZjle1heClqqY7A7z8gmFrT4GDic3zocUrOnVEsfGiZmQREXHJ58TZztZUw0iuuT8RpSgr8YOjXzDOKJVBvcATXjkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1ToW+VH5+lnIQXA3KBLVKcJInLeyqFrfRRDmX4+qDU=;
 b=lvaBxtgHc2aR//JczaZQbwC5o8/ncIK+mi/cKGD5C/41Sj06fPQ/BtUYp80stTMeLLBrwG4Io3sD48pmDu5ahUDXPVUeJxL0Rp9yV3KFIjjK/qYRfabF8M377SarXGuQdhWfiffvNwBs0v9EGI42g5nE26ZEleOyaNoaidAHIks=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5514.namprd10.prod.outlook.com (2603:10b6:510:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 26 Aug
 2021 02:41:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 02:41:51 +0000
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tujd9bwg.fsf@ca-mkp.ca.oracle.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
        <DM6PR04MB7081E6B85744B1F86AC5E7CBE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
Date:   Wed, 25 Aug 2021 22:41:48 -0400
In-Reply-To: <DM6PR04MB7081E6B85744B1F86AC5E7CBE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Thu, 26 Aug 2021 02:07:09 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0059.namprd02.prod.outlook.com
 (2603:10b6:803:20::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0201CA0059.namprd02.prod.outlook.com (2603:10b6:803:20::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 02:41:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af1dea09-cb3f-48fc-9950-08d9683b0f31
X-MS-TrafficTypeDiagnostic: PH0PR10MB5514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5514F2C493193F75EF30849F8EC79@PH0PR10MB5514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pq8dG22N3ttkwAQeGaDzEkPgS1wDb0jslLQG+JAxYFxAwJvGUUoKACIFNOhJikKdm8lrQ6TIKQEhMvRzw/3nRb1uRlHMxfPj+qPxH0ZXkiqnnBOTF3RWHzEkfriQHqr0bm94cJN6pO6GPi+NzXHDEwqEejBAVPg0WJvjH4G/r1wIuR+MtbogtTY9XCHYZq82+YoGU6cpn0uQ/1+T+dJIhrRg4JNSKUcsEquumzdr6NyCOgcFZ7vxST8wsr8wUke+K7vuFt8Gtsjotn7eh7I0U9OsjHxCcalBBvAil3N5itZar/uRNcG7APAwJn+vfePzOqSaGPrnFHOz7eQufq609lwsT3RgO650M6V8DSoj0pOIvp7ZxfzZYhcXSSM8lAfz5kxBHKe5fsUivPikcgfBVsnLe7yBBr+NcNoNKlWya9BdNq9RNXT8e6gUMdJjWW+7NwwXlPVcJ6O3bQbkEGZSO27V5RgoJLcD99Yy/C0TyC1ekj5mt9LZJDDJgYdU/0eyLwoz2kd7eJz287246c217qbH1d0VrqJcpV/Xlfw1d7byEJSTegOOeGGg3AidJxmBD/CyoIZXsb0NAUJYwVyI1K4kjbW2oyuwbB5RBkuHY8GGmAAqXeMqhFtzVkTY1wx2YL7DQQ8/2nqhrhvsX0hVMzfXY6aeTUpIhOkoCYkubUJ/pGcZ8E9nmFhEnw7dUb8dz49MzwerfQO2xv9fyBwqoGjH0XRSxUY/KT4kk+7up6aX55nnMa+CM8Sb1DGoZRuUi+7zmyE6ZCKU8tSyic58S54Cw4pP7cBx+1Gfvk1WPaY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(376002)(136003)(956004)(7696005)(54906003)(66476007)(8676002)(52116002)(26005)(38350700002)(6666004)(66556008)(316002)(55016002)(966005)(4326008)(478600001)(86362001)(66946007)(186003)(6916009)(36916002)(5660300002)(2906002)(8936002)(4744005)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y/PZ5h7StONxWsjo5SkiN79hBB1wh0IVKojBMr3n8FAy3mCMGEzKEVojqO3C?=
 =?us-ascii?Q?8io4MvcO2FdSqM/MUIJh1rNfQpDGCX/B2O2X179RUi4DFTwcKv2P4uCNdBGA?=
 =?us-ascii?Q?7cOG0gEoanCAHTRDIfW91KoLCoHFYFqhpHvQn8L+v+ABugDwjI7KXil+QlnG?=
 =?us-ascii?Q?kHeNPSBg/uFpbh0eBtHlXKH4UqGdqWinvZQHxT73BVfJ3UGf/AtCvhTZMGRG?=
 =?us-ascii?Q?t8CwPk+FscoYqlJc6Ez9U5ENDvRdehCUn2cP++3TqjVQM/kwk9DCFX3idPZ2?=
 =?us-ascii?Q?+nSa5Lkn90gE+4jLHbVbpnlrQ0KJPRL31aez3zShKDPxbBQ8vbty6G/abWC/?=
 =?us-ascii?Q?5zT6UmoPx0WfKgQoNf5DkYpI6FLIeBARznx8oFuwfDyut8aIHx0P1sAkkkz2?=
 =?us-ascii?Q?ObN6J8qKPtUFhotVn3onCaJvxcPXS74ak6HInHfs/68lu5Tl3M/8hATHq7NL?=
 =?us-ascii?Q?nsp+cn9psW0pGKdUwRfXMmwi/NI19Jzzmk9VhagaQeNHmoYD7W31NeFR0cXW?=
 =?us-ascii?Q?QN209JIurIPfK/B2rI/GWxfX4xHrsfbzMBY7uKJpjRGxK8k78R/nLQXsygXh?=
 =?us-ascii?Q?HPcx9zf5z/0Oku1oZuK8oQ7gaNXaqQGejHWA4UzUu4FHvVZfd4eD9z5oqRvl?=
 =?us-ascii?Q?tAEugj7ThB6W40synKCfkL+w6LPIpW87EvMx/ijjJQRlvofV3zvi8XzlqdSM?=
 =?us-ascii?Q?y18fNGj3CRSIHrOWlL1C0FejKwHBjs2GcuVG+MhIH4g4DDflnNNtjCPyLolO?=
 =?us-ascii?Q?tgOcqs0rSv7Ln1pkmEJygU5vVCWGkVQsIbr98AReHEYL4q6ScGpFlWIIiaHP?=
 =?us-ascii?Q?F/qY627+oq5hQrwY6jngrhwbrphg+/7ejjUwCojhz/+zVxQ/iwkUDgvImenJ?=
 =?us-ascii?Q?emKM9wT6TUoCbQtzma++2EQ1qMTwuPculkOzmDLqLNulJUZWmxr86aeKGA5c?=
 =?us-ascii?Q?LdhZnNLv95l0dP+q/vXTEmbJEUtYS42cODb/sSMfFN2C1Fa6Fr6QWhaDBbkG?=
 =?us-ascii?Q?lZHA/e/lgdSpk7wRXOTwEKV305pzt9wRwTxDy5T36goD+1UDFH7ZCSMJVBGH?=
 =?us-ascii?Q?4vn5UEdvIoRflruNj7lEekhjqt/k9yEcimBR+XRTs2FPexLtMMo2Q//hSSED?=
 =?us-ascii?Q?oQKJddAjFLUy9WMqCEIQHl/sK3aiS6vdZ5MuE9XPVPFa17jje9JWzkh2tABb?=
 =?us-ascii?Q?DK1HUr+7jbfV9yCRY9NMWkbgK8vX8ZAFLDZgzD+7HnPnyW4AKiWxvolQONLf?=
 =?us-ascii?Q?nW2S2Q6GND+bTeRCb6zALwf2qPsQ2BsD5Pux0Mr4LxnIImB/ciZx+GmfWpj2?=
 =?us-ascii?Q?zyMKaOI+CQdbNbOo4h6MjYM7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af1dea09-cb3f-48fc-9950-08d9683b0f31
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 02:41:51.8128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q+6HhA8L/AFFgys2FTQuHOI5ZLFSbd4OAsl4kNOAtFtKyt4QwzVwuctdB2K7VLkIbtpMwcTBmT0ITvHYyExfGutnNtELI1xpmLEB4Xeb8bA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=919 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108260012
X-Proofpoint-ORIG-GUID: oM_thxdhIXLkm6fmPmlAtDjG5eInMtXu
X-Proofpoint-GUID: oM_thxdhIXLkm6fmPmlAtDjG5eInMtXu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Re-ping ? Anything against this series ? Can we get it queued for 5.15 ?

Wrt. the choice of 'crange':

https://lore.kernel.org/linux-fsdevel/CAHk-=wiZ=wwa4oAA0y=Kztafgp0n+BDTEV6ybLoH2nvLBeJBLA@mail.gmail.com/

I share Linus' sentiment.

I really think 'crange' is a horribly non-descriptive name compared to
logical_block_size, max_sectors_kb, discard_max_bytes, and the other
things we export.

In addition, the recently posted copy offload patches also used
'crange', in that context to describe a 'copy range'.

Anyway. Just my opinion.

Jens: Feel free to add my Acked-by: to the sd pieces. My SCSI discovery
rework won't make 5.15.

-- 
Martin K. Petersen	Oracle Linux Engineering
