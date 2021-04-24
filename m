Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7875EC43461
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5312E61462
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhDXWTA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:19:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35618 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbhDXWS4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:18:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OMI8S3167844;
        Sat, 24 Apr 2021 22:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=yNeQUIdmaxsEFEYPv73q+fsHYITWeU7qxxIKAp14b1E=;
 b=S/ESETiyNoniOKjFGwZrWmvbwu3jrVWtQZnlaLQig2351zP/AZPjd+BMGmQtybnH2l4+
 Ogm++2+4eCIDsP/yAjeigbIBl4v76zkQ6B5PPXScU2MDh+UGRUDsmko1HR5hP2zCGnh1
 R3IB9qMfUEIyAGEl3E4eEGBtlf56YBX+R/aUA2Y0i9D2HDb24AL03b6HLYgJ2NGy3QED
 iIsTgE4HuLWeXXQnvPeCMcTvQKdI0PKZfwlAX4S+Ej5Ef4jPckvtlLZBa74baXiIKNAr
 5MIrTsYhAzJESBnyeO66oVLdhPkxvyuTSjFf0RVLeA7xZdxHkqgfxakPIsh/sbuQdLtF gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 384ars0t4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:18:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OMAPi6148236;
        Sat, 24 Apr 2021 22:18:07 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3030.oracle.com with ESMTP id 3848et2ejm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:18:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ocYz9y+QFiT9JT2HzxHMJy1jPArbLA7x8uD3y8m60kKPXEPOg5PcEccbClydn8cUDAvP/ff9N8tbQuxiPMYOID8GKg7Ru7KQwCSbmZW+8lwnfGimroqmLmm34IYN7929So1dYsgHvWtOFnSNWEtRjNvdUccLUqNKro+PEL9FL6ojR7EhvHjH7c8ZLGPvMd47OTaQUwc8lWwU/cy9/hZfENWXcT/tE4mzW5o5cbLunJ8N2p+zSLO3mwVKVrd1+mK2HcUHumbwQzSwquZoNnkDGowTB106ua6grrLWwpNRkzoNhUmIYjQTL+KHTobAdynEN33cTU1DjZeSjhbc4znttw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNeQUIdmaxsEFEYPv73q+fsHYITWeU7qxxIKAp14b1E=;
 b=br7jJTg63p4EfJ2gfYB836zwBq06sZXBNr94pX2COZjHuncfhUF7XuxYpnZsRcLJONMZ6vOPxNEQJD8cMRvRDTO08IBTxPZi3mmgd3onLDLSofBp9NaPoRAuLYdWXoPA6IVs/fIAY/fBZ3CmOxk99ygdYOa5KnASN4hsMI/RnpjYcWrmWg+2sSB40C7Zz3OzXRb/oy3JtpWc1PDgddZ/uKRmmZf59dWJaS2FS2/9OHVmqkmtVRtiXvwssZJlj2iS1HOT3gtWP0UkcGxK5LCkKnyDTUKtuJjK53BHkfjo9dsiQ4MA/1OHhRumbJB9/gAzab0ns7C6mHdRI4xPiVeGaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNeQUIdmaxsEFEYPv73q+fsHYITWeU7qxxIKAp14b1E=;
 b=oL9kg4iQtOOVWgJIZUQsOZ4JnxFOQCt8QDeZ8Tjx0WsR5Mn2DQErXyTqVjua59KTMv+gRbODIaZ1brxFlsHWaNcowjcCLC9IuMY4m4KJyfdza1BBpzW2QgyKMO3iXGF6bNzSPuPqlHBw77JzmEtg4ksevhnjeWaBxxjT01URoVw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2885.namprd10.prod.outlook.com (2603:10b6:a03:82::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:18:04 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:18:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 1/6] scsi: iscsi: force immediate failure during shutdown
Date:   Sat, 24 Apr 2021 17:17:50 -0500
Message-Id: <20210424221755.124438-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424221755.124438-1-michael.christie@oracle.com>
References: <20210424221755.124438-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM3PR12CA0079.namprd12.prod.outlook.com
 (2603:10b6:0:57::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM3PR12CA0079.namprd12.prod.outlook.com (2603:10b6:0:57::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Sat, 24 Apr 2021 22:18:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ef40dc4-de74-4e02-9a37-08d9076ed464
X-MS-TrafficTypeDiagnostic: BYAPR10MB2885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2885B628936678768B9E5681F1449@BYAPR10MB2885.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ro51wEBpx8oIeJIFtu6iQwV8wyuiouuXoJbUM+JskGOOtGu2HX2gm14CGKuwtBuOF7TggANOe8A60kLgqzNEfrk4rjpxaLMlV3/R8DIuFPZYJx5X73G1KL2vnTU7S/e55UmM9yFEnT6v/LzTv9hwG0L/T8rSRdym2d7pzcQyLq7Yjja+SlLRt9e7u9Y6v8lkTiGh7aQBVUiKx6kDjJS+l2ltVuMQlJ9537jQ0xSl87GxS/KLydekKQ7GT7mz2uIHuRaz2fbtIW3bap5FsTb8Q1vlP0Od7j1O7UZhVaqwvKS7Vhv10ABAgIrMbgPSVwP9a773rbwpuyUOoIpIolbxbxKRKeQT6F2qWIw4W7NoQt2+Yn44glTWFDvJqO/Kbm6c5howAPy0F8k/uK/dZwcPzJEinxNpIToocIGRSSW+jjr50treSB2yV3XrYl1tZSp3+SdftiJNyadz7adkUtN0TMLEtvK13WJFMtuqHoNJSZKhQ+LlzT797vqRLKRD14xcBKWiE1w/zIDPB0VUzRfV8desH5vqu1RgcEOj2mNixU5ufGN9PI/D7FBgeo/iBVgCRBv1rizF+2aQIXQNjF8/h9ijUwU7Yk8qh77Ledse3N5IYaj9v3O7IBdJ+L631l85ss0oXOUj/a3OLT4M4yrt+gRL15fE0mIaFNKUqS1Omf0zi4Z2J+op+vnHirDyLt3RkKo5bx5GlvD4HK/SV+Z3mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(396003)(366004)(83380400001)(6486002)(66946007)(66556008)(5660300002)(66476007)(38100700002)(6666004)(4326008)(6506007)(478600001)(6512007)(107886003)(2616005)(186003)(316002)(36756003)(52116002)(26005)(86362001)(2906002)(1076003)(956004)(8936002)(8676002)(16526019)(38350700002)(69590400013)(14773001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lnRFb23g8/Fzr4lZ/pXvd87SGZltBv9hc1JrQ+8SAS1UPBLdDtqsm8brd1oB?=
 =?us-ascii?Q?YrgTydNPUsdJXCJ5CSBghBmoWA9NEUGJQG9RNMretGWqJitUt/MqgZFHNXpa?=
 =?us-ascii?Q?jku256xfJiFMVRj5EbuIzlSIAkBt/AiJRQPsX3LncOjW8gaKKmdSvk3//MdK?=
 =?us-ascii?Q?xL9P4oq8sZnLh3iWQBD2J1Zf8sUbdz0ZksUSEPzok4lAAlQA+9NqCElECkmr?=
 =?us-ascii?Q?6+vCWdNnd81YOmOdSZq6FBv1fqCizpWKQWYJKNEPuq8rCz2JGjIOW4w7QHrj?=
 =?us-ascii?Q?avj0z3kYS90o3mw3bwk0fq4oQ5HCwHS7h1PggRQoZWpTTxjPTlVwHUa2gHzz?=
 =?us-ascii?Q?KPMtCxNwp/PFVbQdadedkrBFlFWu5b8nd1Opje0zrmfHls2qXbN0uzJ5JCiH?=
 =?us-ascii?Q?zFvaNdoP+4oi56/r4ER03v+unixd1Vcse7UF+r05QsXUHT4W2RwHXSRTpKbp?=
 =?us-ascii?Q?J1XOOVc+PAsWdz8RbaneSt7/aJl4kGj6N6ykUnCNTTxOZSyUB1WfrGR1+hns?=
 =?us-ascii?Q?k6csqG8sOv0gREVWGN5nanLrf7HzByYF9O8MzpbSaDdZz7U8MqDVZ7QnuAtf?=
 =?us-ascii?Q?GYwi1fsXRGYkAwm4l0YaTLxd00BRMZNqYDUoRLLDv0CP3NFV9sGmdX5mnt6W?=
 =?us-ascii?Q?S1FdkcY2WwTih7Ob3ON7kaFlimqA/+PS7/AbkeAeNXwCYBfxHvfSzk0u2XLs?=
 =?us-ascii?Q?ZioZraYpT1HOANmiDh9S2vac9wz1hpjjboqE3HjQBX0nNgcHM/qZ4Zwr/YLn?=
 =?us-ascii?Q?cDL2HCruTGi+bwVJuagxCJhpXXsYuZx0/j6XIVmNcUhjeWwVMZQyq+0dt14O?=
 =?us-ascii?Q?iZQgDFMkSfMS+Ff7pvR3F9XBsWYtWku8hbUvQEmNoqjc6M8fYlb11YQuiacO?=
 =?us-ascii?Q?+mdiC6MFb6kYAWwpgWbisll5PXjWIvDhwZz/2E1gKr79I2FExcP4XVkcVpH7?=
 =?us-ascii?Q?UVyZSy6l0K2G+AmmtgaP6DDTd0LinkFdoCYYWn/Ec3eqiaMEM9E4vP5uQ2Sq?=
 =?us-ascii?Q?835KBxxBUXvMZvsz6D7thvQw+Zg/Zwl+N3wOdQIbdLYxsW81vDNch4sfTuQP?=
 =?us-ascii?Q?vaWEofxiBRVLfuXXzvWHioFgMJMIFr2tSB1Ps7+fi0L7XUsaNQXvMtcd+tYY?=
 =?us-ascii?Q?NTftAgnkis2g9kfoRGpNtnmghxXfaw57TJEbDwdtguQ5TRIO78bp7qKN9TY2?=
 =?us-ascii?Q?+lNRGp6eQA504H+1Ge39pKWQ4VOAofgiy/+TIQzq5EtgIZDKPQeAXgDEgbuZ?=
 =?us-ascii?Q?VyzYl8sJ5qTmRwRGDOp2iZ4e+RsHUrTnRVPb8hYEFw89vnPlhW0ueCGCCmOq?=
 =?us-ascii?Q?eHauBLY/t5w+ozSAHGRfkC3y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ef40dc4-de74-4e02-9a37-08d9076ed464
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:18:04.2404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ESaoi8tflgPfCb8XyZo30bNPK4P94OcYLdMQnzYm9XCUPVitCCv2UtTI4/pGfc5l+LQKkxCwSltXirLcwo0fxGVLJDeE2++y0g5qnRguYH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2885
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240169
X-Proofpoint-ORIG-GUID: H4GO3kwWmZkkGp2Ki7DIqqAr4KPTO_0O
X-Proofpoint-GUID: H4GO3kwWmZkkGp2Ki7DIqqAr4KPTO_0O
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240169
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the system is not up, we can just fail immediately since iscsid is not
going to ever answer our netlink events. We are already setting the
recovery_tmo to 0, but by passing stop_conn STOP_CONN_TERM we never will
block the session and start the recovery timer, because for that flag
userspace will do the unbind and destroy events which would remove the
devices and wake up and kill the eh.

Since the conn is dead and the system is going dowm this just has us use
STOP_CONN_RECOVER with recovery_tmo=0 so we fail immediately.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 82491343e94a..0cd9f2090993 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2513,11 +2513,11 @@ static void stop_conn_work_fn(struct work_struct *work)
 		session = iscsi_session_lookup(sid);
 		if (session) {
 			if (system_state != SYSTEM_RUNNING) {
+				/* Force recovery to fail immediately */
 				session->recovery_tmo = 0;
-				iscsi_if_stop_conn(conn, STOP_CONN_TERM);
-			} else {
-				iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
 			}
+
+			iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
 		}
 
 		list_del_init(&conn->conn_list_err);
-- 
2.25.1

