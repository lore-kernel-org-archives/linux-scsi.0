Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C4AC4167D
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 02:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiKZCLi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 21:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiKZCLh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 21:11:37 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5D85984F
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 18:11:36 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ1XJ3n029061;
        Sat, 26 Nov 2022 02:11:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=rHHcuRfsQRZW/f9s4pyed/svlGdi6eY4O93SAZpk7Is=;
 b=zUwtKxFcmZWy6ThmHHgUU0vZPn8nXVsOaUnesOGPBP2G/6XKlSNLYFNg9j86iCyPG0lW
 2pKvZkhdNdBrRgBU2SVdRSND2S7N/hYBmhEiiBIT1vygUN7S76ZB9J3fpaq+V9CaU8lp
 5ObuV0QiqeFz7ShDV1kJZHzFs88Kkgja482HESMRZgX4/rfgTfZR/f2tSlsgi38qeubE
 bNU7jjnJ+JZh31gJUQnJ3aNsq7keGAM9VOgQrEKp24eygIkhkqpwrcvX2LgYMaNqjgy7
 a/F5GdDv0Y0z3iHkpU+9iDTlDYJ44R4j0NtcocxwQQ5QHXNiJYbwdDJSUyCkTcNZssl1 EQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m397f80yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 02:11:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AQ1Y1dM009895;
        Sat, 26 Nov 2022 02:11:21 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m39888yqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 02:11:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkl6q4uOoKNVlz7agThHUdJqQPnivg6LOMgssjfsFy2uaUFeqTGGyzR7mnfKwf1gWHA58+SWQHVCuYI9qFfcVPsti6glSB6LtHhvMFiQI5H/hLvUpUvXCIaeogtql4amg0+FVX5ejgXO2dTTz2kBiTK2A1MRlAU9vDC6Seyy1UGfx2/ILerHYUU/4y4idEjLriFp2sfJH/8g/WnxzCL8+wh3ISXiLBOmV8PUSLOrS9CF2d3IzAwU0HXO2EsZ2MQvVJAAVPvm3KkLkEqewg5a72/hZFptCvCWgmzui9P8oIAaGy4WcHppJhuHUvEd+nDlcDv64cCPMdSfhhzJerxF6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHHcuRfsQRZW/f9s4pyed/svlGdi6eY4O93SAZpk7Is=;
 b=FjTUe6KgJ5iRloH/mW3G3wgIeSivx9w1n4Yf+kgmZCfPqcxnEtTuOXSaUTQm4+V9TMxQkkYXaXD2SfCrB/bJT3+MAVD33g1fnYUbAV1COuoDIiH+24n3gIH0vB5KAGnojAfpI9W9SW4gnWnCF9DnsTi3+U1oFvGPzDTW7vWrzrovmPV/Uyq7+KV0ci+Scucq8aTpth7YpCKrHDSNYPpwrma37YbhxvOe9Mn+JvVQ3xbxkqmZ6AkyCoZQK3Fu36pv1dV5mumCZC7DIwSbgeotlgQyPJHzCLMCT9yZZe6Vl/73JjdVtIRh/e7TV2AbZ8VG5IQ8EIFctYkDrqkM+CQfFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHHcuRfsQRZW/f9s4pyed/svlGdi6eY4O93SAZpk7Is=;
 b=ylp0q7yYgyzQVRde3Die3Fz+h7TNJxNwvZoWdTvrz0RQDFATeCG5VYFQm3QyRftYHiDguR1SXqSrSukm6UsZ8VIWkF96eZz2WJNpNHmVR7SfiTpfDjXqNAP5oVRP68DZ3aoMoj2vsCw1h/E7oHEmJB4t/7zDcTrjBj1g56CKULQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4544.namprd10.prod.outlook.com (2603:10b6:a03:2ad::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Sat, 26 Nov
 2022 02:11:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 02:11:19 +0000
To:     Chanwoo Lee <cw9316.lee@samsung.com>
Cc:     stanley.chu@mediatek.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, matthias.bgg@gmail.com,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: Modify the return value
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mt8eo476.fsf@ca-mkp.ca.oracle.com>
References: <CGME20221118045326epcas1p408c9e16a58201043c9eb3c99110fab0c@epcas1p4.samsung.com>
        <20221118045242.2770-1-cw9316.lee@samsung.com>
Date:   Fri, 25 Nov 2022 21:11:16 -0500
In-Reply-To: <20221118045242.2770-1-cw9316.lee@samsung.com> (Chanwoo Lee's
        message of "Fri, 18 Nov 2022 13:52:42 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0085.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4544:EE_
X-MS-Office365-Filtering-Correlation-Id: 275730aa-dcaf-4d7e-bb9f-08dacf5381a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mf7r4yaYK7AAgpfhQh4BYUAahB1p0+tpB81E7r0dkIMU9K0dgR5Lt6AmY2yj5+b5f+i1YdOshnR3N2fzrEJg7YqcpZxIud64OEDoE41VtR+9o22B3BOUt/CReRGVXDhsnyji8jV/e865O57n8Wl7k1Q5amDMO1kIh+GcWtv5m8mN735vn4JUHj9kZ2Kar5OYwpZowC2lNWwzRQcABao7a4JWQ+AvM/ro9ZPE9mwr6KsYR3qmZ2jt5odB/R2lfDvxm9TQCUgjak2L/HSNCCKLVntVlcZq97+M97OlpnZ44klOmEQsVlptjK9lPIV6r2d5sB0L7wnX+xnv+wHCCSomKEvDtinIPWDpfpvxzQmJqTMMCCDva1h5/+K9ImCUKzUWjEf7JDPIRZUq+jzZ2tYm8mg6/jHENVwngx+zZyL4HpK5DwlufkcrTxrDQTXMI/aZu6kT9qHWYAr/r4+awOEn39bGuPwQgzGnpf8G4Zdj1sgthQWLNQ5ju1Alg8PVDsBsz2re5QEbvfOV1jcMu0S+lMSQcGxYSQ95WTU1JsK5f199Bwtm9TQ5e3zlOWxrdH1WV7R4P+Axq4L4kNTKGUd3lArSsa67CRYFbSUq/w5+U2UnGeR0s/56IPZHkYyOTUsj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199015)(6916009)(36916002)(558084003)(4326008)(8676002)(8936002)(5660300002)(41300700001)(316002)(66476007)(66556008)(66946007)(38100700002)(6666004)(478600001)(6486002)(86362001)(6512007)(26005)(186003)(6506007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zI1WS0VpDKEQB1HsuNc8PWHqnbuy23JcHSSRrKMzq/mpbVXSLxGhzmzRt027?=
 =?us-ascii?Q?ztUNhmN85EvLy+SO4vOg+w7h+Yr7PJb1BcpMgNR9Gbsp2l0vl3mB/kgkj0Ck?=
 =?us-ascii?Q?7JihTvS4Abagri/qKcSKZpVhn6kglRvLgNiOqH4+fV//RKOn5cQtbFIy8OSE?=
 =?us-ascii?Q?R5iO6de7/FZEiSlVhVpx6i0GhkxEj5kOQ9wwXhlGNDnOnpg4T/A7+Wk/97lM?=
 =?us-ascii?Q?Xjd4YtJVYZlufiKHXefmyL+95zKXpzsbSCD81mAFmK37tktLqWaU2dvan9pZ?=
 =?us-ascii?Q?VvVpb7F+egJM5XUScLUKsvKAJqmK0b3TqCSc3OobuqvDzMNO/k0UmHlOBXZn?=
 =?us-ascii?Q?Nl/E+1LxgPDLjU/WDhpA2la3tdLRicZu5g3NN2T8tDcEnIow+BjijtQgzhiP?=
 =?us-ascii?Q?TWeHacYYUpt1glqClRkOuYTXo5a7X0DVxgaCDDwlpYEN551ZEj1k3KTx8Ep4?=
 =?us-ascii?Q?MGCf8uQkxRP5pz1/3ZPfjBseKhStw7lR6My7lrIJRCKW+QBzBGs8cAQVfLkY?=
 =?us-ascii?Q?WnD29jVhRBDYkdvdyVFh13ZbrmuOp4Hi+MbGvTIcAz6avRpI/qOfkWIwS5Xa?=
 =?us-ascii?Q?XO1VjywyRWx/BKk46iuZ2Y0joO/qbtqs8B5QXpv+SGFc2WvAf0Qe1XyJ5dgP?=
 =?us-ascii?Q?5CRuh78sOZjsmcEGRHunKLNKjnuQzJxcvmKen8YRFPefqOI7pu/lH2PSS6UO?=
 =?us-ascii?Q?3OWZxAMoiBrtAt6q9XI2zIboSKSmGgygsqQ1gMdcyk63FLhwZCgh4oi4+P4R?=
 =?us-ascii?Q?mA+JnU1GBgGlPBjJIwyOiatBfrXoe/dRKgvjoRPN5zGIdu4mDvqX0JJh6d6d?=
 =?us-ascii?Q?ZqCrbp2lRHXhimWkWve6Uh6k3TZUMTowtp6MuiAc8rRqzSIx+YIR67KL1KAc?=
 =?us-ascii?Q?4B4tdqLqMJ+lrUpHYPQd3DcyotKhO8p+Mn0sjsJTYtgL8AOEcXokjL5OlF5f?=
 =?us-ascii?Q?O4DE6TnhrH78ErrK/3IhqcihFmZ1amylPJIKapeMNIfq1JlENB0QQ8LG/w8w?=
 =?us-ascii?Q?AQG2TWsGX5xmrk24czpgWjRU4CXFj9JafnaFbqTxNl9u/KwYLH8J63ugtNL3?=
 =?us-ascii?Q?5gN2vYIwvtzOceAs0J9s92klHIXAIFk4mEUuFED60eNzDcSW3oWv40xhvou0?=
 =?us-ascii?Q?FKyG4yG2vaovQJ5PNbWsl2b7zCyvI/dgsqX0QyX4F9NyQPqKP8aY77UJH0Cc?=
 =?us-ascii?Q?V2/VdriMO8F8SB5gbrKgn6oLXGbgBVxU5Kc1raSqQgrboBP1W4DfAkmecxaX?=
 =?us-ascii?Q?79WALAkJP0dfYgQJEc+pfg+bvXP/txKsPuFfn0mb4O8CYL6Ikq+e64hfO4yQ?=
 =?us-ascii?Q?F17CqFQIdIpSBsJQkREy1ylWlveqwQAdHuD8DPjDFbgymx89FDlfiNvTWCLX?=
 =?us-ascii?Q?z52IFcOwsKxIogdgBcMXoUmj3iKg3zIkFUuKmd1CpozwLlnx3YLQHNnXPhSc?=
 =?us-ascii?Q?qk6wXSz6dPn7klPSzzpQ+a+f7btVoOnf56Z5w3dP73LjKnsuDw0QofqZNpuK?=
 =?us-ascii?Q?9qMZj2H5KxVrNK4slJIuIq1F/t6rcEbqqmAxjgyBYJEst8JZL5zj96UTtTAN?=
 =?us-ascii?Q?O/QJo+huItu58aKRrzD0OLXFK/n2zxp2HWMHsLuCG8UFbovpI/aCSqwNA0nz?=
 =?us-ascii?Q?0A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?pgvzfL0rHXQTUfZZSxcBrs9Dv4VrX1LiWjWr/R0ywxUGIQQmGMy32giSt3uV?=
 =?us-ascii?Q?+uGA2wJuKRYonGE6K+XfaR2Fl/RstlQz3LXtANeD5230io8juZAxpkDS7QgT?=
 =?us-ascii?Q?FzTS2pqSnKZdgOHps8DcMqEXk5qW4459Hl/wOEZB84el01XOjiq77PRXkFiT?=
 =?us-ascii?Q?P2PY1eEO29dMlKCM66KFJqWWfTOXvXDJFs69ctaUEU52QI0+7golDCahYL+L?=
 =?us-ascii?Q?QCnVDHfGixqmd5/0IIxZYVrXzkkQDqp6bcVZyUSa4ZGupGhKiydE259Gy53e?=
 =?us-ascii?Q?w3vbfj6ss6lplmuMTUZFXUsFlirw2aYIwFQkCqouqxcBp5ueU+uCuHf2S6rV?=
 =?us-ascii?Q?u6RlvC3n/VNsOST6zpvImz/bpTJHZbW45qamjtousCjVwum2XXYyrseczMAk?=
 =?us-ascii?Q?1iotr/EHQ1K60V5Y3hvq94R3HLF6Bi7OhUm3O8fpiLnSw4iis/5DuLOzHwzt?=
 =?us-ascii?Q?t89bK5dPUid/HrAxGfq7MwRg/b0r4UEp0unuCH/J8/u0RZT5xcFE9lQPYHal?=
 =?us-ascii?Q?MT11avZ1tCF85IcHndJIoMS9vnREvgfNj1oSWdCHbxnH6EYH6lWBfJI+wtR4?=
 =?us-ascii?Q?aRBSbXXtCg3ig0eTN1wvkAwfJ9uzuW/Ug3wSoJ0Zka7IrGVggxflB3HYsRuY?=
 =?us-ascii?Q?75eJSZZT9Xe+yOnIQBJOPSvzu6XS6NuikgmjyDN27lS6/+MYo+nJ1jWh+eSC?=
 =?us-ascii?Q?PG10m3rf+x5JE29AvwgGRbnzcUzz+mw65kqF6Iyb6rDILjTXeUzCUCUQtj8T?=
 =?us-ascii?Q?mHckv8IOyM4gBrdFXgcQ6G8lTzK5sx3vbn9EzhaXM2YqEF/a+cqBJpwdh9pU?=
 =?us-ascii?Q?OGd3DdhbfbvyfnUVoA/6Ihu+Px8OWhv/c6XoEwsz96K0UL+G9S20WdDlX1MJ?=
 =?us-ascii?Q?jOnj9G55W676k1dKfCw5LHFdwUk/cTTzVhsbWWQYIaro8CQLjtby5rzGxmCe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 275730aa-dcaf-4d7e-bb9f-08dacf5381a0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 02:11:19.1781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BMEoHzmqySgGiKizIGelrRDmFhUlvztaqjFU1ZzNy0+4VDzMe3+tBuOz2bsJ/fm1/W4Xs70oD1HQq76wm/4a/O8VBmzuwUJJRW6bOgOHLWw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4544
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-26_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=757
 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211260014
X-Proofpoint-ORIG-GUID: wu2uI7t1PlDhoN4dnKM8gXXKuLvFRZEC
X-Proofpoint-GUID: wu2uI7t1PlDhoN4dnKM8gXXKuLvFRZEC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chanwoo,

> Change the same as the other code to return bool type.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
