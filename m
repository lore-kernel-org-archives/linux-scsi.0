Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB9EC43381
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1F4B64DCF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhBWD3g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:29:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45474 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbhBWD3c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 22:29:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3B3rI140178;
        Tue, 23 Feb 2021 03:28:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=L1cH/L1/8AbrJOUIR5OKxjoTKGxRhew8a2aBRw+goiA=;
 b=hK/bEmDWR3lVx3Mf2UTnYeCah5Wn7YfRCGnLxPbsvqdmwfsu2upBJ7s+kXfjlH4u/qHH
 KZEOgiyH9ZQFIXIyYzWWzh5ZxNnPbbKSjv7IcjutVVh3IYbUG+3isSy6EsS5YWzTOIr/
 J2q8cvAUaLnXsNVWxiXw30mP0NjmODzPj8Aa0vMpj1+tOINbLuzHBLNON04baY1Z45uw
 cZq9Bl5YtOY9A3OFRUK6fZ5JpU+Y/Nym6ErhPEh4wU/9e1ZO0yHfbcei90dnWxmMZd9e
 S/SAclHMcNdf7a6CfC5Z/1+2ABF/rW244XtaG5vv++gY6RNxXN6ujSFAqNvQ0gzjAmaf /A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36tsuqwshn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:28:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3QIOj106866;
        Tue, 23 Feb 2021 03:28:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 36uc6r5hu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:28:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEb1Hhr/lopcx72e0GX9P0B1V+CsRYLlWpvk9oug7zRQ0pP32U+QP2I1WXmAEsrcK/+HVMuGR5pVDSgJV0nQSqj9TtmIRSiR+u2I2BKwOFvpDDrPNRw0c0++aGSYdqaIzip50hieA/LUFg6RpgqJrnS8jF+4DZMyhY3d35dlqGTSc8nW9B1xfhyLfluXRTZzvvz/wZJ0Hjn+YKzZCxUWIEUgNjDpBScx1gaDLM7/ONm4986sM2mfHwESBbKNi2X+k7FDrmJQUjb+2Rbt6BytTmy+52pDZQX37lEJmwuOPoawIpk1ZS7kjuKxwfo08eoN73HwgItumpMiZh6/uy9UcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1cH/L1/8AbrJOUIR5OKxjoTKGxRhew8a2aBRw+goiA=;
 b=Em/AIr/+5nSzw/0lIoJZjT431IGpYvZQagH4TL53v3t8tbQJbqRJ7YYMpim/hLotaw+iDqtJzgGr1AdPnQwiuQKCXk/3ft7kwJ/SJURTo7QeENMidM5JWrk8snu0zuF4WTAt/aFnU4Re5rXGODy04ej3Had1pNZ1xw0Bi8cH6llRkdeDkhxjChP1Ie+tS6HJX/+Kt5HnN1JRsRuzRnEa6oDWTQTwV2YDsqzWWkF8hSFaCvtUTqxWeBdkyeoHclYZhpCgrJVISJ7EHzYd7BNuwJcdy48sL80rLQPJ/C4+mqanPhOh1ieNVfL/JaO1d3lNuxKwPu9pxGTpFDJ2DZShEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1cH/L1/8AbrJOUIR5OKxjoTKGxRhew8a2aBRw+goiA=;
 b=rm4/h42VlCFj/zvHBqn4jADKXyb41f3SmVMr7/rPkNRPobRM+l2aiy8rqjoV1ZvADmJAyKA6MJ5usx6TK5duGhQk44HFk6wS6Ah9QGbRbdzMSigNL7TX4r33uhsbifOdbk5lT/mE0C6aSGQ1NZsfHWav1YGnXBUD/vC1qPnqxE4=
Authentication-Results: 163.com; dkim=none (message not signed)
 header.d=none;163.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4471.namprd10.prod.outlook.com (2603:10b6:510:38::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Tue, 23 Feb
 2021 03:28:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 03:28:13 +0000
To:     Chen Lin <chen45464546@163.com>
Cc:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Lin <chen.lin5@zte.com.cn>
Subject: Re: [PATCH] scsi: aic7xxx: Remove unused function pointer typedef
 ahc_bus_suspend/resume_t
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v9ajfoos.fsf@ca-mkp.ca.oracle.com>
References: <1613389249-3409-1-git-send-email-chen45464546@163.com>
Date:   Mon, 22 Feb 2021 22:28:10 -0500
In-Reply-To: <1613389249-3409-1-git-send-email-chen45464546@163.com> (Chen
        Lin's message of "Mon, 15 Feb 2021 19:40:49 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CY4PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:903:33::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CY4PR03CA0018.namprd03.prod.outlook.com (2603:10b6:903:33::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 03:28:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b9a1203-4805-4abc-806e-08d8d7ab0d2c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44715CF9F5F658AC0AC37D618E809@PH0PR10MB4471.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j82Psgl1/y4BVA5wb6ZQQhOCT/2Cj7PT5RUh7EysBKaKCR5zJ2Fi6jts9CCLNXp+kyGJtka8wH4kUs74Pc58fjwSvr4DC3ANhTIbIwV4SZWRPIpP+2Tcpgs6BsZq6/81Q3jpQwtREDPuHTvGYLO7M+FCsh6SwI7Vh1Uqvf8LtrUd0BFHYSNTa9q0xw3/05QyBi97SBRDsJrAQS4dk8WMD4KtUZIC2r4QPTfrgdS5TRyL2VrC9NTzbcca2CEHE+YUmDdpcOaBK95I2596czAl2OWC9UGkidbrWKyJAAStycnSFNCRxcvT4UeNvMFSTQQJSApQ3WbKzIPBGhg6cU7v0dfWouDUBMLxH5zVKYcCkSXyVo5W5VcQzk020FgSV0QSH/l6/k5aLsHUu849AOiPJHQq5Yb8huHQuDaxtP/JSb4dUIwwTeegeT9giAmWSpzbmIZc8+T52wUGTUSyhSdJWcHaPHZO5ZYNTAZZqTvTKVGE8WBKEVV8ooxtlvjBdbW8fhHEKtA2pOcTfI9xkaY3lQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(346002)(396003)(376002)(6916009)(7696005)(478600001)(16526019)(956004)(8936002)(36916002)(2906002)(52116002)(66476007)(66556008)(66946007)(5660300002)(86362001)(558084003)(26005)(8676002)(83380400001)(4326008)(186003)(55016002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?r3YfEhl3Y1wO6LBYQ8LgUGuDkDvbuGz2gFOP6isPJdu6p/McpM8si365g+4m?=
 =?us-ascii?Q?SeAtNJKD8tjV3WKDFjQN3l2UUESWlWEY8RbE+avfdR/BPd45djcZABs7TO3u?=
 =?us-ascii?Q?1NyCqYxm/M+xiyDJYTm3Ehy6uAtEr2209p3yhChQMuA8wVciIr5v+U1JaTAL?=
 =?us-ascii?Q?GyVecZxSr71lbo98FQ0CmVwOPBgSHZbihxUFlvKhEx6hQ2c5kt8x/tCQphrT?=
 =?us-ascii?Q?NDgLmLhbbq6TX/iMzSyz7ITKgFCNOlk9B0QImrhMvfL2faTt5gK8ZvSdsvzg?=
 =?us-ascii?Q?SDHMjdebaJRZeFzfqdntXRvPyt5YYlV2haamj5mOr7P93SUY5WGvFepu+Pqu?=
 =?us-ascii?Q?zqg7ViKjD7cMwTsgkXL9arFsv+FLLuv6TPDgbwxq43ODrXdDJhtLS4Eul4ka?=
 =?us-ascii?Q?/1G7c+jfcdIzRMWE72P8R7qr+qvqKLI5tG3ZcTejMi+ClTnsG4ksF2lEVCVE?=
 =?us-ascii?Q?Ex5LBYu0MGJF1tYFT7MXrzC5trxadpaE2nkCgrXDlksJnRVJxso1eDElFf/z?=
 =?us-ascii?Q?UDb+PwCWFhXr+K9vylkZVfcZWGptIjXkPT8b+GjNEU8KfqjvkuCtR4tUpEf9?=
 =?us-ascii?Q?Gch8YfunouixPXBRjBF0XyjNmtAMvM/Pw7t3P40ci6pDacBIriwHQjmGwqrQ?=
 =?us-ascii?Q?NYC9tfLmWN8WmpfQ1+3u0nz1h8clSQTxY7RwI/64Vq+BoS+VlQgOFbY3HFUG?=
 =?us-ascii?Q?ZyqlS6v0yWybHYJ+dBnOICDNucSeSjjkr9dAMFD1OwcxTxwJ3/yybIX64ezN?=
 =?us-ascii?Q?dAxnfIthR6xE/iK8/a+oYa+yf26ejNuqFjLMudnfMLnDut2+QZFJuNTkyO9m?=
 =?us-ascii?Q?wq64VQ6f3YL68AelTPfx0Or7GgbvZZg/NCOHT0bmM41dZZ2xFLvLQ5Ck3504?=
 =?us-ascii?Q?qm6xWtpMZ1IzOkEZunC7Cul06V7Ahmklxf1YD3XxuCIrCwXY2I0Tn/5m2mMj?=
 =?us-ascii?Q?mVoHeCPIVUY3mflW+1ua72qJrXOwwSPdllNyCs3gL+Y/IkRzCqzQ0tW/hS4m?=
 =?us-ascii?Q?kXbpllHdN4IiVZ8D0PJyeCXlAgXOCmTy6JWtd2lY2J4k/M9kkC9DRN0MYFkD?=
 =?us-ascii?Q?pbO0lbuCNMBZIRPuhZJYpi1E5QnABGE0pk58JI8iNPSUTknr8vWo5BUUR9Yt?=
 =?us-ascii?Q?VqZWgwOOQs2xz39IXpR6AAH3i5hmzJDzDx7jETk9B7BQN0fJtAZ++INLXlnm?=
 =?us-ascii?Q?jgW6gms25hsAlv6wZjMK57TJmZq30eiG6w0VVt8j70NzbYPWgwsxaB4c6hx6?=
 =?us-ascii?Q?UQ7FABXvyfCPuHYx4JvgL728842fwpd1yOGQNNpzRovrKw6/GtsnsU/YDW0c?=
 =?us-ascii?Q?wamS3M7E/HotNHi8b8uhoGV1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b9a1203-4805-4abc-806e-08d8d7ab0d2c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 03:28:13.4529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DjXX9nKhn4rmwdSCO14SPZUFZM275Ndyks29FPaR80NI6TCJBKWEP2aovxdfka5KZCl8KcV7sK9lXgbqMvpbcxtffBEriWn6D7b3afGZV+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4471
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chen,

> Remove the 'ahc_bus_suspend/resume_t' typedef as it is not used.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
