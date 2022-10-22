Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332D6C38A2D
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Oct 2022 03:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJVD1u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Oct 2022 23:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJVD1s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2022 23:27:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67E64B9BD
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 20:27:47 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDoBF005601;
        Sat, 22 Oct 2022 03:27:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=LwKZ1iFPEDJBxl+wXqj8FDfToaBYi13/KQgOd+0adT4=;
 b=nMVuVoEBQAiXrsvD8WKO6Fce6X7REGV2qU11czfwGMtvdoL3ZijzvI0Fb6/qGA7dv/fr
 OYSevx4IJK+QakWWIt269UUSrSd4EMxXaF65hRWgq9KXw4TphaxsAfr34Xqo0HZC/QaJ
 5frCAmWCVC4HuawsBiOxA41bci/EOCvYw1cy1dnFBn87Dj2/9wASsJpm0E7mwEcuhSpZ
 kSbren7Y/ii8VUaSwr0prb91WliuGohhiwtbghkuIa/mhNEThBuMk+MvDEB+ZZapB0bI
 J1kXbjdpBZghtFI0FxzerOjZEKd8yzjjGcKwsQB1zZIUh4pZCriMP/RMk6porVCsHxfO wQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7ndtuhd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 03:27:12 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29M1X6g5032014;
        Sat, 22 Oct 2022 03:27:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y2ha5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 03:27:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CcgKtaE+hoP/gNn0alLRAKTkeoV2rCl/9fwX3EDcIyi0xo6M9OrE3vkbZ9kzQBwtkpmTlMILGo5xcxaw0CB0chUas8GXJacFdUo3sAeoKsg/t/HGVqMQVJf6VIXCQkiFQQ3Er+aZmhSIBTlWXKG2kGOJbg0C0QiB54rpW7YS3zvFO9x7iyBEhnTn17kNE0LgWrE0NdrcM/7d5JZhFmdcVV5dyY65zKttmDQcI2bh9ttOKRx3MPVrEFljMkXI6ITFitIcnIoFOl6Nf/0Suz/5j/ivNbFZobFO4+loH85w3NGw7KW4UUbpMbVJR6BLpT5y9W748sWShmLYq1fVk9dRjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LwKZ1iFPEDJBxl+wXqj8FDfToaBYi13/KQgOd+0adT4=;
 b=LF42O0NXJ+CLZxzN7CLHko3gDvxNb5PqL8jUtM/1JPHcaKS8bzfa7py9wt3KQc4lG7mma8/ENIRZTpWsT2CwhR1Il4dM45+rMefQ0qIhnNhvuIe26BTnce+McHT6ZNeNrj6Sdu9pyj6EERcrLYsKptKFTB/W781Bhxppc9jdLuVe4v77ObNv02BxUXdpSOrm8f4uFXxUnhtTnOUoFkkBN2prvNQ9Xhi++WsVQTW+m6ha/ftS5Wk43UIif+SWnO4NkvXcOsJmFgwnNzW4a6Pfn2FwQWTt/Xt5X/0EefF9aOVeEseLPhLbtTzcbz8z8Sx5geJsw4LEg1+Awl0j9c6k9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LwKZ1iFPEDJBxl+wXqj8FDfToaBYi13/KQgOd+0adT4=;
 b=VXkgioyQqwnsOPppWj7/cKg4dKGaowEyjCrdMEW8Pe1sTvPoADFnYMgmRBfCJFNAUfsofqS+s7PFTW5ZxKm2SF3PF1YSbaUddhbqrFhH8P1cxx3qFXrl8hOgWYNI6xLGs+fyXU17EXfPRL3rpYFIBKeAtfpMpIS0K1b/H9ngHLU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB6492.namprd10.prod.outlook.com (2603:10b6:930:5c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Sat, 22 Oct
 2022 03:27:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8714:e5ca:3c31:7bf]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8714:e5ca:3c31:7bf%7]) with mapi id 15.20.5723.035; Sat, 22 Oct 2022
 03:27:09 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v4 00/10] Fix a deadlock in the UFS driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15ygcwnb6.fsf@ca-mkp.ca.oracle.com>
References: <20221018202958.1902564-1-bvanassche@acm.org>
Date:   Fri, 21 Oct 2022 23:27:06 -0400
In-Reply-To: <20221018202958.1902564-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Tue, 18 Oct 2022 13:29:48 -0700")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:5:334::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB6492:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f6b2e72-404d-432c-182c-08dab3dd4d49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mFwZF/LB9D1MxLDLTg9mvi3N3LWoI3yDIV8GFEjn5aFBod89ezCDH9OyLxcCtvxxmo/lNY/Gj6BP1Agr73lKd3up05xwW3oYfJE3y34Om/hZ6Qo5omQU1GtiW9AOJnbTz9taivoJQWh2jm7JB8Poz5y2Wh5eaFGh4pV4ILW2sXiG/N6TMond8mpuB/16IlxlnYKVgthNNLlTYYFxSkzA396kHJ9WnKYX1u3GyaVe2+00CVmIBhQMTNq1ZwoPNAizHWx6vzat05ZMcUHTC+apO1uPlfUd4Bg1zjrfG+me3EbJSL1DXyQgd0CCmFrqiRzuHobyfnjb3fT7VLRQtUR7EfE5F56Vnpe1ighATK7LJw54S3jJt55vFc3IWYZRvw+BidAKwjPoyd0+wfJsSJDMoALKchSBKhyb6AoGt146U81tDVWogrN3yHdiCMmStpJANONIVpOwyfRU1rcBVjKA4zYj1LcKhLc71GP0XqSi1m8yFZSlKrScFTKspaD+Z85aHsDH33UyWRp5iLp0C+tV+SsMwdd+jZndTAa2m6RBqzAh0vHlvdqabrr9A9OVc7b8OZbKls8+FIDZW4gaAloIjM79KLQafsZtOQtqvfYN2t7Ik5BD53dAYhJAW1dzYQu8Q7NhZGs01Nsk9m7A+GinLztQ4YUXZd6xl/jou474J/a0cVP+Fub0iryQaIgG344xogvWaNlM/VqhLDxws+4bwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199015)(66556008)(6916009)(54906003)(83380400001)(6506007)(316002)(36916002)(66946007)(6666004)(8676002)(86362001)(6512007)(8936002)(41300700001)(4326008)(5660300002)(26005)(2906002)(478600001)(558084003)(186003)(38100700002)(66476007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uvwHd4a3LEKzAWkQKvMFGbwtJcQXGNIjOiEwNhOJsbc3WUAmKCGsg8oaAh7y?=
 =?us-ascii?Q?c8j5lUDoyqbgGS6TCTTzUycSkmSKkJXeNBYHcD8Wa2KvAeGfKl3AmAT0NKbh?=
 =?us-ascii?Q?z7bdsahFrfS7KmTLyRhyjPTnxH4EOH9AiLKiJmD5HcGo8vVfGzh5XWP3hmb5?=
 =?us-ascii?Q?Pt5eWTI0xqYK1Xnd8ZGPs2SaKKT4iSTSDfAEJRaokIaHYZlkV8ZYtnfpIZe/?=
 =?us-ascii?Q?Y/jGFoCgWj2ZztxkMlOwOHIYwsVUXgrJAbwxaeaxHaUCHeHty3nDsAG2+2Oc?=
 =?us-ascii?Q?xz48l1TDDHKE3c4YIrTAmheZSyFnip15huuyZ8ikUAolihGfQiYcaO7hO6J3?=
 =?us-ascii?Q?TNAg7rzg1JTHABsYMNSdETTDKyNxpMjW16dNeQWJNR0JiP2Zyb/WMLJFBlGW?=
 =?us-ascii?Q?lZ/XyAXi8SxR1xlB3AN+P2dePMrMuZV2W2Hvq7Tt6gxheNUnSpuuba4GBx/d?=
 =?us-ascii?Q?f6MMNIBjYEcQ6+nSKKh95Qq1llktgB69LRw20X14OdtcS/z6lohITZ1NgSyQ?=
 =?us-ascii?Q?/ovA8ih+3C5puRq5Fz5rRlTBmhFn5YP230vuLNF764kx8xLxQlTerrapOkMy?=
 =?us-ascii?Q?3o6nMxg13TPUg3ku4LmS2Gx7z88keTLiehZQ/ylzxaW4TW5sAHXfODwu2aeK?=
 =?us-ascii?Q?7N19UYKGUropBoony7x2GqsqVO8hMoV588KCvgNWP//czz1CdIjZN8WMgrRX?=
 =?us-ascii?Q?eprW31mv0y3GHicFiWmQb2ZOspkBWQ/gbDnVXoILlpwXjFf4ZL3Aosp219bV?=
 =?us-ascii?Q?fIofDU1u5hOM8Ko3R+OS0BO2qKeHd0bFycfvCwbrfHVwsDbIbLWffmCEgF3G?=
 =?us-ascii?Q?UQngq50YF9GtnUEhCrVdNdNmiM7ybuvumn0Yal9U+13acqdqJW04RM21KaHA?=
 =?us-ascii?Q?PsZUKj1smsW5Bmweo+RY/Fz3HXgtjOIgUo/8Dm/F579S4hki3oAjM7la/DjA?=
 =?us-ascii?Q?8Wp7D9AVk/Ju5+Wd+HWNzc9zS+rnM/dOBvwRgalSp0fpbTgNdI7XZIF97beG?=
 =?us-ascii?Q?+OYQ4kQgrR3LrSXvvPuyMz0ZAo3uksAy6dNZrVxiTSitvuHbsKTz99PoL/o5?=
 =?us-ascii?Q?vrmDE62kptEPVs/D59kvCy9+VD56W/g2m2dJDBb6f7QylVsZryfmGelrEtnC?=
 =?us-ascii?Q?OadfR1n2BYnIbu4NYsAZhe4I8bzspmdjh81LjYaMGB1cM4ugxUjgXTzFtlsM?=
 =?us-ascii?Q?QkdVW9HrBo+WNHqZ8NAUhmJXDMMw9q1lerpVl1otOcMjuPUDSa4bgcCx1jTu?=
 =?us-ascii?Q?gLMuw30ZEmLGDvXGTl6wrkLCj+EJn8ZAfrw/G0rQdNubXMrTArACT2HKYI0L?=
 =?us-ascii?Q?ThButsGzQBWGzv+1b4+pY/K1YYERgWF2nn3AVnU0QV/kPzNgk4sYAPTuocXB?=
 =?us-ascii?Q?o0vgpdRYyYdEIz3VZi5+HRYjAGf0/zz8PFQzXGVe9S5ga2I1QLUvDSPmCbdS?=
 =?us-ascii?Q?XbF6B7+qSCogdDVUPdkdT6Ti3J5cXvxWTralNX0uQHe2nIXW7PNPaEPFzBFt?=
 =?us-ascii?Q?FCZwM77UsE0GuQTuIAhdziO5LvXd1OmCp/0fSG1LMHS4kThhTMrr2tdcsr95?=
 =?us-ascii?Q?rVms39aFMSvuqf/rLY/N27qzruDnEJO9UD1+9I6cOQIC3/N/paamu7HFw0Xw?=
 =?us-ascii?Q?Yg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6b2e72-404d-432c-182c-08dab3dd4d49
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2022 03:27:09.4001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zlWun2JcfbVWt9KWHktv819Ie6h2Tm9s5BbrGKbjD0VkYnoN3L/bBmFTblzRCTH7CQoJOyyzkKrjFFtRjCSpzGp6lzEcBLL0EOLEMPJck5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6492
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=544 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210220018
X-Proofpoint-ORIG-GUID: F7FWV6BEL_upPor8gy1Brq4lYRRCUnZa
X-Proofpoint-GUID: F7FWV6BEL_upPor8gy1Brq4lYRRCUnZa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series fixes a deadlock in the UFS driver between the
> suspend/resume code and the SCSI error handler. Please consider this
> patch series for the next merge window.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
