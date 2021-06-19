Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC8E0C48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81F8061222
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhFSCnb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:43:31 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46400 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229816AbhFSCna (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:43:30 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2VwPZ017236;
        Sat, 19 Jun 2021 02:41:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=GmLj3+nfd9hBlmTRYP6pc/MnbNtBF4Wlps00poCUKuo=;
 b=YUC8GaJTw/JL6nX5HkOuvjX4MWvtqEHKMoIMl2yOI0AgW38CRJ/h/EgIT9NMo2i1OoDa
 llnwcTiSBuhzVy/9cEYV9kASkHRW8lqk9z+sefujbxkLE/VFcfl5WL9pvBrvzUgYY2Fd
 3TpsatA6sWzOz5acyUZdjQ/vxW0kp+1aUO9Cx6u+GDUbFqiGIVKzgV8gLgKrAoqIGxJm
 l9ucZ3meELB9zFcc5wzDap7bJ4CE1187xUJfOZ/tnBBzDjzzZVAk23IVQRzcU8/FwPns
 03H5U8AbKm/hfhZhhvDkc2LW7PqzUwywO+nUnb1eaEXgfsN/ylT7iAZEK8zvTXXFZ8RP qA== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3990488heq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:41:19 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15J2fIi6114426;
        Sat, 19 Jun 2021 02:41:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by userp3020.oracle.com with ESMTP id 3997wk062f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:41:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbIUVHSK+aVT5Sdjdf8NedFNcprJcnDBh9LnROb6mWKGBNDU1PeY+wYHEV618bCE0Trv1ZAnPyRpSigd14r0TSCV4PvOTCgc7EIqRCFKV1UCwQEUAhH51sxSMTcO2fGaP8+KSkKSBhUIvY0mhTKZyHi7tREqCDrRNfX/GhwYJh6lVCQiu1DP292kfUsu5UAke63SMsn5oIFTYx9AjC9kqWMxBIcGH/EotBz1/cwv+ZTgNiz/nzmciCMyPjfs1vdRaERZ4QEDfB8rl8z7MOHuHiuJ1r+DbYS44r8xGYzNkW7+FDRTzIyOwfuRSAJIbDk56vH6tb4MzE1X+ejzOUBfAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmLj3+nfd9hBlmTRYP6pc/MnbNtBF4Wlps00poCUKuo=;
 b=MoAodfLRoKzc3GJk6xR7t3ffe674yMZkUtcPAsQyiP47cRhicYKEtyKCBfAnATkOAJM1GoCOVNxdq3wbirfcCQH82QfE++Z0BY5ReN7qRQmL+RVLhyIlADhTl1/ysuwmfksQWcpPqpkPfAfGMgfzS3MFy3PPeVGCMdMnAGEEr7j6yIP11PEJUzMr2zLLNMv1gkHLCCsXS4NPy9Txf+aaMqV+r+xiBr2NtNJ3lklyQfNRAq9Xef78l2GYdtaX87C0sKZ7a37QJKEywescA0isE2wVH5q3FMFuayYH+NSxnURRE6Ln/qnba4CXudTAMq64dw81vsuP1t4d0V4jm6AfCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmLj3+nfd9hBlmTRYP6pc/MnbNtBF4Wlps00poCUKuo=;
 b=Y50d/lq2KOhXFXTgKp5Y+a3V7+ZHO6bT2eNOJAXtYOD3l3qegEJ4Id7if6LEre9ExKlFvU4mCRVs6p1ZaLQyunAWCQvLcXoAbI2lFhgVMl7ZxQCLPE8kr0CML35HqBzAeNX8U3LeXV8gWNZgRUVmlsv5xPlvT2BpCwDStWBvvks=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Sat, 19 Jun
 2021 02:41:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 02:41:15 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, ram.vegesna@broadcom.com,
        dan.carpenter@oracle.com
Subject: Re: [PATCH] elx: efct: fix pointer error checking in debugfs init
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2b6wp8c.fsf@ca-mkp.ca.oracle.com>
References: <20210618233004.83769-1-jsmart2021@gmail.com>
Date:   Fri, 18 Jun 2021 22:41:13 -0400
In-Reply-To: <20210618233004.83769-1-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 18 Jun 2021 16:30:04 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0280.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0280.namprd03.prod.outlook.com (2603:10b6:a03:39e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Sat, 19 Jun 2021 02:41:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 001bc93d-b200-4517-7fad-08d932cbb592
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45972BBF8062165AF86618218E0C9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4PmQ0NjfoYiA/D8itPup8/8HpAWJQgQU6BfiavXIjDAnBIhBsK7iDax/0Hk6No3yuZMgKmuQev+3NFlMvYqwIfUmq7KbHQr4MNMAV5hvBlS5XYerN+2UP2Q1loX5chDgVvGnzUyn2SyzJuqJLU2lyConhw5oLX04llA68s05pMLCSrxgUhhPMoDexjlYXcIWbdAROO8pzWtXSdZhh15ldY3j54sED+HUnY1M07ZA8nfkPINFpGVktfRKjP4icmgMXuDEM2x5z8onBTzF+34jJTrFfOPyV/t4kjQNlSaZ1OQbOxq2SkjRsd9bBFOIn/RMKpm1Kvl4PJfu4Gc0dNSSEBaNJwIQvxygeCdFKYC/DC93G0+PuDdfLkYGYUPbA+vg/9SpXqIP0+59IX+8H9ymrcufKWMJSxtg1/VdpkP+33bAja28YOi6oiK7VjjgH9nhZSwmPkiS4v0k3u1x4KtwOaIxMulDkV+gzvX+DAmJY71ct7MjVXnvKOdWrdo1fvUPFWBQOQH401o50muyi/C9mNOcQ+yL5T65LmUHy2JsZjS9uHUtzmk+T+4oA73cFD9vuwA86C6uIplJ/ce5Tiq5dZin1Z/ANGQphukSuj+Qjaxkp6sBgHT/57EmgoQpV1g/AJiTc/+MULyJOqhXQ0FxHvUYbYk9ZlYApEDBdJzronE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(136003)(346002)(558084003)(66476007)(8676002)(66556008)(66946007)(8936002)(26005)(107886003)(86362001)(36916002)(4326008)(7696005)(52116002)(55016002)(478600001)(6916009)(186003)(16526019)(956004)(316002)(38350700002)(5660300002)(38100700002)(2906002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nj/ixhEltcJMAhwB14zNgmR+gt0HnidWmbxVALOwl2qy974NJFdVbytoxonC?=
 =?us-ascii?Q?AGl6hbb2Aux4HD20R/l3/M4Y/9qHzOxJjB0yW9oJ20Hl7+nw0M3yf3tyYUGL?=
 =?us-ascii?Q?Quzb8XC/2YpO2m3HV0QRES4kpZdQNIAo44tS7fngv4uhtJtsfnMQLGSIFPvy?=
 =?us-ascii?Q?QITnEnaCNnjvqrl9PtNgy7aPglgPpqMtbVBiqlkHUC5Dp4bDFIsVnssgLhM/?=
 =?us-ascii?Q?1QcHCUpfpSZx203w9s0ueRuKs7/qG3cKfP/jvV+tTTQ60nNoxWvvnz+rPvHO?=
 =?us-ascii?Q?AaF2rfyXgPhVGoeaGvHBhe1HNSfda9GMczTGBsykpMlppZIIMjW5Brrlscog?=
 =?us-ascii?Q?dQBBpkrHxc2kdej2iFNHE4A2jBvWkp5H0sFMTR1I65ISlSNBChtLu6ygJ12Y?=
 =?us-ascii?Q?zdADv2f4ZD4XFt0PMb+uvqt0lOYjLZm648ysnDKao00a7jyz5wYkcb2x2kR5?=
 =?us-ascii?Q?kLSipVnClIeFJrVHEY6J7XBNnKdeLALmtzbPVEs8ZpTIRUZuRpgjy5hsO4Ws?=
 =?us-ascii?Q?ka4TpwlyqeyTEy0wBr4lnjBi0TeuhVR6BvGqUsfg285HmNUyzg/uNvaP4QD9?=
 =?us-ascii?Q?oK9y/z/RYfUxbTOIGxzmmSTdUBJmmIBNYKxB9T2OaMcEhXKVKBqAUXYI+xxg?=
 =?us-ascii?Q?c+kPxse0Gt4KGpWgBJ+JaLXJ1z0JtAHetpUWiVbNWbAq7Qm8R1d7M9SjG/8h?=
 =?us-ascii?Q?tE9vusiTqHlAVhrQP9oINHWP9z7h5XbOglT1K5Y4QvXZRgy7d8ZC/RRvfXYg?=
 =?us-ascii?Q?bRb8fDP7+Fts11pkHOZ6QKqV0u7qS8A7XcnEl8S2GTXL6gxq00Zxw6eK2v5H?=
 =?us-ascii?Q?RxbxT7JN5/lzcTUjOjL0hZWDAR5cEX0W7JuhR7DCCWoQbKIHABj2zx5R/hVY?=
 =?us-ascii?Q?F9EEOW+c4RcbRlQv0xk4uV10U96HjqIteHN1mPbSPaeSESdub6emzpeEDgOw?=
 =?us-ascii?Q?2zjDS69uN2iWU1P2/Vi9yY3UEUnCeTujXK77aNgYOfL7nWzs9RzvA1arxgLJ?=
 =?us-ascii?Q?yKvMc0I/hrLRf2HKe/Lb9qaCdwk9WIJAVFdeSs5IPB2WtqH0BOsXgZyCbJAs?=
 =?us-ascii?Q?HEmZwr8g1lpV+5katdVa3e4i8JX0/zl4+Pxd5y8NkigGE3uPW7wkGqX+K+yr?=
 =?us-ascii?Q?LnTnLZFCJM6R6eOjDf+apanFBTZkRm+prKC1GhVW7zITVBjBOneZooHHnq9y?=
 =?us-ascii?Q?pTV0N67b9D7F5ddqLbfZJkJtpCqmZX4MubvqwkvRz3sRXf+aHuO+hpFnkmWh?=
 =?us-ascii?Q?FEXjnHh+Vny3kK1Tjaz8B3M3t6eXK5EzYFr2kzYO8phyJY+EAwt+bRi9V5SW?=
 =?us-ascii?Q?II4R/EDMB4UX68ZJhpXx2jy8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 001bc93d-b200-4517-7fad-08d932cbb592
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:41:15.7235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9/IeI5ZmJvzplW3y5fAPrueJmgv9p7sw6sSaH8Sw+FtlhgKs6d4m06ryaaUSx8KbS5PGV29IIf3/cqhBrdYZ8mLNZ3q4OIC14mnpbDfuLzQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106190011
X-Proofpoint-ORIG-GUID: 4OSRzaYjl5_qrohgk4Hf98K2PnP7qjTh
X-Proofpoint-GUID: 4OSRzaYjl5_qrohgk4Hf98K2PnP7qjTh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> debugfs_create_xxx routines, which return pointers, are being checked
> for error by looking for NULL values. The routines may return
> pointer-munged -Exxx codes, so they should be using IS_ERR() to adapt.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
