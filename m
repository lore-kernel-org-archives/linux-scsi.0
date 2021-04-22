Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D212C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 03:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9A01613BA
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 03:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbhDVDfv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 23:35:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59502 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhDVDfk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 23:35:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M2o2xY077639;
        Thu, 22 Apr 2021 03:34:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=LiSa1tl8GZTJVx2I+hBY7MNgVTGTTG6rUTkUjMs8Cy0=;
 b=MgDaSvWvSBGZjmpiUtxJu3gscpkKCQBcCJxDhtsEns0InC9QvgS5H43XbnyeAMyODz6L
 y1RsHO+xGM9onsod92cCKwdC5WGNAs17iEiiW0W52VJ84qJkB1r74FQ/ZWnGwtZlJpzE
 wImYRacuaj3/FB7PLm9P9fA/0rmmEYxC4C2sX/CaavEdxuYNI3WINig+O9bNqXGq4IN3
 iV8UGjtVb21WvCDsdbJXuL1Pmb2bvRjm+UUy9XNqwyHHb2t4Ps88IE3VbFLQiPlt6rSd
 KVmgmZcRGT8zlUN3nGkHEfCV8ch+lMJm3kpXUT3s3gE8WVLCaDdHw5IqGtUhPnb8NVyT gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38022y3dq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 03:34:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M3V2tP082783;
        Thu, 22 Apr 2021 03:34:55 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by aserp3030.oracle.com with ESMTP id 383005t3u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 03:34:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrXHBxhT+wiP2BfwS7vzaSBRmeaKCMdLBqqZtR5LBC20IYnFZcbumbdhiqpLOd8jPUKKQAHEEJsjZ2Y2ll7FIuue80bXp9MPHWs4grBzsGGzU0RWEHanW5m9xaTIBEXdXLlHgWf98nfJg3PBZVTNda3s+3s9ZIEiNIYNawXan/eaLjx2qTWa4riWdeNV7Ll+dvS1lW5wAWhPY1/cImygopeV5yzS6fJVo+4i1JEt83PLlP34XeQQ8oDhg3KlOc0s2LU2yEzfCMzbx2YPndogr2ojpkarGVbEKgMX/Oc6UlBr3eBT4NHAi9AAGtd9BWTKY3JQdRLQLrnTO1CweRbxnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LiSa1tl8GZTJVx2I+hBY7MNgVTGTTG6rUTkUjMs8Cy0=;
 b=ioYRT2Rmm9yPf5LJ+PuvGH8iVdlrI/0HhbHXIyg1k73V+xTvyBtowhF2Ik2wM5AAYyQC2tj6EzM39mLSoTZB0I5RTXZJpGlI5rfP+BqIs6fg3z+CC1fnU7z8WkE2U7euBlJWupMK+iw72DNEm4Q+mPnelWxeBhsPwOD9JOmVxEjB1WAsqVB73Ff4Nij5UaBPDu4JHCIqkqbd2RTHKjwxT3pLJgUmYPPn9YIICCQQ4wCfKv9WsETwwOqT5APlrTQvBxDNpFVEz1F4Ko9VIW4EPHOPsA8SDtbRavES+pzdJHlYMpG/TuZ+1dQPVS2N/MNTi1tv7Ye46m39DWpSowflPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LiSa1tl8GZTJVx2I+hBY7MNgVTGTTG6rUTkUjMs8Cy0=;
 b=sBaKizTLQFyrJSkd8PDVBp+VEYffwZN/l2B2iU19lG012rZ4JCEk/klaqRlkQK7RQK0SBJF9uLtSlQyrvg7HGeqjJoP6ZrjhVM49tPANWQQXA71KlrlvPlMDQepQORMLcHKMNduFBHfWWy23zCrC1bUKHF3PXv24cNFni+NTgF4=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4487.namprd10.prod.outlook.com (2603:10b6:510:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 22 Apr
 2021 03:34:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 03:34:54 +0000
To:     Kees Cook <keescook@chromium.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3][next] scsi: aacraid: Replace one-element array with
 flexible-array member
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgxrrodw.fsf@ca-mkp.ca.oracle.com>
References: <20210421185611.GA105224@embeddedor>
        <yq18s5bt42e.fsf@ca-mkp.ca.oracle.com>
        <202104212019.4315F80C@keescook>
Date:   Wed, 21 Apr 2021 23:34:51 -0400
In-Reply-To: <202104212019.4315F80C@keescook> (Kees Cook's message of "Wed, 21
        Apr 2021 20:20:51 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY5PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR04CA0015.namprd04.prod.outlook.com (2603:10b6:a03:1d0::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Thu, 22 Apr 2021 03:34:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b93a843-8628-4f00-99e7-08d9053f97f6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4487:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4487FDA63E4A31701A3D9F9A8E469@PH0PR10MB4487.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TRFT3NW2qUcVEmbEQ9tnauMER2nXp4fduZNGWlZr8FiKltOedQZh59urimoCr5CCQ43T5BKr+dvywktmq55xZxLYQ9i7iMbQrg+bSJ2p64W8wAXIukH5w/wtZRQY8D5EcMgmrmsB+ysj2lWlN+ZG91CtnD6gHUEtn4qTdZ/dP5il7NQrO6G+SCGATo7HCvDFGMRpv+VL4fYjUW3DaAhdGFXSCUFuHJl7Z82wZBw3UrdmlTSWL3f4WL1rqRlXpSse/8wgOW6g0974CuCDXjo0W4Rgtt5NrPk6R6CJqqGDftR/xoM8rlSFLYnBnrWUx+MOrnZTu3NyziScEY3wQmDRjgMQup2jcX4YOYLI8fKVjkMEvSKBkLybBxapShlgNk97qPKRS4ffVTa+CRgf8yf+3QYl4oLEsMIy+BXNhJKMgf075kh5Di7cAeriUmYXjxlU5LEtWqx05hNDXccOf4e+RrlNJKfs9yqjanKBW2hO9SqriZt+Tme8yRRAzI/EZ14Z4PPDPBaE2ozMPPCSH1d2W5pvIp8y0L3zzdYTm2NnyhZ+ql5/YlQwLGmGiQVCVDRGWsgM1TGp1CjEWwqwU2j3k6ph9zg2IJKz7sdmFe3FhLXBI3FoXhtejo899tklDKDHK149JErrnfzDx4K0Cu91XIdJq0fwXMZ+hET5u4uW2hg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(66476007)(478600001)(52116002)(8936002)(186003)(5660300002)(36916002)(6916009)(86362001)(8676002)(4744005)(316002)(16526019)(26005)(66946007)(55016002)(38350700002)(7696005)(4326008)(38100700002)(2906002)(66556008)(956004)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tdkFGvMcxY6bAwqdX2zY6AgI2T83fTlwKiMoLQ5E/knFWgMCSPKNfQ1CNnzF?=
 =?us-ascii?Q?wkLZ0oYbbhQB9qqjZHKDqqmDqFg4mVdjiiZDmhWKcsIrcvi8G8y55+do3Uag?=
 =?us-ascii?Q?u0NYuslzBflC2z1uDeFr0i/P3Nr1LOjahhaliaeH1yCCOowqQyHFzBqr3b+C?=
 =?us-ascii?Q?B9eYqm3Eaf1z1f69SXnvP9+Cw9qBo0NK11C1mNcLdY2pI9A5g1VcMkYaETJs?=
 =?us-ascii?Q?vroi8Tp0Euo9JIQ3cEJ9ZrVPISCY2Sc3og0PsFAkjUgSjjFgwS0TDKsYnXXg?=
 =?us-ascii?Q?vZFidM3Obm/vNmdR5s06rmS/e5oVHl0K7BnvsZp5G7ZNnZlXMWNO89U3bhja?=
 =?us-ascii?Q?Pd4aiI1Da6U4B19tvbSWRuVU9e++fv24TvoWkWPNO3Jwt0fsly+CvsF+a8Ht?=
 =?us-ascii?Q?a4qYrGJSv8WnBXINKYQPt57yZbujRKDhMgyAm8VD+oPkehgSPS7lpr0A9FsW?=
 =?us-ascii?Q?BdIMXxOxjzxOQasL3Dhjkt/o2iKjXFiH/jQ6QhE6mdP2FR83Wx/y1WFeiDsI?=
 =?us-ascii?Q?ZpoBzWb8LnPdYosu702gThg4uazyGAqw0criTP4+Mh+JiRSR2jQkN/D96g9Y?=
 =?us-ascii?Q?EevtPaJ13VGpSwoQ3PMudvIxINkOmY0eDDXJX0Fe3j5sdTv6aFew/0m8LS5s?=
 =?us-ascii?Q?F/qNZbVWAvqP+gIBTmWvfpD56TYVflX0bvL9aZMNehSWGxfwqzxMB7DiPWYn?=
 =?us-ascii?Q?uiYJE2UmWrrIu06HeZKAEuAoEFTR2UwyWh1AEZBzjyJanRRtiNRieHwkxCPN?=
 =?us-ascii?Q?3GyObuN0+n/k5YRbfo2up0PyduyZ6a+s5BVGnQ9UOe5emGdhkfC1b3iWTDkv?=
 =?us-ascii?Q?jxiCo2aSXOeNMjPByRZxfvkKw0LjoIcHqf+d1fFmHpbFmwQmCpSRSjF6w7pZ?=
 =?us-ascii?Q?Z1qPlhegbw2+Qxcd+1AndjdiBDxGV6M69lZ/N9DIX+l5NXvP0lu2GtWsCrT0?=
 =?us-ascii?Q?JqT3PbSA8/ysLvM8JJmIOitEJPDvS2B1GSei4AjExy1jbFmmyLtqgI4Nqp0X?=
 =?us-ascii?Q?gvGGlec4NXzoLgseBJhYHOIUWQMMlUtdczT2tNRgmQJi5CBroUUP20RBO9Cj?=
 =?us-ascii?Q?0tDIseEE2uWdUAfJ6j5sBsLKbeYV166cKGn5alLbQu5zveg0W+9D4BS6Wc+6?=
 =?us-ascii?Q?RQR+ABtHNd6gKv83LVbLfqElnePRWtL42rimX0W+QjV+gg/nHHeAMevG1UKg?=
 =?us-ascii?Q?L7e1aLPtq16Ehx88GbTJ7z+cK1FjAiPqTnvJIgyqrBv7GwKn3vogSf9BFvnw?=
 =?us-ascii?Q?serZzuYoe5xENljKbJr20YgdBbqQkaD15dzY4y51XfxC3ciUMkZoxzj+6/y8?=
 =?us-ascii?Q?J51X5XfRlqgfT7WHxLgQdb4m?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b93a843-8628-4f00-99e7-08d9053f97f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 03:34:54.1001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mWcOkROqu990S7N0PUzhBsaDeEj7uu7DzI8ZkaNftjXgAzhzNljTbcCbFtvhLokIVVh4qa8SmJYO1jXwYud5KJD17yihLLQDxzWW2SCMiRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4487
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=832 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220030
X-Proofpoint-ORIG-GUID: 75qYnz9yuYGe3o0o4M6eo96HFPV695rf
X-Proofpoint-GUID: 75qYnz9yuYGe3o0o4M6eo96HFPV695rf
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kees,

>> The amended memcpy() hunk appears to be missing from the v3 patch.
>
> It's unchanged from the perspective of the original code. (i.e. there's
> no need to change it since that memcpy isn't involved in anything
> changed by the swapping to the flexible array.)

Ah, I was under the impression that you intended to do sizeof(*sge) to
match the kmalloc_array() above.

-- 
Martin K. Petersen	Oracle Linux Engineering
