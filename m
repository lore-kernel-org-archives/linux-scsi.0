Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7B5C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B06A64E74
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhB0RCW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:02:22 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhB0RCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:02:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGwrsD165632;
        Sat, 27 Feb 2021 17:00:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=KNfrD/p867WaqZD2Up0i0qX2ytIzJreEVUjy7e1IhF0=;
 b=HbRxDfR+iuLfN67Vd4a8olNhDYNe77YaJ8ZSdslLZMJ3Yh1R4j9y9Qjv9LTAakoYWa1i
 Hw9YRCe2SGG7e2tf9zVZSnBuOrQcsiSKRW1irmzqTfn12gPXs9iWhN1QiZtMt5/3q8Fk
 9LSzoNIjND8ZeJgi+dFDYjAveixbFdrZF/GrotRi9q0IAFG2JPFUxTaxWHuwEHt/9k9+
 +a4Bry0C4BgtPdEcA/y+QSDs+badWc+lAtQb1gnSzmJFM6tY5Jb1mYpy+Osi2OtQWuMe
 MD1eSRVvtZid8Svq1L34OfnLdBeT6oJyzN4dbIKdEbFk9mFo7BDeF8a+v4EDnScGQDRz Ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36yeqmrpsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGslmW115709;
        Sat, 27 Feb 2021 17:00:19 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3030.oracle.com with ESMTP id 36yc4a7jaw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICmAhssrCZ8zjF/HT6G80xYACC+CF8N3+ebnnxX+ZLdLOw+8ni8ggPCOOQczz7Q67hsjyBYzghNlk7NhhoqnqN1xM7yOCPG+pHu0vpRJVcfQSgL3iKGU1DFO11wDCKjCZpiBuRzpxuEUoiX+ve6htS21YC8b2JYYsatiktXtn9QeeEfNOzS3hh8YgOX/fKyHJKxIHo1IpTuwOCgQg1dYv6/hi+pc4G26+UCphT8Hynlo+QnnUt6SUi/0HH19r/wRoRw7Czrm1Ed+hOWxCmfnGszDSe30y4hNihiEUEHBk8PpmUQQrvIplWlDbHMwriXJIvX/2J3ALnw9lSLvJ33/IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNfrD/p867WaqZD2Up0i0qX2ytIzJreEVUjy7e1IhF0=;
 b=Gm/YVQiGi9T3ogDeQtuzgKGO0XzoIAW2q5VzX7drbDhGaQBe51F9etcXWXJ4n8NMg/+o3BD9poqR2ZQxdFELwD2WM93mUoxVC1Py+2BgDDUJGDQJLp23PPC/XybMdUb+otT9PZU167TvN0f8S/1lwGmAMQ3//kKzrZn91XWefzM7JBzBYg5CyUm4nJr4WSffXHqTmlM6IxumrbWIGw+Sqmv06fukluClxJ/x1JVvU1CYj4UUkvWVEvLfBK+IcoQlWoZP7Ju6E+nJe09Zph0VDnsJGEQ34jJGfgz8DOcOodbnqMFiPaLXsDSCwGz5qgfP/Y942iVX3z5lThfQoo4VhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNfrD/p867WaqZD2Up0i0qX2ytIzJreEVUjy7e1IhF0=;
 b=yo3Skqkm8n1YeoVMDomPp1zF8AnznUDsCpi/q/T9yaLCtxrPSL4dHqNA0c5iFpyjUKiJBsD3RF7E0lppUP8tBXmFVHSmQ9bFX2sOK1yiEIAqRicmWSTm7S7BjpJdh0ZIWYLRxmXRFBc+vxvUeHmO7d7aJh5y6S/6jSZ4mQBllbo=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:15 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 00/25 V5] target: fix cmd plugging and submission
Date:   Sat, 27 Feb 2021 10:59:41 -0600
Message-Id: <20210227170006.5077-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a3087a0-444c-4af5-e590-08d8db412715
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB34996BE16A30DA2FCD7B3E3EF19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xQdZCCXnyzZvTitOMaI5Da41lqlQXMWF4BIjKwfVTORVmJSbEgvyqpODpDd5CjmjoV+O+7alWrap7BtzOXR+lR+J8PC0ohALOpFoKSHQzt/6bVTcFf4VP6Qy1+DHV0NTupAr50B4WMZile2kolvF1B6YL62NA5R0y6/Wu6gQ5cmxzQT9CVlHhT3xi+2Gd0HY7OXIttunjs456Q+i9thyIo/OMd1TpP7WxgLQXLpTiyZknOL+eFC72DYew4l1lgKh+boeFDdpMHbsLSLUsACroLj0eVZ/Un4nKrnMIjA7pKMpVITIkBXcK08qdgQI/PQCKylPq1ZTyDLC+AZjeCno3Ut9en+hY3Pzd5+cdrJ/+eLTh+7IXRToPQeCzn/g9yljW57yOxs/tIbGR54ylZhhI0dYyLAvWfKejuFMWFA/j9mrJVSgsTfsKgTM4CsNUfP1lcpNOWyDMhDkql2hjO3JdHQ5C31cG2Gb+lXm4Xpeetj4slNVGSBlRJeX1yEJ/3FR0v9oZp2ZvRPFYFIPA2JxfW9ql3wU/xj4RiQtKIr+PEKM9beC9wgIzbfcTd/WvCLq/3JMi35ufb2zXNegXsUeDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(8676002)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Me4Q1YYKUxF8p1YQmWsvcFutbWYoL/a4ksXyTz/KNWZZRBDgyyqUDfrhK+IQ?=
 =?us-ascii?Q?HpE1XmwYkY+TSegfUoM6LBrPfyx0JlcZJlqXhp5TnQrRwzyyQ3cIIv0oh25A?=
 =?us-ascii?Q?7u0YzJDs+ToKNwpcqKEjPB8h91h9+el6POXsb3oIU/VVpzeWongX62zYYusz?=
 =?us-ascii?Q?C+TNqrhpkXAZ8H5D6YJzUG55qOXmGoylVi5j/3pnLnEsmaqld+eshp4GE9T6?=
 =?us-ascii?Q?WCx18a4CoRyq2e3GYmKR4lH0r9UoNrdgd07aKpgoMjS1k04e2ppAzJOAAPsQ?=
 =?us-ascii?Q?zo+unay3J/ZQ4eNl0czqWJxpY+qgLRaIjdFJEzyWel1BTtNTgZUZcoRdDdRY?=
 =?us-ascii?Q?b23brUSZK5s2ZFWKvCZJjZBgb0S8CDG20dJsmSZcoLWkTL1N00XADLD6UnaQ?=
 =?us-ascii?Q?scw4tYfnOJVNDYZhsqvPjrdGnWv3dVQ2fQzQML4t5qdN2rgydN045CAA+H83?=
 =?us-ascii?Q?MwtRnZk0aT/ZFz2TklGGSnqe0MdnMmvkAonK7paDIGdtrMIPwpbhXZdUzlwW?=
 =?us-ascii?Q?0fHU5izMF6YIJTwYEgQtwV5o3SmO1cZ6o3MfAjGkYfMMT16N3+I54ryGAZ2f?=
 =?us-ascii?Q?KXZ4vbnEw3kCaeQmqtwXFsvZGpScAtPfMOggu6AsRxavrWvOYl1LGxhgSgdz?=
 =?us-ascii?Q?2UaXAFUDHibXwoJ4H/2caIBI37puHs1IjdQu6QE5NbAFN4jV4FuKmUEFKCG9?=
 =?us-ascii?Q?FH0UsBaKQ4TqGqbhVPx+GkVUsJo6JUa8qAbAQiDLoV9Rhve4spX9RHOhpcw1?=
 =?us-ascii?Q?8jrLo6jnBnkrWOvMzQj8lgaY/h1NC1rcBo24j38GlmNMAHTjKlTBcW6BClxz?=
 =?us-ascii?Q?V4mRhYdtHB85c81LuT3OCsu9G7TjUXrzQ1aCqnNtH3bukelBBcy6hEM+cQvp?=
 =?us-ascii?Q?M+u6KqbVWz0YACx6zi4vw2FaqjiHmVnpFtwFeUKYX50DA9z+D9kSfN8ssS/5?=
 =?us-ascii?Q?NefFZyGfbqmJSu8D5iAUafy6bdTOikQ/j9lQ/Q5YJZfLMuWm7PNllpCldLAc?=
 =?us-ascii?Q?6qg4qoWUDNr1jXtS8ArixRoB/GUaV9LjIhMlCaE4KbVCKTsXNe8kGrSRzy6y?=
 =?us-ascii?Q?Yc8+D2UdqXQjDRudgC09JPxPm2wTMIqVb1xnmPD9zqAPHchX7JVgivScZk/6?=
 =?us-ascii?Q?rfrxEnzw1SNMiflFR1kO91+/F9ew8TV0IMUz1CwiuGoriRJLzeEabQT7wPEA?=
 =?us-ascii?Q?f+LfUZngz7Bu+Idz2Zh1LeVhf4nwq3Wl98BR7xH+RSSpYNJyzBSD2SNu8Eua?=
 =?us-ascii?Q?1N4LP9paAYASL/PEUb+Ilv26uz9CDlrECO56beiI8qR87GGQ/K5zw5xNEiMR?=
 =?us-ascii?Q?krUElklX2MMhN0DlenOtnLcK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a3087a0-444c-4af5-e590-08d8db412715
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:14.9997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+ZxDetOkykaL+SM4oUqJ8UnSCsCtwpjXt+V6kar8xYQjqIkCwKpkPRZPFIrUJf7JfjQ3LlF3BBlxTaeECGJ7MI6hyKqoKMcK8IteHh8nL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=928 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 5.12 branches
to handle conflicts with the in_interrupt changes.

The patches fix the following issues:

1. target_core_iblock plugs and unplugs the queue for every
command. To handle this issue and handle an issue that
vhost-scsi and loop were avoiding by adding their own workqueue,
I added a new submission workqueue to LIO. Drivers can pass cmds
to it, and we can then submit batches of cmds.

2. vhost-scsi and loop on the submission side were doing a work
per cmd but because we can block in the block layer on resources
like tags we can end up creating lots of threads that will fight
each other. In this patchset I just use a cmd list per device to
avoid abusing the workueue layer and to better batch the cmds
to the lower layers.

The combined patchset fixes a major perf issue we've been hitting
with vhost-scsi where IOPs were stuck at 230K when running:

    fio --filename=/dev/sda  --direct=1 --rw=randrw --bs=4k
    --ioengine=libaio --iodepth=128  --numjobs=8 --time_based
    --group_reporting --runtime=60

The patches in this set get me to 350K when using devices that
have native IOPs of around 400-500K.

3. Fix target_submit* error handling. While handling Christoph's
comment to kill target_submit_cmd_map_sgls I hit several bugs that
are now also fixed up.

V6:
- Fix gfp function arg comment.
- Drop part of git commit message about xcopy using GFP_KERNEL.
- Allow user to pass in specific CPU to do completions on.

V5:
- Add WARN if driver has used simple API and target_stop_session
- Added fix for simple API users (usb, sbp, and xen) for early failure
(invalid LUN, write on a RO dev, etc) handling.

V4:
- Fixed the target_submit error handling.
- Dropped get_cdb callback.
- Fixed kernel robot errors for incorrect return values and unused
variables.
- Used flush instead of cancel to fix bug in tmr code.
- Fixed race in tcmu.
- Made completion affinity handling a configfs setting
- Dropped patch that added the per device work lists. It really helped
a lot for higher perf initiators and tcm loop but only gave around a 5%
boost to other drivers. So I dropped it for now to see if there is
something more generic we can do.

V3:
- Fix rc type in target_submit so its a sense_reason_t
- Add BUG_ON if caller uses target_queue_cmd_submit but hasn't
implemented get_cdb.
- Drop unused variables in loop.
- Fix race in tcmu plug check
- Add comment about how plug check works in iblock
- Do a flush when handling TMRs instead of cancel

V2:
- Fix up container_of use coding style
- Handle offlist review comment from Laurence where with the
original code and my patches we can hit a bug where the cmd
times out, LIO starts up the TMR code, but it misses the cmd
because it's on the workqueue.
- Made the work per device work instead of session to handle
the previous issue and so if one dev hits some issue it sleeps on,
it won't block other devices.



