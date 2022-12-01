Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E50C4321E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiLADeb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiLADea (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:34:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7986493A44
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:34:29 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1297c2022961;
        Thu, 1 Dec 2022 03:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=lSYETm+bJYMNrX3DcLorifpEZ2QRRPtt3+f8Uz6TfA0=;
 b=qdUHwku+wrHa8HcKK0FJWOEfagTINzfSo+Sn86LB9IRnsRBg+b1yLv3dC96iLQAmdH6j
 70/MQBgBZ4apz09rzs2Rg2yl1br61NN9ze7sQHGhYNPdE2aAeqG0fw85czwTjYy6DyPj
 kCin1yos/r8jvuXuxofNju86XShgN3gjrHyqTxHGEs32pZdhZ11XQmP5mEwRs0yqi7AA
 6H6mm2GguPWmUG1HIk49s2wt7/VHGQDA4w+Hy8zKXDQC2b3RarcZxQpSS7BYve+Nus2u
 pCbtrz55hSHhm+/z9MhYAaZ+nKn7O+9yXaqDvW1vOwSV6O7/z4pJVsl40EybFUnq/V7W dw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3xhtbn8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:34:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B12omIr000494;
        Thu, 1 Dec 2022 03:34:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m398gmat5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:34:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4TMkQehmeR5O9LaYnAlVhPJFpUn2qtp34nBCF3gKyI+YVHXxDcGPncRT/L8q0uOS/VlFEzJ5xPozv6StheO5Q/08wkCP/7s01xKMi9sakEheb2A/WbfUQK+mm27wYazaNDPvVQMRYsTNQg3FjkVr4rQECFm6vHzxAHgpjp3kcZ9i/IVG2SMpxLoipfoPrOog/2tEmI4cYrY0eiTFp6LjL2nLke/130Fz06Sf+CeEGu0rEDZpCx3P/W9+0Cgrty/Px5syZraghxkhu50cSW/bRW35bOUAU6WzoQKfh4nLrPZ7fJmQTYNbXqS8m91MBYWlIwhOsvkpaBR6JmvL3Aj4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lSYETm+bJYMNrX3DcLorifpEZ2QRRPtt3+f8Uz6TfA0=;
 b=XHseDLO2oqup633wKUnkG3J5v0BVXpSiLGsqWJ0pC11CdDXHrKlABbjfq4gqgBRedgpXHv5X+crkJO7bkVCk5PuoiO3sjX8uRKBwkLAXc3uKqq1xgdFy5J0hXGCpBmfQuzcIFvWlTDvJMrShTJMmsmrksIYZEsXIfAivVw9tC5fKSjBb4ZVSOfLH7Wx6vi9jv0/hHWW7Ey0AzH3Cp9tkJB+B6ut/aIRr5/RIKMhbgfh0YSqkWCDpwpemm1f8A14XVM28I2jhLtoSemDWHdtVWMnVuK9wM+0vOjAqQR7vUfET+iC04n9lQ+bByB0kWrN1m73XH+zNKIWi/H3AoUpPFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSYETm+bJYMNrX3DcLorifpEZ2QRRPtt3+f8Uz6TfA0=;
 b=vS5ltFJE+EBVDkTn+n1e5nMUX6UTez+OAnAYaMq/x7gzNATrYQBI3MYsN6nErJLBDl18Hyoo4u3kZLbldzOWKg6CYgqywutUP6YAAlZaiJRqonXYSz8QA9cizeVp7/95veitdGl3evZ+/Y0n+FsnPeu8dIlfBEYkQXt3aRZ0Fa8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4315.namprd10.prod.outlook.com (2603:10b6:5:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 03:34:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5880.008; Thu, 1 Dec 2022
 03:34:19 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>,
        <mpatalan@redhat.com>
Subject: Re: [PATCH] qla2xxx: Fix crash when IO abort times out
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgc7iysc.fsf@ca-mkp.ca.oracle.com>
References: <20221129092634.15347-1-njavali@marvell.com>
Date:   Wed, 30 Nov 2022 22:34:17 -0500
In-Reply-To: <20221129092634.15347-1-njavali@marvell.com> (Nilesh Javali's
        message of "Tue, 29 Nov 2022 01:26:34 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SA9P221CA0006.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4315:EE_
X-MS-Office365-Filtering-Correlation-Id: 36a85999-7ff6-4c54-b752-08dad34cee0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GbeRhyLH79K09fx8RwAHCPStbFDNsiWtpPpoa+73GzsvTYS/x1/EjetlunHOTSG84P42RQXq+qVAMes9Y8iQs0o35HgoteiTR2ortdNgSsJ8udf39f0VLf3y7omWIZdPw2NyK4CWcQxKBQ7Qa4l809xFRoDpWlXPqz2cz8fFRclgdZ//HIuhYkvSrd7reSSqh7e303DtR2l68x/89Oz6iaWt6nSZAb/YEOE7hxsPR3HfMmy8LjvOmG9hM2kp79IxJd6Egd0Nk6T24F+ZyGXL+IMqvFeS2v14OKBRyx+vKyUhhcvNnx6QixebrDFh6dApJPu5DDaPMxF10RWv/X2utrNIl7ZDm6miyyK0rk2xPQVKHDFuNUEhM3f8Ex+XS8tKtTeGQRfgrMGzUbgwtm/zpEd5ebRpjrCRWjP2H+/epA2CgI/Ciw3s5hplEsASWhTO64vojhUvfpjA4Ekii2Jpkb0XvC4NsX/eJQ1+EZ3w+yCciEToOlSe/FP3fpgcd48ZuNztagDM7I8QR3VmkjlktavXsbdposu75e9Yj6AmMf9p2NOnWi23WhZkc3vFn28W06hoOpv7wqvd2wOuNycM/oWlE3TAkDzHx0sd9yrUNzpey63xCmuCod6iTP1rweUzIDC/YgjPxzzo4+C9U4TWyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(86362001)(478600001)(6486002)(36916002)(2906002)(186003)(6512007)(38100700002)(83380400001)(66946007)(4744005)(26005)(316002)(66556008)(5660300002)(6506007)(54906003)(8936002)(4326008)(8676002)(66476007)(6916009)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KkMImV9h9E8sRReFjB+/wog2EZGhUyy3iv8eXjqomgMM+UbPknAqGxI4rVra?=
 =?us-ascii?Q?kdsMBEpPcbICvSXRq/I4/dYjojz99dAKIdyuob6n4NkhLAnPUZAXeI3+9nbi?=
 =?us-ascii?Q?wvqov0epxykwJRz+2I0JJfE/aCKb0VJmiFU+u3BgVZDLFb+aUdI+9Rxb5u2w?=
 =?us-ascii?Q?ZKgsxUZ6gNPxoXTF0I3T0gKD3Zklb46nN2FhfcxrV+tQy/pw61CzQW26YyV3?=
 =?us-ascii?Q?wlHaxL9B9qs90mX+fwx8rbm0c/+V76E70yoDxSxv9EqL+YMjCJDQlqbZ6sK+?=
 =?us-ascii?Q?R2LkLtnHbv8g4ez2zJ9iwrxP5c+IH55q6sF0/Si3c3A1Wdcd3qL8gU1hNBGr?=
 =?us-ascii?Q?gv/daNuRHaIVdFiakn1Y/4TvB0rrI/Uol7k5Tqx6DNiD9sLnVCiIY69c9Nas?=
 =?us-ascii?Q?65fBNsZXkwZ0tultIKU1NJJk74baiJd1nEHnBpwC/kT7ayXoBCM3C9ntVbr0?=
 =?us-ascii?Q?p4QNm8sncwFerkQ6YoBU46fvzxgc9U1R4ui2zZxUyXIcELjdhp9v8Q7SQm9G?=
 =?us-ascii?Q?E+d6NZzQ3FdEQH3u/54M9b+V1l3wogUmY/MFtho86Doz3WMeMPFEfGIYBNaL?=
 =?us-ascii?Q?3+PErGU1TZrqqBFY1UEjZ/JDBZJapE4DPdg5XjRM95LRLUD2rELs0Hhb3yUu?=
 =?us-ascii?Q?mp1c6KuUT9dN5ge+ZZ+QP4f2c4YwPL50/I/fo7JJCxr6K6OYJ0j2twYHHvir?=
 =?us-ascii?Q?O1WPpTkXEX4Fn5X24LnpNmrV+HUwLW/xPmTnHcQQeurhku3UlB1wmA1GD4yS?=
 =?us-ascii?Q?BUz2lxx5L3cmSe43WnBvMGX0JWQufF7+1C6E9fanPkGz5eWhFe0jZhyxTUy5?=
 =?us-ascii?Q?68XFfyNK6IJW/IEL/RKuuGxQeNNJE+bmXaxm2tpTB53LnZGS72QPhrxLf7f9?=
 =?us-ascii?Q?rbASr8r6jZgSbSLI9rk0bdk5vamfUKmoBAr2oHOvWraUFdTecdizVeWla96O?=
 =?us-ascii?Q?SbPrdv58coQwxBRS9SzsjozNpvdg4eBKCyYVq+EsMO9LLnjCtH0yPyTZuIV9?=
 =?us-ascii?Q?9S0Dpnw0EEuTwnFL5gyeb5GzzMeAe9JrdIeqKvtbqBFcqG2piMB5dAILYlCw?=
 =?us-ascii?Q?9DKEmgZNJYiyNFmm0joqVo0L0ehLqnl55J9ogW+uWrdBF31GasMRJqwQrDir?=
 =?us-ascii?Q?qZH9hUcbGlA7ykTfssTcv2H6B2H2FqMjiKILqROZqhgUQOGcLEdMkfqXhx/M?=
 =?us-ascii?Q?CZuxpUqRMnaOptbM4WAZi4/X9VoEknSFXKeS0/byXBoaGpwOp3EROpO0wGmE?=
 =?us-ascii?Q?Iy90v5O5SIKvqdAOk6Oo8Ddo6IHPKDA7enEhRrfCV+t0v8aAO2pUrizbtTdG?=
 =?us-ascii?Q?VFz4+vt1F5GOiKBI0FaMYrBK8WnTie1hdH6AOTef3RaTTYxHthRru0oLgvII?=
 =?us-ascii?Q?27jclpgSfsoQoeMFCfUhq3k2OsLI4LgNW3qAEdTtGdcVP8z6Qde3FzZXPpA8?=
 =?us-ascii?Q?f454fR+w3RTPTn/QqKi03TujlCR+g4/PcNEeAXwIAKUW8dQUZbnnXgs0gSr2?=
 =?us-ascii?Q?3s/fHF4+bAY5OL0YKxOBj/Op50GrC4LOoV1qS8x1CpfjdxEXeM90OknMPchx?=
 =?us-ascii?Q?gv4FjunbIfQ4Ph0GKNSSmfca92zI7gxbtfei3Hy9L+AeLOGDLtmOzYHZgusv?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?WzF8xgAMZhRw5zztuEyrOqq1KzleMNK0nzjd6eOZzJBxhpC5XCjSgdGkJ6G5?=
 =?us-ascii?Q?0j+VVZvmpnxJEshfldKq6f6cEX8HVAvZzix1GuZNGi1EbbbA9vwpHLGRKt37?=
 =?us-ascii?Q?DxIuhoQspDH5PoM8rfTWDwFqF+c2NDm6IT176YpnjDV8s71ikLBZ9IoUb/7K?=
 =?us-ascii?Q?Rgr9aaWaL81w/5cg9NrKPbsANbvYlqiDiGHJmvSxQ8Xs55VDAn6jdfU1Ld1n?=
 =?us-ascii?Q?eukWFpWOAPxekydA4hKtX4/oN+hAEPjhWI6ibY8KzPaffLCR4G56yyUeQiY4?=
 =?us-ascii?Q?kT9/8KCKlL7SVXuR+zvCEISq0TyXLzYw4uEftg1pYdF104EZuaIwcliQCB9W?=
 =?us-ascii?Q?XaScRy3XxzEKtx9ynsRX85rJwnfnSQYfeXes2b5dm5ofA5SD6VPZfH/WA0Bg?=
 =?us-ascii?Q?O54WHlYus1IN3VU4MWx7qYJaAHOqrppXSEn+OmAwiN3/yodjUOMlUK0jDVUf?=
 =?us-ascii?Q?0dpf60qnF5FPekeTJcSkksa+OLMZobIpyAsLcMcFeMBRxp0ztSlrOZnj3Whj?=
 =?us-ascii?Q?eTbgqNC/VWkBfN2dF3gRC9OSBFZJ7t8nP6uUEZqnI80Je8+Xk5ffiiYePpvG?=
 =?us-ascii?Q?PHGXqsN/y6uDR3XWiqYpdWCtBuhQQ/Dbc29h5jIH6jMm9NuMQ9rZO6ujWi8Y?=
 =?us-ascii?Q?QBPvImKAFaD9iDQ+KkU8ubi9g7kg89CSCFX8AjRE4iMtB7kVLu7BS7wt+n2i?=
 =?us-ascii?Q?JKF6j+C3qRffIxaZnov1a4lNj6Ys/XQcv+4786V7k7LCTodQXGoYo55KJRlT?=
 =?us-ascii?Q?HAFqm3UFM/ohqL/zXOIpro1b4bOHkPv6vrW6ddshfBVUDy8sf00AcpOxrbWD?=
 =?us-ascii?Q?+1i7wpPG3HjBMXTK5E+ceYKAXMhPbw5rqTn4uavbkyO/ez9IcG0JgEYJBlAz?=
 =?us-ascii?Q?ftjgd0XCl3ePd1zo4W6mbaGwHEIQrL+1XKLgnkYiWAekvHSi4JR3EOLXbGBw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36a85999-7ff6-4c54-b752-08dad34cee0e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 03:34:19.4076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0WnJlPcQsvDaWdOsTcae9rBRYqYtG0v0gcVZp3TJxJf9FX1D7fM6HsNVSWsC471krBwugp5vYCyvnCm3WWVv00AYb7Iho11liPY5xdtg3ek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4315
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_02,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=705
 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010021
X-Proofpoint-GUID: opTjNlyimd30hvnqQxRCayj1x1oJctyW
X-Proofpoint-ORIG-GUID: opTjNlyimd30hvnqQxRCayj1x1oJctyW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> On abort timeout, an IO completion was called without checking if that
> was already completed or not leading up to a crash.
>
> Verify IO and abort request are indeed outstanding before attempting
> completion.
>
> Fixes: ca66aa0949a0 ("scsi: qla2xxx: Do command completion on abort timeout")

I believe that was supposed to be 71c80b75ce8f. Fixed it up and applied
to 6.2/scsi-staging!

-- 
Martin K. Petersen	Oracle Linux Engineering
