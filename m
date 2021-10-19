Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344E6C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13FFF611BF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhJSDMe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 23:12:34 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12574 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhJSDMd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 23:12:33 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19J377NY025772;
        Tue, 19 Oct 2021 03:10:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=R0v22G53GtUUnEO600nB6NKLGLFsNVMDbX7IM06OJsg=;
 b=whYp+dCj6wfKRVQePY4foCKSxAN+MKC1ItLHOcwHIX8lQbPM+2+Z1HXijc3OiEZyx6/M
 lxWwC4BlEN6HH75GwIu8ValD9x/Jw0fwPsQ3uGHBuj3v9f5vFwb2eEfJZlUC3EGEYUAB
 yYmwZ7WRaJnG7CDy9r1rqxDfWP8PKzrISMDgtzu/OvMyW5uLnje9+5JhcvP+mZx5VRGd
 PaB+bi9jHHFnC599Z8N1sqm/iWZYZWSQAGS8AsEigGSGDLObVeCycN8aGqfZkX17gaJF
 ZXoFyTB+YiUSGKiy1XJwakdm+V5oKyokduiCXKa4eDIyhMzQwLTOEGyzZ7O73uqaTdOr NQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brmkyfrha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:10:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19J35TW9098385;
        Tue, 19 Oct 2021 03:10:16 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3030.oracle.com with ESMTP id 3bqkuwh94j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:10:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckCDHS5l+zPTwv1KtiEJT9sFp+Yjw33SC/H5eDsZ92mRPJT9rPzJpCFfQhd5CaRd5iebTh6ThAdyTFmo7WxhQXQt6l/6nDY5q6xXOG1IXuRIEcob4hDdBL8ksLLJ8X0HHjwHt5mIBRc6yNMpbevNqaPbMKO/xJWLqwzt6v9nff3GsL6diB8F4hDWCeMA0EPGVTVrP/5ndZ9VcBOPaydcTn3tWq2LHjEts4qD1J0/IPEeDtdPOk+daiwBmMEwcZz+wwfcbgUHY2XFmG8bnbu2izN37knR7hSX0EwoIqo12mplZKGT3852SOVlcBtCshjuh7PSkR8NkgqwXwWIP2u3UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0v22G53GtUUnEO600nB6NKLGLFsNVMDbX7IM06OJsg=;
 b=kDb7EdAGQwEbrOeR1FjuMMNG/ywMAmKlAFuPeJmVySw0cRqxAwKuEq0Pa+s0pihThg/s1LWudGBW5RL6+8Ehx1GF8cmKzRsQwIuUQH1ogW14wqic/pY/q8VKqlZ0lluh9hIsYRhYAV9GG++QypP7tdrRH0ammzRFj0OOxz1/a643pdeCjSY5ab2vIgA+mq8PqyAO1DmiYfm8rRV5wZWJptgM0i06CHHWpl85lfOkrREN1jy0jZiLHOTIXP9fi7dJYTgsMN+WggXyv5voCtNjrdYoXqFwCixz0e8L6rd1kgMf1bbuKn0dHIQ5jn3YNWfPtMfIDfNy9UKI3Im3UwuZRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0v22G53GtUUnEO600nB6NKLGLFsNVMDbX7IM06OJsg=;
 b=KZtr/HdTYTt9NjmaRTyjVAw0a2R1038SFnMVzvMkZOwLM3soQly3EyLGFmii5NK7TKopP++YZq5e6YUXWwl9WEffKqdPOu2FnEbfJUDDR5ofurFLdB+obIS1oO3hcGbHTpdqqW8AvdJYXlXiu9uAC+s1FxGfkbk0Vlq1ygN3FO0=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5879.namprd10.prod.outlook.com (2603:10b6:510:126::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 03:10:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 03:10:14 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] target: stop using bdevname
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6j5d81d.fsf@ca-mkp.ca.oracle.com>
References: <20211018065052.1822500-1-hch@lst.de>
Date:   Mon, 18 Oct 2021 23:10:12 -0400
In-Reply-To: <20211018065052.1822500-1-hch@lst.de> (Christoph Hellwig's
        message of "Mon, 18 Oct 2021 08:50:52 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0146.namprd05.prod.outlook.com
 (2603:10b6:803:2c::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.18) by SN4PR0501CA0146.namprd05.prod.outlook.com (2603:10b6:803:2c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.8 via Frontend Transport; Tue, 19 Oct 2021 03:10:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c570dd1-9ce8-4566-5682-08d992adf884
X-MS-TrafficTypeDiagnostic: PH7PR10MB5879:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH7PR10MB5879146E285A8C5543358F428EBD9@PH7PR10MB5879.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HgjIfpkElOKA0zSIHG7uf9nPgPyUY3T1c6LiMaaLgSTzpJZxCsSHRlZUp1PnboKU3tg10JwUDvrcwpvE1SxK3DbTm60ci/dSSxJpeK9qLLgTu8npwRa3zS2rI3m1pi6TS91jNpGlVPUyJBSCXZlARXRFBH329PKR6sJuDH+Ir4iVEbKe8nxVWeTzvtJYrdjLXwvH4JgnWfK0PP+oSLrXCKz0X1azLmBmqnWK7dlXz+LYyy2/D3nWUY+i47tt30xnxjVTn6gM1kQtfO3oy6KrNLNDvzVbELiPWYPwxvizmnVFSwaOyCILcj+K7JUhM6rOQHURWJJYY+WRDdS/TN5700OQrgD8YoXkP++JJs6jA36b1KVqJ2csfJ+2gKWuEkIN0TGrp0+oKYbr4WABaem6ZQR7ssnzWZBYd+cm4bj73TwbLT3uK+eO+yNGacQaLUYoABf0uDKYgbysXcVlUKM3vHkQCH+IkrOU5tAUJNqS6f56qQjJN8WtSNN1SiK+yp7f5Yj0418sFSbZbEHLNTL8ufMQL1SFE7fdtJ5iOR/7mbbRYPHC1j7saZRj0Z3e6tWMEUe4rUrrVYVbVEwzFGIHyi4GKC6I2q+LsRPdYUsv6F5WcwcONs3B+YLFFTUzB8c9tq/Ylz0ZlSU7dOczGbSLSc9Kc6ALQRL4RrSmts4g/b4cc8bk9Jholk4IOuHQ3bCnBvBuQojBmoSSOT3WjoiAGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(4326008)(38100700002)(5660300002)(316002)(66556008)(52116002)(8676002)(508600001)(26005)(55016002)(38350700002)(7696005)(36916002)(956004)(86362001)(66946007)(2906002)(66476007)(186003)(558084003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z3xtxtqil1IEwyUnjO5tCzkQ7BKD6wYc9ZAJtVnRkEEV9KGMwNOhZxtL4Jvd?=
 =?us-ascii?Q?ebZ7LtWUrRqLmx8Ewpub6HvYXYYqjF3ypE3MelmlCiC/pPHufx/I8DxZpZPY?=
 =?us-ascii?Q?tcQMRwsSP1+SUNyD+3Y4vmU7JuhNgEJsihsAGmhIFxINM7FU6S2UoNx+mjE7?=
 =?us-ascii?Q?dO9mWC6gibypzAfEUoy/2OFIyqJsB8+sI8XmcdjI0+Wm6unjv+sWHYmUz8bF?=
 =?us-ascii?Q?eUiGjNZfMjiHL305Wy/qrvhqQejiuig/N04J1OrQESFRd3RSLFJLMcKGPbes?=
 =?us-ascii?Q?/F+qu0LA/9HZthhr63PffCzaW6MUWKzLk7hsuwwk7nhmiPjHgXBUXjuxYhlf?=
 =?us-ascii?Q?6U7zA8NAnIdfPAB28bhsHK0rwHD14MwIsloBfjycje5jwzc3TV8M7nS9bRA+?=
 =?us-ascii?Q?7INkTwj7ikru8DBS3y+P1Xth/BznjTqmtyPCYWrJTrOe0V9uqbv9vRl0LsEt?=
 =?us-ascii?Q?l++4nalp+KRAgz/kFcEqF51CtorPpTG8ur0x8whEuaPFwWy5Z8tutiAY6GPb?=
 =?us-ascii?Q?h5utitjdAc4yH2hg14uidCK5u8C9TQ9iJhsxJBZCtXwf4DDBbn5xe7imt8Sl?=
 =?us-ascii?Q?xWEg8vtILnKvWA+9PSIDW3C9DR/B7Z+OrLqdp9zaqefFn3zU2sySZCp4lj9m?=
 =?us-ascii?Q?a7nJRXcitbpJsYHGwyoRQl077HLUJiKyePZqsJgaxhuP84U1eis/PaULpQue?=
 =?us-ascii?Q?pIrVtvOs0IdD9rTOrUHNOfOgyJ+drzU6QF+8/EVSE8Wrm4OQ8XsrrI3yukad?=
 =?us-ascii?Q?iJNvHfOsy0B/19m1k8ZYhg4wIOZY/+LqTSI2ge2LPNh0oMHKzkK/r2okWeCR?=
 =?us-ascii?Q?VPUJk0sWLmQIRyATd1suxlGHJAUFPdiKjZIjoB6MdjCD69kKKUf5DcbiLgj7?=
 =?us-ascii?Q?RvCNpLOv7SVg80sEsHaG9KCs4ty1pXYyP8p85zDlBarHDNmhXehSVkaA8CNo?=
 =?us-ascii?Q?QubT1URkOuE3/ulMJfHoQ/WlFRZeJzdlRq6/WU3Jmk/HJgyhUJDHSE7YdnHp?=
 =?us-ascii?Q?wCcjKOEPrmVmhAYxw+/FPCNFxYHqJDBssoHTcCtp1ySaG/nUKIxGaIExGbH7?=
 =?us-ascii?Q?mm254GJuRLBpwAWnMqBPhqTh5lW9ywSvHiDHRw6bOrPpnnrpZkysYcS7aSi9?=
 =?us-ascii?Q?9GWaVDS9rdvHBUpXxuoQl619zvQd+bqJW527snbVuvlPsIZ/dgYLrDmItOUA?=
 =?us-ascii?Q?i5z1pi/R76q9vYtH/UnDWkzT/dQjw1R5/qj7mMw8lVT68GGP7lEFK0WL8TM9?=
 =?us-ascii?Q?Mh995e9lqIzPmtmRVEgPSMATNNeuqwANIE4F3tmXs0zdw8l8xs/m+A0jm6j3?=
 =?us-ascii?Q?+niO/FqpuoXZoE42yrcfBHYg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c570dd1-9ce8-4566-5682-08d992adf884
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 03:10:14.7131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rgUQPTF+q+4VwQZxSC5JdTesIdCv+v7j9doWf7D2j2oTZ2i0JORgmA5mvyB685YnS5dm3G3akiB5uvLESBMr1tKgIohsVuh6CMb10jUlbQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5879
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10141 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=772 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190015
X-Proofpoint-GUID: -M8QiILuGSFZd7GgyoYOOKYN1QwJup9p
X-Proofpoint-ORIG-GUID: -M8QiILuGSFZd7GgyoYOOKYN1QwJup9p
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Just use the %pg format specifier instead.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
