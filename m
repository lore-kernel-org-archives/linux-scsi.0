Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C471EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 03:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A051461056
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 03:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhJ1DU7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 23:20:59 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:58480 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229691AbhJ1DU5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 23:20:57 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19S1r5ZJ027768;
        Thu, 28 Oct 2021 03:18:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=4J5LnEOSDH/h4d3ktJ22fIgHwyTkpvV9q8rKrFuVtBs=;
 b=VctrBRNaHlj+lgmkDLOvkkahrM2dUoGiWzr2CUFZ8nQgprhrMhOvxJaFWSCPcQXh2op+
 ym/AdqX+b0XV1vhMdIeq3LcHChL/QyJyUqu8Js9K9mNCQRSvHzm9oM8Un05r0zFVmoZB
 xzigbzu2H3Eyjz2cZM5lk5C4lz7IoB/fRH2bu8+aHFP6im1g6EaIcwAxWSePTQCM/tfA
 KYvzzngYH8YX6sLZ8CYEshm1qW1OBZiAiaGYC8yAn0hYF61ZdyUjTNndFN2kR3pfSEcy
 VwkxGJ/iGu7OpZdBQCB0PNyZu2kktRDslvq/gvuzJlrxKMMwdPCA1CrCywwSPLUjpffW 1g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3byjkf05kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 03:18:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19S3FIni121203;
        Thu, 28 Oct 2021 03:18:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3030.oracle.com with ESMTP id 3bx4gavmy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 03:18:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIwkH3iXwx1zPt2L09Q+yAJmiRLQYVzcg1dp11FRmzA40nsRAxP/G9Pz4mBUfy0PedDDuTOXEOwjUifHukZbMSZvl6MA4xSiOhZ39bTjbC9ltV+3X+iNzhb1VuR2WCNtCMB4zyPbl2IIu/73JGhSDVVwUhpG/+FinBZuVoXHbSraBu+6ghTs9bhIZmEtu567IhPYl90Mid7FF98IoDSt1IJeeygAZjdqNxr2zisI8Zo8DV2EY+LpD3+Kzy46GIqvLQjJhKM4prNYd1ActteTXDKm8DNTVP3c1O7SyGCT0w5T065omv9LeOtsKJD68IEgG9hXzwOL+Cc2RY6ovCniWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4J5LnEOSDH/h4d3ktJ22fIgHwyTkpvV9q8rKrFuVtBs=;
 b=Yh4EdxZ1aiYM00v6HxcRdmrYx5bwIp3fxhJM2v3U46AT8d4il6v5nePoFAwACvT7MUmuL9txBEf+sPSkS77ViRyWr6cEL5kv96JcgrmUZo3A7demkVALjt4u986I7tGVMqj8z2NykwCStOdxeiMlgg4iQ/6jUPUYt7DAtZUNaolyRtulIpLbShozq/BZP3MxnFRWRkAI2tD0GPbJuL4E9u4iKRVrVqjrTRv9Cv+torYQB5TRrp+YR35fpUzjVOXuTNJR2L80eJsFXfuM6I2FLj5l8evrHTZFVTYUQcjs9xk/mWH/hl3/Qob9IthpGu80NxIFEu5o84gZpwtqBU+iow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4J5LnEOSDH/h4d3ktJ22fIgHwyTkpvV9q8rKrFuVtBs=;
 b=Dtg9m0+3kejToUPX4CZxqZ3kkAsi4RdeQOz2PLSrhkBtBPbsRDP0lni3P+jB///nVuSYbbKdjUImCfEhem6+dOR8IN+BVC1qOR9MD9iOA+j1JtLtVnXrfGKAF5DmcoEniy5QqneiFkiA0LJzhgH9yWWw6ph8tFk1v3ZYr1Jysrg=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4454.namprd10.prod.outlook.com (2603:10b6:510:3a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Thu, 28 Oct
 2021 03:18:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.015; Thu, 28 Oct 2021
 03:18:07 +0000
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        jongmin jeong <jjmin.jeong@samsung.com>
Subject: Re: [PATCH v5 01/15] scsi: ufs: add quirk to handle broken UIC command
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14k91zvn2.fsf@ca-mkp.ca.oracle.com>
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124505epcas2p2d149a4f26d3475830a36c47049591bb2@epcas2p2.samsung.com>
        <20211018124216.153072-2-chanho61.park@samsung.com>
Date:   Wed, 27 Oct 2021 23:18:05 -0400
In-Reply-To: <20211018124216.153072-2-chanho61.park@samsung.com> (Chanho
        Park's message of "Mon, 18 Oct 2021 21:42:02 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:806:20::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.21) by SA9PR03CA0006.namprd03.prod.outlook.com (2603:10b6:806:20::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend Transport; Thu, 28 Oct 2021 03:18:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eb4504b-ccad-4673-e2b5-08d999c18fac
X-MS-TrafficTypeDiagnostic: PH0PR10MB4454:
X-Microsoft-Antispam-PRVS: <PH0PR10MB44543CE337E320B9A9633F038E869@PH0PR10MB4454.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y1gMVHzl/lq/FTOQmiRfCkNwYi03apVLVbutWbW7M1H0FRVPvdbi/qH83OLBfmSwu5gIAphY589AREcwX4imLfsSgs5NK2w84ePlss9pwS5ionAXpHht0uX/Rh1rorqed8LMbzCbjffeJyG86XoGpUUn94QjO7YQ0ke4yfouOZvZQfAa9AQ7pySd/JdXREDSOVf1X7DtWXXQVPJJrxZ9tyfsdeNr+0MaF7hWp9dqR/ktTm78HCYd5Zn+fAwSlU99tDMHpGpFywRbo9lRyq0PVYu9KHt4WuKjhp+Z+eMCjxJ/j3kcI+E13Lf4i35k3AqSJ7t8W5Ac0fil6gxFXI748u24bNSwfRXNAFRdemxkYeXAhcLEYEJWqrtSaL5MoZxjSKt1Msag0GI743D9h5pmPV12bWbw9PkGqbOEGdmTuv4IZ0fdwAbldn9SUykw2kLB4Ztv7xo5IkQR37b3LwRQ0d9QiNJ5f3gDRMaYwRYr4qRaM+ZK2CEq5r2z030erj3Ht+aNa7wCsmW7Aetft8CB3HtdDIm+jW7II5pRz9lNq+fTVu557aQMNlxHkTIDvV+uuXmzoia/MoiJtSp/8vBnhXDl9UYVFaURhpnSoldYGMBd4+OAKP+Od99/rwlOhDG3uxqOHpHcWnzxblTARyt5hy7rsOWXp8XUGlMDTbo03IeFnMX3Ujrb9cx1A3dDpBfvXo9MrRkQ+EL8DsbR3YWW4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(52116002)(55016002)(7696005)(38350700002)(4326008)(6916009)(38100700002)(4744005)(36916002)(956004)(316002)(2906002)(66556008)(8936002)(26005)(5660300002)(186003)(508600001)(8676002)(54906003)(66946007)(86362001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fkwCtb4bhGTC1HJG1tDNalPHHDwhdkucJxXCTnGEuEgBn6PDRfKS+AdTqwYl?=
 =?us-ascii?Q?N2JQwCAhnwMk5I54dhPkdl1+5H5CKTncXoSO6B7qDM+FV3/S1uEQUXe0ONaq?=
 =?us-ascii?Q?gifYfGy604vWvstwcsCtVBQnZ0r7hmoQbQUAOjTG6fsbo75dbyilsah7oqx5?=
 =?us-ascii?Q?qj+4bx0e6XZQ+drduaJ52EWbdcIynQeS5XUeT9g5T77Sa76DXCFv6cUsaJtl?=
 =?us-ascii?Q?5l/bBGeL9xr2Azaws3yktrXeZSuycJtKUADKj6m9gazNXz35kY/uEk+189XB?=
 =?us-ascii?Q?Av/u/qgetvQRs46I1FtwsxzBlTbEHZhEFjQQig7ezdMRRXhh+XEHPMOwakOo?=
 =?us-ascii?Q?GvoC/8JAwwAuxXFmHnf/iR9Y6hC9o6TeTR3AZ7gPSsjEm2v6ra6sr/MxmyLJ?=
 =?us-ascii?Q?mv9DDRMZIP5BFO41lQr9Mm9/wngWg3QCL++gFRyx1m+v6SjMCUs6sSRly5ow?=
 =?us-ascii?Q?L6vdXoC8HNeKD2fNdd9Hp9joIwb8AuuLOJ0GdkdHAhTpFoP+H4YrqOpwaXyN?=
 =?us-ascii?Q?7eKTO2x24SAb2Pj16avKwAjoKd1Qf8P5DcgptC8T1q9Rd2yXhNupwXPCsr8C?=
 =?us-ascii?Q?WIytwMu92Bk6CNky6jztsbOvqdlkd0MXXUkxgax+eKyi2HbRH7CIS6N/DAaO?=
 =?us-ascii?Q?1SAZ2rw30GyiInbgBaXNG5Fo1hWufOnQSTMTplxizPViqwtJwLn7aS1T+3FM?=
 =?us-ascii?Q?nPIa03wXWBvQ+bnBFJQspztyegu379UKdgj6KYf+qZSdJFo30XW/4PYdR40g?=
 =?us-ascii?Q?uU52dU9/d70jPDjtjvmPXpo8M1kUMdCVrfQWeN2QEJsfF2gNNOiIH8JalL+L?=
 =?us-ascii?Q?zaW+kNZo/r8/B2UdhiqsAOnL69VKN6SEVgugBAQlTdZb2LG6dcrqZTftunsU?=
 =?us-ascii?Q?YehLApvurUCsjoT1UmjG/OFdLrTM90bNbm4JjPV9HbHc2cFpSS1OyKEw3Urm?=
 =?us-ascii?Q?ePWe2CnMvLYCpFpGSV1ibNqnyLHiJWr1MZIuqSMgfQvkUvG1SOEtsbbBHgF+?=
 =?us-ascii?Q?S/iSLrPNcyqCmKJaHWbixBKzzcfgP9L5vNySvDetbA8oLt/O/z3Zwg8nWTZx?=
 =?us-ascii?Q?jVeYNBd43bBSFPG/OFzAL+Oq7sNYd5quFlfNELqXIZhZxZ+n3KQJjpC4T0b+?=
 =?us-ascii?Q?ML9BU+dIbewiLYmBkWWGptHnVPAKvQ/yLuxy4N6E/CDRqKZ7P6DUHCYQYODb?=
 =?us-ascii?Q?YGCErmvcfxfHu4qXW+NXxl8hJo5oc8JQotGEmRQfsWpVZRNDl5hWwvxhWgdC?=
 =?us-ascii?Q?wv/nQ1mYFxuC7+9eHhsUJ+JktCFZiBAtIFMYnjd4EINdh98lzkxLx6cTO4u7?=
 =?us-ascii?Q?U+DnwmKCdhPcgPnopCjf6KWJnRP4owBDedXPwiadoc/l7cODwl9p2KT0uJpQ?=
 =?us-ascii?Q?lveVlgEPpDCnZd+idCj/t2gZE2CP4J/utituXhoUO0snZHtpjP9KyCDWq1lt?=
 =?us-ascii?Q?Gvrj/LZUnSbwOhpZlorLb/uvO8eEhnzV4yz5P0gqmOeyT4z7DZG419vUHTOa?=
 =?us-ascii?Q?YQov0NCEverqWm2SGRzkgWrq2O6Ipd8CZpTm9J4doMHTHU26/U1ANb+gHJzj?=
 =?us-ascii?Q?Q701ZEztSCQ/6wW13zH9XJRZ3rBUODlDwVhuGc6sfZxgdID8bio3I8B56+dv?=
 =?us-ascii?Q?AMowZCz1SA1ZzRsRklWlpJPTZxJ62zChXGqmWvC1GNmt3wPc7Ir2y3X/eOZY?=
 =?us-ascii?Q?/cFeyQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb4504b-ccad-4673-e2b5-08d999c18fac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 03:18:06.9926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RxH1t+qMb4mpTj0anfHmbfqEK4v+NV0ew+5DUys8b3AwAPCbWYQ7BbM8oSSL5JuNZB1Ltw+QH7UY9MMufJG6pvAL8RhYufp7CxrJWv/4N6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4454
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110280014
X-Proofpoint-ORIG-GUID: RWutyjVReL24-Imp8bLYldF4KaoTwAP7
X-Proofpoint-GUID: RWutyjVReL24-Imp8bLYldF4KaoTwAP7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chanho,

> samsung ExynosAuto9 SoC has two types of host controller interface to
> support the virtualization of UFS Device.  One is the physical
> host(PH) that the same as conventaional UFSHCI, and the other is the
> virtual host(VH) that support data transfer function only.

Applied to 5.16/scsi-staging, thanks! I skipped the dt-bindings patches
since the relevant yaml file is not yet upstream.

-- 
Martin K. Petersen	Oracle Linux Engineering
