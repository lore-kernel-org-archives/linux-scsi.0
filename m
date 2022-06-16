Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF3BC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378996AbiFPW2S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378942AbiFPW2C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:28:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADA860AA3
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:27:59 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GJUUPI022342;
        Thu, 16 Jun 2022 22:27:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=CjxGqZ0LS7xcZ2OHrdlfG05eBe9cT4ePABl0eVU2p2E=;
 b=XGNL+XpHY4hd84qtW3j8qOQqNwAOsP1YNT8n0xa/eo0mvATNAcspAuXtK8DDHc9dg5pv
 4DU6VOOPGYOyzPsL5RD2VSaw1TRnmu0MAj+qoLhBOVA0V90bcyDo9U5Leax0Ex2Kne7r
 Sbixj3T8j+nI8R61mqHA2kgd3ODc5fTPOC48LESte4co77pWuPkT6tH2hSc4wSxkdsNt
 bqHQfLbxc6MrOElYtfO+AqpdUl3uh9E4Cusjs5lRuryfGsqMDaRTRBI9YcRHJfIxG/tw
 0KrlxbR2CU9MdaZ9B945LDUtlP/YnfBpZ3v+fiR7BFelELd1qrQtAUzcTQeWyLaWIgAP IA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhfcvbur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:27:52 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMGH0c034591;
        Thu, 16 Jun 2022 22:27:52 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gpr2brek6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:27:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8IYLBt+byo1U7B14NuH+J7bCP6SHVf4Wchod2hJuqTyrKQbXe88Jig2S2tauafNcDho2gnrDNNCyHsIn2ef/cD4XD5DPB36M6p/EUAhNOcU7A5a+fO875kYCG1niBFYusST5aA37qtuetmi+UnjqlKs31EYkWpWbpxavDPiJEBp0BupHfxOF9QRaR3ZkBDOr5+ytB6TBLloNvKg/cvpFSI781jRzrqE1R20xui92pz5BUZTr+zIMHpK0KMB2CxYsCHKlIA/NC1MtWr+1IDFaZSi54/5+eGfop/rGg1PK36bSJul+e1afgK4/jHmhTjdWea1dIzwvQqnhB7An97NZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjxGqZ0LS7xcZ2OHrdlfG05eBe9cT4ePABl0eVU2p2E=;
 b=byqiIwWKWHnkuIB699GmOOLH3lhV3XHEPrxdhBD0eUjRiUB6FG6DTfx3IhL6Aev3drLncvHulp2607WRzLJlhKDKMQRgkWayxpvdam00XvSUW7A82pbqxa3qLe/gWqpB6i2bKBTAp2FmcWcPuV2DnNdvJpFMeEOSFFFnHJU+gd5Wc/ENeyEhEwIdLqRyIy6EWSWVSQnnusCi7Nk662/GCb/GFl0TNOgORYdQwRwt9aXm4CgYUTvCZ1lslZ9QqP19Y0hYFRgSKRTxSw6PV9VOFT1K5b+UVtgNatUMY1eZkJYDm5PsmxqFmiT4Z2p4jCDILYRUOmszv3XBdRoX+xwL2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjxGqZ0LS7xcZ2OHrdlfG05eBe9cT4ePABl0eVU2p2E=;
 b=Eoz1Ytw176UuFvje0a7iNAJQ+tSh854K/MiWWBehU9AwRaRH6Jz4SNrY8r6ev9D40qt3B7b4puhg9O5jaxbEQHNSbxgVmgjZyt9qSLoAUf2RsYJaMgSbpN0Ep0uAazVHtww2B6xGP0smwAAqkOutem2vGWAHw3zd8APW/yt5q0w=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN6PR10MB1267.namprd10.prod.outlook.com (2603:10b6:405:e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Thu, 16 Jun 2022 22:27:50 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:27:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/6] scsi: iscsi: Add helper to remove a session from the kernel
Date:   Thu, 16 Jun 2022 17:27:36 -0500
Message-Id: <20220616222738.5722-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220616222738.5722-1-michael.christie@oracle.com>
References: <20220616222738.5722-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0070.namprd18.prod.outlook.com
 (2603:10b6:3:22::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71fafef5-23fd-468a-0f13-08da4fe77298
X-MS-TrafficTypeDiagnostic: BN6PR10MB1267:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12677068717E1DD7222FD0ABF1AC9@BN6PR10MB1267.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3D9QAf2R54QZVIGFMxwq5hzI5yQlzyOiC8z/KwtosAuYtFt4Jqk+AD0Pu4RrMfPD3UzzPhip5M8+9fEQR9fSzxw90Dmn8snqohnJBoQIkuebZUQoudyaF7W+LYs2b8Y+/1Sf6NzGw08B4x8h5wBYnlgTDGrfcjS/Qo1+JbqClPT3bNP7SeLLcxrx5L5LLbBsgrX0SnN0vaBPbZrC65ws3NkvLXsSQNTxTo4gWjXdhVSnUhZBusPC4+W/40VW3/XidN0wZ5FV41A9J0IiPzAbhs/Nd1OmwK3STy89mqgICsV27wVbwnsGuDvyJ27xa2sROXzjo6KTKFVNJseHeVMLxdEbqTMIdo0Q0XVu3snE/jPZCC9TsvGlO0isLzO2kbeplXRWNc6UJjqbcToUrt0g0twJ/4dLcQImC3WnJd/0OrkIJeozwDPUKUCm+76RCmjuU/UpNUSBSEDigxa5DnoE80U4ial2uKz/sH4GRA+d0tQOGzgYwqRHOdqpUIKaTmUQ+1kypaUyWG3+6QG5FC3qSBWKYyIKmOMVu9PP8mG3g30ICIgdpEz2X0gzbLZTN80kw+3wnwyOE2Gg7YVvTVjm+VzAc4xGAMcp/szEid8i2COrjAbKyINqMwK1LrDZn4WhbBSbmvjm7eQTLQ9I8ikLQOAEGhDLivjs25gC0QzwTELfHyIXyjTRyZkvAicgUuyahPX0arxjaVLeMal0P4WxBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(5660300002)(83380400001)(107886003)(36756003)(2906002)(86362001)(38100700002)(6506007)(38350700002)(26005)(6512007)(6486002)(1076003)(2616005)(508600001)(6666004)(66476007)(8676002)(186003)(66946007)(66556008)(316002)(8936002)(52116002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mz4hufDYKC/oxzL+wm+6YzT720ozl4qYkpCHgpNDmLPQRR8su6EnHF2zxxe8?=
 =?us-ascii?Q?ZG96Xqg7N1ILE09yuLerp/gh0LZAJJkOJNP7S5+ZxnZBDiFUybZRyN/hWYJ2?=
 =?us-ascii?Q?zdkha6oLG7x91ao5F3bPjxl7akuOVr2RRnGJsw+tsrZAcc0zOGfIMRaEUawh?=
 =?us-ascii?Q?f2hDTwAeUz8PJEj19e8rA6V77HBjsdr0KydZ8gNw6HNBi+neTDltTZ1lhGA0?=
 =?us-ascii?Q?0oL0Q6s7oA5aM/VzGgMv0zhfZk4kHCqT5jb81EfM5O7guM1RJ+J45gO/aUAx?=
 =?us-ascii?Q?m5ONfmqHYZvHOKiGL6JPeFPLBojQQjry+mEWVUsWIrg69NPySxAr2Y7bvQUP?=
 =?us-ascii?Q?6geQ0tGzB4UffdkNpvI6eHRJkxtmqQyyoSfsJHB+Duj7niFovkTtdff5omXF?=
 =?us-ascii?Q?pcfpLZK1FjO8LIaOsdurfFIZOF+I3+W7/hmDVsEFbmpZZ/VxOOwd97QUZii+?=
 =?us-ascii?Q?1LXaWSv6wBK8G7+ubcQpQSSxNgoBFReM1G4H544HzLDPzIsU4c8HxQl7sQta?=
 =?us-ascii?Q?iWVzSQr/whEwXEA0KAo2w1h4yy6wJWklHwbwwIw9RRGSd0XD6Bj0YpzF6kVX?=
 =?us-ascii?Q?SlQpL6KNvOMC6BumYDOBmJqtGYek02XnwJms6mIgq+XZrITWdWI0cHcUFPdf?=
 =?us-ascii?Q?0xfG3XRFDv2F+qrxcLV/Xho6hMBiyliGXLYP4b3UTrsn9aotTzuLHzlVBVyj?=
 =?us-ascii?Q?IJ4dXV0soGQ/0jKea1p+sSdoBCeysS2Zki9DleZytH0OvVEY5zltAKdYppy4?=
 =?us-ascii?Q?4q19+0KsktcR4cvFEvRFaKrmBOctYLOTgxJYBdSfHuOrzMymPrIM1YeWEHA4?=
 =?us-ascii?Q?GkuUb9q3VF6tStn5M8YRxJR+rA+34YsfSvlGp3HUb5N0XX+ahShRVcGYGjiO?=
 =?us-ascii?Q?8eJr9X4s7aw3hn+BevddIc/uJijs7hzCglrnmdwAxlJswhP+Klz/nQoBuaXf?=
 =?us-ascii?Q?huz1sSnayhMIyhzxwsYYqmO5Yk6faesLn3eYxRa5F2EdLPvKCYYzZAw2KO2l?=
 =?us-ascii?Q?OZHjeo3McswIxkbTPMt0QJUrrnOyvQ9o2xVP5tWuQEaGHnN74zdaPKz6/sxd?=
 =?us-ascii?Q?WsMp4o7BF+hwo3cqsUKlTYcZX6H1ZtvbSqDOMQso6MjxloATqr76cZxybTyU?=
 =?us-ascii?Q?WvsBemoeYL9uFTeicpABdI2kgfdjFPyAY8GQqsQb0nQAyTSMkpv4tioGVylY?=
 =?us-ascii?Q?goF9AoBnWajXWXo5QDS5tsLQkool0dmNXcgHZqkrQ/GFyiF/oMHSerYtWhFY?=
 =?us-ascii?Q?nfqnBu50PJ6Nl2IWrGD1mDzY5t4FpMb0x6+lxL/gTKAM1A6pq/soRmjCZzsT?=
 =?us-ascii?Q?zXf1A6gB03SKyZSgZfhdk/UuT99sKWcFqASvkrI2C0oYWlBlu8eskNFz7Lf9?=
 =?us-ascii?Q?mxRSj7ya+QgNFE/ML/J8xlZlCPbFmfhJ+szjUFoa/kx6NtIFsrPjkS8FaRpE?=
 =?us-ascii?Q?mcypLs5gtEhAoMOwwDSszfCymFSTOUEKr9R+HO/L98BRKyrH3Imuuu+43FGi?=
 =?us-ascii?Q?Qkqj6SRiP6fGC+/t8o0e9ms4grw59MWXqkGC8rd9r/qxAU3L3JHMjec9OwJg?=
 =?us-ascii?Q?qO0ZNOsGXWU5FZq3plQrD2ya5/kv6JLxNYYDBXKl/IcHGGc4pa5DJpTBNAZI?=
 =?us-ascii?Q?GwsB/cKW1WB9EEmVE7GsquAIYIyWxrG9fWk+MqAIRjfRQlq0bgsaKN6+La0k?=
 =?us-ascii?Q?fPJghyDfIbG0oEbPLEJIItfb342qf/M5LKOZjj0EuVM5E5FaagxPDRRtcC4M?=
 =?us-ascii?Q?QyaJy0/kWZVsfb0B1uK30pGvSJPLXXg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71fafef5-23fd-468a-0f13-08da4fe77298
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:27:50.6828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qUV6boUHuTXXtk6fVq3vDDNa50FUxf1K/dg146P6E5UQidBlb5XerCUi9TTxeU2HQ7dNX0XM2fsF74DmU1jJfUE2HDHqKKBGQduBkExH6XE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1267
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206160090
X-Proofpoint-ORIG-GUID: I4Gtu1_de4ZjYBfsDSXYE01URRDv-YkG
X-Proofpoint-GUID: I4Gtu1_de4ZjYBfsDSXYE01URRDv-YkG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During qedi shutdown we need to stop the iSCSI layer from sending new nops
as pings and from responding to target ones and make sure there is no
running connection cleanups. Commit d1f2ce77638d ("scsi: qedi: Fix host
removal with running sessions") converted the driver to use the libicsi
helper to drive session removal, so the above issues could be handled. The
problem is that during system shutdown iscsid will not be running so when
we try to remove the root session we will hang waiting for userspace to
reply.

This patch adds a helper that will drive the destruction of sessions like
these during system shutdown.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 49 +++++++++++++++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |  1 +
 2 files changed, 50 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index e4614dede7e9..b67a4a938cd1 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2334,6 +2334,55 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
 	ISCSI_DBG_TRANS_CONN(conn, "cleanup done.\n");
 }
 
+static int iscsi_iter_force_destroy_conn_fn(struct device *dev, void *data)
+{
+	struct iscsi_transport *transport;
+	struct iscsi_cls_conn *conn;
+
+	if (!iscsi_is_conn_dev(dev))
+		return 0;
+
+	conn = iscsi_dev_to_conn(dev);
+	transport = conn->transport;
+
+	if (READ_ONCE(conn->state) != ISCSI_CONN_DOWN)
+		iscsi_if_stop_conn(conn, STOP_CONN_TERM);
+
+	transport->destroy_conn(conn);
+	return 0;
+}
+
+/**
+ * iscsi_force_destroy_session - destroy a session from the kernel
+ * @session: session to destroy
+ *
+ * Force the destruction of a session from the kernel. This should only be
+ * used when userspace is no longer running during system shutdown.
+ */
+void iscsi_force_destroy_session(struct iscsi_cls_session *session)
+{
+	struct iscsi_transport *transport = session->transport;
+	unsigned long flags;
+
+	WARN_ON_ONCE(system_state == SYSTEM_RUNNING);
+
+	spin_lock_irqsave(&sesslock, flags);
+	if (list_empty(&session->sess_list)) {
+		spin_unlock_irqrestore(&sesslock, flags);
+		/*
+		 * Conn/ep is already freed. Session is being torn down via
+		 * async path. For shutdown we don't care about it so return.
+		 */
+		return;
+	}
+	spin_unlock_irqrestore(&sesslock, flags);
+
+	device_for_each_child(&session->dev, NULL,
+			      iscsi_iter_force_destroy_conn_fn);
+	transport->destroy_session(session);
+}
+EXPORT_SYMBOL_GPL(iscsi_force_destroy_session);
+
 void iscsi_free_session(struct iscsi_cls_session *session)
 {
 	ISCSI_DBG_TRANS_SESSION(session, "Freeing session\n");
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 9acb8422f680..d6eab7cb221a 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -442,6 +442,7 @@ extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
 						struct iscsi_transport *t,
 						int dd_size,
 						unsigned int target_id);
+extern void iscsi_force_destroy_session(struct iscsi_cls_session *session);
 extern void iscsi_remove_session(struct iscsi_cls_session *session);
 extern void iscsi_free_session(struct iscsi_cls_session *session);
 extern struct iscsi_cls_conn *iscsi_alloc_conn(struct iscsi_cls_session *sess,
-- 
2.25.1

