Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E124AC32771
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 02:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiIPChi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 22:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiIPChh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 22:37:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609D56D9D1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2022 19:37:36 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28G1ww2x013432;
        Fri, 16 Sep 2022 02:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=tIJrrDnfTR6YGMGZeUuXJW5Waz3bwrp7NjXzRJsAYfc=;
 b=URfRotMnhsbtsCsnsaZI3MQ5pWvV3lMzxp2L3eL3UeBo6b8CpYgOwtzLcW/KaO8SzIss
 DGN8cAU9ruxaNMZe+EvEsmNgo0AeaGbdZBIo+4aiWSiVdWCy6q6OvesbKb2JdwKLKGrH
 yR0eVx2NUDZ26kZCUZsGvGb/CUlTc8uvVK65UZP88EFAZD7dj4BYsCATJ68T+4fpOK6b
 C/SwxTTk+RCceS86qVt9iamtlYMJO+9EqxFBAkM7SFdC8aV8aCupSguJpqd6kfa3KdxW
 Y8T9WxBZQNz1IReWw6fNR62HVf1YZDnmoeqkMtA1pMLTq9y98/gqUlF6k9okujHUfFOW tg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jm8xb96u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 02:37:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28G0TD8b013221;
        Fri, 16 Sep 2022 02:37:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jm8x9654w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 02:37:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBDiork9+bC6S5pStx5IksETzVqfgCC6TtNXC2xIJcL2y708uAHDSTpqRWlYS9o0KebL0AeiCiOARDvl5DUwM42xmdvaHZqPfHML9iJEyXO3vGZ7fhDKn+U12Qzqih+KA1p8cImu+o1HbCVCc+fUehGNg6M2wCG9itAUKTI3Dnkvc4v3gIgLOYC03f8q2D8Zlhs6DTvPfLuL+aOTixi2qVYgFIlu1QwF0SxmY79WdtGCHCqlxxX2fvVuwU8SK7rvVvsb7uYkAItdw9JqpPuCecRSQkyQCziXCP3cflfF7vgC36k22VG9ESSBxo1f0JIZvZeIz0ikNnMaGMr8HcCFHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tIJrrDnfTR6YGMGZeUuXJW5Waz3bwrp7NjXzRJsAYfc=;
 b=oLni2/U23e1+SGp4D/ATP0dbut4nkfEnzJR73rTFSEbkNrf7S7XARn/0FVbu/jUA9sF6bb9A3F9WMWLu/I8pTN+GsTRdggM5pRfb1kRhi9WNk9A/X6R78/F2+VPQcp/VWwzlnQws76uijlYnGKjffyPkhgUnn7S5H8ippKRMYYBvQ6P75ABYukVEqUlwZPI6axB9y7+TFIaP80x6P+eRH29nVabJlJPRv0qA4fIL50a8oyWi+/qYgHZY4YRWnCN6ap1/2fV8dsI+CedXM4cNwY0bBKJ7hw0B48ZcJSmbqvNInUduQYdGAbYidHcaUrthJhgYQwLqYPTdF/FTswlVTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIJrrDnfTR6YGMGZeUuXJW5Waz3bwrp7NjXzRJsAYfc=;
 b=UZso33Nz99JiSgcvTHlE44yjWhAEW73doM3T6xbnd5ghq5BWDQtot0U0OOaxjhXC7y+8fOiFU6AIuiiTemyFN4MsxzU04w7hyU15beTPbZPLUSBbQ8dwyzoiNMEppT+Qh5Qz98JXgLbLGZUrHl/6qQoDcEfgirNnexnBLeHj73g=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4554.namprd10.prod.outlook.com (2603:10b6:806:111::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Fri, 16 Sep
 2022 02:37:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 02:37:25 +0000
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "George, Martin" <Martin.George@netapp.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_transport_fc: use %u for dev_loss_tmo
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmfw11uz.fsf@ca-mkp.ca.oracle.com>
References: <20220902131519.16513-1-mwilck@suse.com>
Date:   Thu, 15 Sep 2022 22:37:22 -0400
In-Reply-To: <20220902131519.16513-1-mwilck@suse.com> (mwilck@suse.com's
        message of "Fri, 2 Sep 2022 15:15:19 +0200")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0143.namprd02.prod.outlook.com
 (2603:10b6:5:332::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4554:EE_
X-MS-Office365-Filtering-Correlation-Id: ac87ed30-d467-4368-23ab-08da978c63c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yE1wEmIKMElv4yQBa387hQnG40Gofefal3HgAwxNEf8hX9TZFufc2+rgrwm1Hkq8gL4NlfY2+21pM/ncZ/8U9oPBsf83fi+A0HG/zO+rTlUk3M7YLBYCCBMaQoNP9uH6bIO69VUhwXLguC8JVfg3n64tCryKEpaCF/2c1ckFG0Ddh7UdvxoDjgL3Auh/v0HYW3uxHhmt2/yDeMG74pZLC01LJ9s/9hhnok1fYoE+1YJaiZs6ms3gUg0CFbXYOBQ8gNGDdxvGc5JgRwuMm1rvRTUolrxW/silgqMZJyqYU7EoZjsM7a/KK0cuG7f151c1EY+wYl/ydLdoKS9k+bUP0CCqlKXj+BBiCs+BprHBTl7wdI8AS1fpcVaLiM3pgq5etMRxvmftSBgKH/+gx9T0cCKOmnD83laqgFcmSXqxS9pzdtg2/eD1jbgzQIaLDPaG0NMWaJrZDnS9RWuY8VvkMPbKrh7J9zIUBeFXBhosaNvajZlD9aQvfn3xDPTU1hujjP7HKtjMyZMk620/UsFsKuOQKGNvGWDc4Lonw1Np9GiVw69kps8/+/kFPEpEFNwoWnlG/XYCubxOKT+AaQ8Yt9ZLgGpNT2CX+hkNpUI+xm+FPwvgU9k92+j2URUtjs6lO3lEIo9+dIf/Axi5tJkfprUjwzoSmMpYTRIKoqLL60gdtipsM5u0FNJ0ET31oyDzajO4qAJXBO4c4IAqVcYQwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199015)(558084003)(86362001)(5660300002)(4326008)(8936002)(2906002)(66946007)(66556008)(66476007)(38100700002)(54906003)(316002)(8676002)(6916009)(36916002)(478600001)(6506007)(6666004)(26005)(6512007)(186003)(6486002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WhmTtOsdGHbGiXZvjNAisEbd/SZ7B5/5jKV/0thiMwnBQbJEBiSwc8H2Z7Xh?=
 =?us-ascii?Q?hPzm1QWDWzD1eseX1Z2DUSZpqGVrgGIKDTxTPDnxWq6TW1CsZ9j0P5CqqSP3?=
 =?us-ascii?Q?LODg8Rm1rzmUtgIfrpoSmhkuTtlurdC26sl0Zgh7ruJICoRBP6O4BMHvbHU2?=
 =?us-ascii?Q?os/DABGc2oX9bf6WyFLzuJ7Xgqda0Ff6a+xq5YVSCcTkRnhXAY2BPOlDWFlL?=
 =?us-ascii?Q?ncIBLC4hhG+Ozqb0lGIgL+2zIKetFogpFVBZ4cy1YdLZOPNeisFm7Uqilzab?=
 =?us-ascii?Q?Wxz/2lgUZ3dl9kFK5KszW0jdXyIu8EGFK6rpvsckj/OyyHQmkEbhAjdVhDuQ?=
 =?us-ascii?Q?5Y2Di0OG5MHc9hJY0B/LbsZKeKUgenUS6q6lg9rVLZi1krufYnxbQUxKaZo+?=
 =?us-ascii?Q?zGNp38ROpTk2V/Yc4e24QI+QFPNgeOU+wSknJlVCPKn1JC2D6p+gYYF1pBlS?=
 =?us-ascii?Q?bPbkkB/yyBeixyn0yULEwp3an9CHo0pule3xk8/C4t4f4pCyPOJNm+QLtNrL?=
 =?us-ascii?Q?u1yOp0SSFA6x4tRbe/cBF16+Jm8xN4JtC4MPn6y4sPU7ht3PSDt/GM071odR?=
 =?us-ascii?Q?bTuCmTLuYLpQw7tzSLlLhYRV06AZ4p7l9podELnKxc/XGFZJDW6uAXXNGamV?=
 =?us-ascii?Q?XDDsfhN+4iTo8hfpcxslvLGDipQKdfU8BTWUkuUSMJeh4W8y9+LCSSE0dLb9?=
 =?us-ascii?Q?9JjSovzIFbsYeBT/kWbAzg8r7O1WEXrXfgc5JCgS/2tJholb/T/YGmpYYui0?=
 =?us-ascii?Q?hque0gt8Te2l+1PX+8pXRQbxC2GKp8XIj+SAcuDvxrUL3kb1PRyI8uPMbNGs?=
 =?us-ascii?Q?8GkxE1tsJ9Y5j2Ttu4UVACQILTxHWbHToxigf/Rp4O4qP4JKjyKag9gg5EdR?=
 =?us-ascii?Q?lwzBcD4f3EIQ/Jl1fp7Cqlj5NjplKuzLmgNSXSf1CN+kGjerR/13pFB/cXpF?=
 =?us-ascii?Q?sOoCGWvSgIOYjIPw8U28o7dibq9EC64XU38FgSvlTZAw/BwZrV5OqF3mX8tZ?=
 =?us-ascii?Q?Ega4rVJjzMwM0mTjLCoYY9r6VqvxiFfePTMKzZ5VJ4ahOxeswtJKQpZ/L96Y?=
 =?us-ascii?Q?f22n7PAV2aB4x/mhYH1MmwHW2L2bsxkpybAPtbYWH4CkIhWNM0TWqjKh2u6a?=
 =?us-ascii?Q?Rn/58Uc+VBpibsIbSCvoocfXDSYMcRrNgwoO3WRUFKmUfuC6D5b89xO2Fv23?=
 =?us-ascii?Q?23XlE5e5A77fccvjvlvwxoWj3+KMHEVKMLCBTY3Tzadeyoq4+gr7xbcv72J/?=
 =?us-ascii?Q?gmp6DWx9X3C/p2NyeceSbPuAmKv9rcSMv0BANMyGm63qYDGkarPqUGaKJHsa?=
 =?us-ascii?Q?1swEFINasWnMjPo06khobBuhwNd915vucwgYgnQijaxEW8ntveZJ93sha+p5?=
 =?us-ascii?Q?sLbK5LpuagIRVJU9ayMUrDGkZX6TbZjLm53R+Ce9GD7E/FtARE3V8R6Qxlgm?=
 =?us-ascii?Q?rAOK4a4d8zdQv4Z54w61LaWtAHW+kW0lgNnClcelmfuWXQH34eXO8t5V/hOi?=
 =?us-ascii?Q?S1Z4OIITA/cCzScOb838eqtqJasftWIyV2NhW0ZOaSXhvL+hmaLZWkIyjq+Z?=
 =?us-ascii?Q?Ic38+EW0n9Y4Fkg5zZYwemCTOSr1SvQO1rmS6hL63han/reWfANSnndyKhSI?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac87ed30-d467-4368-23ab-08da978c63c9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 02:37:25.3875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1F25pt0VatS1gGotpIJLXsFhybwNo8kAGgbHOOIT+aCLuvkuh9tEyL5iXbiLFRoCl7hpby8BOWFm1MKvTAD96RB2nc3DBR65r4IWMnx+kCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4554
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_10,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxlogscore=940 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209160017
X-Proofpoint-ORIG-GUID: 5XvOdN5etYYzrgq_QeojJz9bqRn6dtZe
X-Proofpoint-GUID: 5XvOdN5etYYzrgq_QeojJz9bqRn6dtZe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> dev_loss_tmo is an unsigned value. Using "%d" as output format causes
> irritating negative values to be shown in sysfs.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
