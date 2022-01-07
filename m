Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9CEC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Jan 2022 14:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347517AbiAGOKW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Jan 2022 09:10:22 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36480 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347516AbiAGOKV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2022 09:10:21 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 207Dx1Sg014505;
        Fri, 7 Jan 2022 14:10:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=9JU5t1pXp2T86lQO1e2QX9As+FSh06Ks6PtNthBOFOU=;
 b=LHZYlFITtczyUVQqVQJfoV0qS+0eBeizOC2KyRkwT4oheP0M8+G6wZtaMqQz0Cm9EdUB
 5rakETqM/WTOYCHPxNtOB1wvUop45uuYqGvGLCe6Dl4FsCsfP6evYb03BmP8/0rTWnmt
 jqdbjsyIygCZWYmfTJjrgBP4qBM1V3F3LgFaYMck+/+qcI6S8UvKUQboYr4l9NHc96hQ
 +l/sSRMH2PsvwgHvKHfFb7Yul00uUzbLvF8cQv2yh8IYxyAXzxJBy0TtRL2ACAjtSdst
 87NFhpnBKiErgUDqS2BMUMiJx9SUChMNAVWv60Seah3lNRJb8e9YoWitMEuejGpvrNgh /Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3de4v8j4qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 14:09:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 207E6E17101075;
        Fri, 7 Jan 2022 14:09:57 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3030.oracle.com with ESMTP id 3de4w33uky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 14:09:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEZiqKzu71V5bh/PU8kpJScb+dbsl3zp38bXjR8SBDlq5llbD8gr5AKxI+KBm+zC1dbn53zAXnOnoHRPNA4IpPt2+yBuSLQFaL0EIer62UMvwIPg0NbZr0GbD81S5G3mpfQx5AGFsMQcji7hf2WmiLndf86Y6QeKxL6b5CcW3dNpPeB+Cmgkc9hJYosIrH/7tTxrLA+3++imUT8bcw47ybSoyeeTsBx/TgpoG7m4YqF2QoWG0hJqUBD2+viYEAuDToAU56UOn2QYWqtOiPuj+963GhHcn3uVssaCE5tuba1FsesWJrjQvJ77FhAN6wo7G1BlxUlGZQJ9GFSaytYmYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9JU5t1pXp2T86lQO1e2QX9As+FSh06Ks6PtNthBOFOU=;
 b=IzoN4fAjwPtm39bOfOfaP8EeVjlcKUo35+BqzgYmcqXjTY59tEw+uUOz3Qy4s47E+JUs2DgrRD0E0yXJcifhNVtsblVrDnIwPMayh3wPQ0jxg0liJnaPc0HDZTjqqFU8OUSRU/NJUjOSBbrn852k203vZ26cv0vY+aNuWKIMgC4Hut87iVXT20Kk57uCun8lL7nZxoJuNthQSqM+AF+CVhnhEOe3QSi+BwpCRl81z/IQrhkfqgyjyRKJHgZQAcwSuHcCW6QcTh8yimS4eLMygMAxQBjFoCmhqG4mYaWzMVAMAxQvtN1klrWZN+m3xxmv32Irz/WMJfPSrJor4ITX+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JU5t1pXp2T86lQO1e2QX9As+FSh06Ks6PtNthBOFOU=;
 b=JkTyMV1CiqPApX4mAofzkz+epQ/fpyLTWZSkDKcnLU5vEQZAcu/xIB4SgmXcB5c1/jEgbIbsPVF8HbgpvWQJ5A3x7w+ITupjMRIsDsWdq5796AHiKA/SVR5I3+G8Bw+GSd7hts6nP6naZsx6QV5zroJ4fjYHTVwhfUqblBE03qA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5531.namprd10.prod.outlook.com (2603:10b6:510:10d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Fri, 7 Jan
 2022 14:09:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%7]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 14:09:55 +0000
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, <nathan@kernel.org>,
        <colin.i.king@gmail.com>
Subject: Re: [PATCH] scsi: hisi_sas: Remove unused variable and check in
 hisi_sas_send_ata_reset_each_phy()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7afwsbd.fsf@ca-mkp.ca.oracle.com>
References: <1641300126-53574-1-git-send-email-chenxiang66@hisilicon.com>
Date:   Fri, 07 Jan 2022 09:09:53 -0500
In-Reply-To: <1641300126-53574-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Tue, 4 Jan 2022 20:42:06 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:806:a7::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f806c42d-3bbf-46dc-7c48-08d9d1e7617e
X-MS-TrafficTypeDiagnostic: PH0PR10MB5531:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5531E5A9E7AF967E6184A0998E4D9@PH0PR10MB5531.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:590;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0aINP5R4TQ9xHMeKl8EvsWZ+pi7XNNeh9cHMx3FI9ocF0cVTnl26SQFcCceayw9JDSfF7Ap3h4tyBeOfTmyYLqtpRWG1HZpGfDJWWShE8HfTcUE8l3W3bpikNinmgWnFsMDE5I5/xKe3cGLvitGggw6D6yBh1Q+cscWPTtwvu/+weRiu82gtmIRiQqXSnGjB8y97LuCX09/p9PIIkUVoLJt2EdZCjCiPx+gcKczAT0b29K6Or89ngz49z0fITwXx8gSXKJxX7wYQl3wzju6+05r06FS9o27CbqNSMugtXO7B+/peitKB9M8qJKfs40FPru2z7sbWvSp1oNYMWCRV2GO/lxP+iFfJISkmQTMZo9pp74NEZYLmr2cmsUJ05Jr3lnwTgDNsFcwXYlTiou5wDsjB1a+iorvHYglC7u2zzjL4KE9ROtiBI5jFGNJB9uMo+SCyW477kQwIzBAOuhS5Y43ZPQDu/zJWaugeYu0D0KcSIFZ8Bvpjjo/sPAJoUi0IDSMQ8yHtXrAJFWzqEd0T5vuxymMeoFSssQNUT2rfHxERcWyoZGIOzCi3e3G+5vm3SyOOA9isGGuoGZkr5aE6qmWvmARypuy5uuplcumTXAFiCbNg8xjeewnOkUlcm7nODc72/1Xsk0CCFf15irw3YlAfiFIlCOA7ehyfQhPZ707lDll7Wag6dzQCL8nHHR5l1/OmYNmO69+S2kAjID4QLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(83380400001)(8936002)(6486002)(4326008)(38100700002)(316002)(508600001)(38350700002)(6506007)(36916002)(8676002)(52116002)(26005)(5660300002)(2906002)(66946007)(6512007)(66476007)(54906003)(66556008)(86362001)(4744005)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JNjQcXOXfpxXW6m2qm7JTi15EgpPqpILmJ3pjT90OBa9W4v2vXFhn/KSSEMB?=
 =?us-ascii?Q?46nP8e5034kr3Uk8ZrLd7uE/9wPQdcAeKuuCfbZOe8i+KiDEDiGLPiv3d+b9?=
 =?us-ascii?Q?HmNYwM3/LOQ0gjJLvP2JRiCuIzM6XKjhG3phB3zPrc0vXfuruW+e9n/tHXQd?=
 =?us-ascii?Q?YhNK3OO37jauWiW08EoRZOuk3Y4zDy5dw1dtCuFvSnKii5MeXWh6XYC8TvHg?=
 =?us-ascii?Q?Rx4HgJmP98fGMYdTOCmkbBWiY5UqD0T8ulJr5d6lnv2OywryR4VjEirlo174?=
 =?us-ascii?Q?JiUIe7FTzrpLgNJN6ybHjN9XcpNh/2jOcLw2VCJkcxbEx9t01syQMRizYyfq?=
 =?us-ascii?Q?5GSGM0ssiSbbDBLrYV/NP/vdlCYTTx1MlFGZNsyyaj5596kY2HqvZ6YRXeC1?=
 =?us-ascii?Q?MHuYQX+/guxGdTlN+vSAzGboWdfHT6PUg3oEmPIPra49Z+fyZNC9FCyBIfiJ?=
 =?us-ascii?Q?Ay7hVm2sX3z+dHF1XvLpLgpCHJzNFTLThYmrQmqJGhKp1IMZsXU87QsPYebX?=
 =?us-ascii?Q?wwpRj9zU3G4EIbqs6e22Pc6BSLrOK8qLepUZ6rEgnvkILyWXT2tEacv9v/S/?=
 =?us-ascii?Q?IkEcHGv9f21TONXYiBc8moZs2xEvgB1W+dsGfqZdwZ9/KMQ3E3/9s3yyIFgl?=
 =?us-ascii?Q?8nfV/4RfsHqG3jhBL0R8nDk1+gpVgR1sTluecIBuhc2blSrT+JmceTOV/3Av?=
 =?us-ascii?Q?RWPwSpzERv2wFw70EdEX7rR1CTQxGwHkGHnJHFTnOQyxrLdiAKwZ/Z9kZWdE?=
 =?us-ascii?Q?/lILqYk+qrMEqeANZSAX+E/XE3OILH1V4E5kScz1Ie1+a6c3kyIk1I0Lp+lT?=
 =?us-ascii?Q?7X3Pk0igUvzSOrATbym9w2/qhbV/+k+ESQr49iqf3lQviwrSFLRTCQhz8EuY?=
 =?us-ascii?Q?XRAIsIPP4eSxsywyX0XfLey8/2qKe/UwO9j8Nsfhd+OHWTMxJr1jvxSWt4B9?=
 =?us-ascii?Q?S/EfIToboVY8HzCEzAjd9borHbvtZn/RXFGYI2Y/jT1OF5ZFYc09TFftjVgD?=
 =?us-ascii?Q?Ror9JZFOshZtf1lXqp7lStHGJsq77CQG3g76sbjTd0qZpDdlXgezJ3M7oy1S?=
 =?us-ascii?Q?KUGQ3o+nNQc8mLPLY379aXzx/hBLvEXlNbxegG4lENFtH7QM6lQhkoMhRj0l?=
 =?us-ascii?Q?5xNcIpP1he15NcGx3uSt9ibOFYicwOcXnUItUD7MHXZSicdy9F0k3j7Qfq6E?=
 =?us-ascii?Q?mB2K879aHjCxvO81t1mIAsCZwkE0K7qNYctVsEhZNmwZOEpCO1nXj1a2t+Bf?=
 =?us-ascii?Q?/tqfBcaLTY8dhAHDtsxGDGbIqov4vpcLgemBSrKDg118D7T1qRP3m2tbMSEt?=
 =?us-ascii?Q?8O5QJG6ou1DgLftceN/S85LCMwU06GQINVeaznuvwOzirSF57h+cKltUv+Vp?=
 =?us-ascii?Q?lm3dGFe73bQZoS3guyASYEQGxVevwCpVyh7gkZEwqUyaz6vcuXf7SmAeuWMy?=
 =?us-ascii?Q?mkx0uThCjgLbF0ZUoazfEMP79X6CXSAVLotv802umwgPhuBjiHFv8v2DRHzU?=
 =?us-ascii?Q?ZBaKSRoUK+Bqkl+P4Zo74ocZlzYPN7jKa1YPtM9xHd+CK4U/NrJX/JKVzLO0?=
 =?us-ascii?Q?VnwVrmUc3jmVb/nLUTGMLV03t7WB7c/NxLOuMXbSCjmZgV4LQM0FP+n89aLm?=
 =?us-ascii?Q?gUKktCesu35KMkGGKyeuAVlxGB0qVJmA6pAJO9p0BpqchKbrO8WiUQYfzKN6?=
 =?us-ascii?Q?78jNGw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f806c42d-3bbf-46dc-7c48-08d9d1e7617e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 14:09:55.4059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ieb5pppU9/nCh4J8PTbkVGeqjVjq3H5m4a6CQ3wNQ/XEJhAwTpzPhNaSCMIEdeG3LajpZR/8P0SE0yS7mFIBxl2PKqq4fr9zD4RpVTPhcoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5531
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10219 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201070097
X-Proofpoint-ORIG-GUID: H7LSGgEoZ4tAb37J_XANd2xtBJk76GKs
X-Proofpoint-GUID: H7LSGgEoZ4tAb37J_XANd2xtBJk76GKs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


chenxiang,

> In commit 29e2bac87421 ("scsi: hisi_sas: Fix some issues related to
> asd_sas_port->phy_list"), we use asd_sas_port->phy_mask instead of
> accessing asd_sas_port->phy_list, and it is enough to use
> asd_sas_port->phy_mask to check the state of phy, so remove the unused
> check and variable.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
