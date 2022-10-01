Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17161C4332F
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Oct 2022 09:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiJAJwS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Oct 2022 05:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiJAJwQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Oct 2022 05:52:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90C7B48;
        Sat,  1 Oct 2022 02:52:15 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2912s7tH009276;
        Sat, 1 Oct 2022 09:52:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=+hF5tWPtcfqNZrihsR66I85uBTffV0Q24JiqBkdMePE=;
 b=YaN2AGQ0yTwSctiAFK4zcBIbSbFmEwn82rgtW+InT45DuPjuTF5DwFbA0HdEgNl6LIq0
 U0qU9Ge3ONzkatQB/8hxZuzQf7Yju2+fs21n37rBt+M9rDJ7OmZzsBKBZenCjGm5ctNo
 qkTDeRdF7aHs43g1ENHKLapEJ5I160XYXLKuggJx7vmB8CoLlDca5thm1/vpIn1MHPoz
 gCVL9QTWZn5f9OIGvD2u021eJ3KJsso0SPRW91HPIPwp0C7pP3bS/IaKx5p9SAGyqRWS
 RBL+2YA/QVxbnnBZXJTC7dMY2FkAoR7EYLc7YBGfTeloizQuAMp810te+obdRb3UT7iU BQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxd5t8e5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:52:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2918QJ1F011857;
        Sat, 1 Oct 2022 09:52:11 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc02676a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:52:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAgnxFzO0XHh4JIvA9xSigwJ9V3bMAYePZRAL4+LeiyZncFU5xh25xCh+ig48gIoMYBZdAPgcnGP9/YHKvCxf4fEFrBo1gydAR2A47eADqbtg5syMOiIMioiZiaQVlgBdw1L9SWIs4yEThBKV7yLhXRuqxHRHQ0bbAynJmMOjUh9P5qGVkHdjZ4dd39cNCudD9td0Y8r7Pa/xll0pEbNTxCsWT/s8aNrCbNGdeS1L+8/O9Slx6i7Dw9qHhWErYCGWxvs2OUr/OUulTfM/8TrjGyFzGTLlnpXe+pt7hlkOmnTAohadTsjJWLHzKueUBUgnWVnpQOTqgKe9RNLBWR0Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+hF5tWPtcfqNZrihsR66I85uBTffV0Q24JiqBkdMePE=;
 b=h7RyKZ9OpIzWVxb4pLZbhhHlC3vuAlgiDuFikS1t/dgXtuI8vDJ/LEhGTbJulfyJoUsF00OGv95gxB1O9407kqfV7teLCq5fYfUr3lAH2YOX6LmwJXD59Y8cgSj6Z1O8ojUeAbpQurU0AsjoMABtVqP3K7NcvCqJv099Z/PBzZBZeZhR+PlLqj51SbOdNrS8muL9orRdCAmm+WfEaNp/cDbvAfwVsLmJIXq8qm6NhixP82YBzTV5xFEUOfcHUJF5AoZPEq6Cc8WcvQdYSyNVGe4Tr48J3KUwVdgQ3kyjkSdOZL2uTsG0hFmGiStg1EWSSqoUN2UdO4j74lV27htYIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+hF5tWPtcfqNZrihsR66I85uBTffV0Q24JiqBkdMePE=;
 b=ddu0LSnPEC27mLd1ntYcFRKK3Pw9MIHqKfjppk6c3pd7ehXKQja9yWfh+uutU+fOxuwk93w+U/nm8FZpVmKpAoCSyiGBlXUNANWef1fCUtJ0eRbJ3OoiJ8dxxT1wi3p5tPQ1HvRee0avKFHbKWE3EyHpNGRoVM8V0SXsBQvNMcs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB6616.namprd10.prod.outlook.com (2603:10b6:806:2b6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:52:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%6]) with mapi id 15.20.5676.023; Sat, 1 Oct 2022
 09:52:09 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] target/iblock: fold
 iblock_emulate_read_cap_with_block_size into iblock_get_blocks
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsg7kh1e.fsf@ca-mkp.ca.oracle.com>
References: <20220927082225.271975-1-hch@lst.de>
Date:   Sat, 01 Oct 2022 05:52:07 -0400
In-Reply-To: <20220927082225.271975-1-hch@lst.de> (Christoph Hellwig's message
        of "Tue, 27 Sep 2022 10:22:25 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB6616:EE_
X-MS-Office365-Filtering-Correlation-Id: 099ffe9b-375d-46ba-2838-08daa3929b6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lF3KrNzRvxi+oFloSPr+DJQ1KprpRaivyIYtcV1gRuG7dDq60VT97/Hr+BpYO1OogT/sWElc1tpFDs5bIUAqW28NUPwm8Mwl4XOAOHtbFF1+m+fERSWzukrJwUv8QpLsg3hJ6OO9hTE5GchyZmXwgKBguteUpqTqWB8WgLsoyMuBMtGUeRHexSI3x9+6eDXO4KGSeSd/mCkRrqoLHZIG+IoBsuVE4o9tofzJjTefPjz68ApNCyMsCVvqfxaKW9Yv2gHh6bZAA18H29B8uvCEohJzEBVs5OWDPq7DVqBPyQbDQeSl+VV5d63Gveq86uYE3PAxRitarBTt9FsDv3TyGa7wjhD0V95qv5CxmptwULAb4ON+/WwVWoMQjfkcvqWp2OqvXI7P/+ptdubNexsOOrclq+gecd3ImwCPZKk/oB0yO6rovP0A1m+d/zMjGRMJ3WeinkQ1KRMX7oWpRAmhJ+k0VDPRMFMKScJSKVMqN7K2sVpi1tOurxRdLNqrg31cHpM439LgjQga5Vo3uo9GZSvoF2i6B2lCnJLZTcURtRNvo26z52yIErx5pe8QU3Y3y16A7dKbGfjYzgc+zoaU8XRPuQfVrGkd0Qwnvkumrv15ahhH4hprYq4JdBihyj3vU2ukrXwfo8Q62EjuU2SMcKqXlU7JK5/80SNQiTmHB6rlpM3a6L7y2CVciU7hnBaB8w9kF4Srp2tu1G48ODIxcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199015)(6486002)(6916009)(478600001)(316002)(41300700001)(558084003)(8676002)(66946007)(66556008)(66476007)(5660300002)(83380400001)(4326008)(36916002)(38100700002)(6506007)(8936002)(6512007)(186003)(2906002)(26005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oL6qGELvqCFiTJA74AT8McgzeOilhKIlsDl1xmeJtV/JjbkZslhBcAJTTgH5?=
 =?us-ascii?Q?49Cl/uynBNANjxDEbIOHlrfkJXRYIc2U0NPcGvdob7xRbL1YPF/v3PsnqgUB?=
 =?us-ascii?Q?YMHIPOh+GsjPL+XD3zdFn9/L4YSGoFmIfkpOLHP0w4h+wAtnODkdpebGuNNz?=
 =?us-ascii?Q?f0k6Fwwc5oL20RPcVfBtUIPgIfvoQa3qhI0nsLivy6Ohl1hMEBBd8VUKlPQj?=
 =?us-ascii?Q?p4wNQdGsSzKvQHCAoxHJ3Ecnj43Nlue7Qozim8BFss+smXigGAv6L2PkrXgm?=
 =?us-ascii?Q?9wlY8ZPnSfdV9AQa2P5ufQu96lXd6lzUJazLZVPfvGLL+8ZIBY6goD02Kyb4?=
 =?us-ascii?Q?DDs0Vie4oZqj7wTdpFOCHF7JIQC3LsA2azeTsuncqNZRW2WLl9CkTusSxPBR?=
 =?us-ascii?Q?P53BMiQP5Jy6almuALMDGD3njzP58WaKc/UTCdDYI3kYnvsbyMeqEncKUv5Q?=
 =?us-ascii?Q?ZWp9aYnMiOYEMTJnXQveZLOII2wSXeY2kFXrQLQI5Wa/ki+TFxrXpPEDR8nD?=
 =?us-ascii?Q?xG8mh0Oa7ffRk9egcjtzPfrWV/FfH3w+9cXnFEgEhYbJLDxq+xPjOGF2H7MX?=
 =?us-ascii?Q?MaA8M5zeQQuTK6iKAexxyrCXZIsQqEiZScrh8O1n88xevr3otsPKotROfVIZ?=
 =?us-ascii?Q?jC2DGVKSoHATHyai2/tCO7zS2G1+rG3J87MWxapUbQWywbYddEh0HQIWYtGD?=
 =?us-ascii?Q?lzBO3YR6V4deGLlkNyOfUrnIJF7tXu8NN3U8tf63rD7jTe4hO4rjz/prnv7o?=
 =?us-ascii?Q?4nCvw190AgcIYjWe5xaaNadbFTA97+UT34MAK02+H/CCWvDQ8k23RjBcxXcG?=
 =?us-ascii?Q?mYVOaEaY4DNBFrGCjfjnsgL1y77+SvU/BhPMGA10ceeZ0S5kNgRHZzIRJOV7?=
 =?us-ascii?Q?1bbGjaKedh1+Fed6/fT04FDYAuGO7K1+BYpt3G5WgQSb34VdGg1zM0WV+elh?=
 =?us-ascii?Q?fBL5nZlL/1y6a9S7AzgQohfr7VfeIbGsfbQKkrPNkJQREe4DbDPKaaJ5eHEo?=
 =?us-ascii?Q?+g+BWxiktDFR4Ayg1wWrnAcuBtxDWaP0BPnpTeiJ50tGkR5Lx9blHzJ5pfGH?=
 =?us-ascii?Q?IFYM+ECCT+kCfVjiVj4lBpwiZ2GvA0OVeFTEgLgxBZOghABUK7uwWHYhxFYG?=
 =?us-ascii?Q?FpBfCuKwcGvIMMpiFD3OCrYT02dVK9AXfOPTMnMmDTsoIqQ6ViyoWw7MDVUh?=
 =?us-ascii?Q?Pf+31gssQxSGIqJfj2mMpfh2nrpvCIeBHaqPbTv3cRsIoQzkVFDikjx4/VC0?=
 =?us-ascii?Q?Ewxrih3WVVOtxNS7PlFXp7VJgjc9g7qGupsan63eD5Du2Li1kv03cON8XFoc?=
 =?us-ascii?Q?lrRbQP41k+y2BOiJ74x0hMppwnuAtAnsudp4fSeqp0YWXEEbDLO0qGjrrCd1?=
 =?us-ascii?Q?2axA6jrIGh1S5SrGSXHCjY25BPlebtngq2ozwouHtxKQ+MOW/Y8Y3dHX+hIE?=
 =?us-ascii?Q?6Q/OExq/kafGXhodg12D5QRiw0SQ12PWXvd6h57Qy+mqHcgMr8ff27pDokCE?=
 =?us-ascii?Q?ErGR5zcxRV0R74ZGc9WksVTDBZMaqUqUGrPBDmOKfBnPtV+5bRsC/5CdZq1G?=
 =?us-ascii?Q?Q8HUAWwffQWNJSffjbGX9dUqIO6HFGkf8ofQgXnMtjwvOrRyUIdsLrDdnkgM?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 099ffe9b-375d-46ba-2838-08daa3929b6b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:52:09.8139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yO6QP4D95oGuYZaZmH+p1fMrj6Uydel8Fim3ikpRwv+6VBs8GS8QlCNt0ae40iE9l/xyuSbjXWZDYtaJIWnTM/vRkYt41NXXTXzz9bvmFAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-01_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=842
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210010061
X-Proofpoint-ORIG-GUID: trZxacVhgh_nqrooamjdbRqQsFVGpQBa
X-Proofpoint-GUID: trZxacVhgh_nqrooamjdbRqQsFVGpQBa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Fold iblock_emulate_read_cap_with_block_size into its only caller.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
