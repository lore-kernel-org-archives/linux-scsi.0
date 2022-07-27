Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021A0C19F28
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 02:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240051AbiG0CIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 22:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiG0CIJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 22:08:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15AC3C161;
        Tue, 26 Jul 2022 19:08:08 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QKn2nh029968;
        Wed, 27 Jul 2022 02:08:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=5j73nKiY5Hswiw9kUL+EyGtLXMRW5pdZx6pjYTnu7Ws=;
 b=HwaQroi1r90Od9uBt3CsnOx/wbhqj1XZUZwC0YEO2gSdJx95Q5WVNwmiUJMeDm92x195
 gbHoXE6kjZCmLBIxL4iy4f+bRP3MTbUsRnNGiuPjn261jAO9hsJLnZ76nbHpyTLh9MGy
 T+zzTMxGCqc15G99fM0E8zTK7T2L2du0M13Bvmtn3bk0Q/fThx4NrflTi3t52O+S/tqr
 xUA/caCTxh9egL8QDrcsSQokLRA3P/c0qJ2HiwkTqp8CQEqJZPOHFR2vV5iqnNcVs9sH
 igjFv/0wTRfLPT0XYmBYfUel16xoEYKyQP4m/tt9S5CDiOYfaS2th/0oUNMfZNEVKqS6 8A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9hsr8s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 02:08:08 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26R1pqf2006240;
        Wed, 27 Jul 2022 02:08:07 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hh65c9etw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 02:08:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjCzOiEtoM8E+/bFe7v7pBeS0R/zc2dzVdMl67/FVakep1dekXKu+MpEprU9aNeramTmMDJDm/YDm6VuvwqFD+aRmeSjdC4HSVZLS1w0TU+igoyRzCrs0o9yWG8oWYZXKeFDStTriOfBocUsjv59PVzSPaajiMmRw3O1+A8g2Xz5X7NiTRwvrDC+F1YqN2DA6ZAxD6ooxIWwjl72VcyZ8LdaOgdGxfDoV6QMOVNOjjkboQeOBw/+tP75JJAB0RuAs35Rscx20QppPHxKxthj3s0+tyw8X7MMp8Ba9I7Un34JSz6bHjl5QsuS6levsEI8CguBgY8AUgHZcXaPQxyCSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5j73nKiY5Hswiw9kUL+EyGtLXMRW5pdZx6pjYTnu7Ws=;
 b=PxxHXdaixyEu/+NLV13xdxoSG4zQ9WnNUysUEd9ZbcoWEy0Ipe8fH2Dscn33DE6Md6CXluI33So9oVXYakj2zqiGKukLpRlp0sM7+VLfiA46BnfOnqsAbIo4QZIFeXeOr9uyULYbcQ6WPrtuF01X1RRrGDbXzjnBXK7O96FoxmKYN41uSDIxOvipn4I0dcwwJQMh3Mq3tiNXGmovtRmApfNZiwEXaEYa57vJ0Qui5VmZf7iO6d6mDZtOpimD5ARaQ430WzbNetLZhREGcatyApw+ELhd5qXEnqulx5vRtMaldslXUN84IGl5/MlAH0CmeoH+f7C1Z6vPPdcBQTyCuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5j73nKiY5Hswiw9kUL+EyGtLXMRW5pdZx6pjYTnu7Ws=;
 b=lrY0DHWJQ9ehi467Xv0JMFV/ikxee40fwWNWrXfLQw4AxEm7SWO3yVGjW0chb+lTZGLZ/zDNumVYODbkZv4aa6cBLOdpKNULrOv3A9tRUFWTXkhJkv3BXpHS8vvexCzmDjWNDl69yoGBUNLitF53I8H19eJYkRFxtAOgS3ccqNM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5064.namprd10.prod.outlook.com (2603:10b6:408:114::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 02:08:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 02:08:05 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH 0/4] Improve iSCSI target code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8rjcnph.fsf@ca-mkp.ca.oracle.com>
References: <20220718152555.17084-1-d.bogdanov@yadro.com>
Date:   Tue, 26 Jul 2022 22:08:02 -0400
In-Reply-To: <20220718152555.17084-1-d.bogdanov@yadro.com> (Dmitry Bogdanov's
        message of "Mon, 18 Jul 2022 18:25:51 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0121.namprd11.prod.outlook.com
 (2603:10b6:806:131::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c663eaa3-97b7-43c7-ec51-08da6f74d7eb
X-MS-TrafficTypeDiagnostic: BN0PR10MB5064:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wt2IdEKc7qrxm8OUfVVtx3l1NywABxR7vyX2b2D+Ncrvhtw2CyoQMYrstsqzO00tR9Gb6n2I0H4e6eYXcMhR8SpNWQuJoUxTopBBzwTgcya7PJOton3H8nf/Z8ksjHvQPlN6MkALouuxyp2LQF2nonqJ/EbTuB6kXFAqydGdAn+BVg7w9Lt8ofTf9f1Y8poqMpMcZg8svCf9z3TWz1n0heJFlW8bi0C+jjmmCsrqr4HEVK7bCiv6Im2ycSgEJMUaZ4nUW7iDy8MKvz1LULsbaxt5nhED1cPEFJOrVSSYcPIuDx9bTdfthToO0ufGOuzqO45ZvTpZzaS3o0I2lVFXkIzPhivYkFisYbN6eLhUWm6IKnUsH/9h8tJ9Q1AL/ERMsl/kMrRhXowmlvjzP1H/915/NrCA60XgIgfEgqbpnbkUn8B/ooE2el9NzFROYEbUTwjxrYMy5Ap8YnmPy04N7G9V7lEjR4ukhBU+69bk8FS57ohSbjbfhRMbnAHP5VXOon90VCzBKi21diNvmQkKqg4yG86xDduVYhAOfBZp6NZjwCDdaD389pTAi2Xa9yJ8Dlg/29J952AdewdIjqHIoiaCExWUvkzZmuOR+EXWa8Irqlq71/J86l7mAPk7TuZlRwEHIDdU7nK3oTfw66hFtEtFG+WvCJA+XpZmdtw0X4GlZvUXCMSjYmCzP2P5Ou+o2EmSCdAoRG2wKBjFN3YyVkiOtadTDNAuqHvUh18uocqA57ZD6iTjZJjB4AEnH75fc99JZgq5negdifI38fCsg3Uj2uqPSOl73tEAei6T18U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(396003)(366004)(346002)(136003)(38350700002)(38100700002)(8936002)(66556008)(5660300002)(66476007)(36916002)(186003)(66946007)(8676002)(2906002)(41300700001)(52116002)(478600001)(558084003)(6486002)(316002)(26005)(54906003)(4326008)(6512007)(6506007)(6666004)(86362001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FfQMZZwfUZdHyr4A6z6UP+hLCT8NIKs+DAiIGwDzkXbkPd2n0FvAmtnzc+yp?=
 =?us-ascii?Q?swpQIJ9/sQ4Fxvp9oMzN9fFDGQMv0yyr8BcHsZqzN/cyYchOqeUeqv3hwGab?=
 =?us-ascii?Q?UYzElpOQT50niZTaX4XCQ+ZV8FN46GYBL+IXhrRBJfQlrLgRf2beF0ywCQk/?=
 =?us-ascii?Q?hL1ou4ldMgAnThDm/6yTW59+Ag8V81MSuR2MQ/s0c2UQg0olN45lvCKlKtde?=
 =?us-ascii?Q?ZGGlbkOOYsGNaEfTg3x8aIgp8/kKxc5wzhVkYgyn/HJo3hN4H6xiuf7jQbSE?=
 =?us-ascii?Q?GPT3cnK2n//K1Z2D5b5DRChdRMRbVtB1oTti0Fvxr/SRsU9CFwf3HsM3y7Tq?=
 =?us-ascii?Q?XGd+tWm5liVLpHVaiAGsz9wieksKkaUFtDcXICFm8q/bNFGg46pBnkCptYop?=
 =?us-ascii?Q?a5ZPxaj40UPQdKqbNH2ZGSQ33CVcZwEsGPSkO/aaEPCP837IytLLx96YCZF0?=
 =?us-ascii?Q?Zr17vBK8UDHPJ+7rZ4OjCRalgKci8AOSjK2QZF1LiB9Zn9qH54oXvXFiqbk7?=
 =?us-ascii?Q?/fw66ssrGczl7pqplWIoIpY4jqLI57U447COptpO+65QRnJJSICL2KyB2TQp?=
 =?us-ascii?Q?6Oy43xwGJfJW2xiTw6NTaYpDlo6ttvIJexi8HPSvWo2hi+A+SEhcMbPi+1CJ?=
 =?us-ascii?Q?8i+YCATcVZHsJNgHcpMHKxas8kpVuyZxw/IOqBTWZHMp8TQ+q20XIdd/s3Kw?=
 =?us-ascii?Q?czOiTQA7kQZHC9Vi+MnNnK1cOh+BzkA5IYArvn57wOXuYoIiqZRrKI812jub?=
 =?us-ascii?Q?eYcGJS1ZZviiyY4LgqNwFkyuKbDyt5rqF2lzTyu+tu97FkmLGGX++X81Z7Qk?=
 =?us-ascii?Q?FRTuMI/gUPzHPZjkNv96b25fjTpbjx6e4iZ5NKGitb6LVwfJHlxaZ2ti7Uws?=
 =?us-ascii?Q?5w/DTbk/LOTajXcNIE03iYwUEQ/+lNN7WB6qvbSn3Nqrmw3VC15g57XGclEX?=
 =?us-ascii?Q?JLpzFrYIMUzJ8UtytyMZSN27GgwB2sAyi1DkIAU955Aq2uhqfG7Hi7JJhmFj?=
 =?us-ascii?Q?GGyLGXl48Y8BrSc8TmQZt1NLBJy7XV13sBoIyE/pOszzdyRvdGq421u9POBl?=
 =?us-ascii?Q?Ee8wMromSH0XhqFPBvD6cP2jaTpmDTZfgfiiOV7NuaMYiu4vLfMAuBCnDo+j?=
 =?us-ascii?Q?Fwz63btomafPZw8lvL44BzA+c2h9E2X+R69Fz4ygRPpU+yFiKaBp8otwYlwo?=
 =?us-ascii?Q?TFTpyDfvIBSjRIbRBvElHE4szW9ivVkaCePSkWHBw7wG9I6kaae5mdjhRNhV?=
 =?us-ascii?Q?dM3wUMRjNiEs+PL0Dr105Pt+NVSmGqa0EdWPD9hYP1BkHMkqOclyf5ySEumy?=
 =?us-ascii?Q?QalRTlieMdqrVKhvzIKTn2pmUKw7GY1UMXlI1MwJOJdwEaRrW+IyIQcZIztb?=
 =?us-ascii?Q?B2D5IAGgkpa69YrM/C0rfWr21pE72/0qbLmYjsYR5lyyiuvny0n/GOwc0UDe?=
 =?us-ascii?Q?0M7LqQjVmyNaiP2rAuBsu1+dPQipn3kzaKTTzy2FrfglbB6CgY4mAreeb3dx?=
 =?us-ascii?Q?GWFuBEngQiqVwuvjDlaT/e58TqoWBAee5zjgoELdJABfxqb+zoydwVGVOPRC?=
 =?us-ascii?Q?Oa0w6dU22zknsBcJyZRGwzqNQKqm+FAilGh0sCP4wg2o9vQoSC3Y13GBqSP0?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c663eaa3-97b7-43c7-ec51-08da6f74d7eb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 02:08:05.7204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c2ocrgQ0a9jO3L2LAz+W2/z5DdC8P3CX5OsIBu4IKWW4qRY+04cmyFjgXHGxYKKUIa79Sjn3uTVH8FuHN36f+nQ6EUEQNscLq5MLcgUb920=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5064
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=680 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207270005
X-Proofpoint-ORIG-GUID: 7q6hwfMlByCMYJa4o07BTDv_vrCovWUZ
X-Proofpoint-GUID: 7q6hwfMlByCMYJa4o07BTDv_vrCovWUZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> This patchset adds few improvements of iSCSI target that mostly
> required by tests in Window HLK.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
