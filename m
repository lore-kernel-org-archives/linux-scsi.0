Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72227C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F16623125
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbhAMFex (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:34:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56282 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbhAMFew (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:34:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5PAuK085173;
        Wed, 13 Jan 2021 05:34:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=R06REjnk7Jq63/ZFqU5ttr6qN5LnsSKlnsIQZIw4Gd4=;
 b=A/Pyam7o8Bw4sPpPnmDASwICOLWFg4XH/neEUzFWbuXwgJZg0M9nScqMEvzIFYhJpps8
 bb0T0QG0/muSet9LKyGupkRrDnjn/ruPYKjzOL23QgvjaMrV51F/7tp8aVLnNMxSSI4l
 glh291xgptjt0LHUcrHKU/oGJNIksXOelCvI3VEOFKO1frqHfIs+i4c1DXRRAKL+jTmo
 5N9tKPFdy5kK2tKA7j2WcbkQdDQpBW2nQRvrH4ckKGfEmK3Uf/VvY8Bu4ph2+krKVmE/
 9KmtmruxvhSk6ZsA0dYzZ6laUh/OgMz+hV7Uuw/XEMJ5ykK3zMUDSsuXpXTQ1bSP2rJ4 qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 360kvk1j0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:34:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5QZp7026692;
        Wed, 13 Jan 2021 05:34:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3020.oracle.com with ESMTP id 360kf6v3qn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:34:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gK+7HalzeMrMB3uz5pooYzwjnGlxDzsIzuS1xBpA7SRiYRTWVDz2YgjM0jx7dQxWofU4O4H3/8NTBx27hfQVKZje7ENeP85/EISLPzD3m/8vnYAlWVcBNE2OJiJkctOgkXAURhbLy5yKYK3yiTOzoZlD/awOhc0s4B0QSXQwxnPsHXZuMuMlOhaCYjydMWO3QDxAJrOb38Lqx97feBSxnWB3y3lNWB2tRPSBU5uxQ3vsdb3ovTOeFGK15rS6T331L4GWIvKhsyXu/9E+hhWUsmFDB9jCDDV80kyGArUKHe94yA/ZXV7CrERNbtJ9/7M62JvwgIbgnG+PKlKu51zAhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R06REjnk7Jq63/ZFqU5ttr6qN5LnsSKlnsIQZIw4Gd4=;
 b=I1sbC7AMsdftCbAEl/zTv/C6TIE6j/x9NBc95U+1NV9dN7RIISTquc6hMrSUiDi4o9BDIYESy0JBXd7pegkZpmMFcfLw4cEUcDhD8cxjnu4wsiCa3UpS5YVlShrfK5K/49TLMiuYAiedyeFdUVll/vIZTcKXgmIDvjwz4mY9lMWEcPc+bs9b4OaWynhdljzr38HQ094wZrpml+aNCfr2D/nSM9AZVzuezA8XRBQGr+QtvYCC7KTdXynw+O17oaPX95k2ZkCbAUFpLr+FBwS92RsiSaLAhZy3ud21Iv3aSRw69M/gR5BvbetqSW1yJQTpaMgWem0IKVjxr1M/JkYXsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R06REjnk7Jq63/ZFqU5ttr6qN5LnsSKlnsIQZIw4Gd4=;
 b=haEdvA+I5kDwy5fxiIDL/U3wzG3TG/lJtka0YdmXBBnK5rTWwu13eBQsesypGvkrvr4/FrMrZg3cugwLiLRcCab8Lf9mJdyB8Onsy1wP6jBUlGkjL4gq21AZSXckzNKw3IcYvA2M1/bcFu509TiPP+PIhkU5lcaWvA/1KV8SA7A=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 05:34:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.009; Wed, 13 Jan 2021
 05:34:06 +0000
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] target/file: don't zero iter before iov_iter_bvec
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11rep2yey.fsf@ca-mkp.ca.oracle.com>
References: <34cd22d6cec046e3adf402accb1453cc255b9042.1610207523.git.asml.silence@gmail.com>
Date:   Wed, 13 Jan 2021 00:34:03 -0500
In-Reply-To: <34cd22d6cec046e3adf402accb1453cc255b9042.1610207523.git.asml.silence@gmail.com>
        (Pavel Begunkov's message of "Sat, 9 Jan 2021 15:53:27 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR13CA0095.namprd13.prod.outlook.com
 (2603:10b6:806:24::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0095.namprd13.prod.outlook.com (2603:10b6:806:24::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.4 via Frontend Transport; Wed, 13 Jan 2021 05:34:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fd857e8-5937-4ba9-3f32-08d8b784d815
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45841B29AF661C01A7A048DB8EA90@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W9xiUzJlYJ2PX/NKrZdnRTBl0A/OyybsMIb4/hwbFU6Kftsv5Ue3oFET2gJ9cOGjxje69ZPlYaz91W+UWeiyLbvNdsNTpoe87xafJCxde7KWlhw5MSQ6xw4N9wFGpa1Y1I+c43+6Ro53IUvAxkBpBV4eHqyZoPtv1YVlsRD/J3oG0qDW7dhEKy4M2vaOSgcttMZusxSSiK93SjYp2oovZ1Dvg1a9ta8nS/kbcxQxNaL/vKb+jSZ4bIq443G/+/PbJHxzKVLDffpxdmFin6PJPM+v1yqtEe/I+yYoXKMoQ4dMpY2ymCZA668JK6wrpc70yXl3zGYoCY3EX/xogQXyFJ55MoYVLHxPwXs5vZx+UIsO3olAjRuSEqB++SCxKhr8Eycf0+h1oX20LooPAJNbrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39850400004)(376002)(396003)(346002)(52116002)(956004)(4326008)(8676002)(558084003)(7696005)(316002)(478600001)(36916002)(66476007)(26005)(55016002)(6916009)(8936002)(5660300002)(66946007)(66556008)(2906002)(186003)(86362001)(83380400001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LUvmklxQ2+tk8yhwWB4NWY5dSfNoriw/aCRBejg+6idgGSI0XnHCn6mjAfsB?=
 =?us-ascii?Q?nWpRqy29PF4XBRExbjIX6Ycxi/e0Gmr3PQpiVlPRBFyNpBRxLtjDEIxHNnJa?=
 =?us-ascii?Q?DXoY68AKIZwJ7qPE6VvtSfxNLJbIud0ozM2iBgkGCJaYHIJQXIbSmoikRYkP?=
 =?us-ascii?Q?E4No9RvV67DzMyt1yneHEagOMcAoBMcIJW8+zKiQYwlg8Cf7wdRSNlnv1emn?=
 =?us-ascii?Q?4HNK154ihFlEGQRY9FbQMH6mbEoRE4cn1G6kFDdavGE9+WWu2fd/LDLR7d4w?=
 =?us-ascii?Q?T7e1GdinoJGqjVMdkTR+yalgyHAvXfcWGKiPexr6FG3240DjKLR11tVxR7fU?=
 =?us-ascii?Q?Oj9FitI6XRCaddk8aJtqOcFJO7I2yonMHsoH8EwcBvY8/JL9q707kxmTV1Kt?=
 =?us-ascii?Q?kRUx5LIs+v/Itp0oPXfrRDlkuKxczUbzGMwkBqz9ujUYQwOpzOXCOjrAFmTR?=
 =?us-ascii?Q?QCRmbgqUe2FFMFkkLhgDhKi0PRBYV6AMkR+plQQ3ulCKmxerW82OnF9MFBt8?=
 =?us-ascii?Q?qwZrtBH0j+EosEygNn7/TXX/Dl111mLqrbo7QA0j9Lan2xT+hLWCAvum4ewS?=
 =?us-ascii?Q?I2fNK/xjdgcobPz9gmOS5ql6hakiuiwl0w9HElZ8hOz1Wt1oDufk6IQJH0DO?=
 =?us-ascii?Q?hj51nNJ/2y3Dio30kJclaAyTizSqtG+G8CyG+srhQLIvdXG7gHIfYMIyzNrK?=
 =?us-ascii?Q?GSLxn8Nui6Uq+eQnVfeyH5d0lIRIE4kYuSXI47rJYXreDXQvMaaJp6qaNprm?=
 =?us-ascii?Q?7q68iSw/5AC7sZp5NLoUD96m5v728qEWpDPhrGrzaFP0RknWZ5pyGmSRBDvL?=
 =?us-ascii?Q?+FbVZ0d7XkTn0edxWfCW9AckkcvynrZdERd5YnXC1cEIdR4up7NtVHDm60iQ?=
 =?us-ascii?Q?MYxCr+TnkTfsopr40VATjfr3LKq1PAwyhzBz9gnhV2Z4LG3xVqjPWhZO8zfh?=
 =?us-ascii?Q?Uxgr8NLkP4jSCygDiG2J8q/sePiWeu/QwenjBsBNK+1/a2NDw4zBLawh/zqO?=
 =?us-ascii?Q?6dXG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 05:34:06.0478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd857e8-5937-4ba9-3f32-08d8b784d815
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H0I3PPsxNiAzeJE+Yz7PVRvn8SCV1dEEHZPOhNfkh/35K4zndckZtf7pmr21HsZAofGZLcQCnFk56m9eGn6tbmbZWkgHVbossaerthT2aXY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=938 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1011 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130032
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Pavel,

> iov_iter_bvec() initialises iterators well, no need to pre-zero it
> beforehand as done in fd_execute_rw_aio(). Compilers can't optimise it
> out and generate extra code for that (confirmed with assembly).

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
