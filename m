Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64059CA0FFA
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 16:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbjIEQGb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354135AbjIEJvs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 05:51:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6644D1AE
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 02:51:44 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3853OxAF024407;
        Tue, 5 Sep 2023 09:51:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=A4JUGnfOINo1RoW0kWmrGhblpqym/yXdvYtZG8Uex6o=;
 b=o9xqOIt15H8KuKoRODufNfQny7UJLAiOZ4rN2ENRrmew1H2usl1Sumcp6uFAeBCxqsgu
 aiv4tiKzeSBIliuoIHmrl81gOHTyHThS7MMC+p11wT/QUeCwAX3yF6q/c/ovW745vt8R
 vWjAnL15Ole+frZrdkHbsBrY0ueXie398llNMUMuUyazbhA+k6/rqyLYWf77PVTuM1t3
 1fpjLSAzHlItYSxG/jYo8Ga+/W+792X7OYae7Jl17yx6plPvJcu8YmXHdSQp7QwnanUp
 g8t4jIOgUl0NJYWdcHG+GyNGYr+VSVy8aGLIfDwJnaAa5ufyXmYs5KNRbUU//APTYbvc lw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3suvntvuq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 09:51:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3859fT1p006772;
        Tue, 5 Sep 2023 09:51:33 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug51ats-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 09:51:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mz74ujDlA/KzH/IVwk409EDL85ASqCkAep50bqcqle1unKeJ7OSh50c0tiLCsSBQSEoDaedS19Hgh0vDGv4kii4WGMaRBHPWBJPqzuHAU1obHdcnIaTGDpmgh5h+R23a2PdVLzE7/4EyqNEV76PPsK7Q2hrIV+HLYy8FP69GfHTYLDURAR/UtjmHprQaMckEh+2T2gHpOOyL5AzqboglNuOe4Qk/4hgXt7ZGvdYA94wsJmiP6A4XGpfMBo7625O/vDSFXlcnOxnprpnl7s2zElq95aQNt1u8QmIp1XjxCAr+0js0WjQz6+Av+qa4DLshfltBoGqwVwNKRncRDjNjEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4JUGnfOINo1RoW0kWmrGhblpqym/yXdvYtZG8Uex6o=;
 b=YRTKexkih1WpIK9U2n313oBqUAkO0jJ9dDPzfmb1WfcaXwF8b/G8bhT44J7a1GVkFX+RKDKw9uJtTQZoMAGvXfpRM8z4PinRQgOWsMcuilC4kLxV1Augp1PBoawk8f6ltWVNBwOKzboZZNboPRTsZQDu71QzWC3Z79P3RrSzbFX7XNmCb/btEYce6+mF9fG7ceinkK2YJeFG2FCt4p2Sif1KHpne8u1Fqc8o0C811ZsILjY32qV37gbtOr3YOIHECnqS/JVnDRUjPOAc3U2OegALS4Tk7GNrYXF73B/LZ99yYflEHPOVs3K/gEmxzT4n+z6XsYQqIoZ2qXKEqEkuMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4JUGnfOINo1RoW0kWmrGhblpqym/yXdvYtZG8Uex6o=;
 b=sbMKsYrEwoa/Gg4Ea0/WCPAmgN/rmB4KFN2L9Vw/3L0cYX0mAYENXOoTv4D//CiSzO4tRaZFw5FOcpccgWnRTO9UG1r2k2yLh8W4NGfb81x7hNDk3mb2K4U2nr2gqWphD75XxQMil9LWVkUkWMeSfFuS/m68+ckkmLQbjrgZozM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB6995.namprd10.prod.outlook.com (2603:10b6:8:150::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32; Tue, 5 Sep
 2023 09:51:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 09:51:31 +0000
To:     Jinjie Ruan <ruanjinjie@huawei.com>
Cc:     <linux-scsi@vger.kernel.org>, Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Arun Easi <aeasi@marvell.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix the NULL vs IS_ERR() bug for
 debugfs_create_dir()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cyyxkkx4.fsf@ca-mkp.ca.oracle.com>
References: <20230831140930.3166359-1-ruanjinjie@huawei.com>
Date:   Tue, 05 Sep 2023 05:51:29 -0400
In-Reply-To: <20230831140930.3166359-1-ruanjinjie@huawei.com> (Jinjie Ruan's
        message of "Thu, 31 Aug 2023 22:09:29 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB6995:EE_
X-MS-Office365-Filtering-Correlation-Id: b99ac2a7-1bb4-49e2-90ab-08dbadf5aefb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7TO4WlhZBm/kzxB5yx/mwbosjr3HtJafocs+B8nVODYVBWKkyq2hbzehd3G7eyWZqaLLCJ8s9QBMjyjPl2OQcrzmtoM1AOTCC2+0NQ2A5dveBNbAUCc9nZrhqhmiHv4zhcMlzkNpNfSqWBogOWyjCT1t6jSwnfKAb0XN3/DyVnSN2i/7FDqUrsU/2SZL+fkvDJRR6bbVpJoKLvqoULmnijn1KHOgtZqx5X/q+lYBBpXsg3zQcsxc83YrvW3WKN53TNY//GW58tIAJfmS4/oYMtgU+bao+z4jfoiES7A3KGKYRb4XKM7a7Z3AV4pV30joUvHzz+QNpvAPrbNFxI+HqHHtq6+tfNq7n0751R5oXdc606FPQnGbEs91KL5WVfKOyE7BTCLEkc+ZkNSS3Bq8ScHXilZWOe4+KVQ2ZtBMTAHN7qyrFT18004pTJlgNrps5f130RrhB1Qijg35O09lT1Rez4DZnDiYrHkRN4ACzpQVyAVsXh3gdhf7i6juZ9hfRjV7DWr+LNp8MGKPQTqNjo6hkmeE5gUr8tIwJJNBgZtWNr531leNXn32q2AYpChB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199024)(1800799009)(186009)(66476007)(66946007)(2906002)(6916009)(316002)(86362001)(54906003)(558084003)(66556008)(5660300002)(8936002)(4326008)(8676002)(41300700001)(6512007)(26005)(38100700002)(478600001)(6486002)(36916002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HnRAJY6pDjzarRgR0BR4Ih0lwEzPtwjPFNN30PfchX/oXMpyc79KZj0az28H?=
 =?us-ascii?Q?USIQxZmwg+W/nCiKICxf6YulqhZzbFzm+tdyTIG0BY3F/InjwFdXay1cuFI9?=
 =?us-ascii?Q?52COxGUonVmCGj78Epu6dmhK2XGYbr2G8Bux5PSDHhwgqEGyCyahaNgr7M44?=
 =?us-ascii?Q?fxUxrIZQKOdinWKjxkc2p/jLEwnx435yHD2EPIM25y3SCDOwvL3lkRJD294R?=
 =?us-ascii?Q?DEoPM1RQcvCfSDKM1w5RNytw1WrwQbdWvV3eSAKEDOUKeujZOkrE63C10dS4?=
 =?us-ascii?Q?Y1hDlzrgD0zID8jHbQIlQIE3Pedv/GWKuDyFGIx8vC9NFjvkaDVk6NJ1TcWe?=
 =?us-ascii?Q?usk43TTqVaQEU7uREKvQGmY7gRSgL5d+FT9WkXPXgK4tEZltxdBf0lVcacEj?=
 =?us-ascii?Q?yHcqkcoUOB+yv7BtEGkt+qX5JW9FWdQhhDuG2v4fa44x5M/aDilT4e69jTgB?=
 =?us-ascii?Q?v1Wj60aMrYCrQUzYHNwgPAJEN8frQKtP9OG4SOwiCnVLmpGoSjUHvGz68ZnL?=
 =?us-ascii?Q?1ZYGUbwtLuWe5KL2wB6Y0uY6uQGUVxdFOPxDyKQh3nbiCWuYX3/njgzFiaBA?=
 =?us-ascii?Q?+tZv8m3GPfFSewXn5pYbxltpdeOYt/iiTWr5eVKAVlT8HHP2TVRfG5856iDM?=
 =?us-ascii?Q?u0FM0Qrm+azvoqyih0V658tL+zdvNc6rkAS26MKumSscNpeuIoJe4bMnjFI4?=
 =?us-ascii?Q?RWyNf4L40hqVqB5eAK48H/fK/UDTzLnBk8JFu9xrnDAfWLYC8whTGkq4KvCK?=
 =?us-ascii?Q?x/SNY3NEjsQX4FAndMxm6xorvndRwUj1lgQIrrHmNiWZYlW5ird7L3XA2OCM?=
 =?us-ascii?Q?0S8oo52vtzgXbktP0vlm7tTcgjDhbL+44grW2vMnNph4vRTfsF7pPJAJGeAt?=
 =?us-ascii?Q?sJlqKHy3l74B/uCnNcTfbYC3WMb8VTc/2fsyODiaEVjx0U0Hc44LGrGoZhz4?=
 =?us-ascii?Q?ctFgM53hcAfMkDwk+Vl+SVEtaD3As3YMNEe9o630wE55JzKxyAeDzql6gjav?=
 =?us-ascii?Q?oOW19N8+Zw400Nd+NpmWgIJ5JA/cAcgKxlK4fO8UlCdn2igmCWN2YnPoaXk9?=
 =?us-ascii?Q?Akj0olyfov6Cs0fvJMDM4ocREs+UPFeKebxq3y4u8zYN8FSR/G1rY1F+8HsZ?=
 =?us-ascii?Q?QHBwdhsRcKfkPoaOiLyoM6x8KNYaOtr0mmOyt47enMM3hG8QJiLO/xXQ4+XZ?=
 =?us-ascii?Q?/objUeqCLl/cTeeMdyxuaa1pQFVoGmU9+gkwNLigVhCMm+heW8kfqIzZrjxt?=
 =?us-ascii?Q?89j6zMwUPwOsshAp3cgkOVrbgkMyPJE1gmGlL6Ox8ZreYrkKT0xO+GlacuFT?=
 =?us-ascii?Q?mY8/z0pVP8ScHJv3NnkWXtS+RWNYlIAC/TUaCIL04V/TZmS2oKa3QqobWX0t?=
 =?us-ascii?Q?EMNOmVgZ4/2gxIgRrErAtTyJE3qyfaF0U/QY+CyqUDHr1HgEBm+/MPV6WXfH?=
 =?us-ascii?Q?dx4pV6ar8URX1IV9Hxl9J/oNHKBYfzZrk1SFF/ogKCVE9pCjrdJWpyBHgr/9?=
 =?us-ascii?Q?KiruDUFfG4+VpxGnAb7iwUrt4FqUZzz6ndw550M39gEAnifH+XRgK75cGs5d?=
 =?us-ascii?Q?ESlwNEgW5qwDNCLex7H21ziA6mf5p3VrG9QNThMMZOlilYqbBCl73ok9cDMk?=
 =?us-ascii?Q?fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bBq3CRDxVwNbbTzkMNBQS0dQQSBL9+7P1pHFaykyocvd5y3yH2mF+NqxHYAkzt5dmG5qgkUrP63pabRWTqwVDnBPNG56fvcmQNRvKYJkeKCJAB2O8Czqr/kXmI1HvNDkgBHhw1VJYS21OYt78SsJfiNkjSpHOP5VRU4bs7Zpu6o7AyYuoG+P7tqFyTn+X+qr/nN5rkRPLJPUvxvtyuAnka33g8uGBRDMCxltvaPs6F1ts7baJVKDIz725U0V1Ka4qMBfkAVfHShRfu6uF6MZGTD7fMKZhKb+OuB6dxYgz37qL+UUUPEzPPpTEbBUC4Tb38NE08sxeC2DANKjQ0HnLPGgC26aFchH9Y7uN56ohmheFiLt58ftPpZ+JSqDj1CzC9atGSchlpLRKj8/ebOKrEa9E+JDpXRIN9Cfqfd4z3Ct1XlADs9skh1GSXwxCI/oxlbsLKOhHY8j0ek3+8FL0CvZ0il7tzP/ktmO/iof/SpVurVAHHcoD8nFSfBLPT0pUkd0D9QcYVhuehFbHprT5Io+MMmhPjWzzBKyoXbyHSVRGCclzWjLn25ttmvRCRePpMVc9oqHkLIB80SBewc1Sj67zNGyGnjB3+JGuNkKAv6PsJDTa9Xh1BGdWAo8Px5k5FuRb0rvilJ8tSSWRL/g7GHq+BzWe2ZbOASaKJx9qZyFz376Gfr/CXPCfMEE2R/KO8qh/wnIXs4A521vtHqU+UG0pgcK6wWxtTclzF3r3pvJqkakW1n8VZGL9wlxK0VdU1ZGlb9a+/itocpr8OARXfR4Ktzq7SvI2MaPBbhMe+yv/XBMcPOW3l18fdCtX47oKB9bIJTMlgIIh/jeux5C2LqNcP/ahJZ0M8oSEOnwWhM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b99ac2a7-1bb4-49e2-90ab-08dbadf5aefb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 09:51:31.8911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r/DZs41TPiou1nE/BTFMvuUmtqSdmBTfouv77zKs/AuCD7nrMxgMm/P3xbNeBkBBOzoHvM9M3nOZQ8cDhVTlcNBjkYhP9F+srjiBBcHS5BE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_07,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=764
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050088
X-Proofpoint-ORIG-GUID: c5CGPmt29Hv5BVfyvteELy_4g94tns5z
X-Proofpoint-GUID: c5CGPmt29Hv5BVfyvteELy_4g94tns5z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jinjie,

> Since both debugfs_create_dir() and debugfs_create_file() return
> ERR_PTR and never return NULL, So use IS_ERR() to check it instead of
> checking NULL.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
