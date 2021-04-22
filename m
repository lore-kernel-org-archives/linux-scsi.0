Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F14C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 02:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F6DA61404
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 02:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhDVCra (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 22:47:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45204 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhDVCr3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 22:47:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M2hxIj187425;
        Thu, 22 Apr 2021 02:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+RApMkUY19rV33yfYS+aCgpGi3RyFuVEN0J9Ll/FKTk=;
 b=gKDhVdEyDUa2qFao7W05BoXT798nGB6h+ONtZWd7yyYYWtYYevvISvXBmTEtfZKjHmIi
 NSchkz3EqUjMIvWIBfTmxj6Sxo8amcxtdSqigtDeX7Wi2raDU43a9LGx0Be4naYW2xo1
 pytIbx5uO6Tc1AuAh8LubBURKARdBbMOU7hiDfdomxdfPVKPTbQOVihntRy6I4sDVoTZ
 VMghHpXlQgP8W2DiSAcoaQn5W8JWzWkGCCeOSeCDln5nNPLPk6yJ+S/H7nRS540FzEwp
 gnmUnOWXVunLXndgOyMAIrkAa/4Md45A1d0WhjcQMIQ6EFi7DO7ajQBuKZFXmTEyRg8h bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37yveakngx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 02:46:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M2kCkO166756;
        Thu, 22 Apr 2021 02:46:33 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3020.oracle.com with ESMTP id 3809k2s70e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 02:46:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iainqlJcJg6wJhTHdaXRK9jXZV/CMMRc4immoZEcEJDqyRUHyB+XBW25Kzd6Mzzgm9GaAt2zMpbtrCwGDkm8r7ZP0e9Jg/frzZyz7fS0/ZBtoAqk6M06j6MffIFCjb4yvQ2aWugzU8IwTAMAXf6tvWVlpAUDzaOualHhr0rYvpvLf0IsqA5W1SH9xR5NZyTLTxEgCR4JUfi6GrvQ//EyXjH8WQ8vhHduXGu6S63++nEeH/yf+x1Jmx91M9yO+RCwfmoId7g9TY12XKjmfNmvRlqYSbjuoyOL/UOzorcXBaZMv6NN6FoB+phtXCrqo4iLlT328DjsF8qcneHJyE1DJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RApMkUY19rV33yfYS+aCgpGi3RyFuVEN0J9Ll/FKTk=;
 b=J9dXkvK6H3P/0epagKnK4Wx9JRIZYvz/+alp+S9TMqc+EbWppvgC1fA5Zs3bQ8JGo7mGv34oa7sVqDo+WWsbhojBO6uwGPHiHgy0uK/gka2Ujt30I1pT+UeLUZxbUxRSOSeOlkq0UpuRo51H0UiWySF+YwvXfEUyp3voEwA3rHK9bSyt9VOyO+ACUgy4btFdZZG70yBOh0dO+2MMeCfRN+FAFJUZl9sJqP8ap5sG3Rnkaepqu6Ut3jfU9PTVtpCCGFVzLR6WEAgUrydrM0MFrx1Fzw85nsb64XOctqZ8Ivz7tv8T9RoL1u5wmQ3B4NZF0TjvxoGbugtDSinGaO2NYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RApMkUY19rV33yfYS+aCgpGi3RyFuVEN0J9Ll/FKTk=;
 b=tydIDWRoRW1HAt29XKTTkRkclAv4OMVa/2M+ENJ45/5R7YPPJdbr4z+QdUDE2OnDE0WN/5kLb5pbIZ1yrOfi89814x/oNiNUdhjZ2Uz9gTY0c+mJStg//srqTEQH+3FP00lkX6MtyBtK9UwoTHnJMp62hwHZ9q6VVe/L4cXvp9M=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Thu, 22 Apr
 2021 02:46:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 02:46:31 +0000
To:     Martin Wilck <martin.wilck@suse.com>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, "hch@lst.de" <hch@lst.de>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        "bmarzins@redhat.com" <bmarzins@redhat.com>
Subject: Re: RFC: one more time: SCSI device identification
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
        <yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
        <06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
Date:   Wed, 21 Apr 2021 22:46:27 -0400
In-Reply-To: <06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com> (Martin
        Wilck's message of "Fri, 16 Apr 2021 23:28:50 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0105.namprd11.prod.outlook.com
 (2603:10b6:806:d1::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0105.namprd11.prod.outlook.com (2603:10b6:806:d1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 02:46:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e6543c0-36d0-40b4-4bb2-08d90538d5db
X-MS-TrafficTypeDiagnostic: PH0PR10MB4774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4774391977F3EC4866CD1D9B8E469@PH0PR10MB4774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SLUyPrppy8kmTrEMuNZoXTJCj+9HP2jKcKzPTf/S7g1eCEVDDrChsoo4Jnk5Sg4OcaMhyXVBrfNVAxKxTE74C08r3ipV25IAzQ8+48qqiqxkEAVlk/A86wU6wtgdvsLZMMliuMuSw8SIcDkodeKCmiroG/zLuw1j5lM2RyDlAJls2iSJaH9hZAu25QRyD/6iJ53NWAmZBa2e3oqDR/qZikShfyzxnODqQ1d9nfx+0RmilC9baCGYjyvmf5p4WmAjILprk/318EHogK2k5r1E8kb0qkrkuG3Vtsjz3UoHyU83abMVWv60UNHMqyJWCls6dxf990UYabE5ugfOqa/a5IfoM3J6s1M1pysI3xAhHSSRx/ohi3V6V9Z5toFCTlBZnZUl+fZhQD0Kyt6v103jwsjcJZ3MGCR8VK7kmI/ukmb3OVoZ+z8JobxVL8eP8k5K8jlpCFI30/o6aARgsjskYPFBjDUpW+9NFJKlsoTmHNt+5UAmlsWdHqbwcLJiWXYCzmn8H+IIDA3ZumXp2wdVnvzdjqiZo/mB3goQjwxB6wMQf0CWMNt768kYcRGitL8yZCgCnGyDsTzOso2NpXVdSKCxM+bgfa1AEFe9FJ8NZQ+lBqcNk8tpAo0pf0OIE7MqQUvcV8JzYqYrI6owCBexq9NrHrE6bAbIh9Tl81dx0eY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39860400002)(346002)(376002)(38100700002)(38350700002)(83380400001)(86362001)(2906002)(8936002)(66556008)(66476007)(66946007)(55016002)(6916009)(5660300002)(186003)(478600001)(956004)(8676002)(316002)(4326008)(54906003)(26005)(52116002)(36916002)(16526019)(7696005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qhk8cqHuSIgLhSegcrF1ftRsv4Z9FtJ+KXOGCpK2z8KSqebLOQhPhGkcxJ58?=
 =?us-ascii?Q?J28BQKbMs0aPBXqZr4giU7WAsqi+81nBQJ7LqnHCcHg6bL0dDpnPSKCXlVKb?=
 =?us-ascii?Q?GhseLM6n+u/ecZpD/n8JEnMKsHR/H1SzoaIPi7ZrNABiu88e3eUylfOd36Li?=
 =?us-ascii?Q?KFwHwWaC5ZuwFAelY2r8lB+TdVACDp7YhIj+NuBascloSyzXLK4i/LkfIZzF?=
 =?us-ascii?Q?ZSYsG2Vv8zI3fjd0yL8suDCJl05wLNuAykhHgM+r8QMDgZMpUFkVO8hUn11E?=
 =?us-ascii?Q?xZoRmDje2uFxnYYUoK5BLBKO4Hm3rX+qwgZWJIKdYZMAIVCTJJ6wUZIHgNQ0?=
 =?us-ascii?Q?sBUAE/PXvBaoc9W2pb8bw7ME79L6WWdUO1vGIbT606dQQvJ7qky+r7SGRZs2?=
 =?us-ascii?Q?ZfZXCIwQlJz7nW7gQvIYofv0miHRNszauDWyDXg7kRdKD18wvK0twPqJ8aeo?=
 =?us-ascii?Q?8Hcf0YUY69mlOoECj51MoSnbW5GU2w1yg0OanZ6UO8Ykt6mqi+fk4xKlS+16?=
 =?us-ascii?Q?9ae/bFQoasLymI+OkLwoxjdAG/7hXcpihDqAaCTmQLm/L9C4V+RavidbrZ4m?=
 =?us-ascii?Q?ZJybAQcKPpVPCNFSLebkft2E+drBXDdE+flhvnlKjXRumw3yZPS3N2jB/bVo?=
 =?us-ascii?Q?EsRvSiL22ij9krtqEoMwzSuWbkFzSbIIYfDKxmtTE4ZGEQCj9ByKo/8X2CNM?=
 =?us-ascii?Q?FFgoOJ/XHh+2shOWCZ4xXWty7vIAAv1wRVTZjaRmhrS3Kcyb4gn/d7yhlgIo?=
 =?us-ascii?Q?tO0Ku/KcXVk3porC6wmZHacG1Lila5kZ+gfJXvwBSo23HyagpPEF4Q7t7R5g?=
 =?us-ascii?Q?B3N/9566DBLIlab6rb6SGqYVYagX7duUhawO4ZdHfm/lCXG60RwKFjDMn8JN?=
 =?us-ascii?Q?krD9PdkqlxKeRE2IUdE2r7MXMPCyhJ0XSEhVkeNB2niz+0PpP7j36iig5Hp3?=
 =?us-ascii?Q?cKb1OXAK3dAE+t0sNN+lzVuPd3rXg5zf5nlYsCL39JrYLp0+fcmeIeXTyNHv?=
 =?us-ascii?Q?W1182C2OYZ4TbCVaSUTQVXqZ6cTEmmaU1QcfD6T0tX7Mxcl2WMKRB6vyNCQy?=
 =?us-ascii?Q?j04JQghDxrLkJEznPjl79vAb3sy3MbhCz+E4MoStyMbwU+851qMo6QcCBC/T?=
 =?us-ascii?Q?8sRQCA/EWQloovzgMnJ46Kun6HH5ZyOufzclBd8FS+jsVfseIsfGPhAmf4Dp?=
 =?us-ascii?Q?sWw6julzVswmLNdD5MZXOvTIUqmc3B1sQwUcacLKXv5S3P2qzhprnxJ80cPj?=
 =?us-ascii?Q?jC1078RmzIayGLXOIX7Nxy6EIS38ZZQxYUWxobyTeYAheoblPgqNN3WUOKzr?=
 =?us-ascii?Q?SVCaaoaGr8pYJ3Vfy36+XYeP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e6543c0-36d0-40b4-4bb2-08d90538d5db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 02:46:31.5226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T4EUqSag2nc75z/4nkyEbnwXhLlSoLod6CgT3as5UO2lYszbnQI9GdorGhn9Pfqm3Abog3njq/HFtM6MBxxEBfFUx9fI46RPIL64JHiJv7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220023
X-Proofpoint-GUID: U0t0Oh8KC9MDev003-IgqkVW8jOC6nNn
X-Proofpoint-ORIG-GUID: U0t0Oh8KC9MDev003-IgqkVW8jOC6nNn
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> Hm, it sounds intriguing, but it has issues in its own right. For
> years to come, user space will have to probe whether these attribute
> exist, and fall back to the current ones ("wwid", "vpd_pg83")
> otherwise. So user space can't be simplified any time soon. Speaking
> for an important user space consumer of WWIDs (multipathd), I doubt
> that this would improve matters for us. We'd be happy if the kernel
> could just pick the "best" designator for us. But I understand that
> the kernel can't guarantee a good choice (user space can't either).

But user space can be adapted at runtime to pick one designator over the
other (ha!).

We could do that in the kernel too, of course, but I'm afraid what the
resulting BLIST changes would end up looking like over time.

I am also very concerned about changing what the kernel currently
exports in a given variable like "wwid". A seemingly innocuous change to
the reported value could lead to a system no longer booting after
updating the kernel.

(Ignoring for a moment that some arrays will helpfully add a new ID
designator after a firmware upgrade and thus change what the kernel
reports. *sigh*)

> What is your idea how these new sysfs attributes should be named? Just
> enumerate, or name them by type somehow?

Up to you. Whatever you think would be easiest for userland to deal
with. I don't have a good feeling for how common vendor specific ones
are in practice. Things would obviously be easier if SCSI didn't have so
many choices :(

But taking a step back: Other than "it's not what userland currently
does", what specifically is the problem with designator_prio()? We've
picked the priority list once and for all. If we promise never to change
it, what is the issue?

-- 
Martin K. Petersen	Oracle Linux Engineering
