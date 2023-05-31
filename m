Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB25C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 22:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjEaWSc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 18:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjEaWSb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 18:18:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05AB9F
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 15:18:30 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VK8Oam032504;
        Wed, 31 May 2023 22:18:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=XFMkgMQABde4GPUXqxcf3cY14IqdhAyg0cVvg27x9pE=;
 b=kN8IGp5XNppHkEuAs6hhoTjWVEIJer5KwfivE1bnX8tknZJbzaYXnENcTCPIXPR8JtTt
 K2r77jKkzSPmA59HYEzPzf08Zxznj7DZcW1GW8qCYnZnwOVEeE2y4gEaCdRcOCdz+5zH
 JrkGQJSXn9hOTW93JjTdz/MjbGaq58DaevxArEINpFNixFEpN5fD6wD2zphXnImN5POX
 4D1KQvk7P07iX/PYTcVRga4QxZkHGwaNiCaiAzl7m4wxyWSEZJJYmVPaUFShdbSuSLQZ
 EmcjjKenPi6+w6a2V9V+QU0Jf0qb4/uapkpoJ4vmkKcxrpa19vhxxBMDOs30wc2Ufx/e LA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhb97523-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 22:18:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VLucL0003695;
        Wed, 31 May 2023 22:18:26 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qv4ydwtq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 22:18:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlGhJBXHJuTkWPRyny5O/iMh47rI76qadpJuQ068rQ96V5xQQtiyXZydNxsIk+pWH4Pu72QPm+Qz4rhWM981vcM6TiIllOAGmOZ8XbEWZNkgZcLGMdiJyt/bVpbbJlnJHHHuIMR8mVEeWdLg5cMPJcbdQDuKrywl2BoX69S+QCpajY6ytIaEoiIPa1V0L/lBv4G1NljA2R6jQ0WXrHUdHY2wNnMcWnU7Ro821QWWy1Hwt5sutpT2ExWykmHhNbQWn5VTUdP6ABPq5cXRPpnzQkdC7ZxthzQSP4E/7ZD0w0OjT+B43YFcz2hCKgwxIq2LlVOExAvGMaD4VCx2pmMXSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFMkgMQABde4GPUXqxcf3cY14IqdhAyg0cVvg27x9pE=;
 b=Hdd2pbefWyjlYqkwmCODf1QmoH7AfD4YaGKXJDveiLW/dRF7Qj/OdJ4yJ0LtzZ4OZ/N5ibcACjAhCqb0o3xSCJTJPytIVxEX0NskAVrr7q6Sl1IT7JEieJiqJKggrc6a/+CFBouDj2yNQEFXw643N6j11zY+TrlT09S4to9za0EZ8GndpcQw/bnd/Z9qY4z+WXGCcL2s4F1xA3x69LJ8Nk55FW9NeXO6uhtJjdDTzeZ5MPxRX34/Wm3TEyF5mvm6i7F0x2wZZqyKhCGgI2S/bX0bTluKBZLEvFAc3246IIpV5d1mVZKztCAYHOaLc/ZJLi+nNhky816Qh+CrKM5zDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFMkgMQABde4GPUXqxcf3cY14IqdhAyg0cVvg27x9pE=;
 b=c9Wf00H7L9CRdtns5qcN/ZyS8zHEyxVBe2UTTGmao2wNre0e40FeJxJvWTGQDacrJLSVBVLH+CH9KWJS2RDj7jLrwY9qsXR3y4Kv2sn/9v7oXNm77hHcvfP6vpjSY7fcSKD0lmLIcnQ0G3nuFXfd2MM00wKEqjJdsmdzlqDSKDk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ1PR10MB5978.namprd10.prod.outlook.com (2603:10b6:a03:45f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 22:18:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 22:18:24 +0000
To:     Justin Tee <justintee8345@gmail.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        justin.tee@broadcom.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 1/1] lpfc: Fix incorrect big endian type assignments in
 FDMI and VMID paths
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qiwcfh9.fsf@ca-mkp.ca.oracle.com>
References: <20230530191405.21580-1-justintee8345@gmail.com>
Date:   Wed, 31 May 2023 18:18:21 -0400
In-Reply-To: <20230530191405.21580-1-justintee8345@gmail.com> (Justin Tee's
        message of "Tue, 30 May 2023 12:14:05 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0175.namprd05.prod.outlook.com
 (2603:10b6:a03:339::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ1PR10MB5978:EE_
X-MS-Office365-Filtering-Correlation-Id: 72436417-dd84-449a-5105-08db6224f34a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AvcDE/YuugwsOjXfdvTSbPkJvMgEkMgeN5rx50QcxUPwWwcs2B3lG9R+t8I2Aoj7CVYLTLMb6shSPwDeoHaRSbJ2qnTnUOV0ew+uJB5HE1xWnWA1AcGdPqAE0O5mSw5ygPxRNDEwdFByTG+cyXuwWPYtWb0T1BDI862xeKgTNJi63UC3mp6WpD6LokGmUT8usSSKKUmBKrAsZE9zBbI9DuNLBW3L6kmMZUpYgTEIfqMfeLhLxvz0l4YX8tqdKDh62T4QcpAUzQQ33OjMwYZ8lmC6KBx3Qy/MyTZzkB7qWU2BWmDhLMNsRAnJ2wKQcVLxGR61tB1GnwuDaAWAAuWgY6COnwE4H6DEMvIDtyi9EC3qwchhu3nqj0IMhYM4QNtwaAySf0ecf33EV2IXsl2rm3whOdz2pPrDbMAhfOPr8SfBe8Hwa8xHWjrkOlh1XKFH2i2um5W5E5C7uHFXWHmJ8UHoYBVocAPr5Oi+IA/F9sGEOqtI0GyIbQw3XZ9ivNVJUpYdLo+Tl7fVKPw3SBWCJpxDyrjC6Pyu+81K8/IdoE7+IGhmes86edgWhS+ezXSx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199021)(6486002)(36916002)(316002)(6666004)(5660300002)(8936002)(86362001)(41300700001)(83380400001)(8676002)(478600001)(38100700002)(186003)(6512007)(6506007)(26005)(4326008)(6916009)(2906002)(4744005)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZbRbgzLwQ3VIttXHR8wHPhGPFJRhuRNuzgSS/cBIDaj+bD4xk703SFQPad1M?=
 =?us-ascii?Q?CxyywRBKB9CXNA15u0z5sDukJKQHmtAWbHBKw/56xnaXcIrheDspZpdpcApA?=
 =?us-ascii?Q?UpLrRil+D9kvw1XocpalT4yo7lSEeV+h/KRbC0lOFENT0Cg2jBpCmS9qVKeY?=
 =?us-ascii?Q?GfIMSN/ke53KoqlnC/pMxU1dClUgwDB7x4h5JgKVFyN77mnSObe3LSn3JHER?=
 =?us-ascii?Q?b9ehFBOdvgFxCQQTdixlDbu4kxZPYolCjXbe0d22Km2kO5Ym1mJshqgeYOyk?=
 =?us-ascii?Q?5wy7GIVvaV6ivWjyW89XbFM9bG798+RkTIrlTxhmM5D+cAGnW4l+8cR8jyIf?=
 =?us-ascii?Q?9SXCkEOO9RrG0VXLPjAlz5rErWZC2vZz1daPen7n8vpmn5PSKV7t/vkoebkv?=
 =?us-ascii?Q?SkxYp+beYQVE5EWWbQjhA/hqeNeqaqakg+4LBDz/qHTdH6Zu4e4Xl2i3yWUH?=
 =?us-ascii?Q?pJN2Ka4u/fHfdANg9RTxvH7v3d3nvyToTrndfiU/VQJg+hjrlMHvKDB43Fyy?=
 =?us-ascii?Q?BWNEeeJ6a/MEWPQFqdcW6OQYx1JpbTDTE6n0f8BdzGXIBarOKSjjiOgJnbhc?=
 =?us-ascii?Q?lYpeImwLhrjlWczP7J3VU0JA+ZxSq2Ie/FOtzLGP0XV4W4J60DPgGZHf261k?=
 =?us-ascii?Q?i8ZL7H8zSW60l38s97AjqmquROeu/EKTIH2nr+9RDWwJN6Rv4dchEweVmzda?=
 =?us-ascii?Q?wlbYLqNhch2WqNyHHXP3uUpfhh3TJDiUQy+k79daokitLe5yIubgH5SmwIjo?=
 =?us-ascii?Q?a5QnYqgqs2Ya/hK4Y5PivjD+gKZDn3PUdYavzUef8OS8YBjf6Hw3n35ISAuM?=
 =?us-ascii?Q?u6EB3V6367z6DPzb1eer0K6e4XgIRoR0YZ4BvM/vOZfTmesUU8Au4SUj3pkx?=
 =?us-ascii?Q?K9q9IxiQXatbpdkulSa4zMVDPbaAMaBerya0vuBMaTMaD8s3onDn4WrYYbUY?=
 =?us-ascii?Q?AUhwEOUYttj74wY1YnnZNeHHCyWRVu/FWWTMtHRqQT1FGV/CG8iNAFBvGxmz?=
 =?us-ascii?Q?3LdXvEeblIOSjuWCTyW16mIiYpBEYsYXV3qe6Hdj/eMC0PeoqLtMP2VFrziF?=
 =?us-ascii?Q?ct9Pc+DyWGDeCJNkIlK+WGP9jCz46z5Tl+E4XkvmdrKPj04ZAZ4cE5wESNof?=
 =?us-ascii?Q?HCQuBbtRXVN+eFfuSf/gAs+vXHOKoUa6bRWIV6MlcG7QOJSkIupuMiY7PXAW?=
 =?us-ascii?Q?0ISK9JbdpnU1uWKO7EGzXgxSHFPcuYFhwF+rGNMgTR6fFqqpaK7soYV1tuKc?=
 =?us-ascii?Q?w6FJz18HbCMWlHi2aZqNOE8RFoMjHeku1m+1OE9hpJtsjePIOK48nrP+YhPv?=
 =?us-ascii?Q?590f0mZUpActVNb8F+4ZEwRsx8HaPyeSLEsNE8UVvyT8AleVmqPfPwJ1Puzc?=
 =?us-ascii?Q?oPdGAUPL5JtIsa9KFVMkaSVztSmXRYpHoXSSAz2sehzvOMsLLOGKXIHnKL6X?=
 =?us-ascii?Q?IgC787ZHU4Jb90JbBP4ddWpghoFeIC64IQzvVZaPG4JTvu3951GazOxfQTJl?=
 =?us-ascii?Q?tCijWP3bKbh5ldzWEeIsFKvmkVgWK5zFy7w9QD6h9rtBIaTBVtPxhxrph1XN?=
 =?us-ascii?Q?hLQMz4PloC9Hy9PrCDEaFFZNGOcdkX6FyDPf97tQyIC5el1CIqKZgJ3BNk43?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dnA1BKmo1rWgdekCHSwSkBELiftwpTVGLeLErm/cBOd06Gzrx1vj0bbOEM6Z0zJLPvwJA6IKCA37ayofIpTCal+WgaGnD7vca5wx3bHSJbmTp8fxOD/4Ks/+7EQZaYBnug1LPHmuuOM84a5nkU8mwSALhAlAECGiiZoOjxJFHWjXuqjuOcTlTd9c+Ei1ARqSsMIpftA5OF344ay6NYEqBpimPhAWDPbFeIjKthjCmpbUPSm/MHFVuMXE70EpetJNrcMlnNqH80f0ljsWs0gcA+eQW5KsX25yeLsEXbyB9H5cBPuqvlcjMgWxKR7sDg0t5ns7uWxa8DIfHEq+GDqS/6MGfAu0VWnSPHMDi9iRale3erJyryWcO3ZRps4vkuPfzUe04yBmU6qOg1BLOnBklFBoggieBvdyEutuypGyzuo/pVtlDXyYAOiekLgqzrxGPbYVYd67OvSD96Fg5nXX8pkLoCzMjq9sbbTIKvhAr0NpZyZoYZrUIxBtxyvqOhkIpv9xNtXsBZ81/ExdDvh6CVQR5LTrbjHLxTn59G499jrXkxW9A3E8z+WMnOFtOO7gaQp+IykYC85bDVT90hynoBPo8NFeJvbmizaI0gsqE3zFzwN4xAr7QHKHf7395Y6OQsndmONuJGu/wP0zp5wVis+rT+guFRxvbIdOYnvMx5ziU3bP5A8vAn66PBzOpacO0gQ5sBpkBSVRtm2d0J8kHHfzhi7UITzxJXariEhmuOMcwPXow8CZD1Vpu7bY43FqzoNDiZms+JacR63QWW/X9gx6HW1r6O+pCh1R3wKTdCWg+vyQDQHpl8ilUOEDpDTKDVVkD435GJRultt/QrurBuW9TWw+l4kmr/lleIibe+w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72436417-dd84-449a-5105-08db6224f34a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 22:18:24.4532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cA+6H9BU7PKZatQLmab3tZKEbDsv5Cmtg+JVcJwJwP9mFbbnxBSDgZumGm8VoZ6tgqrRkyuSJIMkzDBAHrmzUJ6Bh7lq07DejmW/YgebEvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5978
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_16,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=684
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310188
X-Proofpoint-GUID: YBFTh7HzqVzbszRJPM1oqqsgALRVyA6o
X-Proofpoint-ORIG-GUID: YBFTh7HzqVzbszRJPM1oqqsgALRVyA6o
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Justin,

> The kernel test robot reported sparse warnings regarding the improper
> usage of beXX_to_cpu macros.
>
> Change the flagged FDMI and VMID member variables to __beXX and redo
> the beXX_to_cpu macros appropriately.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
