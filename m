Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E28C77B73
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jun 2023 00:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjFAAao (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 20:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjFAAam (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 20:30:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4C911F;
        Wed, 31 May 2023 17:30:42 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VK8JWD032575;
        Thu, 1 Jun 2023 00:30:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=vGClHyu/F8ZBqQsrxyqLgAVcYRurILEhML/v0AZ5vnM=;
 b=umwa0JSKXyCq8f5PSzH5eNOSmBcmIaCUrUbbliqhoyyz7GMuUfDivCPHdTUcucqJmLvM
 ft593qOyQK6BPzBch2ZQCzUb/G1/g+IDyPRoxAnJLKKVn/yb05UCKf99fqLSuYV3ZktU
 Y6sL3HaZmcvH37mwlJJk/6hFH8wk0WDVCFaC17P74d7I/2fgmGY5/Jo/OWy4GhBoKB2I
 XeZw0LqjDhvxTM0lvcibQeSiGvb0iy7AKTvp6f46GD2mQSFdpt5fh0DTkij/NqqKbVnN
 s5lcz3SBIrUHr8FBSe40Tg+9WJ9kzDA7A8p8I2SYlGE3ZjCj5yECiWXVL7Ssz4+4d5aZ wg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhb97cbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jun 2023 00:30:40 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VMHeQ4004391;
        Thu, 1 Jun 2023 00:30:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qv4ye22nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jun 2023 00:30:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVEYfFVei6DWCFpjJuWxPyCE/2sxc/yRJ6fE47uOtEeJyNYeSFeG0UDxkppQmMJew3uISHsJVIyaWkryt/cepbPnqwllP4Rwo/57oNjGhQdWToeFHCe9E4GroFca9Ia2rxoifANGcoU4Go1x937nQkA2JLlaUVO7k5VvxHs/tTVw2FHIcl1QxJnvqdG9zH5SWnxF/IMED+xD8VnQLKs6X0QBwlpkOvHKvIfSsc3RtY+H3TEI1FIQmZifK68BAEKkSW6nhd0Y8Q6rvytkITr6OfO2d4jYqqTqufYVzjnC6K/khl9DfBXEQII3IySDXV2JKCAajbhh8noBZDWDModlbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGClHyu/F8ZBqQsrxyqLgAVcYRurILEhML/v0AZ5vnM=;
 b=jKdOfn6qM52ZmQnKaEnq4dHtWeQw5sRSWMK352yA8SrtBAGQbVFi10EAXYPkP2YDIvbht92cS4JZPfoZkE50RtkB7Ua/+4q9tYSp0uIr07HTvkbJxzZcDgcVvsWSvNFtqTkMeZkSLhz5FXULiW1YyxdGJZ53WuOUb34PrV3vN6e1mombOcuCoQCoOT55jEclNxyVskw5x2AljgNuNAWQQ7QSs2W1fDJY8VOrDFrsv4WEGoOx/xys83yRhU7cbiyPweamMB4BwFxrOhwJhhwU0rY5lq4HofYtuBDpqJMwFM8il9/J24MhufcqgnfiZtQZzBsY4ev1gnDBBdTFV19N3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGClHyu/F8ZBqQsrxyqLgAVcYRurILEhML/v0AZ5vnM=;
 b=sDtBIyXCfvUJhA0XHKqwtHE8VSFVilv2pMheLanv5NsEAmS8T/ZB7W6LQ/6YK9ittG7TkVWS5AZyACpe/ss2nO9+Gel4HT8OAdfxHKsyMZtDccZUruiagKM/TNEupe0GyvEcSTmIGjJfnD7l2l5n2IXE/LDjE19uHck97rcVKZQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN7PR10MB7104.namprd10.prod.outlook.com (2603:10b6:806:343::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Thu, 1 Jun
 2023 00:30:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6433.022; Thu, 1 Jun 2023
 00:30:36 +0000
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, stable@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>
Subject: Re: [PATCH] mpi3mr: propagate sense data for admin queue SCSI IO
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qiwaush.fsf@ca-mkp.ca.oracle.com>
References: <20230531184025.3803-1-sumit.saxena@broadcom.com>
Date:   Wed, 31 May 2023 20:30:30 -0400
In-Reply-To: <20230531184025.3803-1-sumit.saxena@broadcom.com> (Sumit Saxena's
        message of "Thu, 1 Jun 2023 00:10:25 +0530")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0428.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SN7PR10MB7104:EE_
X-MS-Office365-Filtering-Correlation-Id: c3791d1b-4c6c-4f31-2376-08db62376b4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EM6hUJ8fOHAfU56uvxAe5pRcAQX2/httbgxZI63NKLUUum6xR5yVv5cxtmY7hxf38mtFwEhZ7EjkCenJv09UyZgM+GeThMzgoY2TrZfUM9x2OOMd78pZ6wKkIN82AZ2gPXgnObHfXdpeY+KfORrIphqtASZpw108tM/FpS0pslHg1yK5eP1yMtT8+vewCbd9+MkFK07NzhkgGrF/7GocVsghJyGSQuhwVUtmfbsHvnzvqI2kPOcu2s39hCvTEOHBwaEiwEKVKU0kTzP29ulLZFHzfaXO1y2Z4o+J9QtWaGwR7quGgQyhj8I5jsrlhTg1fx8lUR2RiSo2Xr13/cOa2FXE0dLoIszB4JKdMyta11CAQNsozWkJFy1ZBEGmUnfUD/oRZavStWUfH1up9FvxeCXHHLtjq4CvApaT+0koEYcZJk0h8Q+2TwY2lSS1g6+zbP0lIs6+JvPEqLc0d7+zTF6/I1MlkNHr9kfUXLwFzV3pGHBXC/FzRnbUYAOPsVJYlxJ0+AjB0ApjDyV+S976GvvWqJFWOiDcFjBNb+05x4AYdK31JM699FGXFCK70Es+qC+xyl4jOL6juemKDUOvDXULQvWNnu8vZMF1bJ9pMpY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(346002)(136003)(39860400002)(451199021)(2906002)(186003)(6512007)(6506007)(5660300002)(478600001)(38100700002)(8936002)(8676002)(26005)(83380400001)(6486002)(36916002)(86362001)(41300700001)(558084003)(6666004)(316002)(66476007)(66946007)(66556008)(6916009)(4326008)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6EzHzTO3oFpRdXVqcEuL4HtbLe2mvBuKHTjeGrLzUSYDa0kofXaNFZ8h1a6s?=
 =?us-ascii?Q?MIii/tBfbBsSFIOEXGUNZh7JHytQWMe8AmCi+VRBaC/ybwPEeQzkOakpPEya?=
 =?us-ascii?Q?BQO+FuD1dY/A99nR07qDfiIXCZt5zsDLzvgluIrY9OP9LgRtOmCpTS9esIWl?=
 =?us-ascii?Q?DnvopurvKjYUjeT48h/6EuosQSJj9waEDECHdCWHvQtw1xqs7FXSDmyBr2P7?=
 =?us-ascii?Q?Nx5sv30+KOPE5lU+hMFh8lISDPz025ReYlukyq3LXSYU34YWuMQIUpkdwXkZ?=
 =?us-ascii?Q?GSobptcqSh46zmO9V0STfQK12ALfimLUYZ4eLf/OvdDpvz2CVLJz6XDJmXPI?=
 =?us-ascii?Q?uRvrPqY5RqfgLLn2Ls389ElyS4hc8BaAy0mljQjCYY9bKdETYZNS54ATUSMa?=
 =?us-ascii?Q?/OhXGiRc1bJdMvurgVICLOAEw3m/3ady9nwjfwaf/H/gvFNOXyscQghDNDmV?=
 =?us-ascii?Q?ahPAgCRLrDvc1QTAkFZ1QkigqZHgzgoJIuWpnLkKY4i1y93KDtAp6Al5uiG8?=
 =?us-ascii?Q?G9bSpoJqiNURzs8DwnTTWsv+KUUs2U9x/F6NJT88aswfZ2+AhKyYfxERHWiZ?=
 =?us-ascii?Q?1RPhB0rTMteeajRVrUWE8NNHQFFQHDik9qU3i3/UWzN3R9Ha23RIP5Vg7Czv?=
 =?us-ascii?Q?Sn38PRcCu12kER3fRifFhdK/BhBejzApl4sm3dmVu6LwOqdJ5OyzbiLqhLLH?=
 =?us-ascii?Q?Ce/PXs1p78q64gdiwR3nVvU0HQ5hlHxMoTlA+teEG71jzraSK/oeEjDmUV2J?=
 =?us-ascii?Q?u94Jhh2hjyi1py6AQ+ZPBMsXVllp+vPfUCuuDvzNg8bk0cAGeOJQNmG1ztgo?=
 =?us-ascii?Q?IWMYP2oKpquWo2omzONWC0Y+MRVvdotM3eyFi8YXyma8PB1igoocgw7bIWER?=
 =?us-ascii?Q?B3djXhGaqBHeXuoq37843bnLHnRHf4X3VvB0W+IZdfkC5TmIHfW6FXJdmtrJ?=
 =?us-ascii?Q?U7N3t9yqse/mNAGJhqZXJWc2Gh0omIa9FmS0qlyNIwlkvC0QfhKCm6qcn7uF?=
 =?us-ascii?Q?Ixk33TNfv2Iv53XJdaJkNXpV3ftNkL5Zq2aoHvsW0OjumsOyu1DACqe49QoJ?=
 =?us-ascii?Q?dFePZpGFkhvp6X+yIdqRubKIHaanGtb4GK5Hen2dKLC4LWO2r0E872mVQZsP?=
 =?us-ascii?Q?U/IofVI36GGOiZ1Jb33zvDmK0p/ZYJWZDmNwVv7OqfNm8F1334+CXkIe2bkF?=
 =?us-ascii?Q?XMrDsd3zjOgWziAmqOSn77sfYFf80Q5xo0rAP7BLxLEHa6NW5iZnBTRxrKja?=
 =?us-ascii?Q?9Lh81HlGDGZaot+DTJIbQKZ9jvEKeWC0kQNOTii3FUsHB6q7MnCH8pZfNmx0?=
 =?us-ascii?Q?ypyuOXxWI7ohWrVRBrCSyT6WZzPdtWcGFanUWRMT1S4y/AB5ksmRJZfVvgEW?=
 =?us-ascii?Q?RpYmK8iHB03ZuZqo7YjnvcbPJ2S66DUWo9x1bXVgPx6c96Swpc6eZ+x7zBwn?=
 =?us-ascii?Q?MOVlTrlUIvE0s18gkQBWUBG+1SAEfBBGQ65q5C3toFWEfhyozUL9XeZFxxBy?=
 =?us-ascii?Q?FK/LspghIUmaVFN7clniMI/BEP6+59+D9O/ZQnxrR+JmFD5U5Dyz79ungcuR?=
 =?us-ascii?Q?+olbSQtd33O2isafZeLeKVHgO+6ChMQH6AYxiANVRwC31ZAMjLRJ8Cza4XaN?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 8/lPIs25lLras9DgfQq+SQFr3dV+O7oaokfwpfCvPURjvk/SC+Ecbs0FV8OhJ9Devtpc56O07SXc+zcaasE4+5eweubGFR647IycLletvFDy2J0N1U5s2l3oY9/IH3lai87ejIrxkKMaemaeIHyiV6HIdSM3a2h0KVlyA4uNzuyaJjWTvzEcTlWSgehcMiamyYsxSAKfRav/dfF7RXgllf1DVpVMod+JeyLBU8M7ZcCEnTTFcYllJr34N2ZcRzlBs5YtgqDX+XX22NxFpLIEJNXp7DCUhnATNAMsfaR1gWgnleYxYXFXlQfAYZLreDY2HUpjYNS6bSCHkQqWSuCdicS6UApVfI+i3ij1sH4TjEqMnVjGdNfiCJRUGhtJmryhDYpeWG7qkOk/tY1//KAIceu79EMC5LnW2NVEvxaOdUwTboiPJdHO5+p8WKA8CBaMeL9JE+Kl5Loc+sfiRLUChTL3asMgHGGvq5cVMmj1bbkbLANcM7xC2tc8iVqE54oiKOAYyLew7XbP++m/heJa3vkswLXbTgieBM7+uAiyu85T+/RqAAr4XnbLIyvUGg9BohKPRHwlWq0rJMjFwrsVn7CF+fGxjB41xcPAkqgVbo47i2X8Arhx0JUY9qDVyQQSqfkXv1mF4edDCxOfIpLL4jCt654mnysMuDit3nsxYiIq8QcEGhp43p/awHO50HcbQ9rWH/256GmEgLrAAXVAXrxeY205wg32mne6KVMt3UeOQWwBs+b3N+otOIdWrXb+R7CL4aSyaBaJHa+P4ktHl1ospzQ84KdRRz0r7M2Z7LE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3791d1b-4c6c-4f31-2376-08db62376b4d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 00:30:36.7161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZypMziwUDkYnELdhsU2sOVCFoEmxNdD7gO5JY0mx4PQXuPFtzNt38mrq2Sn80C/XsxhLHr0jGCWiY1yRuj1gUnJs8EVdUBAyIvzIiXbM8p0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7104
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_18,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=984
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010002
X-Proofpoint-GUID: QT2MOkuZrjjZ0W054nECTD470B9CFyIO
X-Proofpoint-ORIG-GUID: QT2MOkuZrjjZ0W054nECTD470B9CFyIO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sumit,

> Copy the sense data to internal driver buffer when the firmware
> completes any SCSI IO command sent through admin queue with sense data
> for further use.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
