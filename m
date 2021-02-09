Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67402C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 03:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AD2164E66
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 03:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhBIDKG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 22:10:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58044 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhBIDIm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 22:08:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191LOMP014096;
        Tue, 9 Feb 2021 03:07:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=G2EG707Y4sWT6XsHGobQkfwIMpnEWwjUtQRd+G71el0=;
 b=Jqm9uzuMJHGc7SbAiFBYIw7NcAedu8kmf2OXhE3pS++Qx58nco0FxB9LRjPJF3bSqwY2
 lTLdf1Fwj+hMBF+jmDc90JLhL15rCZzJqkLUD/9MejORdz55TuXyGdFTlqmtv+srvNNX
 AEMoQ926kTCSze1a+pM5O83YBI1cwRAue7zkvNe/BKWLxCQ/xOIMDcbwbcVyLmQSK5kq
 RFxiM/Xy9o9auSDsyV245I2NC7RNFsK4tN/Xo6iqJZD644fSit4d6pmo5w8VDXI3VZcb
 U+NKL/r5kMEUM2644tRpLQ/4z8i8US7c20clVMubWyKuk0mHkiW8mxEVY4nwtT1RHgaP iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36hk2ke2t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 03:07:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191Lanu008996;
        Tue, 9 Feb 2021 03:07:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3020.oracle.com with ESMTP id 36j510m7a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 03:07:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnqigQU1YOj2AAfTbiWU3Yq6M3olGtAazl+A7DxFzixTgBvpryccZBKSVgtYN4cBZz6inbG/ElM1Gr/Mf4Ip7QmQNGpZYMNYYk32W1ElaaZHxdF/ssZZlM8RmuKcHISmov1jkYn6U7LSubXYTCA7ixLwO8BCFqGWe7u7mhYQKD8R1J8P8Gk+dgf4O6ZWtMc3xZekbkqv8T8Gj0clDOa8UCEi4kKzf4g+s/X+6ZefRZwuKV3HMmua0u11Yp1L9TYN3gEtGHKKF6HvuoXDqUREyC9q/VSRWOz/SSx8BA77ChZSgLiwU88yuqV2RAXt4/TCLUTdZdbnQPM7ePeisTkH8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2EG707Y4sWT6XsHGobQkfwIMpnEWwjUtQRd+G71el0=;
 b=R9dMyPYXdmWQAkUpCQg1frLwl+EJdkk3bvuRMZ+sz5wjibn3iLW2Ee66OGRL7x6nKcOENihj8MWufAJ2zJOSEi90FJKEz+73ozj2UUoj0JkiMM7ZUWSztUY/wijjq7k+pVOx5Gm7yOmd1qxBLKudMlxG1obY4dYF7zUi6ZA4lVa6aFxfYexm8ui83fhvmvi9NYRrREo8RokM47lg2khDO8C8+Y+lAF4bNNFqxNULdzNqt5WHImuqxk++GQ3097H0Z+DsFT12XsSI3+Fdh9gjTnG/o5BfGSIa+ybJDe8XfnAzI9IGhw0WbBny4LCu/cxh8Ridv4ZX1ztt/9sduF8SWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2EG707Y4sWT6XsHGobQkfwIMpnEWwjUtQRd+G71el0=;
 b=jD1uckOwCz4gmjmSxjFhN0vpjtExpB5jxr6/uK8O90baN85Ng0LR/25gxbrBe+KGLH4XOGTZZawNni/pkmFZORN+g9XMbHKY6yXyH3lYs+F2WBhXYrX+Cpf7JeV9QXEpj/iPsuQrYqYmmOJDbFTSVlmSUgPK0Bwq78lpzCk5F/c=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4630.namprd10.prod.outlook.com (2603:10b6:510:33::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Tue, 9 Feb
 2021 03:07:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 03:07:41 +0000
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com, brking@us.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: remove unneeded semicolon
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6serlc5.fsf@ca-mkp.ca.oracle.com>
References: <1612316911-69531-1-git-send-email-yang.lee@linux.alibaba.com>
Date:   Mon, 08 Feb 2021 22:07:39 -0500
In-Reply-To: <1612316911-69531-1-git-send-email-yang.lee@linux.alibaba.com>
        (Yang Li's message of "Wed, 3 Feb 2021 09:48:31 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:a03:254::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR05CA0011.namprd05.prod.outlook.com (2603:10b6:a03:254::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.10 via Frontend Transport; Tue, 9 Feb 2021 03:07:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f013a68-87a4-4bc0-6e5b-08d8cca7dd10
X-MS-TrafficTypeDiagnostic: PH0PR10MB4630:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46304836D21FB208035C526F8E8E9@PH0PR10MB4630.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fDgZcDyRpIICTciRzapowTwplPUUkvyGVO8jEm+x+bBMjIv8knOQGrKM247Lnxm5Oiw4AG/6euEde63/yrQAEw03aoCJ1aV02Q+Pjve9ljUnXZkp5PTKhH9gkojiqR+a+3LV+OyncV/rKfu2LDnlRZrtXF5nJYUNMpPieGqowwF87HQOLbaABI/KmfsUTAHd7wG8ccyRmzHKkbiGXpfplbK9YACyOGAlSv2SbEHKg43XqSCnnUHr3o3qalXJ7rlKQzox2pJYxBvdasWa4D9ulGj3f5mCgaKPqT0Nl6DOYDDY+5JOq1DToy9KpG8k//bZrC+jQVT3IQ/m5sXiFIDQQCYMBzPx1EH6Zsy0K99K2zATqHoVsG+M9kL+edFp+CIyMIyO2LGaZ28nByOrjyW6Xm8UFpOx7I1BVPjTzKIqdHf0rEJrESr+ccIj3oupXJAVR3FQRXmbnxUIgQQXmElFaqoyMshN+G+7ilMByY24fGERfuToM51vAXd9Vgg9d3+1NhcMigy7lCK5jzWiYtkYYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(346002)(376002)(136003)(8936002)(26005)(186003)(4326008)(6916009)(16526019)(4744005)(86362001)(956004)(66946007)(5660300002)(36916002)(7696005)(478600001)(52116002)(8676002)(2906002)(55016002)(316002)(66476007)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HmJX88Y2I+XzHEduFn27Xxovc/x5qn7eNRpl6oW+HGQref4Wyv2gL1EoH5P4?=
 =?us-ascii?Q?nzqo4g5k4CF8Ntq7kmu7xZNMPYeUS9RuZy/ekvCC7t72wftwreXI9pgUygit?=
 =?us-ascii?Q?m6GDPABFiExkWNzygC1t0D5/z0+eBQMEcrI6X5QGb/7Gbjix/jNo9M+9AP+u?=
 =?us-ascii?Q?P4unQ9etdb7RobykxA17BLVmXvqdaMMhrBFlywrCn/yLdR9PhnYFwNGhYc5J?=
 =?us-ascii?Q?xK8A9jV7JI7+VhgrLQi2jaUTbitCf8RmgDSqbsCKEwZCtTuyZ8xLj2Wt0DJK?=
 =?us-ascii?Q?oIbCpNIf6+272456dCqMsZO7Mb7Se03/Q1gB2iY36y6ZhraWry1Rx1TpXbhu?=
 =?us-ascii?Q?nkFD3uGunvX8yOhO09D0OL8XKH3sxoiTVlw5iuvz6tHy+D4cV93TOoN0lCKS?=
 =?us-ascii?Q?u83tIh8vyeM4MZuEuzoypeGfJ3uOkyCPcOpQqFrP1ZnVVSVfQQiB/RjYR0el?=
 =?us-ascii?Q?PGBaQybrEJdnQz9kpCUYzZQm4S/Jf4FAGrXGoVmiA6zx0B8YWqV+LACOr4rW?=
 =?us-ascii?Q?D5DUuywJKPhVkcyqonU0u+Dy3ztt2sNwz+g0LPgKMFJ2DT6QPCVRT+EwUj3Y?=
 =?us-ascii?Q?zItHRFTiyLC4zy9YsCnYz5z1HHs8i1civSrDQLlusmecvdDCC1lydlILqEp2?=
 =?us-ascii?Q?nVHmeGnY2bSJhPMc2lIyXoU4Xnr2oE71Dp/dVigLM0mzFGCJCQiRZcEuqONe?=
 =?us-ascii?Q?N2ZDX/MH6BhNt1fBtQ92IBiEV61wR5iXlcfX2s9XZde2tfSBlt0JHv9+qR+k?=
 =?us-ascii?Q?IsKnKK4NcsExVJN/cQZH18EkdEDwDeQWIPpXSmpq3sREd2Y4eNIKo9+1JIN9?=
 =?us-ascii?Q?5uT/hEkiGfA8fhGT9eXGUCY+0WQUKctXCmYiyTwjwFrzYHUTRaRPpsQ72G0C?=
 =?us-ascii?Q?jKrC1EmP42BdfmXUlazM+5vtWzhkVzlJbAemUd0ceHcxf4lQrlaDmlqhlTCY?=
 =?us-ascii?Q?VyG/R1rTeDTw8EdNbM1sk2H4jAkz+N5cbSiCLyIx7mbXCtUdzoBXHcNPlT1Z?=
 =?us-ascii?Q?TDuvNBgyL/cnRBxPYiYsXYS2rQKxlvX6tWMWAmCjm5OULYgUYCsg4UaRZX/E?=
 =?us-ascii?Q?bZOiCATWePfJZcT4QKg37Nh8bmTK+PuQKgjTs4/F/+rL7FfZhP/aKet1HKzM?=
 =?us-ascii?Q?Y06k30pjJNgmd/vXhv+Tm7ijvUpYWkqDkr4+bedY9tqOLOi7AgcHBd4uHjHM?=
 =?us-ascii?Q?+hUnjY3gNxwuQ+6ldCuuPhvSshmGYWuoy4xrZWwMM5g/5/xn6beze9svt8g2?=
 =?us-ascii?Q?Fv4pC5SGRd9hSGudTIWp4Z4YJCK/Y4vSgcp0F7XX7KKJdD674WCelVEWSAGW?=
 =?us-ascii?Q?nBF17LzrdTxlKMS6B+o/kzoM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f013a68-87a4-4bc0-6e5b-08d8cca7dd10
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 03:07:41.4327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgurPH7O/V/5+9jTGlc0p1qqOu9tALf43JXGVF3dPmE/EhbNvtNSra5tlu+UMvH9UQuzIGnq1MVqxQ7hAxr8GnHiUquEUOOjxpi5vkybyU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4630
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090002
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1011 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090002
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hello Yang,

> Eliminate the following coccicheck warning:
> ./drivers/scsi/qlogicpti.c:1153:3-4: Unneeded semicolon
> ./drivers/scsi/pmcraid.c:5090:2-3: Unneeded semicolon
> ./drivers/scsi/ipr.h:1979:2-3: Unneeded semicolon
> ./drivers/scsi/aha1542.c:287:2-3: Unneeded semicolon
> ./drivers/scsi/aha1542.c:327:3-4: Unneeded semicolon
> ./drivers/scsi/aha1542.c:389:2-3: Unneeded semicolon
> ./drivers/scsi/aha1542.c:487:3-4: Unneeded semicolon
> ./drivers/scsi/aha1542.c:498:2-3: Unneeded semicolon
> ./drivers/scsi/aha1542.c:533:2-3: Unneeded semicolon
> ./drivers/scsi/aha1542.c:548:2-3: Unneeded semicolon
> ./drivers/scsi/aha1542.c:575:2-3: Unneeded semicolon
> ./drivers/scsi/aha1542.c:598:2-3: Unneeded semicolon
> ./drivers/scsi/aha1542.c:631:2-3: Unneeded semicolon
> ./drivers/scsi/aha1542.c:649:2-3: Unneeded semicolon
> ./drivers/scsi/aha1542.c:667:2-3: Unneeded semicolon

One patch per driver, please.

-- 
Martin K. Petersen	Oracle Linux Engineering
