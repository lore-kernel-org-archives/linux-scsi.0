Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC416C38A2D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbiJZXXP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbiJZXWr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:22:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3FCDFC0A;
        Wed, 26 Oct 2022 16:20:46 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QMYdvh000949;
        Wed, 26 Oct 2022 23:20:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=815uMnXIpFSTzhKGHlz/+6xiV94IZueTFHTEWqx1cFs=;
 b=uD0+4iDGzPIQuize5TpW3qBLq9dVOofv/8lN4/oS/3ZoPmI66xc1VqVHBLRImszX1NJ7
 PyPVRdv3rcsi0bX5WmNN2qtbvNCHXVCjo76A8ftbUf1/+c5MT07Tvts+y28w+Fk4tAci
 wSuGmo0KlWUV24qIxMMFtRpON1RC16krj2VAksDcrKulwuSQ9lauLfsD2IM7jhixpY0s
 HdgnxeoNNfSojl7b9BxSarBb2xpzrQkhseABsm2sEs62lOPdZKMNyqq8k9VJWryN9O0I
 izB8yTkpck+Jbs74M29jLCqw78BM3SzzsvzdPhj3wFwgS6sFjqtcH/q2gPsR9+3NkZc1 QQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfax7rgs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM4AB4032835;
        Wed, 26 Oct 2022 23:20:04 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagmdy80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsSvoGn3ug33ZaStwu1hpEcGCjQ88Si5/7rIigsfPYPjXHUpnrUvzEos5VRkYfuyuDjQ89PcbYtgJjwHG7VO1QygUR1JqaEnI9Jd9t4srmiQHlkOsOk9ix2aR6qmcG+9nBDpXTQEgePD0CkPtRJcysKpsmz0o2mEgwK6oSQ5NtJZ6T1CvSU64P3n47PTd7bGZLM9f/mr6XZ5s165iSaHZOEjO/LeOc3R0LaeVHvGmtkvfwfU/TcPTiai83Ph8zACi0GfTOGFhA1ALuAtwX6EgBMOkvjcR0dmODNd1P8Z9MdOppQynSItcJtEPlWwuT+iZ+XBE1p8lgIoDSHft8ZYBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=815uMnXIpFSTzhKGHlz/+6xiV94IZueTFHTEWqx1cFs=;
 b=MkyySA+LK4M9d7VDvhCdrEVTbncuJ3plOyEiLyDEJmfqoPMa4VEdoKFrdTZWnC6R64xIf5ykqlUxT5R/zQRiaS9lZybVQntElCgXeqVO3E5vHgsCrT2lzfWHiGI7xKs5Gm4jKkgn1MleIKnp1QKQafJP1GQDSHMzhwuNP4duxA7jeBM4KYveu0+kAWs7BnjFSj+hJYo1voO1G7g0G8zXCtjUD8SK2tQfziuGNJ/istXYkc6ZbjnndPMUFVpjzKNDHdmx0cFxitHMGop90AT4FA+z3BjYYG6igfburvAvwywjhagvCNb3un91xwhJhcD/tosK0wXKN5uza2pLLz3ODg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=815uMnXIpFSTzhKGHlz/+6xiV94IZueTFHTEWqx1cFs=;
 b=0PY0t9KOkxt0YcIrjsGNyDEpT7Tam9YJ3EqNTjWWATG+gd1g8fiU1gzG2LkGamYELXy/CjWnCJBQHBmhJECVYJFOUCtqY3j9SQwHD1UjA8jpspSTE5phhE7OhNWXINcCn0ixZphbQ4kUktPaIGeQX/GHiynG4gNZK6fTIneSogg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:20:01 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:20:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 09/19] nvme: Add pr_ops read_keys support
Date:   Wed, 26 Oct 2022 18:19:35 -0500
Message-Id: <20221026231945.6609-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:610:4c::23) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dd00e83-6b2c-421f-c647-08dab7a89b48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zlJ+9L6oxW5ZfF7UDGCaTrubxalMJJp/87h+dQvbJfOA/pKpbhlhKtV0lJqYrPq88D4AWAgMOo5KmN/JFo/efRFZpuU7Z0ZfyiXFVutlhszrdxv7oGD4qrmnyUvGdE8XiRBSx8CIosRXepN0Wvzcs+QtMhiAquPZDZUiup0tLWAVYyEhuV4xLu933/Fzoz2da4w0Q3tMPWlvKUtMZuqUi9fSwrW+EJWIYKfLMFE8hbikuHWrVfmC9+3eLVfAQ++7nHSofGbkOMgVYZKfPFRSdm0V56Ls5b/NmZOQZ3iV3CCH7V1KCNOE2kpE0ZHuf+4NOk6S0us0GR9WTNpZVWNlR83OUY0EkAdaYgBL/hOrgzNBokxJG3m2Ad0IvRsRAPdA8iG9HOB+ohSFbw+/nkh0Rr83rcLGFNBqBE1GkotH+O1RVUaX02gcrZ61fCRH5++FPRiypPyQmteMh9Ju29ysZ9inHYjl6SWA1UVFItJtDz5RlBTBrCBEffH7nZcH+B0nqrnTdtASo6MRhakiuUVO3W9I4WlJfFFGhwbkqxX6UnfEHhqvwsX+9aL0PiGJ/5RA94i1+ll3TGjwhGuj9vMvK3pKuRqXeoP4D/+qnsHY3QpUxMaQIIbLZGuz1xP4Bp+Jb/L4179Y8HnDxBf2ZbWObPP/lKkZmBmFroH/gsrQu3Jkft+W8XYn6wylBA0HHli4y+nVXIMx1kslCDGDkWq/V/RGpGOPt3COPiJekqlM+YOauFdrCrhcFhgHek5qcLYr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v+vjuYm7bR1TbJVGbElw2cjttoJVyz2v6m+n31N9tmpC9hgk3GTLvRkkiYxu?=
 =?us-ascii?Q?uWFhIH/QoSyl8JdpxFcg0yPU82m+VI5pYWYqOrm3++xGp123X3KJmjH/xFwO?=
 =?us-ascii?Q?eiwxPTQX9pkupC3NPdShObxroDrFvvJna8hfiEZAP3kzh0Jdg+Jp12k/952u?=
 =?us-ascii?Q?iJdjRQhjY4qslgRDc8EJptlRqAeiA6Dn9pqM0ul0Jzs2lVK1h96ESrdsIE0u?=
 =?us-ascii?Q?bhXV+Fqpy14NMZAx0tmOkKBnujl5nLXLO81hjCriuABQe9PFQ0V8XatSJBU1?=
 =?us-ascii?Q?hNzbrsTQmDiJQZHtUHC3Ql+YemikpBf8lk9G7YYmYi3bZhwlMdeBOJoD8kjO?=
 =?us-ascii?Q?feUdWOqGKM3E3VLqwpT5z56gqCYT4TUaJ3rPt9Di3ilD276Z865drdqaQV0m?=
 =?us-ascii?Q?Obs1dl8ie3AB+sreNIOwqIHDybJWQ/egajjg/nc2Nm9hVrCt3rp084BaSbm+?=
 =?us-ascii?Q?6Mszm3jJsSx0JRuWYS0Lgu6rejuUbDRcZDBA4fjDyJYm/y5Z8TR95SvnciKa?=
 =?us-ascii?Q?ThI97eJmNHiBgot1x5h3TW5PGnpVHMo6y73QIskmqqFObU1FATInnY155I5G?=
 =?us-ascii?Q?g2WppQplwmYIZJ80YScRsJ9T9CS/4NG8SSFXHasmAnUZT9QVR43/KsgVb41/?=
 =?us-ascii?Q?KrqOHZ4cOleMFdlHRGbE/HYESIJ4ZQ7q9wHfjHNfdUJJ34qa0fr2Sq29gL4O?=
 =?us-ascii?Q?PwHbRcGSFfDo1c9SkqOBjQJltqEyLQvzGdw1+auIQIAavTIkpf0oqUfFcrJZ?=
 =?us-ascii?Q?n+vGXK4WrJ4t1bXIfM6mab4/UEZ7MQk6HbTn9wQ9R27ZRiKra2BpMH9sPlYs?=
 =?us-ascii?Q?FshIh2qaFCypZVvUzZDUXin94QVws4wMz/iXA0WG5cOabCmftLTNmR2sDgqK?=
 =?us-ascii?Q?jVlxAsMyOW7FV8hLD3E8EnVU3mwgJIv7zIf6HKTXBbwxU0u1pXx9Rp3ZwKc3?=
 =?us-ascii?Q?zuIh2wf8qhujWmlKkogK6Mc1GLIJgF+PE30shwoFjjsbyIXtQNp1HbC3Wjk3?=
 =?us-ascii?Q?QSAjwx60l8HOqjQI1iGHtPbkXKLzBeNU7T+zm36TZVMrDFXwL056AkzU28qj?=
 =?us-ascii?Q?tQKZs/FI9uVzNiMo+B7KiTxqQRM+THxzyWl0bUYaLdJtJYxe0T3hguiPnVSz?=
 =?us-ascii?Q?wtMoC7E4ruTxbv/JveWujhRJFbwKhxTArmKgvcIgbNYmWDp4EfBB1u+/pfdk?=
 =?us-ascii?Q?mfJFKkJf0BXOq+cl3Ka/104VUQC1ymztbs5YDJ79WTI9CYfRO0ydVwJsX+NU?=
 =?us-ascii?Q?a6+LvtpLipZ3Pa4Iv5eJRmgP6BSlEbe+2qtevayOxDIs5t26R56xWEzqw9TM?=
 =?us-ascii?Q?S9Fyfd2/5BMdZ3nc3bPySbzQ/AqPbaov0u4yMEVwoYKCL68d8rEUfeJB8Wt8?=
 =?us-ascii?Q?s/T1TPzvgUcBPGliOKcc8B0mLGv4J1JSxN5OhdMei/HEsH6LvyFoFOdXH2ER?=
 =?us-ascii?Q?XbuUXpx5edm7kZDHGo3aLMmjWuw1hAZw52ySu20uZFtcTDRhB1uxU08CwGTO?=
 =?us-ascii?Q?Hz3mnB//bi/7jpvs6DcLxuEurN55kpGZIG0/B8vSwOi+3dAErn0bEyhZHloQ?=
 =?us-ascii?Q?RrjfxmQQyL9icUeFGxERoA1WSyRBSlKT7l3yMOM27U/y2yz1yPYES3FR60zO?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dd00e83-6b2c-421f-c647-08dab7a89b48
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:20:01.5379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LV2Wqli4bwwMal1FNxjb+BE70uckLC9nAQDUFM5+D4Aq/hQyK8dSKmcf6UJFgXhp3oBHNoP9nXdMWPV6720BDQpPmPmm/00hCVNbC9/PhjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: RmngU_bW92S36lBBcFRLgvy_8KYFxOrb
X-Proofpoint-ORIG-GUID: RmngU_bW92S36lBBcFRLgvy_8KYFxOrb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds support for the pr_ops read_keys callout by calling the
NVMe Reservation Report helper, then parsing that info to get the
controller's registered keys. Because the callout is only used in the
kernel where the callers do not know about controller/host IDs, the
callout just returns the registered keys which is required by the SCSI PR
in READ KEYS command.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/pr.c | 73 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/nvme.h   |  4 +++
 2 files changed, 77 insertions(+)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index aa88c55879b2..df7eb2440c67 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -118,10 +118,83 @@ static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
 
+static int nvme_pr_resv_report(struct block_device *bdev, u8 *data,
+		u32 data_len, bool *eds)
+{
+	struct nvme_command c = { };
+	int ret;
+
+	c.common.opcode = nvme_cmd_resv_report;
+	c.common.cdw10 = cpu_to_le32(nvme_bytes_to_numd(data_len));
+	c.common.cdw11 = NVME_EXTENDED_DATA_STRUCT;
+	*eds = true;
+
+retry:
+	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
+	    bdev->bd_disk->fops == &nvme_ns_head_ops)
+		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
+	else
+		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
+					      data, data_len);
+	if (ret == NVME_SC_HOST_ID_INCONSIST &&
+	    c.common.cdw11 == NVME_EXTENDED_DATA_STRUCT) {
+		c.common.cdw11 = 0;
+		*eds = false;
+		goto retry;
+	}
+
+	return ret;
+}
+
+static int nvme_pr_read_keys(struct block_device *bdev,
+		struct pr_keys *keys_info, u32 keys_len)
+{
+	struct nvme_reservation_status *status;
+	u32 data_len, num_ret_keys;
+	int ret, i;
+	bool eds;
+	u8 *data;
+
+	/*
+	 * Assume we are using 128-bit host IDs and allocate a buffer large
+	 * enough to get enough keys to fill the return keys buffer.
+	 */
+	num_ret_keys = keys_len / 8;
+	data_len = sizeof(*status) +
+			num_ret_keys * sizeof(struct nvme_registered_ctrl_ext);
+	data = kzalloc(data_len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = nvme_pr_resv_report(bdev, data, data_len, &eds);
+	if (ret)
+		goto free_data;
+
+	status = (struct nvme_reservation_status *)data;
+	keys_info->generation = le32_to_cpu(status->gen);
+	keys_info->num_keys = get_unaligned_le16(&status->regctl);
+
+	num_ret_keys = min(num_ret_keys, keys_info->num_keys);
+	for (i = 0; i < num_ret_keys; i++) {
+		if (eds) {
+			keys_info->keys[i] =
+					le64_to_cpu(status->regctl_eds[i].rkey);
+		} else {
+			keys_info->keys[i] =
+					le64_to_cpu(status->regctl_ds[i].rkey);
+		}
+	}
+
+free_data:
+	kfree(data);
+	return ret;
+}
+
 const struct pr_ops nvme_pr_ops = {
 	.pr_register	= nvme_pr_register,
 	.pr_reserve	= nvme_pr_reserve,
 	.pr_release	= nvme_pr_release,
 	.pr_preempt	= nvme_pr_preempt,
 	.pr_clear	= nvme_pr_clear,
+	.pr_read_keys	= nvme_pr_read_keys,
 };
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 3ab141d982d1..5bc9c84dc216 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -757,6 +757,10 @@ enum {
 	NVME_LBART_ATTRIB_HIDE	= 1 << 1,
 };
 
+enum nvme_eds {
+	NVME_EXTENDED_DATA_STRUCT	= 0x1,
+};
+
 struct nvme_registered_ctrl {
 	__le16	cntlid;
 	__u8	rcsts;
-- 
2.25.1

