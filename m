Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28803C04FDF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 16:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjGaQN0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 12:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjGaQNZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 12:13:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC57A1B7;
        Mon, 31 Jul 2023 09:13:23 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36VDTRZ9017407;
        Mon, 31 Jul 2023 16:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=J//8zMBmLMvdt1thIeAYXF7uKAHx5d8PtQxUK8KOwUc=;
 b=Epq48+rVX48KgvphPmWXIhyw1nEpVqyPs8NhzQNbXvzFQjuh56WGvCHO+v4jW1pco91w
 jzS1OcYpeP4f6PKML6cpKVFPI87Dccj+smU7VYUODFzvi+0PLX2Tuha4Jqpg6iLgp4pH
 T4Z3l+NKwLmdw7FrLkrEThqJde3PpmlLKJeq1J7ix4D/tXrY5ggdeId837DawZxFvye9
 EowI2gCSnMhhLla/tpsXTd2wz5r91dJ6ArYYfGWv5R7Z/PAoTMgsfK58SAmIuS+4Nwkh
 CmuioDXazspN8nQOBV3XcjA5lWgXuzwgY6LWH1Eg9+J/nE9Fs8hS1p/A4BahLS6zV+1m Jw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4sc2b07n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 16:13:23 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36VEnHWX008895;
        Mon, 31 Jul 2023 16:13:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7bawrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 16:13:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bb10J2ok6zMrEEukWJcSf7hLCuDsf2AyWovDnR5Clpw/14LI17YU0Umi5pZglQRkHn6KCVDKjWulD3zOO+vWimTlw+OLF5rKwk6taxVluaAeyOmGdO3orb6M0IVA86mJfslkcv0cGlKTtcD7n1fVZdHqa4LIZ3fyuuxigkcIZ2d0BdnbYHnRLox3WPxPRe4u/HKhayJx7B7QLHkXzL3b4ewVuVcAF+0YeSNNjeBccBBNMhk0ZddfW/90G3Ue2TLDzA5VGgmEAH021YBIrGc/3nBpWV0IgxEu/F75As3R2TP5BnBzGXPenK99aZk4DJORUaenxQsPT0P/Y0tIr0cBBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J//8zMBmLMvdt1thIeAYXF7uKAHx5d8PtQxUK8KOwUc=;
 b=gDNGBrETFe9p5zYM0lN7dOiQQqKgwPImyEL21+KTw5DEuFAdWNIbGI1EtpqzDuVg2cWQpZ5KZZFG2toq1WnKendoxmSP0smul79VD4LqD8fXZFcSt/VzrZNDpbVVcufC/nTpwHK7vNJ2vp0YDdHEs0nmJkxpGXODPTOCANNFCwj0zIuUc1Ndk1z5ZcFIo9gN03rWCUpR+Xs6GF0+Vg34l5tL+45Slg7nE9tcckOJKU7NZ9/eilIJ9JKiSG+v+zQVJbpXKk92Avx3n6lTCNkjXMWPKglRzhI7RM1/yzwairfG684Kzd6VqcVlMx1Dwao+nb8X5Jauld79QEmpbxddHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J//8zMBmLMvdt1thIeAYXF7uKAHx5d8PtQxUK8KOwUc=;
 b=PqSp1RR/q+KECMY9Uoe5ApZZHoGIgrcJlbCaHg2Wjvp50TDkKQkhwBt06EgEHtpaslBAB+YnFcPQ1r/lQVS60NYAnN5A22EcYjtJwCRjH4Xst5w9116Ujeq2QzMPdsf1+WI7GyzKP2DL3RgJBWGHavaW+OMiSxGn9JZM+QwZkIA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB5782.namprd10.prod.outlook.com (2603:10b6:806:23f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.42; Mon, 31 Jul
 2023 16:13:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2dff:95b6:e767:d012]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2dff:95b6:e767:d012%4]) with mapi id 15.20.6631.041; Mon, 31 Jul 2023
 16:13:19 +0000
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH 0/2] scsi: target: iscsi: Get rid of sprintf in
 iscsi_target_configfs.c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zg3cqctm.fsf@ca-mkp.ca.oracle.com>
References: <20230722152657.168859-1-k.shelekhin@yadro.com>
Date:   Mon, 31 Jul 2023 12:13:17 -0400
In-Reply-To: <20230722152657.168859-1-k.shelekhin@yadro.com> (Konstantin
        Shelekhin's message of "Sat, 22 Jul 2023 18:26:36 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA9P223CA0012.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB5782:EE_
X-MS-Office365-Filtering-Correlation-Id: 526e421f-fde6-4fc6-0b22-08db91e10e14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +UxraacT2ijyh8sdrsZzu15Hfph6Nup7oUwNIIrVXnSjiqBHyFTDom0S7pnNCQEmAFhq0DI+D+LdwE02jsySlU5/j5+4vZnYRRCLPXcIT1xojJJ6LNMjQOE2C6pNAJ3p1DDdjslv3+ODDZt0xrySKMNMqNzuSDNqallUXluwk0enzoD3ij844MXnq3BNRZpncPlTNWRzB/84TGOtjzlxPfOIT2H+Jxv8gwcdn/KqZfFaQihHLkm/605wvZcYOfZ3dGWQdsv9sW6EztLK9bfJlZ4S4yZJJvoaZJzkhwCqlMMdw5aWSZYiAcO2xbU9OGj06pllzeDiDyjUoxXTCMBTeKbgcQ8tayYRYr9ZTZ/E76jHXatkNiSM7SIwRwdtEVZPRBaDYvIqtEKLJQijcuEqGlYFP4DdZ4UqQT1kQO3pq/eZBB3iR+uG0KS7xkpQtQmEYZlrij2RXlxhDeQvSC3p23DNiBwZFzYSbgcf5w7yDGvyqIGyboRViMMhZnW3IszUtsPwEThWM7DOat9tVcX13hyKz+EROfe2LD/k7Q8MzLW8gqwZorOwFIt2Afpd3pyMB7+ILPNrpfZzp9FVCmbU5OGBSpk2dfHOi2dHA+B1zZQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199021)(6512007)(6486002)(36916002)(26005)(6506007)(186003)(66946007)(66556008)(54906003)(41300700001)(558084003)(66476007)(86362001)(316002)(4326008)(5660300002)(6916009)(8676002)(8936002)(2906002)(478600001)(38100700002)(26583001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G3w1oND9Z6RxdzxoR+ZfXZZjy6CEpvsAiAP6f9g3mMeAg5UPglEbTUjHGkPR?=
 =?us-ascii?Q?JhE3FrCGd9l/yU+XmlgCgDxjeePxPeJP7lHpR8cD/EzRn9xWbKTUhjwWPY+t?=
 =?us-ascii?Q?U+9csjJQFvZGxKit0wacDNobpez3kobVKuO9DMBXcApuDanXnBlhUbEGXhEr?=
 =?us-ascii?Q?ebepC3ItcyP/nRn/o4RQ1RdYtkcmc8GW/2M3zYaazOe7MdxNOHmIqHIlUZeS?=
 =?us-ascii?Q?Q4/Dz95U7/yr0gQA1i2pOkNdKOohmJSN1/tMF9466d+NVEBo85rh3GigDvM5?=
 =?us-ascii?Q?59rx/NIdnh34nPo1dFHns0xsibcXnohV+GJqaaDHz5jd18LbBtT95PVovzYf?=
 =?us-ascii?Q?K2Rm7tUd0vXlhRSqBwn7qNbPD0DO1UoXQn3AuM6tAWBRqiFLwti+GnFgaeRH?=
 =?us-ascii?Q?3XxUV26Ech0FMecEwZ47U0MdanJ3IXKXsttBtazGdK603tInaGH0DJqa6Kae?=
 =?us-ascii?Q?aQBouNqBDbYPRLYme3Q+L7j5DW0T76pKrNVos4IjlamYtPBUNYq4lx3ma+TH?=
 =?us-ascii?Q?PpabrNqaoOwrNNTT/yH/RYGjgWOVSLl/vTUb4mwavm4cMOZ2te1HECC+ACei?=
 =?us-ascii?Q?yU1KZdLCiQ8iDRr1/3RDAmsVZIxHh5IAi8qLuu4AgtXA+dcfkjzGd/udYr2+?=
 =?us-ascii?Q?znN5dnnlTIrq5Q2DT6qu0nu4TbQe7JAHbdu7aVo2lltaKrDJauJxNzNmEdVd?=
 =?us-ascii?Q?gEURLHCwrIFV/Le5Mljrf6cQtszd9qunxQT0l/5k/AHPkiRvFY9XtnyWchvw?=
 =?us-ascii?Q?XPJgYh0u9sMIxmruEcb8GAfLDLdm40Vr5tL0RBO4kr9NfVLtOSx/xH5pfu+i?=
 =?us-ascii?Q?XtiKzgojV69IOp32Yl24Sd2eqPcjZOyqk8hrVLN5oSiTBDYrDPCU7V5ObCdw?=
 =?us-ascii?Q?Csj0BZtP+b3y9DzfdW7QvJxK9i8aHw3pfkxad7/A24ZNtX9s5+Dm6CEg6rYF?=
 =?us-ascii?Q?IHDO8UNXzX99wnlqL2F78RF4PbfpJUua2iqKripujbNhLdms90FL0hQPef67?=
 =?us-ascii?Q?G4O5Cu4MxB7qDdDK3D6JViOAperW+/pMy/GaxLO7ceVwH69EeJfvzQuobo6M?=
 =?us-ascii?Q?0BJwcwISbalyrM4HqIlw0h/MBiwwOW2sa4SSMJ/dtJe6gYXIs9KWl5w+aRce?=
 =?us-ascii?Q?AWq6/ZoDyQlFPks2boNmD+/IOigcJbUPqrELj9iDOKvKw1H1cModrgJow3At?=
 =?us-ascii?Q?5JT+32q/+Z0I8KKRe1XaFY+VkI318Y/FYY1K3PfdAKJP6+KKpgeJqOTYFqYl?=
 =?us-ascii?Q?uElce5lwdRtMfdsOsGFjvPkpyUSSmWLfOlxveOytJwe2UozBMQ0Q/FSkKPc0?=
 =?us-ascii?Q?fMUJzwkvSsP9RaZEhdC2QgX3CsvNkKWANRE9WW/IiVPzMrPipobmEiU3wx0x?=
 =?us-ascii?Q?ovvY4wPH9rLx7WHKAbOG7X6NLavv806ytTKiU7UdNtkphu756wcC6FUquye6?=
 =?us-ascii?Q?Wn1RFxv6tmXkSIFBHce94SmSWWywYm0pnko48VQTxLDccoKcAmYQKBUF4S3o?=
 =?us-ascii?Q?WLwO/xAX0fy60qjBkA3F/T8UHQM71tnEvIhphmvdFAvwmKyC6sbhC/fftEfA?=
 =?us-ascii?Q?dfCSfBn0m+fGroFrH2RDuTYzP7m8FMn+XygnU2LM6UOg24uhZdI87XXfL9vm?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lD/RvflU9+Rc7JZSkBFhXCxyvGC1SwAopeAjoZzy2qZttgrY0qytxrLhM200QegF9zgPiHVDbCZsFPrzgWObONVrjJUoH/ofViFnCwSl754EULJ0Sf/5pPhqszVeu37REhT98eRSuF7bxB76nlLaTE17ReirCZXNuz04ojvJBMX5Y1D+vk8HTbr1T1qC/WC8aqHdylfVMFxhRUpy/Gt6sTlR0bdx3anwTIu7F9P3hgiJ9pKuhcqBemHq+iLquVjKyuHhc25BvXCarsjUFqXEXkehjHIDJ3QrOkKuP1cvQ1SL40DsiX7d7AYO+5zDWub9CRLSvroRKWy4edhHi/CN1L62NbeE/Pi3KlUHdN3girMhbcsS4kjVo0BEzx+BjMVdrBXvlN7EKVCQTvQr0ru3Zt98bgQKfWpGwZrwH1cKNC54nICP2RUNIX9/L+y5HzKyryh4dvCIB+s3cRNA8BGUyv9VSoc0tY2SQnrYx1Z99T1LNPPz/yVfzWBXp3gjOBDb/MFudm6UFlOEUfZXRvGav7qj3AxSmtAueXTVkOVIKDsPukBrIEoo1Sn0ddAnS7VbPAF0hFeeeAHG+VrGk809ZZbkT9XauQfZbEAGmueLhzQO5IjpqGJuXqaSfrisPgTqxyfnZVeV8z/tvB+v/duqzYMOezS9fLCnTl0mhQw30F4L3gVGsc7B5ivo9IdKRvE1GecqMtOJbdaru+ts2qZYp9BYGYvfEu8h5CpW4dr1Cq5jm1RzKJGOXW8tkIX4Kp9AU2q14oKkFGCL3t+OeueC+LIU6WHQrz91BDasyPL0REw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 526e421f-fde6-4fc6-0b22-08db91e10e14
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2023 16:13:19.4806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +VX9pE4E6D6RU6bp6tsks4BltdDxbIU3o11v3VClHgYG7OPP+vf/djARWEpeHsO4z6Kqjv6qnC8+0+x3mgRcbuYx7IH1m+Q4BB5bIqDQb5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-31_09,2023-07-31_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=542
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307310146
X-Proofpoint-ORIG-GUID: ndJAnY1YW8P7SVt5E_ulfFsHEetKTfvm
X-Proofpoint-GUID: ndJAnY1YW8P7SVt5E_ulfFsHEetKTfvm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Konstantin,

> This patch series cleanses iscsi_target_configfs.c of sprintf usage.
> The first patch fixes the real problem, the second just makes sure we
> are on the safe side from now on.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
