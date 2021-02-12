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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78763C43381
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46B6D64E39
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhBLH1q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:27:46 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59526 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhBLH1n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:27:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7ObY8176673;
        Fri, 12 Feb 2021 07:26:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=drov18IvbxJcf1RpDKUP9FgkY5cU2xGkcthCPJKMhSQ=;
 b=pLunrxhbN6CoTYtASY4VmGfeKFVvWNi2wJKaY3f7U+5drkS4OmS+WLSRRgeFOy9UCycA
 cQ7wNlurpnkD/Ti/dHTg+DEeut8O0tpXu1gSUK+ZzQ1ck1JSnRKx4FQJsdsfCQAHtMVN
 sQMhHlHP3+BM1A8xOorRhbmxeNUjgTywo0qH2r2N8yJKWFyPA0JdD6aSxEt6H2Qt/uPu
 EkhR9bdm9fESaceLuKzvAoCT/jNyHdMx98GxakaPxM1RQ4y51Kkms58FntOTHK0ivHqq
 7HoixMgm/IgP8KaD4sUE92S9DcD6J/pT5sH4hezJ5V6EaIEMch3IzMiz4dT4L44ppfgW cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36hgmatavj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:26:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7PZdN022757;
        Fri, 12 Feb 2021 07:26:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3020.oracle.com with ESMTP id 36j5155a2x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:26:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRfHEcNo8yeCcQi747mBTNgvWwqojC5zGDk/RPl5/dTyNeFlFa6mMWhxNXVfoBOJ2q5cIiVwE6tEKcSSajixCm48T/9zv4HwBF1oNrytPnUYFgRqqVt29qUDHrAS3KgWoVumQfYH1EbHECT3P/NZQFykF/f6qTQiSfWHMfqVRavRp8vjbutwcn0KJB/pzKJ81G+rndGabr+LtzpI8kfZHl5z5y0zwK8oDannFNHasWOrwVVl4mmGE1zgbnjYnDDeAscjB6hDWTnTYYfjshoiMCZW2z757pVs7tn5++RXr6guaJR0Jz6BaF0QBkD39GKrbT1ulJes4xfpTgKwUE/m5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=drov18IvbxJcf1RpDKUP9FgkY5cU2xGkcthCPJKMhSQ=;
 b=WT0YJGDqe/MtdZqkj55TqYbi7m5wICHnM2lQDiCiFa5oDUl/5SXpTjjTjUvmjycQDnbRJLLNyGmGXNmyzM/KF2X3fKiDDaAnpEwjXLMe3XdtEvzYghnQAYTh2hf5MhO5j2rRpGyNIaQZLQ17DGkFS0tO/U6vic873CA6gcImLP2Cub9ZxmuYv7ng7NhBX4fSYOUT8/p1excIgwOfXoPtLSHjY9ZQ2nHnuEOAnrRwHS+SB6ZQiGE+ss6RSv3CfSmP8v6UxeRDY3DAETYkRr/byl0PAomvuuonmDdFcsSGxY71gVbbvke5tZyY1SjgL1hihMQpgqx8dxZ9clXe4CIryg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=drov18IvbxJcf1RpDKUP9FgkY5cU2xGkcthCPJKMhSQ=;
 b=YlG9Uh7YeY2arGA3zPuzZ6sYzWlNt98kmDoPK5RorTi0rvOZX6J4C2+sH8a2PlwKZBJhGtN5WKNXcRSCcbkNg3KgV1O42WbutC62361BLPCAwYkS5TV3KWXSlCt9zF/uwuryYSk3NOiNrRl4g5ZbWJNKcsekXpKDrmOhHS0Lu+I=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5256.namprd10.prod.outlook.com (2603:10b6:408:12f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 12 Feb
 2021 07:26:52 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:26:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/25] target: move t_task_cdb initialization
Date:   Fri, 12 Feb 2021 01:26:18 -0600
Message-Id: <20210212072642.17520-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:26:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37770d7d-5953-4c7a-8426-08d8cf279120
X-MS-TrafficTypeDiagnostic: BN0PR10MB5256:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB52568968F5FB0DD87010B9E8F18B9@BN0PR10MB5256.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ejj4rh0AV81bBe8jfRxiLBFXjWA85Y+n7X4tSK2FEMGScdl2DJipiHbAjsO+TaPb5iXdCJJYhoM+6qfyl1pV13cjKZkwoG/BVSeI0MfTEUGaYvvzEWRTL/D7GaRLip+mEy7bnM772q/DG+XEW1fNviZLMwwESkg3suVS+SuJkcWsf58Pn9B5VmU8xs/W4aEftPYte5HhdFQPz5ePlwL2VGPzs+nkrmnqtCLgLBCIDQwj9mjzzIAOjSAw8mzKo/FLNBy3VSbno+hfzVv2pkoHxNwBP/7oaS5TAdljAT0xQDcEe+AysbmgyJ9mNOfrSTyfK6JeaUe9KjvQeQ0+DpbwDYP40rdsjw980Dqv3/IRowr//TBd8UdMGh8GzJ6dptyAmf25iOQHzTCVPepSgGGFO7i3xJIkO7YTzpTOHWAhuFGw7FhopBAUoNXVzs0+mGaVhFMEThzp50QMt29q69PgkYkYQPR9iYmWzyMNfvJdremIlCkNbV8M9sJpo32BD5c23FXsTHRtwGESvv0RrMgrJ9T+uQcKo1AFmVL88PpIr8aYVPlyrNS4Y3V+BMrSuCpGNJ3P0ITn9b3hffjoCOlAqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(478600001)(1076003)(107886003)(6512007)(83380400001)(8676002)(66556008)(5660300002)(316002)(66476007)(6666004)(8936002)(69590400011)(4326008)(36756003)(86362001)(6506007)(16526019)(2906002)(186003)(2616005)(956004)(6486002)(52116002)(26005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?txqG44vguLV8id+UnINMMNEJGQcE9B/5LeVmJYT6F/BVMVpIXsUzbFb53cXQ?=
 =?us-ascii?Q?RbGDImHs+b73YK/tEKm3h1st83+HsD87li04x0uqZbFD3Te+zn7s5J9gYsLu?=
 =?us-ascii?Q?WK+nt8E3zx++KoevSZSoFCNwaExzFvRu9AVqKRynuxKKJyH1a9yD4iyH9klk?=
 =?us-ascii?Q?Q9PANg+KEpHkG97tbo6ZgeoB6yaGcaFsxJIwIP4Ij6HckkjX4LRZm9EmpUW6?=
 =?us-ascii?Q?B46V1kOK4D3DiWqy/KzyGzYU3+WvEF6eOjwRuZtvwPyaFdVLfb9FV04vX+Y1?=
 =?us-ascii?Q?wzJSv+nQ8kCY9Eud4Gsa5x22L/B1Y33ncfeCQjeMfZms5VXPwXC6PiRHGvBg?=
 =?us-ascii?Q?Apy2owZeehDk1dSm1Hn4l7wfE7U/gIFgulUS4uzRl9LBodmOzuEYrh3RAK4g?=
 =?us-ascii?Q?e5/cbXhNYSEzLZI4UCIpEYKHaLH1MjePwk/IFLuJQQD3c2RZyhriHegLVD0R?=
 =?us-ascii?Q?XTVzx5JD2GGvDrlp4+coh+tg1uMXf+Ij8J4MqVmWgNglfgns3BFOPgRQoDVz?=
 =?us-ascii?Q?3W7T1PdiJ2RSGeAIanNl6yVxoKF9p/rKrhsDGVuqHXmgRdT626BleUATIShh?=
 =?us-ascii?Q?mpqGkqD7aBmNK3HiAfinCTC4p/4/kPzIq+ByCMozw7vkDxiRuS/18C11e8yV?=
 =?us-ascii?Q?x0rpvDvCDTGjGnm1/L4bURjbab13xz2fKct7HnIYigZjpN7b9TBE+3GwdFd/?=
 =?us-ascii?Q?+/VRwZYnopMd2/Sgqu4sWmUf5+3So5rE6bOJrXCCR979OOgxqL46OOpKdpj4?=
 =?us-ascii?Q?VOA6E7GU0amHYmgVFF1YxBNk6ohMpJIRPn8N3KB1jfOgLlO+Au4YEL1PLAbp?=
 =?us-ascii?Q?yQt1MX4DrZniHYDyPFqztYBYWLz1vT0qYFJ83BreJMurDyH6C1XEqa+6IUgI?=
 =?us-ascii?Q?cG0sKNWbNFzDPrVs4PWYhFsT05aqPN2wrOh1noz7715s2/ZBtjgEQ0gmBndN?=
 =?us-ascii?Q?T/2AN4AK0NpWXAy6HCSj/5bso396f64VMJwOsFw+HR+iijrO0bwvQOXl2ozh?=
 =?us-ascii?Q?qhvWQAS4sg35DvmsnYpYLTv7CjPpbWp6WbN7tTVEPcECqeoNHHvmI/JPH+WS?=
 =?us-ascii?Q?Mx5Cw+oGT+Ex5jgSbHDvIVJYaef7EsQCiSx7ePs8hQiDgINYPimvJpJT9r0b?=
 =?us-ascii?Q?bXMC95TulXSXM2vzFKDZHPh0cpcgEY+0/Cs/qrPdqtp/phVvKdCgCJofJ+V9?=
 =?us-ascii?Q?cZIL1e3cy6/osImpBvQOX/iqu/sFRvGEdfQLsuo6LyUuUZMu2EFESSnaw7/R?=
 =?us-ascii?Q?yGBvzm7EGTM5ogAcCCptAKCmPPBTLxQ5pn3N+6rqp+IEiRxp94pJZdr3Rvnu?=
 =?us-ascii?Q?24ocBfSZV+NNXDhPGLZcykEG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37770d7d-5953-4c7a-8426-08d8cf279120
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:26:52.2644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BGtk1/78iPi6vtcu5EkDuJ2XEsd5GenlHR43wGo0tnL19DESjy1QsYl2/k6eHVecu1WSvhJRZDRej3NZHg6fH8htywUANz3mVVfffECBW5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5256
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch splits target_submit_cmd_map_sgls so the initialization
and submission part can be called at different times. If the init part
fails we can reference the t_task_cdb early in some of the logging
and tracing code. This moves it to transport_init_se_cmd so we don't
hit NULL pointer crashes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d47bfd8b0f87..5c4adde96d5e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1389,6 +1389,7 @@ void transport_init_se_cmd(
 	INIT_WORK(&cmd->work, NULL);
 	kref_init(&cmd->cmd_kref);
 
+	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	cmd->se_tfo = tfo;
 	cmd->se_sess = se_sess;
 	cmd->data_length = data_length;
@@ -1430,7 +1431,6 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
 {
 	sense_reason_t ret;
 
-	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	/*
 	 * Ensure that the received CDB is less than the max (252 + 8) bytes
 	 * for VARIABLE_LENGTH_CMD
-- 
2.25.1

