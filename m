Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E125C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FA246115B
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237982AbhDPCFY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36124 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237661AbhDPCFX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xwdb172162;
        Fri, 16 Apr 2021 02:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=0FxfvxrnF/7kcwfu9M20HC6sLODwbIkRzk02d7Pq9pM=;
 b=JTmJuhXA1OjPm8kjJJF6DubOuZrtOhQlf/cwE0g35RCVqV1PrfdXECzWC2hKnOrVU7I9
 tNHMrHblJaMWw1V10pNQxbes3+zdtrZDmI8fY0ij5K96UwHrl0d1Du5o3MJOasJJqLCN
 0J64bKotXTVvwSX9kooCJqZgN6zJlrwhXADdqAeZx+NbPk6AHNe05cB3RtrRLf+9CMgv
 jBm2hWGfhradfRhViR1bSDutEi9x0/NfyQq2xIJRLHDur6HklurEwyaZa4ZvqCJLjeGc
 tEXhnSSTM9mF8O577oUJX6h/S1wKiS+AY/R8wym2EVavpwM45J4P7aOueQtaf/MXRUjl oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37u4nnqmfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G20ef0001074;
        Fri, 16 Apr 2021 02:04:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3030.oracle.com with ESMTP id 37unktfb5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DD5evnx5W/UB2OSn2S6xB8HmrvvgVgc+DJMQNZS3rYJl1iSMhqsEp56RJ4ReCpRFH6owO43oEfCkgW6NgS5tNo48cOeIvKNyl9/AMKoScos4Qo/ZPEVL4j5A2OxlnpfdyVL+qNNza/5GEE+fsZGAkS6cWbwfdSx4Yiwed8dCX1KIyeDc673vYUzjMxKL8HbQ+zy+XziZFTF4zRWrgeIiDIl7BQVtEWQ5D3aQ30AsSuXY2Pl7Aec2Ch3JH713sVnVfb0NZxo567RwEOz28KJ1fjZFJYl1/c24OQNi6mAE92s3V3Z3XOGg969n+oI5NnqbbWfhqPYaXMgD+W7Scx/aIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FxfvxrnF/7kcwfu9M20HC6sLODwbIkRzk02d7Pq9pM=;
 b=HUHWhfSCyIBk4adGC6sbuFNe10dgPsHKvudvlqj4+BG9eCeQetjsRa1UvUWtXqd4zHBCNVLRoi+qBKPpLsN0wCtPBOLuSkCymG4LZKtP4FHmisq8iquQOT5s1uHxBSkwQFQJzgvonmfruXVGpKb+3985N5zKAe6bDZiqd8lziM10waXH3vhonEJU0Lkd4mss9bnp55V6jpVGhOOttmoakUuQJz8QRt0eiPbutJG0y9ukeeSUfN1PLrKC+91FZ1Ys4uWM1cLMaGtpJk6ACVkep3ZxcT/9TSNutL9C5ITcidb00j32CWSj11NvbN7XHAO4m7AWc2t/qsiH9sZ/dBIG3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FxfvxrnF/7kcwfu9M20HC6sLODwbIkRzk02d7Pq9pM=;
 b=NjV0i9LFp9XvqSa0NEwPa94sWxlZKwnitcLv93Vq2WdoyNZVfmP7OzRv3xBnXuZG5tWnc7g6l83kMdq9uawuixxOv0NpdFIa+h5q10jg1jDovOsatvX2uve3yFqmfNJslr+C5eGgsfoS/WhPeFeEC/w2Y310GqEHQ/GSYvG6feA=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2421.namprd10.prod.outlook.com (2603:10b6:a02:b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 16 Apr
 2021 02:04:49 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:04:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH v3 00/17] libicsi and qedi TMF fixes
Date:   Thu, 15 Apr 2021 21:04:23 -0500
Message-Id: <20210416020440.259271-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0100.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::41) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:04:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b22d973-2f17-4720-2292-08d9007c03fa
X-MS-TrafficTypeDiagnostic: BYAPR10MB2421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2421292D2CA7ED9B29EB092DF14C9@BYAPR10MB2421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: stO8aOQH7OQDbUnttZzET356yvEq3jE0TMRJBdBhMkysSSdOWAM5C5wpBOZPnenkWevqRBuhUSy+Dunv+Pr1z2sCdSishMW8FBU9aTJJPb57H0Zlb46d84EhlCwXcg1zKwVGwWwg3aPpbYPuW7TCzsSjVua/U+wzeXOmxVBkSHvs7lhqdBdwaMq/nr83Dji+9HCySLHLhIR+DMHQ5Z73+vFstil7whdSzOmHYqjRTDOO65DT9Dj/eFwcYuxN6KvWaIQ9ZsV3RGUNcM8yzLoABP0S2rtVoypFPgg8VI2iPErgEm/3h02NrB9RqGNT9helyuitSLWs1SLjKE0cNa9siseHFw7IERt4K7O5EPmtYhMKY9QEMUqWr3ja415v32mFST8pY6gMAS/ICro1G/4FIkBaDHXw2gzbodBU2XYu5xkFdK5lqTRrhNPFouEg84Wc1TQPy0kEC5uIn84FJhB7x4oXCnWiNjw5SHSLqEMOmtlT4g/Kb6mdTM2eFQKCb9xqXg+yLf1oZ/F/q22Fxke0XOGmnB2xaxMVIRyskCvKxUyU6yCk/vhFlNKoNQaFqYAmqCWJYg13vjRtXuTYqqQ0wyOHNj7UjaUCOTQnGFKsOgFGw0Yeeu0MTGe8cyH5gVSxQiPRsGk1aqa45+GoC12yybfV/ENXyYV8lRIs1WDK4MkJp+95Gb/2TMCNYBQk4RF5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(186003)(69590400012)(16526019)(5660300002)(1076003)(6666004)(36756003)(26005)(83380400001)(52116002)(2906002)(6486002)(2616005)(6512007)(956004)(8936002)(8676002)(316002)(478600001)(66556008)(38350700002)(66476007)(6506007)(38100700002)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8p+uIp1IyjHnGZJCiF0cRxiZfzpERlnD+/A9ozWSROZNxgGCZ82ZIVg/RCG0?=
 =?us-ascii?Q?JDLMA6/nMNJ4n41sBwEQ7MzID7ZiV9WE3tWpBOvxsi+aHYtQxPTMCkky6hHY?=
 =?us-ascii?Q?zbWNcRiPZB4e0TRB2tC6X01f7aVFyolvB4bhMz+s26PpqbCwJAjH34RonJGe?=
 =?us-ascii?Q?cANxbKRMl1gpXBnW+T1Wq36NhOftBHOb/tGhFFeVYLdRVPQso9pcoMPzpRfH?=
 =?us-ascii?Q?3TstOzBaYn3dz66TRrcTMTpQwSMADIBe75masw6BONhCjxvkjyVPeyf4Yj74?=
 =?us-ascii?Q?I7pQ2ZfJIAt/iWDdgKLkk/0K1OWD70OqSdFufMwURwHEFfm9R2zuYYvuxJ/i?=
 =?us-ascii?Q?gS56XQMaMDm7BHPuHVQX4NJWChnRE4eXbX2Kqqd8XRdrMWyE1ioAPRcN9NBf?=
 =?us-ascii?Q?vgEmkg3TSMSRGRXM1ffHnQiUejs7oVjNxZm6KrGCLL6nGAlDpEH9dQbnSBCv?=
 =?us-ascii?Q?p/8h+9icR0GdhIzht9ixXijLnyG77ShLRqyX8Wtm6HbGh0qgLDfbclpWK6pA?=
 =?us-ascii?Q?PvncGUWPGHudcBhrN3i6zN6dG1lswPAaBHxZ0Qei58lAazgijhxImuV2/s78?=
 =?us-ascii?Q?XH/CXXpHGEROoKhN6v2+mooodx5SHeyP+g5hE/P/uVgwqL7lILQTLTFnJ2bk?=
 =?us-ascii?Q?GYnMKIC3t6LvM8cOVqzZpnOzVg6myFH0YYhPKyY8CU3y2/tpWzsYC+5kzs4n?=
 =?us-ascii?Q?IcLXOGqomVbk965xbLECUhj45kT4gxix4gMCBscGmYRIBsrAMZqS6begUPK4?=
 =?us-ascii?Q?GtLTr5WKNISLgFsFzH1SJgoytzecTLo7bUx1M6GvbWrQj0Z5Df75z7sDwupa?=
 =?us-ascii?Q?jQqpqFkzg0dfT9pIE6RQ6Iz3jMsCsDUo3bJz5CoZsiU1vwdfOFW0UdDK97hI?=
 =?us-ascii?Q?0FvAzOstLq0Jmd5+kGpKw/pbYF9UVmn83kUzoJ1BlR4V4Apq/kBc1VCH7/4M?=
 =?us-ascii?Q?0098qw9ypydQ1xP0EORh7No6lSXbyHE6g2gvj5c0TGSzHGBzUH7+z5DMBjYT?=
 =?us-ascii?Q?zofq78nltXKClZSHEhFdX1zdsHKeZiEshs3NjdGhfNUTH9hVwtMONM08BfJU?=
 =?us-ascii?Q?Udau0JtGT/KzmjQR0EBe5vAe956Wl7RoQJy+NnlQTC1W5B1C0MlUPZ7+S/Bw?=
 =?us-ascii?Q?gm7wIlQV6d2Y30d2Td9Ht6eCVwgT+UjXYhE+WEQd/EvnmbfxKd6JPZU6b06Y?=
 =?us-ascii?Q?jXmp+AhKM5gUiQf3Ew1YuhQX+7VY4ykk7CmsrSa+zfL3/QfDDfVVhJz8pRKG?=
 =?us-ascii?Q?urjzGV9X8vYGEtKQceqLM3yNr6e5/05A/fmknXDqR/jJlBGLXuENUedWFV9n?=
 =?us-ascii?Q?rb5OqAQyCkrxxF61MstcMyN0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b22d973-2f17-4720-2292-08d9007c03fa
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:04:49.4743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YiijTJaVMa9FDJkdUqPse9QD9UHS1e7flw0DdYji5GjEDUL+IGqkMjZqnaOvT0edLcnE1twTIOCAmlrpsZMgts31p3f9k2q6vPoOfyeB1TM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-ORIG-GUID: 5QQ8YgctF8qQzKAeEBrmNejnpB4PyCBV
X-Proofpoint-GUID: 5QQ8YgctF8qQzKAeEBrmNejnpB4PyCBV
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 5.12 scsi-fixes branch
which has this fix: 73603e995a37 ("scsi: iscsi: Fix iSCSI cls conn state")
that has conflicts with a patch in this set.

The patches fix TMF bugs in the qedi driver, libiscsi EH issues that are
common to all offload drivers like qedi and some fixes for cases where
userspace is not doing an unbind target nl cmd and we are doing TMFs
during session termination.

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


