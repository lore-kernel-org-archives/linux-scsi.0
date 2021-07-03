Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1509C07E97
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Jul 2021 15:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C43161628
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Jul 2021 15:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhGCQBO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Jul 2021 12:01:14 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:7108 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229818AbhGCQBO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Jul 2021 12:01:14 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 163FvdiM026365;
        Sat, 3 Jul 2021 15:58:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=UxvV7Y5lbzIHaQ51nr+xHb8+1GXFR6/ccwT+mDoysJM=;
 b=I9SDfH/sLBEiWJ8SW7T6DxcC2u3Rn069FGC4mruPmBJrLCWuupetS40l2rC0oOKu4Glp
 w1+y9+Tb5Ly1c4g0Khhd7l4xZ4MV2CLCbYhk6DZrDg4uANVdrgywHzYzYt+iGE57bQTb
 ilmx27msXpAAA9sAaww9eZwCqtcQnQA9aytnsPpSSQvGjZn/OX1X246MgO9V9ioNQYrU
 s1NvNKZPWW8HysU8HqwM56qOnXks2MShmB6Pwwg4hQos3rAtOULsbhce1pbXuta8WgqM
 1C0F03f2+h3CXHmeGcaO37OLcwK1FurnHtGi46e7ARf92pQnPBosOJycF6RxDtInPDo9 UA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39jeacgh17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Jul 2021 15:58:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 163Fu5DA133773;
        Sat, 3 Jul 2021 15:58:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3020.oracle.com with ESMTP id 39jfq39u37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Jul 2021 15:58:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8zE7NUd0VxWhS9BfnrdXnb2W9+XFjFbR7HCYZxYw/O/JABnxaeINoAPK1VM6rUx4PETE9HUXdBkcxcFtXKoPgfRfkbcIW1ltHECYtGym7uyxROkFE001xFil33mWdc/wjR8n0AVC0So8+B40Ce5rf5HmrAnznIVB9GdnTWRK+h0QQ6kKRJojH4RgoJW1MrbTF4krgYM88jDr+x2s/jwzoSpNGo/Gokpxuc9+vzhWLydEmJYVHP8miuaITLU7q4Xu0doxyr6mVV4fcf7+pvoPgi79z+Ubeduhfln8aX0xrUPFNdkhVash2F7Oh/C6oPTAlDAhcddB3EM4L0gJThEwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UxvV7Y5lbzIHaQ51nr+xHb8+1GXFR6/ccwT+mDoysJM=;
 b=DGBY30R3Q40A2SvjsS9bkuvlode/9sb6vYTck4H8fv3h2DC7WExBVoBd3x79CPJmq7y5X5y6jmQ82CXzK2lzg4DgfvVxJhAvv5KcJKsh4YVLwvLXrBX750R/7GGwhWlR1ThxGS7uvMRdHtODWt+ZArsxXpoSEiMQ4VvyIR4uGEbMIPV3PwwO3HK95FibdoK9dSXW34OOuxYzUTZIHhJdczPJ13rIrHklN6kTme/Q2ECol+rxl+OHNIOaLwAqbYW3MUp6BrlLvkxnCeFNsN9yu4h8ZVmU8E9F2lcWu1bAgRLSqpVxAEAktJhmC9WASgefKhjHM2f8QwYqbLNKaJgkbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UxvV7Y5lbzIHaQ51nr+xHb8+1GXFR6/ccwT+mDoysJM=;
 b=Yueoa8rO3CO2yM4zeuIfLsGQXbs3zBryW82nMpZ7K/sDs2pm+lec90Xg7yPD35g/41TUgclchaTLmFNGg02DPjkT2ysMQn8u/vb5WDGEn+BMMszA59T+kFF1igjCemEGnCLqxL1ql/W2DKXqj7ws6yhmeCH14h2rR/Z5um58Fdo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4725.namprd10.prod.outlook.com (2603:10b6:510:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23; Sat, 3 Jul
 2021 15:58:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Sat, 3 Jul 2021
 15:58:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, torvalds@linux-foundation.org
Cc:     muneendra.kumar@broadcom.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: blkcg: Fix application ID config options
Date:   Sat,  3 Jul 2021 11:58:33 -0400
Message-Id: <20210703155833.3267-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR11CA0200.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0200.namprd11.prod.outlook.com (2603:10b6:806:1bc::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21 via Frontend Transport; Sat, 3 Jul 2021 15:58:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89430cee-3e58-4788-7115-08d93e3b6abd
X-MS-TrafficTypeDiagnostic: PH0PR10MB4725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4725CEE4DF1BAF816FF8AA818E1E9@PH0PR10MB4725.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kzDpiz9xPEZEjBAxInHEOPBHySijdBvPT9S+wLY8ER2JQdtDCPlv4nks6OIY/sQmLQkfljsnYykmi5RrJqbmDRlKVfgBd09EOlh4FderjXSMXcuspm/PdHy8ekXxaMDzeQXHLzorjflX9iNp3kxnDgPPYBPKwLVdhEL+Vwgi3BAdX7eWMtVzIjtLa1HQ3GKvRA9GUeHXcPchFL3kgo9Tf13CYwKRz7VXsKpVEeS3yMP3abkjO+MbRUEuL0uuGccoJLo+5aN9Lxx777Or3YooB/ACXRWFYGa0mT4StwHoEDED+2uzp+KhUn4h9oSFUFG0cmarFxj9wYXlC2lPpP8s8Thb+U7PTfWpLinYkxs/j/mE5ceELYQhTmbJneI0RfPTK5mlRrlheMDCYd9+VSIKxR6fWAsWbJvOEgUUmA+3uBUiiLUdCIYfVAKQsjsyYOmFTQzK3+gwfX49HiGbjITKFPQCZNqzqQjZ75nxMUtghczlQKcx+elBTEZB9yb5+QKIo4di7ZH6Phl2XIXAPZoSDUygE7dTX6uhL6jsUtFkPcO5UAa5c5nitzL2vURCHcyCMRdw9AYu3DnsnrXuDU7s8JJX2SQZjL094tcN7F1Knam7hSK/Vxd7gBur46LCbBM+Vveisefyfm12ENnoEBf1396cWaEwvxjYPvOYJCPTdPC2FVBqIxfc0ieV08fLGd570euC+aQF06FCqe3n3eVsSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(39860400002)(376002)(136003)(107886003)(36756003)(6486002)(956004)(6666004)(316002)(2616005)(8936002)(38350700002)(38100700002)(1076003)(8676002)(83380400001)(4326008)(7696005)(16526019)(66946007)(186003)(66476007)(86362001)(5660300002)(2906002)(478600001)(66556008)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KHm2IxQTrHBRwIH2JjaZxL47F0aSAjlarKt337RAYKJY6iEWq1MyisOuchwP?=
 =?us-ascii?Q?NGFUZyk3ewsClSM6Y/Jz+mHOeBH282NEJ6hPO88Zw6Ai7h8pjC7gXM9BFz4a?=
 =?us-ascii?Q?pmPxBJl/X6efzFmJ0LFz0Q0wGuclHps27/sxa/k6nOTlFA6TJPwHcQfViyBa?=
 =?us-ascii?Q?uBfklQRICY2YflnpIfY1fDI3rrsvdOisRFPl0Va0wVRE+Duq64DE66iiMYLk?=
 =?us-ascii?Q?EYNyp8XzxwFC80B076yUEZiYkdqgdnyBNu5SSGT/ZQ0zZ570YqnPyEQwg9W5?=
 =?us-ascii?Q?Mh/wF3PMWkOi/+7YezePl08jVQkYBpManYX3hsQ4mdjGcMV2srOhGb+/D4uF?=
 =?us-ascii?Q?r79razJCMNh2nxCCkB9LBQ/A/WLq3q5Ew2850mHLs+DPmNnMHFg/q7fo82eI?=
 =?us-ascii?Q?VlIEYzu6ecEWA3atAx80rjJWMFrjU4PXChXlN9I92yLi4g8KcCyE/HiGcT32?=
 =?us-ascii?Q?0uMDEE5dlSgKZ6FoiMSDofrX1hQOv7JmvjLO9hnYliBYhbMo9BnCEKoymKy6?=
 =?us-ascii?Q?aCPdo/cTwIuGSTf+psZBordbR263Fys80CwrK7Dfo/rxM4r4FJCqay8uSlqB?=
 =?us-ascii?Q?WXWlHcFlG4nna7SNex6L3rOyWvRnGgIZKPjen88KB2gVHVi7/6YybBWSEf0u?=
 =?us-ascii?Q?8MiHbYqsoQrpJcDDidBukYmZKi76Cu0Y2XTKhgl0iVGxfLC9K2z0yznxl8H4?=
 =?us-ascii?Q?Y3ictpk9ungvM8MiPQIIcQCzPBwwWzgEeEZwlmjwE3Bcpy8wZaTrywpft+DH?=
 =?us-ascii?Q?TFYPOY/hMGZ6nUKnNIYiEq0YTHrFd9z4bPpm0B89u4XHVjm2/FI+Xllxo48U?=
 =?us-ascii?Q?4kYPT/t/6uQVK7fjh28zAa9XLZ/tGy7PPad937bhEiKPGFsQR7zzssEgLvLo?=
 =?us-ascii?Q?ITZdKvtUDJBlEXYOC1e30Ee/IhMJj2atdh4jKhrlR5+SAZPbHjWbL2LJYeEb?=
 =?us-ascii?Q?b5KsJO7Xfm6H5yQA/0OC2CRuQdng/eVT47Pdw6PunLdHuptcSBgs7VdQtd24?=
 =?us-ascii?Q?/VcuoyquJzNJj92O9E7izQPON5jPcLAifvcsmnkwgwf5e+d+tGiZXR8rDzaP?=
 =?us-ascii?Q?ASBBYtLlceMb42dziB7k1sMU0BFu/k+MN7807ikyItOUOUVuvVEYj9VioJDM?=
 =?us-ascii?Q?VUDpBU0urOUHqgDI6iLjle8D+3q05Fe2rZVHgOZkkfgCYLlmGORFEpjZvjDE?=
 =?us-ascii?Q?PmXNyixIbKG1GykwtYyDh6v5Q7Gy9lWviLyFGWVKxBinJxvmYw3fo8a1KpNu?=
 =?us-ascii?Q?FnLnU8vsMoyKTJlQASS1iTZMAtofDaEneqBa7NgU+mbO/zZC8x9pMa6KOApj?=
 =?us-ascii?Q?MPFG1g7U2Tan9tN5Hbe0KkjD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89430cee-3e58-4788-7115-08d93e3b6abd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2021 15:58:36.5842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: japgoeXI4iqHRU0MTv/XzdXD3rvRSD6Uub52Gkq/Hxe3ldG8pHsHYDBaQWxy3e4OldhuuPyySD2P8sh1J6GqlHboqVu/JTJlj6qJr7gt6x4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4725
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10034 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107030101
X-Proofpoint-GUID: qOyMy5DjBNGy3kXOsuM9cGd-MFnFB3wF
X-Proofpoint-ORIG-GUID: qOyMy5DjBNGy3kXOsuM9cGd-MFnFB3wF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit d2bcbeab4200 ("scsi: blkcg: Add app identifier support for
blkcg") introduced an FC_APPID config option under SCSI. However, the
added config option is not used anywhere. Simply remove it.

The block layer BLK_CGROUP_FC_APPID config option is what actually
controls whether the application ID code should be built or not. Make
this option dependent on NVMe over FC since that is currently the only
transport which supports the capability.

Fixes: d2bcbeab4200 ("scsi: blkcg: Add app identifier support for blkcg")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/Kconfig        |  2 +-
 drivers/scsi/Kconfig | 13 -------------
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 03886d105301..3923ed732ac4 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -146,7 +146,7 @@ config BLK_CGROUP_IOLATENCY
 
 config BLK_CGROUP_FC_APPID
 	bool "Enable support to track FC I/O Traffic across cgroup applications"
-	depends on BLK_CGROUP=y
+	depends on BLK_CGROUP=y && NVME_FC
 	help
 	  Enabling this option enables the support to track FC I/O traffic across
 	  cgroup applications. It enables the Fabric and the storage targets to
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4dc42a8ff71a..8f44d433e06e 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -235,19 +235,6 @@ config SCSI_FC_ATTRS
 	  each attached FiberChannel device to sysfs, say Y.
 	  Otherwise, say N.
 
-config FC_APPID
-	bool "Enable support to track FC I/O Traffic"
-	depends on BLOCK && BLK_CGROUP
-	depends on SCSI
-	select BLK_CGROUP_FC_APPID
-	default y
-	help
-	  If you say Y here, it enables the support to track
-	  FC I/O traffic over fabric. It enables the Fabric and the
-	  storage targets to identify, monitor, and handle FC traffic
-	  based on VM tags by inserting application specific
-	  identification into the FC frame.
-
 config SCSI_ISCSI_ATTRS
 	tristate "iSCSI Transport Attributes"
 	depends on SCSI && NET
-- 
2.32.0

