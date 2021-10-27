Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8CB6C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 15:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D587610A4
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 15:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237820AbhJ0Pi1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 11:38:27 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:58310 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232502AbhJ0Pi0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 11:38:26 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RF4YAZ029057;
        Wed, 27 Oct 2021 15:35:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0WZ+ZkNujXK+P9w6LXoiRqj3JtK3795kL+Q3z/q0EA0=;
 b=WMqn7xdmMdncfbRB50Jc2DZwZfMvFdSqQQuDWNElK8+5+hFGUqQBAe9AE0van/mdlGwE
 9z4dpisFY0I+WnVW2iAtvQgDIEpESsaPK95OuW/C+8hVjF8IdwHSKHFe/vtAJA8WTbs3
 MgGt/LC2rhXDCNFWfZA6ZCWU6G/d6GY2+KWLTK44jPxe6VbfNwHBciYmlGvVZhjatMx1
 qW7UBH/ZopLKXnhJbbNSUc3++KgogH56jk0it+/W/qsPXpCXRHTv4952+uw+HuBG3b03
 Xe0kM/XlDJVaXeORoyqn4d0UD79wKCCcffTEZJncPE7BZhG+9D/EawIWJfK5zByPAmnu aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fjm0e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 15:35:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19RFZYPn015163;
        Wed, 27 Oct 2021 15:35:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3020.oracle.com with ESMTP id 3bx4gcvry1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 15:35:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9LzaaBnKleA75/zjcpSF0V0tt7QT9YYtnlvI7iEFPCcb9eFDpRB8Pecp3FwmqD+BcYjcuAWgU8tPE97q5QAlqTJlYuHd8KgCluBhR5kGV/vEI5/1Z4o/GWsRBkhMZYXTJquR1dm7sQIS3y0u6H2q+2tirdxJlI70OVsnxFC3+fO5JDTWjLmPWbkonQJEHhna/1kOktMidFxduZOd/ohjBM2JERPPm4kvhXlau2ytqXmOqiJS4IcOkqEVb4M1ddQyWXS8rVBnry9QaweXLE2imDwMgeWZzhurqyRg2MB7MkUxJ0znoMwiiWeuq+vVX73dLHGCRxWVyU0EmE888H4IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0WZ+ZkNujXK+P9w6LXoiRqj3JtK3795kL+Q3z/q0EA0=;
 b=Ru8n494Zkx4ze6gj7oKVEI2jzmed2mPe4/9NZkk4dMjGjt7NSTECzlOgPEpAHIF382Re1MtKTZgMjiLYs2+FbMOhNqkFungYvLDEcI9C57UqT4MrXYkOgvAMiL5H6+n7qW2RZpPwHdIO072f5ENtjAJN/bQi59WC1m9Rb3frtbHAdjs8P9q670wNpBeua0khG6sGLScgrUhvxFBL+xmeI6UGw7EuHXiNZ6PFLIVDd1JdXeQc9hlzc9UqEBHCJsBvguS+vQhKdSAAi8J+/lg1g0fi9rPnurWD4QyElvw4zIAzNvCQ746gVAm8oD8zdtzXHej5iPpDRYHIknLfu8zWHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0WZ+ZkNujXK+P9w6LXoiRqj3JtK3795kL+Q3z/q0EA0=;
 b=jGODD8caaOvH/cldXTxq2pajApTSNVjqF7xP0U6nSgFTb14tJYGHsUmvhaS1aR51LO1hvvHoCwakoNzVXmU5hcRrcfOi0XD4jW8Fuxk4WwxDcEUb22h/LKE1ao5T98gr6DcLkPqtiyIyMZG8aq5HwtTFLTfcvbI9FFoEl0X7WQs=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4517.namprd10.prod.outlook.com (2603:10b6:510:36::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 15:35:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 15:35:43 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135om1p3i.fsf@ca-mkp.ca.oracle.com>
References: <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
        <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
        <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
        <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
        <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
        <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
        <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
        <20211027052724.GA8946@lst.de>
        <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
        <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
        <YXlqSRLHuIFiMLY7@T590>
        <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
Date:   Wed, 27 Oct 2021 11:35:40 -0400
In-Reply-To: <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk> (Jens Axboe's
        message of "Wed, 27 Oct 2021 09:06:05 -0600")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0158.namprd04.prod.outlook.com
 (2603:10b6:806:125::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.21) by SN7PR04CA0158.namprd04.prod.outlook.com (2603:10b6:806:125::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend Transport; Wed, 27 Oct 2021 15:35:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b39d729-b71a-4240-d77d-08d9995f6fee
X-MS-TrafficTypeDiagnostic: PH0PR10MB4517:
X-Microsoft-Antispam-PRVS: <PH0PR10MB4517D81B9CD9B21DCC5035388E859@PH0PR10MB4517.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PFSzvMRzjJYOq8AKQiNRacZn7HCG396RmyoZ7VYcoxJEmoDLmiSs4TzkF/bV3d9jgUtyb3nAwf4ivMxKG8rp+Q43A7JiUx4kmHe+F4m+DsNoPAULtTHw/G1000MAt6fcCLZrlk2YmnoyEOvKJQ0gUGIEEY0Z4oWqJrqQYoBVglu1q+K86Lb67OTQolRbHvJKw+ElPpV0dxh0X+3hLIaHAdZwb6zGzOB+0pyRnl2yWjpBRYcLPRaL7vU/UBaRJDGYWXW6kJEQrHrbv96cUpl9YUiDD2C4DEFYLs/xtCr+IazdDwSJ8ZCC0ufoz8fxCoNIopIzt3ln2eraEkPmFh1pcbnY9cnu29jhUFCFkTCyTOdL74fVhKzJFU3LmgLzQgB4yeH3tnoxysRIpcT1Sw3lkET5oKe8tmjqR+RfjBDPAQgdLze+pVhkMX77hOuDPK2OTSjpIdkKkQNnE6Qk4XkcUQM0veSET6HImJWat/kJ15mxRF4DYjSRJJbBlGo/sa02DYD6h5sMrQ9C1fLLIZObzcsn9S1G5wAmxhJQU0jPKVpDjVxqu2XFLolAVkwCvYed2M/234zroJUQahBau/FampAB9OhSqJ8t1a1gznS35zm8Jfk7KRKd90RBENkH+wfXR/dlo0j+h7IOve48CkpbqRYohglCXsjULB1SfKB2xUByNKnSUdOl2c1NEDXT3NO6uFdfy+gG+1JR+1OAzVoGsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(52116002)(66476007)(83380400001)(66556008)(38100700002)(4744005)(316002)(38350700002)(86362001)(7696005)(54906003)(4326008)(66946007)(508600001)(7416002)(956004)(2906002)(5660300002)(186003)(26005)(8676002)(6916009)(55016002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p9w5v1nKgQNhuLSQdR4bb4aQUqgYYJp7lYr80sdig8BJlMIbZrqXjUs+rfQl?=
 =?us-ascii?Q?tjAFSEJTkzn0qAAok3W8CPTEfz/p08t692dg8rwdXuylb0QPMW6wumuERC37?=
 =?us-ascii?Q?MwCVBzFRyMHnYjYVLr61tvv+fDOgGmXXgunQfNL0V85nPMG+yTYhFjCS5etF?=
 =?us-ascii?Q?6/ycqr8pSXI7cn0ZQvGaE5Sg0/JdCBxeWeNhWTZyxSw1kguwjMXVXZ1bmEEa?=
 =?us-ascii?Q?bDiuxGJNu9dstlepA9opPkZZ3ICm41BRt9mgiSePllV5wveWlRQV5PBm36Mi?=
 =?us-ascii?Q?GY+M0ffux9G87tpMejzaTLroWnelvsLWFgA/Q/XkZleuWKUxuwNksfCMNRuL?=
 =?us-ascii?Q?EEAiWYlNL4PJvFoGgG5zD0nmgGKKIzMej0DgH7gJfcfE/DCRlJMnpkbMk38k?=
 =?us-ascii?Q?uyKHeptiR5dobsxNHnvTIkOc+ED5Z0/M/7Xksy/ctT6314HeAq2z5KoKXn3I?=
 =?us-ascii?Q?Du1BTNPVgEXThYg1/X3yXW2tGY21ZPRkHjMw1rv1A9Hy02AdYoYFCSOlDi9I?=
 =?us-ascii?Q?1Ul+QPTwlxbeIZBcevW3cV2+K0Gg+aKVqWstr878Sy+a9Pp6NhzuSk8AG3so?=
 =?us-ascii?Q?7u2u3m6EgjsWYhut1BeXjbkNbMPrSnsbZG4BtOS7pxSoc31XprJvSX7+CiKA?=
 =?us-ascii?Q?P2rVaG61gcMRDXiwOben9tBYXR+xxkCzkuXyupPRqntmoVhw6gz2Z0BUghWW?=
 =?us-ascii?Q?kmPgDgY5Pzc5kIkZLzQ9YUS4MsbCbtVuUKUXazEp/+BiVOlY6AOoErm937jx?=
 =?us-ascii?Q?nPh3mkRo40XNOa4mqNwFmNRK7T8pGAafSIFWM0OR+CdgZZOgdxT8Xa9gCZPw?=
 =?us-ascii?Q?ZwExQnYxj8YoMCIFrmmI3gRSBi+2PjSeGyJVMhMXX8bNMqK4TfnPz0ZSliQz?=
 =?us-ascii?Q?DJwbxwVDeFQGhMkGCAkegc/MtNuBnST9LZ7PbKl/HxMXF1xrhSJFM1nnePGo?=
 =?us-ascii?Q?s+aC76LvVC3H2dfBB2a1IPz4yZ8Ebjp0giQyH1+6jXGykgvd0xKtZO6X2l+m?=
 =?us-ascii?Q?CyHDVJnQRKxa3iRewLcYOnvLW2FyRlIFrBvBrQuF5tWIVJxqtGketuVp2u9A?=
 =?us-ascii?Q?Ni6OdN1zfoVpQYhpe/VRxaZfXkUzD6M7A2At4J8aVHoeLiZ19YxXpon0xhjK?=
 =?us-ascii?Q?XLPkJWJxUVHHRBCr5mUcoMea+z/wfIvGPXiapQZjGuQvEbJwC5tJH1glxu7g?=
 =?us-ascii?Q?AUln1Trcf1ZOSWko9TovkWoVpUTODVSERhaX6sMPRetE5j7MKmVP45hgesia?=
 =?us-ascii?Q?OK1LxibwLmRBGaPMvgV2SadUoD6kA0Qu6WJf/c3cISoy8X3LgQQYTZJNeN0h?=
 =?us-ascii?Q?IQ9yXeGBXsFi7syeYqcPbVXLNR5R92w8HjtVL5y8Q+UF+I/EWN8pa1hpWtDA?=
 =?us-ascii?Q?kHkY30M9HuoBJZWVl0YsGHhDpKJcHe4e2tTxxYDSoT/0uV/wNlQZCdO4pQ3y?=
 =?us-ascii?Q?LutsfCjkvk7brG3Fvapf0ef6VBXhT61cNN6PlHTGvtGFZ4tTeDG2vglnHG91?=
 =?us-ascii?Q?CKUQVcgGUJu1F6tTMmWzw95O6+44ZNMptG3UfwzlIY70cj5KuBxZ67tClNSi?=
 =?us-ascii?Q?RFCpjbu8BQHjaUvvYpRTftstIbPb4AFREaIVkMZloS8lCd6qX3ycX9nhDs4V?=
 =?us-ascii?Q?i6MuBk1fdeFNK/VkpjpXNSajou81og/w2iHHWgxplx9tZQczmFYX7whyiUri?=
 =?us-ascii?Q?nwXh7A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b39d729-b71a-4240-d77d-08d9995f6fee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 15:35:42.9647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UBAuhnksjTWiAL8e1JFJTWDWe9sRGofm+Z2Zm1HFl7M9qOUG1qCjRnWoGO57BqrRPMTP6nlrRDUx7E2ScaJhiSGabNfOJOi4SRb44eprs2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4517
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270093
X-Proofpoint-GUID: b7B8ZDNudRSyZgLaTU5qSHHks5txGi4v
X-Proofpoint-ORIG-GUID: b7B8ZDNudRSyZgLaTU5qSHHks5txGi4v
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jens,

> But yes, reuse of the existing request is probably another potentially
> viable approach. My worry there is that inevitably you end up needing
> to stash a lot of data to restore the original, and we're certainly
> not adding anything to struct request for that.

Yeah, I much prefer the reserved tag approach. That was my original
recommendation.

SCSI error handling does command hijacking and it is absolutely
dreadful.

-- 
Martin K. Petersen	Oracle Linux Engineering
