Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A6FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 03:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiEXDOW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 23:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiEXDOV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 23:14:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98EE82152;
        Mon, 23 May 2022 20:14:20 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NMi8tl009518;
        Tue, 24 May 2022 03:14:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=jOnbnD3jbc9W7mtZ7O9veGBwvGsws1m6WWnZ/62IPKE=;
 b=1Isg7mx8yxtnf9AvEJ/N4+fQYz+ChDenc8v3vgGX9gdZMfToP0xcZtbvjBgsvPYUFWES
 pOjNpjbkVMOeI/s9e1OUFOYO2xZu3x6f26d7sf9NsdZ2XVyZsUkf+oE1KnD33G7EKwGf
 pekJdQkAzwixhnGbDbGLmiUAVEcTzTF5UiExQtGvOQPRkddEvTSpgdPXs+igMxAhNK2R
 nA/jHASfdh9fMALqns0hCpUsWC6LLREF6pKyo5I/SpT/o7rYqLpswdPW+fYNzVADKZ4b
 0yAkG8fFjQXb3YstMDCYYed3yG9o0tFluNN6nxa3uOXoNfX9hHIMW3V+2wFUL+8EfjK/ 5w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6pp053dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 03:14:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24O3AJIF003611;
        Tue, 24 May 2022 03:14:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph266xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 03:14:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dKI+e2VfRSezmAzjgiMYfACktyCbgPdxCDdFl4xQ0ZpOoVtUwbh8V0F81HHU1P/u5PXchAFx73DUC9sWp/C2fsLop6Nf5ufDuwgbvnhSwfNDR1GL1sE1W3/CtJ7xhdeUzuGAYg9XI2ZeH+JyVga23ECzmEIYU/0LnZABDTAOdQ9VQrJubku45gK4G2k6N1q9uiBUHLKIRm+GFD8U9vugMQQkgi9Kw1TxqDUSiRBlmOPW8vvClkrcnmSNVioA3aj3t1TPSEVFUGuEHKT94003KYDBvtUJ+4SdI5Ng2jJWXGcsasXpFqoCLKdDosfm8OBwfb7s9NoEcWcniDK2su6+Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOnbnD3jbc9W7mtZ7O9veGBwvGsws1m6WWnZ/62IPKE=;
 b=PMDJaaWa4RP285vvBWv1y7nNRZ5U6aj5anNjDq3GinXCydTC0ySyPi3RNpFg7DFIwF0viZ7l2mHRkpdZ4oLhe2L+ioXiJWuU3KcZ2AMJb/ei+e4xizCna6cygNO8GVkJJBRGCI+OU7/GOpjhOwLK92xDoIKUAJBAwxqQdIhOE36Oxt3yB2f/Ko+rM7Nfj+BQz0fJapl5HrrepPpqEyidFrQNgsGr8qbFmuu6z8E93NpPvokNwzYox3GIVT0ziugQfB5cUJUx4JDL5uX5a89uejLBLL6z25bJyk5tTpNBz0mx+g7ps5wcJ0oMj/rFqAxzixP/2efBlaL/JWrmv+G+kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOnbnD3jbc9W7mtZ7O9veGBwvGsws1m6WWnZ/62IPKE=;
 b=o1K/Q7Ojt4BREKBMJhPsq/P4GlHg3X/jAyfXCzxNa9q2j3y+lyicIwnlkp01zQNosYDGCY9w3NZ/oJHFQOq79ekCdjoQxiefomp18f61dxNfKI/93GrTJtTzx2mIl+AWHK1bgCwRCvZmhyAa3R2ooE/tMBTtq7vqMj+lPv1wBc8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW4PR10MB5861.namprd10.prod.outlook.com (2603:10b6:303:18e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Tue, 24 May
 2022 03:14:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 03:14:11 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufshcd: delete unnecessary NULL check
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7znhbbb.fsf@ca-mkp.ca.oracle.com>
References: <YotFotj43TkB8Rid@kili>
Date:   Mon, 23 May 2022 23:14:08 -0400
In-Reply-To: <YotFotj43TkB8Rid@kili> (Dan Carpenter's message of "Mon, 23 May
        2022 11:28:18 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0177.namprd03.prod.outlook.com
 (2603:10b6:a03:338::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91e0af34-6b44-4a79-dec9-08da3d3378fe
X-MS-TrafficTypeDiagnostic: MW4PR10MB5861:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB5861228840A1D947D92C31018ED79@MW4PR10MB5861.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QTMKFfEbXizVgyJvKY0ranjwlPoFB1UsJk4tKLwgwRuhcbdxZRhV5PLKlP94IuyH4++EnzHDVpg9rM+qCxe5OfjhXeBfDxCzXFnXOybZMvXlW2UUsl9ZI2aLs0THwXmRI+xkcBDEFPoABpeZxVOAbIp5hGJKh0L2qp1OpVSxFS1k8tpnAo5VljOdCpx0qZK0fX3Fs1aUm8Qa3fAulKjkegcsLJjFxEkg/1JpzE6y6Jlx6Bt8riz0odc7shQLEGgDg8FwPquW3xr33jYmVB8RHvXPW96wkOLQfjexTocgIvuhfs2n8C0zix0aYKpjtGhSJwXL7zSfcRY/Df+qymzk5e/chNuhEuiVqn65dpzjqPSJheoiD9cCKwuEr4GlZCcvuCOOAQtY+StqaWpMQ97fQP3DZ05GP/06+TUSFRO3d1uiKnbrSUeONzoJulSpCcsbM2ro03S9Rd1Xxco4ss9Oe8ptwpmuPYGS8/rjcmBSKz/LAsFes/NvXpX6pdIvxDRb54AaWCkmtAlclLLbxMmWwnaJLU3gm44QMmetwTi5eYVjiwQGQiYNxHuQ9UaKHaBdvFc2pGSwQf1M8pxWOYVtX7SwnBWO2sKAbMMbND81La0mlvRZRFqUsz1REw0030YDTLON+G2u07GwYlxH0uVngRBr5Ry6aSRg+XpZLE8Tzo4eDxIwkAx8FPsHR1Vn5mommwi1gZMpco7V+j99+Z7UXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(4326008)(38350700002)(6862004)(66556008)(66946007)(558084003)(8676002)(66476007)(2906002)(5660300002)(54906003)(6636002)(8936002)(86362001)(6486002)(316002)(508600001)(26005)(186003)(6512007)(83380400001)(52116002)(6506007)(6666004)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U5kQdVVTEbgcMQxS6Snlytx7yf2Ma0ggWF69ueO7AGnpBxu452eBncNc03vd?=
 =?us-ascii?Q?HgTDu+/VVW7odquqvzTuUoQks/JkBg1HdcC7EdMzHxbiBMPwYA5C+x5xPi4M?=
 =?us-ascii?Q?TWnkrb7083SkwzvdRKScVIfynMGD2DdzaFnzW10IrD74xn8oMrOOFFaiatC2?=
 =?us-ascii?Q?NvDzC5/Yjc3+lIX1yxdm02VdTu9xRawI35qwoPtcW5CzN+tA5zmsnqHjoOYX?=
 =?us-ascii?Q?ZONzrdb3VNnSElosRSFY31cJcHGFth+KBMdLujxoa1z08/qmbWhi2bzQCeP+?=
 =?us-ascii?Q?wpV6WDPMYSsRJ2LfPj4SxgTeYnrSOeMG35KzGkqKnDm1PJQo0CSkew2dBkc0?=
 =?us-ascii?Q?N+rKWg7bCcpITiaRE4KBtvQnXJ5e4QvsjzABd6tb9KFjp4/8KjGpR0lQmR5e?=
 =?us-ascii?Q?UYCLHl0Djc5H8Z+YkLP+dNn6y8k/71E795PLlOtQ5wjRVmRWQdQKGff28FH3?=
 =?us-ascii?Q?VaHfIy/DR/y2GV+DTC08bRDWGX/9FLFBssjafFcspnWnAPaEF31EoKN/7SLb?=
 =?us-ascii?Q?vpPyUjfLhVUowAQHhEUE8l4SVBogOr8TtaFHfb0tA+slFbpbgIxraFIf1s87?=
 =?us-ascii?Q?6T0cDOD9cbavttSUJ9Hu1AUOj6/4O17esywOoC36egQhhFpWYxAH2Ra8eVRj?=
 =?us-ascii?Q?7m1npw7JGOQNo3IWxu5N0R0JTCf52wXWiIIRZMnLS/hMp/nKKmrFsWdhfwFm?=
 =?us-ascii?Q?qmy1DxPY6zgs+eolZfgBqZyX/lXH0VJ/mx+MIGhm85KybpapCJHkOPt3e+pJ?=
 =?us-ascii?Q?kUF2FdmRt+rBaoLqUYzeka9R8tiura0ZU8mG0QqBe6ekkwGodiE6kJoIod7/?=
 =?us-ascii?Q?MKhF4iZtovNYwyOjAt1wlUoT9BtltUUS9/mbFO2/U93di8wqm1BsQ5y4lneg?=
 =?us-ascii?Q?uSOnCzX+1XjNBrbSYZafrhJ1m03C5sKCqi8W6rb6KHNllXjwDv/K7i09C6Va?=
 =?us-ascii?Q?6G3SDa19ZZxfOBDSlOO7Plsgcf0IInoayf4elI+wK0bX8UPdVmmXjzQIdR/I?=
 =?us-ascii?Q?Z7laBoLN+OE/ATvVeu3dErRIdKrygBgWyU5b+pGiWi8E2qUeP7aI76auYch0?=
 =?us-ascii?Q?e1Xj6/g0dVc7z1M+y7kQObazbDoE9L9NdxYFzl9CQZY2L4kgGBltHf715BmF?=
 =?us-ascii?Q?M7e6OP4pNn3FLs2OBu7FKF5PjTldukvGBnok65afjgvBX1F62hJ3A480zZIq?=
 =?us-ascii?Q?Sp9ck9DQItenxTps+2JxjCD0VMbHF03EJO3Y4wY9MHJMlEgnR7kKY3xEEytV?=
 =?us-ascii?Q?Ty9qRCljnoPYtDFa63Nmz+MMRxJ3UmguV+hOUKd/zpSgtL4as4n3cQI4M249?=
 =?us-ascii?Q?sgCIaMPZdrAK0Cw6ZxdWNK92xrTUXl6CV5UEJxvmTFf9J+aD6Q57l3UalVPG?=
 =?us-ascii?Q?K4/d7EbTzFoNeGftEhSMVPV4538lWYVAbtRaDzs/2jD7UbahV3LRwrynX6I7?=
 =?us-ascii?Q?aLb+hudphzgeY49zydoLPbNuwBYoXBxJPorN840r9FNQh7DYF+NUhEhhPZCf?=
 =?us-ascii?Q?/AhR61hACmjqzjXmdCmGsjR0CxnNFQ2kEUUM6ZUH8G5mEnRWqRVLB9CCCYB8?=
 =?us-ascii?Q?4weUnXoYLoznUTe7QBQznYfJiGMMsvFSH/Vou5hgtJGB6B8iwXgyWUcTWrIZ?=
 =?us-ascii?Q?EPnJiYU5+Khv7zt5I3ejbGTdMEESUA2V8Ei8TJnJHuJdopE1UsgwUhZUggDv?=
 =?us-ascii?Q?rCA3af79mrARSggT+qWfSyp3DLq1xpJRaXFWiIopPi3bYoVH0VhGCdgW34IL?=
 =?us-ascii?Q?w6JfWZ/DHbCA6NvVKOQQpV9tq++azxI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e0af34-6b44-4a79-dec9-08da3d3378fe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 03:14:11.0661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jiUcqukAeMPfbz7uwaf/hnX8q0/EKbLZveTE3cuUbVw2otNowR4lKRIAfHBpMrd030NJs4WbKiTek8dlW8z0Cip7fx2x04lXxQQSdEf12k4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5861
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-24_01:2022-05-23,2022-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 mlxlogscore=870 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205240016
X-Proofpoint-ORIG-GUID: 6laTEXaEfJQREr8zOYV5VMVwRxm7GJ9p
X-Proofpoint-GUID: 6laTEXaEfJQREr8zOYV5VMVwRxm7GJ9p
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> The "info" pointer points to somewhere in the middle of the "hba"
> struct.  It can't possibly be NULL.  Delete the NULL check.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
