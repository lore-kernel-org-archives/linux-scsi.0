Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BAF5C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Oct 2021 01:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D24160F35
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Oct 2021 01:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhJWB5L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 21:57:11 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61080 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229597AbhJWB5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 21:57:10 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MNao7F021645;
        Sat, 23 Oct 2021 01:54:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=EJk+ogtj1AItRq0Vm0HjzhqdD84p8xlvMeSBuYYXjsk=;
 b=iQNuXc5s+h+rv7ZOM2cE2OEDOidu5MTyHjgUKeJSDrd6O3zfUrkhRGepX9rjIGr3REVo
 wo6K1t9ErnKrbsQnyho5oVcFpwQHsvMY60QbWAR/npFzG3lhYWp3Z/SUB2zF7a2xFQvb
 301mzzowcao4ur2zIQbJ0PqYTMhQMF+88ycY4J26RfIU6OS6grFcZxbhlKbdhX+De64p
 7uOE07X6KFWNw+zBlnl/cyVa9rNHSf3qj4CsfDSaCvMdFkZh8TfGywPqAGIa8O/xnXDy
 m4AM3iklWp1WSL6MMZincNDq84o+O/rqVuKKIDyR80ntJy94Hr8pZfcdFwNDNwFpJI1G WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3buta8c9ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Oct 2021 01:54:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19N1jLMF153266;
        Sat, 23 Oct 2021 01:54:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3020.oracle.com with ESMTP id 3bqpjbeann-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Oct 2021 01:54:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HEWtJdxUGdS3D195+6PTcF/DgaYL2GwkIg/j3E9aUdRLNwkr2WLRmSv5KYEiqjTNfpzmU+M/f1c+KopKrTmxeJkQQgJp2xTqiAlPAbOq0xgmC/Uo5yM2EhYGNADJ0Q6nyRKBMkucDFzk9bDWB3kr/7XvDNIzuq7YoLAA0VSGULLW6RsYWN6Y4Bd5DsgDs1bXvkK9N37W87HqC+YDUB8rtJmbk7J9RqQF6KkPCG5x1nWe4gJ4zYAol8QQHkUA0m2qA41WhiZq7+bCuJ5vYkHyDeWUWcpk09K6zdA8cq4UXVl5vWloLVAzadS4Egc/8HyinlQrcUHX14nRAw1QfNJS1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJk+ogtj1AItRq0Vm0HjzhqdD84p8xlvMeSBuYYXjsk=;
 b=l7omXqQYX1u1N1MJ1TOrWrKB5bOMndsIR3zbfFpmNE3nirit48n30qcZ78wH0BiCW92fQ69CBaKs/VlCQ9wUP1AjlXPJuOKVpR35UeQ6rTwkaJgE5OyVu35mqV7QvpsF7kx34JPqvYG0WBiFt0WX+5xErHaODTnGIsXq14z4mVQ+lOfC5bEq8VqEh/qdulXgCVmBxolEAz7wIZKQFTA0Jv+cRQqZhuRGXPnxY2UlDRDvYCB0AHemOPMQG7ziByIX3MUBp4HRlqUePtdPeS3VCSM/kpJQ0ovvW55K2P2JEEjEJgiIsPWbcZ9BMyIV3wK3QMe0G5T0kANFJzHl3SKwdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJk+ogtj1AItRq0Vm0HjzhqdD84p8xlvMeSBuYYXjsk=;
 b=Q5t+/WWRDuzsVwPLHt9svl8+qdGLxA18qDBXXwfUCkJRfWFcRq+CVLIMVMNyRo6rjKLl0lUYUNPndxTGN8sYfUbWJbUFQW2c3EIghCW8rbZuVXSGFfz00SAbV0Zltx2u8K+xzmH1IMAGmx2DHAU8Zh9XeRtUzoe3sxKk5OBNHyM=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Sat, 23 Oct
 2021 01:54:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4628.018; Sat, 23 Oct 2021
 01:54:46 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: please revert the UFS HPB support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ilxp68x3.fsf@ca-mkp.ca.oracle.com>
References: <20211021144210.GA28195@lst.de>
Date:   Fri, 22 Oct 2021 21:54:44 -0400
In-Reply-To: <20211021144210.GA28195@lst.de> (Christoph Hellwig's message of
        "Thu, 21 Oct 2021 16:42:10 +0200")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:23a::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.45) by MN2PR03CA0013.namprd03.prod.outlook.com (2603:10b6:208:23a::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Sat, 23 Oct 2021 01:54:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd62168e-e96b-4adc-ecdb-08d995c816d3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4421:
X-Microsoft-Antispam-PRVS: <PH0PR10MB4421C3A310CFDD2786885C7A8E819@PH0PR10MB4421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t2ew5z0Ao1nIogmXnQmavTytEZkkIcoHs4zDFuBjPVsHadkMp7fhDxPk5e8upYl7Q+WSJR6f7F5CPnqoj5pXW9cDC7RmWpyiqHKAaJrq1+uGZFR6I017OlQ97Vcso78sV9GSKlKg2OxU4Khi/54uVnkWEYIKFTsSg5Mt/qsnHJnwlWSZoXAFNgEHTNevuLgKSzPyarshUtem9z+oAFDIRLbi/lhe3bCagz1sJikdMT1pTXwCtS7pVvmuzGggHDZ0mjQREh+xeJRnrer6VLBj5O670aRT4rc9aiBgld4phr4o3ITo/T6uGi03clX71ZDmHNyDx1t0EpEn6UjL9Ea20OyKqun3BIUk5VT6UosuDYXfpkrU8B/9al34+SqHkmpPQJZaz0WS9YhbkiuQ6vvex+C+FiYwVSt3XVi7jlT6HhSkRF7M3MfhEorI01/k7g1Sl7e+/Dk6/C5kw022/iymcjZd/HsbjaTBy9oyK125Q49/LN0iE5TjrilHus4dtah0UJwdT9prwty5R8ndCuGh1/vDTEsrmPgnNbDQlxQs/T9RNIMX+NjVw9P+66hmB9vXSWpGWhoBAux/+noApDQ/8jS6bmE10TJVy873rf+/+2Py0RkCOG6OWCh4N94/Y78f8brlN5FrLdNyBYTihLS1l335pAh7YEPEzd4Vm/PkwLsRC3bNHQ5mUrs5FbCXpWOtERvtvlBt8DzJn/jEVNjx1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(54906003)(83380400001)(6916009)(52116002)(8676002)(66476007)(4326008)(66946007)(508600001)(5660300002)(86362001)(316002)(38350700002)(186003)(26005)(2906002)(38100700002)(7696005)(36916002)(55016002)(66556008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rJ8uIBVw3F0Lgspz6/Tzqf440dtd46ihqILpF9f8fh6WlrS5+EADvE14dljH?=
 =?us-ascii?Q?o3dRHYzow1zZFBevxFC4CGcbOObHlZmCDUPQDHmxeDMfp2oFWr9+XWUA9dxy?=
 =?us-ascii?Q?iQkp0W9IuIz/0OnIhRx9EGGJyJE3s8uE9695gvt+ZbqLMyPwN+VfwJXmxyy6?=
 =?us-ascii?Q?HVSFIbyI0pyyrFbnv2Dtv1Khp8RFO2k8J14hLEIGveY/hRjqlYVVQyFaMMh0?=
 =?us-ascii?Q?3ldy+h6IWjoDCL//giiuehc4XNNHpboQEl6pDRG6ifHeK9KksomDFoewtLT8?=
 =?us-ascii?Q?GReSXL8k4JiXO3V1POkS3u+EnuyrKRpBddykYo7P2xeax0igGBRRjoImySUO?=
 =?us-ascii?Q?mvadGTRFQ/4sJCXASE8/B/2ONI6FGacm3wdMyRQ2mOOb+9Q2rYVQsmqyHlnA?=
 =?us-ascii?Q?xd5qN3358+v3RSNIhnKsBK5xNcU4tEZpy4QluH+xEHKlo7QwLwvEfOL37gQw?=
 =?us-ascii?Q?/eKAUSSc2Ig8QHZ/St7JdNh8LrDhaz9ag8anrRXHmZ3YZlLKe2YFGAFXdfOW?=
 =?us-ascii?Q?Tyr5c5I1IEi1yixY1SGWWYpaDj2wNii92A5oat88lkIP/bvD343KX1yIEr5D?=
 =?us-ascii?Q?sLcpvHYZdBYyAeLBMnnkKU4v1C1wP11TeP3+2eZNy4Zw0ihiJIk+7nEZRVYU?=
 =?us-ascii?Q?vgjA2creinBT8CsATS/zbEQ8wDCm/GdyTexTk30dk6CQRRa4NWIiSvCBTQGl?=
 =?us-ascii?Q?jPK7G03U0ZYWQNrwPBFlXraIR7EJELAvz1N+lyfs6CiPauD7mUxy6JJXUuav?=
 =?us-ascii?Q?xfnSjUnSd+/goMrapx/O5youm0S1wuX4B0e3BCbzyWsUlSbPgcVvOA38PxPt?=
 =?us-ascii?Q?OSJgMZs0tznU1lHP+NoclFVrfk3sEopt1nljUsqWSMS56ifpykOiWL2vBSYx?=
 =?us-ascii?Q?vZkIxY/gIeSWaSpbk0Pk6ntVBNuRab6MZ6MSI8BfQlPSZ5Qdpdk/rUWwvyRf?=
 =?us-ascii?Q?G2D4uIUrA6lSthHE0ZkEYR9af88k33TEo/DZpA/zdK4rXI6mbToHhY7MBLDb?=
 =?us-ascii?Q?Gjv1dmQoFWaOXgWhiJAdyW3+gRUx4vUQXHBopmvAGs4e025TORPYdY/Svb3J?=
 =?us-ascii?Q?eWo4IILMVIfzvLcjyIuboIOx30ofvCDGbP4zl21NlPdaSHa9vOa2rCD9bt4E?=
 =?us-ascii?Q?COd832Xz66Glv+dfRK5X26Mv3cHEqKHoxY8oJXalm6guAd6MynoYU0+vsOVU?=
 =?us-ascii?Q?sfTZjxHS4ZJ9AcklRiF8j3HjJe/3TWwepL9iQSJxVQqyXTE7ZBOzPMGCQDuD?=
 =?us-ascii?Q?UytknjNsEOWFv8U0i+06tdc1CGBMWC0gAvE8LfUOf1nMqRF9GNgW/LvuW9TC?=
 =?us-ascii?Q?8WK0xRIiIFVBUhunHugTKv5VytQCrXD+lzihRPZhTop0QUZrKpj0GQcpDZmB?=
 =?us-ascii?Q?wgX+tRcOMH7/6w0c3HLGXa+pB+tq/1Yv7gouzuHJz7QWpMIR4RZUxNiX/Eds?=
 =?us-ascii?Q?KF64nLvyunNxaMSmzVAGmbMwUsTUkz92k5vi4mK59/MZ8Tq1VWn4qyOW/Idb?=
 =?us-ascii?Q?RvXt4M6zKtmIjzaa7njVz3MuiRQdTor1dgcbFy5OObtR3if6ExL2kKR+SQJ6?=
 =?us-ascii?Q?nX1PW/8qW1i69xh6Nl40+79NuyCVv8f3QyPMQJbr/Plv2mk54g+EK7NSp6LK?=
 =?us-ascii?Q?y4nXo1YpwbDKYyhS+4YCzHzVt56I7FmmOKWW6yLaLChIupjQ/M9uVvBZlZCn?=
 =?us-ascii?Q?khGrdg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd62168e-e96b-4adc-ecdb-08d995c816d3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2021 01:54:45.9616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qDFNU2dViHEtlUkdoIBDExL8LyKvZof34zvWOrnXJoNJOAmh9LjsjQYywFh5jq7RMqjSg5IlWypbkQx7MlFKT7DI1rBvrVKZPLCdX/aaNXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10145 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110230009
X-Proofpoint-GUID: giOg6RqjdzcsknWStbBP5yqivwwp3RD1
X-Proofpoint-ORIG-GUID: giOg6RqjdzcsknWStbBP5yqivwwp3RD1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Christoph,

> I just noticed the UFS HPB support landed in 5.15, and just as before
> it is completely broken by allocating another request on the same
> device and then reinserting it in the queue.  It is bad enough that we
> have to live with blk_insert_cloned_request for dm-mpath, but this is
> too big of an API abuse to make it into a release.  We need to drop
> this code ASAP, and I can prepare a patch for that.

The series went through 40 iterations on the list prior to being merged.
I don't recall a better approach to reconcile the HPB model with the
stack being offered during that process?

As much as I don't like HPB, all the major UFS subsystem stakeholders
are behind it. The hardware is shipping and various device stacks
already adopted support for it. At this stage I don't think dropping the
code is a way forward. I am much more in favor of having a productive
discussion about how to go about addressing the problems with the
queuing model...

-- 
Martin K. Petersen	Oracle Linux Engineering
