Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC37FA3746
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbiJZXZv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234336AbiJZXYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:24:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B406570;
        Wed, 26 Oct 2022 16:22:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLFsOa022260;
        Wed, 26 Oct 2022 23:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=E22ybMMBlOSZVinQOvpwAMAckRJcSirCZ7sja8givC8=;
 b=F/3flNJwr4kiUOXX0cU9X5S3Hr9KSmtNfMkvgk3HtLNHYuo3dfcFDQpolG8O7NnBKohz
 KRHxU67oVtHpXyQK2lzZ56u6DQ8HvF4NCe0S0qpggf23n/gkS5OV/5ejsp99JafZzE69
 5RMWIfn1hAXVqpWNb6Z4/Jhd/oTicKX3cvTG/NBE01xjRD/CnNjs1OHiLyVB365UvRB3
 LDmeXUZcaIMmGBrNOvvQrHUSvRKyID3XB+T8nMgDDlRpigb+VX5LF5Jn4JKDZ/2BKrLH
 QSw0O9SeyBuo9Fmhk/Kxe0w2PUpuknMMVIAX7IkNu0jQ/SrLzNjtm8DTtGzFjC7O5AGr DA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahe8n8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:06 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM46QW009475;
        Wed, 26 Oct 2022 23:20:06 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagedtfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qv4V3CDPKfpdiLKrg3viOu55osgDufj13kHs//AlkjOq2mOfBSZUERUwAeVqLBS4eOtzotZqj0MXVw9aGc+R+7lmhK4Lc/OzGxJDi1dGAqUIFFBu+c0vGG+TOgZ7P+qilYtB1D1o3K2r5UixU2QBAbFdXqQzrNZ/QfILPk0zemvnu2grOqu2jhwZLqn40d478LU8G5Bf1YLJSjqfjoHKeVQWWd81OPnXK3BfdfjmFoio06hxTxh6YJteLUY7KF65MuEgkt1dGvL4m7Nf9GCckDs5wZrxBnB/E2yJhutffXJLv82XhMKfu4OWi7lwZAYJkUv9eXSHo4zZRJdfiQ+K6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E22ybMMBlOSZVinQOvpwAMAckRJcSirCZ7sja8givC8=;
 b=VO4UlsW3K07cfh2sy61RFkp8pCCDr4n6+gCHbJx0B5HshHZKfzk3dniX0ZBb/SY38ikJeac/q5V8rqkWj5oF50flHZ8GBrfkQLNtksTipfMe0soqA7wkfBT7M66Oq0jpRf02d64Mx3dvv30bJmmAxhHjnPU1+zZ7WTqDcmDyYvQGOOVg4sb/W9WkSWvf+KhS4xR6QvemMyXG6bBh4KBUAKN+whbKfqerbZQXwZj/5/q6ImGmYd6Ghg+1BDiH0LrnFBCKEaZwj1l3puBD/xxqBY5u91tiiS9eErNhdKtbnkqKMaWzBfuQY0iGvbl2AE5PJcU5STO7oGRdF2w1wLXdjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E22ybMMBlOSZVinQOvpwAMAckRJcSirCZ7sja8givC8=;
 b=e8wAR/To3PJA2CJLEgLhpa9M0hBcDh/xthtReUpBLoJP1ko29+V7uf1VY75FgATk8CxCb5EQKfwwkWn4L7afhVl0h6RutFhGgNfssX4eHYoH81Sas+USsM1tUZusY9ATorpFLVWWWBAf59O22PybQ/8fOkuPP/vmp1N7/FE6jOE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:20:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:20:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 11/19] nvme: Add pr_ops read_reservation support
Date:   Wed, 26 Oct 2022 18:19:37 -0500
Message-Id: <20221026231945.6609-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0256.namprd03.prod.outlook.com
 (2603:10b6:610:e5::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 90901428-e77f-41d4-5b99-08dab7a89cec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F68MeDvrbOutrXL/YTidPwv93FYlas9JOqIZyDKiMKATf/q3rlY4oF0EaCnYfIvHFN3d+uGb168V+xiwu0zCKB6cYfYQEMsXvzN4dnxshQSex5S5ZfFZ0OTghk/JXzFa8w7sRDuV60/NwpXi8X2O7c3GoGdLIzCv7/mXnWrgk2Mg4zl1hplyVRBixcUTtWdV6zJRfVfz9yHbrCNmCWlKZ/PlKXTvwdN/i16CMEgzjcyuYsbo/q8j+n9zn7NP9tPWuzYy1aT5QSlf4rGPTIIQtemq6BccG5EMcUxlspjB+MI2+vZxjWgEc6ix0W3TcqHPM8U8M50hg3lPMDXPqP5QYKimSqv5zzugGbFeJlkGmu5w2iNh+vpVsvxBxdHX5l9sjIvTjokzrWmxchcnoyIqeh19z0gTl497C+QKaPx2WSPQZRa3NI8dPLDSAFIOnMa8TIJSD/k2aSSKdWmSGU9ONwDEJkqeNtqG966lWneL+0T0YlAgAuWQQr09Cp05B6xKF1WTABdeCifSzqC6qwU8RFgVu17K6oVtN+2USn8lKIxlOO/Yz9zQpnBXgiIQ7jlb5SGSou7Pq8zbHPN1aqpSSNR0chUgFTGZ7KGG0HHD7NmWHfSouGBx8vbWBr4m0SgbygT9oMZzOtXWl7vX7kjFx6TgEW1IXxGymti8DeqFA+v2ZO/Y6igTQiVJqgbwEfVAlPtsRh7XvX+Geei+5MEGorbPnXW47reroUjYuSntUQW7HTC9Y6+ROTDOBNKb0Vwi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ko6haSxRTBrC9n3+OIgG4pLzkQYAGFFX5A13UxafLGmIJ69KhnBjWkrix8YW?=
 =?us-ascii?Q?gSBMwk7UXIPH4Z8NtBXX0ukmD4ypRtxA7qOoxnwGVzvuiPOaQJe39f+YnfIe?=
 =?us-ascii?Q?grYHpa9ZDJL/J/+/L/7kXEJVgO8eMzio0iXP0rr/F/k27OtmcWRFf0o7fZiN?=
 =?us-ascii?Q?wLrX6mmQF9CRTI8OiGY62z+twdmFQykAOgZ+MQx2Zrb2aOyq7YOXaQ6eufdb?=
 =?us-ascii?Q?7vonC6RZFk5OT7ieNDZuzOLgm0uc6ZPexaoC1ljRuQ3/gOTKcKHrDYxFvrkQ?=
 =?us-ascii?Q?3+aJIF8QYxOqVaWfE4/XGGnzXl2Uvgl36W/F6GK1nt6puGxrr/IYZ5NQibA/?=
 =?us-ascii?Q?grGAzZOBd3o7f7g8pSVi5nCbsr8pyr2V8OsHnzI71BSZFXs4Qv6LhtOF3J0J?=
 =?us-ascii?Q?6xCHKTm1ajUCNHzLuTqAzrpIW4C5yzvAoWlykwN5ZYrMGIUyKPl5zemX0/Wy?=
 =?us-ascii?Q?YmQKvRMEy7Z0ABY4d0rgb8vsKwUsIdRom2Dpxpq+oKioijethT6TuzeHFGYc?=
 =?us-ascii?Q?Sl9RRZu60NROb3lyFXzrZo0rExs2zB8FWzc68776fSYhddVkB/d1UWP2zbAE?=
 =?us-ascii?Q?fTJumSYiMCUK4Mihvqm+8wDl4qUD/F1FvMT57OiF2eTCWMK/2vmKziFixGqy?=
 =?us-ascii?Q?fxEJcc1xGEg1Kq9ILV+d36krqbFvKp5SzBNgo6iiNSxRCOGl0z5EadbM+s/d?=
 =?us-ascii?Q?iJNI7a3uDK/nB4kkXt2Vg8cXBnbxfsSa/RpSRyjw6abp9lBnodrT0KZeNmew?=
 =?us-ascii?Q?ed3W18bkBpK9EleovW74go8PBauPAEER2PhCyQI3XbgYiVgXmx5n6hMHhEBF?=
 =?us-ascii?Q?RzW2U9Wj1vOwP3tfhXjghVtGS6SvB5UIq6Y2zVWS3ubAqIJmLmwQ9Wl/klwe?=
 =?us-ascii?Q?wza0fBsz1YrGnonx4R0Opqt1DxtOx0qCjy81zS0+Q33JX6pOJd9O4Hoaw0YW?=
 =?us-ascii?Q?9BGIP0qpv9eg33ePzi+eoB/UTchxnUNioAOZCvsD3ZiGvjb2ugywtFnQ5hMI?=
 =?us-ascii?Q?6HChhlPaGB/6pipUgy7Li+I1QP6sAkkpUEEhRo1gETFApEkNPhN15o7HKb9A?=
 =?us-ascii?Q?IvEzGzba4TYnWb8WolUqqDDvNudu30Uh/vjHAcdb8FGxztYIYPIBXJDqdCfz?=
 =?us-ascii?Q?25miHG7+1jyrzr8sRGTpNVgehhgzLEcwZ10mtpEtQpCM+gReWdYgDeNEosgC?=
 =?us-ascii?Q?YVREXjAyibeb0MTgakOsK3BJkmN0+eGHsM0eTSSlZBrgFwftUJE5VTnBn9XG?=
 =?us-ascii?Q?XEm4fTqJ88EgS/M7emNbhqRI4VnWoYXPW79UHc3RIF9x5LA2kysCzfQGB8v2?=
 =?us-ascii?Q?zJqwxO7keVlUy3xML9EKxtd37Movf1g/B2kEacCrp32m16VP/TqsV856NSSn?=
 =?us-ascii?Q?ig+yfIqN1iHP67ahfKUYaoDWMFeFyvarH3KEAOuulVURIIpHzwIoeVuN2Pox?=
 =?us-ascii?Q?5I10VUz+rX8AeAoeuNcTcvqEeFx5hZKgB5IdJTIm6pZ4n6PCWU5fgE7NnDPZ?=
 =?us-ascii?Q?QPkeoJeGETsYN9Weo7bSmj1uQg6YE0yX77dAliQLyZXqrk12u6zegeZdOZWD?=
 =?us-ascii?Q?/WstmHHoxjNgBs/RYEb4qwPXXnr+DQSzmTlzF9R8i0+WKYuvsJ7xOEAaJCHt?=
 =?us-ascii?Q?7w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90901428-e77f-41d4-5b99-08dab7a89cec
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:20:04.3033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IaRw7gk1IryZANayDbwEVn3hSDe6N4U/CBZvnGbYManLLjaiyHortr4uIqSVVqjVUVgH5vZvXlK/5DK5xaL5WJpfVo+tVrWhMiZGBdjh7lU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: _K14-oyEsiM4ZPOdDZQ633md61V3N2y0
X-Proofpoint-ORIG-GUID: _K14-oyEsiM4ZPOdDZQ633md61V3N2y0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds support for the pr_ops read_reservation callout by
calling the NVMe Reservation Report helper. It then parses that info to
detect if there is a reservation and if there is then convert the
returned info to a pr_ops pr_held_reservation struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/pr.c | 79 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 5c4611d15d9c..87a0aaf811f4 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -30,6 +30,18 @@ static enum nvme_pr_type nvme_pr_type_from_blk(enum pr_type type)
 	return 0;
 }
 
+static enum pr_type block_pr_type_from_nvme(enum nvme_pr_type type)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(nvme_pr_types); i++) {
+		if (nvme_pr_types[i].nvme_type == type)
+			return nvme_pr_types[i].blk_type;
+	}
+
+	return 0;
+}
+
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
 		struct nvme_command *c, u8 *data, unsigned int data_len)
 {
@@ -194,6 +206,72 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 	return ret;
 }
 
+static int nvme_pr_read_reservation(struct block_device *bdev,
+		struct pr_held_reservation *resv)
+{
+	struct nvme_reservation_status tmp_status, *status;
+	int ret, i, num_regs;
+	u32 data_len;
+	bool eds;
+	u8 *data;
+
+	memset(resv, 0, sizeof(*resv));
+retry:
+	/*
+	 * Get the number of registrations so we know how big to allocate
+	 * the response buffer.
+	 */
+	ret = nvme_pr_resv_report(bdev, (u8 *)&tmp_status, sizeof(tmp_status),
+				  &eds);
+	if (ret)
+		return 0;
+
+	num_regs = get_unaligned_le16(&tmp_status.regctl);
+	if (!num_regs) {
+		resv->generation = le32_to_cpu(tmp_status.gen);
+		return 0;
+	}
+
+	data_len = sizeof(*status) +
+			num_regs * sizeof(struct nvme_registered_ctrl_ext);
+	data = kzalloc(data_len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = nvme_pr_resv_report(bdev, data, data_len, &eds);
+	if (ret)
+		goto free_data;
+	status = (struct nvme_reservation_status *)data;
+
+	if (num_regs != get_unaligned_le16(&status->regctl)) {
+		kfree(data);
+		goto retry;
+	}
+
+	resv->generation = le32_to_cpu(status->gen);
+	resv->type = block_pr_type_from_nvme(status->rtype);
+
+	for (i = 0; i < num_regs; i++) {
+		if (eds) {
+			if (status->regctl_eds[i].rcsts) {
+				resv->key =
+					le64_to_cpu(status->regctl_eds[i].rkey);
+				break;
+			}
+		} else {
+			if (status->regctl_ds[i].rcsts) {
+				resv->key =
+					le64_to_cpu(status->regctl_ds[i].rkey);
+				break;
+			}
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
@@ -201,4 +279,5 @@ const struct pr_ops nvme_pr_ops = {
 	.pr_preempt	= nvme_pr_preempt,
 	.pr_clear	= nvme_pr_clear,
 	.pr_read_keys	= nvme_pr_read_keys,
+	.pr_read_reservation = nvme_pr_read_reservation,
 };
-- 
2.25.1

