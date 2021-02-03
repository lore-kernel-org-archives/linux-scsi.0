Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03EBC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 01:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B59964F4C
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 01:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhBCBfJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 20:35:09 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:50426 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhBCBfG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 20:35:06 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131Y9u1193235;
        Wed, 3 Feb 2021 01:34:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ZZgwqA/8loUF0tGhzCebU4SUjmKcud940dblHN/xIko=;
 b=YNEGQcaLlFz0ECByymYY5RU45sdI+6/nwTadBwpp63IUVxSj37BD9AObokm90TJNfR7T
 McbgsE9DFs8RLN7G4lvJAA2MjU1dKontkGqexbs1FSFKVTX9YyYOs0SOVoLAftz1zggg
 t8JEGYiexCPe+Tkmtz3DfjA3WXMeEpU5e/DMORtoyV6Hd24+WcKGu1JqCs0zw4VkOBW9
 c58P/MbpxFzMWv7vAbnaF95hFaqLTtxIALQdbXVQUGS+lawP6o0B+EmqQa9wuFSv0Is0
 PSYv8Lk185I61YA7e6PAc6HxDa5PlniDWt5jhSkHtOB5DpTojmyIa/8WYuclsst2BjIg KA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36cvyawtyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131OxjI139717;
        Wed, 3 Feb 2021 01:34:09 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2058.outbound.protection.outlook.com [104.47.44.58])
        by aserp3020.oracle.com with ESMTP id 36dhc05qfv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjdeMlMDPJtF0p6LL5sEhD12cNnppwi4D57B7mOzRsg5PQbJNaJ/j/OlwkFm0Oj2jfukEU88ZAZPz0SYTI122LElq7hTQ+6qe9/GeT1sDdobcH09ry9SmxdgFH6Ei2frnyi3yEjaX14ExMEMP0g0sp46QIOb6h9SlVXjrDTJmUeTA/U58ccfAJ/2lGmKW10w232/hejYjhL5xjx44nqc0hvebfrExmjQvhV9WOghck7y7LdTDkFTvVO3H++yD2YL+L+jnY2XPt5zOnBXdGiFWq+PWvsvoa5DbciiLxpt3K/J7XdgYrFwvH1KTgXcrrAB/i5Y1B69uZHXq6pPTR0aTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZZgwqA/8loUF0tGhzCebU4SUjmKcud940dblHN/xIko=;
 b=IJe7QQl8Qn7Sc/BmUpFI1BpVxmYKZy5myxBM3BE/yAgXET6pAtqTenWQ6EYAw1D0DF58VJKiUVfMfBSV3DNB8SHGVAyA9SKpYxQkkGEfXQ9qW3JIYK9W7KvUS8t60fR85vYoINEaElRFvY6BZZvLjLslVecaZW0oy+paHVSZAZ2vjepPUt8Br1UsmtrFc7ewT6EONKgGAlZxOkX5qr46Y951L8yaoKNdFy1g4omkBDMbpoen33nSVGxxeyhwXUqlA8qQkwbkvZCZ9gt/Zhz/ycXZl0AlIDHOo0jwWg05GjEExi6R2dDV0tX54MjPKi2qWnrAYYvBOjvHQkJfGHQ0zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZZgwqA/8loUF0tGhzCebU4SUjmKcud940dblHN/xIko=;
 b=aZwwY3/iU1unZjihZxsw5w4kVf7idDVRR8luU0w27USXRWJsCB1JeLIdrBsvAR2otXmdlvw40Ub3UzE3eRbU1rRxlBcNh3cVLrO1d10cYgbYMsXcT4XCVCTOJqdfd/xYfZKYvyusX8lbelFAbfhtA8+aaCW3AN8CJf544Vm4x00=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN0PR10MB5320.namprd10.prod.outlook.com (2603:10b6:408:12a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 3 Feb
 2021 01:34:05 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 01:34:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 0/9 V5] iscsi fixes and cleanups
Date:   Tue,  2 Feb 2021 19:33:47 -0600
Message-Id: <20210203013356.11177-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:610:4e::22) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR02CA0012.namprd02.prod.outlook.com (2603:10b6:610:4e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 01:34:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47ea7678-3f5b-4ea2-95a9-08d8c7e3cb12
X-MS-TrafficTypeDiagnostic: BN0PR10MB5320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB53209EEDECFF899ABA9F9F00F1B49@BN0PR10MB5320.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3DCFziL16/K8ur9MSJvG89sBrau42Z3kJVCe90u589U65x+uuKgaONHudNsQCaqT5SqOX7Kw8N4KqPIS7m8uto0GyvURyD4g65DzdFxX96La9yYK5Q7SRrUN8snwxtMe+TmOVYKBaMzPPLWZRWXsBPEpHuuptL7r7BIZHD/BbJLk+x48elW7lKIKEtPZka5lB7XZBiyeE2pGFYnglmu3oNw/sx5WrZK9ohC1o97dRPfst6cq5jfLCoXFoNCgK1JEbsr0/TPX1FXxP0D5mkXRqhJmjZnNdfwXAmORPdxJkcOLCXtoL1rJIwMxQrqnFtkah0fSPaMy1Y9hoy5gJjVbF8KypD2W5nWCckSrj0AIGhGf7Clx8JXUZGcivoxiw8PHoMMIrwHpjwvJv+GOXeRFIt64kccFy6r9mcJ7Wb5uJBm5Ol//FzfiWmO+WJ8IIUzZWxJ65VtYNzotNytCrA3uXMWV9jZ1p6otwgnNuvIi8J10XNDa4ZqCpXXq2iLgwn/yT29+NxPMR5puzlGGEzfS63pZPhteW2ftzZlFvreubR/HF/gcw1el0YEkR6PsjW3okM2JuIDVDiNAbYVmCR5SfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(376002)(346002)(52116002)(316002)(6666004)(69590400007)(956004)(2616005)(2906002)(478600001)(86362001)(4326008)(66476007)(66556008)(66946007)(36756003)(6486002)(6506007)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mmy52oblipXvo53csyS46kMPLgqFOgMIuFj1stYTsqmz4RY8rU8zaXk5p2pB?=
 =?us-ascii?Q?W8iaQ8REvh9fCi4jHSvP5tZtxKJahpImlzqeumAAK1wUAW3nTFjduOsgyFAz?=
 =?us-ascii?Q?XOiEiPu3a2CjMMjhuI9M05KonqNoGV50NGqyxZLYtlIsBeJHHcfZvotYB8eY?=
 =?us-ascii?Q?kcjpSuY3WcdkV/8Oyn75uwFczJH+5JxI6JXdjUOM0pj20hFlUsDJK0XO+nLZ?=
 =?us-ascii?Q?8/A9EFKaFe659oLPTYWKwP5n7FRTAs+ukkemCjAL+/rKZsrsdJotnYPIYaDE?=
 =?us-ascii?Q?0jjeNmCIEthiHIDx50nPsd5SPHHIjNidrju/1lmfAZyXBrUyAc2tW4aGpYp4?=
 =?us-ascii?Q?Uxo/7uTIgsvz2tWz92Ng4FrCxCal4b2jT9lxkDPJKEFTT1IE5VTDXlNPHX7z?=
 =?us-ascii?Q?4sAZVhj9BUnH3ykaCznMclXz3Pn0dTxQnkAbS1p82oqc3pYKhQaV7ZLO+vFq?=
 =?us-ascii?Q?Bmqr1VvLwwwECLnvzSDEjJ3eWlT2HuR6dRa24IjmyYgkxusBm6rmWj0mbuyH?=
 =?us-ascii?Q?gbLyxGdn/9/4qEhYl091px+wgvwhXR86gRxKUtN53iT86Ga+rV+6Kb2zyQsW?=
 =?us-ascii?Q?yUJgbNGmyFMqE3lFVdo5dVcA3lKz2F4jkNMUhJkwUaqxyUWNzziRjwZrzBdo?=
 =?us-ascii?Q?yo5buVR69vgWPGDUrGIr+dIso9s6xMXCQtYF9aRhe+0ZOYvAZYtuvbEY5vJ0?=
 =?us-ascii?Q?lrfZZPBrUMiwhVmHR0UQixeneZd08Ygr8cavJuEqNAt0BODH04yoMW7hSled?=
 =?us-ascii?Q?2GIEOg9WgjVUEmvAhC3k1Z20ebRwnDngZHPZi/98RrsNL6NQfT01Z55cV6vd?=
 =?us-ascii?Q?wdp+MhleeTuk26C0LeEk++bergU0KFPYuBAV9wcK/aCsGWEAac12uqGKKtgU?=
 =?us-ascii?Q?Mv5FvBgEeQgzMhQzuQKm/0BYtqorecTBQd0exPLi86gATIcCH3dPeSS6ZqMP?=
 =?us-ascii?Q?aijRPqAy5jtxz58y50bqeka70vEC7psrmiqtAHaMoiGf7irAEkuyVyZj4Try?=
 =?us-ascii?Q?DeoM6C0+6Pqd8ETzmdponhKjR7UVcrzyxLpen92LxzQ3h06rKLMjRSy574Pd?=
 =?us-ascii?Q?e+U0YDtl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ea7678-3f5b-4ea2-95a9-08d8c7e3cb12
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:34:05.3390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oigeJ2f/XaZJHx07KRp/cffem6soSG473/kAtJt1DvRPx+q6Y9eEu9v+JcqCYKGWTLSd93e3oB7BharwJFiSArhx1auW5Zvg5XHRLJNoiE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5320
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Martin's 5.12 branches contain
fixes for a cmd lifetime bug, software iscsi can_queue setup,
and a couple of the lock cleanup patches Lee has already ackd.

V5:
- Fix up KERN_ERR/INFO use when detecting invalid max_cmds values
from the user.
- Set iscsi_tcp can queue to max value it can support not including
mgmt cmds since the driver itself is not limited and that is a libiscsi
layer limit.
- Added the iscsi session class lock cleanup from the lock cleanup
patchset since it was reviewed already and this is now a patchset
for the next feature window.

V4:
- Add patch:
[PATCH 4/7] libiscsi: fix iscsi host workq destruction
to fix an issue where the user might only call iscsi_host_alloc then
iscsi_host_free and that was leaving the iscsi workqueue running.
- Add check for if a driver were to set can_queue to ISCSI_MGMT_CMDS_MAX
or less.
V3:
- Add some patches for issues found while testing.
	- session queue depth was stuck at 128
	- cmd window could not be detected when session was relogged in.
- Patch "libiscsi: drop taskqueuelock" had a bug where we did not
disable bhs and during xmit thread suspension leaked the current task.
V2:
- Take back_lock when looping over running cmds in iscsi_eh_cmd_timed_out
in case those complete while we are accessing them.



