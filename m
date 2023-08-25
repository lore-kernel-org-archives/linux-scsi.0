Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A414DC3DA66
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 21:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjHYVJI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Aug 2023 17:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbjHYVJB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2023 17:09:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32782211C
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2023 14:08:59 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37PIEOsP031083;
        Fri, 25 Aug 2023 21:08:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=wdmQ05sfZ7RM90cUwSvjr1xzpsXOYH7XqfKLBCSzwOc=;
 b=ITLjpZzk/1l5ml0yVIchjB/6k7v+EMLu4QV1qFrN4j51Mo3dNmaclt5H3Btfctj2BC1h
 EVXtKIuhpG7N9pSZqZiuiccHtjaLFN9iPmmyRilXZ2YcUXMsdiienTbtL4IY5xDSggWG
 1qqzOvceDe5au41bGxzT8Yu1NCeqW9fbCvmNL5u720gRfyhH1Gja0qalwzlMxVF3oIFj
 HUPxSrp+gwAbTfS7GDGPsI2KakIRwgf/1ptE/g59pZ8mLg45Hj4diN9edoYNWVFj7GPw
 rJyb+7BW0poGKjMzTi2MYpqVSW1V4qhUIvTVVERh1aLj3ArqRFeEpKqSSvz+xk2Z5JSg JA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn20cq71m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 21:08:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37PL1JKP000845;
        Fri, 25 Aug 2023 21:08:56 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1yvbagk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 21:08:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHIY6RIDbTUCvgR7yRkwI1BORFiB4bQ+g4Q3SLcNJJnR/9aJN9sjpIPAk7LL897rbirlyH2O+IIPwlz8S1LEZ/Zsoj71JQuI9P/NYyZ7mzTcUxfIfLfh67VM+DfV55A+83jeCQWsc+AynM/VCqkYaQUrOG/07shJZTL7p9dBZ6EnRfixUXslA0sUBvKBZCpi8dkyJnAlZC1Ek02kvrlyrllPJhy0YEGByj6EdLxeHVOvmg7mHm2h9Zffh9uD30Adi9rLK9Sb9NhANxLNJFx53VP+XxCuw519Lcq5oXR3kc7npOavZVHtBFRXlGZVspOKNnMj9bS5bYL+PUkerRw4qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdmQ05sfZ7RM90cUwSvjr1xzpsXOYH7XqfKLBCSzwOc=;
 b=abNcm6VfH9IArdTk1vfSeN87O++ZRvahV0C16UTp7vnnfv4UAB+v8GyiQeDeypuMlo1T8TSy3JFnFe5rug0GLfXKauGtCeDR96rcbWFJvhbyfDacl54LUH1hNHXl3OI6fwzD354wu3ahSO0O4R+UkzgU2jCXCkBkLKJnBW4ffB5AKCbH6of9kfVco9Wx2b56vxoD6LCXkLjOEc5MntJLOsvScDQBMsy13jO/QLOZlGfs/SIB7di5i9Q9xuvqLeX00DdUDTldzXmv2PEdGt8Fk6uliLI86qeLJwnb/67Vo5KCpr3FZuX1z8qFIprStv/OBD7J63TeG/S373pHaJCErA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdmQ05sfZ7RM90cUwSvjr1xzpsXOYH7XqfKLBCSzwOc=;
 b=iQq2+V74lM/GSOwyKDhHBI11qMfjPxp10jsr1aT6zyMktjuDWNS66j8j2vBGe3EcPNw8eMbZHN4W7JBtnkcPtWi3XOQH7xUuUVI93xKpl1Pti1nyeenlz418QmChGObhK4zRgbka6qyRZuYYgjnQdWjMV9Y9YtorQ1EpwFR0zjY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB7538.namprd10.prod.outlook.com (2603:10b6:208:44b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 21:08:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.034; Fri, 25 Aug 2023
 21:08:53 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: Re: [PATCH v2] qla2xxx: remove unused variables in func
 qla24xx_build_scsi_type_6_iocbs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wmxizv6s.fsf@ca-mkp.ca.oracle.com>
References: <20230825070017.46066-1-njavali@marvell.com>
Date:   Fri, 25 Aug 2023 17:08:51 -0400
In-Reply-To: <20230825070017.46066-1-njavali@marvell.com> (Nilesh Javali's
        message of "Fri, 25 Aug 2023 12:30:17 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SA1PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB7538:EE_
X-MS-Office365-Filtering-Correlation-Id: 635ceda3-31d2-4a40-2a92-08dba5af7ce0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6MLj3ybnqLpvPZZ/wh+NtvEldXGANEtri+1qO7mcKgIHnO7lp2rZ+6xR1F1RYU8KJldFzXKUm9yHJmWpm8nnS2LdGQ4dRY34aCnE7ckw/tQ6x3A6c3xEkruFaQ2/DwB4tMnfIcb/yp+EJwYaGDNM9IokIJgu12jGkM0APgoi4YyKIjnAdh5NHJHaCxLt9CBOOH8dn+qb10qQTUtKstDp7ngg3DNzoh320HIN101ZbIIGU2RlDpA3LN9mg4cP87IN6bkwzsfaMgElTosAMHlsuyDWYcVTODsaErFSqDsj80APWwM3UzCsug04wL/TQ56WcNPAWcuBFMiBoWrFRM4dCXMM9GBl7LeQ1A5BOPxGvpVwfp5zrmvKR+demRmh1qvcJ6088OsdVMdTpSCHADIEfDnxFnrcTeVB744Z7OecjiqWNfOPUgBnWj57FF9jPPmn1ZPxhwnGHYxDwNMxTh3zeY9aOV1fVNYI+B+LgeiSmX+8L8KIsWtIEIbQatKUuShruT6qkSSeOOURUkl+XO82jR1aW/SGAyYndUSewv5Es0RprmQJn9MJgGbQohubRtTB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(396003)(366004)(346002)(1800799009)(451199024)(186009)(6486002)(38100700002)(4326008)(8676002)(8936002)(54906003)(6506007)(41300700001)(36916002)(316002)(66556008)(6916009)(66476007)(86362001)(66946007)(6512007)(26005)(478600001)(83380400001)(4744005)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i2JcQGQuT4cX7zTym4fqBbrbpLZ3HhgkjYcNLfLjY2c5zYfa428j9WRt2w5m?=
 =?us-ascii?Q?DdPCBk43WKahpCOZH5cTfY+sLYklehNyJYsD/8hr8m5lR8mtWlsvjLnAI/w7?=
 =?us-ascii?Q?3xHNF4xLOBwG7X4e9OS5kfPyGbLxzTUYOTXpALI1ID4jcNdESSA4JkDDOsAx?=
 =?us-ascii?Q?+fNCR217ngSSlWnw2IlodBNbP07HEZASlXtF8B2tTH00u5GuiV6gZpKCIX3j?=
 =?us-ascii?Q?j0O6J47Xbqx/fGCkc6Hc2+cSwOBue3Jx3aXdpMSqQSKHCu4VHnB0oAyoTGFW?=
 =?us-ascii?Q?IMHN9GwI4WJNLd+rtMVndDc7LrORhjhNmE3A3AV+hK66x2zvNtpK9Q9W9ddq?=
 =?us-ascii?Q?1oK2pxcKoU3sv7s8/vDN2Eo6hnZz8scS6w+wfP6i29UIiWYoXjjGQ/9t/4YX?=
 =?us-ascii?Q?4F2mjgukgtwS0VqFYCLMijOLkirRBWm8etTQEh8fdaKz51mjs5AfZtSnIJXd?=
 =?us-ascii?Q?hfJhPoN+uHQ6MLs4r+c7XYfpAzK+/TbCLTjPqukskKK2EV2A3/Za2AYl1JyZ?=
 =?us-ascii?Q?n0m3WRWZroyGV0XlTr057NJaVZZAFQ94Lup616oO/P06VwKIopZgWikq13bS?=
 =?us-ascii?Q?eIq+PVJXw32E9Ky/vN5lY40NMliyCh4kh3r9hk59/GBt/HPLcuG+X8ymg1Uf?=
 =?us-ascii?Q?N7rNm0C5iQmwI6UM+xLZkuAfMUoyZRis/iT8RZPWdcnGzGt/AXR+YKCCL5MI?=
 =?us-ascii?Q?knVTJjUlgs1vtfx94jC/fIMKioFKC9Ij47SkoX6NGJw7gnEAqApVwjsEHzfy?=
 =?us-ascii?Q?IrGb/ifY9+G+ZZUF87GRwbkjHSl164iizROAiYnuucigBVWlBuBllzJ3T2cM?=
 =?us-ascii?Q?9SVgWIg2EJ32pHcwir3sz0WeOipqheFjpbavUAngxB3ggOkw79F34wVJ/ifD?=
 =?us-ascii?Q?JPS4shGas702rtZCbwLOj7HlYV9k/r8UvE2HHhrLfai9KP8vB6ewzGMpePkr?=
 =?us-ascii?Q?XnoNh+sy8Ey/gmcFpOi4fb6TAq6XR3ziAvjDbompPG8ug1o3if8FS2YZyS1P?=
 =?us-ascii?Q?Gci8+uV6JWyWmHM5zyTUIgLl64Vc1pKD5te31BBL4RbHHUKZQ3eL8/I6kWMl?=
 =?us-ascii?Q?4PV6yi0PO9eWuIYoQKrtKafE5k1epOeFqqIKL032IPj2kMRZK+mEHH7cE8yQ?=
 =?us-ascii?Q?P6e7V55f1V01WkKmhBOas5gJdYTl+yJ7zGOBQuxFf7+xlDOZb45EvbB2m7yl?=
 =?us-ascii?Q?ReYv+E7JTBk2AyRnUK8XnOyu0DzkRWMesYI2SdRmtKFRylpy6vLEQsWwsSZK?=
 =?us-ascii?Q?v1u2A9oo0IxvJzdOlJezhQZ1SITemqf93qOK92xieM0Ul1c1++DNCDJBrHoS?=
 =?us-ascii?Q?PAFKthlwF9NaqL9j7lYOB/1fOKU1ec6hRZMt8Ja0I2fBH9SUuiwP6RtmP42E?=
 =?us-ascii?Q?sAPcEBFhcaC4TjWzc9pR2NfDOMRGDoisKSVKSwvao9JeD/GxU8yT/Qd52p4/?=
 =?us-ascii?Q?bXWLAizSCApPFDKdY+UFKBzSQkKp9znr5PaUM0yD4XVF0cwRkNPawYmqM0Y7?=
 =?us-ascii?Q?d5ISdiCi/+p70+7YgbBDPxwstURr2ngKfPLSth/mzRlVfnKKafxot5Se0Ee7?=
 =?us-ascii?Q?UCtWMjn5TiJPPtdwl3HnNIdAbts8sS+VsWdXpuwYEbcmG0gk8mVyOqQ+FIbS?=
 =?us-ascii?Q?0g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: n6eewEqswD95r2dZY4Sf0+rVwdVMvvz9exOupFYA0jyQPHUj4o/1Jz0RNB56/EkwiqWz6W1O9snGySkEAwDPudz3Sp+RF0CrArKKuMSnkvRKPEgm+igwQ6Jou3MpCnCvAH7bHCDnO3vf9GISvldagkbmvwDYPAwrdp7guY2f1o+gZRFlm/J3XwRL5vfwSGvCIih58tYBSPXdYLG5AxtGnE8ug+LORdH3XPzrNgOgx3rtnsYntIVersCDayhTZfktxpJjlrKe1MMP7uWEj1s93gK0XQIGverGCL7fQ5ljSrAbPsSC/b8v4V9rFaTs83TCvkzp2OyUMF0cVXqpT1IIi4GmyG+WPuZ9etHPVJ1zA2R/bvZrNPcP8zsMBnqUkIg9e/1NAWr6wkCgvbprQVhOwMxwLBANjkusPsPrS9DswObhYecwOYAdo4tidCHMBmNGjc22RWa4RtxVVwIHSPs5KEn4boNaSxbr6bnVY59qRyNCl/2yJNJjU8uCevoCJ4yCPLc6NJ8pHlH97kwHzwT+YDQTV6uW43W5lFqiE+wqGitwCdvFrX/+MYxbnFKmOSlFSfhTBUbhImeAveUJujLe/YeTuE2P6jwulYettFIFAnm3Jemd3UW6eGiXZ+VPWjIYa7tRE5kuN0KJEw5g8+1ZoihF88MhTOoNgSjY5k1mi0Kj0330eAk7FQlnsTwiBrgC3qZdinF0sqQMasoEXtQYV1QvcPclSHoW/b/FS0yLiIYaa6lYt8baSgjVB+222b6fhvnUiVOzZpTakV8k1BMGWHNVT8KHPxsZieqCY5jYeqE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 635ceda3-31d2-4a40-2a92-08dba5af7ce0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 21:08:53.7220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KKciyUgZ0pEpPx41NHhGCXM8xPdC3D5yGxSlYIYCb7agardJaxiOME7QpM3tddZZPRGLPY0dhikqP37AXtsfhtlEiLywe+5p5EwWhXeWWCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7538
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_19,2023-08-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=831
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308250189
X-Proofpoint-ORIG-GUID: afXZ3VAnG4WUtU6fOPmdV6DzPdNEsB7i
X-Proofpoint-GUID: afXZ3VAnG4WUtU6fOPmdV6DzPdNEsB7i
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Sparse warning reported,
>
> drivers/scsi/qla2xxx/qla_iocb.c: In function 'qla24xx_build_scsi_type_6_iocbs':
>>> drivers/scsi/qla2xxx/qla_iocb.c:594:29: warning: variable 'ha' set but not used [-Wunused-but-set-variable]
>      594 |         struct qla_hw_data *ha;
>          |                             ^~
>
> Remove unused variables 'vha' and 'ha'.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
