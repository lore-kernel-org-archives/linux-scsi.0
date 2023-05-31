Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FC9C77B73
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 15:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbjEaPHD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 11:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbjEaPGq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 11:06:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4488FE77
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 08:06:22 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VERRCk020136;
        Wed, 31 May 2023 15:06:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=B2G0FNX70H6SjLRCCfc4jQizheM+SKkkRUgU1JmNqZU=;
 b=mgIJ5H4/sClPuNMCFPjMN9/6q9a9BIv8XZBtLRJHoFo9bLT/sEzXDU7ljfOBlAoY7tIl
 x4mixK6Zfgd+fKNNbAEUl/C3lETM/6haHTSeKcS1qmrL8JONudfLwd9Kn1OsqGCpYcmv
 3sgd3rbfdnqCVP4y/qsN3Prj2iPNjEnqoI9SMWm7sEiAzzcufqYrOrLK7bAF1nXlGAnx
 EO1YiSB58xX0F+LwMTVbRH50CsGm/PbI5kfJv5JsgGObvHrzAS14bLANsa3WMtCWZ0+q
 aJvWbdNkPnLhXmiIzSTKU593zC1r2mcizza3OoHrAUhldYOhtqqXPcu/BfK3E5nPBygy LA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhjh63kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 15:06:16 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VDvCMb000314;
        Wed, 31 May 2023 15:06:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8qa7avw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 15:06:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bF7D7EHrne+JaAD/8Gdrx8CiBEcfoWeydKQQEVhwFhDm25eQtUkfmwiW2bsgywVwiHLcTeWlAsNw+F4r4u8cCyFH2/zxiFSQivyWtPrpVQbmm2ah76H0vqyK8EAFJYshbBxADEdQZaKm02i98ULlkN7gqA3fBYOvAXesgLBfVlq0QMG7LsZDnC7vUMWE6TOvmjPNXxOCEGBLNTBzdHCSp/ZpZCM2IeIai7aDv3+Du1tWuaYzH4pcculQ5oXE3clwwziSVBoI/iBtHfLc46sTQSxfON/7Abmd7Onb3h6x3vpS8C4f23zAUuWksi5OO6Etw6xciWghsLjkdvnwHuHIkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2G0FNX70H6SjLRCCfc4jQizheM+SKkkRUgU1JmNqZU=;
 b=kKcFan+R2+ylFJd6cBy50ymbi19ykQVc3zinzTaMOWZjkveF8MfMksO1YDMzXhuaaf38LNlax2j5CvO1YnlUOcnouuFon7sxXnauSzDQwrH9Lb4XXGN36Z/gaW0WM37AEBmbt4lcerDptMahwX/8DfMmUY0Jwewr3juPkIk5mrGKJcoEBBMznEtyUitB06Wv7wZ3G6Gjt/Z1pUonnc//Vi7l4OpTQtwBwXoJqTGkZWS/blON0DQTvWQjnLPbfnGjcnLVZDlSCLcWmcF+EGzAhH03/mMnWhu1lFysG6baHWZ7xZo2anGHHU/YQokteqtq3D12+CZ9BRggKA5wwvNgcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2G0FNX70H6SjLRCCfc4jQizheM+SKkkRUgU1JmNqZU=;
 b=Vw/qtycBld7QHDWdkVz9efeBnyQ6qMYWSuHLbP8qtY42zSvaNi0iWaXqS1OKjd9aUdEctyfpXKnAAlKK9b2qyhLkEG+IkvjGIvBJSReo/EDZS/v5zw9gKn3DmaECcC4byrEv2jYleVJIcgEIE5H5V/r0KqWPQtOXx1LynPgMajM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB6178.namprd10.prod.outlook.com (2603:10b6:510:1f2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Wed, 31 May
 2023 15:06:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 15:06:13 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 0/3] SCSI core patches
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18rd4h76x.fsf@ca-mkp.ca.oracle.com>
References: <20230518193159.1166304-1-bvanassche@acm.org>
Date:   Wed, 31 May 2023 11:06:07 -0400
In-Reply-To: <20230518193159.1166304-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 18 May 2023 12:31:56 -0700")
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0020.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB6178:EE_
X-MS-Office365-Filtering-Correlation-Id: 87f89edd-88a0-4137-47dd-08db61e8937b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bbU3QYsl5jWMxmCf3vEMpYQ5ZGOmW68njhg2VVk2mqw5Ohz08z6n5KMzFRNOv3JAF6ks+/kKj0Y56aHqmTn8KcMoUBlI5z6ShGE5C4zg/vRDEpyOJg0CmgJPSUduEDKlfwZgWLRrdFlysJV8BrOiDRYSjc+Eek7Nw7OAqg6GzVKUtKueOkbNOxpeNBAVyuFYAho5RLl9wgNuHb/lU5WmzTKKpMMgTBEC33TuzkzMa7P4b9kdPrPQdg/grGrnJMixU7WMpVdFUVq6V/ctApAlTKrRCOYjiQKFFfWhCOpGqPCOXKdNvZmhcxmiY8WPjAM5ltbEIlWzHKFl+OM1Yqt0StMpEpF80AoictTHb2KQdkpJj+1bL4TmrJXSl+HzXuybZn6fMr1LyRhbvaxf37M3fhpszEWW/xV5Veoxi0tCd5yeLbqv9pYsxKJCRNcF8h8KzhIbX7QM7E2HLN9M1L4rR4YVslMUQ27hd+2bOF0cab9RnkLKRMT8hVXKdeJKO51pEHPsxeeUMlVWqt+72As31ySa581QT63Pv9fPUtWZn/97ySq4YQzpeFoUfL3qiINR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199021)(6512007)(6506007)(186003)(2906002)(54906003)(478600001)(26005)(86362001)(36916002)(8676002)(8936002)(66946007)(6486002)(38100700002)(41300700001)(6666004)(66476007)(316002)(5660300002)(558084003)(66556008)(6916009)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dKriOQ6lt2xlmzCC/l3/aFmSSwpALpP6qtziQsITZafYOvAHb9WBiDGPDrgv?=
 =?us-ascii?Q?OiYlHJNw/jdFjmcfr7Fki/LUWftQfelkrgfrheK2w8KQ+RKEqvoeHm/6cnp3?=
 =?us-ascii?Q?s6C5X9SAL46kqjmIKv5Hvp4JphLw466AzsiKdtlgZ7cfLL1RAgfqYpDyTNig?=
 =?us-ascii?Q?D1scil7O86tX+78bHoovimgOB1mKZKbY/n3cThkn9ApobHUDMwhQFKXVpBAt?=
 =?us-ascii?Q?hiWtVhllt6tEfXoysWrAfMMyngqogTWQKmCq/QzCElyGuwmgZW9MuyXW+MJ/?=
 =?us-ascii?Q?8g5vAF0vKHWjXLPOZTt/xU0tDcAnjObDhcW6je2b4UKYnNGM8JiE8gJ8e1vR?=
 =?us-ascii?Q?HLCx6Y3uDTeK/qHkC9lJ/aSvlMdUWoK7ZcTsYQdzvh8ctQ4q2/fQcyYSqrB1?=
 =?us-ascii?Q?0D7ZlPdMOry2v2D8RdCDu1AxmWGaimdRbuqhpQyOxcX+3tUWbudotyy20hDB?=
 =?us-ascii?Q?5rZqy/1ECr/IVlJZl+K/yFGnWBKfHB57RuFm024zF9L6M4vF+K/+JPCj+ACe?=
 =?us-ascii?Q?Yn4F6/N/5LWEQNdj24yR7PPXSk5JTekbSD5IN5OvsWiCbT72QjJEO8ywwdCn?=
 =?us-ascii?Q?EW+1vAYuZTj7xW2AN6TCUvX2MMn/rzCFFmaRG4FpDb9c4Owt6XgCPnr/y6Ef?=
 =?us-ascii?Q?1xPojoRr8BshK7edAdIc8Wkz2ckFEMzgqaIDOCSRr+/BVabYB39To4dCHT/g?=
 =?us-ascii?Q?gtJJFiKsdPMGeLIrC2EZnmCTAbZUoH2GGiUMNTYr1D0U7cQR5UviQdmBlEUJ?=
 =?us-ascii?Q?EpGROiPEzdJ5VrGGEuoxV7k4BEwZsYRXpqIpDyIXKMBHdyBaeH0c99Z/f/9x?=
 =?us-ascii?Q?iXfTq95hgw21xsNO7N6XBDwyOd4q/u7zHY2ZnnXe5s/uELubNuFAA1N4DwYk?=
 =?us-ascii?Q?hJluEUrrZi0JfSYxdQIyhG0Jb5EXHIQezw0T3HmM3yN+rmFixS4CLYUUCR+W?=
 =?us-ascii?Q?0cmq0eZ9ibXDmr9H6D7eeCM1NaW3kcMkaHUHW7Z3Zsmt5QOYu5tfZl7sz9GE?=
 =?us-ascii?Q?uvyR8KrvssAj1O7q/EIjEt4m9PR4yFD7bv+9QxSElBWQAQw3xMEdntRK5ijn?=
 =?us-ascii?Q?kbCjY7Imcpdb3NWhF01wW+FGE+XPQ9NTmIZcqJi6zZLVzTR0RENDUQugLeer?=
 =?us-ascii?Q?gELZfYHc4MHzAl8HuHJ8TMnaLEUCOXz7QCq6yzpB7yR2WVFCPBpGHM61DN6+?=
 =?us-ascii?Q?p2+bMwwyilZ4O5FSHL9/pmqp7us1OCkE0gF48D89os5gcS6I286vvyxsidDI?=
 =?us-ascii?Q?s+jKyaEPDpEhSXBTthd2deOY0UUYaE2BYj+zoytcoITPDfXWjzvUfhzmBa3v?=
 =?us-ascii?Q?JUf735Jiz4a6LFf2gdsGKisPEwucg1EeVlU7av5Wi2mKIB/afCkniKLC8r63?=
 =?us-ascii?Q?09m4j81meWKz78Gwf6uW87yDtzdCwuQQV/e9JKSEa11pTte5O36qMZct8I7h?=
 =?us-ascii?Q?AklJEEgSjeK8cgzb0se/YPgpI8++TJJ0YCcVsEaVqROd7nSCP8PizPZ3AFf6?=
 =?us-ascii?Q?bzWvNEo9jXlaF4E0sn69+TSs3/6fizlSaF/eshwbNrkVC1ScHYvoZK1PYsIW?=
 =?us-ascii?Q?iDv6FNy7b2d/ff/GFtd+8sn+v7rBSL1bEne68+dZJUE6NAmH3trtF3mMWwhn?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Utd7Ldq/2CCMlPXPrbu+agYCtVf35zpGTMmJzSErQB+F8krD0hBWbUhBbPCoEvWK6nveOKtXU4+jQC04TPaJhjQYoFf1pPJvx1Y6ceVNhVqu4eGcszDiNJAujUPiVHI9YaPNZuxy2MT2ML2CbEyLTVR2SOKxTU7tsrn4hT6hTjxpXUCAvqRLTY3c1O+pPcKFGtYFJaO7NwSA64mvMvFeYw5mnQTqM8hwPueExEwkmqyUSR9HK7+vQsAwKIRn1B7nTN2OtCJEl5hcj5Znv6eIh9gyBXWNbYTFT/sdOZcm/fGnnEbg7ic0t3FIGLwqYyJ1RSYOkpyT5o59nEBqjg0BFStaUtvHDtvjg5+buGFDSIesoN2NUeud/zW6PXvK1TyO9vgjFoiGBgpEt0qXoDStmAfBEF0cM8rPmxiWLzMRzkxzQrCVydGClyq6UUJ/hqgAJtzxWLgX+YFT1ki9y1MFhjkkAIhXWJkUdYjGQ1h+HiEsmEiFbZEEqmLblhLOb/mojcTf2Nmgc4TAqNJljDnKXp85Zgaz+7AoqMvnCQi66Ltp48TZgTwvJYnjMVaE0TzTWgo9wRTrC2O22hH3Nbsixqk2hqIuBWSJ6hBPokeoNn4IBek+5Aa0riKbAUBz0E3B8gysUsAu87kyn+znSuDtncHegFyvOqIQy1AUHJETTLTXHL7xcs1ApDW0hSti5kUAyy1cycgiumGY74k+iK50yvakd+nfuX3rFAnEnwhsKobvwUlpxjV77mx58qekq3ZnvgpaTQogxMzWNLsrBDSkHil8oFlVFfJNhm1YMZLG6n0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f89edd-88a0-4137-47dd-08db61e8937b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:06:13.8841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FvkA9FAPDv/PtH7FRl9Q+tlRpVSuvhH1R/tMh+GWVxGfu2Rru7ARQEbeOiY9u3pMC79o/5HnTnnZxdVwHkYAoZ7PO+vmT80RyuASBw0c8fM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_10,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=871
 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305310128
X-Proofpoint-GUID: fBlvbdNzCZYcUbVrFDYIwfgmAynJtUrR
X-Proofpoint-ORIG-GUID: fBlvbdNzCZYcUbVrFDYIwfgmAynJtUrR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Please consider these SCSI core patches for the next merge window.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
