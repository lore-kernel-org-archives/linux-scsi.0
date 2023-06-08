Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A75C7EE25
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 01:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbjFHBWY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 21:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbjFHBWW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 21:22:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEACF26A8
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 18:22:21 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357MeVU2026221;
        Thu, 8 Jun 2023 01:22:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=eCiVsKwlIHMkIydUAu+3+5L3BB4boVjvCUJktTe+5xw=;
 b=aQCAkPrxmkS2WYX7ZFEuF9PX5TLzQI8UkPz7NYp46ICtthF8IJE9HpL7Eooex3F1LiZf
 vCo+KktP1L4vXcJv2haruCfjR7hMkWX35/PCQ/SnC3daTSSzaIa2K2uKFsUNT0rJ4KCy
 b1CtxvYIe9EW/S3HJtuayhi8qoo0WfPVRcu+J8sRTrw+8ILFqAqTyZhNjk6+nLaY3rvO
 hpBqwj8Vrab1rb+9pZEI/+Z0sHpzHxOA6nQFFBunJFANkBj+y4KNFge9ju4WwoQfQiNs
 Nxqj3mRYfglwAA7332/OLt0c3c7rEhhV+FBtd24Cc8gZKNp2jVExwIECjOZfbnlypZ9E QA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6rb49j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:22:06 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 357NdQoD015682;
        Thu, 8 Jun 2023 01:22:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6mfv6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:22:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXQ/NvJgGdccgXEQgK33dwKvdO4bkZS9JzkuGSxvm8CG87YGzlX9nV4QCM2IPgSspaqACE7dG505F8kAVna1e0k4upTRlwqHODOQ+H5Ie3TfZQj3fX+oVl7GHuiCC8oXXfQcKE9O8+hDB/aMT5sFqgeLhbcZPB3bJ86s2GDD5yJk58K9xpoL7YH79gJRJiLiwkJZ3sL/CfufcN+olnXjuA7SwrH7fEpNBoBZzm4aUxJn6xhaxkVWvyxN2BP8jGWlBledmC1u5LDjSWlIttKHR0Wgo9+k1lGUnTdbESIBchG3lJgzntdCriKJNiGTFwu5Hj+D/ZAjyHQeH1h7QL0uhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eCiVsKwlIHMkIydUAu+3+5L3BB4boVjvCUJktTe+5xw=;
 b=JLwmO28lTyftJmeOIOuCev0Yfh7zPIgpSnNT9k/QH/DVnYPPck1+sc0ETGS/VsUUyFFB7Tg7VIWObO2fmIaCi2ykUl10m+OJfylt4BbvVllTO4mcIY2OG//RKLzpveyMBT/rPDwQYi3KGqr9GjkSyaukt38LeEFnVJMzuE755SWtk3+EMRkLZw7eO7nymCA4NgzIXQKq5LZ16/r3k6s7aLwQcUnor84uRThsnrPLBA1qct66WRyUIoV9ErUqa9myifK2dJRDNCMKK2JYJhNXF7IEHl1Bags4xO3b65HJq5dn2hBEtFRXKEhu+BZMjU+fLxOSrL+G6UOl2QZ5OT3KfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eCiVsKwlIHMkIydUAu+3+5L3BB4boVjvCUJktTe+5xw=;
 b=FdnXEDOaCUB1hp+1uxxnY13tf86PBKQ8dpPYLuw+Su0dyTZkqF+cQVd8By1aH4Nn06vzUHCP7FFhl6Ksx6viFdrT3HymcKjHN+Y6kGSD9TBejf8FmtVM1ExjHFEoymxNSmSp/vizhXstWyLxVS1+AwGG4OYz91zVu5igMZYp7ik=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5178.namprd10.prod.outlook.com (2603:10b6:610:dd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 01:22:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0%6]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 01:22:03 +0000
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        kernel@pengutronix.de, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
Subject: Re: [PATCH] scsi: hisi_sas: Convert to platform remove callback
 returning void
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8fy3g2c.fsf@ca-mkp.ca.oracle.com>
References: <20230518202043.261739-1-u.kleine-koenig@pengutronix.de>
        <yq1353ch738.fsf@ca-mkp.ca.oracle.com>
        <20230606154607.omxmmuckgpzuwm4c@pengutronix.de>
Date:   Wed, 07 Jun 2023 21:22:00 -0400
In-Reply-To: <20230606154607.omxmmuckgpzuwm4c@pengutronix.de> ("Uwe
        =?utf-8?Q?Kleine-K=C3=B6nig=22's?= message of "Tue, 6 Jun 2023 17:46:07
 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB5178:EE_
X-MS-Office365-Filtering-Correlation-Id: e2bb75b6-ebc1-41d5-9454-08db67bec40e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6q2q4EsrQn0MCwoZ7bgbmW4QInXRN6yJ3L+pOnYni57YFnI/m1QkmIpLhq38pnp+BM1ab5vk8GJ8e1gJ1UcsbDwNevLs1viMQWV3yKWA9lizdu6RymgwMuxUbY4KtdCxccmsMiMhtB1TbQPpr2i3EyMwicgWzzT8H8tx1e+M93dqUuiU/kxdQpiRYS/j9d4CnJCa4DwJbJ8BCzmmesDub4FZ4K5/YkQ2q2jQ2TfzjsT9LSpxlurKYL6yWel8nCjCJJx2fGQy0xX8eovv/xews2gqjgMLFIE1LgxF62K7g9GNXEKASykY2ZEQ6qJeK1oAnZ4212AxUQTaUOM1Q1dtHewOOPWbYUymUWq6zNuGFruHgcT0mAZ53hGWda21QGKsBerpHh3aY6KhCvOTVX7lwgcsUaYdh8imRfCcZOuXcRMkhYqQDHeHT2Cy/t94g17GoDIFvNPwNb59je+fHhmtAn655JDBs3yuFsp0KBpcGEFjImNQZ06NvxN9AktLfu4OEZNIvmRP8AhgDpXf32fnL7JS4FzkWPD+rrNfGn/aNXw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199021)(41300700001)(8676002)(4326008)(66556008)(6916009)(66476007)(8936002)(66946007)(5660300002)(316002)(54906003)(2906002)(4744005)(478600001)(38100700002)(6512007)(186003)(6506007)(86362001)(26005)(36916002)(6486002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2sZZTpRCTiqBTcAC9eqQ9mZvpDGmGjB4nJxUzPQEcjdlbKV8R8oD+ldVwwE0?=
 =?us-ascii?Q?mueRiJ41y8zkxT62IS5DOscbBLx5NZmr6fWUK+ODgQJqSQdSQLFXuiJevUsU?=
 =?us-ascii?Q?7fa6hvRibanqe7jRCJHjjVsy32evEpec3Q1uv0wldl0N/Ll0HP6G3wXn6IS8?=
 =?us-ascii?Q?HOKxiexmecJvnp1U7igJeYvKdxknjW5eRiC9Haz5p/yCt4qr1lJRsISCivcr?=
 =?us-ascii?Q?NCIIwSkbN5xjQFf8gWXNUiShj2reUnDMlnizReW7AHNby3/lecBeYxumyGlT?=
 =?us-ascii?Q?qdA/2bwrQhcNs7hwVrc5TZdK8060bspO+qlkb8xL8hd7SC2lTIJwx9HVhHFC?=
 =?us-ascii?Q?/nvgnY8/AO2WWkCVJ+le1AuuhDxQNAvkK6uxImpLWqadj3lrYhxZUBCOvBcx?=
 =?us-ascii?Q?gPdaTK/jU157VOVfmq1puzVCM1h8qxkaLY+iX4vdwu9WMJAD4SXGci5ZX1sT?=
 =?us-ascii?Q?OPQoYUJQ4gKHpzWhAtct3bWG1COBDu9eb/uiAJ79LqKM34aHDEGGj6rt1IEj?=
 =?us-ascii?Q?ellRYxTePxHsZ+jTkCkXsh4slQXhBRcB2AzqBr8VdnesbHEVwSZmTrKq2UCB?=
 =?us-ascii?Q?GrUESEeT0KrQb0ffosEh2wyDIsfHxBltNsZ7PX81G4NtqOaN/cG0aSxhJBtd?=
 =?us-ascii?Q?vd0MjhZ/2CFG1PJLo302iYppdO1sWsqOQtHRCa7YAHwb71s6P/+lyXyItSh6?=
 =?us-ascii?Q?QjtYNF8BevCkj9PklcL+6vzEh4DdVtWNXECLt8qmGpUN5F8tQnoineTVXvU+?=
 =?us-ascii?Q?E20+IAQZwvK8AjJinEtEVmriYWdACXshYkpM4adpCJq1mi5i3pdZ7EItH3vq?=
 =?us-ascii?Q?chLFt059jKRu2+y5v9D6iUnLKQch+U9Dfrif3b9fwejSFG8/1J8DoKpsX7Oe?=
 =?us-ascii?Q?Z60dRIi1psAOdTGmfSPTvVejTS7oHiBOR9JIMgMEsRiAMqBkT9fxx5OKeqrL?=
 =?us-ascii?Q?9muJPfYhEGZm3IYSmNxYvkpbvSOY/aNYSXLcOBpkVPm7nX7j+5tgel6ojQRR?=
 =?us-ascii?Q?BNgiWLz2QV5gIyPCImbRltfqMwfcWoff17182Ytrt7F4bH4qGusf9UKF+QwP?=
 =?us-ascii?Q?NffzkZAqJfY1I2mwvSFTe2aZGMGnTt1rZF1pkJQagPLEB/BgkHtw2ej54hEP?=
 =?us-ascii?Q?KyYuV+qsdicXjyXhBV1EDgTJP3hvTOO318PNdIMYCOltA2CxxxXNiMtQKTD7?=
 =?us-ascii?Q?XVdD0GNd83tBGYyQZ8DOWkbz4udM5WkneAivKPR7xTyeSTyDtSzTLfY0CHmS?=
 =?us-ascii?Q?7rAP+WLS/UxuI/FNIE2CEGal+yGw55fCM8U7pLIELVIpcJlOzzFor2/vZMME?=
 =?us-ascii?Q?mQnT5jQo1j0EyvOiMQ0tAgimgZI1P+/C/v20LjdOiNQfOFliJW7wEbDTgDwA?=
 =?us-ascii?Q?PaJuXH7d4tw+Ti3vWm8wfys0A8QEAPt4rvLTK5VSPTb639pwsL3DsczsHI/c?=
 =?us-ascii?Q?cgkkUgstDU67yGrBKg/xJJBwMS4snSEnTSA21xa5IrMgA4gjfRe4XBmdLhBO?=
 =?us-ascii?Q?bV0uLFoRcPvFPNnFQTac/Tdr1KgYJ/TD0D+IrViZPr6QggDs9tYv69fFhTPr?=
 =?us-ascii?Q?8KJ2RM5UG5AiTNjJNYhzqJCrOJnOUjrgL2MLQQ3m2b+o9on2xM/7Jl1aQfzA?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: RPevy+LQ1R9eShi2IxRXvcbfCx2ilLd1S80/VGTPxpGJ2wl//0ysZlBB380wJyc7DcjFjggel1uG87fLUBplayFf9tYFCAdKJMlL28cnHM/xyPT4irLXUmlIIolp/Z8YOLrBneLvw3V5oBlOi0NE5bhmcvRLRZnKIqE9ZMaD3ixSFGyFAqxZaanZ/sHGEzBSvu3MqExx4RwEjAXGe+fLhY/jSkCWdx9AiZc1dXSJbaDIpF9naOS3DhcspuOFtV5p0pQVYUsEsF/XUBvlMm2sNxQrCVuvJiOwnLzTU//lm2A86ZVyc8/0+37yXD0CcDov2yik344hg95ABv+24/caRDrlw5pJpG2xc6TSCXvVNFWYpJkcx2UETfUY4G343lOaOYiYO9rOSwsQXICCIWsQJU9sXG2B7kNrw3ZjvOl4t5CbH9xPcZiD4hjwwXYf6O9HGTk8MIX9RJIS9rK5qchJpIFdvTM6RYOz6sgjdfecBhZiSLM2P2ozVzJtu7ZOgyMQme3RLGqq0cDIYd06ufOCjWjUXa2hCHfN/nYEeWyWcpTd4c9QHNlSF3Ka5DGzxCsrsHJwfF3ZCN4N/xc3VHbrZDA3C+cN3m2g+ZKNNrRneFKddBg03vowiEzrxDPs13r99KoII6WKS4EO9XE01AynIVHmPXnWJ3VWqBf5GE5hKKn1M2o2InzRWG400J8djA80v6tuOMEVu/YrAeu927zYTrXs7eILj39R4A38fboPjT4brJosYfFdYoX1FsSxiMOuh/3I+G7oHzIeBhH1mV3S2q9FMKdkh8nkdiZ6TUXBgjiWr9/jl8z/MCeKz/LS8op+beIiy1xHN6pLi0Pj9bSypjjjt1IcBld4bkBAR7gPgtYzuc2O7FwUxd67cmWo+GeD
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2bb75b6-ebc1-41d5-9454-08db67bec40e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 01:22:03.4821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YhdMHZO02hcLlOu+4RnqRbMKFro34LECsyRCW1DgdZZ4uHORTVsTLYeRCsfQwzJxzuMwa18c9bkZo386uhYSWzrmg31XfwpwGq/lV813eFE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_13,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxlogscore=968 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306080008
X-Proofpoint-ORIG-GUID: NkVzUnbMfargjUriAchDVomEziarp-wV
X-Proofpoint-GUID: NkVzUnbMfargjUriAchDVomEziarp-wV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Uwe,

>> Applied to 6.5/scsi-staging, thanks!
>
> I don't see it there:
>
> 	$ git fetch git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git refs/heads/6.5/scsi-staging
> 	From https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi
> 	 * branch                      6.5/scsi-staging -> FETCH_HEAD
>
> 	$ git log --oneline v6.3..FETCH_HEAD --author=Uwe --grep=hisi_sas | wc -l
> 	0
>
> What am I missing?

Must have fumbled the key presses. Sorry about that! I have reapplied
the patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
