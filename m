Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A2AC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 03:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F3CC64F21
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 03:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhCQDdB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 23:33:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53188 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhCQDcx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 23:32:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H3NpNh008154;
        Wed, 17 Mar 2021 03:32:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=pnydDBza8X3smmQxQKi4tvZMNbnaLWQf0mPegi7E7z8=;
 b=les5RsrN1tfJpbuvgeoTIZMixANNfLetBPA8+934sICoeVHU6FJHMuKMIFzh1HuiXyz7
 tyPG07FpbyjpNLa3obssgEQz+tUD67LienAlMTxXupERTbXxwxZ6fLLHGfnKH1YaSaeH
 L6aprmL5HEFAcwMVhHbuTR464/9ivA1Xb/gwe/Eotk1S0KUDuPHRQMC/otdEOyFC0MUQ
 PFXBpaZ6Vj3bXBOFdL0HYeHP3Hk4kahR4nisL1qi/lDvmdO8cqoqFertv1TOySrBnSfI
 h7MJAjzhM9ztOMuoqnaVH3ffk9J1KSmTS2/Y9v20RnUhLGiXfC04C4PL1vn0KVqVytzo aA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 378p1ntms8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 03:32:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H3QBGP195576;
        Wed, 17 Mar 2021 03:32:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by userp3030.oracle.com with ESMTP id 3797b0xrrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 03:32:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPKVVWttgraPg+pG5IOM16IPeqClXNLuxqJC8k6cVd2di+M3BIG3vjXANgywTi/fFCm1Q1TlR6O26J7fSVwOWtc/jpG1pCtUDH59Qz4cuGhuD0jZx2+9RytWAKAD1r3fszmLdCFmgCOgZ9aorgp95sLcUzUGPJEWbnlBmjS3sIDgJkohBR87tMcizxwsmcw+/BJGmJGRJ8UhCdaXhgJVWNfKxX9UFgO5cHgyaL+eyOF/xmlD4SOjIUKYQ+pmbJnSAU/BcOcBaQA6GZ4l0fjYKrxUJX0u9H5sgh4IxBUER5WhdVH96MxvlH+KCjjlOmGys5JobRv2E2CbuW/DXvAE2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnydDBza8X3smmQxQKi4tvZMNbnaLWQf0mPegi7E7z8=;
 b=itnruLHYH29N+0WJscwggK1+gZzfMt7EpcfNgbM1vdCPBU3ebIk36UFUHjjKIpyvFcxzCGe7luA4S1H3PngTpDycSuKHjFAIpo7bzeGFcINToFWE9luGzacQTSSNcryKZAWcAjm97W5wzxoio4ggUsxvx2M3Mu8IQyeQup71KGJ2WCnFw/I/4Mz7snReUn4sIi69MEcFgxIIexHgwvDf8syFNlZ+vi96c7dPMHomgrBztexnqQp42FuWyQvkh9+GgUnRRkPgPVvjlKsH2gqZsihDCyJW2NX4vOzWWilLWjX0kQypogVrqHySzWpOw9XM5PW2U05yqvlF+BqJCf0Avw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnydDBza8X3smmQxQKi4tvZMNbnaLWQf0mPegi7E7z8=;
 b=dVEeSXsOhqFIHjyGSLTxRMMUriSvWIxYzJd2lM7xbATHItpSWP3+Ndh+QbrcsHvviVQ/tm/ScbKNwOWwSQN8/OPnhiK6epVAalwo1wZpZ13PhIdeHYPoj2JVItYyRTUIQWUdQW73qVyVavtDcGRCozZaZm1+gy4PgPzsV8bC3TM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4726.namprd10.prod.outlook.com (2603:10b6:510:3d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 17 Mar
 2021 03:32:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 03:32:46 +0000
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: mpt3sas: Replace unnecessary dynamic
 allocation with a static one
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eege1mlt.fsf@ca-mkp.ca.oracle.com>
References: <20210310235951.GA108661@embeddedor>
Date:   Tue, 16 Mar 2021 23:32:41 -0400
In-Reply-To: <20210310235951.GA108661@embeddedor> (Gustavo A. R. Silva's
        message of "Wed, 10 Mar 2021 17:59:51 -0600")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR12CA0020.namprd12.prod.outlook.com
 (2603:10b6:610:57::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR12CA0020.namprd12.prod.outlook.com (2603:10b6:610:57::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Wed, 17 Mar 2021 03:32:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7aacd207-01e9-4533-56ca-08d8e8f554cd
X-MS-TrafficTypeDiagnostic: PH0PR10MB4726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4726EA53DED7F66061B95B7C8E6A9@PH0PR10MB4726.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /4ZI6HsXegd0Mrqs8e+QHvA9KUyQ8o7JsFu2uRKvWINM62TABXf2sJbqbAVgaOcwcbe+VgGTnZSBsop2QrKQ2BM1PH1JZuEg1USOCptIdjyLEOtM2pB0rL7idqJnfGRl05Cu70JMe6PG/e9/FgKpTX5WNDXSXCvm3i2L56xoOTzkLzeqQnQ9qyNwLWrDa5AqBw9GgQf4rxlUu4xHJsDy1UP4DX5Ex+E9tQI3h4FJPAoDQ+qbO1KF8sAMwtNIDL8H1oO28B2Welne3hG9wXuWz+0+OREYIfG5Ia3rheqWVUahB6iClc6kjK2rGMvPzKkhiSGUmkG0ygcCc9XLqq8rXmAPx7+LCUD8NltdVeaCN5FWsXDWhJw/XaMVd30WNLodySWr/xT/ehfPGSWQTem+ivj/d4J0m87BLAE0iMxRn5JcwVv/AHQ+3JH+dj+TH9kqM3QsMHxZ+SUyI++2QBGd//y08HFtseI1cEgNer5x+jndI0A6Jy/QXVbZrdm1J9RzTV+YEuvaS9O3S6KhDihkk3p/abWTdyF9hwml3khmWFLHoIIWPkn3oYvABrQs+8cPI0APR5LNbwE8KciLCRzGMSqyG3uLHZqbALPy1X4X/0o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(396003)(376002)(366004)(316002)(6666004)(54906003)(5660300002)(478600001)(66946007)(4326008)(66556008)(66476007)(26005)(2906002)(7696005)(6916009)(8936002)(558084003)(52116002)(956004)(186003)(16526019)(55016002)(86362001)(8676002)(36916002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2MR2BQBzjBe3PvpSX8Vqj8GneHDNlEzPS+5r3EQDHwgqV1FG0/y3AaOJT+lv?=
 =?us-ascii?Q?bp/X5vXM76mzeNnk4fIDQ03NlAEMrCFTza2qtHaO6hbvXIIpWOQZR+0xhlPr?=
 =?us-ascii?Q?awJxs5jVOjWnft2cIqVrISpRTn5mIuzs0vqFp51xZj57hUcLwgYAzkNNbAXd?=
 =?us-ascii?Q?lrBJCalZhG0t2EzqG1kMhpRf8DLwnc49M0Rdm3MicsWh7vxscbzG2DsJ/AtV?=
 =?us-ascii?Q?m6LJ/rwRT2yC8tt6f88/+jP/TdOzFOwFL82wpkc3DNUmMqGvGmZbbcepltiZ?=
 =?us-ascii?Q?LUDAO7/1nlilqpXO1R8CS8If9e3zWpvdXW1AmLEa+lceyFTq5CvDyUgZqS7v?=
 =?us-ascii?Q?t9PRo+YO5tC8s20V+IsZWxrkLYIMRQNneb5rVBrLRegfdRyBJjHBLf7HVJOS?=
 =?us-ascii?Q?7Li5Cp2j8VRWFY8bNCY0IYz3whSx9J0KzFZ+AS//U5Vpu3/LGJmYlpg1UlH/?=
 =?us-ascii?Q?iXeiagqSdUXxFDnNYRRivFuyEXAWhKWZhip6Pbq6h+WnGyty+WtGjmQbaivd?=
 =?us-ascii?Q?H4MPyzFuQRtPmhdwrQ5nS1xNCmhZgoGCrtxDOL5Iv6FlBB01/ci4GlFTTAq0?=
 =?us-ascii?Q?PnIvhx/iIHjuylvVBqSh+fQ99NHwbpT8t1mv2JDOiGIWcF7884KOkWLdJjjb?=
 =?us-ascii?Q?cL7JsjTHESmdPd40E81CkHA5KZ9gxP0AJABntmcCC8v+MqecLNkGlYq6u03E?=
 =?us-ascii?Q?0fQC8e9Gy3SEWYOe2Z5MjNtCdVxJbI6smmAyQ7s0A2GSk7IWwpZOaH0XI515?=
 =?us-ascii?Q?V5q7S/09s73FLksUMN5K9Kf2ZKLGbd2IA5u7AsWQFe8HXQITLi4weIyM1u6P?=
 =?us-ascii?Q?1QsIRk+m27U21Xknos0s3pMHEZ1yMfWNIEPN91Oj+tf+CauaTSLbB6kRb7j9?=
 =?us-ascii?Q?0lTvRZsqITWpWV8ZSQgSmdpCdQgNA7/KF+N20PeH4yBvBnniFqaltZ3ImF/v?=
 =?us-ascii?Q?PgsyPrSyBMszzHst03DIg+goTT9EbxjVMglAbFFHjgrLsjWxfNjxAT7BhcDG?=
 =?us-ascii?Q?YP/94bOI0xB6g2OJjapHNt2sC8UVJU+zBtdvAHejJfRhdabQbkl+AqDasr24?=
 =?us-ascii?Q?CAThhdAsHOqzVwLSH1RRk3Wv4d8RYHCr+HXeg1svU0XY3HfBtgGTpFLmxAAx?=
 =?us-ascii?Q?6ejfPn/6tOIfWMHPBwt/JRHEbM13a+Eennq0G/jBmk5dPDWKPj4OnYwhnBPO?=
 =?us-ascii?Q?hH+yrb59/caqzZJ4zDJ3qCY6Yb9uDoO8wdCwCPXHt975e7n8oUx2P+OTMB+P?=
 =?us-ascii?Q?I4kEUpCxBXU+hVFpcT32URzg7SEKV5v3gUmAnboIw+yrcCYYOkFuCKPabaBI?=
 =?us-ascii?Q?vyGtgIgc3585L3hGkcSrQg/9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aacd207-01e9-4533-56ca-08d8e8f554cd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 03:32:46.1444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aiSJYLuXwytUjFo4P6vOsi+zonzJl43l6WBfIdJwkSxGBpXs9mTNmnppvbcFpfE1+dVa8AEAekgcJZkf/kpcPQEtXKRmOxDM46rWX0rYb40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4726
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170025
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1011 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gustavo,

> Dynamic memory allocation isn't actually needed and it can be replaced
> by statically allocating memory for struct object io_unit_pg3 with 36
> hardcoded entries for its GPIOVal array.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
