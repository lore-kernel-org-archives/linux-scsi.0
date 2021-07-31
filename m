Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A38FC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 03:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 359D860FE7
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Jul 2021 03:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhGaDrt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jul 2021 23:47:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52160 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231487AbhGaDrr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jul 2021 23:47:47 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16V3lfVj026008;
        Sat, 31 Jul 2021 03:47:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=VMXlG/x8lWUKpsO+51ULn9PdBDI4sMPukxJ+SYIbz4Y=;
 b=iuHsErzkxL5MbxNp2VvaaGyqefrMavwDWLNge1NqVGBLVFXHiHsSxuHsmkwrV9lLzY08
 IPyIQFNSVRvkZ6yBPr4EE8WIH2SuY4OfrCMOgNN/XWo1s7wvAG4QvvnvbFBmZWjpWAng
 JUPWOG9V67eZkdSMLOMAsSkEZDIWoqrLu0kTIDRbT8cZqrNnYQL/9FkWnNJCtmhtK47I
 2JCNY7ySOT7t7kxDol1+WR5VCQL1W9+wsTmiyugLrEVRXSPEiAckuoa3GHbNu++i6kTH
 0J3TGTo8fjvLtPoKWTwklqKTFaV7ajZgpKWI/f77JSK42ddR2bNbXI2pkiIqu7eRTsgc Qg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=VMXlG/x8lWUKpsO+51ULn9PdBDI4sMPukxJ+SYIbz4Y=;
 b=C0d/etKlQqykwX4TmlThpUQF0V4YtmdpYLVJpM4f+R4+Aw8pgCGLAO9sRRDVuTfUb2KR
 ihbwuE0uDDTEcQebxPIfAnbh2yRpzUv0XuVDpsS/H9Tk1uGB6q4FzT/a+ie9pvL4qBgu
 eBBdte5vcaYvM4Ypu9soWrVaP5zUminVwVijGYZnV/ybrR2rEOW+POU3qKcIms5jfib6
 za7ptHN/iLVvJgPvVYw5ULP6Ql8Dqm0ZsaR0eO9YmdWlqXqunfI2g1gNbhMrnTBlymkg
 9OqMV462nPVrJChgs4m4YUdj50bHKS8OrjHac0t//QAhzxFuZPg6Bd65ZEO30TJYQVpc 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a4x4s00w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Jul 2021 03:47:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16V3ZfrD188332;
        Sat, 31 Jul 2021 03:47:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3020.oracle.com with ESMTP id 3a4xb1s3nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Jul 2021 03:47:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lufp1mb/bkVMHkfQVbqeLqk+AAy/5m3Pmi7WhuJBB+Tl1jDu8OzNZd7FA+8O/gbKNrBOfQNfBIkMbFZv9O40HDM1djh3dR6u4QNTxMYVVN1qyUD4eF+XX+nlVO0o0agUN0VzRfLJdvvdtkLOa1YoLXa9PnetJEmgtKmdj/3dVk7kyn0zelM+Qx79uSmwJ5dzinVxeDdytnKuQIppwLvrqKwp+HNs0QNM0U5h6IONYyLEMFnFBCoSKf1F/CN/QZRLyYxl/TWIp2HRdKJbuo40puhK3VnVZnczd3CyV8dpIGDnCGu10dwdL6k+88HIXVikYe4vefQb8M9YXLeT/0/1BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMXlG/x8lWUKpsO+51ULn9PdBDI4sMPukxJ+SYIbz4Y=;
 b=m6W92QmMFJ4Qt4iMP5VHShS5yQjZwgbaL5ouZ+ns4zLMRXU4tmrM5GviDANg5z7WQ8df0Rkr4UGuyk3XMOjJYz91xGzvf8uwIqrRo7hkC3/bqOO60stGIumcSAikTpcaiIjAPGRb2CUjloo4gsReHi0TA6Vgu2tH2FiCvLxs1lXpcBcV9iUN0HIEne9RMsc5xU07osMPkEmmP59vfN+7PG/xvYLT27WT4v/A+UgfpMbfY4QnvbFfjAdXoNOP7AlUqhyq/oLYzXD5NACyix/mXTiMeJ3zxKfo0mE+303esPKBbctBqi0DkTFJr92/riq3HUmL5g3Q3e7zDBoVGgZtYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMXlG/x8lWUKpsO+51ULn9PdBDI4sMPukxJ+SYIbz4Y=;
 b=f7HbKLgg7aYqVE9Rx/FgNrbiNeD3vCaRgk+XA+azFDZpLpMt5dldzfTwxfKb7z+8Wnvb56W+ZdC8FYwpoBdGJMi6XVEvwVAeOAP4m7sF1rfRn6t1K4bg0bK5ctPZc5+2iFzC2NZdpiWR1aoh9AOR4YWXMN+gzqIFVR+xANYIZJw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4503.namprd10.prod.outlook.com (2603:10b6:510:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Sat, 31 Jul
 2021 03:47:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Sat, 31 Jul 2021
 03:47:39 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: Re: [PATCH] lpfc: fix possible ABBA deadlock in nvmet_xri_aborted
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czqzm9f5.fsf@ca-mkp.ca.oracle.com>
References: <20210730163309.25809-1-jsmart2021@gmail.com>
Date:   Fri, 30 Jul 2021 23:47:36 -0400
In-Reply-To: <20210730163309.25809-1-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 30 Jul 2021 09:33:09 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0049.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0049.namprd05.prod.outlook.com (2603:10b6:a03:33f::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.8 via Frontend Transport; Sat, 31 Jul 2021 03:47:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06887e53-8bf8-44fa-41dd-08d953d5f134
X-MS-TrafficTypeDiagnostic: PH0PR10MB4503:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4503F905CA21A1AB6D68A1DD8EED9@PH0PR10MB4503.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wzZBCSE8WYvRfmgBIMJLE8P5VS3QIgr7VuOtyIHsaIlyDAahWQbQwIpm1/Kzhg5be3FmPwj9c8QFcy9GJWqwZLMgCguLQ+fAlG12iVUaCGgWDxZeS5lltLFJzypAg8c7tacaCnc99jf9NsL02NMRIaNBTT2NjmN9/+XEftbM8YohaNa/OQdDQrwy+iWe2PFfR4thRgX6T7p5KSwi2ECsYaGzcve98nhl20SZlX7ycdV+DV4NCk+OxzseMgjvKRU7d7Nay/Zk7QENIRM24Ge7d3QEAFEOGfwrFiBJg8Rtrq8tybNJlx7XxDoA84Kl4x5ovNok+3TwNsLwliJtCf+FwsQpdS/L4AiX3zLL6hfTf2STgB6kXW6DXGQxeftja1x23fHQs32QAnjYV25n+v+Sti/HfA1YcUpz96UhTSIErW0bq3BPHlKHKkMJyPF2YciejZg+3sVm1bNdSXOT6YI+eqCuJcxhzdP/Ayo2tRV2CCYKBL0bpPRhVTKL5/5yjN0U7Uzp07BJetl22FuINn/DdT9K/KUAYsFpV0KBQax65Oo70nt1bxdMfbDBRVgnzlxVJTe4HzKG0cj45VOCJxVcNqHnT84I8OvGG7LEtvq+Mrl5XAbrU7GwLkGsG4SOriGuumb+yMZeRVKE6lmSbpwHBrjtUbaIdpqIdWbfOfZOJjG8+jyQUAEYPzHEdrFJecklnY75gko3XEte3/c3A09lag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(55016002)(52116002)(508600001)(7696005)(4326008)(186003)(86362001)(2906002)(956004)(26005)(5660300002)(36916002)(8936002)(66476007)(316002)(66556008)(66946007)(6916009)(8676002)(38100700002)(38350700002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BMnX6SLcSd5cKA5zT5iEgwUdiX6bugcc50u0Na8rs5jgqVmGZgFWCll7+NJo?=
 =?us-ascii?Q?TP/rOH/Ale4IoG7/zYA/G21hKzvBrKjnB4MYH2tL+8qwQlx6bEbjUdoYJpIK?=
 =?us-ascii?Q?f9ZRF5M+ruGn/gfr49KMevxDjpcEU5zXP7C0OwYMRBbrATsHvkyZOGJoedbF?=
 =?us-ascii?Q?292+7hJjUShn0TmzBEKle7ieIVe8lrgtu/ShgDnWJP2ZynfN+yKtlP6KfI2z?=
 =?us-ascii?Q?dm3Xqyb6WlMR2u7uJpnooytzi+/iCimAmXNWWeNuVtkG8k12ne7f3LxcNYZe?=
 =?us-ascii?Q?pt2IgI21Vvj++jozzji8h2O2R5KWCVDKHY/wfvlqRltQ4ZHtUSMaJaVKYB1e?=
 =?us-ascii?Q?ZdIm7jmaA/RePOu/HOu1yb3NSjI+mqTnfgk62isqVdTl4TPeYgTmlS7yk4lF?=
 =?us-ascii?Q?xBwY2hoQQuyBCcpXBR6EI78e/3gDrI+OoIPjqNlyGklzHuM1Xz5m34gpGPx8?=
 =?us-ascii?Q?SnOnjBdp/U/uKqkpaypmaFp3LBeUQOD1bPuI5ZE8h/X7OElhyZBg9j4zzBmR?=
 =?us-ascii?Q?jn5wgNhF0JigvxlHb3vvU3w4MVppkvbsmJRUcIH04jB2brZn/kzYSrgHMxop?=
 =?us-ascii?Q?amyGKZIXuyObOrQLN+0P9q/B6Ib0FzXzFiGfpN7CpeVQe/caYC5Nt/0ug+AV?=
 =?us-ascii?Q?lWKLROoQmcfyikOELVdvIkQ3Z99R+R+ZwLUECD5b2gdKGPQR7XdN502CKTxE?=
 =?us-ascii?Q?Rzm0bQ0Kadz6OEF8b3RykpzYlS5dUZ1bJaRm4fe0XBDXxtswRFoiR2SCPo8k?=
 =?us-ascii?Q?haW93pVFV4n/6d7FljJNOi0QeFvYYcyibmQD53zf9tGKZe7LeJejPV16Hfqa?=
 =?us-ascii?Q?/snQaE2evmMW+NCcvNFuZUrEyA0yAEdqaBwIeEBFflU1nzXwqnrNPQSP6qW8?=
 =?us-ascii?Q?q4UbzNJR4ZTHkPFxTCWjl0DJZ2VyfE4B91cfCScJQbxW0Xjz/+Mh4lDJVxmA?=
 =?us-ascii?Q?v99SGSn6t6BrlWtPxzbZZj/mAy1a1eJKKWBF3nhVM1noRKZqpXAC5CDnMXAM?=
 =?us-ascii?Q?4PIA8FMJDDDm32mKRC5ipdr4J8xem2CXXoyIFLmpbFIw9XjgTAoOVkwxpTcu?=
 =?us-ascii?Q?T8IgLzGfc064OKRn0p5LPnIMTa00PL73QlAzDaV8e4YQtPVID8KTbdSLkSpx?=
 =?us-ascii?Q?Cjq0I6rDfv/4TAMNHE0q5q1qLuUiqEs9LGLzmzCXWXVjikulGlfl5OiJzwgs?=
 =?us-ascii?Q?j8MKClarsqJMzFRCPl9C+0AMJ2HBcHjCk+CSeokYJhTL9700f3jJJ7WmiSnO?=
 =?us-ascii?Q?UDNtvdY1tLdg+KVihKCLJExZ+pXw01+m3dnOewaCt5n2Xed3HhoWnNxyuCh2?=
 =?us-ascii?Q?pRsKZfYzqPKhTDkIFCFMsu/w?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06887e53-8bf8-44fa-41dd-08d953d5f134
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 03:47:39.1052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iZWc7XzQrssiWFsn5vROPvOrTiElLunEcbwxs6dsmtUT3yTtzfUfGNsO5oZFTmCrlOMagrVMy5WqQERHnzRDaCv/fNHma0GJi35/JbgHJ6c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4503
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10061 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107310017
X-Proofpoint-GUID: Q6Lw3jtZYRB_KIgmJNKqOrved2Jm4f6x
X-Proofpoint-ORIG-GUID: Q6Lw3jtZYRB_KIgmJNKqOrved2Jm4f6x
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> The lpfc_sli4_nvmet_xri_aborted routine takes out the abts_buf_list_lock
> and traverses the buffer contexts to match the xri. Upon match, it then
> takes the context lock before potentially removing the context from the
> associated buffer list. This violates the lock hierarchy used elsewhere
> in the driver of locking context, then the abts_buf_list_lock - thus a
> possible deadlock.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
