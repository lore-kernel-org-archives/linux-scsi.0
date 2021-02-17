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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CB3C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6061064DEC
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhBQUaA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:30:00 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41048 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235051AbhBQU32 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:29:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKOAa2146945;
        Wed, 17 Feb 2021 20:28:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=nmNPczwdrWFQufUfS26xsht2CcTvVrMqQOEoCGgZw3A=;
 b=pYVy4rxMS92I4Mgcfd5WJch34bN4mey1sEQ3uwy55LfNf1/o8o3N+fjFPGfczBnqAqid
 gkYv8H44xKpw4goN2Z9YU+W5P6qzsLH6UMH1gsmlxD/refyqogOV6+95gwfEXOIbED8B
 456k5PAC4rpRaqNY+BhD/+eqr0G7Yq/idWyM1HtYkj27Wiv+9Z6VBHT3E331vSxINWCN
 SpzuNm3xLBM9ys4nUT2aUhBmnyxkJ9BdAjTW4Ywf8wwsLVLAYkwLGmSiih8UOwy3iWzg
 vEZWCRtwkp5QFqwSCHuUJTGfAWB2VeqIg6v2oGUSSOtBeUdcHZDL651CMa+V4fSo6qBq zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36p7dnkpjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQOlP004067;
        Wed, 17 Feb 2021 20:28:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3030.oracle.com with ESMTP id 36prbpwwx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKcB4MijxZ7cR3DJQ9q+xVxa84Sf8z4DC0ESoisqTAx+z55K6aZaQQWsDPjU/1mSlRYKiKaFbrtQosDNuWAlLtye+S6lvTfmrQaR72VgI1eSG5jLNMjC1rA/JQvhikVvLKZdMiSHgEgK8YlBuE9iYrJpYBHPkS33rXLtX7hMrSgoBBB+Ek9+XL4nIa4ylUF2EMbWwRYpOf4lCnrOlnP0Oa9kk4+b6BOvDLJK4KV1SJ91i6hq+5SfRY9YywTy3anvat+ycyVrwsdE0TDHHodJqZ+FgPV8FeS8n4f91OBMEN5vQ9Yq8geomemS9k75qP78+agQhinfXELpdPK7kyyCGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmNPczwdrWFQufUfS26xsht2CcTvVrMqQOEoCGgZw3A=;
 b=N6ibxl6A4LBKL9DqBkt918jbPkf3NzSoPdx7Vji7U3ucEyF7Dym2/+SCVf87oC98APy1jEBWSz5L2olO+3Aqcd+FdWO6/pUrkX+KZD8rc5blgj1yLwDMjnbG5wUx6QrbsxKxNS01QnDe6fPO56Tfy3x+OP7Wpnu/I/PzorL1V91smYWvSWgSEHxuFmSn3VXIZaUwBevRPQvnmIKnpsspHN7vCt+rEKnC3Pp0A/5Wiey2h4tY2VGdkqOnJSfvecLZO2YZoypoJyVz97NRWQhKMDfpjlwhNUD4T5HLwosKYTJPAmV0qJXH6mKMu5Ldx3hGvNsO1IzIsmpqSHpjDeumeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmNPczwdrWFQufUfS26xsht2CcTvVrMqQOEoCGgZw3A=;
 b=f8AuD+5OhRBcvGyB0HfLB9MxM8n59NUHeVkdZmsp7hB27p0Dv3PutkMFz9l01zUkR5lx0bJDXlyse0bNv5jJQ0aMHvBpkJ9FGQYxxEoEAn7ruSg/OYkYIHh+Pk2YCYMortdV+EfdKkg8cHJEWEgCFQZo9AaH6XyELVK2bAbbQWo=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4101.namprd10.prod.outlook.com (2603:10b6:a03:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 20:28:34 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Michael Cyr <mikecyr@linux.ibm.com>
Subject: [PATCH 06/25] ibmvscsi_tgt: Convert to new submission API
Date:   Wed, 17 Feb 2021 14:27:52 -0600
Message-Id: <20210217202811.5575-7-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec6f3a64-d7ad-444e-4282-08d8d3829940
X-MS-TrafficTypeDiagnostic: BYAPR10MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB410103BD9C6C7C3C9D9BB662F1869@BYAPR10MB4101.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z4hixpHc7CGAupP6BA2XhGfjU4MuP1b0SYzsKox4huzWnSBi4AACsDceWKblFcPLOJK5SvBYssRPfUbBpbsSnwPUQiShONg0A5NzZrwFV4rXad9b8nUDNE+3vDbpSPna3Lg/OB321Eh7OEetwWh8zzj9kNSNfCU0yWAtcvujJNrigy330X2j26AjMUG5aMRB6tS+2RHLjpTOaEQsXWlssMRuYgBPMb2UDhCChKfXcpWQKF50l5T0sGhy532BVsLsa2QnjFQV+doMJzHqCOyDM9YyJQ20byVZsxqRKL/T7EEpoH9NPAUGsHbDhii5aDYaBzFc1Bont+uyqNdm1VOBi7xW1HKlNW1xfA+5d6AWc8DysYLLeLzy2UeO4i9u0IFb5lhx9dYIbSooyoHeTlyuXg2v7P4Hn7nqxIOMo+2hysPcu2ZnpzlMwa3F1si8HGZ7iIvDvDNJP99InQR+/cVIV6qJFi0KwNGBwnooWHV42eABhdY6QLyEbASYlW3CyOVIsZEgzmMgNeknmlaHQDm8rH5zAeDQvE06jtxkC1qEZAJe93Z+kTUrMtpoV28FDpD5pLiRAjwVE04zKw9qNvCgyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(1076003)(6486002)(26005)(316002)(54906003)(478600001)(2906002)(186003)(86362001)(6666004)(2616005)(6506007)(52116002)(956004)(36756003)(66946007)(8936002)(6512007)(8676002)(4326008)(66556008)(66476007)(69590400012)(5660300002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1Catg4BYUfqymMu4OvNgD5WSptoCcBpDrMdgV/weTcHwAjaquZZ8dlmhXjpd?=
 =?us-ascii?Q?fNDICovTnRxiuiqbkqmMNOepLCldjnBfiEJJXZBT6R0EDO6FFJTVKDSiS5kQ?=
 =?us-ascii?Q?Tr6/+RNkb/RlKdxMgBgl3iK64ljc3LaZ7ZljBQRBwdWNSdof23o7/eSVlL3l?=
 =?us-ascii?Q?Ujlt0Stx1FHa63iZCJ/O5hxamUcv8GSpQ725ectwg1YOVY864GmfoMODO803?=
 =?us-ascii?Q?zLh/s7HUSryZDPb75dAUpWZmnnavU/BzusHUztX/PVOBfvYizIfQqhIQTAdJ?=
 =?us-ascii?Q?nrqPVXh0XGYgDGQoy/3RWyAZ6ULvuO3gPERTwUCpPu5baXwI4A3dlSKjmZLK?=
 =?us-ascii?Q?/PfRFX5xjdGZ4YXH9SVAjXZnvE8CIrTPlTSI3PXdZiUvBSNzNwzauZHgsdGw?=
 =?us-ascii?Q?OcuZYPwnVRFS5wR7JSEikdx74wVBrik9ut8C+unGbOHz2M6RszNDYgyC7UX8?=
 =?us-ascii?Q?QLyMLnJpRgV77RzHCnoa2aBVr+Avez6S0DZffF63LkF5udXBXDHjfQonQMJZ?=
 =?us-ascii?Q?PntGkzdb0kjhODsaWQ1wwi7rcA4IJWIiNFCK6aKx8bvc8JPRXCkx0vvIiPun?=
 =?us-ascii?Q?XNIQF8U6dR/DfLoFB2zpnKHwfBsZRuSSK7i2e/rW/2yy2cUoFFKKAImd+Pmo?=
 =?us-ascii?Q?v+95QXbqQlA+Cjg+a9kvx+T+0kUu3pVuLirwKUv0SQixkGCtcSaLDZ/1talX?=
 =?us-ascii?Q?rZmXEFML5MJ0oGjClELl/h2+qxy1ZPltb/9kifv2usfHEZAUnDIGegvUthPN?=
 =?us-ascii?Q?y692ket1dBfsHSwwpOagjiXKXEDuL+7iyMIBVqn/5Vg1rpZvVMhhkLkiBZg1?=
 =?us-ascii?Q?S1xkXV1vE0p56Y929MknQl1LJ3763aZy2giE/YB6Eixp1MuGzkvJcl20yjT4?=
 =?us-ascii?Q?5eOhgVAaA8xwLm9PxOOJc+e4n25/acZK+BPu5IPZzxXRqIMM2w/cEj413orp?=
 =?us-ascii?Q?Aeqv7FH/sN7hja0bYwGep4WJ19UL7mX9EbdyGwCVEUX2mlFCgI+4Tw5v73Ci?=
 =?us-ascii?Q?IlCDNbfK7GdBxEDFbZfDYTNRuPFlo7mp9BDzpm0PzVqttjQTe1yC+RXL35pk?=
 =?us-ascii?Q?zaH9IrrgOr0863AypIgcOGb4+UjV7qWGY0SnRQR7vaeZwGDGL/G59o/dXZuv?=
 =?us-ascii?Q?MY//EewL6rm+X48g/1/Hyod/ZzlOZSbnHTUMcWyhVxswrgKc+hT/tLKCPnXv?=
 =?us-ascii?Q?2N4o70rswahoIiQ+PzA646NIpLLQtlc5n2kie/hQlD/k05u/iJMN5s2riNqb?=
 =?us-ascii?Q?P8Ddxz5THwIUxAst6RoqDoonxMIpMKDgm4v9ZzAiYKBic+xgmlh397Z3kdKO?=
 =?us-ascii?Q?Lt/kY4rCOT1g9R8MZDh/9J1K?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6f3a64-d7ad-444e-4282-08d8d3829940
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:34.5188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p6pq7PmxYXu5jZr4uDEcZRpmLFMTd3SOX3ZP0jk0DCOE2opQb+yFOQPx+2BbYGEAnzYR+QZnJzT5gWfT0fbjpV/S46VFEX+h5hgrqGk38hM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session. It
will never return a failure, so we can remove that code from
the driver.

Cc: Michael Cyr <mikecyr@linux.ibm.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index cc3908c2d2f9..cfc54532402c 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -2670,7 +2670,6 @@ static void ibmvscsis_parse_cmd(struct scsi_info *vscsi,
 	u64 data_len = 0;
 	enum dma_data_direction dir;
 	int attr = 0;
-	int rc = 0;
 
 	nexus = vscsi->tport.ibmv_nexus;
 	/*
@@ -2725,17 +2724,9 @@ static void ibmvscsis_parse_cmd(struct scsi_info *vscsi,
 
 	srp->lun.scsi_lun[0] &= 0x3f;
 
-	rc = target_submit_cmd(&cmd->se_cmd, nexus->se_sess, srp->cdb,
-			       cmd->sense_buf, scsilun_to_int(&srp->lun),
-			       data_len, attr, dir, 0);
-	if (rc) {
-		dev_err(&vscsi->dev, "target_submit_cmd failed, rc %d\n", rc);
-		spin_lock_bh(&vscsi->intr_lock);
-		list_del(&cmd->list);
-		ibmvscsis_free_cmd_resources(vscsi, cmd);
-		spin_unlock_bh(&vscsi->intr_lock);
-		goto fail;
-	}
+	target_submit_cmd(&cmd->se_cmd, nexus->se_sess, srp->cdb,
+			  cmd->sense_buf, scsilun_to_int(&srp->lun),
+			  data_len, attr, dir, 0);
 	return;
 
 fail:
-- 
2.25.1

