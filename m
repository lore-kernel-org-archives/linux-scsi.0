Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEFCC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E991611AC
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhDPCao (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:30:44 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58118 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234926AbhDPCam (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:30:42 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2U6LT027199;
        Fri, 16 Apr 2021 02:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=xxbqVHWmIXY/QM+TNK3d3qoXD9LYkwOk2oVg1CZ7hh0=;
 b=pxZF10STsKCYzlE2sH5HQnVkmvHYgj6i5eYA/MeHFPhycK5FdMwWxcL+RvQEUVKC7iTh
 bE9BmOmvtf4kbWtijDQ/bOFCalsQpmwXI2gmtCKz4BCjBaJmuwWrBjVKIYtJsfDVfVEE
 8DORdorUso2fDnODxkUUZuCatXQgYrYklPd2+ltkwlOzh3oTduwk9QHyzzKv7bSNwc0b
 hhstuj266hI5bTjaZIOBnvVAzHLOnKx9PQDWVdbnEw41NMDD6onoCgOxj9+yIuVo/ktx
 xl9yUg1O6pqhG3euIkpcEvkW/sjm73+p8rx7UcWPJX94Cu0QOdZP32iIUX3tsle0pwqg MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37u1hbqt9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:30:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2Tojq111404;
        Fri, 16 Apr 2021 02:30:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by aserp3020.oracle.com with ESMTP id 37unx3tcne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:30:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxXFuqR6WPBo4D8GBhehhyEY8BqhVsqzNorI4NnUErMmTq9xVox9V9wkmyGMV5z0fZZECgzVyab++JH0UIFi1bm1mQ/DeMYvPqrwkR8YBdJ4BLEDftZFlma5R0CL6LLVWmhpdkvsujF2NgJQJuXN3PvFXHuw3vm+M5RRk18gSLw27zWKGInaKGV7JxC3m2xh3ehFc+Xry771dSiR5aNNwRoTmxFsp9Ia9XWpoRpjfWLyWXsJn5qnJWDpIIDXTOSIfMTLH0GY62FNNpmEu4zPqADRZwJ0c4dNPHS9TBphm2hlEvbIHqYF4DAAQ0BFGmHA8S0RUJOF1cuHIfUX7uJJmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxbqVHWmIXY/QM+TNK3d3qoXD9LYkwOk2oVg1CZ7hh0=;
 b=I1W5l1d/vNYON+w0Ay2EJ77ZLu/A6xidF+LxJCMBQxPE0Q03ChoVc/U5GgByP23M1yNTk+04/clMOwO2qCBDXlD06elzFM8GD1H7kzoWdYYHsGZW1T/7sNyDp+1H8/SwpA4n3pOWH4mJ98jRTwyqY3dtHkUTp3xw5M93ur9QQwsNIBsRGywd6xokhR3sYHqrZYJ6ytexkVEcFpWGYMfWp1hxIWnyTzSVvuv6SwhrReitnBwM9olcUd1rUoMBVsNMdpx1SXCqFz+0hC/kJ05/D0mhVISAM54+ciwSI7fSAW/uqoFMo7yDMOeq2NO62vFuyYeN+pddcHvTJfP5ohQVig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxbqVHWmIXY/QM+TNK3d3qoXD9LYkwOk2oVg1CZ7hh0=;
 b=ahxncNNsdXF6QyShRr9peXxSk4ChqTZ87cjRIkoPXJJNlTzU3+ihYM/3t5OS4q2MNTuziITujpg59l4okl6Y8egA1fcRqiy47aN4x7TMQ0foZqOhXb6+Yybt+M0ts284dGgygmqZS8HNzVSeiL4MbOQNi8y07GgcAMcOJRVShHA=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:30:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:30:03 +0000
To:     Viswas G <Viswas.G@microchip.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Ruksar.devadi@microchip.com>, <vishakhavc@google.com>,
        <radha@google.com>, <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4 0/8] pm80xx updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmyvyna6.fsf@ca-mkp.ca.oracle.com>
References: <20210415103352.3580-1-Viswas.G@microchip.com>
Date:   Thu, 15 Apr 2021 22:29:59 -0400
In-Reply-To: <20210415103352.3580-1-Viswas.G@microchip.com> (Viswas G.'s
        message of "Thu, 15 Apr 2021 16:03:44 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN6PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:805:de::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR05CA0023.namprd05.prod.outlook.com (2603:10b6:805:de::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.8 via Frontend Transport; Fri, 16 Apr 2021 02:30:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7aa533e-b642-4b9d-342c-08d9007f8a82
X-MS-TrafficTypeDiagnostic: PH0PR10MB4774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47749CAD65255480D90E15B28E4C9@PH0PR10MB4774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XX2onkxBTlCPlxu2NlcFQ8VrikFQBa9HZO0L3IqZKzYggGIh42+CAqfezUSe0ujf7RJT6a2634EKm6b1NFc9DPmegX6PrV7zfBjwXmW7bHezC8BjuyD2BzfCpQNya9hGd0FaZN+daqnuWWcsRyz94hJetedc9grNxJXrs8BUH2ChiG2OJALrcJ1WjOaRyfSUuBFUPTsQTdhTDNUcQEV8hQR5oJG569GRC0fpXYxrqj7bIrKC2BSaJPtJVMi/MW4mO7O19i3z+EXmUts5vTqYXUFeCAQ6Cm7E1lM/f5RZgK5QKoNnOQKb4GtsbIiYWyvdyeTvYK7+0sXxiW1ZH2wQYInmhLHQDc8NvyGNIwvLS8UOdlDDTL33z92dYeSdQES2EQiCmUZ7/1eJcohmNMlVAhk8JhaRiGqFNLmvn+2fo1CzmZXRu4zKx2fN0OtCHEjlRDj+s8s+bUt/W+LE1jEjWX5SlaidmLnVZFW10TjPLzq993XLi8dQ4d1EQQ1L4wtoMuFlaF5TXTlDEn2jDj7rEmOjhKCLWeszxlZUrlLRNp2E+gzrkfoRiWMimwn0gJe2l6SY4+k9/iYMxSu9XY0/awz7QbXe9YKEilgfrUFbZJQe8G5yPPf1PLt7JvBnzFSOgECPhnJ6TBxVLSlTLpyJ5wk72jYXtoEMbM4hEK5A7ig=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(366004)(396003)(6916009)(86362001)(66476007)(36916002)(26005)(16526019)(7696005)(66946007)(52116002)(7416002)(55016002)(6666004)(558084003)(66556008)(38350700002)(956004)(38100700002)(2906002)(316002)(4326008)(5660300002)(54906003)(186003)(8676002)(8936002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kYOIkI2qkYhSs1Svm26oMTeRmIc1X+W/ItKlGRfOEip83/nS0Nq/38fi8lEv?=
 =?us-ascii?Q?vIdcBWJkeIZ7hO4TXg6VbEpuzMA4HBXh3x3leu8CuFsj6ukDLGU+fXn+lx19?=
 =?us-ascii?Q?QwoB1AFDvSzI3M6wksWtic9rHrFBp/QoqesPSPUfEZxxt7ypRn/fCq5AaO/A?=
 =?us-ascii?Q?q0z/JnzWzv2GzH2/koGeFMKCzSgqEz4Fo9+vz44GWtXfhD8qXB9oPQwIGjjy?=
 =?us-ascii?Q?ZQQnYha08lfABWRTYOQZ7o7y16aqJChsajAX1U8axEXNiMB0H9yenIqAcMTO?=
 =?us-ascii?Q?/4sTRyuOyOPFJg/ZAaLOWqfAWbtfueFqTLsxAGf0I4ZJ71f2DKpsP3+MvV4o?=
 =?us-ascii?Q?cwTGh0i7/Mk5MWig6DF00LoSpJ96tcu9906JpYP+Qnth5D5V1+S+j8RG4KNm?=
 =?us-ascii?Q?/RdIMcBf18PYK1Tx2I54BEAfJe9iKQLh4xTcasAZKLmp8+4wvxOQcxNRsF6Z?=
 =?us-ascii?Q?TPVFKkhqIK0lBxnXAYoVWCKCHdJ1eYA/gBfOV0MP6744rwg5SLSgH9Ll6Zwp?=
 =?us-ascii?Q?am+3rTbKZ+yPh0tJrW2hyWXPJTdeolR47NKiwz63YD464zzOBol8V/OtJ0bB?=
 =?us-ascii?Q?AmbSaruE2PDUNsr1uz2W56F/GLrA9CoMnSHtQH6LoM1a7KxrVDeDImVKJs80?=
 =?us-ascii?Q?avD7FHUSHuVVJBlYyKsviqEP1gCncy/4kOCnEdpiSqolJ8qkJbYsiYvS80K1?=
 =?us-ascii?Q?TfawFwlI/BKPSZKagRkmhyTOyCoCpKcjrXg/3qp9+dRd4l8acvZEhqSKKRbJ?=
 =?us-ascii?Q?vWwWoCA6ONf7Twgq0E+Vn8L3ZbJThoXp5CN/2vrxLir1Gx9Nv1C1r5LnPKJR?=
 =?us-ascii?Q?7YIES8GDqdBj7hI2Wet3kE72l5xEjAXLQvUyjpct0pU9KAxbMsyjnHaekj6N?=
 =?us-ascii?Q?XfIuX7LylV6a6d218KcyatNWxzWs1I8S8dinDsOHq8o58lSwFNJvJJD0k+32?=
 =?us-ascii?Q?J/tzysE6a9pjfdxIMadwfaIYjTO9vWHEi2JMTL5RB05u4h3MdXRplPk3tsdB?=
 =?us-ascii?Q?zjlsGs+KmTWxSsWYQNsa1P3Mh7rLvtGMfGgK3ZAHdo00MmN9mHRXh89crfk6?=
 =?us-ascii?Q?Rk+qrkMqg4g3xvn1JqXXId/gjKOS0wzCyD9jDr5q7BgSW8OMcpFog3JxKgpb?=
 =?us-ascii?Q?bvjQcimLtptOntWmIyzK5VRlEPv3h/AhqA2zGri9E0K59dtyJ4gMboX2Xxzo?=
 =?us-ascii?Q?khqrXWAZWE5QoKjxsRHt5DDtzFXi159F5tNIFgeAJypIy1xptGKxE3P1MM30?=
 =?us-ascii?Q?9Enc/kKLq+msqZCn/El4QmgKQ+1G4E/djsVinE5CVuJguS83vVuxLkGNq1Tf?=
 =?us-ascii?Q?tcqjV80q43JioLfPgO1rmCuy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7aa533e-b642-4b9d-342c-08d9007f8a82
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:30:03.5575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JdVD2foRl1BfBBXRoSIva72sMsjbJ+jw5xbH+pQUyjOnwCkrv0iQCGbhJRC661uPfNMcnh0XM0DgREpjJtAV2svS61GlfuRTqxJZ2TGMK2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=807 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160019
X-Proofpoint-GUID: b1vXLzulMrlCiO16Rf7dHaRqtLWNjYt3
X-Proofpoint-ORIG-GUID: b1vXLzulMrlCiO16Rf7dHaRqtLWNjYt3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Viswas,

> This patch set include some bug fixes and enhancements for pm80xx
> driver.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
