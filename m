Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175B5C25B0D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244457AbiHIAEu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238298AbiHIAEs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:04:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DFC17594;
        Mon,  8 Aug 2022 17:04:47 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NwJlD007174;
        Tue, 9 Aug 2022 00:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=znCtJiRiTBEZY4u6S9GahsjlyLfZbpsDVKGBX7ls5EQ=;
 b=WaTmr8/zRQS+88mwMR1sdIkjk2YtDO7BzPSp/+0G6g3B39hiye5ZaYeLgNTrhHUl89x8
 VsywhmSbiHeyu9/bfuhTnOTMS2mgx09OR+vjB2gmUclR0Vqcbvpgd6JiSis7ZXubHqSX
 tIzHWFbUQSon4jQCL5bagUaFPkF5GsqP0F+SgcA3duSbTlqzlDQXRk4eL2SkhvB8Gcxn
 APqSZZXXTcNUqOkNVK12L5DySgkMdC1urxxfhSGnCh1UMaY7rVMIHHyemKS7wKO7I1cf
 m+E1i9XzH+3McsjlrBhvXbBuP3LuYUG8Op2tnLAziiM1KSOlzfOeCtcgyDETSCglIaIJ TA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsg69n1d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0hsb032829;
        Tue, 9 Aug 2022 00:04:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hser2cbnw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dfy+VCdsMub5W+j3q3zZODUcy3in7ZMhHA7PQniFRo257l8PkxwqGKe+KmswegIu4Jw6Gpruf0qdcy3M1gpaqKUVonlgMBRdziXYqESZfQ2Ua239optkD+A304ywfnbMO/s7kyKWpGoXidVmsCI9rtyhcE5Yz/kWyzXaFPr0MWvgZnJzB/zbcMsQ20SUtrg88CeeB5L4raZDmzAfv9RQd63Gsm9M8znAyLWWZvC8YN8QPdLvWHpqWVMlZwNBgilmCtelf9zIcDNkn7rk+SxEZYRT2Cw9+W/VxdXEauH5XPdE3pWAj50n70NTgJSJBGJqNY16AFsWJmDsU2bCJpcpcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=znCtJiRiTBEZY4u6S9GahsjlyLfZbpsDVKGBX7ls5EQ=;
 b=YrNQ99JQs2wbk2n0Ow3E7bm5z+g/bp6hRHlmC/PZw3YUonn7Kbi040CW+Xiyh3gnjOts6ByiijP0HcFdVY7cuY281XiCsgCgiICeQvQ2jv9qqV8Ud9/88X45e88lvqrcQwDeb0vOA7VeVWTvlPSlGe40O6ZuMNSig8pqthy6/JBrNRK6wUPBPhMk1ft9Gel+XOBHw2Ya4PN8MTFU6fT1kaxoP0cHxrJgqXpkXPZx8/l7QiXKUBAmfsEIArXop72zXCouhab+yRAGVywTQsQErx7ROSRmJ4/iODWSFkNdV38HNn5fYyVDLxiUAx4FSAwIxmfQkfmcPw/a6RfVDF5sBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znCtJiRiTBEZY4u6S9GahsjlyLfZbpsDVKGBX7ls5EQ=;
 b=x5pkMP9ByxwVr/l5PmS1B7YQD0tkNTdGV6xe04y3qXTZ7qAcDD3mrPayckUQkbPViCjW5bQ++yU4NURYK1kudv1VDxVd3Md5mta6JZUx1XE45pFfzD39q9BbBRRsoeaAgJWlTtyMjaytTzGaPYHZAXM4vNglB+9PrsfbqsIMurY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:23 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 01/20] block: Add PR callouts for read keys and reservation
Date:   Mon,  8 Aug 2022 19:04:00 -0500
Message-Id: <20220809000419.10674-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:610:38::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8123884c-29a3-4ac6-1225-08da799ab710
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZwP4yV1pR/3z8r+5lJA38aDQk1xZHPIawUbA5SFi1+g+eCsfE00eCeUS7wAn6QZ+6r2C8AUyGHZBIuZWXHKIVfP4xgD5mq91OvVB0ezigUGJ/YLvUlqGF61IRt13eR14nPiduVXtcF+nklNY6VHhI7CqXoxHtt+NdKf1lEMBClWN5gTK5AJGYxPAzfOcYxW1XZOFIHIU8o7yWChkZg9+0hmbeL8NyX4bRx9rwZdYvP2BzXFsuu4IkLUFhIeTMwDi7KFZR8x7InsNuRYI3Bh1HJK8bMvxeEHPoDQCytRDCEUzLc/i3Q39L/g/RgGmah9fGzgKAc0s4FOowddDrxt/6VtlVveUkgf6tRNqRjNvMi6wLnyuywIU4ygyfF2nIAbEPzjrUu+45UZkGARJvFxfy7lDBYmHEtnERNyYzr5R6m4D+X7mYQeH8v6Qz2DQUq/nRTUKE8DnETPLeEjEFL2H19bHqC3WlOeeDqd+ZCEzxiBZBXwrdpts3vz9IHNQrQI9AgzJ7DMEUegN/vDfOK7FJUzG0JM8kPpb81+nUhWgbbRdPFAOSsYECddQZfYQLffNbTQMexYmOSbKNew3rLnEQemYD28zjdTJsvZN6VCtI465i5/4hk9Hl7b6iY8FDNEHMlXXNnOsJYtvpAjyyI8o2RTEFBW4aLapcwF53239FRjQtpL1mHsCQXARPymyFZQcZgwj+KtGIyeyGCs4BDGmaVANaGVuJ2pzemZ+BH9NV4QFjxnVEzs/vn+3wO2JUkhI62v6fWeDJrWj6J7rjY56bDugSsbSFg1VC3QLSCUGo94=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g+vI3MMH2s1WqLOlbVq5cYUzDX9DYwtdgQbxTx7gK2AS8OtDeBK1+2VSMXl3?=
 =?us-ascii?Q?n7YdFSaUb020Y24tsH7qiIZX5ketq4IZ7A2ZROu2zGZBR0Bvzn608HM83qlN?=
 =?us-ascii?Q?gpM0+r10uaarMs1dgfDAtudmU1KrwmxN4zX4QmAYRGJ5mU3NYM9HR2G02gbj?=
 =?us-ascii?Q?YRv2ETcOuX+BZTO8dWD9+FnTqIU3QpRgkBA2QdifYJB8YGO/etM3MvxCE8xs?=
 =?us-ascii?Q?18WwZw6AzSnF9VSMXhlyP9rbol8uipv4G2p/X6MeQwppZj8BqZa8zWOzkiZi?=
 =?us-ascii?Q?QoYtcyC7Bwe9NjS16Ig0S5d2jX3a2pD7BXyiPQV9IAJOhgbimpv+jsQEqmFT?=
 =?us-ascii?Q?nDL8kOi+cybg9w/C09gRFCWY0IzZTN2bwrVvOziW4hSB1K6bu4uqWYejOchc?=
 =?us-ascii?Q?E/nFKbssqLHHQ+i00F27ybzN5qwdvegdS1Ena37hztTXEnx57BF0sIXG3+rS?=
 =?us-ascii?Q?CjTxYPYbqm/OYN0GnkZ9eEClMdXjXfgtiWFLoAyX5ZK8hW4eKtct+Wfd+Tdh?=
 =?us-ascii?Q?U/56Bix8RwAMvUxtPnaQifn6vjMENaCkWy+7+JUYJtRQdj9OYSV0PWwkmovZ?=
 =?us-ascii?Q?YNJnclHwp2KkC/7r1o7OnKX9SK3RRVelpbVb9MwLJBmisM/oKaJnVLQyHuJw?=
 =?us-ascii?Q?QQUgg6MofidXGS38LZHej4m4lYSGFghYujiLrJGoj6r2fXtTrQl/qdZkfJwD?=
 =?us-ascii?Q?WDjUTYqeYaK+jEv/MB5kOlAZt5Xw8CtJVl90PMB+WKeE9GHpFq+5oR4llyjf?=
 =?us-ascii?Q?o7pemm1kFWgk5YOizXbXZew4j9YZJG6SQ7tuwLQUUPyVakX0mkfnnu0EanOS?=
 =?us-ascii?Q?ljv6eC1S12+LZwc6IPOg6CmyFr5BH/0lMjGq2QieQN0C3O1atNAQ3gK3iK6S?=
 =?us-ascii?Q?A7avS1KPicPaTV//hIwgfCNgwI6ta+nJMXrIV/uFX+kJ7g/O/SH8w4Mf4HXX?=
 =?us-ascii?Q?5Jsc6wBFYSXCBhYEEMUb/ARBZTT8tHPjs52nZOTP6nuqyuS5TkevOhy9f+7G?=
 =?us-ascii?Q?HMbkPbC0Il+laNgKnlBrh1OmdZJlLAF4GnLQ/wBIxM0O0SaLio67Vd5E5UjG?=
 =?us-ascii?Q?PTvwdgC3o6YYHbhCoyaer/4MHamKeEQSRwo+7ivwEhTU0xWl5egQ/at5lzJW?=
 =?us-ascii?Q?F9LT75RdconH/lT4F7+uHRcCtOTjG0vGzdP13CiZwiWkKXkuuiUBeKJ02Iij?=
 =?us-ascii?Q?hcW9oALh2+S563Rcpg3vJuG7KaOlNEKPwxdYeijdP7W0lqaDHtsgLFDukaaJ?=
 =?us-ascii?Q?9XIFkspm3lgt9CbJzeb1LEMqq96oGPEyk4Wr4XcQ/RoFX7yA7wgXc79wWvp/?=
 =?us-ascii?Q?s6Wm5XAOQaW7Y7s29cz9YU45crBqzVlhtZA74skc3Pv0Evn4H9/0Hzu3mp7o?=
 =?us-ascii?Q?YQsZUB4VOd+JRm+momYJsFvL/4Ef6naeje1h82yQuSPMBoXQHh6tD7z5kDBl?=
 =?us-ascii?Q?7lysS2JRJqNWOFVZ9U4Bu77IpVLapGLp/nbp1/IVhNil4+N808DbdoPkjwEa?=
 =?us-ascii?Q?uA1xsDFzVGRZY1ZSx/cRlafXz6PJz5p7zDwpwbh8rH3PSsnc9VexVL9nZrhS?=
 =?us-ascii?Q?mYxUJJFEOhaPHodIDpMhhqJh1W4GFGvPAfYCr70ODJWl89LyWijxR8p8NjZp?=
 =?us-ascii?Q?ww=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8123884c-29a3-4ac6-1225-08da799ab710
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:23.1273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ofT7aIcOQgOIWgC+6iDF4OYBWv9ObyQqcf6fmkRtEsU383EhwfqMK3MiGicczbTJc6jJuN5j2kqxj517gS3xa9bl2gUFrfDuRnr4GSZ4ZCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: kEnnU2xUAS40oK5N9V7RK2G4FHB5Yg87
X-Proofpoint-GUID: kEnnU2xUAS40oK5N9V7RK2G4FHB5Yg87
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add callouts for reading keys and reservations. This allows LIO to support
the READ_KEYS and READ_RESERVATION commands and will allow dm-multipath
to optimize it's error handling so it can check if it's getting an error
because there's an existing reservation or if we need to retry different
paths.

Note: This only initially adds the struct definitions in the kernel as I'm
not sure if we wanted to export the interface to userspace yet. read_keys
and read_reservation are exactly what dm-multipath and LIO need, but for a
userspace interface we may want something like SCSI's READ_FULL_STATUS and
NVMe's report reservation commands. Those are overkill for dm/LIO and
READ_FULL_STATUS is sometimes broken for SCSI devices.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/linux/pr.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/pr.h b/include/linux/pr.h
index 94ceec713afe..79b3d2853a20 100644
--- a/include/linux/pr.h
+++ b/include/linux/pr.h
@@ -4,6 +4,18 @@
 
 #include <uapi/linux/pr.h>
 
+struct pr_keys {
+	u32	generation;
+	u32	num_keys;
+	u64	keys[];
+};
+
+struct pr_held_reservation {
+	u64	key;
+	u32	type;
+	u32	generation;
+};
+
 struct pr_ops {
 	int (*pr_register)(struct block_device *bdev, u64 old_key, u64 new_key,
 			u32 flags);
@@ -14,6 +26,18 @@ struct pr_ops {
 	int (*pr_preempt)(struct block_device *bdev, u64 old_key, u64 new_key,
 			enum pr_type type, bool abort);
 	int (*pr_clear)(struct block_device *bdev, u64 key);
+	/*
+	 * pr_read_keys - Read the registered keys and return them in the
+	 * pr_keys->keys array. The keys array will have been allocated at the
+	 * end of the pr_keys struct and is keys_len bytes. If there are more
+	 * keys than can fit in the array, success will still be returned and
+	 * pr_keys->num_keys will reflect the total number of keys the device
+	 * contains, so the caller can retry with a larger array.
+	 */
+	int (*pr_read_keys)(struct block_device *bdev,
+			struct pr_keys *keys_info, u32 keys_len);
+	int (*pr_read_reservation)(struct block_device *bdev,
+			struct pr_held_reservation *rsv);
 };
 
 #endif /* LINUX_PR_H */
-- 
2.18.2

