Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC797C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Oct 2022 09:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJAJrh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Oct 2022 05:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJAJr3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Oct 2022 05:47:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413FE48C8B
        for <linux-scsi@vger.kernel.org>; Sat,  1 Oct 2022 02:47:29 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2919O6rm019200;
        Sat, 1 Oct 2022 09:47:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=2CCGBgPIKfRyfL1GmdnhP6eCF2Wwqi9xMyXB2sN2Nxg=;
 b=Mp/KTF0QDo4g/lqvEylfYCSLd2yRpmnfRadsfgF0MUhLNouR6aqqbTtDjbRoQzjpSJ0M
 PTRGq/NYg6RbBPsssALqFfYipmZROywXTUTmm/2f0RSu7xUsBP7qYWSRD1EufLB+HBJb
 PlDF6myMOlCfSCsSaua+IcPEHtRhHGTbubnSPAZfQqt/S1zCazRUcveKk7U4Kp+CNAQL
 csKm3QLLAcxK054Kq3qiQjOBahZNoNqNt0K1mI2VvEIj86DLEcsn48EZc4mDICTDyg6t
 ziW2qzI+M8R0ouS+awSf7xcGd4iN/IGRRIPpjDAyZ9xxG26TFUYbKGxJcER56xG4kfcJ EA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc51rgh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:47:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2918v1vT003349;
        Sat, 1 Oct 2022 09:47:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc07pcjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:47:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vw+t88kx+4pAz05bwxVQUdOWzAUevS4iHmBXHYqPDiA3kaemsAqprq9Ajbx/OHfcJGjOxO6YxMDadkgcB6TmU2r9GCWebfyJw0w5fzrdqVOS4Egj7oADiIhUUXaBQF8OYF0S+pu1I4x8DFPA+GEzowKs3nviRglrzVa1ChcK9/P5a5sdT7zrVsB+s0dR7Osn+qP2K+cc6M7G4L89GYvb8v9UzGia9pBIcsHphLIW3mdARjKTV/807RvlZG6dUelmAnvTyJNyXBgGmBaBfTfYALxHOMW2Owe/DBYF5gcvA1hDHUT+2vxNGHdA/jbZidvVOGYpZE8BQBMs9hyTFo7yFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CCGBgPIKfRyfL1GmdnhP6eCF2Wwqi9xMyXB2sN2Nxg=;
 b=FK5yh62TJknZkz8+arzAFxsXErsXTphIipN5wzKsC+3LHrc5oybrVWcEzoYCgodwqN6tZJwZdOQP/5lVGatFw3AwEjuKzvq7R8Zu1vMwHyoLQGbq481aAA2gSgRiGEMKrmMWw6x2u8/LmFqoJUFCV5CbZHX48PrjJPaZhmUSiiyF51qm1OQO/rIXe83xyYfu8ygH/Ce6ikyjXTfkTr5ti/hTyiydkRog/2Xblm1fxgD+EkV5+vSNCzGCDHRHlr7KdPVCvL7XcZHiopL8mLCUn/vC0usCCkYAH0FOekaVzkdmz3kKDTuEDweOgk1zwWbdzXunwV5kl1nmb3GUTRBgaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CCGBgPIKfRyfL1GmdnhP6eCF2Wwqi9xMyXB2sN2Nxg=;
 b=py9wnQGsBcocZKKqXRB8GnRJy2nkxz/cDy7cdtEGRReJ1BhYIlk+IlzTcN0BY8eNaA1tJkE/4GGjziRMFKsnPR9hqttC/ylz9LrzOPkyaz8LEKg09VGqXGt9mosVKR03xGyH6sFiDwCiSl8ilabG5yeTsK3upyG86flq9UzjJdU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB6616.namprd10.prod.outlook.com (2603:10b6:806:2b6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:47:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%6]) with mapi id 15.20.5676.023; Sat, 1 Oct 2022
 09:47:19 +0000
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/5] scsi: Define the COMPLETED sense key
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0zrkhbg.fsf@ca-mkp.ca.oracle.com>
References: <20220926205257.601750-1-Niklas.Cassel@wdc.com>
        <20220926205257.601750-2-Niklas.Cassel@wdc.com>
Date:   Sat, 01 Oct 2022 05:47:17 -0400
In-Reply-To: <20220926205257.601750-2-Niklas.Cassel@wdc.com> (Niklas Cassel's
        message of "Mon, 26 Sep 2022 20:53:05 +0000")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0335.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB6616:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a126180-0115-48d1-a10d-08daa391ee81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V8jJ7zBgDJCRKp4TuoMq+b7uY8FA/gBVJ9MfKnqe7Y8YlQHF16DQMBFKDrCocELt31IH4HQ66km+rQO+r7tmZnVNf7lhmS2gT0x8diANRnPkehs3rW+0HPUMHPNQWS05i8hBDBbQs6eo4wbP0X1MLdj4cq5Xsww4D5IsA8hv+1n4H2f3jHZIOmCxBakkVx412EtLxyC9Y4DLc5+bevR1qypjxh9OsHmt5Z+tnozLO2ohxUdX6PDil0o2SqX4qwGbUsAv22NSU8EVqRMn4zAxvY2xCDPrBkmdfXZA+lR83dU5JRqpbJgvEqWtDig7nqTXhhUIiZ/k26SKbTVVJmoL4R6lxqJoq1Gvpmx3sDmjOxjwbh6kHBQBB7NOhH5JuNnT2pVloWX9rglRAwKHWlwo7akbw1FEzF6PWokJhhWFtQWyMFj7zKM3JTstvlmGtAmQqels0qc8HHolox5wfO0ke4Z8Uj4Tcao2W6F+A+VIVwyLQUGMnrETdwe2F3HGCvyRCfUML8/XfQG7RxcGim3TxJ63+qZb43ff7j1jXTv5jmP09BTKGSYR4bAdNvPgqWw0BGL+4rS3oG6tw/aYxSTuIJy6dSO88WQth/TnDNmYs1VewwQ1Hbh9rcRjR3Qbsbyji29VdhESCcyld/lfaB59CbjpmbE7KQlz15wZmqEj+8LnWlp6a/ejjS8l9JUHKMjyaE6qMQA/BV/NWHtf+2BC9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199015)(6486002)(6916009)(54906003)(478600001)(316002)(41300700001)(8676002)(66946007)(66556008)(66476007)(5660300002)(4326008)(36916002)(38100700002)(6506007)(8936002)(4744005)(6512007)(186003)(2906002)(26005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BgJKK9lNRzwImzt+bxi0A3HVkkbtoTtcHnFJdVSJPKLOguH53UjlbfmsiyLw?=
 =?us-ascii?Q?O5CDBijvKzqfK2xncTbi1NjoL4DxmRYCHaDgo2FlpOH0dLRfHPXbVHVJTY+K?=
 =?us-ascii?Q?K8CBQWusa/4mxRPNH61pgmJ1pUgS+WajDf8kz8CUhXklO/1cXjhGZ9QUsCnr?=
 =?us-ascii?Q?PEiD5/QLWPkctbeNmnQsJU9RjDTsl7qc0ZJqIIMNYLjFeWecVoBfGYVdV5C/?=
 =?us-ascii?Q?WBKcd6eM9ekYhSZid3fJ4ntMWUv90NXMbNuCiKDT2w6o2845+xCUnzBlO8xa?=
 =?us-ascii?Q?ACBXeK7WkObOo0iZiwtglaKOdH0GsSN3Ynkro5xe7hCsNRKAJEoIIZT3+KLn?=
 =?us-ascii?Q?I+FaLL57Z7kgOq0j292LB0VyHGNBikNA2ZZY7rXNP7DSQTEKJBGRw8SchLKg?=
 =?us-ascii?Q?lC480BBeLJlVpWIHiAaqMgMdW0kJbwah4TQRRdLfTfrQK6FVOGTH0OyXAY1A?=
 =?us-ascii?Q?ASlllpmmaAgnT/HZjAzJqP7W7Q8LcUNqQ4854tT7scVnI3UUbwEisaQXJdc9?=
 =?us-ascii?Q?BlwZuWft2Kic4mnLjNhFZ6GKEhjPhCW0/pH7awnLXnKs07Mch8TLCz4ySgoK?=
 =?us-ascii?Q?YFgigEqo13iagBrt9Mcmu/zZeRzTxX9qooIm8ICOSWHouJmz383hhs+4WwQ0?=
 =?us-ascii?Q?0miX1XZwMXXFxJW467YnapzLphYbUbG+LhXU3lg3rT0y3ScWTBpAL4BqtqRX?=
 =?us-ascii?Q?qwbFePn65Lks8KvSfR4YW9RyY+2owVyAUup38onea4sz2gHVs2mjalpTiT9W?=
 =?us-ascii?Q?sxsOu1+1VNfS/pTKRsFpG089bcxw5DA25t6vFetb55nG+b3x9mAtfQm5XDY3?=
 =?us-ascii?Q?UTvUxpOII1NkJI09NS72TiGFFcaGbqQYpcwbkMZeWcmvpLNM4gRYyHQV1vQJ?=
 =?us-ascii?Q?11N3IbonGJUyqXEkuhsLBvFqjHe3VeW2uAtpuOQ08Ev1wmWVrSM8h0jLxuYU?=
 =?us-ascii?Q?D9ZVL2uEEtVDDd0IbyOyVqpteRl+HYOuG+F7zWwmJAiMg4sQVj8p1Zzt11T9?=
 =?us-ascii?Q?h9/QK0VgaJPW/bLVVkURVYcZT6A2nMpzq9+4UMhzXoIGYsO0KIqeFSb/TmAs?=
 =?us-ascii?Q?k39DDIdhEOAoOLdYWG2Hd81XSwAzW22KLAEr+3ate7DIpDZUJxfm6eThc7Cj?=
 =?us-ascii?Q?WyGRfz+pJ80YUphrEQl4O0YbPnMsrBYVMm+MdZEvZ1o0U1x0v2/sPWqNDxoq?=
 =?us-ascii?Q?EeXqicpxuSwMQms/AmPduncf5QMS6iQ65y2sounM+F3VWC+uY72CNUIgEhSD?=
 =?us-ascii?Q?KgLp1fgQ8VWi/Fc4sZWSFUL1mDYFFRfZisgNVijYgKeEBeFqavdrQenvBjXB?=
 =?us-ascii?Q?SdfYe/OYjVJEFH+x0Xk1rzWIv+dOiFkj3dw8RQ/XXq9ka6X6+JrGCGY8/djt?=
 =?us-ascii?Q?WOkhzqUFjCH+mHjiRdf2rbQvxJ03psx6qJVLDSnj5HgY8N58LNZcS5PY/DQZ?=
 =?us-ascii?Q?ufTBtfkKIOAyshDot+HLL+7uTpqneotiFxsFEK+w1hZ4f2tGAwBOeQHCI5iy?=
 =?us-ascii?Q?IRJ1UvNgXI32ZKxi5XxyQ5v2DC3KXyP3GXHtG+7uoZT16ktutKPHT+XVfTyA?=
 =?us-ascii?Q?mW8LRGWVIIU3LZU8WmeeVt7MSYa8Uth5Z4r96txPVzLUcrt12Jud+SDCGadg?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a126180-0115-48d1-a10d-08daa391ee81
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:47:19.4341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1uQ4cfLcWSY6oF91f5Qymji3uZUCa8AbMw+2Dng/ftRuOqTJ859vSgFTgkBgXP/4LKgSVSHxwaHR+m8J98fdIbc62K07kMwFaoYk3VwMrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-01_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210010061
X-Proofpoint-GUID: 28O0hpL3Wv04Eobib1xrvKaFCgg_m4_q
X-Proofpoint-ORIG-GUID: 28O0hpL3Wv04Eobib1xrvKaFCgg_m4_q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Niklas,

I'll just ACK this change so it can go through ATA with the rest of the
series.

> Add the definition for the COMPLETED sense key in scsi_proto.h. While
> at it, cleanup the white lines around the sense keys macro
> definitions.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
