Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544C6C433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27F2A61360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbhDCXZY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:25:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46058 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237004AbhDCXZS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:25:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NOwFC041952;
        Sat, 3 Apr 2021 23:25:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=dsUkDGQV4RH0svfHIoEeCzwNZZ9V58taf8GYaJqCESs=;
 b=Tv3gScnvG4ulnRz4F0fLn8uKXsqwtDmXY8XLuW+2Ak43iPc73R67TvMzuFashlixEL82
 zDWIvwHqySvao4J68m2zwzsxjR3YGusuyQWXYsWG/Srak1xx2hbQEtSobOSj+cbyXZ5K
 VNhtUTaHRNkxRV6Ohv+u2Scc6Vc9ECYe339p89quOoDC8bLkwNVBEWgDgJygvt5C4xEV
 RufSAfktuzcMOQEPQDbP8slt5cnQGYwBWc1cgR5k2e/ThyOSwjSHJQVzgIsDmkR/nnMR
 NdqImFoL5kUBKc3n2vcHV99ToBh9poQSxgj7RwOf5oP2mcRGSKuJQgcEvrjWs4SEQAHv hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37pfsrrsha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:25:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtBb117020;
        Sat, 3 Apr 2021 23:25:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbt0w-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:25:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ct4kGYSxL/lX0+HgJMxWjc3knecE4st/b7NShOgk63JstR8Jlpd2ZmjQpC4o6lO2QG3/Sh1RbIQYHk8QjUclMMraacbh8quWGyMrOYBWxGEK+dkBb9eBnU48ojlcbyaFubfqu5uXZLeTqWLl9Nzb3zKe0olOY4J8yh8YPdxDNwQ0S3gPd3edkNy709cL2Sh9oGTVcfiL4Er0elSQevzK1N3USj/2ZUCSY5NY1jM+VyNVjdnBrOzzl8G7+cYXnFnyKVQULZGc8/0MGW5ueXKcSx2cYqMJZmitTOt9LQMLbXG2mcrxoEz6hnGmu1OW0Z9948th/Ib0cHuWVFlTwUOWqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsUkDGQV4RH0svfHIoEeCzwNZZ9V58taf8GYaJqCESs=;
 b=GLGHUNuFH0DhEgqeIGCZxHxH4CWT0XRSlMSzRtXUX5wlLOdunNSgxQQMFJThuLYTr3L0WPo47HmbeSJ3Xr4dEiRKPSol1AnaBIt/GQjGYFELeSaO0VDWWhKN2mFzuD9O0puQvDBe85JLztuoF0Y+r+Wfchx8TQq9pwStosHibNCmg+DPhO/DGVIKXqni2qSGVpQkvkI6LWR1ASWWYFFrXty6TTOa2F4E95f2G4hSx0n3uNA/w7+ulCrrCG2xU+QuzD0ajjTOUhFt+lLeO4I4r9Ep65mvWkvXT+c9Sxe6PjFOIkXjAAmULvEs6y9K+QgRTWG1+NwQCoBdno8r1PSTAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsUkDGQV4RH0svfHIoEeCzwNZZ9V58taf8GYaJqCESs=;
 b=kjuZ/Gsk88GkbEmowwq0DIn//6T8vfz2CJvipxkujadbENotwKKGxKhiqwN815nFJ/7VR/FN/di/fReKEQYCBIeCfUpX79lRTt4Bhkp9M0nYxwBO4kyLyjxXdCrqEVSJ+/722RdcMwg21EKWLTyLqUuNmyy9J+gS+Pl01V4mUcE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:58 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 40/40] scsi: iscsi_tcp: tell net layer we are sending multiple pdus
Date:   Sat,  3 Apr 2021 18:23:33 -0500
Message-Id: <20210403232333.212927-41-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11a1eaae-baac-43b5-2ded-08d8f6f7a591
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431C29CF4B81A279A735F50F1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yLjpMHwRWF1jHwWIaglqaMaR0LCR98Hun/JVHPWx0u4kKenjMtYznLSkl+PohiNX+WPqHfuBpEfmGpv+verRvmAlQzI4MnzzMSpIeKIMQv/ggEuh1cXlpy3Ik/5youPcBM+/7TUXJ2t9w1gyxSeXNmTVNY1Q5ZniTnkJG9332iRQajK/UevN2tr55vVvKKowpL3o2DeGOI+s6l2J30J+Tr70U1C+JzxLrW7/rvf90XnsKT1P7SN0YBIS/t6ZlLrgk5E9qLgvFlB2kUH5f/Mqw7aLPV2j+VeP7KGnjDC0bskzd4q+3i5bkyqqeFiGMES2nKcKXVf3l7y7w9yfLkRR6RoFP1TCNc6nkD0K/3ojgLzBbohQDJn3aDbliGPYoMOhoORmIEGVCF7OnxIV9JsO6n/Ku8dbay4R7FQYnltX1LNvLMXCbB9gLrXWWsEK37KiMUoFUYngIJ5GuttVqYLfrXeAKwBVuuIxgSVMhPCTQzo0ePNRBobtsuS24uTSeRETWZ3SI3wQW/WbYokYnudKXCWDzbd0zs7VupP1tLunOCt5cc0E+5dlD0LBwrA9NWPPDT0fKEB99jleQFw+hdWart6n60l2o7P3bSEdsfibKyI+pS9F5T3nI0Qt657SEUH0nM8e64fZmxMVEQe/eexor6+Yx15hL8slQB+yVHcKB/u0TDTVAeEkf5uuhZ5S2Tp49YDbRRZ96jcMGT26XfZBvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(8676002)(186003)(8936002)(6512007)(2906002)(956004)(107886003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001)(52116002)(36756003)(6486002)(7416002)(86362001)(316002)(478600001)(38100700001)(69590400012)(66476007)(6506007)(66556008)(2616005)(921005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0YBCa06dZ7d9NoZmGJOp5N2ORi2/vW47km2njuGYmYYyskR1fbEKPJBFNxKK?=
 =?us-ascii?Q?GiBSPMXW5K5lJGOmdZiKBLQkYji876d6776eSW13uOpO/qFgQAwcFDXMHywW?=
 =?us-ascii?Q?EtlOfV1kz1055EAYvfdOCCHyEvG4TEPopsZqDTH/xt5GhjdUKz1RFxF9UF7h?=
 =?us-ascii?Q?5BI829+ITQMfeHJhOx0znC+fTpvFO5iGGTwpslSUJUFC39ZrhMzYvSs2qJbM?=
 =?us-ascii?Q?5ZaWb+bKLoSPP8QSlfdnKiqZizS8oF8HV3D9MJyo7FkOrDHoqdifWXR9KwR8?=
 =?us-ascii?Q?KkG2S3Vj1zy8usXBMOmjMYfF1LA8bgIQg9jDvVyCgtzcpN/czxMtpIwWfwNM?=
 =?us-ascii?Q?cjAdiQgC5JF2aU/p9NmJPsTTFSRFAJfZA5nwmcKXncDp8h88e5dn/xaXF0l1?=
 =?us-ascii?Q?fLs7Myr8Z/9/sZGowsXnF8wjhwQ1Oighsj+a1crjDG5K5SNfMsE11Z5y2VbX?=
 =?us-ascii?Q?0VpPpvMLnfHXB5LM+xqLihoftdlTyra/isoasOR2Fv9xadEFdfAJ+1xLfmHC?=
 =?us-ascii?Q?le1zz644p7QWwtoeFgo88Nmg8X7u3IUUSQtLUmJL0XJAYCJWvlyMOfA9Rakk?=
 =?us-ascii?Q?FDHWFgw3vwysVPkDnPvRS8Id3IPOpwJrqC2Nq3QR6nbsgAi2EathAZdAIafh?=
 =?us-ascii?Q?3zoLWSS17ipFP/bJuPNb+lGVpMdZR14KA2Cy9/hcFlzpPTZsnR/zHYoJlOzV?=
 =?us-ascii?Q?Zf/H9n+DLQ+Lx+MtURu8M4qZb8aMXu7imxYOvT+19U8qzevtCln9DMw9Yh9q?=
 =?us-ascii?Q?24Sayi/d4rps0NplpZn68ur6Agg1yuucVAMZZ5dIxeDgG+05TA8TbOQ4uR+4?=
 =?us-ascii?Q?ymqMckHQ8anVU9njZgBqg/dMit0JtmTKodvByUgfY7tnKzVj+NDMC20oLyht?=
 =?us-ascii?Q?E7b6gcMfNmu2xd/2c7+BkaXR2vcHiW1OQNO0FhSVvCwhmGq11i+jeDUV0BtM?=
 =?us-ascii?Q?1rhNWw0PHmok74pwxdzgPqPzeNVHPnzyR2K+5eIniT6uJ300fdckkKIvPZW4?=
 =?us-ascii?Q?k2w2gtRczt8lRn8IUChQBlgtHjlrZxIYR5nfnNRI3Z8phBQALWkqWD0VfcWE?=
 =?us-ascii?Q?JuzBw30twKmjVZA+LZr93+f3pGUzVXEq+b/PCkVBbLiCdGvb1QcynTwQMcp2?=
 =?us-ascii?Q?24XeoyAryEF0SiQCeg7zD++56x+Gwclj17rQplZR+vQmaf7Q6RmTMGvyZSgx?=
 =?us-ascii?Q?ghovImGP4eEkOT/M2n6CyY6Yl3GQRjMNMLel/KV8TIma7bXYd4t/rQhjTej1?=
 =?us-ascii?Q?pJoUiQ2S8dUNn2NJUJZybJuszvAkJaUKtjXE5x3KWHznZmtpr8fVDLwaLTp7?=
 =?us-ascii?Q?NCuC6hYjsAkzqbmBrGi7/rpz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11a1eaae-baac-43b5-2ded-08d8f6f7a591
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:36.9514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bld4gT63DuHpSt4/f3DOUPOvMakRxeLEXVPxb/5cFrxD1NViBp4O0bm6hTsxG4PQCDQTxcKElkr09Wr9yRNPomODsd4EuyLuI/aoIq0Zivw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: uwFFUEt64Tl8NyQirJVdQRJ1HuDdUno6
X-Proofpoint-GUID: uwFFUEt64Tl8NyQirJVdQRJ1HuDdUno6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we are executing a multiple pdu sequence, tell the network layer we
will have more data.

This also sets MSG_MORE if the app batched cmds and we know we have more
than one that are going to be sent.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 16 +++++++++++-----
 drivers/scsi/libiscsi.c  | 10 ++++++++++
 include/scsi/libiscsi.h  |  1 +
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index eff5f8456ced..a85688d7ae2b 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -246,7 +246,8 @@ iscsi_sw_tcp_conn_restore_callbacks(struct iscsi_conn *conn)
 /**
  * iscsi_sw_tcp_xmit_segment - transmit segment
  * @tcp_conn: the iSCSI TCP connection
- * @segment: the buffer to transmnit
+ * @task: iscsi task we are transmitting data for
+ * @segment: the buffer to transmit
  *
  * This function transmits as much of the buffer as
  * the network layer will accept, and returns the number of
@@ -257,6 +258,7 @@ iscsi_sw_tcp_conn_restore_callbacks(struct iscsi_conn *conn)
  * it will retrieve the hash value and send it as well.
  */
 static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
+				     struct iscsi_task *task,
 				     struct iscsi_segment *segment)
 {
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
@@ -273,7 +275,10 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 		offset = segment->copied;
 		copy = segment->size - offset;
 
-		if (segment->total_copied + segment->size < segment->total_size)
+		if (segment->total_copied + segment->size <
+		    segment->total_size ||
+		    !(task->hdr->flags & ISCSI_FLAG_CMD_FINAL) ||
+		    !iscsi_xmit_list_is_empty(tcp_conn->iscsi_conn))
 			flags |= MSG_MORE;
 
 		/* Use sendpage if we can; else fall back to sendmsg */
@@ -304,8 +309,9 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 /**
  * iscsi_sw_tcp_xmit - TCP transmit
  * @conn: iscsi connection
+ * @task: iscsi task to send data for
  **/
-static int iscsi_sw_tcp_xmit(struct iscsi_conn *conn)
+static int iscsi_sw_tcp_xmit(struct iscsi_conn *conn, struct iscsi_task *task)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
@@ -314,7 +320,7 @@ static int iscsi_sw_tcp_xmit(struct iscsi_conn *conn)
 	int rc = 0;
 
 	while (1) {
-		rc = iscsi_sw_tcp_xmit_segment(tcp_conn, segment);
+		rc = iscsi_sw_tcp_xmit_segment(tcp_conn, task, segment);
 		/*
 		 * We may not have been able to send data because the conn
 		 * is getting stopped. libiscsi will know so propagate err
@@ -382,7 +388,7 @@ static int iscsi_sw_tcp_pdu_xmit(struct iscsi_task *task)
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	while (iscsi_sw_tcp_xmit_qlen(conn)) {
-		rc = iscsi_sw_tcp_xmit(conn);
+		rc = iscsi_sw_tcp_xmit(conn, task);
 		if (rc == 0) {
 			rc = -EAGAIN;
 			break;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index dd1e1963dd05..168afcb63bcf 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1609,6 +1609,16 @@ static bool iscsi_move_tasks(struct llist_head *submit_queue,
 	return !list_empty(exec_queue);
 }
 
+inline bool iscsi_xmit_list_is_empty(struct iscsi_conn *conn)
+{
+	if (!list_empty(&conn->cmd_exec_list) ||
+	    !list_empty(&conn->requeue_exec_list))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(iscsi_xmit_list_is_empty);
+
 static void iscsi_move_all_tasks(struct iscsi_conn *conn)
 {
 	iscsi_move_tasks(&conn->requeue, &conn->requeue_exec_list);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 12bdaee3b87e..f53f41f032d5 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -491,6 +491,7 @@ extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 extern int iscsi_complete_task(struct iscsi_conn *conn, struct iscsi_task *task,
 			       struct iscsi_hdr *hdr, char *data, int datalen);
 extern int iscsi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
+extern bool iscsi_xmit_list_is_empty(struct iscsi_conn *conn);
 
 struct iscsi_sc_iter_data {
 	struct iscsi_conn *conn;
-- 
2.25.1

