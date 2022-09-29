Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E15C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbiI2Cy3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbiI2Cy1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:54:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D19C67455
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:54:26 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1T88U018191;
        Thu, 29 Sep 2022 02:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=9GxzqZ06l6tle7MuDLMy2diLEEaR5zH0TE9KLqIWViw=;
 b=PAureYW7OZNvnnWDqW/CfyMnjW/J5rUoEYgQHZnx6ckDGzX5rywffW88Y11B0n7daPsz
 VGMbIe+Q4ttlBDU/Ry5cSQp3tiufd4f9nCY7TXmVPZZz+hqJnYKPTeMKXPVnodk21VQz
 eQJaX5mAekd1ks5atJTd/J0OXVqQF8Quux0ZBnSnrKCTOsRlScYk9oscj+hhPMacQ2YR
 b1fi9sbLTE42rp+mnDfkMjS06CueJuZVjT0TFSnC4zxBcEaaaVoSWVB7lQCvZJ3YwU02
 +tpPDy7lds1IDX3YivDW9rIo8ANrcMzN+1/4f58AhI5i3+rK6aX58+vSBgnbIME4PtkG rA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstet3ue7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1Ylev039394;
        Thu, 29 Sep 2022 02:54:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpq9jc24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEab1gu8gJopcohYto4/gYwZJOMaN1UugIIW3xKZxJdiokjGxB1S8OfZQLbHFUNgIpt2Er4FQOe3y3siAb9v3cZhJdpaqKU6D8MSWK1PTK6mL9Y8w4K2oC/cslTNTgdXIYzoHzM23GOWL3GrYd/gBdn5WhlQxE1v76UFtBAoGNoVcw5Sagc084tuXXljNxeWPp0W96KCHE2gYewV+PxpRZ9LMOiOMjEu3knt/qnqutudaN+1TyP7NkL0x9EYxe9VJAn73D4YwluJFyBrZMr+hIXGuN272B/6ysqJXt5pJW79jFR56JtWvhQNLtlyX4GI3io+UGTpvHxPb6xKGO7hkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9GxzqZ06l6tle7MuDLMy2diLEEaR5zH0TE9KLqIWViw=;
 b=QYZlnXSdc4gA3Ft4RooSbei3sb3r8m/ONjsVBsbtRIrBO55MlKRBpLLeqijYLfd/DzwQhVO0TJiN98g2W6zD909axfk5X4XXPGDCvW+OMyRJWYsyTOebWEjZOg9GZDGJZxk783OmxSH8FSI8CXU8rBWCqFoUNuRGsvMVTXgAu2uqFAcaeucClEeToJmVz5t92XZciaZKXvTJ/R5PzuDwKXF1YeCBRZwTzLL1vX5UDsZz2svkX0NDtqTQSmdY+DejD2AGtl7inU55qhGUXk/g177lscvjTtGJ275omUpp8nZ6fUcRk0Dxa9wGADL6FPzlOots4J1F0b5bwSYinSfWHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GxzqZ06l6tle7MuDLMy2diLEEaR5zH0TE9KLqIWViw=;
 b=z8mjSHgJnR7T6/Gqu2O/y20HxXNXDmumsjqENcvNFjp/M7PXBsV3GALRIyrA5O+pA481KR84r6oFXuk3eY9kIuoyfQ8VEV1jt/49hOcU2RxQsKWjmJWJ9TQ11fqzFVFESUPNqhPmRo+qzYEZsmf37LzRHZwdghGJeEbZoXJOOqQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v2 00/35] Allow scsi_execute users to control retries
Date:   Wed, 28 Sep 2022 21:53:32 -0500
Message-Id: <20220929025407.119804-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0002.namprd08.prod.outlook.com
 (2603:10b6:610:5a::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f18b685-e54f-4ebb-93a3-08daa1c5e355
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OzsdXgr8HfoZ6EZNUR69bxUWFirPIiFYMDMgad8jY+PY29gO42W3s15JCjDSQ9x0SKuGSX1uf4gHxTmVOfmyWP9yHZWCZ074BClQ924+RTY72hBmMwjw8Wc/v64DP+/bpyjvxT2PoHoMa2FQ8mLl2Cb5CqVP5tDACC3IIjFi/wMI7Wxjc5wtqhMW75cxAn9OCf9NhifIGlZ9HOPm+Ib4jdpsoXF5qnaHxchhLaTC2HH9MIcdEwW0p5ptXP0JIW6zpfMr1akTS5I35sAVmTldH3mrWv/6GLg1VVoSw5CdEAhlhhNbKEBctD8DsRiAj/94HS4fb2Kb8zKEofhEUXHw7AU+k+mN/PjjlDqRKik00jRQ+ikoGVfK5mxceQzU1R3lPz3Xpa6bDQdL0SrzvNoax0VjvrhsI9hnxvnJ1HaNjVBXKaxcD0ZeZ/bWoJlHR7iNtm7igXMptiLVvX/y2tF1Wpco8SxtamUijZjJttIdgLNS/GXe7Y6uUSs4SaosvbgkojDnx1MzU4xr0fB1Bz4XUyvYOJOhCSG+FlJw0B28dQCUvXNR/ToJxsbGbCKPFJ8p4lS6yUUNsxRjMQTlV8X4PVJWbJwAuS+NvFEMMNoWXyXj2KGRcl8/0so8PpU+ypHvMGZBUB6atMoXV3qazeLM2p7NSJmxobQot5OQ3c37IaqncDT5ncH+IyuVwiKWA5fHXN3k+cHNbrqO1pACdxOqUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(8936002)(5660300002)(66556008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FnRNOrBwvNk3EwP7cFDBFY7zuii6ZqZLW+aefuG27Vcmhnav4hnVpYUa7vOW?=
 =?us-ascii?Q?Y9S+k/tQaCHCCyQZH8GYLNE1tZVRzj2tR5xwI1X2BfMT8ST6fDW6yTYaI85s?=
 =?us-ascii?Q?VGS1lfSG3ElbjAw4ULlCzvQADjxdpipUvci9RYkMmT/GZFyQeiVJkWQ+w22w?=
 =?us-ascii?Q?aeulAEtj9DmHTc/LtQswLp3nCC9kv4QVbKGKyeL73lspzdgETYaiV51hIPN2?=
 =?us-ascii?Q?U2QLrwgFGIUUpco7UZkSC5WKuFBqqMUkmnsPWV64BYu9SvywfeozFB2UP53J?=
 =?us-ascii?Q?0EMkmUPeaN7/dJhqwwn2+jIuqwQxEoS59ZrlOCpfAK7R8kCCj3L1reRnF/u/?=
 =?us-ascii?Q?h/dP6oAtD0gb2+d5Qq7Tw7+91cdI+61Ln2NP/jdEi+iIj3Zwg6Qd14vVPP9I?=
 =?us-ascii?Q?xriZb2IzBJHHUpBbfVGOBKPyb5YjmkDvOLiIHr3WdKo2BjjwFi4iRuFiR81j?=
 =?us-ascii?Q?bzsmzJHohgYad5sSNgFmJTEOD3plplfQ+lhJnTtadqAfKzhLiyfaoRoYlyRx?=
 =?us-ascii?Q?jFSFoJkBDYzRA+I7tgGN4eFJ/G9DnC2U44HhZs+WHSehaw5gsPvxQT2pgoFb?=
 =?us-ascii?Q?HHAm6lFsuBlxUc682nUMeFZrU6V1LuPEEr1c4ZAH0BVEmMfvWiVgy5jvYhcf?=
 =?us-ascii?Q?shplZlcYVVTOhK/FfCDMLU0wqVr1q9No4BfpB/7scRxbmHG0dIr1Afy3V9dY?=
 =?us-ascii?Q?LSsxH+SZ48/yZIAc+z08LQU/x3sdgS5XB0r833YL4SxAnA3mayQtRrwyScZc?=
 =?us-ascii?Q?vXEhHrXoKsDpIgmlx41Sd8vTVDmdDiflyew+LIM7iZ8jtpqp+K06WgOjClRa?=
 =?us-ascii?Q?urx3SvpYZf+eXXtzEZMzgxY1BwOGr7UvSy1vgop9pQRW/u3TP1gM7KFyQo4v?=
 =?us-ascii?Q?ClyVZiZ5/PDSX46YK2Aj435qu/8muQ8WvSFcjeHyQtWSXCKGTDCH1g8tTa76?=
 =?us-ascii?Q?vcL06lqPj9JbgPeXCo+aOD5Gz5b/bQmovPnwjRk3q3MPSJ1CF93MAHfjYmIb?=
 =?us-ascii?Q?IYgNunXEJecmQBYD3BKa/yR/z224u+qEz49NyIX+oyluhFKEVdboQcxkM+fc?=
 =?us-ascii?Q?rQqFTCkgexIfxAs8NTxrzQxozYUacXx+9tdR23ttk2m8A0FNyoHsln8Ld2+A?=
 =?us-ascii?Q?wytZ2M2xZTLftSQJX7rzS1FULWHSE/usF5EArTer1l6n8JG/lhj/SmYr0t8I?=
 =?us-ascii?Q?MqtkJlhzVhNXntionek+Td+rGPjea/fek7unG2N2VhUIG3j3Fl5bU1/FwvJH?=
 =?us-ascii?Q?fv8FMZZz7ECpo+7wgC7zDkew1qU69+ChEaVv7UUhkEDbZSaqLy6BtjavvfAw?=
 =?us-ascii?Q?ssZHxbZ9ZD4fBppeliRj6T3Tqxvncq3OdLxbzJZj85Z8Y3dLAHYi4EpeXUGj?=
 =?us-ascii?Q?fFQa65mFnUL7o3feuudGJTxusXbJtgNmHeeM0Z5Z/ooA5R7FuWDvgBaYr7n0?=
 =?us-ascii?Q?etSKXtkjqk6ttPHH96diAGvY9WnWNTRsUwcmdQKGLOhiSqUo3OZuI8iD2hL/?=
 =?us-ascii?Q?dC2dvnvKbXo9inLnkk5ALmemlUwmX6Zs0r8hbyPx/bHjIfHrXXT3/S8j0Eu6?=
 =?us-ascii?Q?j4kOvbwjK7gV/EmqlkXJ5vLnmE7DSMD0Am+wM4/1hdout6PGi7k2BcRLXe/p?=
 =?us-ascii?Q?Hg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f18b685-e54f-4ebb-93a3-08daa1c5e355
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:12.2574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzNHwuuXGnGb0+kwWJ/JPH9Y1ydqKQWefKqNQxYPS1TqerJ0ZmrQ/v9J+JO6N8aAF05q1aL2/m04on0KhyXuL743+JC4nQyp6NYuNm7PPD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-GUID: RS3wa9-R6PZF9yj9o_bLFdkmDSPCU0yW
X-Proofpoint-ORIG-GUID: RS3wa9-R6PZF9yj9o_bLFdkmDSPCU0yW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over a combo of linus's tree and Martin's
6.1-queue tree (they are both missing patches so I couldn't build
against just one) allow scsi_execute* users to control exactly which
errors are retried, so we can reduce the sense/sshdr handling they have 
to do.

The patches allow scsi_execute* users to pass in an array of failures
which they want retried and also specify how many times they want them
retried. If we hit an error that the user did not specify then we drop
down to the default behavior. This allows us to remove almost all the
retry logic from scsi_execute* users.

We then only need to drive retries from the caller for:

1. wants to sleep between retries or had strict timings like in
sd_spinup_disk or ufs.
2. needed to set some internal state between retries like in
scsi_test_unit_ready)
3. retried based on the error code and it's internal state like in the
alua rtpg handling.

v2:
- Rename scsi_prep_sense
- Change scsi_check_passthrough's loop and added some fixes
- Modified scsi_execute* so it uses a struct to pass in args



