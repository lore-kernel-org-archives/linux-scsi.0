Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A5DC67871
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbjALDJo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236117AbjALDJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:09:03 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC25F4914B;
        Wed, 11 Jan 2023 19:08:59 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30BLE9YN017450;
        Thu, 12 Jan 2023 03:08:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mBn7HYt/szGA3aK8ogj25vr3Hh+/zFsJkicqWkLdXso=;
 b=TBohDFKfidh2ZhvI2ijyKuJ0O2GLHvwg5FVmZHYyNhGGn2TJCpZ4UvNgt4OP4/UKSXqO
 vAnfqeWk94ig+1XByl9P0TTzteD9QMr07CZaJPpoTtPj4UHVSdzd5/DsANqDCRDohISk
 jyLKfK/fJSH38ypMb9DzLua9kFTUSxZgv2ovl41uyTd+KOnHV/g6cZgSfT/lPVjh48fZ
 02eerIZIW+RJgC3auCy+1c2um0TUAshigxNjsPmPV29f5rCwy0eWPQ96WBv/TComSKgi
 duzVuvk7La5Xc/GUjHn+qBFNBZe79TDqMdMQG0oOdfcssgMlmFNP66vAcP802DDI8flp SA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n22x00upd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:54 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C0VJu4034149;
        Thu, 12 Jan 2023 03:08:53 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4fuxs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDC7ZxeYRB4N9dQp7UnfXRXNELVAc4vfs/3DgH4v6wgsCem7QQvpV5C2SpXue3RjO7UMflsX3JnnX7ky+fWWUXZGGVO3gZwhQDSDF1BX9ytrVVmzO93bXNjjG3lY9y2kn5x3MzvwBaTt8A5PME/+K+JgI/GkEB5bespw1K2CpNbOh9WZC8fEMpw8NG588FemQ2ZUwcF7rH2I4ZTMv5+GKzjYlsrAIZn6k2oLp+UGXN31GhFDR5nQYKdlqwP+qgDoNhpoeRYaNAsOuf1Bq1VcFL+dWCumEmjoLTfM/1GN9ORDXSRCtBIJYb+viGhMunEFZSfzQGYovkTnb7FTeED4Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mBn7HYt/szGA3aK8ogj25vr3Hh+/zFsJkicqWkLdXso=;
 b=hDmzFmqq12yH/B5lr3Hy+dIg1eb2YhlxZOSxNid/g/VLQaxiKcmteYomF+osOSQijwIK8C+sBa40JhWS0CfiAucxXm0/cDOPyYY9cFLobB/MKZtlEYZvFZLfpPw5tU4T71uv+tfwHbITFMtXF7x3xhOzNtIAbA9WdZGsoyY/abZvgMNcWMTxFOrWxWxMiEEdYmVTQrBhTgdAfQZekj/B0HAdKC2ivUyTQK+YXNZWAjvskuTxBR0Dnbtc76SSNY7cESXuPM4Hpjfv4UznrVHLQgf6pye/1P2dg+NIuEiXRDiPFn974KzHDgaY3AajRdxqm/168t4LcfAq6xsYvmRKPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBn7HYt/szGA3aK8ogj25vr3Hh+/zFsJkicqWkLdXso=;
 b=WEETdgaRBp2awAhpZKoMe9Mx+YtqrwaHTOc8cMH0aoQYjnpAFpP7uPRB/fzIDydhVVpYlhK1hUo6UM1b5RrNhng52UOYhvhQHk6FXtNlOZGBGdjqkoQZqq4hW8U5DV5gS453OgPFR+GML9WBUB/S/rChC7WqYwgkSujZItJSe7A=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6595.namprd10.prod.outlook.com (2603:10b6:806:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 03:08:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:08:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 10/13] scsi: target: iscsit: Add helper to check when cmd has failed
Date:   Wed, 11 Jan 2023 21:08:29 -0600
Message-Id: <20230112030832.110143-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112030832.110143-1-michael.christie@oracle.com>
References: <20230112030832.110143-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0224.namprd03.prod.outlook.com
 (2603:10b6:610:e7::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: 1711ad5c-0c22-43c7-0c7a-08daf44a54b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: frNOUzh+A+GRYK+FlEcdXzthQw9P0MVLXj2lloU/c4qwLgY7qpUYsOcPk/e40fXBU52mNRwKESh7bHA54OyYcex9x+i1i9F/u8TvUZOKVmIeBC9zWtQD9JpVqN94s8qYwo8YfW2dnDmtBTxQbWW+zDz5UnunmKHqLFA/g71vv7qwJn6vhXP/101dgb/mfdFBp8MchcY/rXO2a6ZKds+8ob9sFOEcPFEetQRdKlzFRZLyNuNq6hEXiUivGen1HF82deyeO55yfv6HzCjE4ndiQpDuL9v5GZjRjFSi9gXStmn12+BX8zz4U7DvJxvVM/b3+viVIk3TTMw0EmyDs/a4cHrcDCNM0G748Nep0wz5/pElhc9CvpiiwCiJknqFHf3nV9ZNx5EwqGz80f70bH5GrKeVXrQxCFGhD6RbegAtDtKcAj1D+nZDYtinUd8xCt285BP9wRdm1vasSDbQ6e3/Fkpe3zb/Eba8RZkxTp9Ut7VFg+5NkeIheJ/579SiHlSph8qp8ZJeq90wiydYFbaZSAB9dQYlJFAHwcPWeOfcV9uwE43gvxnXQcCyI5prP2jAHDgeKvbfSpovDTNDfGG16AcPa2SoM027WJ32WBrJWlvAzVDRFFZJ/mpteQ67oa2mFT9V4t/BoIG1a5t83OOvcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(36756003)(2616005)(1076003)(6486002)(316002)(478600001)(107886003)(6506007)(6666004)(26005)(186003)(5660300002)(8936002)(6512007)(2906002)(8676002)(4326008)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ofoPhQZTwY2VhEijYx5IecWzB5G2aG05vxsp5y89HNEsLAM2g2wIOKaFYz5?=
 =?us-ascii?Q?eiYuhFr+AVSZerOybWZgIMy2193Y4he75wKNpaE29N2mYinIdLdLFnxwBUPW?=
 =?us-ascii?Q?Rz3HScnxLGkg5AweU4aONZ4ec/8fQgbBeL9kY6N2caMne3i6P8Eu5LhlOVqE?=
 =?us-ascii?Q?K1cVAy0H29LAXQ7XuuMLbZlseJtfjs/S8vBFh0uv+/zbrIRTAsqF3LChmGBw?=
 =?us-ascii?Q?U2pbG3B//nutX6iWrlo9hvYwRr+2coryUPxnOua+cdZXS89p5YzUBUrFNinh?=
 =?us-ascii?Q?Typ4cF/gpQ+kHUzBQrfYqYyZGbDZLNbyQB+rpkRPBZlj4t08nVavPzFgFkXh?=
 =?us-ascii?Q?UsfKmo8Fb7mR9yiHGwstcXu84qZeijrdVVj94r2wLcHHdpkRTfxN682Dk1q5?=
 =?us-ascii?Q?N0eqozOVrey0J28hqtavngmdSbYjqqzpLkbL1tcAtgFZmAJxDnlXKxAtAceR?=
 =?us-ascii?Q?KMvq/9jtCFXIM+PkK6o81nejz5PpP0Gs2Eq32WMnE3fQdxuQUqwubyj5qrb2?=
 =?us-ascii?Q?aQ10wPEeuM5RlT+F/UrZo/z4DMmMyJrHWK0udDYLg0Pa8C48x0RXyukB2OYC?=
 =?us-ascii?Q?Y/4SBJYvp4FxrAilooquLTwVDmeyuJFHoFBGI+JS6S4cuS9vkaL6lxzV14Sh?=
 =?us-ascii?Q?Qp6NRIe58bGJRqKZtKzTFhkpJ8SP3UamQlvoy9bk0ZBZ1IeKsm+MYFUMKHTW?=
 =?us-ascii?Q?OQORPbMZgXTXO5zwKVtIjkCBRs7lvoJwLb/U9CIQ9Ond1V8/ViVow9N4nb+1?=
 =?us-ascii?Q?FVAeAY0PzuxHV1XhO2IPQkzFr7tQP8O0Ym4mBOHqJuDLSynGd50Eu9o1ciW0?=
 =?us-ascii?Q?oncMAss6BXM/wM6MqoN3z43g0kxj2G9RLMDdEI7Ex+NFdBUZ+EZn3nVJyXgM?=
 =?us-ascii?Q?YhPp8tpFHBlYfSTkQCd3aquGvMr1pXnyTUZmd0m5YG+TrBBNIvoul7WWUC9O?=
 =?us-ascii?Q?EquxHdqyVbv8pjjsvE7B4LpUkwz+hlnNPtsydw1T4DiWOz5irHfoTQRLXKSg?=
 =?us-ascii?Q?reDU83oJmqS/XxmSZHbdw7XyOe4XA+6min/s7BRwL0sQBRFcj93SeDGpGZyE?=
 =?us-ascii?Q?elr2GixWTzjGfPxtHXrbr4O9cJk673BMhGBGDlOy4w1oKVr1cRjkNOnfjd6l?=
 =?us-ascii?Q?ThHeZ6gG+H6MyQoylW0PeF3U4fdrB/3xpYX206qqtBN8bgi/rqFd5l/93MYI?=
 =?us-ascii?Q?doU1WOF/J+oD2IRK0WV7qKNxeQzXWb/zmXeXVDzrOyutu5hIQuAcJhtnPrcK?=
 =?us-ascii?Q?rL8G1ejrtFSoueOSzHPnK27wOR10WdRi5jApF2IT9ABucIIH/p/DlsSkCb+H?=
 =?us-ascii?Q?iSmSZ6nfisheveqbcPZn0lhHiC00s/qalYs/hUztn+xDQ+AUrO3w0s+kE8UF?=
 =?us-ascii?Q?Ghc7PUspRGKGGT6ZtUntNi7bKWpLMp1FtCY7bAdFEAEkFMgTJJZT4gTrjKnl?=
 =?us-ascii?Q?QmGbkp0g+DCsYknMmSBSBxtdKResaUD+gOvZe/tTQWl3UYnGlFyTjlTUeFma?=
 =?us-ascii?Q?EakMoMW0bZjLHMK0kM3F+ZLB1/uqNja8w2HxJHlRGCQnoIUZXWFg7zLjOXsZ?=
 =?us-ascii?Q?3t/xjs3ae+9X5WQvLkpoUm0bRGoGEqABaI8Gw3krEsoVYYcurhIU3/LzWIwN?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +uSRZMNjVinCVdgMt4WCXwkkWw4XO0D803WOg8kbsLe7Em2jU9PlRtAg9Ww1RmiO+JUeqk83YqZGqrTDRsRhkmM8Nso9tHDOlQT2SUqvAfGbub6XgaPotunbNOLdwq0LsQubnf37BuGG5PEaBDsYIWUD+eHBK+bmOId5R7y0gxJXyLD0UQIZ+mppetbdR9t5vPLDvXWC1BZxpTnVp6tbz/JNGMYc+i2Ro7VGRcXez5Qk93t8iDWG86KukuIiyb/InuE9l73KT9hqWC2QZnHbcECAX/4S4sJhjYV/SZEW2SEplMHm9Ao5r9qCqp7cXyO91pMg0ZcW0f7aI3Axi0AWAB8Zjb2xu2qNI4qGEFTMCsbSl0QUMedjArNHqMw9IOmvqrtybpAWCeuBeF6qLIlZUWorPyuJSnLGfcPG/+QHFIxvc3ANWMeLECCGfrhVupONYokIjv19Dd/2+IeMjBU4g7PuEInMVD+ENKKB5/Ra4AFkyMZMbSoR7ElhOfBmEBOiC9iT+l8Ob88pS26KtcwfH1sadMdgSaAAAyOCCKvmW3I1UuhDjM7WYC4eNz2w+ZHtQ8DKqmJTgOq3cQJotxyLeTQdQNbvj6iZX/KXDer6cxXcNBLN6rF75R9MGjntbHVpG6uFsNM9h5NGClMyCr8gmjvTzNEaM2PrlNy+AP0pamL3CO+jsC09zp1C/kHlhppSz/PYZR4KSlL0xelewK7yupnGzXIb5beaf59ABVRR5vm8V+lir3viHTXCv7/3B/xsUMQs1JL7u71aZoBEEBAS2OOnebIfzj3jKhCiDabKnvLhRQWpetA+HVZQJVjI4knJbtN+sRx1BcmAFYhHM86YYqFlPDBnIUMXHRsHwNmL5jMn14hs0p8542JW2jGhKzi7
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1711ad5c-0c22-43c7-0c7a-08daf44a54b7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:08:51.3948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ciPOAMQqeGbMydbd6H1lfG4E4CrE+hSYm3iyEkyf9Uqyb82p2Na7orby8ckT1YlsSgy/f0P8jllhjKW3u74SPKZZ0AYCs9YBs1miobJSCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120019
X-Proofpoint-ORIG-GUID: ko9tv56ygx1siEinmC8X6o6O9XYzdbX7
X-Proofpoint-GUID: ko9tv56ygx1siEinmC8X6o6O9XYzdbX7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This moves the check in lio_queue_status to new helper so other code can
use it to check for commands that were failed by lio core or iscsit.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 3 +--
 include/target/iscsi/iscsi_target_core.h     | 5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 5d0f51822414..82c1d335c369 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1411,9 +1411,8 @@ static int lio_queue_status(struct se_cmd *se_cmd)
 
 	cmd->i_state = ISTATE_SEND_STATUS;
 
-	if (cmd->se_cmd.scsi_status || cmd->sense_reason) {
+	if (iscsit_cmd_failed(cmd))
 		return iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
-	}
 	return conn->conn_transport->iscsit_queue_status(conn, cmd);
 }
 
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 229118156a1f..938dee8b7a51 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -913,6 +913,11 @@ static inline u32 session_get_next_ttt(struct iscsit_session *session)
 	return ttt;
 }
 
+static inline bool iscsit_cmd_failed(struct iscsit_cmd *cmd)
+{
+	return cmd->se_cmd.scsi_status || cmd->sense_reason;
+}
+
 extern struct iscsit_cmd *iscsit_find_cmd_from_itt(struct iscsit_conn *, itt_t);
 
 extern void iscsit_thread_check_cpumask(struct iscsit_conn *conn,
-- 
2.31.1

