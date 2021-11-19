Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9AE6C4321E
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 03:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEBE961B3E
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 03:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhKSDH7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 22:07:59 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:12422 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231848AbhKSDH6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 22:07:58 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2eTvX000713;
        Fri, 19 Nov 2021 03:04:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Mtx+pQwWOsc64DZ1dlnRKY6R88zg9TJUwzKvp9twLCQ=;
 b=fp/GA3sNlHzCkMTZQhbjywXWEB7HmWe+QFztBVyfjMYPoULYJdkcEh4SnvdCuMNtOxJN
 nWbJB8fBsrJ0Th0YwOzed152wsb8ehOuoleFcoyEV/ORRiltrJsJ88lrnQUAglDQIj4d
 8d2oLV0iR+sk3O/uz3gRZemG6bFvTzEzhkIbxmbn6XY9xwLyOqpJD/BAP6vrCdqHyj3s
 54dPPDqzNttWd2zaiyvhhuofQhoxUWA7ktM3+51JXUYxkOAguW7sAVXGfKMBDeaIG+0/
 TJbtzjYOJSGZx2Re9xwP6k2Tv23Y1yyqnfTAgf46aIf/K+gHrdIUbNPqqco/E+5j5a4G 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd205mc0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 03:04:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ30NM7123810;
        Fri, 19 Nov 2021 03:04:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3030.oracle.com with ESMTP id 3ca2g1ju70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 03:04:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSsQWplcyuU56g9AI972ic/t5wEQRTC2MPbjA+n603X3bXkU9Br129GzGYCBdzMRYlX+TGuJXL2GsVwYRNRUjhRaHq47QIt37GyT0AWpcjxSpQWf1M3vdUabeLJGLDZ3qj2KBzMixb4rv+PxDRO4Lte4FuhCNd2oVEzYFyR93FX0d/fxlk2YSHnofwSFfX24UjZfXbb1OaEVQDzoR7VE0kIgPGnyB+NvfHp6lCRxm6OXiC3S5z46HRwsGm/p99wWoT4Yw5dSNCF9b6YFEJDTp0/mav4/WrynzJNSXnBM4Zg34sL1FpmlUtSPgZFh0dnSSbuTjJt/qGMInXH1PHNBrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mtx+pQwWOsc64DZ1dlnRKY6R88zg9TJUwzKvp9twLCQ=;
 b=ghqaFy+t3/C62la2DKNss58wsfgd+vIR/lHGACsZttwuw7yXtINJeQ0ZlPxbuROOQ28SCuId8n3+AvmUV5Cn0U5KChuy5hd2sWfW0XBA5Yf4QC4J7iuIijT6d+O4TTxxEpMJJh3FQLuUfuAqwiOqkDtws07l3QVD5cvw/9ECCJixvoVmZqYcfz7wb9JSz3VMp/mLHK5jbkXkQYlOraOaNEhLoP6sKoNN3LIvO6yJfcnU2+6phZV2ij9MNeT9uS3Q0HJjY9BdFRIdG3qWEUyWIsgXJOE2eolP5/PkpelNiFCTXSBmsI4S0xZizBRlV9gXXsl1ZaGdiI0ef6lZB9rR6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mtx+pQwWOsc64DZ1dlnRKY6R88zg9TJUwzKvp9twLCQ=;
 b=uREgyAcM5kS1C0Hzm+mETfFyZRb0qTj41e8tm1qpFGTjXg9mUQTfy/qmkGJ6VqYcF71sZQuqvRgCmKGlhAhNje9W7UXWzznqhzNQvTwt+h/1g69JsNqDbnpVGL/mQdPgGYFPeALrBqBTfCQOpP35upV9EfeFb1pDUfxMI/jhjME=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5816.namprd10.prod.outlook.com (2603:10b6:510:127::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Fri, 19 Nov
 2021 03:04:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 03:04:48 +0000
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Fix double space in SCSI_UFS_HWMON description
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y25k6e2h.fsf@ca-mkp.ca.oracle.com>
References: <20211106164741.1571206-1-geert@linux-m68k.org>
Date:   Thu, 18 Nov 2021 22:04:46 -0500
In-Reply-To: <20211106164741.1571206-1-geert@linux-m68k.org> (Geert
        Uytterhoeven's message of "Sat, 6 Nov 2021 17:47:41 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.14) by SA0PR11CA0154.namprd11.prod.outlook.com (2603:10b6:806:1bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Fri, 19 Nov 2021 03:04:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0e9a31f-d226-43b6-5acc-08d9ab09589c
X-MS-TrafficTypeDiagnostic: PH7PR10MB5816:
X-Microsoft-Antispam-PRVS: <PH7PR10MB58165A727B9C00918845F90E8E9C9@PH7PR10MB5816.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cWmKfwhQrwfRuAeCv3/DBgHj7oXOIQORzd/gNw7ZtrseSa63dIMuQ2MIEhiJgxZX7ym9/WOP7aGWfA4EuF3ES6mMbgrBNxMjwpJBP/tUyH6zxu56mYr7k4wz7ttXWA/HOp8QdnTqR1heBS/k7XhBQjyEpJw1Z9IvmgTIh17iRwK4WqHQeErGcpDVMT7Jxoa61+HCGZvC9mMALyOme+H5PfT7gCRamHwpMf4pA8l/O6I1olULbinP9LFfh9W1CcXlTJE+W71TDu0pyHXixPtBinhW1oYzLel9ZaP0ebZAKZpf0ZdJ5Tyv0A2VjV6/qbDbJZ7Ji26Z1SkVcF457NCv+szXTBlq3QEXoGhyazWOuAtGo+Wa/tALVFpSCDriQILJBi9C1xid2ShkQGGf8ZYncyowpq/N9S3QHAqsEXNpYyO5JINCxGG609K7IhS1DdWGmGGYxon1P9Zu1431H+0Y4kY74N6sX61rzo99H8ll4ZlDMLfNO2vgvU76kH+X4jlLK9lX0r04/Mug7vEMhm8yTWLoTBxyUn0+EsxQnEmK4Uymsn6sLD2ZMljZVreQB2FTdFdpjwvvv30ngIw+upAPc0/iApHS6RemwpuQd1aYskGA3LsDeRhwVv0HPVXhj66BFRaHNUWQZDQG4jQAFWvdRvElyPFMmKbk7pp+dLz+0F0orYzBpW5utw+PyGvZgPPbN4VguhH6ptIfAIvFIR4gng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(36916002)(38100700002)(7696005)(8676002)(4326008)(558084003)(8936002)(55016002)(52116002)(26005)(316002)(5660300002)(186003)(86362001)(54906003)(66946007)(508600001)(66476007)(66556008)(6916009)(956004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FYiFl3YmFIAgVG5s3kPmKCB2MWdHHcIwz0DLWiYzregoN4GZs6Ra06/l5ZPz?=
 =?us-ascii?Q?Map6Wbgb1i2ZsD+oUtYPqScr7YBBsq9YSZ2wyiwRtVi23QRjgJUmvAxylV7C?=
 =?us-ascii?Q?j2fhENL4SEhayiL2HctFcEUwB3ioRMJqkOES1KZxvDMVMMJq+xbTyf1U5t3+?=
 =?us-ascii?Q?GvbmdpokGBxRS1x7nUoOZi3Yb31cjPZ5ePnwL/Ge4YZwGtI0AlHQcvSBGEgy?=
 =?us-ascii?Q?SZfJj9eoVTf/u3QWvFwPSK/tjOeoZqhVJyT8HnNSmga4iih7cicCvN0SxI0Y?=
 =?us-ascii?Q?iuhDrar8WphihcetP3+FPL3WVyYwdPS5SCzwCUTZvSRP5f0X16UQTkqMqwJy?=
 =?us-ascii?Q?AaXiYMNYtgmUKcjD9oJpzsRwZpRV7XlkHsKT9Ukjb8GR0FhI9QwarLKlc7Iv?=
 =?us-ascii?Q?0snJW2azww1dGQeobEMmx6GKXg9kVnLjGWCV5RZ7jsIt7jUqdpmIF8V9VrWj?=
 =?us-ascii?Q?ApFEZdR14EvwoWjal9eHyq8RkQR4WhbXOXcBk8kBfM83jlkwi6KtwKk/vnU7?=
 =?us-ascii?Q?qR8KU3LqZz+gQiPFsGn+MFf58EAR0KlhwpkXOXSZ7Iy94wv6U8BKUW/oDj0x?=
 =?us-ascii?Q?Tzgy5JgUAzwKMJaqGSQS6YbQNc7AjlAQOvz9pNpwt1suQFKNNLQ4dNGdqWvy?=
 =?us-ascii?Q?0f8Rm5WHs1w95D2NSQDfHVpqJhGWPbu1MMxIkg6V531W8fUEBvghNrsgDld5?=
 =?us-ascii?Q?wttBPbXNZlELUgBz6aQATeL/3cOdfAVJzOf7bYW/hUPM/Xz3iwVSvxptKchm?=
 =?us-ascii?Q?wP/ApO9vjtDy/wvNz0M1cvl7udxxnVWt1ISdhTe3XQOm1XOZfnc3kmGAoRMq?=
 =?us-ascii?Q?w+7gNsu69tQW4lF5bGX3aDndyIT5wDBA9I99KXcqMmbqY96Qkl6VyPCmQjC6?=
 =?us-ascii?Q?EwrHtx63CiH4JUzXqP4k//crYff+M8n7kgQbPQ+EDIaUxIbaFWdUjmlUDvXa?=
 =?us-ascii?Q?0LhL44AzlbqkXWMAopcexcxlA3AGkugSOq4/6RL/JBGKVQ2B/Yntx5U9NZv+?=
 =?us-ascii?Q?d5HbVzERMEZcOAiFj4NFvpbKUO/H8trZyaak6V9z2Em+oOOTPoJHT1IkHiL/?=
 =?us-ascii?Q?M5XOaSwcEKVsKjEFSsus2TYQn5rGC22oU88CxNgP+OnjkHe2IaSV8UwLX9Bt?=
 =?us-ascii?Q?rI8JLRluC8cpQxR0Agft8MTCVi7Pra3ihnwDQ0pMnqwVA+mVssvS3WQXxlrG?=
 =?us-ascii?Q?UZ2Dt0dXF7KehlvKbctnPRLsMK+bvn34T9wrjWoJ9Hrg6uGns+kvGBYdbfvG?=
 =?us-ascii?Q?nQ0CTNypMU8RpbTAx31TW8u9bxgB45laaOPrXQSqJWWWsb+YBLAjcuQpNvhk?=
 =?us-ascii?Q?VBfjV1ZIHK4S9L35zYLx1YLKWzmU/LWi1HOmRBMWxWmNOZmJH+tOkseMBWK1?=
 =?us-ascii?Q?7Cs7G8pB/x/DVCxzlYI9vSBf/K7cFsDt00ElnAO8GWuSX1LkgAG1rqtqnrBz?=
 =?us-ascii?Q?+Ck+CV8fyzPO9TVpDuSuTotQLMDMwb428u4Rw1pvjGc7psQ8I8ZrbVKtT24r?=
 =?us-ascii?Q?wENyhhiGP0bWdtlC1D/OzxB2EZcPONa5E1Q1erijoxGtPgzKQuIC/iTytBMq?=
 =?us-ascii?Q?90zo4QWXtTA7LZ3EvrAOEE47P6CV2GndVOiSr3YmZ1Toe91i7XOAPjLpyruX?=
 =?us-ascii?Q?SkjWQz+VQ6ORUDnepslSTdG0sMB+hVLkN5h9kfm80qPb4GW2WYWbpEAFn7fr?=
 =?us-ascii?Q?keBeJA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0e9a31f-d226-43b6-5acc-08d9ab09589c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 03:04:48.0438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2oKU1TWzjcPCURH37XEQOYQQXrQ2kNaXQIsfySy/Xzo7h69knzwIPwL3COZQpw56GTiOeqokjXyFbASv/ra9DQ53BHrU5WiXnKy2xVZGY3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5816
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=825 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190013
X-Proofpoint-ORIG-GUID: XF6-nmgJ0YBZDv0ffp5WOV-ygJMORTmw
X-Proofpoint-GUID: XF6-nmgJ0YBZDv0ffp5WOV-ygJMORTmw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Geert,

> There's no reason to have a double space between "UFS" and
> "Temperature", hence drop it.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
