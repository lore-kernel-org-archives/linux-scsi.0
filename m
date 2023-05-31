Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B3FC7EE23
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 15:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbjEaPVa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 11:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbjEaPVX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 11:21:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA880C0
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 08:21:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VERRMB027640;
        Wed, 31 May 2023 15:21:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=Sn8SCRtboH92F6sJ0wudnYs98Hr9X9RNZnnq9ZKCxPI=;
 b=ttuWiPVqm6E6ljJipACPldq9FnyLh14mYVj3ndHdigUWQoyc/ySiTQwnin/TPBpbMMP5
 +RqiynGLD62+28uC79QYDTvRS95w8fQZUESoMfrzqf7Ki5dAjwM9YosF0pQehvOn++R4
 hOPOUxfvksbdpbI9FPTxalxBRbyg+0KRBTApK6mJiQhZ6r0wji0f6M6t99l9QseJAB5Q
 v+F5GNeeMSrmb+sH1j9UtpSkMIhwuQb2V2jUXYJduIFvh/Z/31EhnLCj+ks3rz9yxNCZ
 RYdxtkIeRLdYM6ot1D6P/BKxnmk1xeWseYGJCCxMD1r8yHn4XAvvisW7/fIA25uIJI2n lQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhwwe2ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 15:21:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VF0Y1I014631;
        Wed, 31 May 2023 15:21:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a5qx1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 15:21:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naUVsunn6S/NAUOktpB7kYXQRYadYWZXqnLhb5nauyxu+y3JV4noaas8aF/sdgXBvlZAxlomQNp2mpotYTPRtBtUsR6KVu2rV0yOPM88wrEZVeywpafhx7QBp/61xT4khhVR6BBxRwFymtvTuWW28l84fNgmyh9tXivVbMm7NaxvSw103lSFBfuIBdrGvrVfKcCB+AG/h0H4ZY+HoE5mnDvFgNoKYe92SUvlKlnYi0sSsIePwW7A5GB8l/vl1a2BKPoPx+Vo6clRDLdLmMK0QqSjgSVHXmqB/qwlk7UVy4xqkuzvPQ1tS3ZVA3YQVt3sxZ4acJ4jR4+UU7BFoteBJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sn8SCRtboH92F6sJ0wudnYs98Hr9X9RNZnnq9ZKCxPI=;
 b=cuWlaJGatCQPJ1sbOLW8xNP91mUBpJdNvssKcoGY7UqqtX9VBOySy29iqx+qJWqK4ymVJKLVX/EEj4jS1VNLkLOMQ/p9L92LYL9Qq0KwNc63d7+N/Xrh8yYxwInkNUOP6NnyGz+ovYVSbZAsFj6VTivsHeQuQrgCbafLGErQQVp9NZq1o61lsIzpHc/WWCuB5erDPFHdvUjDSVg+Pg000Uur/0/bbs7+iA/vuXHAbyMr7729YCQuY663bThqHWWoIXYo7RxygpyBG396I6VBnZyibFh4ivTFNcLbsq0T7cDgLu2SMaDHfY+pR3zwPpPlxZbOty/T43+dbaIXKbmL0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sn8SCRtboH92F6sJ0wudnYs98Hr9X9RNZnnq9ZKCxPI=;
 b=Q8jcHZH3MLbT84E0eIgzqtEKgd3SWGoTcxZxuZKtOFAyob+F7l3GcuX3wSQeaExFh5pWab5wUs32kZf4hlLh2uZ0gTRWKrqXoXSFPg7P41XLIEw5G5jgemu2U0W3kk5wsGwwYgRRiwkiA6fwOS/QDR/gTYyu1H9WeA24XBTKY5w=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH8PR10MB6338.namprd10.prod.outlook.com (2603:10b6:510:1cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 15:21:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 15:21:10 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ata: libata-scsi: fix ata_msense_control kdoc comment
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0qwfrxk.fsf@ca-mkp.ca.oracle.com>
References: <20230523074701.293502-1-dlemoal@kernel.org>
Date:   Wed, 31 May 2023 11:21:01 -0400
In-Reply-To: <20230523074701.293502-1-dlemoal@kernel.org> (Damien Le Moal's
        message of "Tue, 23 May 2023 16:47:01 +0900")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0038.prod.exchangelabs.com (2603:10b6:a03:94::15)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH8PR10MB6338:EE_
X-MS-Office365-Filtering-Correlation-Id: 99f45c6d-a2ea-4477-5c9d-08db61eaa9cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MGPjygTmW9PEZa93q4uzRPtvmXOoNTT1htWqy/Cgy1mi876yNJcMOeTcjrmA+YQOSsoaKJJLLPXA3MEeqrHuWsXrIlmh5/p5j5MYi9rUoFWLbuHoSZbOWy2JJNC17B9qQxJq23BLtUi9nfAFrnxn9ceoHHgjLpVYssFPIPwUrEDLb403T5H/9s5hZV+OrdZEmufi1BdmDPs3gmoefO074UPjhzmNLVvmVqUAVrOZ7k4Yckh8Q63100ePzEajfY7BPKoxzKr+2mMxtdkXgf7nJvh16i0uknPykda4CMWbVE8JCLuUo5jgnvn4UC7M2Nx3XUORnN0MmkQh7d5Jf8AwzEVdS1nkex+44RO0D4VnsZtkBsaEHBWbH0klzkqIxqJR70tsm9vjUO5YAdT/DedPX1agCvdovrVQEiJzdRPISzD1HbBmlW+wmgzImy3OEzBPwNeDfwvxebf6slzBo9yb6WGN+Z0x4XYeQ0nj+glBZ24Y6vIBO2vuN/YNKIeyORsSfMknub6RpPl1bYPyVYdGmXvET8cYWNFUaGoCP5YFXkQPsBcRmnVR3nEML7QfR1jl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(366004)(346002)(39860400002)(451199021)(478600001)(8936002)(558084003)(5660300002)(8676002)(2906002)(86362001)(6916009)(66946007)(66556008)(4326008)(66476007)(316002)(36916002)(38100700002)(41300700001)(186003)(107886003)(6512007)(6506007)(26005)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7Y2bF3lIHi0Hot56v2WI/SkJgAZu3E7Xl+HeIjtpuuzoDrB4b0gjTOvW61Ar?=
 =?us-ascii?Q?BcLKxtT+iW4H9e5ULIFIs9HQONq/Mo87SGMo8vxOpbOUfcmajsAMsPn00bBd?=
 =?us-ascii?Q?aZHs2K7aFvdqhubIizBzM95SeLy8iJUxsvZ4P7dvKPYWnS1tyUlAO22RDrDF?=
 =?us-ascii?Q?whpy4DlwG27gnU1lJuo48MoSuKjRqriMdNIUhylpg7WjLHUNltzn2Qkj3FAj?=
 =?us-ascii?Q?OJ375+5KRvMwHI+YQ8JIZ0XEofF61RzRJo7kylO+hql2WlYHdW/7gSD6XJ15?=
 =?us-ascii?Q?+1N0GOQLvutjZgtSvlTS3uwhjWthpYbd64nFxiHdV6XmMosp8uIH7UMe+Xec?=
 =?us-ascii?Q?qM7RuXMhCryMJwWsKOvdsVFhHiq8hkD8ajFvqDkZyGKwnqxzs1v6iDA8axCo?=
 =?us-ascii?Q?f0tx30NH8m6djrklMiXKzHoK+XV/uTe5liOJb0YYM56pzNgid5rv4/AtYxic?=
 =?us-ascii?Q?CqSZqGLquen22l3CktijpfDf0Scet98i6LJ/iQMqIP8eUjZyjLo5GPSVmd0q?=
 =?us-ascii?Q?789W0s/oQwn/a9QV3lIc0cFuWQw6PATap11KH25YkfLXM878m3NWI1OU/DX1?=
 =?us-ascii?Q?SpZpilhgNlIBCNLNMITXCa+z+k4asK501ht+Qj4uueF2wA69a4fYsA/MW+b5?=
 =?us-ascii?Q?MmUlPeR6ZXZpHoUXKWh4ne7B1nIui1g8i5f238cFc9Q3U/6hFdIG2eB3W2hl?=
 =?us-ascii?Q?9bcAqA1YPGFWR0WKVJw6zRKH5c0CVDv9roHww+v/R4hyV1GoPgzX/IwdJdet?=
 =?us-ascii?Q?hVtFJOboAq7L/l8g8+jZLCYjDlIcC4z66FXQEJ6UkPOhlnjh8XoPJNnw4OBB?=
 =?us-ascii?Q?3RVKqIATERtGyES9sq7Y7nh7R++RFuxedjt2WJ96tQm17QbYAssoo7fkQUbF?=
 =?us-ascii?Q?OLNR/sUr467/UnsJJcX+FGNwl8oAMkOJFSTbuJJmbrQt6/y07qQR8QB9Bx68?=
 =?us-ascii?Q?2K3WDIkAh2Sb+8xSAhZBsFJrLkwHKRZZ/n1+RyI/YhT84r1+Eo+JA6TIsH+Z?=
 =?us-ascii?Q?lbYu6b/xat+IzmQx2jBEzvKXfAjje2JvyufpGu1QCRJsBIQU1wteGhu0Xf+7?=
 =?us-ascii?Q?EfrSUMSCdtjmaxrxHeeHu3LfDlfXoVSqC5zkmA7ksejUj7opdhfF6vRW9VoY?=
 =?us-ascii?Q?Y9mSSHW+QD1hvdA0EIkK9JpElN/hyRor/lj2hbcPwEqx3MyjVOUyCmbcWNWL?=
 =?us-ascii?Q?0doHay0Ybh17kjieW9doD0hSXe16qX561AWLoaI6KdvyQHAIQjzTMC7ufgJ1?=
 =?us-ascii?Q?QF6SYd3AyYqZ8lcPLHKqMDZBNZOEbtfpV2sUHyt+90NZCAsFS5c1M48zEIq6?=
 =?us-ascii?Q?bbMEuHagtCg5+HFyk5fkp+J7pLlvcRQ+NUUhbVSyFBfUS8ObSrqnKjCn8dX4?=
 =?us-ascii?Q?UEPTc+r4reexeDRUFGtnL7mddHhmsP1/cVH22nE8rPZCWHqN58dChyDCwogD?=
 =?us-ascii?Q?vUtclva5JpinMYfbaWUNh2IQ82ute0oxrwG20qe6GKuDoCbVNAqtKIr0lh+2?=
 =?us-ascii?Q?ULsTOpHWVz0tIfVHoKh7ZuDBGE80/Qk5I0/9o+hN2xdvZ01QZMYzuy2yHSfg?=
 =?us-ascii?Q?F6zaG66S4btJp0PW5ifYd1YptK2nt3Ra0VxFtykHnPu1F/ZbgXX8pp6bA2lK?=
 =?us-ascii?Q?/g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NqCqy8N1G8mTfAn4jzp3k1DLjD2fmo/UyncMC0p3qxB8gpe8xVx/Z8CtDR6JSACi/fXzgEj+UR3HS+yO/7K9tG8p/iTtbKfwr4liez/uK7DfAmR0c7T7T6a9LsL14GVWiScGVh2i2YY2+TRUic2jBNs42r7TAp0Xng9kMv7fvp76OlatXzlLET/0BWTu/7k5ay+cQ2PPjjF8RTaRM9I0/HWlVDo2JII3CJwhxZWe6zYL5xWSpXFhQveC98Dg8lYmXV4uyQ1Pg4L0+3zzCESU6jSfpHclJ+j5gg2y3JsesQrHP00xGhXm4zU8kQ+/IiX5bndm2lyRqMxIOSoc644KqI1pnR9pbwOG+9O9Z4H/osYajcYv+kBUs9ftBzjq8GJdABXueCBiO2xIZLJKUfJ0N/wZbyqSi/ekedGqSbBn4wy7xScFFz5M79sin/nW8adkFByBpS/kE6hUM9zoIu6Ac6uzyKMZ2aFjdVEM4XAgcXrTD2Cdv8FNZS8+QQGJI38HqcTN+8QCCW37oLAN2YoCLiEqQ7UyniVa6Ti2HLJxYyPIx7F36sXksg7JCXa/wOsDj1Ji4WgDaRGB28+CxQQUSvtsn4kMufsyfhXT4QaDwJZcbafM9qH+cjdHz/OUBJNjU+JMxjjzmau8Um65LPB+a4t3jKvwmGtwjCh8GXdoqhYm6nJmxEwdbyjkn+AiXj/gIjG5966GjBU34/cJeYGgrpPHu4VfO5PkuP2DatuLExAX1FAPNdDU4ZYrNH1Y9iMoMo7PHlOuHqzqa56dQk/yMiDw67wPMcYQnJsCabDGp+U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f45c6d-a2ea-4477-5c9d-08db61eaa9cc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:21:10.3310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JIPcNcUJpfhRA66zxu0w0Ea25Y30uqJ7wZHqRQKFDkoyplwwvz3xeVYPqgfg+GxByltGcn3AJgyyF/nvqMv3Y61RPLe9jOrnleEjZ12BMz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6338
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_10,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=721 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305310130
X-Proofpoint-ORIG-GUID: 7OciGJsVM7aK8yXMMVuxotf3XW0Ki_TV
X-Proofpoint-GUID: 7OciGJsVM7aK8yXMMVuxotf3XW0Ki_TV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Add missing description of the spg argument of ata_msense_control().

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
