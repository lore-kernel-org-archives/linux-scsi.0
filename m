Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 003FAC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1F7A60F41
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbhHQDKE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:10:04 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38886 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233690AbhHQDKD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:10:03 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H36iIJ001307;
        Tue, 17 Aug 2021 03:09:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=rm8BcmX2nPfnxYEOzQJNoJCCy6rtkgOTjMHnpXS9aok=;
 b=hZg1cdAzWlHZ90tp7kPRH5VH4W935SrZsNuy6ymBxXUrErnuAYBoikIbYMKhmv11Mcua
 uSi9nYxi2EChzse3E25NxgSN8+bgfOBZ6hoR7+DsxsOwG6Fa73PMLTFt90ta+PhYjboH
 ma0SC8JTmoiMn56BQ8GBhzXI29RzIn7aORwziHjvV3c23zjyyGMvqi4L9nNPqCcQPOtt
 j2sp7WZA5Ppx/K/HMkJ9x7F+rEcZGxkvZncnUQXyk2+m5K4EiMF1lNI0PkwHSvETm/Qr
 dfmmBbqrn2o7aQyWm2PjlQlx+mGxHqLbSxxrhrbac+eIkTw1i980zeLAWMckCGQmgTGy JA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=rm8BcmX2nPfnxYEOzQJNoJCCy6rtkgOTjMHnpXS9aok=;
 b=dbZccTtJ2zR/FbyMd8x4poUJSvUv/XnMjyK10YRLbchLclHiHTSni22nhGlNSN4ierKi
 xW9IX5qeAp663z3kqw/Pz6Ta2E0oSBS8bDHQocBA4sgUSyStVzEkfkSChh0YHLvLlpVy
 fd0IOXb0VmzFUBg0zAXwjsHDxaKFgqAgFX8uLGXqQDN5oLPc8Qa7m6ZVQS22XvEXTaN0
 jQkCaZnF0Aze2wJoTIhfBV6oR8l2tPL+SQJqnsR6OwFnMBK66dOEgF8at/cu814t7JXJ
 HkCDHY2lzq1m5wTlTnMBmSaOh2RJMwo69SAARFtEK6OVFaOTNMgJYg0XmMEG57413e2L HQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3af8303bn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:09:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H34x6T073951;
        Tue, 17 Aug 2021 03:09:22 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by userp3030.oracle.com with ESMTP id 3ae2xy9wpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:09:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXIL7g9UDwX4go+RRIfNgGNGcSB+bPaFNeP8OzeDEzuQnFwWOPiXIPseVwBxYak4AjFU88napXD4sAPS9hRAUqxdpP6ryzo9gQmwbL04Xw7y5QH/3LzSKdhqxmNqAvTtsc/AytBeQhJbX0v+fdBtq2UbN4Q7kC6oFn3sxY/GsdeuHSGh0CsAN09G/X7RFMCz6K6cMl074WvWUFGvkkwh30/YyilnuW4tbp5yEjP/cfwI2rAASMsjiOzLm5Vg2gLhBzWxPH3CmkRt6ol0vDduMzMGbxEwIFRSB6z8XJ8UtNZA0R4qnxk3MVL9T7c46sfpisWJdBb3UtBrvDvKJRZTUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rm8BcmX2nPfnxYEOzQJNoJCCy6rtkgOTjMHnpXS9aok=;
 b=ax3d62rvuDZf9lTFqrmB7dVf2RL/23njbbp36jIqzJuO/X8o1ERGtzcsrQv/gIlhRTbepGE0AdXGb/zijwFBmV2wcG7j+78/GDuOJGm1LHtlO/5IbXfcE9tji/TGi4v9itS7R4qpgh3dOi5JDvobplTUU8mWgvd4JDPOlPxJRD9WDG+pwY3RwepstXWWPLsjJxQM5kb8SDVYVzE6asIO4YKzNbagYVcfBacSvoGfAHG/m1sYAt8Vcu91xIZunyiLVh79J8kNfBtzQQ0LIcJ+Hp8yNT2vDvkMnkMOF4a+ovNkZLaYjIDjI7RPCw7T9xG8lTvsmaHPjyUCeYPEzG+o7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rm8BcmX2nPfnxYEOzQJNoJCCy6rtkgOTjMHnpXS9aok=;
 b=c2OFMzEkhNN5Jwfzjta0zrIP59LJIj8u3/ow+9nDqI50J6cKoirG0ecKWgg6HPc8K4AT0IPWEg0eBucKdEu7ZT30vWEJUtNrViswO7H+0sHAIgM/fXIZi5ZdnYVfV0fgzRPnfGuAViRWJeUXKLpZO6ewWKuBPAfEr8sPJ6zxEIo=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5561.namprd10.prod.outlook.com (2603:10b6:510:f0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Tue, 17 Aug
 2021 03:09:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:09:20 +0000
To:     Sergey Samoylenko <s.samoylenko@yadro.com>
Cc:     <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
        <ddiss@suse.de>, <bvanassche@acm.org>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [v3 0/2] scsi: target: fix sense key for invalid XCOPY request
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0kkojhp.fsf@ca-mkp.ca.oracle.com>
References: <20210803145410.80147-1-s.samoylenko@yadro.com>
Date:   Mon, 16 Aug 2021 23:09:16 -0400
In-Reply-To: <20210803145410.80147-1-s.samoylenko@yadro.com> (Sergey
        Samoylenko's message of "Tue, 3 Aug 2021 17:54:08 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0067.prod.exchangelabs.com (2603:10b6:a03:94::44)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR01CA0067.prod.exchangelabs.com (2603:10b6:a03:94::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Tue, 17 Aug 2021 03:09:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a7166b8-cf68-4ae0-5094-08d9612c67e3
X-MS-TrafficTypeDiagnostic: PH0PR10MB5561:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5561AF5DFA456A492668AE6B8EFE9@PH0PR10MB5561.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +aEJX/wNsxRfxs158vFm+w7TzG8jCmCLYPCpmTyzx7zGzy4hydgKL6emRUGcgOnjG7r5pEvvY42loJCKWFRUBDURaJ0I0AQU0lOp8YG5nTyBArGeERy3Kk+vZ2BLqSKJxRmKZQSn6Zz3EApQ1o51Jseyl3zxBfMTKfNltf667zmdvn57EM3y6fx0/SLbOvMy75J59o1Z8xaAg4n3PNEVSOGwhYCInaxSfx5v55h3HWcyLvb3njc2BZSkX/yrR5+a9AV4DB5wsgs4ryMExgPLjssXlDBIBKNmxQO1K094rznWEae5YEnPU72g7TFHRg+V6Ag0Lq0O4JNybYi1Y1lG8AXKvO69PtyeYI/1x2c6TTStWmNWfvm4w+Au6A7biNaYFwcpDj39kMT3VurK4fHHwwg7S8DSKHVWMfIa9ybs3qrjJpkiuMeWHymWsTdfs+c1HgJRDs2yWqzZAAmCFAcUFeuLYPXj2GTJdnwkej/3mNaBBGLFXzBawHa1jyn9B9x8V/dLxcofZy101vGsRUa4Bup8SDzikt3+QyulZjPSIGnMYNybvw9Ut5vVm52IU0RXivOW3sQTSutnHmSgv8nyjDkFWswXCgUrBMfa+U7QpDRVThpBolIF2iRCPLv7oGdC9YnfqL/NLD49OlYAbBX5XSm755ACBi8UICk6nZ29ZPxCnQIsJea04UtSXzTbwopnx967byErFU5b55g63x2M6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(83380400001)(316002)(508600001)(54906003)(956004)(26005)(86362001)(4744005)(8936002)(2906002)(6916009)(66476007)(66556008)(66946007)(6666004)(7696005)(52116002)(36916002)(38350700002)(38100700002)(55016002)(4326008)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hV+iPAPDPBx2MsgXIo1WVp13bXFpP0tpOCjvvKJvOQXXYqM2juiHJ+3L03ql?=
 =?us-ascii?Q?uMTRXsJe+O6gCwhHX2IYkfC7XtflGMC8+bvpwZF/Kv9yh242bv1soP0Qxiwy?=
 =?us-ascii?Q?Zl2nIck3u+I9RgyQP+Pppkgb9nI5cRYJPhFenEpHxaPQerk7N0ZkjXqNU+n0?=
 =?us-ascii?Q?lD1MupO68sNBsEbnBGdyEHFwR/U8xmJLPHLyTTNNAMPIe9PfR/wVbdNt1TGf?=
 =?us-ascii?Q?KL8CeKv5RrTWS5x7wprGwgNRLq/mKI6bwAE1JZSVDeEdYp6Nq+noa8NxXQel?=
 =?us-ascii?Q?HDCf5b4UnGwcuNwsNfHuPNiXhi2WunJH+F8fJWz5+TAhRx1+nIMdXfzPc8UE?=
 =?us-ascii?Q?mhRFR2ZoaSCFwspw8BtzUu3t7I+0qC7w33JkUqaSDwkmR+QsNtYnza8tUGk1?=
 =?us-ascii?Q?rNoPj+bCiFL/q+6G2rvoUX0/nIsioBopztVVGYAvDnbOHa9OTLiWGSUhDD97?=
 =?us-ascii?Q?bjVvLQ8xEJmWBmTNOqMukWOQMax8KBnhlRltp6kH9XhfoaHJAXebl8YC03iG?=
 =?us-ascii?Q?2Mxp0dbG+/6WHuAd3BJWy4iD9G+LLmOj0belp0bYqsu5aNHFWjEevyiKTSa1?=
 =?us-ascii?Q?YHDC8b8WTRnE7oNtMV9Jy3SlK+4TFrq3Nk2UOF4urQbg7WVy7rqp6+/4Eftr?=
 =?us-ascii?Q?/VcKA1YdbOAD47zYOfYiaTEFmxQjK5OFIg7WufywqdOgxh7WSxyeC0sde4Aw?=
 =?us-ascii?Q?sCeG80rwcGQE5dQlJzrjnPEBBTnLA84rXog3xkHEnL9Z1gIyzVVEYDczOzl0?=
 =?us-ascii?Q?eVMMSmCOldgeu1mfVx5e/KbBm+7WafCeWdGK+3JyZKGoVZ+hgTIbvVLlmdKM?=
 =?us-ascii?Q?AMFhUs7s/9dTNERBpEg74hSDN7tqaGoUpzBLD033qMqW2GYbJ1X3qppiqvMn?=
 =?us-ascii?Q?sDQhJCZRVC2iutXRjocX+4hMq4bL+nHw+Q9LVxqYUFcyY0/abArk1dsW8agb?=
 =?us-ascii?Q?9n2up9fIlsmBkQWm7Gl4k8BEm+cwLTssO+yKmQ1JRaq9SUKKRFtThS9KAp8M?=
 =?us-ascii?Q?GhE/vlWZzGfxoQ6/HO4kyaHS7S7b9VoTn1xmjwKvxg/aIJqBF3QyPGW9+QwO?=
 =?us-ascii?Q?FMRIGnRFotQLGYPcAUb6BlNpmCCLHbu8XnhisCf+qiJ9XCbSwmnNK6jgKi12?=
 =?us-ascii?Q?L9fCq+jvWoM7Ca+9nxYhGKJRhqTk/F5ujeVkBxsvYvaVz+6k5G4dOqD0ktuP?=
 =?us-ascii?Q?IfTr4WRK4TVqk+o/viwz2qZFsyraFx4ij9qMSdSUpg6MqK2VzwaoQeUCMZ75?=
 =?us-ascii?Q?NZoZotKlwVVyA6wilFSisKS1LWp7InJgr8oewvnI9HzgVteqSLKohDDwrcpU?=
 =?us-ascii?Q?7JEP0mHWpsYhz2VTWzo3utdz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7166b8-cf68-4ae0-5094-08d9612c67e3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:09:20.0236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: um5yYIsPX2OumaJEAISNELn9weLmU90/U4/2B+oqlBAvbB/JOYlpUXAlQLAI7hLvimvljvIrrKCNb0YpJpL/SBbdfVWF/aqUJo++moSLIxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5561
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=806 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170018
X-Proofpoint-ORIG-GUID: eMaiHE89anlKHgiYvT6CDJimgnujfJ7D
X-Proofpoint-GUID: eMaiHE89anlKHgiYvT6CDJimgnujfJ7D
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sergey,

> EXTENDED COPY tests in libiscsi [1] show that TCM doesn't follow SPC4
> when detects invalid parameters in a XCOPY command or IO errors. The
> replies from TCM contain wrong sense key or ASCQ for incorrect
> request.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
