Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E84E7C433E9
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 02:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E0864FB5
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 02:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhBEC5v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 21:57:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33320 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhBEC5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 21:57:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1152t2x5026353;
        Fri, 5 Feb 2021 02:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=r2RYQLVhK1r1H3bFuTC5P6502twQmKxe7QZA71dM2Mw=;
 b=ssKzhN/EyOFyfTGI+tQLKTXIJ9rpveaheV7ugg5+TS/ZgNxkHCPYPcmQAikXRVElS1za
 YAuEMsu03W2UEv7mYY+8wRtDhoY6FwVtdJlQb3AMwq2F+BmMrq4oeDQfQBqu9jATI9xB
 EbShJVCBW4OmhUTnXpvnAXuYxT8eC6A2At5MqCv0a7oOtPdyuh0qQ5BStwbE2SxEbh4M
 DcCG8On5UnQm0nDY0gWgbxSGTu+iBvpKCARuDnKI0Yd9rvOjdSlIS0m3cpIkqe7UGoyq
 bv3Xd8X6NErT9+NXW6JycfeZ0BMl2RC3vhV6tSu/kcxWTN72HKtvEcf1izsmvVOpRxJX 6A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36cydm8226-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 02:56:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1152pdZI139191;
        Fri, 5 Feb 2021 02:54:31 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by aserp3030.oracle.com with ESMTP id 36dh1tb7m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 02:54:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVr3l3BbJam4eQf8o6aceRfwgqa22RH70EchHTtQUz1Cs/PVy3Zzvf+ivtlUmxFqTh7/CuWxC4X8097xwRvQ2+QF9UyNATxdZO8C0BMZu77NeVfHnTa/nNPCMvaiiZd1uDDsY7vVXuk+3krubO17Y0i2xxN0AtOT4JW2ZqVJhH+hRVno/ExqpCnV5euC35UoF601Oea35cy62zbnmFQG1vmawHvFBlgLQedzKX5Uv989HNHqutAXdQH7Y1D4hYRB/J7/tfku01bAdtann3SLcMBl8ir6Ce4zYBan/HHornvCZNwgXe76LezZS1SZHslc73nToxOCWuCQ1HXDrxvzMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2RYQLVhK1r1H3bFuTC5P6502twQmKxe7QZA71dM2Mw=;
 b=FiUxAmt8BsfMxFxg/R9b+6Cvb6ueL8+A4OdKXQKH3R/V4RAsuM1AgNn7u+oGNdC23M5qghQjQtYLtJzQr+gnHh8lflQbhntbw5C60yh7PMCRKTw89p4V/1zt1O0uxxguTFGOR5kWs8aEYqbGD7y5fUlsN6EOUnKMzQ6Tz/fh8Lh+3Kywrs55Gc+hcHOTvMO0EZwIBuNBJ+HYjk/E90ozZeFlEhIWHv8luZUdAZxGofdpM3MKyT4qkWWJJJtAQGnT0UyJZ/8Nz+b4HUyGmD0q3wHHnNFDlAdr03kKmX7y7MgrtXArU3viiOQc0M3zBv4yLc9bUzoFD+XaX7cQvbWyYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2RYQLVhK1r1H3bFuTC5P6502twQmKxe7QZA71dM2Mw=;
 b=EnglsiDpgNPGsOZzhwL1tpuDeqOT3rMS8HgeTQm69okwL1qENn0GFTkJtCX2/SXVoLlvVAhQi++bykHux35hdOaGZeRwVKQkVfeuN9OWGy6Oa3TcCCu63FUk2HZLqgARBEIHkband7tMMsi4yVY8U56zzaecoSXZ3ATwCWoPKzA=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 5 Feb
 2021 02:54:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 02:54:29 +0000
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: Re: [PATCH v4 5/8] block: introduce zone_write_granularity limit
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2g3teb3.fsf@ca-mkp.ca.oracle.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
        <20210128044733.503606-6-damien.lemoal@wdc.com>
Date:   Thu, 04 Feb 2021 21:54:25 -0500
In-Reply-To: <20210128044733.503606-6-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Thu, 28 Jan 2021 13:47:30 +0900")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH0PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:610:b1::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH0PR13CA0015.namprd13.prod.outlook.com (2603:10b6:610:b1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.13 via Frontend Transport; Fri, 5 Feb 2021 02:54:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3114a6da-14f9-4d65-1e35-08d8c9815b46
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB466437F6325E33D3078151A08EB29@PH0PR10MB4664.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iqHi1UL3AumdgvWKhnYFT9zRru2OhBSqH4q6nvjctn0sD844fAik2sC6gRNMpLjhQdtKeEkpqknyY2xyLaGCQfDSOlmpUybAcLvnHhrds5Dk4wQZdJCd19YGg0wZxi6zLdSAbJgwmEvPEY6CDlVwV57bqATmG3rJnifle4BK4D4ldBqamO3AQD1bLUATXPSheQ/ZeqU7EY4AGrp3XnRIKhwSA4FYL7PDZXeJbuHalaz15trixq83fRBjS82o4ODJlHTpm0WCQRh3oheJdMWJHp+RxcAdUcSnRC0UUC5rnhGvr7Y00HHm2VI51yFNpJgzZB9ngs9sBYmAxAwj6GRlxA1IIDkVXFV2veSa1MgJ4XiuxBXiSHNjv044DD47jxWYTbUMLW4g9MGmP8BwXrdut2sIBkvGCgpUKou9iFbE2HJQ0YGOvQhuLEDV/euvJgaRVXrAYN9KBv9lXX6QfbUXBnQV2RCgQAPDt21NFjguyfbCfsYAAuZk4yDEHeZB3s7SCZ/EnJG/CbZaKgpVt3HRaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(396003)(39860400002)(366004)(52116002)(8676002)(4326008)(16526019)(55016002)(2906002)(478600001)(6916009)(5660300002)(6666004)(83380400001)(8936002)(7696005)(26005)(36916002)(66556008)(316002)(186003)(54906003)(66946007)(86362001)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VMeLXTt+WxRkTTutt3D1LvYsFWZ6rUshhQS8t1Cre3UiQ7dlfgz3Ovjp8cmV?=
 =?us-ascii?Q?x+evcV9W4SKPlAF9Zm537dobjWr3kNOBpTwr2OaYI+xQfka+6/gioqJNFRAJ?=
 =?us-ascii?Q?zusrgfzJJU+bwDr+uqN0OcCWHQ8jTBmPXk4hEGL3xZoCJZALzIOLVcfaCry4?=
 =?us-ascii?Q?KWIZCQCCS/dwLBeb5ZTCce/Zqy29oz/cQ6dX/baXsP0saLyYLqqtQ4hfeprW?=
 =?us-ascii?Q?M3ULKC/AKHD++0+dbqaXoYxJYyIRMiwrJoflRdgkJ++zX0WcrLoAsFrgiGpW?=
 =?us-ascii?Q?n/ezPjADPqsJF4jAjJ1jHKqjK+RBCwf9CEFnAUGvI9I3k8NojZ7Q5zAMH0kv?=
 =?us-ascii?Q?dbZRjbgRQAvNkdJJL8JaDzGoz1p7XZIxkMXgP+LDOh1tyd1LhSou0F5ZV0cI?=
 =?us-ascii?Q?jbO1geJnDzUvR5nll2CHNe5NZYq1BsQ6oKDoEFzIwjoKyBgiPwnjgGBduHAc?=
 =?us-ascii?Q?0WnavJjHnwtU+DhxePrs0q4fngBBE8TTJFGllcAGLRqVba2EAxMbQdVTTAKp?=
 =?us-ascii?Q?lgLzfo3CmgfNDJRr7DKR8HpCzKGrKZJvhZRhjNV6k2WZY8sUN1MD01CQYLkI?=
 =?us-ascii?Q?09XLcVxzSiXfjZkWl9QUL4OdgJDVCnXjSygdf0X1cYPELITOVxrenkAE0cot?=
 =?us-ascii?Q?UFe3IlpkKgQ2GZ2k5FkEKm26PsnJnbuM7wHMj6T0VrKCJ1T7bcCkwtlK4Qrh?=
 =?us-ascii?Q?KezssdKHXFfqnYbhGX9ZFgdzDpNsDAU18hpIIalZUJmm3WEovX11IAsWknXY?=
 =?us-ascii?Q?OwVmT7+zU+j7Tn9rUBK8T2w+C0Y70jQd+gWMs+B6WPi37U5YIFuYjEvCHMvW?=
 =?us-ascii?Q?oJ2CZuLcGFbLKyoG5PWF0nFHK5Sp2+54upIIevRbKWi1uJzGfqZ7x4hk5m9X?=
 =?us-ascii?Q?nA7cyN7ynYR+sO7/cv2VE2TMxmCy+YM8mZYvn/Wakvjg1wMGNt+MpOupa+62?=
 =?us-ascii?Q?NAg0LdtSF5wYkkHExYnMActUeKXkvuITvN2kO/Nn8SDACy3TZmdC9j84i60o?=
 =?us-ascii?Q?ttlmbdV8Ku3N1G8ti4qrDnpL7o3Go6jHhnQjKtrjjQMjUJVhGQDfjsL0zmgp?=
 =?us-ascii?Q?7410cAu3U1KabY4QazGezfB5i85fHi9NcfYwGmMcgmk+Y+OOB57itWX+c18j?=
 =?us-ascii?Q?4Kdgeq/fK2Xjm+aNEhT5vkAASnkcx19uUyT+q7vM0tkp/3I0T3V04p6Ah4mI?=
 =?us-ascii?Q?4+QYhpLQrQyPrNUqpHqe6Qpw4sKLrKtPiYYSrUerAxXN+2N4K9XR1NvVXV3x?=
 =?us-ascii?Q?lA/I+qlZvyv3enXkOTUXQDzDOEvATr1eQkJqB94e4o0ZU/urcypAk0IhJjyt?=
 =?us-ascii?Q?uPrkzDpK1QxkKIHe2pzuZjOA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3114a6da-14f9-4d65-1e35-08d8c9815b46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 02:54:29.3057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sCu10vPruehNlOhgC79MRZae7v/Y7OG9YCm1JohDf7F86+8c5AgOQq0X0ztxWlXIJNLAeV+8cv+ZHMVhvPGSRK8GjPZVabjEt3udPnmaxHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4664
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102050018
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102050018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Per ZBC and ZAC specifications, host-managed SMR hard-disks mandate that
> all writes into sequential write required zones be aligned to the device
> physical block size. However, NVMe ZNS does not have this constraint and
> allows write operations into sequential zones to be aligned to the
> device logical block size. This inconsistency does not help with
> software portability across device types.
>
> To solve this, introduce the zone_write_granularity queue limit to
> indicate the alignment constraint, in bytes, of write operations into
> zones of a zoned block device. This new limit is exported as a
> read-only sysfs queue attribute and the helper
> blk_queue_zone_write_granularity() introduced for drivers to set this
> limit.
>
> The function blk_queue_set_zoned() is modified to set this new limit to
> the device logical block size by default. NVMe ZNS devices as well as
> zoned nullb devices use this default value as is. The scsi disk driver
> is modified to execute the blk_queue_zone_write_granularity() helper to
> set the zone write granularity of host-managed SMR disks to the disk
> physical block size.
>
> The accessor functions queue_zone_write_granularity() and
> bdev_zone_write_granularity() are also introduced.

Looks fine.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
