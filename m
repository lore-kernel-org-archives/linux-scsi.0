Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D858BC25B0E
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbiHIAGe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244326AbiHIAGK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:06:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725F91C906;
        Mon,  8 Aug 2022 17:06:09 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NxYXJ000317;
        Tue, 9 Aug 2022 00:04:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=iWKAVGTaOfAMbRaB8Vh9yefBMRTWbzvZ0iY9lcF07yQ=;
 b=fwi+LI56gT2z6CyCpLYNZHGvJZ1aRQrDDyAHGOHsXH8imzOnK/XGaLXi3dwtGfcs/Npk
 udHfWS0ZMoIQuVK2Orv8a7j5sj6OhzIoljE47pVPffKhan+xcu4WqPdXEoslMuQwEAjM
 rSQiHWtSUrjA5J0NGWAMm6GTadUsoCdy95RKNcnVx9aXlY0/NuqlUJb+WoSfYPrFJZlE
 U1rLZShoa3zIgYCG/nuAPdFcKKr63ZUSrnrU0pQY0jx+daK/NoapEQkYa3tcBBIQ0nlp
 hi1Z9dFva/QMAY5sFJ2U8/CG1zb5fjIZMG9NhjOVKAfP++6JXLfsrnTEpZ/O2Hm7y88O vA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsew155h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0i97013162;
        Tue, 9 Aug 2022 00:04:36 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hu0q2b9kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRr+FFR/ivUPk1ykTu7ozlzmxBsz83GgljbnqEqiTl76aytPfKadeOiul6PZ/f6X5AVXTWXx3g8KWSjNnBQfMzxa+e/XR5Wd/U7yyhZQ8Sz8hM3Powvo2OPW7pyd3r4B6WQwP/oGRNhNndyaUpZ1//8mwWWDsK3fYppRJJ+GnAOWa3jtdGYAkLBRFqlmyrK/n7NiFZzCRWZXpQ5aJ1RouuG4T8liRwPEzdfVyRM1Dye9SzfHajnMTjjoEJvjUhewPbFvYcVRdRNd2+Q3K+xLEyKQBjC54nFuJu26IdTOLG0f9IFML1Xm/4K3u8fzw2C2Z0JSnu1SUebQCwxUMRfqDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWKAVGTaOfAMbRaB8Vh9yefBMRTWbzvZ0iY9lcF07yQ=;
 b=n/rMmuksePBCKpKg7wtPS2GedZjK9SpitGUHFKaVv+aqnfOuh2bE3Xg7N8+2vFgeNTWnWvVbnoNaIorgDvUxVilddDo/Kh7bvGhcCkOdxMHO67qzbE8SZ1J5rg+bmlXFDRBXhZEj0+nwh1Gj7FlnAUD0F+/J0MjPcTqZ+FGdhhdVzRwfX/1EBrobdXX/PpkeM0maJtlE2TtnAdHkIO1Os1Dfrgp5co9E2F2Mwe45mx+x23A/xlx8aehW8pZmuwZCbEivp4C0jOxB2KZZwyhY5BkqeZB7N1786UeGbmHNk3M4V/ZG2pyyXo8/a3O1zLyNhHfBym0hwgoIT3IGoYEUhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWKAVGTaOfAMbRaB8Vh9yefBMRTWbzvZ0iY9lcF07yQ=;
 b=C5r2P7B9ZAG7wuRIgAqWNg/hfDJ3IS5WD2Os94th7Kukhg55rYl+rdpXu2TfWda+4p+Wmvo7XgLz80g/pR779WMEaFb8VOOBDUVGkaInaA6lIQp+TaJJC2A5bUQptD9NpA7vdIOUKymjk6cFNHC2F8PxhUjluSvJccOjSF9Q9KQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 09/20] nvme: Add helper to execute Reservation Report
Date:   Mon,  8 Aug 2022 19:04:08 -0500
Message-Id: <20220809000419.10674-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0209.namprd03.prod.outlook.com
 (2603:10b6:610:e4::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1af35c0-77a4-44ec-d3a2-08da799abe2f
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bmRw3ED0LiOs5/vbwSR+TtTDg7QusfcJLka1fUrZjQwZg1vmppFq8pVILCBlVvO2GH7pD0rqJDSPyfvazIl5ZGJKOsT8BemjyN/rW2FogyaCBmFT5i2GUAy3/cyPRJAnHAi3K6B+9JwCoBwfDVeet7CRjSnkfBMQZHOc8cOs8DcYgSy3aoDXPQ1zZuw2wIhXqdwGfC4VJ58877Gw5L1JKpVzhAWbz8PFl2bXK6hv90MMNQoEIoJSpQ8QZFVXISYhdSrhbmf/kcA9c+Wn9HeTnLMfieieQkqReO+jdg7u/clq7OrGoP6WPXn0aSkGxQ3HgihfSDzyiCNJQisuc/ilBSLf9qdEWJu//HJZAqWMPjjgZOrdnYe0D7WtHJWEPzTazb/sNjeVuOoII2co2k9Lc4Srvv5y3Zrlqb+Bm3BJJ9bhgCcBAe/9cMo6J5n4aNa1YZfu6kc+2VwepISWpLY3Ct8SxoUOv26/5oT9DXBhvi2HSdKoi3ruL/gnqR5oKia4D0SrDpTjW+Y5ucmhNPin+H4v4YeSPCaQ6uII6yOCKwx19JKxr2SxFl3GuX7IIwEROX+Jv47z/5dTSMsmLWQP3WePC9kg10nRGQBHWFB3YtrsV5jansqL2T2Vyl3dXZurPMu1zPPlgAe8eTF4SU3CDclPZr/9A6j244QzLfi6aZUMyEPC0GLhH/AOxJHkukaZHaxdHtqIhBSwGqHhXHP2FnpTU9LxHU76JgmEqFPih6eCUZbVdvxivxoKAp+Jk8+dE4AMzw0Sb3fsCyAfAobLmq3FTiSbGuf7umnS9SDylWE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?15Oj6XpeIhuRej44OkZxD3bGjMYvBxHiYm19ukKht/oIDRxVqxx7W9h2Wx5Y?=
 =?us-ascii?Q?Lfj1OISVrlnxOPNnN2oIcOH4Ir9BvA0krI0IJvAF6hwGkcxc2rurjN6sH0CP?=
 =?us-ascii?Q?uppoAbL5FGmc3GZivIdxbwqfRUu4zSAedtSYfdrtW0xvgYF5HMDTwlWLNoNw?=
 =?us-ascii?Q?YlyhDrLMH6bOFlii2LlgOR2QNlXW8mAMHDcfz9ViL7gYa68st7KmqRB7QmaK?=
 =?us-ascii?Q?TCxChN7c0LMpx3VKynh4glx0vxqsC5jr27oM8MtPWmyiVZp3WzuX1TxnM16a?=
 =?us-ascii?Q?KFBtnpeDeIYEUbgMRPK9YOPu92TihI0SJ0Zv4MC30R736CeYIkDHJ59DyMGu?=
 =?us-ascii?Q?W7jNZPluCmQaD72Wtoh2Qo4sgBJWy0XqHJ/psxHnp91oWu7F4Yo5/1vKkqVe?=
 =?us-ascii?Q?wiqfldBw5CSP7juEoSIwxRLj2y1TCddajehaw/MwADwL2roJVL1BdA/AyCB/?=
 =?us-ascii?Q?Nwy4SXtdG+eMcZXn3u8UyRWYINfLV654rGA5XMvn1nKBiUM9uvipKys4fSTl?=
 =?us-ascii?Q?50RzgT/BQTfMUfpgRwB7m+rGxl7NwnMS1IQmSmisAHh51ScZikrgcDFu7fsq?=
 =?us-ascii?Q?IYCSE8EyhfmpZyJ60qv8pnGU7wwQDVbmZutd6MbMyrRf61yrx8K3GGx4vLjY?=
 =?us-ascii?Q?9Mgsg+lDGnwwAkIzABgYUAk4EhY79QPCB4kRIPZVpjHtMsAudlitwi1txE3B?=
 =?us-ascii?Q?EGV3r3JW12yWFsE+S4iLruG6W5lnrgokxR+NybOjdCxuNvWj9GTBs8xSJwPn?=
 =?us-ascii?Q?62+omjB+AtxvCGTlQBF+xkAduyiE3l3UoW/ZN/WJYNtIaPPXWQDTEMlhUI/z?=
 =?us-ascii?Q?H18bQWs29qRYp1HwpQa8D2qGtOH0To2gTT4kRzEOUzMhuJX3gmHGKQkgghbp?=
 =?us-ascii?Q?9GwDI7fPkYBjZcYGF+aAUZ0+E4G6Fnfq0MArR26bP4UqguvYhChvl6KZTrON?=
 =?us-ascii?Q?czeQ1HJPUx1wPkL7G6wBfCniwgDfcEJk+M6O8eQSql9HKuDb4rkTTMZwmZRU?=
 =?us-ascii?Q?JHpNnKXKos6xATOIuXue2JftJXp+NDudl/opxCho+m7qYnbsFnsYU7B/yUtp?=
 =?us-ascii?Q?5z0MP1cBcwQovqq58g3PIFhUIO915IO+HFNhT85IQ+V49OXAt1XV0yn6avJ2?=
 =?us-ascii?Q?JovtUNPBfnl/5li3Gs/0sIVnS8J2MC2wNL89sHFwPVboYqnNs+XWDoO5k6Rf?=
 =?us-ascii?Q?FcljpJZz6CiGopW3B+ER31xp24+X84CZsSDb5vTEGIYw5c/lLW7yz1H7nbO5?=
 =?us-ascii?Q?HpQDQzxVZIzZOpSXHZ0PoohpR9NzLvRk42jrRrsrpjbxX+Ry4M7RPs2pbj6A?=
 =?us-ascii?Q?8gkfyLgkWuhjYct1wJuDwNAJmN+hmvAhHKoI+/M3KvHbNKL/JvybUpJWBD5a?=
 =?us-ascii?Q?eFi0f9kFG5UyKEgdh3++9DMvhz4MvcWSHzXGcJk7zJsdRC+ZGNxpzl/YAonl?=
 =?us-ascii?Q?sdH1A1eLdswBzLuFAkPMZp9XFxpbGiWN06BgEY4DA1xA1JjFLtYRlr3AAamz?=
 =?us-ascii?Q?yKcZatHji/vrJ5xtx/cNJ/uCAShKLqpcSwK8vkK2RCBM3CTZRdxBoT6bO57R?=
 =?us-ascii?Q?WTFNlOIwOTjaesmgE/DyOFtGTiEaUQ6J7MX5VOPyfBy2bpgAMyQ4TC8QvkNE?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1af35c0-77a4-44ec-d3a2-08da799abe2f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:35.0326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXSmkbqGc8ANh4seI4wfza6ZEcOSrVaL/WYImjnx6D72647yYzkR/FlEFQk1leVqTyI4FPxuEiAsI0loV1xHIEjY/+FrjOXlW3nOFdG+MqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: h9vD1FbRq9vWMjTaCa3vo4Tnu9fEzJ1Q
X-Proofpoint-GUID: h9vD1FbRq9vWMjTaCa3vo4Tnu9fEzJ1Q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a helper to execute the Reservation Report. The next patches
will then convert call it and convert that info to read_keys and
read_reservation.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/core.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0dc768ae0c16..6b22a5dec122 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2196,6 +2196,33 @@ static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type
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
+	c.common.cdw11 = 1;
+	*eds = true;
+
+retry:
+	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
+	    bdev->bd_disk->fops == &nvme_ns_head_ops)
+		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
+	else
+		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
+					      data, data_len);
+	if (ret == NVME_SC_HOST_ID_INCONSIST && c.common.cdw11) {
+		c.common.cdw11 = 0;
+		*eds = false;
+		goto retry;
+	}
+
+	return ret;
+}
+
 const struct pr_ops nvme_pr_ops = {
 	.pr_register	= nvme_pr_register,
 	.pr_reserve	= nvme_pr_reserve,
-- 
2.18.2

