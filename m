Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060BAC19F2C
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 23:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbiHAXua (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 19:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiHAXu2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 19:50:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A237667;
        Mon,  1 Aug 2022 16:50:27 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271No9wP001956;
        Mon, 1 Aug 2022 23:50:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=FJK4sg8/lpRahy+TnGBFmH/Uzs2yQVQMEb7ckc3ECAM=;
 b=lHAzY8eLTDoOpmnl8mWTjtBncCTebr4WEZjonAoG340fhJYSjreIxL8kD/KiAFIyWqw6
 UmVGUs8wnLcqVzaIx49i0l+6IbZqjbkrVo4v+xb8Tis/27v+udPI9WXYR3eCJrYYPjOs
 Wu9gUr7fVaQna/HDJvXXcAjqMJ4C78AH3pjr/40bgRxMta5cYSh3PgLrDP6us8bnyGoD
 H4ps5ltWdGsSe07SpV03RsPvqnMmyEd/BqFLW+h5eqH8dE8c3lLpXdawjy41z/cdVBax
 hj0RRuJg6Qci/AU4bXSFZVJ9qjBaFPePZF25egTSQp86bWa+7ViUOVJaib0s8bMXDdf5 PQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmvh9n43h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 23:50:26 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271M0W58014203;
        Mon, 1 Aug 2022 23:50:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu31t139-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 23:50:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcrKBJN/PbrapTxW5n989M6+VKKbIt8uyZMRIjq5sfIFykAmRZRVO/mLQRVH5Gdyf3dHibGdUeNZ6UIQQ9ZnU+K30vUqXtcPMhrU8JAvdwBG0PMByIq/WTDKZYBoKnZBCxLRe2hQASHBHzZ67FT7qpBxQlJiX942Rz1fcv65ASiKKrI/GIdauBhGaMTF5hK49JwwUPYgDE3Abz8O1YUbCYo1V58E7QWS5trgMqtah0dz+dSdYHO7FmTQlRELYCyXY9BDevSt3+BIFqtAZWZThCnwpODmqATDvauTlYOWcvBoDYpw7kRvPJ9Wxloyywviwfr71aypCfoH3APD8pETog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJK4sg8/lpRahy+TnGBFmH/Uzs2yQVQMEb7ckc3ECAM=;
 b=j66Vl6BS4s+CYnuTPfLKaeEUdkXDuQeye79+nNafZiIxYb3k8bFAjyYgkGszkhx0P9VANYZbPiuzeqG43H2ewmer1O7HTxBwOWE0NJKJyyveTfQRdgPMIFh5q281XYD/6Fx3EK91vuJb0jEcal3F+rU6n9BEORqM0MpcLeW9cv6S95tI0SdTNbxt4/zW4V1RvilJZ7rIDhcHsOPf6ijciqVtnJOGNb+j7ZmRsBFpYnPCZHiZRcRHhHnIYDD1UobzcrcggR7kDtoavttx3GcunUQ+iHOX1yBAi/6eTy+Kz0ONjBpF8etcdc24iNEflg4oCCZ/Jo75sBPjnKkVTzvZpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJK4sg8/lpRahy+TnGBFmH/Uzs2yQVQMEb7ckc3ECAM=;
 b=de81v/+GvOxAUaXhsmOprjmKRTo0zayN8761XnZT0zj4ogsh2KHU+iDudTz5+dsNBbB8LIQg8g3nFlmfCzbvbCh2MWOE+BvnPbEksuu4Q/SzNgcyVKusfpHz0xRiPWZ4nnXzl36P8cVp3YtAXuvI4emx0D5FlQ0q6ydYsd+zXdU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB4913.namprd10.prod.outlook.com (2603:10b6:208:307::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Mon, 1 Aug
 2022 23:50:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 23:50:22 +0000
To:     Steffen Maier <maier@linux.ibm.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] zfcp: fix missing auto port scan and thus missing
 target ports
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qtz4j83.fsf@ca-mkp.ca.oracle.com>
References: <20220729162529.1620730-1-maier@linux.ibm.com>
Date:   Mon, 01 Aug 2022 19:50:18 -0400
In-Reply-To: <20220729162529.1620730-1-maier@linux.ibm.com> (Steffen Maier's
        message of "Fri, 29 Jul 2022 18:25:29 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0094.namprd11.prod.outlook.com
 (2603:10b6:806:d1::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 493d6e05-411e-425b-62a8-08da74189907
X-MS-TrafficTypeDiagnostic: BLAPR10MB4913:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O8aFraOp0EYb5oEZohuVvzzrNc6ITGVYzm0yYp+j4MugLDS+rtjCfv72oYJEX638/anXREwokV9+ntzBsoIRIq4uu9zgZY4jt8r4uipbI+Iah1FM1NMrmGIjb3wIffHPKFwl7DfT6sIWq/6KYIoyzuSvFjeKza2CSA1NkFTTow593M6QI65BkmL2HO4A68v5GpduMn9Re3woxWYMLWAC0uh/aYqc89Hs1I5uyI9Fp1AsjhoJ5h3/hC2Tt1q/mJFgckvzXjcGBbPL0mZ0dM3Zk6QqHPT1bpomlTIylq+O75X8hsZ2r4IQpUnhsIFkJ+0yskyTcjh8VgYHslmWLBVr44RFmPRTJMfDICe17NTzr7+6BvBoro6KTOp8pIcCcBt1dVK8+79fyazGse5MkUjDr3Jk0Hc3YdxUWSM7WzL9PMo3zDkv53Lr/mSEgxhJbrSzm+VTTuQfASsehtMYwKefEpDg23uUuw3UT6LQRTd35riUwjxpssF4k5f8zdwC15GVZicexC/50DrP9D3K9l+vRwOzNiBSBOEvR35UVCogUWrO1CCq1KSObJG+fPEWqnJYg5OVLZM1h+Xae0w7kBMgFK3qplDXG1MuaOjRKsmIT4DiXe+n/Sq66y4qJZAVzrXF/lC7r8pCSVYGw4uLiVSZNH1O+Sc5mTP6yNZr2IyKQtij/4ceDqKJ9gFHJysNlW+ULEPvbMb9qgywBwU7q4Zs54sJ9phY0W9WbX7OdkjFzeYTPNzZDCsP3v2IEs/ov4jYoXFRHLg702t3cXbT6eKs50aEngCpAzsMrP0kU3NK7Bj/A1wPEjG0dzM6NyFsWKuf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(366004)(376002)(39860400002)(66556008)(5660300002)(6916009)(478600001)(316002)(66476007)(54906003)(66946007)(6486002)(4744005)(8936002)(4326008)(8676002)(6666004)(26005)(36916002)(52116002)(2906002)(41300700001)(186003)(6506007)(6512007)(86362001)(83380400001)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GlukUdeGvelJpTmP4YyD/kePbdj1Oq0gQLlisFEuYmhNDJws0LtRB9F72Cj5?=
 =?us-ascii?Q?wQ5GqhGMG7bSm3kuHc/VsMIKdlUDmcfgh1lcoSNXllywWPVtglUejQiMDd+3?=
 =?us-ascii?Q?E7l4tWBSJ3lHtfrGlowcf4ROM7Pfoi94huAcTP7RYhezt/gbMFYnLkA9h3rc?=
 =?us-ascii?Q?mbp858kEDV567W8HnCiWLYfbjkuz1oWCLPW5WAUEadpfqG7VJj9VhP+x/Ce5?=
 =?us-ascii?Q?QKz34JzI61ByJNaLeBG8WcNGSS4SGNE9lO6FqmgJNmPMGLsyrUYnNBnPaRRb?=
 =?us-ascii?Q?fB8aWsLhWmRMyuPPLEytFCtBDrM2Ryv240HYyka3kKOOPFqrXZsdEBJhl6VK?=
 =?us-ascii?Q?qgfKb4ircqBpNM1SeFiD2CVcY1isbXxDXhc5NEwcbzg7Z5j0o4+QRQDvKyrS?=
 =?us-ascii?Q?c6r38ccmQ6ibGMBhQSPxBNidzBol9spc3IRUZfkPJFhob9ggbWMPiqpC6NfS?=
 =?us-ascii?Q?92bmlxhtl1zaMnNeJZzlUfAtbNrqLU3v2MamW6udITqCZUwbSggAiuTD1+F3?=
 =?us-ascii?Q?5a9TYU4PBJuKx3CXprngqeH/m77vb59jYKOOF7v4qA47kBM2gRKw/nRc5MH1?=
 =?us-ascii?Q?1AJyVAFoFEoHfr9cvLNal31j3PhQC6KDnppPVQAVsN9i7wKtXlHlGP7GVnmo?=
 =?us-ascii?Q?9Ad/LhPj6CV0sapUR8KhFBIn/7wJsQp24vA29i7X6Ft/7P5AA+BaI66jCz8U?=
 =?us-ascii?Q?hf/ddO5PptG9GQzRM0jJ8ygtxhWWQ+jPF9JY21AUnVbzRfc9RSR4cgEffvAW?=
 =?us-ascii?Q?KTQGmYe1zQJndQ4U90oQmqjSIOfpWlAw4sDYidIvgTIXvnGZ9IQT/r1II+jR?=
 =?us-ascii?Q?vpBWWP3DEyDyXy9B8XpjzCtcskMMEZYPgCxXNkvDU0xgabGy/QA+xWdeMxg7?=
 =?us-ascii?Q?aLivcf4SukEPsrP/Qm1XkNH7K167YGy2q4HmOzcHvv7qfpNARmo4AdMVv5gs?=
 =?us-ascii?Q?ItW/t1y5mXskWroMGM5LnIcCudnYDHSre4XTdCW8ze77QoekYxhjTDFpjhC8?=
 =?us-ascii?Q?NrAHH5idLyFcGp8ASFZSGtfKgt1RLSQcw5X8mxFTp4pGNGQs9+iRyOSGuXmS?=
 =?us-ascii?Q?bAeq3fifqQhnDrxgfckjirE5yviDu17hH8XrY+lbw2F2lgflY3quk7pdZzW1?=
 =?us-ascii?Q?oHoRKOMXlffYm1/zONkx9I1qVVpu9P6sld6JK1b5H51p/Jpu4QUE3rWR9/W0?=
 =?us-ascii?Q?nz4C7SHDGGkx8teq6kXKozq8xIMYRifu1BcEx4WskuGpR58j6bLSTOYU+9hy?=
 =?us-ascii?Q?vueRD5JsX74ZL0zx7/9B8+kbV0XkplFaruE57WI97zLx8/KTJztV8+Jw5Xhh?=
 =?us-ascii?Q?Jwmkwd6w3XP3qAC71aZa+F4IcD7cGFO7Y/EStU5DP77m4UFoxSmVqDeBv+jk?=
 =?us-ascii?Q?E4wX4OLh8q38G+inzv3R3r5HATE9lmpNtrptv+vr3yRGvs4NTEKdx5nmhk7B?=
 =?us-ascii?Q?QQNz+HJA0gr4jsJ/W8ih4mCdSnItew8ajo6gx8BuylMBiIMpY8m1TBLeNOB2?=
 =?us-ascii?Q?mUP2ZJIIVqATh4lf42CVZNu8zlFB/J2rgtlD+z7ncRHWE46J8E2M1/D8LYEK?=
 =?us-ascii?Q?w8ZqRDBFNZgcp5MjNBGeunGWXLwU7Wthe/1d+W6ocNK8NZkxycFIQ+nhVhn4?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 493d6e05-411e-425b-62a8-08da74189907
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 23:50:22.3668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1BuvuLPDDnhXojsSapo36EyRZ/AjeygQWpto0oHEaGa1Jg09A0QvYnREspt6spJuvvhBZcd6uplVkLe2U5xEPgBFV/40eE8Uh8TFIaDqJiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4913
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_12,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=880 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208010119
X-Proofpoint-ORIG-GUID: vI753hCsVd4jsBnbXCi8AM8sXX28gqyp
X-Proofpoint-GUID: vI753hCsVd4jsBnbXCi8AM8sXX28gqyp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Steffen,

> Case (1): The only waiter on wka_port->completion_wq is
> zfcp_fc_wka_port_get() trying to open a WKA port. As such it should
> only be woken up by WKA port *open* responses, not by WKA port close
> responses.
>
> Case (2): A close WKA port response coming in just after having sent a
> new open WKA port request and before blocking for the open response
> with wait_event() in zfcp_fc_wka_port_get() erroneously renders the
> wait_event a NOP because the close handler overwrites
> wka_port->status. Hence the wait_event condition is erroneously true
> and it does not enter blocking state.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
