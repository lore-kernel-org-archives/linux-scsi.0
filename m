Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D449AC47083
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC5B5613D0
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhFBDpZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 23:45:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:33756 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229625AbhFBDpY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 23:45:24 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1523gEOn012892;
        Wed, 2 Jun 2021 03:43:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=oFuI0685qpKGtWj51MUd05gUyCVW0z2zHQJV5sw27LM=;
 b=sTPrOl8mDe/l6rcizzZR6JIJ8BPgv59eECOIuHXaP6zxrIcL4V4UltsbCLwCZYeJnelr
 T9KfrdSYMbcrnOPLOLpkovbVn7xxu4QIUWAvra53t42xFQBbYxLyL/nkm1AxnOfN0Vw3
 2N1BTYp9XTNoLs2PsE7Ews1mfIDUhKB7u6x7xQ24wVrhvhWhb168aT5rPfdFPhv6UDZp
 /6YfwWW+p5o9DRFCxvnsDHxiNUcSLXHKTIxymv2POYxKRYyc2SMkdt6K8IzuibsRF3w/
 0Nm84IHXDm+vFjeQG18tycxUlfG0qUkh2TpxNArSB0mSdnWgdB7hrVMy9p9v8p+Js1Gx ng== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 38vtymgs41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 03:43:19 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 1523hI2r042320;
        Wed, 2 Jun 2021 03:43:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3020.oracle.com with ESMTP id 38x1bch70x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 03:43:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQ9kM3TNkaiuUhCxeu9Is2kN/vWW00ZpE6NHBwNCwum9ma9bIOrfBOBgaEXbhliXB5c3deNCKFJve3jmnYK35V/n7n7v/58XczfFbGAS7ZPbq/biLtSAW4bt/FzHjGrai6b0osfT50daXSE+bRLWCw7MVR6RNrNopjHWCq/NIO6DgUtI3ZCLHAODzEVJkN2wxgcMC+oQY66VQujx6hHc5/9FFx9ZoPvh1e8cKLrQ2darsV303lx0b7nEv9+FK55h+m2qoWykpf9bmEFNpcMv8Rxt0V1uDiswceLWElHOo0B5qz2vqjDSQ1mKGo7aD/BuJtKwKILeAmBUjN9OED2IFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFuI0685qpKGtWj51MUd05gUyCVW0z2zHQJV5sw27LM=;
 b=BJ2NuLp4xXz/cmNjKllcyh/4Eh+UnTM5EYTl2OePY8En9BHsIblpzlxZxvbJRxCKBGMWwBkYc1hEU5fI646RKN+0lPcBgcPOzoPULDO+tGDBuDLp7h3yiIgALo2fln1umLpcBvPKPXc/6fLlwxUnrTm7JoHQBCVpLytZ+VL1zjAbLta2l0nl42eX8k1xqif+pitHg9uqAFAl3OpWpBleZoc77UKeiqH9ih6PDY1G1CNgo+wnKA+8tI/ru5TdggarUU9d75LYjbUE1BMlqA3f9s/MmGattG57bUwV+clRgmvK0OwlHrIXRm7x1es7+ECZ0N6kHTdcTV+k62nvqgqeEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFuI0685qpKGtWj51MUd05gUyCVW0z2zHQJV5sw27LM=;
 b=ZidkA34snrlQEze9Qv6TFMlHuRRmhwF1DBoYji0gcUhaFzPnl9cdwbyPoMJHHQpjADw8WuhIPUajuHk0CMSIvcSS4t3zqPgwii3aeYKrolPD6z0PEcqW9yfyd1f7r28AbVbJjBNMR4HNTtsecCi8VZA/V9t8SZ2sdA7TLy6KTcg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4695.namprd10.prod.outlook.com (2603:10b6:510:3f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 03:43:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 03:43:16 +0000
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, cang@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Fix a kernel-doc related formatting issue
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s3torsm.fsf@ca-mkp.ca.oracle.com>
References: <20210531163122.451375-1-huobean@gmail.com>
Date:   Tue, 01 Jun 2021 23:43:12 -0400
In-Reply-To: <20210531163122.451375-1-huobean@gmail.com> (Bean Huo's message
        of "Mon, 31 May 2021 18:31:22 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN6PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:805:de::40) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR05CA0027.namprd05.prod.outlook.com (2603:10b6:805:de::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11 via Frontend Transport; Wed, 2 Jun 2021 03:43:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f58b2dcc-3b70-4246-3795-08d925788e15
X-MS-TrafficTypeDiagnostic: PH0PR10MB4695:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB469579948DCB606B732198918E3D9@PH0PR10MB4695.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r7k1kNe/5gYUJjDqmUIchUm58BHL4FxBkEN7xih5WCc3JdN9CG46wIv6Dtatz6UZcnZ3W8YNZCwzn5C+R8HOAX0KrwDqxZChQ6DhlzHZl/qvW33z6WtD4KCXwIlLJ6uFvAvFygWhvNp/QiMP8dWPfp2kS4NmDlUSE/XWEdhdFZVb2oeLDcm8KwL6899GqwVRKE+HVYqEpsCxpVt43nhtyNYgaKO8zjBkamdg/wZQigBl+PYeY0farvkzPXNUY9n9tmF0wznOoCONu+wAibBYAQ/XOgh3y/R7rtd2N/A1UWAcSYEfBnzzEqEvt/AE8Ma6G39H9+X/YVPqPU5D90pE5oaiV0wGMUsvV9uEwyhMeZz0xfnxa5Hnvut8GBYOdE4gBkN21oHsCz1RcAN0LNk0y1ZzBaUxY37JE+XePsPnYqZHkX+2+N1DzhKA+9mNE2UlNC5RY9XrzXT3IWlInCZ/wPKTNKicxJJc9hFt80rIOiKOWpn0CiznUHpgSsei7+6IJCJpAawuliw8G4C4SFhrJE/uErG/XAGKs0KyvF4khw54gCYImFSUTIapc5dlQD9FqTDU4LfDh8NVCBjqcCsmebTwtOKONOjUW2HyDDL+MuQVe+cRFZ8q8W3r0tysVJqeUFqxX21ZFx8yYUkCL9cFrH/sSJINx1la2k0RaIfR6Jg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(346002)(136003)(376002)(186003)(86362001)(26005)(38350700002)(38100700002)(8676002)(956004)(6916009)(7416002)(83380400001)(5660300002)(66946007)(16526019)(316002)(66556008)(52116002)(7696005)(4326008)(55016002)(36916002)(478600001)(8936002)(66476007)(2906002)(558084003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oaKXNFcc5F1Pn15wqi52PUx0aq/aEjH0Nhwh01WwtbZhJUKEfUyr2fRt7IBn?=
 =?us-ascii?Q?tCMIQt1fG0DMK8w0euTjq+xqPLNx1b1BywsPt7LrklfoGRZPmb8tpF/K4btV?=
 =?us-ascii?Q?pD2uTEDZ0MuhQEZ5sw3kmvFWbdm2HgnrQXzv9SYwqFx/MKBiULQDh/k0VQcB?=
 =?us-ascii?Q?RCSTGYOnU7Ax7Io+ub6yQLr3Ec0gcujhwQJbM7h3amTtF0mfmIqO7oClrEJV?=
 =?us-ascii?Q?atL3XFutXqmmsGz7HcLPjFE0ssYxz8ViaO6vaj1MNNgM1zRe5aDxH8e6uBBb?=
 =?us-ascii?Q?RRSmoN8jtXhHqxG5PPIpqFS+F/bK5eZDQ8veAqG9Z5OwCKhIpC3+5d/EpgV3?=
 =?us-ascii?Q?LziXO/oOdlTJPy6cLaTDnvmkIhcX3gVDBcNT6hYzJuvh35kM9CYYi6l/a8Zc?=
 =?us-ascii?Q?kb7olNmPwk9+wOVOi1lZh6TND8AkYMo5Czh8d+PHpLCPv3bwDp4N03vxI9uN?=
 =?us-ascii?Q?LLPFDy97Xue1G7b0fbdOVi8iBohPaXURmM8eC7FGIOcxpHOH7GLYQcRzZ0jK?=
 =?us-ascii?Q?mjqWcQJg7GkG+Nqwme0S9Q9QK/M3WpBM3qea4PANUKXmtAblsuPAaFJS1cpQ?=
 =?us-ascii?Q?/Od8LFYZZGK/mTbYL7hJaDZRTLsa6ram534nc+siyv8bPjuiljFy6x+HWFeq?=
 =?us-ascii?Q?z3/C1Z2qO/49pbbAjpApMw138P1UaN1JDyiS6DXROEtDGDmL7y6lE9XGbCGH?=
 =?us-ascii?Q?VQxuilwFEoJhfwWH76d66SW9OTHgALlAyxNrWWxJC9Xh1oF5N0ypQ589WGvR?=
 =?us-ascii?Q?+Dv+SqXzKFdxps1FjihEK5+s0Vs7Uv7cYhj+PncIIcCoXu53T0xjfDYSYMET?=
 =?us-ascii?Q?2Rl3CsQqLosPmTcbdjgA2nKswhBL0TF+p++Yu13S/815q5NUoH2e1SZsjdMb?=
 =?us-ascii?Q?xz6SOTDjyfN7GLGvbuBQ73dRny6xec5mlJExBSKlXSmWXsLli9CvTeGe59Xy?=
 =?us-ascii?Q?y+cDMDWwBxVqDOrDAnjGiSqegASO65I9ME17JMnf18grWMoJtDdoIoNuVfDB?=
 =?us-ascii?Q?BOpdrHBmc4YflcAEirgoJicMaqNH/WAMYws/tXMKpvH3vrLIk8xnDMxrRMeC?=
 =?us-ascii?Q?KCydCHUuGY+c5/ZWV4ZtzU0EAbynxhm+m3mD5TNYrTEN/+8MBer3sdGdfms7?=
 =?us-ascii?Q?WCnyhSVnu9Bg7IBT0l4Ylz/nl/hFyYFzRO8Ly7LBThTVkizSi3e2anGvUaUN?=
 =?us-ascii?Q?vBgjsgZ8Cv+b5gBz0JP3bGMjjS768ZHASIiKyBAEmD9eOb8Cr6L05aaUSyNI?=
 =?us-ascii?Q?Jf7IY/AEXmQ1hBvCKJ/IlFrpddKaaFJUrgGsR1OAnI1SfX2zVCdDW/am5fjq?=
 =?us-ascii?Q?jtol1hn0rU7lPNjtwJRNmvGs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f58b2dcc-3b70-4246-3795-08d925788e15
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 03:43:16.1416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e2LTHL1UctnDqIlLo8U44zP7NXyJoQK3pmJlcYE/IF6tiEVCJUIDgZrPoDyadR2y6BxnDow9icVcMSVZ77x/ZOtJTd0SQMK0UgRfE/7K6jo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4695
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020021
X-Proofpoint-GUID: dPIBrmuooFoGtKy_gtK1RahpXnqx9q2P
X-Proofpoint-ORIG-GUID: dPIBrmuooFoGtKy_gtK1RahpXnqx9q2P
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> Fix the following W=1 kernel build warning:

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
