Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A89C4321E
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 21:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiKOV2t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 16:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiKOV2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 16:28:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE70B57;
        Tue, 15 Nov 2022 13:28:46 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AFJRp2Y016588;
        Tue, 15 Nov 2022 21:28:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=yBpKAcbFJz9VaxrzKw9rxzYH+IC2kvv2s49PSZaile8=;
 b=zViE6R0mn3kqZmXm6tqhoJan94WvVIdn3WGUUNuNexRdfoZExGmomBQJH+FFleSTRSKg
 xqrUBuLWj+XHUeLoCejMJllFQSjvTXzIp9cy7lDpovP2aOdVQl/OncdnFDj4iBWd1QWb
 Gj0nF6KZg6UojjO3a6XF+7REmt2YWY2fmhnxcI074CZt/jQ2d0Gl9PgSXrwKerWFsRef
 GCc7iv0pkHo5iIRDGfOKbuq3TG2XPEL0X9pLMVzE/IDfOos7Q9gh0vhO+GAzvIpmBJOI
 gNY+d9HZ0RSNKkTusEIAaQ+ukb92/8R37rFSyqTl3ALRBqiboo4i28gc6rTI8keEDIw/ Uw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv8ykj99a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 21:28:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AFKDURb031804;
        Tue, 15 Nov 2022 21:28:30 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xcg3dg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 21:28:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnmdjywaBLRY7MQ43vT+UE91cLKUUiYelAVWDsVyb9pfJ4cIEJMOoDrzkeQbMZOqxzp+h+qqsYn6BsObZaVEllqgXFxMVmYqOwNaOunLXSlbt5VowmjDNAbvSOyK8vDl8ZPcIPEKUTuxLlvS2II62cUcdbDRPJgp4HuYFTiNkGBoU3iSPNxGA+Xw8J0wvocWFXTgUc67olpHL0BHQ6atFi9k6E561scqboJ+eZtkIzTDewezt+jQS8T8c6zvfP4qMLAuBfPttQdFiRphSsW9ii5C2SfAB1yFAPoTOJH0NGrM7ascmG98dIf/A7cbmUDUt39ntKXMT7K8BTC1UXllkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yBpKAcbFJz9VaxrzKw9rxzYH+IC2kvv2s49PSZaile8=;
 b=Uzf9pNKNuQa6aUwL6IFcf1WpHZqfgwD3ybm7yDEv8TBGPmLUEkxbu8nT1JTmmw0cuuK10kaOA5jw+unDsoEB9Q+IysI5cSWXXCxWuBtc2rz230n2a7rDVx//F0uMx9yxMVokwVHrU2pRM++SjtAbnU0E2umoDnPmoi9xzw72IV5XtPRSwDQCnrH0Y+yqS9UJv5Ystes7RcrVFEnsglnwPrZztSTjP7JOxmYb5Qrz6g7foNnFLG5PQ2x5/5qtaXOWOAp1o3+NsN00JKSM2p+6ES5n6t6y/YENxXZh6kSplLNA3GhhppF1nkO2uyT5iYqiGOoWn2Semt2gTOYFjr6ipQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yBpKAcbFJz9VaxrzKw9rxzYH+IC2kvv2s49PSZaile8=;
 b=F51vndmwqaoR6Ht0VlVKDoVSxc3kpQfos5tTDb6ZKtbx6NkVeAvuOJMIjU3hw81mK3QjYVWcCwMPuxvVmAXyeh0uouFTArbyWUlVFaJekEIAA0DU3BhMyLJKqIDkqjqSA9hioL1zrYW0dakjsmmaNB5jOHTqVs+08LOi7+2oSF4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5368.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 21:28:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 21:28:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Subject: [PATCH v2 0/4] block/scsi/nvme: Add error codes for PR ops
Date:   Tue, 15 Nov 2022 15:28:21 -0600
Message-Id: <20221115212825.7945-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0008.namprd19.prod.outlook.com
 (2603:10b6:610:4d::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5368:EE_
X-MS-Office365-Filtering-Correlation-Id: 94f8387f-0945-4e0c-4c74-08dac75055dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /9/vofwIOiMM2R1+WM/M0JgH/hjaa70iT9LWKKqPycoITAemt4r8MHbFhz5qETCqgLYt9ytkVWEeycSGkbfXZbgfqlASpA9ILrS8L1HZVzHJs8oBuFWcoLhFGdHi5lJsKfVa0EKmtBGRN0sFRrXiKSC9fkTHyOwoK0Y+cqjAkEblPtowJY2VeSTFvzVoKG6fQOKnC0pMF+1+HLntAAnoH3KlS8nm3x2L71GEYDTXgz19lhND+T5vcVasDfIxa7OERw1lY6jKgALgkhi7Kz96ATcrk8cfCr81w1HatDXCjGzxsgopKIJ5sAD9STDVapBXmeI0i1yXQU2CS2CFbgS1WTOFz7pomM6ry0YzPJ1QbTarqVI4l2SXMcuFz4WAEOiEMHpbsz0coXzYDUcJAb7i0V44ol/ly3qpBXpnnUyD9/5cIpsmtt8y+05+BtCfeMV26lxEiiK1LHadzeKrgsM+bb45SCNozXSczXtEHKDP6ZKzpNh2swhjOe0gVbEmpSu7jSAHY/u9g13zGY7SeMnUGxFXokw24221l+jUCMpxREtlTFtxpyBiJNiCHT03NS1g6E4es4kC817PvogxyA8GQ6O3oiyvUW8EUnWP1uAIqnaWMC4wRs9jvWue/laXVkFctg/ZRhZQ54QKtereg4Br4/mEQfnv4+yd49UrnUHUTyhBvWWn52peCyr/k1kAierCfLdbpF2NqceyBFZ+CNHcrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199015)(1076003)(36756003)(6486002)(478600001)(6512007)(6666004)(2616005)(6506007)(86362001)(26005)(186003)(38100700002)(8936002)(41300700001)(2906002)(4744005)(5660300002)(316002)(8676002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j6//UnJqb0nBFhNlrz4juOlV56fhmLCtaU4FHaILJwFkzmWOOV1nLYUb2ICo?=
 =?us-ascii?Q?xn8fOxR0oY5xXUr+z8nxRwYcQTO4jxnlQIIMSj35QEB8IoPF+QyKJgQUP41W?=
 =?us-ascii?Q?AgB3MHmOX3+uXrtN80DnCP1YQg90HNSN/L1AQgqWseL8Wmn0GPJoFfvXBDM0?=
 =?us-ascii?Q?M15Olza40DgZIRuDhPiBP5GbsddEEzPO4idKLoNm3M0j/dVs0/mm53MhVuPz?=
 =?us-ascii?Q?J6p9a0OtbjhqeOdNJLpbQEdH95QIAlLqIe2x8mPWMkjJnFeMg1QYHK/0EMCb?=
 =?us-ascii?Q?720oWOaZJpetpbUAeZSDP3Y3sG8VTLMCWb7my1OHDuG2NnqpCb1v0isKBzrZ?=
 =?us-ascii?Q?xg6OhiK06AXIHb7QY2hswUqvpxbpkLvabywEDgsNUnm1ancrsmfHuBQIW5gu?=
 =?us-ascii?Q?mxTd0Btw899uHreL3a9PuBJK60j8381OzRxTsrSy4EFpWZbVS1LkIkLk0tKD?=
 =?us-ascii?Q?rdurz82KMxztcYI2UqbZVIj6UypoqJjLrzS/oULNW9I+AvnFU/OLrKapM0fx?=
 =?us-ascii?Q?BfTCO14h5UYbaIuzN8GEmCSu4n9WqbnJFty2bw7qm1C6+MDZumt7H4q/NMbB?=
 =?us-ascii?Q?F8XE02IweJy4ASM3aJI7RuPJuzquWQefQ+KBBkOt4Wu2HQIZturG5hAzyVvN?=
 =?us-ascii?Q?mQxu+FtpOiPfa/KJBQGCyCkrlYZkm887aoi2gw2Mpz1DMC97bHgfNNbfXSZY?=
 =?us-ascii?Q?pbW47+nyKrkSwMLi7eG0n7/OmZoNnmR+7slzqxxM4xVXkx4d6aTS2I28ybwk?=
 =?us-ascii?Q?CD3zHWLN3mN9SqjVurEorQlI/VBZbC1R7Muw6YpGtjIbsvbCkCUxUrZKQyyP?=
 =?us-ascii?Q?hXFXg7U1ovKyYINuLOPvsVoG7f6lQG/jOqQVnYs4WBB2On9ypTKGpni+AV99?=
 =?us-ascii?Q?wX+wccO5tXDiUg6ZVhk4BMaF13vaaDVNIRvaMIJJu7RSHvhpDYRsu481XHGc?=
 =?us-ascii?Q?cJj4BNVFiTPZVJZAe87wpoXGCr+hsQuCQepaz32kvljpxdgh1XfFW6ClyIx+?=
 =?us-ascii?Q?8ynG0cTxRJT8mjMXEzCdlmKskktXF3GERFPAu1PjiSfTTCz05EJ4EEjXEnok?=
 =?us-ascii?Q?CUg7e8VsND3xRSCy9zwk4cmQrnRGGaAvjgpui37d9bacyAYBycoAeRhw781I?=
 =?us-ascii?Q?Jzkc5P0hOQfQs9UugwBukrPB7aJcoxddbcA2EAG4RAvFuQOWDxWIbNgXinNw?=
 =?us-ascii?Q?x8orWAUe/mk1AjO+B8SJH1QKJh0GhzoFYTdqpfBAVTXSGfQHu0aFGAW257ey?=
 =?us-ascii?Q?xMtkLMTGTrLm8VN/w3sLG/SAkQrT7uxyBnpUcxPlMfNtI5xg474q6kipiM4I?=
 =?us-ascii?Q?8CfMRQWXRTctwCXVmRjcWeVBMWiNVslmMiESTnTs0o9Y73h4Tl0X6tavofum?=
 =?us-ascii?Q?SXISJ5jCDIL+eCMgo6S+eXmU3kJuQkzPFQ6iz12VqSzqXCrSnot24vyG/6Lo?=
 =?us-ascii?Q?UlWnx9i7UMB+Sb6iG/P0EH1myB9Zx5UsSQv1JKS1UU1aKjtWoN9cPvJS92y+?=
 =?us-ascii?Q?APslXngeVPSgtp8WNgCK7n/OsjiDpVkpLhYbadZtFGMglr+FtL04FXi1O2Cp?=
 =?us-ascii?Q?mhA4f8ySnkLXMoAtyp5bit1Qr9Usfm/fuS9MbwlTSI3nMy3rwgcU/kZ8I/gL?=
 =?us-ascii?Q?uQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?H2H+L/kUcQMf4FLdjpnNwPbXQrUad57EoucNKmt7UmEYMo9RDWYIM9Yu9Hkm?=
 =?us-ascii?Q?9QuFHg/nMVn/Hr96eg1wjIcnB5HeyzY7PoP1Nt4uXsAsgUlXUg+DoYCm/5ES?=
 =?us-ascii?Q?1gNRzSFnw5NyLf0pnLkHhYradni95uDn1iCNuI7BN5wvFxutsdLnBiSKgIaI?=
 =?us-ascii?Q?eWK5ibVozD/WZVuA9bXPP6Jxub+JXyxOLqAnnsn9FSXVFs9AdjyrFbZ4SS6i?=
 =?us-ascii?Q?lMMonJH14ZIm+wEYDkHGfQyfSL3H+qxy5UpaInYYJGibKr/+WfoJKe6V46vp?=
 =?us-ascii?Q?K97rzDAuyrMrcESYBISS8JYLbHMYh5LUeUFb7OlEC10pyHhNunajSV4UThU5?=
 =?us-ascii?Q?FpABwDMv0qN5Z7eS2dBfKGLuEnQEW515PGxKSt7rcuQtmxlI6b/JTmlKuBu5?=
 =?us-ascii?Q?QpKAng9bJKOWwaO6vzKGkwN7mum37is1nc0XTIF1BXg9ZtKQCDhhVAOBCj8u?=
 =?us-ascii?Q?PmNMJSXN7p6ZDGWYRd713ST8Aw9lFGe4Ys55uGE+dAqTUUeWzol87/F/7jYv?=
 =?us-ascii?Q?Qg7nhC+B55FIHMVgIzH0dxSkjoBM73wel55Jwb8J6EvrfM6Fw7eZWYBr1/ca?=
 =?us-ascii?Q?lmJ1e0saZgC6CqFI1KJgI1VB/E2SeO+jMFKbR3FyEm8TtfY75QNgyKls+get?=
 =?us-ascii?Q?ktWbdrgGuGRmvMRJsOVBjOShbtDKlrwy1fz6h9zvKTW5BVArryAdRjHhmVCK?=
 =?us-ascii?Q?ipFIKLdIvB7GL63CuPpoZTXRKwgc0s7muieYb1cq32gCQh6JVJFCv05x3CpS?=
 =?us-ascii?Q?e4XNLd1X58yLIJ2L8bY6xuA7aN5RDDyXKsefY2XD4JEQpstRijjNA2p3p7po?=
 =?us-ascii?Q?NS3iWKsaqisHxM2EZHa+9xoawrj2UqSM9PlvnKu1byou1+9hW9ygCCHcjJni?=
 =?us-ascii?Q?bGpo7cK81E/8YktLGxprXrV3Guoiq+sOP/ORzW8ZijmBInMVHqx7dSI4n+L+?=
 =?us-ascii?Q?3tpJW7fvRBkEabC4vG85Dn7Hgh3/oEJOgaww4v4EjDfmSA4uaNBtTvuOy7Rn?=
 =?us-ascii?Q?oDkN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f8387f-0945-4e0c-4c74-08dac75055dc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 21:28:27.9408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fi+BS7Hk3RQ9hA4Ga2pb+1iaC2ilsuVB7JET6aY3nxYKuT8FHW0s6x1BUOvAQ2nzJgarHeqpdPieZAhHKgQo6M7kn0tbAQIIGIDZ8KmzLnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_08,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211150147
X-Proofpoint-GUID: BaN4Ha0ZykXFK__qvEEyjz58m2QMXT07
X-Proofpoint-ORIG-GUID: BaN4Ha0ZykXFK__qvEEyjz58m2QMXT07
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree and allow the PR/pr_ops
users to handle errors without having to know the device type and also
for SCSI handle devices that require the sense code. Currently, we return
a -Exyz type of error code if the PR call fails before the drivers can
send the command and a device specific error code if it's queued. The
problem is that the callers don't always know the device type so they
can't check for specific errors like reservation conflicts, or transport
errors or invalid operations.

These patches add common error codes which callers can check for.

v2:
- Drop PR_STS_OP_NOT_SUPP and PR_STS_OP_INVALID.
- Drop dependence on scsi_exeucte patchset and include status_byte
patch in this patchset.
- Check for all nvme path errors with nvme_is_path_error.


