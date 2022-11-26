Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D31C43217
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 00:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiKZAVR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 19:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiKZAVH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 19:21:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC0C528B2
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 16:21:07 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ0GpmP025121;
        Sat, 26 Nov 2022 00:20:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=2tnAJQ3BzxWNo3YoGxJVSZ2fku0HFRDSV3hY39N3dZU=;
 b=Ed/mQCr+/jzNVsZzLOEVvvdDbwR3nJcS2VFOpw2pE61PBmQWaFaswQsGOUvO2zI0yf+J
 Nif4ew1K/L/sJSFxxTHTLdoBVNTusDGTOyI9DwNQOOZjCD/d9QXT8I1gYdKIwEPgx1gX
 yzsKCs6MyhriAuAjpyAj6G7VBocAd2iVh/EsytThpA0Lk9g3/FeWu6xTPqvKIN4VW1jL
 Qx24nZV1uz5PFKGd38/sQPNRSwxgm4iPMMYEh/i/+EIhIOKEiRB/aIfayISchjU+9GjB
 DLhDy0dQkUFSQxckXzT6rYptVcEAGs2+LK6lCz1UHQokaaDf8sBjoHjSZoonFGHcLvnY nw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m2jqm23g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:20:55 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2APKEop3028073;
        Sat, 26 Nov 2022 00:20:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkfx4p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:20:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bn63WbMxrXHj7VRVayGattuox5SxKrofNbEi5IqN1p/oGQ+GwA6H/lsnxUZ8AmQMwekjv2RNHa/co89pRQnbbaPz1atVYsfc5L/CjgNX1GyzIy64WRmZkagLXP/9ivvlwkmhOyM+wZTGjIuklcR6K4PUCVZas23C/linKi4PVn1s7edtCQA67dFIhJNp0FI3+BPPrsMpqn2jZWfFFXaoR9xt9weE1A6Q/chzKPtVcBqpfj3yGoomM4vyqrZqJK5VFrQaNvAW+sSen7TFObuFZVZaw5TGKkFUG+Vx/tnDbKl0WMhBRzSX8oSF+7HN74pI6uVcyU/dGZB+OkVTOy5aRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2tnAJQ3BzxWNo3YoGxJVSZ2fku0HFRDSV3hY39N3dZU=;
 b=bP9pOiJXGtjXRX092iH9WvQwr/+xmNvwDOrsaXkxbMvvqzLSuU3Grb20VJtR/E8nBHIU8gwDwUwXPbQmdG1vvcWhGFMs2DLGIpl05zOSjkD74eL6ujR9xosKMABB/ZYgDd06ZXOKqUtONTY0mNdN2oupYOFkL5K/lG3xnGaiElVJ9bsRi8I10f8SFgVMlSzkVclniXEdE9nWhDtmK6uNwRS5m/ex0x9yWStEIWRgBCzCgVuiHbwrWUZzh3An5ImqjTaUVwgfsQgjD/EnJZqPKnTDnWPoXa73JaMvAMra4Lon88lrddM7CsYBW8zFBXnDR0yaMC86of120TS0zhgcAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tnAJQ3BzxWNo3YoGxJVSZ2fku0HFRDSV3hY39N3dZU=;
 b=mdw+DHDmk4IdcuP+taETrCbs2dH0e1Easn/a3TefujhGyy0K1mAGTKjBXPR+xN9l5yISK8GW0P8rFOEiLlFvFRDohrirndN6Sl3NXaqB8M3IJJTxzUmamkh37qZaqtVOVJQz8YepRsnsiCwVmN3wtZDlpCPdWZawTCG9ULq4Ebk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL3PR10MB6164.namprd10.prod.outlook.com (2603:10b6:208:3bf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Sat, 26 Nov
 2022 00:20:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 00:20:50 +0000
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     <brking@us.ibm.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <wayneb@linux.vnet.ibm.com>,
        <James.Bottomley@suse.de>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: ipr: Fix WARNING in ipr_init()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wn7ipnvr.fsf@ca-mkp.ca.oracle.com>
References: <20221113064513.14028-1-shangxiaojing@huawei.com>
Date:   Fri, 25 Nov 2022 19:20:47 -0500
In-Reply-To: <20221113064513.14028-1-shangxiaojing@huawei.com> (Shang
        XiaoJing's message of "Sun, 13 Nov 2022 14:45:13 +0800")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BL3PR10MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 34c54398-aa17-4470-14e8-08dacf441272
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0kp1grUWuP6JNs4ADJqjOzpnNIEkuvjzsLKDFTfDEwUmXsiwQ2p/TxjcCqTGTTtoflp3TxiiF/no5KcIXqP2bJe+xm+pl2M5HmQHearOs7+BDb5OVW0f8E+4NrbEls/cgGlJKL7WetOM9qL/eBOP8/EnqcSbL4zbAESFCPamYnfi+ZBGqjUV9jjq0jKW8M6XSejAW5vs7vamCuY9ccLIlpNWZGov9fF5xg+jsuiHcy0cLhxhArDTPsUSqxE9kV4B/uPy+clrC3P3fseiStszznZQ9PGf0wzDSggFMuqDV+08cclat501+k2M9sNteMc2eFIDr1uIwDqIvhImNzZKKePdEz4rfAk6f95yeoF3ssPD9LXgsqEe3y5/zU5u+ZVxv2JCzJZ2T9GXL8xGBYk+gqx5ygYyaxmz95QArMKcoWAgu6N2mL7X8MWG2QOPrjPNpLW3A5lK4SAnPtpcrKV/n0WNfbRRwOGP0n7aQ/Lrjv/byOEOaSxXqP+Iw42IPEQ0Fozd1/clQbgmm8eSsC74UhV4J3GrwwvNDMlZmBlCm86+YRhZX0mkArpkPpGJ86zVm44+wU6TjNiC+vGKgjHfXuFQMt3FGkQJD/ho1q0S35oBSto0a961iJvZUwlXkgtJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(39860400002)(136003)(366004)(451199015)(83380400001)(86362001)(6506007)(6916009)(558084003)(6486002)(36916002)(54906003)(6666004)(6512007)(186003)(5660300002)(26005)(478600001)(66556008)(316002)(2906002)(8676002)(41300700001)(8936002)(66946007)(66476007)(4326008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6nO6WJ45pG8gWcDo6wl7eNIZvfRigkGOhTM82wf2TzGi9N/Gf1Oh+ts1TMiX?=
 =?us-ascii?Q?OhnNrvFtyO05teVzMvC+wic8HMq95ZTFIAxWGOqgeE0uHR7MbZx+meBwYbWn?=
 =?us-ascii?Q?u01BktGqkV0p57Ukdt0/lffgye9jmegxgFwpgHDeNsHB0lSBEZ39YbPonCSI?=
 =?us-ascii?Q?nrDfb+AClAvPhx/ylbctfR6VW+/JMMon9QcAa1XPR0HdDem/0UK4/iH7k4QG?=
 =?us-ascii?Q?VCGperzBiTh5DD1ZimYr3Jh9Y/e1Ttbhr6PFyVXzCB0xFPGxlHtWDdGMFo3Z?=
 =?us-ascii?Q?UWMRwC8aih8vdXO6eXQ0bvseW4K4WpWQcHoe+Yk73tUzLTjOxqSq+CRh6aTT?=
 =?us-ascii?Q?BkplydsehuoBRK0HsEUscE/WcGvgKwt3TPrWmNVz+kjT7XKwmktqvsFmhl1v?=
 =?us-ascii?Q?xjm6cI/mNj9SP5cnTNb5QOMHkbuG0528Ax8o+tvh4sOe5haNRJ2+/W1W0kd1?=
 =?us-ascii?Q?YWiU8fX9wARKTbCXEEhaxvCZiyoviISJlhA67pN8zdKY/hb5djKDJuPQihY2?=
 =?us-ascii?Q?3pafppFI2c9+1rtotSrfBJswLiBL7OVXOskgkbyGAVd2zQQp25PTKIp7iTY0?=
 =?us-ascii?Q?RKLEK5ASUq9cDvNb6vXMDqOtp98pUOavbbLe+ykA1++SkWzKGeiYihaohTNm?=
 =?us-ascii?Q?ihKHFJNPFk9uBLieYn5nSFsojhgoSCRNeY6M1W8/qpr1NScCT9yYHJIhyv6P?=
 =?us-ascii?Q?xvYdN8UaSsTySbC1uvwhuwfnZogzSRe+2un0AUY/cW0JcGRA211mteBNvPmf?=
 =?us-ascii?Q?jw2piyZLvd/JOhu0OdssRWsWxOTXGP8RcyGwiEsIxsa/UYyiS2ALY34S+1RB?=
 =?us-ascii?Q?LFjm0LMUKvv2MRsxG63cHdppSVBjH8jYjQo9yxJKdo5tvQyQs5n/AfLiQvxa?=
 =?us-ascii?Q?XVVoni+LZzwwGfDBkziQYhUE+orF0h+5ZQ4FY8U18SLd9sseblOMsPeXs9Zo?=
 =?us-ascii?Q?ClQ1XSPn76s2qraBZklJ2V9ctpBwprm8w7iFkBhAMT7D5YiE5NWx2GWx77ph?=
 =?us-ascii?Q?imnwz5/rM+Nb1P5foJbSBgwosrycNtcCPSkWeRlEMwZgS+eU9CO98iN1XqiL?=
 =?us-ascii?Q?N7tGUXg2PvpcfUHQpNYH9y8ltTf9QJWhWWgCE+u0msaiTZZO7j+BYdZDNAxW?=
 =?us-ascii?Q?/K+7ry5SQP/a+HR+ZuAuCvsqsDN8yUK/geasDDLm7w1Yn4ldqGwnlcMpl3cZ?=
 =?us-ascii?Q?MoO5KqDATDVfYiUhXcCH9wtqB4DeHGAL9in0giyhga3dMeWICqG5qNrfh2kj?=
 =?us-ascii?Q?te+x7wJTBEtdOcbNrHGgrk+H7MYSKKTE1sM9SA9Zjv+3PbYOvh1jdZzEYKHM?=
 =?us-ascii?Q?GgEjL231Y6LFfkeDB7bU/6uPPtMWHloZbHF+LeSQT/c2HGFLs02aPtHyzfRJ?=
 =?us-ascii?Q?+vaP/rCap/JNfyrgYy1VwP2bDu0lzwuKhZ+7IRSu0SaLBLzlexb2q16UYlvj?=
 =?us-ascii?Q?yonnrJ4hBvOca51Y2FMLIblXi+fD2Cln2hwl/DMZF64Wc12Ce8lCWFJLniBg?=
 =?us-ascii?Q?5F9pGAbjM9YI//EV/u8YyRsnO65RvTSkx5trND/tkPP0DG0ijsqL4Wwx7fZS?=
 =?us-ascii?Q?Mtz5RpFIJyxdmlt8ZUhylYYCg9r0qYaTsM6mAp6ffL7QgpFxCCQ4DZRuSszD?=
 =?us-ascii?Q?YA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?oV2Qn7iJKJxTYUyifrB5Y053XBOnDXoDgiVNUym8yYm2QK4oqjUyfzbnQCrX?=
 =?us-ascii?Q?Gml7tgH7Pydq11H6E/jfXU3nEF/8xCiM+0/DtPg2Y/0l+m2aRTOnOMMM4kFK?=
 =?us-ascii?Q?uUggAfJHeJo31YABUmgS6y2RFsnZkFRn7cazCvGLcpLT5qWoAg/mbGORU7sk?=
 =?us-ascii?Q?1SIv4Qn5WpbWXn+jkbZEUUj21sqvSz2UcWNbL9cWb5kb4g0aUlOO8EiCFNGx?=
 =?us-ascii?Q?kRdarxysuDiHW94kqq5nCvMWgiWpPIOpMSM9llKMGEjKhuXMJvBFzSgXpCdA?=
 =?us-ascii?Q?xfnOkIRHnGTSyEjzBgi/g+qo5Apvguqijgwfa/fYkOKvPRuLTqMbV9/t7+/z?=
 =?us-ascii?Q?a91NNnedSlG8tR11L1kxoXpgKROh3CZ9xpxHb3VVmGWluCXjTY7NNIJhno1X?=
 =?us-ascii?Q?LoRNYvM1S0mpWQpllFdP2LZUcp9gdItZbYblthMN2uNWTO5bUX6VHkGbz29/?=
 =?us-ascii?Q?0pHUqCWDQuZI06CiD5Yvf/z7JdS/z8N59D3N4YwOckaQuPrEnVGhWTxrEKff?=
 =?us-ascii?Q?/Usi06QAhyfnTwZ5KGNiXRaVxtq/g75sb7pkNV4PFEeuPV9r9OhBugxJea/7?=
 =?us-ascii?Q?OuADREb4wVjVihpwNJabe6Az0xsy3A6UVRPkLLVYN4GXVZtL4RpIk4Ywk1in?=
 =?us-ascii?Q?o9WiH6Ke2JYa7QC+8w6xfV7T6vPDMTm5FCJctwoAmg4MwulFCtH3N6Y4FJIW?=
 =?us-ascii?Q?YgLX3XnVTwQjD0rExbICTAfPorTPJkUXa8dcoX5bmBERmb2Bn2ZRnOQFJlbJ?=
 =?us-ascii?Q?U7ouve/809opFBLYoPFftkM3VzPrMCs7PAbw+ZmfnrXEZWXkwHiSG8noSj8q?=
 =?us-ascii?Q?thcLNO44v2LNvkrqlIh7iy9oaQWpTxeQIhpAJgb54VDwpW/pdsZCHgfHNc57?=
 =?us-ascii?Q?ovn973xsTSh5rRJLg3z7BgU8Rph0AtnF6yUM6n6+11taSMfdC8dCU9HuoNVy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34c54398-aa17-4470-14e8-08dacf441272
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 00:20:50.1944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4iR7OFZ5m3vakl+myX/rwhOSnpn/3XTbbKOMQcQCJgGEsOsaPhggPiTKO3v1QlAkbf/SA2YVSyH5rmYfWqdk26iv7cXI72UnETxMK8r3/Os=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_12,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211260000
X-Proofpoint-GUID: kdZT0Rp214jLMOMRyYAT6S3_hG5TjAKF
X-Proofpoint-ORIG-GUID: kdZT0Rp214jLMOMRyYAT6S3_hG5TjAKF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Shang,

> ipr_init() will not call unregister_reboot_notifier() when
> pci_register_driver() failed, which causes the WARNING. Call
> unregister_reboot_notifier() when pci_register_driver() failed.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
