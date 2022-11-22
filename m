Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18944C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbiKVDjv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKVDju (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:39:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884A827CE1
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:39:49 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM38XPj014665;
        Tue, 22 Nov 2022 03:39:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ctJ8QmWUICFzUIhKdtIbEB9EaVROj4Hbzsg03ds1p30=;
 b=xlw6CJcEq1LeslNLl+FI7yucko5MLyrVBrPi0NR3tiWszIqLbnzmNQEu0T/RskGPNO7B
 rhdOga07Kadt0I9CnGwdkQGXg3HLWLoSSTEXiW5eIx20N51FrmHm+avloVyO+xYAkrTI
 DFPhJ83aMPsj7Un1Qm01VnuBPcySS8kNm9g7Fl61X35VuEBkhlxvMHtl47s8oyNvc7jT
 VlGk5cyWYmqhLd/Y/7rFXBtw+Z5xdCwBd03Y4yBH1VatYbojY7M27HmHI3I1KK+3q4Mo
 ujAOD+pPDlLZ0H/ff6AMfJwuE9fXDyN9eRK8rzoCo3ey855dZ2iqe3NA8DL97IoR6VUe EA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0afr2c47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:39:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM1hQQC008199;
        Tue, 22 Nov 2022 03:39:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk472g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:39:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRvnkTFFWzUi6HfrZW862zdFjzoEl73uzwph2VxeuaT2wRPpwqe7OwQ4k9sLwvEKMMQjx5tdSVzwR/3Awja5vEAI5D/+9XWiICOIzupWFPEkqjUIiwtcjH9DzvKml6k//TcOhQu1oj5qlg6hMob8qiqzivLhtASf9SbBerGr3OWWJCrglbkzOmkgaQqw+ctJkZWSDOiYiLsUApiGnWFFEB9Cf1mWazHkQcOLdu1xDTe0qiM3/n3aiB+SdiP3u4LPvrTMZ9AylELu8ibv5vHl4P86gKY3MeBgadTI4is0WTtMAJmp7ImbtMQQ4SM8Z77lenf2wtkJhz4WU+WvJkrGew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ctJ8QmWUICFzUIhKdtIbEB9EaVROj4Hbzsg03ds1p30=;
 b=kFJq5ytohS1G3e8Etk0g6QxVMhV3Or3pp9C3zo5w8yByHxdk7tl9CSUcjL0TN5035aVR+LycvKybr8BN+PgEFdvIT0Gro9Uoi6bdt5VwwA7Cqawyk5dg7eZO75UbhE+Wyk7kt26H7YpmLrZjVp8HPcoJCUraj+OCPC0obX40YZ+vDqNYRHVXN19f9QA2QFDidXG8qhdiCmzyIn3imfxHxAfp7gNiS43BXgNIPvsRGIjTm3I1adV25XC5MvHfNaRkzLiQLltYmI4lJPFfdTGFlFcMwRXa2TUW3by/bSPv2jxoTMxraXTnLostbLzWmX5ii/4r5CzCscaSJnKSs6w8fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctJ8QmWUICFzUIhKdtIbEB9EaVROj4Hbzsg03ds1p30=;
 b=J9hlxD80RQhY7MMxaBjUHi1foI5ALL+K7T8SnG4mvXRuep68oHZTlNMtBPJ+8Ugq+WKunuXgbS3NsLSfAK5hWaZfJAlPfX8cBAfHUzMda+jhEIZ7X6/QtxJhLrImRUbJ8BI/zx3ZzfEnJ5h5KDx2CiBMNy+m+3E2kW3/IvCXnwU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:39:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:39:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 00/15] Add struct to pass in optional args to scsi_execute
Date:   Mon, 21 Nov 2022 21:39:19 -0600
Message-Id: <20221122033934.33797-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0260.namprd03.prod.outlook.com
 (2603:10b6:610:e5::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: 95242f7d-dc9d-4cc1-7b9d-08dacc3b2d23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: axYlunuH37fRzX5XLxplD/yxQNpTPAlUMBa4h/LoKQ8nUDYq8PIGeJnH9mdMmggZ0B0xjuqU7KjydW1vmLmOML+57h0xwdfame1iUZtyZB8R8SuS/lpNIyyBFMlvPnu9g4JgYHcgk3MabBwinsqf2w+wAZiiTUPwLTqG4O4poApe4845n7LGt1cCwo8e7nf8Ee54rVG54zWoiNocEd9oveWA0CGXDiuKEXyXKZZ3icX0Xf2AHL4iFa0oEKt20gWbSwc/AGJUMMyNXEfRyBuvzIT9dYCeoBN05uTtlYrQ7tY7wcWWsw1lWjlR1m6M0gZOw7tSa3Ew2yB8nTSEhSkqI+AfcxIRG7xkSqshgT66ArJOVpSfXVerBrbMrhXMAnR7c0LK9bVje9rhu6o9GBY1LyF9XflKdqlZWnAKFdFYpGR7FZ0TeNRNUr9uYroJaASa5klwqR2MaqBJkmFANDQveLUBR5lkLX4AQynzL0L9KCk5Julaa4QmCs7u9jlUUnBq8gdaJIuBhgbXun0UjxgfY14ccZ3L92ewLKWLdGqqGhFNB+7WR95CUM1711coSLDhOObmgDI91/JrY43PLuKY1c8aev0WvpMViHVAzKcHvxhrWuF/XkZPAQ+2FbkRLnNcR3NwD/l22ZOIn3cRikBRxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(38100700002)(41300700001)(4744005)(2906002)(86362001)(66476007)(6486002)(66556008)(8676002)(316002)(66946007)(6512007)(186003)(26005)(1076003)(8936002)(478600001)(5660300002)(2616005)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k/gvr25qcjuv28od28mR25ZfRi8V+jZW32zWfn35HYjlxbN813ajRg4MWsIw?=
 =?us-ascii?Q?on/ikO3kmFFzC2/k5Rh268Has2rrQFsvy3wtdove3FQ5n8PUiMTgF8VRYpUF?=
 =?us-ascii?Q?Bn2Ug6cRPqRs26sYj6sxrry4arDbn/Yndk5ZTLM7XiNmL/vWWqYKrWRhaqxj?=
 =?us-ascii?Q?VZJElOizDnHFY4pKIU2KtP8d6W80eHF5FAPACbY6K+Wyvnj76oD13JKO6ecu?=
 =?us-ascii?Q?oB2rf3II/uB8pZpb3F/KTJj01NWH367SmG3Xzkg9y3HPrfOjQPTZNS8EiTuD?=
 =?us-ascii?Q?NDXZtJMDutptgbnds4mhGEn/fTMFWPoRpF1IUtZpfSdcEcZjpwZk7KWaD1/X?=
 =?us-ascii?Q?fTEGCbTvNA0mh1Sg7ZrYOj58/arQ8e4RBVpaR+Dl0ahg5zTc3/rPXO3B/3Zd?=
 =?us-ascii?Q?Aw9ogj76Jo+853PL/q193bP4XIr7GGnDzKHOrAwoFdqF+8iF2nRMEjokCMM9?=
 =?us-ascii?Q?NxJTnKLaidb6zYYrxW3QKFXQCBawGcIkVGrBX33ccwBIKD/9aHAaJPOVa46l?=
 =?us-ascii?Q?OOj5DTupOka07NoNU6AzUF1g4FbWS4ozpKAuiwDhkOwDE072r2sKqbHD/l/n?=
 =?us-ascii?Q?6oqA+4XY0X+3ASZvll4B9ECbyxM45TMo+on0IUIVDag0DZlpMwikkhJ41Wmt?=
 =?us-ascii?Q?77iw3QmzrfJiWNk7rzPZhTUh3PAlCckt7p1RB9vHm8AS+XFvbkNwBsDKsLsL?=
 =?us-ascii?Q?Edj4yMwCFj6uorOAdxfqKg2n0d02v2ldbL584lLjKTcEPBteY+tsFYHE2/qg?=
 =?us-ascii?Q?Uzf5ai6KntPYvkrhmnFdwn9zlhWWcu8Wyw1Q+qePwkDS7kW3/M4LqVxcTaFa?=
 =?us-ascii?Q?iaIyvWAwZlh4Uo8TjEckGguPzVj9+jo4IEeBvW+Ns8gG/IVKfLnGQ77JGCOX?=
 =?us-ascii?Q?R7xCP9ryaAlJ6eh5N/WO9s5tvZxl/j5C3ISwINdohTdJrxDFee49KP/kIk7G?=
 =?us-ascii?Q?0jNnqm0NykxCNUZBhK2hQ+0SHg7Xu5XqVoxTpxl8CW4Ylu8mLiUOXWwv6Peb?=
 =?us-ascii?Q?+2Uj95TZN3PHCnbXJlmqLpXuMyy57bNWG91h1dIChjRcMyksT87D/t+fWzN/?=
 =?us-ascii?Q?DejMdUC7/aYgA8s+peCZSGf8rhJMDp/S4ZYxyBV+VzEseoZHZDZLDx5I4cfI?=
 =?us-ascii?Q?OVME+d5rZ2hY6gZF1M01AMbXjeVceLW1Pc/FFUmku2hx6E27uUhNXkXfqFMx?=
 =?us-ascii?Q?SvX6ppFrI2GxnGfmzlgfvUZXlaHW4IPIN4xxBss1oAEnk4AcTeYtetN46iRY?=
 =?us-ascii?Q?LQQoDLwT+b7CJU/A3ZxoHNqVyCMmZxKx/SbGTeDO8Mf3PvXv0ITn2c1FG4bO?=
 =?us-ascii?Q?AQJcNIcSxV6bctjhnan6DBjpze+oojzp1YTGILIItKhI0Lr4gQs4LKg6fvZw?=
 =?us-ascii?Q?v5K6RVWNd4x21PsWYgkFNDKcVqEmIzqL8yVlUgThEEyJXBWpZmsHaui1cfI2?=
 =?us-ascii?Q?ZyF8mhMXSkE+3bhqvufACkNiABDlv6o5dF/Wh9HezRSzrkigKQKQ36KHYam8?=
 =?us-ascii?Q?UOh6hFovB53QB4ZfxDaOCnSOxGES0ZmjZplMRQKKNXniTA5hJIbXkF0oByyN?=
 =?us-ascii?Q?gP79/1GBcfRJ3WLvo/XlL8DLt2ha2LFudT3uArxxZ6QxVd4iwwYIpC8S0HJr?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mo0XxgTxZjy86ATc8O2HSI9PMWBi6ApHUZxNHnnCgOvbmSKlgOYPAyNZ8zmQea5tw4l0MGMzhxKFEYtB5nJpfiy7YhBUBKuapRWST2eDd/DNREw7LD2YRYTXQpCpK24ObuhE3RdoEfDelI8WYWzAa5vX59zPuePLNZFcQ+g767yzD/5Xn1O1owcJtPkA/J27WuL6h3tmh+CMX0Ix+HNbeT7fgObJZmJJJIkZ1sMKzDr8JijmboPmbLz6CZfHLB+aa62gmuDpuU0o+jHE1KcJegILj4ofsldX68QcZ1N0siNiyRe1XmLjSOnZzFM5xRwfs0YSuqqlHgTyX3rP5J9GR0TTk+ql5SkIcD3q2f72Ymd7OOzTcaq0HLjuhJP/M71tQ784d2BeskGvJThzvKQzqj1WBFs90025mKIQSlG4iK2pgRk2wt6B+2rdmZV5Tr5sa6arfcPyps9sFmyKkli9zznREXqFleQ+i9SqWNM2k8WPjMJwX3ro4rFmHK4/1yO9FFCai58b3P9BUv4sNXlJgYLNCi55zTzi8Qj46gvDd1OdkZwWa2q7wKBFrKOpAPUuJ1i8jsxPsz08xVk/r3HQcmm6/rUOdYDdTEIpTmY3WEo9lPEb3lxIMWkYxRNbzhKUQJeTPvldGjKJU+Uv/eOxHF1jzLPEwm3PbHP/FanIqbt2HZhUcQDGyIoxcYPkGaCkUn0ILNjETCu/cIfx5wfmmAxuY/qkrIFOnnIEvmlPLLXSul3zXeKBJKBAeKynPCmZtk4i6rR1Enx1JzJrvgEDwZec5ERuZYALAyrgtGm2iR2h/0pNLIagv/sX655xtwAJE1MHU8al4HW3YiGpxv0tILnijnPvvLfElKu6netoQZ+qTGYKoXX468T1+HLadMwI
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95242f7d-dc9d-4cc1-7b9d-08dacc3b2d23
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:39:35.9720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uicBdSOoeV0li5QXFbxMgxYrGNaZ3JLApZ52ZwmgDJS41Wyj3gNcMuQ99ohJ1vtzrYszX7jcm19y7EbHwx9X1YEGRfvl60V/Hij6MzD7+YM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=884 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220024
X-Proofpoint-GUID: Cua6ckmNrY6cs9jmIBMh6Z2NqfRXD_Du
X-Proofpoint-ORIG-GUID: Cua6ckmNrY6cs9jmIBMh6Z2NqfRXD_Du
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Martin's 6.1 scsi queue branch adds a
struct that contains optinal arguments to the scsi_execute* functions.
Right now, it's just a nice cleanup, but will be needed for the patches
that allow the scsi passthrough users to control retries. I separated
the 2 sets to make it easier to review and post.


