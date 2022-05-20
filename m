Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534DCC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 00:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343983AbiETAZd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 20:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343994AbiETAZc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 20:25:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1432E12E30F
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 17:25:30 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24K0JECf030168;
        Fri, 20 May 2022 00:25:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=emBOr7EQgp5Gw6cRZWaEin9/WyUxKbM6WIj0jUrAxfw=;
 b=NtMAYdVc/Rdt7IIP6x+9xfNhjtS7sozwYzbY9XvV4SFr6OyUQ92S4Xom0a9V6QoecK+u
 4So8EChgxzQU+hoxMDGAxBWr39hMGzXFUMX3RVE4YgPIvzvDSht9rXMna0OB0c+WRLh3
 8Xwc9osr1/qlZUm6mKafLEfp19DaOp18yvcRtamEbqZcZRtRx14J/dm+oJpHhnc49A3q
 Tvy6w1INidKG5Vwp0YNwupc6KiMqEyDJ58+DL5ZL00wKIctdjxWs6iTN8nl3Wmb3iPmw
 d2rcw2A+z6027J9mQvDOFuaYgKCV4Veb1VeIrcqwqWlJ7U6y3vph5wbvGfStXOHaOJrO pw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310ws2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 00:25:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24K0K53D036588;
        Fri, 20 May 2022 00:25:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22vbaqxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 00:25:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jm49/SysDVIUuwJWrA/dZRUVMEQlJBCdOvg9m2qv3EhGTElplpbunKJtBaAJ9W1he+JIYlH3MG0kh7s6YaJ08qIJuVB51u/6/467uCAzugQqLY2odkTwcywWro54nX6TuXgGPf837B0WcfWrONX6tuv+VyNZTHozXW3kTn3qBKgLx1nViAx9BWebhafvLshhOqwVNnGLOhV7T8l0e2l2FAWXWGwMaEyIRRIjkLyK+0XuqI9a7Ur1rmF+MagKu3cD8aOWU4+6500s7xP32qeCR5qD6uDF7JtAv1ohZMd1ZpNp90d0OiLP6FIto9SqG5H/xVQAtmMaJcTHhURrtzTTfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=emBOr7EQgp5Gw6cRZWaEin9/WyUxKbM6WIj0jUrAxfw=;
 b=NDUXEZdA9tn9G0P5zL2ZC9z7CswClpbh4sdGyXc34FjZeDQBiDazU/jgYavFzoVbWHmClYCG+0ADFcKJTL5iNkAsTtZJF3gSJ7a7Wd2+mNZ9KzzrSZnLJd/4wBQv8SyhaugyGJ+kyIdOhwksTNnmgce5vashiL4gO8FYkSImNiX/0G3taFm804wMPlbuzsfxA3TUwWVIC9zeePNmrORj/yxR+0FP3PW+eOYuU1zH+qaqOY/nQLorvszDlJDm1QCbO/+giPqm2vEEQ9X/R7eWoIXGP9pCUFmKh49r/9SnZeCvzMRMdg7fhn+xrxcihCjtRrt8FBAQ2y6Tq0Wh32Fx9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=emBOr7EQgp5Gw6cRZWaEin9/WyUxKbM6WIj0jUrAxfw=;
 b=sbYxUrJ0dfHX2PxEEXPOb2KCnc3CUbp7bQ8jFITiQvFGKZyOqNgVjvMkADV6WmanA15VVenAxGUOeOd8jSDDZBB8woFzhu+X98bz5G8LvRa1hH2bDq0i99hWBWF00gK8Tt9PSuu7OcPLfW523Z0j3qH+5hJYe6R1Phh/ZFbtHuA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL0PR10MB2883.namprd10.prod.outlook.com (2603:10b6:208:73::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Fri, 20 May
 2022 00:25:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 00:25:26 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Add VMID support to nvme-fc transport and lpfc
 driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15ym1m4ny.fsf@ca-mkp.ca.oracle.com>
References: <20220519123110.17361-1-jsmart2021@gmail.com>
Date:   Thu, 19 May 2022 20:25:23 -0400
In-Reply-To: <20220519123110.17361-1-jsmart2021@gmail.com> (James Smart's
        message of "Thu, 19 May 2022 05:31:06 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99ff2ca0-f872-4ce0-124c-08da39f73cca
X-MS-TrafficTypeDiagnostic: BL0PR10MB2883:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2883C292CE64B450284B9CCD8ED39@BL0PR10MB2883.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qhI3xY//XZw8fpkSuQRKohdeC08wHEK9zzwjqQt3atba5mPyINiECm8a8bKLQlao1i63/rxft608rPd5bUQ1GYqZVdY+XjccWuu7lS+rVSH985rTbqTfn+OZJUFm425v8arYqPA2X/4x/Tyj2lIrTNdAyoveEM9VTFeQi9OkIcvAhFIT+Gj0yz7Ic5eZ+3TP9sW8RELC5xexpw0GvYORspNB6AIEJG2ATYLnLxLvmqDL5sgq2BVGPGu64yJzJb5R/EPow310IaVWWUOHUKwI1HheOYCyzl00yBrnUzgfrXD/mgocDvHfZR8x82a9+MgZfQ79wQArp7aFOiqacuE05LzqhNvdtAjtFSKlPbSwBMQaNBXrxnY9wxcciyHDoD7B2wAaZR4+mVLzu8b/b/jGJKTFFOCidhARCVkzYM5/7QVfR+oqlvtM6SlZvmVLNtDW1DMO0/g/xUE3dTgNAg5oMqcEI7U105iczrLlxzqAhUzI/vG3jwb/7IeiVeIMd3OmO/uFcO4rCNqkS1UW3Gj0QPkyWx76uKIDpqptHuvYlBXkG+eJqgbgJOy86/RdR0kBGuBa5gt0csI73mSFGmGSp4p/2AxA7Eyfd2EvVMkZgwUAoxR9PmZ1rbvlQM8gkt1qf7lpndP3kFvu2r0kmB+K5p5V3Q98kmE+BwZ9r2pUX/x7VmrG732rga3CiDvA3uFL6rVQ7gVb5kB/BhSD1QYJQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(316002)(6512007)(52116002)(36916002)(8676002)(26005)(558084003)(6506007)(6916009)(66556008)(6486002)(508600001)(5660300002)(86362001)(186003)(38100700002)(2906002)(6666004)(66946007)(66476007)(8936002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ACjttiFPY2zJwPPc/6Z6EMxqkPsIJHSb/t892lOqEfS3v+fztfRE09JG1xAf?=
 =?us-ascii?Q?n6ikNUAGjznjzTpBJJWKkYgJSaCuTZwBVPcbnrxGIDTR/Qo04iilkkz+2Lhc?=
 =?us-ascii?Q?/eU6APnVvKrrsRTEB+w+u+Tu5l1+7QUdkmkd5quoZewyd0rxQSiZa7IkshCs?=
 =?us-ascii?Q?6EYD/+4aNviOgMCKcCbHM3oIuU9DMT8qxB3eW/vatBlgib0cF5POxfAmkzkh?=
 =?us-ascii?Q?VizNrKV5sV1Bzpl1eAcO5TMexgcsueGy2MWRXqiVQBV9iEcV6eh5Ej6M+jQS?=
 =?us-ascii?Q?3PjXhxBUufTWezRipxF3s3pgt32asbjzq21QQOMg0Emn1UcbN7xNhBzQchtw?=
 =?us-ascii?Q?3pExjRr1PQ8+VnKXKMbow/ZnF3+NQBeY++ORFlK0EXdJL9yA34bnUypiNtVK?=
 =?us-ascii?Q?cExenJpjDFwnvbAiPS9yLbWndXwDitfTWSYASn7TVLip7xOuV9IrLbc3wxDj?=
 =?us-ascii?Q?bqUU+KsdMc8QYOi2tM0RpDUKOxL7ZOseeyzP5SoYswVcJxHWZpZYSq3vEm6Y?=
 =?us-ascii?Q?ezEUjY9oeCUqO/2/Md9H3E/lx8fKHfljoqD2qi6fsfq9uz6PwAZ1KQV9g4Yb?=
 =?us-ascii?Q?GidyakZ099QxG+6LDjixKu46K9zcPknvZsqo7ojXMuqJhLhM3L76G2+kniQe?=
 =?us-ascii?Q?Mhhe0IZFwSPVUbvxIc70SDDFKtl6b0MkdKbDtoW2qjjHWSlzbzLqVq0xt67D?=
 =?us-ascii?Q?+Kqsc90u0O+RbqApLn+9RvYTboxXap/sRu4r9FvwcL4XArC5cr9DiiB4EvdT?=
 =?us-ascii?Q?y1xUaTa0lMJwnAW/jtJhGXu1AOgzQeQ1QiwHhlBH+JIA7f/mfT0o/6WjkSf7?=
 =?us-ascii?Q?w4hzalFuSQz/g+qidrH9vjARwf/lYqEYVz2FJRa0FhhX6XipV+PRT8Ta2zbx?=
 =?us-ascii?Q?L440gMzWeTbVeB5FZlOWw+6rCh4o++W3PLm7PWR6FcfoE7XIAC2BDtNe9f0D?=
 =?us-ascii?Q?4OHSIenUX+kkH6paSPM7zR7i4VV+vx7ipjn4BTubmP1dK3JgsL6YGS6Omi+l?=
 =?us-ascii?Q?G3F9yoCsBPkOElPr3E40prqAfQO7SYFSVzSUqVxMe7HDJ5PF1KGwePXTAR19?=
 =?us-ascii?Q?bjo4k+3Hbu/F+JoJQvQ7XAVJWnNiaTKIIuZaR+exiRcio5MPntrhhZ5Gs9t1?=
 =?us-ascii?Q?lyv06yDdQZnaq4gaYejVmYZSl6cdYQfa/uipGvp6uLw44mQvw825Q/Sj6bQI?=
 =?us-ascii?Q?nyLhUoJfkWugVDehRlu5y1QUl1woDQ1CoJDOh4EpfW96IpVz87I6DSnYEiCS?=
 =?us-ascii?Q?Tj/UVkKUVfOMad7obmMr1/Iuq1RkYsg3soqTwjXsy6OTnznnuU756R/RSHUp?=
 =?us-ascii?Q?E8Ea84rs7xLdyceY5te+6N6AlDmPB5ClDJgNHNZdP8w7lvX6GTtCb92u8i7m?=
 =?us-ascii?Q?HRVPZnfwpTLLNXPF7Lyq/bQYHnM+fbdi2b220TMnMMfkmYR59t4ybWQ2+S6D?=
 =?us-ascii?Q?RSqhJUYkdZTQ3LXT6DCzg2Qjdr0/MA1cUQqB27LUjp2J+SO4gtuBucxW4BXX?=
 =?us-ascii?Q?/+lacJ37XbxUiNH9MoeZgaD5xWSz1B/BqMx2KO92QGzYoyhv510buO4yPGVU?=
 =?us-ascii?Q?7AIsIBBZ4u6SQqNd2TEs0W0IJjHs1ngkE/q7Nc35OxS2eo8xKbDQK8gay4PC?=
 =?us-ascii?Q?otqPLbDoDjS2OR2j/rSUtM9Jg2qixMbAYeGvyreNjRYR1zeL5WNMZVKIzVoh?=
 =?us-ascii?Q?eHAGsWbwC6Vs0pIakL0ri2uSd20noyH82WW0scbyEqhKKz9waOaspvdTZT1P?=
 =?us-ascii?Q?m8xxoRvoascH9CtcPnXWAGd4cPx41ug=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ff2ca0-f872-4ce0-124c-08da39f73cca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 00:25:26.8271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4xq1LQgvean0qfVjzxbfZ0DsTcCyUs/jmZFAVSyLcvVY4hjgzArAlC2PU0Xyp6wt9iF9Yqstpgh52iUT2M2YnjDbwBH0KPDdlC8nuAN4odQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2883
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-19_06:2022-05-19,2022-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=656 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200000
X-Proofpoint-ORIG-GUID: cRzpLo4u_psyhW0OfIyXU26Cm4b1-MXV
X-Proofpoint-GUID: cRzpLo4u_psyhW0OfIyXU26Cm4b1-MXV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> This patch adds vmid support to the nvme-fc transport.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
