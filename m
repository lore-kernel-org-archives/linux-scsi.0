Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89158C49361
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 638EE611CE
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhFSC0u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:26:50 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36378 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231305AbhFSC0t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:26:49 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2Bx8I021565;
        Sat, 19 Jun 2021 02:24:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=vhvybDnfQpgoWLo1Aw519za+yXacMtds0Ij1RwryHLE=;
 b=pN9kRJdi1TTKOKGnx27cPlxK8XIf/f+j2gxavBcLGcSh9DwQqt2MIZKc4b9qvwXlGAvS
 COHzczR6K8WWDn1cj5pmPhGuDqoZWaL4fc5ummF2np/NUoYKCgywUrpPgG1KXWgWwPiG
 CASs+u8uwIoWuLWVY+Z3EoX19cbPfKpt1b8yHCY1qqDrbR6TqDCZ4MBg+1vJDlILUsgd
 Va+MDDrRceEw1CuV6rdVdSeHcyEOG8zT9BRXT8ih9+8pkfb09nGgBflR+h15u7gRWyQt
 18cBV+dTbpegpWhnicHwC94pO5HjViAS+rGZt0/HbTIfOBMfoS8zkam2xS7xnNSnJt2j FA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3997c180hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:24:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J2FPJe181516;
        Sat, 19 Jun 2021 02:24:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3030.oracle.com with ESMTP id 3996ma1d5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:24:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkvIWtdR1iwIoxbUHBTd1GgJJFO6Ec0VH4hxE1urEJcMJDe6y+qOhpSwC6QaninqqqWZ8IsE5TcqZu+WFZ1ZPUgj5VSYvHPRUJNUoOqLT0ayvqmdduTORcxMTcAMG0UxPQWsm6kQ6tm99eUsYmx/DtVAYWl1hwX+f6EyBqCSb96c2CYmMaeTC13plp+vu9dbpiNtc9sdZPiuSu1PUABf7B2WExtiLSVrjxPeDu59U4Y00mJHRbJFEofoIU2Q/i5nKFC11Ef/Dlt7IXIl0fCYsjBcHfnvy4o3Bn4DKhHstfBHn5uxADgMBNGuB2iAJ+MoEY6j8SEM57cLI2zasu4OfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhvybDnfQpgoWLo1Aw519za+yXacMtds0Ij1RwryHLE=;
 b=KtVZNeOIVi6BJUhrISoctRl7cLkMX/XIqpNSpd4MnWR9tIwYi61pzsZlQCZOoDHKmqtSC9IpStjjjKyIodfl8FzB+vx5zrH4tb9T69RmszG28qEczALIoYYqPa0F/flSqRQEUmuxWCKeBrdncv4aMpFNJTavroT3JrnpXaTDT1wjDfKjlaxMAb+sEzqoycgmGg2J2fKUMqSL5m+QCpmCCVu6YusnkR3VgU+D7yba3O3VWfl/oPgw4yy1p0yWQPbl34s59WI0R7+Y/8hwLafpl+RxXlKnlWFuCkN2LL6GoPYBpQ0WMdPnSjgjThM0TP5zk8QzFx6+0UO9KPcDgnytaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhvybDnfQpgoWLo1Aw519za+yXacMtds0Ij1RwryHLE=;
 b=b0NA3Fhptd2wSXS1yarcDiMZE1HmNIEB2w1tvgXItZmOpAwPUhVPlNdoqlU06PzMOUoCE8K04W3IK3cJQ4Qts++JKCLJqR5GqPM+FNp9XnmVjlIh8FaD5028YUjQaZjWY3Q+OFPqJ3HZFKJAbnkz+Gua8LYXW7KRJs0NcpHyA5g=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (20.182.136.88) by
 MWHPR10MB1485.namprd10.prod.outlook.com (10.169.234.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.18; Sat, 19 Jun 2021 02:24:32 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.021; Sat, 19 Jun 2021
 02:24:32 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: elx: efct: remove redundant initialization
 of variable lun
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0mqzj58.fsf@ca-mkp.ca.oracle.com>
References: <20210616171621.16176-1-colin.king@canonical.com>
Date:   Fri, 18 Jun 2021 22:24:27 -0400
In-Reply-To: <20210616171621.16176-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 16 Jun 2021 18:16:21 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN2PR01CA0007.prod.exchangelabs.com (2603:10b6:804:2::17)
 To CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN2PR01CA0007.prod.exchangelabs.com (2603:10b6:804:2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Sat, 19 Jun 2021 02:24:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86e98d81-8572-4fc4-6fdd-08d932c95f55
X-MS-TrafficTypeDiagnostic: MWHPR10MB1485:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB148555157DD556E94BA794E08E0C9@MWHPR10MB1485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s3tMoRfqPfSM6/SYAEqQS3XBxY5v4IaKNr2Sosh2r5CDShkNyEDttZCmsbx8FKSNVKbLxGLcM9woYVoZctBIjOr3IYf5vTz0N903+LXUA0FeqphXjzFeqshefo5YCPKpWGAs8XEaFZqeMOhKFU7VCPxj9BWvnkKjEpBjBfXEjpAIz0qSp61tMosdNXm7BsDt2MAW7Avso3xe0jR5WYkr+szCDf4YOZJ9uJ/S7xs/PPKF9iA6KmZ2+cBD/IDOWIGh0GqWK1QKnKKRlOzn1gJHhkEG4LffyIVWeHK62YBcvE/3fFgu34Ygq6z6fi05AJLOoyQIM5Kh2kKxj/4qaETQ3LS8Oh44KTBeTdr/3b7PWhNOF3tBxVVvQr+UhAlKAsQkN075x95sZ7d8/yXxTi6GPYuNcDvq7rPcPnn7rpIlJYOrFPYgz2dcVNYRtK5GLTPjdvcL9gcvewkM2Hw/6w/GGnRxiU+t5Xk5Li3ot/vMm5DT+654WVdTPI7tKQ4oaIL3BtUtLAf3KT6xoI+tNn69C8iHXvj0bfBgAeXg9DjpuKRhs08b3mosNSW+EIGGLBAnl6Z25hJh/vAgTBnBcN7hYKxsXgAmsCw7DdaWGa7KGDEQBiPzPgFNOz7oZaDnkcnQ6ZEAsTF5eqQTiHBKjzTb8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(396003)(39860400002)(66556008)(8936002)(54906003)(478600001)(6666004)(66476007)(66946007)(956004)(86362001)(8676002)(4326008)(55016002)(7696005)(38350700002)(38100700002)(36916002)(52116002)(5660300002)(316002)(558084003)(2906002)(6916009)(26005)(186003)(83380400001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2FnH5UDzwBbi4WNtu5g/BMknmTlalwgQwdPZfSSd4OueyAoYlaUKhF7ii38P?=
 =?us-ascii?Q?Q0E92uLoow81SVCir7P8yqKG9m436ZKO525eotsBZFBMGkvMa3vQYgh+Aefw?=
 =?us-ascii?Q?4FBwFQHVUxmIb0JQdv2M1pQU2voDdFVXumQ6ekwoUilYuw5fDngGy9d8tWUf?=
 =?us-ascii?Q?gCfXdSh/JF2wwfRxyXntdhKvDFX8bhiCngob/gWK6APpB0qVqAJemsZrK26Z?=
 =?us-ascii?Q?/GLb5N/cCLGqqpKCvZRFp9gd8cPQvikcBsKgN2YJee//AaTy+Ty5rKyPsAXM?=
 =?us-ascii?Q?3+IjtwXh8/bze3ZsnTCM7kdSc82NP/EX0c3ubutN9vJOQg7hKFgIkK9MhL2y?=
 =?us-ascii?Q?R4uq34Z9WgSwwKH1uy3dmIQM4ObN07Gl1kuG+9IHsepwskc0Q6ptAkhYJqn5?=
 =?us-ascii?Q?sOEQ0OBAdUjBKT263wE1W7xYizmKSBBJL5uAJh9lIXw0JOsVGqygs8aUnBuz?=
 =?us-ascii?Q?Tz556q74+hS3BO16mHzwqbNqRxIUIqdfAf0EYgzmzHNmlNoNCoZvnXcIao9e?=
 =?us-ascii?Q?IbPaS0AFCbkOn1sGPewpgpO6nQ5LKXeN5hjfyHm56gTATKtRilc/w1pRkz+c?=
 =?us-ascii?Q?G6Gg6d1rtcjq8n9Res9BWeDaGCJDQAyzsg2W5mP6vuOe/nl2SHq3HoN8wnhX?=
 =?us-ascii?Q?T1bPQnAxGI8LNrDzkK120trzAN141udNA/NGmAQLXY5sZe+Bc615/CbYEZen?=
 =?us-ascii?Q?JUaVhagwJKJ7tC1Sa997khdgEsxIFUiapWHGZINWXnb9XUni/xSRIknAyKsk?=
 =?us-ascii?Q?LgqbFVCa95eOFwu3pswu2p7Rm6FL9DYpAN5ombKv42TxD2EdwI3vvIKae9Y/?=
 =?us-ascii?Q?gg1VyPBFLVpv3h8G8jiGGhC7T8nzMJZfyhgSqylG2b9/h8na4pE7r8Pdo6yL?=
 =?us-ascii?Q?CXAaqs2T8zcJUdaZYVA89JK+65wICxDE+DQ/K0Ppj/NrS4Tuuop8WiOqY9fB?=
 =?us-ascii?Q?w7T9i1XYlp+BBDQk92zE3nFWk5XFKFAFMFE5/SKjipGEv66cO4Geb4bHs7qP?=
 =?us-ascii?Q?1FeJPwR5r255HC5uZqwrGXhAakn5zMffENEYnw4RHKfxyo+u97GOCtfweFzb?=
 =?us-ascii?Q?ovVuUMxgV+3mA/czwV6fLDxj1KMbwDd8bMo1tuq2JjLjJQFItr+tw0sJ1LgM?=
 =?us-ascii?Q?8yl+z2U0JO2RJdbbUzM7e+eTRYciE+mbrvmWb4QhYqFP8+zQiV+jWDyg29a8?=
 =?us-ascii?Q?983EWWhFlMPYFzgfXqn4Yx54w3BPt9npBpusWDGGKyFiE6QWxth522GeXlBd?=
 =?us-ascii?Q?pjgrS+CR+YCAIQ9Lx1ypzcRp6b7PkqpI22Eyt3ZYUfIcu8EdZ6NZot7zZCi4?=
 =?us-ascii?Q?EiLlrS50C7/EpjfjuAQ1KCGv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86e98d81-8572-4fc4-6fdd-08d932c95f55
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:24:31.9781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9L5l/Ye4AI82zm3Z7x2teo2lfmBV6qffLhEZiSXU46VLQ1nUzhvXfn3TXgvEOUXb8fBP0BhrrRHk0bZMSFyU8R0VwRj3ZSzGFm5qAR32UcA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190010
X-Proofpoint-ORIG-GUID: S6_SOLEBFwlV1r_ljiw7hBkJ3QhEpIw-
X-Proofpoint-GUID: S6_SOLEBFwlV1r_ljiw7hBkJ3QhEpIw-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The variable lun is being initialized with a value that is never read,
> it is being updated later on. The assignment is redundant and can be
> removed.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
