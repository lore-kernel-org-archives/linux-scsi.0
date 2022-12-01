Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EB3C4321E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiLAD3r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiLAD3p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:29:45 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EA45BD60;
        Wed, 30 Nov 2022 19:29:44 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B10sYxU013177;
        Thu, 1 Dec 2022 03:29:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=DoTjrO6D6sCfVCOmszxgNxPe0nStP2o5g1MymJVdlGs=;
 b=VGebBc4o8R489T10J15cRub6QBMqPu1usnepVDqUay1ArELU44pT23fN4pkcn3qCPDAk
 d5vx4JS/iNsBUcSC5i44XX59UrO56kF0w+0OXgzZWCRYDUvNHsxIxHRsoadDgnaq8vGh
 6E+VhKXgYbqf4QGqhaEvUPKjmIrLq/wBjI2xm0AY2pmjoKLsiscU8HkMPfUgOm8OJmIN
 lhPVyO+Qvg6ki0ClnTEpfqLzDa4Pvw7Ygj1LCWwpWHYyaGegvI86cE/7JyKJwWAvrSDW
 HM9xF/+nHLAnpmPTWxH4RJC9CsTyuW2SY71Il5wzNEo3tB+0nWQ/deEYKeAIcJlFgwIB cQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m397fm7b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:29:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B12Ose0019669;
        Thu, 1 Dec 2022 03:29:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a9ks4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:29:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqaEpp+/KvlgXLfXTnHWIdw1/TUT91wCO9DwfKaLy5RwYisO/djo8gdAuEueKNOwrH1p2i0t5TZpJqxlt9EjW2w4odEKBfJMxeAwwCr8yQYZ1bOyv4uJppYhX+VE6iLdgBawf3bylm2KSfHRrPB0uFLJbYnWM84/E/lygHKnNKCA9dbpBjB4CJAUmXcTpncsxSKOvz7tA4vt2HWtOHMKQwBZq+871FyD/dCUGyoYlrVWGwzSDhRVDWWkHS0sfhKvvAqyChoXFL6yI13niZjpq2/VXiUtknxwavgpZqXWIi+2WwVJitPhhYuBIPsuoLq3qREkeC+4qW0LY9CZewpeSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DoTjrO6D6sCfVCOmszxgNxPe0nStP2o5g1MymJVdlGs=;
 b=Hwp5Pq+l9zpWHpDkMBIC+B90wBLzLm7qEkgAsWj5LRv58oX0NJejiCDeqj39FNCparmIB9Zsxe0IX2C95nWEXkccalJQb2De4WY0IlcLeMGvViXc+2KSiUtcfalSlNttQDI7+Px57UNI3Vt6gOw+wQdongg90WrlImnMCPD8HrJjtbCw5N9DJCYGSRyk6HfmNkv+iZUGWrE4d5HH/ui2rpG59HgUm9H726A9RAEeHOm6eI1Sy2TMDAdOIxSXXjneJ8wQZwHxASWWcHMNmy1WWC99l3zSZV+UduI3v/6tKQTC9cLBTpMk4tHK9NDKCtM9IfioYvvmDpwlzxJe90Lp0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DoTjrO6D6sCfVCOmszxgNxPe0nStP2o5g1MymJVdlGs=;
 b=tycXTPCATFfo6yaL57ukoNdHiAxiATbH361+NXS7BjYDuKi7LflgE7OLBjPU4ijrs91ECHImXzlTDpIvDAO0Stv5VIVDjbP74FCkK/oFtTLDsCotNgwz0zpF2cOIAD4iHbY3X04bdFM7MJJZWI5R1dHLZigQ5moa860DnWU2vXc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4315.namprd10.prod.outlook.com (2603:10b6:5:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 03:29:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5880.008; Thu, 1 Dec 2022
 03:29:01 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] block/scsi/nvme: Add error codes for PR ops
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yevkdse.fsf@ca-mkp.ca.oracle.com>
References: <20221122032603.32766-1-michael.christie@oracle.com>
        <yq1o7sumo0c.fsf@ca-mkp.ca.oracle.com>
        <538bcade-c453-e6f8-4530-808a9bf2140a@nvidia.com>
        <20221129132805.GA13061@lst.de>
        <613117ce-56ce-10cb-1548-eac1741ceae5@kernel.dk>
        <b84bad4d-7129-c848-215a-a7cc519dc98a@oracle.com>
Date:   Wed, 30 Nov 2022 22:28:59 -0500
In-Reply-To: <b84bad4d-7129-c848-215a-a7cc519dc98a@oracle.com> (Mike
        Christie's message of "Tue, 29 Nov 2022 15:31:23 -0600")
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0041.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4315:EE_
X-MS-Office365-Filtering-Correlation-Id: dbe8df7a-fa4f-4ffa-e3ed-08dad34c30c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e1X73tyCu5g+Xd5U1Xb+aK3IW88rLjzULSfI3irYAA7JZ+QXv/DlptPlv1m5SMVQes/f5ByvHjclaGkWQmMWyvgXNDq3HdckRMB/f9DSLFJDPAxYFntv7gJtfTNudIC/X1D88lFtRt83Q14xDzC5/PFnHSj5jktB42zv8WFvLevvGq6ckEv5b5dkRULx+AF5FKbXsiGl1NuJxdHfQPmcSNyQUxexprhZQYvaExeaJXwoZk3Lr3ooFcm+7iHy7PcyvWwWQIU+rqHPMpRfQpC6oBnbPK1BC9qiuKSg0HIuruZ8Is2fSHYTJeedclGzTBeNjDUvj0501almXNt7qWmGr0DbnXjvcxAPCKxSmDM6mTBejATgR198hAcat43pTnWh0Wreq5O4kXsDfyV8cmXzJpXQ79//9REX5NpJ1DUOw3S/mac4hwBzorRNNG3fUgerKafofhACcDHfzwqfWfnLB4eGrHyn5Y6aJIXJP6DrMkE2F4NART5X+M8Q8fQ3+t5VsDDzReIfrlMxM1C4/jRx3aSrhpjcmxplthqXNDoHktxhY7b06co0Iov6jG79McIh6ZzfKI9Du649O9Jd6t/IVP16vCxuof7YMGS93F0rk5mSqsjmx+WVD4R1LoveeM6shuMCHswZPHVEEJgB6lGLfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(86362001)(478600001)(7416002)(6486002)(36916002)(2906002)(186003)(6512007)(38100700002)(83380400001)(66946007)(6862004)(6636002)(4744005)(26005)(316002)(66556008)(5660300002)(6506007)(54906003)(8936002)(4326008)(8676002)(66476007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xTP+83crqF2YZD/682MdlBbSXUF6rcelHSwxRbS/4TY0Mdpeij3Papuh2kHb?=
 =?us-ascii?Q?LfN0+P1RJ/z1yKkog76qO6EwzfAgnrKJMh89BCDOJh1pB/kIxZpKh6tkFmov?=
 =?us-ascii?Q?HtBBCLNN0BkRWq4EDT61IBwleAo9NdsImr8nIw13sQ1vrTpy9XL+Y865A+KY?=
 =?us-ascii?Q?KgH/Z0XLqXVkqkP4aGv17Guk8ZR3GMStRj9TLV4SsRENGhBNlCAFtoOLwhS7?=
 =?us-ascii?Q?BN4/knBKK4gO0ZcrhlFgOYEfHeM4S4duSmw6Nvfc1aS79OukM6HQTPm0KIPH?=
 =?us-ascii?Q?KLqVA2XvcUKe+lS7OM17kC50HSXLIq5fa6ov43v2kE18Jk+/iX9rvGosLnH0?=
 =?us-ascii?Q?yEFjWGVSdyJpM82mmqGUT7FrtZ5AED9HXY3f95vPE6LAMZxeOFjUH1Kxct/f?=
 =?us-ascii?Q?Gyx2CMeT/smS2eNXF0b2b0GkpuYhF7v0+6lyd7V1G9GVsJBhBl0RxhN6p9vq?=
 =?us-ascii?Q?GK7zC5C2AyeAyJ1J8H9rme2A6bYssqML3jfqTehvlnbjVKESrkWlu8SxYOGH?=
 =?us-ascii?Q?b8r9OJfSrb54+X8LQkKHxfX8m30JEryJWRBoORHBv0qgtkfG7Txqq5xhtdSj?=
 =?us-ascii?Q?fk70DAkjDOCXoUjaohXkDZK03w42lskqOJLVhlSSj6uWo/bwGh1xXRKn/5Hp?=
 =?us-ascii?Q?XFKP/5SBwmGfkIWN/dP6Ok5nZO0HeG5nNOo9sxdaQQawLWf70yZJXIsm9uZS?=
 =?us-ascii?Q?L25mi2HMSxI6pJXtuGOEU4qB3GMsBGghNfAIeq24jShUkx63Bu4t0496GGOS?=
 =?us-ascii?Q?wiMkeaWJHcCa47Hs2Xb/c2HIoGEe5QJBkevF8LZsPLuTZfjoNaUVcJbrx4uH?=
 =?us-ascii?Q?cL1YpjMeAzrVM1eEtCXTstmvP54FUGGYYPgM1vGy07Jw/GEkwIqZ3ZqOZUZh?=
 =?us-ascii?Q?79NguxCsejqZ5eDSkSrkeT+mgW8wEjh+iXctPUZPpyiSeOsK0Wjoy359uPNE?=
 =?us-ascii?Q?SCcBGZZqG+RrFQ3ouM+AyB1PK9AqhL1QgHOdE/Dx1huuz1fSZsxsaf2AaYdE?=
 =?us-ascii?Q?MJXHersQ242zHWlblBopl4XH0NvV+vZAiQnVR79TIDyWl9oA6tIEVbfWglzy?=
 =?us-ascii?Q?0ArPgj2P2H+W8h+O7nuvz6AfpgadzvOZTQ+3PHyfp2oyLEIDRbblfahdtBlo?=
 =?us-ascii?Q?acE2DY5LZZwOPo6APCBLsi615NoGI33YCxtMDRjvuiMIhejGj26ABGvstijH?=
 =?us-ascii?Q?Co45i6MTftWohPGYDERMbgO1BvsbOLp4Fsarv8t6rYs7MIhRTHkaLVZcu1z5?=
 =?us-ascii?Q?tycqT/lGcEALnRAZfcG5E8nd6V3GgEete8/JnmNv0uplc9lAAlDcPoFcycYf?=
 =?us-ascii?Q?q7yCwQn4z1k2hXB2LL68qMNfOoZ2sxou2Q+RAX7vtscL1AzNJrDB/XM4yEKR?=
 =?us-ascii?Q?pMsSCWnnH1k+1zLwPA8pETTGLRoeMSLuUFYjNzWw3drz4zSTZYCDhMOfbtKF?=
 =?us-ascii?Q?RGP0VKySz3v53X32YCdv+uV/aChXm7d0j95M++yZivgHA1TrITbhD9T2wGDm?=
 =?us-ascii?Q?HULyibZJgXMZt4Hzm+5JXWi34d0vCtz+NCGn43j6qlAFXs/s1m25tH9W85Dd?=
 =?us-ascii?Q?bELtx/1M+p7i/QS+wyNUFbsqRMy6uVR2pV0xJMgozzDU97mtMUzr6Hvl2nBy?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?jS5iV9xcQpDgF9jRy0S7jrSE/HIieLa1+ad7LCeqweVcHnhud+VAfwBz+ahr?=
 =?us-ascii?Q?/3JcdKf0m/+R+lPdzJYPj0XFgz3OU6lI/FnoX3cT6RfKF5NevE2GfMiBr19o?=
 =?us-ascii?Q?3b1HZ8R7YGgft0arZ/8zHN+0NZnHdLY9v3VTIVa3ICtRNSspRbMQuEvCEHPd?=
 =?us-ascii?Q?2pZluD004io6HRk5dzeaQ+J931pfEj/oFhYPSfF0Dw6jwwi0dmYhZD2qUjQi?=
 =?us-ascii?Q?2MaM2/Y2tRnIJDGH94CR9zrfQcsXQxEtLEKJ/zoI/xwfi85ixNXIQUhxzjPq?=
 =?us-ascii?Q?ZfgLNzc24MgBanJPw+m9t0imtE6JfHeDolYhhCPm6uX5d7JInrW7Jit0L/AG?=
 =?us-ascii?Q?t7Hq5kd2v5d4Dhwgkzry7WnZezytReJLJ2wnEkttfEsCOws8z5ofa5oh6TIg?=
 =?us-ascii?Q?pA7mmgz0I69kFYb/BD9OkX/IXLDfg1fjH6nIodhP+yle7xgFx1EsxKiEyujw?=
 =?us-ascii?Q?Kb8549eSKcLae3+n47R74t2rqiw+LmxzVuy/Cc1xx65kjurlT1Mn49lfbeJK?=
 =?us-ascii?Q?nE7SnAVcLQO+ddXCoWM2gJJsfTWrneXHYyKjwlFuCDoCb19A6GlWwbxLpva+?=
 =?us-ascii?Q?d8fKwgPQVSty31+eX5U6DcDKlHDcVYl0i+EE6Q10g4mAzQxypqn0V8cVCPrx?=
 =?us-ascii?Q?jHIAJniHt7K00f/jBcXr2drAJJlDYGpJDTI3yvVFBvMU20+k9Qf8FeiIbjTv?=
 =?us-ascii?Q?vd8ZnRstR3K1Mw0FvdBO7sf1nf/OFGnpyr5mhJha9z8aykxgbmhAZ0lBkT5t?=
 =?us-ascii?Q?+WnKQfF9YGCAdpt6I1vUhQ9kjvCYXZZ/LtLzy5j/meMDsAXWF2JYNou0elZm?=
 =?us-ascii?Q?77b1oFmskmx1afCQFEFZVAhUB+5F7RjSwHw1lvAzDKM3osI42Ac1Bumef78V?=
 =?us-ascii?Q?nnSAuz6GTmmZx4+MXYHcuiZV8nuYInHEofgMvunmEde1mU8Edlv610KRykoZ?=
 =?us-ascii?Q?J5kmZR2IEcKYbwhnpI/JBxllxcqNqxYTQyDylnXn6jpWXGGetr7SVkCn0p9a?=
 =?us-ascii?Q?5A3/di1dZ0PohaOSoTg1WZF0Sc1k7omEvo2jOY0TmCSrM18=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbe8df7a-fa4f-4ffa-e3ed-08dad34c30c2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 03:29:01.7576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v8LmqH9Yy7Z4NVlBCBY9AbDuuYpoGinbwgVEypmZzQEH5NYE04DyBMY+AUhPaAayvPMUmkAzZy01agsMMu9cL2Uk0+gDWia3MIwSQDhjPg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4315
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_02,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=945
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212010020
X-Proofpoint-ORIG-GUID: YkYpR4aXU78l8Rs8j15qE4oWVSL9DVFQ
X-Proofpoint-GUID: YkYpR4aXU78l8Rs8j15qE4oWVSL9DVFQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> This patchset has no conflicts with anyone's trees right now.
>
> I have more patchsets that also touch the block, scsi and nvme
> layers that build on this set. The future patches are more
> heavy on the scsi side if that makes a difference.

OK. I merged this series into 6.2/scsi-staging. There really weren't any
non-SCSI changes except for the NVMe tweak.

-- 
Martin K. Petersen	Oracle Linux Engineering
