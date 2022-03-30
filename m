Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58AFC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Mar 2022 02:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242171AbiC3C6U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 22:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242166AbiC3C6S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 22:58:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD8518178C
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 19:56:33 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22TKmjvN001219;
        Wed, 30 Mar 2022 02:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=uMHG+NM5e4N7c/qoCUW3lTtaWACQg/bPjp2lY3/17Tc=;
 b=OfJHKWR6u3tLm7bxwRytcadgDpIPNHH6cso2eZ2uxha2LOm2e+z4sXx1TC4CSDFNL7Tw
 jioVga6Pg609FHiTGuxNEmN55uOV4pI5rxMoYI7FkBFdLVr7xoy3leUqJ2av4nkpFmWH
 pC1maruNRN6BTwYT3twHFqkzTMgQ3ykd/+N+3bbPmDhU5d2cJaAKZg36xdP1LJ6Mg8JL
 xNh0tEimZEFwn4JXPaoGbiDPeqKRalpZ2IwbeYbiIwS7uFPOZ+REEshvnWs6lgLTcGhd
 PUgHKaRTr33cp8It9qZU4oRIA8dgvT0a0eKNdRPUJYL4655MzCtytd8GbRuzu087k5kq dg== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1s8cr2jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 02:56:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22U2ofH6100771;
        Wed, 30 Mar 2022 02:56:29 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by aserp3030.oracle.com with ESMTP id 3f1rv8e6wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 02:56:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0M0AEsDs9PvFQ++5fV0LFNCHoMKDzZBdjLSB8cP86KGyF9JObaTgBM7CZRq6+8GJWqgg5zp+mpbSahtoSx0xKPcvgIZWlMikDeCklIqA/9anmVRO2DPJTtkXxBlEjnnubJtwE1zAWZU/GMMLL4dxfRsXukDdfrZLQ01cgY9/SvMaO4ZeP2iSJDCy+kwHsKo3c7lxdZQ0l4Sx5cuUb/9hNFCNJEMKuKC4ZRfaZU9XbTlDSwy9tNeDtDKULZ73rTMASxTmJjaiWK269IwbGGv2n529uheBNM7FIpI5Nsl5a9E5a0TjyU3adnl8b28PH/1rvRSl4yeAwowRfkz1tupyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uMHG+NM5e4N7c/qoCUW3lTtaWACQg/bPjp2lY3/17Tc=;
 b=eXMkJAnh5ZmP3gOZz0pHlB0C4gDYGmJiNlIk+sTidc7c3/fczwpyOKdc3fjMvJ2Jf3ldzoy4tbijQjc0ropJYc4t8/gCE5u8UTvN1YXBRL8CwmgWu+DSqQ4O9ipPsxo1NL8+aStC40yEYXYdFv/uM+I1CfENAuMs+EsdP9pdxxmpJMtkgAWEY+KBlxWH1rSjK1u8t29qV3KQwJ834YFI3gMVp3UQVYBSwj7kpilPk6ryF9P/UTkb/ogtxZi9SbGKsZjQ6jSJQpQa6dWRgKvuY0Vlj8p0nWHxJIpwzYoN5ZY8uJ/go7YAnBmAR7aHQdvfsYuvwMRWIfYLp7XaMcnggg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMHG+NM5e4N7c/qoCUW3lTtaWACQg/bPjp2lY3/17Tc=;
 b=Xra+zQ6eLUbGbtvpDp3ewFxDlJ/8Fq9yU7tkXvu4m6M3UnvnVXnQYrmFI6g/in2i+3Dm2OII0DCE38wnC0Z3mOgQ6lJnrrjHbR8ACydBpEGzpRqOePoDBLvZfWf0Y2Igz/0hbaUZBQr3/xVnpwUCcwbPbrusGRAM9KLRp9YELhY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BYAPR10MB3701.namprd10.prod.outlook.com (2603:10b6:a03:125::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.16; Wed, 30 Mar
 2022 02:56:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 02:56:27 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v2] scsi: mpt3sas: fix use after free in
 _scsih_expander_node_remove()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6d8xi5w.fsf@ca-mkp.ca.oracle.com>
References: <20220322055702.95276-1-damien.lemoal@opensource.wdc.com>
Date:   Tue, 29 Mar 2022 22:56:25 -0400
In-Reply-To: <20220322055702.95276-1-damien.lemoal@opensource.wdc.com> (Damien
        Le Moal's message of "Tue, 22 Mar 2022 14:57:02 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0026.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89b046db-e663-435d-4c9c-08da11f8e280
X-MS-TrafficTypeDiagnostic: BYAPR10MB3701:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB37010A5DBA245178C4718EEA8E1F9@BYAPR10MB3701.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FK9zJiPrw0lU6jG2B7UNoZck+8TJq6N0oqK+Kgacx6wKmyFjFlWVmTVBSbkp7BvQNAx6DHNJgMDmNUI/70lQOXlOpZZAuIlg4G4qkCprwh8G7aMYkR6qLICq0URf9qtgK5V2KebsFRtMVVq4/JQKeHXNLcOSAn9ZlYOvcx10HerAfZCjcfXlPra17A9HCr9YDzHrPIAhhzt3Hcsd4mzshhxIQJv0mNhDQmSJJwKjNPlhDzM+vPA1+00Lnktai/OrADCFGaehz7pKH5X72gRn4dDJf7A5LV9Ehe8deCBxZTEUyuyiQO1oZTl30+BRqr7Q1h/er8UGQfVB76Mur928mfROqT7nP6TIVzMtClfaX9FDwXE8AXXhcZXx04cQ7HA2mNNz+4nr901XGKiin0TFw6J5GYx1Kqhdl7v5Ed6PUFYo2ZqczjcwP2bYZEYURWN/ukzgDyO8JDVc8hCPzgfNqftMmKzkLTMh2PuD2qsTslZD5FNaTrvhyNBt0l55OIC1Kp/oG8QFAIIfQR7Po3efPuCxzw31VAMGYe4jYGJXt7AeI0O+S5IZXafTY1w8waI7SYopq6jONY40bnl1ksKFcWDygOkaLOUYGb5xjfBNWqDLIevcf7qZCwJfqANUavhKE+9s0+f1dinKK66zL7d/bp73x/9oNQSG5AnUYfn0+F7WGt1nEB8DoGTGPOX5Rk0NgxWFgoOHX0X3U4sJl0dbP9Ynu+8jr0yFr2LW+szBCl8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(316002)(8676002)(6916009)(54906003)(6486002)(186003)(66556008)(5660300002)(508600001)(66946007)(86362001)(66476007)(8936002)(38350700002)(6512007)(2906002)(38100700002)(36916002)(4744005)(6506007)(52116002)(26005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gQ/Rj3yCsKcOYGuOqFcc4uL73skH59RRvqvtXoBl4jQAWHn0eAwLMQeF+1uW?=
 =?us-ascii?Q?j0SbZWzXEK3oanQ6yFLj870uXj9JGUVFHkN3TPSEdDRenDsgEP909DF0xRKc?=
 =?us-ascii?Q?nf9i/0QJBnxc83NA4qbZA9IclJOn+OfxfGCrIuc85MEpbrygQ0a9+EWVNvTW?=
 =?us-ascii?Q?fDWQtSD+NivBDYnafOhoC1w/LsuIeBDxmRfDQKqbf0DiQ9sITc37S8y55MYa?=
 =?us-ascii?Q?+o17AsGVfuPgWoxNF+MbjLkl5fdOvLu6jjQJb8LiGtiOn5XCEdmmnclk8PfL?=
 =?us-ascii?Q?IWCRNzicAFzRQvTgL/4XIiPqe/WE7sPxgPzMqgenjDQRz+dMtBR0r/+9Y1c2?=
 =?us-ascii?Q?JfThGJMaGKOxaa7FtwZ8orIEHuYbc1JHlq1N3UBuOcfv1yKL3dfd8vMc1vcQ?=
 =?us-ascii?Q?fe3WpKFcvQeRjUhBF8fSxYOp7up2jgDf3k2NP3scqOAUonqHATu8TeKeYV7/?=
 =?us-ascii?Q?sUggSDje04kpX1TYK7dtBV/dSM3b1nBJKlEU52f/EPlOzleGrOrq35JAIXJt?=
 =?us-ascii?Q?LM45hfFp9mSWx2qrTGL0KDlVc284706X53J4LVWJlLiU7FfI46FcHbDSxsqP?=
 =?us-ascii?Q?AwsKAMYhBKT8W9K/Lo8H/s51mh8FPSfXZQ6eDO6D8r9WNbfbbsB8dllE5NbX?=
 =?us-ascii?Q?yRBrlcfQ9l+7gKALigWcVxxxvw3AwZuASZA7zXQOo2fZDMIIHjQ7ostbQxZv?=
 =?us-ascii?Q?7PcHMBeJS1HqNy90B0+SRdJ90cR6dsYMaqUO6yffTIX4LloiM6H0UdvfRxJT?=
 =?us-ascii?Q?cnJxl6YwRBe75y5W9FzNja+O7ABZ+DKFAR6DL3Bpk7QNzcJbE8z/hVkFER1m?=
 =?us-ascii?Q?8S+6lw+XnvqEauBQAtfnHw53P00KLu+rU970HHuR3Xj7UmOLctju/h8y2h8Y?=
 =?us-ascii?Q?PDIQBNwR7onXwuRDSeKEeCUvrwt2L0Ftcs6i0lW/lzvycVA7jr+IzEpMTJx3?=
 =?us-ascii?Q?Umz5ccMPxRsQ/nEqHuIbRrUTcfUYJ9C97qCmiuTluWV53eewyvlzJit6u//a?=
 =?us-ascii?Q?yro9HEszDbh6hKiDeCGGVVgFgFcjl3Q1o20+wpd/22G6AJzPuurySKBKF5e0?=
 =?us-ascii?Q?JTPrUruhSaQuAwBrKF7m8mwzhgvwjXBU49bezObbTMYjJLpvh/mOCFG99ost?=
 =?us-ascii?Q?2g6e+ShGZ8k8s5gnRRZRwQqqkr3/jpKHFid6nvgkI+hMB0Rlw+tTWZsD1yPl?=
 =?us-ascii?Q?HMDeaTw5gJ+QLgTP+cAhAQVEA/7op7GiDqdF1lXRSM8HoCLh0occkSagJ3lG?=
 =?us-ascii?Q?A65jm21ZxsKq/e4do86PI+iDkvzdK2EfGaguckWT07bYvwZdT5jpEDDMtLWS?=
 =?us-ascii?Q?hAD7jApA876lqIa0kecw8SCrFWLKHPLRS1jTA+XG3cPKO8L7ofht4mAFSiAQ?=
 =?us-ascii?Q?vwjmwOe/HCqTWvEL4L6tbrWns7ov9Y4wTrwdOx4koqMFLczVRt+fs8XtNjQo?=
 =?us-ascii?Q?5fa3gC4Voerk056aCttKOwq7bm1IlW6pfJ/LrBT+R7GsXTbNtGbp2tZjc7SW?=
 =?us-ascii?Q?h3fpu71VxwLl+gkHp/KjWU3K1aTzL+Q6sqa3WmcZimX/D8JefILL88CWhHzW?=
 =?us-ascii?Q?NDv7FBxwD1t1IpbbAzwywLf4bZfVr58+8TP/7QF1H+x1dNQrwOgU38EwaDSz?=
 =?us-ascii?Q?YM+AIF+2NKzti9P/4ImUvvRj+hPRvxvox55KbuDsTZUPNW14JDeG448YJ7kC?=
 =?us-ascii?Q?2ooUTHXuaJzZMco4WUlE1pKR0XNjR5O44Y1xtzMEzyZY1hbOKiBCA1LHxVJ8?=
 =?us-ascii?Q?bd0TDpVyYRRuN/Gb8fW7GmWz0LjXBF0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b046db-e663-435d-4c9c-08da11f8e280
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 02:56:27.7060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0DIJ4ahEuRO7A63skLIe8hUdJtpbSQGwarRLw3HyKAChzfJ8aTdXQGW0FX6rz0gDDUcGxvRbKWIN6m00NZBuXMylYZRDOKJ35JFGCN9zAbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3701
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=751 spamscore=0
 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203300013
X-Proofpoint-GUID: GPLVkJRu7eoG_1TQkKX2fVTfVG8-xVSd
X-Proofpoint-ORIG-GUID: GPLVkJRu7eoG_1TQkKX2fVTfVG8-xVSd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> The function mpt3sas_transport_port_remove() called in
> _scsih_expander_node_remove() frees the port field of the sas_expander
> structure, leading to the following use-after-free splat from Kasan
> when the ioc_info() call following that function is executed
> (e.g. when doing rmmod of the driver module):

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
