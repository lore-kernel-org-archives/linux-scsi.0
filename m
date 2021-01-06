Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BD9C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 02:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EC3C22D04
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 02:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbhAFCxU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 21:53:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59780 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbhAFCxU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 21:53:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1062oRWf017997;
        Wed, 6 Jan 2021 02:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=9GtVbBDZNEkD8JWrJXXreLI+5DYexUcaRN0GDVX9zos=;
 b=kE6zxe1Smb6s83LRzHW96+TaA/ZFOR7oDvEyEPm2mPixFsjMCZlKugzymY5J/5Q0NWJu
 sOHYWNnKmZklKSjzi0ogat31hFn8Erdq51ecmyaQA99xodMGNzv3WE5M3/9ZYM+OO38E
 bwIPTIB90U5j1huIm+IWkYYHVv+qa+H22OyAKNKflWQZgh96iQdG5BwxkzI50b3fVPyK
 bvMCaELW53jVD4xIWVVzv9xSnyFfKP/QFAh70YnTJeZbF5CBCmCLlQat/WJdTNSUlpDm
 q/8HkgY+mHGbQxWgTLijtiKq9gIkCL0KuoJVgWvInQarFRe+T8i4noC+nZEJjtSg8Ozw 3A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35tg8r3jfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 02:52:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1062isT4084764;
        Wed, 6 Jan 2021 02:45:34 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2055.outbound.protection.outlook.com [104.47.36.55])
        by aserp3030.oracle.com with ESMTP id 35v4rc4tea-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 02:45:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FT0J0qHwKiPQWM0yKOr/W+zT8kJ4wC3xdaDmwZnc43+Da52iLXZuc0UQYS8UIkT980JCQTnfFa7swsWcWp6dumbthToIEyR8DaQWHzc4VFMDRHvZStPpuy6FQrpT2y/4/UtMgu8xdaUeKK7cqDrhKh1q7QWD7YX6vOhoYXB8vFERainZAqMmbJ/I6AwC9MpS0eJ3T2hUTyCM7Vnd7R2xd+akEEvnINdtWSavX8k22PYXMFLov2FD8nGH7y4WfEt7PQ9UnR31LbstX8t/p23VJJ+l4c1K+x8/oBOJ/wqkIhY0Z6ie5YACcZPJprNZ6aW6iZfoP9LzpU4fF/Om2aR+BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GtVbBDZNEkD8JWrJXXreLI+5DYexUcaRN0GDVX9zos=;
 b=BeVqp/m69oPaKQYxfdS8NTzdI86TD7ZW/jgAef/cp4/8oVSWyyqKo5sE3DpTiDXbMKzqmcAmeAAN1/qQ4CCqI1uV8OYZrFaZV1VdRz5M8zKiEksgjkdxMVvvnohYwIAlw73oXAlr2ZtXyLa8Q9uE5ddbOKcCBnj5QOA+qC2mrLdmuUbsk+dDA4EXF/za0hYRUhE4HNSB4F7G/TQh4EJ9C0NBGx2wIQyxPSMrq4fmTsLMHMywV+svMB7BWR51Dz4AXNOPrhyetWUlQLhOqES8xTMXNK6ub7V9138JyQ0C7KwgcL3Rk6XAnNib2+/vW3+sJWqC3PekO5tUSE7o2PCxCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GtVbBDZNEkD8JWrJXXreLI+5DYexUcaRN0GDVX9zos=;
 b=DTbxlEUUrXfdTE+7hx3Ce0u31t6S0sLSiLaGMErQwGbEPaGmSZv0g1DZFfVOIdyHJ5pkIfj9qKeQCu5Dt5aFFVV7eFEGjOCA4sZm1DBFrErX3XwvpOT3QYog+PkhHOc0f1gF56qeeYE8wInT7gO//OrQJNFgxDawDtl07w0VfwU=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 02:45:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 02:45:19 +0000
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Subject: Re: [PATCH v8 0/3] Three changes related with UFS clock scaling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im8ag4z6.fsf@ca-mkp.ca.oracle.com>
References: <1609327777-20520-1-git-send-email-cang@codeaurora.org>
Date:   Tue, 05 Jan 2021 21:45:16 -0500
In-Reply-To: <1609327777-20520-1-git-send-email-cang@codeaurora.org> (Can
        Guo's message of "Wed, 30 Dec 2020 03:29:33 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR03CA0012.namprd03.prod.outlook.com (2603:10b6:a02:a8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 02:45:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2939844c-1211-4632-a8b2-08d8b1ed1b2f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4711649F162E4C0A32AC7B878ED00@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wlZ8dkomezV43vZlqTBEyJcFvPhCt1peZwF4JxoSk3e1S7roo0FeUAVYzeTxzAHuEn+biLx8nWmTLEg60SSo7rldU8wW7Ggve6mWyvW4F1xODz/8PlbjqsBotAsVY7IKI7L5R1gDIGO8RyoLv+9t1JDLaFwH/J79TQVf50h/Wi45pH7QtoIjNnbNjTnsPpD8wWd4S/JmiOBQAz9ICfSJXx3dlFZR9kE3FmRkVaub1BCwXhs1HcYHjSHgntciV3OTVUH+Ok7t3hbymD0NysPRND+A1YPmK3k4Zb2VQchkGALpP+rEnRq9OvYrL5FDk4/OMT5Q+3wmnkQ2nGOMS0NeccZGv5kuHgTnE4JOtMkujR5sM/imv5xbEBZAOLJoGQZbuCyWLVMSfHddcUYjvIv2uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(39840400004)(346002)(52116002)(316002)(36916002)(7696005)(26005)(2906002)(558084003)(66556008)(478600001)(16526019)(956004)(7416002)(6916009)(4326008)(8676002)(86362001)(55016002)(8936002)(66476007)(5660300002)(66946007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TU9QVAciShhRf8w5XIIKzozVt+IIt7rozK2aW2KY5ye2tQvs1cxPlj5/G4u8?=
 =?us-ascii?Q?xCyWiE3EU4P+XxdnHOZA0sjoGzAmwNPP8L2LbrPPM57jM6BHAHwUVFlrNYAK?=
 =?us-ascii?Q?1MP2AiV3USeZQwiZ0Ppsqj1V53yL3i62La3cozFlucTfQDH6FHIi72amJQ+e?=
 =?us-ascii?Q?78z5cEnUXZ+XOcBGpyKR9dvOYpbd0lgLdF14GWBjZA5BOZrwK4jXNDWi0xrx?=
 =?us-ascii?Q?WIVZPddqWPF/GBiQk9Tn7hHa4rhY6g4ymJ0TG6CG3k9cfMBqBbivRFZZALJk?=
 =?us-ascii?Q?Bzbgbu4Z/suEZkPqcFvlGKI2M5+/HoU0u8fGm5pAARTuUk4k8WK/ecFKsnVD?=
 =?us-ascii?Q?c+E4lJv6vTbNiYLPGBaVZgt32fF0dMm+/jF5bywMEYYjmIcx7hbx4C4tXwRQ?=
 =?us-ascii?Q?Hkabzs3WnoqGGnJINo3vLy7ByTbFxYXP1IMI1UlXUHz3xr5hRAKHYl6wghpS?=
 =?us-ascii?Q?SzPHtGENMyLEM0AG0HXMRSoA9pfYDd5bU13V2wFFx+G8+7lJCDi+NhCXkjY3?=
 =?us-ascii?Q?d7KDOVTVWE+rsX3FtFcd0w8byfv5SsiMKu2U0BIwj7yoVeBUKzBziSgo3zjQ?=
 =?us-ascii?Q?lp+OHtQQlMiqgrjLn33kDfBQ9YxJrPTIDbiheNNv68jGIKzODbb2k6lejRD+?=
 =?us-ascii?Q?fI8IHRddLTjjOWUX1xMl0UDvMC/4lBH/CtTnOtU2eGdxSPOFTIJNd8Ec9m5U?=
 =?us-ascii?Q?lI49cGa166WxrEPsfjXr8YbGuOdGrN4ZeyyvwrUnXI4cVbFVh80J0FJPUM64?=
 =?us-ascii?Q?vUKpKKpVNhEMGuPJscgBhH8Nd6Pgz0iV33Ol1xleORiVSfBuXbmJ2QraSZOU?=
 =?us-ascii?Q?vYj1XYESsKLPmvYFnoNP7ggwYo+TJDEj4XgVgJcbefFgiZcLv9byH8q/+6Wm?=
 =?us-ascii?Q?p1wM6qemzVhMfHqqyw5pZxbf/PZo76vkn/QaoSMZeFCR85+9/Dlz7/QG6kk+?=
 =?us-ascii?Q?OE5rtW3oMHVMOe5vTGMQtoxs/FZpYQWUbclZpoiTgsk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 02:45:19.3283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 2939844c-1211-4632-a8b2-08d8b1ed1b2f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CKPtrx/NqYL0QlDU3Si8vPCs3EUqGCNF5nDOlAeN/74a2aqsjVlZ7J/iOVEyEjpUczvxnQYQflyYF36mzzLKKa9jYsmsm3FiAW/RY2dqMkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=960 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> This series is made based on 5.10/scsi-fixes branch.

Please rebase on top of 5.12/scsi-queue and resubmit. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
