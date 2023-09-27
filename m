Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EFFE82CCC
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 19:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjI0TvL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 15:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjI0TvK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 15:51:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41226126;
        Wed, 27 Sep 2023 12:51:06 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RIxGuT023558;
        Wed, 27 Sep 2023 19:50:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=3UnQLshN33yvR4C1C7/kH5Fdi6QYj0NT2UIUKFnIzFA=;
 b=hfFLr/Ps06r0k99kZzN1PREwW3K6Ekt5XLhmZpBS/NNiQeScRqDQQXJzJKpaQakfSrsa
 DqEA5PlV4Jxk1pODcvpz72waL1vTy5CPBIsIjhJypy+EP8B7J9HoJdife7NyTSfAZuWk
 77HJACcZ9fXZK4pKqzIvxo/acLkgDFMOI+d3OvFtOLJ4cPG1/XP0feno/HkTnIi+Q4Qh
 z605tIk4i8RMXWDD/CWv7N9eWrDAE+BrKN6Pds1i2PwyVDkzqVq2UnUVGBRpLP7CErA0
 k4G1fPrECZE5mDFXmcWJ0H4x8gUmasBi2grg6Dhue2VA5WBnCsp2Bt53EsY26lCcpN51 eg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pm2akhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:50:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38RJa1k0030950;
        Wed, 27 Sep 2023 19:50:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfefcbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:50:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8xtjgisDArmcnEnu1VHDoMjLGWRWyOJp76PNFzQawF4vweawJmOrDGiohEm8ayILAKrFkeNUf3QMgZnsndP1IbcJaFYH7BCwlFQfuBhw9crY69ZkGX/o2OgUz83mR5MQnAQeV9uEZNcw8xPM6qmbHWvUO0oz1oYZ2nrX2JB1ep6RP/XOdFF7c0zvNSuL2eaAs/GgiIMBD8A+3Ca4lLFVjgu+oGgHU09ur7G/I689pnu31dEcA5n9KvdlVHPOpRmvdXX+MHcyKODUCjMF8nfFT9nXYp9DPj1Q4QdzlpCvCRucQ9QVBEqXpI9ai8A3Clig1PtVsInsGDzkYlXOqD5+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3UnQLshN33yvR4C1C7/kH5Fdi6QYj0NT2UIUKFnIzFA=;
 b=lAe2ufnVdtjl7ArXQ5ueFQJTHPkh1zH2yFm9fszmmJD7h/j0JGWOOaa5QcaBf9sjJ6ZE5K7O4u8tRe7fNqMbyYTX9ZkUx+m/Pm7pelgLTZjuheEjQtTgIPDzius7+hvePCkyaK9c7+DoexoTh4T6PAQW9w3jNqRlr06apG/hjSv8iq4pV+guCPiIU0UUQ//yBngaropOUXfo2KSepwWG0nPJZBlzgHSJWLgWkdvqof5p2dpyd8BoYxx5UdmLz1f4Wl1fW2VmZOnJ6NMCdqoYiladz4NOJCHg6uC96bMT5r96jEkaRCYGPxxn+/nCWIhc/iCU8/n0KryBzW1a7HSh4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3UnQLshN33yvR4C1C7/kH5Fdi6QYj0NT2UIUKFnIzFA=;
 b=hN96Cr8c/lHQY1KiCrExOkIlFRAyFxKzN2FJMXR4cdQnKscBZflsVRNbceoRWd+iF1F4dsd1dUOTYYczU7Qh5OXXY7yrcTrQTgjornTqCpSZk/1/9vdUwQREo9M3MUsjEvYVEYXyt3np0ouEn69ChWUuwlm/tIYNwJlpgfOOye8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB7309.namprd10.prod.outlook.com (2603:10b6:208:3fe::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.24; Wed, 27 Sep
 2023 19:50:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6813.017; Wed, 27 Sep 2023
 19:50:38 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v8 04/23] scsi: sd: Differentiate system and runtime
 start/stop management
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1il7vz9gd.fsf@ca-mkp.ca.oracle.com>
References: <20230927141828.90288-1-dlemoal@kernel.org>
        <20230927141828.90288-5-dlemoal@kernel.org>
Date:   Wed, 27 Sep 2023 15:50:35 -0400
In-Reply-To: <20230927141828.90288-5-dlemoal@kernel.org> (Damien Le Moal's
        message of "Wed, 27 Sep 2023 23:18:09 +0900")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB7309:EE_
X-MS-Office365-Filtering-Correlation-Id: f2fcbfd8-87ea-48ad-16e2-08dbbf9305ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uTuo1jxAD294TempWqcEiI8bmRtOPsWLjyMDpiVOXTwSneVMBHxjgEtMuf9GIinzVaWuVm3mTb+oNa6nId5aIsjxdj0LjyF2j9/F7LHhbs8QxNxwdLyVruYCzB/lLh7ZD/5wYRns/P/+kJuCpSRReZmlGSwoer+K+wAKUpW/GaDUv3Zxy8JySp3Jd9HZehVlSY2XZENIgrzzo6vSbRo2LfuCF/cUfTjHAnFgBTLSlobhU0vnJnlGlVOiVLqgK+xcJl/xpajKq1jQhcEWC9/G3TiBnhOWOdz2wrZFnpLdeMwSCTt/w0j9HZKWD6vzpEe3aghnCKam2Os3cG1Oj9f23FZO9xTZIK9Ejtl3jRAM1zIvuzsHRlE6owLYYugVNxbIFwVCL9L7cLtsrZEMkl4iBfNGl6XwA/lFUZ5zxy4llBBdQJLHUTmcyOD2c0YWDWwxiyQdT77wLvQjoj46kXT3vhTHcBjE7R7WRlDjpHaI9L+8N2oDuY83z1Ugi0a86f0YUxbFflt0ypVs9n/2yAQmSot0Da7v37ywbxszf5ARIFq43E2qQgpYPs2XQFC5Xmtv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(136003)(376002)(230922051799003)(451199024)(186009)(1800799009)(6486002)(6506007)(478600001)(36916002)(6666004)(38100700002)(41300700001)(4744005)(2906002)(83380400001)(6512007)(26005)(86362001)(66556008)(6916009)(5660300002)(316002)(66476007)(8936002)(66946007)(54906003)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?URsbpMmG9Vb8KBTSYINs+Uq2z3EKzAeQFy7aAsPRzdB+xhlcGQwU5dJiLboO?=
 =?us-ascii?Q?Q6nmKTImWcXsG0aGav3GUL5t6NsnvhKmIr1R9qPOg4LVCJQo1o6Fu/mw9YPS?=
 =?us-ascii?Q?Kv1ITiX4WvmMXDXrzCBKW2WazkFLJ6z+qvCDuU2Z1bhGvMAxADOjr9kSLvrv?=
 =?us-ascii?Q?LrcJm1ItpG15OIGMB+0uKsHvbKlTXtYKxwO39ZpK6boINa0jno1VLaoAtJyc?=
 =?us-ascii?Q?DlZSXTMjGM1AwRU5OQP5ruFy+2BN6Qm2sDVQAU0+iFligITRFNunj6vLqi6L?=
 =?us-ascii?Q?ZwHnVudpOpHtBF/dgcOAdCb2YEYxOrCWEbabzTRRh3UtFVzuzxvoGE1NH/ln?=
 =?us-ascii?Q?NmLKHl0kSjMSNNo3c3O2wZueUbGT8maszT+S2bq0yWi9zcsy0LcDYJnoqRVZ?=
 =?us-ascii?Q?V/L2vKSMGSwlC84ukMyAPArWjXL0ifrrsxW2JL4iZiZyqfp873f5u7OquaNX?=
 =?us-ascii?Q?92Prfap4uAtoKNNxNDETiSSh8UvJFjK+fYNL16iX9lXwx4+l83i17sP21q9A?=
 =?us-ascii?Q?pRJFnrPBVeuEvHX1hweaGKA7voa2YFnMaOzerg4kxWLCX9cda/oNXtq5Miqa?=
 =?us-ascii?Q?FL0VdpTsAKVJdYffZ+MqMM6UE8xBagLpRAlIv909L1lUeLbxpsGzaBH7MkcQ?=
 =?us-ascii?Q?uj1OwovK5edpuo/BC+BVSTaXnRNXjJ5OE7R2ibfTgElk4w4zbjbduTLtIjGb?=
 =?us-ascii?Q?XzEGpn7CnPW99gESs/HsU2pakKtfhSWEzz9CvQr0BUmaw0Q8sQY3eZvL0PQK?=
 =?us-ascii?Q?xFBTCnHDhpEjQb/jZEKDrCJRC1BAa6u+l1J5f940vmBRhlukYNY8zPS1GhOm?=
 =?us-ascii?Q?EmcWAZCHTC+alfHU02p+sG4HTJLoUbS3S0apQ2nJpbgush+GrWWgs/Ez/Mz0?=
 =?us-ascii?Q?AzcHNLazxF71WQe4F2y+YCXGGGM2oB4Ct9tKaNv5YTC+NSIHj41/X21pc3Rt?=
 =?us-ascii?Q?8myLxUmSNP+dvoG846w9L9rHAidQHaTQ92rfI71/YC2PLLB9ibCr3w5ykPrM?=
 =?us-ascii?Q?yZ/yOQtihJHAIskq+tyr2Vuiu/qZeLc4UXSE2kAXWqs7ci/JKMfAxT7R/bTp?=
 =?us-ascii?Q?KdGKPDbv4mag/OWgFHZ0Ss8e9lkAhHDFc1LkPmts8DpoBo1MgbhjoQrq6fo+?=
 =?us-ascii?Q?V8PXH0kRXAGkRQ5LLb7FOy01DkEjywpp2ko1CVL70dsPzCwAahrDvWfuKUOP?=
 =?us-ascii?Q?I1mM5Ni9flbN/oXhsZCPFTFaqoDyCyKNSZcPrpx2X/c7hDnyuJXbdgVdtZSD?=
 =?us-ascii?Q?ohvMuZe7bDKhrfnwVZquzO23C1iJhXTZU+NaZ1cddG+WWPCRvMnxUOaOHslZ?=
 =?us-ascii?Q?Z1PQKXpNGSz587lfvJqgwqAy+VsWG9nGKVVlFqtcq41oTEKN0OuEtizbUHWq?=
 =?us-ascii?Q?0kSaswigTuAGCY34407ouYn2+gUbK6Eh37c1NfPmUN5BbRpqj07vLlkClPKK?=
 =?us-ascii?Q?UMf2042+aTf2Mm9ydKTVBnfhldwKuIplvRgvG9h8TrahK7gA8pZrxGWup6Hv?=
 =?us-ascii?Q?yo5bMVRdr/o54sU2Wt3iOCmmAGE2aGFXtO8R4gMoADTb7jEW4KjUCbf6NQSD?=
 =?us-ascii?Q?VuGqjcp6+gIKmG+Kvl7GEAh9QbArFKtMcjoCZw9G6flCAANseYbxs1QeU5ue?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?qnNB9se8Uw3jzKxgm/ngvev3eNg3lFRxDYfxwlSkcZhZ6U5zdpbO24UMX9Ni?=
 =?us-ascii?Q?MqW2na/Acb6aAb9XRm99E6ucE82QQZYzRhf9EPD5XtCXIkfIQlXIoFTKQOdh?=
 =?us-ascii?Q?143rYrMgE9rrLrqtvAH4ZsEqJBrKmH8NyW92TvkJZPvWT+rUkvXNpVIEdjay?=
 =?us-ascii?Q?f8mxYsC2q9F4O1AUKSuLLZTxQabLTMdhj+oypsqH6EZg1P0lrH3Egvi2Qlrs?=
 =?us-ascii?Q?X1X4hhcXJ8I5NHKlniajbk0iHdMYQUsGJI8BnXbLJiUK20BjAdRO/sjM4HsP?=
 =?us-ascii?Q?/7VVBPo6AgLcjOhfBm32w3h+IbYZlE4NcDUmGAlqeHpCprZi9Dj+VQHQAiH7?=
 =?us-ascii?Q?IojNMJt4Gv1dTErzTsfdiC4KLI1QMjUzoXGPGZhZl1108Dp9LIDZPDVdoQlO?=
 =?us-ascii?Q?AXgUigNXC3jIWPwa/n2LHLdC8trmEtpmDTMws7OctDIUUQP+g5vBAxsHKRTu?=
 =?us-ascii?Q?HBJ0cP6sWLmN1iDWvtbJYtbUHnVmxvOJCM/t6oT7RbrTUrJH6ew2I0L7mMol?=
 =?us-ascii?Q?SLVBM07iVM9zkJJRW4YdcBOCE+DrYN9IgPXS6P1xIjbDhMksF/1VhR3svUsU?=
 =?us-ascii?Q?uODyoAnIvgxN57UvnC8hz/T6rWXZj95I52Gq8BKqgNgOnShHcUGNvGl3K5ku?=
 =?us-ascii?Q?0+imqB3P8XCBuyTC2rr48LodJVGgBoUz0q0N0f7LxSxomMoH2Wxa5kojLOzU?=
 =?us-ascii?Q?q7aV7PGBU2X4Bbi1+8i9yio89bd/xNrEcHBbHaQGHPHYKkRLGEwm+mTZ3Bdl?=
 =?us-ascii?Q?R6oCYY1GnJRXFK17JT1z8DpmGUkvc4wgCk0c9LHcP/aRNaHX1rOXfHvsD4Te?=
 =?us-ascii?Q?dn0B//Y44GTbmGq5viJ1Wla5GVk364VPuG4OCdwFeXiK5txmGclXBhrxIdlN?=
 =?us-ascii?Q?fLAhd6dYzItuRJDXC3KKBSFmQZCn5TsSDMhmknCRg8gpNCz6GvKw4AebZhIg?=
 =?us-ascii?Q?JQO9T0A3QewENFVKOa6/cQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2fcbfd8-87ea-48ad-16e2-08dbbf9305ab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 19:50:38.1763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mY4R/X8Mo28Ach34MHbN+0uOIFjlNty78byTmRJa/Sx4GJz3LOiqSPlCEx5LMQMEXJUh1IXSQ1GCTHGAo3kbJr0jKLB3i3o6PJweMjiHDMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7309
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_12,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309270168
X-Proofpoint-ORIG-GUID: TKrI-ltREvXlU6NrtmCx_Q-tur4A49Gf
X-Proofpoint-GUID: TKrI-ltREvXlU6NrtmCx_Q-tur4A49Gf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> The underlying device and driver of a SCSI disk may have different
> system and runtime power mode control requirements. This is because
> runtime power management affects only the SCSI disk, while sustem level

/s/sustem/system/

> power management affects all devices, including the controller for the
> SCSI disk.
>
> +manage_start_stop_show(struct device *dev,
> +		       struct device_attribute *attr, char *buf)
>  {
>  	struct scsi_disk *sdkp = to_scsi_disk(dev);
>  	struct scsi_device *sdp = sdkp->device;
>  
> -	return sprintf(buf, "%u\n", sdp->manage_start_stop);
> +	return sprintf(buf, "%u\n",
> +		       sdp->manage_system_start_stop &&
> +		       sdp->manage_runtime_start_stop);
>  }
> +static DEVICE_ATTR_RO(manage_start_stop);

Nitpick: I suggest you turn these sprintf() calls into sysfs_emit()
before the checker bots notice.

Otherwise this looks OK to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
