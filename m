Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627B2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 11 May 2022 02:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241577AbiEKCdJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 22:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241636AbiEKCdC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 22:33:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC9C6B7C5;
        Tue, 10 May 2022 19:32:57 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AKu3rn023623;
        Wed, 11 May 2022 02:32:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=yULIHoCxNXBzZcTlSWRuIUcjVwhrQ0zzhO06SJNdd1c=;
 b=ASCROJAFB6WqlJ1ylUN6bTDZIYngsHWzpSsVsaoxoS2/L4OjEqMyqkN9k5GL+7epo2JD
 kFvtUdqvMoKGOpD5iJQEZcA+RE/M0HeuqnI1SMP9KHg+qO1iw0B9ANnymgwvsJyhHJQ5
 MX1Tg0IzyQeOzVHy2AjKjJAxBfamfyPb/knlVrJOSUmJ/ltUMZnLWMr+ie3TURAloZfV
 hBm+emus3i4k0oDxkpu3Z4F3oh3ADUJSyr3WDuXWc6iTlyt2U5of4ZjbP86BuxEv4bs5
 Krw8s6poX3douYw2NazylXZZdd5jbqdqbKbFGaQRzvf/+/rWB9IB3PJno8ti4wzfZh9G aw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgcsrg28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:32:49 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24B2KMPk022247;
        Wed, 11 May 2022 02:32:48 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fwf73hfpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:32:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPcLVFMXncKWyNK6/6hVJGttHVyQPHaS55tXkvav8zxwGd0qoVLHuppl4fL2BwVilr8DLoHMDiJu7sj4LVnge0AbuotFNi/TAG7HOTcw5nQI651dogcbm4nT9JcaCPMW3J052LGC5JwV86XCvuSpmQmeZIivYjMDfG9vztvr8e0UCt7jtczb4KNi/LW2lxeA3jPRf07oEz3ruOdS4tQ1JgloqvPv7UJh7q7XdQbsX3K+LxD5I03vV1ClR0CIrAmMci4nSFieN3THCNyvigCD5Dd3ZrRuEMhiyfhCmoOvL3J9ch73nSZX61hNHxYNSAFnygXFiF1cp2BolxPWzk6hMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yULIHoCxNXBzZcTlSWRuIUcjVwhrQ0zzhO06SJNdd1c=;
 b=A6lDs6nPBrH0GSYyKoZVscMBwF/WNZZ4J1zZl5EFcF8OoGpXkzcbOA09Ho4jcecVBP6hVe9h6w17cFll1eD0J2+UTPFCKL5v9WwYupPqUilrkerxQNS8+cXlkGIWzjO4d+a2fGnV0tAsBGQcObNovh8MDjO7yjKE2VwoMorD5LyEzBGI2EhWlorWHH1QP5w6yoH7DvEpbgeVc/dicrNuB7P8AdyRFVMQUbvVFNFVtE5ZDHNttJ0c7S8gcrXjkQ8emCjYxJ46AiH5XkNRpkRbVPtjWdXtTOEIzs5gdJejeUDIHR8EUjdzhD8iTOAvPtLNog4IAiwBGBUpffT6DFPi3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yULIHoCxNXBzZcTlSWRuIUcjVwhrQ0zzhO06SJNdd1c=;
 b=K98YPO7vZ6JdYUEYCpnJhlU+YHqD/j3apxlJ2w+XhHRyGgZwn6ZkdmpE6qWUMNussTWmh8/STHgmo5r3fT5d3vUYN6EdPjAXX/7fFaicdZdXM01PyC3sagKVa1Xa753NpaSBXZ5Rq7R3m97/9YxgX7IOfrvoJlNq9uJXC34jg50=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4569.namprd10.prod.outlook.com (2603:10b6:806:111::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Wed, 11 May
 2022 02:32:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 02:32:45 +0000
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <martin.petersen@oracle.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <michael.christie@oracle.com>
Subject: Re: [PATCH 1/3] target/iscsi: rename iscsi_cmd to iscsit_cmd
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czgkyf28.fsf@ca-mkp.ca.oracle.com>
References: <20220428092939.36768-1-mgurtovoy@nvidia.com>
Date:   Tue, 10 May 2022 22:32:43 -0400
In-Reply-To: <20220428092939.36768-1-mgurtovoy@nvidia.com> (Max Gurtovoy's
        message of "Thu, 28 Apr 2022 12:29:37 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SN7P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa15b15a-4581-449c-a656-08da32f687e0
X-MS-TrafficTypeDiagnostic: SA2PR10MB4569:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4569E717B85CAC483EF060938EC89@SA2PR10MB4569.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uDOJsAdLGWdZ891SuNgA21AE21dMZIXjKeBILX23/+YX1sCU61e7YOIJ+AzCrZcb3CTvTUoVEO98Nhu+40JaZUFdP6QoD4PZdHlLgZx1XRbVMLe3mEbQ2374TTVeAdaJXujngrQN94HQq1D46YQiGrpECdkDj70mnlbmySjpG3FtLPoyjL/CRaSS47qK46kWJayV5U6pbyi833w6DCr3EuC98RGVRi5r9sPjE+0cSr5HHTWgKpjDqh7JFKmPKR5kaLN7JSYZSpxxDIlCycf+AB2twT3bRxg4ps1moKe3uWdWtow4HqdDblz5ZMcjktcofSuuVNwsau75NmojezfcgXOaMsSXp7jkLcmTnaC64wilTiE4O3VwvzrEitBzSQPqOJx+FZbvgDswDEE8sxZ8VIpQFQA21ATgS6jMOjQl+Rr2tfZdjTu8BPNcI74V0nAsB6C9eLBCzDaCM+VKevjPaxXGlyA9joZ2oLeES35+hSGKEG9hgdByxoXkLCym8OsnvuO0ck5yMfRKEoQRCuh8YikbszQrUaFkLOtE/csxU4eGIjyWBNjftrQfeiwAYE/L05n6yStGj/KfNOKlvFyYvlZyXXbbL5uPIaSQ4a62Cvjw8oZst27OO+IrP5Jhnl36W3OLtD9fTDczLACBrZzvxdS4l1xoK/TIeUcVGMPLNeLfhSP5BeBlxACMmtwB1W8t7WVNb77QxfBJTMjyJsuoIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(107886003)(26005)(6512007)(558084003)(8676002)(4326008)(6916009)(186003)(66556008)(316002)(66946007)(54906003)(66476007)(5660300002)(2906002)(86362001)(6506007)(8936002)(6486002)(508600001)(38350700002)(36916002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hiyJg71EgFOBCHreORRIQoi70yRLNcWdc83ZgJ3uStm2gwCebjwdDRx8tw6o?=
 =?us-ascii?Q?0CFC0NOdzcb3AcfYHpa3X5bsLoQQcECa3WZFR25TkId9+TQ6EPbyhjQemavg?=
 =?us-ascii?Q?Aazda9qrZBzeQaB60X/BD0TZJsI5mlNLjXBeL7HgcPFiYAgPyFd8sOHsGbJh?=
 =?us-ascii?Q?B21R/eVcfOa0/ZUHwijNG0vrpxpv7/R8yOu8riNfm1gL8KFk0vXfQt6I2w2X?=
 =?us-ascii?Q?gDf/SUgp5awad+1h0a4vwlKenVb6k/H2iBmt6+Cy+6TzdvVdfTidS2/ZDoML?=
 =?us-ascii?Q?z6DHDs7r/pZaYaJgFoJ3hqMCK9cvYGKBWWtvgKtk7RAH8fDeKOse5UQ/UI2k?=
 =?us-ascii?Q?Y/eDNtE7kVVPV5vNrGXmqhv8R7Mbq8WYLWbwwHIarukRVo67Mnwj38GEf4Ls?=
 =?us-ascii?Q?+9n52qb6Va7LPExD/wIF2OjP9hUoIae2fGDmpnO3TijwixGuLVpgAdOIv8Mp?=
 =?us-ascii?Q?o0PCOJfbY56vWdgA+XYH7PrH44VluTThT42eUfw4HTEio8mM70+VoLuxb2bj?=
 =?us-ascii?Q?AzA8CjrCANWue0F77LBcUnFFR9ssOvtlyk7z0/U/HM/ka75TUPaWcbfEBqgo?=
 =?us-ascii?Q?3DYIpwFRcRuhLBYmvMB2IIJ078gblPu5G1CpdlNAe9O611pkBEuV6Jh+UuVb?=
 =?us-ascii?Q?BcJz5YF3nVcCegOlCWcbCYN+Y+vh5UO8oiFKK14J9yj0upz2P0Wn2zW/Lwxt?=
 =?us-ascii?Q?kbYe9Kh5DZEBWSf1EMSDGGwGgvfsB/XlEs1EMXokPGVxRNw7U5ldmKIWZGSo?=
 =?us-ascii?Q?Rfef272jSV7zuORMvY6TdGjGiXKuiVyYOUkZBetmvSruGUHvJq8d16sQt+vN?=
 =?us-ascii?Q?kzYE7vMMaYeyYdm9MQT/tkMjLmichl3d36KZoV9iE7/A6IcZKBzkvvDIW4ua?=
 =?us-ascii?Q?eipxBJN/TWLzC/ub4K/jzM0rXGy4+GozZNauEXT13FHf5DpeffoxG/5KCYrp?=
 =?us-ascii?Q?TQaKSTKt97Mc8cUPP5gdBKcXEgYAo0//z25Cs12aRkbLvfNc8s9wEyBGuCaB?=
 =?us-ascii?Q?t8wlS+aaM7M8v8VZ7nSV9m+05qXNgbm5H+ge+/g3lDRQXJTw2O5G4n8K9a9b?=
 =?us-ascii?Q?jy+4bJbHiLj11DirRfjF92ioNzV/kYd55zQ8FPy9bvBbe2CScmDVHuolZqRa?=
 =?us-ascii?Q?26j/daOF5+Qu0QOGFVDT9mvS/ypFMv3gH+83CTGt+BGqk3Zuz0p2c4z9pIF5?=
 =?us-ascii?Q?heOLyQxNhHC0nkO6G7OE3Tc99/RJwiN4rBYiiCOgWia4w54JKuhwPsFSijfc?=
 =?us-ascii?Q?Berjmf7mtXJuyhtAxaXn5EfGfbSDr+HF7FQaBBUeTOgFNWkAcmRRwEGvhLUX?=
 =?us-ascii?Q?02G2gQwm1DCMI9oRmrvKw1nR+Ro3uZJJ+G9mvxylJzCH6dD8vIlybXzXiy97?=
 =?us-ascii?Q?24H3uIaJdoBbyPd9+1ay6eCkemfUemy8ovrVqim/LbMs4l3SEjcBO+ufYSBP?=
 =?us-ascii?Q?lcqm8KKPDY981OXhbrfMjcMdzs1CRkW31bnNzmZzgILbWVVYY5bKwJMkgSHw?=
 =?us-ascii?Q?jHwgvEb+PJvtuPdPC917ddXfeNGqU3yGrmsaTYZpmk2yb+O6b1pnDvg4R1yE?=
 =?us-ascii?Q?TZIK5n5tZTDT1jX+G9t+Isz5//bZR8k94V2OeFR4mzwkMCTovF2LNO4d86ts?=
 =?us-ascii?Q?vV/F/Ec2j7/pdgBqv54azbUp6FlnIOsw79SgSyigJZKMLOgDzH+IkRplZIUD?=
 =?us-ascii?Q?3/A2x9Ko79JqmgBubZd97Qd9IqDp2bX8MwnNZ7Z72nIXP4zdzM0+WAln475f?=
 =?us-ascii?Q?BRNfCNwbcBBUsogKlUVRM1EjxJ3F9wk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa15b15a-4581-449c-a656-08da32f687e0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 02:32:45.0586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 45JKihAOCZbwuQ7Qsdji5C2pFMfQsOCy5W3eR3hZbV/v/OV9ii2+AzuwsXqon4yjmyKM0m/im+mOhZyCxGWovAnNwUNFYRR+1RQiAVY8N1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4569
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_07:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=617 adultscore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110010
X-Proofpoint-GUID: wxh1oeZXPwA-5rOQ_b9KzJGwJc0UBuCB
X-Proofpoint-ORIG-GUID: wxh1oeZXPwA-5rOQ_b9KzJGwJc0UBuCB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Max,

> The structure iscsi_cmd naming is used by the iscsi initiator driver.
> Rename the target cmd to iscsit_cmd to have more readable code.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
