Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E131C4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 03:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47DD061185
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 03:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242702AbhHFDm3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 23:42:29 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:59050 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231173AbhHFDm2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 23:42:28 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1763evNU029382;
        Fri, 6 Aug 2021 03:42:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=c5yCSohvQbiHy/6iUCOGQwTwXkiLm7TqmzQCcO2RFpU=;
 b=dMyC9WS3yIDnHyJKx092gUZdjTIc4R4l9uUNf5Z7eCUhO+TPoPRQjibwVqdKgf3rxXez
 x47uZOpbZivb7gQCWJAEhW6s3OV+eVwXTouDUvEIHDhnkp/4Z8Dd8NVzUGI7c8lyIA98
 csJ8KszNmSrxByr5KBU5ohibG83l8THn0QdVZS0wVkqL///Mz4kSUUTjPc+w+iIrhqu0
 UHHjpfMKXj+29Iq3lxX63HWUpRooflecMSPCO+QUteqF5RcBagYhPuOEHMxTDXw3GC3c
 9rDYDDOtTGqoMbZMO5nN1FV5L7n1UMwG6cmE9/cx1birYaJI4SLx2T4gJ97enjFRgPkC ZQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=c5yCSohvQbiHy/6iUCOGQwTwXkiLm7TqmzQCcO2RFpU=;
 b=Tp5f6DZorSM9OONwKt622XfKT9GtaSCZCUlQZy9DwPrTfM+Iz27VG/U1xLhpkxv72YyL
 j9XGCYmwJgrcN4Ao7Dg9CNSk479HQ0N6rsE9yQARGewXz9Q0pjHNw/m8BjI6C7wUKPMO
 nBh2QRFr2n6bThR1QX8ED0gwIIUki7L8PBjds9Eyp+yRdHx1P5f0xI+q+ScIwNvQ9c+m
 yNb9U8IuGSHqDi21EpZ5kRdIB5DM1WPD9FQ7dQe052TfOlPJKh8bm9CV3e2XQR014hC1
 zI768Yi9vF0eMimABaLVHYd0TBf/NrSQc+OrFBZafJh/fLBbyqlT/cv9mw3VP82slU6N JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7hxpnmcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 03:42:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1763e82K010686;
        Fri, 6 Aug 2021 03:42:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 3a7r4aw2y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 03:42:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+MQLAVCrt8T4EjcvvQKqIBLFnv0mUg2unHPL/IC8+RjpJnP6OvIoUClJCHtlbV7QpykGHJzoH+c+diWa+zwUfwg6Q9AQdI4tqfX+MWv9vFKTnjCwqXxQ0yHJxZafN04rEEBy1u87B4mwKoTds2SQvLM1o0Ht77rZqI+sT/xJfYmcmUTgw0HN1vX7DFi4DAtB1rKNoL76T35C8ywUaIEHklHLlKOurCd5Pq3GbPIiF2i4no4Xl5fDpS3I3SRI8n+neGjTlWGbHN1iQ2D0InEhL9r+fVAqYBFw2ZIAUBdIvgjKG+pRMdqGzXwrhA75iu89Jm5mrcPDQVqZeaSRDOWIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c5yCSohvQbiHy/6iUCOGQwTwXkiLm7TqmzQCcO2RFpU=;
 b=Pk6z7jEM2d965T6Sbw7VOiGLZ5cZpXlCWp1WlInqz74vHgltQRVIEo0zxaVzreGOwxDmAtSp/Bdlz2g1i5gyU8jUBrlTZDJSzHrqi5dhGXbdQQH+k7DTPIGhfb6VGM2Hd8FMMoHal6PSfFQKNk3PdtY+dYVwDnrceoL8XDc/WiBPMysn+qVkCcKjvpXoyiziKgQwxpU1ZEhf1+K4Qt/BRm2plA2jFEFd83uXiC3jWHiHK6fGiITFUn2tunsZ0gvdjqFt7VX4+eBryHbHHMmI/R6KZhLcxUYlRzmaOZjIQY1rvC9oedEuCn+Q+KhxLdKFiougWBZpM3xyPM1Qg5bc2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c5yCSohvQbiHy/6iUCOGQwTwXkiLm7TqmzQCcO2RFpU=;
 b=U3XIAM+fpxizIVKeZUmBCUBnfZVGFjh+9YuzvDr1NvhEX2K+wS90gXAEoYsYoz8yqqG4cUPB/57eUL7jCWJipSA28zchCveGZszEXDIRk3DQt6wlIiSq7tJOrjs6nSsZmle89qFQ5iPbtmtMsyDvNEJ3WvOCnmBrry/8AKid270=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5435.namprd10.prod.outlook.com (2603:10b6:510:ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Fri, 6 Aug
 2021 03:41:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 03:41:59 +0000
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 0/4] Initial support for multi-actuator HDDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s1ffdz7.fsf@ca-mkp.ca.oracle.com>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
Date:   Thu, 05 Aug 2021 23:41:55 -0400
In-Reply-To: <20210726013806.84815-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Mon, 26 Jul 2021 10:38:02 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0033.prod.exchangelabs.com (2603:10b6:805:b6::46)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR01CA0033.prod.exchangelabs.com (2603:10b6:805:b6::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 03:41:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb46a4fb-ed7e-459d-c81d-08d9588c253e
X-MS-TrafficTypeDiagnostic: PH0PR10MB5435:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5435360E7A843D9F0CD39A118EF39@PH0PR10MB5435.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQSDdOYXHZ/u7dpNTk10UdjN0KNKdWyAXI1ZFXrplWHzNtwXt19RDenZtpjI5aicr9CgnAWsszkEIkmVmHl5DSnJgHn/9jWk8gdjoTvi30y5GB/uQAUAr2gGiIo+hBWUaKdKgJlRAFsz8pggfY/vmRSfT8t/uwVolkYlQoj0CVjUGHOO3slUJTXG2BlMY85jLmbCJSrY3bsk1spGiuuHShe/JxkQd5zTzzI0OXE2xXAheyy/T6O2jqKR30nlCUTj+7Sieh7fZNWsP4+HO0TvxsAgAHXBoOa0pVKRObNF0ovJAZAV4cHAklwRjEUJXGuKe5sH7ncB2s0QB9UDNpKUHhNhuZnoaWvWjTn8DEd+EmOHtQSrOwNEZvy8yh9DSej0+cUDNoTbRNaPoQVaAYZhMhNahM6Q00i0jahp1UnrL9POhVr0Wzo111F/hkBSRc0LEtC/lWMzKE/EkHs0K7jtOmEbD3OOrJ3vU8Fj++XI6huswxCDO45oc9e3YB0B/8jIDiZcuY9BR2bdrZvOkhR2TbhidH7eQAiWkiP1Rp4Z55vMok7SqvCHqpiyhhAhUcQVjRmNQja4trsldm/TXWuyXlCqX2fogjykS5r4DJHlAWKD6COI6hJibEoirGnEO/wJdL1M5yq7dyLvYGrJnmqn52tHGlIV9RRkwQg/KMCTNQXQOks+B6aWOi4p+uKfyGuQJ73q+iMZXUwHsiLcHj3dOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(136003)(366004)(346002)(4326008)(86362001)(186003)(6916009)(6666004)(956004)(2906002)(52116002)(66476007)(54906003)(7696005)(83380400001)(38100700002)(38350700002)(8676002)(36916002)(8936002)(66556008)(478600001)(26005)(66946007)(55016002)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ArPXpMWfl6jIrL4F17hLGRPpqPAKaQkSDYQKbdMmxEcwrqfN+hFPc+PxJx6/?=
 =?us-ascii?Q?xzrH8zejVh/0S1UyxkMoLoMq56ITxJzFlWcq0x/JSGzZM7bgidqdhkbLYmp3?=
 =?us-ascii?Q?jYB0fcSHMQJmSg1VhnnsfbPTpenlo5h8Bx4/r+emeMW31bBckmwV+7Yi61wV?=
 =?us-ascii?Q?ZiA1aaFCiQuAL4PYqeM86wsKJG7oAwuZZNqtJVVh0sdcAJt6Ha5NRaN2Fhxa?=
 =?us-ascii?Q?rCu16vsXugEWTQCGwdPuqWD7YgFy9DyeAr9XauPpAnZi2XZYzY0W+rmSsFFg?=
 =?us-ascii?Q?h5TucG6/hdYCyni9NzuVtpTJZ6sc3hRgoWTORpqz4hItRiq8wehqOsTQPXoT?=
 =?us-ascii?Q?ljdVG56p1NuUeLz7Zid9IfzfR1gPhT/YVCyzF3FjLJqPbk0p9bmU83qOBLUW?=
 =?us-ascii?Q?qKP4nkGJDLl642/ExZT9CLRCTUIrZqtdD63D0DtorYPeqJlZpzyi6GU/ovOT?=
 =?us-ascii?Q?8N89RtbhfQEteaoq9doRG2R++lH1694Eomn9aTGr617rWekip4EXBeRUyP/e?=
 =?us-ascii?Q?QMQyCNGucUOu8awMgT3qCx0b5QFYduCq+jM8E0GUlbPNY+d19QScy06ofp5y?=
 =?us-ascii?Q?lQzmVGGWmo1C1ECYR1MrMEpfpj8w9FdN/slbCYf/1AoIN6srq+hmhvJk/etA?=
 =?us-ascii?Q?w32f3/4LE7a7otfcMRztAZ3bY3u0KL28QPmUdXeVxVC5dhefe1/A0Su8HoaL?=
 =?us-ascii?Q?TuKKjIAHcplXQATzT/Yg2FKU2tDWnd1rQxiCA4suB6leneKvGyPxyQDL2UC+?=
 =?us-ascii?Q?DjayBx6YXmW0tF69GbOsUNtuxFRuEE6TTuYIXx/ZRZrqo7+P9yE76w6rry4J?=
 =?us-ascii?Q?UT6Sg0SDSu2B2sLjVUG8y7ZP6Nu/J7sbhBO7kOtg5As9vSxARxvUefLxstUp?=
 =?us-ascii?Q?7bE/8jwj70wdjx8QHA1HZA3AfiqqRpyJ36dC+NRI3x7PgePGRRvAy2/TVj8U?=
 =?us-ascii?Q?WnSvpfEvP8+qgmdTnHyuAeh4TIY7Iqp/qkJHJMwFcLHB0HI5FrY0r0Uj2xd3?=
 =?us-ascii?Q?jhsRotHtBGKeUhv376lNRWpzM85UyiuNkjl1NpjldYxT5Bhm/85VTr+eiri4?=
 =?us-ascii?Q?CPjlQciSalvdKVgC9ZkulyFo74i457P624jQjYYH5F+SBRnW8g0hLncm75Fj?=
 =?us-ascii?Q?go57PXNGbnhngdIrGGY5hlfnc2u5xnre1PFvuhdv0HxQHYDAH9I6CxUpnGcD?=
 =?us-ascii?Q?6LXriSz1LjQiKA8v4oEx3aFNJqJLrEbtrjJvz7Ofby3XgDlq8F2+WPZbaQtM?=
 =?us-ascii?Q?SXN1INGAhpnnUeG1Noels2oUj2vEtmfa8GK2nmfa+lGfg25CfVr2WvG9lMB1?=
 =?us-ascii?Q?b6CPXO720rbokqyApnmdALO8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb46a4fb-ed7e-459d-c81d-08d9588c253e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 03:41:59.4347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: on8X4J/YeuVxbWR8SmqoqfruZ6UnArHt4+cx7r+ZRHC7MCVsNItm4hgcmDqb6iGc8kZj4a2mRqJ953AwS6CppwtuTz0GZXO0RlydODz1APw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5435
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=610 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060022
X-Proofpoint-GUID: OcF4HxttQfLEb8oCNyAaIHBSiDZcTU-h
X-Proofpoint-ORIG-GUID: OcF4HxttQfLEb8oCNyAaIHBSiDZcTU-h
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Single LUN multi-actuator hard-disks are cappable to seek and execute
> multiple commands in parallel. This capability is exposed to the host
> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).
> Each positioning range describes the contiguous set of LBAs that an
> actuator serves.

I have to say that I prefer the multi-LUN model.

> The first patch adds the block layer plumbing to expose concurrent
> sector ranges of the device through sysfs as a sub-directory of the
> device sysfs queue directory.

So how do you envision this range reporting should work when putting
DM/MD on top of a multi-actuator disk?

And even without multi-actuator drives, how would you express concurrent
ranges on a DM/MD device sitting on top of a several single-actuator
devices?

While I appreciate that it is easy to just export what the hardware
reports in sysfs, I also think we should consider how filesystems would
use that information. And how things would work outside of the simple
fs-on-top-of-multi-actuator-drive case.

-- 
Martin K. Petersen	Oracle Linux Engineering
