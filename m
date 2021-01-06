Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66329C433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 03:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 390AE22BF5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 03:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbhAFDp7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 22:45:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55874 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbhAFDp7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 22:45:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1063ZSxx100313;
        Wed, 6 Jan 2021 03:45:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=CeLoA46haq2aqamFyQFVqWTDBkYItYPtvlPRilEiuXw=;
 b=ndTipzKD9bVlUzPSrW4zVHERJDiAZvDfuXxlGbhAOnAFAHLcsS8eNvH3/bxLZHfIR71A
 xuwElDy+U1UjdOt4frVwaUToHwI+qRfWGIA8HOvlZ/d6COXKSzPiOQ6gd1Qp5GLq5vEl
 7fdZdVbx3TF9w1TXurEKL252btBBAKOQ65QMhjVPphLJspBvm8qh0QnQQG6e5iEm4vaT
 3FU/N6BJcwYuutkm6RNEUDAaAa3kJt0vTTADat1OmG5zMR/ym+LHY97/gl4ATYou3P4x
 Aodbvng8yBxsQ6FER/fKNGu3dQZrOclmONlFmjJDTbqnGIyGeWQPm4vNuVRSoAovr0sc dQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35w53b01xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 03:45:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1063cDWe154164;
        Wed, 6 Jan 2021 03:45:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3020.oracle.com with ESMTP id 35v1f9e8pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 03:45:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kW3ZOsnFGqf/sNps3LumsRHaRIc0bOhQizuk9udfeYNDjy9FBhXtz67cgiUcJMAPHtYOGJrNagiwAjnZe7/SNDQ6hLhfEFM28PLIPgtk8ze6C0m4uzteYcwbtTH1Yb1g1u+JyEwXgcFCNVMlbvTiqdk40JfRtQQelmkNxH2WKrk52HwPsd7ceZ52qdsfVnq3tSX2sUxbiIbMxaiubHB8dW2oeyE4Ualq0sifsilQD3/2w34sdJIgJAYZjzge2HrmawCfjm3ztUJTkN1P04nLItBiWZjFu5NNGZGDBzmgCEwZXDjNlb4A6bpbbDoxqgzBrA8zC1gUuqdhZwfJ0NFYBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeLoA46haq2aqamFyQFVqWTDBkYItYPtvlPRilEiuXw=;
 b=Ps5RPYJfAkoovCl12rC9i2Nlu5whpMypxRkMP9ZtgIVCUX5ZceJxjfHRYMGl9HaPaGcxAtHgMUXwvcB4uFJmhQbEuKqj5qSJ+m0/8smdXfMunKBKzH0pFHU8BxhCtV+JSCGpDTglXtmzKIL8A5xcW6vnej2n2/8gE8ECgRLvqVARIXIMyGyIv1KL8s7YH8h37yzMoU4G6119j2zQDXmstcWD5m2w5WtQIfZAPFmpK/d8aXUr7mEFPg66rxrOCX9irKbYCQyuDtV7kKFS0F+pKvqbq53ojdethMXn34sLnXzBa0rBH47e/md2YxJICwDavu3EWJwTHadN6SQsqhhrBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeLoA46haq2aqamFyQFVqWTDBkYItYPtvlPRilEiuXw=;
 b=hmr+pjbOwF1iUOc5OrQICTXMA2IJ3QYm5PVl/P1ieKc8YJa1mxPM73D7Hvty3PlEyca8pm2of3deKMpJ+QA82qqMW1jYfjfAO9fi+kw/j7Bpud07zd0lbov2VXb7rfsNy/t8KJFahaGSC2HqI+pV+EUPeoz0w43J4AifqnxIkss=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4629.namprd10.prod.outlook.com (2603:10b6:510:31::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Wed, 6 Jan
 2021 03:45:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 03:45:04 +0000
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com
Subject: Re: [PATCH v2] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17doqg2j3.fsf@ca-mkp.ca.oracle.com>
References: <20201218033131.2624065-1-jaegeuk@kernel.org>
        <X+C+oqegC7EI6zDv@google.com>
Date:   Tue, 05 Jan 2021 22:45:01 -0500
In-Reply-To: <X+C+oqegC7EI6zDv@google.com> (Jaegeuk Kim's message of "Mon, 21
        Dec 2020 07:26:26 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR01CA0021.prod.exchangelabs.com (2603:10b6:a02:80::34)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR01CA0021.prod.exchangelabs.com (2603:10b6:a02:80::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.30 via Frontend Transport; Wed, 6 Jan 2021 03:45:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e3c82b2-1a45-4204-e456-08d8b1f57431
X-MS-TrafficTypeDiagnostic: PH0PR10MB4629:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4629B6291EE2605E284552DD8ED00@PH0PR10MB4629.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dk7MRgQG/egsDMEIrX95HjaDyvMP79Y+EUM/IOnf7niK49TxU0TkVC1gKw0zcV8CckrWOLCoyyH681FqH85uWgVante3LjhSw+/M+cdGlqUjUWmwsiLnpqq+vH3srE40m8YDCepl+I2sfZP27rat3Nz6javhV4ev4F1TR4UBQ74O94QIDgeKc0flyFN6XdYX0E9bWAqbcQowbpiXA0nn8toRf47h3KuhdVcF3/i+AnjWSKnsyfrfyXfI7b753DrQymml1Ccigc9ZKef65tsrUtmTfyO9BQEeJAIRWHnzQ2j5uXyeeEd/kvaHHYmEYC+Ok4wIfs4W27QDTpgJ26dfPxdnM9E/rXswGpFXQYTHO6gDuYp3D5LIIO1hzIf2y4wq1B3XmMPsQN2bF6cUWZhNLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(366004)(136003)(376002)(396003)(346002)(316002)(6666004)(956004)(86362001)(36916002)(66476007)(66946007)(2906002)(7696005)(83380400001)(4744005)(8676002)(52116002)(8936002)(55016002)(16526019)(478600001)(186003)(6916009)(4326008)(26005)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SaPtT2pibTWQbPz4wKvaKHTRBZnA4xHIVOphcmlElHsx8eDLghPbpVbe6/fS?=
 =?us-ascii?Q?5Z46ZC2Y11ew95Rw91tbrCY8ebWWHmDnlzXvqRWFUgKcLcvf7WtKmVQVwnfF?=
 =?us-ascii?Q?9YkgE8iehZ7wc83R6lFbWaSjt74irZg0MzNISY4sqRnpstIM8txOm09pnTcl?=
 =?us-ascii?Q?LegSnozc2i2hg/OcYq4pYUwrzLlQkoNpLFQgb17twcc+HmEcdng0Gcr4Pugq?=
 =?us-ascii?Q?aKvWwJcHEqhaZ6dTacp8vYYNEVPuiNkhZZLHA9KtOdMPYpUdDIpM64nF8SkO?=
 =?us-ascii?Q?gm20QAnbRBU7fJ/nCmSTUpi7mdJnpTgQIkyrB+67bH/wvioXWhKWQhZ2GDWh?=
 =?us-ascii?Q?8mimIhWAoz8/XS6uCVxx89EDBBmKAguxcgM1pEdlVAKtHCBq3v/K4UysMFwB?=
 =?us-ascii?Q?dYPepu3T5nUwSDB1t56bgglD2ZRr8DnAmUzJ027WLC7dGYJuuYrhlWkqOY1P?=
 =?us-ascii?Q?DcQ19kLQGaTkpjL4JsR99YyLewar8HYKhG1i2Dg8Sl5w9NGR2VYIuLt+kwKb?=
 =?us-ascii?Q?k2qc6IZ3gFKFUfgNIEhzZfaUnLzWL6x8TM/lVIABHeKBkaNlJP4rSnn5B5pn?=
 =?us-ascii?Q?jrGDFvV879laA+nOpU+rkEX+MEZmH32YPFeUxim2Y3u0kCOPbW5B2Nfo09HZ?=
 =?us-ascii?Q?KHjOKA9HxVB5grDcXC8/0kN7cA6Fvi4WplvU6Yu58LYOIQhelrYBqy/UB0CC?=
 =?us-ascii?Q?f3K056OHro5SF97EdQrkbXG0ZGC5d9GF/PfMKT12l9k1oQNtbFUDYuVx8qd5?=
 =?us-ascii?Q?/Q44uI8zZw1gByrCtzXcbQVC5c1qFr5uE6xn6CchviLRyE2nOYTYtoUxYHJk?=
 =?us-ascii?Q?GXxA14BVWz7uuX9tW7YLM12doiik2vlpHR6YuBFUNdVj2M97W7UgSGeRqQJ3?=
 =?us-ascii?Q?HnjL37jcjIirfwbk5PXr6eeqYzeV67klWp6Ghoxqm8zOo0y/9oPIpF2sVMS4?=
 =?us-ascii?Q?Y7g5XKd7AkipIKBkzqm5VMwiKLjs1sCJ/PwCaIxltPc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 03:45:04.6370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e3c82b2-1a45-4204-e456-08d8b1f57431
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1P5I8vvyuWWU34MIoJ7AFU1+vojShXo4ra3wKotutpJ2rxMWdySu5yjQ/LqIbCMlHCiP/FAZTackm03pEPhGEGYPx6hYyanSDwnWe30E8XU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4629
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=652 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 malwarescore=0
 mlxlogscore=828 bulkscore=0 impostorscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jaegeuk,

> When gate_work/ungate_work gets an error during hibern8_enter or exit,
>  ufshcd_err_handler()
>    ufshcd_scsi_block_requests()
>    ufshcd_reset_and_restore()
>      ufshcd_clear_ua_wluns() -> stuck
>    ufshcd_scsi_unblock_requests()
>
> In order to avoid it, ufshcd_clear_ua_wluns() can be called per recovery flows
> such as suspend/resume, link_recovery, and error_handler.
>
> Fixes: 1918651f2d7e ("scsi: ufs: Clear UAC for RPMB after ufshcd resets")
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Please resubmit instead of replying to an existing patch. Both b4 and
patchwork get confused.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
