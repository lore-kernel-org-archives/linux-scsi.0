Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB52FC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6937564E57
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhBWD1m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:27:42 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44088 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhBWD1l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 22:27:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3A2Eb139463;
        Tue, 23 Feb 2021 03:26:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=aCCNKqrczshAFCG3BX80CxTmw64e23br3ll40BDnRBI=;
 b=UhSwrIMH0iaZAcz5B4iUtjPSSHnf8sHe9C+XQc+DW0Hd5kukJWRoE/QqkwCxP8MjgVZc
 grntmNKEK4UUd63mx62BeHBGc+kJ9ieGbPGZEKzRPWqj4e8rSqXb1s7xw/HVtXkkXdu/
 hN6nOOgbKZTwF0iH1f/egjeXOiSRQW+5CPwm1sXRENHEH7mPqC1VI8oUvEEiiVlFpNQS
 uKEeLTc6AEM0oAGETb1nOJBiahAmXfLlhA1DY+RV8fTOEwLc5qnfoRcE6isp21kejTas
 oekaaANlnp4L8e9OFRfA4sG3KQ4xm8xtbZnL0Fqcmkcw4+2Lngw3k5V/x1Z4NsG8Mag2 oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36tsuqwsfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:26:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3QXsD014243;
        Tue, 23 Feb 2021 03:26:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3030.oracle.com with ESMTP id 36v9m41ad4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:26:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lB5cIfXVkLEEMJazuw9/TFFo1euoTJ3JMGgSV6dDf1vwZUH+8Fv+OPAdBCj1cvUibzp1HNGqfjbxmct+6+9gtBOlOrqzNobmb/y0E/+vlzOzEEaOvJQswZio7T5P+tJjkn5iv9G7u1LeB/4pmIuGdJOYXa0nUN5FivGYR/JS/xUaxHnuT1OmD1fa79OOUsdwHuf2C02sXvOvuAyv3z2b2CwGFIDbii3AkAwfgZ1gH8Jy+T7lhmymCW+SYTIbMoc+aPN3AnLg/0TH9YT7nuuQeiSijyGoXRidJtScbc0bSpHLcDAHFlw8253aYoPb2a7k9EyoHsUKVegCtlJxd7xK9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCCNKqrczshAFCG3BX80CxTmw64e23br3ll40BDnRBI=;
 b=ZdApsIPuycSAdn9HReSvOKa8ij3XJT6iAKfPS441NHc3Gw9Q0v7kUUIFblIU+W4LAXZo3iHwac5Pth83wbK9QqKW8lAgc3m3bj/+Jzp+/Vi6c/1O9x8qEukoLOnwuiVDx9QZ7O0j7ohtIANVvedKoR+UTBbe2YVz9imDajCItgGfBM/El25v9MqspW/PQLCa//zgC0vnjyOMQP7rN9fKpRI6ne2ft1HTY3PGyaHfH7dUdplIjRBgGwAmQed11hgDUWSD9lxexri28v2d2x36RB98aItlVgzE5EUMktNaGtRhq3qh3o2D+gjW37c0EfK+aqlGhjRUERtcwGZt7qIywQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCCNKqrczshAFCG3BX80CxTmw64e23br3ll40BDnRBI=;
 b=FEVZTKPVh0PNNNQU1A4fpfyziOTD2+WqUSEA9on5e1bQfzlL4/uJnJ97ypc3T8Kr7FaUofBleyfSfxrK4fnC6y5af5uccJxclEmei8saDsouR+1C8mnRumeusI+10AQte/+ST0pgGamuxHCVGc9pGJKd8IrZBLCf+7xbmiuG1H0=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4471.namprd10.prod.outlook.com (2603:10b6:510:38::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Tue, 23 Feb
 2021 03:26:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 03:26:52 +0000
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] SCSI: bnx2fc: fix Kconfig warning & CNIC build errors
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11rd7h3bh.fsf@ca-mkp.ca.oracle.com>
References: <20210213192428.22537-1-rdunlap@infradead.org>
Date:   Mon, 22 Feb 2021 22:26:50 -0500
In-Reply-To: <20210213192428.22537-1-rdunlap@infradead.org> (Randy Dunlap's
        message of "Sat, 13 Feb 2021 11:24:28 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:a03:54::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR02CA0042.namprd02.prod.outlook.com (2603:10b6:a03:54::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 03:26:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c765745-c23d-4c3e-b337-08d8d7aadd19
X-MS-TrafficTypeDiagnostic: PH0PR10MB4471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4471B62DFB289C9FDC76EB538E809@PH0PR10MB4471.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Yys2pdupW1UEy7/7c+qs0WP6l1yaPIT+GCKaSPI1yYDtTdIumtvVIqi01aew/7xJN/qKc3dyZX8sXE2x1bvEc9vR6q7w0bzcZwGM4n6f9zgIifZBZuaHUIsq+UbMX5tbPOEOFcSZDoAC3sgcibe8HHlWuG/6/uddwNPQkTZLfIqPQNWFzhnSuQSvM8SZwQyQ16ZEOYP8aZTC9eYfm9hDB/9B+8kva54coIyjABZQMDKM2yX56mMsMvq4QLlogN5ZTGauU/PJhiolJC5a2whkm0JozypLpXxCSiAqUzd4t/7s4K7jHMdymNX7QApZIaQI6JagVbHVgRYCc1RENAVta3+0vdOTdFP/8g9IG8GPF4/Vc91WNMbQMF+2BLXF0yd7JuVwF0tbUEksF1Htr75qSmTaCZgIm8GDq/yxuRtp5NDZdAZdWDAmtbF6EOMUYhLxqahebqCYTTSjh+wJ1yL6exId4xYjJtNB73eYbbzs47GHt14oBNnZD8fzwKiSDdIcPUIfCW/U4K0PKomTrLKrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(346002)(396003)(376002)(6916009)(7696005)(478600001)(16526019)(956004)(8936002)(36916002)(2906002)(52116002)(66476007)(66556008)(66946007)(5660300002)(86362001)(558084003)(26005)(8676002)(4326008)(186003)(54906003)(55016002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xAXm5NvSe1US7jQb14IWSzYkc8tfqC/oZFeYphNaOceHc9wxi7NeVy44aSR8?=
 =?us-ascii?Q?XWeIkrkHCqWPVAUvxKZjSY+Z3HZZjOe/LL95iXmBBEnNrPA+mIQuU6V8/mIz?=
 =?us-ascii?Q?Ay8K7+LuE3C22rjx9ZXOZZtc/aPx9T6tF/yVCO7ofF6cqjFCT6i7M2wO0v2E?=
 =?us-ascii?Q?HmILlpZIg4mD8KR94aJZtl3FHd/1LCF4RrWWA4XhOsJ7GHk+4dj2Jxco3LqR?=
 =?us-ascii?Q?HKLWBjr+2quSt+QNqgCTZoiM7QVOZcRkWobGS4XMneXNj1ncMYb1eUzzNOAG?=
 =?us-ascii?Q?t5XgBuyhcWCwLvP5CrsG7NaJOeZk4FYRTNtap7lzr4XaihhSvRbVm72erNJr?=
 =?us-ascii?Q?YVCcRKtkXcE55SVUStUdPxc1j1FL9YOtxLcuh6StrsAbOaTWu57Nr/VbCwFr?=
 =?us-ascii?Q?O+K+5rtiFjloVmRDYklLhGKnY+iQzNc4Mg3Zu4C96vFP+yQfRD1oKDMPzfdw?=
 =?us-ascii?Q?X9+0GSlSZpAEV+f1dI14x5+jBKwvDhwrtxRdhtnr5Ufo+whPACWsXAlToqt8?=
 =?us-ascii?Q?da1kso6xIIOk0iADjGDDU++IgPyaQ0bBXO5ngAaUXhke0vmoGIEGVgay91vF?=
 =?us-ascii?Q?Xfo/gzO91IwdISpBtkmWz8tliscd1Fr5Y59TSJyt8e0hBC+SfjPvfxl4/2ZO?=
 =?us-ascii?Q?n5ACEsbfpTuXTAQ9thFs2TWROUCkjk5rGqCUPoCmNbxMS9SHht62UTL+eAv3?=
 =?us-ascii?Q?UMOzB/klKPUKy5KfLkbLHmoQChGNhFVMiSEhyvsWQdut2wq9fTA5obg2459T?=
 =?us-ascii?Q?WPCbGQsLfGq9FV1Uc91OfGICYZU5cC43KjRYdm11bORYc4hrKxZh5cELWLZj?=
 =?us-ascii?Q?GJygjjgSu0COn90qZsAlqZmWqrSuRlJygQ62jb3N/qA2KLbKWylhlCHqsUVG?=
 =?us-ascii?Q?vEDytSJOxpq0z8lZlxPq+tH+6/0ueWj1yjINJew0s+FUahznJbRJhlF0ku/+?=
 =?us-ascii?Q?SyxNfWDyqMoCoMOVfef/JlQobKD00zLLebFKJXFGX6HKY1zVakSW1HLGr5IG?=
 =?us-ascii?Q?3dk953whLgMcJK7g+kRzyRnHFH24+dp85rMux9nQLzF296dkxMe6COF1pu+O?=
 =?us-ascii?Q?ML7S8j82+MxcF0syNmyKWh2UjC0jWq2WHHxhluwsE5g8WsUm3ZFg/Xkx2726?=
 =?us-ascii?Q?Cer1Ga7fBDpG/OZJ8AVo2qRLfBO3RBPmVqsa2vOaP3QRdbojIysId3TEhv5v?=
 =?us-ascii?Q?1P4JdrUu5TMp+dOejNaBzU3H2fDp+I87/VhLZlwOoOfr2VIFGx1woUCZpSQT?=
 =?us-ascii?Q?SRNmlrmyKFOEoGwPnFbG1EiyZBdRLg/oogby8AeagM1qzJTSu5dBowLWVx03?=
 =?us-ascii?Q?rPMW/DZ0TJqwkfx0xlUc286o?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c765745-c23d-4c3e-b337-08d8d7aadd19
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 03:26:52.7961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: clwuFWWIS7bP9uyjD0QEMUOH8DruZbfWAJqdmmSbG3/ktLiBDanrvPJjzedc3Rc6K3+tbu6cSX41zLl2ZHsvDjiaJ9bJS3i1GO1DPsCrKZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4471
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=924 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Randy,

> CNIC depends on MMU, but since 'select' does not follow any dependency
> chains, SCSI_BNX2X_FCOE also needs to depend on MMU, so that erroneous
> configs are not generated, which cause build errors in cnic.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
