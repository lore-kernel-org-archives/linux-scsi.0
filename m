Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD32C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240503AbiCHAlP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbiCHAlP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:41:15 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAB93DA6B
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:40:19 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227LG1OE002100;
        Tue, 8 Mar 2022 00:40:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=r8OO8RTmpIpgxfgvDMnSgpXuwsXIYksXMlM2q6AW/os=;
 b=cKd7NfGaHZlSPZEbPBrXxNJEj8DgFLGrbOx+zCCI55TsbEhPLs45Bmen7HrTckco8S00
 jrhlR2lQG0n0yHJRQjTIJkHr6ryPtz0EHZGWGzIs7itzUysVLhQcAJMzRxMTsuVHpYS/
 K1ABq6xVEnM3esJkk2fPOs+QvlZgLrRJl9KFBAXpuNnyIxYBhb8rjtAI7WDrbi6A8r9q
 yO2s4fB0hzvKNvaiTrklBRTi/E4NiMcjjfu8QtRsOXAaYS3XMUncWiI5g1pMRRpXOS9X
 pEnDDmYNLXv/HYpvShXfRO4gPp3cZ60N96NvKljK8RPjUqczCdl0zr+cZFhaHgi7FkGz +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfsdh9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:40:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280alEC119127;
        Tue, 8 Mar 2022 00:40:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3020.oracle.com with ESMTP id 3em1ajmyke-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:40:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFlxil2C510tTUXbgRkRO2b087FeRTaKvAyIs/mqGZsL5dFQK6jQedV9e4C+h2aeX1Ji2q2plrSDiiP1GzFklES9/8x4tagKbBhCRmaLgdwd1Yy0w3EVEwiz08JF24qsEoQkNLE8SaFPpmkR709LHSNd+Yo9NQkz3A8qRVAdieTL49hpjHmxCr1weyyUNh32nMNKKz54CCoN9K9e8rPpth/Sf/W1bAt5CfLf+suujdWLu1YFl7xhLL49/hCMdZyV/O+wJYIOLeT1TVvZCGQJltOE7RxiWCDOj7+K1VPi8GWvSvYAXNDhrYC02fih6F5rEDpXMnamynYXJMxT6dzuRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r8OO8RTmpIpgxfgvDMnSgpXuwsXIYksXMlM2q6AW/os=;
 b=c+j314NYzMddyaogJsh1dvrXSZhhgMP4fbRlX/iUPEcEQmOkQ9RpgZn3AkJsi9+2lOndLfp9rTyOiXKLnxfUDDXefvgeaG7A3CTKp8AUm7bxYtcrEra59XnE5w9baV/eJuHDWsGUdD58awmfiVG8Le/OooNgSOuvZ9g89a/tF9dGGw2T180AviuuQ4W2ncqrTM8QQdu42Aiy5bS66I8LXf727gFZ+M+cT2V2NNdQgijeANXBqX0+PNCTOPovXuHc51qKHZx01FQ9wnU2uP6QJBZ+hCFMCTIOLeyh+48ateWSflJBIuwu1CUrXz8S4dJuc16BXKQHItAN05zT/zF/Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8OO8RTmpIpgxfgvDMnSgpXuwsXIYksXMlM2q6AW/os=;
 b=vwBAQ/Ctg2Ri7yv0Wz8zLEcM8odLEE2y3wto9J9sKECgFylV72WwlgnLriPaefzh0MSbLsTCeonur1TsdrzYdLr7/pqVVpmDq7acZLyzTerfCl8x7QpHdIckWW8vnoGAK4wnJsJRHdP84mVHVa9VhxzOw64EsHhF18ov5A9wI6M=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (10.168.103.135) by
 MN2PR10MB3680.namprd10.prod.outlook.com (20.179.98.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Tue, 8 Mar 2022 00:40:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:40:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, lduncan@suse.com, cleech@redhat.com,
        ming.lei@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC PATCH 2/4] scsi: iscsi: Tell drivers when we must not block
Date:   Mon,  7 Mar 2022 18:39:55 -0600
Message-Id: <20220308003957.123312-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308003957.123312-1-michael.christie@oracle.com>
References: <20220308003957.123312-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:5:40::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a94204cb-a5e3-460f-5efd-08da009c30cf
X-MS-TrafficTypeDiagnostic: MN2PR10MB3680:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB36806060A9521CA243DB5B4EF1099@MN2PR10MB3680.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NlYcE8u8NCJA15RcbLNiF6/B3KpcxHlO3eFcfsVveXM1RVd8CPvfjeBeLp74a3SDBGk0iDWSnj7wWenRP4pALlHCiRgsm7ggHxKaMRlsomv+UwK+4ZxnYH7oQuy6hR77/ood0mXxLHbfxqg2DO116+skorC9vyqyiT+5b5ttCu7bMLH5YuMcITtog+P/fCkRuXFJSzszBHFE8m0n25ErE/aW66pQ7u8xpEqAqo0vaXm16SflxjSwkXdAzT4H6JDNARsyKFmeJnFZ6x0PJyYK7YFRijEigbDX5iy2NEXMkzTUueb5hXSYKLpzqLBzPhbOdCb+PuZpr2xTLmRXrMLKJejVMwCXX1w9GHCJWObHHcNF/NlFzKGGClIq3ZsekXFDjaYbLZh49ZIuyQ/AH2CJEu8KCvgR2/8j5pUm1mD5TWHQOQJCORlGnTyxIcFcZ5KpDkp8NkzF3hLqIbdY85DRgYcemczBE4GKAgtkaSLLVRVf0UQVTU28nhiBBMR8wL4jUL+UpsfLmGIlzvdp9vZjcdZ7Q0dMk/AhmWHuiTMhXYdyCb0dWAJPch+3jybvh0ALfXLyXPC3GLqCBF9Qqt4HOHfPIXr0J+MxHqYCq6b4mmXWS8HnGUlwYg+BHn9sLLK3Sg7D9z3r3wcJYMxfN9voURH0o3EeVDYfkCzDR473+a+aWUPkKTMaGwC1f8IgJQxcLAGlDhMhYshS5MA+MlKm8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(508600001)(6506007)(52116002)(86362001)(8936002)(66556008)(30864003)(6666004)(8676002)(66946007)(6486002)(6512007)(107886003)(1076003)(2906002)(26005)(186003)(4326008)(66476007)(38100700002)(38350700002)(316002)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XoTn4hazVxv+Z7di7Mu0QWg0zre/C8AmRXLbFod4w12j8eWDm9gL8pxj3RKF?=
 =?us-ascii?Q?+oIdxB/Q2xD133KZATcMWtoIwQWF9VPANYtPfDPIWJd9HxMYENLCotu5FkIu?=
 =?us-ascii?Q?MdbyDvg/lS6WSUCCLBXlaEWvyYAQaucwOSniBnvdFi8gpac+arPKML1+jNxO?=
 =?us-ascii?Q?Xkckw53pV+be4yBVBX1GnDjMcXbL918W14K8yms5d5bkZUOoG5CTKImoY+/c?=
 =?us-ascii?Q?udMHPikQFefGePj1qHyW9KtU4Oyz4at+7tOxgHMkeZPlAB6VHBATdo5e/6Fi?=
 =?us-ascii?Q?RuxcJzfRmYVBdulDM0NFLEEKxDzJkeRWiE1tr3bjPkrWkKbG93DkjTUeCg19?=
 =?us-ascii?Q?TiZV8YQH+VAeBAcCpWMEerOKEJyDa6OheBy68cmWJm1SiER5zfNqB37nYQql?=
 =?us-ascii?Q?i97b6NLy6JC3LLN7hexMhlj/BlfQdJlw9FrTJE7tB794ygQSKGjIzae6qRTm?=
 =?us-ascii?Q?S4evjYLs367/pugJth+NIQTPRGvmAJZCrSBK2ibQwcQYV3GodsMJNwdpPRjO?=
 =?us-ascii?Q?a121dDRbQqPPj1Koyo7jmuc6XvL+bBGVhpd8jiLWULND7yOzg1Wr4aCtuT9C?=
 =?us-ascii?Q?ijZi5ECFFNXaaHpBsb2/0aYQjzG/6y99WFlItcWRyC3xNqL2wKLspgOhhynP?=
 =?us-ascii?Q?526ySj5N/1ETgzb9owDqu97EWZXBEJ0NHf2odkY/trzdafVnGq4iFvkjftZx?=
 =?us-ascii?Q?zXcziYrJsPtmwIiXEbrYlC94QdDddjpiGx3GNhCThmlIALnOgmYE6urNt964?=
 =?us-ascii?Q?j9tlu5rmFrBtvj5SSylzwsxvaSclnZH+gO2az3Y7cKli1Cm1lw+WBmFHzSxO?=
 =?us-ascii?Q?Oip/uwWA4gXiZIFzjB3KIo4kTtgcL6aqvGx9sOjgp1xZXwNRk30oLjldBS2u?=
 =?us-ascii?Q?OB/pgcLQegFdRxfwsLywXdQPU6j39hGoL4caR52XDwffVq8UzWnlvVT8Kzb0?=
 =?us-ascii?Q?cXDkQ/uipkv/LVULaCmVDDHJOwQPyRcb4QLADojUjNgsYobCGCQkI5PaNaCM?=
 =?us-ascii?Q?1j3Ls1YFfRhnqqc3uhP5IVAmSVFlwyLzqdyr7Ah8v1UVCWbLwI8AhyYm4jzZ?=
 =?us-ascii?Q?afOy2/wSBOQfOeuYD2RI5eRh/AOubwKg2CPxfZ7Y103mFjQkM5572oGHXPKE?=
 =?us-ascii?Q?TFprKfk1wA5H3Baen9M/ITQVkwVHzNK/KNlae0MoZD/r35Q/Iz1f0D0b7VKc?=
 =?us-ascii?Q?QGoXMeYv+5iEnKlcomzuQ29ZuvfNYBX9GrhL2mmKPVPvXPyEDmoJTEMatscO?=
 =?us-ascii?Q?L+AVrNOlaQA9cjfUK88mO7LsFFDFrAyLEdp0BP+oAsQssTlk/BUjy8Y7RrCo?=
 =?us-ascii?Q?6V7lteSrzsQ/sgCx2i+V6cLJ+FQfPNv07TWv2l2b1BVA6/An+llr8IXDFEBJ?=
 =?us-ascii?Q?urlTabRssW2omCdrKVA+SdnvGcxj9bEtPF7EI9cbLaz5NUSmYTszJ0DigYow?=
 =?us-ascii?Q?Uupnl3p8RhYqbJIbnVBkBf39QyIEi8nM2EFwXBG53DVn1mk9LafVXFNrETgz?=
 =?us-ascii?Q?t43ygsSUJmmKgUTl6kv60ustZlr/sdvOHF1XtiobtJ5hHCRIJE7lnUkxMrDi?=
 =?us-ascii?Q?Oyy/WK6ScMJA4H6EOuFrIPLW8SGsB5uRHUTz7sOh1OAICY/kUkg+LuC8S8xJ?=
 =?us-ascii?Q?WxZUh3yetGrpUPHtUjWgrijmEU8bD/kDX/kK+zQeWKp+ynK0qZVticW+UDv2?=
 =?us-ascii?Q?cgZB9w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a94204cb-a5e3-460f-5efd-08da009c30cf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:40:06.1235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BNj/f2it8bDt/s2au/qRiKHVP9QiNKsRr6+XRyfLNT/rYKBZ4pPg3U4V5DeGBIVlH8lX9cLbDkNQk6WXpR1YRPhqwCk7LanH+ZruD3fwiQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3680
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080000
X-Proofpoint-GUID: QNBmPZe5A8aSXajFwVcb9iMGWdqnfer2
X-Proofpoint-ORIG-GUID: QNBmPZe5A8aSXajFwVcb9iMGWdqnfer2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When in the next patches we xmit from kblockd we will want to perform
non-blocking IO so we don't affect other sessions while waiting for memory.
This adds an arg to the task and pdu xmit functions so libiscsi can tell
the drivers that support transmitting from both queuecommand and the
iscsi_q wq when they can't block.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  2 +-
 drivers/scsi/be2iscsi/be_main.c          |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |  3 ++-
 drivers/scsi/cxgbi/libcxgbi.c            |  2 +-
 drivers/scsi/cxgbi/libcxgbi.h            |  2 +-
 drivers/scsi/iscsi_tcp.c                 | 16 +++++++++++-----
 drivers/scsi/libiscsi.c                  | 16 ++++++++--------
 drivers/scsi/libiscsi_tcp.c              |  5 +++--
 drivers/scsi/qedi/qedi_iscsi.c           |  2 +-
 drivers/scsi/qla4xxx/ql4_os.c            |  4 ++--
 include/scsi/libiscsi_tcp.h              |  2 +-
 include/scsi/scsi_transport_iscsi.h      |  4 ++--
 12 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 07e47021a71f..244a4540dbf6 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -317,7 +317,7 @@ static int iscsi_iser_task_xmit_unsol_data(struct iscsi_conn *conn,
  *
  * Return: zero on success or escalates $error on failure.
  */
-static int iscsi_iser_task_xmit(struct iscsi_task *task)
+static int iscsi_iser_task_xmit(struct iscsi_task *task, bool dontwait)
 {
 	struct iscsi_conn *conn = task->conn;
 	struct iscsi_iser_task *iser_task = task->dd_data;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 36fddce2786d..fbd0c6981097 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4745,7 +4745,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	return 0;
 }
 
-static int beiscsi_task_xmit(struct iscsi_task *task)
+static int beiscsi_task_xmit(struct iscsi_task *task, bool dontwait)
 {
 	struct beiscsi_io_task *io_task = task->dd_data;
 	struct scsi_cmnd *sc = task->sc;
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index a592ca8602f9..d887157c1c02 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1213,10 +1213,11 @@ bnx2i_mtask_xmit(struct iscsi_conn *conn, struct iscsi_task *task)
 /**
  * bnx2i_task_xmit - transmit iscsi command to chip for further processing
  * @task:	transport layer command structure pointer
+ * @dontwait:	true if the driver should not block
  *
  * maps SG buffers and send request to chip/firmware in the form of SQ WQE
  */
-static int bnx2i_task_xmit(struct iscsi_task *task)
+static int bnx2i_task_xmit(struct iscsi_task *task, bool dontwait)
 {
 	struct iscsi_conn *conn = task->conn;
 	struct iscsi_session *session = conn->session;
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 411b0d386fad..6fc6cf1a0090 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2358,7 +2358,7 @@ static int cxgbi_sock_send_skb(struct cxgbi_sock *csk, struct sk_buff *skb)
 	return len;
 }
 
-int cxgbi_conn_xmit_pdu(struct iscsi_task *task)
+int cxgbi_conn_xmit_pdu(struct iscsi_task *task, bool dontwait)
 {
 	struct iscsi_tcp_conn *tcp_conn = task->conn->dd_data;
 	struct cxgbi_conn *cconn = tcp_conn->dd_data;
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 3687b5c0cf90..a852dc31171a 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -604,7 +604,7 @@ void cxgbi_conn_tx_open(struct cxgbi_sock *);
 void cxgbi_conn_pdu_ready(struct cxgbi_sock *);
 int cxgbi_conn_alloc_pdu(struct iscsi_task *, u8);
 int cxgbi_conn_init_pdu(struct iscsi_task *, unsigned int , unsigned int);
-int cxgbi_conn_xmit_pdu(struct iscsi_task *);
+int cxgbi_conn_xmit_pdu(struct iscsi_task *, bool);
 
 void cxgbi_cleanup_task(struct iscsi_task *task);
 
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 974245eab605..c2627505011d 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -279,6 +279,7 @@ iscsi_sw_tcp_conn_restore_callbacks(struct iscsi_conn *conn)
  * iscsi_sw_tcp_xmit_segment - transmit segment
  * @tcp_conn: the iSCSI TCP connection
  * @segment: the buffer to transmnit
+ * @dontwait: true if we should use MSG_DONTWAIT
  *
  * This function transmits as much of the buffer as
  * the network layer will accept, and returns the number of
@@ -289,7 +290,8 @@ iscsi_sw_tcp_conn_restore_callbacks(struct iscsi_conn *conn)
  * it will retrieve the hash value and send it as well.
  */
 static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
-				     struct iscsi_segment *segment)
+				     struct iscsi_segment *segment,
+				     bool dontwait)
 {
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
 	struct socket *sk = tcp_sw_conn->sock;
@@ -308,6 +310,9 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 		if (segment->total_copied + segment->size < segment->total_size)
 			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
 
+		if (dontwait)
+			flags |= MSG_DONTWAIT;
+
 		/* Use sendpage if we can; else fall back to sendmsg */
 		if (!segment->data) {
 			sg = segment->sg;
@@ -350,8 +355,9 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 /**
  * iscsi_sw_tcp_xmit - TCP transmit
  * @conn: iscsi connection
+ * @dontwait: true if we should perform nonblocking IO
  **/
-static int iscsi_sw_tcp_xmit(struct iscsi_conn *conn)
+static int iscsi_sw_tcp_xmit(struct iscsi_conn *conn, bool dontwait)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
@@ -360,7 +366,7 @@ static int iscsi_sw_tcp_xmit(struct iscsi_conn *conn)
 	int rc = 0;
 
 	while (1) {
-		rc = iscsi_sw_tcp_xmit_segment(tcp_conn, segment);
+		rc = iscsi_sw_tcp_xmit_segment(tcp_conn, segment, dontwait);
 		/*
 		 * We may not have been able to send data because the conn
 		 * is getting stopped. libiscsi will know so propagate err
@@ -411,7 +417,7 @@ static inline int iscsi_sw_tcp_xmit_qlen(struct iscsi_conn *conn)
 	return segment->total_copied - segment->total_size;
 }
 
-static int iscsi_sw_tcp_pdu_xmit(struct iscsi_task *task)
+static int iscsi_sw_tcp_pdu_xmit(struct iscsi_task *task, bool dontwait)
 {
 	struct iscsi_conn *conn = task->conn;
 	unsigned int noreclaim_flag;
@@ -428,7 +434,7 @@ static int iscsi_sw_tcp_pdu_xmit(struct iscsi_task *task)
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	while (iscsi_sw_tcp_xmit_qlen(conn)) {
-		rc = iscsi_sw_tcp_xmit(conn);
+		rc = iscsi_sw_tcp_xmit(conn, dontwait);
 		if (rc == 0) {
 			rc = -EAGAIN;
 			break;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index fcf5c30614ba..63e0d97df50f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -812,7 +812,7 @@ static int iscsi_send_mgmt_task(struct iscsi_task *task)
 		if (rc)
 			return rc;
 
-		rc = session->tt->xmit_task(task);
+		rc = session->tt->xmit_task(task, false);
 		if (rc)
 			return rc;
 	} else {
@@ -1498,7 +1498,7 @@ static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
 }
 
 static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
-			   bool was_requeue)
+			   bool was_requeue, bool dontwait)
 {
 	int rc;
 
@@ -1539,7 +1539,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	}
 
 	spin_unlock_bh(&conn->session->frwd_lock);
-	rc = conn->session->tt->xmit_task(task);
+	rc = conn->session->tt->xmit_task(task, dontwait);
 	spin_lock_bh(&conn->session->frwd_lock);
 	if (!rc) {
 		/* done with this task */
@@ -1608,7 +1608,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	}
 
 	if (conn->task) {
-		rc = iscsi_xmit_task(conn, conn->task, false);
+		rc = iscsi_xmit_task(conn, conn->task, false, false);
 	        if (rc)
 		        goto done;
 	}
@@ -1630,7 +1630,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 			spin_unlock_bh(&conn->session->back_lock);
 			continue;
 		}
-		rc = iscsi_xmit_task(conn, task, false);
+		rc = iscsi_xmit_task(conn, task, false, false);
 		if (rc)
 			goto done;
 	}
@@ -1652,7 +1652,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 				fail_scsi_task(task, DID_ABORT);
 			continue;
 		}
-		rc = iscsi_xmit_task(conn, task, false);
+		rc = iscsi_xmit_task(conn, task, false, false);
 		if (rc)
 			goto done;
 		/*
@@ -1678,7 +1678,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 			break;
 
 		list_del_init(&task->running);
-		rc = iscsi_xmit_task(conn, task, true);
+		rc = iscsi_xmit_task(conn, task, true, false);
 		if (rc)
 			goto done;
 		if (!list_empty(&conn->mgmtqueue))
@@ -1843,7 +1843,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 				goto prepd_fault;
 			}
 		}
-		if (session->tt->xmit_task(task)) {
+		if (session->tt->xmit_task(task, true)) {
 			session->cmdsn--;
 			reason = FAILURE_SESSION_NOT_READY;
 			goto prepd_reject;
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index defe08142b75..2c783862963d 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1060,12 +1060,13 @@ static struct iscsi_r2t_info *iscsi_tcp_get_curr_r2t(struct iscsi_task *task)
 /**
  * iscsi_tcp_task_xmit - xmit normal PDU task
  * @task: iscsi command task
+ * @dontwait: true if the driver should not wait for wmem space
  *
  * We're expected to return 0 when everything was transmitted successfully,
  * -EAGAIN if there's still data in the queue, or != 0 for any other kind
  * of error.
  */
-int iscsi_tcp_task_xmit(struct iscsi_task *task)
+int iscsi_tcp_task_xmit(struct iscsi_task *task, bool dontwait)
 {
 	struct iscsi_conn *conn = task->conn;
 	struct iscsi_session *session = conn->session;
@@ -1074,7 +1075,7 @@ int iscsi_tcp_task_xmit(struct iscsi_task *task)
 
 flush:
 	/* Flush any pending data first. */
-	rc = session->tt->xmit_pdu(task);
+	rc = session->tt->xmit_pdu(task, dontwait);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 282ecb4e39bb..80a9bd4ef65e 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -827,7 +827,7 @@ static int qedi_mtask_xmit(struct iscsi_conn *conn, struct iscsi_task *task)
 	return qedi_iscsi_send_generic_request(task);
 }
 
-static int qedi_task_xmit(struct iscsi_task *task)
+static int qedi_task_xmit(struct iscsi_task *task, bool dontwait)
 {
 	struct iscsi_conn *conn = task->conn;
 	struct qedi_conn *qedi_conn = conn->dd_data;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 955d8cb675f1..60f8c10c000d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -137,7 +137,7 @@ qla4xxx_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 static void qla4xxx_session_destroy(struct iscsi_cls_session *sess);
 static void qla4xxx_task_work(struct work_struct *wdata);
 static int qla4xxx_alloc_pdu(struct iscsi_task *, uint8_t);
-static int qla4xxx_task_xmit(struct iscsi_task *);
+static int qla4xxx_task_xmit(struct iscsi_task *, bool);
 static void qla4xxx_task_cleanup(struct iscsi_task *);
 static void qla4xxx_fail_session(struct iscsi_cls_session *cls_session);
 static void qla4xxx_conn_get_stats(struct iscsi_cls_conn *cls_conn,
@@ -3477,7 +3477,7 @@ static void qla4xxx_task_cleanup(struct iscsi_task *task)
 	return;
 }
 
-static int qla4xxx_task_xmit(struct iscsi_task *task)
+static int qla4xxx_task_xmit(struct iscsi_task *task, bool dontwait)
 {
 	struct scsi_cmnd *sc = task->sc;
 	struct iscsi_session *sess = task->conn->session;
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index 7c8ba9d7378b..9fb97cbfa05c 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -88,7 +88,7 @@ extern int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 			      unsigned int offset, bool offloaded, int *status);
 extern void iscsi_tcp_cleanup_task(struct iscsi_task *task);
 extern int iscsi_tcp_task_init(struct iscsi_task *task);
-extern int iscsi_tcp_task_xmit(struct iscsi_task *task);
+extern int iscsi_tcp_task_xmit(struct iscsi_task *task, bool dontwait);
 
 /* segment helpers */
 extern int iscsi_tcp_recv_segment_is_hdr(struct iscsi_tcp_conn *tcp_conn);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 7a0d24d3b916..d3b37d28e11a 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -108,11 +108,11 @@ struct iscsi_transport {
 			   struct iscsi_stats *stats);
 
 	int (*init_task) (struct iscsi_task *task);
-	int (*xmit_task) (struct iscsi_task *task);
+	int (*xmit_task) (struct iscsi_task *task, bool dontwait);
 	void (*cleanup_task) (struct iscsi_task *task);
 
 	int (*alloc_pdu) (struct iscsi_task *task, uint8_t opcode);
-	int (*xmit_pdu) (struct iscsi_task *task);
+	int (*xmit_pdu) (struct iscsi_task *task, bool dontwait);
 	int (*init_pdu) (struct iscsi_task *task, unsigned int offset,
 			 unsigned int count);
 	void (*parse_pdu_itt) (struct iscsi_conn *conn, itt_t itt,
-- 
2.25.1

