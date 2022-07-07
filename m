Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF73C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 21:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbiGGVHe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236604AbiGGVHd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 17:07:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47592CE3E
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2022 14:07:32 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCYZV015405;
        Thu, 7 Jul 2022 21:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=uHGBgMJMFE70tawjYP2v7vybZhTEhEY5TmOksmEHnAc=;
 b=fRjOO9FpZ/cZYyzqvN72QrgP4n1loVB/P62KsvxrMnTXfMSsMTkB5oE8B2NuoVB3sw3L
 dTQr9UZpI3Obaq8Jmv01jhEk7YiJ4E98Tv6Nn6qcIvmekXts+v+Jcm0xmETWZ/AYe9OO
 NbszNn3GONI/CfsfyhVk+neRv2QwNjUe8+KPkwzUAyEqrp0tRVWWXh97KLXecNvefZQ+
 dK2g6YOKU9ZFkuX9NnTCmffNITM8SezVn3gnjc0QiMIEHrcQSxxIuPf82t6MR+XhCag7
 O+nj8YbAE89aYE4RapJpqGoQyFnOw3B2WXcGAaQnXyKhLyv/A3+eMzo9bZRMETGn9+J0 Vg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubyx95t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:07:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267L1MOj035839;
        Thu, 7 Jul 2022 21:07:17 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4ud7bf75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:07:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPY80lSvHd57kEV6db2Kv3FR/6o2IIyC1VZMxjbskXJWt5062iq5+l/4Lyej2xtxmUhv55b3EgiXjlz/C9MLAOxbQOZWIBmhoLDhajWBtN17SI7LWrBuXqAnZhGGMaGUy155AACGofUGwUqW02Y+EUeAKHSzU2/hTOgbKvGsrhUW9a23IJ+xzxMIsVgfaxqtt8ft0CrEI43QAQd3ALpi8w4RGnxFQ7EjLbCvt65eg3Pug72gv1nmlhDWKFRPTTonXM6Jww7YHzAnZaMziNP/LObFYLbdex881FQCs6RKyEMrABtkoRdiMCA6ojLZB3AXZGDIY5C8vqJ5+im/fW10Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHGBgMJMFE70tawjYP2v7vybZhTEhEY5TmOksmEHnAc=;
 b=l2vsHnsGXsMnzhYzX2o6YnleQhvo5DHf95KHRyeo2CEzcG/wR6tkxC1X7dMJDmsbHmForxD5dfO9Cyjcl9GHaK2CXNFAx71ExrcuVcYxX1njAe6HrUpr+vIhTi5rAfBvvv5kL7bWFRlsN5wtWJubxX9v+D6e53KcjeDb9139PSN3Oa/NzzffJXchP6mjAOaGgULJl0ltMDde5BQ2poPrgWpdlYsYXwV3iWcm9YnSi/2GXlbKY3nJSacn6MN4FOCGtTzzO3MfgEAb5bCAElf0CQoT2HQZrDO0b0SjvVtMCdN70KrcYF+N+ga+m+TXMsaS9W6JF88JfDfbPd2je+STPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHGBgMJMFE70tawjYP2v7vybZhTEhEY5TmOksmEHnAc=;
 b=Pt0YwZsVjIAwjgSztoJFRIu/Pw56lnNQi6CRhXIrBQkxiD7fTY5U4ch9251Q95CpipXWKd2jztHgv0b30BaJBsxo75vhSgh0u7pt/iZ/moiKZG4IGpQnXA2LDDq3US6OI5h3UZTDajuecOI6oIe8Nv5HnsMgUNIv+fxpLkJBDOY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN6PR10MB2845.namprd10.prod.outlook.com (2603:10b6:805:da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Thu, 7 Jul
 2022 21:07:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5395.022; Thu, 7 Jul 2022
 21:07:15 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Reduce ATA disk resume time
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tu7s639j.fsf@ca-mkp.ca.oracle.com>
References: <20220630195703.10155-1-bvanassche@acm.org>
Date:   Thu, 07 Jul 2022 17:07:12 -0400
In-Reply-To: <20220630195703.10155-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 30 Jun 2022 12:57:01 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0201.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30df4c4a-18f8-474e-b5e3-08da605cab59
X-MS-TrafficTypeDiagnostic: SN6PR10MB2845:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3WesoaKLMVejYPVBZJ7Zafj/5mZXvkIo9KumED1OK8EoqGZdW3ksHOPNBBj7NK7GQ8txMfVy9+2MG4R+U7RY4xu27um0IAHzsDWNLFfbjCXnKR9CTzHg4Te5caBAXJKwld7eDOZNbDgxVgJYY/UgrLEC7b+D2WoUxT9CZCtNR2RKwJ1JzwY17BYE9spWl+gux2htwcgTLz9PuwwxPAkiTkuETFZUskzFisAJ6cd6ULuL89TmsJ/MPzoQ5LAXXagBNXmW3w2M3Jqh+LXCINDpNZJ9oCgkbR+9EWxiJ+bpOsmKK4ySftNowphAdCLEqL+HuA1LMFksCAsikbUNluSTK2iffkMTQUDekyQichB4+C5cE/5+EYvScIAtMo7JJpiTT/f9/UVePBwZoYisotcvCdryqNkfZaJRQPDtig2lJ1wqGS2nCxzwugO1MPDyYU+lG4yyei8cR2SgHKpl9mU+oDX324/TPRlGU4rSNSdPorLRRoQNouIyqAvFtJgNRhGkvvpkO2FzEVL1Km/jsBX0MIy0iZha6bnjGVRr/TxqYWkzPC1NEeacGXOV5qK33p/ESwK3jyz9nQNhQSudmOV+H1gwfqSg0ossm/z//wChXBKGSgOySaugNtvbdxcBqaBwQG3copjE1Thy6+2ZafACCczfJDpsQOgpaww0AecGCobBJj2MaQytX/+wV5b7eDKJHeW9CSWDGJ1ZmoYgsUi/BEUum8AECkHzWDx/50m/35V6AF35+PCv0j8L2vy/IlpdpdVvBf4Hi7wp3I9TGsu6zSnCSfV/1poEzIki5LRd6sP9erqqWZr2/+3qzrp6Y1yG5eacMOphiIqShSSDXiPtB6BnBbIc+b1MmCCfaR6Q2JE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(376002)(346002)(396003)(39860400002)(41300700001)(6512007)(478600001)(66946007)(4326008)(36916002)(6666004)(2906002)(6916009)(6486002)(86362001)(316002)(6506007)(26005)(54906003)(52116002)(66556008)(38350700002)(83380400001)(38100700002)(8676002)(8936002)(5660300002)(4744005)(66476007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2mNG/XlAkgp+V7mAi3sS98sMZckJbI5jx5E0fbeobvWmEjm/KMear2SBPE+/?=
 =?us-ascii?Q?NraYwONActgIiqOwDPCeYLKDpIuzk/Q3+TjD2wgtBFfsSbkLibWuSqICYiNb?=
 =?us-ascii?Q?BRMQITIOV2ozeyB0x7XOtdKVePYz987XJRAC++zRoWw6+LLbGabiiBsFs1hg?=
 =?us-ascii?Q?VKWshoQ93LbWgnAsM5FH/M5iQojD9MG/3Aw3W/hnSQikmCdIphEAJQQOHmW/?=
 =?us-ascii?Q?+t6YEbVTakeMSWysE9MpY5rIk5XObmj1IeOz8Tz0HXetstoUC97I6WEEbfQg?=
 =?us-ascii?Q?QR56SMAiw47Rro0NfpRr0YkRVmBRXvcnUAqt3BBWDmeR9Bks8GP0cS8re/ji?=
 =?us-ascii?Q?MzYoll4l7z4qBsDmLoDKI6MK8OwOiCuNs5O3eNTcouwMnQX0qCzjabIuXwcN?=
 =?us-ascii?Q?DhQ5EAPoUPVTOfQm8U3RFKfrnfagXnaMhNDCzqRafp+sy2sqxAb/MsEvkyte?=
 =?us-ascii?Q?PpmTHqdS7hS8rT0Zm1ks/tzGhAtvZY1A1cTaWlqKEnlnh5Mpli+Lgan52tjt?=
 =?us-ascii?Q?f8YhXbI1vyh7UPGDBaVhvicIEFI82rVoCitZ1RV27hKodoXqR0xP/lQ4cRbN?=
 =?us-ascii?Q?E4oFZp1yd8RSB3gXLIXLFYzxUKSnDWG54f68AQfW0qBCV76bJj6Z09tbon/R?=
 =?us-ascii?Q?X0eKkzdjiKngBhCDzGJAFP8VEjJRcMp3nUuoTKaDeMk8kKwfIgDEvF9DyKr1?=
 =?us-ascii?Q?KTIwwtXi9vGCCIPfCJ4R2ew33M9Bj145UTtAe0QnMtDLXdrKslTwQdpvVFKd?=
 =?us-ascii?Q?6UZyghY3J/CShJyFsgIOMM1K3PySVcU6AXRN2A+YzIDC5/F3k7H8zu0QWWd9?=
 =?us-ascii?Q?fJE95aNm0+oN0thjsSzI7T6foMswZmj9kyFhwJKdq0B5lZsvJTTeOzEVcV86?=
 =?us-ascii?Q?geDyU/lI4qfrPkL7M7m2aPYeX11r5uWM8ZMoMITSQMcwO1rRiCV6tlb2e+yW?=
 =?us-ascii?Q?GFTCN4WFoKZbXMp3N57xqGAqM/WRlh9pix9eFIDZLT2iUCL4DuqtNu0DLEa+?=
 =?us-ascii?Q?YlB3C6HkIDD+8n80gl4zQ1+jvK2yboBfjrCS0dKDsG6RSbT4pXNEmXTm46WM?=
 =?us-ascii?Q?41w1KRJrqBOqvrw8b5pBwnDVIED2CAeW3WBucJ0PpUTEtkWSj7YrNQZ+EaIq?=
 =?us-ascii?Q?FPTpgy9oo7Gt9ZvBa0HsoVJgYWS2dpndywK9P+lIorRNIjIG3U4yf6iyssRV?=
 =?us-ascii?Q?0OZZ3wIT21ht2uAN1tFu5KAOL71KAPVkmV0xrU/Kjr0IipTPhRAMhw40m8Ou?=
 =?us-ascii?Q?JYhICVE6EroF0ZhIfj03Yh/IsxiUaARUa52SKT28CBEzzUbZ4RApmAGSRWvz?=
 =?us-ascii?Q?sdcmdCceKwG5zkfgXTA5EU06FwTvYLnlhQ5Oux0uk1g/eKSpjuh+Wysgf7K+?=
 =?us-ascii?Q?EeLOfMU8tBnlpvztvm9HJ222UxBE/jZBY/GuxXTf2GatAPNtGOoZxV8KCMAW?=
 =?us-ascii?Q?KfUsXldyiKMDJ+j5lhdY7rS63h073cnqLSCTzENJ8G/8OPidu42EgIHtDqV5?=
 =?us-ascii?Q?Grrz+cduRcPzyg3UNuPTVNd9xq3VCJxg98S/FFx+Z2nf1tcTPrJI6hkSF0Ms?=
 =?us-ascii?Q?X3Mnr9oBFybVSAELsuOHvJTUog6fP/eQVQMifd2w9Hk5/um3Ktq0sh6ve6qZ?=
 =?us-ascii?Q?hQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30df4c4a-18f8-474e-b5e3-08da605cab59
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 21:07:15.6417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fblyGnTD7WE38Nr4I76l4XW9tQSeIgRjIgabna1JsLu9AuQxreUN1pZsL+TMBnxigynHEvCWk4zeLGMg1OtOg3wav4Yx3fLAuQpg7PuwFSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2845
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=641
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070083
X-Proofpoint-ORIG-GUID: S9ppIkAes4p1mSPMdRyLcHyG2kY8l3ld
X-Proofpoint-GUID: S9ppIkAes4p1mSPMdRyLcHyG2kY8l3ld
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Recently it was reported that patch "scsi: core: pm: Rely on the
> device driver core for async power management" causes resuming to take
> longer if an ATA disk is present. This patch series fixes that
> regression. Please consider this patch series for kernel v5.20.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
