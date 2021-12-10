Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7751C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Dec 2021 14:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbhLJOWl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Dec 2021 09:22:41 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45178 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232148AbhLJOWk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Dec 2021 09:22:40 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BAE905n026538;
        Fri, 10 Dec 2021 14:19:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=oJwdZ/Yt0ofvm803TjmhJP+YozO2Ok4oDG30Rzj9oso=;
 b=EhRe4G5tgGhZeDXoZ9CZOggZHPCoH2gJePFHut9SscI0tUbzpEjT7aeeZQoGuXRbWUAS
 oX9ObMJkGEeo85BvBvyb22Jbqpkt7s2FJvPiVPtMuXncT2HqPuIQ0czVt3rnAqAsCzeH
 oFyuFUwqRI8ctT0jFQZhp01z76cAAT1Kutz4FJIrfpJPESFpOe92hSo5+l/MMg3d8PZC
 NcfHVHCRqYGfL2nNvsMRZPP3hUS2xFV83OGbZRmzSZIrtCuoqR0fzNLRzmTq2Jb3Hhx1
 Vz5Hnc7sYo1VH71HZvPg9WX0AYGO1KCPbxI0Dj4El2HgNGi5501lYrbLXSMM1rFKhdWy 0A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctse1p61e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 14:19:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BAEFLHb098758;
        Fri, 10 Dec 2021 14:19:03 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by userp3030.oracle.com with ESMTP id 3cqwf43w01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 14:19:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPLcRtkAQ7ZJy25Q0WUSNixBFEalc8sYsurtrWdJAkSzKfkUdWETuG8zm7wJ8g8kIl4Lgjcct2qW58Qw0qa+TLBtYVm95KNC6kX3eI8GySyZE0dZaZHF/KhFltCHYWd+aKI47IOOAWoq1WdbqLpyrOULdi2bsZ7YYjqNNtUV9mMijP3K9ymFtM1op01VGtVG5mZ4yT/AZFtYF7HFRP6ezh21oUhGuByiIuwq9WuMtMafqsOOhTkExzwjnENED683XwB635hKwIdThRox1JfrjbI7mysGuhssElgq3Em5+qcoArfz18PJ4eDk3vtkM3lgiRTi5mksjwntgToRaQc6vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJwdZ/Yt0ofvm803TjmhJP+YozO2Ok4oDG30Rzj9oso=;
 b=VYl6pkcPHVq75Q7Y6pQre4quWMoYYzwqoA2MLbVW5GYE50fPhBxQUAkmQRLI5Rf+FdRFVufyLDU2DcrjjYn/pvEkiG7zdnAmiwlQbCoTAaHpE7JTgRcG32zjEZ2G2Wty5tcvxf2YWh7Hiy0fJj8A88b3HrLKbo7uxi6lgw/ybKnN+h8LlpoWMysXoZHWNIwNk879wjQrXNxbU3ubeBBbxt24odsdV+BhUQTeaHBbBfJ72UO87JalxrLLpJZMvzolVWTm7GLSqQaPQ2ZdX22jy7CIGuHv1JndJZBFix/8tTH9QqhlYM4nZPgV6fMkWd1j6hS1MV/Oai0qJBC98Npe1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJwdZ/Yt0ofvm803TjmhJP+YozO2Ok4oDG30Rzj9oso=;
 b=COrabqFNi2dE9kYpeI4T8t/bf1xGtW4+wCQ9+zRrWCrYdhLUoF3pIOJPT6naUDMLmdaA9SLrJsWJluc+GL3YAF6zCFcyGXJZLcuN5lHWJ4D3CxifYkEheV5X/PxjBaV4uvF6xsbTfYJ8G5tZ9kU3C03Y8dN0m2Fw5OgUa2MSU6s=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1823.namprd10.prod.outlook.com
 (2603:10b6:300:110::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Fri, 10 Dec
 2021 14:19:00 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4755.026; Fri, 10 Dec 2021
 14:19:00 +0000
Date:   Fri, 10 Dec 2021 17:18:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     don.brace@microchip.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: smartpqi: Update device removal management
Message-ID: <20211210141851.GA18906@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AS8PR05CA0010.eurprd05.prod.outlook.com
 (2603:10a6:20b:311::15) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by AS8PR05CA0010.eurprd05.prod.outlook.com (2603:10a6:20b:311::15) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 10 Dec 2021 14:18:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03be430e-bc98-4c13-57b1-08d9bbe802ab
X-MS-TrafficTypeDiagnostic: MWHPR10MB1823:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB18238AEEA0DCCCDAB8DFFB328E719@MWHPR10MB1823.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4b4lVQiK8AcVRoz/5LqiPDPU2czRrHgPhdFQ0Oxg3iydjVYmdp2k0sIhpDdQlbH4Y8N3o76nxRD93J0SedXP2DZcm2CfCT+ToGh36aqosfHN/Ns0lnLTC69iGAINcGtYIMmuzPpQoEsJTAbjHOfRlW6VDjKx1UB1htvWP+mIPVjYQpOrlmOn4uQJUN1y2+ZXp2Dg1qKG7oVGP1ADjYvAhbJ24JeaJgksZZCDsQDc6ngzky2PKLeWb1KT+F4U/+NKVGxXqbUsOjYJ7zoSneUh+/sCBMVsmPmNErDQqjWA/qa/6xgPxGPZebJI3DaSO2c687hAeXMx2mO7mMP+sPJEbyDYWRB8FVevcHopkPPSg0gGug9SoTs9HkDgl+Sujnm3P1ILXZJzlRu8zWi8TxXgESWWZNzbdENGBKZgqE6Ve13f9aJtWJBCKOE4/Igddrz6W3nLACo+ALkvY145e058Dutb7N62KrvZLhNK72VjgnPJXp1yMd6c/UCglPDauNe1hJRB+BiYEMKDT3OrS4CEBZUqWqzlmYA5ohq1mBPrzjEnBXR92jy7D9Bp5nx2YM6Xq2ZwunvfnmZ/Nbm1Dmf0RqLcjfQqD3TDr7fU8XvZlTsE0M010H+qJxmcwML8RCEWdpHa0S63MEROxSZ1HiCHw89INJyXgNpuUgu3ec6Sub06DDR7VVncXJcky1DdHc2IPXnK+eQW05Ymp3hbq7pCaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(6666004)(4326008)(1076003)(55016003)(9576002)(15650500001)(86362001)(26005)(8936002)(316002)(38100700002)(66476007)(38350700002)(66556008)(66946007)(2906002)(5660300002)(6496006)(52116002)(33716001)(8676002)(186003)(6916009)(956004)(9686003)(83380400001)(44832011)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m/n/AdLLTkA6SuGCU62hOaLvtFsrHLAnpnGQiBawgipOHlsGmWVQD6vp0+jP?=
 =?us-ascii?Q?9YswjwrcKrG0FUo/LbXgXCkzxbUdAlVkZQ9Kfxg886/jDsIDZ5vd1iqH6vDa?=
 =?us-ascii?Q?9M70lQnMA828Qmm96VUfHbPQ7MYtbbBax9mzBH830a/wVlC16to4Goa7A65v?=
 =?us-ascii?Q?RnFKOlWK+iLiptad2BDs1+GOCM4ktAZcjRZFppGQ6EsW3DG9IMKnapmOO9ev?=
 =?us-ascii?Q?e4MN+GduJK05ode2t1q2ucfKsC2mFoAB0iF9p+C1yhPSYxh4ms0zx3DBObGq?=
 =?us-ascii?Q?yblZIK43ic/OfU6PnCeMyAI93MwWPyF4QAQys7Ag4NFVts7ZkfCVG5UJ/7h1?=
 =?us-ascii?Q?bkxaQVk8AsPDedvPWWVrVdwkIiqi1ZyYCpA0XrqtVEKlbmsTEFscQfe/p5uz?=
 =?us-ascii?Q?2uEZ4H2AZf/EJNsAl1h0TkEiuZd1c9TDqx/EW4WlT1gNfJ6BLm9T0NWbH4DS?=
 =?us-ascii?Q?sSImTrdihRq7h69kwgHiBQXof6ZQ0LDiyJn9J2eiHUaVH5Y+G8dNFmiyzinK?=
 =?us-ascii?Q?nyNsLvBGV8wyFkSWUCn0ZGyjrMl6NMxPYRA4ISXm5AAIh1r34Et/xKSg9MaK?=
 =?us-ascii?Q?XpNfimxu/EEAXyxaCGCbrPX6h4xiOcKP9zC1joraWKJyUshUPl/3WM6ZrNYw?=
 =?us-ascii?Q?7zEeZHYc6uxFOPQWBegIYba5Wjtef192F5WOAE3UlbyWS1DjMNfZplC84uze?=
 =?us-ascii?Q?OIHKqL9eU3iPlG7sPw9AEb3nyyKrUqp5BnHnSsEVXpjhaMUb05hq6nsyRe79?=
 =?us-ascii?Q?sFBof7FgidQwpdyg3tmTssK6WAFzgGGVFB2otryMIUIIP25e5P9QSlSjVavI?=
 =?us-ascii?Q?+r/1ryu123p49/nJAIe8bB2RoiI6MnuPnXViNfTXdvov7OZr2NofRgFvecEh?=
 =?us-ascii?Q?5sldYhhAPDK493l9P6+Mak6tImpWp1bUxVaz57rdGo6lySDWYhYRqSzw39NI?=
 =?us-ascii?Q?L6cbpLSWW37QPhEN6eV5vGLoxkoxkT3DLBzPuA11Y0/IaYjMx37lFBfOfh7X?=
 =?us-ascii?Q?YAclh5xPA+wiA+yCJdgcO8of2mT4wuycflNBbe2ejbBCI2kcsH9DS2TdD4wg?=
 =?us-ascii?Q?6nitZxmkXh/UaptefZTKKQWo8V+UOUGRhms46Iw3V1jicULJTxMim1XBqQbE?=
 =?us-ascii?Q?vMiyahqqXoioCzIU2rLj5n3LhvQ7K12d5vfUGD5JNNUghrB03SG7wWK9BnQa?=
 =?us-ascii?Q?7IE2VNqvPqoFiEJkXmfS2DW/BWY1CPTKOKD5ol8iuHQ/9DuK8LrAQg0IAvzd?=
 =?us-ascii?Q?VOQX+UQRmAgjQj1h3FLv3QZ7+yJcy8XxYwVL5/eovYwxmIktFUp5yNBdh4zP?=
 =?us-ascii?Q?t/y8va5YGfXfxxlP64K7an9C45caNF+dSOG1eJLsHkIdHJBVASn5CUhepWAZ?=
 =?us-ascii?Q?6BhFxNME9ILFRS7sizkchbCJKHXPKFz7mTRFbpyIR6dc13IgPu88RZHTPyh4?=
 =?us-ascii?Q?JHs2kN9rpyBP3SWSoqtArk3fQXgN7aVYNYJLnEYj1VJ+C7wIjHPJahDK8Sdr?=
 =?us-ascii?Q?OhVwKS/xbjOBGFQc+6tKdp3kPXfXrleUk1CRcff0m5u3J5MdTPiAwlHvgXPq?=
 =?us-ascii?Q?Ywav55gIYUAkqMkt/eRTaqjDY38YYAUVXeUqHZnBBZ+6929MOAY1gzvwBpIw?=
 =?us-ascii?Q?lKr+tGLMNld+DlYEQNc/SX1akpkhBQqE/cljD96j9R5HgRdpA05Bi19AZHYs?=
 =?us-ascii?Q?RpXHIbKmO0IA4JL0CWZa7NHouAk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03be430e-bc98-4c13-57b1-08d9bbe802ab
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 14:19:00.3764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqcdZ4VsFWnNtiryZEldYYuJktW5zaQ+nZ0QNaxxlVLsl5NBYx0i9OqOSWu5oB13RrwNVKPv3x+F8LuKjVrGb8OgIWkfs6sIhaqAIKaVSHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1823
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=848 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100082
X-Proofpoint-GUID: 6z_VkVYSQYHIZcNz4KteCHBRamcS61dk
X-Proofpoint-ORIG-GUID: 6z_VkVYSQYHIZcNz4KteCHBRamcS61dk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Don Brace,

The patch 819225b03dc7: "scsi: smartpqi: Update device removal
management" from Sep 28, 2021, leads to the following Smatch static
checker warning:

	drivers/scsi/scsi_sysfs.c:1463 __scsi_remove_device()
	warn: sleeping in atomic context

drivers/scsi/smartpqi/smartpqi_init.c
  2510  static void pqi_remove_all_scsi_devices(struct pqi_ctrl_info *ctrl_info)
  2511  {
  2512          unsigned long flags;
  2513          struct pqi_scsi_dev *device;
  2514          struct pqi_scsi_dev *next;
  2515  
  2516          spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
                ^^^^^^^^^^^^^^^^^^
Takes a spinlock

  2517  
  2518          list_for_each_entry_safe(device, next, &ctrl_info->scsi_device_list,
  2519                  scsi_device_list_entry) {
  2520                  if (pqi_is_device_added(device))
  2521                          pqi_remove_device(ctrl_info, device);
                                ^^^^^^^^^^^^^^^^^^
This calls scsi_remove_device() which takes a mutex so it can sleep.

  2522                  list_del(&device->scsi_device_list_entry);
  2523                  pqi_free_device(device);
  2524          }
  2525  
  2526          spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
  2527  }

regards,
dan carpenter
