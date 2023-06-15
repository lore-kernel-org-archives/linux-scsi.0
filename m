Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48A2EB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 01:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbjFOB1m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 21:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjFOB1l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 21:27:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B55A2126;
        Wed, 14 Jun 2023 18:27:40 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EJrM7k018103;
        Thu, 15 Jun 2023 01:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=DtuuuU81fbA8DUe6kPI0okTjcbiQyNXcmgHZPmFa7N8=;
 b=HdU0GTrGQYZakBI+eVWaiJ3gGLCYFzgodfstuWfZ1OJp4xUpKZXAzGOf4fC/J5SSHQq3
 VWRNFP03MIiTk+9A+b83anjbo0vSleVh2VYl2ZkCZkIR0ZmreOXOnxo+teIew6P2w/DM
 lazzIa1h1sT/8Zup1U9yhbrNHLUI0vu4DAK8ZzhZ8eDm90l6OJ5Dn9FIcDEeC2TkRq63
 KL4m9YxorSuHvmjTgwY52TQEgxTLvl9eDn7ai9qt0p1+NN3W06uTIm/UsxOIs3QSWQXl
 In/bzhjEcvurfybAYgcjkihLA0PE5URzQZUBjLgMyUTWxXbiPqPE7pnKLzS8sSWg1OJJ AA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h7d8vay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 01:27:36 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35ENM6N4009022;
        Thu, 15 Jun 2023 01:27:35 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm6jxcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 01:27:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADd7Cysxyz5avfgqUnr58MOyzBOOKehU0GJJZkZoiFU1WedOlgTe/Ct7JtyW8ZqmKWhtWH8M20mnxeeouGxGOmzFI4PUPcK3nVv71TCodsT/voCW11TOHGoj7FyvZZoYiYjE4zeFKRkaGXdIpECOS+vU/s5nSvZrz+/ic7QGimCqAA3zrwJJC4dAJW4WFl/D+1wzmqreYT/2IDx3XjQ+TaCvWgbwtVoW9EwNTE5wfWIGx8ZvKNzI5y9l0GeFnIgw01A77VPVnsSsibDHOT4+rx1LSr4stki4v6+unbwrFf1s+ktxgRMAK4tmSpqlztdX0bWSY7xdtkJluLZv+YJupw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DtuuuU81fbA8DUe6kPI0okTjcbiQyNXcmgHZPmFa7N8=;
 b=J54BZFqVb6caXy1CJm5DGFtogbAZAxSQc3fUXh/QPrQ+6x4HXWSJPrulfGXwbwwDGnb0S11gbsh7KRA55MjEQHPQTIxx3/OLzjg4GLffcdjWE9+Dgavkh3vze2gTkWQYB++xwIceeEIVNcEnUeWzOwtOefFyRBKCdXubyD1L41+gd5BJBTcyROIQ18wNbGrioPADnDkJAjPyYCq0MXg4s3sHm/N/NnZ7ck6VmaXk5CKP3IXO0cc00SfJZt5z1YxuSgoiMaItgorSNm5NZxRF3aWlaKmw5aDpAPDr9B3wp7XaBZE27QJAc8m9leJ2NfopQIRv0EBKKD412fERDVmlDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DtuuuU81fbA8DUe6kPI0okTjcbiQyNXcmgHZPmFa7N8=;
 b=agT1NbrkYwCwk4NxwwOSK24ecN8iwHlar72Oj9XQawXKYmAACqdNJD7jiH076JdBmoK8xvofFvhGnSJjMSihdqG8Lc2Vha6pInuWci0sG1L127eEt0n0Xio7TJcA0/JAU3J+yuNlR6JCsBMPRbQ/bipz8KRPOMFNSRHthXH1fQ0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW4PR10MB5726.namprd10.prod.outlook.com (2603:10b6:303:18c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 01:27:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0%7]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 01:27:33 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH RESEND] block: improve ioprio value validity checks
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1352ty0p5.fsf@ca-mkp.ca.oracle.com>
References: <20230608095556.124001-1-dlemoal@kernel.org>
Date:   Wed, 14 Jun 2023 21:27:30 -0400
In-Reply-To: <20230608095556.124001-1-dlemoal@kernel.org> (Damien Le Moal's
        message of "Thu, 8 Jun 2023 18:55:56 +0900")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0014.namprd21.prod.outlook.com
 (2603:10b6:a03:114::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW4PR10MB5726:EE_
X-MS-Office365-Filtering-Correlation-Id: 21052454-5586-4ca7-faa8-08db6d3fb149
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R0exyh3N49RZ4A5xhq5BRQakM9Q6yLjePNuuPkPsbR7VOwWw7qIMtolDU6pNtNsSFU8NXeEN5nMCAZ4mGbid3Gw9oFyLTRB3nF9adWNjXys4yHBntSvJRGI07maKIU0f97KAKe28QwFBN7EzGAtwLEaTVV9Ib+mvoecsDxBXOPN0QJHtxzYmwXpYEefilUTpkWYyKcIgZHBntbdC3sDA06tuqxBPKW6ij5hKZuoxux5z+rr2hDFiC+4jmF4gWadnXcWQxKiVaiFaPFU9+dACbn+/cP14BNjpFJcUGTj8Evzphd3HEzCdh9T39JlSMQjiWuc9POKEHFjVBEPNVbYQiGIXloVnTWwYSAepMQ3l3plw5uuWQ/q29A/l3/Mo2k452jvW3n8RoZrKL4U/rSUA/peyk1AxVFZYMv4eNZUtTNdmT6fxFw03ZZCjEAmKHJkrIfvWCbMFCTzou4me5QV+telLs5T/mSzdSZBCP37nB//aWiBfSr+PNtNZkr7kWX4tWIr87bgO23d62Ck7qfYPd/PCFsWjQdi0SWjV4RoVYRDc7vkyne0qEvSyNuo0e9bi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199021)(26005)(6506007)(6512007)(186003)(478600001)(6486002)(36916002)(4744005)(2906002)(316002)(41300700001)(8936002)(86362001)(5660300002)(8676002)(38100700002)(54906003)(66946007)(83380400001)(66476007)(6916009)(66556008)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kV8/xcrvnijhhBPx7M0XNL7XZ1JIEAAj89JdTfqW2UAhJnk067Ei91wM7MRK?=
 =?us-ascii?Q?F0auIDCCDeYgjD70pQ+ZVYle2g+Fcp54jCUHBV8RQsMOL4w6m3GG60J35XAP?=
 =?us-ascii?Q?WtN3ADRUdnLiZWLjVTlizOnuXt1zvpRDgp7FEBB1XNbwTNGJG+yJe3Y7epOV?=
 =?us-ascii?Q?599WHNwN7rpdxXNmWNtgJ6qnn9J9Nl2nRBuISa5TiHjqgtuVOyD09nI+69A8?=
 =?us-ascii?Q?r4JGo4BE/XAWyDU+hziY3RTV5/xC72WMkr9vQZINQwa2BQT5cqOJ6kC2b8d8?=
 =?us-ascii?Q?g62uTldkpGbnH94XOy0GPV+dH2OlL8iZVl9WrzwksQqpgMtUOjFEx2hfEoaF?=
 =?us-ascii?Q?B8zHBWxNgbl/VuxZCIcYug5A+h5fEl74KP+dv8EdolVbbY7TH7OiCrxM85/b?=
 =?us-ascii?Q?/NKTN82IHV1bRKC8Q5n+vSEejXvcE3UwjV2k3RGC/AzNdq0eNRJR2kkO3YuR?=
 =?us-ascii?Q?ulSWEnkCYR9ujSpOqg/pSwW9LQ5g0l622HGl7WsAsJWRsEejGu1SMmJDm9hv?=
 =?us-ascii?Q?EdafPps2lFlNi1tD0dnCG++Yg9NaO1TMJ2sMfb4Y+anxtKSIH5SMzS9kMVpN?=
 =?us-ascii?Q?b5m2Biq8gzzYXeoLrNA993xTbTtaiBdQKNOCRLMvVLUmiVmyRsENPaD5Ogm1?=
 =?us-ascii?Q?s89HUG/EcOkKzaa1aNM5mwuJ7gG/4m/Y05Ns1xpo2Rg6rGH3LrYW0IV8+xqY?=
 =?us-ascii?Q?llFGGjOigUsUvathBVHaIipfrW/6yDi1TWjSra+76CInaFfggUVksfUzDXlV?=
 =?us-ascii?Q?8B7GVdz1A6+qhP5dUgBCbVn16rUf3SztugbsnBZFbqWzarP3BW4UZN0ZYMyH?=
 =?us-ascii?Q?NwBadXbAMxtN2rpD9PhaJ9/21sOXmeSylVtYrZhqSns6FxvmeErwxSFA2R3d?=
 =?us-ascii?Q?eC15Ez0ezsMqpj6OOoJpJP7Py17YC8j+O/C4RdW0+ELgLM8GZ5nP1qUfkhLf?=
 =?us-ascii?Q?m8SFFN+WcCaEmLzkSvpJZfEflul69XnJtMR/3KTqsVA0lGlCEF9NyG0wofgj?=
 =?us-ascii?Q?fHHI8FVdUkF3681TuJK7RgozJnbciLduGWfOx6eQw4DqqwPqhkrIWfH++l30?=
 =?us-ascii?Q?/JZmueP63Kj2dfXOktmK01hb4PDb8xcYuod0JMGvHzaH2qC6ARzx2cn2Ovno?=
 =?us-ascii?Q?oypmDhIcSBoqObzgMiuLZu+wvtcOQwL2OVyFIuECIW2ILSeNTWFxP+yDrQx2?=
 =?us-ascii?Q?rDCuVpq2KQjk1jDTYKV4EUa7VCZ2U8LlL1HdfQ7qqKmFv/vCNKMoV56y4qCj?=
 =?us-ascii?Q?IAm3TLfGdxA/z1sQGL+Yt2xg/oaOvrRuggBPdBpyMkp1HEH7TyyoQRZLqc8G?=
 =?us-ascii?Q?YMd5oeIUCoVqCAWfcm6neOcKXuco1xKMzrnsSnDSE6DJs3EMrginXUBfJrhC?=
 =?us-ascii?Q?KazucqssC3FuZZZIkdanQReeAv5xcNRwMnxTUKXE+CwXBfGLiySgShHQgkIq?=
 =?us-ascii?Q?LoZ1Q0Ba4abJXg4aJyArL4JzAE394zOQogqg3hkJqUIBIOAU4DnrunGzWCCa?=
 =?us-ascii?Q?K23YVg1GKhtdX3FUgfppUQbb1d47V0tPq74L3aLzduR+dKQr0Oyr/pJkadoo?=
 =?us-ascii?Q?JHfQBiLCBkov2rGLB3YKA0uWE8tnx5kUcsxI2Nk9N2AAH9mzaoLBM7yo7yuq?=
 =?us-ascii?Q?qA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /1TKLqn6roxYfKG0R6zsQ2hyd+rFfuHF4aHwmBw15vXk6VIR5wiQLISuROO7cM6f5wLsdOdm2gdzjjM5+WFA2HG5BrHS37X5pYV+2avQRzINaKagLs5WEjBqM38ElQRW4/rYF45FXXoBLdR/3yBaJdzfSl9cysCAermVitCo6VBvnqPFJ9LbM4L8VYSTkGtNmaF/xfTEI7dHFuRjprvA9sFPi8MeHvTBf330p+ENI+QQPlrgZS2/0I0PQIADpA7inHO53eunsBRsvj9RINtvqWsdKUL3/3qhaMjs07I4vwuctW3ssYWGpdpoM6D8/VY+pOojTYmi0Y3GDCowi9IjNrcX46+AWWwFxS3Q5bhyIaXjNTvmUoLQr8y7J2dBjuAOCsyrpHs0pfgtAjd4OwV6hr4nF//QcHFYLnPyJZyENWvtNPq5631MhDnkU9yUFTqpLivFbc3P/tLDg+MF7255rFvbZnV8uS/xQcG4Qmc52mIqwoNd315hHnwnar6HEsMc3NU4lRaH5VL+8E8c+VtNWaXuXs7hOpWuCuRRY0taI3lpM4VGl7J5ysH/vbHleLRX4qtrMHV3smVIVY5r1dCGtUAUHjFOinrF/42VBmR2lov/kU4PcFTFItRS/HPa9Nj9aU3+ei/xZlFRbnYPXm5MF+38M9oBjv8oNoTQI6v7EMWvdq16Y9AZqUSKmvZTd2rAJNFgjZbUgHSXyWUC/x/8zrsdX0pF4Iam/BWXu1QiuyBsAzUYvKRdueeBTkwjy9i3aF8tJamlV1q2MVQMDyCGfrQNYnmgaNQGKBpzLZuwk3lkhTn2byMm8/pMo3hwmBYSD/sljoUMZSdEhppDmL3I6Rh+EiqITmtkWa1o1GXLCbClCtE9MfAyN83UMjFWKDva
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21052454-5586-4ca7-faa8-08db6d3fb149
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 01:27:32.9003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yp3HhZOuxN7YuY+aAEatSUYpqpugMMrYd5zJ/eO18Ldvs61VkoUnwKZ0XjRdMVyMO40HXdCqpMDx3DGPkgwq7vVCFX1/8XpqSbxRIlNwBf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5726
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=554 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150010
X-Proofpoint-ORIG-GUID: zJiAD8kMiDzNRq0Dijh5feDFauVxU_w3
X-Proofpoint-GUID: zJiAD8kMiDzNRq0Dijh5feDFauVxU_w3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> The introduction of the macro IOPRIO_PRIO_LEVEL() in commit
> eca2040972b4 ("scsi: block: ioprio: Clean up interface definition")
> results in an iopriority level to always be masked using the macro
> IOPRIO_LEVEL_MASK, and thus to the kernel always seeing an acceptable
> value for an I/O priority level when checked in ioprio_check_cap().
> Before this patch, this function would return an error for some (but
> not all) invalid values for a level valid range of [0..7].

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
