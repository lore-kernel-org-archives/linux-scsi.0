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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D8AC47085
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B956E6140E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhEYSU2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:28 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44132 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbhEYSUV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:21 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIF656124670;
        Tue, 25 May 2021 18:18:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=b33fZPkUhxi2Rc2f8T/6df2PrzHrbHiSccxFxs2G4tM=;
 b=mZTGyF4cCGQyjqtnw0evAFhvPfTGA1sf7qq5MW65JRE6JYpSVGcOiKmvRleVXMJF//SZ
 PY6V6TzlKVP6N/bw/R95aQh0J4HcdFrAKp+yANUTwBApIJLQRCLScwYvtA0vWw1saOVo
 KPz3CgpNp7R7sM10qdKXHLLCVcxNugQg7IZXBwL5GPEGXNo4+9U1XM9CCwRqdL1LUjED
 8GmOKHXTwIMWws9Whb8QNXWh2VGigM98r433RD16uk2rmYv1OkYIRMr9NiZXG7xpolw8
 8M1bkmyMOUa3UA01enwb2YpzUyHcBtNI1azD4mBVV/Ldm30N/21z6tTRuc7m/iE/jydi 5A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfceyrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIGD0p010935;
        Tue, 25 May 2021 18:18:44 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by userp3020.oracle.com with ESMTP id 38qbqsggy9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+r+vBk7/QQNOnqLjNkjpK8kOyZy8css6AdvbZ+5LdZjG7h/XtITGk0efcxdDR9t40pnNDE1z56w7p9FX6fqjfX6gqNCAD1OE5booGrlWztpCBCL6Jnki76pFZOY2Gc/tj/vTKNogbtmPGUEuKHKx4l2KIDdWKyBrPjwiCvA6MSSjqx2AvrKS2YUbsx5dkSEN2OAl85xPATqwanBCcfrrRADB5oeG8eWkL31KyUqkNZUr3nuw17RFz18aCX1Krpk7zIaJtf9AZhWfbicOZHFPZX9M/fEas9VjppC5fg3XreJUrAmKFTmT4jrfYjFlutHpW7gT9lmcYEq3nq44Oj0SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b33fZPkUhxi2Rc2f8T/6df2PrzHrbHiSccxFxs2G4tM=;
 b=HjTLRPiywJjpvn+y6WPTIIcGOPFs+0QhWl+gaQW5k/YCCfCe3yqoPqMVjqsZPvE/DGK+acL+2wuxenbJWljwOwUEuzNpEblIfdAK+ZjpVeBHtCfoKkub3GAqTi2qwrMlPv7BFvx6fVdJwMNPOWKgy6r4za5n2yHR1jvByF4ZJCFydqBcslMXsqfwr31XYANAlRFy1+CmWdbtY7xbpESpNjfO30yb5SyqDE1vfs4DpaUPdZSdgQTgM8Ab90slK+kEAAQzwrsAv+s+qAKXnumxXrTp/vMzuYkOnkfNUs8IPND0QfxD4NQCIXxRF7krwnoHtWgSbV07X7LizcCKtBQuCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b33fZPkUhxi2Rc2f8T/6df2PrzHrbHiSccxFxs2G4tM=;
 b=mdoCEI5oYR72+fOXu3T1joigG43UQvjz4MIoGRFGXxhjHNVG07C/qZcQV1//3hIVZHeJ9DnB4+r9WnclNLxRjF1fw/v/5pDGQMnl/nUizFgtCAay/RCYWlqXcuggSJEkBtXs3/TRlBglhs2R2k4Qr7zGl/Rb3I57Wtj4NeV9w9Y=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:42 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 12/28] scsi: iscsi: Get ref to conn during reset handling
Date:   Tue, 25 May 2021 13:18:05 -0500
Message-Id: <20210525181821.7617-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a09aa72-970f-475b-0dbe-08d91fa9869b
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3891EB7206D026EE224A5832F1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i3oD7n9iTS8Ijwzf85zI34CSR2Fua3ItA5JFdMkyGqBJPCq8CYHgjIJOrtE8Vtjk7TNSgQAFHlvTeg8hKrTyieWrda1Y1Yj5mJi28rjmnKSPSSGl2O0uRo/6DAcBcBD+bLuGpmXxqL+d5ycQAhnmzwiSI/E8N9KYsdediOjzHc3NF2Q4lUfesINXLQVIMaofXl3QTkpTjIwjK/8F8ZtdS3k3oLegsBUarvdgrvOMrPMkc+kcHuPeWPaPXiuQjrW4FgI+3uoFNGf5Ez+pFXdFQUoLaYRJjb3VSmpo/DjThn1nm6nJ/4RMiJ8Y2rYEa99RC6MxcMYHqndtigfwprYUmFXoJLUxJOcBJshLxxjzPlWsy0seQDq04dgPjHqG/oaktRMIkACv3IkDRqekUEIc87Dd4cgVHLBIrGICE2rCBLhUt9wnKj2PMSl9inqZOA2ZhVH5SYJ8DrhPpjRlCbqLAlwkgdnemw7V+kpMReKexGxZjFahOID1EoFU3P8Ws+IShhW1kKLFDlAXfUj5FeDPm2oAMYC/ihc0cUUq5GHPV/Hzqxcye/5wLHf67LyC8V6ZnaEiLe/JaX41Jj1q4DjioLUgILLEhXkRiiEuQETlOoBZTZlciBtqViDXbTEb9XA/QXtgK59LjIhQCe1N+juEjqkDZP5FnPmP7g88prBnzGS1pJ2xjuKEJ/NBxHomW6ac
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?r4UEYqndDPtxT6KhhdTKvDT/c3qwa7u7gyUvwRm9KSrw99nnQKnViPOPArV1?=
 =?us-ascii?Q?H9o6Dyx86EC2X9s2TOV4yVPRpL6JrwG0pL3qSBO6aNfRsNanMOszllrv8VV2?=
 =?us-ascii?Q?fDthqC6cI39l5YOU1U4Z85H/8lpx+XNKo+sIuv933Qi+a+WNYksXpz9jTxTQ?=
 =?us-ascii?Q?nTnhRzedlS4oNxminzW5eGWby/d00888uQVUqsC8XKv8Hpga5oRMp/z+DlJK?=
 =?us-ascii?Q?48lPMeNJAs1RH18JKOvdfAVMgj/vKJquHy6pwoLld33R3zH+r5JBnYfal3De?=
 =?us-ascii?Q?kVoOgex1jSd7bBg/s6RXZAlVlM30Q++w4OaVD9sYf6ccPD7HV5R69CxgMVOW?=
 =?us-ascii?Q?gqfJwmmLr1ag5LIry7lNhcgmfqAOJ+ANv4T6VYSF0yXxdVS3vinK2X82DbcR?=
 =?us-ascii?Q?12/edQMM13iAOzU6Qb5WZWZ3URjN+A0BDrwESnWgBCjiGAb2lsf6LCMXg2aY?=
 =?us-ascii?Q?OTWXXbulN3DLjAuhymjQsGxArMYYsp/CyOGWX14ZOiojPWmDHA4xzwhMigTP?=
 =?us-ascii?Q?ph2KW5nA0IChR9xZA3Yf97DPc5sP7L51vMFR3dL9Uz5m2nJXlWsTQV4JdzDp?=
 =?us-ascii?Q?4QbjjUv19S0fh7cOrs+yF9kP171yNAdZfKhHgzpR8UqGLf8XG2nt5kEoNg7L?=
 =?us-ascii?Q?EUqvFvcoKJNbzZEqgw2LD6p3dsMbor8fHFyCC6MhIPQqgaXd3mBQ2E/Ybz7S?=
 =?us-ascii?Q?PQuFN1fL3lCTPXNvI6h9LKGdYN+UvEWZjXK/ywA1Z3Zp/uolXtDG4uKNY8Vc?=
 =?us-ascii?Q?m7fUY09BFPYtZhCC9iv8HRCtUc61DNvQIMum/jIoc+FYKH9LaMGz4/yv9BGx?=
 =?us-ascii?Q?kIFaspd8edh89OzP0ws+/KnxsGne3sHmqf5bJoFJk7yUSUxRgcN4dyOWpTQu?=
 =?us-ascii?Q?jJ6BYi58VDGd38OAFegz9/2U6yWhmDyG+nQI3Zf3lOaGxgS6qKrPBKNmEXsr?=
 =?us-ascii?Q?Sgr2frRjwa/H5YvDnBnlnRm9T1ZQtCkTf8tX1Af/625Vr8OS8+MPv1kMQCdg?=
 =?us-ascii?Q?sgBYsPRQJ7+SHlpdYSkfsOyKj6Nb7TTnsWdRHdGotJrS/Hfl5Dr6xqL/sVSp?=
 =?us-ascii?Q?mgkYVCwT4+UltYDdMESJ8LNyH9oMlROVKraD5htqpJTjsNRCCaJ9qoLrEx75?=
 =?us-ascii?Q?j//j11P+jACTyzA/G8pTsY9v+DQyj0MMJYvxNq6alNesOEo7QdIfb2TTJz2f?=
 =?us-ascii?Q?BLRBBsXYstk9wY6PDl3fLUUBSwmoSDAcJUMeKypAMX6qwvlfHs0x/ZfwT7+c?=
 =?us-ascii?Q?IJVbUba+zxz0SojnQ5P3Mn2PnlWCcT0hqBNzp6cohmrwuUqucxI8EQgfn0yI?=
 =?us-ascii?Q?4lP194YNV1qWeLUGKB5/BcFj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a09aa72-970f-475b-0dbe-08d91fa9869b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:41.9707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +1+f2ay1LsV1JoF+Vp6X3RVn6GMOk2qpAP0AcnU+uQgCSan/yuhJ/rNdwItd7okF58rEzU6CkK8Pl/QaLQCysX2I3uLAdFdMfG6YuYjfk8s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: mR6N0SJPSVnVDGQI4uk1tZN66V2GyfZ0
X-Proofpoint-GUID: mR6N0SJPSVnVDGQI4uk1tZN66V2GyfZ0
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The comment in iscsi_eh_session_reset is wrong and we don't wait for the
EH to complete before tearing down the conn. This has us get a ref to the
conn when we are not holding the eh_mutex/frwd_lock so it does not get
freed from under us.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6ca3d35a3d11..b7445d9e99d6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2492,7 +2492,6 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
-	conn = session->leadconn;
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
@@ -2507,13 +2506,14 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 		return FAILED;
 	}
 
+	conn = session->leadconn;
+	iscsi_get_conn(conn->cls_conn);
+
 	spin_unlock_bh(&session->frwd_lock);
 	mutex_unlock(&session->eh_mutex);
-	/*
-	 * we drop the lock here but the leadconn cannot be destoyed while
-	 * we are in the scsi eh
-	 */
+
 	iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
+	iscsi_put_conn(conn->cls_conn);
 
 	ISCSI_DBG_EH(session, "wait for relogin\n");
 	wait_event_interruptible(conn->ehwait,
-- 
2.25.1

