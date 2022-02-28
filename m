Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94712C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 03:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiB1D3e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 22:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiB1D3c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 22:29:32 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81B64CD66;
        Sun, 27 Feb 2022 19:28:54 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21S2lOO6015409;
        Mon, 28 Feb 2022 03:28:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=qo8ai3Ci3rmmIEhyws1q3D9cdHeK94LpMdqhJ02dcb8=;
 b=RpJgxsBEX8mKCYFHeuQ7tvvHZGIgzQ0V8DlH0afyk0cUq76E/kq55OmUpEPixsh/Nvhf
 V8dvq4W5kTHyDVgVLZNwLDP95ypgnXLp3kh8qqmrJKl4+eEgLdc2vVB624cOB2xapQaH
 RVSV9yd3w6SCoY1VL9O4PwRWA/Zt6C0WyZULkZ/iHWM6kXi8UVl2oFJ4XRIHhtl34RKh
 Y+9gdTz+ZT3Ff6RLFIHW+r7GqNJXVBVKPtmVjecT1W0u0QETdd8dtwx4kE16d/9JixAC
 6ElvApmHjvOvH/Dg6yqeAKWibS1uaiMg/F3uORDccu0AIDcL1Ewz1wWhWeSGlEJ90NXf 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efc3aav0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:28:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21S3Fqov099849;
        Mon, 28 Feb 2022 03:28:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3030.oracle.com with ESMTP id 3ef9ausmtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:28:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fw9ztHd/Mdk7uS6A/G/pIYnEklahOC0z6J53XUNTHjT0FSEevg2vsU8NscXDEj3ktV0mipSg4560mYDGPBwA6nN8oiQX1g87/IgIsYPas0+KN0cLTRTqBvwOMPb3M0U+VwhdJi+qddKuGGdnanezZnE5x06e8jPNlDcccA240lCrWyEQh6mWACRwn0T54MqcxL8TlZTTQRrItOimWHUNExGnIKqUZkJ5dG+RBtlVpFk+q0lVALIHkor5bW668VMB1neDMAhc3cYaa73s82FEoPWP6DBlsHCOzyrY4XNqYuwo1sdzTz++uVXbRWn5KCVYInkGSBgCRZGtiDZclIgLmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qo8ai3Ci3rmmIEhyws1q3D9cdHeK94LpMdqhJ02dcb8=;
 b=ex4JplyzR1Zb/8q50bzYOonyX/p2+vY+5cDiojZBn+X+61/EnFhcCohQ+0gZzbjYQyAEVpjU69U+LUfbc7zaBV7evVTvm6wf3VCpHWAmj6MWHy/yxzrAzUeGXqabIS51EY5gft7zYdrKRrFMCdx5voudTqsljZfHZglmzEod91RhDD01TC0OaRwtY+SmIpOufyMC5CVIjkuMkmIL9kME5SA4uDp4tLDFeGaE47bzyu8Isi1RSdBgT8IkMmDK5WP6I/BPCATMdOE+qKPIyZslNv3rMoWJJETkKdsmHCsupe0JAtOV8UNEebXxBGhC8fDiXbPzpnD2cM+B69E41tdriQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qo8ai3Ci3rmmIEhyws1q3D9cdHeK94LpMdqhJ02dcb8=;
 b=KMN5XiqF954IJUCn4F2+UVS7mF0WOH2/vpCSUwAscpuznysEkz8eF+BjvyPnrMtObYQZMfOTgnKQCKZdj6TaNxCnL1++fKMOVv6m8EEONHyClOdrapUAzxynD51KP9duiRgvZBySDvjgGHlPKFRrVYbs2yb4NHb2rOdp/5yOaJQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM5PR10MB1371.namprd10.prod.outlook.com (2603:10b6:3:9::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.26; Mon, 28 Feb 2022 03:28:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0%6]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 03:28:47 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: remove struct scsi_request v2
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tucj656c.fsf@ca-mkp.ca.oracle.com>
References: <20220224175552.988286-1-hch@lst.de>
Date:   Sun, 27 Feb 2022 22:28:45 -0500
In-Reply-To: <20220224175552.988286-1-hch@lst.de> (Christoph Hellwig's message
        of "Thu, 24 Feb 2022 18:55:44 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:332::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c1528a8-298b-46bf-378c-08d9fa6a6e6a
X-MS-TrafficTypeDiagnostic: DM5PR10MB1371:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1371C55C451DCE8DF44D190B8E019@DM5PR10MB1371.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xcejaPdnaGjwSiHXknJSBSALyZb6d4Jgare5INZ0E60d4Z+VMP7K031t2yMiC3G6lQtAVERbzvCaHBz4GHfRxowa9V1Fl53z2P3tU74OZzGYe0kxNb2AbaX56g4saflplA0b1IgmRfC4QJQtJ9fbuRNSi+dvD23m4H/y81J3HWETtmsxoDv0HUOYGXAkhJ1tx2FhKs+76QDKYOt61px4YpzFzj6FbCCoY9RbJmfzL9gvZCKwP6JX9Iu6y1nDD9KWg/ivG0eDVguTyDmBuNTPppnbqLXv/xNSZQKhs1LgXfRfYABWgqkjbEJ2j6gkf+emgpvKHAfGv0OIHzlwlhGSH005GRZV0miewWoDMyzmCq7TFjKEgMZaAe+n5dywCvVwTiOIiClhKg9lpM8q3pxaUWb9EqknmmiK2vSzirfV7evn+/546d0izhN2ba7UJD5IdbluXwZkkpbZK7jMN2LGObXcblOs4IM6PpG2SoWfWksOEdHVNvELVE4IhGxexvlVm7iw57g4cnuBAZCSqpeKzVutdBPK85WLbM4rc03WhvVs94Q9FEaae/N+598ED1sWkf2V5hzRWNuFCApstlkXj1Q2LgBUYWvzTmvUOxpCNy3gDQ2/m5FzsyNvl5JyzOUiwlQU4m49gmI73agiRhLW/S/BGo8FiHC7roLUcPdsPMod88r/1mj8E+PIqCsDBoAGx8nAYHKCdVGyGBJ/TVEI2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(66476007)(6916009)(316002)(186003)(4744005)(38350700002)(38100700002)(6486002)(86362001)(8936002)(5660300002)(26005)(66946007)(508600001)(66556008)(6512007)(6506007)(52116002)(2906002)(36916002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?am+Pcghi5Usch8e0eqeo+/H38zwz1X7a6VwnAOigukMFRvjB7X98wKN3/iVR?=
 =?us-ascii?Q?Z4/Cmwvk2klsY6DjQ7NxAQCRXxeKD+LATxQVuAeHL2kbyY33qRO+l+Zmynn8?=
 =?us-ascii?Q?eGP1uD7xxNywECJ1gfHkDbf3fQysK0lFhQghgvRxqsa1vq//PiPsFielbSSw?=
 =?us-ascii?Q?0s2j0qwnjC5n4229Gd58J9ILBUc1X/zbDUmdb8ontLpy4f8xDsd5jkkGdTPM?=
 =?us-ascii?Q?MMrAtCbYZC6dL6q6wLvqfkxozm6S8ONFacRbc/0qt73MszcRMisB6vEbikp9?=
 =?us-ascii?Q?5XNNj6LHB+Zy1rCbcKLS/K2t+iKrVpQMo7uIzmN/4JJ2rFNr8aQ/uNku7DkK?=
 =?us-ascii?Q?QdeH/eSJvGrHz3UM8sICrkpisokk7wDFhQe4KTfQnw3B1UH0NW7QpFhYJ+XG?=
 =?us-ascii?Q?ZE/TNH0s2dTbV4PRt3kYfcSv5EKJz/zKxRLDTuXqnKkoACTxL+XfcQwwPQCl?=
 =?us-ascii?Q?LAV9S9098cx9QEIdszrqneuoSrYdgrlKCU2PrlZpEZsm8GwIEWR7oQKYJiCn?=
 =?us-ascii?Q?SFLFd7/CbK/VPMTDcNayTE6v4VGaJfBii5TuEBflOD+SpyXt+ZJ9zYFNsLd0?=
 =?us-ascii?Q?mkDj6NRKJvpR64ZTTVC/dgLqBLj8VdzDYc+inCL7g6FqYXmXbVMyuac0dzaf?=
 =?us-ascii?Q?WPXPJdd6yg04y+8/laOIp+E2tEGoHVUI5FvE7l521nV9zcSRoB3fK99SZVO8?=
 =?us-ascii?Q?tWk39rpaiuYdPrnRoh4foqqbu1N7EdgXWY1Cl/MM6c4GSg8ElwaHslBkGN6v?=
 =?us-ascii?Q?Xr9Abyh7x/Zp0wK2ndG2xOBMigJLfDAuCNzDZb6EsAsLMfq10vlo/z4bmEzX?=
 =?us-ascii?Q?HZOf2lrCXR0ENBcZN/eg92/Z25Rz6oMXHJEkFUQUMyJtuHOIkiQXfQl/bsLI?=
 =?us-ascii?Q?9s59h03SOPG5pi3hMcp6sC1VFJP0mI11tpIEqytu2DNS9i64BbbhF85gHkzv?=
 =?us-ascii?Q?1K7ELnvW4pPf7hrzoF2WACi5Y9to3mqd/hBkKK8JNw6Ee91gxSdu6RIMaJbv?=
 =?us-ascii?Q?+F1xPzIAgSdMF7bY9jaNv/l1dZKOcuJTxO4plbCSvhBRuvT08mISvh5yyDZG?=
 =?us-ascii?Q?vDHzjcfLBxBJbgXT8LUozEfiiPaacs6swh1uaSuceY4BOc47sQjdwf9YRlN0?=
 =?us-ascii?Q?ExSDsiIct8T2zRb4iRuAjqw9HDD7qknPYO7xGYFQsJm4DugGyLCOm3mS5wrn?=
 =?us-ascii?Q?7gVlbJ2O5xcgdW/yhwTmEIL5ffBAC4usTFhkyn5RyWX2R86e/JeU8wZaIK3U?=
 =?us-ascii?Q?yAyjrSkkfdrjrrdxBAh9gnYqz+8iKj6645vh04jd/VU7QiO45ijBQa17VSog?=
 =?us-ascii?Q?aCrralb1XcPAvXxzBE+ptYU/6W1DdsrgghKDcwpxXdOiT7TZzdGM2Tcx4fPL?=
 =?us-ascii?Q?xblXlT4sPrR4uwJfII+NZcZoRYZdh4x362joI9VaRqbTABynayQzYz6/bZV+?=
 =?us-ascii?Q?VpH3Nys5JOam0xiyfpcwRoEuOQUHT9vuZMS3I3zBCtsCD+CuSAbzDlJY4kPc?=
 =?us-ascii?Q?dFGS6MbHpH6Ik00VcbJpP37XVGrI25dLDclA07Q3MmkPAXbkmQ93yRFugmZg?=
 =?us-ascii?Q?79iFxB3CwY13n8DIXs8p4fdiB/Hnvj52LcD763QIKRyj0U5j4NN94UNLk4n8?=
 =?us-ascii?Q?/b6JR8iZShvCIZiDOvQDLe0ks6Ou1EL/tZTqV3tOfdmLwm+s76p6gKXDY010?=
 =?us-ascii?Q?oSZL8Cw9s54WNrXlGdFjnt4pUhU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c1528a8-298b-46bf-378c-08d9fa6a6e6a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 03:28:47.7755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ks17aP5bS3oujF9BrsZBa0240nvsPMACY7PXgOZKw+kCDAfuEOAUaHlRDfOP6tgM/jk4ko3eq8Ip/v87XxPMcVfRYYelPmtPUYJwpdLii44=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1371
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10271 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=777
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280019
X-Proofpoint-GUID: cthbPzLebC_XE8l11YGIMCEDjlAtiMIq
X-Proofpoint-ORIG-GUID: cthbPzLebC_XE8l11YGIMCEDjlAtiMIq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> with the recent removal of the REQ_OP_SCSI_{IN,OUT} based passthrough
> from non-scsi drivers, the need for the scsi_request structure went
> away as well.  As all submitters of SCSI passthrough requests are
> using the SCSI midlayer now they can just fill out the scsi_cmnd
> directly.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
