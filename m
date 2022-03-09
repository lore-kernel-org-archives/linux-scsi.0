Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975A8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 03:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiCIDv3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 22:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiCIDv3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 22:51:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E1E10BBFC;
        Tue,  8 Mar 2022 19:50:31 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228M9E3p010476;
        Wed, 9 Mar 2022 03:50:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=j1apvO4DG0VWY5ZgUvw+uI6h2jddmykqutuJsT9Xy4o=;
 b=PreMtWGB58fS2ZSsklnOoX1SOe9c3GgfHiXY/41+robem782swR+14j8VfvRnRZE2ajL
 XO+FvKjdMwfapwKh0ysYS7QGus11TwMk/BRrL6fjcw3Nw7lXRnwPLbdsIb5X5lyRJkKJ
 N7GW3mvSKRhubhKShxDd3GoBKn3P+73mgiBnvn0X72Jpaj4N940CHz1FHpaf4R1U1vze
 QC/17sx5L1+hVoW6NoGyVV9xGJH1kyPkCakEKce4mWuXC9PFZwzXjJlkxdHmXPv67PpB
 mLQ879GbVpelc6+1oyTe9gxmqBlYD1lTgVJl4m1ywbRSIZkD3dTkz9FmXZQAIcCaoO3K Mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0ru1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 03:50:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2293kMF6068181;
        Wed, 9 Mar 2022 03:50:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3030.oracle.com with ESMTP id 3ekvyvgg0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 03:50:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGSY1N3qVUDoHSgNhJktqZ2Xa25Oi/Y3N+mALK/sLPOyG6kSjalBwBqc3QbdPbffbGdivELA0svML828LTocV4Yiac33pxVRd6uQNWSFcg2Ht5FlpYvBpDzI2o5qpkcgjFTKDnNkMgeWu2YCe+1AyYcBSLU7poVUb3ZLABqKgEM6NHpL29yCESHzlrfncu12S80yQ1ovxeRnwrsrmrxjl0V7oqxi9x4vUydA+cNDUyTfzaYZTFT2VrH/mk2jUvzceBZ1Ig2XWhrDGo2NlMKgQ26NYwle2XN5MF7RPsf1sgt7m+dLFT+d8i/7n+UTVWuQmABLA6foX0CblAIf9nJADg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1apvO4DG0VWY5ZgUvw+uI6h2jddmykqutuJsT9Xy4o=;
 b=QPNVIe7iy7ve8sZYJBK6us4bpzof6/tUrobn/td5qY0I9pMQBgIWWUyr9UzNQZbgTj0CihAZv7Ls7DJhCXQXKJ/heAGjouf4t+ilw17gKpsvLISkeF9l2zOtBcD+IQEwP/7FF7KRShHdNLtW3bz7G9OXUxZXCVE0dEdn8+Yi9HtDeFoHyCMGgumX9bfQBKcEvI5fnOe23bUFt0xeE01LAiSQhHwiUOwkH3ZQxdBZBkVCGT5KuV4tt+D4akJhT+t9tNH91R/+Ti+D6uh6MpBOKC53uyVVrfnD0ZShZzCQeOv4fTdr2z6Mjj4ZKQsbxSrAULL5kC9DX5//ojxYNwRQlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1apvO4DG0VWY5ZgUvw+uI6h2jddmykqutuJsT9Xy4o=;
 b=bRiDIcFNSaEVQnZqYcIqxHbSGuL8rLOoprq5XgnJffsTdtcYhvXteFH3yBrUAmrxY9r5WVUn69LMOpAI2K8Vpm8mvTBG68o1JQ1/ipnL67HMRbkbTWp5+2IT1CowUwKziazmfFh2U7ScGsY2qhtn+SKshCBccA6w5ZrzQwiJWEk=
Received: from SA2PR10MB4763.namprd10.prod.outlook.com (2603:10b6:806:117::19)
 by DM6PR10MB3003.namprd10.prod.outlook.com (2603:10b6:5:6c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 03:50:01 +0000
Received: from SA2PR10MB4763.namprd10.prod.outlook.com
 ([fe80::a045:e293:518:7604]) by SA2PR10MB4763.namprd10.prod.outlook.com
 ([fe80::a045:e293:518:7604%3]) with mapi id 15.20.5038.026; Wed, 9 Mar 2022
 03:50:01 +0000
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-doc@vger.kernel.org, patches@lists.linux.dev,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] SCSI: docs: UFS documentation corrections
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lexjkco0.fsf@ca-mkp.ca.oracle.com>
References: <20220307013224.5130-1-rdunlap@infradead.org>
Date:   Tue, 08 Mar 2022 22:49:59 -0500
In-Reply-To: <20220307013224.5130-1-rdunlap@infradead.org> (Randy Dunlap's
        message of "Sun, 6 Mar 2022 17:32:24 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To SA2PR10MB4763.namprd10.prod.outlook.com
 (2603:10b6:806:117::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd48c22e-71d2-4a1b-e392-08da017fe383
X-MS-TrafficTypeDiagnostic: DM6PR10MB3003:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3003D91F9FFC28CFF9BC4D448E0A9@DM6PR10MB3003.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VZ90ijZ/4wJZPlNYLI2Z5WItz2dNpET1rq8b2n/1j4baHSQ57/3495zLWmfXdpAhLtfgbQcnWui9S/5XtJMeywZstdxeNLFm54sf1tVhZJE1hj6JUlnvqzHSbVqP2lLoK+OKKmPoYHfb7zjUp8z8x4mpqy249PX52i9rOv3NIifl2/8wDwFkgIBe6eb+fgo1esB1YPhnrMBpf4ILUXW8G3fKoRBE1gK9n0VWyCV7pA/ubOUqvkOTJBx/80drJcJns0V1ZCqPxG4fyPmrl5PAcNnNpzGkcM+inyJNpUV+z7//6pxJ7fzluaub+i6CaEaL24dpaE0huesHdFX0nq0TzzAumPWIeKSyH+tx0mA/np2AN4tctp+58NCa6DwDNvGiITh9yXH2GjUluAcHERFYXqt2gkeWhlAzpgKCMOkhS5MdyZ2nygF3tiTceBNQa4HtEon6jMW+WJAirsTLOnGD9X8x11vl69FqGaq8pKpYVAidX1RzL3MCAQbOt/2MivahAWDseruO2LpVYlJUiU+TiM7Ik91K4z0PRANZvPEicdWjiBn1wGzpX228BGEgszEYWcfWBX5eMkQTYtbsCNMIA6ElUM+lKzUgK4CxZDvbGkIiBZfU74u16zbmXKbA3HKI/7G3oU8Xh5cNLwyXzuxt/0ZM6z8F1Zeno0RczL2I/VCoybpDOuJtSuk87HuVvpEnzjOo6frWyymCuSZD+YuhIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4763.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66556008)(4326008)(86362001)(6486002)(8936002)(5660300002)(66946007)(26005)(186003)(558084003)(8676002)(6506007)(2906002)(6512007)(52116002)(36916002)(38350700002)(38100700002)(54906003)(508600001)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wIZgF4R0JK/Lq0mvDNs/9ovyqljsXocNscKhArg1v5W0g/VdUmK6z4PubYwa?=
 =?us-ascii?Q?BT1T4VLnvdGxpjzl9tf6VSO7r+LUTvUdDN/r5bxoKp0MX1zA2eRkb1albugj?=
 =?us-ascii?Q?FNjPqlRY3BQibXTMO77aWNqDeubn0wVEI0U6Mbqw15mvsBv5UfWqpSKIAUKU?=
 =?us-ascii?Q?pOvdgGZwidxIEM5ZDLtG57sfsgqb6W2+2SKNDCbJgKr0xc1zJGSL1bPjlVbJ?=
 =?us-ascii?Q?H8nkMLNdJfLQr1jFLZjF0DlAEWdBSRpgZHij/9CznRT1YFJLUzaA4se/f5AG?=
 =?us-ascii?Q?1uJ8U4mCkOQBVUO9tuw/cbVcugGr6Ek5xLfvqW7gK+ECJJsj8JmlzfumVDBL?=
 =?us-ascii?Q?uWMwsN9CosgvxUku1E0VoX0xEzYMVqJT7GUlH0ouJo3adGFrcnC6ltJ2RAqj?=
 =?us-ascii?Q?kRsCEaJWVoGXLwj//foeqDBJdYERUgehLtaFvdjpY3rMf9bdpiIaAyTmmQrs?=
 =?us-ascii?Q?xirnn+9JKUJH4hlw++fHwJxXxfcDF9+gvwDdgNbzVTrAfjxRsw93bbAenAIo?=
 =?us-ascii?Q?BkYzYkfP9YCxfgJR2B808k/7rP4zx6yGBT1easINbpbKF2KgGW7ibBjLIjSX?=
 =?us-ascii?Q?+O2oqbw+qk/5BWrwHL84IWJQ2kWjsv6hILK8o30nP5yr6rrBDCLk16zqKoZb?=
 =?us-ascii?Q?ugtSHevXx65CK4h1lVZRG+yLTTc6G4MGwyb9dZyAtl3PdozV8ZxMNGKN4jxH?=
 =?us-ascii?Q?A1XBrPXNBqRLznYAQg09dVx7oSGksDUAS2ckJUHnm6Of3ix8pIYC4kdiycSv?=
 =?us-ascii?Q?6XFCal2GWkVDB14oe2w57nkgHJUlupi0iX+N2uEKrR2aFSIR+8BzaWuA4Ch7?=
 =?us-ascii?Q?WpG1JS2DI/IxyrZPlUBpKhMSeGngKYeWaB12UktPoigOCfjJw9YqmAvsh6GU?=
 =?us-ascii?Q?rTuf2u0a4Z9OHoOJsDd+A8FTkBTaQo9dFD39KnMnmupWAf+szagyqFFdKutP?=
 =?us-ascii?Q?s5fU6OV4KU+sWfiCuuP3GTaZel3gS/ylzbaAtuBfd69EDlZFAOWhlsuaisZi?=
 =?us-ascii?Q?KMlADiBJEUDAVdH1JuIGkewuGtCqWszxss88F95Q+vTgRDSwQFSq3vR6df6P?=
 =?us-ascii?Q?+Ct/SfsVJMp9SzhYaoCwp5STO78OMbYLLz5bvYHtd6BNpQEcm2kCc1sbiYoc?=
 =?us-ascii?Q?WsWHRhUiWc1RqfVcdg8NJYqMwvqQOHTQgNj1Wzess2WH1wGpvXDQGqR/aRfc?=
 =?us-ascii?Q?iSr/6XOq6bU8ZhcReHox4Y0h2m8gltVycVK6D5NDoScxVA43Z5qRTgmRHevP?=
 =?us-ascii?Q?UumlHNeOqZO+e/Vu+n10fQGdTt/PLiy4Ny5tFvnG1R1Q49UoOY3N3IdNm+QH?=
 =?us-ascii?Q?yvY7N3l2Bqe9tH298fsMswjnm053+cRrUx02rPpFBYhNHLcexE4imJEwdh7Y?=
 =?us-ascii?Q?qQuvoepREaFios8EcN8XX7eqVzcnyrUhwg6/oCA+oDIAsfLyZ/0QqG0cfh7K?=
 =?us-ascii?Q?LAezfnpWjMfS45e6nCwEy4vZ/HyUClvtVXA7psan7lcN7EZg1wZtbbM7FMGP?=
 =?us-ascii?Q?ikNl2yDiJjv5Kg9utqTamCP5eBmpz13SLJzm4RzXY6P7cfAP3mhWfmpFF6a+?=
 =?us-ascii?Q?R6vkykhde8iVtxDpcx/FECWNNl7Ijfv3tDVlB2K4rZ8gMmadVMB9+yc9Jue+?=
 =?us-ascii?Q?+4IB45kQDPKSqMmpoOFT9ktR9RjHC+lUO6vak9zJXQiIPVieJe71MN3f/0rU?=
 =?us-ascii?Q?PqbHnD2Yv16j4ydY9XaYK34y/hE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd48c22e-71d2-4a1b-e392-08da017fe383
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4763.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 03:50:01.6985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2QwZ+aYq8H9CBtgkUG5YKilupVxzp9fsEJV/ftjIOvdeVu2sAz0jStmzC04IIwi5B7kSpSOLPGWEjptrVN625C2mtPDFK/oO+hb8BAuzQIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3003
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10280 signatures=690848
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=736 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090020
X-Proofpoint-ORIG-GUID: N6IfwKuRRiM9bGlP62HJLFWinVWg5sSr
X-Proofpoint-GUID: N6IfwKuRRiM9bGlP62HJLFWinVWg5sSr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Randy,

> Make a variety of corrections to ufs.rst:

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
