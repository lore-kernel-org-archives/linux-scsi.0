Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5532FC05027
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 02:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbjAXClY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 21:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbjAXClL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 21:41:11 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B75367E7
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 18:40:37 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04tDO020240;
        Tue, 24 Jan 2023 02:39:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=Slu2TdSwkFTjtaFO/tBkyRptT5ktyfe+ZGpA3TzVx2o=;
 b=i8XZjJ3OCHro8iM9YGnUD12ITvo5fpl4Hb0orgzSAYGQDYZ7Aaa0yDUNDjCnK+QObItk
 zcnPnkN0GPDfb+AvzAQ2gNa2YwQfO9yfAfaAjdmFDxQOkfUN5o89QLduZAKgu17dQfkO
 JCMzUr0K9s3Ni7q+/+Gud8/MsKf/t+EgJAxk3PZ4pLs6Nx0wCDdbBhf/6ekRy2CAVTiG
 Kx3LYiyN/kHN15R1aH9AbXvsvCuoM5CdOUPl/gmwvTsOZFEUsu9cPqr5wKsnCHbjP9Le
 xL/zosHVyoxHvYVlGEysaC/FNh6wWtY+d5T6MGRyT1nU0ALHdaSMKQHHjI5JGKUcpHd0 XQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86ybcd84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 02:39:50 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O2ExxH023258;
        Tue, 24 Jan 2023 02:39:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4nnhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 02:39:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZ8TJdkqD/kIPjHEg20mJfcdQncrZ8FQFkf7a45eTjuvmaoXFyKy/wHCiXlNyCOUiIGim5VYHjr0jbu9K/mwrTEjqn8e0p+hKKTh/2NFRYcRH/zijPNYV6jZzHtKb9A/FItiisaewu9ZT15xAmn4SsH2sw1+Z+Z/+rJcVWJB+8W1b1+iiwdrBh//XUg0NTHB0poh6hSppC3+xeICVk0Mme9zKsleCm/DL6OMSuDeNDhZB8xaw6uPbrgcofcmYLcN+ARC8I/UgaiuyCymNV0tBfoK/q/CFypUfl9wFlM3Dov2ZyEhVrX+nC+fzRQ2nA4LaFQdTpkrCxB43m5+DLOO+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Slu2TdSwkFTjtaFO/tBkyRptT5ktyfe+ZGpA3TzVx2o=;
 b=g5N6eDbzzc/GhMkVNFU/YXMwCtB0cO5XThK53cOiuWIwui6qmdxqgsRRQYLoh4Gun6mSSq3aWOCxIjkxIz6ij5mDyXFUMGxGjKFf2Jd3HRhrzz8MxV21lyuft6OAhOwen6GVbhaB/pQMMJ8ki5bQ+cc8Yhnrf5izL2gUx5fZGto9m/6v8JZb3w5xG7j2apA2J0WfAQtX0asKHBuUF8PnMe4hXqLs7C8aluBIiKXnkHVaVm3/KGy39BfHmi83Q8MvylVxh+UXk+jbZCBb0raA2AAO5tKTBvs5/RQXbuqcrWCVpBn5Uhwrb3u6ahw+PDAbmfqM3ccNwAgsuRgW44J3Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Slu2TdSwkFTjtaFO/tBkyRptT5ktyfe+ZGpA3TzVx2o=;
 b=eXBg3upxaZnsCSmMkTF3qU84/frRMFTXZWqg23QS0T0BKq/WgFaezDT8GA9SSKX9j5mFhNiUzD/7a6ON9ynycAPjII/TDL0BS6RVmJCZbzrBU0RZfXiL9iYDtrDvXaE+5l1wvjhSB6K72/AeTZDgdiQBh4lSs1DIvYQ6HbbJ/vs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN6PR10MB7423.namprd10.prod.outlook.com (2603:10b6:208:46c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.16; Tue, 24 Jan
 2023 02:39:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%8]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 02:39:47 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH v2 0/3] Enable DMA clustering in the UFS driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15ycwmza1.fsf@ca-mkp.ca.oracle.com>
References: <20230112234215.2630817-1-bvanassche@acm.org>
Date:   Mon, 23 Jan 2023 21:39:44 -0500
In-Reply-To: <20230112234215.2630817-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 12 Jan 2023 15:42:12 -0800")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0335.namprd03.prod.outlook.com
 (2603:10b6:8:55::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN6PR10MB7423:EE_
X-MS-Office365-Filtering-Correlation-Id: 27285bd0-048d-4c96-ec91-08dafdb44234
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xwLwPV8zlIqxjI7BuvZI3ksgOWB1Pt5LyF1gvsw1Rf20tnpXDfRYaELllnA/Aim7aLBvo2SBPQQ4BcBgs+6iI+mYLmrB9ojReGJyZV3Q21IKsIwI+EpI9TvAMxGPi72oUJz5YGLKETOhUrHjVBtH3ylS5Xy6e09SS9LlTY2X7x04Vy82Ksd/JRp+Ve5VtrHGDOXnZh4u/Y+/NeCsZuEaQMt4imiaLQcc7rt4UMrO2UYHD/CQM5IgF0RLp3K7vV2B2RU35L3QuSFevn5tTT/bY+WpOZodFhpI+aayfEsDJO528A4rIj4HQ31GG2J+tTFEcdaexOAdqCZqJHEZ+tPio4/M8v7e4tXcp79LxQeOf+v6nnd+2WmexQycFpU3GanMsGnfhXLT0aOtAogCA4uc1KhCC5HiLqmzv0zX91k56z5YMWQaXRoO7CBuUiuBSH/JQ0kgBP7ukiO8b7ZPxwKfxhjW8WopK7DNH9REYFrzoUedxGwaZQBPu9Idvxw+DVB1xGbDLCGykZn3mtc7xA1nCMuewL3jkiUbPJhGGFsoGu+z1pb72zHMPhZn8q8sUhNYpJ8omUvBxbsYeYx45Pg3CnNmIZPKN3lGSKcEM+SqVcsqi7vU/L0STmIQNcoNW2udKG4+MLV2ITtxXiPENjjqGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(39860400002)(396003)(451199015)(36916002)(41300700001)(86362001)(5660300002)(8936002)(4326008)(2906002)(558084003)(38100700002)(478600001)(6486002)(66946007)(6916009)(26005)(6512007)(8676002)(186003)(6506007)(316002)(54906003)(6666004)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ODFNqnVlaUN4twSuEdQ3mmIWGwVb9NKW8Qq/JLTWU6Dcf9KRym2WgF5cOHU0?=
 =?us-ascii?Q?80zVLCIZzlbbY7CToWqL+3xzpQZRYxfi+fl4U1NB+/nDKiSPscHbomTQYvOj?=
 =?us-ascii?Q?ohbxA2xOI2u3MRSaLoT/KPiusAz9cNWf0t/Yxo8KxEbtyP1fPyouf3PIy3GW?=
 =?us-ascii?Q?aP5aCoKmIJjiPNu4frVkxBXfbXRSaZ+cGtKpKeT3RLnDW8/VDWLtAPBoiopH?=
 =?us-ascii?Q?va+qx4VsyXAyVT9m922kS1H1iwuyeunZksubHtcaavsIJfkoZYrkXzdDD6k3?=
 =?us-ascii?Q?IRlXmP7ryzUnZuCyn8UXfNJtymPoNlTD4nkErG02/I0qDNHb5bHcAGc+EjGR?=
 =?us-ascii?Q?pjRXb5d6ibW2aTbZQDbpIWEG/XhbW+vAni0UTBqdlNB7rbVZJXpVRVXbRPch?=
 =?us-ascii?Q?WUHjWEnNt+4Gv5RgIsAw9w55/4JB9/rmsh4O/C8HFGPQZd061npTNdMDGg/u?=
 =?us-ascii?Q?kNOECmhtoyK7TBKV0sm3Le0cX7s13NG4iPdDRIwgabnesX26qkaXM9/ZfYOV?=
 =?us-ascii?Q?ZMDS8OFLdFASYU4Zo0rONGcVfX91posOGfSSmqtfwlnR4olHIB9UFlh9eoOs?=
 =?us-ascii?Q?KZU9p7lCyWqpbLsG/kbNcR5FTV5yUVSXi/8wbhrkEq3AQDqyKHlCyNMwQoyV?=
 =?us-ascii?Q?F1XnZKB3ezVuz30qZK4M/Nrn2Ur2pTqTejOUPmbya3ENGKG3rFn0FkJc/WuL?=
 =?us-ascii?Q?OuLB1sgoaZbEytvO6hkqcQ44zDoJ21Qb8frSp1gFXdg2waEJct2Fo4/tRM/0?=
 =?us-ascii?Q?snj8e7ZjjowpyWMJc4M7ZrVPlpcgzHxHYtVeqdVWInEHbEOalm+3yLptTWvI?=
 =?us-ascii?Q?wph2//Pi9mnd4tQSK1zxh93jA42svgDNOYPFMYX3eRasJqRTVLy7EnkckaKn?=
 =?us-ascii?Q?jbfSqPNAAzgbA38wVQojioAT+bDWt90uNpglAPz0IgzLSul/L3ixdocIO9Er?=
 =?us-ascii?Q?8QqSmidlL5fqUi2VLy/V+Ed2r40KQsxkeqRlM4lIFWF7pD9aFCjTtOXqvQQ6?=
 =?us-ascii?Q?plmdiartFuZYDQ/eUxPX2QrhSNkKvJnp0jOGn5W2ylZJZ93bI3alGn2m98xi?=
 =?us-ascii?Q?Aqm3WyZeFv4dVCmDV5xUHlzAB1iy3Wq94OA51Sw1ECwzckTW8UCQpMVKBEGd?=
 =?us-ascii?Q?LUVuBjFV2zhJb3fn9v7DVzQzEx7LW+WRFFzhFSsl9DNK8HuIiLP6N58PxJ3Y?=
 =?us-ascii?Q?ocSDPoXyWhZxC62dtFkvCkIPEytClyEuYFDUxpKkW1975KkNz7B30erFq+Iv?=
 =?us-ascii?Q?p7dnqjW/KpI13VTTZjp7hf7itdnPwKVRiJh9GiGawFJ7uOz0Hk+JaEDwnNB1?=
 =?us-ascii?Q?OPg/NSaR9itMLlAxgGUNoXfCxSZqxNfXsT4ow+1H57X9VSgau6pth4m5aois?=
 =?us-ascii?Q?3WdPVPX/vpORLpRS34ItlrKjqyRHwx7KxKpMwhfmLULAYcqYv/67N1YQFFPO?=
 =?us-ascii?Q?2zqZDWSWouTkxn3mKt8WUaRSOR3J8BPymrKV1R/fLTDEN13Ep5BnVz+1AinX?=
 =?us-ascii?Q?bl792xLt9oAxkY9Nhl8AezkYzklypM/C2twwRtLQaFf1FjBFqgV8cneqfbO6?=
 =?us-ascii?Q?hOscqN+rbThHiWtnVTwEz2wibyPMebVuV7uaMZONwi/1kV9fkWoA7pSg3NYY?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: fEoIsUktYiu3jmdNU+mEXcgZvECe6Prigkq/JQM9TBfpYQmGGV3u3hp2Lppp2LJYHRbb9bSJwTwajiYu3VUiC/qIA65KBmEfrpGburf6a8WoZ0i2ZBZ+OOnq1P/Y6w6x+sPGxITHNHdS4eTDej6akkl7Q9r4NW8Ff7eCYduXgYyxVw4Cv0TlrXSbGc26N2eBH4wttdMz/YHuvjUPJmMH49z7+lYRXB3TxV0Ibot4ZPQ+a4oGZtliissxTDXvj0MAHa4ajdsTPZi7hkeYPtp/u8rGt2savaT8Mvq0kk0mbA3+YTYYyad6oXAihcdx6hQC1FvuSwvA5Bf6/jDqi8HIFz4RpsIoYpeKQKON5k7Ont+9Nix9d6GExISMME3kWCfPTK3+Nnp8xjujrG8l8DrjZEqO83+pcThRjujzgb05A8Q655Sude1cqSfqppgEVs8J5ZZJYWbhvCGBXECQQ9XS4us0PkT8RUv4c9QTLD9gV9N92P/64ClSWvpRaaOr7FMF1FipAYRU/nduBvBT+abAK2t5SiW7rj599sDb8kQlYt0g5mdqCkuJqFYiGmfXyVOUrmRil4NX7SNqDEKuMf7rj7KWTAWn4QmrnoYhLm1+urRUYozTKqeKgnUjeV2mIBjeFvPHTG5KokHQPPJiDX6duBkAi4TQJIjJAQ4uUEORwS/kB4GH4tiblmcBLvJ6NHit0bJ6bDNK6yItXbrWRQjii1m8ef4cEGiVhp50N1Wx6KR4JUfo4CCtDxqtqtGwhixcxq4Jf1BRduW31iuVMqleMDxbmiIpwDZSNQthDQ9f/CFGVCv7aXnPzYHtFs9u38K2POeQ2w3eaHbXv6mILpzjjCRZrLOSzkwXjWd24jr8HgmJ4JjKsXgRdNZddfKhLJdc
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27285bd0-048d-4c96-ec91-08dafdb44234
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 02:39:47.5395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y7cl4jnJDV4F1sLkfPADKTqPmKNqvXuKU2iv8yJPrQur0YFeDINDKm6Tm0qDx2M/3ptgoHze9IC1SQJN528wL30GcY/YkPtuc50GNjAv6t0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7423
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=697 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240021
X-Proofpoint-GUID: Ldmk2kHfsGHplM7IyRlM6bJJPqf-GU-k
X-Proofpoint-ORIG-GUID: Ldmk2kHfsGHplM7IyRlM6bJJPqf-GU-k
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> The third patch in this series enables DMA clustering in the UFS
> driver since UFS host controllers support DMA clustering. The first
> two patches fix bugs in the Exynos host controller driver.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
