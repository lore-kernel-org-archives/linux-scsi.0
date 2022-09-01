Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A828ECAAD1
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 04:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiIAEJe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 00:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIAEJd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 00:09:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F44ACA3C
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 21:09:31 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VNmmlZ028371;
        Thu, 1 Sep 2022 04:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=8mNRgWTqTbdu2ZgEZjMIM2yRvFl6S5G/Ged+uMqlL+k=;
 b=C045HEYsz4xEQptuPginFxwVQx2ZCma/Sv3hzhQkJ2Qh6pUatBKc2MB2/HeSwYnIpyiC
 IwpBompVCxIwryEsKuISBD938o3uQ5PR39Ai7kpDrqYGYg+GHjLdrB+vltsPiELtna0R
 +yIhBtz0vYMUPmC557dxyMZyOW0Mcm3zlbjARFZJHM6USiTOVUXfJV6E4IXEpYkFRCU0
 0rv7E38txha3+k93TRXBKvuERyuS3wEam6vUXX9kl6VdrhEwGkzdTaBWn1q3wL599Tq9
 k0yXK2rzN7yEFotKp7rq8AOQXOBItREsDdUOJz+VeCxX3R7mevyIoGq5DgeCTf+xYuRa Iw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7a22awuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 04:09:29 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2813j4rT037809;
        Thu, 1 Sep 2022 04:09:28 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q5rp1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 04:09:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjJQVdT0KGdlwQEsQuZeuffmBcT88hJxozB5I7iCjEasahHTWCaoqN+ubJImcQ42x+y0Zu7Zk5/bbYPEVf2LL6996fCcFQ1OI9HHyD2QGBPr8P7L5TzlK4UVV1lYCKL5tFEXtyNgHwZZhm3sBG4vBSjoWeZCvq9KGrVyfn3hFEHt0O31T7+O59GbhlT46h4PYyqP5ub0aJqiXmIcHVsWHt0wjNCFxT0QwjemEyosbIt8UeA6MCT6yBdViwSQ9Nw6Ma9gxmlPYQgFKLLk29K5+LujgJfnsOdC4cGfmEoVS++27f3CWF7c+mY3nsYffKFlL902lEpmYlaIcUq8A8BeAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mNRgWTqTbdu2ZgEZjMIM2yRvFl6S5G/Ged+uMqlL+k=;
 b=MLZFtVOpV1BBeJHBrBT+7abm1lAybYFQMqMitPPKF9vvqkomDD85/t6tTy4OsdZidPN3PysJrc8p1zk2FfYz22LwyawUOb6jw7KLDCexhGjbRUSv1pBDC3OEIWMVdJJyI8lb28uQm4YX06dLbc8TXBimq+uTB9BI5OKehMASfjYCJKqzCCadhaKpw7JsqjV3hfKOUQWz5jnMuMeq0aE5HBEvx2KA4EyuYKEtZZXPbLpnMfbgvS5FntE3uLp8UQIPwhUs23aNZEcXyH9yRZCx+Iv1VBgiKlqvAlx6yS0ILTXWTdIo7G9ncxgabZjEDcB7XJE2rsw3V+2jEBkfX9GERw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mNRgWTqTbdu2ZgEZjMIM2yRvFl6S5G/Ged+uMqlL+k=;
 b=XMT29YYJbJHVgzzPlPjS6ZSFteZOV4JMya4PfZHDu2Ujxp96CITpA7ks0Y6aGzvVg91d/NTzeePBTFSiHpz+DeTVn1xDoYDyJLX/Oi31bOKanAtYt7ethjFSXllFHz0+gZvWh0yJbpeiaXskVCOfFJivCH2qlQ6Q5Fw1bSiDtcQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 04:09:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 04:09:26 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH] mpt3sas: Stop Error handler escalation when device removed
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmgfn3bp.fsf@ca-mkp.ca.oracle.com>
References: <20220816080801.13929-1-sreekanth.reddy@broadcom.com>
Date:   Thu, 01 Sep 2022 00:09:23 -0400
In-Reply-To: <20220816080801.13929-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Tue, 16 Aug 2022 13:38:01 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0010.prod.exchangelabs.com (2603:10b6:805:b6::23)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0573728-9b2e-4684-4b9c-08da8bcfc29c
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NDaDjUMkviHHH5NXNYbd3FwuWhHc4sGgTOcKeki6K+4ej1KuRSmRgHD6QI6N1UV5iKtgMn5iZ7lYmlHvPeohmvUDvmh+tkqNb72pwLBIN1+dqT/zKYwFr8LOPyBYm+IX4TI5INTDfchDqRMe4Tpj4he9qtiNrjZ5F/HZf15zwN1Ofj3m3onrzUTOV1PzW6CX0bLsidrbT/AZ98xt+QegGMzsh/4T7joN+qzHA8OcpNpy4O3vN7NriKcAvZuEVeqorJShILJuraUfryyvnxwOa2ZB2AEb0AW4T0bCc7H/TwLJIqLO4lSFAoi8BnwAvmktUoWO9nNNzQPryuXJEST77mrZnqifrJvupQNHpa8NoHYzE1bnIWcYERoyctsd+hTPo6yBdjXdlfJHEqtdnw4Kuw7eUVlfxu/eSmTEsxkEjQyA/LskSQq4tlqMXTFsO5/LKD2jDRpGvunerijxnceeowJo/mBFVeE4E5WNRjqMkvN6HOFsxP7OCPSSTkZmfboHcD1cE+xGimsEOkXjFEaDsrfmFA60yEtMMwpioy3TWGrYmzH7iQc/aD7pYSWO7InM1ycF6THzbMIElvCuOuHfq97zQyRkDAfSOUuStEg3SP29QXpII+BmXl0JRhyjT7QBWFWxOElgXYL/mZsW29RWbx/c0onL0Sm1gzYd9ZOqJnwkjjBU8UqmO1r+3sZelNnr6zEktwW1bONTysPayuWluMhxkK/ojzxx2BsmN4h61JHm2lNEDi0Yuw1yBPZA3vOAWQAEpk5cfXv4DgMXTB1SRwTcFMqy6XDx9alXAqGJlI4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(396003)(366004)(39860400002)(41300700001)(186003)(6512007)(38100700002)(26005)(6666004)(107886003)(8936002)(66556008)(66476007)(66946007)(4326008)(8676002)(2906002)(4744005)(5660300002)(6486002)(86362001)(316002)(478600001)(6916009)(6506007)(52116002)(36916002)(38350700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?urMN3dG8R+XE+r7JOTdU0p8Qd6ikLCXdQFUt8n/NbmLFzYjhnzyIdxm9KsqB?=
 =?us-ascii?Q?gWSDDzGZOVz6c4Mjbc9nHcMh5xD8wMFD5Gq04YDp4QddH2MejbV2cUTnasGQ?=
 =?us-ascii?Q?jlcfkMDGADhrw4HvZIye8QL5a69mCZQmkdi8u99V2o1JffDQMXAJG9mxlIA4?=
 =?us-ascii?Q?KDkBXDpBWt982jgykdMOxJHBVDzlyZfREG9g0Fma0EdsORJ3mPXzPISzy1av?=
 =?us-ascii?Q?IggVxjz/eFYUOsSuo1/anCSr6RjSxQF/mFEPAhXsW4XMtdJkwfn259Ugk35R?=
 =?us-ascii?Q?msq97mCojczs4pRCTD8SK5aKSO/vc8qXs8v9qTLPM4Uk5Et1FcfIt7gb6bFQ?=
 =?us-ascii?Q?+QNLdCpt1e5pzrkC2Mk0G4jjEmWf6mv4BysJxTaAEQYJnGfiJ9mW37JnFRgo?=
 =?us-ascii?Q?P7OrnTbYxcy9H2bChjw3o+SSBdYpFpohZ/mXYnYFz3uoPj6Nda6lh5ZXm3An?=
 =?us-ascii?Q?a3zEfDqRsvPbYe4aqyJpbBqBmAGuLVygNdGZ1jIbhUPHAXMnBQegXtADoQ8o?=
 =?us-ascii?Q?DGK0lKggrwj5xToxOrPUBgUhxk6VR4Nm5AvdSiGWQg4ZzvZHNDH6O42UsUGo?=
 =?us-ascii?Q?qaqh8FbvHUCO/oxib2jGqzkyvV9z7KwAKd1l2wIftJQ4R7TTjdQxa5b3IppJ?=
 =?us-ascii?Q?gA57qmqigfX2tTcRiQZW8v64gz1j3a1ahmezV/xn1ilTkfgOsUt7s1EBIU4w?=
 =?us-ascii?Q?Z03cTVjUBCEjy9UrFIr61U4CPIhfDJV8ARE1b83b2y0xWAuOEb6eZTRcw/nu?=
 =?us-ascii?Q?ODhvnPUrYVy6d2p0TSGjnil0Nj8JXS+hMt9Xsyi6LtnJmlxkOEkjCtRpEqJl?=
 =?us-ascii?Q?5BZ0/9Lxy5hFNxjccMBLwKsaVw3Ceqdd/gPpKyztbLpTHMUDqXPcTM4UWWyo?=
 =?us-ascii?Q?BYABoO5PIGFDdMGBPyKa7pW0ALijzC+zFwDq+2L04pcg3Xqowm1GdJsLyuH7?=
 =?us-ascii?Q?EWRI0LYKkPW7nAvllASgwJndTB9M2u7r4ohxdAXyWjxeCOHTr4NBcQdS6pi0?=
 =?us-ascii?Q?PRk5ikZEmtNHek7PSYQQ3gVYZfQ/r7zjqA8f87CTtnG/ER4l55Wom9wrMKq3?=
 =?us-ascii?Q?iGex2wAgF/VSaWySqMrW1NUyTW6c+TkSjlFqTrB53p3oUBAkITiQ5tgzdO+X?=
 =?us-ascii?Q?oe8VUuYVbttMFY1QJyokcGq+YEBU0CUD9GA6Ohdza/64TCriH53zaYOhLevd?=
 =?us-ascii?Q?hp8B6G4aTVYavNwZpoge3XcXAqQRsZ+RB/V8H382Odz6DEUigrL1Voh2WzAA?=
 =?us-ascii?Q?RHgqPtt9+VlVWf8ykWmTdnlbt0hrL3wCUOZz0OyHseI2k2mLdx5Z8vXyVyk/?=
 =?us-ascii?Q?OA6JG0vIugV8uFNElGaJTXna6RrgN71FPwx7TNRqn3ZQ3ItxPyhxlpLyQbph?=
 =?us-ascii?Q?lOQ/K8MsFnHGpnCAksXxGaITCOjMpYH3V2JgEC57u/S9WdFzrgl90G3npSm/?=
 =?us-ascii?Q?xIIlBsS8Y/7edx/mvWnhEnCs6rE82cV5BsVmxjnP1DuIAWecFOs8WMsOhKj5?=
 =?us-ascii?Q?c2le+mQdGzyVx7iMei8pSxFB1TmSptOQFRd/vR8uvwfqAqI0BMYqTn9wzf88?=
 =?us-ascii?Q?ROgkT/SQB4sVI+T+IYDVHCcPVqZAOc/KVvTad+lrz1QXthNRJwX7guKewd6E?=
 =?us-ascii?Q?wA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0573728-9b2e-4684-4b9c-08da8bcfc29c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 04:09:26.7266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kRpp9xf9Aw9wiTZPrA+8GRn3dS6+VZqrRfLVWG+NHDG/xWvgeEyciujvNHQyFhOyyyiSGvwrwHQVwfvmLgm+OdBnMNDfh62eaXPUne7m1qI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5867
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_02,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=990 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209010019
X-Proofpoint-GUID: n0t8oesGmNK1dOMdyPbjOrMzc2a9vZeu
X-Proofpoint-ORIG-GUID: n0t8oesGmNK1dOMdyPbjOrMzc2a9vZeu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> If SCSI Error Handler is going on for timedout I/Os on a drive and
> that corresponding drive is removed then stop escalating to higher
> level of reset by returning the TUR with "I_T NEXUS LOSS OCCURRED"
> sense key.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
