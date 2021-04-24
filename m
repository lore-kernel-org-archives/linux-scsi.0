Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8168EC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6438F6128A
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhDXWHD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33784 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhDXWHC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6Fe1005137;
        Sat, 24 Apr 2021 22:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=vEFrB0HgrYcUUTcGMZ3krEwkk6DJo26ErM8GUoe37Gg=;
 b=cEg2yRnQxEVGgFTWYMPWjtqXItj73LnEgaPz4sgaUT/7coFQvFx4AnnTi1TPArwCIG8J
 Zu8Xd9u1MmanJomnM9iTH3iWKyqFON6ZQZCIFNkTbutemeyj9QzsGt3YIOI9vbiJMIlj
 6t/UxRQOTwEG0VON4Gv4ECc2ogUNxVMaiezeppyYa51oAgs9LZMcIO6KTcNNUk9XV+Xv
 tEcL6WCvqxzd6bw00je/jpsT9ID+SHu8hdxpXn/HGDt2+jb3kz1ljN/tybbJ15y1DX4k
 V4/VUyq6V1hskql6GUh25Gfu5I8NxL/SiIl7J/9I+rrsTxWpitsuCB53cqkmuw3Hfc3g KQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 384byp0rkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM5Yeu053539;
        Sat, 24 Apr 2021 22:06:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3020.oracle.com with ESMTP id 384b51tykw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g73xe4GwrCr/uCyJc73HyQwV0JqTILLSiMnCAxjdeIUaq2Z4wv+jFT+3+fUb6KxouxWkeFEe+zVGR0abBKAacdXdiHTLA2M963cF/p+snFc1rCiu+RwhEyZyTUfdnt017an4Xy12XDl84ozIUunn1e+2kJLAabPXQlnk2TYXdrZTvBgsSNGsLBX0bqXvVAXMzjK8ht6tOOw9zAbyfcn+5pLhvLH3Ra+OvantdnCtJEMg3rEkD3a8g5DiFyJgf0JvO1DJ8tZWcEIDCorGFNICu8hijqGZGQo8GvpQTGeXCV3g/GFsrDt6JIdZSJyVJDvT2LMlI6aPDQ682r6okJHKsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEFrB0HgrYcUUTcGMZ3krEwkk6DJo26ErM8GUoe37Gg=;
 b=Gsvpr5UwjSIR+o+bmJkerckRFYS05JNts1fWWr3Vc/oZ0l+/X74aL2NKZXg/5OvV7WtQNVsnuF5jYFHQSbZglwCYPnXpdsJk4X7omIqcG0OXJVLSDbDeHBDBiOMV/+TZ5IQPLRPgCNlKotDg5CbLQuoJ7lwIVKR35kWZUGC4J/ofw1GSxcczdMyMwpe99d39PA4AXLqBU9LPVOJsy/glWzu/iNtrSmpzTQqCksj5tYb+lqxn1J7UUKgt2MlJtbCxQ8bQMpWhlyws58q9SxCpg50C7LkGxWnY5rmIQYYM8JXVvHrs5aK3aiScq3kYbJeJLzaIfLBD147n8GsraSrkfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEFrB0HgrYcUUTcGMZ3krEwkk6DJo26ErM8GUoe37Gg=;
 b=F+0wfxRfg6P27QX37SyXkOHO5HM9B1hChzkjfFIObxqkUdlUJuVN6/fQUv3DPB4pUSig3YF+Tr4XlOjZWVjqHOkTkUgDlBU4emsPnCXdyBahtgdDOWRhBxbjfEwd7AA63Yqc68TfAlW2Fj+1WRLj9UuxXqURPocMMfg63loUdKM=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:12 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH v4 00/17] libiscsi and qedi TMF fixes
Date:   Sat, 24 Apr 2021 17:05:46 -0500
Message-Id: <20210424220603.123703-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00867803-228a-483e-d161-08d9076d2c04
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB331797C1440FD97380481E32F1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Px2W9AZHEstXxxXUc6tsZjkVWmfqI6eSrY6l6HJx9MHEShAQ+gqp9p6N206NUG2ycc6yW6Q+NaTf1bxHq5zdLNF84E/Sn7u4J7nWxjN9SyvN/8nRqW4oYOKXjH5ER3tmC5llLYvaNb70wLHtKifwEJwf/4Jdr4BaiRytxNYkGGrQB+onxGep7nt5fWJuWnMgmF4K1SLGmwHdelstpaO5qVzMiGpzyhUttm4b13QPFMB5FhLvMiwLByQRQovMXfIesdk/gEftbKcDsxv/qH9hvstUfe6o/S4F5MekF+28a6LGetEjk1mChHvLEnfeebtl2OMUsK9vYlZRVyowM9tkK5lO3/jiNpg8p18zb/HoTEpfNqnIZZ6D/0M7zf2wEzJ96mOZ4ZmJ2r4Wco+YejZj6fMC0r/FrMdpgJ0tOcoszBjdQKt9GXy2arRCdVEWjJOrPIH+C5cGrtKlpKlydbF+QVNZ5U1S67gY4NLYB014JZUqe3bM4BmMO+Wd5O6na22XEacuxYWo21UtW4V/qLY/YzAa8rQLvUA13z6NyEYDdMlV02lZrEZ9jJGbuB1vDkcmxjCZ/bcnlh14zhXM2t9ie6B6fx+Q4Mk6HZDaJUbVRmiLqhzYYEti5/4dFI4gqfXvp93WRvfirXPngf8EcJTNM8Vg/IpXSipBxhhSTlpYkfNVrXqeVjsO9fulagRV5u7h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(16526019)(316002)(6512007)(8676002)(956004)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fAi5g8sz2g14jizSnPDUXmewWA/k7AOMbxKVC6Ne0tTpsp+udVRK+MlYPU3A?=
 =?us-ascii?Q?+4VZrO2jk/AxtWwGnMxOkjJDQSaaS7IXPDuV5G4osmnM7yJzsLGsYAhU8Sm9?=
 =?us-ascii?Q?D5HKyjJiQ51F8VWOU+YC4mrX+VdHWZ/QYEgveGW8l0B5uL4MN5vbgxaNcjb3?=
 =?us-ascii?Q?Q0XZRSIbIKdTkKC9Bs2+45ph5Y7kvBOFRdI8HkX/v0rrxpWj4Il0ctVa4lLi?=
 =?us-ascii?Q?anK5iA5doU6KwK4xGXi/O4KXElv9sNIr4OwJH636SeO1Nj3jXsv2aSVteoIK?=
 =?us-ascii?Q?2Pt5SNmk+vH7tzatWuXRTj8XtDYmeImWfT4Bd3XG+c7XQ30P/k1SdZ5uIv7e?=
 =?us-ascii?Q?XCCPcaS6DAnn5Rnm8IZtbmx7tmz96mEfSjEeyAAgQ7PIEwcIVBG6PgAnKRj3?=
 =?us-ascii?Q?9zKpRogERoLuR+1fnSNLkLa459g0PAmELexprGaRXqgMUKJ7+dxmJ1/3xPC1?=
 =?us-ascii?Q?V338t+RLXhFqn9aXvndyEw5sxnzLyVFe7EuuMLCQ+eNWyw+hhV0i2eERTFpg?=
 =?us-ascii?Q?AobLWwUh5OajEmOdk6taZ8BS+vO7K7NZS5QGIX1gm7b3cwVb6lEFSGpbhw/L?=
 =?us-ascii?Q?7/N3Gj1EUi8IBuiTFlun+qvvI8zZ/V45+CSfXB9n/TwyUvtYPH1t2FB9zeKm?=
 =?us-ascii?Q?lBBeHTVxzQ+JOsxDreJFpW1Vq52oaIxpgoq8yqW5imAtYDx2RMAnkURDY19u?=
 =?us-ascii?Q?iK95Z/vMTYwcGqGA0JUH+ejpzjCExAplWQa79f9l+ToWDxAKgNDWj9S12fw4?=
 =?us-ascii?Q?RjiqIdBEddysNu2hcznafYJtqeuzU0BHxqNzfWoYnd4cBtF0oqwSeRPEfSdb?=
 =?us-ascii?Q?tg7WNM3nMMc73dvHxZ1Iqo9jCTLXdh1040rzddjkFwAmU0Pi8XaNmI7AQOLU?=
 =?us-ascii?Q?Gdam4jnyvKSnvbtjiosTS4t8h0h0brgqv0E5BZ+ANVu2nMY5Uf51ID9cZx3I?=
 =?us-ascii?Q?gv+A6AZsZ9ZGsQSuo7kbFngGN6vEE9DlZdONTI5p8mJhlcOij5ffckb//leN?=
 =?us-ascii?Q?6SVSb3YpyhwgnFVPQr6U5ITqUQj2kiuE0B/oKMQVLazOtBGqDK3F/NQ/AWOR?=
 =?us-ascii?Q?Du1KgDIV10z2DVd0T1YJurA7tA4Lbo0/ppyiFaKCoq8ETAbL5rL4IH7xtg4t?=
 =?us-ascii?Q?w9/UbH/DkwTlf2aYMd7W3wywFQC6uAqj/Nmok1OR+BdJslV26GjOI/zlahHK?=
 =?us-ascii?Q?1iUXr/fSXHNoUSdfcxkTR0MtrY9aLUhcjC1q1uPRnYS1Gn5WYAONhPdWFwsF?=
 =?us-ascii?Q?hELAqMWX4w1KQJfTSV7wCn9WeQCGe1rIvHbby+rIecc1K3tUXyx7sPlZ9lH2?=
 =?us-ascii?Q?fRRS5IEtg8XA1XJtTK+/+LMW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00867803-228a-483e-d161-08d9076d2c04
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:12.4586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pF1vysvMPDayzZ+9tF730V7IEZC/cWPsBWGyorl3H+v0XzBDDg1k1c9T1qwtmRGaheEyyehwsK7Aat3zS8T+FjyCtplsBcS5ZY7hGOPXnNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: 7buTDKL_TrZ4YypzbILNA1M6KoyCGhuN
X-Proofpoint-GUID: 7buTDKL_TrZ4YypzbILNA1M6KoyCGhuN
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree. They apply to any
of Martin's branches that has this fix: 73603e995a37 ("scsi: iscsi: Fix
iSCSI cls conn state") that has conflicts with a patch in this set.

The patches fix TMF bugs in the qedi driver, libiscsi EH issues that are
common to all offload drivers like qedi and some fixes for cases where
userspace is not doing an unbind target nl cmd and we are doing TMFs
during session termination.


V4:
- Rm unused rtid variable in qedi
- Added a default case in TMF switch just in case people do not like
not having it.
V3:
- Fix u16 initialization and test.
- Fix bool return value use.
- Added patches for cases where EH is running then userspace terminates
the connection without removing the target first.
- Made patch that stops IO during ep_disconnect more driver friendly
by handling if the ep is bound or not.

V2:
- Dropped patch that reverted the in-kernel conn failure handling. I
posted a full patchset to fix that separately.
- Modfied the tmf vs cmd queueing patch. The RFC patch only supported
qedi and offload drivers. iscsi_tcp/cxgbgi do not need it.
- Added patch for another issue found where cmds can still be queued to the
driver while it does ep_disconnect.





