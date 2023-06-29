Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F1FBEB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jun 2023 01:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjF2B7K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 21:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbjF2B7I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 21:59:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D402681;
        Wed, 28 Jun 2023 18:59:07 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35T1jxLd019775;
        Thu, 29 Jun 2023 01:59:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=hbvlkaGEkfiCoVgK+g1dQOOI1PNg+TUoOW+E7WEB67k=;
 b=YOoKLzdEEZD5e8NviDpCaMe/gRQJGzCTa182MVUtF9tRV88eXcO/O/ml1AUxevcKBccU
 ojyc2T04WeHisWGtbXM1LQ+Kzk+APlw3rIOatOZtHo9vJpoJ1qT/T/f6TERrOM6fIP/G
 VL2v9mWP4lLU+ld9F5Cx2dvBq26kAjrIuOGWwQIkXutLLEHKH1oEGaIr0jJwQ7hlOrBl
 Z5VNCR3iEp8i6m0Y8s0ted5JJm0REpHaACbIea3zWd1wyanAB9wpIeza9VyKWxxMDnJI
 yy1zCvAO8AlLC5LiGH7pzHBGrocIvyFD/zM8uoeX9jpxnDy/yhLQPm5SGyfaCLzfLdUI gA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rdq31257k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 01:59:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35SNlS11004004;
        Thu, 29 Jun 2023 01:59:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rdpxcuf7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 01:59:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k7/ugndfKlafKrJvaQqKjuB/WJBA+vPdDIKkwAm28ydBIp7BDiVjAUVqnf9B5hFeneBd+NJL9T3o9zky0WJG7IUqr7cKoPJUeh3dBmL89VvxvE7HkqJfp0FAhhaCuJRNjErJ1i3iqG9558lxf0M+TLCFP3Z5ZFlx/cMFhxXb8kH1roU2etAA6x8tX35yYoytVU6JSb+RMdw6boMJ6AJy7ohoKhNDsjDOwwm+c/VbTIv1pe4HGGpD548GsyeVklpEUnDHzMgE+PJfcteE/NbEW3aaJWs9dAOtuA4/yWQDCLY9AmC+u8AQQ+5Ot2vtUKv1M0SNELFYuXMLlqUxfRU+Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbvlkaGEkfiCoVgK+g1dQOOI1PNg+TUoOW+E7WEB67k=;
 b=g34gtWrZXkFHPaj45H2qW59Bq47/K3Pj5xzRXVxhbO6OkepOxVOysbL3+05kvnWiAYsuPXTREFGqpX7zcv8CJS97VZE/IwXbKjV1rqxJdhp0tIUYQMjEsOvfZWe1nv34Kgg28+YzuaAkTGNB3qIS5I+QnAWvrfBxPjRf4Zp3xfpGfepfyUYhFeBr6bDgJ1HbZzYyg73oS76FRKDIestrQSO903zusfsi9wdCtGNe4xmMqQN49hW/iLEGkJX/0QpQ72F7hEAqXNrv854VHn5uIpVFzP1UvOH9hHSF8YHgKIkkO25E5IHDQqtivKOSmY7Om3GOf7h+MoSM+AFEZkHTFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hbvlkaGEkfiCoVgK+g1dQOOI1PNg+TUoOW+E7WEB67k=;
 b=u46s1Yv46A/V+yT9AlcOVVNu5StxMW1s0pM+ASq6PyKgVI2MbcwnLtas+F9jrlPO3woxu6DOLtEpKQ9vKVPvbXenP8Dglox/iy96uZ+ga8QUayxq/lCoMF7SFejELVvbiqvoY2oF+wH723m8ei2SLqeijCdGuRd+vca3q3eghvg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB5736.namprd10.prod.outlook.com (2603:10b6:806:232::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Thu, 29 Jun
 2023 01:58:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0%7]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 01:58:55 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 1/1] scsi: target: Quiet bool conversion warning with
 pr_preempt use
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jmrowq0.fsf@ca-mkp.ca.oracle.com>
References: <20230623161136.6270-1-michael.christie@oracle.com>
Date:   Wed, 28 Jun 2023 21:58:53 -0400
In-Reply-To: <20230623161136.6270-1-michael.christie@oracle.com> (Mike
        Christie's message of "Fri, 23 Jun 2023 11:11:36 -0500")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:5:174::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB5736:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f57860b-c603-4148-de09-08db78446534
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R3Bd+7MFq+hBNAWqFoKrUo5Hya3iUzEo+6TQn4S9Gs8jpuOcXb0ikefPX4QY3LNhU9Es2aenWKEC10/fu2Xl0S+AZIgTRZk5pa+TyeiNpnND3bWKlmQG7jQW+qtLk3p6zJzDwG5uhtQFWpc97D2y+dFN4Xf3sYPQ6PR43LtgGu1/vvtGXV7Ss/oxkKGF6aeobPqv6ENZiHkKhGq78kOP+tQeDjoPGEioRXhvsE1CYCPDO5XGeh6wipzjZcKsvm/eZKkCBWwZSUtKwLK/EfHdl/I9ZTAG/Wrej4eAdZTEOEI68jKXpTDDAEvAqn1jmVLBcooyB+ymg5uL/hwcWseXSBXGFgwWzRMuoOCVsKM8KooWwCIcvNgH5W491xoQpKIUi4N2jF5PI73bwBY2fMtbNpW3NjV+20PmgxmtRaGu8lmF+ULCahdT5vtotVzAshEF/uG86tirgOVCY3QrER6ZcFfYYSQL6lf/TO+De3dgJuSmMtEuLjiq053J7qXGIB5HWf0LcfTqduBwGN+VKuz8J1DcDc9ggYJPI591XUURpGPeBX4GTrLhfZ8xLuEkSwr8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(396003)(39860400002)(376002)(451199021)(66476007)(8676002)(41300700001)(66556008)(6636002)(316002)(8936002)(66946007)(6506007)(26005)(186003)(6512007)(478600001)(36916002)(4326008)(6486002)(2906002)(5660300002)(6862004)(38100700002)(558084003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gHTnnRA7SR4YTO+MPyxiegM0OlYywkQGozBG/51EAjtzzeA2SjofEPf1vPBb?=
 =?us-ascii?Q?I+MldSEw66YSZb2lO6A/5kr4ruZpPhlWZKLyIFG79FXVXi7DvIjqxFHEts7z?=
 =?us-ascii?Q?KY5E410Jupx3Bat3LwSJyTD0exLvmAO7cL33Qe98j0pEihM1sg1IdAGnWsPg?=
 =?us-ascii?Q?Sp1o2VHEzAK3xAMCUNg+YBt3OPLg+nYhFMhoUrvgI/1nHiXuwVObaO2yh/2e?=
 =?us-ascii?Q?E48UM2T4zbG2/Oi/BBpy+VyAXVjg6U94KxtLZyUij61zW/y3dweFMx1u7+uS?=
 =?us-ascii?Q?yJG5M7XwjehR8Gcn3dpOAbWk18uKp4UQDlTl+MbLeZ3P3vrwWdfAWNtf3tqL?=
 =?us-ascii?Q?Z+YFTIm4yfPtnjW2TidRz3iH19voZHThHnke38iPLSAjjbsUO2TNnCyyhmyA?=
 =?us-ascii?Q?HYzxMs2ATLzzO6ZLZT6jDPyVR0ToW16GODxJVhhNekTAA4/Sdn9iUdRxmGw4?=
 =?us-ascii?Q?zX3rIrwHti7Khj/65wB6gwEjbl3Rq7OpKlTapkQK8dk1FHjIkBCFtI7Lhgv0?=
 =?us-ascii?Q?AUkPOKRvCzb0w9lggfCFuv/G5ShHQLzFtZSdy+Orc653P/tGgm2etVI0WciD?=
 =?us-ascii?Q?64juVoNk+uhmkya4PY6Smn5YLT0kpbuFSUuiXFJT3Cm5NvaFfWIDM7VwIdt6?=
 =?us-ascii?Q?VWYGCRagpP4cJg41V/6r2w6GZom/Hs9ndIkM4SuFvY75DtP9R/9J/9DKsBw+?=
 =?us-ascii?Q?PPsh49itpogxnQzerYm8DsAad5XnUy2FmyATd6YYMmzQswtG3+VsTcFv2eDY?=
 =?us-ascii?Q?Ac16LsVtDsfypq7CPUBR4VBHJBCOiB9qeuPRyYzMAOJ8aZp3fT7/eUk/G0qV?=
 =?us-ascii?Q?/pgFijy3na1Bk22j+FxdP5AAr5R0jp4MSUeRzaVeIXI9ZNbTE1VVUxpIwYs9?=
 =?us-ascii?Q?U4Y7AiZrPtgw0xiJGyGtP/seaazyHnNvpKzwdUbE9mFCiNG+qH0avZgkyJG5?=
 =?us-ascii?Q?6Vem6b5Q6Mag0zJ87BZmJ6Zlt2PfW0idTldc/sZBInFjZKbkSLukTmTGfn/X?=
 =?us-ascii?Q?LRO522oeSr4IEdTzH3s4Q62LeWUpgVN0Xm8NHQR9cCDl8fCgIpgfylujPDIP?=
 =?us-ascii?Q?9HsnMgoTOEIrVgp74F0ue6SzsaWiqE9I8lPS2ERDCeX0tRC9IJ4n2GXFqFpD?=
 =?us-ascii?Q?nPnxFPj1jq2SF+KUeSABzLSPKWHlrwhNSNPX5WzJH5EsLaTjX8JtczxccS8B?=
 =?us-ascii?Q?4/qvb8Vf7zGK8pMH/XyWD3IU8pxE/cwdQqFtrFS8UWzha6odIG89hQVwM7Rg?=
 =?us-ascii?Q?quOY/ssdgLb1sT9o3UIoOzlqLYQpO87CP18OkhOKNAFIZp0r+bFAl7ACb/7G?=
 =?us-ascii?Q?lxrcQMxz3+wZAGvnQRhJoGXyH7wfOsUv85/U8yg6emDCltbxFIPySp/TFuMa?=
 =?us-ascii?Q?hQFKwIi3GdNMHnk6gPkia6+f4es5L554aAUFXSdPMHT0uGUIunrBnsj4XVsZ?=
 =?us-ascii?Q?vqtGjPl/bZcfgTWxpd6xcR5pbiNcTf9tCIgMZExz+e640wl9ZsG0PRhpArmV?=
 =?us-ascii?Q?eYpLQUSyleskOF/BSlZEsIv6YoXwpzxhVqRrIY9eLfYZzj9PrUvJP+uw/CdA?=
 =?us-ascii?Q?SyXxqpHp8eBg8LYS9BkVpxcrndjdlgUjjAFYjQnoAc1wo+nmCABPYs6TS4wS?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: l4j/YwmTEnTS3t2V9QF6JG2nxOKniKWJjzb/F/skLGE2RK1U8ZguL876c4S1h7qmw73cgjkp0UYdn0YEscBfDvnDrHTzl8UuACkgCLuP8mJtj/J6Q5CPtZB+8y5FMTapjIR+adPs018Wgt0Xe2IbtTVrRq0zU1Z3rZhKurYC7OJTGSHt65GblCvnNnoP7bxotxZ25mszF7DqqbSPJNdUCfrMGmK3Y8yQsjtln+wwy/vbGqEbUZ7tKk1HbmQJYxLOu9zRQ8ZzApO3Z09h5R8SNa1nvxIG78ouM1xrLq8inOcx0f5AdKgB5V3/d6WWvqigYq4VvWbWlSuMKu64T2/VDtRPHTeMeelHdTaLUoGWnK2cyxSH86v7a+ZfKzAmulqFXZibW2nwcIORKKofgcRNc7AOgmPjKmmOeSHDYVWwp7JDo2dsUcOLmyVSQZAmvGEc3v5PVjmxyfUmkAT+ulrHzSNI/OFSu2kFI1QlfOm/EBzyUFt5q0RLDfgXU0bHyo9OJzi2IPzBjHp9617lMOVx4rTojdAoT7jnhfgunllmA8fJk0jAPrlHuQp3girAZEv1Sz1tj76IVSrNTc3FGvd5pi9rqfndwazRiVr08O0iLbOrr58N/0cqi8dPP22eMINsq9t3XsN3onfdUnOVirrA86PWrLHabkG4q/nzp+GwYUBSTq2TcdkS/48mutiopX3yEuQbt5VrNhh0TyqYPLUbLVpRFG278u0fQNM4rpOyONYy2KLSdINtnGrIN+64FHuZlia1SQ/C/e64DMSm6atqJ/Cn/CpIWbpm/CPTBF9XQP8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f57860b-c603-4148-de09-08db78446534
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2023 01:58:55.5227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UYfgjHZH9118UBPG2/BtKaSuozJdKwREvgyOIIgPPsYeeV/ZUxW5ClvWGfufVyxQjRtkPx3rexel9/++ttoGAuD5akldMqGcJe61sk+1f/w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5736
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-28_14,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=667 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306290017
X-Proofpoint-ORIG-GUID: _yDGWxudu34FZwJtX8YweTvmjGiQ3jMc
X-Proofpoint-GUID: _yDGWxudu34FZwJtX8YweTvmjGiQ3jMc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> We want to pass in true for pr_preempt's argument if we are doing a
> PRO_PREEMPT_AND_ABORT, so just test sa against PRO_PREEMPT_AND_ABORT, and
> pass the result directly to pr_preempt.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
