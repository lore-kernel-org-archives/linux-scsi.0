Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D5FC77B73
	for <linux-scsi@archiver.kernel.org>; Sat,  6 May 2023 22:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjEFWUh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 May 2023 18:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjEFWUf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 May 2023 18:20:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D891D11D8A
        for <linux-scsi@vger.kernel.org>; Sat,  6 May 2023 15:20:33 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 346JU2r4002953;
        Sat, 6 May 2023 22:20:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=Xb2ovW1oAyBIaJHRBDuFSk/4sigfVSIqh1vS5VmmSYI=;
 b=SA0eiuayIwnF5B7xOM4dUDWcoz4aiUgpAJN5SOMRlRisuqm49jOdViykpDsqMMOmUZs1
 5ZK8dH4y0yoAH4/LinyFpUMMS5ljxiWwS7XlXi0gZiFmU4AmKd55HjJekkS0rgIltyHX
 DwNptRxoEbfo8zkFcuvALMn3B0eHxB4MiPOBwuIzHdu+tWNAZWc6MclX7nOEs4cZeneg
 52SYSb5aMhseWg+8Lpl/qko7qAYWLntHDUuYLNFhBFZGjWWTjqvwVsfinUhoCQWJ6a84
 5n5qJJ9gX7jm9EN9SWitCQSUo0m1luUZenadN4GwzO6dkLdFty+oggxEaWPQ0mkJG1ob qQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qddtcgyrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 May 2023 22:20:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 346LZPYY011408;
        Sat, 6 May 2023 22:20:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qddb3jywa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 May 2023 22:20:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUo7+Gi3cw/CXEBt2F6lsDOIKMh2TbFl+Dgm+N18XEJ4URRwQMlB5tvvP+63Px09MkkU6xD+sKEbHAU0o38unCWvr6QWpZ7x2+K5Zz4nTb53w5RvUkvO0mhVxaw5XQbA522DI+B2+0gAXm4c4Iu0sCGfkYbQG6WGunHoBMOOSZRf5q6ZWwohjyq4bvQbc7y8xbXsZNw9l5gv9jLDjPdgATs0Dmq2mRs+iw76AlsBegYIK75Bl2dWm3bGGN4kd9dMj9GCJHC3y73R96mA9dba0irqxWm89Mjn+RQ6DavChh6a5lKp72P3WD2LPyirJNRlY1TkSbpZsVDLXoZ77QROUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xb2ovW1oAyBIaJHRBDuFSk/4sigfVSIqh1vS5VmmSYI=;
 b=liRj7JtUCNulZ6Bf2/WuT9dis6Oo7cRumvMUn6qEKqM9P7h0rYBbK9a/CUTq9llzKVM041ngVTROi79PpCwadgCCTUe7FiAFEUHo6EsvKbIYHbcMk5+gL3NW2xJGN1CEkex+WknbTAfMB5f0AqTJBbxlhPKp9KqeQy79LMblZ1kB3HdIwmDkzxSr+BeDVrISCb67PuyM9wh+8+zHlK+0JAKzBxnM6jxDH0Kgqoq+lut5Wl4MibO3Ku++Dddfh1psG6clDmaifOX0BrDw3og20dkYSnikUl+JPs4N48wLEs8sXHFoHfFONAFBmVMfuUpu4R/+HxLAS1eZM3jKR90j0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xb2ovW1oAyBIaJHRBDuFSk/4sigfVSIqh1vS5VmmSYI=;
 b=eyXRi9iDu79BNhymj2gHzhlVba4gjgSKH5lTSIV/dBxV4K+fCnI9Dia8Kd2PpCPdcMjyMuDirL/7jzWW92aoWJ96WL1hU87UbDwyQsnHAyNyg+EGcsXteIPFj39vQnk6/2zeDBTshph+JhRrOtpJImEdFUt3wBfs+KHUi/Bw6H8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5286.namprd10.prod.outlook.com (2603:10b6:408:127::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.30; Sat, 6 May
 2023 22:20:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6363.030; Sat, 6 May 2023
 22:20:10 +0000
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>
Subject: Re: [PATCH v3 0/3] scsi: libsas: remove empty branches and code
 simplification
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135493xwu.fsf@ca-mkp.ca.oracle.com>
References: <20230421093744.1583609-1-yanaijie@huawei.com>
Date:   Sat, 06 May 2023 18:20:08 -0400
In-Reply-To: <20230421093744.1583609-1-yanaijie@huawei.com> (Jason Yan's
        message of "Fri, 21 Apr 2023 17:37:41 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0115.namprd11.prod.outlook.com
 (2603:10b6:806:d1::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB5286:EE_
X-MS-Office365-Filtering-Correlation-Id: 3785871c-177a-42e8-c28b-08db4e800e38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 87HjTCTZCKJOY+1UQdx+Xu8uETTsJ8qxWxMKJPXWmd9OvF9HQ3rjjTejGSxIAn5k8tBlG4wC3eCuf7Ne1XiqWk0+/QK/9GazHmAp3SEHa0BI1mGodFs2Uk2xWNJvXHerDqzRIUlv1WGdHlKUogLWrS/XZJunUWieb/WKd6wfntP8w7VqO0HWjluB8kF0QzyyK3ROZiZ4QPNC48URzsAQ4o65Vl5bi2M/42y0oqx8eEJ3XwzhMokXdZzPKnHYgYgnYSbd2JJKgM4thS3EplQK8+w+LgFAwr4k6p135fsfS8rkKHGRrz6djbwNQbhMxWcgU+T8kglwaV4YTkVoarwt76vhVXJMPCRPAydj2EYf9TMcFK76gq6peE9JA1zBgipW+59SXRNFnMtTdHechYnMsCygO933JEp6OgUpljqW5KDRbSHhlyM7dKbKWSW8+xqeGjjDxpiQeY0DoUt9Bs1+SDw5qFTa46ECzny5/06tu5SFJMtvFBT+rAMnLRemrRa0sujQIuBi7a/XYSJuQNtMP40hwrIVjkpHM2WIKvsl6RIA9vsCB2KaMHcOgDDxd3Ff
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199021)(8676002)(8936002)(6512007)(6506007)(26005)(107886003)(2906002)(41300700001)(4326008)(6916009)(36916002)(478600001)(6486002)(316002)(5660300002)(186003)(54906003)(66946007)(66556008)(66476007)(558084003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cfeiQdwxKpbAgm7RKWdKIJSX43QPcZDQajI4Vat63HijH5xTJQaZ0gr3zLrU?=
 =?us-ascii?Q?B3qvcvR8sGEGdA3LWYRSkclXOlsTzvdlw3aXVjlYGLhRwM8N6fy1mqfM0wF5?=
 =?us-ascii?Q?k+fMKTLezu8QbJEax8CT/Z3SgSA5CXz2QV47sLdCdUfpTnpVu0gzYnARBYqm?=
 =?us-ascii?Q?EwvFwygOC2lvPH/OJw5a6G7V+e7ni7kw05Q+i4mHEG00cMvp24DrHz9R+10B?=
 =?us-ascii?Q?BXMifrHG7MlF5tywvOsxb2pJJ5ba9c4UKcPcr/TSOkjAWCORcP9cmwRJnJw4?=
 =?us-ascii?Q?OzE2hpjYxkFkFWXE7OPE+hcg5yCuyGXgsegbUCg4C0dN2wRsoBxcF9sR+oGR?=
 =?us-ascii?Q?3KEP7hFE70YJ5rtlTlWS6s7NntoiVGflVfB2D2UIqdL2dtjscixuEwpi3ktR?=
 =?us-ascii?Q?uRBkhGc3vWRNqpnvqEC7Y9sV/a8QRbFBVeS4ZsaiXHDFq2i3Osd4RhiXIJHf?=
 =?us-ascii?Q?cq/In4EaxzJ4lW0RewF7ng2+7UqhicnrXQLxmfPdDxcN8oKgrWL2972ZRyss?=
 =?us-ascii?Q?pjnEJ9sbipDfuIKALTxS+VbBtY/7q16j3Ob5caizbaDfF9VcnebnmNzMgxhk?=
 =?us-ascii?Q?TqlXmxNUDemSsbeaE/+XLIyN1Byoaj4JKPPkTMRYwCWkNCj7hPQ8GhP7WZ+h?=
 =?us-ascii?Q?67upMivI5isXOzS3OigPvo0v1m79cUTWRuXAMWmoNZAZA1IlUTNcbh0uLIKW?=
 =?us-ascii?Q?dZxqYuGJ/P4bU00oEUjK9yN1aPJTf+o/X2hRwTFNgN3+J+Ocb/El7t2qscEA?=
 =?us-ascii?Q?e2O+RnitYE0k/5az1ojUE+bHARmvZHJydoukBKl5lAv9zQ3MkpUx1PF7dKum?=
 =?us-ascii?Q?omo7TdeplFtoFsjF8dzM6tdNt6eHmgWM3WVeYrdu8QC7hsFbHTlhnmBvtCSJ?=
 =?us-ascii?Q?hM8P5BRwGzU9PvLAq/zLvJdtUqZgkA87uZfDLNS7lUDw2oeFDSSVuKaBVxsn?=
 =?us-ascii?Q?Zw9xINQ9ckiMUGb6qZIsuqGK8Cnbs2vfPGLDcqsO/J2C76V15zES3/i2um1j?=
 =?us-ascii?Q?fs4w6qoYjaDm1VAB/e6QnaWkl2BsNieYT+BZu/jrRk6coTLB8V0vumAxzVdp?=
 =?us-ascii?Q?xM2AZQHT5ZCXWNcfqGnvIREfdAk9Wp08Q1PJInD5PqDdikuQQKvDJpHpHbd4?=
 =?us-ascii?Q?FeIanq3wXx76LeovkPCidXafj4bCgmmu2dTvS4h2ssD370bU7SeXXkOHzBlx?=
 =?us-ascii?Q?YilbjpVzxHi0fdeB3HhXlDJ9r5x2QnaIVaqFPVzytZO+yybpNlextztArK1H?=
 =?us-ascii?Q?OMiWLopw/WWs7fqXYIdwEZjMYD8QFvJzo1mAJm4r1rP1UIiQtkcK96vccM73?=
 =?us-ascii?Q?9NQiSMM4NCo/hX+QOdAUEmGQmJorRo7VErZz/CnESrfPSSz5M1heofkY44nU?=
 =?us-ascii?Q?uHuRv1Go61wDslUQCxS0J1iSBerzdN8MsRz9cqICRzdjE867O7sOPcvPWnIY?=
 =?us-ascii?Q?klOmCEeAas2Ndf8P1AMbe+jK4f+2pa9HTtxcTywvWiozwUjLhr1DdPMyDLut?=
 =?us-ascii?Q?n/vx9s1WkG+Uteh+t0ONYPYJLFpaCBOZVlyyRHC/ZeNlZS4WyloGn+z1m9UA?=
 =?us-ascii?Q?R1+FJpV1W74h5j8MBPkY4sxKSmdI8CBTh6P+US87gxY6an4T9URTQywjcg3w?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Th+/YHo9wTrkWfhwqbIeBZe9WG3XAI3YR5jAL/yzDJQRBvH29wgGbVZYhHSP?=
 =?us-ascii?Q?X0iBbF46p4OQLk9cduyynq7gY+B39Ka+HJ3RNep5rzL55aKp8rJF/RqikXrR?=
 =?us-ascii?Q?5DObO4jV74G/t8Akma5lsCI0CJPvvqwhJXZDda4mtvAMv2fspYZCRzJXpUuE?=
 =?us-ascii?Q?Gx8tZ2j8gUh31IuvBoBwwEKCknEeajvmFCh+XDLbozmvThoff0ACWGUzippA?=
 =?us-ascii?Q?3C0ACF3ZklbglvmA/k+5qHiJ/CmkWf2dMI+v+7AG0FzzVRnYVU3ugMCSjKMo?=
 =?us-ascii?Q?tPT8mkhu0gF3AcTALvX0+ptcNej64DVOKL8YbkH/41v9WCFOjO6B0KCmDOQo?=
 =?us-ascii?Q?3mcz8UfVmp4U/V8DIKTk225YnTSgiNNnaXLTymSGacopNKJ0Po0oK2WQoOhK?=
 =?us-ascii?Q?iy5E0rthXx9gV7dkVyF3fKoqCE0hW4Vl4XucBYH0L4XPwipXCvGGGCaFQNBJ?=
 =?us-ascii?Q?5/IOuvFfrZzk1BdVjAnUpm55nNJ34JSIojTarO9B2Ves9MTOczC5yBaSW8Eg?=
 =?us-ascii?Q?8Wkcfym+wekNUDAedn37IRUo6e7cOLNSzulN9dNlD2XeP39FlCIpVNmJsu9c?=
 =?us-ascii?Q?6EoM3y3uWqmGxQ/6UAi7GvHcwcZa/Y34KEAKHi+qqbxWeIXhTssieLN0rSfx?=
 =?us-ascii?Q?kqtXbSYrdwyS0XUTRal0BOgdnJq8vS+sVOMMer3hw4zB0KIzvW8IR0N1XrU9?=
 =?us-ascii?Q?XzleTpdI1er3opiH1UO0vjzL94U2yhW7j37dH9MZCJq0bhEJi3THNtpJH3az?=
 =?us-ascii?Q?A/g75VfWXeUo0mwQt2QX5OeD1sUWZ6p9MYhF3HeXqG0rw1JCzmY5Tyv2u943?=
 =?us-ascii?Q?pBjTYTGhhVtNK6Cv7siPH+37NWnWMwNhWEOOxWdc1oR/9GNsZba1D4yx87zC?=
 =?us-ascii?Q?BgCRHfK5wcAS2kO9qGXGhTf5hc054pmbQ4pD+c1WcAfJoYI4P1byI9Rfih1i?=
 =?us-ascii?Q?Dzg7KlzYjYqZR+Bsvds2ti7s8QazB8xlMiDJ9u+6x7U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3785871c-177a-42e8-c28b-08db4e800e38
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 22:20:10.5496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6BJ9ofuc1FPZMispXjrJVnt6pN1rcsBybilziKbC8oNcp27PFzeuPGmJahn0lWQbk0b0EQTC4VGZtdfC4XcWA+At4oSUPEQtSRnjGn6UkBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-06_14,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=860
 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305060174
X-Proofpoint-GUID: jeIjG2rxruvJ4PSHqlmY3Dbfo6tY4qb5
X-Proofpoint-ORIG-GUID: jeIjG2rxruvJ4PSHqlmY3Dbfo6tY4qb5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> Three patches to remove two empty branches and a little code
> simplification.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
