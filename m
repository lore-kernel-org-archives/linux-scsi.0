Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99644C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 03:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62B8264EB6
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 03:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBIDpS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 22:45:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39478 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhBIDms (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 22:42:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1193cN2O082873;
        Tue, 9 Feb 2021 03:41:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=TnBr4dVKEHbasXEvxPsDFFmLENwiljQhSjV1mJJfR5Y=;
 b=eB8S9+SDFQsfEQmzkPgop04vZmMxgKW9qbgiWWnx/1gb6QW4BwCwmwc9AbEl8kZsvm/5
 LYs7CMDyw/vFxM6ZOg1AsOITxCmwiy+ATvUlqdCvepeY7zooK93Nb+ytZroUvTzMjPNg
 h+/G7V4A2fuZYSe+2hm95hUrd2h+Dhjp6/AymaUuOhg8cY8AZ8w5xXzp/oKjTST+cJv/
 yFGNdT8pe+qY2DjyNs1h/nJWdJvOItNJXvTlWnlnVn/KvCnhy14xUM9/GFD3aK50q/la
 R5jGAGexS3v4RAqcvir8STMu1aJrS2D/Lt9KT21ZDJJgaWqcMvEXuwLEk22rRrfy5gqN uA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36hkrmx2by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 03:41:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1193ZNbn185929;
        Tue, 9 Feb 2021 03:41:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 36j510ngmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 03:41:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ap4Df+pLpx6foq7NJaRBKCS2OgD+XIiZ444lN+tepusFs/UzvmeuBf5UjA20G1GCKLfhhZFkwQ7MrUUnxsvRZI+wRgG2veGMyhuVq4VwiQdceAAbCnGrOYYVqUV132f/s7RI2ouOGGYDO+vB1XvOVeTozaSGrOFUl/bzKmI6jJhSfP1Rd4FUL5WOJBZs5G8FRJ1pqgRZeMDwv6GaYnVnyRL5XQBag3VTvmoUx81oBwr6ZaSc9Sf3SDBBuKxJCHqGHPTrtGyIf6T58ALJzVT5AW7VKLG/V3ayjg5Xpeca7imz17RY6U46L8p0MfC2u+HI2asXNcotRm/ldNh+is6uIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TnBr4dVKEHbasXEvxPsDFFmLENwiljQhSjV1mJJfR5Y=;
 b=T+Hi6H6h8QHidd8kOrlGQQM2H08RR8pAZhPCIdFYTaCWUCTJis0URr6LaSdI3pdDmo4W7HodQtrc14/OQgV6eo/wu5Kq+IA3D4tgFK4ELVBTmnyaSgMkKjI0nlyqJ1BTnG/di+SYqN1xV5ofCfjSYftW3FkgyNawxWiDz4Ep4Z827fMGwYmAwHDVqc52aOt6GTsklMlSqpbGKzQrKJ8GbnDuKBqwSy3RpDRz5LTW+mS82Q+XLgt2fqyILTj4CwtGVooU96BzvFQvToDvfFrrrWj+hZ9mHpvSUUP0/vJYC/Lmme1DeAOWPj5oUtnIarNAkuFB62+P3uii5gkO0eRbJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TnBr4dVKEHbasXEvxPsDFFmLENwiljQhSjV1mJJfR5Y=;
 b=qJTji5L0sti0T0T/gMdKdOt1Qc8vqg8+FeVRf2VLKuEbUvhK9ZqmBrFQVZ/HgkeKRG1saxKWDhR8Wvm6sDpXkqQFH46L7lXxSPSfdBBDACK1BWo87hmaZPvYsUm0ZIhYyWFBTYWpalknni+ySrk8cCcyMOP7V3Z91jBJbFWXczE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4773.namprd10.prod.outlook.com (2603:10b6:510:3e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Tue, 9 Feb
 2021 03:41:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 03:41:49 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: Re: [PATCH 0/9 V6] iscsi fixes and cleanups
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im71rjpq.fsf@ca-mkp.ca.oracle.com>
References: <20210207044608.27585-1-michael.christie@oracle.com>
Date:   Mon, 08 Feb 2021 22:41:47 -0500
In-Reply-To: <20210207044608.27585-1-michael.christie@oracle.com> (Mike
        Christie's message of "Sat, 6 Feb 2021 22:45:59 -0600")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR11CA0105.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::46) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR11CA0105.namprd11.prod.outlook.com (2603:10b6:a03:f4::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Tue, 9 Feb 2021 03:41:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23e3ca3d-15e4-4a57-d6f2-08d8ccaca1e4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4773:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4773EAD7644F9A516E7F4B8E8E8E9@PH0PR10MB4773.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D/o4VvqsdOrDPaR/3hrf/bMAuvOqLok0oHGTCzeN69ccvY5Eat+3uPyWMxEvBwp+rLGtyjC1gTej/Nr5fnWJD6mTMn3muWBtHAcqFK/FPd8AucpeZ7N4TnCTWcCPzZ8KIBrPaOcjhBDYHAz4Zu2wJWcdgKwMGy7QdB6hEPk8e5R6OmIhqWcrYwxs3G3Q+9xLbgZDH1LprN1k+cOMwFuuUrB2hCN9ekPPyyvawM1k7lwOmjEI+unH2nDOQuT09rtOS0SjFlN0X4jPV+tiiLHMlLqApK1KHQO9ubfqRi3A1MZuRgJd57xtK/79WJPKKVhPPUWT2cBZKVONwbtZQ653agfInRWIa8r5CiwaZC2AdaPP6g+RjEmBrcv2tIIUcWDrkcMk0REKHz0J9HnlbybjIV3RW3jhDs/I0ob+LIpt6bUyiiV7mKG4jHu2AdhbrcMA5WjZcQeos00pD3GvF38/X8HJCvnvWeoYQIKxaKKUMvbiyV28ytVNpx4I92GrpBn67Jn20mLVyrNIR/9qVhy0BQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(376002)(136003)(346002)(16526019)(186003)(316002)(558084003)(6862004)(36916002)(66556008)(7696005)(6636002)(2906002)(55016002)(8936002)(83380400001)(66476007)(956004)(5660300002)(52116002)(66946007)(478600001)(8676002)(26005)(86362001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pkHBPgadnMAe3CBsVcSELIVUWEwdAxodw6Yasd+pJTaEvBuQnP52xcWkrh88?=
 =?us-ascii?Q?SMKeqUv85Q2w3OcBo9xgkD3XU3WBQU+UWVLHv8TgornxCy7Bz24aqWSyXkw+?=
 =?us-ascii?Q?vzycFXgu2nivlqRwFlq6UB+I3eZNAbHL+mX0MO6X1lVyJWyo/i9GgCa83MOR?=
 =?us-ascii?Q?Qm3bbyIF1OYlutJd2x8v9koCM45Pe8dfkihTO8fFw07YEo/juD3sdOTIeeqs?=
 =?us-ascii?Q?B2jTjFgPfqi2SCpvxXnwzl57xZEKzDvMeLJjjMCYUC5DeCDbfH03zifVPFg3?=
 =?us-ascii?Q?BEYVSSFDFFnAGE9Li93KYZPojFe3VvoQoA8e3L/iR/Rcslx790vlX6J8aowt?=
 =?us-ascii?Q?SOYcls7d/lTIM1w5WPMMbefqQCXoavXT8iHxHu55cimWQULieAY+UxKz30mY?=
 =?us-ascii?Q?vWJ7W8X8q5WtSbYpr9tqix7gqJgkwHvCCrf1deqWoVJg/dE+xfEmGQNMW4gZ?=
 =?us-ascii?Q?BbluqJb/PiHWJm1HtSgcBCKwmWVNCIM4HY6gH974IiK5sIKtmzuFDjEkULfD?=
 =?us-ascii?Q?U2eBkV+vmZ3e5cC8sg2yVtZX45Sxpv4i7dpuuW3fUELF3Ud42SFcYYnV7uf6?=
 =?us-ascii?Q?K+c4VRILA5N9U3dHK5rik6TrvrquqbZS8x8x0NQfDdURUKHkK9rNySoOY7TQ?=
 =?us-ascii?Q?r8OiZK/PrwrUaexuzPSnT01o0x1O/g/cjGaX1d7cBxB/5tW0ORT0RhHISHec?=
 =?us-ascii?Q?v/XYRRPDDrU7X6TmjEZGx2eDMHfZzSTXznYLScvVl1ZYMkGfEga7xMu07taE?=
 =?us-ascii?Q?I5VTk0lWV9VstYQLjl0QgjDK+i4CP2ZPJ90gbLijpaB2bkchPtqbbD1DsFB/?=
 =?us-ascii?Q?JbklAq2G27HdWUxvaIxoe+b+WbPDMzCCpFgHisMe5nYKs5p257LLzR/NbZgb?=
 =?us-ascii?Q?/nyfa8mVCIpqlN1Xst5KgSAKvQPpUKvzv4M+Movqgx+3IeSL5XJTsuNKiHRK?=
 =?us-ascii?Q?MlGVb5oMSpMXjuK2d5zQnGhxq8TufVvuQ16AShWP0B63pisZSiVeljaOl24k?=
 =?us-ascii?Q?EWNgXwaqEaCpTyLjV8HXxyclpGJ7vF9jbbj+clSUsMDjT7XuWF9Y30q4Ths5?=
 =?us-ascii?Q?rxR0ehTWRNLTWju4F1qPSFTlM3POKytdwK0mONVYU7UIikRo96x/YPEfP3jy?=
 =?us-ascii?Q?dwGRPMBG4equM0ArXJvEJaKOlfDo7SEKTF8/tnuT4OJmLCv9TP02hF3oJH/6?=
 =?us-ascii?Q?oyImUFC4Nh/WM/psd+LRQFVKsGq4xlWINAQnUgkC8+Wbe1PY87CWnrkUgE7d?=
 =?us-ascii?Q?wrQ3MUU1PFft8g8EUwLumLnRSLUIC73hhlmfn2DUCR0zGqgn2mXqiTCvCWTc?=
 =?us-ascii?Q?tuXivF6JE69EvK4OGcQPA/2s?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e3ca3d-15e4-4a57-d6f2-08d8ccaca1e4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 03:41:49.6431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j4uaB+l/8bjy9xBGH93n9YLJ8ZTZJyGa1I8FDJv+NiemsLop5dWDqylQXrtidUd+E03AxtNUmVxgfRaDhWUO5rVMeAEYSkmPv3qR6AEdDjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4773
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=916 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090004
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches made over Martin's 5.12 branches contain fixes
> for a cmd lifetime bug, software iscsi can_queue setup, and a couple
> of the lock cleanup patches Lee has already ackd.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
