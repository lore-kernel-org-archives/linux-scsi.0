Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E4EC07E9A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 01:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC86E611CB
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 01:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhGMB50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 21:57:26 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26438 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230000AbhGMB50 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Jul 2021 21:57:26 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D1l8c1025999;
        Tue, 13 Jul 2021 01:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=0a0LMdkmed9xJMwqoEpm3+8LdGZX73CbCCOWE49uNfk=;
 b=uyl6yGclAADhh11SrSLD70iw3ny3EXjol1I2zt+JaQuUmqrmmD7C1Z01GPboSKVcpoM9
 wKUkSIiwVdzjkeMTZrDQsds9JQqkcpWM/gzs9SpUoM0q3/Brkjj3NL3xG9SmJA2IyEHb
 +G4oPKg9z6rsTm/KU/DpXAC/TXNQ3+SqCdq6nDJaqFiMZ+XaLZuLPxtEKSF0boU0H/A1
 4PeZV5gwjPLI4ibysT07PNniap8/RkrMBRWonNHzp/mmjuq6fUUFR2Qu0k+ypVCYO1WC
 5TAOSAsCAtJYDHbG47CQhDesVr5T1Rn4nJP1O2t7dARd5hTpA2QufAnSJ88kPZFMEeln 5g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb17p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:54:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16D1kniE091902;
        Tue, 13 Jul 2021 01:54:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3030.oracle.com with ESMTP id 39qyctrmv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:54:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkPNe+hOO+kud0k3CFgZDK0oM9/hvz9IdDeasHALzXC4AtjfZ+YefCuo56NIijG+EXPUSAgVz+aoqZvEQ/LtbEAJYIv7YhVlgYfmJJcHFP+kS7cWjoMPzs3tabkeEf6FYQZeNM9BnyvI/HPfQIRW02+blgCYOv8CHhsI4F3GFtUna8he4JBBrAQRRXHwiGI2vbnEiTpl7Qs2Y8nKCWGhHCMNPpNc1PPYMjUgon7lZTuiVeAkY2c/zRBvTPADXzpxbpJUMFDXSTm1GvhxDwoUPZ/Ga0/29lb0WtjkYSWlCjl4jDpznkrqp3ZcxKKDa9pcG95i+9qV4PMe9+KbIo7AZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0a0LMdkmed9xJMwqoEpm3+8LdGZX73CbCCOWE49uNfk=;
 b=D78XxgWF3oR6FQBk5FL56I55yG8VRyod7AvOPeBxMhEn6zUEetatfyS30xBUrsse6Je4pnNx3+msvxze7Z2zegpL97JW6gq+K9M3SqaWkg4K835xYsVRqfUwkCQ4SjDz8kwmi3OrBErjIZG+K4kOa0MViZDcrzLyWL2Yr4ldlOtaqz8PngebwHUgEfnQUuwU1ApBomm/+7eWJpMQyVo03Rf4cmmX2ioEJpo99He0OoJmTLZo6V5lmSVXE92QqpK8ZYFpgGNHEG4I4FXGHFbmNFGFq2MP9IgZFOnfQXntBUy/ow0pZVE4mpP8Ij8Zirx3DSl0AaWnJ6Y+skjRvrcofg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0a0LMdkmed9xJMwqoEpm3+8LdGZX73CbCCOWE49uNfk=;
 b=Sg+3UX7jTbQCFtYf5Y0MlgqKg/8ceKC54pnMf5UoFnMIuXbWLwmv4FtInA/iV+KaUlidUaih7A+jcvjhlefJEw+JEw0r5eCtLS71jmcERN6cQ+ceEhan/WppNBD1u5ik+x3CyIcp/0JFhmKkK9fpOs5zPxa5U56cxzDvwWOnZww=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5467.namprd10.prod.outlook.com (2603:10b6:510:d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Tue, 13 Jul
 2021 01:54:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%7]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 01:54:25 +0000
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: pm8001: clean up kernel-doc and comments
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7gz567v.fsf@ca-mkp.ca.oracle.com>
References: <20210708165723.8594-1-rdunlap@infradead.org>
Date:   Mon, 12 Jul 2021 21:54:20 -0400
In-Reply-To: <20210708165723.8594-1-rdunlap@infradead.org> (Randy Dunlap's
        message of "Thu, 8 Jul 2021 09:57:23 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0080.namprd11.prod.outlook.com
 (2603:10b6:806:d2::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0080.namprd11.prod.outlook.com (2603:10b6:806:d2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21 via Frontend Transport; Tue, 13 Jul 2021 01:54:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 321d0705-8b44-44de-8a34-08d945a12443
X-MS-TrafficTypeDiagnostic: PH0PR10MB5467:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5467AF5CB3F19DAD450D30028E149@PH0PR10MB5467.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IRsH8Xfb3Y6DYdzYRWY1LsXlBYyWDRaBWugQ+FpVmJHukp3tpX2T5QjcdKacTuECkh9wtPPfhnA3nmfEGYrWw1a51x6s4JmAT24fXSaYKXi5xWj7c6/ij8n2++uJpwkH021r+6TR1KVHPwzOmC9EUx5JcgsGAJkWvSRekA1LfGWjqaRTv0mHylut5hkWoOrdG8E/UzdmqO+gNCvianJOrBVRWfIQjzgv0ZwYlA6kk3MPFYKVvTPx8Ed156POwXDU5e17GYDzmH3dQDOis4Ghzri09BDGDMBXPwMCrM70kXxAuSwkchJpSqCJlVQ4xL5Y/DYSM8Zu99GUuIMHRsWghKu1bPGjyQBuwWO5545uHgfMJKiekzp9iHuFG2fasC+KknUfweGd2ouTsX6wlPmYA6ub65ONXYrRCMcg284Nk/8F6u58qNWBQdksfTXwF5KMQvN+2rm2qkd4GpGI3BMlE+U0uuqGEXR3eysO5cWC9sjK/p0F8eSbu1KHeYKMH6yp98WE5Vs5luurDfNuEXdzjsoWMKe/qn6b9OD7aKTpFFpcG4z4Q+/W5y3ObGcTbXl9hYgDyAv8Gt9FIsBacngBeLi8MmwB77niJ4tfqznrmaqM3V9FpyvY/UbXGprx6TBQJ0EORwCxKjhLnFgMzh07Ac6nEiMs7T97HmF0TlcNqa2e/ih22fSAJzsaZ1zEp+ULYR3dykKjJ0ia2/M3hsTPnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(346002)(396003)(39860400002)(83380400001)(2906002)(86362001)(6666004)(66946007)(38350700002)(66556008)(186003)(26005)(66476007)(8936002)(478600001)(316002)(55016002)(54906003)(36916002)(4326008)(8676002)(7696005)(52116002)(5660300002)(107886003)(6916009)(558084003)(956004)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?41fcBYY/NKpqi6+R7zRQ61Qd2512EXKsY+4lfXijD40eDm3upnpcTC1Cc54n?=
 =?us-ascii?Q?A16oNp10+2hgxq9SZwoAYkaqJ5+8RlgOFXTGRIEUclJ8xcEqfqfNC7Y9ltAd?=
 =?us-ascii?Q?7Q6CDKTDSpx/SBTj/L+ipvUVTvCQ1VXQSFbCC8F1qgepbYDbz5J117C+jTQt?=
 =?us-ascii?Q?OF9Ytm5ghVTWjSLxGYNlR9b6DQwFABc1aNR0HINhwDtonDBpGNpswbS3DSIZ?=
 =?us-ascii?Q?Q1P+A2PNMb5IDc25I+EH6ps843Mj/oH3L3W0tWBMeESCbVpmoxEPxRXd4OuL?=
 =?us-ascii?Q?EqajU0zGAHJI+gyNUF86Xh7f5Kh6SqGZbABLGS96Cl24L7VD8RlS12f7Sh3U?=
 =?us-ascii?Q?FhLzaxBIeTbqUXzAQLpWN9picbLNnyjn+yu+MtTxnh8uyKLxldE7n1vBncfg?=
 =?us-ascii?Q?fExNU/t+3A5PzitXRxySyRFXh8yMw6Lechszt1Ydyk/GyZtGpXzFyZPvQEXf?=
 =?us-ascii?Q?HDPc2roKa+n5Bac/jzrd7NPtqoXa7X6N5Y7ZukgD6m/GN5doOMAo1yBYX5wr?=
 =?us-ascii?Q?17cKn/6n4TsEaqkbcpVLN2RD1NQaT1zC8mU5xwQiPR88JSd6zVxo5PztF0by?=
 =?us-ascii?Q?2PzZc8AhkF8m56GTRxnOadwW3rRHFw2tEozbtIqll7BIY9p6Os6y7OT01K3M?=
 =?us-ascii?Q?uZtDbdpLI6Pm4W5dTWx4AsXSe5oObr1mP2k/XBIP1HlTkU8L9d1fboalfTZ2?=
 =?us-ascii?Q?ArPvfcNfGeInLSHBidmkWSF1Wefjy8G/IfL1fR/FHyrc7gQMkhSkemqVnxAX?=
 =?us-ascii?Q?lJYoEoCcNcIljoBRT+aaYYptMs17Vy8H3b/sXPUKnGrw1O9MQwOMpo0iYZax?=
 =?us-ascii?Q?G5gTuB7QN48ow1TT/1JlVrI/73LWMrStX1MDfl+gVzM44GBjSdV7dXe+Ef53?=
 =?us-ascii?Q?dIHtX8J1huy1tBUDJ5CUEBTgt3NP0phctZxgZME9yt8FXffTW3jI1ay2JRx4?=
 =?us-ascii?Q?x9SNrjFqQg3RehwkPH5NlKroP0IOz0Mfeqgjkop9opWLgEMTD7lu3Q2mjquS?=
 =?us-ascii?Q?Y7DaZG0KrJ21uHrCqmDNHNWvxIGBLviDN1aZuh1bEGjt1YhD1z4+YW24Ru2o?=
 =?us-ascii?Q?pYCs1CfEfYuzJ12WGBPhxSqMY3QEDqOer9L6fSiScSzIAqD2X5La+aPG+YEj?=
 =?us-ascii?Q?XR1dSKbw5xQb88TVZhQSbAynVgVzXfrVbbE4szE2+/t/qm4noyZM67fSOCyf?=
 =?us-ascii?Q?j1liwFLp9YPV1gCcde3kv67+9CmEF2yBy9lf1Sowqxm89LcmXKJt5jXzocfD?=
 =?us-ascii?Q?pDQ4FN/Rt6mVnkuZs3xM61JJG5IzvLDlvH8SyJ60SwUfgtSI62VOapBM/nC/?=
 =?us-ascii?Q?EnvPO5GtqVr7JFxNHaxTkvdl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 321d0705-8b44-44de-8a34-08d945a12443
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 01:54:25.6962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FA5uuxGJxOuPxkFbt8qhwXvhPqr48/SX3vQoDjrNIRwUuCxjU+eeotqqDySeAsd8wqpeGS3WIl4M2yBKjVJQNcs6bN8dLugo4dVRzxZDcck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5467
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130009
X-Proofpoint-ORIG-GUID: nUBcaVYC3mmRGbpS6tRngwvdVrg6gtYL
X-Proofpoint-GUID: nUBcaVYC3mmRGbpS6tRngwvdVrg6gtYL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Randy,

> Fix kernel-doc warnings then test again, wash, rinse, find more, then
> repeat more/again.  Also fix spellos, some grammar, and some
> punctuation.

Applied to 5.14/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
