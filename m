Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D51C07E9E
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 14:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCF996144E
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 14:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhGFOpG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 10:45:06 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61778 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232395AbhGFOoG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 10:44:06 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166EZZk8003195;
        Tue, 6 Jul 2021 14:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=awwcBrcsoTb7EFRfvUxWJDz62aQpd3P60lF63yPHPE4=;
 b=A3uOwrgHMacRo/mD8ixVUqeTCxkEdB5heoXAakHLOxA2yGixk5eI9pvMo+9enG30GE0U
 sHpvvfTZBzYrLx2IVFn/rDhpDisn2YZGOuonxn65SAd43zU+n4w2i79wFfJxlFJ+GLuD
 nuBUkzSCKcaVU0R8ovoXNFznU57QTewvhGx2I3QHHqZAMInN/Lw1rEP6IP91oO/v2vR3
 WnKkosdW9gxdMAryIk858c3OGA+kixlqdkRwU7sJ/j/GipgKBhiN3okAv2IRLJsSE2tj
 vpehdD1mu8zLkw2lKLlOfSrvFlq3BJp3zyqPu72o/lpKaAH5m2XwgLnE+TY+HQ9l5FEs Dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39m2smj0p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jul 2021 14:41:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 166Ea68T092534;
        Tue, 6 Jul 2021 14:41:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3030.oracle.com with ESMTP id 39jd11enb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jul 2021 14:41:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LwpM4wFZB2m+EcNC332Gr8JRLly9etwX2Bgt2fr2HcK2RgpVrx/EffAac+80PteEkH1Kvgm+fUVnJScK0o/tMAbNb+tsW1Ksrc6EdgnHGs8y0+gg1sMa9apXCt8S+dSyjodyRpjjzPuMvJhH1lalJRIqdrAPhw5PgLloh60MbfPkWPsZuBfSMtvgEUfGiVih9MX2xYW6HiruD+Kx8+5VS0xu7F0U7Lz+KS2OzrKBGoyC9mp9M3qF5fYIgugYFb6iTwLe7AQ5uACPsRegwgAw/WWYgpm1U3JliVno1MCo+bOh/nvbr05k5V14yMMPqkW+tOBT2wOjMkwC3pJ22uYm8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awwcBrcsoTb7EFRfvUxWJDz62aQpd3P60lF63yPHPE4=;
 b=W6cRk1LvAVi0uRKFoptKrL33uPuT0d1JVslt/lzuoJujpfFqZfBt+fI8pw/WZb5xK+McnxYCKAzu8m5+0ovdb+WxYTCT3n8rBqgOWwNUw5LaS8kDN/HiydFX/YmKSc3ZdCrtpQ4fvU6SYKZ7bSVAQPGOCxcjY/O/lHdYse72p2Iyk3HAqNA4cyulWDFDGlnqenyCW1H8WzabnqMGG5uB0o4kKE5OxpMzsyGcFLoyyvYz3h4WdfthOR2JI3rWreJwfwq6SJYs3RR11mU6nYMyimqHTFttrc3JfIpw0/7t9Tqx/NN6fc/ctZvSE7Rk+1g/f3U4yHICnNco5GTpGFPSkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awwcBrcsoTb7EFRfvUxWJDz62aQpd3P60lF63yPHPE4=;
 b=yv43WjXo9+VcCsjaRD08CICMC7qzAoWkIiJ7kYbgAF1Qor/ONKpJdFdHuOibP8/gvqQmk2shd7IcOPvQZJQHyqW66XExS8V7DPZwvcyOocqGK0IXF5tIgwxGmpKfKfDngHQVRm0Jfn9oOHPhXttko+8qVO3nqHS0hC/V1AvPoLE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2256.namprd10.prod.outlook.com
 (2603:10b6:301:31::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23; Tue, 6 Jul
 2021 14:41:16 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 14:41:16 +0000
Date:   Tue, 6 Jul 2021 17:40:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Marco Elver <elver@google.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, hare@suse.de,
        martin.petersen@oracle.com, syzkaller-bugs@googlegroups.com
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.13+ merge window
Message-ID: <20210706144056.GE26651@kadam>
References: <e118d4b2fb924156f791564483336e7125276c47.camel@HansenPartnership.com>
 <YORh1+8Mk5RYCzx7@elver.google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YORh1+8Mk5RYCzx7@elver.google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0023.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::16)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNAP275CA0023.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Tue, 6 Jul 2021 14:41:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6796fb74-422e-4ffe-c848-08d9408c1c3b
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2256:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB225641F602023A67E4D00DD48E1B9@MWHPR1001MB2256.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PfoQovxupyW6h/edQL/lLvoJ51NCdySvNPtQKyfomv/IiN/kqbTwsm1TTKbhi4TRy7mXKQprGHDS2FKb/TCISKr0bcIhJ9a7OIjzUI48zQksOWAn5+1PvZdhM29UT/h4sF2vVAPBziB7pe23AO8hKpK7RlE3QRIc4i/5+j7vLKRwa+VtQ0YKyWzqvVJtax44nq/8GqDvulHyipZWbjyEHrFZ5jPDRB246t5UFYcuyIxFXhHsICaTfyVvFXFewTKTJF+yADUNahdUbLqtK2XLxuI2Wms8acRUJ32mn8KTFEMxd3zzSEY7k0jyR+GxH65xITCuFOBeq99UZSE18TvMBp1SI449eUNtloaB0UXoOqIquGiTVHjLaoga1gF1bO2hl+/fRGZJdkjhMdx6Ytx2HCvwWj5ctEvGzUWvK1CgNYxJrVMfNNNxyy5Ua+PGGB+u4ctNslYXd/y5jhNboY0iRLcShrfyxAR/XM+6LRZ3WNssEypLsKLTH5jA0OqWdEe2VBJDRJQ+PWWgt6iRLN42R0gZc0crtLfhK1wr0h9CMb3l4AYwpwLUR55G62ep7bXM9SHAQ/6JofnAAHk6F71kO9Y2cF4MMvL9yRPULhLOGPyGxDkTYUw/6xSrO2RnIpSsOuSEujQfEWdwDiSaPi6Tc+wyuYjPfxVkL9Zw0VrOVSoqi/7DflVaUKU3T/bLF/Lqcn3xrnjmqSPRSnR8k60ZrkPNOsOotJKPc7SJI3Osp9ff9KMk7yfkwRt+sJ3n1r9YSFoyr8+vlguogOhHUNkDgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(366004)(346002)(376002)(66556008)(316002)(5660300002)(478600001)(2906002)(966005)(8676002)(83380400001)(9576002)(66946007)(6916009)(8936002)(54906003)(6666004)(4326008)(86362001)(55016002)(66476007)(9686003)(26005)(6496006)(1076003)(186003)(38100700002)(956004)(44832011)(33716001)(52116002)(33656002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PogvlLlcDf2Nifte6plDCRgxvz3+qfEvO2F0w9mFKHY4agksEdA1ifp6XdLt?=
 =?us-ascii?Q?8UKmRcdOwdrNps2OFfzw94yuJO/PuHlGjqbREHkVox/jQojipyYHZfEgwf3f?=
 =?us-ascii?Q?50YUCjCdCNlNrACHr8DwKIrA01ZT2J5O0jbKUzirhf9M6/ws7znoJqmeYE97?=
 =?us-ascii?Q?ShIohBWMySlv5X/yigL7u6zlMxq+aK7ZFhY/ill9nJXxkMx9Ee6Zi7UBSiLA?=
 =?us-ascii?Q?tjVRWerDq8KOiEpCqz6Q/vhwVo/kymCd3LefNj90I5aDEvYAC45sfpIKjT4G?=
 =?us-ascii?Q?VbPdiCZdr4F/5g/1ogG7XMtye8MzEOiLRjWxkPhE/lEkGk5LDVaixGZ2fz/V?=
 =?us-ascii?Q?LnQ2KnnJZsalVj3QNFbUOfJrDuYPOsgn+aO83G+Eg71tG6Mm//WZ7v8G3taX?=
 =?us-ascii?Q?UEPyEgwBhixUwRiGAFguAAP6I4i6/OvYMG3/CT2p5YuEGvk+y5C6ylOC1s8O?=
 =?us-ascii?Q?t4yJu0nna4ArXgi5Ma6pXPsT/Tqai0xjz5dYmhTFNCPwAm/wmOQkIS7Ozc3e?=
 =?us-ascii?Q?UVdx3yp29Tu5cTi65YoXrMi5QRKhz6oNtHus/Cytw/8ds93iIbb10sioF1TQ?=
 =?us-ascii?Q?NpXQWxJjFgCC7EKkJePLRgNUWOECYjRQzpw2YMKCCU4XdNnB2ogoH8r9Sr0N?=
 =?us-ascii?Q?g9370Viwpo4p9DeycZYPv5HMsMXxil6YpNK5R4iUJRahjOgNlYdemRWYEnXe?=
 =?us-ascii?Q?UEho0f6G7cMwGC+PVitP1dH3x2qR/zDBlFJl6V71gXJIBDE66U1TVeQsqR5+?=
 =?us-ascii?Q?WLrGtAkauSkgZHeTD+nTe4bYOWOnAbWqxn28M7pckXX0cGzHMWxEwwf3DRdT?=
 =?us-ascii?Q?JAillafzs//AiL6NMNDJynswRbtTR1TDuPKmVYk6VfeVQ4cTHXR8C2bOsvro?=
 =?us-ascii?Q?w+Vm2Iiena3K3kCaf4BNFwhch8/3ykzPcf3OYXoK2v25NvbGkPRkMmzNK0/M?=
 =?us-ascii?Q?/Ha8KPCSqqvmH/dAtzII3pOogUnOqOPVAN+R/mB5tYsleD+FH7WIKQmx6NDT?=
 =?us-ascii?Q?U+pYm827CEgb8GM2Kux4h1Xf+p776WEq2aNg9bo0JsdyESAa9uj7SToXT7Fa?=
 =?us-ascii?Q?vvbmiQpW60Xe2O2QtTJGfrMDJOEAn0XavdEi2/s4VJrPSqPWihIDG+8vKR1L?=
 =?us-ascii?Q?C0fwQQ6v5DVG4etToSS7jvPzkEi4ONGLrIuTLZn/lTkljM8q5DppiD1tG8qx?=
 =?us-ascii?Q?zpa6jUD/nFMz/l7ShzYBvJgGz8GEPZVuAiFNtgbKs0BWJ5RzdtAfu9kB3JjC?=
 =?us-ascii?Q?LpD/sAZ4v3ADV1t7SUQN4Hpncb9Mi+nvT2f8nQyKRRMkBPP6tWae14s6vfev?=
 =?us-ascii?Q?Kz582ze+t7PqQNNgqtZlLVin?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6796fb74-422e-4ffe-c848-08d9408c1c3b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2021 14:41:16.6023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z89EEP7WhcwEIT7224roXeNC/l+PLTAWlvn8/pvgnW6KGwLJn/U+cMPCUkHSXYK3TZc+zsprBz9kHrL6hMTmKi2J/oPdv6PU5J/p6zasnH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2256
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060068
X-Proofpoint-GUID: CX-z2UKS6lA8nN_cpItW-nZsnA1BD3tU
X-Proofpoint-ORIG-GUID: CX-z2UKS6lA8nN_cpItW-nZsnA1BD3tU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 06, 2021 at 03:59:51PM +0200, 'Marco Elver' via syzkaller-bugs wrote:
> On Fri, Jul 02, 2021 at 09:11AM +0100, James Bottomley wrote:
> [...]
> >       scsi: core: Kill DRIVER_SENSE
> [...]
> 
> As of this being merged, most of our syzbot instances are broken with:
> 
> | Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
> | CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.13.0-syzkaller #0
> | Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> | Call Trace:
> |  __dump_stack lib/dump_stack.c:79 [inline]
> |  dump_stack_lvl+0x6e/0x91 lib/dump_stack.c:96
> |  panic+0x192/0x4c7 kernel/panic.c:232
> |  mount_block_root+0x268/0x31a init/do_mounts.c:439
> |  mount_root+0x162/0x18d init/do_mounts.c:555
> |  prepare_namespace+0x1ff/0x234 init/do_mounts.c:607
> |  kernel_init_freeable+0x2c4/0x2d6 init/main.c:1604
> |  kernel_init+0x1a/0x1c0 init/main.c:1483
> |  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> I've bisected the problem to 464a00c9e0ad ("scsi: core: Kill DRIVER_SENSE"):

Here is one of syzbot reports.

https://groups.google.com/g/syzkaller-bugs/c/6aqmRNRYI7E/m/V7BNerRfDAAJ

If you look at the console output link, init_mount() is failing with
-ENXIO.  It looks the sda drive is not found at all.  It's supposed to
print a list of available partitions but the list is empty.

regards,
dan carpenter

