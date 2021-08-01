Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998D4C4338F
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Aug 2021 17:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C6E761029
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Aug 2021 17:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhHARj5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Aug 2021 13:39:57 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:57786 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229548AbhHARj5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Aug 2021 13:39:57 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 171HW4G1019441;
        Sun, 1 Aug 2021 17:39:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=dd79v9XoOIe9PYiM/6ORTM6YMW6u9YDMovDXlEHpJIs=;
 b=TluHyX4V9cdq0h0sliaGo5bJ/oGSVJUK+S5B0raP3sjVSjrSM9V9oHGsYKhOV7S6OJYf
 Kiz1UJoCgwfYjyJvOMboRIwu/088UUXwforawQWVjtongv483GPd2gThAB6nB52/kY1L
 wuOJv8ESLg3rAsIL+jOvi7sQ8koRLRpgHnoaf37khNNdsAfhPNsvvoaD0BA8MJCzWWxe
 XP9WEcgDOrEDTWTf4Jv3mKehir/MoYs5MpKKM4HDf5+fSpcE5x57Px2gSPlKbQYI6Ex9
 wLuylmguoDwfLRWqj3epoAdd+yDISpPvOhBe32KLdVDkORonlVmsUeg9YrWdeBS73+nL Zw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=dd79v9XoOIe9PYiM/6ORTM6YMW6u9YDMovDXlEHpJIs=;
 b=TPlEZorbJvS6zwYBiMDlicudK01Paf4eocCUtc3JMfsAIqwD+MloJZngNNiylj0etc4C
 A52POze+ffb9hnendk+ZtIZGkQDYaBencOxv3Cvr/jSFqXYcNY+fxYVfitrhsQ/juwI0
 Cl3RrqVgaPHcx+gwSvWyXxTU6dNug3yWNJOwB+ro8MhW6qUC4bovacgJm/ct8z2EA3Un
 Tl4cJt00OgVLSsY7Z2mqHPGbfT89EJVoHI6rKoxG+Dpcwfq5fMNAy42Wlm6VTQbQ6bzQ
 zySk1pkn59dODvU44b3eJ9DyhIOEWbTgdALLNANSPQCA16XKbejfqNThQTMWLKDdV+2A Dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a4y2s9nht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Aug 2021 17:39:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 171HZlIM008565;
        Sun, 1 Aug 2021 17:39:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3020.oracle.com with ESMTP id 3a4xb3pfhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Aug 2021 17:39:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBdvJ1oSHdw9yghJ6Fm5EfSGCVhWYhr172X0PeLedi6aFgEl/5TTx4hkcvrQN/hqy7pj+RLEAeiiQBQGx5OLT9nFHyRNCCZdfOVm6jJGQ3cZ+s7heu24g/uCY3xmk8MYuNR3g5BLZKbppjLg+38vf0jJ2ZTRTw9hDW0E3CPhsr9zv7bIuqgvLL7Ox/lemFz6xhbpa2UrDEunOHZ9sdIAaHFMNNCFAf0yuOCt66vFKewjYrVicMT6hqOJHDofV6fC3XsScDIzbVrrB1u00V0d8kbP+w+r7Hb6rbd90DKtmdOwfh81CPwQ8SlAMquihlGP1Ccca5JkD8VoUc7Bdk7ySQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dd79v9XoOIe9PYiM/6ORTM6YMW6u9YDMovDXlEHpJIs=;
 b=BCUjdiBTzt75DYCuCIoEo+R5hM5kL539469bsIEn0qKUrBdNSXUkmV+tVaeTOm9hohBWU2smnWjGrzbJZKaLUJ5SHqX9DKTZojOCnWURHREXvBtVY3TY5dghzv53iU4TcQy6elj4cuH24E9BKo0C+m2bjWkTTZOJbtrujbiWVMFfwju0T5yvHIdAlBQ9YwXydxR2IPLosdhj6cyPs3zEZqF2C7ZaYvOoB6jazV6ygw2mv8fIZptuInZsQda5FFitF/atFY4zVFel8R6yvqMC3zYa347W2j2J8XNB3I7khYNMU6b+hgCXhiXKHBRTt3EbRwnAwhp9PwS+ePIzcQVrfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dd79v9XoOIe9PYiM/6ORTM6YMW6u9YDMovDXlEHpJIs=;
 b=g7QLgiRzrmVyLhYX2lHZjH7izprIrYl6tNzD2nMxUyZWr97y3eywmyyvbk9THSARA1WAaGvVj6YJ7qW7eI32jiQHyxtO/rPJR7N4YvTd23bTOXIZe9QU2Mt62tw0uAfrTKbC7989yDTyyX48FySbJgyMOjt+osLj/i5M8QgyNH0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5418.namprd10.prod.outlook.com (2603:10b6:510:e5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Sun, 1 Aug
 2021 17:39:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Sun, 1 Aug 2021
 17:39:43 +0000
To:     Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc:     njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, lukas.bulwahn@gmail.com
Subject: Re: [PATCH] scsi: qla4xxx: convert uses of __constant_cpu_to_<foo>
 to cpu_to_<foo>
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsvtkqsv.fsf@ca-mkp.ca.oracle.com>
References: <20210716112852.24598-1-dwaipayanray1@gmail.com>
Date:   Sun, 01 Aug 2021 13:39:40 -0400
In-Reply-To: <20210716112852.24598-1-dwaipayanray1@gmail.com> (Dwaipayan Ray's
        message of "Fri, 16 Jul 2021 16:58:52 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:806:20::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR03CA0002.namprd03.prod.outlook.com (2603:10b6:806:20::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend Transport; Sun, 1 Aug 2021 17:39:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19789f15-2042-43b8-0a41-08d9551358cd
X-MS-TrafficTypeDiagnostic: PH0PR10MB5418:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB541859B49825E0FBA03C72468EEE9@PH0PR10MB5418.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ua/qMh9iubKweoatM9MLtWMEj3f1/sWQ+5RBDGViqjtfFs6K1aYRORjSpBqKACKcZ9e0pmH7/B8SXJnopDiRmsgoQCGGqdufWBX8FEmUiVO9eMhv7Ro04ytN4rK7WNIg11ZHeiW4GTYkoE81iIab3ZQa4xeWCAAEPS2Gp5BcKKxwgTHKmIdVYrYHsflyzI+UEW5SywuIwFUqNf5m5G7t4gHf9dvjiID3Nw6UCLJlmQkCk7qZgiE2+M9u+4CNnUzZoD+S+vZl0C/0ozgKgkGJyoSOZcg5v/yA4mqpVXyHUbs/w6FzgN+n/cbhAthqEcAmc6c4R1KD2oHmtgstoFF42pQGdmny3/RlVfLx8AGv/Q5ppf4Y0HAMs8N7g6I2OP99Ox4t2gxKmcPK3SkXY5vm3pbmC82Zl7ZtFbJM9j6Hy9vTKbhFcx1uRJ6LsuB+iTeDc0WxN3N2cvhD4EpK1SWehY6flnFrAW80wm7qd9T1qVfdtZEiPmjPaJXg6U3ME/Oxgy0cTMmNdIQ1ieq3r6zD3sLYnCsOZrVLeqSr8sNutPmJPn6WXERuq/ieYTqZkEjyIbIR6yVWmPrA49PB97+2Cy8CbFcKBYsGDMmNRXU1QfwQknOjVen8x914TYHBz220wGXFt4nQPSs9auXmQ2yiqkH3le6Kpaoxvgg7YKPOb6lpTB11X2R0XwDkf0jKSQAmka3RPJ66IJUJUty9Ok9WL6xUTtFDxrDgmHevE88qZeQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(376002)(366004)(39860400002)(558084003)(55016002)(956004)(66946007)(2906002)(86362001)(478600001)(66556008)(66476007)(316002)(4326008)(5660300002)(7696005)(8936002)(8676002)(6916009)(186003)(36916002)(52116002)(26005)(38350700002)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X0LJ3WYhz0aRSXZdt8Lao8EM0L1gcYAAaDHjtJw5JsLddHQolnOQFA55nUgH?=
 =?us-ascii?Q?DZYpCbjtfC2FtP8+K9f4wBTCipZa60dni5QQ45P/cseysxYZHuvCA6n+Q26r?=
 =?us-ascii?Q?xglziPRafX6aT+d77diQ68MgGFdo5+sQ565awe+Tb606S93Y17RzO400h808?=
 =?us-ascii?Q?Zm6NoMJn1TaAetkTmzxFhBdwiygGeHD/IfINJIc3AuA7RO/pICkwfgjHWww5?=
 =?us-ascii?Q?xzXrF0HF5yrppaVpDl+eGNCfsWFHefZKaCZle41ZtRPHJfVLJYh+bnsBMvrc?=
 =?us-ascii?Q?E4h+tb2HOkw5/V4mYCWLY67BczY9z2ch6BjgdxuA7J6X4751PlvQg/cfh+EO?=
 =?us-ascii?Q?rUAC2uw8UWcUxPynl9wzJfguSXghKguCFHkaQzRU8til4/P/kYEQmrVVgrW3?=
 =?us-ascii?Q?KsLduB2yjZ2uyBsiYSAGFU7UjBupQaZ+qanE7RDteXaE/EPl6QFs8LncrAkc?=
 =?us-ascii?Q?Ns6qtujtQS4FD2blgzoeyF9npyUUXaGXVXCziR/8FDpbQwGSGyOX1X/9hHND?=
 =?us-ascii?Q?rysXYhTnd1QKGKvkYAGJ0432cQskVGNegywga8jHTOYhoFdERd7s8iOD7748?=
 =?us-ascii?Q?iNrwIOry3sC5/Y1Q/XDSiNR1hvwO7fb8UuUN/icRI1Fch/wYdH6VEX8xh7VN?=
 =?us-ascii?Q?Su8OCtRVeYyzKaXmmHL1zzgJN3XrxORE0Ijp/9CFjaPPthu7niDDz5UT0os3?=
 =?us-ascii?Q?Hag1iqNLoC+39l5trkTkk6gYNX03nqUf7oLGRiEpI45kjij8lgAq6JZ6/NJO?=
 =?us-ascii?Q?nb48ghOgEzqMNy9J+3LvVBfjDIOspV+0het3bztGtFH4o5wzHSjitPrlIO+M?=
 =?us-ascii?Q?gDV/6PQ6HWjAOEj0ASY2dYvmbWyS7o2Zh0d9gFG4EkyeeOcxeezAbBVZJ0ak?=
 =?us-ascii?Q?no74mpqCoWHqaTLhL+gtwGSG9hXz45REmlWinBgIv3gLX5VixNAypTrZWSHQ?=
 =?us-ascii?Q?yYX5JHllGLCpUgGZxL2UOxPEONSKA+chFBlHn9qr2Qp7aPK/F4Kr51Lv56yd?=
 =?us-ascii?Q?8oht/1Q6HpeSPcN/b/TO10tP9XXPeq63j/mDoKA4SARI+JF99N7Oe1XfJBeE?=
 =?us-ascii?Q?9b87GdvliPLHwkObyWgD6YsdH1nYS+O8Q4xoeZRXvlrezU7uiUQp8MBSC7fI?=
 =?us-ascii?Q?5ZOTTI4oTCUvCET6vgjJ4pdQKdtKditiMV2xEACOJcnE5qpnzf0iet9un6iQ?=
 =?us-ascii?Q?U6m/hAcOZI99f2D3ewY63M9NYXj354UtFzPpbg8vXcXC2fS4+UImc+dAigw6?=
 =?us-ascii?Q?6ANCRzCrxmV5oZSSNvwuaRXN2oi9VLndOKIV5QlwALQdzstz9GAHhx14QMeQ?=
 =?us-ascii?Q?3l7RoExVjKr4IHkVyOaK3q0p?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19789f15-2042-43b8-0a41-08d9551358cd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2021 17:39:43.3342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r9quqtERkyVm0805ZN0aPeTa+gBkkpaxDiYZJgq/+toIHHsdlfXHcPer+Ws4XJMgGs792iQA9F5eFRyjZTRuGdOEztESylxouQZY+ETjMrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5418
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10062 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=837 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108010126
X-Proofpoint-ORIG-GUID: 59VU8P6E7TVuYZRy03fB1Btt4ssyp00O
X-Proofpoint-GUID: 59VU8P6E7TVuYZRy03fB1Btt4ssyp00O
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dwaipayan,

> The macros cpu_to_le16 and cpu_to_le32 has special cases for
> constants.  So their __constant_<foo> versions are not required.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
