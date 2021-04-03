Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A760C43461
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FF156135F
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbhDCXYf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45014 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236975AbhDCXYX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:23 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NOCFp099638;
        Sat, 3 Apr 2021 23:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=fyFz3rzvDTFxtt4Kde8ArSwaxDoPDHezHrGR+ztMdLs=;
 b=sxMl1zvkJ5mfjYPK6l7vDG0pEGXgiOMzRnI06pxCGidiuyLOgwNLIDp67fgJDzIkC+0O
 QB+obWaLsIFCy+zADNMJzCFYtq/ezy5nhQM4ZL6EAwPoMT3ynvjPH0ErjijloKcEXHYy
 rIA+O7zR/8VEa/nHNkBRSy9Ht/BB7ZvLUMIR6KdDL+XyM39+i1XH0BlkLhmANG/wLSCt
 lS6YTTqY5ooZyuW63hdP0mGQrct4XRXi4OpCeQVeEOj8fbfKB8pj3yg3vhSWL/U992at
 cpy3FkmmaAHvqfq2h3CfCgXh914NIKVFJD7lxsyPSvavCdaQf4yxwegknCrU3wtQlgDO 0Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37pdvb8v6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NL6x0130144;
        Sat, 3 Apr 2021 23:24:11 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by aserp3020.oracle.com with ESMTP id 37pg61huas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgnYxKiSfpmX0d9CZkwAwBzIqY0cucPjq4WUgjsTPANe9es83Hs8tudK5vOj/M8paCGDufvcm5LubZTUKCZchbuVoDQERUZDp9RuyvIYAX+NwBxKfzeNoigy/HMuNEKDgsBkyrf2qTCbw9BUsMwPQL6o9Dd90g30LFB340vGYD6ZTkg/8D3/JslKtnJ2XHa1ptBUanQIEJVp3WfV1iNbQHqxbVaOBrRGSQxtAjBMgN+5lL06LTuEuyPaRAv9KLYG94R4Zh+fFO3JZNRuM11RONI8LonsoeWqoMzGNmZj2gtWOLuJ42n+BbMWyVebIUA3u5HgBOmPPjgoEkaB9pcqjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyFz3rzvDTFxtt4Kde8ArSwaxDoPDHezHrGR+ztMdLs=;
 b=kuVG4OzJ76skSHMnFJ1X03t3LP3qLiXpOA6qlNHXCXAq+WGmAmbJiDlVT7PWssa0mpDkbx2pqUllmmV+96nJHuyukSwoLE07Mwy8lu36tXQHm2nfK9fuKzFjM1yGU0KW89wmrr0Ie13+jeBvLQlgsY3dEuhsVD0tSQcTXIlhhhlA0V0TmD+T8KNPZHqN1VGTGnOkZ5uwGzAZwbwptJrOyBrKSpZNfSX9huIfMvK1Sjh12fQvQavluL6aqyfdPgdqzTmSZXGOwMQGD9oJj2oaha1IXz0Z0/OnOgGToWryQ7fshMHVSALnuYZ8ckK7rtL+n0iVwdLtcf4yywfzzh3ARg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyFz3rzvDTFxtt4Kde8ArSwaxDoPDHezHrGR+ztMdLs=;
 b=Ve//lYy7H2YzfSazhL70o+k0iplWWIXYpvGVaqxDoAJL0CQ39cwCDXY9dS03JC3Zk3wN8IupxszCqzMjaxOrWIcb6oAvL0NJgS2Ja9UHTGICFIBUXApcSS/IuRCFOlzaoshcPsdFxhv2DQCytTdYrba+C4RMdEGco5N2QEsGNdw=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:24:09 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 19/40] scsi: qedi: drop libiscsi itt use
Date:   Sat,  3 Apr 2021 18:23:12 -0500
Message-Id: <20210403232333.212927-20-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 834ab8d3-2ca2-4592-f430-08d8f6f794fb
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3526E03FCBFB7FF85BC8585FF1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gn0TH82NGIkL86aLKEodok3U0TDXPnMlrXQtUroxwoarSAJHvd1fSvK3TJbne3RHm0bKDbfmImQXAMA4S0j5oHMLmUqUzh75+n95WagSLacRznsYyeIjvfjm2d82hs++4n2fxoW6S0t3mFzSNe4mKK1eqPj8TUOwesFYAbTYX0wZOHD0fgKX50bT1yq16bg8frJOnhnG8Qgqu+ZZRuHytmtzFlpBMOoGAbIlEIC8qy3NdFmFjlSKKNhXxspln4kaMfSiB479ROkZMwZGMd4x/96Ee8Wi/yEIXWH+8xx04cleylRcHCwSrG/7lWe8uIH5m28UvyrY0M8eeoGZPPKIgo+0wQctI0bvIg+svBlbC4nEa5BMexC2dYIp7p/NJKP9Js/5eWif+At+iFSd3iODl9fbsKHnZ9ULs/9QNWGnNcAEXpTcHVdc6mvn3nZFlZPHz7oqGiMzZ68uy/+VzXmY85iqaXKCRolRJ4Pmu5uXwuEVjMHDa05wOVheyHffddjyXW8M4CyJGE1VNCAhJF5M2Ogvy7OGG/XexRzjRAB+smy7FLpXfrOAGBf1emM7UDIzxtlpy3wAMWX/UwogUrobcND7LYWY8LfjuH8xR6Iwu/wb6HnxYA+nokDiwel99E8MUeKXJPHalAepIz8ySE0eEgOFTRiUhiXAchnYSDATJOKrjccxWBA1Mrf5Slz4VbBb7/yenW9UYYOXB6xQoFaEBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(30864003)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(6666004)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JvAGVmrY0GO0UTHmjIpty6E79la/YY3HjN2fqFYtDZaWtsUN2rQO4sYf9ef+?=
 =?us-ascii?Q?3qa/6jXHTgFGhJIKm2igKbCA2QCFDaMbDT+T43YkzWAXhIEiSUmXsaOP4JWI?=
 =?us-ascii?Q?8ln1FiI7recnrRTr4m1YKbuKz+mWnWihNjQY8GpGOi4Hti7wCQNzHZ1pQYlm?=
 =?us-ascii?Q?wsuZdZxwvNsSgY1jGgcb3w4EPrY0pD+ZY/EqY8MvZOUkJBM063d+XIG7/zc4?=
 =?us-ascii?Q?KV3gm6lqtAEhulEId/sImgoj0dsC3AL55BV9AdFVlYSj5Fpj3SpgGDEAg9W/?=
 =?us-ascii?Q?mAHFSuTsqOxzeVUFvuvGHhS17TPssoYFUpHoUFjVW7C0BIeJeiNvdvRRjbLv?=
 =?us-ascii?Q?INYnGtZAexAlbfYGARNA4B1dtVkhkUTa3MSL2ivYKrnjR/S2pE/oCuRmiX0I?=
 =?us-ascii?Q?UAPBGhWcDJvsVxFkGtrv8MrMpP+saFfu0zfA7pRhOrqFw7CoAUFTRejSlAGi?=
 =?us-ascii?Q?b9wfexBqTCyPmSLYohu+J23pdPP2KRRLbmxYvrGaVAQwSzpqky2DU/QYbHv7?=
 =?us-ascii?Q?2JNkXk5T+bocRA977Gm2RPY6ChKvkrdMbUBwYN2PIe66rHZkhAhg2w4A50hn?=
 =?us-ascii?Q?7KAvSIXcGcbFYx97q4Q7JPMFulFNKqjs8V1YZdulO27FF+7zFshnRNKtCt1C?=
 =?us-ascii?Q?EvaavnEQ76MgmD2Gjf72Q2AslQyGvqeay/iJoV/8fv6QYcVVvE1x1OmRIn4j?=
 =?us-ascii?Q?XOIgSj6ryHw9RAWX8Kj6g78EbGDWVa5GTLkZ1NFJ5VPsGQctORCKWLQAfXYl?=
 =?us-ascii?Q?FKlNYx6WH7JtjosKerigXkZIJlbccavsaSCGq0sFjhkGWu7GcYIc22ByaFZG?=
 =?us-ascii?Q?XRV4A+nrTTXJ7ilCR1QMSjhWlxI8JJvp+QZAUgVIKai2oIQICIJlC2Pmv7wF?=
 =?us-ascii?Q?k9J0LbPHdYCDuEjCK+mL03jfjzrXV+kI1EoUIOV0dYrnVyT/rv7IADri6Thh?=
 =?us-ascii?Q?7gZUF6MO5xj6iJH1nmW7QRBzHaBv214c6Ena3wAd/YILbuWCyB8SEzjBQAc4?=
 =?us-ascii?Q?I6QNgDnAdniN6OpSXXwEWmZC+nWdAxa7nZ5Duc+geWpFoPj3OC7s/UTBBjd7?=
 =?us-ascii?Q?aNzPPyt6zTBg0wZUdS1tj1FXs3IQYKv3JSxtD9EwX+5qPj0i+SJcrfvwrbwz?=
 =?us-ascii?Q?CpekfVsTFGaZLthTisCO1lPgodgUfQAP9OkSkuR4ATQ7zXM47RYHFmVpSmR3?=
 =?us-ascii?Q?25t9bNwb+/i2et5r5LP+/cCK8UQXiDLcjNxk9GcyfkKHVaZhKYod4c/vjANq?=
 =?us-ascii?Q?O78Z50fe5iVAVMP5K8zPPJgk51OGO99ksP1f07Z1EPhTbL84W6c5x4vH3dKa?=
 =?us-ascii?Q?Lrh5nlUBPTf/zDUjQw0WixCu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 834ab8d3-2ca2-4592-f430-08d8f6f794fb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:09.1559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +WO/r/5PbgaKESNFgXTKVHJH8w/QtMS1mYqJWscvuA6lUWnxbM1nbZduqrDSzmb218X3vSw/wsUXhp97Z6IcSK4p8zHu+hwQA33155IAdB0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-GUID: ayrHEdq5zA1PRh_SNqcwrb-loEzod4yC
X-Proofpoint-ORIG-GUID: ayrHEdq5zA1PRh_SNqcwrb-loEzod4yC
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qedi has several tags:

1. 16 bit hw/fw tag for each low level cq/sq entry.
2. libiscsi itt/tag which comes from libiscsi for each cmd/task.
3. 32 bit iscsi itt/tag used for each iscsi PDU. The driver combines 1
and 2 to form this.

This patch simplifies the driver so we only have #1. Note that in a
future patchset for qedi only we can go further and remove #1 and use
the blk tag.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 127 ++++++++++++++++-----------------
 drivers/scsi/qedi/qedi_gbl.h   |   4 +-
 drivers/scsi/qedi/qedi_iscsi.h |   3 -
 drivers/scsi/qedi/qedi_main.c  |  22 ++----
 4 files changed, 70 insertions(+), 86 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 3357b0ff7dba..217291e81cdb 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -44,7 +44,6 @@ static void qedi_process_logout_resp(struct qedi_ctx *qedi,
 	resp_hdr->flags = cqe_logout_response->flags;
 	resp_hdr->hlength = 0;
 
-	resp_hdr->itt = build_itt(cqe->cqe_solicited.itid, conn->session->age);
 	resp_hdr->statsn = cpu_to_be32(cqe_logout_response->stat_sn);
 	resp_hdr->exp_cmdsn = cpu_to_be32(cqe_logout_response->exp_cmd_sn);
 	resp_hdr->max_cmdsn = cpu_to_be32(cqe_logout_response->max_cmd_sn);
@@ -71,7 +70,7 @@ static void qedi_process_logout_resp(struct qedi_ctx *qedi,
 
 	cmd->state = RESPONSE_RECEIVED;
 	qedi_clear_task_idx(qedi, cmd->task_id);
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
+	iscsi_complete_task(conn, task, (struct iscsi_hdr *)resp_hdr, NULL, 0);
 
 	spin_unlock(&session->back_lock);
 }
@@ -104,8 +103,6 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 	       (cqe_text_response->hdr_second_dword &
 		ISCSI_TEXT_RESPONSE_HDR_DATA_SEG_LEN_MASK));
 
-	resp_hdr_ptr->itt = build_itt(cqe->cqe_solicited.itid,
-				      conn->session->age);
 	resp_hdr_ptr->ttt = cqe_text_response->ttt;
 	resp_hdr_ptr->statsn = cpu_to_be32(cqe_text_response->stat_sn);
 	resp_hdr_ptr->exp_cmdsn = cpu_to_be32(cqe_text_response->exp_cmd_sn);
@@ -137,10 +134,10 @@ static void qedi_process_text_resp(struct qedi_ctx *qedi,
 	cmd->state = RESPONSE_RECEIVED;
 	qedi_clear_task_idx(qedi, cmd->task_id);
 
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr,
-			     qedi_conn->gen_pdu.resp_buf,
-			     (qedi_conn->gen_pdu.resp_wr_ptr -
-			      qedi_conn->gen_pdu.resp_buf));
+	iscsi_complete_task(conn, task, (struct iscsi_hdr *)resp_hdr_ptr,
+			    qedi_conn->gen_pdu.resp_buf,
+			    (qedi_conn->gen_pdu.resp_wr_ptr -
+			     qedi_conn->gen_pdu.resp_buf));
 	spin_unlock(&session->back_lock);
 }
 
@@ -170,7 +167,8 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	qedi_clear_task_idx(qedi, qedi_cmd->task_id);
 
 	spin_lock(&session->back_lock);
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
+	iscsi_complete_task(conn, qedi_cmd->task,
+			    (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
 	spin_unlock(&session->back_lock);
 
 exit_tmf_resp:
@@ -215,8 +213,6 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 	hton24(resp_hdr_ptr->dlength,
 	       (cqe_tmp_response->hdr_second_dword &
 		ISCSI_TMF_RESPONSE_HDR_DATA_SEG_LEN_MASK));
-	resp_hdr_ptr->itt = build_itt(cqe->cqe_solicited.itid,
-				      conn->session->age);
 	resp_hdr_ptr->statsn = cpu_to_be32(cqe_tmp_response->stat_sn);
 	resp_hdr_ptr->exp_cmdsn  = cpu_to_be32(cqe_tmp_response->exp_cmd_sn);
 	resp_hdr_ptr->max_cmdsn = cpu_to_be32(cqe_tmp_response->max_cmd_sn);
@@ -244,7 +240,8 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 
 	qedi_clear_task_idx(qedi, qedi_cmd->task_id);
 
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
+	iscsi_complete_task(conn, qedi_cmd->task,
+			    (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
 	kfree(resp_hdr_ptr);
 
 unblock_sess:
@@ -279,8 +276,6 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 	hton24(resp_hdr_ptr->dlength,
 	       (cqe_login_response->hdr_second_dword &
 		ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK));
-	resp_hdr_ptr->itt = build_itt(cqe->cqe_solicited.itid,
-				      conn->session->age);
 	resp_hdr_ptr->tsih = cqe_login_response->tsih;
 	resp_hdr_ptr->statsn = cpu_to_be32(cqe_login_response->stat_sn);
 	resp_hdr_ptr->exp_cmdsn = cpu_to_be32(cqe_login_response->exp_cmd_sn);
@@ -301,9 +296,9 @@ static void qedi_process_login_resp(struct qedi_ctx *qedi,
 
 	memset(task_ctx, '\0', sizeof(*task_ctx));
 
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr,
-			     qedi_conn->gen_pdu.resp_buf,
-			     (qedi_conn->gen_pdu.resp_wr_ptr -
+	iscsi_complete_task(conn, task, (struct iscsi_hdr *)resp_hdr_ptr,
+			    qedi_conn->gen_pdu.resp_buf,
+			    (qedi_conn->gen_pdu.resp_wr_ptr -
 			     qedi_conn->gen_pdu.resp_buf));
 
 	spin_unlock(&session->back_lock);
@@ -448,8 +443,6 @@ static int qedi_process_nopin_mesg(struct qedi_ctx *qedi,
 	if (task) {
 		cmd = task->dd_data;
 		hdr->flags = ISCSI_FLAG_CMD_FINAL;
-		hdr->itt = build_itt(cqe->cqe_solicited.itid,
-				     conn->session->age);
 		lun[0] = 0xffffffff;
 		lun[1] = 0xffffffff;
 		memcpy(&hdr->lun, lun, sizeof(struct scsi_lun));
@@ -469,7 +462,8 @@ static int qedi_process_nopin_mesg(struct qedi_ctx *qedi,
 	}
 
 done:
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, bdq_data, pdu_len);
+	iscsi_complete_task(conn, task, (struct iscsi_hdr *)hdr, bdq_data,
+			    pdu_len);
 
 	spin_unlock_bh(&session->back_lock);
 	return tgt_async_nop;
@@ -477,7 +471,6 @@ static int qedi_process_nopin_mesg(struct qedi_ctx *qedi,
 
 static void qedi_process_async_mesg(struct qedi_ctx *qedi,
 				    union iscsi_cqe *cqe,
-				    struct iscsi_task *task,
 				    struct qedi_conn *qedi_conn,
 				    u16 que_idx)
 {
@@ -523,15 +516,14 @@ static void qedi_process_async_mesg(struct qedi_ctx *qedi,
 	resp_hdr->param2 = cpu_to_be16(cqe_async_msg->param2_rsrv);
 	resp_hdr->param3 = cpu_to_be16(cqe_async_msg->param3_rsrv);
 
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, bdq_data,
-			     pdu_len);
+	iscsi_complete_task(conn, NULL, (struct iscsi_hdr *)resp_hdr, bdq_data,
+			    pdu_len);
 
 	spin_unlock_bh(&session->back_lock);
 }
 
 static void qedi_process_reject_mesg(struct qedi_ctx *qedi,
 				     union iscsi_cqe *cqe,
-				     struct iscsi_task *task,
 				     struct qedi_conn *qedi_conn,
 				     uint16_t que_idx)
 {
@@ -566,8 +558,8 @@ static void qedi_process_reject_mesg(struct qedi_ctx *qedi,
 	hdr->statsn = cpu_to_be32(cqe_reject->stat_sn);
 	hdr->ffffffff = cpu_to_be32(0xffffffff);
 
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
-			     conn->data, pld_len);
+	iscsi_complete_task(conn, NULL, (struct iscsi_hdr *)hdr, conn->data,
+			    pld_len);
 	spin_unlock_bh(&session->back_lock);
 }
 
@@ -628,7 +620,6 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 	hdr->opcode = cqe_data_in->opcode;
 	hdr->max_cmdsn = cpu_to_be32(cqe_data_in->max_cmd_sn);
 	hdr->exp_cmdsn = cpu_to_be32(cqe_data_in->exp_cmd_sn);
-	hdr->itt = build_itt(cqe->cqe_solicited.itid, conn->session->age);
 	hdr->response = cqe_data_in->reserved1;
 	hdr->cmd_status = cqe_data_in->status_rsvd;
 	hdr->flags = cqe_data_in->flags;
@@ -647,7 +638,7 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 		     GET_FIELD(cqe_err_bits, CQE_ERROR_BITMAP_UNDER_RUN_ERR))) {
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 			  "Under flow itt=0x%x proto flags=0x%x tid=0x%x cid 0x%x fw resid 0x%x sc dlen 0x%x\n",
-			  hdr->itt, cqe_data_in->flags, cmd->task_id,
+			  task->itt, cqe_data_in->flags, cmd->task_id,
 			  qedi_conn->iscsi_conn_id, hdr->residual_count,
 			  scsi_bufflen(sc_cmd));
 		hdr->residual_count = cpu_to_be32(scsi_bufflen(sc_cmd));
@@ -671,8 +662,8 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 		qedi_trace_io(qedi, task, cmd->task_id, QEDI_IO_TRACE_RSP);
 
 	qedi_clear_task_idx(qedi, cmd->task_id);
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
-			     conn->data, datalen);
+	iscsi_complete_task(conn, task, (struct iscsi_hdr *)hdr, conn->data,
+			    datalen);
 error:
 	spin_unlock_bh(&session->back_lock);
 }
@@ -740,15 +731,13 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 {
 	struct qedi_work_map *work, *work_tmp;
 	u32 proto_itt = cqe->itid;
-	u32 ptmp_itt = 0;
-	itt_t protoitt = 0;
 	int found = 0;
 	struct qedi_cmd *qedi_cmd = NULL;
 	u32 rtid = 0;
 	u32 iscsi_cid;
 	struct qedi_conn *qedi_conn;
 	struct qedi_cmd *dbg_cmd;
-	struct iscsi_task *task;
+	struct iscsi_task *task = NULL;
 
 	iscsi_cid = cqe->conn_id;
 	qedi_conn = qedi->cid_que.conn_cid_tbl[iscsi_cid];
@@ -809,16 +798,20 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 		qedi_cmd->state = CLEANUP_RECV;
 		wake_up_interruptible(&qedi_conn->wait_queue);
 	} else if (qedi_conn->cmd_cleanup_req > 0) {
-		spin_lock_bh(&conn->session->back_lock);
-		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
-		protoitt = build_itt(ptmp_itt, conn->session->age);
-		task = iscsi_itt_to_task(conn, protoitt);
+		dbg_cmd = qedi_get_cmd_from_tid(qedi, cqe->itid, true);
+		if (dbg_cmd) {
+			/*
+			 * We don't have a ref to the task so this is just used
+			 * as a hint.
+			 */
+			task = dbg_cmd->task;
+		}
+
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
-			  "cleanup io itid=0x%x, protoitt=0x%x, cmd_cleanup_cmpl=%d, cid=0x%x\n",
-			  cqe->itid, protoitt, qedi_conn->cmd_cleanup_cmpl,
+			  "cleanup io itid=0x%x, cmd_cleanup_cmpl=%d, cid=0x%x\n",
+			  cqe->itid, qedi_conn->cmd_cleanup_cmpl,
 			  qedi_conn->iscsi_conn_id);
 
-		spin_unlock_bh(&conn->session->back_lock);
 		if (!task) {
 			QEDI_NOTICE(&qedi->dbg_ctx,
 				    "task is null, itid=0x%x, cid=0x%x\n",
@@ -834,12 +827,18 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
 
 	} else {
-		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
-		protoitt = build_itt(ptmp_itt, conn->session->age);
-		task = iscsi_itt_to_task(conn, protoitt);
+		dbg_cmd = qedi_get_cmd_from_tid(qedi, cqe->itid, false);
+		if (dbg_cmd) {
+			/*
+			 * We don't have a ref to the task so this is just used
+			 * for debugging.
+			 */
+			task = dbg_cmd->task;
+		}
+
 		QEDI_ERR(&qedi->dbg_ctx,
-			 "Delayed or untracked cleanup response, itt=0x%x, tid=0x%x, cid=0x%x, task=%p\n",
-			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id, task);
+			 "Delayed or untracked cleanup response, tid=0x%x, cid=0x%x, task=%p\n",
+			 cqe->itid, qedi_conn->iscsi_conn_id, task);
 	}
 }
 
@@ -907,8 +906,6 @@ void qedi_fp_process_cqes(struct qedi_work *work)
 			qedi_process_nopin_local_cmpl(qedi, &cqe->cqe_solicited,
 						      task, q_conn);
 		} else {
-			cqe->cqe_solicited.itid =
-					       qedi_get_itt(cqe->cqe_solicited);
 			/* Process other solicited responses */
 			qedi_mtask_completion(qedi, cqe, task, q_conn, que_idx);
 		}
@@ -916,16 +913,14 @@ void qedi_fp_process_cqes(struct qedi_work *work)
 	case ISCSI_CQE_TYPE_UNSOLICITED:
 		switch (hdr_opcode) {
 		case ISCSI_OPCODE_NOP_IN:
-			qedi_process_nopin_mesg(qedi, cqe, task, q_conn,
+			qedi_process_nopin_mesg(qedi, cqe, NULL, q_conn,
 						que_idx);
 			break;
 		case ISCSI_OPCODE_ASYNC_MSG:
-			qedi_process_async_mesg(qedi, cqe, task, q_conn,
-						que_idx);
+			qedi_process_async_mesg(qedi, cqe, q_conn, que_idx);
 			break;
 		case ISCSI_OPCODE_REJECT:
-			qedi_process_reject_mesg(qedi, cqe, task, q_conn,
-						 que_idx);
+			qedi_process_reject_mesg(qedi, cqe, q_conn, que_idx);
 			break;
 		}
 		goto exit_fp_process;
@@ -1035,8 +1030,8 @@ int qedi_send_iscsi_login(struct qedi_conn *qedi_conn,
 	login_req_pdu_header.tsih = login_hdr->tsih;
 	login_req_pdu_header.hdr_second_dword = ntoh24(login_hdr->dlength);
 
-	qedi_update_itt_map(qedi, tid, task->itt, qedi_cmd);
-	login_req_pdu_header.itt = qedi_set_itt(tid, get_itt(task->itt));
+	qedi_update_itt_map(qedi, tid, qedi_cmd);
+	login_req_pdu_header.itt = tid;
 	login_req_pdu_header.cid = qedi_conn->iscsi_conn_id;
 	login_req_pdu_header.cmd_sn = be32_to_cpu(login_hdr->cmdsn);
 	login_req_pdu_header.exp_stat_sn = be32_to_cpu(login_hdr->exp_statsn);
@@ -1129,8 +1124,8 @@ int qedi_send_iscsi_logout(struct qedi_conn *qedi_conn,
 	/* Update header info */
 	logout_pdu_header.opcode = logout_hdr->opcode;
 	logout_pdu_header.reason_code = 0x80 | logout_hdr->flags;
-	qedi_update_itt_map(qedi, tid, task->itt, qedi_cmd);
-	logout_pdu_header.itt = qedi_set_itt(tid, get_itt(task->itt));
+	qedi_update_itt_map(qedi, tid, qedi_cmd);
+	logout_pdu_header.itt = tid;
 	logout_pdu_header.exp_stat_sn = be32_to_cpu(logout_hdr->exp_statsn);
 	logout_pdu_header.cmd_sn = be32_to_cpu(logout_hdr->cmdsn);
 	logout_pdu_header.cid = qedi_conn->iscsi_conn_id;
@@ -1464,8 +1459,8 @@ int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 	memset(&tmf_pdu_header, 0, sizeof(tmf_pdu_header));
 
 	/* Update header info */
-	qedi_update_itt_map(qedi, tid, mtask->itt, qedi_cmd);
-	tmf_pdu_header.itt = qedi_set_itt(tid, get_itt(mtask->itt));
+	qedi_update_itt_map(qedi, tid, qedi_cmd);
+	tmf_pdu_header.itt = tid;
 	tmf_pdu_header.cmd_sn = be32_to_cpu(tmf_hdr->cmdsn);
 
 	memcpy(scsi_lun, &tmf_hdr->lun, sizeof(struct scsi_lun));
@@ -1481,9 +1476,7 @@ int qedi_send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task *mtask)
 			return 0;
 		}
 		cmd = (struct qedi_cmd *)ctask->dd_data;
-		tmf_pdu_header.rtt =
-				qedi_set_itt(cmd->task_id,
-					     get_itt(tmf_hdr->rtt));
+		tmf_pdu_header.rtt = cmd->task_id;
 	} else {
 		tmf_pdu_header.rtt = ISCSI_RESERVED_TAG;
 	}
@@ -1564,8 +1557,8 @@ int qedi_send_iscsi_text(struct qedi_conn *qedi_conn,
 	text_request_pdu_header.opcode = text_hdr->opcode;
 	text_request_pdu_header.flags_attr = text_hdr->flags;
 
-	qedi_update_itt_map(qedi, tid, task->itt, qedi_cmd);
-	text_request_pdu_header.itt = qedi_set_itt(tid, get_itt(task->itt));
+	qedi_update_itt_map(qedi, tid, qedi_cmd);
+	text_request_pdu_header.itt = tid;
 	text_request_pdu_header.ttt = text_hdr->ttt;
 	text_request_pdu_header.cmd_sn = be32_to_cpu(text_hdr->cmdsn);
 	text_request_pdu_header.exp_stat_sn = be32_to_cpu(text_hdr->exp_statsn);
@@ -1670,13 +1663,13 @@ int qedi_send_iscsi_nopout(struct qedi_conn *qedi_conn,
 	nop_out_pdu_header.cmd_sn = be32_to_cpu(nopout_hdr->cmdsn);
 	nop_out_pdu_header.exp_stat_sn = be32_to_cpu(nopout_hdr->exp_statsn);
 
-	qedi_update_itt_map(qedi, tid, task->itt, qedi_cmd);
+	qedi_update_itt_map(qedi, tid, qedi_cmd);
 
 	if (nopout_hdr->ttt != ISCSI_TTT_ALL_ONES) {
 		nop_out_pdu_header.itt = be32_to_cpu(nopout_hdr->itt);
 		nop_out_pdu_header.ttt = be32_to_cpu(nopout_hdr->ttt);
 	} else {
-		nop_out_pdu_header.itt = qedi_set_itt(tid, get_itt(task->itt));
+		nop_out_pdu_header.itt = tid;
 		nop_out_pdu_header.ttt = ISCSI_TTT_ALL_ONES;
 
 		spin_lock(&qedi_conn->list_lock);
@@ -2025,8 +2018,8 @@ int qedi_iscsi_send_ioreq(struct iscsi_task *task)
 	cmd_pdu_header.lun.lo = be32_to_cpu(scsi_lun[0]);
 	cmd_pdu_header.lun.hi = be32_to_cpu(scsi_lun[1]);
 
-	qedi_update_itt_map(qedi, tid, task->itt, cmd);
-	cmd_pdu_header.itt = qedi_set_itt(tid, get_itt(task->itt));
+	qedi_update_itt_map(qedi, tid, cmd);
+	cmd_pdu_header.itt = tid;
 	cmd_pdu_header.expected_transfer_length = cpu_to_be32(hdr->data_length);
 	cmd_pdu_header.hdr_second_dword = ntoh24(hdr->dlength);
 	cmd_pdu_header.cmd_sn = be32_to_cpu(hdr->cmdsn);
diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index 098982e6f8a2..4222d693c095 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -38,11 +38,13 @@ int qedi_send_iscsi_nopout(struct qedi_conn *qedi_conn,
 			   struct iscsi_task *task,
 			   char *datap, int data_len, int unsol);
 int qedi_iscsi_send_ioreq(struct iscsi_task *task);
+struct qedi_cmd *qedi_get_cmd_from_tid(struct qedi_ctx *qedi, u32 tid,
+				       bool clear_mapping);
 int qedi_get_task_idx(struct qedi_ctx *qedi);
 void qedi_clear_task_idx(struct qedi_ctx *qedi, int idx);
 int qedi_iscsi_cleanup_task(struct iscsi_task *task);
 void qedi_iscsi_unmap_sg_list(struct qedi_cmd *cmd);
-void qedi_update_itt_map(struct qedi_ctx *qedi, u32 tid, u32 proto_itt,
+void qedi_update_itt_map(struct qedi_ctx *qedi, u32 tid,
 			 struct qedi_cmd *qedi_cmd);
 void qedi_get_proto_itt(struct qedi_ctx *qedi, u32 tid, u32 *proto_itt);
 void qedi_get_task_tid(struct qedi_ctx *qedi, u32 itt, int16_t *tid);
diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscsi.h
index 5522df952c30..662e7380a14c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.h
+++ b/drivers/scsi/qedi/qedi_iscsi.h
@@ -227,9 +227,6 @@ struct qedi_boot_target {
 	u32 ipv6_en;
 };
 
-#define qedi_set_itt(task_id, itt) ((u32)(((task_id) & 0xffff) | ((itt) << 16)))
-#define qedi_get_itt(cqe) (cqe.iscsi_hdr.cmd.itt >> 16)
-
 #define QEDI_OFLD_WAIT_STATE(q) ((q)->state == EP_STATE_OFLDCONN_FAILED || \
 				(q)->state == EP_STATE_OFLDCONN_COMPL)
 
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 0aa0061dad40..f10739148080 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -62,7 +62,6 @@ static LIST_HEAD(qedi_udev_list);
 /* Static function declaration */
 static int qedi_alloc_global_queues(struct qedi_ctx *qedi);
 static void qedi_free_global_queues(struct qedi_ctx *qedi);
-static struct qedi_cmd *qedi_get_cmd_from_tid(struct qedi_ctx *qedi, u32 tid);
 static void qedi_reset_uio_rings(struct qedi_uio_dev *udev);
 static void qedi_ll2_free_skbs(struct qedi_ctx *qedi);
 static struct nvm_iscsi_block *qedi_get_nvram_block(struct qedi_ctx *qedi);
@@ -1223,7 +1222,8 @@ static int qedi_queue_cqe(struct qedi_ctx *qedi, union iscsi_cqe *cqe,
 	switch (cqe->cqe_common.cqe_type) {
 	case ISCSI_CQE_TYPE_SOLICITED:
 	case ISCSI_CQE_TYPE_SOLICITED_WITH_SENSE:
-		qedi_cmd = qedi_get_cmd_from_tid(qedi, cqe->cqe_solicited.itid);
+		qedi_cmd = qedi_get_cmd_from_tid(qedi, cqe->cqe_solicited.itid,
+						 true);
 		if (!qedi_cmd) {
 			rc = -1;
 			break;
@@ -1850,10 +1850,8 @@ void qedi_clear_task_idx(struct qedi_ctx *qedi, int idx)
 			 "FW task context, already cleared, tid=0x%x\n", idx);
 }
 
-void qedi_update_itt_map(struct qedi_ctx *qedi, u32 tid, u32 proto_itt,
-			 struct qedi_cmd *cmd)
+void qedi_update_itt_map(struct qedi_ctx *qedi, u32 tid, struct qedi_cmd *cmd)
 {
-	qedi->itt_map[tid].itt = proto_itt;
 	qedi->itt_map[tid].p_cmd = cmd;
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
@@ -1878,15 +1876,8 @@ void qedi_get_task_tid(struct qedi_ctx *qedi, u32 itt, s16 *tid)
 	WARN_ON(1);
 }
 
-void qedi_get_proto_itt(struct qedi_ctx *qedi, u32 tid, u32 *proto_itt)
-{
-	*proto_itt = qedi->itt_map[tid].itt;
-	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
-		  "Get itt map tid [0x%x with proto itt[0x%x]",
-		  tid, *proto_itt);
-}
-
-struct qedi_cmd *qedi_get_cmd_from_tid(struct qedi_ctx *qedi, u32 tid)
+struct qedi_cmd *qedi_get_cmd_from_tid(struct qedi_ctx *qedi, u32 tid,
+				       bool clear_mapping)
 {
 	struct qedi_cmd *cmd = NULL;
 
@@ -1897,7 +1888,8 @@ struct qedi_cmd *qedi_get_cmd_from_tid(struct qedi_ctx *qedi, u32 tid)
 	if (cmd->task_id != tid)
 		return NULL;
 
-	qedi->itt_map[tid].p_cmd = NULL;
+	if (clear_mapping)
+		qedi->itt_map[tid].p_cmd = NULL;
 
 	return cmd;
 }
-- 
2.25.1

