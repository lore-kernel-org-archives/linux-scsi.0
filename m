Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE6BC7EE3A
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 17:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjBXRsI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 12:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjBXRr6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 12:47:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B293593;
        Fri, 24 Feb 2023 09:47:51 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OHhrEn013868;
        Fri, 24 Feb 2023 17:45:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ZErqBaMndButBwMFn4FUb9IbiqcWB3jZAeeXjD5QyaY=;
 b=yMiED10nQrt3Wkz2eLdwS4XwWfrCRhATo/R+gLPg/FlPvnugmKsn4uqnPYnLwg0KqQ6i
 t1234FVX+cTMqz8uqGSHbojGR1ba08+Iu5o06F3htBNxnV3c298XJyTrBYdrbBN6YiY4
 u9MoGivtrGvooRwly6BHCt+xEpsgoqbKXfQoJzoY+V720CfiSjh+WYHPCQr9qFWRmbEe
 yAIv1m8yYn5qKwHMOGJbTWdbaFV1q+jtJY89sZflhkPKx70VLoyvVf1zD97c0HdegDJP
 CqCiojE+C22QZaqjowZOvNzKyvTDRBi74AeMHBbkdzsYS7LQHRIbuDvsTyA/Nh27w0NM gQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntnf3nqxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:24 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31OH9Lvl033950;
        Fri, 24 Feb 2023 17:45:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn4h5nu6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eFHT4Y7VIVvG2Dxb97h/r1MTiZoLnip8xQHnstgwPAG46dCg/wwws4v9uPy6jquDH9cguFK1foTgla1lx7+PeI27dpTSTXnAwo0boFrlaDZowUdiuJkhPO1vlu0HbYdnp0tboVl8A2aXIjW99EQMWfp5mcUbtybl4wA0NNLHOTsPyQ8prYbVcNSWsH/jGjI4Dtzi7J20kHFEF4SIOLOYMcRknmCi73usSYB24s6+2rnJ4kw02VNS0n5xxxJOJ7cFAZdmnjaLW2DiVX0zOKTSqVmq+guGqA4+BxRUzNUQVI/IGV3/XaMSyan2/lcpeJ3SwQFVUndTSkb0KAAWB59NlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZErqBaMndButBwMFn4FUb9IbiqcWB3jZAeeXjD5QyaY=;
 b=FYKva+r0LkJco+sBxA97Dsb1zoNuMctDupG25nU/blMhjAtJSQXGNn/aNBG3BXQgRNQjelmCShsmb3uYVewU4s6IYg/o4aeYUgqqSVjhcCRiFlcIE8RWAdZJ2TZZo4DgYE4caJJBMkIQyFGXzbkol0qzUy9tkXt2u+uE//EWwbop8dzrJqBRrNGmP5v8GZ45Z18/HOqMqsq2YtW62Ooc98qdmZdyp3xFPkXt0x2ROwziftcZutYCxkdjOrZLpy0M4cL/qmD82pKoah8Mo567yiKiFzbgL9HOLURArRGEPq6IgtrReJDrLjBj1xQU77NJrw2S5CmMgD44rbiHUtGFdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZErqBaMndButBwMFn4FUb9IbiqcWB3jZAeeXjD5QyaY=;
 b=FKHaCRWb2628/Re9D/AIjpAiC30mVr+V1ErU/KryhS+uou/Z0wB+PqYzrn1Fwm5EN8yvmWpiNjWaHgQvdi8BPDoK3t2/drF0fNOngP9hiwv0BDX7vbWVazQM/V2LXr2MuaR9ticfi5i1MSI20ZFpstZMcPLqr40DB8+CI/H6Jws=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 12/18] nvme: Add a nvme_pr_type enum
Date:   Fri, 24 Feb 2023 11:44:56 -0600
Message-Id: <20230224174502.321490-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0305.namprd03.prod.outlook.com
 (2603:10b6:8:2b::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 6540f1ab-ce3e-4f21-e941-08db168ee75b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RCTYJAyx0bKD+c1NbuRN4BVAu+yCNlo0avCKIl16a3D3jYWth0r4mnVUcmLMMOm0UwnQPYmDDtZVY8S1cbiJ6z+j42f+Yw17B4gPkMPNidVIPlxt9eD7MwXtTJOrPWQS4e0qkFCm5taL3n+7uL59ya4brVIZ4vUUtWfWjGsNPMWCO6JDmHY03wD7VTIaBJzz3nCf82Ke/lhCe/HwnvNYA2Dkl2RNI/tVAWo7seMm4JLmgygrgPYnxi/rU7raPy4V6QTqcKlAB5Gbq/0oc+EFxhZ9KNZx7SdEkEKFeSfFKlpNmIubKsv2pUl4cs13eEcF8vWRJJNqHsMVsTjTRlnuPhhR7tqFpJUce2Dlhuxtp/E7lBu9u5tzsDxeqX0kRarSKuL3VAE8Fg0KLytnFigzP29sRl2BKKgXdL/Zhg4kSFLtFHpRH1MpDeLyEAdubhsG8jlI7GsYr5XWu+yHV86qhRf2mPFPBOfGe/NIAZv9jn7dhQXhOaTEPPQxzqd9PbB9ieLtjBwNTA+5THSFOqeB5yqM1nw6Xmsur5O00lp0TH7VDu4UMIKcHjRxcXqpJ7jN9z7l9g0PmatlGL3rCdXCuFYiZ697LmF59mo9lpzyLy6pyNv0DRnAkhEzc6FmaCdPD+79GZBMtBOrRIScX2rjDstWQ16NqqvGHgheFIE+OB09m10k+TTf68ryxQsDi8lQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SdgDFr+lkFeV2a9L3lKo9UJ/1O5AZukHUvN51Rx8lM3t5pSekp+kiREAtweH?=
 =?us-ascii?Q?TRGxBcfBwld13TduNEGgP19ZVNR1NQNkdAakCmaOHNiPP43XH0AGqqZV+ftT?=
 =?us-ascii?Q?UJ4mmAQm+sDn5+5sg/s2gUnTxm8sg/QV2yNKXr/jhXgiw4hZrwIH604xeudj?=
 =?us-ascii?Q?u5g7cUVLW1S7zc6qXaQEYPT4AQsVMXQt/+aItL4be+e1h6Ms75pxO4YtFW3J?=
 =?us-ascii?Q?BQbxDfb9hfmaxV/EeQ2xY2JCQPCv8qb7IHebH42ds1sJeQEof3/1DtOiLq+d?=
 =?us-ascii?Q?YCgwluxsES5lnY5qG+U4Wh3vGQyfz9Wj5k/KYTnbnuBzZa2aWTc3uFmYneuw?=
 =?us-ascii?Q?Uva0JoaEAHudrX+KkLVy5NwqNXMYc5wgPNvwv10UxzshkWFzYQ5NNhBCjDd/?=
 =?us-ascii?Q?BzyHXXs7V8lI5KHhdKxStR71uJnlidD88adOptqCIrMfBUsnILCBUhUjh3zI?=
 =?us-ascii?Q?f/mMzugaMHycunq0ghAs6BYHEA4vcUZvAv/D3Vs/lAPD2nwi0/NgvPyJJEn2?=
 =?us-ascii?Q?o77hpy8I+XOde4SMN2p+Ec/0dhAFLzMyrSCuE8HPsZDM47xOc+DGkA8fZDl4?=
 =?us-ascii?Q?7XVgUUHYrrrBFQySJV4udI/8v4QWa1NSaW8f69/Tt5zvJUWl/Wo0mf48Uk4A?=
 =?us-ascii?Q?3TI5ngEYyPZuWhWLj7kMvqa0M3lY/9WPc4zOzxARCCSnY1tD16DYOa7Z/dOd?=
 =?us-ascii?Q?Qp3rkCnObyDEjDtewa/hiSP5qKg8WRzOPNfE8qYv6HmPZhs0Vbel++3XTYtP?=
 =?us-ascii?Q?/cYjwBHpcuftJ7udLDofQalEqbNxxZGyxUaUiqX0jxKpzrP8o7F/XRfMt3Ve?=
 =?us-ascii?Q?wRt/c+jqieUZ8npseIHSXZqtmhJXPBGus7dzi2tyF+zCLbv0HLpUoUK2AkDW?=
 =?us-ascii?Q?q8FcvYIIE4+3QZtaPHkjKGISCklWMnJ2Ip4EuOJWQLMXVz3j4rEY+9TGp0D4?=
 =?us-ascii?Q?USi8kMnXxZRNY2ZvUxgSRuVkDr2Wgpm4GFBb1nKveqEGpuTMJMPecSExM5BI?=
 =?us-ascii?Q?63zg8wxDnplcN926JyeMtUPFFFb/D8qA6duvJ/Q1QSlLIqpWDy8q1qWikT1p?=
 =?us-ascii?Q?/J/wK5OoTaI/1SFaZkQ7lld6sQIlcH6Ajx0PGpmN7bq6LDg/9bfIRuLzJJwN?=
 =?us-ascii?Q?2rznSy93WLONyRzWF1nYwgw/29jKNrwPi64dmZdVU8ArdZwiB7ChZ/U/DBqn?=
 =?us-ascii?Q?Zc+JBBdNI+WVTbx81RNhLIZPhd2GJiOh9TWZ+uzYurKi0IlN6h0vcEsQzl/z?=
 =?us-ascii?Q?yfTu7WOmqacyAiDgCUogTEB+2HqoE2lL9qAp+UQbCIjFAgkUymy6MLNY5rF4?=
 =?us-ascii?Q?/eIQqrgUIyX7CMdAvX3YLFhRdhuzDU74lbLikFh8/vv3QazpLNFVHsiSDhrn?=
 =?us-ascii?Q?cWatssJiW9J0/wvrHcPDIz4xduYg8shxQUpDEtkZngpR3WiodAwH8nK7/yKk?=
 =?us-ascii?Q?4dsnFUG0rn6kgmPON7VNOF2+q16/lleZN7k40cqhQWlqL9PBXPndA5G54b3J?=
 =?us-ascii?Q?f4an20v8Qi0rXP9CIAq1BTgTzGBQYqozYxux3WopEfpgYKvA/VbnxEVydzBl?=
 =?us-ascii?Q?r0Gw90D3L1hLFBBvLcYUoe5pkG6SS4VhRdyJ4cMg5TTUOrZ94mlCuzfCfHEd?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?QcHvJBy+pUuSQrtMtjBYURlY18lqahhKZN9OzRhCASYRxhZv3Fl6oDcN0xg2?=
 =?us-ascii?Q?C/moQT8wBMUPgqCdT9HgKyl6nm7HYJqreGahxFSoLclxeJYCPQnE2AfqOPb6?=
 =?us-ascii?Q?9DDLdH+0SIOASFOR0hGuwDW+T2zElG7FmOa2uWgtkG3Sl6ppJ9EqF6ny6ELC?=
 =?us-ascii?Q?J0HpBO6/hx3exYvBBwyN/UBH58rTZr95wkuBVhspMQ8oV47OktLiIre4b6TK?=
 =?us-ascii?Q?1f5+GX4Dw6YMppOLcL/UyvTw5URN2AO99xc3+l0SadpRD6tmBxmcSq+bBFlo?=
 =?us-ascii?Q?1SBL7j35A/nE7mZCUjNbN1OpK+rwTxN1I8lULRQ2zjUbToTB2YaQWk4v+rWB?=
 =?us-ascii?Q?QJlHzOr8xcC+Oo3HkQrkTjjUab+wGzG6i5uj7edTtFq+VP4JCUY8oio5Bflg?=
 =?us-ascii?Q?Tb46D+6CaoGjGNiA+6PtxKBPyvCkcMmass5KrHXA4+FK5vZLO6/tEm1OHn9a?=
 =?us-ascii?Q?choUjWXbbZ5ZvvAAbAAp4elJ4MBIFuqOJtiwYe+uyR10/OA4W9utd3t9OorJ?=
 =?us-ascii?Q?BIgvT7/MhnkAsSPeysYcThXMkjf5DnhfYcf86oU6zAA9fennZnJudHiwnSew?=
 =?us-ascii?Q?ZHPKNHYxP9qTWz7WuUb1MGlUyFMbLa8//tC2U8h6XfKEcOBZRyFtL3iNEOU2?=
 =?us-ascii?Q?1vt5vpTtWa2/zCz8MhFZITJwt/M47CAuIjRSG4Vo0ZzoVAGSFK6PUxvWziMn?=
 =?us-ascii?Q?b3ba96jTMdWjgQYbkJC0VqxFkRTojmNhO6IfRG3BWb79b+r9kM2848tfe3KG?=
 =?us-ascii?Q?SDOacZnP/k47hpN+/7SGWnSaSgVBkIF5XUxKJH01Mz8VB4Y2gs9OLx7WMEsX?=
 =?us-ascii?Q?FM+ox4GllvOOyxb2pVjErlO9dISaDSNc2G2ody1CQmBlerFMwWM6BWS6ILPT?=
 =?us-ascii?Q?U2DzS0vUmHD5GCaCdtDz5XM2ilvvn5J2ZS0c5hKATOZgyk2p8jt+VOXTLwZc?=
 =?us-ascii?Q?9p8S0tQ60ttlDWp8EeWbDT3hWSOie5TEDJfc0u/GLW6dDRy0vRGVje/uci0j?=
 =?us-ascii?Q?5ECxk2Jpts7xXWlL6NECph+EtA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6540f1ab-ce3e-4f21-e941-08db168ee75b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:22.7503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tI6dOiDvxIxE2QLRgldv7XH3/oI1hUD+4tYyboqekouZZ6fm+M7KscQJiyLe6jNXpxQMju18RTr6AxklQeqLS9HYn3swMsv+Va2qR3HGC8c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=979 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-GUID: zVUGl1rlKG19WAKVedmC9ON4U3yZF7Na
X-Proofpoint-ORIG-GUID: zVUGl1rlKG19WAKVedmC9ON4U3yZF7Na
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch adds support to report the reservation type, so we need to
be able to convert from the NVMe PR value we get from the device to the
linux block layer PR value that will be returned to callers. To prepare
for that, this patch adds a nvme_pr_type enum and renames the nvme_pr_type
function.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---

Note for Chaitanya, Keith and Bart. For these patches where we convert
between block and nvme pr values, it seemed like Chaitanya and Keith
didn't have a strong preference. Bart had the suggestion to keep the
switch and drop the default so the compiler can warn us if new types
are added. This seemed like a nice benefit so I went that way.


 drivers/nvme/host/pr.c | 24 ++++++++++++------------
 include/linux/nvme.h   |  9 +++++++++
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index ac6b9008e7e1..66086369dbce 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -6,24 +6,24 @@
 
 #include "nvme.h"
 
-static char nvme_pr_type(enum pr_type type)
+static enum nvme_pr_type nvme_pr_type_from_blk(enum pr_type type)
 {
 	switch (type) {
 	case PR_WRITE_EXCLUSIVE:
-		return 1;
+		return NVME_PR_WRITE_EXCLUSIVE;
 	case PR_EXCLUSIVE_ACCESS:
-		return 2;
+		return NVME_PR_EXCLUSIVE_ACCESS;
 	case PR_WRITE_EXCLUSIVE_REG_ONLY:
-		return 3;
+		return NVME_PR_WRITE_EXCLUSIVE_REG_ONLY;
 	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
-		return 4;
+		return NVME_PR_EXCLUSIVE_ACCESS_REG_ONLY;
 	case PR_WRITE_EXCLUSIVE_ALL_REGS:
-		return 5;
+		return NVME_PR_WRITE_EXCLUSIVE_ALL_REGS;
 	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
-		return 6;
-	default:
-		return 0;
+		return NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS;
 	}
+
+	return 0;
 }
 
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
@@ -124,7 +124,7 @@ static int nvme_pr_reserve(struct block_device *bdev, u64 key,
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
 
-	cdw10 = nvme_pr_type(type) << 8;
+	cdw10 = nvme_pr_type_from_blk(type) << 8;
 	cdw10 |= ((flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0);
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire);
 }
@@ -132,7 +132,7 @@ static int nvme_pr_reserve(struct block_device *bdev, u64 key,
 static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
 		enum pr_type type, bool abort)
 {
-	u32 cdw10 = nvme_pr_type(type) << 8 | (abort ? 2 : 1);
+	u32 cdw10 = nvme_pr_type_from_blk(type) << 8 | (abort ? 2 : 1);
 
 	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
 }
@@ -146,7 +146,7 @@ static int nvme_pr_clear(struct block_device *bdev, u64 key)
 
 static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 0 : 1 << 3);
+	u32 cdw10 = nvme_pr_type_from_blk(type) << 8 | (key ? 0 : 1 << 3);
 
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 50fc596ec888..bae08167735a 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -759,6 +759,15 @@ enum {
 	NVME_LBART_ATTRIB_HIDE	= 1 << 1,
 };
 
+enum nvme_pr_type {
+	NVME_PR_WRITE_EXCLUSIVE			= 1,
+	NVME_PR_EXCLUSIVE_ACCESS		= 2,
+	NVME_PR_WRITE_EXCLUSIVE_REG_ONLY	= 3,
+	NVME_PR_EXCLUSIVE_ACCESS_REG_ONLY	= 4,
+	NVME_PR_WRITE_EXCLUSIVE_ALL_REGS	= 5,
+	NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS	= 6,
+};
+
 enum nvme_eds {
 	NVME_EXTENDED_DATA_STRUCT	= 0x1,
 };
-- 
2.25.1

