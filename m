Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970DFC433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6534523B1F
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbhAWDkG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 22:40:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60468 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbhAWDkE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 22:40:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N3VJ3E177904;
        Sat, 23 Jan 2021 03:39:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Pxvui5V9X3KmMMWabTqOXAmELsCNvxjGffRF6QXH35o=;
 b=YtGjYzSzGKLjnb/z5PsOadk/pui2v+6c2BiQIcv4QcQG85IVwz75tZBvkuNUguD50Dgc
 BW1Aevnqa7HMo0pvv1w51iWew0WmheXUkSZkm8Q3ciABBINXkLkd66QsilEbsNtCIgUi
 igs0GsegUJWLxAOG6+k2iOLboVpr0EaC43eMLhfC2WNlTi+MayewZHAWQa9GI8gDF6T4
 +TAcBqaTm9UwndhbNO45d8f8XacjtEORSwNxlV6NNIvBxAKv/GLhVIAnYAMorvxMiFBH
 S5KwNXDu1+35LytsQYQG9WuEV9+f/a3cPFzSlN2sj/X0FaEODwiMUDqw6Do2oe/P57ir kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 368brk81by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 03:39:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N3UrGG175532;
        Sat, 23 Jan 2021 03:39:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3689u8uad6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 03:39:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRD15QEwVW7UMPJNZscOk7CDXne2+f6N0+5kgY8zlk3nf1F9uNVOVeJf9IEUtDEObztX1rLQ9RAStzlabFl+d580f8wSfvthnb+/AxtFAPwHNO6Ub3GWILv9063HVRGW4QUm15Sn+IeYQm3fxFPNp0Qlq8sdpVzA+CS30e0i/KyJKRK5wqlxv3Fkm5IpgIf8ndhwnx7lm2P2jrN6opqdzNzbFBKjPHdcPbpHBgtKk7zzDAXoN27KeURLufSkKGWwgy7pWP5eoSvDLc/F/wunVKdXQU6WI062uU7S1HVq94v2Zd7r+1svr4FVHjnLSPz8/ZC1HrAQ5fDOdxO/+1g/iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pxvui5V9X3KmMMWabTqOXAmELsCNvxjGffRF6QXH35o=;
 b=mroUMzEzZVzN2W0digdquhdvx2dJ0H2yvyGcIwilq3WAAn0+7GCqoYr47/B6pul8vXy3zGLo382ndnlE6Xvz6vAijtBdZ+ecaKFTQLQ9Zyupy3tnFOfOEcVliPY6NGABz2k/ldndWTVnntaSzbzOUXFrEWxmH1PgeYqSTBE55TWATPNc9PR51N0M5iCUbtsJ1wyIyA2KUvdAdTk+0DYLMktArD3Y5Vz/6evyLLwPSwsM1A5ONtEQxYqdqViGW3IUwxnkj3v7U0EPG6tPU9zVYHoGXlbQZG7gUpMe7MLG8tOnwr4E4zuYc3ddCFkR0uvJ2CXCo7Y06EL3Vq++NlXDIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pxvui5V9X3KmMMWabTqOXAmELsCNvxjGffRF6QXH35o=;
 b=GlCe5Y8Utp+PVOW77F+SFXTaOk0fP9yAoe3yBRvhSQYsZ7C2tvJ6/3F51wJSOy3V8usajlwOCwR8MJHEJ6xbP3H/TGF84sFd2aQmLfe9Unr/mAVjQrWzpeMRKiwUkP8rNsd23rWaHnDmpgY7NPmE65PRwAxWeHwtPYhHPZp5+kk=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4550.namprd10.prod.outlook.com (2603:10b6:510:34::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 03:39:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 03:39:02 +0000
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Changheun Lee <nanich.lee@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "jisoo2146.oh@samsung.com" <jisoo2146.oh@samsung.com>,
        "junho89.kim@samsung.com" <junho89.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "mj0123.lee@samsung.com" <mj0123.lee@samsung.com>,
        "oneukum@suse.com" <oneukum@suse.com>,
        "seunghwan.hyun@samsung.com" <seunghwan.hyun@samsung.com>,
        "sookwan7.kim@samsung.com" <sookwan7.kim@samsung.com>,
        "woosung2.lee@samsung.com" <woosung2.lee@samsung.com>,
        "yt0928.kim@samsung.com" <yt0928.kim@samsung.com>
Subject: Re: [PATCH 1/1] scsi: sd: use max_xfer_blocks for set rw_max if
 max_xfer_blocks is available
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z3o9vod.fsf@ca-mkp.ca.oracle.com>
References: <BL0PR04MB65144693C61F2192038FA5C0E7A20@BL0PR04MB6514.namprd04.prod.outlook.com>
        <CGME20210122072413epcas1p2d7bd97c9eae97b9b77d13e2c4a2f02f2@epcas1p2.samsung.com>
        <20210122070851.16105-1-nanich.lee@samsung.com>
        <BL0PR04MB6514C248B950F5FDB77B96EAE7A00@BL0PR04MB6514.namprd04.prod.outlook.com>
Date:   Fri, 22 Jan 2021 22:38:58 -0500
In-Reply-To: <BL0PR04MB6514C248B950F5FDB77B96EAE7A00@BL0PR04MB6514.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Fri, 22 Jan 2021 07:44:00 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH0PR04CA0115.namprd04.prod.outlook.com
 (2603:10b6:610:75::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH0PR04CA0115.namprd04.prod.outlook.com (2603:10b6:610:75::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Sat, 23 Jan 2021 03:39:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75d1cb44-4a3b-4c84-a92e-08d8bf506d71
X-MS-TrafficTypeDiagnostic: PH0PR10MB4550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4550E756EFA0AE3ED5D33C4B8EBF9@PH0PR10MB4550.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CxIT/N6332HSDAQ6bLAb1ADRLGjSjZaSsjfMEOB28XPxhpsSl3WY9e3KnReHtMb5KKFx9qAiJfoiwiQbPRH8xzFWyn8ykFsDHeEF9zOMJG6ZcribLTgyzEQUPX3nL1VmhOijwKWA9cCqep5DCwtHqI2W9RywcGh4SfoQci3o/V0BhWBzhvTlKjF6acIkk4zuwwUGAkghr19OmU3OstJU6lc5xuvhdKzWGzYS7r9kA4HVZ/TOaVzvQFmmEynKjm5BDgMxdkFd3o6+pOQdArVtuEQ2XZiVp75zPuP9BeCyDwpo0ANQaM5DcAmpsN1ZmpIHFbkuCJleSIRcnhH5gbgR59RnVayqqnnttm7qxab1UFkCsMhDFS8P1SsDjirItOBdhAdSezHd44yfeLWoNpYFCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39860400002)(4744005)(8936002)(956004)(6916009)(8676002)(7416002)(2906002)(16526019)(186003)(26005)(83380400001)(52116002)(54906003)(5660300002)(316002)(7696005)(36916002)(86362001)(66556008)(66476007)(66946007)(478600001)(6666004)(55016002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?F2ifCSq0ddXPzDGbG8w9bMiSMd1Vr60F2WPxRBMJfLdKPux6PEwo4s7ymmrg?=
 =?us-ascii?Q?TZU3JNeZtjQUaLy6kNwMVqBL4oxC60P7K3sRWoQxSN0XkIm2uE6y690gCD07?=
 =?us-ascii?Q?GIXyESQSHLiidKlEzCNtzpR7YdXLrzKwumZWTddpJuBIGRxkhfBOk60NmwLp?=
 =?us-ascii?Q?da+RFCLjGulFo4lHXu3sywUVlEGY/2Eau/DW8YZJFZsbXooOewFAqsdeofEA?=
 =?us-ascii?Q?ZXZUFGo7JBftPvAIUHaxUSiW/9RF71HcdEjXYJXW5fk3ECEOE6BtunIRa96h?=
 =?us-ascii?Q?HRisRxZfeCImgKS+pq/TW5EbwKQJ9yRxO3Ust+cC6idOgZ3BQEjrjtia1Kzm?=
 =?us-ascii?Q?l4M98sWNJe8aHO7r+t4+A7n475ZxgpQpBHnwzYL1U3Vo5MtQFrfTi5H1SnnU?=
 =?us-ascii?Q?caLy1ep+XinexdMdkbNWD75pL/jZWsTzlDw+vRMsyo02qGIHqOttdy85Lmd/?=
 =?us-ascii?Q?4NAKAuLP1nfKV6KGom33zIIyTQGDTWbbOlMEtTKL/lsu9+EEyJV/Gzah3JmJ?=
 =?us-ascii?Q?2d4Q6vuWWL2kUWT+G0AqxMUsi3J6BPV6Bo2awUEle40aw716N3K2c/Hv2juE?=
 =?us-ascii?Q?o+aOIqEykCPyVvICnZIPNIJaDTxCp1dCRp8LpbYaVw5n9CVcM9ZPUKuUoLUH?=
 =?us-ascii?Q?FQhjz4uj6GUOEG9Q+CLtVQHT3ptrmMnV33Kf+k3CJUA1lwywaZ0CMTuMc9WB?=
 =?us-ascii?Q?hX4Fe3cH3kbUQjdeQO3RP4ZQfTuoNTlskkIYlxLWRslljJOHlObVVrkyXXIk?=
 =?us-ascii?Q?9f7l14u2kEUW14y64nAyeDon9fnuipYpESQEibn5Lwzts63xG9vPFFQjLvcA?=
 =?us-ascii?Q?SRetG3WA5cyW3QDs1AwUuqySZ3UEt4NwbesK6QGeGccmm2sxtA86cgd7A1LC?=
 =?us-ascii?Q?eC9WEvF8RaFb1Ls0FJNFdNrqxLWf/uu3vlRGr0XiYqAM4lknIQOqyVmwPexm?=
 =?us-ascii?Q?gX4Hl6+T0YRKoVRDginAJOi5f+kyVOdOHb1h32j60uNFEgYy413pjWDC2L3x?=
 =?us-ascii?Q?9Aw0hvNyl5DLQUGQiaYL1Hkp+L0r/O8/L99U9wxwpZDyGoSRlFMB0IHmu1jy?=
 =?us-ascii?Q?Enr9Xksf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75d1cb44-4a3b-4c84-a92e-08d8bf506d71
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 03:39:02.8395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +YuCVYioUVSG74w/8dcYSDpmq13ixmqSJ85P7hkH4gVdk8ac3o7Zt3GdS2vLcgY/8OSjeYGyg71eZaRvrRB6afykce3I0rxopV/rgmFiyQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4550
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230019
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101230019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

>> How about set larger valid value between sdkp->max_xfer_blocks,
>> and sdkp->opt_xfer_blocks to rw_max?
>
> Again, if your device reports an opt_xfer_blocks value that is too
> small for its own good, that is a problem with this device.

Correct. It is very much intentional that we do not default to issuing
the largest commands supported by the physical hardware.

If the device is not reporting an optimal transfer size, and the block
layer default is too small, the solution is to adjust max_sectors_kb in
sysfs (by adding a udev rule, for instance).

-- 
Martin K. Petersen	Oracle Linux Engineering
