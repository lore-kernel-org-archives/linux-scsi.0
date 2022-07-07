Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8582EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 21:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbiGGVcs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236147AbiGGVcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 17:32:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CC93335F;
        Thu,  7 Jul 2022 14:32:47 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KDGvC005689;
        Thu, 7 Jul 2022 21:32:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Ri0NYhpDuQDHQcTFUJWM5oK6Y+QUnxyH4vaJGrbr5qE=;
 b=PdMgQJ6W/CdcqKnVmRiIB2qMRZoYSN8qJT9n5TQ8/yPg8j089uQC/xbDS8Lby0fAK3hV
 YtqJKYpAH5thZV6opRNm3i7brztxKkgd5fxCRdFUQ+hhdnXKxqtgF4+euCy2WFwNtV/q
 Wh1T/d7NVZcXpRiujbGabNV3nXXXB++W5FEtXRoRCka2LM2H++AoQFMQQ1UnBId2lTkG
 vfa2GNGe56mdKYqAE1bAIKUlqSh/Q4400YogWEyCmkZOGs5mU4j62zD/WzK4UE5ZfpXa
 vlGOefyw78YVV1pBoDkkRBtbH6B8r4fNAOHT5Bl5T8uCKktidQ4HvdQONyFApiUcg1cS zQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubye645-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:32:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267LB4d8014468;
        Thu, 7 Jul 2022 21:32:20 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h4ud227ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:32:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fn9AZ7eMjp9qTQcNdRnuq/WKd+vayDRmHep918GExhGbkgaf4zinLpWAMF89t958ZDu8gMutB7k3uWTxIja8P/eWCHGq/d1fyMzTSFMy06G+3XKk6g2ic8BR+bxsrHStvWigMgZCZ4R4PXt4I7YBvEuoWJyGMCo84T70PmQ/vVvKDyFh9ud5AXRvKr1HXFXeuF+f3dOLtyEPktgFm+Xu/YzlqihCpTIMBI5wqrtqz6jSbHQPxkNWSduRB1G7qVFRWPMAWTMAcw2CgSLJCyNFC5pSauvkwA0k+bNTYdkrFeo3C97MWMWxNaQyAqvCgzQ7raxEX+ztCLR8gn/MRiS59g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ri0NYhpDuQDHQcTFUJWM5oK6Y+QUnxyH4vaJGrbr5qE=;
 b=cYsvmTKA9zwmI/FAc9QKJNubRhSdoa5S309CrNBcYhG2K+1yZC7gcoIA4j+IXGSqz2VxzDddt97ykPY6NezOuVaUOymCEAnYVIHq0UjuKjb3Ty7hH8eHSMwAYMZ/NC9Ni76+7ma6ZxGD/RC+Fq4SaWimzrKfxXtNdv2FpAWEl1cPvovlOc4u+0HeLJseeyt8u+vK7iUc7fsiyX7ao9o4nDaZc4h6z3U6WGCHBcU53dAfTpuI75UvEPAm3VyPEjqIki9acJXCRezzG9ItisVgNI5ulTt4Qm8o/p0i8H3hg/7FsljItLVC3w9n7blY/JMesbsxXoFM/QudpATbuGz9Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ri0NYhpDuQDHQcTFUJWM5oK6Y+QUnxyH4vaJGrbr5qE=;
 b=ZKjqwIz+xsI/pdIDBRAi+8YZSVnomuf6oPgcaahT1QbBsVMKDJkOq3p4ERvb3F1ZInhCOJsZDn+kY+ou55GAjEIBWrm52N7Tbn7PG3RpaG5ottgekuDOKtNc5IrZRyGdkLql5DJ1vg2RdwFlYISFOh1k+nuX3Wbce/AyNnWraFE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB2553.namprd10.prod.outlook.com (2603:10b6:5:b1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Thu, 7 Jul
 2022 21:32:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5395.022; Thu, 7 Jul 2022
 21:32:17 +0000
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 0/3] change exynos ufs phy control
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17d4o624t.fsf@ca-mkp.ca.oracle.com>
References: <CGME20220706020540epcas2p37a8b697af2c6786db9e4ed67cf20a40f@epcas2p3.samsung.com>
        <20220706020255.151177-1-chanho61.park@samsung.com>
Date:   Thu, 07 Jul 2022 17:32:11 -0400
In-Reply-To: <20220706020255.151177-1-chanho61.park@samsung.com> (Chanho
        Park's message of "Wed, 6 Jul 2022 11:02:52 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:806:121::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7aaca6b5-fd8d-40f7-0396-08da60602a73
X-MS-TrafficTypeDiagnostic: DM6PR10MB2553:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XWZzW8tWTa1kAUtNUy8By98fAat7t19pcE/ZStlRyxxz2W7EG/jI+AJzfqx+FhBPuUbiuVzhs4CvMAuEOhwDeaNU5yZ9X0WNjhlRTcqVdm5yzqq464PAN+tWK9orb/z/w+Jgt2desrtrrrGd0Z05qRwoJzqOk+aXNybY5PWzShxcGn8RQlTViE7+GeE2LPZHPQaLwLFsLtfJ0CnaWu7dOatirtlsu79a80cBDrZtXwNlTucfpGLrNXBj+dgMBWedjWLdJoBtlxT/FUmzaGgBxhHuz7U/Q8OPCM4OfIU3k3cKauaTAWNAeyYdTzupBvnNsDSn8REjhqzziZQNrxZ//s2SD6J23uGFkoLbbSkOivtez+zmu2FOBNWxknLZf5R6GTk4236D4WMQ7QdfIoGIe4GuLybkXv0KDIi1JOLtBewTil2ghbHZofCRk23DUIVkilQZ8Vaf6eSKL23VuSzWslZ6CwCgkXs9h5X655h7eCprtt3xpLqVehWqoVsbHhHbZGfvJKWQv3MW41z6a4a+8/8Zh4y/zWgE+0O7vyL6774+KSC5kmi9s1mYRNkNEJY4WC5s2njHYnmR8ayd3T4dsUvjTra1g8LyLPP1Q1Ab0VJhKo36DjSGeZ4v/B8NgbCXNo5IunvlrWZw1BItypmCJaz3nb+3TI8v3K/Lr2V45u3huXnpRq6TIFo97PMZT9sd0nQ+NpCCCnKZzzhlMeS7Yk8kaQIuCdOXGV8y2uqMZ3lkPllytu+KGrPiUa/HlaV9ykxxqbNWwfuQUKC6/vjRYNxRE2jWruBuqM7tjf2EKly37lGIQxWBZU4BP1/YMaTl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(396003)(346002)(39860400002)(376002)(5660300002)(8936002)(86362001)(36916002)(7416002)(8676002)(316002)(41300700001)(66946007)(6916009)(66556008)(66476007)(4326008)(54906003)(4744005)(6666004)(6506007)(26005)(6486002)(6512007)(2906002)(52116002)(38100700002)(186003)(478600001)(83380400001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uuUcVcYzHO/cMGzCohErzI1kYkSvzOsRwb9SEVCGhzI7vsHsHV6zaTxCiu+y?=
 =?us-ascii?Q?mqlV4/92BdAZs+kVxJq1mK0IYwE3Bp8FlrCZZzexDcN965RzXZvvNbNfDxUo?=
 =?us-ascii?Q?itrME8aluL5RPSdxBbPhogSG4xpUGXAFJXsAj32O/yEpQgmxQneQbMeKhSw9?=
 =?us-ascii?Q?UqyQYzidO+XHBpAJCWt8erKqsyz2iKVSrD4D4ZFlIWNZjH3cztX3XS2OzGU9?=
 =?us-ascii?Q?DV7zqoihozCqYE6uh32gPsJonNUfa9GLsW2lVdgkn6VLndJKelXD5GBOyfmk?=
 =?us-ascii?Q?wPaUpEHrPuOQqVnGx9tmNK5qhOPl2rR8hhRCq1vBctemp+Volipn4zQ0zB85?=
 =?us-ascii?Q?KNXt4yeKjpRkvRFKsBG131LwyHnNAP85GRomDSL00i4z3D1mNKcxloq1W1d8?=
 =?us-ascii?Q?zu33YuDT3AkS2QQisogCC7cKmHkknQBIN5CgpNBSMh8EjPVmUuyZ+ht6/a/G?=
 =?us-ascii?Q?HAAJhDTfiFJlQXNU7nRa1ACLovuABDivBoxUT5NCkToEFV7tkh6v66Ln5XJM?=
 =?us-ascii?Q?uyOd5MahkrARC0iUJRY3VfgqglfGlkZJy7uTUfYdJBObZPKBERDcYUciTQwr?=
 =?us-ascii?Q?5mb4Tp0qN6pN5aQVA2E9EabANMIUhb+BTvo0V/hEk8ZnfOpTrjWshK+3iVe0?=
 =?us-ascii?Q?lKBaVK0jpdddoAeiGoYLBX/KBtpd/vdv0LZtx4v9Ho5uAfdbZE/9PJwm4vZJ?=
 =?us-ascii?Q?9b0o+2ZkyPoRzTLDNFbp01GpQmdH23pzZR77kelPMnmLVJ1ng237C9nH97Xy?=
 =?us-ascii?Q?D4TH2SoHUs2PeHV5I3d0lTHGB4Hhupdv3w4BOx+BO4ylITqA1gHyY0IIhewm?=
 =?us-ascii?Q?JnKepaMIHM6RVBu4lPXAAf9MuM6picvfA6rS5/TGjC/DaQO8VfHRXoJ7XVRy?=
 =?us-ascii?Q?LmNAM4IiAlPsZCuOQdWA+iSSP8DGye7f59drCpYYQOg45S0ui/VMmSqA+X8I?=
 =?us-ascii?Q?VSE3X63/egJF3EO19RiI38GQgsA0I5MTwm4WA85rWp6G4aUbCsdWvycNOR0L?=
 =?us-ascii?Q?mGAjTJotxtDVV8tDTd8k5ehS63kZRfpPcsfaN/DhIXPJ8O3e34u1CGgB5Dy1?=
 =?us-ascii?Q?7QZU4KKVIynbkyfb94hayEOZRpuURdoxDL2Bu/DNc5Qaeevi39HLk9OroMTn?=
 =?us-ascii?Q?DLo48KuF2PqlWBea05fynLhAS1F3uDqN8Aw+vYk6XB/towytHMnAzpKMHeke?=
 =?us-ascii?Q?ru2GtFQdrVBG45ZMnxSP44YQ+jmTp4wUKcNemtxcixyzT+A241CiMn/xzlLq?=
 =?us-ascii?Q?KZM7YfpkMQz1QN8J0MQEcMTaSKoLTM5H5hcxJscMl48hweyoM3YJKiDMN8eR?=
 =?us-ascii?Q?1ABdNk72pruCDiv3A7DXzlrJ1wuVlOmlFuJs27hB2NK7SKHcofl42vKGbMEZ?=
 =?us-ascii?Q?PYtn73XfklwoqD5/HZRjZqSGP83pIq9kZBaAmY3gupPMTHCKH/NeTCyv7lqf?=
 =?us-ascii?Q?TAti0+LU4lGT/ItcvGC9d2WnqQ9O7bVz6SC6R02H+NOc1/9zhlZ4jXNV3Tc2?=
 =?us-ascii?Q?+bEWC78cdIHP3wboD6OK71NmbsWpU2gy0C9gh5lJdxYpRxTckpOOf/69Bv0H?=
 =?us-ascii?Q?deMEGKC9mD4qhEQgzLvyRvbhXb+KcuOOkqJUBevAHZDWXUHjHPxdA/ltIMBC?=
 =?us-ascii?Q?iQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aaca6b5-fd8d-40f7-0396-08da60602a73
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 21:32:17.3216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AoBqWj9MYDoRPPcABT2uuIKc1QQ5WGv231fIq2xTphVLHZLPlvz0U/0FElQtOfUlmg69WrNd1PIruE05STl77gYVVfQzFvIgD1mnqAqbyBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2553
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=816 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070084
X-Proofpoint-GUID: OEszBX6SDOTFE4ElyC2indaIyJ7mH26s
X-Proofpoint-ORIG-GUID: OEszBX6SDOTFE4ElyC2indaIyJ7mH26s
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chanho,

> The first patch is for changing phy clocks manipulation from
> controlling each symbol/ref clocks to clk_bulk APIs. The second patch
> is for making power on/off sequences between pmu isolation and clk
> control.  Finally, the third patch changes the phy on/off and init
> sequences from ufs-exynos host driver.

Were you intending this series to go through SCSI or the phy tree?

-- 
Martin K. Petersen	Oracle Linux Engineering
