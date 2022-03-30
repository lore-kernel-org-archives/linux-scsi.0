Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B193C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Mar 2022 03:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242429AbiC3DzS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 23:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbiC3DzN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 23:55:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEF9140EA;
        Tue, 29 Mar 2022 20:53:27 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22U3Mdc3026999;
        Wed, 30 Mar 2022 03:53:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ZP1p+MR0dG6zjsXA1rFYLuNZflakaXllnCpE276Du/s=;
 b=Ud/iKdmTngb/1HgAz+7QMQHi2dZZBOzmjDH1p1iAX+bCiuriGVEPZFOae4b6PWls1ZAh
 0I2hSIJ2hDZfVfl0oV6jto1ATd9Ffj1tW92ZVUQ4heV/gLJo35GbWjd3D1GchlJvjOma
 zZTlWB6+HptY900tXFj2gP9lZ1NSLK0Kawobibtb573AWreGC/hxcfPV3tzD8D+61Avn
 97Lq3YFnZuxqiXu1dPYZLYJOhwHWQpeFSzwqDCW8KdtqnDyO9nQX5lt0EmToZhQTPZlZ
 TqqbubxihK0fBt5pDRQICRnHJinj7o+BiA/6x+eJhFbxkcWfZGsTI1L8AVdI6Mmrl0MP DA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1tes0916-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 03:53:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22U3odfQ068898;
        Wed, 30 Mar 2022 03:53:19 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3020.oracle.com with ESMTP id 3f1v9fjvbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 03:53:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PujaxUXLkyQEAKMCd7vtyuY7CUEd8o7AAFMheHGz+PE8ldf4JlkIMUI43AvxRR2FuW0ntG2htg4f3VojHCZGtcPxzMcVm5vVc7gKzuJzcm9lfrZgEm1i3cl2v8ubSF53/PAEnrsSi8TWlNzolob+VFbJCDEkoSIPum5gEniaal18vluo3LNimbUnyShyj/q2BThdLpF7UJTygiutqHVSphdC4DEzwk4lhjW1ADF1uIiSJPzCjidbMBd8kupWjxE0/nYUH0sU2TQ7V1kZ9B4xxHNKj7OB9RFJjd8QHKUzTo+0Vc+3gn+8M/tS62H5VnwthxBiKkse2dDWq0OrUe9ucQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZP1p+MR0dG6zjsXA1rFYLuNZflakaXllnCpE276Du/s=;
 b=NAqk/gZyNuvHRGmvwZ9dmYFy4Kv4N8wl5YNhHdEP/lRZYmZt0RrRRXEWcjrbNOHMMKFVMzmL8vLjJ9g+Z05Q33syxqCDGbHnT9smYHr0YNNWpJPZWXI/16McWN0+NCIRuRucrvY/yiKvVR1eFGab+clOqkXTnZAsFGXjP8ASAnIvfdSvilhdyxTR2d8pM+WdHy8CICzWwBon8W2jT9XKAObvdwOWEz95Vtzvz0FgvAioXBTEDL2AFe8vHCRwzA5gVEVQwipRhgdwM1urPAtxvrNnYXL2WORwszM5KYy3Iswf2Ii+3fQZhHDvJzo2KaBWiK0DsKydQxWasBrIjJoUuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZP1p+MR0dG6zjsXA1rFYLuNZflakaXllnCpE276Du/s=;
 b=Gzt4FcCnbnejsVhlS1UwNJ53D6mZqMqnypA1ImRyOM0aJsyQSIVx1tME9PHpLVb5ApbC7MlcJ7fUScyG1qbVxqr6Y+ajs7d/jvw2wYrO37xT4m5kTVza1MvirrCCZw9UvX97jpkIIfnKzRXKbMCgBnPqPRW5JhvDS82UnLEoGow=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB5156.namprd10.prod.outlook.com (2603:10b6:208:321::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Wed, 30 Mar
 2022 03:53:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 03:53:17 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: hisi_sas: remove stray fallthrough annotation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfr0t7tn.fsf@ca-mkp.ca.oracle.com>
References: <20220317075214.GC25237@kili>
Date:   Tue, 29 Mar 2022 23:53:15 -0400
In-Reply-To: <20220317075214.GC25237@kili> (Dan Carpenter's message of "Thu,
        17 Mar 2022 10:52:14 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0028.namprd04.prod.outlook.com
 (2603:10b6:803:2a::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2432a44a-3d7e-4437-090a-08da1200d29f
X-MS-TrafficTypeDiagnostic: BLAPR10MB5156:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB5156395BA0E419F4DD471FA88E1F9@BLAPR10MB5156.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x0yRAGNUdHkH7J2HiN9ZxSx5WlCluYI1rz0+TxVDhuTdxNG/V2I45vS7xCqQr+oHa847jLID4SNG/iYIx7p0gA8J1/oiBprTz2MgyNhPhgxHYcSLadyZduNIXq2AcQiKJaSpD2qQh3RE0FQzRCwIaiOHcEKwNne/X101iWYP4UITA3XMZB5YK+ek6SJTF+6RXwq6mVh9cFZ0bmM12X04h774YWmC31P2enmHa370poofNeWegDkA2glJ6HVjYkotCj1+YO3zL3VlbQqUXA1LyxusMHyTjOQ68qqWvqSiwl7esloIOQ5+3Zlcy3UibFYo40gg+cnJz34XUDfm34Y8KDTbM7EhEQ2+thCCC+80fqGQnV2nesVQrP/3NE1F+TbYmTUYwD38S8AHVPriXOE9+7npMgf/wYNm8RYCF8ZMPcW3oy1IcewUweKi7Gm5+VoYhh2l7e7/20/PpZbhNt8QGsc6tDk8KVjV39hTQqj5GIvhsvoJVU8XQP7ff98nEga9wOcH7QfhCDNxc2nurTIxfEYjUEKh9kVdX6GrwgoTODNjJbHRrqDB0TajDDPQmR+/v3P0GSpi7340LMeHfWSaTPukWYuqAdL7TNS0VYtj5p7ukPPCFzwsxmzBNmAz777puY93LUtS/E9HwCLIgLAlSxXzUkMZ9lSUXsDqLD+ZhJEHcCuVtkKtp96qNgSO/8eli4y/6ipCCX8YxbC3Nhml9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(54906003)(6636002)(86362001)(8676002)(66476007)(4326008)(36916002)(6862004)(66556008)(66946007)(6512007)(52116002)(6506007)(38350700002)(6486002)(508600001)(38100700002)(5660300002)(558084003)(186003)(2906002)(8936002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+HVDsxU+oBe2wgJzNn5TihFsixwpqw+yy7td0UUzF+akY/YilG+SiX8KiQfd?=
 =?us-ascii?Q?TSoeHij3jZJVt9K/IQmrg5zEma/YcjD+shwFv3T6UQlDYcWSLQ6TkjHYv2YB?=
 =?us-ascii?Q?TN/41H+SBsLCCqtWsL2pKOGCQRMrnw5ghSNJPyNvbmWJTz9po31mAYm3PLcU?=
 =?us-ascii?Q?NFNFZOjXo8jtg3o9ivs4dJbh4kG8KOZtMXw4IxIiK0c3VGM6tk+bVhb0h7Md?=
 =?us-ascii?Q?Z3OyjliYY2YeBxXeIA1sdRRu2HZkjVojbxsGUhupynf3QAgHQ6hSEo7oQPPQ?=
 =?us-ascii?Q?0Y1bkyN7as4HlRk4fsGXqedtA70q7OLZtNamz5ejhWR0+4stZ1H8j/WsK9vD?=
 =?us-ascii?Q?fpny+RnI0u935JFfcK80Oq/pqCg/KxxQRzdGs8X6YvLpT8iOrX30rdIcftpP?=
 =?us-ascii?Q?pnDbEh0U8syZ7+ljbXvb89/duDBBImO+XGeHHIhUXABEofsY33Xx3ycXTtq4?=
 =?us-ascii?Q?cT8PejSNSX3VHTJyvW4bqDQEr+YBfd3rjaWxIwqBMsXHqa2F6buf6ApyH3xx?=
 =?us-ascii?Q?t8jQf4ggpqm+qvpspXZA/HJU8I94NfqY1SnkG9ujTjd5YPAihFxSScsaxTiv?=
 =?us-ascii?Q?+gv4jlXKaGF7ycUQIoKktrnBmWM3tVzxCnOSZ3cMiIoMV5/V1t2s5T8pCiFi?=
 =?us-ascii?Q?tnmA/uya6xxMBNChbRfELc/XhxK8vTD5D1jHN5T2Rx/U/k5GDef3iGr/pp0h?=
 =?us-ascii?Q?YvGpFCPguCa0RogBrb1zDEuARNNQyDjGI6GhZPMXM2IJcU2ZSQdAKtIZ0G4v?=
 =?us-ascii?Q?44+ueAl7yWtB//VmHOZap1p6zxOMkp2/zb2MBPazF5TTCKozrv2vbDtQcdXr?=
 =?us-ascii?Q?+OyC8crZZ1rlK7aT0e01sE8gvh0Y6bo5PfSh31dZ3bgdf6n3X/MK7crHQ8qf?=
 =?us-ascii?Q?n5pgpFalWNSktaPfYmVyt2y53cwIR+plfjHC+6QMvN3GEQ6+4fqtKnjaVKMW?=
 =?us-ascii?Q?8qGkdEl7b/7RMxUfC5naiM03SiCTeDGllc0+Dm/BEN7hPVXj+HRmZhZAsJ3X?=
 =?us-ascii?Q?rBl3xvlnpxTRlKqNs1BLSmUoRmdWclaNjD2CEQSmvWCK7Wju9f5vU08TGkDX?=
 =?us-ascii?Q?n7bTAhrhjN1mJBwlTDhnQxpYuj1t9t25k9BDWj12bvQ7SMnQZCk2iRlhKtro?=
 =?us-ascii?Q?QNNQQmir56Ce/vnTjk+jHM1dJSomP1gleBrebm83rMnp5CiWsanKl9JGAfUI?=
 =?us-ascii?Q?uw+Fv7F+ez8PSZMgJOEY+98HpszjhcxDBYI8VAR8QaEs2KX30Fdg3lgkpaCh?=
 =?us-ascii?Q?3whKCOm/oXXfLJX2ltUXNALx+3tGnHWqe8JYGtL1hxuGP66CX8wRXYvJXFuZ?=
 =?us-ascii?Q?JOW870xQOdAMjk7gTGp8Vq+vIO7lHlfxU15iavTl8N0peBv8AmtyVvkDyocY?=
 =?us-ascii?Q?VGqQPYjf3XIiDpOF9F0QwHlT/QSH4cQ9VyImf5Bvq4kO/2fxbX6bTZKaQaV3?=
 =?us-ascii?Q?qUhWgHnADmu+un4W1wpvroVdwgsiDIf8ZBdnsMNBO2OAaJRtGeeM3wb83CSe?=
 =?us-ascii?Q?+BinTXt20o4SiIvbN7FtI0BJr+m6DJFhpga6gxkic1y678QcHaVsGuwPNl83?=
 =?us-ascii?Q?kKV1n7qNR1H5dj0jfGHpEwICUdo4BWqKrHausDKtGTbzObbh+iwGvbA/UIJ0?=
 =?us-ascii?Q?IVJ32ebrixj7UZXlI537BTgIxNU74aYFeo6C6IAjUPiOVe0ejXSlhhwQztyy?=
 =?us-ascii?Q?4e2FMAEQfWGgUIm8vNzTmSRapfJwrHpHeKfs2oR2VhOCZ+PE+XvixlZmtXq3?=
 =?us-ascii?Q?dXsQ0CUOXLNkSL9g9DYgg3w8PvPPtnE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2432a44a-3d7e-4437-090a-08da1200d29f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 03:53:17.0534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i9V6Sdd9VTqzi7b4jx/eZ9RtAnm2b4M+bbqWXLQqp4Oj4X6+Lv1pmu4plEqPbQiizdPg+1DatSNG7/aZ/mpHSsC9jLF0ExsGENKqA0iT5hs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5156
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=578 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300017
X-Proofpoint-GUID: pxIJz88GGULybeSrxqOCjLNXeRXRsNiR
X-Proofpoint-ORIG-GUID: pxIJz88GGULybeSrxqOCjLNXeRXRsNiR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> This case statement doesn't fall through any more so remove the
> fallthrough annotation.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
