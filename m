Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6706AC6FA8F
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 01:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237829AbjHaBj2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjHaBj1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 21:39:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA0DCC2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 18:39:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0Dgw6016294;
        Thu, 31 Aug 2023 01:39:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=OHnPSzM2pPQrZMQFowSwZYy7Mtc16f0cuZUISYxuSQU=;
 b=0Xe+lw4LXgY2zwg63go6CM1M3HIw73mJLnuNKV7dmShpkgKdcqIR3OAfpCeJL5qykK8R
 Tia4m8V+VeeILeRhLX2Ta4tNTeLwI9PxLuMHnCD1QH+B9rVmckR3K8fLmXhJ8D9M5dIp
 j4EdmnzGNKKDjbmYVoeWmpqG8BT6dZrLFSL8vAap/M8wUQxbq5f766Tmj1GiyhkurFe2
 sQcyy01XIuinCPr4pYBRilVaNbeHCw14LaDFax7U5JkljpiMDtP5XnnKXE1MQ+6ws2EU
 oJdLMZyxjEh4gGE8Y0x7vINEydmkFsbiXMh7Ri+yqWaKLHNnt6MqhkxnxdDyrOvGRNiX XA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9gcrpad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:39:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0BO85000527;
        Thu, 31 Aug 2023 01:39:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6gdc866-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:39:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SyQi0kugOkag8+FkRmoEGSj7u20aJHcOLGepfkGiYxT1fdqzwG4N60TOBwuVVvWqVXAgQnD6qnVn8oY9lQ9quXo6qYicPWjL+Cf+dWjCH/8UrholnibbPlFihmofcW9zS1C5/Bt6B87aekRKe2TCM3CWYbHFcXrl8rGRg7G1d3XG8XSxXpik5igfrHv3XYSMsU/4QKw12Ocz9Li4O6vrxWKS4Aio9m/jL555OVEeMNEEuTEAeDppH+HIWYmy+OAhcn2OfyMWV/VZPbhz96o9xmYDmrtnDtOl+Yp96tHqF6V7mHIYh8uEA/qEDV0quCe7R1I674yJotbF58Uab1/OyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHnPSzM2pPQrZMQFowSwZYy7Mtc16f0cuZUISYxuSQU=;
 b=kqNU8bYyNTckaM8JoaRE5lJoTPuAqrZJpNwKIcyteDLpRJIFhD/xHYJVv+yD61HY19P1q/wNkogKUAQbwJwkF24ESD+Ybcz3uNNbWuW+t1qWG0JDdYLuR82jPdLswRERNZ54/JO9a3Nn0gkrz44jo1gODIgnXJt3/1szX+CpYyxIZMtNf2hMkMaHZVBxWebnoCzHW0q0oWo2YTz4ZNzDpPcwqZFNk538iDAFzjG8Z8v512vbPWEnDKzXwjBTz04c4xMmB+Tg3wLbRR1QA/IDRd9RI4T4yeN3l6iwtnfrteahZuVWUjcRuVRnQB5CIHEzmcOiHsnPwS1BcwSof9F3CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHnPSzM2pPQrZMQFowSwZYy7Mtc16f0cuZUISYxuSQU=;
 b=MfBZzABpo6AM6n7xHmiNLEv+89ODh5/RC1PtE2FwoA7MQ7J0wpKExIhbMskCwoY2x+/lkXEMxq612PQtB4vD9/WCDg5rmNJCw4iEcJ4ICvyA5nLJbwR2CAiZrDmOF841E6ywJzdcwv8WWYPqfYZSoW8vToFQ9sPM3r18tIL9N1M=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4786.namprd10.prod.outlook.com (2603:10b6:303:6d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.35; Thu, 31 Aug
 2023 01:39:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.035; Thu, 31 Aug 2023
 01:39:21 +0000
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        sumit.saxena@broadcom.com
Subject: Re: [PATCH v4 0/2] mpt3sas: Additional retries when reading
 specific registers
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7iot2gv.fsf@ca-mkp.ca.oracle.com>
References: <20230829090020.5417-1-ranjan.kumar@broadcom.com>
Date:   Wed, 30 Aug 2023 21:39:18 -0400
In-Reply-To: <20230829090020.5417-1-ranjan.kumar@broadcom.com> (Ranjan Kumar's
        message of "Tue, 29 Aug 2023 14:30:18 +0530")
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0030.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CO1PR10MB4786:EE_
X-MS-Office365-Filtering-Correlation-Id: f2114f09-b442-45cb-c360-08dba9c31928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bdzqpAFTs0GVSUkh8RXtZXwz0+NX3G+Tham5vfzi/qS8R8r7Mj8MpD8wrIMllcOiLbBf/swAvubylAInb3xHW6hV6MF3TEC50gCUzzJ8O2F5WXjzzPeVqxTMQMB3qkWxfaPv8a6Bb1duyUOT0kbS/z0en6XADygEU1jHvrIFuS9NTekmZmf22D9frrge9+tMScH2QafYerS3297p6JJwpEa549vaXUZA/3m6Qm/bKC3gg0060h4a02bFEyq+Oi4dO/UM01WSFOL8Z1126sMqQKeJVKO7cX1VvxtOHAlV8ZRzUH4UsAsEJR/kAu2UUpIl3r3bS3+4JCcwoEtRLz8C48bqEGYXZn+CP0CztAjYOlcwc/u+So4V3YHE3lFuDy4bkl8+poR5WDqkQFFucbvTQoYgHwyj1swhe4vCV+MD0PQY2m1S+byKY2JyhYPfhrJFqdFCqfLK3Na+raPyk50Wl+RU/V3mHp4lIWgPPHiByYZj9ptPghTkqoUSrLCmU00fOfEd3v4F4zo5Wzlzrt76LcGcXUVvUycdCjRe9KuqPJmhphCMoeefYbEd4qiLYaaWRBu7r1V5o3hyHoiQpWJeKMNyAvNNW2zU+9YXe4sfsT8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(376002)(396003)(366004)(39860400002)(1800799009)(186009)(451199024)(8936002)(6666004)(478600001)(66556008)(66946007)(6506007)(6486002)(66476007)(36916002)(316002)(38100700002)(41300700001)(6512007)(8676002)(26005)(5660300002)(558084003)(2906002)(86362001)(6916009)(4326008)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ScMqOXUSJhrC6FCZRipKVm9KUD+pagddJuUwjzmLQ/g2OLwz+sDR5oV4uQgU?=
 =?us-ascii?Q?txiiOaDvP4E8NpMAMBx8RK6gKspkhWzMtSPmQJkvBZVCyNrMT2HXOfppsy3B?=
 =?us-ascii?Q?EyvZ8RbMT/RmwIvm7p7ypr7g5qIzIPDmbj1nKuy2b9We5V7N5b+SptPW4BPq?=
 =?us-ascii?Q?sgRc9nhh8v/YWyQskJ7sl6DJb0o2snY/gXGPnBSK2vmk2mHgdNmPeclmUyg0?=
 =?us-ascii?Q?D/v0VptBRKLEVkTfuehv0uuuX0n8T95UeOIdmpiO5wuRkGUP6RQ3SCIhhaox?=
 =?us-ascii?Q?mWJTpro/JhpwkPSB3JK+GFRqNaQ2WJCnQNzr/b46+wbt+R3lx+65Wb+dWmNn?=
 =?us-ascii?Q?LyR2eJ8yV2Cml6T4vV+askMlblv+p60EXIcfW2CkSRgbWviQV5J9fvRXxkKX?=
 =?us-ascii?Q?pTu4Jc4VQrHS7RNNRavstdkkKV/RudzM0TMFvORwf1AXEwP1A+ZkE7wZuXmc?=
 =?us-ascii?Q?ZOEuWC5AWySX4cafYi1WRC7TrDG/KkQlH56dZQuEnKsAkKFF7DeCloVH/sMF?=
 =?us-ascii?Q?m5l9zp0dRHY2fAbdvTmUOxTBpDymO9Ypux1pnL/2W/lgLnv5Ixxl1AMvsSeY?=
 =?us-ascii?Q?/Ml05meMl8wMvXrfBe7xA4vuYUCY/Jf803AsVQH4zBDKssyFkOQjc5CUYrUf?=
 =?us-ascii?Q?vx4rWoMJ1KLjliC/T70DYSQwQcrxHILOm1S8X7Ivz2QQMcsatCFY1tPcl5FB?=
 =?us-ascii?Q?uWQyksnuoeeTPE2hFARaXm2hncUCQ9zBOerYWQTv7CCdjGJKKCSrCEdLyNCZ?=
 =?us-ascii?Q?lz8hPW/fcSI6qsTPP1f02BmtxL1rNL3aCYoxkmMhYyVOHsKrSGvFBCqpnhR4?=
 =?us-ascii?Q?mYq3Qc50x38l6zP6XbJb4+MVG1OIIwlt3Phts0RQ4uzyHJ9PCTP5KDnze+1z?=
 =?us-ascii?Q?WmlC/rxCXCKGVtlugs/9UwhJJPzIrGBOtu/QiQN8IUtd7msHQyp6WJTC5RSZ?=
 =?us-ascii?Q?WmiZB6MRo70IPC69TaXG3AsMQ9JvSu3yZcG3FhSsdb/FD6vOsBVdDFsYIG8H?=
 =?us-ascii?Q?4LyhwztVQLO92cswcsWUvnsrIAxDTIGf6arWnSidNBwra2aoZ/mfafrxGB3L?=
 =?us-ascii?Q?D2qmyocWPWxMLo/GP+0MxXySfTqoyqWh4IdEJQHxgjB0iFZzSVvzgol9nv8r?=
 =?us-ascii?Q?gWBAIHnc5YVpNk0vvFE/92phr9ytN6QPmjgoay7UkAe/arlMLq2UuUSJcWz1?=
 =?us-ascii?Q?NZkRzfBxNWLjiie7a5rJU0tzEE7/r0HgxCLSPnqgtUhbGqfsPb2vLvnhcwPX?=
 =?us-ascii?Q?YcjChOWIvgRlxsDdu/aQC301EAV8AfBs6mexxeyTPf08ld2dTcNHW7GDdoHa?=
 =?us-ascii?Q?YWJagLhWSZHt8Md1Q7eT6h2itl8cler3BMfQde0wuwj2cDwfTjA6JUUDJyex?=
 =?us-ascii?Q?2zuiuFqq/Be105TxizbeR9cW1zLG4yuD6HAaZ09CHhIPcjrMUroh/Fvinn8U?=
 =?us-ascii?Q?q6ruEg20d3sFoDfmmk6+pvKPw/rVMYK0qP8bXsEGB+gBWWrrYm66+KFei8Up?=
 =?us-ascii?Q?46NqtK/NzeVDQJrufPesUBDA4YVF76EUsg5hY4cwVZgy5wWHbZ5WpXA/VMgr?=
 =?us-ascii?Q?01m3mUnS+ciWOCxJ4VD0gntS6dJHC5gXMacilm58MXQBQ+/TKI2AbE92Z5AE?=
 =?us-ascii?Q?kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JsMej8ll/r1ztnDWwn2KPHBcprDaxy4+rg2fayEh6o5RrJMi4Eioy0pziADcE6TiLB9aqTTrD/ZKFCP1SwGn17bAuqRo89xXd2lPTlZ0a+DwPw4afkicPdvcwSsQ/fa6CKYAdm8mIDJ3lNP6x2FofEFbpUjdEjFi9WGWKou+TKrm6reK5xxTDHcnpLszQ6CzlwYEs9oPNpIjXZQb17W2R9H2904hlBXcuOz+wg2HbYswFRwBkMM8x/oO2wG35lnmZT9gFlQ2yICxj4qlusM1bBp1M86wD7tIfw6Ded44riVJYyuLhUAuV0K+dzsWq29OXUSSB+BUDayYTI+GGidjl3YX347WjeK1pcTtvRtKEMfoZu3nRg0hcpgL+sDTxHVOdJonvtuOIgs3sn3zzZ7rdBuhtEN+c3GWp5T9rjuCfw0VNUoTFtFZz6yaDMH3HB5RdEPVAh458xDbB5iP2WyYYDsCs9UIGjbtzQY9O2YabmIW/isqHBd02BkD89HBr+GJcdyfs4EwQ85XcY+TvwfB9PQGKTIeE2UpEUMC9IQO5R/Ue352hzrQUMPB+MMccPL6crlydCW4QLyDCT1eacQsMppR7xIGJeMH0S52ru4Iyd39+OsVas7tOfA5ZBnANzd2mTKIofuYIAudCuzfbowCiMP7Li256AbJN96yYsBNczpoaAHZolgCQTgrpqSmd5/YfY+yIxP4Df2mf+3a/zykaLRlyb53SXAUobpjX0AVSS7PaLgUSnrQKJMCFs4IBbBk3M0pJaTUACYLs1RB0ENzIVVc1rjFxaOYqjdDF9JO5m4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2114f09-b442-45cb-c360-08dba9c31928
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2023 01:39:21.0730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bugh7lRGijQMGVg/mL8m9NswJzeSnXYQEdBKw+kr8t7yLrVJAu8jJkRiOsciCOG6UAUkbm/qljGE56E8PB4usioZw6May9e+gtHRDffIT80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4786
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-31_01,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=894
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308310013
X-Proofpoint-ORIG-GUID: jxANNfo2DVDocVqjbtlT4lcKFJ0_4M7a
X-Proofpoint-GUID: jxANNfo2DVDocVqjbtlT4lcKFJ0_4M7a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ranjan,

> Doorbell and Host diagnostic registers could return 0 even
> after 3 retries and that leads to occasional resets of the
> controllers, hence increased the retry count to thirty.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
