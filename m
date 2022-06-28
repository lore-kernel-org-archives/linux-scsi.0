Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365E8CCA47F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 02:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244533AbiF1C1J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 22:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244366AbiF1CZI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 22:25:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5844D2559C;
        Mon, 27 Jun 2022 19:23:43 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S12tRo013227;
        Tue, 28 Jun 2022 02:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=wDeD8pdc8nHDDMqO7L2at6TstK7vo/pp/5vZ3IpnV+A=;
 b=NM0qGNI/5UA0Oy5oydZW3SDJ1m3VUv2uk4R2c/WqR0f/eHYaVR66HtrcrxaNfi+0x7yH
 l7aMSgMNhIVrdXUKBRxEEFgJw3yAifSraxsFWPMqB40mGoVLsRzU4LIHjU5yOrOHWBWZ
 i7S3RlVLsoq8itVrCU6FroHf53T1XbfQl7RDxWlsJJZd22s72pB8Zd6uP0XnJIja3xQK
 miQDIhKIaYZQ/U1x1lsHJL7P0o5UrDhIdDb9nufC7ApPOMJTQp2qHN/LxnJmW6ETBoOI
 1rEr0mqpwtomoKBouIJ1zwJCkgQNJZUtl+sETyGXvD7rQ2QkxLWBDekYwQfoZ8t6zUXb BQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwtwu4sya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:23:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S2L1Gr015908;
        Tue, 28 Jun 2022 02:23:34 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt7hr45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:23:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJIk4kI6N+9zIKuA5lMzctu12BSq2nzly/n5z+VgfIa5sAF6wymQDHphPzq81R8WuemyYEXVsF49hKHDeKF6jxB5Yzpx54Ke2kGVQKabXTtu/EkQluwQ38uH0vAVeWjJgx599CjmuS+VSybcJOL6iBZ5gIaP/GFYdHpjNO7cHxpPDLNDdbTRi6Z3o0QjS2ZMYbdd4raA4jrHfQ/5tD/p8tWvrRf5SBe2Fok+kEOWxarjG/xyOdWcEroh1GKge6tVdyG8DMJUh4OJFxo6A3/0Jn6ToDnq5tOKmVTpzvgEqcjpOm/fQGciGqsP5PaahYpZTz1Bze9B4yR7cwREW/SkkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDeD8pdc8nHDDMqO7L2at6TstK7vo/pp/5vZ3IpnV+A=;
 b=Uo50H4ZUIVqzOijoyjKkHqh3a17Ig03UslOxd7UxlUwZxkFhkgnf/I3zVih1pFhTwFvLVwhkud4JlRqanEczICWzPKIG1Yu+Y6Cxa8zAhkpBFwbIHCOyAZaUyp8/xSWjX5X8soX4KfyMSj6hdFrpb+1edVBeoPJ9eHaNeL3zqBxDU0b5nUSLkEJUOpR07IQEujPuPA2amV2A9mCT3+g5HVtOCZjLJKb2kufzfBqpq6THSuRLj028lg3q/67Qfzw8bVQpKsIBqGlZdVFGG+I7b+z5uzMfOxJOG0RGcN3+m+8N9k1eyKcvCwriqnGr2EBBS8ZQjVjbdxkq39kYcZveQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDeD8pdc8nHDDMqO7L2at6TstK7vo/pp/5vZ3IpnV+A=;
 b=fCmJLY6U9Rq9vXYEpvnp/KEs7CPq5MQoxph6PvvcPsitpRZ0esyOsdl9l233mgvEzapHNr+MlbJ4NeVU3IxVHIvsSBUriKJzc8nA0yEWVzwrL52IYrNIDJ3dfpAZR9svVknWRykp/b9HfbzP+fRgdetceHMoaPxUXr4h7SgO3/0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB5140.namprd10.prod.outlook.com (2603:10b6:208:320::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 02:23:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 02:23:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 0/1] target: Unmap fixes
Date:   Mon, 27 Jun 2022 21:23:24 -0500
Message-Id: <20220628022325.14627-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0270.namprd03.prod.outlook.com
 (2603:10b6:610:e5::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c7ea141-4300-44e9-983a-08da58ad321a
X-MS-TrafficTypeDiagnostic: BLAPR10MB5140:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ojJGbUTNfC+J0UNTvxX5mk7jUVYnPEoIeq7T1fsrswkffJboK6yKd7Wof/Gvjk1bMetNwJldFIl3qLMcssmFfXswSdf3nasfGJVJadMu8Eh3wIOYO1lBcRUtExn2Q267u+oJE+xD15g0Lpq2Dnfu0Ip7/IgjZDcrpUPdUf3TSkCs7XDjE5KvqqCdiOk7qQNascz1yJQ5HnSnuLtzJ8C0U+tk29ThCjz/6IOsFPtKy+AYEGM4Jg2u7m3B/V9+w452CKM7OSCi2nNWWUIkJXWJe328upPX1diKsJ0TENb3SSy1EZQkEl2QzlSa96y7TBLrJPzqRnqm/L7NqCpgmxJA+JAx1+1Byg7eo7/AiBwNHRfaa7vpVI+oBhm1hZjmKJ30B2fY7xozFu9GEnIY3Xq7O7sKKHy5ArppzRfqG3bjrw6T8Ic5OSuc/b9suuiCwkpWTV5CvutlFF3ZeOQDQ6rpyRw7kjVQNSPlh0pig8UEyjww3ZuvPmb+3KVcz085L0eZZbiuRnErzwphJcZ/wRRneRFlbsKggECL/KCbiAuELwRg2ZjPYgFRFYs/wRkVJnoO6Rjn0zHU2BTlo64PwPSxRb1C7neEBXNNI0WLUIve66IngdunXBEl/XnjNNvZz1B1iHwnxgRjkIQyDFbp59xgFhdm/yhgpDqPZgjljcZWml5x3YJtu3pY0IWgNNEJUbsyBvKoHl7v0LABB5m4QtVr1GOoHb+LLZkCWdE9etR5Bu6xEXxoSpn2EqyVN5XkSoHOz7huSegZAZha8c9RXOZ//MlF9fa7OOxLMLtUGpdhQRI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(39860400002)(366004)(346002)(136003)(1076003)(36756003)(38100700002)(66556008)(6666004)(8936002)(66946007)(38350700002)(316002)(66476007)(41300700001)(6506007)(86362001)(6512007)(6486002)(478600001)(26005)(52116002)(2906002)(5660300002)(186003)(8676002)(4744005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G72cdt0rPq50wjScFjD8614A8omU0VGS/mScg5VCfF2MVynfgdKGRpE3VTzV?=
 =?us-ascii?Q?Lhn6+aBtz0s8epnp1UQ+643iWxyKC5oDsKWfR2x2QmPAnAB5cvMWige90Cmi?=
 =?us-ascii?Q?ep4srjh2CaHm5fr3if83kEazVPim6k6pdKdWCAuY2bXjeNu7tEESPORg77no?=
 =?us-ascii?Q?iXE8WD+A7XFJnY/WaQ1GJH2F+g00MpYqqzEkx6/IaQlK27HD04AKDhPvpmGA?=
 =?us-ascii?Q?RC7MoW03vOveOznlozqH3Khc6a7EQmFIiTfrvWQw3C1qHWM2Aa8M0/2Znu7D?=
 =?us-ascii?Q?a1dWfkM+NXZgUexs3Cr2f/iBuyTJb8M4V1RYRQqwqIixJvY6QlVerDzNd/hm?=
 =?us-ascii?Q?t4SwkBCkMJC/MyuttYrs19MbPSrn49aI85dCFgbMats5/7aL30VN9kJgKFkk?=
 =?us-ascii?Q?c0B06vkx+qNNg2ExM86obQucyWVJchsPDn7jzW1l+YoVlGtWIxa8I9mM0clS?=
 =?us-ascii?Q?dQPHTz/3PhtzIxpba5l/pC+QoQaZs9+Kqy68Uwxq4HRBe/8gFiQJ01veJtC+?=
 =?us-ascii?Q?x32mDaY2Cb0JmfX+Z9yABFj6Aof2OruXnMbDLZOfuNycL1X9XvrjDQYL6/hw?=
 =?us-ascii?Q?rwn/Q5pgps/tPxqY640zgHxD3CuOHzHpFNWlYcVDrx2L8EGkkCEaYqx0uJ+j?=
 =?us-ascii?Q?ISpR6l+aXAatNpqrVWdgPN0UQmIAgFiBLwycgwrq92kQkphKMGh5vJKcGyCl?=
 =?us-ascii?Q?HrUJ7Q0qVK0p5+JDkzauUPr2vblzRtas3F2rVPPSU12hpMvaZXrz++uvyX7u?=
 =?us-ascii?Q?WfRKs7cc7HwdWcSdudtE9xBTOOw7ZDjTHEQ0XwelkTZITngP5p3UKYtNJj8l?=
 =?us-ascii?Q?/ndquiS757gaQeFQvB8gb40W05tIAiF430oVcsIFzofsjqNQJPTI589dqXYL?=
 =?us-ascii?Q?ZVVQyXq8vKweg0lDnwB2rBu7ElOL5Mx3ikC+cWs7Ts7LTFpGVt4PvYDq7q7O?=
 =?us-ascii?Q?309LKpfMxZDQ67HNXsYmuOFFCNh8KP4BFyyObgFDdoq0wtPy13UosQavNa/h?=
 =?us-ascii?Q?P8FlWVceqoAm3fsLd4jRJoIDWoxMLxoKUIRBO0RDTQ3pOzCjovYTJe0sJhAM?=
 =?us-ascii?Q?emkOWNP3uqJ93bIq4wHonPF6yNbm75tCxuUx+Wc6vao14AhBGVIXh9XV1D8R?=
 =?us-ascii?Q?x2bW5stLT6XXF3V2Xs79Sh1UXarP20O/szDhg/7bY4vAAJNqdRmTDAjwUfXP?=
 =?us-ascii?Q?rBFTWA2NWSq0ZuJ4EIae+stm+MBm6e4RKAhT/nIyTBlXpLBEJfzrtAQBIaPF?=
 =?us-ascii?Q?9eSVSF7gqSMXhBv9B0j9KKU7YpCGiZUYB3vRHdnr0ETazkLfzXXmxa40JKhP?=
 =?us-ascii?Q?Jh+xLMmH/ki+kLK7XFN+8t6uFElZInHKUW0S9y8gnfYHgbsKQ1XQtNKNi/cV?=
 =?us-ascii?Q?Jolwh/VaK36PQve1DUpzsN6TE2g40szp2je6YIrN3Mz+O8Px/P4oORQO0hY5?=
 =?us-ascii?Q?EWtJ3Lg28IRTwtxdnaMsOvJKfyReX0XxNN+rkxI7+uRSo89B9pWaKpPLljpq?=
 =?us-ascii?Q?PAzwpnjOGFPmR0RKvQhviKkhCrQJ0bBB0V3L7CrhapKgv7qUX8mmaw6YRSj3?=
 =?us-ascii?Q?AkOUYUECvIt1p7gCj8aOQl56OKpv3BdfGHKpb60uNdwbMRQDl19mBBzVjtn9?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c7ea141-4300-44e9-983a-08da58ad321a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 02:23:32.1724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gsD7ZLx2ICbGrCSQ/DwtT/HqWizlXuxKflxwdOvr4mNaugIdh5waSku1pO5SRbd88ypguUTSVz6DswxIG6UwhI3xz1J2ubqHZ1Q3M2ZWssY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5140
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-27_06:2022-06-24,2022-06-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=790 suspectscore=0
 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280009
X-Proofpoint-ORIG-GUID: pNafT-W6vPvq2DjUe1eCbrM8c2gtC935
X-Proofpoint-GUID: pNafT-W6vPvq2DjUe1eCbrM8c2gtC935
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch made over Linus's tree fixes a crash hit when we get a
WRITE SAME with the NDOB bit set or if the initiator has sent a malformed
WRITE SAME that does not contain any data out buffer even though NDOB=0.

V2:
- This version of patch only fixes the crash. It does not implement
support. Plus other non fix patches put into a feature patchset.



