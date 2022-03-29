Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2DCC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240416AbiC2SHI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240348AbiC2SHG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:07:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298D9AC93B
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:05:21 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsKkh022181;
        Tue, 29 Mar 2022 18:03:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=EFuaw9rix6gQKCBHGkcYWuxUQZFq8bToNJAYuM2RxI4=;
 b=xLUN2dB6uNR+US8IdFmQ4JmX2dPqOQuL+JwCISb0PtHF6y1Tl8n6PTNBLS4pBsnCrUJb
 k5VMHk5BvZaZkBUY5r+/2l4G3pckB9DoKKnITkpQrHqiVAnEoQPSsIvIzOEFshJf3NYL
 SuYd2fuSeKaFLS7sizoSSUeCBUv+LM8oZ13XAFg5EJ4lI5pGsEHcYSJRQOQjkT5dJ1uN
 xXgvW4dBl11LYHxYRMKAbq+shsK77Ng44XMZraXwRMW9oeI0OdNzfMPeCBdbRcQX6+sA
 +bKEDw9hSs6APOeAldaADuAGopXrEEUBwoR7xYDyoADRoEZ4gyJ+boJOfrxfu/zVfvkv Sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1tqb78tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THvFJD048570;
        Tue, 29 Mar 2022 18:03:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3f1v9fhge0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lj0N7uo0F7AlB56j2EEA9HfBcxCcEbWOvujSvBceLputV6CR41H2RWMNLDYbV2d7rGvunbcFiJxPHmntii/J6nydh5G4fcRbuZlqCMFDJxDaSbObgPHFr29qVK5wtE77tUJZ8SIHHTMLDD8AuT2bKQ9uG1tEV2+e/jeMdYlbJgIrp3KHDbjmnIb5qyg3ITVSYa9nddk35Ee0F9KuN+sY/CQNJ23ik+C+nYGl2Hpbusi1KmaWx1NugWJp0db9wGydB4augFMXSnZrlnfcl7JE3DLYtSGOc/2vxnr05QBsJ8yqUhJr5+vRqjgPw1gqN6As2iwpnWE7BNqtMPbZ/G5w9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFuaw9rix6gQKCBHGkcYWuxUQZFq8bToNJAYuM2RxI4=;
 b=nbi5NvCX4fVwJYx33cDyhCREbMM0q/0gRJdrg1zHPPUE9k/OUb7hHRvtzg9AIWFE/y0panOsDNZd+SnT1kEiB992ibaFdqdIGwQgyABkXsXFZy9/6L4TCzI4An8YEDOO1ad9CARNwg5JOc1l4/6hYWSI1MU/CXZh7fBI4K6IMfR9NUyIx6764pH0m3svGZYVOZHsFrsYLvhlW3pTXAmIV1U5Zq+zc3hHBQ12vUb/M93hGldo7e6BtvrP52jB3dmIVhZvjZqbQqct8jbIFPv/4W76tUeK69a+f3NadQdTtfGfKEsmY4C59PCbuJ9GYpVei0zqV4SWc5i1CAMriDuJ+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFuaw9rix6gQKCBHGkcYWuxUQZFq8bToNJAYuM2RxI4=;
 b=ooCAVYU6nPDTFZvx/c8461wbgbQVove2xmyIDQSV6foUEhxxar7c7fuyVbiW/K72zFUNhCp80u8dh4SsXdCWHx51zu17yD6X3Kj2wYHLjfclhmNyMxvepn/UDI3M5k8aL78d7neZRqn2aX1XkZAFSjRDN8YLvHtWhyUFOI440Mk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: [PATCH V3 00/15] misc iscsi patches
Date:   Tue, 29 Mar 2022 13:03:11 -0500
Message-Id: <20220329180326.5586-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12a35c34-a155-4e57-445b-08da11ae7123
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB358460AEC22D5AC9600D7759F11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h2A3HfAc8DpBmfxjty/mwOxWHNLN/ihWwieCtiO7p5HfeLHtfglhlylcWcpK4rRdAqxRJ1tG6P4jHmfaTjfYQZANYRCjWuPH02ckOs4TXtrzypHyCfqhiuS9DMOye9gf59gZNpknrTkDQtMGimOvqGhFBXwuhE8RxsQTGbNjPM0u1Cvu38Gw/X6stz4GAhCuPSe7k58yppzldp2QynA9Fc+RqhOgcqFVnwgS7gVdQ2RaktEfOePoE7V6qUv1KpA8JmwzkObA3nmZNSgpLYKKJMVAUV0n6rYdMElbPdIxGF4YWCEfr21uhDpFfeMPx/+letHin/nqFIiFjSp7A/oBYs3VweqaamAHy2fl93e9sfoQTZkERW/Qmqu6sdlGNqJMBujMhTri2PjU3u/ilxBHxDC/k9Sk18AfG+OCpuf5ALRKaaBaHDuIdFnIfln0UoFsMKeVrDPgyc7I063mdflBVYzv90OuKbX9LoFArGo8PHnniwgbZYhAtHDv5/DY/HdLm+mZ6P0aS5EEF7UEwG4RTrZC1/y5UweR5cDk27bQXrYlhwvkiG+0QqUXA6cVYMjQ0W5LrUr5nv72djuLE447p0FNpyQxmQGi5kQJYYxc+UJ9g4x1otbihktfC2eg8nfK22v6KrZX9Cft93TCekcZOdiOGQYsYuaCH7ud0SKN47i7sl+ROrZ7BV3RY/DxDEpp/l+aXrZuw8CubTGPwvEDgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(316002)(8936002)(8676002)(6512007)(66556008)(4744005)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(52116002)(6666004)(86362001)(83380400001)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aClUMddUQDI3Sjkr9VwJo6vBu38GwKQQdPP+wIHG76p/JmgtSTWAVFNAQ3DA?=
 =?us-ascii?Q?iX4Hnecx3dl5wuXe6D2QhLjsUEfqfpJVP2YsbJZpPi3EHd9vfM/QShC2O86Y?=
 =?us-ascii?Q?q8/JUSj4cpZWBRljSay5RHgM5PHPC1gq90OdWLUmX3GnMN8UPVrbOaxCdznI?=
 =?us-ascii?Q?i4MvqInldbWfDU+Gq3Kd4rvXdwbGPHLYf8oaxrpnswdBJwlvGQbZFGCKv32s?=
 =?us-ascii?Q?WooGVy2OqOOOH/j3+mzOH06B0NMPE6FRuI8xRq8yaD6IzUuo5HrYvzw2etmz?=
 =?us-ascii?Q?TD1RmfChUUcGK9GpWkp4WI8TFKn5q+y8EOYMPE2Dy7p1TxwSbaRHbj+QVFM8?=
 =?us-ascii?Q?5434+FegZ/NTyWzK0zFzXgUKkP9fk8VjAsHjP0Z9ZTV1JYFHKwGkdfozn2tB?=
 =?us-ascii?Q?x/TOL5jighLz4PAEHHkmh2z2yD3/jJacM9qtl8elu5j1743BPOblVOJ8CVAV?=
 =?us-ascii?Q?19fMmk5Xq34jzT7X9bXQ38/rs1blr7OC8gzsRDn9vtG0uq5YgbnZiunc0wLn?=
 =?us-ascii?Q?y23JIKxFKgvbL8WF9jYlYJyFQipQ71sRqzKMxU3PALFvMdPFxb4xXrG0VReT?=
 =?us-ascii?Q?VbECyrfHUULaZlLXMlbA4bPI6kXIfWLHAs8eraQL84kbvEAnY/v9fa5lJm0g?=
 =?us-ascii?Q?h1rPb/yCQ3/BWdlnkaElU7oXwzoQUDv1nTzKWUTLFpV+MkeAfrpy90FrAtUL?=
 =?us-ascii?Q?t/TYDbNGda/a60aEdCJcjxilIJG+SsvPZLU9DfRmJFVBC9qf8N+Vl25Int1k?=
 =?us-ascii?Q?/nwKURGtLzefEfDxIrDunji2UgLCxMyw42Z0rzcwqtL4ZbJTEM3nvQ+T2KgT?=
 =?us-ascii?Q?z4GGc2exoJ0gtMt4S8OogGtLloyAwDCHg1aWvANW6XUFtC7z5+84k/uaVSJ+?=
 =?us-ascii?Q?J9T6KdUqFRKTIOkKrFd8o1wMKDysgn+sF+U7bNWZe/0sZ5PJPeOGc2ulYGez?=
 =?us-ascii?Q?P9fqYsDYZ44UZGGo+2KWrOxB8j1Hg/AnySJajnbOGA92u7KPSn4GhMwJt1tj?=
 =?us-ascii?Q?3l2a4YON666ibc0wgII2UN6Apj6/Xdzz/Ea+UmzkouKDsPzZgTAfnSCIFXQa?=
 =?us-ascii?Q?76+HVK/TqI+0roVQNuutSWsQdDVFmE3v/ttp9KAW+4Ctb7B1S6Mu8Ya2MyQU?=
 =?us-ascii?Q?EgIR9GyeZc5xDX0CeIZMouoEcd5wC+LReI6avOeJFFyMYxOtgj9WD/ojDq/h?=
 =?us-ascii?Q?364Q/rNGgASSsdhYGGSlezzk42yDak8veJ6ah2BKKw9lO5H/YqQLwrm/hq4N?=
 =?us-ascii?Q?BeQWuDkQQqeOoKqyBvG8MFgMkpZxgErp3yrz2sJv+TcnuMcH+WT7bR52WgTY?=
 =?us-ascii?Q?akOyQoCrcLYCDsaXnADMsnoa9hH3OxXrn3AtHgTShKPRa7X4WZrUaZOYEaBD?=
 =?us-ascii?Q?kCUCLb2J4Y4k9nKzaWBIy2SXzySowNe4rGVtaGQMzDCBAtCW9nG8Itm3cWGu?=
 =?us-ascii?Q?jc9n30N+hW6kJnSJ7bz2NQUzZpcdPCyQwYKGYu6TVHV/6x1jNjAEDioc0p1Q?=
 =?us-ascii?Q?HFBKZGqJw15wLSTUvuc9tczjaurFYefLIGGLP0agSHl7fHgdnqcUt/EyZ9rg?=
 =?us-ascii?Q?ZFImJ42c0/WOeS9pwjJ6ujbC2ZucKvE2wx0JF/I1bDE1s9H5o7KafyDn0Xet?=
 =?us-ascii?Q?2Xvvi9lmAF91GPZ2tRMxChzsxV5ByamdKPz8XJPVbm5c85s1yP9wtgiQwarN?=
 =?us-ascii?Q?n0AIu3PX6VRZHRXia7Jpb+JgmxDqCr1xu9Aa2fHOqcw9FQiPNeLnRVt0t4N9?=
 =?us-ascii?Q?yWVDkNiGCY3F5Yfsh2WJT6UBZWWbvEI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a35c34-a155-4e57-445b-08da11ae7123
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:34.8027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6XiMh3f3L8dEs3uuDUZhVe8lTryloPz13t6THVz0hXpWorNgw5UySrSXQ1QbaJmQAMenzN+xBa2A/0TsPE8B3HVLWLu9wml1lwylj7MBGbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-GUID: YWiwnsG4krfEkLRrhDz73Pl6tHuHuZH8
X-Proofpoint-ORIG-GUID: YWiwnsG4krfEkLRrhDz73Pl6tHuHuZH8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 5.18 branches which
contain Bart's SCp.ptr changes and some other iscsi patches. They
also apply over Linus's tree but that kernel does not boot for me
due to unrelated issues.

They are mix of minor fixes and perf improvements and cleanups.

V3:
- Added fixes for iscsid restart for issues found by Marvell.
- There was a mixup in v2 where an older version of a patch was sent
that used msleep instead of udelay (v1 has udelay but v2 has msleep).
This posting has the correct udelay version so checkpatch is happy
and msleep was too long

V2:
- Fix up git commit messages.
- Rename modparam that controls if we create sessions using the
network softirq or iscsi_q.
- Drop zero copy patch but leave the part that set the sendpage
version of MSG_MORE. It turns out we were never using zero copy for the
header and it was the MSG_SENDPAGE_NOTLAST that was helping.


