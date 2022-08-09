Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2889C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244683AbiHIAHC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244653AbiHIAHA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:07:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FF81A3A6;
        Mon,  8 Aug 2022 17:06:55 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NweGJ020677;
        Tue, 9 Aug 2022 00:04:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=0IJxqGdCy6ATwvHsBIbo+54ZvUbeTYpa93O97vsfRdw=;
 b=26tTTFHACIXBTVuzHkL+iRl+osZ5VZFCISO6gg0WjDH2L2jKvSd45hjxwRL1yWGUZpPJ
 JWVzBei7n+xqsbKKFM1bwUQzg59iQtq3bxccgRvBB105mRcq/sqNN7URjsi9Mb4YjuBS
 x94xEWt7o/SP7wwgqFzLiYlL4Fi9zAeS4Sa8GtWd7txGU/hiNO3vtQgvU7CQMWcrYe7X
 v8Y6lr5pUJufPru8T/9g8Zqkr15JHU4NSA1up4/mTH8cdDORckv08VezoA3Plqh6Fh55
 mFd/qPp+XriL1/I60AszVJ9flAVvFya5Qfydcw87ilD81LMluJsI/SosWxscOaswfTOc Gg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsgut53aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0hHn032800;
        Tue, 9 Aug 2022 00:04:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hser2cbrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wqs6oNkpRhdqlLGvnPXYm1fCBoZ/E9uXZEEFhTgiFKNu09nre4dCQyA4PAagMQRk7HbDo8heDjP+M44yiCMqorlV5FwgR1fxY1JkaoCOU0thlarkcgdV1Cv1BKHxBYHDcfVveh8UrT8hgN6j6a8rXXv/ulWhrcQfTH01TpIvl6s0wEZ8AfN3teqaoGffcnM9y6ZiX4owKLP5W7CEmZfm6WcmuvGFJLQ/+Trmbk+Pjk16ba8OdXmm4E+7WySqYteMDcKGnW6PswUgGyWvY3U2eQuZeB9RAENwFHt2itlOP5DLUZXuU9Co5V0Gc9BYyWh0c8yU+X39/3dSmvCYEgOZLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IJxqGdCy6ATwvHsBIbo+54ZvUbeTYpa93O97vsfRdw=;
 b=MI7sbP6Mhb9febpmGh7bgL43o5KZa1wEtf8xA2/Lox6vASWahwZcgtNwAOewFP4qQD8FVFX5pxVeS2694u5FFQgQ9baRGqvrrOq126ZmFyu6UuJYSHNQrSP4eAEuXXiH2viiTxZKbS69IbJfSAXBq/1H8nU5Os+88S7XwQ+5Rd0/VesCAWeKnRHpxxMgHDI2e4NgaNFia+I9FHyzm30eHRnHfsJlDzldNxA5K5wVx6UsR0dNB/H5n+VYQ7qbiLDUPBlP9spYt+OgBc7tqUWS0C8Xw/hRvIbng+1o3SoPUj7bw4MjmJ8FeXjgTlwFKAz5EElQYA1T5l3f7r5W55HkKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IJxqGdCy6ATwvHsBIbo+54ZvUbeTYpa93O97vsfRdw=;
 b=BbnW39yF3x96wdyjjVBvF/XWqMoa5E6MCvxLIMSZe1gp/P7a9WGIvWmVbt5AnOjmXAcBROFmvSTJ/zGn/tynnYNobPtEguxZG8S+atTXjDy7Q9uXCrVWxySRpn72fxqk3Xx0U/3nFmJGm2zH/484957HIKLmWwwnocujVsTjXMo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 11/20] nvme: Add pr_ops read_reservation support
Date:   Mon,  8 Aug 2022 19:04:10 -0500
Message-Id: <20220809000419.10674-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0044.namprd18.prod.outlook.com
 (2603:10b6:610:55::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c50eed6-b28f-45d6-7306-08da799ac062
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cYaXt14XyEP3f879pPAFFtLBsRfRz2bpRQtZ11ny5nTvpLgKYW3aEi2iHVpvWBE4MBh1DGXTX7s+IjaD033dUyQxj0b0UTqnK4eFfOZjqhG8vYLmROd8lKnDvZ+yrzx3JA/iNL1EAcXKdrUUaJRtZbIywyCZQ7D2lKKGD/Be2tivqcSlNlJUoKAKnMttDjKH0d0z+SmDDqLDB33A2dJ3jmJEg7Q0GW6i0JUc0dJJawPodPtBXKc9iQ1rY9hJvOBdxyz2u1PL4UAihU2OrWv7+aCpd0K/48SzfIIdH7SKHdcTcCLU1NpVSayFTGCCk+4pqAaCw8Z+h6sZcylQwr31XDIO7Azl4aqumhjNr2/T16VfR7d/XzpncyvluQrtM1iHoScFjxrgjn8JcIktZzk35OA4mBkEN0o2mCPFRurL6/yBs5f6xq4VYAM2+wkfPL7rPLBWoFDCAqgBXWHNBj6wmMSfy9xvtbwLLALlNH9J1HadPD4n5RjVFhXlNqspovzrbwL4ythPDHYwAsgHRx/GfXx/5VQZcNrEv+2beXpUIiVlXTCjjL+d7xHZFF1jY9yFKJiO+OEcW0CGeeEViJh49IDi//2rPjZ/ocWYk4Vnoj62BRNhdEe8urYq2TUya+vGXFsjlE+VMlml2YSjBxo1lzjhMH1pE8jt0WTmGcoLYPkxlaXPCLxoLR47DbTrpsa07oRYgrmN8WrM9Gv8JBQW4Z0g/BJm0TgXOSnHjC6TvF7ptvcaJyGuPBqXZ9qEgXijgKYnme9R5we8IR3ws0QdyjK7Visgbxvrxnz8Za5aRIA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1c6RnEyEJY+HQJo13NuxrkD4Y+Mia5m7ds0aJSxmaPATYjZQ2oUZVHne0OIP?=
 =?us-ascii?Q?3r4hNO2d68OhCoju5yXbV8sFBgyvbUdrAdtBMtLWTzVXbmXEdXlZJYFlwijJ?=
 =?us-ascii?Q?pNiQozr9znfwGvFCaH1mhY+sEVWXhZeSJRtC2C74Lphg1r2tkuX4ItpUf7++?=
 =?us-ascii?Q?yrVc08jYtfpW2CYxgq8Cb6zpVK7CEVYz6a+ZYMKLC/rrCfH2w3XxuLiAP8bz?=
 =?us-ascii?Q?FCaThcghEKymC5L7Jyz3KUbeH1p3RfVUTfEyHibNcmcbECHt8PefIwNQmn+p?=
 =?us-ascii?Q?qhyhsgIuri5R8QFuzbNr78B3DtITnaFfOcm1FjFe2CVG4Q/k2tYJ7dPmadOR?=
 =?us-ascii?Q?3RsKD68+KnNuM2DOmqbnq2/G3MSbZgcUvyvNRtYjRRahxKXFl1z3UFblLFQD?=
 =?us-ascii?Q?pfHAvxNsIsgtSYE/AKe9GM+z/ksVC+7z+jtoV8N1jc/sanFPqEci1KPB6Il3?=
 =?us-ascii?Q?bCDBhsivsYhOyWNb31FaXQEltXUWHd+OgA+/cUF1VavqR3ovzENnJVYmurqS?=
 =?us-ascii?Q?eC7AvdJO2lHA5/DrS7u5Qp9FZbvLEZ7ql6ix2H9y6SkLchirWwuLpSdlgcU+?=
 =?us-ascii?Q?6i38xcEruOPrYCh0gSgSTRW1E6APT12E98+tv/8aZUvoRg/l/APB/cpdJMm7?=
 =?us-ascii?Q?0RFL4dVqtex8PKRCDuRVRyjvDp8CXJ5u0rwcDqH0fQcQOQC0YsIgWQEBAyrL?=
 =?us-ascii?Q?/UNElONZvR22zUW5UgxMJEV8ZdIW5yRQbqKd60ugflW5F7niUwAPfsEmHrcq?=
 =?us-ascii?Q?YikKF355Qx2yjCO3ZraUq/8u41zLRM0vnat1K27tOXfOEYHNLh7Sl0NOa7qZ?=
 =?us-ascii?Q?rxDvirZAMVeebmVX7Ahj2e0Zm3j+cG6YEe6JiDm2kSO6yeGTG2WV2W2MSVsh?=
 =?us-ascii?Q?Yy2YbXR2T1xHh6V3ITnqJbCFBbltaqD3RdGKvz7IR33q+wUt1I3Xw78sFyDv?=
 =?us-ascii?Q?o6WyOWYkhS2FcBBi+8L6TGQNwm9skj0q5Gegw1UtaWLDUEj4z80HnUvGWDAJ?=
 =?us-ascii?Q?HwmajxjfoUo73NYV5PiFHQGqE3K5NyqyAbpub/2jiNNACTEF9pq7hr0MI9KE?=
 =?us-ascii?Q?Wd8FRqw+hnaaKoeV1Vh3MrhhLZtMl33zgC5qrU1vk5hGzJLkJbm641JYNRoO?=
 =?us-ascii?Q?m+zxzeNLQcIe82ctXAwsUHQ+GjTzmZrXwADa1PCwJKvgdzx+mXvnAJtDlKvN?=
 =?us-ascii?Q?ezce2t4oxOYP6VNk+MmhMaDAW55KMvMrlyXM1l9yCR7sTF22raLt+1eq+3Bx?=
 =?us-ascii?Q?3znwjCGsFCKMGhIV9IyUMiip9gImTr7JN3BlR2CZyx6xnsEfvT1K+BW+DLIz?=
 =?us-ascii?Q?1fz/7KbHG1FWRWmxCJhn0nPnc133UnsiOIzBzZgGzPhp8WkMkbT47jzp4JTc?=
 =?us-ascii?Q?8qLsWbr07PNkZagu6T1q9diLPMKwAAL+3rC0KABhcyQR+AjSn4Av5nWhi9az?=
 =?us-ascii?Q?D3IET4lIy/fdGEO6MYAceKNZI83irL06yTgTy6CdR7z3yn3C7TSJN+rFvw/b?=
 =?us-ascii?Q?0xRF0rnf8g4Lh67DZpuuZzisxVkFTMAFZHFYJ9opgDI3BJ9cLOHtzIED4aSv?=
 =?us-ascii?Q?k9CeB18wt5zm6Gic7Ns3Ab/QmgEhrCGW4vXW/Jvk3wVrIV+l+uQJNsJYJwpN?=
 =?us-ascii?Q?kg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c50eed6-b28f-45d6-7306-08da799ac062
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:38.7354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yex6dyQzfFbVS7lOwkdc/7B7kYPoZbl0fwiSU5KPI3EIgjf3y0wnryw1hIRwfoPAsduvJ3FUe8sZvo+iOUO+deyA9x1LCynZU0du+bsTc6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: KSxOCj_gnIkONoC4guM_FB7JPr5LkXGS
X-Proofpoint-GUID: KSxOCj_gnIkONoC4guM_FB7JPr5LkXGS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds support for the pr_ops read_reservation callout by
calling the NVMe Reservation Report helper. It then parses that info to
detect if there is a reservation and if there is then convert the
returned info to a pr_ops pr_held_reservation struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/core.c | 68 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 230e5deca391..5bbc1d84a87e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2267,6 +2267,73 @@ static int nvme_pr_read_keys(struct block_device *bdev,
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
+
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
+	resv->type = block_pr_type(status->rtype);
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
@@ -2274,6 +2341,7 @@ const struct pr_ops nvme_pr_ops = {
 	.pr_preempt	= nvme_pr_preempt,
 	.pr_clear	= nvme_pr_clear,
 	.pr_read_keys	= nvme_pr_read_keys,
+	.pr_read_reservation = nvme_pr_read_reservation,
 };
 
 #ifdef CONFIG_BLK_SED_OPAL
-- 
2.18.2

