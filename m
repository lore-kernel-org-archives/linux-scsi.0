Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B175CC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:16:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9568661178
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbhHXDQp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:16:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:19550 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233797AbhHXDQi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:16:38 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0x9Yi013533;
        Tue, 24 Aug 2021 03:15:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ypMhE1LX6Nc7UVDZOCloGhLfc6eo+d37q7eDeE+nG5s=;
 b=xEZrKXW0/zesUNx/6TydqEiqWM6gcwufqzk3hTG8eiSD3RZiCwO2CAe4k2vfZwpamPkb
 F5K54Cpw+1RhI7kRBKU7I3i9n9u+QhA9xAe/cvAZRw9byLJyP5RpagDHQKiBio+wwnxB
 lZaH7mABDPkX8qVrr2bM8V5UsZSgwbqMrq9oqsXowMusWpukRN1aMTZn9q2s478JS4bv
 JBOVCbjDz2N9EZWe06b9xtKQzyQmc2sBGkIsVXCWq0tAhS4dRVP/hfkwE9O55vJCuh6D
 aOT1DkBvFhnsa3fsjFu2pbLPSTKaKMCpMHyXsbseCYDxGgJ4apiaUaGZT2YcBCU6+X/R AA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ypMhE1LX6Nc7UVDZOCloGhLfc6eo+d37q7eDeE+nG5s=;
 b=wR+uUE3H1cBptoM/N27ZyIm5y1maZpsonkU/X3MF3E9hoiwsOpP0CcAj1xuOXSJ8W9aI
 8EMnHA1R2sr2qaycGCzRjcGuv2JFfsyaIPB2H+sgzPGesPvnw2kIMDJMLRaGV5gWk82o
 px+j/XyKj+UGQjJm83LNsL06d5yd71S62pcEy1EPNQfSX5RTvomqEZBuc51UqTa8Go/9
 VDOkYrNJRfOfaU38oEGAER8QcZV0X+wXTgScjP89S5+veMOWsL0nCvmQzenRzn08JOpC
 nUpeGlLldvcdQG9zFH4XUSAu8CcNY6Y7vBmH1fgMAC11HWye+cNjgxIf56c5pYoEY9lw mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akxreb1cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:15:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O3BUb9145426;
        Tue, 24 Aug 2021 03:15:50 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3030.oracle.com with ESMTP id 3ajpkwem5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:15:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BkHa/3D/eL8Y5RFgRLT38Sm0AMH+qkk8KD71CR39VZbTdvPTWl/VN2AIPbwwqdO7Vf2F/PvL/gbDfNj4bpJ5pjBPO2BTOEiyvG/cbNGTbIfmjO3YXQ67od1pMM5P1sDjnW0BwA2/ScdRe/JD0A1QUKNFlHHzrHhmDjK4OYcVQswewBO0XBLlVN4r1Y5xq+bF3189kyLLczSC8q7Tpe2u2+X08ZVnSL3TBWaDkGKANZo4Y5yOfDlb+wHB45J+mDIoQaV3zY17U6SSl37Boj/66WvOuUty33dF1zuguf6IvjOmfTeKRgyCi9iNV29emLPwIjmltGiSw4bvqcAU5whk8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypMhE1LX6Nc7UVDZOCloGhLfc6eo+d37q7eDeE+nG5s=;
 b=CAysbd9pxpDxdppKtNvzi1ysWmnFl3IFo5U4Wt+Q2/akVLZxvbumZClehS99AkRhmxYKqwESMfq+ZOcmvdtrOdgo+XXAjCcOZWVYC7VbsgnxTOV7EIl8f90YFFJ4YR5EcniJ5PLV754rgRGzdtwX57ZO4HAcXKOCh1W5dBHNyOT3vi2plcYxRQI94JbBEfm6FosafrUq+1502NvJlv3ChbWv5RX43GF5NM7ZN/jMXnib6vUOCk+uxz5EV0oD/3CmPKk5B2HOmR1Jie/tk55s5akvHHpKEUXwUacIOwxzSwQSd8MyFLCDTh2/zwpVKR+2odOswhxR1bG5tZ9olkP74Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypMhE1LX6Nc7UVDZOCloGhLfc6eo+d37q7eDeE+nG5s=;
 b=QynAuK+7l9vUJPEpLgFHJsaHYiOA1arpylJUpweOmqF9UpyfDi+G4z2nqzncgSW0PUsPmV/JqTvaRYDm6r+qeinm4RyFNxPrfrztUGBK2AGKIOXmyr4gym8vkoO7lTXTBmbf8BnHZ7lcU+F7YSPT5fzJ+GL0UE6jKFiIZpBWHxw=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4485.namprd10.prod.outlook.com (2603:10b6:510:41::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 03:15:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 03:15:47 +0000
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        krzysztof.kozlowski@canonical.com,
        linux-samsung-soc@vger.kernel.org, avri.altman@wdc.com,
        kwmad.kim@samsung.com, dan.carpenter@oracle.com
Subject: Re: [PATCH] scsi: ufs: ufs-exynos: Fix static checker warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6l7fs87.fsf@ca-mkp.ca.oracle.com>
References: <CGME20210819170304epcas5p211ae01fc6ba6f5beaf7afaa90dcd5dda@epcas5p2.samsung.com>
        <20210819171131.55912-1-alim.akhtar@samsung.com>
Date:   Mon, 23 Aug 2021 23:15:44 -0400
In-Reply-To: <20210819171131.55912-1-alim.akhtar@samsung.com> (Alim Akhtar's
        message of "Thu, 19 Aug 2021 22:41:31 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0065.namprd12.prod.outlook.com
 (2603:10b6:802:20::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN1PR12CA0065.namprd12.prod.outlook.com (2603:10b6:802:20::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 03:15:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7ce36cf-4ebf-43c6-0ed0-08d966ad77b1
X-MS-TrafficTypeDiagnostic: PH0PR10MB4485:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44854140C3A43D2F77D55D408EC59@PH0PR10MB4485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GP8qV41ZlRj7MpMsBZV2TXFRXTx9gxBA0Yy0al6CDwxLmRJzzIXyV2b0l5M62XVPDmTR4ouVVjJKzO+eXDUpl19juuxDh9/l4ogY6IlS3b+sVWpsZqUq9q7NgU6T6DQrWcQ9biHGkE0Lmgg+OfeCFp+hrT61eNFtAZRNN1U1v5/erh1iceNlUUoBLC9Se87KCk3lkP62PG3d8X/uWF7TdeP9Mdt7aCYRsOGYV71DxADtQcAWPULKlRY9idn7FSiJCRKNsTb6QydHXUevpRQksB6N94H5nqyBPoeV+89FfRyQHcD4V1fm1EgvqwgQhVFs+jUhjvxv51H59blmQ33B1TerCTyxLcQxZtAz2k54mg8V6I2l/FR5AcYmoFNlYLruQ+zmZQlBHibMT9Ff0XbIdO3POBjUNI91b6QmtgmWcdaoySDl5BKyT5kk1z3K2pMj3Tb1X09iKa71pzo0SwmoW4hk0jctEULr/NdxsO2ZaEYya7+3h9+JjgpIfRGk+/nVxq4tDNGg1kXFcp10dkFKRXf21H8dX8fzJ1GX2jDmSx487JJJw8vI+ucZyg6Hr2YuEO4peThojcy9cE0K2t7QMCrfuiXtejR8X18nycaUw1WTHTyfKUSXu27s9qZW2oPOT4zrkZcpUqvmvVcJMkh89kqQbNtSnigsCfRCbgzM+QlKHxD77dlsfMQWQ9tPXPGZRP9LBM0TmwM5TbZycTB4Hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(366004)(39860400002)(346002)(38100700002)(38350700002)(52116002)(7696005)(86362001)(4326008)(558084003)(6916009)(5660300002)(83380400001)(8936002)(107886003)(2906002)(36916002)(55016002)(478600001)(956004)(26005)(8676002)(66946007)(66476007)(66556008)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VfNzr1Fz/VLWNCPYkbwu2RDX3lB4Y/pDa3+ReV1Z3JxoNMQuDpnxmq/6qezj?=
 =?us-ascii?Q?bx9CQtkqbvoa5O9r58etngo3B+WE5HNVMymdp0YJa3n9miXYPyRaPUAr+5vq?=
 =?us-ascii?Q?BVhdTPcgdkl3k4jFlbnjNycww0rK+OMFM8isXayx8KK6LQxy+aEMkinI4kt3?=
 =?us-ascii?Q?M4IkxGF6VsKGyWabjwIysAUvy+TXcJ7hVRK8e5/zSWbohy6/DhQn4XLSDc7Z?=
 =?us-ascii?Q?cOTkP5jmiOWjB+xPS2BVnN/GPu1SS87ASrsQVYIUEzQqEdvg3wHO71t78mBm?=
 =?us-ascii?Q?VMql82ZAB2gIVZKLGDp9XxLc0Eq9c6Wj13wpx+fOSOQ0Ft47Gcb9uvKc7wNV?=
 =?us-ascii?Q?Mt4Fc1vCMdYnkmY8/ienoOEzOHgikkUmHj5dRK0HD8r6E0/a5+Cz6ZOpM0jY?=
 =?us-ascii?Q?Q6nQb1A2ZyJ0Wz2gInjVRJriPRplYIJHTdRwxiwvLJdKlhIhv5ohEJt9ZhDi?=
 =?us-ascii?Q?Wq0nEENCXJfRJUCclmHvnUri8m1oCIQnRYOAF8bTH5VdaFoLOv/a2eOix6Dl?=
 =?us-ascii?Q?eyIRfOAUQYN4ESDdpmzWE82fgliBtJwZYTzq/nNRamac7pXh0lH4oQ6FI16O?=
 =?us-ascii?Q?vyiAIDtxHYRthMxpCvfSho9j3dbb5SbRkkHoR2Lepkd51ajfpGhBDJSf/GsR?=
 =?us-ascii?Q?ZFE3ybyrQZb6KewWiSukMJjBvAhiBWaymNyq7mFtPi/ZdhtZs2uraZ1S0z8w?=
 =?us-ascii?Q?WWAvnVdS2Qi1Rxll4mSB9vsfU5su9HzybD1NkEJi18fwf9xkub7n6XTNRaT0?=
 =?us-ascii?Q?YtSbeZxau5hB83GSP0tqeAQ4xAMGrDfuVDQihaRMiHz3fl50Rg/B4Gfnmua8?=
 =?us-ascii?Q?DgbRKaj+xuYpc5LHegRsmDUY40kZlbyN8X9JSw68aSxNivr2aDkyOhKplWBV?=
 =?us-ascii?Q?mPM/LW6GWAHxxzAgpi649YkCPppUt2u9AtSgmyNjbVr7BMP+loLRtZHLUgCu?=
 =?us-ascii?Q?Nbgyk86qZGaGV2zg08uR92lWS8K3g/saA6r8bSOh0PCopp4dmDukk050nV69?=
 =?us-ascii?Q?0/rytsG2GoRvm7zct7Osdo5eTbA+yA3oWsBI4ZJuqeQGgA281Ozrfvdy8P+z?=
 =?us-ascii?Q?BxCcV5Tq/un/ZfmC4141b+RwO2myCXbgXPD3qaqPRJ9P8tVYaDrYz7MKa8VQ?=
 =?us-ascii?Q?+MOOcLVe0CJ5ByHp//ojYv6fkvj4IOFSL/M+gAyOmBp/P6OgiIhWVTtGyfGj?=
 =?us-ascii?Q?cHt2PygEBcREK5uiaz/+x90ebbnJMy10FoqD9xPTm/+PWoOsqblPPqI/wLGZ?=
 =?us-ascii?Q?xc2AGzvRqTas+/aP5HCP5Z4SXx1PuigdhpnGsQwUpXxlxHPaIjzsEwnsIoE1?=
 =?us-ascii?Q?sJUSmqdfaRUXpivr96XxW5or?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7ce36cf-4ebf-43c6-0ed0-08d966ad77b1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 03:15:47.4119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2MH+WnkupvPI3qq+3lxwU2GB5X3pfMwB57lKTG771CmiLgQY17VG2wz7TmYPfXIsSSBdl5AJL4LkMXAbLzYbMHFJMajYOY1Z1DeqQN3m8D0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4485
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=938 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240019
X-Proofpoint-ORIG-GUID: 0isoYiJ9VrFr_mm7z6tcLqnK9Ls1toK5
X-Proofpoint-GUID: 0isoYiJ9VrFr_mm7z6tcLqnK9Ls1toK5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alim,

> clk_get_rate() returns unsigned long and currently this driver
> stores the return value in u32 type, resulting the below warning:

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
