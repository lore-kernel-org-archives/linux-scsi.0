Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B2FC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 04:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F15964FEF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 04:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhCJEsP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 23:48:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48984 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbhCJEr6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 23:47:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A4Y05D096992;
        Wed, 10 Mar 2021 04:47:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=BFT7SrRugYWK+YvgQXTECAiLM72PSXpubobH01K1hUs=;
 b=OtyVtN8Wp/tTTA0woV1DefVZ/mVUc1jLMOxF08uWHXbYyLuYF9+nliOo7oa07dIBj9Ex
 AJL3pfRvlVzKSpOGv4tqaHwrcOCRQbUifGH5fXEb33pIsfDlWbhOBgE+NeWGPaXfKaO3
 Gh7xIgEUoOkUfkFr49VBmZ1mbECwVK8KC/3keeM6I05vUymm5u5mgoEV4c+Xm6L8h2LD
 xai1X1e6E5x7opkovzGWPE2KCm/aj4LXNOA5IPAOl6Ig5gJO5LrGa5TyPLGmvAyq/vM3
 o2ZdhKY09Hv1Uw0zhaU+cMLk7+LBF+X9aEAeffQKbazskvZZpC1Y86cNpMA8M/ZDa4/x Rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37415r9n34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 04:47:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A4jV6e084985;
        Wed, 10 Mar 2021 04:47:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3020.oracle.com with ESMTP id 374kn0dhbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 04:47:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TE4AwEhFlwAExCVUztBs0KpKDMKyS3tBLelcG/IB+SUBeVKXEmAj/dC0a5eOylVJzQF7p5E9UUefZcgoMJN5XZhQ0newxFI9NCpL/XnRSoZhBp4ILPHXRJZlKvt14Gvzw0kGKTZSCAUf61rOK+ZOVWouYrdsNJhJTL8G0gLwMg21Kc5pYFnM4MQD0OTA2oCEcPFv0HVNp9d3+9nw/idGksOjrFYDvq6Ic4YwElfZmT6x1Tin8uPw7JYUStAS7Cxmj+NWBA8J3RrxlMGMMMYjd87bleWRHhjd6RueOdtzfWMHfH+xyRbhkTrOfRTXyL7wta29zRJesEIbgRIEMrMHtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFT7SrRugYWK+YvgQXTECAiLM72PSXpubobH01K1hUs=;
 b=HH2R0Bv8IcrvUiCt50cCqmiCtPgqYYOb424pdJudu0jfQwwqY0YkOg89QFqwYOzj2WlX4bgsIHAQzXI+w+fOXiEWl71/t/j9QPj103P4yQgeD/dnqw+Y+1CIXbdA56B2Sqxl4THcS4fr7omooOFCHKFnO8ajX57dXUWV5AarYqxkQbbZlZB9xTZIMD54iGHKK+vrtF55/cO4WDeZVqqZ9GFvFngOdAZKerjVX3qeFWNtb2pre5iUDmrlIzi4Uqx+dk8hE0uvo3xq5xuPz1lcY4wq4J64olJNM3SRockK+yYt7zqtDGEd+ZLNjLAxOTL0ci2GWughCR273Ir8onUKJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFT7SrRugYWK+YvgQXTECAiLM72PSXpubobH01K1hUs=;
 b=KYpFjg1KM/Mv/d8u2LS/TfayhloXv8l8XvWUKGmhOFz/BbTKmcDA8gOV3lJ/z0SmoPK2uGNejatVZpz11mwJVV1hXfYgYFCr6RZ+k8jp6bVG7zIdR1/WEwO/CGMu+Xke08Yjjzb5jGg64/rFerxqv2BKwZTWkp7+o3xexkp0NCY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4487.namprd10.prod.outlook.com (2603:10b6:510:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 04:47:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 04:47:50 +0000
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: pm80xx: Replace magic numbers with device state
 defines
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtvbaa3k.fsf@ca-mkp.ca.oracle.com>
References: <20210305060908.2476850-1-ipylypiv@google.com>
Date:   Tue, 09 Mar 2021 23:47:47 -0500
In-Reply-To: <20210305060908.2476850-1-ipylypiv@google.com> (Igor Pylypiv's
        message of "Thu, 4 Mar 2021 22:09:08 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:a03:40::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR04CA0010.namprd04.prod.outlook.com (2603:10b6:a03:40::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 04:47:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c620f9ec-c388-4d48-0977-08d8e37fa87b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4487:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4487CEDBCFB89D3348E175928E919@PH0PR10MB4487.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cRMmh0iLurS863+anHwZfI5+cLYnfF6VYJ+P20ZhJ+8LJLyzBhCl49qmjuJ5F7ZHX52o8VokqGeg01KFGwwanSbcgz2hl3AAFyI4MnB9cEj1WZmUH2KHGT+EJ9XOo+NNuSRjsx14JfR+ZyGDSGNOEt2V3795Wqhv4OYerXS/rgoXAYzlIigx8Y0/L/vUn9MWAFA7NdGnjTS8C38mnem5mnKfXbnL7OOqDa2AZQmkWlsYPebsRcByVq+NzB63f8T+1x43dXwfTz1nPrc/bFMWp4zHpbwarLjh/kBP0XcYnkfrVITCp3E9NLAeFWSwkQqQNLhsFNlIUfuvNUc5esbgXiVq950c42MJIRV29lZJk24z3wh4OXGJ72P/cvjkaCe5IhYzBBjrQsb3r0RuHhU3NQ06VR32OmQ+uoEduXpIrRdAW9Qc6IEXFAaIfi4zLYNSAL21yrMsna/TpXr8ZLw+6YmVGfFSkpSww4SemzH1raThT2zVSPQD8fpXAVyuCK+crg3suveq78gcYOlaUsmglg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(346002)(376002)(26005)(8676002)(86362001)(4326008)(316002)(55016002)(36916002)(7696005)(2906002)(6916009)(478600001)(54906003)(52116002)(16526019)(186003)(956004)(8936002)(5660300002)(66946007)(66476007)(558084003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XnbQbHlAFpTfNbIRBmcW1iB/AaG8HGexAS6ptTqR14kFPJ9t0u9/NbFhu0/c?=
 =?us-ascii?Q?pDR4asgOFb0t0w1kBxD0OWmfj+ACLe92XspuLagfD0IVNnZ2r+/m6Zr6se7Z?=
 =?us-ascii?Q?4WrrnDnDSZ+ZYXCJtyAnwUrlxsr7xlVnQF/GH6P+T06VkKcwFbFPwX2R+xDW?=
 =?us-ascii?Q?Eis3aiu7RMnRPguOZFVhFIqGJtzRYqPFOxXEFhZBIkKK2yRaLhcllAch2v2U?=
 =?us-ascii?Q?TFLQfDEuXuYxT08/MTahgcGQCWwN6c2kGdqPb1VkjWE4MvqYZYPbdCM7wldq?=
 =?us-ascii?Q?HWIJ2JgUvSf3DmHBDddq3LYpZ828PxaibH1Qt8rBy9LWhMlTqQVNKSJdRjdl?=
 =?us-ascii?Q?JtYaXqvN5J5t30ntbs8QSSOKIQs5LEUmiyqGyJvILI2bdFB5wd+JlWEhsfwN?=
 =?us-ascii?Q?tygqs0k0Jy6N+lI3T+1q/zO7/w558Av2SWs/og1HZLZVYg5MsBHf4MpN1Df1?=
 =?us-ascii?Q?vxD9cbj01ZeS/ZGQ0nGUNgmWGCVV371edwG8oyG911rLj0gugtUD6+M+RpbR?=
 =?us-ascii?Q?v3rAsDNFwhsUFuymxYcPSwQuDm9lU8FDZbYNf6qanX++CfHBoXPhuvrWmUK7?=
 =?us-ascii?Q?hgOIHxKDaw59Z/haC+jyb3IjPdj/QTqNbaQSHDfDpD0JqWa04+Xtz7ROPRRj?=
 =?us-ascii?Q?ycaunFHf4rAzr59ro9JlMBOm8vrWEGQrzTuaMob57i6AVn6Kkr/3YzZ/fEz7?=
 =?us-ascii?Q?w+1yCnMKiC91c53XfEyU/pTCMC8QAZwS5JDqhw4nksyYw0EOgqKg+P+40nxU?=
 =?us-ascii?Q?ZFUEG9xYOvoNay110UTq30JdkbvAzmsIhjaUMD1rEnysYN0Ji01Ty3jhUQGM?=
 =?us-ascii?Q?NvXnfR3x574xnDD5xOUAH8PSTHtDoBLdEQB/y+k+0F7MBhS/2jh+CGySqnH7?=
 =?us-ascii?Q?0YTp7IXiamB9Zcx8uKznPsXovY/lVYAS4AQUWvwg+8qZ39GNeQF/bNf4IhX1?=
 =?us-ascii?Q?fI2QTbluAuc9Eaqz6V7cD+fQxS+WIG99x7yZkgOFHcG4rXEvMMCuugA9850H?=
 =?us-ascii?Q?BGuU7tP3z/Hll567OP+y2GVON8ftuKWJNgwHao6zxMuuoa8juVbEx57tfD35?=
 =?us-ascii?Q?nMVwTGIaUtLnRmF+SUX/LTIib1ACdHZ3icqe3gWcQGb4/wiXqdDJnwZmZcIW?=
 =?us-ascii?Q?TqLXTso+4EXHBogEQAhke9caBKO+WKiWGTRE6LOgOE9T/1fWTo4PPzbTGk0N?=
 =?us-ascii?Q?HMswSmNXi+QbeF9HiIDylyLh303t1h1rVzdLdjbEhqHiAw5fky4jaBP++Rz0?=
 =?us-ascii?Q?qumIMKs0iljjbtm8zEL9MhE8H0MLZb9Cs8tTwH60TXBU9tbx1fb3QZgZMXPJ?=
 =?us-ascii?Q?e/zb6tMQHY9/B7eHIn4AVR71?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c620f9ec-c388-4d48-0977-08d8e37fa87b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 04:47:50.1674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /NVLikYsmJPGfx8rqccVnwQgrrdURxObmzokQOJgTvDdUOuqYMSP+R+nwYhbbG1QrDEsoupxzGHGk4wrf8W+GBp1DW/bdD0h0Dcr1nUy6eg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4487
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=927 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Igor,

> This improves the code readability.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
