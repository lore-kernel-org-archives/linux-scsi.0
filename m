Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB38C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A08C60F41
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbhHQDS3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:18:29 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:45062 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233585AbhHQDS1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:18:27 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H3BtpJ025387;
        Tue, 17 Aug 2021 03:17:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=POWv+ZxNnlQE/sXYwru3VCGVqXH8nyWyoum/KC58r3c=;
 b=J93/tl+52fByQoWAfkDMMNe5zxSIGtuj6E8McR6fvG+d535UG+AA5pv9WCVn/reqRw5E
 2aTlnllhI3U5oy9la7GhNzRki26scHOiVrclbJ2LKSX2liDH45AItkmlU7K2UfmF0FiZ
 +6g98UjQwO6STJkzsDrJKHthV3WhKuBBW1OoQhKdWobivjqWkkBPmlVtAGscpw8EI7Ta
 65iAkBaB/w0cwp5qBiUZPWYp2wBlK6thkOSciro2nMhlmENJKvf/iU7u0ldykVEBN0sW
 nxiNH2DikzWG+8iReZMC8kmceaIOyHGC/1IvD/31+jCFJj+4YtgaQg1ngk5KgNUu0SW9 eA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=POWv+ZxNnlQE/sXYwru3VCGVqXH8nyWyoum/KC58r3c=;
 b=sOcJyFXK9C1WKk5HaVGZzJm1c1o8rihhVUsZoEg+Up7pLdunr0GsAhLJEvzf3Ih35PkN
 HrdxtiTa0lyjy7ndLICtm4G8tnOup6WMmgU2F6gRtdZ+4SB4vkviA7XPCNXDM19qcI2y
 N+ocHIMujcoqirGXGpqeOnZ76h7WtqaOI73vUOE8SpgnKEVgjphpWB9iN/luYv0RoQty
 QI9BcPZSd6mRjL/xM3dtDfIeKaKsJwUyRSbnzwv9qoUM9LmS71cQwRAGubj5/vUu1UcY
 IJ7/zT4Lmg0xbMtxieXcvs9BFY3cRJZ70CjRB3ggAsCEcLvEtKAcevVVSsaeqCGOl25/ 8Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afgpgjn30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H3AxqZ038849;
        Tue, 17 Aug 2021 03:17:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3020.oracle.com with ESMTP id 3aeqktadm0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUJRDLtFlcF3r6QY0TEJx/MlDIzeYyM6QHBvDJSniruUG0Za3ksHo0poD9XvEMGhdtxlNlgAZ3NwL6qXWIX/wIj6PVo1mf2WhPbBvi1lxFIykJjm7qO6hKEtBhjxIwREy0kaKrJrqGPB7yN84GZDuH7SD9pdyd204/iMPwnoZ/fUbinfnQ4vEKeUz+PshjZZd/c1+8kH7CNsK4L99ghLJmP5ptOhY8mnl4JtER0eVgvRKefr8bfaG0WJg1P/NeC2BVtWOHK9Ik9qx/prEnt7IdHwBG6HvHvGAr4hLtpgjMFMB2PmlZe4MavW3lGFoSLiEZOdPSzLwQU0z9pU+PZkkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POWv+ZxNnlQE/sXYwru3VCGVqXH8nyWyoum/KC58r3c=;
 b=h7f5uHIty6eOVuHrtpEFFafpDs33sPm/oBBxbhB5BPRUYd4vDt5q/VU9ueIQlqk4idOnpJhDfvVa9TXjDsSHNu56yr4qIAMxChDKE7XBnHWIWZIUcWBFbQWr2JfBVNXwVD0Yvgt+5XG+ZQVL5nKO6e9tq+tutxiZirotjB3tI0djesxZD7j5bKj/tMkubL8SUX4nipjfDQu9wqJU192MwEiFdyJFgjDZttK8NSfP6WhXlcO5hpRelvidP/Y1oSI3TPV4ohzZAIAsKUsPIBTJizV8h0Zy/NENXF0VSCO+pbiMUWF4p7po8eSTu1Byn7Jb5rFU0FEdEnEkApXTonOt4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POWv+ZxNnlQE/sXYwru3VCGVqXH8nyWyoum/KC58r3c=;
 b=oFPDE1MmNUfw500iuBg+27U1kgJBGlaqAX681Kl4DAikz+IYgXsEW5AVyG5VzF4ZC6kSWLphkIdd87dCcHFilAX8PXwp2o7Agrb8DASwoaCLoERupU1PLR0nbkkHGFz+OP9GyDSI3am+L8bnKu4hnFFlwdO2f3FSl3KOIpD4tbk=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4566.namprd10.prod.outlook.com (2603:10b6:510:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Tue, 17 Aug
 2021 03:17:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:17:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] scsi: ufs: Few HPB fixes
Date:   Mon, 16 Aug 2021 23:17:32 -0400
Message-Id: <162916990043.4875.768876310075142181.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210808090024.21721-1-avri.altman@wdc.com>
References: <20210808090024.21721-1-avri.altman@wdc.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:806:125::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0178.namprd04.prod.outlook.com (2603:10b6:806:125::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 03:17:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a98f4b4c-34d6-4a8b-8a3d-08d9612d9600
X-MS-TrafficTypeDiagnostic: PH0PR10MB4566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4566BF03B6BAC0AAF07D1E968EFE9@PH0PR10MB4566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7P3KvFDewHHQ7lSRqmgxN4j+hRMU2NK+SmzOhWA1r7R+dfmoVfGeKjJelz/IEU7p9zYuyd4iP2BZUMj6QMTyzdgYxRksw77FtNyrJuPvEenqsJsW9LazfxFR5HYa4rlfnQ0Mn0VrOAvdOPaSHZlhJpI+u9LebBULNlGUxhb84EfMVwsKaCSzGI7uShSmQ1Wv4tGewaXrg7ROxX8Pmxfwn56kwPZhkYSV0RDZiRg3vg2/tMY8Z7tQmJYflCKhdUMH9CIOuBFLzLQu6+vNWU+e3qb3A8QGwP5ahoBqQQuOGBm+3LsA4aJYcLTGpSVfMOsWqWko4PHXX6Mde9mR/IZsLBXdA71uDlCbXQQxUOibwSCdOJfIQ1qcD+KGtPRyJfK3cpUGDtEu8fb8ZMRjeHpJSft77gev6TOOIZDoUpjwUiDm0RsgjF+afuqeETVjVi1DK11ofh3kOfKRDAv6uo2W5dipaqfekvnQXCKFtWqW1j7rn+xrQF/gNm35qs2Z4s1PXsl9iTzByGQCl3Ve6FUgkMGExHluIGP/Oj1sx9zrhFnoWktKvpghXxYZysyqqgl242poqUuQq5/7KQxIX0K6prSLOJzq/OWMemBtxHSU93TMk2CUQ2SCL3kjguTVsrkDsAsXxyQ4uoYwxFvHb49zk8mM+8CnM81O2w/iHQJRSSohyW7C3rTR4mDTGeNOBim+ZuT806idleiR9WoNGvwBo9KxWHWzMv4WOJwXFLc8lsydeDEUemxV4TTWb9Iji8sUz0QC9ijx3pIrR2B/bTk6FXzzVglQ+sAxu5+Is3tk3ir4rLIk4QwqPXCM07qRUJQI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(366004)(396003)(376002)(6486002)(52116002)(7696005)(4326008)(66556008)(66476007)(66946007)(6666004)(5660300002)(2906002)(83380400001)(86362001)(186003)(38350700002)(8676002)(4744005)(26005)(36756003)(54906003)(2616005)(316002)(956004)(38100700002)(110136005)(103116003)(966005)(8936002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGxId0s2eUVUbklZSFl2SXlrSzFPWGJsN0MvN2JBRXdyUklLWEhKVWxJMnFG?=
 =?utf-8?B?Wk9zbWVFWVVlQmZtamZwSWJVd3RUNlB3ZHlKYTkwbTE2MDlNSjNsN0ZCbTN2?=
 =?utf-8?B?Tm13YWxBdnhnd1BSS0NxTnV3SExIc1lCbGRrNTF2bC92WDd4N3QycndsNGFH?=
 =?utf-8?B?UWlpOVBVTktmTVNObFRZZ2FPVnM0a0ZyMVNkWVYyU0lmSmhPZ2h3cTRjVDhS?=
 =?utf-8?B?c2pIcHNxY2VlOEdxUEdmLzhoeWFWWFJKY3BYWWlxV2FRVWVCQ2FRQzdXV3Zu?=
 =?utf-8?B?TVcyRDVGbkswcjZQWTJQamJtT1dwazlCdzJWTVpJb29pS0R6bE5Qdmc0TFI3?=
 =?utf-8?B?b0lISUcySlVmQVhUeHBuc3htQ3RLNWdrTUFxM0svc0FPM2VVVGN6bExBYUwx?=
 =?utf-8?B?SnBwZm9lRmM0cUx5OHM0OHNyMitaTmhwaGNwcGJUaDdCM0Z0b042ajh5RFRm?=
 =?utf-8?B?eTlLM2cxUXQ1MVZOTWN0R3Fma2lxeE85YTRWODNFVjFUeGdKQy9NWGRMSHJJ?=
 =?utf-8?B?TUJQT2p0Qm9hcEo3bWFCSm0vams4ZDJLMTRTdVoxdldTb3p1V1plVGd0amdn?=
 =?utf-8?B?dE1tQVBrcCtFTnVqOTdEY2JyUUk3T014RWYyVCtyYXRIa3ppZUorbjU4eGpt?=
 =?utf-8?B?WndlZC94OXhWOVBXdm8vNmJCVWIyZkRybW40ZCtPN0RxM2thR0JSTTVtZnhu?=
 =?utf-8?B?ZzVzQkc5QytwdWpuOEs4M0QwR3dHSVorOE5UOEdPVWVpcGtrWTVrQVJYdEE2?=
 =?utf-8?B?c2VvMmF5MDhpSEl1cjZLWE9BbzdoL21DTElvZlhUd0JhTFgyZldsU0hwc21m?=
 =?utf-8?B?WDc0MzF0TWk0NzBxTVprRFlIM3ZZVFlHUVNydVJkZVVuL0NYeXF4NG92TDQr?=
 =?utf-8?B?S0phQk1RbWJLVDRuWFlxUVNMUHpHaGxKQjVPNnlLc0dvNnpabCs0NEpCcW9Q?=
 =?utf-8?B?emJpTVJsOXpWQmR6THAyL1pxbTAvbWFhbk1vbWNaQU9GSmFnQ2hqU0FEVDhZ?=
 =?utf-8?B?Vmh5US90VTliaFo3NlBuM1JrWUNWc1hCUUdYOWc0bjh6aHJSQ3lrZjN4a1VS?=
 =?utf-8?B?SVZ4SjA3STlnNVBmSitUTFRLUG11bUpPYU84eG1RU3hveVFkVXREZ3VLN3lT?=
 =?utf-8?B?ek9TK09hUkhKL1FiZWNVWkwxR1JtelhhQTBwZDRIMjllSWloMWE0NjI4SXBw?=
 =?utf-8?B?NzNlWjR5RjJtNlZmbnE5WmppT3RqWGx4OC9WZW5uNGxxME1BWHcxNjN0SXU0?=
 =?utf-8?B?UVh5Y1B2dGx4VUN6R0VJYkkrZ0VRWnFiOGM0VTF2SU9HMlJBM0s3TTk5ckZm?=
 =?utf-8?B?VjUxZnQ2QXpKcktZY005cktSVUUzN040c25pcjArUVFXUk1xWFJCdHcwaHNy?=
 =?utf-8?B?c2didjhpNVY2dkF3VU9KalRNaXRiODlLcG5qdHpEK1RWZlZCS1h1MWROb2ky?=
 =?utf-8?B?ekQxNVJJdGV6ODhlYTdETi9FNy9UYk5IWElYWi9uNHBlb0Rqb21qQnF6NVRa?=
 =?utf-8?B?ZDJwR2dvdWxXYWlGNVNlMGJYQW5VcUdJeVFVOXAvUFIvL3dFTWZxbDVYZkhm?=
 =?utf-8?B?V1UyMUM0ZmwySU9iVkRpdjNqUHI1VnJSUjExU3hlOFdYcWhVdWkrdXUvM1hU?=
 =?utf-8?B?YlFnZGZqSjFDTG53MlFMTjFCbTVRUit6M2RVZTJ2bnJvcnR0UnJhdXk5Qlk4?=
 =?utf-8?B?UExpNm5tdjh3Ky9FcHUrbHBVcGJEbWp0a2NSbkpJM3NvYU16QTg5ZnFLRHpu?=
 =?utf-8?Q?Azsvjx1vuqqPJwHkuW+Lfi5i/JVgDEVYY4rRZN+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a98f4b4c-34d6-4a8b-8a3d-08d9612d9600
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:17:46.9677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LSQLmTDS2+/gYlJhktyQnFIqK6gVQ6z2fTMob4e6i6GMCJ42zTSrlBPSdgwkCcF35P6wf2+OpftjJFJPHHFycvzLtPuowNJl39Seave8UFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4566
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=915 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170019
X-Proofpoint-GUID: N8S0La5YIGTbN3fnuhgtSezndKQ9S9XV
X-Proofpoint-ORIG-GUID: N8S0La5YIGTbN3fnuhgtSezndKQ9S9XV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 8 Aug 2021 12:00:20 +0300, Avri Altman wrote:

> This patch series include several hpb fixes, most of them host mode.
> Please consider this patch series for kernel v5.15.
> 
> Thanks,
> Avri
> 
> Avri Altman (4):
>   scsi: ufshpb: re-wind the read timeout on every read
>   scsi: ufshpb: Use a correct max multi chunk
>   scsi: ufshpb: Verify that num_inflight_map_req is non-negative
>   scsi: ufshpb: Do not report victim error in HCM
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/4] scsi: ufshpb: re-wind the read timeout on every read
      https://git.kernel.org/mkp/scsi/c/283e61c5a9be
[2/4] scsi: ufshpb: Use a correct max multi chunk
      https://git.kernel.org/mkp/scsi/c/07106f86ae13
[3/4] scsi: ufshpb: Verify that num_inflight_map_req is non-negative
      https://git.kernel.org/mkp/scsi/c/22aede9f48b6
[4/4] scsi: ufshpb: Do not report victim error in HCM
      https://git.kernel.org/mkp/scsi/c/10163cee1f06

-- 
Martin K. Petersen	Oracle Linux Engineering
