Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D44C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD0DE64F45
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbhBDLiA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:38:00 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40286 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235780AbhBDLgX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 06:36:23 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BYHmt072673;
        Thu, 4 Feb 2021 11:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=mHGGgG2d53MLyUkuEIqroziYw7ExnQ/ohqpxpxpOr4M=;
 b=Y0hCE+2i8jxU3+8q/GAjPCfXQPIbpRPmDpqoph4SWO/bMCb6qj1KaRl5GSuL+pGJ1sOM
 0c0q5Ps4Ol3nABL165+caOv488u71K7bJgC3ScZf1SUBHxO27h3yYnhWJt7KCxS8J+Zr
 tHoESsJwHHyAhuISC68Dbx0TtcAl53jhX4nJSR3fgkuTE3azgmcqRmmlyhsE4vH8LSap
 w5a+ORNdlyQQ7IyAVQFtX/Tfp6IiLOGwUP/6GXG18ex4q6ZALCGZ14wnaBl+Ssmpfhfs
 URdDznIJH2J0B8S2ulTpRBKw6HEpVlPa9knDOwGT6rK3myvYXIdOb+TtBDAjTtvWiVAc iQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36cxvr7h0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BULCS037141;
        Thu, 4 Feb 2021 11:35:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3020.oracle.com with ESMTP id 36dh7v17ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cobSs7SZBWKX5B5lej4kREK8pqJR+W/5rzlOkp5i0QpUIOzneaFYw5fqaCMzfXwCnnqDAmtxQBtOH7slY4OPKY+6hNK/ZH5WykEa4PdnpEQRFkOsgFmDrX0zF+Bc0GHaBjrDZORw5RTtD9wgsuqFuD1NjNl6jb2UFbVXVTTnpw2BklbffjmGp+5SZ8y44rH9HP+D+GXItdV+ylwrYR/oECsuflqlMyh39ShOY5btG+cXhByLIqoKlThZj61Mp5oecVwkPuw8PPUhn0T9AlWMzfwQ0YT/0ec6pSCqCRN7qwGR7cavwCuHAT8uXOJ3yXYpPDWjoMfF8Eddc7udOqjeBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHGGgG2d53MLyUkuEIqroziYw7ExnQ/ohqpxpxpOr4M=;
 b=b0t5Om45b9FOdq/W4LzSnhDidZUIYZ70CNvIRPIzUSXUALvQXarHakRBnpnmuhoBYL3E6kGAuFIROudkfaltgBy/xH06trHcADHo8AuxxSeHFe2DbA+ztT+OlkaU2Fm+qF/B6jLnBiG06QBCAoRfdEvvv1mZr36w/UvpnPY0KKDGWaTuaPjWawZbKoKa08bgMp12pXLes4DAdliWyi5EJh8ErCRweROIqkqjnBhOr40VAmH+2jTIISy8RnbS201LC4oJbk28lNo9AdP1WuMAz7c8N51fPzJYmXh9x+iEcPjbLNS50l+jpca7E6VvhM7CyN1nyCK54jeZcgAEo/vBpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHGGgG2d53MLyUkuEIqroziYw7ExnQ/ohqpxpxpOr4M=;
 b=ysKWWMogR1zXgXT/L54rDpOU0Lo9q3Jqdv2TUUJxd3TdbrFhQRreFJpDILNlZJtbJOPSgK0wsaTIUPxOmlMG3owHfE6hauKSygr5k4+0AsOgz3/3hYWTRnOg6W5uNCiBtYgO9LuWQ3tGw8z9zsL8O/f0KD5HsMo8i3BdjIVN61M=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 11:35:35 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 11:35:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 09/11] target_core_user: add backend plug/unplug callouts
Date:   Thu,  4 Feb 2021 05:35:11 -0600
Message-Id: <20210204113513.93204-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204113513.93204-1-michael.christie@oracle.com>
References: <20210204113513.93204-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:610:cc::29) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:610:cc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 11:35:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85368185-bd7d-4c7f-a5ed-08d8c900fc94
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4480E03F1F8B93C812EE33A4F1B39@SJ0PR10MB4480.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qpwvW8mTZhWIkEU/tkov5jxDX41FhgnWviEoMYKFv49xbJ5WDAnR3jqhvbal5sz8SixbFmhZFdgT+Q9Imx8kPZArmSJlQqS/v+/zTm3WFzKZ72JG6Ri+ndnLPEIsWOC7kWA8IBQL2OmmYledg8ttyb0TnLqLLDhLAdKTAO+Rn3zCtaTCnPBn6otZl2vlbNTSpgNAwXSt8W9Rj9J8C7ytesyG6gv4MQPKiZl/0D6saG42IaihJXIXNcPqKHkWKjqoctCT9RCFzw3Xs6/ZwC3e/ZdvQpQI2NdzEK0Si+PsaWB6r/ROOKzE0STypcvxMxCOLLiRz4N/4rsKEEAH4kjtRKK7C4Z1oo1csdudWigPZyEste2ddNTci/hFQ7ca2jSxJYBKqNnuapyztt3p/Dv0CeLqb6pkVuaIY607xdt52SwkShQaNEqb+EpweLlXc3XUOjT5cK/Yo+ssDhnhSjDAge3IQdwbSsryHRok1fQ3dk4/TTM27nyWRrQbGTS1A2GDRHJQ+cAKjbDr8lhXegquovtiM+jwpLaNcX9osPndMQvuiJxQa4jojBzLs+GB+iw4I2PBp+Z+lyq4JvGMHRbNBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(52116002)(66946007)(66476007)(66556008)(26005)(6512007)(478600001)(16526019)(6486002)(8676002)(107886003)(8936002)(4326008)(186003)(2906002)(6506007)(5660300002)(6666004)(2616005)(1076003)(956004)(316002)(36756003)(86362001)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rMu3Kf2HX01WWPrGJtazTCsUx091Em46nxn7TPcengAzfmS4feEk3FKAv1PK?=
 =?us-ascii?Q?8cBJSRePMjQ2MvztRxp4xXbKeOeht2NX+MorZ3iDmeFpgZNT570NPS94iFjX?=
 =?us-ascii?Q?p3waTP/HJLfNON8hCxGz8GYmnhkpvvVXbfGahWADe0WyHvIme61xoVUHcvvL?=
 =?us-ascii?Q?56ykolGQxwtuuvCCP+euzvNpaeJq5rjREQeYIMOGld5ySn4iiot8nQh3U1ky?=
 =?us-ascii?Q?xx5lX5lUF6Xlua64o8Tt9bgxLS72WwaRJ5gRqk4HznvuPQLBDx07hJ0SPZvK?=
 =?us-ascii?Q?eGvHlqKfoodr54f1t6Fp8YTGM1o+1J0sEtyPr4dcqtEAtGc+r+Upta45hnDU?=
 =?us-ascii?Q?3VOK7xHmE2c2KsGDJlliDpYj8ELnpLbuADAwcJCzpJ0krKXCMVd66RbZ1SO6?=
 =?us-ascii?Q?qALE1D7bMQiJaEuToWlKRfOhjWaZXgL/LLb7d4ot6nQFCen6Jyr4RkfwDYJi?=
 =?us-ascii?Q?2R6Hw4358klSPKad/szCZh5XGh/BRreVKiitcGqnRmLoEcTvFrVJi1xR97ot?=
 =?us-ascii?Q?JpDOIoayV2OT2FI4k3j2KGnksfMOIZZM4Ou1HlB4p42p+tSRgXj2zepQtNgK?=
 =?us-ascii?Q?TTAyVKZnYXQUGXO94gCL1xnAgsF+73Oir1m9Av1szUM4VRCwqvXtroI6qNJm?=
 =?us-ascii?Q?kdEQX3q8+2UdE4KyEtaLxCTTpJgFr/v/jnVWv1yeCKRFFDzPqms/DSpXtx+L?=
 =?us-ascii?Q?gqFnvAd5CLR2kc24FibgnoajXG3z6Vfczeb7BU4qM8JbkwDjTXGYjMUzfwtb?=
 =?us-ascii?Q?uFsoBLmuhNFV3p5tCojVVzirtHq56r2en1SY74oY7LTkBnVqmuJA1xcb0csE?=
 =?us-ascii?Q?m0w4beRFwd9T7+6nLghOqZApf9LGGl6qFt/U9HKIemnLQgEE2o09TpVi6/Sv?=
 =?us-ascii?Q?XxPoni6D2pFH6OurlAA/B/jugLEG3KLuRNg+MGz41Kmte13Jy6Ztl3T/1Wyb?=
 =?us-ascii?Q?L/RlchMPbtj77XFpi/GT/qvEBgVlDUfu0I238QUcUE21HnQ3w1nRtUJS6Emn?=
 =?us-ascii?Q?lzC68O/WYUmRFfqwax9tuMUq1g4u2CCbQCa0ZPBmgXjyR5yQIyDXKeFTB/ch?=
 =?us-ascii?Q?LrDK1k9sgRou5IWpyqK9/81ENNfaHFnKqsDQz/3BKU6QUywt1P1M7lNt/8av?=
 =?us-ascii?Q?gNFU8IQy/nZNCkTYqoFaUicUOpFVZIDWhi2kMGx7bwI/q0md4vHKuCRYVYoc?=
 =?us-ascii?Q?0ncMsVKer2IO0pvwg8rjZmgYUeIU8PVY0uTTfyojK9qVjFlnpByilBNU1Xhs?=
 =?us-ascii?Q?WUIPxTYDvXK1r0KfSr5ISGbKr1MOxDwm1BnpW65yJaWJnMGbKiiK509vRe6h?=
 =?us-ascii?Q?buJeercdKx2nfiJZP8eimxMe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85368185-bd7d-4c7f-a5ed-08d8c900fc94
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:35:34.9007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EyzAYovtk6GNOHJuyQ2JiO1US8y/ZVz9IYYpFcp1aY8kK3v2Is68LBRLAC4XGe3iq3wrwZoDObS7euyEJNVm942e+5b49TL0whtLN9NcQ6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4480
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040072
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040073
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds plug/unplug callouts for tcmu, so we can avoid the
number of times we switch to userspace. Using this driver with tcm
loop is a common config, and dependng on the nr_hw_queues and fio
jobs this patch can increase IOPs by only around 5% because we
hit other issues like the big per tcmu device mutex.

Bodo, because the improvement is so small I'm not sure if we
want this patch. I was thinking when you fix those other issues
you've been working on then it might be more useful.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_user.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index a5991df23581..d67be2f959b9 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -111,6 +111,7 @@ struct tcmu_dev {
 	struct kref kref;
 
 	struct se_device se_dev;
+	struct se_dev_plug se_plug;
 
 	char *name;
 	struct se_hba *hba;
@@ -119,6 +120,7 @@ struct tcmu_dev {
 #define TCMU_DEV_BIT_BROKEN 1
 #define TCMU_DEV_BIT_BLOCKED 2
 #define TCMU_DEV_BIT_TMR_NOTIFY 3
+#define TCM_DEV_BIT_PLUGGED 4
 	unsigned long flags;
 
 	struct uio_info uio_info;
@@ -959,6 +961,26 @@ static uint32_t ring_insert_padding(struct tcmu_dev *udev, size_t cmd_size)
 	return cmd_head;
 }
 
+static void tcmu_unplug_device(struct se_dev_plug *se_plug)
+{
+	struct se_device *se_dev = se_plug->se_dev;
+	struct tcmu_dev *udev = TCMU_DEV(se_dev);
+
+	uio_event_notify(&udev->uio_info);
+	clear_bit(TCM_DEV_BIT_PLUGGED, &udev->flags);
+}
+
+static struct se_dev_plug *tcmu_plug_device(struct se_cmd *se_cmd)
+{
+	struct se_device *se_dev = se_cmd->se_dev;
+	struct tcmu_dev *udev = TCMU_DEV(se_dev);
+
+	if (!test_and_set_bit(TCM_DEV_BIT_PLUGGED, &udev->flags))
+		return &udev->se_plug;
+
+	return NULL;
+}
+
 /**
  * queue_cmd_ring - queue cmd to ring or internally
  * @tcmu_cmd: cmd to queue
@@ -1086,8 +1108,8 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 
 	list_add_tail(&tcmu_cmd->queue_entry, &udev->inflight_queue);
 
-	/* TODO: only if FLUSH and FUA? */
-	uio_event_notify(&udev->uio_info);
+	if (!test_bit(TCM_DEV_BIT_PLUGGED, &udev->flags))
+		uio_event_notify(&udev->uio_info);
 
 	return 0;
 
@@ -2840,6 +2862,8 @@ static struct target_backend_ops tcmu_ops = {
 	.configure_device	= tcmu_configure_device,
 	.destroy_device		= tcmu_destroy_device,
 	.free_device		= tcmu_free_device,
+	.unplug_device		= tcmu_unplug_device,
+	.plug_device		= tcmu_plug_device,
 	.parse_cdb		= tcmu_parse_cdb,
 	.tmr_notify		= tcmu_tmr_notify,
 	.set_configfs_dev_params = tcmu_set_configfs_dev_params,
-- 
2.25.1

