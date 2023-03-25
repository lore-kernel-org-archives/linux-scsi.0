Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECBEC6FD1C
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Mar 2023 01:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbjCYBVN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 21:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbjCYBVM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 21:21:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFC81A950
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 18:21:00 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32P1KGRP030469;
        Sat, 25 Mar 2023 01:20:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=qdKoLP/T24xkO2M/yBfs0v1jT9fVx6G3Gl520UAiuPw=;
 b=CzxcSIBvnccRo4LOrt/z0pO78gUsNKIZJlaE3lEBPVPQhQO5EaI8pNIRbqwLgMhnJfsx
 bn4/2VZfE7td9gvcoir1NUy6Rz8z91L2nAxGcrskefdawsQSjm+78JTsrTyIQH71sRTa
 8clgjKCeySL6kHnvtVBB7DUp51ebX9aDFC58Q1+2SxP0zkgh4C/CdCsxzsIb2NDnbhrj
 78o5jtbqWuFVD9AkoERIffVG3xB9Z75IGI3qLadwxf3+nEmGNewM53C9u1Ka+SR1hWxI
 YMmv9p34MpoQhzECLHjvPFfCI5opGRiMhrwGup+Q1CCQBnB9HJlLOOloj+Vdcduux2t/ ng== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phq6rg02y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Mar 2023 01:20:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OMdhfx001459;
        Sat, 25 Mar 2023 01:20:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk4phj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Mar 2023 01:20:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TjX75I6u3QQb552l/uNI1m6gt3cdg7qxzuux96+x8Ln5ci7uIsTbfF8XZyT8tPT0kCwXE4bjRf5DlncN2U/ioMHnY/B6LCgyoPZU8xWRbfRD9nhEL0V62C/GEMTX7J67DGFTC6//reScaalyefe6E6gNDwrJgdHR55fk078n04dW2uNGBQSgktgQRgJeYLTlzokuUipbS5Swi6pZDQXsZBeiKImOguvFhbSVoLrhH9NnFpkITpq9T/IL3wet74femgJmETRZTZNa79jnfhyLqbKneE2KpKQOmjDanJpXSDQb/Ugw4zMR8dkPlsc+ji1NJNx/3QaY4GOL3HN1QorfbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qdKoLP/T24xkO2M/yBfs0v1jT9fVx6G3Gl520UAiuPw=;
 b=kCcGbkQ/zlqWrZdD8W2E5NzxwXnVULUqr++YCboJ87gxBZGvtCmO6KFbRcxW4OOJkBopfsITJG7xDSHvK1+7ORfX7LWHzsF4N2SI2tADAng9fGDflr0n4r+Y5iynZOXg+mFe9ajRG53ohtze6UynsJXSsoivsT/V+EOjqtm/pXOCluLdqW368/nksQlpyXXzjSGHOCwSt7QxkakWCx6tToWodkOnwRYHG7fLdEETMhO7Vw2D1j6m/Od8w2601ffPMX8nNdf6j5ZxAVwMa6qK5wYLq6pgFMs1IpUlGk8PZqrEnAQMYkahxdw4NxgzzSO38139m+ZPXWozCnMxtb/beg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdKoLP/T24xkO2M/yBfs0v1jT9fVx6G3Gl520UAiuPw=;
 b=j6WaJVTt+PvI5Kf7dOL1dKaoeyWYJp5KFE9CPcBl/QSY9X7uUQLzd83G6NjrMYeety8ay+xZ0KNNXDidyoJmlb16PHJxnI7s4C8mwtKoYSmkCMi1bxguqCWe/s7uKi8YVoAMTEKKT6pLTlpcTBkU1VgwwBTsvz4IrtfX/SL/51U=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4823.namprd10.prod.outlook.com (2603:10b6:408:12d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sat, 25 Mar
 2023 01:20:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6178.038; Sat, 25 Mar 2023
 01:20:56 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Improves scsi_vpd_inquiry() checks
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wn35hbl3.fsf@ca-mkp.ca.oracle.com>
References: <20230322022211.116327-1-damien.lemoal@opensource.wdc.com>
Date:   Fri, 24 Mar 2023 21:20:50 -0400
In-Reply-To: <20230322022211.116327-1-damien.lemoal@opensource.wdc.com>
        (Damien Le Moal's message of "Wed, 22 Mar 2023 11:22:11 +0900")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0437.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4823:EE_
X-MS-Office365-Filtering-Correlation-Id: 965b41ea-28f2-4941-bff0-08db2ccf2f3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZB7M89ylG1shZGrLpicEHlP5m0uCeiJpMKGZFeu1bEvqGhWKcXj7EO8/nbARx/lFKasxF5ybRw1QIa5wznkG6wCWedx2PcAG2wLxu+HHhbQkrf52B0IWMK+6oUegKZ6V6jumQ7wRh0wT1e3xZWJocicI2CT9OSzJYc8RtOAfuRx9sB5kmpkPX3YiUhuEI+PgwumNsmLX93njCVdSB8jkrOBLq8YcEnMbPI2BK9815ySsRHl4ZtIiwX2fkQ07ea9pJahkrbulxgCVAgQTMRtm6raUixCaJDMJ3HQN2fcIf0fpiZZM6OwEvyOpdUaTXkmSlq+y55p1kiQMhMCzLH7oOjtsWoo8JIJCarrKsH0H3o5fQav1n5d7UNvd/XiMGAuJcm9s1gwEFcTAIW66zam4vMpJMwuD2b7KBW8PreuJiAnpQxMOyFQtId8JSe87Ygrs2vs2ximlFMzmsYnEKeubnSvpd6zyeVw/aU39BrdeDH5/SfiOxFl/ER2NoKkrjlWgcU3pqA0iAgpoVXroOspJSgDEFUNuRDU34h723iK66MM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199021)(966005)(41300700001)(4744005)(66946007)(4326008)(6916009)(8676002)(66476007)(66556008)(186003)(2906002)(6486002)(83380400001)(36916002)(5660300002)(6666004)(26005)(38100700002)(86362001)(8936002)(6512007)(6506007)(316002)(107886003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V5CDpV5Vd2++tL/+JDwsuNk2lr0XmkELpaMwUYhSl0N+/rq6gNig5qZVX54H?=
 =?us-ascii?Q?epYCcRzmDCLZQ6Ri69NuRu3FFgWKuaNXErUJEfai6491qHv9hsnaE0kFdB2b?=
 =?us-ascii?Q?ntbYrGGfOlO0s5A49+cu8u5M85+A50HVD9QPtU0RoJ5XzGzYWk+/NMSXafxL?=
 =?us-ascii?Q?a2NRifrf1I+c0rB0W2ByWhYJcFr0Yl4tBxL79qKbm9hzSDAKvi3SDfKjIMDX?=
 =?us-ascii?Q?cnpyaA2VICoJUpyLhaMAHCOOWTr3dfb5VsDEj5u5NozU0H+YqfveOEp9jhkR?=
 =?us-ascii?Q?LjGD1zeU/BETDVoQReKdlMwLKZLHCjc2O1AFQemZD+zx2fdZUf0SBKOHTe1C?=
 =?us-ascii?Q?l+Wq1znLVksaWBtz9DobU6XPGwtPNasHFrvca2+XlKWgoNc/F9OUjA8UyY1T?=
 =?us-ascii?Q?I+svSkQjusT3s0ROxLSxwPLL3RXgGuuxiPCMHk41zRIEPtDPxQ4gbRLnVFC0?=
 =?us-ascii?Q?g7+zTSIQcsa8OtKv0N70AkDvnCdh6CwEUl6nDWS1OLhvgFA2mhUACsFVy+hd?=
 =?us-ascii?Q?CDecKy7eIOhQHQN5qezerhri6sMMenMY6q2H4akFAlYObJOs6CkdowwchK53?=
 =?us-ascii?Q?mQ7WJtuxuNt5cT3NAL3AO6yQiG2jkHlN5FjBL6XaawJDB5KLXfLObe0l5pgm?=
 =?us-ascii?Q?hjCHpZ7HcwcLhgq9Uk2SKzCu+jmYlIFRZvbGCKREfdlHx0fERhnw2Lm0HwoI?=
 =?us-ascii?Q?oyIam+1uZtHmbu3L6FAV6rx88vt+8dM/1xL6y0+AwX7V6stoRryTPA0SZNc4?=
 =?us-ascii?Q?iULBMafbzUeMapkxcg/wUgenFoYGg9HAaSHwBbQoOlt9AN6HAli5vrRDlkIm?=
 =?us-ascii?Q?em6t8JONziT/x5RGGvmUlNL6ycQbaHYOixFs+5nOoMPh/YTJ99OdVini/hhO?=
 =?us-ascii?Q?4zIvHHMzu5MlxCq8eAX9KItOSdnDKcEKcvatZ1IB+SWREvekyaQIrbxaDoea?=
 =?us-ascii?Q?XzkKp1zEr3ea13mStKO9d3bjeOWzupCnehnpDbgVmZwSE5t1Bc1VwI7Yrabu?=
 =?us-ascii?Q?aEv+B4DEXyHRZXrP+QzZTNd4jP5ntAVxrvHNIktmdiNGxS17fbURiP5vwhy8?=
 =?us-ascii?Q?dYM3tTiK67EH+4XIAnOMoJzpWGqHb1uwDyk0Rr5NpEX/m20ewUIKzF4b52lY?=
 =?us-ascii?Q?6JIPt+RXmvfQ7UY1AVRiRemC7eUWKIjTwBImFL3Sr63pYyZEP/wC7Y1hsf0w?=
 =?us-ascii?Q?sCLNOagVQyPDXyjgCj7JGfFqUWJKo8b3aOFfAtHBX6uOmmfVyEALpl4etJa1?=
 =?us-ascii?Q?GmGjJdRJ/xPBoo+ceeTO/cdXJzCv/pS+s82eHFeZ969PRHXTkzymFWBWxdTW?=
 =?us-ascii?Q?qssDvBh2Pog1tFOLLIBRSATGXW6OpQ1KvuJG+ub/9nbmDSM//ggrGHQ9M8BR?=
 =?us-ascii?Q?wOYdV0gE2II5rk87vOz/p3n2Ta25HPNj+F0i26wEHmRfvrVyfjNxj2MF3Mf8?=
 =?us-ascii?Q?Mkm0iuzOKuiK1X7khySblM6kKU5+H/RdyFpGDIIliuKfkcVSDvZGLqK1ovSc?=
 =?us-ascii?Q?wus/iyqov114+siSY0Nk4UeI+G9X09bmz67hXIwfALUiSsFs0Bjk3QnhxHD5?=
 =?us-ascii?Q?jbYBt8GwlssdxoHgGdTTF4kQGVIjXyiYlSTn6l4JPa970f5mHqcW++LBqS82?=
 =?us-ascii?Q?+g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SDzmitTIdnUT7i1C/lcs88JQndQbpSaatdC9bSC7j9Y64SN3B1Rz2V1fsBriiUd+2Dogmuv0Fm1uFNTa6E5ikkQ5kjnwmiQv+k5YZNKR3sFER7O8G6M9wF9+jTSZQbEqLSWzjIZ1qWFCQgdyNbOeytCHnoUS2fOQTavdKNs2gPe23F1dt08W10kNNlCop3hQPq0TJ6BmRb9Jj9zk9WOvvbc6X1VzbtCnRYVJ20w+Flx+uAjL1X49Ij23rPoKcl4i8zg21f6vAkAHt2GJE++ngRClUsmURbt2PbXC4NfhjPW9HMyXePp0Oq0BGSKTeI3FRAZ1PcB89NUd7wPPVZMExUmET5I70nvg86D3pWtensOazNYtL047OhJb31uwatRhAI7MYn3MztX8P00ePu3uKlK/6i+QJSJk/uB15OrVOxuEatecFBVfJ613twvhqr5FKk7Ot3gHnke+j31LTGe/yuS2yZOYipPwz0FV6JJZrKZuSfBojvzaCEhda0oXjuc1wiLzKYKp57lXL3V5j4pDvC5v8biGUNxikyTsbHEgPongt3ykr5i8eA65b0u5lH/cNqxGZuAWpGPtiB/xVXVoGuVnVT1w3cX7IZ+oxKXaeZpEFEEMKhHtp9ufH2/LgR6885a5F/Ew2c5strmC6Nxa8x3fEBJQesOG5VBIoODIa9qaW7HtOJZy4H9FO+2gbaivVhvGS7yXO4BQrpIbBlUehBOPssAp0aDUadVMvvPdKJDsJsou0IXBYr5umW29kWvGwht0lF7ferGQU7knr2sL74dAjJdUPsv1wjvt1fznEfQKux7Ruu+k/+A1W6jOWs/P
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 965b41ea-28f2-4941-bff0-08db2ccf2f3d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 01:20:56.7047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uSwKZaee/smGxwrrIhcJS8ogmUeR5FUPpPElrTkm0gtRR21RmF9uBPcIvGV0QhkmQ1Rv3IUdWnMzYqhYzseHDIJshvKb1FtSfNEAjCIrlFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4823
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=796 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303250008
X-Proofpoint-GUID: vEJ1raaMYTaQFG60m-68LMbcB5iA4pQI
X-Proofpoint-ORIG-GUID: vEJ1raaMYTaQFG60m-68LMbcB5iA4pQI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Some USB-SATA adapters have a broken behavior when a non supported VPD
> page is probed: depending on the VPD page number, a 4 byte header with a
> valid VPD page number but with a 0 lenghth is returned. Currently,
> scsi_vpd_inquiry() only checks that the page number is valid to
> determine if the page is supported, which results in VPD page users
> receiving only the 4 B header for the non existent page. This error
> manifests itself very often with page 0xb9 for the concurrent
> Positioning Ranges detection done by sd_read_cpr(), resulting in the
> error message:

Applied to 6.3/scsi-fixes, thanks!

[1/1] scsi: core: Improve scsi_vpd_inquiry() checks
      https://git.kernel.org/mkp/scsi/c/f0aa59a33d2a

-- 
Martin K. Petersen	Oracle Linux Engineering
