Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2E7C74A44
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 02:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjCJChm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 21:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjCJChk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 21:37:40 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA87EF2239;
        Thu,  9 Mar 2023 18:37:38 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LwtJ8021591;
        Fri, 10 Mar 2023 02:37:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=fEcYl3fcyOQ34NXpZ3ymVedhwuJpOZBEkPVVR16UTc0=;
 b=kOjtelcw9ZieH8hPlB6GMRgv0N1JbSoMuO8Lc6RyZC6g1x2cs/Vv+gcvbc6MLk4C/5A7
 W71Ycb5qsTaC7eS2zUTaQm7Q4y01ra0/5iDpovhfADozJpTSacKd6oP3iidx9/NzQ/yc
 6zIUDvLyvmGWo+pysWaLspxbodDqkxY3vstZwA1CS4KztdMkEJnU8hEGzpFGjmBEAeHn
 +WhzQLXLk+LNp69tgQHq4b8/pRaw4a26mcStNZryurbg4Rvkbm4fheLMkV8dTWN4Lbpf
 YvrUk4T0AW1XVCymtaTGS0PQEZKvGKL4bv8Fd1fC451gFd4qAhLqvThXp5RwD8FH4HQ+ xQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418144gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 02:37:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32A2Cftj007348;
        Fri, 10 Mar 2023 02:37:31 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4j43qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 02:37:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KfMtW4tmic68QnpjIjmASQUH6AEyJ7ILSonC0RZXrcIvtQYwWNGbIopSk0WHNNpBPYjJjDe0jmr6CambV3To+b9IdtJwW5NohesIFNcI7T6HxCEZcpICtBNVHYMmwvpvGB6seldNcb9zBc/2UUOAg0NkQtJGJCtjbIaVmGtSSjbIxVZOTZbeqLYNBdFIJd5ADCIu13PcdkPqI7VE6CokmPEuKJT7o785q2zDgSPnlOk2BKLE7PgT141b0rzctWBNToeALbjxB1WOsQGuqBla2G4Chtk4rhr/nQGxM73tgeOZ1EUeJZEph7Dhxi/mImy87mrQw6vDfg7WcgWKdW/8Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fEcYl3fcyOQ34NXpZ3ymVedhwuJpOZBEkPVVR16UTc0=;
 b=jvuzYrKZfFtisRSz25Vfg78ZUx2lgfOQJvycEZEW0kfonXoCftRfx4Q5LFkDGhEkZD7jbrYWNtGkxy3Zfl+Gz8aYQ3fO8SHkSGsxEAgJjmKm9pAi9SpGM68+soAR8So1dOCMLIwLoWumj5y3GH3h5aXKSDxZKNTiMOJGGbfQX3KryyTcQweJ+rmlOJUzrQPiicG10JBjh6A+9vx4HL1A306w9cgG1sAtx5muEnuJXBNXkRrDs/s0Ywp8mHgPf0HRagkWee/JjmuJjLVRkSNKZ8Rsa55/XO2SDfMjOZgoKm3anjFsOQvw85MhpAUt9ZNTjm0EaObtjFOYqdFgIgwulA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fEcYl3fcyOQ34NXpZ3ymVedhwuJpOZBEkPVVR16UTc0=;
 b=YYRyKThl7o6kQn3/NtT9r4MwAompY653UwnkVLKOYPTCQifaqMVrKhoka7ZGQs013a/J6PbQNZl+VWB8k3OAhVmsUIbZllF1YGE00vDKIPUIZEZvDd4jJEoi9GhHQVG+6u6TEYSGo22wYipGvBnmyaJfUMlYzGAU2IYBgTzcbrQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5270.namprd10.prod.outlook.com (2603:10b6:408:120::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 02:37:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 02:37:28 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [PATCH v5 0/5] scsi: target: make RTPI an TPG identifier
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bkl18h80.fsf@ca-mkp.ca.oracle.com>
References: <20230301084512.21956-1-d.bogdanov@yadro.com>
Date:   Thu, 09 Mar 2023 21:37:25 -0500
In-Reply-To: <20230301084512.21956-1-d.bogdanov@yadro.com> (Dmitry Bogdanov's
        message of "Wed, 1 Mar 2023 11:45:08 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0060.namprd11.prod.outlook.com
 (2603:10b6:806:d0::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB5270:EE_
X-MS-Office365-Filtering-Correlation-Id: 408795e3-75aa-4c76-f643-08db21106393
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ly2SOkJHnEI4Q2BvMCykF2vDzJ8n/1uPwYtwnzCkTLvcBloHhUmAWKxV9aGVW+AOPXDL3m0pK97Q9i2d87IaUgHzXZBM4rBL8rYWgVbV1s2gm5XOVS2HtRQCwbg9t4o/sIcrgjswHEgEgR6QDR4V6aRIkMXHIVoQaj1GnZKu/M8N9d+7I5DIcY+gpDP6plIDVRW3e3dtg7UX0+B0uDD+KQith9/KL5A1Ce21jwh5HEl8QDUpMKo8/RJFXTGVGc6SvN/gU/pJHc05mo3FNp7/cjJx3ZDYhH2oVSTx+ZfbnoXQrofsaf4b/XOy3rxCdUPrg0YGBcP3s8B9+l6Fh+Ul0+exJX5TOWctYP509shRGo2pp+8XZ20ffp5MZb3BeYQBXrpM7vpWmdTqfoRhwVkFaoXX+rV16YDmpl31eY8waK4YjhiHZNoMf2X1QB1yIBPCPXbBpWv2TMp1MWlLkZs8BaQNij/vpU7APx3HEOS3FLYrfyuYRqusXfjQfFXOonnE/m9sFIJfKwCjAK0F7eEDmeb18JF/hl+kveNYK9ja5dtUfciFmpswyuN1mmQVGRJ5iuw73k1Hx9sNSVAbCbKVzhuBcoIzVfmuDT4emJn6lig8DMUPrrY+ZmvVQ8qzDYOR3xeZWkTVH8qcH5sbsAxMSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199018)(38100700002)(86362001)(66556008)(66476007)(4326008)(6916009)(8676002)(66946007)(316002)(41300700001)(4744005)(2906002)(5660300002)(8936002)(186003)(6512007)(6506007)(26005)(54906003)(478600001)(6486002)(36916002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6R7H0Zi/FbBYjrjz+P2xdIWWp38ny0tNDk/n+zIiwCMp4snvj0P1etpPOOY/?=
 =?us-ascii?Q?sw/k5XV1NdaV6fQraN1rPtOh74ZxmGj5Ayuvkz/3+4nyoZNHGdBQ442wHQrp?=
 =?us-ascii?Q?we2n71oK3Ya4WBzR6/xupGvNxigp7nK7s6FnqPcIHdrOk2E/gUNNxAXZuSKy?=
 =?us-ascii?Q?ZMKOsg2fXE517YPR/OGQBtUlffzCY0xNj9CH+qRsZA7sqyKWPM8S0LX+/xO7?=
 =?us-ascii?Q?jsDQBuVXyhyL/MQokp7gA4iiRhBxDaWLK4FJkPnW6c+TpvI8CP+9kXxPavPs?=
 =?us-ascii?Q?j5IMm+OV/y/Pl4Fk+h4PwPoA2c47Y2uPO7Gmw/Zg7fYVQvOV0eTZij8Etg6U?=
 =?us-ascii?Q?YkaP3tcbusIPihbtzDvOmm8Evo1RX4hjFVOg1g1salyxJ11NZ+J7/t64s0ur?=
 =?us-ascii?Q?YLbZ7bPvsGUd26caJYCQ+qsa7jAimt+MkWMflrC4OB/BkVJ3GC7rTVJH5D/1?=
 =?us-ascii?Q?3Z8baCYKuyMy/txEUG4DH+hWlFtW1jgBO801Mijm9TsEypGsze5R98DkBbjD?=
 =?us-ascii?Q?IzyfAtrL70xrbnNI3jBGqZNdyAdCnby9zXkwCEZoqMu9YLwzVGAiNFSa+Qw8?=
 =?us-ascii?Q?/SB5aCpKuoDjqYwn42PzSSWarYALeVKXX9q7N5HKdP/uJ55M5Yc0Tf6RzfOr?=
 =?us-ascii?Q?wPdwdxdIYg1JISi/Qcg3nJKy3pAtanWmwpXsL2GUiyymD91/ffPxvIcOvBDK?=
 =?us-ascii?Q?vfBdqC1tXAZ8k0aQMKRaWjut4naJgLrCulON95KCYSbjPOVdLIszL9kt5y2N?=
 =?us-ascii?Q?y1kFWdQlxK+HGnSHG5dSOIgtYYv1DFOpjRvEUl95EprabDnX0J4MZpSy5ohR?=
 =?us-ascii?Q?JRqofnb0bkgmj9tfXsf/e+Z3VQFg/cVMWm6qgPrtjiBdqOk/NuHzqkz9OPq0?=
 =?us-ascii?Q?vl6V3TZs+zBYA+oGSGkE/8JAV8IDJ4CyfDlLL0dCC47UFxXzT4VH396cEOt0?=
 =?us-ascii?Q?mQUfDuozCUOySrbtISEAcCZ0Qc6qzXws72aCQ5odMjSzVQ32am8htu/vlo4v?=
 =?us-ascii?Q?F9qYeAVQi+Z+dAyw0noKttMUl9/ZxMa5Wx9cSpgwzdUQA3C0yc0ohRTT6DFg?=
 =?us-ascii?Q?uD8iguKyiG+pcarDt48I2Ra/kNJdndOvoj5CSxJt91NHT1+WEYfUH5QoGO5z?=
 =?us-ascii?Q?Se8C+kWQpKr1ER6ZM+6rw9Bo4bH3zd3JemfQXlG3vSaDzQM8zcLAeBqz1Y/j?=
 =?us-ascii?Q?3UKPmUHbNKDlKbemrfiyptORGMXW8cQ13naDVuyFri1uc2V7S8oREukxngjK?=
 =?us-ascii?Q?uhz8OsxR3meCDHZ3bL2HzQJSApdpi5Dob08Q8GT4FXc7F9C6pZEMQX5gFrlN?=
 =?us-ascii?Q?kJ5GHt+t590F6kollR92wg7RcqTemyaNxhWGo7IRH7PdNz1yb16qDrAmJBB7?=
 =?us-ascii?Q?CA+L87a41IvdtmeiG3igPUqwIw7BmJpQgQ4iU6+kCHGFX2G1t9X1elYkvWhr?=
 =?us-ascii?Q?/1HB89GskgvT2QC6EVmRnQgVXm2Z/zqqwVfVnR8HZac/uP5M/Fwq3VtsShg7?=
 =?us-ascii?Q?fKKJ1ITP5eQh8U8n5HAekhR5QMfctaTb2vCApeFwZrA0lffSKJwb2qa5xJUB?=
 =?us-ascii?Q?OXP0+gQdLOWsatTc5dA+jrg2zDhtNVef5Ln7TAHsYTKEE2LxxTYgQuBmGfI6?=
 =?us-ascii?Q?Hg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SQO+We/1xVpLSzZm1PB3+oeGHhViX1kfIqBUXnzK40yDPSeqgC7W2LRrpV/pOyNG0xlkrF583UoNuX5ZJz6KybZr3qyWCYZZbX+IrVwUS2EWcphLw+8sXwC0M392xV3qGf7UKdjblEwdKMHL3NTC/zUldT6/FxDGvodmUeo6/miPueBikxdF1rKNh8uAfG1Xgm9z/DGZfZxmrus0bCV/Pv/sNAIj/jw2AB0qgcQq039wu+RjIUwFjChluepQX3oq4hJVmcYh7zyAxOclEn5rK+FEPoAvfGB3TuMSj8CzzUnyWqOPzPMKCXvHnivMv4athHQ2O8v3VNNAFBLDEbkFZivtc4AUHvZHtCavyzAZkfVEjvkjxuqC7g0TD466FJ9f5bTRw3ky/A8vU2zUv583SQ7quufe78KezD4skJNJ2YhC0HezPz4RXC+4UvO3yXBgu0zo1Yt4ian3uKhmbpmz26Xq4czmJ1HLzCc9pSOdlAxjo3UdDlCxLLbBsjbMfASRZ1MqU5IEcdRUwc1gKnembEeA3e4EjJeDRI/wDWRRNuJ7NpOVeMtrgmABtPO012+b2TI8rADlhLyajYKd4369kv5EihgrmxUO1q/fd7rA9cgYu2m5twD10DOl/XNrQ/Rq7NHycDeae4C2tirFtPpiw9yriWYv6Yfv+IU9zLDf0/m2FL6yvS7NvY5AHc58O9dmEtRKol/Mpvg8LpUEEzQYl/hC4M5nQyQ2H1BE6uMBa+9jFa+v2QpZgeLq+FSWZeri9/4ssFCBr3Mhk1rkggVsyRXuG73nzW60cie+N3oIxl1M7gB408DKhp1BsgAFRRinfVViHY9h9WeMNSUt3CkHjg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 408795e3-75aa-4c76-f643-08db21106393
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 02:37:28.1422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8GNOFvglapmfvZYEHzpuXEkDQZ30o9waoTHgHZQ4fj0NzgISGMC38Jo60Bxpm/XfcHV55wBd1LYBmo6LB5M5vz6ZJTwohNAaNlp5wMD2Ebg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5270
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_14,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=677 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100016
X-Proofpoint-ORIG-GUID: oCI5FlNjyKYO67lsTiyZqjayMq_i9RNn
X-Proofpoint-GUID: oCI5FlNjyKYO67lsTiyZqjayMq_i9RNn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> SAM-5 4.6.5.2 (Relative Port Identifier attribute) defines the
> attribute as unique across SCSI target ports:
>  The Relative Port Identifier attribute identifies a SCSI target port
>  or a SCSI initiator port relative to other SCSI ports in a SCSI
>  target device and any SCSI initiator devices contained within that
>  SCSI target device. A SCSI target device may assign relative port
>  identifiers to its SCSI target ports and any SCSI initiator ports. If
>  relative port identifiers are assigned, the SCSI target device shall
>  assign each of its SCSI target ports and any SCSI initiator ports a
>  unique relative port identifier from 1 to 65 535. SCSI target ports
>  and SCSI initiator ports share the same number space.

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
