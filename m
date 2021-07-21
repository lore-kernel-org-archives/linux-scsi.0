Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_C,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA616C636CA
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 18:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C17086101B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 18:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237150AbhGURVY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 13:21:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48782 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230444AbhGURVX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jul 2021 13:21:23 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16LHqv0j018818;
        Wed, 21 Jul 2021 18:01:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=gPOAbOoxXDgTw4+AyHNt6q4S7aYsFGlBstAYnI7DBXQ=;
 b=WN3KzIsyvqsmwWxF+WF3P7S5/tl3WovByw4UobBgTZhz/C9aCkDfJEWw1j9Sh/WDHAFm
 hiao+jFSj74izRVDLhTvBn6JkLa3Q+auQyM2EWybshSwS5Gu9XGuFDQV5CLAESHTsE/d
 JmQzX6oODjCC29TvaCk+GY6XtatJQ6SBWtK7uG/19lWVZIIEcVWk7Td6oiIGh/cxowM5
 N1R7G9UFTooqkwDHdRz5zfZcqgdMmiikaPLR4PVrJM385tvue5jswr/4ZdkxkCdT3i6R
 hJM7PcHQxCaSNLVXK2u+OOuEf6zzcaf22+TeldOUZgSocqvf5tGxfFCYTxlKWLCiGOby 0A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2020-01-29; bh=gPOAbOoxXDgTw4+AyHNt6q4S7aYsFGlBstAYnI7DBXQ=;
 b=OW076PJvTQoLFMhnaAFz7bcntgKKmHEldOl5QolXeFmTY8CHIGq+SGEWngcWxyLNHpac
 7xo73JKZk6evU8lqbucr17r/gg9XWcdEDjPxeeiMzAHKd55gMha9bXidYBpuC4hGwt93
 06kES8ziM6xxgqUyFCBcqkFdGcrftTIo/Alwmz98bIl/lNGBC5atthqSX+tfOjft3zfm
 /kXOHhnrTJB0WXNj47Tg9phdHiJfF1dbSAQhxNamY9fkB70VO+tP+mYDGhuwRD7xGTsN
 Z6uxMxps3gatPILWX4XN0CdX2gMjN1Yd81rS7QaTKDWp6w4kI58rszPFaZavNpzm+pnc PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39wyq0u718-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 18:01:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16LI0RRP106793;
        Wed, 21 Jul 2021 18:01:53 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by userp3020.oracle.com with ESMTP id 39v8yxwgsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 18:01:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXfVsqwL1yLUwci2CWQ5wOrNVrSsN4g5SwKX/yiEE9URx3EoA19ENoDMXE9Hv9zzUbsi3Fx3mHemPosUM/J5oTGYT2MR+v0kY87K7qsCKvcUiHN3siKCYG7gPCdCc+cv+DePMKgXqNJVfPvMc/mhaZtLDX6USTa3Kxmc7exNt8lckX9fezbcrdWMHE3ECTSB6VaupWMLQiP1xs0N8s4Y47K2EN+93KnMuy8VEliIMpD+8JvodZOIjP785N8O9f3U603g2Ebk8BrAOZIkguIS06b16HyDH6sZfgusTDOJCShv4pUf7d34do1zpc18tBojZMHchuaWhQmO2auRNZsfRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPOAbOoxXDgTw4+AyHNt6q4S7aYsFGlBstAYnI7DBXQ=;
 b=C/tBJwoj9rO30QWyIh3cpUZqdXCQU94GR9r81GDJ7BKxUT7zal9FA+wdY7Jcm4ifI3FlkQ5n+lrNarFgnJVflqkZtJjElNYhORYOoIFY7Ia48xodC2YZRg61xhvyWWPKxIlWeG4napVnjoLKnw1gHoIM4iMbN2tYjGOq8eDug0TojQZ792XHM2TPjekfzJ6p8xV5FDG2x7zthBzHLvPPTmEN4u4BrsFYknFTWiNhTscRlfo8+WS09wrg0wCDhTUeTHKUs7x9U+V9Rd7d1ThOVfseUy65Rq/7AxzW4i44bKxn9+WktnRqKTIpbAZt4XDZJ2UaiQTx+dhYStMdGMjyqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPOAbOoxXDgTw4+AyHNt6q4S7aYsFGlBstAYnI7DBXQ=;
 b=QxwmQn2jTsUcZScaDK6JbqXTJcry+oq1+ZE5kzt6O98uUDGZfsMUfaHiEg7PBOpZfd8nI4HoVXVgWNGha7ZVLDo4YCJQG7qjYwSAB8Qb7ShK1fKU31pdR62KcxfYn+ifL6dzmElm9MRuVCgb205gnM09UchMey1ZTIZ536vgwQM=
Authentication-Results: lists.01.org; dkim=none (message not signed)
 header.d=none;lists.01.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1774.namprd10.prod.outlook.com
 (2603:10b6:301:9::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24; Wed, 21 Jul
 2021 18:01:50 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 18:01:50 +0000
Date:   Wed, 21 Jul 2021 21:01:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Damien Le Moal <damien.lemoal@wdc.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org
Subject: Re: [PATCH 2/4] scsi: sd: add concurrent positioning ranges support
Message-ID: <202107220019.vhjyS5ei-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721104205.885115-3-damien.lemoal@wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5PR0301CA0021.eurprd03.prod.outlook.com
 (2603:10a6:206:14::34) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by AM5PR0301CA0021.eurprd03.prod.outlook.com (2603:10a6:206:14::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 21 Jul 2021 18:01:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6938948e-2bb6-4182-30ec-08d94c719d3f
X-MS-TrafficTypeDiagnostic: MWHPR10MB1774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB17745EF76587DF10088D548A8EE39@MWHPR10MB1774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a8OtlROY0xo3aavDMR2eCMvt7uoJZTZqCfBVr3P1WvUuTKbnqy6J357Op22I5mgQsphDCIILT5Q0L3kmcoI64UqnzOTTmC2BbOw7JKSTdunPb1kqbuIt1k1nBvtOuig62oxMHuxx5lDtqICQ3RuYx+jMoa9cYeX8i6llTSxSa2gADmUehapy+ynJ5tMknKsQb+dtI++mCTS4xJuXJ1tReW4cWKCl2zSul1xuAt5U/VsR5ZPOgqULAMl66Y0ck1Hmqadoa5CAjXyVVvqE3Jz34I77z7HYjUYZTdSqG7YoC2tdeXRfkPzai2ZxUK6XpVoVvS7GB+xVa1ujc+nc+Wz7rlvxCDEDDooITwvK45rLK4Ii3u3LWvRXcZR6TDgV9GVeKL2jKa9bmJ3znSNUSksTEkeWEERHkevb+O1otUViXu1SjFzuWXj3n4qNPHm44xDSz8HPEe/jqita6KiVholtcjcW7ihjBxDPvCdAxF3eUB1pXoKNUm8a8/ZbakEQy+gFYUSY48Uigz2DtUWt9UGupm01HTits+ehtgwb5nNeP36xgrsD3vELwgNgeyDMTY158TEjGF2bepNmlPFnoabvcOXMkUqmUhr1Klhi7txJh3rydhmZj+D1LnzXIp3e0uKYraOCrG66eu8FVlacdMpTizqonYjGRf4CeWzqAB3noc/+JBjeQ5LB2gMgYd5rx6Q7WJq/kmVKNuTTGud0ZGINVJHYiGnVExyXZ3pFgdO0RzOIaSzP31XU5ELozmlb2oKxBgG60BJxDKcvaLv9f+giQa7/lXPrBHCOBomuuAVk0EKx12Ma0SfI8SemyLhlrSMs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:fr;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(396003)(366004)(2906002)(956004)(8936002)(6496006)(44832011)(8676002)(86362001)(6486002)(110136005)(316002)(36756003)(4326008)(38350700002)(38100700002)(186003)(478600001)(66476007)(26005)(66556008)(66946007)(6666004)(52116002)(9686003)(5660300002)(83380400001)(966005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7XUkXww3GM8iTxfvwRdhh2QRWp0tkkr9pb7f3InZ6+NAVraq1Tjz2lBD6X8E?=
 =?us-ascii?Q?Y4SqqWxjrmkAVby+AbTvLNL+PqDdDWwZFDKIitGbv+bbTYlsjfafd/Av7KxR?=
 =?us-ascii?Q?GLR1lDCvqOK50/5tG9Cl0Pi0tRW2/TdLDrHBt9esejUExKrq1QKxUmSXAsjD?=
 =?us-ascii?Q?WaQoKD7/fpazVrcdSJiz0q//w7SHH9r16flOx+2XBwo1JQu2/IT19DjQ0KXR?=
 =?us-ascii?Q?Oen03xnaM7I3MWr3KsY00F/NSJMVE+eemRSUnoOGn4B2lfQVhngnanN4l8KC?=
 =?us-ascii?Q?xRvXNTKOwzMtz+re+xMzOzKUg70kUvZKGQ66e5QzBQW0gjJ1jYthncntuPGG?=
 =?us-ascii?Q?coKaWGb8GlBSgbb8Q2JPoEsXNsYFaaKY/HxP+wnY9/UAf4XS0X8EIRtpQlVR?=
 =?us-ascii?Q?vkoi0N/yqQIIT9fIlIqGORo89DRAK8OvWGviClkOFiKAmHmU2sxLoLwfSwbX?=
 =?us-ascii?Q?fSgs64Xne4gjuenFFVDziZzj0Kzc9C9Uh5Bhf7iicxHZkd8b8zurSdJj/yn7?=
 =?us-ascii?Q?YurUOKbEO3YbNUsCflTBgmBU+x208jFqny3EVCji9LyVEGbBqJliJH5fR7pQ?=
 =?us-ascii?Q?7t0s7wAxJb4RfWFPw9m16mizBiufnYx6FCSwkfcr4Xu/T02wIAS7lKCc4pNL?=
 =?us-ascii?Q?28ahJx8GOs41YlU6SjnSq+M/NXOoZd+M163sOcf0jKw0jSOUc8JQfN3MnwLo?=
 =?us-ascii?Q?xbwJpb8FYwHOtOlxHNKZZGuGmqaWRCcKmtQO1InfbQuzgb3Syu0Ar0xf+5CO?=
 =?us-ascii?Q?i4T/8DD6mP38v5sK7xgMKVWcXK3FCLKvgOS9DwBUBxX1mf52hLAdHOqvDWml?=
 =?us-ascii?Q?zYnStudXj9lD0t9dcdG/gSy7oglxRDBxiIKx5cajhe2muUlwzRbUW9nqMH0C?=
 =?us-ascii?Q?S+WYbiGKfukuunSgKh3hMwSs9CbPyf+WQExpaFRfXjN8YCQvQDglLrnM5Xxe?=
 =?us-ascii?Q?wgrqr1Z5P+NaCoxDMS9T0FW8p0+4vOyakvFi8KLO4AgFL2703Avh0jhHP6je?=
 =?us-ascii?Q?igJNar9geAnsY/O/fZitXbYvWrN6Ha4PTMZJXFNpNEizK8RsPdcEu1K/eHbW?=
 =?us-ascii?Q?5ipnb5MGfJ14PYQG3pq1VaHlh5FzPRb9RxNENDp7hUTkQWxlKA3uaCcvxeV6?=
 =?us-ascii?Q?zswryMgxWdrUZvGMhcUvmT9enkFPKxgvN+vd2TFcXMJkRRiUi/EEzBAtL8JG?=
 =?us-ascii?Q?0mVsbE5LjubbaaP9oD6qxmcYn+9pTgt+dSVl422LxNf4cf4n0n6aHmQucE7j?=
 =?us-ascii?Q?tlrwYJK87wnuyozmwRHcwv8CPWb25WBwpYgBFMcQt6cLkA1T3xmG9+EpI8cK?=
 =?us-ascii?Q?jKAQqScg+PuXbsaMR7e72zOT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6938948e-2bb6-4182-30ec-08d94c719d3f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 18:01:50.7023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /0kQzKvo1eE3iuDvTBj5CJ/Pa6vZIse3ROpcAGif/sMjhsqtiAVshPYiNf7gIY57OfTxLwRJNz3loe1pg9s3UjsO8hUN0Zip2hXSNP/d/NM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1774
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10052 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107210106
X-Proofpoint-GUID: zZqxny_-1WKWoJmrUOHO6eD32Gs9PZr2
X-Proofpoint-ORIG-GUID: zZqxny_-1WKWoJmrUOHO6eD32Gs9PZr2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Damien,

url:    https://github.com/0day-ci/linux/commits/Damien-Le-Moal/Initial-support-for-multi-actuator-HDDs/20210721-185447
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: x86_64-randconfig-m001-20210720 (attached as .config)
compiler: gcc-10 (Ubuntu 10.3.0-1ubuntu1~20.04) 10.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
drivers/scsi/sd.c:3204 sd_read_cpr() error: uninitialized symbol 'buffer'.

vim +/buffer +3204 drivers/scsi/sd.c

331fc9cf44c011 Damien Le Moal 2021-07-21  3137  static void sd_read_cpr(struct scsi_disk *sdkp)
331fc9cf44c011 Damien Le Moal 2021-07-21  3138  {
331fc9cf44c011 Damien Le Moal 2021-07-21  3139  	unsigned char *buffer, *desc;
                                                                       ^^^^^^
331fc9cf44c011 Damien Le Moal 2021-07-21  3140  	struct blk_cranges *cr = NULL;
331fc9cf44c011 Damien Le Moal 2021-07-21  3141  	unsigned int nr_cpr = 0;
331fc9cf44c011 Damien Le Moal 2021-07-21  3142  	int i, vpd_len, buf_len = SD_BUF_SIZE;
331fc9cf44c011 Damien Le Moal 2021-07-21  3143  
331fc9cf44c011 Damien Le Moal 2021-07-21  3144  	/*
331fc9cf44c011 Damien Le Moal 2021-07-21  3145  	 * We need to have the capacity set first for the block layer to be
331fc9cf44c011 Damien Le Moal 2021-07-21  3146  	 * able to check the ranges.
331fc9cf44c011 Damien Le Moal 2021-07-21  3147  	 */
331fc9cf44c011 Damien Le Moal 2021-07-21  3148  	if (sdkp->first_scan)
331fc9cf44c011 Damien Le Moal 2021-07-21  3149  		return;
331fc9cf44c011 Damien Le Moal 2021-07-21  3150  
331fc9cf44c011 Damien Le Moal 2021-07-21  3151  	if (!sdkp->capacity)
331fc9cf44c011 Damien Le Moal 2021-07-21  3152  		goto out;
                                                                ^^^^^^^^^
This should just return probably?

331fc9cf44c011 Damien Le Moal 2021-07-21  3153  
331fc9cf44c011 Damien Le Moal 2021-07-21  3154  	/*
331fc9cf44c011 Damien Le Moal 2021-07-21  3155  	 * Concurrent Positioning Ranges VPD: there can be at most 256 ranges,
331fc9cf44c011 Damien Le Moal 2021-07-21  3156  	 * leading to a maximum page size of 64 + 256*32 bytes.
331fc9cf44c011 Damien Le Moal 2021-07-21  3157  	 */
331fc9cf44c011 Damien Le Moal 2021-07-21  3158  	buf_len = 64 + 256*32;
331fc9cf44c011 Damien Le Moal 2021-07-21  3159  	buffer = kmalloc(buf_len, GFP_KERNEL);
331fc9cf44c011 Damien Le Moal 2021-07-21  3160  	if (!buffer || scsi_get_vpd_page(sdkp->device, 0xb9, buffer, buf_len))
331fc9cf44c011 Damien Le Moal 2021-07-21  3161  		goto out;
331fc9cf44c011 Damien Le Moal 2021-07-21  3162  
331fc9cf44c011 Damien Le Moal 2021-07-21  3163  	/* We must have at least a 64B header and one 32B range descriptor */
331fc9cf44c011 Damien Le Moal 2021-07-21  3164  	vpd_len = get_unaligned_be16(&buffer[2]) + 3;
331fc9cf44c011 Damien Le Moal 2021-07-21  3165  	if (vpd_len > buf_len || vpd_len < 64 + 32 || (vpd_len & 31)) {
331fc9cf44c011 Damien Le Moal 2021-07-21  3166  		sd_printk(KERN_ERR, sdkp,
331fc9cf44c011 Damien Le Moal 2021-07-21  3167  			  "Invalid Concurrent Positioning Ranges VPD page\n");
331fc9cf44c011 Damien Le Moal 2021-07-21  3168  		goto out;
331fc9cf44c011 Damien Le Moal 2021-07-21  3169  	}
331fc9cf44c011 Damien Le Moal 2021-07-21  3170  
331fc9cf44c011 Damien Le Moal 2021-07-21  3171  	nr_cpr = (vpd_len - 64) / 32;
331fc9cf44c011 Damien Le Moal 2021-07-21  3172  	if (nr_cpr == 1) {
331fc9cf44c011 Damien Le Moal 2021-07-21  3173  		nr_cpr = 0;
331fc9cf44c011 Damien Le Moal 2021-07-21  3174  		goto out;
331fc9cf44c011 Damien Le Moal 2021-07-21  3175  	}
331fc9cf44c011 Damien Le Moal 2021-07-21  3176  
331fc9cf44c011 Damien Le Moal 2021-07-21  3177  	cr = blk_alloc_cranges(sdkp->disk, nr_cpr);
331fc9cf44c011 Damien Le Moal 2021-07-21  3178  	if (!cr) {
331fc9cf44c011 Damien Le Moal 2021-07-21  3179  		nr_cpr = 0;
331fc9cf44c011 Damien Le Moal 2021-07-21  3180  		goto out;
331fc9cf44c011 Damien Le Moal 2021-07-21  3181  	}
331fc9cf44c011 Damien Le Moal 2021-07-21  3182  
331fc9cf44c011 Damien Le Moal 2021-07-21  3183  	desc = &buffer[64];
331fc9cf44c011 Damien Le Moal 2021-07-21  3184  	for (i = 0; i < nr_cpr; i++, desc += 32) {
331fc9cf44c011 Damien Le Moal 2021-07-21  3185  		if (desc[0] != i) {
331fc9cf44c011 Damien Le Moal 2021-07-21  3186  			sd_printk(KERN_ERR, sdkp,
331fc9cf44c011 Damien Le Moal 2021-07-21  3187  				"Invalid Concurrent Positioning Range number\n");
331fc9cf44c011 Damien Le Moal 2021-07-21  3188  			nr_cpr = 0;
331fc9cf44c011 Damien Le Moal 2021-07-21  3189  			break;
331fc9cf44c011 Damien Le Moal 2021-07-21  3190  		}
331fc9cf44c011 Damien Le Moal 2021-07-21  3191  
331fc9cf44c011 Damien Le Moal 2021-07-21  3192  		cr->ranges[i].sector = sd64_to_sectors(sdkp, desc + 8);
331fc9cf44c011 Damien Le Moal 2021-07-21  3193  		cr->ranges[i].nr_sectors = sd64_to_sectors(sdkp, desc + 16);
331fc9cf44c011 Damien Le Moal 2021-07-21  3194  	}
331fc9cf44c011 Damien Le Moal 2021-07-21  3195  
331fc9cf44c011 Damien Le Moal 2021-07-21  3196  out:
331fc9cf44c011 Damien Le Moal 2021-07-21  3197  	blk_queue_set_cranges(sdkp->disk, cr);
331fc9cf44c011 Damien Le Moal 2021-07-21  3198  	if (nr_cpr && sdkp->nr_actuators != nr_cpr) {
331fc9cf44c011 Damien Le Moal 2021-07-21  3199  		sd_printk(KERN_NOTICE, sdkp,
331fc9cf44c011 Damien Le Moal 2021-07-21  3200  			  "%u concurrent positioning ranges\n", nr_cpr);
331fc9cf44c011 Damien Le Moal 2021-07-21  3201  		sdkp->nr_actuators = nr_cpr;
331fc9cf44c011 Damien Le Moal 2021-07-21  3202  	}
331fc9cf44c011 Damien Le Moal 2021-07-21  3203  
331fc9cf44c011 Damien Le Moal 2021-07-21 @3204  	kfree(buffer);
                                                        ^^^^^^^^^^^^^

331fc9cf44c011 Damien Le Moal 2021-07-21  3205  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

