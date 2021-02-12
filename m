Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1A3C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A52464E39
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhBLHbE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:31:04 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42340 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhBLH3x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:29:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7Pxpi017197;
        Fri, 12 Feb 2021 07:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fykfHGcyaFRt5NhIis3zRliEuZ4j2G8ziMADvFSZUI4=;
 b=NjnIVcJukboumay0O4ZB/CRq7wn0wBtoUyZ2yX92WRLdF8tqZxVD/0Tw1kd7pA37vmjw
 uWlyyT3imZLX4jUYUlGS4aL2hJIGe41DG9lBHOG1n7ZyVDfTwYQbnhZxSsVEyWGkQMYl
 1JbyvUsvZ21aAstKA0xPOGsi7B03jH2/9ZJjxoGjLVQFALVnZbgbLTt0/n0YJnQZvdtz
 NLi/Mq/1e6pa47a9/YtvxK8axtv+5bl1ytooe7KvMXQmLBriTXZ/FVdfVXKDM7vIJGyE
 I0cxSUy+w5uLraSgkNZCwmKX70S9k/9elDHoZyyzO9SE769Ve4GS5Z7aSJ0lpLY+ZGDv rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36mv9dvcum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7P9RO168446;
        Fri, 12 Feb 2021 07:27:06 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by userp3030.oracle.com with ESMTP id 36j5214tpg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7ePDJ7Dgufu/enYxSp2coAJzL8hf/f5V2DIQ3FrYapsaAmjmJlN7ijvFS9e5X05z7zc1G123ZfqGgJqcXFO1v3ngIucYzWTSM2M4uLaBYGN+AY14zYSP/jNX201Y/zSYJ2Z2WW/Ks7NNodvlr8melHcbxu9uehHrMogtGvoKhbe+Muc+jg2RhrW46JsT+Fhi4jp3c8LOX3e5aC8p2b7CcZ1aMBn6VajgL2o7UXGhVMGQO+qX2cnvI3ZAMh/ADtP4QKZDpQhvAlG9v8L2CyuNiOo8OhUDbs5xUggbxV/NjVDwkmSu0AUWo4l4nr/CfhMykpJsvy9TDkorIgdRRyBPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fykfHGcyaFRt5NhIis3zRliEuZ4j2G8ziMADvFSZUI4=;
 b=m7+EHGczbaVTyf6TFtFHIcLSKlKU8aDPiaHmlkHnTWA3rOIKF5lytm434CvzdCoPUDpCd5ChhO2bx5SRujDuuC8dFe8v2rWJtAzA5gnSo/LEWtfMWYh/T19ydH79cWEVhC5EXc4plJns0P5bT2YxIPOFpyL2qTNLDltmauMi14saO935IazKw4lIklv+coT5ZTTCCaYlNXwzdGKygAJlk7IvjQwg3u8JmwqXMC9/S28hgGPVZVB4+2ubKColl18/R7D4LUI915CojdU47SxrPHLu0+Q/M9IB9MT02LSE0bk9oigdrdFiUe7wZkVTxx1qWR93K37dUo75Lk09I1+QAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fykfHGcyaFRt5NhIis3zRliEuZ4j2G8ziMADvFSZUI4=;
 b=QVQR1wJyS2MSnXQUliK6XSFQ7hVMCgI3/751Q7KET+cH7XisuZE1RcuOouy12HrmCyODYH1aHu2WH3B3JYY+CCPEO2bvhaQ95yHyCG+uimdRiYlK3e8BCUGYwFA+BR4jgdPN4Nj1mq5tbyqxL3Ii1fv99PfM1RFiIEFujV+lGLY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:05 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 12/25] xen-scsiback: Convert to new submission API
Date:   Fri, 12 Feb 2021 01:26:29 -0600
Message-Id: <20210212072642.17520-13-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5370e664-764f-4b55-d900-08d8cf2798e0
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5254114B2AA05077E13AF62EF18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:415;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HVQ18sSYv2MNO5mrwsHsrSZw5dG73Ww/TqLLUBYAy7sLTOUdAJQeP5aqxaudOyUWPbPpG7bDZQtU2A38tzdSZJAH6wALlJB1wS9UyS9uBRH5fdfiBvkAqEywB0sViTUFY/4QOZMkn1IUi2YZzpO4ryL3LC0T0Ev8+Fw/EHE44KzfNTVhSnk4OWTGLm445Iau5A5hVRQmwT3DSldP4wt4EgeXR8HfEGT36r1vDFwyuJzw0zhjojHuQXZwMaqwV3KJba2ZMpMJvgnwt7LgMO8ZIntfK4W1+gY6nslG1it8rV884R71BnndObG5BEFhKGqrarkLr6hoELj5mfMJz84XGkSa5xi/5gaBgEERCPKbs8yhi7HN5TJp+mM2dXI8R7JTVKeEPtnkloYf4A/Nuq3e+R3mcsjFS7ZAh+LBjoKJFW4b/2wKoFnyXH1Pz1UWHu59xiTPBGbNAq+yhnu6b9E5xJcqvr2tAg34VGZyzqE5ZD4YNXLGZA7J+cZYE0K5Xg41jvPAT/bdEmcZXTQl/csK+NBUX5XoNmedB3cV3dRlxRAXdtI2N2wVtDtVIYo46UMfk7jC87oRJHeT6HOYRfnfEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(107886003)(26005)(956004)(6666004)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NPfrMdncgHHFzC3qDPTxgHbu6P2wGatFxj2mq7kwAdxCnSShgqcmxCijXt7b?=
 =?us-ascii?Q?Zwv1XTGgD15J505KFE1C54mZDlEpyNoZp13NUwNIDLKokeo26jXqWXg9xpH/?=
 =?us-ascii?Q?n/bMJHzFqiE4hCviib+0UNGLQ80L7J9YNRgNJ5ZZrEFfGXeVnrQpd/bjQ4a1?=
 =?us-ascii?Q?0mkHBEJB1bQRn7CZGa69tmmBFMnfswI4yTKunMsU6MKbXH9GR6WZYRivIB+G?=
 =?us-ascii?Q?5K7lnNJ9ohh/DKDO/MLPv5Rqg6qNVNiqb/9Vw1q0uLF6wTxUwhn9lvfMFHvw?=
 =?us-ascii?Q?Dblnq3U2mP4izPvYVnheeZcw1lUIh0PSiNv0g1uwrN3qrQIpjOeZeAAcQQBw?=
 =?us-ascii?Q?NTBJWFMY+t0q2VAOljOGfj5Y6mRNtHX/OWMgDHccOMykiTQggeFJDTj4INYD?=
 =?us-ascii?Q?ux3DD10CchiaYe1YG/p5xMssbgSxmPs8TKK9BxcMdMM3iVE2UklmdAJdgPA2?=
 =?us-ascii?Q?KyJWVix4GikFWivhHM970ajOlJBMt8c6aWZxzEo4m8Q3A5wu/ClQgKyHEw0F?=
 =?us-ascii?Q?4Re5GlDGDjsYhm6HI93TegdN76NiR9pLFcepZ4Z3fdUjMfpwzZdjP2A1L+cI?=
 =?us-ascii?Q?uaKL0u9p9JXKKPN/GKoayGIr0eHAbDEOCsP8XDCswPiTNQVkvFpga5NYlTa5?=
 =?us-ascii?Q?pf1hdraBWz4ANL1aATDqlqRuBix36xQC44ZThs3fBxQyaHPB6QSQstmnW9ff?=
 =?us-ascii?Q?3YZy449X+7JjgTdIP7osv17dylNaGUg2lRrz3NnSZT2Grb7gcceGjZcnCMIC?=
 =?us-ascii?Q?49VAndxKMa2Xm43GewzYCbAkr1puLjM/4YryDeB2Mw21FkurOsoPZfWl8eKs?=
 =?us-ascii?Q?f++YQPvTXx3FZxrHsbua3pRtQdVzItrAtK7fp9NU7cbzlPHRoHnnkoyIYL6F?=
 =?us-ascii?Q?dr4A2c7Owv4v4OReiFOzM2kpzPCix9UsKuL6STJZ8qqOX7T57/QTVr2kJlRc?=
 =?us-ascii?Q?tFm3gdK7LqFeG5L6LiGVbNnvpWOu5twd6FMOINT1CeM5BnfIIA1q5rlXmcEu?=
 =?us-ascii?Q?8ZXWow9ZVY2DppNbWGuKzcSrUQv0FYYUbliWS+iFojGr36bNwRDHzkiUkZr7?=
 =?us-ascii?Q?EBYG63JM82LVSuy8EyVoX2JpEtiOS0j0mIvX30q2Gt8dqAKyuLEkbW2BBwaB?=
 =?us-ascii?Q?SUqPRm+m2fkze3CkJzG0k8lqsTOwKmumaCSO+xK3l2VrHB75I5fcyRZT0Pv3?=
 =?us-ascii?Q?MxZg4ac/8ueaUnPkbbki4v5RvOBo7skJoKOOY54We3WWzYfireKxT/6+O+oV?=
 =?us-ascii?Q?rJLuVAhCex+eDsRbT8HNsUxDUeZoJZPXi1DA6U9g7Kz+b39c4fvtqsi4PryC?=
 =?us-ascii?Q?0WL0WZ9038Jo8oXA0dHN4ADG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5370e664-764f-4b55-d900-08d8cf2798e0
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:05.0250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C4IDYSQn24EWPCnSTlKicGZnKMgrmlnml5Ob1xipaeVv2Vkw+Uryr34m0XJrutJSOIslkiKOjG2OVMG9KqjWrDOWwptCx538y/ENkP4JswU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls is being removed, so convert xen
to the new submission API. This has it use
target_init_cmd/target_submit_prep/target_submit because we need to
have lio core map sgls which is now done in target_submit_prep.
target_init_cmd will never fail for xen because it does it's
own sync during session shutdown, so we can remove that code.

Note: xen never calls target_stop_session so
target_submit_cmd_map_sgls never failed (in the new API
target_init_cmd handles target_stop_session being called when cmds
are being submitted). If it were to have used target_stop_session
and got an error, we would have hit a refcount bug like xen and usb,
because it does:

    if (rc < 0) {
            transport_send_check_condition_and_sense(se_cmd,
                            TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
            transport_generic_free_cmd(se_cmd, 0);
    }

transport_send_check_condition_and_sense calls queue_status which
calls scsiback_cmd_done->target_put_sess_cmd. We do an extra
transport_generic_free_cmd call above which would have dropped
the refcount to -1 and the refcount code would spit out errors.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/xen/xen-scsiback.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 862162dca33c..7bf9a6bede6d 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -360,21 +360,18 @@ static void scsiback_cmd_exec(struct vscsibk_pend *pending_req)
 {
 	struct se_cmd *se_cmd = &pending_req->se_cmd;
 	struct se_session *sess = pending_req->v2p->tpg->tpg_nexus->tvn_se_sess;
-	int rc;
 
 	scsiback_get(pending_req->info);
 	se_cmd->tag = pending_req->rqid;
-	rc = target_submit_cmd_map_sgls(se_cmd, sess, pending_req->cmnd,
-			pending_req->sense_buffer, pending_req->v2p->lun,
-			pending_req->data_len, 0,
-			pending_req->sc_data_direction, TARGET_SCF_ACK_KREF,
-			pending_req->sgl, pending_req->n_sg,
-			NULL, 0, NULL, 0);
-	if (rc < 0) {
-		transport_send_check_condition_and_sense(se_cmd,
-				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
-		transport_generic_free_cmd(se_cmd, 0);
-	}
+	target_init_cmd(se_cmd, sess, pending_req->sense_buffer,
+			pending_req->v2p->lun, pending_req->data_len, 0,
+			pending_req->sc_data_direction, TARGET_SCF_ACK_KREF);
+
+	if (target_submit_prep(se_cmd, pending_req->cmnd, pending_req->sgl,
+			       pending_req->n_sg, NULL, 0, NULL, 0))
+		return;
+
+	target_submit(se_cmd);
 }
 
 static int scsiback_gnttab_data_map_batch(struct gnttab_map_grant_ref *map,
-- 
2.25.1

