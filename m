Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1B6C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B52F61216
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbhIODbJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:31:09 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3688 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229983AbhIODbH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 23:31:07 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18F2Xvmx011608;
        Wed, 15 Sep 2021 03:29:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=s4zWdhigge1gNuo5NK5Ffzf/1ux6E9HB+FsMiBjHSis=;
 b=MZLtbQJfGnMyr3B1qTi9HKBLWZRNNNUkJ+Y6DVufjDirpty2dbT/yQpQLOfBkrLJ8Sn7
 vds5zU02xtEEMyrL4FAUlzPoNsIExXA6cVGd6Jb1NdrHkSvtuo2sMqqMCdoT8h/GJn1H
 rF9sDp+IHjb27hCWYkC8azbAbaNmu6uhvsfCXG5+i9yOq87YXZkHiTYQ/YpJTWWHZhLq
 06LgNn+w5rx7HTGgL7ok9UUGyaTuuxiOAqZHHSg2GUlpCIZOVW5E9/qh6CpBMZavk3Hf
 cjwqdTQyLS4DzVokOScWoM53MbBd8Bww0shSb5ojtkrxFLZ66WYAd4tvybvrNXAfm9JX iQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=s4zWdhigge1gNuo5NK5Ffzf/1ux6E9HB+FsMiBjHSis=;
 b=Nfjdx6nJk8FwZIFVzYZIO8iIJWHiYreS51IH07GCqw5gxM0yDLuRrsy8aNF1Z+q0bFmm
 /EKsTpX7lX2ZjfVHv4ESr90pRZHbf1paB3EjuC1CxnvLKTKsHRRJ/tKaGVbe1CT7ehTM
 Vcufvly4L1LLJxJt/xy4ozzXZx+AhvJAyKZvpyJyC7RJ1F5Z6GaGwFPNZdwCylkS8CDU
 idozTcn3DmLr3Ex+IZA0+1suXYyMDPj+ffojfy4m9lYL9UQudDpabPrWUmGqdRZ7x8Tl
 7DUMhT9RVeSdd+uIT8X7MG70vRyLKog3/pEwJR0YWuZyUlahVSwSWMZlF5vPVcY+Rdrv vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2pygb5wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:29:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18F3GYCv171365;
        Wed, 15 Sep 2021 03:29:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3030.oracle.com with ESMTP id 3b0jge0702-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:29:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V7pP3Bs0Sjt8hfjsdpdNpzPjG0hy+6QBM+StDBeX/Tr5G5hjpSufitnK6vbMOUJTKI+xZGploAL7Nqo3Mmdnu4l0iMIQQ+pU6vEC/weVH+91xAWsGDDvh3qMtVDf3rSfd/hNlzAIhdXN5/tZdpzrODITLh4Ns2jYCQk1Va/BYhZ5AxIpe/1jy8Y5IuYYjnYUZR1EoNBhjC9Ii5YecY+4JZmU9pnvtjD1/Riwe9m8bOlIORoRVLlfBiDQ+bLdfmRXZNJpT1wKu6pwh8T13XG8YH651DFc3dhuwZePH8MiELqhWgzsEN/W+hUS4we99wv3Kof4Rts5X65qs30dKGi27g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=s4zWdhigge1gNuo5NK5Ffzf/1ux6E9HB+FsMiBjHSis=;
 b=MZ3lMypjNAFJEzHbW29d16dv/oGQBb0WqjnIXVW6a5wkda9iOwB+g+b+QSmpm/q4qk2thTg+f4eJ3Xz64UkOXFFwQ2oCr56KIUxbwayUyQSqEvUlRi+F+2xZaOHet9dTgcyLbNODjXdKsLwvmGzIz+AvGkzwx9aiFxdaT6qiuAztGUF2CMV3I0UE0n9WqjicbSlRlC+Mm5Z5kqdplaI1f1Htp5iuH/1st/v4zUqoFByeKZq+QgxjOBohmmx+hUc1/QtunXAoSUbg92BKHK4OCbEf/yoOOjNs9kJXkP8HF0Slag9Lz7BdwXQNTwmYUyMS7kv3xUUwlzhytTgZGiJWBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4zWdhigge1gNuo5NK5Ffzf/1ux6E9HB+FsMiBjHSis=;
 b=PGeoyGI8ABvD4sNtgvPHz4gLwZ8MrYq9/+feZF9+Fr5OmNvkzOf30c5fIuYgObYRsOH139GvTKwFkrp8iG9sSbOUmORpW97s0yKkoWq9Vxz037Mv2qc/BH5ri/G1qR4M4iZoqImaRqLrJr3LtZz/PanBT+E0rbhWOO9wpKztIBU=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5593.namprd10.prod.outlook.com (2603:10b6:510:f5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 03:29:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 03:29:40 +0000
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Keoseong Park <keosung.park@samsung.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: ufshpb: Use proper power management API
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r5qwm7b.fsf@ca-mkp.ca.oracle.com>
References: <CGME20210902003534epcms2p1937a0f0eeb48a441cb69f5ef13ff8430@epcms2p1>
        <20210902003534epcms2p1937a0f0eeb48a441cb69f5ef13ff8430@epcms2p1>
Date:   Tue, 14 Sep 2021 23:29:37 -0400
In-Reply-To: <20210902003534epcms2p1937a0f0eeb48a441cb69f5ef13ff8430@epcms2p1>
        (Daejun Park's message of "Thu, 02 Sep 2021 09:35:34 +0900")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0030.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::43) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.50) by BY5PR20CA0030.namprd20.prod.outlook.com (2603:10b6:a03:1f4::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Wed, 15 Sep 2021 03:29:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e26ca858-bc67-4689-8302-08d977f90d19
X-MS-TrafficTypeDiagnostic: PH0PR10MB5593:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB559309510772B426818A70E28EDB9@PH0PR10MB5593.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:272;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gy9fGXuRL8STn548zEQV51vnCPlgclrnYTicOzdbOvmgFOTy+uu/pGC8YZr8gNSr13h8UPb+4G2Is+teyZ6SPzUmXjzZgLeFhhUyM8k7/e4XXO8yJVwJVxOQb49pdZpfcyTftV1ZJU3V/gqqB+UtXJGx+KN2sltEO0rhWVNgY+eyDgOpmvPsc0NZEifOvNkcvoGYaBOnFT7EX6770wBWBevLPTgKDHkZrMQ+2mjj49JM3464i14B7XYrnCcUazqmW+pgpqR8WQajhUeTjBeVvzHif7ScvxZk+oV9WmwRHWFAhiuIq1vo5CtEblTavGRgyHfpZhUvvF5y6fNkRUitiIG7SfJI76sXKMyfJxczS9aEIuOyM3cE2xJZYQ7yhTpRJW4QWpcaPmbMFMxetcDpIGhDaXfP+kIw/kIzIdqnOlQQT5qrurZHVNKB/X3h7rHnKmrkTH9cVaOh+BS7uZ6oQ4mtoGOhJe6K3yQc7MBXcMi/nSN0ya53VL8JX8WnJj8tRaR4f4GfF1TiNhtT6PUwFq8JJPOVJicIJijeMbhbpOZjD5y+0eUQqHKmIMxNoIhgS9FJ3VzjhpFAfh+yYL6vo86ov4PkKna9brKlkwZi5tjTvCHOtCj3LMBQIi7ibrOgXOtI4draDCGQaVF/CNdGo6JY50ZkhbAjiJoWiFEivVBmUyz/mHyprB9AZkS+5QrkjYGuHoQvlcb8FPHjvdmu4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(376002)(136003)(396003)(26005)(38100700002)(66556008)(8936002)(86362001)(2906002)(38350700002)(66946007)(956004)(186003)(66476007)(36916002)(55016002)(6916009)(316002)(478600001)(7696005)(4744005)(54906003)(83380400001)(5660300002)(4326008)(8676002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?myTsXZTNHgKtUq/oT1+lFB6oUnZYbZqWJfgx88Hs6F++CetwzPOXWEBk2QvC?=
 =?us-ascii?Q?ks5yUaTyfaTTfLC29Bhh0N4xCj1l3NhSSTMy2CJvoLSyo081T7DrP1+gJtgb?=
 =?us-ascii?Q?4PUgmlPLPinOpNQMxRvnDOnLyRBfdLK6cTOXTVV1q0K1BkyoB39k1678DbIR?=
 =?us-ascii?Q?XX16ZHPjahdAUi4dzIKgPlyN9Kb2GAdwcGdZbJ08IjGU+1BR/c08igkmexqU?=
 =?us-ascii?Q?lL4y7D4ujCxXRKCjzOUonwKa3ktdcoxSRHLMRJe0w+wRab9wbeH7Spy/Dd66?=
 =?us-ascii?Q?POluRJLimbTPzGAbip83mDsRjiBq2eZUzUvILQ3IdHOQfZAebz4YkK6yvacd?=
 =?us-ascii?Q?poKDqFY9c3OjrAZXERxK5zWRCvB0Hz2Kdl7IwEqtSFgaGN8KPEGzYMDLlmK4?=
 =?us-ascii?Q?8wGXEHqdnb+JFZjGIkjMTNmRGoLDQIYIak1Sb3JF2EywZm+k1PEtlPId8aiB?=
 =?us-ascii?Q?1oJDBvZeEKfr51N418MOzH50Eggx/KS3qec10XSIF5EdO8NVVWXzewJQGShT?=
 =?us-ascii?Q?YrTyrfWDsJx5QaCusinUYdIAYOjILJpzc6lU5aTCOPUHgC/59BeeREzpaEjj?=
 =?us-ascii?Q?aCSf0lT8FVXQrQSf6qht2R1EJW+JgrcoG8EcZ1dkzIpDxWtj0RVaw0pv7E7D?=
 =?us-ascii?Q?AfCO/5BaNux86jrUhrEvN8DGyAr9VsEtqhN0Y8fYCGmTcVKts4Ia3OLdpOKC?=
 =?us-ascii?Q?+pnbLfPkTGyEtCcWqdvoOvwbgdb7AInFIzJIM1uYOnYfl+ooeS+vWg8dYvcd?=
 =?us-ascii?Q?mYhpWRp2Sa2W8NtOYrYDxmdX4KpDW1osA68nY/WZH6jyNA2+J5G/8KKQekYR?=
 =?us-ascii?Q?BTJZISnuP1xOOovlm1dvaGU0fcMWBWytmF7lznvIir64bGyXklKlTOyQwwuA?=
 =?us-ascii?Q?S+MNHO+cwY7099AT510C1WEr7S/FGrY82TTbfFtuDlhUmo9xq5N3wDoLnNFi?=
 =?us-ascii?Q?zUnaS1ykV54PwYx3Z2nvq00BWsXgBYseQAbeBXOX8ouFO0VOjvAcI4JzdFnb?=
 =?us-ascii?Q?DkTaLDc8bR8dwiroEoj5npPzlhzaZAjb4Ycqp8Lv1bGuVOVOK3ZCaCS2iK00?=
 =?us-ascii?Q?O6xt9Ah4QzAPQc7jffUV0SdKgtYa2HyngTeyaXvI9ua9LcekHInkXoUSgo/D?=
 =?us-ascii?Q?JSfCEqLoXvK0d43+uCHQ2RnpjqYPbItslaASbxBC7l1+dmwibLwkUoIxPwc1?=
 =?us-ascii?Q?KXdrCWpQ3IMZ5ona371hq/gHyzdab6vHYPoujRbsZDP9nNfaW1SZj1FQqs62?=
 =?us-ascii?Q?XlkfWye8dJEoFoFodQKHu+UpL39tUGBDZ0LEfdVRBkmHUgu8LtA5/DT7mgCm?=
 =?us-ascii?Q?epMYp4L9KzLd3bd/kxDEGCNR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26ca858-bc67-4689-8302-08d977f90d19
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 03:29:40.0849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2F9fYj9Zxv9CUDm5bbFBXaDQvR9MwQawAjgIwFQZn8eNzC0m6XuP9In8N6JaBNjNtgC1qEo24lTVum+CaKknjs4HpSrNElUpg50PEo7ggc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5593
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10107 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=761 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109150019
X-Proofpoint-GUID: vqDiHt3GhttkRBgjFhi2b7llF8LJOwdt
X-Proofpoint-ORIG-GUID: vqDiHt3GhttkRBgjFhi2b7llF8LJOwdt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Daejun,

> In ufshpb, pm_runtime_{get,put}_sync() are used to avoid unwanted
> runtime suspend during query requests. In commit b294ff3e3449 ("scsi:
> ufs: core: Enable power management for wlun") has been modified to use
> ufshcd_rpm_{get,put}_sync() APIs.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
