Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE63EC433E9
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B44C64E4B
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhBWDgh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:36:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42124 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbhBWDg2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 22:36:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3UK73133309;
        Tue, 23 Feb 2021 03:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=a37LwkQ5xfxpAXveVFuTrMAG1j/ll/tw9gBHfS+mtpk=;
 b=VFmjFm9ryroLyxQwEqXhglZkOJDjHkdssIPagATZ5fFV4p5cFURHqQzRJPOREpS0IyjC
 CXLzGoyvfWhuTwOXu0hLYD7hchLIiAvdyeUa+VWJlH34PWPqhI+IeqLbpW8lPE73MLI9
 UpuGEXjdasAVOmpswm/8YObBGPcriy61+lpUgYhNI4AgS0RJGhR74UUJpq8s6NY5uJFt
 0AKcYpCnySquzjdT+6cMTENqpjaGl1/GLIYzU6IaLc5di9IadR6VQNzxpdyh1cfmVPFo
 A7shYiW1KBPqeW4eKhzCXmGn6icONFhnlSS9P8GmJoZTDeVXetrYrjy+aVNcklAqOpJi 8A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36ttcm5rpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:35:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3QI29106930;
        Tue, 23 Feb 2021 03:35:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3020.oracle.com with ESMTP id 36uc6r5pp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:35:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AiTnO65UYHO9CFwpabm39BIxyOmG9zfI3al1ID1L0n1EfD+/0YbJ7zS9KQiLMkQPE/2mrt5Rk+4Tu1wE1hAi2MouprlfqAdkvt29qxrdXaUbDxWmwGGfTUU+IGtUzZA4cEosHxsIRpmgGv6JJScpnfs/lHjvEQZeDlqcfQwL/1i/L9qM6pj+5Sof+PqPeEqmAT41KrkVgcWRkYadMZtFKAFI8wx1YK9sfoj9d/4n0WhNXjT1XQ7Ln39R08TgnbVequU7QcfOceJp0HsBlpjVtzKjfVAZ1/BViWEAqEdbwigC4UNnta80s+qO3EYxace4jM7zPd5JDmVQK7lMVEQ5zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a37LwkQ5xfxpAXveVFuTrMAG1j/ll/tw9gBHfS+mtpk=;
 b=OzQcLSjDiaDzl4eEZbPhhjmv1DW1lnfKpVrLDw3DPQjNH+Rerh51DnV5jTA29EhX73SWZPpnLk0T0MCkjxzHyhMHLhqHopdUykYUacN5DDrIcSr98tPcxWU/ivuF0ztAMgSNqNusmU0UsG+TJxoCvwB+syzqq1wIFx0V8TWYnnSM6QHm70oYk9Np/RRokie/Ryms/745GfpYHjdxvXKcHANs5d7u5mESoh2Xo88O0wvZWfebqENf5Pbs668D90v7pE9GevOWc1g5iHdAr0k+bf5KO7oFm5dSEolHGgrr+C9Cyd44v0dbGyjI8dPCY2rCq4TX9YcGBp8b2CVIuiXECA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a37LwkQ5xfxpAXveVFuTrMAG1j/ll/tw9gBHfS+mtpk=;
 b=dIfQfAsaIZ3FyY/NdX/O2U08C6UuP/22Ma6pHy8tYtb1AlxJfit+l6D2plJ8TxXOu9j0ObUftiSPnbCialalVloCmRqB3/Qu+VXsuTDfsw1XGdyZU3M82noBt/VQxSe4upyNoG0HttgN3mMOh8TA33aYXPnBmMBeNBbLo+SyAqU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4437.namprd10.prod.outlook.com (2603:10b6:510:3a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Tue, 23 Feb
 2021 03:35:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 03:35:42 +0000
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH 0/2] scsi: target: tcmu: Fix memory leak
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0qzfoch.fsf@ca-mkp.ca.oracle.com>
References: <20210218175039.7829-1-bostroesser@gmail.com>
Date:   Mon, 22 Feb 2021 22:35:39 -0500
In-Reply-To: <20210218175039.7829-1-bostroesser@gmail.com> (Bodo Stroesser's
        message of "Thu, 18 Feb 2021 18:50:37 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:a03:40::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR04CA0003.namprd04.prod.outlook.com (2603:10b6:a03:40::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Tue, 23 Feb 2021 03:35:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65f107e8-e372-4d29-b55b-08d8d7ac1879
X-MS-TrafficTypeDiagnostic: PH0PR10MB4437:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB443764EE804A0118A203D2F98E809@PH0PR10MB4437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mUuTS48LYuAPdnPYsKOxEhK4j6k2/l+q6REfN8TkXb/+1bvjcVtEtWuzHz3Efcc55RUeik/q/Qghd6y67jc58c9+WD/2Qfl4ZJ+wzGWZwJvmmBvAl6aJS8xY2UzIq9wE5bdcoG1nhBea94Q68LGzSfJW6GwqboG1fJuAVNgba+lPCnyGR3KC8hD0kdh24WLIUTxG84hoXpVs4tTSjVVhY9YseX5gVZ3zH1UyXMrswxVrCScWl6AnaWH18y/5jXq7TFgbyE+Ss2BW3exupCInCo1R+jKbw9CK5crtzqyic1IOXqZEvIvzjJMVvuPy9rNNlhQi1kNDMCptn6uqNOVBPEHNuSRRWQDM7MiRvmnsEolmr8nQUrzy4RxBOUZefbOCTKtKdFUbSukMJHgYTmp2NZmoDZGxxbV3n67S3IwW4zXkuGLGxRecqQCvU5WLEpfZJ2n+EPlmQ528xl6a5HKOxcUF7EVfsmdPwv2J4CayBGDO8d9iPHEY7LkRo8sH/DQYKjRey/Gp1PzF2Ztkb7AuSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39860400002)(366004)(376002)(186003)(8936002)(6916009)(8676002)(4326008)(16526019)(54906003)(107886003)(55016002)(26005)(558084003)(66556008)(66946007)(66476007)(5660300002)(86362001)(2906002)(7696005)(36916002)(956004)(52116002)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8Vp1HG32TkEQVIHyEEimadI1u08jma/XaPJzolOW2ZxZ1EgDS9E1qGS45PvQ?=
 =?us-ascii?Q?nH50+3iTlGvXvSI+9FXp0/UmGj4L6a4UuAS9gY6n1CfxgpLjN85dAaGv3yQR?=
 =?us-ascii?Q?FgbCjlAdPQwsbdx5nJ7w65B9+EaM/8uswgZ0xsJA7BX7pX/+l87caP95GOc/?=
 =?us-ascii?Q?Os8U6XdivoqAtTjmC3E8A4rug1NmL1YZd6fUz116S+NY9Mxaw0nhxgwIRN9R?=
 =?us-ascii?Q?EnF7GnhFDEJfcjlKAkg6YTqwHHxk8MGcPTnFFIpKtJ8mfQAllI3ILdfPQGiv?=
 =?us-ascii?Q?oGxXmJRsigG5+H7MgKoK1CqSAoPTY+v2/5Xyo5eRKODzbq1L3XTcxh9SeTv4?=
 =?us-ascii?Q?dbROmASC4qTBuRc2cdx84HkWOtFsBWKSC9uVnTShjdknbaSCDQE5knSrYLtw?=
 =?us-ascii?Q?4uwLfibCOzVLFn9OodXVGuasGAn/XGkHwcXLD66RHQUD9It2BN77tHZuhbOS?=
 =?us-ascii?Q?Uh6h64rxlLRHupOg2UNU0ZwmFjqdLH6bGmwlt/JXNsUNv+MiZNytzacPeJpN?=
 =?us-ascii?Q?ij68IH45R5Qor/zMVCh+cNyVaTOCrTq2zauUfFff6XgVayN4QY0gOZfkdbuV?=
 =?us-ascii?Q?rGTB6wyYxgQBtmH10pIfQBGqbG6HsS4x4LIhdHttk13QujxDSDMdkUDPB1n0?=
 =?us-ascii?Q?Jr3CNcK1ic+mCoK/5Gbckk2PZxm9jAMzQnYR09UWLYPQ7rmxvN/r2GZ8rOoE?=
 =?us-ascii?Q?+r8rVLV8BxOslXvB/FkYsSnMyuhMpMFWCl+nM654DV/9R40Bq4ckR4kqopgc?=
 =?us-ascii?Q?Wxmo8oNetFeMupWnjz9wQnrOFBF2Rmhuh5qjUWyLGxPINrriJeA4fjcI5vLM?=
 =?us-ascii?Q?PgmlR+H1Vb3Qp9rza7UdtLGL5pCjaYqAow1xxF+i8l29KqHG9eaS5NmpZGHz?=
 =?us-ascii?Q?5G526+xY5TupVt4DEFpULRtvIfl/23xKxAemuYdUESMGeJUh5IIQtd4uzE8z?=
 =?us-ascii?Q?i2Cx5Ca8pMx3liVO+43whHGWqIHDk+0B0uDmqaJNnqrQjQM/2UZ9BkD6eoDZ?=
 =?us-ascii?Q?1OOT0a0/3ToOAD4nHHZ5PbKfqmJIT84AUN5hegRK3IgtgfHwIa5jd3mVvHzN?=
 =?us-ascii?Q?W9C14m3ICCjP/ZcJw7ToHn3i/OrZ+HcDRSFV6MRqJq5Z+90EUdIpQ7ElSLSQ?=
 =?us-ascii?Q?Wzip0P96JX+pzN6aXxXEc+LTNApxiYMyJlTlIffOU9h8hsM66TNC9slq6tV1?=
 =?us-ascii?Q?u99MPqQBBub44jCfj7j1M6IyWj+76+RxhWmFCyBU06bNNveP01byigsdiJUd?=
 =?us-ascii?Q?DTf0w0SQBgsH3cSHeQRRwNpzG9GsELJAAbtamg4W3chXq+N/nsV/lIoNZAQU?=
 =?us-ascii?Q?OdgSkZzhCevv3nX4xKvwSFw0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f107e8-e372-4d29-b55b-08d8d7ac1879
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 03:35:41.9454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A2sG47p0COmrdDTqwVd+ztLpann9H5znao5NNQNnztNJcFeQOkBup55dtcw0AagmosXo/1dVKS7/SbOn9tl8iaJdH+MVvkI9qeXibpRtydI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4437
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bodo,

> This small series applies to Martin's for-next.
>
> This is the third attempt to fix a severe memory leak in tcmu.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
