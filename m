Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA43DC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 00:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BB816120A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 00:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236139AbhDLAv2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 20:51:28 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42512 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbhDLAv1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 20:51:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C0ouFY065721;
        Mon, 12 Apr 2021 00:50:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=xPgGNTPZv8tVFH2XfDVKdMvUvcfXMspj1YtoOj7Lzrw=;
 b=jhyustRw6hhgs48jg3Q9QLohM/Ne3EMZZr7icANcpj7GXmiXaRiwWk56HToidi7nhz6d
 6Q7rLe63w/1RULgnH2o9pVQ8MmNGH93WWkUqh0Fr/Tq3oi/ZW1rYqdozIFeDQIsaohOa
 Ngi5j6Uca8q6I2ZvMYaZNQd+Qlff19VlQsp5X4XA8E553ls1P6EXQG57jpM7aAh2W9Au
 Voijgaz/2E7Bu1HhcgM7nK2aTYwr7GSBSobfMVBYT7T2agB5aAe2vpd1fVpFm6JLd4WY
 LeDwjmrvmN17nJR9UqxPLwkp/Ddbo/fr558Gbi3+NXQZ+tQmuzeeM4vjCN9gsqa8KcTv NA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37u1hba3u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 00:50:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C0aNPA051826;
        Mon, 12 Apr 2021 00:50:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by aserp3030.oracle.com with ESMTP id 37unkmf7xe-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 00:50:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNyIpPWNPWpBzn6YuRnJDHiiqZcg3XHPFlSMzDGwf2GwTyxjFwwjLnsIOIs64KEYx8vSNEaNU19JPrNSGUWwoC1nTKSlWoZjriJ0fRKG4ykM0zy+HC2R7G13+8FI1AnFzSK1DXwthv5deb2yVXStxBedQEQCpW0t3NvFqa/to1g9RAcFwUsSvv9xsg77kr0CS27vG6new/LclSqhY6LAbDh32Y+jRBU3E4JuDXMYFU/UOLsuije0qBSLjGhFHe92MbyT34+YGM3KjjFbjeHKhJq9ymegauxFW69fGIOWr4D6iw4iMNDSP5jJhW3zVmSJb6Rb4yTyhDMTNlOEflIPAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPgGNTPZv8tVFH2XfDVKdMvUvcfXMspj1YtoOj7Lzrw=;
 b=dWnnGs75QoF7AVAtPNAra12SMA5hcsq+WhzNoqCZpLZWB/f84Dv7paM71nANBLvjz7gAFO3ZPthAYXMTdAg/h69yOZjtymEmEq7mTLYv8RA8/GSm3Vc1iOOGUb785dQRtzb5BS9/UX4UgOKODAVNE/dyuXXocM0aUghsn/myixkbvxgiyZRBM+p8v+QWAL40soBdwHIX8OXO9kPPl0TMYq5rHDIFEX35q3Ixui4VcjhM2OgCBdPhIfN11fkhixcD9ON3h0gGNkktP+Bs4hHd7VkS0OE0pBqLVbmsgijcmbd6O5g28BrdFcgHn+ie/3IhQZh4gJu670q2hqE9zBP2Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPgGNTPZv8tVFH2XfDVKdMvUvcfXMspj1YtoOj7Lzrw=;
 b=O20Ix0JaR6o7UgefDC69cO6/hJq9dXEErYLaJxr20P3nQcpvcc8sWx3hn+ImtwW/nw2Kt7zoheHqLDxb2DSsifNI53v+UizjFIHAsm32mYZFT0vUU9RhTnTE1QtfEN8pcqpgX1teDATLegmcwav//gUYhkNQZNa2MV7AQEBX560=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4307.namprd10.prod.outlook.com (2603:10b6:a03:212::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 00:50:54 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Mon, 12 Apr 2021
 00:50:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC v2 2/7] scsi: iscsi: force immediate failure during shutdown
Date:   Sun, 11 Apr 2021 19:50:38 -0500
Message-Id: <20210412005043.5121-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412005043.5121-1-michael.christie@oracle.com>
References: <20210412005043.5121-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR06CA0062.namprd06.prod.outlook.com
 (2603:10b6:5:54::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR06CA0062.namprd06.prod.outlook.com (2603:10b6:5:54::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 00:50:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1820a55a-8fca-4e5c-bef2-08d8fd4d06fa
X-MS-TrafficTypeDiagnostic: BY5PR10MB4307:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4307E155373DB9F780BB77D1F1709@BY5PR10MB4307.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T54IDnxsEyrRoEjU+feeuTT37JUbw16yPmY1C/4p73JEs95wZFN0JfFtDvH+ieLUj1KuCvBAuj0XkdwDUs94IEQlwVOjKUpmmfPySf6M37iLsn3p9WA0dBMN/hMcJGCBZDtGXdXhl4Ac/X4LYPRG/dWTxHtsegnCxiAxPizzc8ZCJoW/l5tzgHqQ83CTDSbeXhWLBPDbIAF0lSb/QAt9swBpj6utpFLGCVYXo4z6KSJuaiOsYZ0bfMD+5BVUEygxHyo8pk8QzN440GkkwCDiWbgPdWXMyMuMJjuiN8nSkamYYQ+IRXYis2PBOB3CU2nUP1xV08RJyXTbZuxdpDYNJop5sxGrf0GVmHrLkU5uI0OJN3GtHCxjIjZ+EgZB21XFEN2tOpZMs2d0NunSEctftXFNK91+0b2zNRtPHnzFsLcPzSov6l/wC9ug0iAyN9Pk8RVJuzsIDD0I0njMHJKf9PTNo3NSv/SThubNzRyEkXByYv/BffLKR7qkpO3+UMgR4j1Tq4YksnJgXCKeg4rdBpbt8QlZ56DFTri30igyvYXWYsr0qywBP0xSfRKtED38fK+tmEBidA2fAjNSWObW7gSkRDBpig6DoK2SD2oZkodevQ/3Z8lXChswhEJa1WG7lOcCWzFX66EHWgI6RLffKOCtiFNWqo0Y2f2ItamsNlGvkT4ubpsD0/0YoaAevD12DXGXWKQdH/j6ST8i71W+eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(26005)(316002)(186003)(16526019)(2906002)(86362001)(83380400001)(1076003)(4326008)(107886003)(956004)(66556008)(478600001)(8676002)(38100700002)(8936002)(69590400012)(2616005)(66946007)(5660300002)(6506007)(6486002)(38350700002)(6512007)(6666004)(36756003)(52116002)(66476007)(14773001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KJ6Jlc5O+hssvJYSJR0fGj2JaOPVE7bbrCFdlrPo7qkwjyGoci8K3IsuUcgi?=
 =?us-ascii?Q?Ny7SePxk7OOPFv+1NZqVajJA4rzgelBy0P6ypr6lvuV8bZ/gYxrhSc9++fFo?=
 =?us-ascii?Q?YyeZdOG4nJ0g4eeSUZ6MfKmw3NVy11KXuIst2YzOBNSamA6VYjUmKgpS8IN+?=
 =?us-ascii?Q?K5fbDsKMJ7YcLBZBCq2Bqi9nAL+RXhOb+onanx/tTFpBwKUZRDF2jdCRytsX?=
 =?us-ascii?Q?uPJOw+TbW3cfAvnmS+UPpr4VtUpq5jmZgzxeda5ubwBQfKkugyGpGlqR9fKC?=
 =?us-ascii?Q?WjenTidz3az40mM2fptC3huDM+hR/emFpUMQ1Tzrm1k/apcxjYNBaQvwLikO?=
 =?us-ascii?Q?06hevGYdn8KaWfeR7RQD1XYtniOmceefs4Kzv24NC8GswzvzUAeIhVd1RY3T?=
 =?us-ascii?Q?3ZocQ0etCa+WsSHyzoWxtQ2YVsk8LRDBpM8q6os/Mmnac01691MVPwPL+/XA?=
 =?us-ascii?Q?LfisdX1wNBqOgbwGHxvELCb5HMnO3jIvx7KWJ+hEPnr9y6f0yQPIDpSgsuXN?=
 =?us-ascii?Q?zGk0PDXly+/rhQZM1Hhzy58wSfKnjfeGfj22z6QSEvqFbaa3f+BLwDNRwO/F?=
 =?us-ascii?Q?Q/ebkRiOdudy9x1CflngAUCximJrPwWqOOVrP6iZGjzNOll/HIQc1CH+r1as?=
 =?us-ascii?Q?5GIH7HRujcGez+Hf3RAML0ibF4KZwpIFqr16Hj0Zh49INooTG21xWZ+rHxxp?=
 =?us-ascii?Q?JTmuN6sSy9T7F42/6KwyYeEHRQSgFaKa9zOOiPVoCuZbkNQlQJL0e/YO5NLj?=
 =?us-ascii?Q?W0kI0gVr+/WkNmZg1mjziPE5yEoWXrLKrZJOVIkbNayAqSnzTc3UfUwGH7+9?=
 =?us-ascii?Q?qvZL3gPxBFxyrAuzdmAC2WcOJr2lfJ/OgHzTVbWGkAr79To7iKY9SsBYs+xW?=
 =?us-ascii?Q?NC2QuL8NUA63RfUh/FU3CqO3j3B0DFFApybIXasTEXAIuG+GcZbvLXiE6J1d?=
 =?us-ascii?Q?GswHorCAn0bGNz2SyWimqrFu5EgfjSQ9IiFhzcfs7vsoQewwTW+uqJk0P43v?=
 =?us-ascii?Q?V7u0tExAm3FFBzCaZ82NlOtUI3fEf+BSOZ79/2fEFEXZHeSAdv3nWjH6f//U?=
 =?us-ascii?Q?J6vx2WtPQtm+bDtIl7TqBuHhv1Fs9q81/JkkiDgwUKfiVzGt3b6oPj27iv+W?=
 =?us-ascii?Q?Ic64I6xcuDlEKwUn3ORQfr6FKedAE/yNvSjGa8JP/Mbd3t+ZV3RyoG8N49Yb?=
 =?us-ascii?Q?wjdmI4sUcRQbsfVKvyhM953YNYrR2N/3V7+v4n9KPPLPeuE8b9LPh/RK/uVF?=
 =?us-ascii?Q?F+TYcU6JuhV8+r3cl+mEi45qzHNBIUzGn76TN34C0iMmGJ7nueRmohsve6mY?=
 =?us-ascii?Q?gB0SLDmMqcTs9Cy1TCiAR948?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1820a55a-8fca-4e5c-bef2-08d8fd4d06fa
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 00:50:54.5779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fl+8T7pltbsflSM/Td7g2TAAEffC2r73VZb/5e3v2fiIbuk+pAylNdvbdRzrAfSySqLGFz40hpXAEp5NrZwVHpq1Vot7S68dOyf7Vy4aqnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4307
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120001
X-Proofpoint-GUID: 0juR5ZvpIVy1Mbln3pVBlwhcC6bqqB7d
X-Proofpoint-ORIG-GUID: 0juR5ZvpIVy1Mbln3pVBlwhcC6bqqB7d
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120001
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
index 441f0152193f..168953cc0ff9 100644
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

