Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D945C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jun 2022 03:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379940AbiFQDEy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 23:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379503AbiFQDEw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 23:04:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8BD66229;
        Thu, 16 Jun 2022 20:04:52 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25H0XvBr026644;
        Fri, 17 Jun 2022 03:04:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=VQnLgU1BKMwgAsw7P2EzBvvxUtzc60ML77DoTWd+Ibk=;
 b=UMsCUtPvWMr3FdhwruZaDVaY1eEnRkjNFPA7G8jFb+72bY++Q0Il9p/etfo2sggnxmzx
 FJ8YnQHrWM/zVhBM/vPafWPiSRO+7ANwZbiaDocWf/ZPikke9tDLGfSWuZjjW58p2wg/
 tjwJSZv66rr//yy9uQdTeXYwwi3s3oPJJXdM5Bkcabpel/f1Dh/PaJhE03wfawzUrMX/
 EVFQrC8AZdukSeILaO1y91oHUYYrmOe7+zkE6g3Kwe3afx0JimxfL10TJvHKcE0GTBIE
 B04zMU/6Q3b13idtuciViscV28d0nEzXt2C/0bjKdwiM+qhlxE7+jcqkjsJgHLbVXgov +Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhn0mubk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 03:04:51 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25H2tlK8019489;
        Fri, 17 Jun 2022 03:04:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gpqwcq8hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 03:04:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exyMjfLpGLMIw69U4qGgWbZMLvCJzEjmYy9Lz9eH0UBQeV5uKiokbanFuwb4YgBvlotjGSJ8zpJM9eWDi0pclSbJzUksYZsukzkKSoPWJgQYHrM7aCfnRhVG0h/gvh4SqWvSO8L9MTNzv+ndFKz1IIu/Fl97dI4+zpAjX+uRFud53LrBlDanC2g9m+1b06LMn0mABFGAMpx03bD7/fBu0qWLAF7BEx7csdoPFkvgUBXABsuc5pgxNQJ1NuJ6MAhUyAEiQS8BHeoN/LPaMdmfaTtVO1rYVTuB4o2Kk7Vgun7p2tTKrLj81Iw79sxaJZCQH5Xk3uf7Cv4zMIexEJ6xqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQnLgU1BKMwgAsw7P2EzBvvxUtzc60ML77DoTWd+Ibk=;
 b=RkuKcdff9ja0nmcifR37tV35kFwMH5FPtbMzLXYmVXHs0fMXmMqK1+Gp+iRs/VQM/K0N7y/2/TXm+aNNvvVZWAYIxtenOnYuhg3iq0Bh6VzWa9DqCUvOCtjK1df5iklgelRLMlcYYMwHzimnoNyGHqNJ0N+/XnFCSfAE6mFURpIK6jlEzWXMoft1vK1ep9D6MzdUHFC9+P+uGfxeCreuId8TIvWvvsgr1ZomUjX/ywnQ04VMSNOBLyG6kRMMo6QfrkVEYeF2U+tbEUe8AqV59neZsQjLhnvdcopnqUhv9tjnXLu30GVzfv59zdjAmEdeRTNzA98aVfU7sM58yvfF0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQnLgU1BKMwgAsw7P2EzBvvxUtzc60ML77DoTWd+Ibk=;
 b=aQ5pcuB/AZ52Sp+X99p/MEv/28cHBnb4JBwkzgv55rH5GbgqTG9FNQerbsYHghxIAN/eqJhf/pM9mctYBQboAOnLXCCVJoHYK4hhPLqG8zAj1EEoaddTIOkBlav3jqecF4d2j2ijkZeIUY80fnkxcOWobOI1Ymx85Q5mkR+ta3w=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MWHPR10MB1280.namprd10.prod.outlook.com (2603:10b6:301:8::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.17; Fri, 17 Jun 2022 03:04:47 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Fri, 17 Jun 2022
 03:04:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 0/4] target unmap/writespace fixes and enhancements
Date:   Thu, 16 Jun 2022 22:04:35 -0500
Message-Id: <20220617030440.116427-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR20CA0034.namprd20.prod.outlook.com
 (2603:10b6:3:13d::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79ab4f0d-0b4a-497f-6510-08da500e22f7
X-MS-TrafficTypeDiagnostic: MWHPR10MB1280:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB12800E1F20D0C7CC99811C78F1AF9@MWHPR10MB1280.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SSTzqh988veWfvet/WgZR+6jAiSsZv+PCdoOsbqOMUH7i0NiNm5SliI2T0xudKOcet8kK9k1aLoRiq7IS9Lpv5oVFzQo4gEBqto1nPHGd52oAdx6ThQwMbf2TJ+RYTEAkau/NdDQPrJpoA7+B22ta6B54fb1zqjOZxu7nWc4ZMv/mBxPkxnX9vroli2dHnlDPh2Wfvt84syR8PQZpdSh9QQWVK2Kjx1YurweTbJmt6DmpWw5Rfjer4lyvda2RWjkSgi5k5076IyGvfvSWgepWujoeXhSgOECUaTry0g3Cvat6kbhSrTkds6WiqYDDyXUGQDlUDfZoiSDMKNiou3AItY0YKpemRlUJcz9te3j/8cdQTJb9VL6g2+dzx3+Y9gQMyCDF5IqTlu3yQBSma/BupHXA4NdiHtEIp3PIoi+rykmsPF/MB93Fy00O7uSLKMvp/gWlXyYBbWSqchiEWtrfG3gozvu3wQ+qFtvjolWBCw1T7HgiIWh3Z8/eXI97U15HErTe6t1PcKaBhmdm1Ua4DtDZLu6px1ujtjebw7FRankse5rzb+XTUHf8Es81OMb89CoWjullzjznewuZ6D4DJEjo4J/QbuD69UUc5sEZrvK5IywSYClgl8uey0WV4VWBCdWkV3CLSSoLmhbpSEbuJedta+fkmPdjWkCuWyvlIgtwEIHoyB+0Ve+s9DfPfp9HEoxlyiP3JpGJ24qoNv1uQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(8936002)(6666004)(558084003)(6506007)(6486002)(6512007)(508600001)(186003)(26005)(66946007)(52116002)(38100700002)(2906002)(38350700002)(1076003)(86362001)(66556008)(36756003)(8676002)(2616005)(316002)(66476007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JcBqlpp4fd/oaDcERspChvSHjuJ4pquW41ZVxi5/jlORW6/IZqxy604W2y+I?=
 =?us-ascii?Q?5yB5AwN1ZP63AVsgMqlYS81/uiWMRC0TSSFyl6mdVliSTuK8NbvHA6Or9yhf?=
 =?us-ascii?Q?cwlPR5zmpVpszC06sOojnQIoSQkm3KRPxMeLwvcYRFwJ6TIN93PrxMtHA3S3?=
 =?us-ascii?Q?VLvYaaZ5geYrwwtzKV3N+lmhSuaMyNzcTDSI83aDjy/gmeJEfTUOF+rlxM0d?=
 =?us-ascii?Q?UWX3aH4VIb9q/0LY/tsUSLJchOMS4G01QfAx9MNj8LjBF5JXd40cD8hTgZiL?=
 =?us-ascii?Q?h/5d5yihksHowTmiL+CKp5lKQv418gzyXF6CKQ/03GYTT771SSXcumOzK00v?=
 =?us-ascii?Q?tHw0SMRMt742XyxvfTKHr54hlFc2Zf0ROh6AwdmbodXhSJKB2kKZ+hYQ6FWI?=
 =?us-ascii?Q?Uf4gFz6oRliJ4qqw2csNYhwVYR9mJuYI8RjiRuWNgYUKMT+nhPUuStqC6w2C?=
 =?us-ascii?Q?zj7DHmVeSZqYGbkNGqDcAT9Xe5azBsSMjvh+cSNZnbQbLTMC/CesJ51uoOmf?=
 =?us-ascii?Q?ZZULlkud4xwluqd09G05TOoZ/rizDo3nGnncyV3+xjgW0YoENL+jFrn0nJn1?=
 =?us-ascii?Q?gzcdVXC3X1PqBbzY0av5QXPjZKKcs42EDCgyGuJYpUTLUcRgTsPTgZBz5VdR?=
 =?us-ascii?Q?FvGk5QuuSzwNVwFB6PJWE3J2NYqj30wn/PIJyvMarSf5bnf2aDUv1RJeISFO?=
 =?us-ascii?Q?rSTfLz7KSR8Elua0SOaVCKDLkaZzP4fMWgPmKk0EoRbjvJmpZWO1avboVgBR?=
 =?us-ascii?Q?i+oXvGWSxTAgn86RJTI3wKqc3A+1VNzHV/SL5ZEAxtHur19Tj3qK6hK9nmnF?=
 =?us-ascii?Q?3js6TmHzRJ5NYhUbt5AJofInOEsf8Gh6OCR3Q6diEZLy0BlomE2BMiXmPzNy?=
 =?us-ascii?Q?v3O8Tmbjq10/5CWtBGHpZ6bRIHU6O3riDXTPMZX6UQvqhqBgsPxjRdcweOTK?=
 =?us-ascii?Q?pecCQlRCOPMIyJmV8thymvDd3+weaC24Rv2fbK9lT4/37cOnGjh03wmiH3tU?=
 =?us-ascii?Q?v7EMn9+hygmlodvEWxkPhViwJXhrp5bHVfKC2qmo+8zhuP3v2+AloZa93M1H?=
 =?us-ascii?Q?uxGIPnjhv+jy8wUsECM/4ivgN4E0o43lBGWg8CEOaYRIvz5nSSvo6mUa2/SC?=
 =?us-ascii?Q?vCTvchLaQ6rInRY6EVEarSKVpaqztwqd2ZMBlRdobszJED54t5N/rsdljACS?=
 =?us-ascii?Q?QCpo/ALFbhkpMghJB9/XNWGJqsRbm450Z2R1dtqEGNH7G5IVOKbmIchdRIwX?=
 =?us-ascii?Q?hhVYqmwwtBLyWo6/g1uFLhc5gSYPjisO7ENMZcd7OMZx0i6vVFd0X/YovOg9?=
 =?us-ascii?Q?gg7plRYgHhyPUzJxTGTmE0kG2xwRz3YNynJfqSqcjNu6wwvsh/9ZmovS+690?=
 =?us-ascii?Q?nRTXUVBxl6Yd+KxiORTRLrkBvBG0mHd2FDHrkHIh2pCr0Yegi6KtwAd8k2Jg?=
 =?us-ascii?Q?1Rjo+YTf7mFZ8D7LtoGiIQfWOB6la5Y6fVSdgygs+Gl1FRG5sc/qfau3hyYj?=
 =?us-ascii?Q?7VNPLmc86alrqdoJ3oryW/WMaKURmHSCFmI0CTdZFMlPHw0BgHeIcVvChIze?=
 =?us-ascii?Q?CNdyeJkOhevVGj3CL6dtciO6oZZKX5pOLcpKjYcCxU29CdFP4JM9CTU3+xVF?=
 =?us-ascii?Q?IhZri+NnqVFh7kywIaRKPZ5ZzLFRJYBUSdiyskn9E4Tzp87PnN2ubiS/7aBh?=
 =?us-ascii?Q?tcbdMXI0/SXb/xZCbDedcWl5f9+XtmpI5YFtE7mxaDBUy2H7vyaQQmdezg/R?=
 =?us-ascii?Q?ApYKV6hce21sY4t+2FPKbfPLBqrEIbk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ab4f0d-0b4a-497f-6510-08da500e22f7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 03:04:47.4624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFLsWnXVxewrFC1+3E+99UOrPFHp96akh3UQ/HtnhEe/mx51Hp1rGYvrQF/QfwPmDRH0Kw8NIvvWj6X1H/2N8CT+6wYRRaevxZSgoWW+Gpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1280
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-17_02:2022-06-16,2022-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=853 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206170012
X-Proofpoint-GUID: DfdeF0r0761Kfyt5vIFf1q33UbZXIPjD
X-Proofpoint-ORIG-GUID: DfdeF0r0761Kfyt5vIFf1q33UbZXIPjD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree. The fix a crash that's
hit when using writesame with the NDOB bit, and allow uses to config
unmap after it's been setup in LIO.



