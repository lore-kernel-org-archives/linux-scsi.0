Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62DABC7EE23
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jun 2023 00:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjFAAYP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 20:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjFAAYO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 20:24:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD594124
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 17:24:13 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VKBU36021994;
        Thu, 1 Jun 2023 00:23:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=1jP5qraQKsVE+vacpS+sXx4FFCmp0gU0usQcCqy96o8=;
 b=njXlVn5kmbq9Vn3H7yXMbWZBAmlBgjLBdyqhUeiBH2iz/+uMhMFVE/Lv4UeFIuZwO1i5
 RwU3fP//S14araHxZhxIf2FZw6GfPzYKp322m+NgVCS2DdJg2aJM5DM1twDnkNV0IUL3
 nLj65gr2y6VKjOXh2rxVQfr06+dY6RD5j7JLqZCBkYEi15R6snzjMW0NpeIu98i3DV7U
 Uy4DYvYKncCJ2Pw6edLrUmgrnzCdpBWqVrMA5EYiBJSqFp6FSuIuMJE+MK3fGRWsVYOK
 6Ln7mIk1mM5WV64xjaRfUozEiBC3HDzxNGOlm8Uk9wyUrYdhA5zECYXi2EjxL4n6TMF9 MQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhmjqbuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jun 2023 00:23:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3510HNCe026045;
        Thu, 1 Jun 2023 00:23:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8acygby-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jun 2023 00:23:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvhFos48bVd3hWxwY5DiyzACHdmvMGa/Kn1F1LkiM9c/NVqqP++2Isik1AR5D9ru1W2s2yiyouMbF93RFoSzmZiChD2iXGkm02Lpqbkh3MGt3APNU/jup7A3GQJ78zEN3tJ/JgYpWXtp47VFnZ8VVJ04D/Z/n1dnxaXpnj6Q/q8aJ834PKp14WQaz37sHQ+WmNdfnh1p5ZkqxcWinXbWuANHvaow7xKI3rUj2Z4EglOBeeQk6ODsIjLxKZEc7gasW5cTpNAmGjly8WEpPwhtaDXOcPYyuc6Ml7GboLbVu0p1Z4FsLm/theeuQw7VVFu++wkWpIqXtn9rSRkLp3euGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1jP5qraQKsVE+vacpS+sXx4FFCmp0gU0usQcCqy96o8=;
 b=BRrZMI+xe/rAw/dFyUIzEzdLBsrjpHIcZ6+/x+9sZwsjO4kIIvfUHErfSyKPv/QQvimAfI0Vz/O4F0u6MVDaFaYzdr2SLikDszXBGhyKA/anp/QmU1hgw/6Jkm+W9YIrRa+aeXLpFLouJJT9hWTojcQzVqftNKLat4S3p6voNp1Y/9NRUj2ZVmOg3+Da8S+TyOl8YzWr/2oJRrNphw4Kbq7pzp0f3Vk6dY9OOylWmANWp86zHMEmYKQQyj23pTJciSpMYWeFvuxdJ6UNfo7CB3hWcRf9bEFTsx/ldnpXeMDJ6harcBreOw9OIEpIKF0G0IhtqEKdnLTEX3BAm4lSfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jP5qraQKsVE+vacpS+sXx4FFCmp0gU0usQcCqy96o8=;
 b=T6ySlfxvLfGZpzCxrafDoGuDdafU+nY5UVBHh+m6O+To07tNQISp0JB9BQKN9npCRBRQaXvwcRtl/tMgKQ/XpZlZ0OfXMxJRDr2ndPWYLFdw5yfPqAq4h202dYldnTloPwhRE9judamZQyBqjSHRiF6VHtH2SHr2ACfJyX7puQ0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH2PR10MB4152.namprd10.prod.outlook.com (2603:10b6:610:79::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Thu, 1 Jun
 2023 00:23:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6433.022; Thu, 1 Jun 2023
 00:23:05 +0000
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc:     <quic_asutoshd@quicinc.com>, <quic_cang@quicinc.com>,
        <bvanassche@acm.org>, <mani@kernel.org>,
        <stanley.chu@mediatek.com>, <adrian.hunter@intel.com>,
        <beanhuo@micron.com>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v7 0/7] ufs: core: mcq: Add ufshcd_abort() and error
 handler support in MCQ mode
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17csoav4y.fsf@ca-mkp.ca.oracle.com>
References: <cover.1685396241.git.quic_nguyenb@quicinc.com>
Date:   Wed, 31 May 2023 20:23:02 -0400
In-Reply-To: <cover.1685396241.git.quic_nguyenb@quicinc.com> (Bao D. Nguyen's
        message of "Mon, 29 May 2023 15:12:19 -0700")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0002.namprd06.prod.outlook.com
 (2603:10b6:5:120::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH2PR10MB4152:EE_
X-MS-Office365-Filtering-Correlation-Id: 22b492ee-314a-4f32-a4c7-08db62365e46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fnv50Cz0bpufz/f6CKjl5NxB/SZPSBbccTMLq4lYVSMWg9rICs8w8uBQRUUhhvLXgmsfNi1GFj+7RENDCfxGzfahGAYKGvNC6/tH2F2RRGLa1rPRGe8OxhpCTyH5PirMwkouaZa+MIMPLLv0YnPhliHO/pa/r4Mn898asM2eGhUXHmpjSfR4YbA9AV6uSR8la1GHxU4djL7LYQVjm31uwRbY4owtNQsgagvSTFlLu2WQkz47TOB74Lmp0FiSCeCQ9xTPgi8PyMkSU9F0pDn0nq9MQY1QIj7Wc3K1y8VS9NTNGjTsNNLNZk5jObDmF0hBT5mtKwK3vBcvmBLoHIG5bo9R24P8BhX69jgO7PkuPRC2rZNTaOi1O0kyrtWgIN/7TxH2vierCtBxOcT+JYoyglP79FAZTOeGGYb+nQO/rL4FLJm3iv9pEY1dgju3Xpt2AvYC+ofl7m6RG2GBvz3ToT3e0/MCUB/LKjQ3sPTsWWnLJah9ki1Psa0i/6loziErGb1pY/HK3uW8R6RKaXdHn4wBm8Ff8uTOJA9+yUJFlINNIzUXul9Atp1y7IG/aphL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199021)(26005)(6486002)(36916002)(6506007)(6512007)(2906002)(186003)(316002)(558084003)(8676002)(5660300002)(41300700001)(8936002)(7416002)(6666004)(478600001)(38100700002)(54906003)(6916009)(86362001)(4326008)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cg2yfLQjBcc81LjYO3Buj7g8w3z9pKje2RGGhc4MGFvixPYOYQO0NGlUNAIs?=
 =?us-ascii?Q?f/1WnMUBK1zzNoNsAX3Yo6+3+gBXZC1tL/wd6cyCNgp/lPrHHZAS3D1UQsLI?=
 =?us-ascii?Q?URUF6694cJAK6VAX4H6jHR4CvfYigWOqm/9WSI4xVetvF435gkQv65wo9rqp?=
 =?us-ascii?Q?MPifBfEd8FaM+XG8F1vopIfKa1ATU+w3nJNmZHlQhZR/qQY1/kYpYfs6jpqG?=
 =?us-ascii?Q?Oyd70wTjgznHRl/vyBrz7PNygIyu67NhhzoA0BRe85s46nQlKQJAvrupTXG1?=
 =?us-ascii?Q?AAvlt0sQrLLilEA5yOuRqeF/N8HPccK5WtBOPaXioBGCSV491ZrMjI2JSNeh?=
 =?us-ascii?Q?CSmpWjrG2mrxylJuVlZa6VzO5V7pId9HCpcaceMKcStxKH1hGDUfXTy3G3+s?=
 =?us-ascii?Q?OdFPZj992S2c4eLnX3X09rrVhXcKYX1JM9I9jP5i5tvAv8fx7nCvLcteaf5Z?=
 =?us-ascii?Q?QwEu5o84I+Z9VEhXd0OgDR/e+d8CkZF/aJnSiDTQM3ORW0GBpOM6PZUTLU7p?=
 =?us-ascii?Q?SKkauEbfUDARYC0CuKipXOzSrFpUGXvU+vsMUSBZUXVhVG6AV3a7TjcCRT2b?=
 =?us-ascii?Q?3MAxnDICfY/eDlapXFhPepyXfEO66Pfk+ASGDKqzHrymW7/NI9YaSrZuT3ou?=
 =?us-ascii?Q?SpY+wmNruza5ptctLU9CIMFwfGHA84p/b2hnT4iFq0/3rsgNT6fkpCgMoZB7?=
 =?us-ascii?Q?q8BrJQGVi1G35ve94TWa7Qv025NxlEYn6vSj58PDsbxL9X7em7Vt23uweIgn?=
 =?us-ascii?Q?bPo/OMwR87AE0SUiD04G1WNhmYa1RSFeEKCh12n+32oJ6AgsNzVgI8KPmz5D?=
 =?us-ascii?Q?QCsuKrOQviYGMDQNYFz9z45WVaYJDHYFRLMECLdfwNGWKQw2oG6w8vYv9znu?=
 =?us-ascii?Q?inPgcZXif5Z6IElbZ/tL8Iz0aZUjhhYVj8ITRKboMs5KuvIHrmdU8HSkJTYR?=
 =?us-ascii?Q?zXXUrgLTU3SO6Dz1285047nf9PW4npFL40QsLBcIzSfSSLv8r+9Qmj0JSDwQ?=
 =?us-ascii?Q?dEnqrKqybAF0PZWZfC4JTkFZSOpmGcBxWYm5V/M5TOM4y5ZIu+7LEBNDz5fE?=
 =?us-ascii?Q?SIdM3mXZT9fP+W3nIMXGHe4Qbm98GUC4Y3YZhYcM1nWMLLiREu+naOfpvuG0?=
 =?us-ascii?Q?BeVVr+tGvFOU4Tl1uS4Tksk0ipNx4cmyck9tl6KylXJxd03nHmEd/fdTDo9v?=
 =?us-ascii?Q?Sd+vsA73qjko1RxJDEEUhJ6Y8mzeHWsSqqjzc9cUGmT8ruXbeopxWA00fvO7?=
 =?us-ascii?Q?qzLzlV0DVkEGcxi0VGpt7OQuPote8q8QLYWQ7i8CpRLYU/0VnsJe4K4XVx17?=
 =?us-ascii?Q?C9IfVHnTgOlcShWrZPGNC+itgxX5ow57h8FYlRD0tPU3nuPszvFS41tCP7Db?=
 =?us-ascii?Q?qpZR7XoUUEVHs5EzQEgHn66A2NEVWqn6ofkQDTChGdMdtpuuszTtAwGuwRTH?=
 =?us-ascii?Q?FNlJPSgRzUsGPEy0GI00Nd4TCrcHOcZaNAbQRo/lFEQC96G2aUJXVGWzpZXB?=
 =?us-ascii?Q?TcLs3ihlk4KLOEgPeD3ReFroei3yP42PO/nytzwTjBocdaIh+c9X6BxcMmj5?=
 =?us-ascii?Q?Abeh8aWIhYfyyM7iX01dxHwXkr7YfXqfltO4sbT/k8OXsM+lNETeQHr4O8xO?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?qI94b/ngq4qd3uPXZrJIQqa1AWmMo45EgU1ceE3qn+NNwKcHBjsuS6VkquqI?=
 =?us-ascii?Q?nlcxBFRTFBtdn2HGpBFh90dkgTLerWTbihjCNhwURjbkYAYB18a/3Pa03Bjd?=
 =?us-ascii?Q?sYs5CUVdWxIywKzSc/FoqCwDgdzZ6/LZB3k4sCZO7kR8wxHFF5Ulxt+HPhse?=
 =?us-ascii?Q?8GL3Sixm6sjIG9ptofSmyutVf25pQl4o4RC7xfMM+jEufv/++ShW6WnpbpG3?=
 =?us-ascii?Q?D3W+PGEdMq5vYxryh0/QMFy6lzYPbG8m6608U4VSCAoBo67gyUxDKgR+t5rv?=
 =?us-ascii?Q?H5HWo4GMl1t6Egt/2eaJbHva3yWwTk6C+S0YNSnttLW9x0rqqs3kUd3gai/+?=
 =?us-ascii?Q?PCUhzY2MtYIKgmqVoIN2+dqyNkbwz/fzD0NEI9zujJEimk+jyp8vS+1eWgK8?=
 =?us-ascii?Q?d+Jr0FZ3sKvjVCD8ngXYi0wAw2uNXI/xCkGdudB69tT++KVf+Itlj+h+bwyz?=
 =?us-ascii?Q?rKgOOnHQKNMAmgB2/ketnSqpp3f4cuWzIhZlE7SmfcJNHIyryQny1+xn4gY4?=
 =?us-ascii?Q?EVNafTWMeZxemV2eTGgPs11cFscHlScGESQRc7s+qtS9gZ4qKdpdaZzTJOle?=
 =?us-ascii?Q?eqGOrJ/qjs8R1fXr0zbvvY2NFLf9mmUwA7ONG94fFvagNuYJiUmdBBfhxfUu?=
 =?us-ascii?Q?Df2eM62NyaruDdOEcp0GTFbb1Bn3odJirwvDU1K1vGh4A9X689VT3NUXYh9z?=
 =?us-ascii?Q?Jj26HKneLVYrSSeMGZKRwPiBAn6ruIGkPML1ayyf6j5QG6DSLf3YosULoQy0?=
 =?us-ascii?Q?f0pdoS1LDR2Ol766kltBPa25c53MzP95eE4bTVaBNCur9W4pSd82KTKRxOst?=
 =?us-ascii?Q?mUnV6yOL6bxphRaZT4GuhuGswqjELJ7ufdvKgeOboTGlQBkiMRNXGSkTJjTT?=
 =?us-ascii?Q?4442crkNDockjal6eQl91FRS0V54cPQsWUNfpkOTDFGabattWfkAAR31lt+g?=
 =?us-ascii?Q?PsoAuhFrUPuHHV1lLHhkLA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b492ee-314a-4f32-a4c7-08db62365e46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 00:23:05.4058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8hAsXwG9v7A15lrspCp6RQeYCcJB+NdvnFOIXbH8JdtolDKOJtUoxT3oXcGyJqnxB+0f+ZneN9ISSTr1lRVBwMIvv0c0dXhNxry9duUvFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4152
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_18,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 mlxlogscore=509 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306010001
X-Proofpoint-ORIG-GUID: lYPmPBABtsEp0aGfrtSwIri9X2GR0-WN
X-Proofpoint-GUID: lYPmPBABtsEp0aGfrtSwIri9X2GR0-WN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bao,

> This patch series enable support for ufshcd_abort() and error handler
> in MCQ mode.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
