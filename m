Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73750C433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 03:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F5BC61159
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 03:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhEEDT1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 23:19:27 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55756 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhEEDT0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2021 23:19:26 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1453E6UA036916;
        Wed, 5 May 2021 03:18:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=a1g7jZvOSYflXvd4fyek2xmJLmGrUHJQQfGeTo9Za50=;
 b=tcKVC7rwNF0q7FedvODcu9YbzChJYQ13R6kk0uOL8kIqECfSEKlFkYMjNWmXTtPrV3j3
 DeQta8/h3tnmPjP+lbHEHEA8xcT/If7iF4rffLTydjyjWdjFVBLY8jvpMdYeyAPBBBWI
 bhWEiAMZrO+an6woC0KtwtTTnSPdjPYr8srCn4fsl68bHDhIKuf+4JIpjKyxZDiTkL6S
 AQ03lisVKjLZ7IcKPC1mcHOAx0AJp7e5SICU2lCwt48orSOVoJpPAZbKSAb43VCd1Tzv
 FTVNJw80qaS4q1prVzgIsDDqu2bfdlnX/kCLbVmiwFHId9n7p24Y/TMO4k47vU38tdaa tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38begj8b71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 May 2021 03:18:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14535QSP138013;
        Wed, 5 May 2021 03:18:24 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2170.outbound.protection.outlook.com [104.47.73.170])
        by userp3020.oracle.com with ESMTP id 38bfurfhed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 May 2021 03:18:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LqxXmFRq/6IJSqjASjy0WeQq/wixsko4YHJoax6dstV6KWPz9zOlTZGYzxfZEQ0HJcUccu47o6GtsxzyEMzFFMYKAbHvAJkL5fwr4t8SP26nLr1seqd/SQlZYhKP8K4+JG896KlVtbCBAfw0nMSjqcjWYpxj/Ndp2oySJaqFZJwylMx3keMW2v2H/evmHgA5s3/5sSiRUz5SVdaXCTL5POAK7CEEuzE+upzpsFsap78FfdtPLdTJXWat7kxRWQ5eLVaU9NNpU3nJvmwT7WMUEFsn0Q0POeaRCg3WZygL2H//LcACJEIf446erl00LBADbmjVHGSyXavBHV2u1eqM5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1g7jZvOSYflXvd4fyek2xmJLmGrUHJQQfGeTo9Za50=;
 b=Dgn53b5Jt2K8AdCzlsJ6LftcQKSOl1jD2dQdUmqoZNbEEJXwukW++rwXOO+GVixG4oYltKdyi4tZX5KPE/JDDyjD3Pace+E/q17IFWAWqhKZPASbu9sCJgAICjF4bfIpJT11nvJZ+Ekj0bjB6dGmsrqVqCx+Gja5eNbkCxPOrnGVQ9UIJbuFvsXKBTr5t8OQNGW7eXb3KNU1XIyLS/OWn8TXR6da88vR5EXSIc0aE+3zr4TpwvXuOFDlzVjFLVGmFjOpvg0q4bqOELVFxHFaEKWL0mAtxsPCqshMadyXtxST8w8dhbL3OSXt4zJqwQzvwK2oOFMJFinuTUwC5VmJwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1g7jZvOSYflXvd4fyek2xmJLmGrUHJQQfGeTo9Za50=;
 b=TIBSpdmc5GnIXJXqZOTEmN3KpJh3WX54v4XIzvCwszmTKlc+8MvGIuJ/nFaDyAJYWnIP91rLZjROeUtEpDyYLzKgmZ1x9ufjrWSDs6zogl8b2GgylojlWUEtlq8i+x0msoC8OocRGXJTTHLdgqJ09mP4uJrOcd1pxxWx1JRFCNg=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CO6PR10MB5460.namprd10.prod.outlook.com (2603:10b6:5:35e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 5 May
 2021 03:18:22 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::6091:8d07:2f26:cf44]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::6091:8d07:2f26:cf44%5]) with mapi id 15.20.4108.025; Wed, 5 May 2021
 03:18:22 +0000
To:     michael.christie@oracle.com
Cc:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: Re: [PATCH v4 00/17] libiscsi and qedi TMF fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnsdho5q.fsf@ca-mkp.ca.oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
        <2460ea87-be0c-2a99-c445-142218645dff@oracle.com>
Date:   Tue, 04 May 2021 23:18:19 -0400
In-Reply-To: <2460ea87-be0c-2a99-c445-142218645dff@oracle.com> (michael
        christie's message of "Tue, 4 May 2021 22:02:32 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0047.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::22) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0047.namprd03.prod.outlook.com (2603:10b6:a03:33e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Wed, 5 May 2021 03:18:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c035e0ac-b904-4914-c093-08d90f746ffc
X-MS-TrafficTypeDiagnostic: CO6PR10MB5460:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB5460870D0CE839A5129DC4FE8E599@CO6PR10MB5460.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nGlt97epkvpZi7MTsNpRcPDFOGhUllVZYbACL8/b0vsgWZUYZlrR7/USERedQ0zxeqFSQJ0DcJd51UehbAL6ajy883LwtdwznxQspzeJ4eDCnggjwa6QPCayzYIYyE/7ba8ikGbJXddZZaO62X9tQUMPEXarBk1PfTBR1z8IOEyUBVm2MyoH8rCzgWSb399GACCtc/7HKmZjsbA/LTP88xVn4KoZa+6qkmg5/lRHLukriJY5QzGPjvGRUOSmxH/xHV/Pc1Vl7j1glReYCKhHHojb0zqYqMBptfSUGc/kkBQatnij8kHxbj89D2sUDcLTdR3/KvwxaO4htrlJ80E0aQz7rixOWkCBx0T/lmKcOO6hLvofBHxWA5PmjNUblLpcL+7OkBov59p9qCs6P6Xc5v3VzhAgQs+TASlfYfB9BTz5Jvuozh7/OT4rDvy5vPjCLZKBqfMdoUoORRj6efXONFydMDjqHJBxx3pfmDT9cIvoPoO6kxRpNO4VFZMuDTKPLuW5KfjsEehAEBcwBq8m/EucTw1f0g+1DNAluAZgTPC9farpc4JteqKoxWcROUiBssot/azoDVT+E+giZxnvgRQM/k3aKY2mqPHoPoOVlNKKqUceR0ubYZqm/dzjqEaG6omxvemZExn2CKZHOfdU/HdlX7UHy7Cbn1mCa1qR2l0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(376002)(396003)(366004)(8936002)(86362001)(26005)(4326008)(8676002)(16526019)(316002)(83380400001)(34206002)(478600001)(66946007)(186003)(6636002)(4744005)(38350700002)(66556008)(2906002)(52116002)(38100700002)(55016002)(36916002)(7696005)(956004)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Wgeyu67FqMOE92B1E8mk5+++827bPnqxSLZr6jTT7gtqCXT2TH60lampp5T0?=
 =?us-ascii?Q?34bEpZIW0dISvBuZis6QigdOzv/90Ph2TcqibkGqxHw8EojWbUvJ0IBDVoWu?=
 =?us-ascii?Q?wQe+G15YEjnuTxVZQnyuzlAJykI36u/klwBakM+ffpR3bZht3EL6fbpuXFUb?=
 =?us-ascii?Q?DUjBiePOqvg20GEDfOKCpVaRRggjUqE9O1hFSsZRxabZMvNDuUqKjwaKsFCk?=
 =?us-ascii?Q?sbwI3yv06lCEBsmfzpg1ZMzOFV6e4PcitCr7ALvmQWnEl7cpF4ByOOqqu1ji?=
 =?us-ascii?Q?v/mvtuVSwyN4H4H17zbQvAbWG2psE90ROjvEAT6mzPb3dDxX5a31eArOLj/7?=
 =?us-ascii?Q?1X7ramDln+tCaaJaZJ7l/i2NOUS7Fj5SRMe3B9nxUqQEBo6irCLrNE6yD5Aq?=
 =?us-ascii?Q?ez3z/SiL5HCUFrPGRDR01DtiPax5YVAQJYdOvKvgZCVlXIGUB/rvSa8aB2Ft?=
 =?us-ascii?Q?FKjWNei8PBggxSOEQEHLBBUsoX7IvWhfvAN3CeWlaUPSfpifVafPhd1yl0Wh?=
 =?us-ascii?Q?bRl+16WSxnqklCPpgtrJl4BkkATPOj3I9NskKEGkEEPqGHIYZj/TD0rOBnhA?=
 =?us-ascii?Q?tZ8z3/eV3KkLqIbyB7DALKUaDuyU1ckPIGMM3UQ40B9vS0hiEn/Cn29bIxjC?=
 =?us-ascii?Q?eJL601rsDYxW2ZCzyBGIiksF3PG2zJfZUKzOpRC1SSrNKAT0KKe9AE5pHcol?=
 =?us-ascii?Q?qUTBHikiybAl50vUwPiW0sXeLP+/O5ppJAIXiLi80qvTrflOXTqaoKlXWnGs?=
 =?us-ascii?Q?uwWScgSP12L5ngeVSNveU1uZ+hT+n8y1ZAA6WrR2riJ1mZPHrD+IaR4gqrT0?=
 =?us-ascii?Q?DEn5w6gKmC/v36fjTXp1x91htsXLTyZsJPfWzagVIGjKCOtbYamA/tI3yXAz?=
 =?us-ascii?Q?z8dN7PrKx/YQ7m3Uz9dKmCGFxEOpiyIo7IXyW/75TB6J90MwjHNElSDytfWv?=
 =?us-ascii?Q?7wDLSRGcOEwEMHo2bVuMHUOt6FAz8eUv9YYmf3QQUE58BvN4iTp1sGOsF8Se?=
 =?us-ascii?Q?wNbqfppc4l+F97Zbah6Cwt41f5kCe9+Of/tywsaiSvQinnpanLmJ/P1yrJR6?=
 =?us-ascii?Q?H0KOHaya3OHEr7WLs6tkU1k1J67E+vcGfmZjcWWZWNFgkPRdbz2tdq8tdf+g?=
 =?us-ascii?Q?FlHac0zkShdt4q8C7sElV3v8GMLFtREywAZSGntic5kPqLpCcwpvV9acgyVC?=
 =?us-ascii?Q?L4juMp3JVKL60gn9IT/5NCeXfG1h/kZ3ND4ME9kOJ/rR0uttD8zEVOq0AgO7?=
 =?us-ascii?Q?S7IuH4zMbYJ4Z1ohGXadHl3ERTo9OxcDk5qKDDIp/AfcGMDeEnqGK58gcMcb?=
 =?us-ascii?Q?pqGoXDmyaVrzzwYSo8aWvF+6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c035e0ac-b904-4914-c093-08d90f746ffc
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 03:18:22.0338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q6q4MtQ4mmoOKUlug6MYLKGKOy7W6XmbfTJb/RaFkGW7JXFK1khF+ZhnJXgUT33a4YYFpzm9jZlM+69Xj1hP1P6VzFlMZuElyehX3aZD274=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5460
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9974 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=828 phishscore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2105050022
X-Proofpoint-GUID: MvNpL8Q1KD3XqB28penvfTkIg9FBV3Fa
X-Proofpoint-ORIG-GUID: MvNpL8Q1KD3XqB28penvfTkIg9FBV3Fa
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9974 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2105050022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Please don't merge this patchset. I want to make a change that will
> make my other iscsi patchsets easier to merge, and fix a patch so we
> don't get multiple error messages for the same problem.
>
> When Lee is done reviewing "[PATCH v3 0/6] iscsi: Fix in kernel conn
> failure handling" I'll roll everything up into one patchset.

OK. It's currently sitting in staging but I'll just drop it again. I
would have had to rebase it regardless due to the DOWN vs. FAILED
conflict.

-- 
Martin K. Petersen	Oracle Linux Engineering
