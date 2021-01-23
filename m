Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1126EC433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B96DE23B1B
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbhAWDIk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 22:08:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59124 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbhAWDIj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 22:08:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N340wi030250;
        Sat, 23 Jan 2021 03:07:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=zd9yHia0xyCktuBmgUMQO5k5IaJkgN6akkrCblnkPyI=;
 b=prmXK5pcAjtUUBmr8tKEcwwaU3qDqcAB626Yjt/v8ab24pJB+U+CdjTDNlVq0WfO1MBu
 /TfkYaPn8KAi/pr70DJSfidBXxjrXc5hdwFWecozJFagvCNVnN4nxo3u5+zvZ8ZCW/kf
 mTa6ornwA/HYEEOeQOfyhG5FbFhO6B3VAeojXup/wy586QAHOJi37p2GuQUEUo5jQAzK
 d7zzciEA2ugVIf9ubX9xD5q/8jbxUxplpo0YGn6y0YM784M82oOIWISMM9SKiGjx1DS0
 g8x9Lds/uFMNx/EFsiYd1OJNTAxVIIs4K8wQBAR14WW2qyTfgTTWLIaIN/a+ZoBO2q3m 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 368b7qg1dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 03:07:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N2xqCI153168;
        Sat, 23 Jan 2021 03:07:38 GMT
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2059.outbound.protection.outlook.com [104.47.46.59])
        by userp3030.oracle.com with ESMTP id 3688wrcwf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 03:07:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LgwEUr9NKve8k0Bzbk3MlTGHDdRV0ccdpVY0VCHe4uUijv9vXERr0Kr60MO2CMdQ5zx7wbGGai4IeByiJXC776JyqrmO0cVvocNX4GDPsUs6oEape2Az008zHe7VlYMxZHnt4fd0/8ZOyO2UA1HfPJkNxJFL0QXBJmdbSAwmWpyuVf8DmGchCZtY6Q9xrc/WEOV+qmeEvMq4gtImEuVf5AHPGSI6wssor54s7uf0rPjoIrohpzpa54wOOqZ14jRB329Un8uJgvalmqeqQegD1NhqESFczlNZWD1Jwn1D2ESso8wmuOG0uyfbTuZNxW2UqJV++4u2Jd7hr6lBBJ62Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zd9yHia0xyCktuBmgUMQO5k5IaJkgN6akkrCblnkPyI=;
 b=ZWTJBAHh4tUM/uZzp6X8R5kuudPWr7ud2eImEgoNVlbyc7k4vK+6Efn26xu+CvSSljUH/VaKqF4tX4U38S0qerrgL9TT30DAzD+8OMJaDxDIgTEKcc+2ChQ/1EkLPpDHluz1rua3hoY/AFro14Su1d3zIrS4Vk0hYnpOK1+bHzrqzEH0J8A08Ed8UEPZ0Oh8F/etUcMU8efDWQ5GOiwIyp3OMFthNy6SwAL8Tn6z2mK9f0mmMnuONmtrE3Xn2EpnIzsc9Y5N/PdF40NOIoOjsUBzhi6JOtfqYxc6MLY4ysVIc4bNMdqGLtZ4OMQ4jXmVo04IKdkM4BHkSp9UpUjLKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zd9yHia0xyCktuBmgUMQO5k5IaJkgN6akkrCblnkPyI=;
 b=RNazuLWwZf+BvW6ioiK5782iDgyMn4G2THxnQ6RdDT7uAzq761naauw9Q1eaceWPOGeMXm3OxIiPR6gqrb/F54LO8VCg939kPUkLCzbatR3LeBmsVFXv9I/9Id8BiUpgLEDCiVI5bM0pS+YWkuddFp1d5Rs3lwRHu+ZQh+Qn1lk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4776.namprd10.prod.outlook.com (2603:10b6:510:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Sat, 23 Jan
 2021 03:07:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 03:07:36 +0000
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Cleanup WB buffer flush toggle implementation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg6s9wrw.fsf@ca-mkp.ca.oracle.com>
References: <20210121185736.12471-1-huobean@gmail.com>
Date:   Fri, 22 Jan 2021 22:07:33 -0500
In-Reply-To: <20210121185736.12471-1-huobean@gmail.com> (Bean Huo's message of
        "Thu, 21 Jan 2021 19:57:36 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:1e0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Sat, 23 Jan 2021 03:07:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eab6c7a8-aeeb-40f5-321c-08d8bf4c08de
X-MS-TrafficTypeDiagnostic: PH0PR10MB4776:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4776D1E022E47B6ACD53F6D48EBF9@PH0PR10MB4776.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1C72rUnYPmTiWBn1HX4WCimy89qete5JuhN2gmSE+x/fRLcls8ZDY/K9q95IAtzGScXWCgW1iw/XFPKollDJRO8O5AR89SBQityhvaAGAbIlEqrtc/q0mGlr73hEjke/t+60DOCpyNxaWofANxbb3k7eNwUPjgCrTZthpgstHevW8mEn64JqvRPuKS0P/4i/7eWjENvKtwJcBCUZvhIQPXvMWWAbsqxDrXisElfQLJBQN0BwQLkmzcldpb5BuqoM74/EUGpIGzpk3C4WpsPRb475XY099rffPvwmtnndc33bdNmAzwRQ/aWADm9IRRtZnXD6zSd6DI9Gj3V/OglW+QzJZSngxZJ9XcZXfKCUUV2yz3Mp3oOxPzHETRdVTvV63kPNnGQnT/DlXO5Ua2f7Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(366004)(396003)(376002)(7416002)(8676002)(36916002)(66946007)(8936002)(86362001)(4326008)(478600001)(52116002)(558084003)(7696005)(2906002)(186003)(83380400001)(6916009)(66476007)(5660300002)(26005)(66556008)(16526019)(316002)(956004)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?a03EUfD/5blpWWW5zu/zNV5sIpBRgEB0JFuQjSp0ZQBTj4pZzBdkQwVKzNKV?=
 =?us-ascii?Q?KHRhwBzLLwrOzb81oEqVbah/KkwJADi9aiOAHkVSCdBG4DwdLfCVB0GhLBw2?=
 =?us-ascii?Q?85VenFkRP6MXjUBz5VLY3xgYBWF+LwWirESCA6LN2bUUIpY9sb7sHxAAwFh3?=
 =?us-ascii?Q?tMnjOkPSwA9IIC9ktd9MFLcg54iVlv7DsMrptG51RTCXTVvTe7ddgk427TJV?=
 =?us-ascii?Q?UXpWBOvnNxEdkkX3yVrmDlU5cYvtOPe9rXPff5N03u9cfNomcb8G/gZhsLSS?=
 =?us-ascii?Q?joHa9O4xdJ2wqGnREIIxfbchEfwkIiAvs2Y0pRM08sJXTzDkxGKUH1BhbMlz?=
 =?us-ascii?Q?1eZZLbOMV4HRcEYs/CLg5ZKOyw/TPKBYCrZEUpGkpv7QjowbnhPUVyfzh+ef?=
 =?us-ascii?Q?xtX294D2nTzc8faJGCE64E+BE0c5EhaYq3p7kTQH8H7vudUFOt+3jPfDqrUA?=
 =?us-ascii?Q?Rrn/5VMRnMS0kLMzWMvJ23RsrSV93n7pjpVzphQKGf0jYAgncZeitnBVyAjf?=
 =?us-ascii?Q?xwHFcUmv3OE76mcuN4Ypb8HhJ02O8huQilyVvuJhsX9ZEBF0BivuWu2CzVEN?=
 =?us-ascii?Q?1e4c/qQoi6sD5TXF8R4BWjcrO/dRAL+kpLE0AQxQ4U/yz0lSNWD48G3bHjhk?=
 =?us-ascii?Q?YOMCRYFS1dGpY53tFsF34NtmICNzdLrdJhq+oLsFItcUfXGuYsAJmjSKbokF?=
 =?us-ascii?Q?/XujQjOaFBwWuRlRYYbGx7HbnamzfzmCW3j4VG2/C6Pxu7lDHe08lgYet0rT?=
 =?us-ascii?Q?ReeK2QhGyK1u2jT4VhuwaRTB2A1XPaFAIaybfb9rx1CHLBLWjCuv0x2b4GUM?=
 =?us-ascii?Q?rhH7zleyKnhlboAfYXuTF/VrXvtKCgQchZ/42c7vrt54mSBfkzAM8FtAqeTM?=
 =?us-ascii?Q?1M2vlA4eVBIguX8OEjxD/hUMKfI3u3Sp1SCMld+ePXc73ct4jBURiVWzUitF?=
 =?us-ascii?Q?lCNLJhDTeyvOcbVb+JSAZbrC77F2L2KeU9noOpWrR2kR8I6NrHEJ9JjbNzkz?=
 =?us-ascii?Q?XIcNGitLGprVHAQRsGNc5hv+kfby4IhbBRIWhLlihOSEdLMQE9ps5r5cS81R?=
 =?us-ascii?Q?EyhKKwk+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab6c7a8-aeeb-40f5-321c-08d8bf4c08de
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 03:07:36.1010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hu31ulhF44NDLGHnSVx7EwWci4XaeWrOg655aEPpXhjcluoPv42QTBc1yKdf+HDllOzMtlxF5gn7IHTmoCXbH8Ne0eLEg6NGd3KvzAMtqPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4776
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> Delete ufshcd_wb_buf_flush_enable() and ufshcd_wb_buf_flush_disable(),
> move the implementation into ufshcd_wb_toggle_flush().

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
