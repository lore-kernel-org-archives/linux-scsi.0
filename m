Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E2BC43219
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 586F564E50
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbhBDLhx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:37:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38534 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbhBDLgN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 06:36:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BZ7wM122140;
        Thu, 4 Feb 2021 11:35:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=07opFoXXDs6iuIB9hzD7urrI9NClkS/s5ptSJd3u6lA=;
 b=T8ZLwjii/kvk/phMiV6Q/X5nRgmLQH/Q7h9yYGXjMnHAL4u3n4WBO0Bg7mAHtRBO1QWM
 wvUGZzWzkkZWBZ4SNtR34ndgB+Fiy/TAsT0bxcjsSASTIxyTbyj4zjYxPbiMcEDYx6sP
 AJjG7Wp8bLLN5vTSaEHkHOjflXz/6cJ+EtW2dIGVD6/RpoAIMYtg4VBqyRG2fUfHnUJ2
 kUFRBhge6T8JU1Yh/497lkbNPS2xqXFXg7YEULtHN5xUaGfnKJjlncFzCc1oJJvgxw95
 iw9Z5E70zmKdCSps1ibgHdf4wiV5cZCNmLcZZ22aQPpKHvWG41BPkdY0CVv7/+DYhamf hQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36cydm4r6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BYfbO134905;
        Thu, 4 Feb 2021 11:35:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 36dhd187nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQAVyqoW1Pp7ewEP0tnwSGVpb702glNDv86bDQp0annZsyPPBkTKtjPtbfbfnyBClnUd5E1tuODwUx8qb5oualggMFyliYkri38aLzOvZtBYuCXno21dp1P2gG1UJOaWH1/N0Qz0I10TsJmWEPW7Sp6ClAbLqPS3UdVF1dzoTncKE3Lo1AkbUgo7cTxiGfHCCxlFsw3YwmTjqkZK8md6gA5IK9pRJeVkrKw6BCNviX90lz/RnRLof6uQ06pF1ubq8mb0OL4yiFnKo4wwx8dEYFgitIsuDLOZVoe0R+sQrd/+x7LOvswBr0+DVuH48CJiZjoKRGnZEaHQrIHO+IkJvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07opFoXXDs6iuIB9hzD7urrI9NClkS/s5ptSJd3u6lA=;
 b=GI1w0NxEWuhFPKaH8KsO15ZDnEMmFFHQDxQUfIVLDNOxjFsFI29lHJVdiSlylGO8A5ZUCkhNGRqiD0Ijh16oWl5FBZU81qUmTNJVH2PKh0DkU65W1F2C/+cv/F8TecZf2c2Q1tD6ZQz0Ya9GRa+cMYmrtnJcro3LToV50XIt5T+bq2TkSNd/FUqyh93anJLTdHTR8qfpAh6Bs9MrY8p90pwI++llmEf+cmTIa0o+vkhMalGEcYQQ0eLjT0kumOVA2HY1t9JefyIJNNdWWcftOR7o028x7qAQVWESvt3RTCZgW/vrVZw08ZEt5brDeOP/T1DdPEeggYcXB0uACnIHzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07opFoXXDs6iuIB9hzD7urrI9NClkS/s5ptSJd3u6lA=;
 b=OGY5/TQoJ/Q8HHCE7zF+Dha5mu//sAA9DCzshdYg3RcArMSBYo3CAaX7rA6qACDGZ/kl0/0R3fz5nztm5NlcLRZgLvnupO7eda5pbznUzK/dD+EKi0a0IRgcV6iBv+T2MTEj0+a6ARWqGCP58U9s66r1pahf3RydcGmT1GrchSQ=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 11:35:23 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 11:35:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Subject: [PATCH 00/11] target: fix cmd plugging and completion
Date:   Thu,  4 Feb 2021 05:35:02 -0600
Message-Id: <20210204113513.93204-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:610:cc::29) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:610:cc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 11:35:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38def812-782f-42d5-502e-08d8c900f54c
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4480033D60E4C872924B7AC6F1B39@SJ0PR10MB4480.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m+ys4wobSp+VaCYq10tHhi7orpL6kUqFv+4gBPlCJKx0UxvDpB8LF0Xt5b5TgqPV+ZlL93DAEVPF3YRQKKTOW9Cwq/2eEpoBe2aKPdMeThAnfkd/LKEa4M2sRCkTbREhZbJHGE1PM6cw/+caOD08vTxm4vL9TsKMjnw8weeczhOrX9zwhnBVDK1vU8Q9b6OEC3gSTzKGK0y+y8pjlVM4XZ0I/xP4+iE51HTffYqT9CobFruMgUJsNyGfG3vm1PzYVEM6YvI9JIyDHlFKvGIV9zS1/xZFkCr1EmvsCfmqP5bIDRoahR/z6bV7yRxn3Oy4Crd/nUwhCjuENcjrADe3KI0JRG8bNjbGHnGye6BQ7wIfDgE1U4elZzoGntD6PTpEDcq2h1IOvBmnyn9t31lNzzRRsopg5P912Q0RsC9+j3Ghj7ewjdEsvq2Nl1wiSGn3QnAQxM6euqi29M43Wa4IhAAs1Nw7iekcWNjRhJaCjJhvrPysnO4WHjCdh8Zmg6oEdiJOq7+D7UjXD4Ga8OixBGTV4JM327om1VOGCVzLNqfrvCnnAuxeJiPYPM5reL7L5euOvqXhumH0iIhjr2vKIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(52116002)(66946007)(66476007)(66556008)(26005)(6512007)(478600001)(16526019)(6486002)(8676002)(8936002)(186003)(2906002)(6506007)(5660300002)(6666004)(2616005)(1076003)(956004)(316002)(36756003)(86362001)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IcsXworMsApXcppXxrJSL2LpAI1UMXOggHJnPY1uvgWfdQnjW2vsFfXzK98e?=
 =?us-ascii?Q?8QDgTJVP01ZGNf9HNs81wgSTpXjWP4TxGq9S1sQF/UsJ7D9+uqw81SfzkRXE?=
 =?us-ascii?Q?aqKFAWKmoWov4rLFo/mPnynXZjg8JZIQh77QTXI+VCboexxaDsKfMef6SnSd?=
 =?us-ascii?Q?4TVQms5KyGVIkzPlUYiT/KFRZ6nQG3iWjwwK/L2KfqRraX7/Vlnf5liE67h/?=
 =?us-ascii?Q?jBVK4NGmoa76e7+HfuUC6igPZtzkSci7Ab+9jsgUJ3cK3w1KgppAA3qIvvyj?=
 =?us-ascii?Q?vbRwG2GNs2E7f4o0IpWYo88B9bpBkvM5GOo0Mtz6rbsLZlVMH9rvWsJQadWV?=
 =?us-ascii?Q?zvizh/jwuP2phvLWLILBabDNTPkGXeVaI/JlGHXMCqsk5HN/rh/0XV93Thfh?=
 =?us-ascii?Q?mWyiTUeRgdbwOZG+36BLwYcT8eBp4a9GwnGmRrsiWRyUlE+06jrSDUKKb4xA?=
 =?us-ascii?Q?7B+KUtV13n6yaR0SEBjusPHp6q0AVXx638Sp8psTyx11CzKlEN/xZelYcXFV?=
 =?us-ascii?Q?bURC5fHLfZSs/hOQ9aYlphgNvqES1MClxJm50R+ckpFl4ciGdPJ/knTCc+xM?=
 =?us-ascii?Q?gAI610evzJvzprK+B7yte2FbpgejLyopvT9Nlj1uY7EFpql78mfq8rW8eD4q?=
 =?us-ascii?Q?6om7mEdMSY4+SIBxkmy25XfvPqgjDEM/uTnUbCw0djsNE842ozQvzN1JcbDk?=
 =?us-ascii?Q?aBh5YGc7xpLmXkjPOOc6gCsymZuisTnjzIFfs3sRghVz+nv++laqmxgOYCWW?=
 =?us-ascii?Q?DCToB+M8krzpY1SXs+vDxFwXcZ8FIdTsM+8E6KOK4PeytkeneckO++9LG7YU?=
 =?us-ascii?Q?x1tXMCfEItpvA/NNFk0AYwRK/Uop+Tzx6fl6YfTZNP428f1KWl7HV4qedEO5?=
 =?us-ascii?Q?J1iyAu3gL7VI4Usb8ickOyUyXGLScMN3yRhcc0xUctmmzqDVh9ljcfheG3vi?=
 =?us-ascii?Q?fteMvxWpeCRC98cybeuqaQK+JvfnzBM8t1uODlpDG0fCpWUFRpVRZFJITN+L?=
 =?us-ascii?Q?sTVqe/dpDNwEHIOHSPAOAH8+6/w/uuGnPxw6WMxaRYRM7e5uAbVagnG08RDk?=
 =?us-ascii?Q?qyJU+Rv6qPXavj40GSxFqL+g/nwYGj5E1CK6qy4ergGbzonbkh7fVAKLZ+Vi?=
 =?us-ascii?Q?QwYua1y51KtZ4/YjCTiIyYHSLEnslkcU4BGCMPA6QixnWDJ39JKkQ+4B7T7X?=
 =?us-ascii?Q?X3VzuDjrmTAmegc/NYcwErCPjyBEFtc7Y/l57Sb2i9A2T+vX1xn9UCWrOXO6?=
 =?us-ascii?Q?P8IQoYPVhX/L1Qp8tF3oz2+LFcNWh0UkeWcQVVvbmilhb2Rp+I9slxceNaHf?=
 =?us-ascii?Q?amnZxM9pgt2oNJQd3cl672lZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38def812-782f-42d5-502e-08d8c900f54c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:35:23.1304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oxVI+Q+qT848qQmZjGvTlx/kBW+jzHlUcgs1xjGkTZvB2Y/dQ9Dne9+EN26TtMiyQe9HJIWbB2eodXQn9IrigvDaoCZf9CyJMNlH3yRgT/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4480
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040073
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1011
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040073
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Martin's 5.12 branches fix two
issues:

1. target_core_iblock plugs and unplugs the queue for every
command. To handle this issue and handle an issue that
vhost-scsi and loop were avoiding by adding their own workqueue,
I added a new submission workqueue to LIO. Drivers can pass cmds
to it, and we can then submit batches of cmds.

2. vhost-scsi and loop on the submission side were doing a work
per cmd and on the lio completion side it was doing a work per
cmd. The cap on running works is 512 (max_active) and so we can
end up end up using a lot of threads when submissions start blocking
because they hit the block tag limit or the completion side blocks
trying to send the cmd. In this patchset I just use a cmd list
per session to avoid abusing the workueue layer.

The combined patchset fixes a major perf issue we've been hitting
where IOPs is stuck at 230K when running:

    fio --filename=/dev/sda  --direct=1 --rw=randrw --bs=4k
    --ioengine=libaio --iodepth=128  --numjobs=8 --time_based
    --group_reporting --runtime=60

The patches in this set get me to 350K when using devices that
have native IOPs of around 400-500K.

Note that 5.12 has some interrupt changes that my patches
collide with. Martin's 5.12 branches had the changes so I
based my patches on that.



