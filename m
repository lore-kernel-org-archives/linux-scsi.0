Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F86C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1F9264E50
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhBIMjq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:39:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43464 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhBIMjn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 07:39:43 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CYjOD038285;
        Tue, 9 Feb 2021 12:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=c2Wby0SKu5sjWfKFJOtH/PiT2u0EGbraW7PzUAc+Zo4=;
 b=O62icuhnu643nwKoZjXpWLHuArnn50Ck7nssX86x6cnXjZwE0HM1za81FE18789vCX5r
 1U+iLTnjy+PFruIseXpLgp8IM7czhWhRqeD/wR5qHUyB9NNnqT+fOWS+LBX8ZP759Fla
 QKX+3VhQ0aw6/nDBHqvGrUwpYJQURFc6XhV9PQNIUFZj/rc3j4sBxxlXaYiIhhWAcvyA
 SYfd4nA19KdoJNbK4ScnV1X+h6n+zp7Nyu07sJO7oKkq6o4v0YUilFY17Kh4sdWtOpL/
 pHnOSsMLpgcGq9kHM1lCT8BuH0/BTNdZsYD09Hobp7QIIXgHBgTX4DdKYRV3Uaka2pdT 6Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36hjhqqag5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:38:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CaDIC178533;
        Tue, 9 Feb 2021 12:38:57 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3030.oracle.com with ESMTP id 36j4pnn07j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:38:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhaS6ZYsPZbv+kizynLUAtQgp0P49cOb4vjcjvHJICdT0//iGyF5Git2bJmplORs1cV99FVr94Pd84WepMZMFKxDosW3iA1pBSobDp3PPyijtHIDgwM6BJ+HA03bfp/H4g/D6AsDmnFCW6DIk3ItUC3HEnrjXuJnQqPKUlTrYUKpe0S63XYSrQhT4nrgY+7tyJ2kf5gXxYaOryeJ2tlLP4YbLQzVRKUH9fVz6BR+Og/3jiqAYBPLz3id/gbHllQFvSyL7JuhGbSdMPe+O1Lp8PIu6npZJIFgKP5i+Z7l6AmNj1JORQTNN1IXDC3ToBRiMqdhcRU1QpbpNOZtmzL6qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2Wby0SKu5sjWfKFJOtH/PiT2u0EGbraW7PzUAc+Zo4=;
 b=LWxbsNtT6orYXEVFWY4OxPi8biSj8/vg9UnFjcyqLakJYLr8d6MXdqjguAcY4x7QgM3YPyjBdFvg5BVKA8MK1Tq7vMtMscpavjILAWoiTY+iAo+w1Cu6Z9GeSt8RLpeBw652V1pwg8Q9bNHneAOA3U1SGFq58M1eOMmb0vuNZ5nTPQbp2DIQmigfiU4ezBdr9rq2ftCxB+7vEB5K9v6je71PdWW60z61N5wvEOod7xiDX8LhvuAEwl1NQ8XT8HtlhWhi+lIVj9YfJfmZ06KhIhqLXvhA4cV75qkAL/W5F2gez8vL82/v/u+cPa9RWURmDrl3JfSI3Hd5VVoeYWPvIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2Wby0SKu5sjWfKFJOtH/PiT2u0EGbraW7PzUAc+Zo4=;
 b=aIppOK5QAaIyZESqtYZ3wABGZDuwFBAcBYlOsqSQxbXRMf0f3lOow3fRnSSxyG/kWV6uJzsfMpouKxP6lyI+g3vVit35SL937kRkRXVtviZ1TrCzYqNiXROMdodKU51iT/jc0D6C8Zvws8Z7kkK1DUFpsxo4QjtffdGqjl8H2P8=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 12:38:54 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 12:38:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 00/12 V2] target: fix cmd plugging and completion
Date:   Tue,  9 Feb 2021 06:38:32 -0600
Message-Id: <20210209123845.4856-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:610:59::17) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:59::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 12:38:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52dc666f-58e0-4703-7408-08d8ccf7a94e
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB260089BEA5F7E1846B5DE7EAF18E9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FneyM39rBBbGhkFTUYL4RTwVoyi1QbMtv59rOZirv/p3lWlsO1rTG6JI1OEVHMRIz8HwsQ4wzH7sQmRHzYDUuWjjpbeoUpDGXdh1vJt94JY7AdJCgot4Cn/222W/71A6CWUJ0SDXOFEUttpXyPTCfN4fFmD9LVTeGXMrQtHErwRg/tbQGi++5XYbpXjhwApvrZ6UAhjsTw9JLpEuSXESHuTdI5a2e5BtCe0z2ygChDFOWdSXNz7OD16H34i8uj1ShzF46e2UHnk5wHBN3Fj9CIuYG75JrRigbiSIkQnVXsf8iowrOz7iufINR/156SCX2N1BWaMpNyEToGgCU8/U6hBTIDidVEKvrDn8tuu+1w7HHBxWnJhtGjrwX2BDYyduL5yY1y/Sy393Zz1GjXcDXIEsg8iw39Y7R5Yrr6HyxPH5wrXpwll8M4jiDRjOGbBpazd8KvlqP6kuiBHCrnjk1a9br1g8pwFd6qbr+Z8IfIf+ArrR5p+934YERUpY6D/9ysXfIIK9s7ejHV3GvIVMEv4T9IZoy9wtW8Wi+8nAxLCQ9uP8SwNpQvrUO4eK9di29IOgsRUpxapSOMSj3BKuQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(6486002)(16526019)(8676002)(86362001)(8936002)(5660300002)(6666004)(1076003)(478600001)(6512007)(6506007)(52116002)(26005)(69590400011)(186003)(66946007)(66476007)(36756003)(66556008)(316002)(83380400001)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qLibVrONfhSl6CJRITr9BYGRVz3n4B/20iz8QHV2bJbGUdJBBOMLJDF4KmXg?=
 =?us-ascii?Q?hCp1QkMyb8TY4JtHD0nNpiHsLpxMiNJaKWIKNy+eVo9yN35Koda1i3bbcgIE?=
 =?us-ascii?Q?GoaZexAiY4yV4u1xWLog5+MldURNkjF1BreXYp1SDxQatYdCHXLq8L8y2wqw?=
 =?us-ascii?Q?yZsfOcmcCSFR3oVyK0qtRSvKFvsKe+rY/BvMdM5OMiFsu4GJrlN9MZTlmL9q?=
 =?us-ascii?Q?UJ7T/ZJOedTzkG265HqA91MBuAFB+YLGBVlqO7+foKqCvBFSIUqqMhZwI7Mr?=
 =?us-ascii?Q?iN6nH8X30XDOClBPcJ0X2w/1NbEz2/CNtg9wNLLmqOI9fnNu/pBbiNLmdDix?=
 =?us-ascii?Q?+xybrO7bXc2veEmQ19iVFOt+NjMS9AXmcu8fNe+eyC4degwuwBCx1GEnSnbH?=
 =?us-ascii?Q?3Yveqx+ua3r7BEwlAgFqG1ilqUdGW78rApNva7Aa4kUUkMThtkSEetEYgj+0?=
 =?us-ascii?Q?nnjvpmwyBP5ObT0sehfbC5HdO4ny5QWn/haeMDUVbLCQs3o7jra5k29Zduo7?=
 =?us-ascii?Q?4xuwJkcP16CNDL6lJHEBYyCjXCHxuhE2yVBgG2rvXgh8JhX62YbsiKLW8dc4?=
 =?us-ascii?Q?IPiRR8WyeKkRG0jwtanEeMbohVWw+A6tHJty6tDgkaBgSqtYQ+Zf6msZjB1n?=
 =?us-ascii?Q?jFS4tbcnb4dUjsgLN5AvjXwt34JOvCIDGYr3zIC+9OXKM3lnm+KFYFilafP4?=
 =?us-ascii?Q?J9kcHWhu0Vdp7Q8b0aYSGUmw9HxLEjdwQBXyLOtkq7zClqG3Wk4AZBJ3LPJX?=
 =?us-ascii?Q?geqxmIFmzeH+sqFDWnpfTPD+wV/qh2DQWfowJHHvAQUbrywhuzQpGKzSeI56?=
 =?us-ascii?Q?lvI3OoosNAriVA2TLQcXHgC9ZoJnu5DgAzS0oE1PRphy3pi2w15C3f4Ao+ck?=
 =?us-ascii?Q?i9E93wWbMt77xHWEk5Pbgv4h/PSW9nrBRtiX5WaMtNU2UCAY4MsNPNsptoXm?=
 =?us-ascii?Q?yJkXhCa4qUM0IWV5nRw0r4i5CLhUzuqm+wHUAaHaGkaQnDYYuIxj7W/c+i3P?=
 =?us-ascii?Q?NeOhkPBaq4Gs4Ud/UJbt7lvX/h4/HXcnv5ycCRBFp6YxW8eFdwtJJc1UTZot?=
 =?us-ascii?Q?rLCwq0wY1/w7xicfOXYgTseIV7j8yFkb5I2BuYw3JR43y+/Sl11RhmDnvD+f?=
 =?us-ascii?Q?8oonJGKu33slozADTbjxwJVdERJd0dfavO+JG+R1nFH9nD6wxCCYu31sqwzc?=
 =?us-ascii?Q?4B6xalxOG5ZtJzFZxpDls48OWZm4R2FOlTXqluThEr5kzKhddiujgC5dEebj?=
 =?us-ascii?Q?UxY0t5WgtcNMqgwrP1PZTVdf6E+hSne8bp06zMR8wAvx9y19F5nxcJGunVd9?=
 =?us-ascii?Q?Q7QdQcGMGjKnjaQesHy6VxvY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52dc666f-58e0-4703-7408-08d8ccf7a94e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 12:38:54.3943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pNBOD3BmXS2w7Zp4Wet6Q9IHGzFX4NcNYo8W0SPRew4GZ9gVIA9UiH+1ReU3pf8jnClX5KomVYDFVmEfIpKv9ylU9/UZifr5bSteTvwGuQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090066
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

V2:
- Fix up container_of use coding style
- Handle offlist review comment from Laurence where with the
original code and my patches we can hit a bug where the cmd
times out, LIO starts up the TMR code, but it misses the cmd
because it's on the workqueue.
- Made the work per device work instead of session to handle
the previous issue and so if one dev hits some issue it sleeps on,
it won't block other devices.



