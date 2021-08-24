Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D053FC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6200600D3
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbhHXDLg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:11:36 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43944 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234187AbhHXDHT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:07:19 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0xGgR011536;
        Tue, 24 Aug 2021 03:06:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=C0PZnaRPncXKrwoh0gF6BLsF7GXqkRnqIOQu1QOId70=;
 b=ZsMAgngSxjqoqe/P3fUm2+gtgRhm/+laTJuDFitu91I6w8+5wQL528HCxfG7hTVI2OnX
 8AEfe5aq+jcNCdyxkOBUzGzxLtc028V4y7DxFr3DiMAevJGc5ajK5O0oPTVBHGsiRVFP
 6lU4w63jR1XoRE4aSw6IPCASEnLVKlH4oZoToN3s1YaTst+Y1AKAgZTqD3qB7NNWXCQc
 ttyknt9oGtSq9Cb3w6N74OdsZZlXTUSOxJPQdqDD/IUbnw/RIclz4ZzUVj2bsTC15Q33
 rsmlvmCaljss3nPBUhQz36evqkWk/DCxnbN6sVpS8v/CCNbAzfBDz7+1Y35bK8bSZKHg EQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=C0PZnaRPncXKrwoh0gF6BLsF7GXqkRnqIOQu1QOId70=;
 b=lTIantL13d5SOqzbebC9lMuVcjJ3OVdLdg0tzD3ASrT/M4viK8o22Eizjps2tGy1f9Bp
 wfV3FK862/bf9mUYfnuYO/JAWysQgeN1F4A0G8DCES6S6Y0T08Re+958TuHVrt8TIfch
 84AMPbFUGyojWnMe/akdVpXYARL/Sdo4ewCdI04AYkQys2QkGmopWBHNXhrKFz2HABpi
 9ByEKmbnksjLse0cVUyeLo85P56R5p1ek+Wiyxu2VECGwSluAZcfBd4ZGu1sPSkJ57+r
 HcauTxtqPesjv2lK4vHz0WUY0iPd+HAK21ozjeQ9AbkqhzC8eT9N0Tx7Jkk/b29wHIPL wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akwfm3531-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:06:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O35JbB012524;
        Tue, 24 Aug 2021 03:06:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by aserp3030.oracle.com with ESMTP id 3ajqhdsqpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:06:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4v4EO91EmUXViywOzXC9cf6g2BwoQ4lSfzlxXAFunMT+QhLdStDIjEOK8Q2BOZIbKZg8mMOGuN9I6hipYx5Q+VKHGWfa9Nly9kojNT79Slcj+oqsVDBAIMKhue8762txaqRCpnk2V9YXetYQVecU/d6Vy+lM+ZtAYxv8tcOSZCHeBMvpasZaeNT28/wO11C6sPn539/CtGKe2xnCMYqpJI+hk1Fv2oLd4eQjY0WBhcPz5n6cA/+LF2qq9YeKugvGRjcAPQD1jxCwdgPImJSfn88Lp4JtJnIb+mV/CemhqNPXzEQGsN8QKgwew0QV5Ac6kdkt1PYd3lMkqM+jpOdEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0PZnaRPncXKrwoh0gF6BLsF7GXqkRnqIOQu1QOId70=;
 b=GIB514+SYhemUjJ5G9I+wa1tdY2PBEqcv2XB2/AII0+gUQTxYFLHNFq8kLlI2n1p1bGc8QDlnnpptxhH68AyKto2FxWDVefUokhvgUtsXn3Hu8S7Y0pvc+lyhE9ZoYPLZzIRYw2ALRDP3Ci9fpUfFySFWQh3ohSi7pPO9OMDQ/hMZe21kjPx8oq1DD/8J9swS7lwUGLyqGt7zedeOyPQnz0su7bZvLgjsb9jOMCzmZmaEk2aR/qxFw3UOHOfHKbD564F8vlp7QgIknYX1laqRUgvZvqJOc3c8PGTW+sshziYHEF+8QA/RgbVQCt+HP0a/M9ijU1675IDMXvf4M9CSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0PZnaRPncXKrwoh0gF6BLsF7GXqkRnqIOQu1QOId70=;
 b=NmJ+nZtfV2vvWQr3ivfE0l16xYvjz388vLXrBjY3B/5vNcDwrJwwFqKorDDi0pGzvj168pISR0bBnAvzeHI/QDuOHUiN6w+1p5x6WsOr/L3QR0lkMLMMHyFA1LtUw38+B1sGQioriUSvsEenCaCfDjzMz0NG+NvfNjjfi2QbuoM=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Tue, 24 Aug
 2021 03:06:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 03:06:25 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Nilesh Javali <njavali@marvell.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] qla2xxx: Do not call fc_block_scsi_eh() during bus
 reset
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmu3fson.fsf@ca-mkp.ca.oracle.com>
References: <20210819091913.94436-1-hare@suse.de>
        <20210819091913.94436-2-hare@suse.de>
Date:   Mon, 23 Aug 2021 23:06:21 -0400
In-Reply-To: <20210819091913.94436-2-hare@suse.de> (Hannes Reinecke's message
        of "Thu, 19 Aug 2021 11:19:11 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0039.namprd11.prod.outlook.com
 (2603:10b6:806:d0::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0039.namprd11.prod.outlook.com (2603:10b6:806:d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 03:06:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb830d15-3813-4b5d-4d9b-08d966ac289d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46649C4193289E60D987228E8EC59@PH0PR10MB4664.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wyWIHYcIsEIp2FESLd7CPqGseMutudLZPiEhvdXjYg34Xao8Lx/EgIZK277U51SZON+GU8WrT0kU1KHkmHtu/1xWoqsWYR60pYDX7cf/suK3Et81Js7aerPSlH1I9c8HRZJIezety5B+AFMDcoh7zaXtSYv3HMdhP7ydQ7pfM+W5gyp9mubHI8qTkcV4bqBpkLnmBxGQ40QU022BpeDu1rHk+idjThnZR6AKjNKO6xgGNN3XMQ6mQdGC+ZeY4KvD/lT4vl11dXt4ZKe8Ax9cpJN2rsMa3SPY9U+/yVtjd5069Db0NmcQZQMYKHPex0pvs4FD9tdfmNi7H39/WsHjdLYmGXMqkEjXrs6RZ63N9zYiy2U2uMYF4xwBGFt8/KNJctPNGuaThRp5ODCEJgy7fnqcvR4t25XQXWf+FTkM8VHyX0mIBGRBgu/ENVjfLrZ7aDFqCYiTe7USldzkQhN9hcGukLm3AgXWZi1voRSpXBgxAdBVF5XkAEE9QA9d+APTN1I5tWJdM/9JbEYRBxtzt/qTPwemSnms2OdfAnJ90LaUClana/AmcU553fD1O7H48JaUZrUbexScOEKeW8EuioN3wEsuHXWbS5LnyGx0avu+PbKHLvWBKKat7hS7+zKFrIWc1YbzohM6aLzux4LwqpV347K43P0DISD1NZx24w4z6sKtmz5AHMlTDOrhDdJ9CMkJzPZAAfLOi8flk0x1VQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(8676002)(26005)(7696005)(52116002)(956004)(36916002)(86362001)(66946007)(558084003)(4326008)(6666004)(5660300002)(508600001)(316002)(2906002)(186003)(66476007)(8936002)(66556008)(55016002)(54906003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FFwdvnmccgmcZTTcsRC4De1qt3c5epru6tDzKmdlvrxtQxiS/ojp+eWbf7oD?=
 =?us-ascii?Q?QYLuxinEA+aP6rq0jv4F4G6c5mcKwkY7htGEYy3SuHc9RwEuypeoSjYCltWn?=
 =?us-ascii?Q?2jswBIoRLEeM/GbrGwKcrWPHjwk8aK5H3vWpdJtpvwGg6nACqnka2xs6G7sg?=
 =?us-ascii?Q?7PuaOyW9I2WKVlaaLQBf0XLaPXv1L6s9kPeE/Uw4maHwdl7Zm24rjQWVzL5T?=
 =?us-ascii?Q?2MCurfrdql54y1hSxTCb07qlFNovCRvxz/Qc/j59QY8OCMrX9YWDJmCT3tbF?=
 =?us-ascii?Q?4tC7TggiV2rJ7jr+DmlTlZxz55aoUM+BvrYo/UFRPdBtoCtBY0hOltKIa16I?=
 =?us-ascii?Q?xNptPiR8Y2mNx4rA2nNSwJ+R3E5U4E5Tk1XrWaaK8cXi05PrPMXB854Hudeu?=
 =?us-ascii?Q?8JgmUfITZt7zRRE8m6vzpaF4JqWlnr6onLQoqbxkBEU563zK02UyL9yVw8OK?=
 =?us-ascii?Q?fcw9JLCD9msq3aCnEH+OQKcWuH50cM9wXpuJkYD5ogneardKUmRFZrqcDzeF?=
 =?us-ascii?Q?0JGCcJwnWSD6aPzSmTRW7GtRiBcYQLuQy+Nh3nXu6t7pgJg/lXDaISlPBDjB?=
 =?us-ascii?Q?TL6w4V0wJyIynvi8EqOG8o/5pMb3T18rq3rxEYNQvnXAmYXOhvPkvmwTDHaC?=
 =?us-ascii?Q?+s09oSqAw+b4oYkuezWCeM2xqIqdAqltM+oHArKl9qbuphAfw3aHWpRI641H?=
 =?us-ascii?Q?MAjpLrpBhrjJXXtNBV6uGytW6BB9NzRPN5n+J8Yfpmhpp41NO/fop/W+7Q5e?=
 =?us-ascii?Q?OQSlHtYXHVEyhTGpKXGRRE20DG74h3ZHWgEys+Wb2+PUARRoFwJMEZLfjPTl?=
 =?us-ascii?Q?u9gcdRGlmUn8LPx7EnTvvpGFhqj1Mwyh0grrdSdYVAREDAPVqJDaHEADfOob?=
 =?us-ascii?Q?ruHjzJfeQBEQqjwGxwz7Q4VjyQBMHe4K/ChH/Cdz3MCB/VmW91LwSyd2w8RF?=
 =?us-ascii?Q?XRwfTGND3RLhexsXPlnrtN4prRtpDVjXt0hFirAVWa72iOOCtYHBekL/C1Ii?=
 =?us-ascii?Q?fiY5trS7ncaYB8j36BaQFvUo2812cKzGh+NrY1OSCkt8YPcyM7we/Vl1UxHy?=
 =?us-ascii?Q?98COTgpGKfwh5N9knO88LcznetIFcvPmcSGfAKKP+rrs5huh5CKinhU+HjR4?=
 =?us-ascii?Q?I4qAA8nFhSDLmprhj1UQdKs4Oi8/DNADfhvoQN9ToWXBkOxgGvC4gKO3uEP9?=
 =?us-ascii?Q?yBx6sLXcaLUOrdE0g3BWux+wd4h8d87ZKHXVeuIfqjR3UOyvngTpLbKBkFLd?=
 =?us-ascii?Q?nAAF0RcoxJKjXUx23wySXy9/XbxRRsq7mq+R8HzOBuTYYHbUH7xTQmK9LDpm?=
 =?us-ascii?Q?kha3Yue+WhnADsz7tv3mXLPw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb830d15-3813-4b5d-4d9b-08d966ac289d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 03:06:25.2238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /BDW6Rm12fHfJFu/xL/eBXww/nZHHu50AzmPadcNuEAUdHSoh/eolaGSVu1tMCdhuMKUrd4qbruIsn/EZJU9qJUD07ZRYkNI2kVSMmHHXG4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4664
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240018
X-Proofpoint-ORIG-GUID: fPC99lr6XyMcdOqad6Caqhc9k83-aFXJ
X-Proofpoint-GUID: fPC99lr6XyMcdOqad6Caqhc9k83-aFXJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> When calling bus reset the driver will be doing a full SAN resync
> anyway, so there is no need to wait for any pending RSCNs; they'll be
> re-issued during resync anyway.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
