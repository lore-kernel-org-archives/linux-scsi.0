Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED240C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 00:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbiDHAPy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbiDHAPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 20:15:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394F612B5E0
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 17:13:38 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237Jv8j0005378;
        Fri, 8 Apr 2022 00:13:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=h2VbVoXicP5hoOoxVea5nKUJqSWFKhYSrzCPAk6yHQY=;
 b=ZkiZzLKgTvrlotiU1tOYxig80pS+8r0aGrEFdthPvhiqJFeM1CEwJ4iUlIIPq1CPq5la
 eo7Wsanas9SaCZppcZ0mreFH1CfDaJO3dgoohJlBRwaeak0mQZME/hcnyIITTjXxeM5d
 X/R7ekY1JCIV4xdPyvf66yoPjuha6aWjx2GSE2izRQSN2+Jyrg4dA9Foqq2T/TGvR0Nk
 oRV0kURPmIy2zUh4OEO+vnClBVABDdRTuXrdxAacbIUGEdy3Aqf0zIr+A3uA8J6FmyMl
 uDN6B4qE7kk5PAU7xR3Lzv8O4y1jhuZwVU6VIgE/hTapl0JYoymr9gI+mEuljNsFkp09 kg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d935env-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237M7smj029005;
        Fri, 8 Apr 2022 00:13:30 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f974erfry-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4PUTFlb9iJ05W5xtsxCjcoyGMfGmJuny1kGsTbUPKkuLLNgVDWoXP21nHaBIWRLRdWt6TIFcv148UlSeBp6Sz1qGt2AzdRFd5ikjt+4fXeePcMCpPpjqo3rnMdeY4/kxuQSnrGg5o6j3tshNhbRFGTrRfN4d9Ig3mYqr8gAGrxCebxLAorf8fkwhK65sNLxNyG+LkwDSNSxJJ7Gq/5Yxx6C/oMHe7ezMf07HLCZwzznTjl5pIa0XFVz1bQxWvO5kM7hiGeQDEBCtINzn2mlhxOcnjXoiaFxohgzRY2/NBIMA/LuQo20irhlo8fokz+G8/JqAH5WhSmlUUyp8u+1Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2VbVoXicP5hoOoxVea5nKUJqSWFKhYSrzCPAk6yHQY=;
 b=POJ/+cnNxjcT86tttsLu4nWYODsONmQJaZa6Y1Ar7rf6HE4JROJxDX1Cu057TZtZ2uQ/19tUYuv/xePXXtlFENI3PTHnt3GhmS9lf46p8Y2kN1sTssbCrVvtcg8IsM7pQHZfODWd4Ux7WVBOvbGSg8QfZRVm+MmzxwhhJsM6MCjY2isYKD2wDN/x79/D2NvljBg1X0xnQJmBxxgI6F5thMMN71b1cAPUkYM3u32QCLwgxF2feQOZsUR93xP9dRD3zYPZ6fzCvxuz0Kp7rdRbaBRrg85uKE3muhAa1EDqQHU4SyAQgruWwwm5cKBAWz7bRXQ9YxhKdUoHYBcZYeVR+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2VbVoXicP5hoOoxVea5nKUJqSWFKhYSrzCPAk6yHQY=;
 b=ntsKTYqF+XAMfVM17qF/n7dsszTa2YDCTbKv2WHDXsLv8cH4XDT5x1sPNlI3RxWMgZjtkTto4wI/x9g9PjpUAQNByVid++wKxQ5uwZDZdvBgqBwPqjlfxIxLOnK+1otoqIN8rOChawdvP2NaijShta3rQtFL8ZM4bPKCVLNM5Qg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB3762.namprd10.prod.outlook.com (2603:10b6:a03:1b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 00:13:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 00:13:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     skashyap@marvell.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 09/10] scsi: qedi: Fix failed disconnect handling.
Date:   Thu,  7 Apr 2022 19:13:13 -0500
Message-Id: <20220408001314.5014-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408001314.5014-1-michael.christie@oracle.com>
References: <20220408001314.5014-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36b3af9b-679b-4758-e125-08da18f49a89
X-MS-TrafficTypeDiagnostic: BY5PR10MB3762:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB3762AFDF3066EAE23D81C42AF1E99@BY5PR10MB3762.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z2gvGm/QZmfEZbB8+njzuSNxmyXC5NP5kHQ03M1d6xhemed0VYTHk9MZOXXhJY9qUxzxAeEx1dNUamm0hEOVPNDD+TlT+6JpmbxZ3Eeq4A4WtQdyZa1KX+O4GMvVBKxC7UxpLkCbCHBl45FSAVNP5nDhPkl9zQI8VUcsqavBfyEXoKRVzk6cdhvmoP+hiTRoRezbhrEbY7PUYg/m0DXusufUR0y+/Zx8MhVTjaUMGdNjiBk8n6e5h/bTDzI49O5pisYfulEYhyaGSXaKX5P9FYoUABBZ3QHB8TFR/dOt1ndmMCAKhXrQKzAnPwwrcA2v1yNtKrFRVW603mkj05jgV4ENFodCI+TOgychA/I+BWRvKF5g/GmhqHl163HK/GTVZrb25i89YNsB82YkfV71eO+nPQj673I9sSZcTNRLT5Vrl0XPHj0ESEmBeAiYhqFWAT1Yrp+guUK+BvwdEsja4t5EzisEqE2lmrFw3wzGUlPTI1iBsb+R4ZJPpESGiuoFCxeq+CcB63GN8Vpe6h7HZp+9v85UKUVGJ/Pi4hVxJOKhJ21f5xa27jPOz2PLaM6x+Us0yUMqWW9eYTWsHJ3cW/SeG3LTpSdrRf9w6m2lOurnM4UE66l7Dv4trgcoJaqAGKdbNwfTkQPIv7M2Ay/Uu8KaGg+xTAgou7CqsRQXSueWCZBoSL8M5Zxdoz16PMY9wnplnYle03gI1CoeCCp3aA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(6512007)(52116002)(5660300002)(2616005)(508600001)(6486002)(107886003)(8936002)(6666004)(6506007)(2906002)(38100700002)(38350700002)(186003)(1076003)(26005)(83380400001)(66556008)(4326008)(316002)(66946007)(66476007)(8676002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v+JIujZCqaogwjUTca1twJW8jONb2b1I8iMq+5ZEJsLtNUInwFcQPvIRz3MK?=
 =?us-ascii?Q?myqM+ewfbcUxyylYxKUJFifedp9AkGMLLk4K6dvshdjb59QgQ5lGJQrBeqQk?=
 =?us-ascii?Q?ochnK+5/0eObyAURhCntGmQBUXTbzwQJB0gGUdmYNgVMW7SNOSmgUZ8yInfw?=
 =?us-ascii?Q?o8fZdNTzeZ2LiOCMSqfQ8LrQ6iRHfRSTY+qCIngj2ZUIpKr1zrEiavMKeHmX?=
 =?us-ascii?Q?K/BMb/mgn6iMN4DJIQ5JE/8vxj0jOvScNampLZQ8LPwr4AiPJdOpRwHRa3/g?=
 =?us-ascii?Q?qEop5+XhloCI/jzSDXLwwsSfT4CEdAOIvpnEH+zGdNe3+WjhQ7kPo+ALJIMT?=
 =?us-ascii?Q?/AISmNQY28MZ/vhro3xRN5Ohe1J2p6rLeuKE22nPbOO2y7DS2I/ZbIRwCRhG?=
 =?us-ascii?Q?6fQoTKXpGb5nBpUhanFe3Zilw4i+9j6unArKLGPH42DCHoSCa6Fw8CsEpRNN?=
 =?us-ascii?Q?CO8mDtGJA10f1BKxzvbM1v19wQzgOPE+n9zaLR5lH2cn8I6NG3k8WTr6Eao4?=
 =?us-ascii?Q?U/RQfmJLvej0NwK1YFKthXv6OJMduSUN2FGaVTVAEwHEXh3lM0i+W+apPgWH?=
 =?us-ascii?Q?sIe8JvIlKspa0H1vJJ/4IHEPRUOEEj7xPkkjEYgcayPIAjPhhZVbD+h5vNAR?=
 =?us-ascii?Q?ofP3G7IQISgRZqLSZw+gQSutA92RpcRuCYqGhiSO8fY7YGy+zE/WHBEKCow4?=
 =?us-ascii?Q?zY/+cAz+fT5PkhDzEiAAHk63lE+pfmxNrysbkR2RCBDrsAmhwRzBLX8BbLtx?=
 =?us-ascii?Q?qQGeptiLcUwzlhOeySjQcz17nvAGJtHTX5aMEISLepfxlUTQtGeHk/be/dbP?=
 =?us-ascii?Q?vLYU6fhNkhfrIwMmIGvm73Rn0jaE/61zl+csufZsWIprtH+kIJ7NrcOfzNT+?=
 =?us-ascii?Q?oG8twzoZEsqv6If01Tkd2CzmEuyO8P7lnjEOuVNTCY2jzRTXqyf6YMQyK1Rz?=
 =?us-ascii?Q?mRPk10ySkEY8rGxePggzdsU2QpNcXppsKIreO1BPzYRq9C9gd/suG1Bbgado?=
 =?us-ascii?Q?lf+nS9G4CYrhtCw/fuhJWCvbeeWJJbJfsVbC8o3ZUQKKbnyz4rqhE09ao4iV?=
 =?us-ascii?Q?M0WEmpydWhqccwZwFb75+/fWsMfSNRD8Xru3NiVZJ137YQmCaQle2nZbYH+q?=
 =?us-ascii?Q?L2LRwfrCTVPIQSsH6rh0WiRFcZCWbjesM//zWDreVByqpL/gDe1uSE6ckN4B?=
 =?us-ascii?Q?PYm1ybooZGYECKSw21uIEGGQ+3Y/Qviq/0BiZDPEO5geaGRVYDnygasGaqZD?=
 =?us-ascii?Q?CdAu1LPh5FiA5iKMOQuX334YT2HRvI8Qd5zwypVKtAzsRiRvR0p6xuYE5R5A?=
 =?us-ascii?Q?aVXO2INj6UlpTIUxb+XYptx2sr0/wbK6AvCscxeuNpVNjNMmfjT3j+gR+62S?=
 =?us-ascii?Q?FWGmmrbF+AbRj2prGZeqXlcLBAyVOuJVnbwpqKn5LyZ71r+mCM7MJ9v9SyOJ?=
 =?us-ascii?Q?e8nVy0Qz9lx0m8QJ2pjx1QXcW6wy4KQOQlSBQShX9/yb7V/KDBWOR5hoBf7r?=
 =?us-ascii?Q?Wdj2kesOsPh/S9L6+DUC9zB1Ov3EL9Ur1hIafmptoMJ+8J1qABTlhTTjoxKS?=
 =?us-ascii?Q?rfUH5/la2DEPK+djO2OwO6kjvAhXXwMK0L+lnCBNpnSksptuK0c5e2g5zC0k?=
 =?us-ascii?Q?dIegwk04ZePb1OwsZ0ILa5qemhaLGIZvuT7GFmT9EBAaw9XYcTcWGu+dJemb?=
 =?us-ascii?Q?L0xzHbYcT86hrR8h+eTkVpfG4b7+SHYUHufcrGWk5onpPGs5Ql2gx8iksOJJ?=
 =?us-ascii?Q?xP0sczwMZVB4JAHD01uRH12v6JZ8cxY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b3af9b-679b-4758-e125-08da18f49a89
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 00:13:27.1410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QaI2MqS8Tpb8O+1Fl6SyHrNc/LgnxIACv4lPhLaxAlVwQeLKOuVLLHDoeXIBEcd980qP4VWCRQP0Suj11tWOLqmheAasvtYdmGJhKjCylTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3762
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204070064
X-Proofpoint-ORIG-GUID: eZWPc3bD0Ey-F-CkJARMwDWGI3WkSkgn
X-Proofpoint-GUID: eZWPc3bD0Ey-F-CkJARMwDWGI3WkSkgn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We set the qedi_ep state to EP_STATE_OFLDCONN_START when the ep is
created. Then in qedi_set_path we kick off the offload work. If userspace
times out the connection and calls ep_disconnect, qedi will only flush the
offload work if the qedi_ep state has transitioned away from
EP_STATE_OFLDCONN_START. If we can't connect we will not have transitioned
state and will leave the offload work running, and we will free the
qedi_ep from under it.

This patch just has us init the work when we create the ep, then always
flush it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 69 +++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 8196f89f404e..31ec429104e2 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -860,6 +860,37 @@ static int qedi_task_xmit(struct iscsi_task *task)
 	return qedi_iscsi_send_ioreq(task);
 }
 
+static void qedi_offload_work(struct work_struct *work)
+{
+	struct qedi_endpoint *qedi_ep =
+		container_of(work, struct qedi_endpoint, offload_work);
+	struct qedi_ctx *qedi;
+	int wait_delay = 5 * HZ;
+	int ret;
+
+	qedi = qedi_ep->qedi;
+
+	ret = qedi_iscsi_offload_conn(qedi_ep);
+	if (ret) {
+		QEDI_ERR(&qedi->dbg_ctx,
+			 "offload error: iscsi_cid=%u, qedi_ep=%p, ret=%d\n",
+			 qedi_ep->iscsi_cid, qedi_ep, ret);
+		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
+		return;
+	}
+
+	ret = wait_event_interruptible_timeout(qedi_ep->tcp_ofld_wait,
+					       (qedi_ep->state ==
+					       EP_STATE_OFLDCONN_COMPL),
+					       wait_delay);
+	if (ret <= 0 || qedi_ep->state != EP_STATE_OFLDCONN_COMPL) {
+		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
+		QEDI_ERR(&qedi->dbg_ctx,
+			 "Offload conn TIMEOUT iscsi_cid=%u, qedi_ep=%p\n",
+			 qedi_ep->iscsi_cid, qedi_ep);
+	}
+}
+
 static struct iscsi_endpoint *
 qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		int non_blocking)
@@ -908,6 +939,7 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	}
 	qedi_ep = ep->dd_data;
 	memset(qedi_ep, 0, sizeof(struct qedi_endpoint));
+	INIT_WORK(&qedi_ep->offload_work, qedi_offload_work);
 	qedi_ep->state = EP_STATE_IDLE;
 	qedi_ep->iscsi_cid = (u32)-1;
 	qedi_ep->qedi = qedi;
@@ -1056,12 +1088,11 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 	qedi_ep = ep->dd_data;
 	qedi = qedi_ep->qedi;
 
+	flush_work(&qedi_ep->offload_work);
+
 	if (qedi_ep->state == EP_STATE_OFLDCONN_START)
 		goto ep_exit_recover;
 
-	if (qedi_ep->state != EP_STATE_OFLDCONN_NONE)
-		flush_work(&qedi_ep->offload_work);
-
 	if (qedi_ep->conn) {
 		qedi_conn = qedi_ep->conn;
 		abrt_conn = qedi_conn->abrt_conn;
@@ -1235,37 +1266,6 @@ static int qedi_data_avail(struct qedi_ctx *qedi, u16 vlanid)
 	return rc;
 }
 
-static void qedi_offload_work(struct work_struct *work)
-{
-	struct qedi_endpoint *qedi_ep =
-		container_of(work, struct qedi_endpoint, offload_work);
-	struct qedi_ctx *qedi;
-	int wait_delay = 5 * HZ;
-	int ret;
-
-	qedi = qedi_ep->qedi;
-
-	ret = qedi_iscsi_offload_conn(qedi_ep);
-	if (ret) {
-		QEDI_ERR(&qedi->dbg_ctx,
-			 "offload error: iscsi_cid=%u, qedi_ep=%p, ret=%d\n",
-			 qedi_ep->iscsi_cid, qedi_ep, ret);
-		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
-		return;
-	}
-
-	ret = wait_event_interruptible_timeout(qedi_ep->tcp_ofld_wait,
-					       (qedi_ep->state ==
-					       EP_STATE_OFLDCONN_COMPL),
-					       wait_delay);
-	if ((ret <= 0) || (qedi_ep->state != EP_STATE_OFLDCONN_COMPL)) {
-		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
-		QEDI_ERR(&qedi->dbg_ctx,
-			 "Offload conn TIMEOUT iscsi_cid=%u, qedi_ep=%p\n",
-			 qedi_ep->iscsi_cid, qedi_ep);
-	}
-}
-
 static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
 {
 	struct qedi_ctx *qedi;
@@ -1381,7 +1381,6 @@ static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
 			  qedi_ep->dst_addr, qedi_ep->dst_port);
 	}
 
-	INIT_WORK(&qedi_ep->offload_work, qedi_offload_work);
 	queue_work(qedi->offload_thread, &qedi_ep->offload_work);
 
 	ret = 0;
-- 
2.25.1

