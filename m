Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25E9C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 03:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240371AbiCHDRU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 22:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiCHDRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 22:17:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4611DFF4;
        Mon,  7 Mar 2022 19:16:23 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2282HvBV009309;
        Tue, 8 Mar 2022 03:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tNUXFy+gjWvor2le2w0QQK0ZIDJl1DZplUCv/K0Gq3M=;
 b=uNJfeLKniXoXGNm5KfDtEmDlahrKqNLeIBnneaPn0uXlr4XeyjkVs86zboGAwxEa696K
 1kjtj+qRKp4MhNsZf50oIFZZA4LluhQeQazSzS3CUg5U4r26jra7WihvyaVMEagP3jhG
 CXANpeu2roCpL6MjOY79lC/tde+IoV1LDHUMj5FTjc2B0zm2XyiNqIsuRYoTEWyXLIee
 Re8EN+97Vo0m1Moa0oiB15cjR+rBTevtiGlfVS45Y6MudJplhMJgnkP1ANio9ra4LiVJ
 MZEHI3qtK1MzhZrOhMdpgPwZ4mjy3uaHs4AnQxav8Ym0yyS9CJDtOYefF0zEtuybKexG Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cdnnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:16:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2283B1XE179847;
        Tue, 8 Mar 2022 03:16:17 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3020.oracle.com with ESMTP id 3envvjtts0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:16:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFLMoItjPhJRJxHUwpnfZcX8dQPq26eCYhCxpBe5kDqvn5vHx7rnu8BMa7ArjaPo9izH6x9FV61ezLHjvrf5gAKXG3SyUF6kgUzUIEDzddoy90aMeUrVzuD9KxzK+G2GRaxIeKbLbjiRPC3K22MfNEnkogbM35JBP5QQ1//4LzkmIRhPMhPClIMCyN6OCK26gFE6TaTkLNIS56dv+G7B9z8Uw8tU8Cgv7wQvokAoUwNIeou+IgcwENdK1CMlG7a0lDwlVtIeKhn9JrqKFaqxGu89WR/sNc27/MQZAqoS4C4skznMJlc1gTfeBusP2wfr6soECEJjOsbcY7dBFHrvXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tNUXFy+gjWvor2le2w0QQK0ZIDJl1DZplUCv/K0Gq3M=;
 b=YMVKvIX375a5dkc7aldz2Ts6hNPVeMgK6yDh4BQVf2TrO4lQ+4aw2mVQFU5pizIoGCyuCzN+8gYaZSiKCFe81vm1qWnqdpyQAYhWoUeNT/OhtUgtmMEub1m74pInUYWvUtthag8ED9UEOrZi9iR/ygg9Si1Ul1bGMliNbmSym1Q+3kC/G5Nw4mPVBP3TEFHy92xxoE7B6qB81/vR6TtHtauZaEnBkL+ujbgCZz7M9/NoujLXI2NMM2YJlTGaAEYE9jXuB9gZlZvQ4T46C8bDlfEGacIhi880aErKy/N8ZQzY+6omB/e1bFUyDsejPNixH996nQKd3z7O2hyttMvcIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNUXFy+gjWvor2le2w0QQK0ZIDJl1DZplUCv/K0Gq3M=;
 b=N8w5aIkV1aq3r6mQxla+hEb9T2/86VQ1icngD9IyHRnnasVrYS7uzc8PY3+f28uuzDCMzLbL7mRwkzZTYUky70vrw6w6n8FiispZgRabcn7hndUljzeCMcBK6VMw11dKW+S5xShwm6TNNCq3vHhpqnJodDNu5aYAVBMgbco5F9Y=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CO6PR10MB5586.namprd10.prod.outlook.com (2603:10b6:303:145::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Tue, 8 Mar
 2022 03:16:14 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d%3]) with mapi id 15.20.5038.026; Tue, 8 Mar 2022
 03:16:14 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 03/14] scsi: don't use disk->private_data to find the
 scsi_driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135jtqgm2.fsf@ca-mkp.ca.oracle.com>
References: <20220304160331.399757-1-hch@lst.de>
        <20220304160331.399757-4-hch@lst.de>
Date:   Mon, 07 Mar 2022 22:16:12 -0500
In-Reply-To: <20220304160331.399757-4-hch@lst.de> (Christoph Hellwig's message
        of "Fri, 4 Mar 2022 17:03:20 +0100")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0020.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::33) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cb64721-a639-448e-6c8e-08da00b200ce
X-MS-TrafficTypeDiagnostic: CO6PR10MB5586:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5586883F5E017875C52FABF68E099@CO6PR10MB5586.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nIcVQXlNKGUHZZj5dGIeWTalkLsn2e5Akyo+L62BmkjOfjJmPxyp0KuhKQhrLpJdpGuQWRQKhaoq2iplSg3nF/2wSEUm4pRw8RsQGzq4V78TCD95EnMbcRQhA4c5o7SMTgu1Ji2tPfPnd3N3LTELedVq+Xk48ZoqBfykWirUGERS61k6bRq+y1vKPBskrFc8HDgRoV9yJ3yiwkY1bmPTWbJF7BIu9xKld0jPcCG0jUTfc/4kHOZ/5oHznphnIT+ShcGZuHW9WLYVHyy65Uylkyq6WmBnZjzxxd5jvagxkvASOcbar5H3GiZ0Y0w6losomdug9PBb+ZMOgxW6+vy35MoyMLHVdmQr0uLl8QyEJWHvwlRzB/PCkKPxB6ejQZTZKyxaEdNMBNqbRESru7jcSM7sP+/S0bPXUA39TZSQxa0fdgLT4VadnpvCRuUygRSHD6SoWIds/WR0dL4whekZrraNxwUU5lJWMVdeswgGFcStKvg83D7z3cOFYFVMGZZe6ZFajgws2aQYuDMACYGSYvAhWEqOPTVxNvpaPmmn6hpztzVnqPi5yAtXu0USMfpJmxhAZuS5V9fd0RK9ibIXMYTwMWgCC2eEOR1wXZkxIBre7ivLmvwLjUPHTlr1kT5moEkoncZPd1FlWKYPlaz8PGFx882zftsVzHT+ifpXq9QTw2ckM0JVcdBgrIsVw8qf7wBHzaB1SgbSV9g2xwscW0aVDf3IcL+0yNG4LUHmBCA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(4326008)(8676002)(316002)(6916009)(54906003)(5660300002)(66556008)(66476007)(38100700002)(66946007)(38350700002)(8936002)(508600001)(4744005)(6486002)(2906002)(36916002)(6512007)(6506007)(52116002)(26005)(186003)(37363002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S0RTS4r3tqK1RNZlq+b07tAeYtPfmvkvc/0aRbau71Vdtk9asfm01Td8LM69?=
 =?us-ascii?Q?x+KEVlKVKxwJ60+J7JcM99SBig/K+aHUes36+ZWSI6166xuKcvtISdhD8GdZ?=
 =?us-ascii?Q?XyBcg+dCKP7o7eRTo+aR46RQxG507qp2b53+XRF+lTR+HYQUrqrJqfOSbe0P?=
 =?us-ascii?Q?WlT2rPXhlyKTCJKEhfYjzC1tueQHSRBxLBR9doBeWmHlOHeXUCZtlKeWBPNl?=
 =?us-ascii?Q?TP1QxBqsta4/7Q0OklrBEXY1XNhIfIjrMKv+Te/IgPv32he3FQckWlmYbB2O?=
 =?us-ascii?Q?EdMcx6lBfhncc7LnVc4HZCcIsSMN+KzZg37i6xtH1nl1cBSxypXXeZJAp2+8?=
 =?us-ascii?Q?O/zt+u6+TkWjdS/e52Q1OBoMojbFSJAzQYCVGxepr7ytFznWEs6jx9LuVsKU?=
 =?us-ascii?Q?cKZV7r5G+HuJfGgQWMb2FOdey+nP9zM3OCC4hTqJb/j7ylQKQ8z5/vLYTD6o?=
 =?us-ascii?Q?c2veY1hGiOhV2RG+3raTprZQtq5Xqsnz7/C5jbDrrg5I324JIkEw6rSLotrY?=
 =?us-ascii?Q?DZgFyzeNef0YQXG8YKgwAUEOU/mBJNPI2uUJEeUDER+gj34GaM5jJAjxpA6H?=
 =?us-ascii?Q?LXEaHIsIA77PYXMz/ge85qpQuXoiUsD40c7pNWeqwqRSV2dCvH6St2WV1t1m?=
 =?us-ascii?Q?f8KyquFaaYApnBAvpuDnd6W15DsgFSBLwCLe1O2gT7MjvE0g4cnfKgwH+15l?=
 =?us-ascii?Q?7B20JZ/H6QepXjzJHaP7zutby85EJ+H28Xk3OGr/YsQIpO7ebCf/ij/oiPnV?=
 =?us-ascii?Q?S+4EQhXh/O7yf0V5yoWAAscs/2yI6qnlWQQFnunwbkkNL3xF0ne8YaD+w1qq?=
 =?us-ascii?Q?hPQw4HQBLNL0w6qL5REeIxQCTlxe4Z4TW17Zxlu2IAdNSmSoWgsFVTTjNw+d?=
 =?us-ascii?Q?n+/P6jLaVvvaGDsBzFDIQqVr3CC00sbGXT5N4B3AFnrA70saSdngtENV0Eg4?=
 =?us-ascii?Q?jyNO1ew1QjO3r7PeuUYHys9h5Ju2d2xT6WnsRhH0T+ck1g2XQ+7mECQZHAJ/?=
 =?us-ascii?Q?vSEdgmDT4huqZdTxpJdzxmgUddNxSwHbsaE1YzVbYQXb60Gznt1bK6YWEnw9?=
 =?us-ascii?Q?NFwN+fGLbsgKfo6KVb57QD+CbzEIpTmZKr4EqJ+E46sfwDfG4/yJozp3uM1o?=
 =?us-ascii?Q?diuheB9DaZN5kLD5+StyjoCKiIDe294B9Wy+8YCLH+8EFFLRDgr5idPzhREp?=
 =?us-ascii?Q?GCq9RDJ6WfIJpKSPP8L976AwC91Iy/Am6OaveweJjqnVax3JC7MiPsFjHmL4?=
 =?us-ascii?Q?jNarGzYwpMYbx7TIV3iFjf3QVkUsJR3pyXx5QrW4ZqfXbzSRAHP0dttlf2bJ?=
 =?us-ascii?Q?gq2rIO3Gdb6za6SwhfYR8d/LX9O0MTSZSWKuR0UZBWmANb1q4UPvXX5avW2W?=
 =?us-ascii?Q?Z0JxB53y1RDLFsf0mm8EHWNped4VX0qs8haekdFtDbbHWuwlrVN4QF1k8Hye?=
 =?us-ascii?Q?+6XKUeQOSd0zidGpMoT5KEccKITdA/yEJ2mL3oDJFRTmn5saq8/mpiwiHpdx?=
 =?us-ascii?Q?KcxyL2WrbN01HxYRhAVrlcc6IOW1lHYlBmMYJpC7jd6TZJ+0VXd/ZRMVylKv?=
 =?us-ascii?Q?jN/a5q7haHvDXuF6HaogT3EVyKIFLt2W+3T5FakJsQFYejIoBrOLHdgG1bq4?=
 =?us-ascii?Q?xRUFKyIvoLQbbNwouiHnmjh4FczWBs0JKwt+7MLLWmU6UASEffChntREyRl/?=
 =?us-ascii?Q?KQmWmA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb64721-a639-448e-6c8e-08da00b200ce
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 03:16:14.5146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXLfcgcnlJ7hJyod+3rG3oep2QINPeV6SfAlKu/oQXBq+OvRlRVyG4dv+phPJUFF5nOByKrI3uvwaEazLJQkgqsLiRAz2P8zOG1hZo2B1yw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5586
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=974 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080006
X-Proofpoint-ORIG-GUID: 8zlnD0Cqssha__NMxZX1Uw1WySY6TSiy
X-Proofpoint-GUID: 8zlnD0Cqssha__NMxZX1Uw1WySY6TSiy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Requiring every ULP to have the scsi_drive as first member of the
> private data is rather fragile and not necessary anyway.  Just use
> the driver hanging off the SCSI device instead.

Looks fine.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
