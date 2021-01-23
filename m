Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4BEC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A9AB2343E
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbhAWDBp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 22:01:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48608 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbhAWDBo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 22:01:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N2tUjm007559;
        Sat, 23 Jan 2021 02:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=hgqWpibu4eyZ4chrb36RWtnUcr6Pdfr8qp9o3/ifno8=;
 b=cUWIbMR9JxBQuNRduha1bVLOKQqTfr7k2cIs9kt+KKTY3d8pnGaZ2+JnwOL1sMVz/B9P
 v+RFA89OUVXl8FzQOb7S1QsM9LR/5xxcRwjVDJs/OEoE1xycJkn2Et8KeNvBgK188K4a
 XNE+k7p03JyhD57I4Bfy59OqanO2+sk7ZKpuqIdWmwDnWpNQ6MUYyGx9cBESU28ay2v2
 YXyQGzEkhI6cWGk64gdHub4/aZowq6dKVpXnZK/gB6k31WXW4g9l3o4BG3VwtDV7DWbp
 XwMXqYsfR4Clfv7juu+8+taBgyOv1KislOgSqaN/TfR+3W/Jor8Dnw5F6uv8u5ZqPqXK eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 368b7qg0dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 02:55:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N2srwR094404;
        Sat, 23 Jan 2021 02:55:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3030.oracle.com with ESMTP id 3689u8thdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 02:55:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nm5EhnEqiDkWif7+3q5pXPr3UH4c5PMuNchzmYTPdgSm8GEjg73xDLspp8VtN3e62Nw7rJFkWIrnVBe8pJ7EwwcYLczHjt9SPBCYxt/PJmFIImj3b1E0Xxx6d8C4GYmqk5W5V1V5/ggT7EwRDGOLwMBcAa4UToLlXs8efwa6IfRtcfKygiedyBmnc2f4OwaXlVqZAZ6E8wn4O/1chkfPKKVRRQErJbv3uImyQZCqTxLgx3LJI/D5JlzagX0xgLyXD0os4El6hRHJ6a3BmVXTk8iS/Ml6n8NA3CSzuXP/l2NDEo373hqORYyVgtaPkvnDRcR+oqZlJEjShfbxX7g2MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hgqWpibu4eyZ4chrb36RWtnUcr6Pdfr8qp9o3/ifno8=;
 b=ocGxU+HfXL5jI49AiZxxb5dy/7eDNQRT8qS1AwCkWNAAvsXsAZxOJ3fLG/GLGUdy35vdC/mhSHv1xWizMPaJoM1bMQu4Gt8dzpNp9CodKeXfdGyIGw7C1t4i116V8w6M0oD5H9PAmENE+L+x49ZMkUhn3FyKFiqSdgO2bBVZx1VfMu3cIMAgPexCuwLh6LN6uQSf4ygQ/ZQbl2mAtqkr+0Pwig6WREFmuOo5IRGkxz/XOlD2DV1dIkoRbvQAN8SsisQNKh9S9DUcANrfsQ7O/s9pF3fpPQwgBOffYljkqh9lxraUkaQRdfNMXNXKj/HQnlHE+B/frNcq4YoOZwo6Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hgqWpibu4eyZ4chrb36RWtnUcr6Pdfr8qp9o3/ifno8=;
 b=HEiRk2Dcw6eJD1+5RhMhc9wna1rbTRUpbNXrHXfIA606RqyUWoUiPyHaBuqH2/8cuO1/pWT1IQLSr+t1oCbjG4QvP8ryZ4q/ThtuHW3MaO4PjB5DvwZGbItKuMlaj2VGOE2IBpqVxEDwebyubiZV7nrRFjeCiqT+kj1FxF+i2xI=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4792.namprd10.prod.outlook.com (2603:10b6:510:3d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 02:55:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 02:55:56 +0000
To:     YANG LI <abaci-bugfix@linux.alibaba.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: style: Simplify bool comparison
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bldgbbv5.fsf@ca-mkp.ca.oracle.com>
References: <1610355253-25960-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Date:   Fri, 22 Jan 2021 21:55:52 -0500
In-Reply-To: <1610355253-25960-1-git-send-email-abaci-bugfix@linux.alibaba.com>
        (YANG LI's message of "Mon, 11 Jan 2021 16:54:13 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH0PR04CA0105.namprd04.prod.outlook.com
 (2603:10b6:610:75::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH0PR04CA0105.namprd04.prod.outlook.com (2603:10b6:610:75::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Sat, 23 Jan 2021 02:55:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51f75adf-d12c-427f-ee88-08d8bf4a67a6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4792:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4792548B8AD3FAAD0DB628B18EBF9@PH0PR10MB4792.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i28bvF1f4ONCedLBwM4R14gX+SHL6Agc6DGDQfvKmDoKkeGbIhqPVGCEQ4OEEZE7Nz2N0ucmDpJFXu9N4evgJI3l0sjdIJbB+YltDJTbe5E8kZgNfqE2QrtJIjC5Uwtg12ynbWTjClGdEyKiTdd/bkEChRiHAaNOpSC4aMRJYnDfNhB4HgTfVOTTDnLf2cFgSRUuIk5kJOs/5y+SBYY3cKaa/Z8E+bpP5jTOiQvfWZNjXa0w/8m3AIX/NolDMs3xCklmHh9kTrbqXpUd+rFJDZbnCbt7R7as22IDtuBZvK0xVdtC3+9FBB3rIUg5cmA1Yzy0SBbfikhwpfWNj+GQf7LKrXrRwqEYgJcjQH/smj3V3hV52RUXM4RhfXebbFD6z0ZXJDkokbzSSa9IiOnqV56C7VH9EuKueyr7Vqk4vlvCqPNZvQVsMx4yL+8DjWig
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(366004)(136003)(376002)(26005)(8936002)(186003)(4326008)(6666004)(956004)(52116002)(7696005)(8676002)(36916002)(16526019)(316002)(66476007)(5660300002)(6916009)(66556008)(66946007)(55016002)(86362001)(478600001)(558084003)(83380400001)(2906002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0Qu3pDo6TjGByZ17gZqrqrTdeGIzkL4qBC5j7odSTQNvYR2ouiwjfmZgFtO+?=
 =?us-ascii?Q?80FzbTh/ZQe3arD27HsMyfyZR04BZGLpDnFiVUBEBhyWxn8/jHvMzYCQedjI?=
 =?us-ascii?Q?a39S1QmSuMFXf8M2bUvyAIdu5UzXb3/LxT2xqNKtNKlXdEcl9OZZpffhv2sB?=
 =?us-ascii?Q?991Ss0DSsAAD0INGOH03xyt4VI19/ZjCwK5o3gr4mdGff1vcyRZDn8scNJaE?=
 =?us-ascii?Q?/bGiQ1zW8vHmLMh3dwjjIpaQSQv4LWUeLMZHPL4WUgnRUd9Pq1/+xYpRskSB?=
 =?us-ascii?Q?vGCcN/J8k1moCEH6w7ZyR1y5ShgNOiJOsi6zqsnijT8rrS0ksKfIoYmP46Zn?=
 =?us-ascii?Q?BXXEJcNICrZSRVkd6FEXb77A3aPB8DhS9ytcCKUAuM5EpSa0R1GQX+JCMwNI?=
 =?us-ascii?Q?SJVaiUBH4z2TEhtroXpKYTqsKqBAgHZXcbYM7s8GNE+1F4pdRGhqhAbwz+0O?=
 =?us-ascii?Q?o6TL0qBp9HXywF4mEadwq9GQN0kuFfJUK8XZXIPOKyi3r9zZD9WNt8m9ip7v?=
 =?us-ascii?Q?OSjC/GZhFl7sMTRtiL9bCR3MnpQ1Db/eXEwCN2zWN3kRk44tWZThUJ8i+i39?=
 =?us-ascii?Q?HFvnxjnmwSnzcVhl5evK4voA7H4p+Wvs+i1IhqAb1bShYTKjr6gO/U/v6L7h?=
 =?us-ascii?Q?wIZlSq2/RW1cU+8WIWZsDwmBoyclUW0zTVJt4vZi4/v+5/9bAIAc2mdIj0+k?=
 =?us-ascii?Q?QhdnNi76dBHYrLi6wpj+q6tWgFwTPayf/Tf3cDNs+cT4vj1Dn2vdmIsvFpGq?=
 =?us-ascii?Q?UcFv22T5AucLl6dZOsCbL8QVo/IJpQPQO9DxT+6xhrTKUZYlPiiDsO6c6KYq?=
 =?us-ascii?Q?Si4w/AMEWn8XOisNCWXE2aCT7lkIM7P1jSbsWojRjh/+ivrGC/BmbvvfLJ+e?=
 =?us-ascii?Q?GLj7BKNTK6D1N4SeSYUfSMjbtzh7tScC3Yu/HPQDfg5q8XXptgAizmOIIXZh?=
 =?us-ascii?Q?BoT255rpLtpzCuFljpP9vBnMemSS2kW3AHOmxZptDwBSf4bzWflJgMphhxsB?=
 =?us-ascii?Q?mrgpPZXDQW/bbnkQIIfHLF5B6uCtPKt8B/FtmxX4hT8ubr28IavimVdAGq2k?=
 =?us-ascii?Q?HpT+cmKE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f75adf-d12c-427f-ee88-08d8bf4a67a6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 02:55:56.2205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FojAY4Ft8y376tFkyYSHByry4Wm0zi4FwrIOPBdlZCYJnS8pnJQzAoVVCWgUnRmTCKyGK5tqhsnTpjjBK66clQ5p5XOa2k6JKCkj988KBRI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4792
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230016
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yang,

> Fix the following coccicheck warning:
> ./drivers/scsi/mpt3sas/mpt3sas_base.c:2424:5-20: WARNING: Comparison of
> 0/1 to bool variable

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
