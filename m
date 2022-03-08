Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE5DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 03:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242251AbiCHD2B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 22:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244903AbiCHD17 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 22:27:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E2D2B261;
        Mon,  7 Mar 2022 19:27:03 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2282Z8IN031953;
        Tue, 8 Mar 2022 03:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=pcUU+ZGDlpBOPjOzJdw7WnLWrnm9UikT+KfroGXJjag=;
 b=k73N/Q3xsKcVTYJPfGRxkEBEdnTazt0ENznOiCRoU7AkTYj3vf9GFQYJBKUbecCkqd7b
 xEcUNPM84MGPwzNZhXs3gEeunwmFI98gmt7gcbfb1QJy5kYByz9V2htIqfT7RVM9NaZf
 SNukrlDe71vPPCW9Q77SebVxFXfWp3dnRRI9pZaVk9jFQSmxvMu3BJHl1Xa5JfhyeVXz
 zEDnrjQd8DDkkr6JMnK4o9LI3/+3X1K+09q4v73bpvt4GNTChPMTSnV5UGhPN/e28ZT5
 kvb0k7lqn8OyqhQC1FU18RWAFY30kv9wnfAu0VqSHoUahU1ozTTwFc5mNOCO4IF7rNeo dQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyrank04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:26:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2283P8lc191497;
        Tue, 8 Mar 2022 03:26:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 3ekyp1qhwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:26:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iIA0CB+F93VZ8wlWcijkL4qPyMEoHnGmyIYy0RopZVMoMJiGaN3dS3gkBuyuxPDPsUpWET5C9eeYIkjr6OD/jB2jFm+so/mpG47Iv14eMGDUmvXm+9gbgSDXEcNTHRRjmOktR8I+cQS/0UzyFpmbxdJlMsct2fufczkaUIrv/BQ7GEMPhyU4Vx8exeXJyK95FSo8l9BNGrdyxVh2LH2DavMYEa3oP1ca+zK+wSEaW2Mg4gOO39Z4vmqQIDMZ83PqXY246c4zqXk6fB/3KhXSkkYtmqH/QsLFTAtymtU8t+TmsbQOfKM4DfHRaRarDXtrPMmp/ESfiAth6QYdpasExQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pcUU+ZGDlpBOPjOzJdw7WnLWrnm9UikT+KfroGXJjag=;
 b=PrWbN/GG+ZlrAhmqMkcZVOBrwvo7tAkhUTTaMiHw+uB6mE2hS8OJRki8DsQ58hvd1UvatElspkPYAJSiTEmqRVkIew1durfV1T/4mfvtuD/woDKfKorek/EeX3yGTevS8ue9aHUf8yqFG0Lv16InsZtfeJNgButb7c7Iw4PxVdPPLukIEV3XiwQJ/1X2oi1x4e79ZaSMhOYYPv9m7PUIfmvI7SrQ2ZWUgm9IA5+V5uwYJ/Gzv2nqShAwf+g2ccf8p02gotUo5JCf1nuPWC0p8KnF7jxk4WHFX+8Xl3XZG0VC2RX4g75sKdl4DvXHBPRZQZjc23o3Vqnn9AOip2QPKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pcUU+ZGDlpBOPjOzJdw7WnLWrnm9UikT+KfroGXJjag=;
 b=JrT8jAWRmJJko+J1aI0/OFVzppA7mPHHQNTbqXtbXypi5MIui44/Nk1RUGecYeYMhUoKYuFT4+cd6PMqgvp93BUwME9rLaO3BqJvTzIQwrNCs0PF0r5HZAQ4N0OJwxFGQ6CqhN//R1iCaBGyYp5YsPBXQMSOn61wkA9qd4AuiAc=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CO1PR10MB4481.namprd10.prod.outlook.com (2603:10b6:303:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 03:26:53 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d%3]) with mapi id 15.20.5038.026; Tue, 8 Mar 2022
 03:26:53 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 06/14] sd: delay calling free_opal_dev
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lexlp1ks.fsf@ca-mkp.ca.oracle.com>
References: <20220304160331.399757-1-hch@lst.de>
        <20220304160331.399757-7-hch@lst.de>
Date:   Mon, 07 Mar 2022 22:26:51 -0500
In-Reply-To: <20220304160331.399757-7-hch@lst.de> (Christoph Hellwig's message
        of "Fri, 4 Mar 2022 17:03:23 +0100")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0014.namprd11.prod.outlook.com
 (2603:10b6:208:23b::19) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adc00440-6cd7-4083-6665-08da00b37da1
X-MS-TrafficTypeDiagnostic: CO1PR10MB4481:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4481E980F6A1EEADEEBFEE048E099@CO1PR10MB4481.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2/WZfCkeL2jZ3WDBhQDsfPjMOQSE1/NUHq+Riu+k/po6ujzMjr0Rp5BTtqLNN+ca01xc6hBc3GTWUa18Oa+y9xy9ZLHFWdGg4kshV/oq7WuC1fx+FvMJVPOXaniQpH9fpFiWAUutxjzMWG2+eC73jAXLK/WGLfWeNcfEVB8TOfcw5FeJhcFged1pUcb1bFS2hpCoYzwwvCeHXE4jHUa9FgCJxOvW9+z860HqxgEPTSeLyTqCwe54X71CEy/XeyVamdD7bBzvdAofRRZg2LOmNepr626F3FY0W774LyLZ8otpqPZL/D2/k10PpS/TTuPO3HqwPSpjL+1b6BlVxiG6tY6OlDnN576MkNAkC5U5pRD36WwFz3YAxrxKfO59t2OMgtoOpRUrNW1esEIShfqjwAK1ALFOHMZGCoNPpyaZZ3zVe49ZpzV2hXfCO+gAzYqgUQgbvKe/9GTKaGMwvlztsugzk6BULGMNMUn4NDfSdk8KWNqTdbPeqdZW1Y/1Sd/5o6fzDK9muwtGRc09AoAXAXwyHG4dXW2g9I46VbwO9Kd8y0v8mIXgqiCCWym3gkd36PllFdDcngixcdylyhxZ3paI+X/f+teRlyifhsx5wBPMCx7WrrslQrWsk7NCzq3VSKLc5e63z5xMSY58ZYXueesojGzamYWFHOsJxNnt37bI6OZG7biIDmzn32gMQOz0SGhqAZouOt08feCXzKySPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(38350700002)(8936002)(6916009)(54906003)(26005)(38100700002)(508600001)(4744005)(5660300002)(66476007)(83380400001)(8676002)(4326008)(2906002)(186003)(86362001)(66946007)(66556008)(316002)(52116002)(36916002)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z8En1l0uyjbTUZP8IqZWoEcJndOHs/zGkX1LcfT/i8YeB2RE/pnqYcI8jH8C?=
 =?us-ascii?Q?vf79SDWR+LK0v7+niYLt/0rjGH+kJN7gzQeRFj0M35/vp5o75hu0kouMHE+A?=
 =?us-ascii?Q?g1vjcpmnR/FWDT8ab5x2Zjin1Xe8nslc3SvMrJfxUgEqmIM7xC0lP8VTRXVp?=
 =?us-ascii?Q?9It7L9gpDJWsfQ6FIn7aOwZwaBCPlLPHh5vQPqkadkDs14xAWLutK1ACoE2c?=
 =?us-ascii?Q?2U3cYzHlpUwtXYfKQTcknxHVRQsOmpf4/6ziko3/B9FxiAcivzA/2B1+vomF?=
 =?us-ascii?Q?vLpLMBR9l+KySWB3GQw4IMpeBniOQuXqlmWrQZ7Rdv+GTOPA2DW8NKCtyng4?=
 =?us-ascii?Q?9RZx9SXsbOgJg+MvcQdXdvb0XDuyEu+pstiU1AeFRNmWrjkqx++zCy6PSmzb?=
 =?us-ascii?Q?9750ayGEZOkMkR665Jc4c3xEWpyYDKEk5ORO2aVUUegMqQQAxJXYp7Kk0OAu?=
 =?us-ascii?Q?g41Zf8dsZMpeA+gAnKix+0GEcZKgRjg1SAlgs5yfoPxLBtF3ROx+GQTrsbhU?=
 =?us-ascii?Q?hV6Qe+sRSKvnfv5RHnH6AitpkJ+cDmh1MiCFfRNtcwl0+5tcZIu4AW1KIXvw?=
 =?us-ascii?Q?Yjw1DtS5qkhF3iymXaCRlnkt3r8viDPMbwBOtgdQxg/Xa9rF8UFMF/b4jR1z?=
 =?us-ascii?Q?eLzx+rCUp2gQ0nx21yeWT8Eoph/AOkqALMNggpJ0LFYehdpK17pK+sS6G565?=
 =?us-ascii?Q?0hF2NzNtczBvSjJc5PUsMz0fWR5aXC5/moiseVXhJkp2LBprcHJU5Ly+fNzt?=
 =?us-ascii?Q?4CeuBCgadSCXE4xm5yk5R0HY7+pnx3SMb5mEFeaf5Va35UNectlirEwS0Aeg?=
 =?us-ascii?Q?3/1MOXZClrbYcePwUUwdBU3ntZXUEFA9PD7C/0uBZdoayRO5stimQYpI+yrf?=
 =?us-ascii?Q?SgnuhHuXZMegt80ThspC8umDSBMAsrm+E95AG4IM8WdhKk515ZzV71c+/4Rt?=
 =?us-ascii?Q?Mqf+Z/qfdBx+I8jDRiO/PT8s0vtZiob3kmcbapyckhAywjQ3yxBIdvbxqN59?=
 =?us-ascii?Q?T6ZHXAajuWzeDdSykK+JKScfRiMuySiqU/e9irkPqWLWb624E8eukpmigOsf?=
 =?us-ascii?Q?alQzT6gO4IefBDFeZcaqDSgvSQIpX9lRTuqMEawmpxqFwWRPTpw6RnwR4G69?=
 =?us-ascii?Q?o0/xBe7sB6HeQUQq8G4RXglQ9LbHaVe9xqJdCt8zaWbG+2s5/z4OzOMXZGyd?=
 =?us-ascii?Q?CiXtSqAB+fp2qBhsoGNoeY1kRAVGoSaGVmYR/zbs6AWBYEG8pcM73cozxdvo?=
 =?us-ascii?Q?Oxugcmox77cFFMT33I1ak4+EZFjFjEBJNJ7txlBKphI4Ant+x5Z67UcDtt3X?=
 =?us-ascii?Q?vc6UTACJ9SgKGDnstGlOo/ZPHfmBAYZ6sLtRi7SSS50ZyBgZCQiSX74lBtc2?=
 =?us-ascii?Q?cMWb735k2DmghXnBSahDQeDX13iOFJVcTx1rKD78ER/Mi13vazEhVzKQLVi8?=
 =?us-ascii?Q?3O1HUtQtQVoIqp03+oUOgAQht8hqhQ/AmHjxOt9SNmzSgYtekSiWpb1LG8+n?=
 =?us-ascii?Q?vBvEyOVcK4eEoIOaSfNMysVh2KHcVCNq3kM3QE68fTI23Y6ieMeJAVzUbFbD?=
 =?us-ascii?Q?J2tewud92onoToSzYctyX7tk3F5Jd6/tfCzkkWHP7GmdjrEH50XVVBXww8su?=
 =?us-ascii?Q?XwOl7ImuWWFrbdVRmBFt2IWKJdkuuuLEnSTFbypLc3KK+CuoSjCMOBi7b8zJ?=
 =?us-ascii?Q?yE3aTg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adc00440-6cd7-4083-6665-08da00b37da1
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 03:26:53.4316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Je7P0mEFEn16UtzdAXS0wsM+yc39fDlt1rw/h4UX5xLFml9ogaOY0HUJq8QaWP77gb5ruCKHOQut08iMVjMsL35RbXcKBMVKfjI58UHObGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4481
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=788 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080008
X-Proofpoint-GUID: 138EnpFCPpRiSF7hQLQcmz00Hm4NOJZR
X-Proofpoint-ORIG-GUID: 138EnpFCPpRiSF7hQLQcmz00Hm4NOJZR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Call free_opal_dev from scsi_disk_release as the opal_dev field is
> access

accessed?

> from the ioctl handler, which isn't synchronized vs sd_release and thus
> can be accesses during or after sd_release was called.

accessed?

Otherwise fine.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
