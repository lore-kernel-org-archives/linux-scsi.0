Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F07FC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 02:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 529FE60EFE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 02:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbhHRCia (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 22:38:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:2342 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234435AbhHRCi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 22:38:29 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17I2W9De023069;
        Wed, 18 Aug 2021 02:37:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mdAo+d9ynx/JPfxZfvJdUa6lIOgvw6SUoaG6Vb89y0c=;
 b=EZKYqF3sK8ReL0oEBhxAvJchGJPSv1v3HXPwUUQA/dcqcK6kri/+mFDOlNwuVi7KoHLm
 /YC40cVPMIptlAEmXasnrHR5FJRGfrzlxHTaJHzAmcUK6hwXVP/jt+yBUxbMwZAG2yeW
 OjwBC7QQZbalbaNOMRqbCmYMP5wy67j5hWuAoEt3mpVhqaTKlFYOFLKRnzkEGVjgZYax
 6+CypdsrrV49XVAdYqx8bmXuRJLE1X1RAsrIYrNLqvv9ZRDYGnMGGff/irH9llHXWM6l
 0HNgGEnshGsXIg2cEZjROuYnvk4eMaoZbecV9PDomIpZ6UNreFxRlaD+3Jkle5zZwiip kg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=mdAo+d9ynx/JPfxZfvJdUa6lIOgvw6SUoaG6Vb89y0c=;
 b=VI39cNtkMp32JMXcQZ+gd5+CJs9JiqNy63IMdhBOWyA4xP3eRDHXSrPQtqNgCxuMghtH
 YcMxEruXPl82de2QhKHQIG8G09uMhXWwvkqVvzE6Fismx7oRwzFcdAZxyY7KQu+UeWHo
 3aoZS67/BFfkawUCxOrNozUlFfyvUI0x1uXe5g3fjpTZhUZ7MpVuNXK4nQmv0nqBhic7
 tmQCZhiBTzeCyAhTi3UzrAlN/SWyZSwv5yk1xnVQbZQnqLwekC2QDYakOqd82+VWwmux
 S/EL2cbDRD0v56fDfyTH2Xq1vrZHefJmpi7wdQ3gaJB5LzNAsc0pQr9oXJffXmdBRMta Ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afdbd5rw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 02:37:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17I2Uu3c191216;
        Wed, 18 Aug 2021 02:37:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by aserp3030.oracle.com with ESMTP id 3ae3vgmyjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 02:37:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxJqAZgQ3JokhMHuoKZB5VUFvMQMcmkFD0Qa5AYuxLG9P09LAyB8Ej/etZ4FAlBkVwmYqOOMH+kJiyoWr9ArATzMVMaQImgsW6vItQPbVRW8BAUnSsLP+3cdiAoom9K1fl5r85bYuUN5zMG/KjzzyVBV44WwEqAuwmv3GkM0h4cpRHQQ0uuRURBqdlT7eXYHp1nHOpMuve0sQ4fqAxnnRZ0xPR8KBy1AaYls51hOYavsh0cIUURsP1CL686e3fiAymB7lr9ePUnvg6y79FC+sSJ4Kw2dzR9Utb6gQPvYAVrnVOzVhDwQagIaGqpM/SCNrWNNI7C62wt0ICKVS4afnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdAo+d9ynx/JPfxZfvJdUa6lIOgvw6SUoaG6Vb89y0c=;
 b=fjW+sL2Wg31jNOy+dhejXvHZgb/CxPvXMOssIYFmZJsMzfJSiZh7r31mKAGmjCAZvScxIZxMffrwK9npksjNXZ+OKk7hIhrpK9YT3e1MaMoOm9Mkkqvh7lhCN266aUMdPWvzietmTTY4T20I7O5EB/qvmLnbGdaqlH4AsDg0Se4Y3TEWdyzbHUOcX1n05D/XUun7/ov9iyuH7M1tWEI2GIB7OwqGaBvyNikXz8Ob5Krwg1yc6Melqnfr2RFInJbNaXjXFmcW8CtYdJh5UrIxGgOn7kAV9VocxU0N40xVyA2olwp1o64xTIjdZ+ZdDJ5zjiR1mBI3ufyCFRIKyUV/7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdAo+d9ynx/JPfxZfvJdUa6lIOgvw6SUoaG6Vb89y0c=;
 b=L8diSLBOjHhKNuF9uodMUVabf8MoJiClwARG0V/gx9/NJD/vy63ABK/CnXLbCAd6BUuII8nsROrww2gTbT4UGRr+duX1szFhcF7pWk/lKx01Kd8SLaCbvzTG7bUd1UE3cFneST9lBItUDFWvIP7Q17p31jhzMuug7Bq2Nnidg+s=
Authentication-Results: hyperstone.com; dkim=none (message not signed)
 header.d=none;hyperstone.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Wed, 18 Aug
 2021 02:37:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 02:37:48 +0000
To:     Christian =?utf-8?Q?L=C3=B6hle?= <CLoehle@hyperstone.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Do not exit sd_spinup_disk quietly
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y28zlbpr.fsf@ca-mkp.ca.oracle.com>
References: <CWXP265MB26803209FD08A64222EEEA02C4FD9@CWXP265MB2680.GBRP265.PROD.OUTLOOK.COM>
Date:   Tue, 17 Aug 2021 22:37:45 -0400
In-Reply-To: <CWXP265MB26803209FD08A64222EEEA02C4FD9@CWXP265MB2680.GBRP265.PROD.OUTLOOK.COM>
        ("Christian =?utf-8?Q?L=C3=B6hle=22's?= message of "Mon, 16 Aug 2021
 09:37:51 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0085.namprd13.prod.outlook.com
 (2603:10b6:806:23::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0085.namprd13.prod.outlook.com (2603:10b6:806:23::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Wed, 18 Aug 2021 02:37:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd094c37-6295-45d5-2c01-08d961f12af6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4597001425EED518AC3D127C8EFF9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LW9rquJHh/Nn7s90fpGKHJs/oQUn4q1232N8UXgfZ5FsQeUSIc7hhvYtp6uIeYhQEVG62DPEkGYf19ta/gWmPOQZmZEBFN9mM0s5WeLq0DmPDfpSuH4pYjmF0DwtxgeqjODc2QSYYaP86/JA2QdfcrYNSvwVqT9JerBnFsYlNvhRgbbqYo/fLf7GpMREqOircEPibge11PmgEQ/8RocmS/bcyqeFcQq9q61L8JYvMrPdR1r0dgWO6W/Bs1hEl1bJc0oJiX/1CDd7GTbyNDTEeg9Z6m/Qjzb9wBkvubcvBEaZKWy1nV1Yhkoz27e55UPs7v1Qupru3aeuWN73fLMBGUPFItWcakBK6tBzSTb+oPA0ZXTxJJEOafaEvpl0/59LvlM4ZHO7HrjDCxRmDOm2uXRZMUAsRwnx8R+HdMYGi+dUMyXNyEY7TpwgKZigdzJjVbA62iD7qtqdFGABU6uMOzdFELsZlnvHpa0N8WfixuUNx4Jz6Urqv4l1K7br6zuvxifpTTd0THiqB6hTp2ztuYzOYY+Xm4VDJUHBcPx/PjFMpn0Vg9cq3ggeWXEikjyMrZ9nPt+SlcwGmnn0grB6gCUkrXozl7aa6pymCxvlMf9cTC41rrkPDmLG451SeOSzccL1eUSmUaxCcETevdUGS+KCGdKr83PpwUP/wcDMPXvd2fUzgik3wg7dk59rh44yPwc+J94lV0s728xhTSVXbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(66556008)(6666004)(55016002)(186003)(86362001)(8936002)(6916009)(5660300002)(4326008)(52116002)(7696005)(2906002)(36916002)(38100700002)(54906003)(38350700002)(316002)(26005)(66946007)(8676002)(956004)(107886003)(66476007)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bVqCXtI7uFFKzchYVL7XocRxOtRWhn5pG/XZiynFCi60CWP0vkUsg9eWlgGN?=
 =?us-ascii?Q?64EpmNLLPh00/UNfozrNRGsrTRIiOdbyn3/Dq05r8Vbq/uOUE6aYisqtbWR9?=
 =?us-ascii?Q?HNgiFjLm4IHgh3mjxjDea6W3gdHmCnzI4+kMaSoVrvw2sTP4sZj7Q9hARf7M?=
 =?us-ascii?Q?vZ718Vw4BqiEFzOa/9EwxSLRfLUtpzcXT6y3rC4VVgE1eZxXCJamvzlYucK3?=
 =?us-ascii?Q?YNDSpQpkZIjTTgQ3ETMYmklmb306xjgRpelCeb9la5ZSxlsyZ7rPjqovqMcv?=
 =?us-ascii?Q?T9fE9+jT/kYWUD+hY/8ekyLP5LpQQBwfNacZ++o2PzKR9E0LG9AOyQ8fIKSy?=
 =?us-ascii?Q?K04Cv6GS/8CzhMsFpiYl4aE5RBi9Vt+ZC3arI7X7aM8Pv8bznl5ME5Y8F2/z?=
 =?us-ascii?Q?9nfqgTbKdPRnSeiwFW7Wd+z+5uRMrvSoyC+vBina7PUTY9pP3SB0hckPcof/?=
 =?us-ascii?Q?HfdjR8kHxb9emRqRq4ScQdOHa9BfhYzPfjebjcPh5/6yul8fh9bEtXhZEJQV?=
 =?us-ascii?Q?qe31lPRAnXCXIMSRA+g2ooDssNByqKjwolxxQf4v9I1AOtlTSX1eGnNxTv3d?=
 =?us-ascii?Q?ULACY80y0ttHf2u6AJEgf2lNOKIAC1SGCzIrJN/v/roOem5+o3vw0GBwq3Zp?=
 =?us-ascii?Q?DEkFDaMJtUl4dXtQyjRjxxTrtk0FyOEPiH9/f/S5sY/V+h7/dCTygTwZZHam?=
 =?us-ascii?Q?M+iAH6inv5ztbRrBZvJSX+FGMb3QpF00Nh/aJV5+KOuVPApalYMvsE5o6dlx?=
 =?us-ascii?Q?b3QCW5SXOh/fmhMZTv/d3qRKGoDk0MJ5uy03V8iDFUntdA+8W+pRUNk8mi65?=
 =?us-ascii?Q?Zo03H6Y+rP6gvgFaHCryftKGqXH/UjizpvUia6pggzXmcACYo1LNW9s/O9SH?=
 =?us-ascii?Q?WbMtXOro94DW/TJvpHadOF23FigSC3BB2lhfYJQWsXno6wlECDaAcDiblomT?=
 =?us-ascii?Q?8i/O4Nn8inDRyNA1vTn/P+SD04fjkKNRRYAK1+BRKCSbsbOrxURhmSaRRKUh?=
 =?us-ascii?Q?/g5KhhWdl3c38wvYCUbXyQEHhpgCzFhV4PWCSXPjTw+bTDTtjwwMi4SiFE0+?=
 =?us-ascii?Q?CT7QWg8HTB6VodV8EYIp23w4pbuACO7Ef+N3Rt6d58xw/Qew402AwaL49wad?=
 =?us-ascii?Q?DdwSwliD3aalNDA/RZidcjXwFH0cGrWgUG0ha/Y7r6Uu2066qZWnflwn0rf9?=
 =?us-ascii?Q?Hjbbk8wUz+eEm+BqDQgW7lz27G7oA+3529mFpUyYGmGTZ5TeLDECi8rKB7aR?=
 =?us-ascii?Q?NAD1bo0W8GfzQ366naCL5eAun5KNOKe1oufhGSIqXRTEHiCciY5iGs3NS9kX?=
 =?us-ascii?Q?vhodoa1Zh2atyVZI3RIOb7jp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd094c37-6295-45d5-2c01-08d961f12af6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 02:37:48.7057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YnqcG8eteaKwjZhYXQ+a/Vg3gPTTkXfUZAGwFgkux6Hi9KztucPMfs4PCB44AT5MhBFsuwLYOG9Ugq6RcIOd6uu5geqyzi0WSz9d1m1EtHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180014
X-Proofpoint-ORIG-GUID: OsHIrDgwWBvXSS_r7gDjn6Bhq53_tu0E
X-Proofpoint-GUID: OsHIrDgwWBvXSS_r7gDjn6Bhq53_tu0E
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christian,

> The sd_spinup_disk function logs what is happening nicely.
> Unfortunately this output stops if the media was marked removed in the
> meantime. To prevent a puzzling output, add a print for this case,
> too.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
