Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CEB7C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 03:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbiLNDCE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 22:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237225AbiLNDCC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 22:02:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52A222533
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 19:02:00 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDLNrew028189;
        Wed, 14 Dec 2022 03:01:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=Oe28FtHKFoMFu8o+x84hw/8BUjXTtCdqH1nRx/9zcpY=;
 b=s8C287b5XRsfE3tytkXxg43v0FhyXbjfpxCWnRoOyXQXIqcB2jAQfwWcMHk6k+Q0hFUM
 E4a1cyPrvYA2vrXxwNW2ZdwKUTlKkD0rUNOWZhBUgrQ6v7L3SJeJYF/8e4bcWsDx31ky
 lM7FZRuCyzzTmKyckMsFb2ru98bxFn/CH2WulRO2253Hz6GL5A9kYcDnE8q6AxHvKg6K
 EuGUKKx/YLMXMuj10wNUDH4kkV3pSXDvABiRtELkr7dPvyj4qjSPDFAjOINAFH2wYDqC
 Eqn/+i5k57xOQF9FiVL8Q6P7uhwcd6JyaFPOGG8tqRMrgYeF0Vx7uteI5BL8Cxi0qhf9 TA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeu0ux5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 03:01:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDNoevF037311;
        Wed, 14 Dec 2022 03:01:56 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyekgr1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 03:01:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XyX+Jc/dsDS2861pqbvRiTVRmw3x/3v2H332fSVnrJIks83WP+reB2xohWXsOkHOufMByCdILZUa7bYhRuhqRn8bQLkKuAsXvhxscNa1SHWPWMqGAshhCLM09Fumi6himx2kNPHFZfZP4h7AhjWCZ2LyptuAASmFcuOoC8CNvKU7LU6OaJ1XYKl3NSAj56FsUopNrPCE2nBcUpKVTM8rQPb1TslYguDBw+Q+CxAn2UYUjjta7ZFRlB+pJlj48hsi2ZLLl2c3h+oNcmbOoODOO9WJnlvOStATVedeUiBsx5pj68k/nN0dLIhiy5nCkik15TnkFsIOEamPZVJqB0kpqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oe28FtHKFoMFu8o+x84hw/8BUjXTtCdqH1nRx/9zcpY=;
 b=VEIi/wk5XITxR+5W0ZqIj4s7AxFEYmjxk/m0oBesVjGx6GJxxPP3lBq3IjKixiIueX02jUDMHLIleNpstbgYjw5/UunENCp/VnPQ3eW/xRve8hec3FSRHAC1rSRvUFb9ogXI2XEM2O/uitSRlnWZQ4sA3AOHCWYJ/iJNohX/OPaIb6uMLMcmH/+ars3N5bsXbOdEsekqPd6cWDpYzCWf6W/ijF3VGiPP5qp31piHnIG9pn1bAew8ygJQ5qrtpTXH6bPIUXMGHgX3CmCZOcJ5xMB2lCvAZ4RQOzecEomCjqFi0uegUV2XuOm9VUD2szZgy42Ve8dna9kupaqHXXf7JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oe28FtHKFoMFu8o+x84hw/8BUjXTtCdqH1nRx/9zcpY=;
 b=hOTqe8RWDbuLV+CUnxwRXnO6fY/3gGfdYPPp/nf0gVxqeBm2blEWHCpsBQhKMx/JR6PBCeBtg12V08b5gZhXgLC9Zi1vDYeyHXUO5GjpA2hId/rDXj3z1cSgWLfVsNkJAB0M0XSL1Osjq4gFPs7HQ/rKuYtSf+sna1koB7fA+Hk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH2PR10MB4343.namprd10.prod.outlook.com (2603:10b6:610:a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 03:01:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22%2]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 03:01:54 +0000
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH] scsi: mpi3mr: refer CONFIG_SCSI_MPI3MR in makefile
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsdielig.fsf@ca-mkp.ca.oracle.com>
References: <20221207023659.2411785-1-shinichiro.kawasaki@wdc.com>
Date:   Tue, 13 Dec 2022 22:01:52 -0500
In-Reply-To: <20221207023659.2411785-1-shinichiro.kawasaki@wdc.com>
        (Shin'ichiro Kawasaki's message of "Wed, 7 Dec 2022 11:36:59 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0050.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH2PR10MB4343:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a3cf5ef-e6fb-464e-48eb-08dadd7f8e5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1pvAQAIfUTQWWlGiwuvNxRnE+jSXahWnD7WSVja4Cj7Rk/SF1XjvtEviTpfWfqgbEAUclWEJpWKVrwYkuHZFdgOWglBnmiw3o7MkYv3c+KfhK1mQW9toUhPD/Xqh6SB4HaHPHiCknKbXaxTqxxIFzuXOBWjmH4+iqRm3KU81j0CxPPTBCYOZo7ishwkotsii8/VH9eycPjXBWpYCKmL0834XSX/5IrpCrKX24iopyVLbAkkx2+6j7J15NPB2swJNqk74Hg2DCOX4Xv523Wr7S55VXPY4RMI8X/JJGX+H5pxzsenPmkq3djmAZ8QkoIbZTcg1+CMSwMOc5QVtu/YSP2seGe50FAYSlJ14ivdxQmu/V1P7X586VJkSiP07yHXAPF+UBxGKhRg1Z6ZMDNrAq9AQgRlfDLayoObasblooGaGA1uujo+vkZYz0m6bRrZRWfwQkBHHeojexAZRmF5n0iv4Cxk0uD5Ug0hC49SKzjVbQ3FJLsh705d4l8LwKeMt7IWL7ApUtCjAD+O+hxrZTMuzRAhbXlyyHK1RFf7bgC+R5P7qvm6tymxHAO4b4bdxSYSUa0oPrj7a/vV6ZP5k66xKIvy9XLtlxtqkav+8+3/mJ8zHlayPV3+sEdc81Ui52hvgfNvusLHF8YgNKnJdayYO8l5N/S5p1l1BArn9m/M8OmlHtAiTHbRlM28BXXnr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(366004)(39860400002)(451199015)(6506007)(36916002)(6512007)(26005)(186003)(2906002)(478600001)(6486002)(54906003)(316002)(6916009)(38100700002)(8676002)(66476007)(4326008)(66946007)(66556008)(8936002)(41300700001)(4744005)(5660300002)(86362001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KmDnplM7wMAtJzYsS1gvHLc4XSfDWlXqIMtn+oWNOAhJrjCvLMBcXWWOJ97i?=
 =?us-ascii?Q?Wn0SZpw6BhPSxbDztXk1TY2ZJYDSE8Zz7+z//G55v4UcgozDRQyw/bs0heNM?=
 =?us-ascii?Q?g9UuRs6NYQ96zypW1qaJUifYhHoS4uzAyFE9iDXdsFMsrdpZrn+TB7SzL7ND?=
 =?us-ascii?Q?P5nN/TIYnTkP8bOiZxQ7LoqPLfyouyeRs+c0yr5rSRPeaWsm0i1Z3QiDGfwM?=
 =?us-ascii?Q?I3OtjQ2jR6KebbicOMqBuhTPvASPJPs1ATObYTbeUWEs6Cf7AEQ/C1gykjz+?=
 =?us-ascii?Q?6UsYJLy/z4Y2WWJEEE78blpoxJ0yJtP45C9eCar+dHluGWGlHjK1pbkIYAGt?=
 =?us-ascii?Q?xWcCPSA+o/GLpv+KhkRTtPlH7XptnUDZ1DS6xZh2JdSXRHAO5I8CUFduZ4H1?=
 =?us-ascii?Q?sK8Q64d+uWs362/wXjPfKcJaPeCSD0wdPoWXSldtGwZP/t8DxWoGdFF6sVzK?=
 =?us-ascii?Q?1gS8O9cz74GByEALOY+s1TR7ffSepPT1cI8i03XtzfQwJqIV/i5fOLp1ZTR8?=
 =?us-ascii?Q?rcH7GFaUFLPU11Zn1K3ETBT1vEuKac7a1ioANxOuZt3KVYv7/BFC6uG4qHMs?=
 =?us-ascii?Q?/r3Tfj2JNHFpZGj8RaqMvJwDScg8mKHRJmnYyu/gOltdTdDxZdfQkS1d9x2w?=
 =?us-ascii?Q?m/gtrdXeHQftAYvzu4oCfvSYNIPw8sMvc4kttfZokx4wwJwijZiRA19HNEMZ?=
 =?us-ascii?Q?aWp+hN4TRXBmD0RYKqUNLLkHKjq+kdjwfrVTXTR6SApIOvpuKyj/qf6v0NVU?=
 =?us-ascii?Q?h48hC/E3ryaR27X3zsM1ePZXLhvMtBDlD1/JGsWskhCzJ9wFwuD70MtoI3Mm?=
 =?us-ascii?Q?YLYKNWpxSxtQo1EV/cj+DsoCoSLjtn/PdOm41Kw558TPs80E7dgq+O1dc+9W?=
 =?us-ascii?Q?AYBJgvSbICmOln2qdyhIROEVEfCuxjhA1iufdjZyEpbQHl4sxglKmqTJqNRj?=
 =?us-ascii?Q?waQIKbP4l8pJtunXLeh7VsVddcjIdGCDiASrUZ/pTfTY/F5yT5dW8n7wq/mu?=
 =?us-ascii?Q?ZMYGEy2urldVznhK3WAv3Al0uVJQSB4IgAVePqsOB3UgBSFlqogSzk/kkXvK?=
 =?us-ascii?Q?23W5UmWPMFLibgjRhpU7VUUEGXmhO3ONKWtPckoKmioVd4tQ2eIrrbGHdCd8?=
 =?us-ascii?Q?lwjuiB9HxDCE4cir22T3cWtogqMdwaoBl2e2WTvyOtdFVHGZKy1o47YswzFX?=
 =?us-ascii?Q?9YDzVdJW+tR32brEdiNy2Tq2MPNVrr+s1MisHaIhKo/j8rwHHYtEgj0cRzci?=
 =?us-ascii?Q?tTBqbkFs+UpXmvYJCB4OFGOgKTJrjJzrU2oxR+Cg7j3UI6OeypIIwsZekVYn?=
 =?us-ascii?Q?FGzlsWLd5AwfrBvmR6tBge1QP6CKNH7+FgAsW4MbezJihmYun2kb63hmK3PH?=
 =?us-ascii?Q?xIRaTvSGqqk7mX2l1Q/OdTSRwn/gGAdk5TF4IoChY5bk3MaKDruOrNdtUpW3?=
 =?us-ascii?Q?EQnmPw1EhBugyQIvqb2A/k4w4oJTRoDeYqyQPICtmsXhBkVkr7eu91+SajQ9?=
 =?us-ascii?Q?RskRLqqpM+PXB3QlhsaCowR+2Cssm7cQD7ftlPk1YqODG+sTeTCj2wnqcmNt?=
 =?us-ascii?Q?sU+E2kDqcP34B5ZoTbTZ84irEr7SrfR1RFvBTLHZ8z79FmQ9GKvJZjd20QBA?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3cf5ef-e6fb-464e-48eb-08dadd7f8e5a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 03:01:54.7087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oukU7/lOLKDMrlIbIUxcP3pAEM6CN7V+j1LZ/UyoIiS8ksNzpAqDa/2xu1CNJgOTw+7WH2JtqFWbwMUwEj8dxJE3z9Kn0cWafwcIATjLPSs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4343
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_10,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=957 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140022
X-Proofpoint-ORIG-GUID: HOMxpuIRUh1LGaEQDidVhqEc-azP4fCS
X-Proofpoint-GUID: HOMxpuIRUh1LGaEQDidVhqEc-azP4fCS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Shin'ichiro,

> When kconfig item CONFIG_SCSI_MPI3MR was introduced for mpi3mr driver,
> makefile of the driver was not modified to refer the kconfig item. Then
> mpi3mr.ko is built regardless of the kconfig item value y or m. Also
> "make localmodconfig" can not find the kconfig item in the makefile,
> then it does not generate CONFIG_SCSI_MPI3MR=m even when mpi3mr.ko is
> loaded on the system. Refer the kconfig item to avoid the issues.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
