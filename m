Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B24C48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 03:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80FB8613BD
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 03:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbhFSDcE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 23:32:04 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8576 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230413AbhFSDcE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 23:32:04 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J3SYj4003722;
        Sat, 19 Jun 2021 03:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=BUxQY/ukP6JgyJJOk/EGqPhMz1IaACKGG+S6NVoC4Sw=;
 b=t2m1lR7Nh2QzGKe40Z77aIHHxvkBeB+4qYHeW7TJKRLa5VTaQE3GzxxEfnPSXr3Ku1/E
 4vgf96syO53+ncCZYOS8sspaIo150AW7m9s1U33cBBVm2qJDiFeS0wmrxNgaKHWEFfaG
 Y706eqI2AzAUt73uN8a+F5Ka65HMXNJyTnG3JE51VmaSSWdnFLR3Y+xqCNbSek+nX48Z
 dnRJTTsLpxt+pG6ohGuMhF05DenupEXAWbh+lTq27DXqLaJHX/dyqw29rdnqxsP2KI7h
 r1jpdI4lizUvv2PhnvAoYLxcBPju0LBxYDG03NYSZRPTiZDHAlGflJcuIMGk/yJYSqt/ RQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3997c181pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 03:29:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J3BPgn067476;
        Sat, 19 Jun 2021 03:29:50 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by aserp3030.oracle.com with ESMTP id 3996ma2gy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 03:29:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtEw+22at44SetcbpLXrUM6nhd7SG2nG3Bg8QiPYwpk2uyX+VYkFI44Kr9pg1HcgSn3prE8bpVb5KXislqvHL4OspHITqbRs5cu9DIV6X7n+VeAqW4DtaKtcIKWAUBTEcy6K4w4qcUwS+3j0J+4n5fA5aC7mE5iLQjithXEnfbstXY5gAfgp+MzVB+HE5SOaHL7Dqd+U7ZBCKFe4xyHJiZcq4ZKPgA6UxkKvdoX0zP9ZWuZ7PsI4wKet+A6JwIf9Am/p2UIBdaewI1pLdGzKeRIWKuHmwOXEpXD5zpVV9Oh97bs4++t0t85UiOGQr1l5whCu8rBIgz32vdf5V1ZOQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUxQY/ukP6JgyJJOk/EGqPhMz1IaACKGG+S6NVoC4Sw=;
 b=mwDYJrXT5fG67zFGfcclWO4DnuVZsQpnLHzUt+U4V45oD+Y+RH0j5VCRwt8lhK6kI43kU9vpN3CGmTCJVJNATY7xrbOUSitKQ3OIO4zVTJVuwQO8GSQlz6HO9sE3qF+hw07h12SxujwlqRRd8eaCLaDOO6Zl0lcrCxl6+RW/1GnNwAvy31iJyVJWQktSg7PprZlf8CxPUsNz8428gXhK4F3TRzXcPNf6h5br8HWVbaKQmMVDYu2ft4Olx4mpP2XJNibU7C1Ll0pC09dS6t2qY1BMbJ4CMkrSPUJZZNGmni89qYH4fErSkwHftRo75+xIopiZhK4qy9NpNx1k5FK1dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUxQY/ukP6JgyJJOk/EGqPhMz1IaACKGG+S6NVoC4Sw=;
 b=BAOB41wqYSiZame0H4Oz+tfG+cqHLwdklUb2gMn8SsTxWh84AgCm6DhKdX//nQUgSiM76nZnf1WoevgvHx7NTSt9JOdWpdv2Bj3w8vmeP6BoS4SFz3n8Qe923v0MOXJQgAUQZBpb9qA7LciR7GrXreSXGWUs2yxq/c+LMI9O+Gw=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Sat, 19 Jun
 2021 03:29:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 03:29:48 +0000
To:     Kees Cook <keescook@chromium.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: aha1740: Avoid over-read of sense buffer
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmwiv8f0.fsf@ca-mkp.ca.oracle.com>
References: <20210616212437.1727088-1-keescook@chromium.org>
Date:   Fri, 18 Jun 2021 23:29:45 -0400
In-Reply-To: <20210616212437.1727088-1-keescook@chromium.org> (Kees Cook's
        message of "Wed, 16 Jun 2021 14:24:37 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0179.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0179.namprd11.prod.outlook.com (2603:10b6:806:1bb::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Sat, 19 Jun 2021 03:29:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b99afc1-349b-4d5d-7027-08d932d27def
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB546693A8F5C49931494DB4418E0C9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 54tVnpPi6AMTmeo1XNKdSMSKl3UhVoZ+gnnq6wk2ss1VmUgLRJeqwrBmBdBvE8Dvz2yG2D0VmiqpeCXYvQex9cAcnQ1IXtj6ODWgHHT++ZgykGcD0w8phiBdUiSByyLn5UdnVWZjdkQECZQ1BybopRYDe93+XI2k0t/vsC13bttSNDTndaVw1rUKVt7/iAz0eYrHDJ3J2hDxpFKogiyxN6sdrMaIUMfSXBYxUQESV93o99J5xrQ0YDSQTZbdqFMnPTMFWiqL9D/MAaFotMqASbmyaw/vVoJ+I3yB+lIJO4j4U97wie6Lj2XxH3hg6eNlvEgxjfoIhSQ3BNf0H2ClSI0aAWssvopxTvD76W8ez64VruszTCP4ucQxk0/0pIvhaqaDWv9ZMC9TmqDkZzIQR9r5zpRwVJ9QWaS0Hg8K+r+ZxtyjrNPTnmm8rdjUBeXNUhotADttie+vHhj4y28PBYoHVnTC0XRZ9qckcvKOy/fOt48QF22sw+2LHZEaO3iCsGeQ39L7ORs56FzM9fV1EUBDaivV3hLeB6AAt2CFlxmJ8e8mWfKwmUc5SvhEeJ2JpR7Goj0M8FP1iOIzyCfHF9QoyNgyDqs85JHb/tLJEMreBeTwJg0C8NuKzbpKoTyeKgdYSHJVGO3ND00tloaGTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(376002)(346002)(396003)(7696005)(66556008)(316002)(36916002)(66946007)(478600001)(16526019)(55016002)(54906003)(4326008)(26005)(2906002)(186003)(558084003)(66476007)(6916009)(52116002)(8936002)(8676002)(6666004)(956004)(86362001)(38100700002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hxTlUhuG0xV0qY14DXHeypafcC615a7M5ds26KpRgYmGflK6GML4lRsUVJSn?=
 =?us-ascii?Q?lxHwM6MTrAYwTq8w2JRPgWlGWvV1lQskYqIGKF41xuXIJH8hU7yx3rOgKyqn?=
 =?us-ascii?Q?/E8mpFzYcuYZEAqMRu7oT+/aahBCt2VBfXmIDoAoPhvE9I0262vIoSje5dmk?=
 =?us-ascii?Q?DmnUqimZzgfgdJ0nDzaEAPVnTeTwBOXhQtHXG2dn5h43rctkiWSl1gQwDDLr?=
 =?us-ascii?Q?3YrHM+r5qdl2EvujVuIBJ0nOqcqZ1iaTFjaBZrThlmi4iVx3j/bnCDtf5YlD?=
 =?us-ascii?Q?DnobPSRgyN6l/GhCm2opWTW6rscSFKUUeo8UrRKFe1iu5phqoC5+hoGa9u9M?=
 =?us-ascii?Q?GiWRupNzp1kVCvIMWV7VZVEG/kxBlxUjSlH3C43+mQufWT+zJjEWO0vy86zo?=
 =?us-ascii?Q?3CMrY9Vkhn0AMU81rk+04JlNPIv3ZFkk0r/M2O4P8rMtv/sYGR4lg4YE8gKB?=
 =?us-ascii?Q?DX72qZhOaPpf4O/K0bl1k8u2iLj0ZReooSyofXLEvcJ/N50Ln6iT2ML4FarO?=
 =?us-ascii?Q?aYATbmw7bMHaQTyFu+FYP9xhXWtcieY1Z5Sfyl3yf23T4LSfAOHg88Nu/vwa?=
 =?us-ascii?Q?wx2h6CZEq6U/R55u9jq8jN0qSQlTd15aSxJCP447CQPLYkvStqfhRQ5OEHiP?=
 =?us-ascii?Q?fS608gNimlY9dlT20S+CVFwAY1+qNtegM7BKxXvslM7D0yAabKPy/9RdKjny?=
 =?us-ascii?Q?RrUJEoIUauOteTF0vATZBEfr9KMG5S+FysNIoOxMCk/44u9aLxW6pIZrdxQS?=
 =?us-ascii?Q?gUhpDUK8lgY/5IlSl6iUt77cNJJV6XOH9OyMFQMG0UkT37DOi0SA9HxDXrM2?=
 =?us-ascii?Q?9+JteWCrDfD3AbUpCOVauIBt/2Sciqnwk3JK99ImOygcJF3aqBQFGrdO4W9D?=
 =?us-ascii?Q?s56Y9VA1nso5C0Vkh3MV8z9tQGRmuMbArg9oTRvruNqAwFhuiFrLyXEQF0Ps?=
 =?us-ascii?Q?rk7N/Q6BuTKrjo5pP8d1HXFxc5M1rYh+OufHoRZFGxKR3WjyuwwxRHdoMFG+?=
 =?us-ascii?Q?CAjewO00g4PJXakhBen/oKB5OWrXkNFZWD33pypJtfMf1qKGzVqZfPfcS7ZB?=
 =?us-ascii?Q?rgNowu9n3VIm4K7x1XYcM4loX31Zk8LVR5nQ1Yu9gRv8TR61IcZAB5k5ZcA7?=
 =?us-ascii?Q?Q4sCZfW2QZ6duMH0fUuqox7DEeDTrbx5ESsEoW3I4fl0ulOaQUH7nHZrCesK?=
 =?us-ascii?Q?EBHEik//HTW6BWTBWmCcex+1n4TuTOFtIH+IXeWUr7Lj16i19UHATKCVSj8X?=
 =?us-ascii?Q?AWtSVO60PPFv1onFKLp1t0+RSAKtAE55A3czBLbnZ1srDgcjNKIh3DgTdlsS?=
 =?us-ascii?Q?R5XXKvEbDJ4Fc2KQrXHRk65t?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b99afc1-349b-4d5d-7027-08d932d27def
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 03:29:48.8494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g4K6CH4xJVhJkWWw+1XEQxRuEhhf8tP3XifRfx/9SW+mhRTZ6V+x+wMmBV1lwSrXhKZ/8wRLvSDCW9Sk7LyKX5CXfWFHu7QKnf3E0TXgewY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190016
X-Proofpoint-ORIG-GUID: uzFczUldR2lPnPLvO4LC1b6PnVoOQK6D
X-Proofpoint-GUID: uzFczUldR2lPnPLvO4LC1b6PnVoOQK6D
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kees,

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally reading across neighboring array fields.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
