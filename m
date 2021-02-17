Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FDDEC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB27464E68
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhBQU3z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:29:55 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:53060 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbhBQU30 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:29:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKOW49017856;
        Wed, 17 Feb 2021 20:28:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=IIGvzMJTnj7LCDuzrwvw4HdY5QbD9p3SIVclTcSvc3s=;
 b=PF1PX0wCh0kwntngZy92HZFaXoDLgx+4betPw1K7DvQqi0hZe9LSQMcM34tFVrC7bIhO
 euzwf6lMlPZCUN7rzGoKkGehbYqor0RKfHiBOC8HLuWb6pVJBDVFs0EAIFZrJNIrVCMK
 BSJHlYZhQmpl5/8CJCrXe7ERnW03e7ylxCQjH6qL5HuQCJ8ZCjPYhoSKkyeGVbZOr0X/
 VEu8IAu1f9tJMLBbEy9WfpZr50dZ4sdSTY0JCxvsLxlYrnQZoQh27iDadD1dSGlYubFg
 A8g5PRg98xzkwIaaOPumrcc4iy9zd5iAu2UUnYzHzteVekAzVI0QM6ZtvVZlAIMIYf/d cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36p49bbwx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQB6C191515;
        Wed, 17 Feb 2021 20:28:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3020.oracle.com with ESMTP id 36prp0p684-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lhgd+dfoFF60sZTHJhVec3pmVb2PeFOcDJTYnH1DBSRVUf9ye03U6PBJXO+9E2+ddRnaDBV0mbCmkUstgPi4yBmttxcdG46WTS4hkWDsBHxfsvbJ9sj6c5DBgVc0EVhSkbJf9PP5JC601JuK9IIEX3lezUl8dMSwdef10FDrO02JrevL2aJsZQrjheqhu3RcVr/rL7fXMTru5TJDyiqdnEvVigvf6ZJwgKr8dCDmyS3Wl75KfVwgQQYfoYDm2LRnJ3ZbYskugPwlj66huP+NgRR55ByVtmmb1AFTsqZjMEsV2VKI1U40KI3EejsKBkga6HYXjb7hKOHhPtB4Z7+MTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIGvzMJTnj7LCDuzrwvw4HdY5QbD9p3SIVclTcSvc3s=;
 b=gXvsBFuWE9THjJawWMSBAatbLyNNZFEctSWkR7svsEQH68iUdpuIrM9NU2nmioNYpR4YRcRfNdjZ4C3erNc3HndhCkooS0SlIJhYoB2Op2xgY1wVrM8jdHdNs3AM9G52P9oj6XV5PYy71nakOotYtIiN3ruNvZBvDUoI54fFix8tR4Z105gNEPQQ2lXoE9FkkWcf2UA5AcR2ux1V3t90UaP/jHYGEZd0mfAWH/l7ax/4QAVHkwoihuveyGU9zqQYjUeYl5Y/KvdJP+/tmhMygDZER3x5Xyq8TY7+4ZHKA/VvvXyV8kFXS2EenH2r0k+wVEvZBXyyG47qNeGZh5LPdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIGvzMJTnj7LCDuzrwvw4HdY5QbD9p3SIVclTcSvc3s=;
 b=PVzfXRJgqPuOgd5YZm1iNvuTrlABU8lQxpYXRwDFAQleKk+Ff4tFrcF0JTI+aJrW77bLqOdaPWgVbzzVpEkSiAzbMrmg2LhZvkQCMf/xC1lm1/tB5kJxyUwGogUHLov1u+rMEq2BxRSlNji5tg8KrqZn1NpoOmVpl3smR00DxDw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4101.namprd10.prod.outlook.com (2603:10b6:a03:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 20:28:32 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 05/25] srpt: Convert to new submission API
Date:   Wed, 17 Feb 2021 14:27:51 -0600
Message-Id: <20210217202811.5575-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217202811.5575-1-michael.christie@oracle.com>
References: <20210217202811.5575-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cccddb8-6436-4911-0ad8-08d8d38297b6
X-MS-TrafficTypeDiagnostic: BYAPR10MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB4101A953EE3D3A71058ABA14F1869@BYAPR10MB4101.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s+iQuBGeaowv/LZa0Xd+pqRCm8gC43/6AkPgsleXcfbd+UmQmA7QcLkmntW5cC1QVJBoi9YhtjB1nx4KPwUWFTReXydKQvKwZGAgW/6CHdnYL9NqM2cC1aDminv/wxzeUyzqhBvz1rsofMHaXNR8JD8NMr3335nTLKeiEy20HnEU1bEXR/WHebp3HlhdXHMit+A60EJZrBPoQ4nAHsgXfr2C5VT1c8EIfhUryYFEeCw7pexCsXei6esWl3LpHPL7oF/xQXYjM1+XDZSD+OxtAjyELDCyK4KcC5ib6gs3nS4SLmi7M8vTn/NA5Yqm3yYZisdJeMLR4AyY7F9BjuTxo9DagZOurzjCpRD7eBeR+mat5BHc7gzrSjQE6CWmgQru3ZFyndKUeiVXOHknGBJw+kKFzjcx5E7ZAZTAWHffirqIsdhs9zLkPilIzR7wQHfxL8f5mEXQ2aXeIpb98fSlfFrXcbcbbXVtywjLkH6J6VG+X779IY9fHtOfBc9EqTRnPxKdchF/V099cFHFTNg7l2KxZm1/ttsqFRqiYw+PXxoY4dYoyOXyipqED0Xq2YNs5jp53QGH1Bx2XW7bEbqdIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(1076003)(6486002)(26005)(316002)(54906003)(478600001)(2906002)(186003)(86362001)(6666004)(2616005)(6506007)(52116002)(956004)(36756003)(66946007)(8936002)(6512007)(8676002)(4326008)(66556008)(66476007)(69590400012)(5660300002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?APhCWhYbt6ES9klOuYDLVZpQsBgssqzoNxiYVbb8VMVHx5fIIkGRP/hzZdY1?=
 =?us-ascii?Q?6/b7YuGOtbpTW1+BDaSLAEc771HjrNgzRggoGJT6wx7IltB6gBS0MJzIgzO1?=
 =?us-ascii?Q?nEJOIia4mdkWcYCyCWKUJphA96YZ2RiL8gQGJo/jMY9p13vDWuDX6RoiQomW?=
 =?us-ascii?Q?ke3LtNfRFErgizONr5nhWxhUdiw9RNpoX++JmrESI3N3zNopaorliFnShImH?=
 =?us-ascii?Q?Him5gMgmoMebE3UTXl9gLt2h6JG3kacCLsN6F9fxmC/Wgd6NNpVjC9SBBbBx?=
 =?us-ascii?Q?EoUD0Lwdgd7yobWn5GZhQp25RpaPlDYrheKUG4ZKsIxoB7sidCajl5qHdIPU?=
 =?us-ascii?Q?5zpOJIC/sDrRMDXBClEn3+rFOqCAkG8ixHMGEzGbPNKb1kGfJKUnysnKWQoR?=
 =?us-ascii?Q?z2/W02h/9q6YLlKs3XLKTLO8U0+bIjxmcccu41gvyb9KcmlF37gOL/yPfOfY?=
 =?us-ascii?Q?+FJiPoiIdq+7fjUXPD+SdT1EC5jWVQ0Iv/is5220uDvGb6hv3bTh2qMwOYDb?=
 =?us-ascii?Q?VqLK+VuT17Oiti0dKOUarg7OLdUNhbz2+zqmsYSigucfccj/G3+TUtjNG09i?=
 =?us-ascii?Q?r9gvOIUXviKrEiQh4/h0T0qfytYTNaPK//W+zuwI3s3SOqI82NRX5Zk41b8R?=
 =?us-ascii?Q?q6dhEklLfoEDoN+FHm+S+PWFBnnu3Mm0TZmVOpWW9e876um9+nsxynCRjr6k?=
 =?us-ascii?Q?ft/a/C1cNtMYOsBkhAx4+0GvplB+FJ67LpI2CND4cCYP5MyErxSPBlfa+kNI?=
 =?us-ascii?Q?l36d503O/gF5VeMY8UMgASfsbU3wHuPKPdXAt6KdGHioH2syFohvh448miV4?=
 =?us-ascii?Q?kp+irt/g3t9aF1bZBtvxNOkBtzdMG+ovFgXyDgeLPfNAEw2QVigV5LBt/inn?=
 =?us-ascii?Q?dKch922KBRUxqRjjUx2csLMqWhfd/rwzLD6qjij7sNVtx9ROmZOgi+ir1ok7?=
 =?us-ascii?Q?A4LOf8kqAku5SrnONRrmk8Bysy3RDf9IQEZwaF6g1D47l295jZNoeAvHm835?=
 =?us-ascii?Q?zX/gdnyldX/bRws2JCF6kmk+7Vj2LIlJdwvcCFYL07KmQfqcc5cECXe4BHDT?=
 =?us-ascii?Q?a6jtMg0HsXSf/vsbk0QD7z1DdMjPos9eoKOyNayj6xktujKvmQb3qyP9USKo?=
 =?us-ascii?Q?8v+N/4Qs3BJnSgbC6+zCb9Oz9umUi2ovn43tAZFnzNMkIMPtcsDnC4woYKF+?=
 =?us-ascii?Q?jWkUFeqUXLhuaNpmKzYGJP4725QOoRCNar1kfg3ApaEuy2/i+kdqZKjhCWbX?=
 =?us-ascii?Q?niZcFPcLIYoMZo7NZOb9C7XwrHOl+cJZBk2Hfa4Ubd5PHlmuU/0o3+n0llVt?=
 =?us-ascii?Q?OpguPVgimz71FgA2dRaJOfzD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cccddb8-6436-4911-0ad8-08d8d38297b6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:32.7818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TVWd5l2xteNWc2oQinhEsyvOIRlZ79Gbgp8f+3u89n3pIHW+7vCI9a4FmsAcfWTHOS5wFM2wQco2MxblughiAnDv24T4q4qBfmtDHQEC+2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls is being removed, so convert srpt to
the new submission API.

srpt uses target_stop_session to sync session shutdown with lio core,
so we use target_init_cmd/target_submit_prep/target_submit, because
target_init_cmd will detect the target_stop_session call and return
an error.

Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6be60aa5ffe2..87741e0b4bca 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1528,16 +1528,19 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		goto busy;
 	}
 
-	rc = target_submit_cmd_map_sgls(cmd, ch->sess, srp_cmd->cdb,
-			       &send_ioctx->sense_data[0],
-			       scsilun_to_int(&srp_cmd->lun), data_len,
-			       TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF,
-			       sg, sg_cnt, NULL, 0, NULL, 0);
+	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
+			     scsilun_to_int(&srp_cmd->lun), data_len,
+			     TCM_SIMPLE_TAG, dir, TARGET_SCF_ACK_KREF);
 	if (rc != 0) {
 		pr_debug("target_submit_cmd() returned %d for tag %#llx\n", rc,
 			 srp_cmd->tag);
 		goto busy;
 	}
+
+	if (target_submit_prep(cmd, srp_cmd->cdb, sg, sg_cnt, NULL, 0, NULL, 0))
+		return;
+
+	target_submit(cmd);
 	return;
 
 busy:
-- 
2.25.1

