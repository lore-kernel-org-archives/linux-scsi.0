Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FC3C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 02:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD63C61178
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 02:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhD0CxQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 22:53:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59100 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhD0CxP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 22:53:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R2nVIm050975;
        Tue, 27 Apr 2021 02:52:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=DCYbnLpgh1NBrms1zTLh1tKaBk8SGj+JlxfoQNYjQz8=;
 b=bIWTtpsIam6YFlYIAvTp77PYRhl/hni1tAL3H0oPYYLW4niinCXllsVM/54uyg1Wlrfb
 H3HJ8RRjSYBJBGahsCM7PuWd1/tQPDS/Giil3jdnB5X9z83Nc8ws4YVWufjasQ+b+woj
 zO/hc/3+Xc8eaMXXbsaHTcM1Iles00ShMUW6WO1QHnoZ/tk5nKCEfso6AI5hc+Qx0rn3
 /da7eKrC68wMAB7F0zWhp7ovv5jQ5t1b2vfwgiYdhkeYZEg5ZT7b5LYopiw0T2JmGvDk
 Gt0aghlF6CvxyNGrk+vPWx3EsANTkhdlAuHaldhJSHu5xW/07kjyT6gXlImhWV1hCIJi /Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 385afsuyc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 02:52:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R2oRHp115341;
        Tue, 27 Apr 2021 02:52:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3030.oracle.com with ESMTP id 3849ce2m4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 02:52:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OvHRPuyTb3pdiEYusfFhixXg7j9aC0zJuUzldymxdd6OlYMuYH6g3KoEjXG1v2/PVAyTJw5gMB6eTz80+ukaRYNkMH5IHR5Faf8jPFH44ZjNYZeFbf1wvvclQKH916mfZeZi16rw1R7tQC7yB+eJOYCusHbnNeZB5YR73zOkYdwHNjWcfjl7NSfw6hhSLkXXDFxFzCDZ5U2kVfamNfDGIuzZ32ZQ6lj/TvEodggZNl/FEuAzkNPI7KNIe1G6SKPPJi3G2MR6hSMb3qyFrsts8zKkTzwukBqyjaERZguKclycN/TuO7dIwYtjBUP3aQW5qlsk4TAHUmuA50O1BLLjNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DCYbnLpgh1NBrms1zTLh1tKaBk8SGj+JlxfoQNYjQz8=;
 b=kDFV4LYN9U1RIwNqtVNoCmPPUAPLaMtxpcb7lgNkWAYcngCMTz0eD2GAUUpDCRG/jOt5mvm6sozHylt5SiqMoSd1Leb1qfO4cAPoS6VFNOVnm4cu83bybzgI4uyDyUHkHUq6AZYj+2uSbvzkVB/zx9owxEG+Ts5Ku0jjKlIBaMhxmp3iqJZJiJMjhWhwtntGXGqxfICxFRRPw13H/AzvplU0ibl/HJ0lT2tLg1IyO2ENWDEEdl9j+oORe0CZZrnmII2I0EyI/KwWXSCZFqsd+fZ3+0sML6eOCfsi/KxOB1UEcfCig8W2VVLJuNeGEi3MmTov7So7ASaBv2hjMglKNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DCYbnLpgh1NBrms1zTLh1tKaBk8SGj+JlxfoQNYjQz8=;
 b=V51bMkhybsf9DPISxt/no7vkVLtktRQE33NHPy7T3RIAAf8yzM8Mo0pz6R6Vf3BsEWMl/5MudxzKuQIQ+3JJdhzYUAkWXEU8tagZWQRcM1devN/nLq+804f28IKEp/k89SijEuzLgG0Y+nxfBwccsJL4on4BYP2PAqt04fNVryA=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Tue, 27 Apr
 2021 02:52:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 02:52:25 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: remove redundant assignment to pointer
 temp_hdr
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czugo2w0.fsf@ca-mkp.ca.oracle.com>
References: <20210420104123.376420-1-colin.king@canonical.com>
Date:   Mon, 26 Apr 2021 22:52:22 -0400
In-Reply-To: <20210420104123.376420-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 20 Apr 2021 11:41:23 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:806:20::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR03CA0003.namprd03.prod.outlook.com (2603:10b6:806:20::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Tue, 27 Apr 2021 02:52:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 561dd2b4-36b4-4189-76d4-08d909277d11
X-MS-TrafficTypeDiagnostic: PH0PR10MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4439A6C4EEED6FEBE9DEFF978E419@PH0PR10MB4439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eo2xbifgypNUl1dtwdfupS3LRZPYt9Q8axqVP/eo8YkjxW2AKQsqafmu6PFaNcWJhoXgv8j/l02BThpNW47g+etR/Z98FkZROYDLr6YWyAZxPhHXnaOF0WFEqTZAApwc/3n/q1vW3pK39ylnYbQ7hNokMzX7T37I7cWsE+69242VUiKRubMg6pet4gEdcy84Gw8XYUy6SfGLwHbkI2K5yyuAIrJFh5i9VrJbvJ/SvMs5+ba9EW82EzBGsensUI4C52uAmxadOniisaNn8r6+7rV6+cpao6+aR6JVewAiYfjr4gE/FSFlLEPXQwZbqBRRKqZFvh+rn0Erv71N8oMNxznzHlK2xZmmgyDYDmlApJPcGwpcSY6MDual/Yw8/Z2Gb7Raahdjs2yOiAl8aQxxN25we6m8t8pOem36mDAUhGflkE4yNw7P2wIEnrXZWGjeJhycn7KwoaNuWNKypMR0b3jHzlO9dxyBbtwfNG3UU17pkOobiiPMmEGd8fqDht2HUVua1ZiGyiZSoH/yJQyt7JRUnLRpA2HEkTFHyQYxd2kaTyLc+Clesqui3hbfyhKzNvgSeCsbwKYSdqeb97jpRCcNCO2EfemXNqDJKi5EX9zpaA44teyrxL6fAbJ2LsLOEuMlXqLlNmOJ5yNNPOrP821vX38JLlUD6NafM/ptB50=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(2906002)(8936002)(4326008)(8676002)(86362001)(66476007)(36916002)(956004)(5660300002)(6916009)(66556008)(6666004)(186003)(16526019)(38100700002)(316002)(38350700002)(66946007)(26005)(55016002)(7696005)(478600001)(52116002)(54906003)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sZYpnSoozJI3RrVIwGpYwy0aP7m5rK3AGwJjB+k+r3/LfRibAofaWWetjF9Q?=
 =?us-ascii?Q?u201CiqqFgFz03txMo5JwrUKsh50bPEAqXWsK2kzsOjl48szy09PwJAQgcfP?=
 =?us-ascii?Q?mgRHmsk/MVItRAnEBmDDyUi3aQAkGajLM7qeGz0Hvm0iNa201OxtunwuFfDB?=
 =?us-ascii?Q?lgrGIpDrvcnJII1XzT+dSo/CruFOqTEHCI+gdXZKoQs8uvW3c1PphGbUd2/J?=
 =?us-ascii?Q?diTmTnNqBsUxjdL1HozyHNuzy6nZ6SERWEqJJhXd0o2QXZeaIllLiErXs87Z?=
 =?us-ascii?Q?Gf5IcuPkME059cARjqR7ThUvd2PlH5ZXlpswXY6zadRWawZtJGQbn4UG/anD?=
 =?us-ascii?Q?ngY2XQ+Fe6dflIhv7mDH7s8U7K0Mr8OH/M59hVBGKHdeuODFtqY+isQuCtW0?=
 =?us-ascii?Q?+jqBVDhQ/uHfx8PAuxsuVPL3sJ++gCcWrqY0a53yb/M1X0AA69fLJDC1nNty?=
 =?us-ascii?Q?zaT/IvxTLqTP8Rh2u1gnKVsC/IFObaLur8yMknWT74QJX2590+GyyAOrb9j7?=
 =?us-ascii?Q?LZdETukS1jblQiz1SBE3QI5PZ1CuOu8fQuRzsifFlb0hm1Uni7R2I3dK4a6E?=
 =?us-ascii?Q?aY5gqBo4jcHztbCsKSMrUfLvH5NEjTazzUvk5L4XtE0rHr1h6dklKk/diQg0?=
 =?us-ascii?Q?+MRDiq0o8f4Fu9evNTbsh8aHSFxDMx4cQF/k0/L6nEdf16Xml8UV7Ewxca7o?=
 =?us-ascii?Q?1kbuxW8wDnPqzW2M06eWuJxbAjA3YQyJWCAj9VuBgDp9kw5A0iIlVwD0ndbH?=
 =?us-ascii?Q?gg35giJU1iGAXiUMbkpbEMncFsYxzVt4SKf36REA4feX1XZRL+tEdMJivwoO?=
 =?us-ascii?Q?S4PR8CQXtx8q0HpfQMxfo955CnpGQ0XJw4rdiJNZom/UoZjIW2Exk//fwR+A?=
 =?us-ascii?Q?Lh4chsZwxDq8GUCbAMgIpzrLm372Tt+8l2VM/ueW/TPlT1f2wrJLeN8qVEW8?=
 =?us-ascii?Q?x6Fz51n+9wy3ZitAA1tOwg4WVkpqVMI9tMwU7ANyTPsgqJZsPGDdJlgM34U3?=
 =?us-ascii?Q?w34ZYpvMwXmGvrqJL97GJIiiLhz1WdAw+WoPkWQ7UcCVyet0mzcVPMqU28kK?=
 =?us-ascii?Q?+Yb0ZCm4vG7xpnn3X7123+2SybEZTTtEBTZTHn+qGOV+a7foR+aEAQZK3hfP?=
 =?us-ascii?Q?aLoc816AnPIUQHG9Tnxgk7LvHoaihCjgXJgU068P1w1HCq+kg3l9cxNq3EMw?=
 =?us-ascii?Q?EY6dMy+k1JaOlzkwu5jTdxsE61UnuBm3bi7Pwb8WjQqwKzHUju8WpaUyFo7G?=
 =?us-ascii?Q?VzpD3ZrE6gGbipgHLowCeYt7vxcaA+CnnXb41qiVT/mKNe6E26wfMUGaan+Y?=
 =?us-ascii?Q?v8xvXv7M9yz+aYB/4u2jMVFY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 561dd2b4-36b4-4189-76d4-08d909277d11
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 02:52:25.8099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lo9aC3y84BXJyfi6qHMsyUtxplDoG4NwVwLmKLeP0xbTqwh5v04qhyu/cGXXm+mlhSPAe+Rz82eE1CBkzlwtm3ZaR7k6JDqjx19emRkti8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270018
X-Proofpoint-GUID: XP_GHwz5M-Azl7ZuK9StyrxosYHVjju2
X-Proofpoint-ORIG-GUID: XP_GHwz5M-Azl7ZuK9StyrxosYHVjju2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The pointer tmp_hdr is being assigned a value that is never read, the
> assignment is redundant and can be removed.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
