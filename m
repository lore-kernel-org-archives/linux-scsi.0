Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2470C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378861AbiFPW2O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378901AbiFPW2C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:28:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC4F6006C
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:27:59 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GIm6B8032726;
        Thu, 16 Jun 2022 22:27:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=5AwKPawvQRHSsq/HBa7KjRtPfopY83jlMfxNQtOmFUs=;
 b=aXPgzwWOPVlR3qeQfLLwngo4K8/hInjQ2PemDnXXq2wtO2bhUIEJRZAZnfUQAVWjZZIT
 PzYqngK2BtnGMB7BGc4yFYPztZp/pkPDW1LeHIYtybSjW/1RSLe6vCVXo2xBOHajfj2e
 YIb8ti56Xd6ju6LXNEa8WBOLVD4S5EIq6Sg91VjZUIXzCwecIrm5uks+MQym650Ksbuv
 nU1PY60gpqQVEU3EDmXoBX2VnrFWNmZlP4/TN3VqFz3PjO8UvNzbkbB1MtdRXn0ndlHx
 IhrbGEIEl0yoPcPzYaPDdmi0t9DyIwzi14mOGI9MBXgSPZ2FCE7scMObx2YJJ1FsrAOS /w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2vm10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:27:51 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMG1fK013371;
        Thu, 16 Jun 2022 22:27:50 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr7qjfvd-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:27:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oShbt0SI8COAuhWAg4Ps0Tb3w+LSMYBlll9pZj6BipFDO3kPBu6RWyRyTJn/WmrlAkE9QqgE8DrZNyRMNPIDnF28/GpEaKgSUTBQwRGj7rXoPz98Gf8VrlDNOEj6yLoIX3Nuinli8Xdy/1R4Gz2ZCSpnDIW1tmeKGFxz55IdMZSjmVzPN6hRUtfFr17BUHVBwfLj1hIRxCUGYvFF6wluyY/ynRVRT/x+LYx4bEz/hwLaDyn3nalrGMyZJ6bvBhognnHoLBcPTsFrZ/Zpz6NOvv1dMupKOXFsn4SU5coHewBRHAlx06WLvbaWBrYkNU9TK8a4w1VLtjCAdjwTWFu+1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5AwKPawvQRHSsq/HBa7KjRtPfopY83jlMfxNQtOmFUs=;
 b=R6n+QFy5p9klyR++SRfJFPPSVnHJ03ABtwhKRclQoXm5tGWiXxmhGTk+GykUBVVDe9VOJ7NGAV+qvlIm0xfkzhqygaOtr7uCtWnXBWHcExN/aABGKMOMpCog+mT4ZMdDXYt9qnEewnvIZv1SBprvxVS3xDqkeD/8ustgKXTPE2IP6HeB1IT6hhnIWCPLyVU7Om6aczdwpJUFK+IglEnFHNbU6Jzm7qmoOuI+b0N9qR9HJxnyvBACmza3rREnsfthBl1qjwFGiqoQdZ5vAQ5F1lViy1cdZWJlTCx4kZUQTgm72E1wtYIxSndwYtM9qjXHG1cy7fsSoUhrDh+nbXr+rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AwKPawvQRHSsq/HBa7KjRtPfopY83jlMfxNQtOmFUs=;
 b=jNOOWw0U2yFEkt1cv5EkVx8dGh0aPTyzMuXHiLWXswmKzeEVkczYrBqOE329MYnJ6HGMx0qWgpiP2Bx4n45RUePkKPdeq1VAoXuq8yStLmijKPcxWL0tgJuZs0oQ96jiTQgaQPZSOuqhDx06228QksMfPMHndwBrgZ8O0ZcFLfM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN6PR10MB1267.namprd10.prod.outlook.com (2603:10b6:405:e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Thu, 16 Jun 2022 22:27:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:27:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/6] scsi: iscsi: Allow iscsi_if_stop_conn to be called from kernel
Date:   Thu, 16 Jun 2022 17:27:34 -0500
Message-Id: <20220616222738.5722-3-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: b383d9d4-b5bf-4ef5-0d53-08da4fe7718d
X-MS-TrafficTypeDiagnostic: BN6PR10MB1267:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1267BCD44835A6883FF8294AF1AC9@BN6PR10MB1267.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nEi0VGSQxYlSEVWDoPSqJYxa+3YMO00XAQF4QWpq5nYIbvL46wMKIYf0YW9kn7bTNno5t6epcZbXdU8m1DcqvQqerOTnsZXTLq32Htal1ZcM7Xn5/m6S99XDoat26ys+nFsAINo4+/RHu3VV81XTVaFVpUznccg+2yeyBoOIB1SoUTH3fN72O6Qwbn7JGIo1w+7hg1+kcNcsA44no4Qz7k49jLPIiexCWbP7i8K07Lq+V3g+JLaayeqe1SWRn8kBksmBo8fG4I9fW3/VGoMPcZJFLMzuroEYfAkY3oSC4k81UJ4AzUg2GvdycsU5OknmnFypJutLoQz3uhKstbCfXa9kO+H+2ctOn78Q1oWD4ZNaaYykjLNa0UmX8mpM41FQUEjAy+Iq8mCg0W4KTPu0OL8feY6i0x8LAXyLSBVY8tIhYodGdrn4JDdK+IWb4IGiY8wCixPJqjzqmQUhwDTfrtmpEtpJG1mNO5iBLXYP33GNqkalYPVlQ+n0QZdou6BlNwtafX9uuKGrc0jXvDCnwbEegGAk666THcFs19Yu/ZEH+LUwjDJuEi9Y+FqJsTnpz3PuiWbyPN0g+AE/iDnBuhHTQsV8NOgPDbYVfI0NnWXsTqdZhZa1HHv2oIMT2PuQAhdo+ZgtRlcwX7/OWQyM0X6a3by9LK18xBydalAOmG8G2yxa7SiQ+c14sdHAxrquNp2IC6rILKi+ugKfo/SA4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(5660300002)(83380400001)(107886003)(36756003)(2906002)(86362001)(38100700002)(6506007)(38350700002)(26005)(6512007)(6486002)(1076003)(2616005)(508600001)(6666004)(66476007)(8676002)(186003)(66946007)(66556008)(316002)(8936002)(52116002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VFQps9em4cDfsu+5GohDLRlax5/k7aghSkmZy3icoyHePOzcSdj44E+UCusK?=
 =?us-ascii?Q?2gYWZyaDt0ncEXWUJTzeKNcOYtjlU8KXtV0dLICJTKrlwrwYQqdz8dJtN8rs?=
 =?us-ascii?Q?F12p03hKXQ318NncS0+tGoTvUAVyyZ0yuaPlyLFRCN+7pdmwo1BnXbkjdrgA?=
 =?us-ascii?Q?jm9dw7KzxjiqhycuTjsBHfDCNDlaRrc89PMCZ/uKooqwIIdf9v7I/3WBbqNA?=
 =?us-ascii?Q?dpBX+zJDagDAb1EH66sQf+PvC/zZysqXRP8Lc1meLvbp81+wNpveeUuO6CH/?=
 =?us-ascii?Q?O4obFobmAj2cIM2lHiRpN/9CbMLDYtUXjAHSjlYVX7YykkgJ6PD2sOMsOoTD?=
 =?us-ascii?Q?UrHRRRLvzhF7xRAeyBV1Ebi1qYqYdXchLPMzJj+InsKdr9qx1k2164R/a2t4?=
 =?us-ascii?Q?ChNzNze7+xEl6AgeeKZxzgIjahqrlPYDMm/Uwux9mJiLxM1mwS2woQ3LAyDW?=
 =?us-ascii?Q?T2FSWw6k2k5dOiAb2jz4PkcK1AWiia7VMJe2dSZDPpoPC29n4JJ5GladXG1M?=
 =?us-ascii?Q?MRxwoWKrkDwjbnELAyaIwCZW+dWbWcFTRiRg0XMjihXZtm7pJ73o0iTAGzDK?=
 =?us-ascii?Q?0+TzRJF2RlT3fnwX1NIv81azI9Xo5h1Im3BIIabGRy+eN5e5qaqaJX5iSQLo?=
 =?us-ascii?Q?lQFJnCVXUZi6su+9g5vQLKWL7R++PFEyohpndWolc+ewOvFZn7LuAWRIYYPW?=
 =?us-ascii?Q?u5cswAM+FB+pnXQ0XoIL25p5XNw5Zp3r/nLsaxKkdUGX2a7f/WZ/DgubBFWp?=
 =?us-ascii?Q?XczZsxUlXtf1Hi4l8TLDpWQ0fPWnle+VD0QBqxWM2v7qrhUV1aE9QiEdvZxH?=
 =?us-ascii?Q?I/AT5OpGYAPOGmbn3bSNIVDHMkXgykkKVptdhDZru3UR2XB2gqJ8nxXG9053?=
 =?us-ascii?Q?79EyAuQ3v5ALRk3tMg+YP3nOQ+pj6JbwnxhMue7r6NkpgkMpOIj+kIQ1xKvM?=
 =?us-ascii?Q?CKQSFhSfEKYH4oZGCeMTIMEYoxy4gVJ78jnWI5Q9evc6hmI9aqy/tU21o5Ea?=
 =?us-ascii?Q?JhrdSQmV/qWtM3lSiJs4L/1cGeoPamK8jCIdOW+4f1/LJSPKI5yUTYx9tcCd?=
 =?us-ascii?Q?6oZlwqaJFXi0gEIAa/FWrfNl3u99dra2L6ULwoN0XI3xmMTRkGX1I60oVa+u?=
 =?us-ascii?Q?kp8kQzmH30syXN5LAPdJcBZPJd2V4vl/vTrLWGbww194P4NQ11u1dCZQS5ox?=
 =?us-ascii?Q?umw/Ewjgdta6G0QYOmbbZWA7zJ18b4F3d/qZoQFCNofoxAiYfuxxCncmA0Lc?=
 =?us-ascii?Q?FISR5vMf8kb/M5Rx+M9pChCbzuCk+VU0dG+udKDZr3/wk9aPlJenckkeK5lM?=
 =?us-ascii?Q?4dET+aPUHE172VPqYSLr2jf15Un/+TOGd5Fj7RcibAw1WQOVsJO+hLgBzueg?=
 =?us-ascii?Q?sbTKQnk0sfpgRh6XHB8To6pMmZrPhmTIJ1vIfHNQNVtCr/pydXI1gbeGkfHM?=
 =?us-ascii?Q?OJPna1QEwRvBxKba4Wub6wUXnT/rMp3Xu0kifDJ2kz8PPFSC/mY6U5p1cjUq?=
 =?us-ascii?Q?pflbEOtuB37It0Y8LEAIzwXVXIBYyhuKcItAahzD4z3BxsAuY9CJb+nuEl+H?=
 =?us-ascii?Q?tY63GQ1esH6sf/JfUeePbElnXegox0D0L6JsALX+UtJimXMW0gdMIvKYqAGg?=
 =?us-ascii?Q?rIE9EjxIDOF+cWn8N01Pxcs5ZJWehaQD6voilxr6gFfq3HioiKYxwYbPWOEc?=
 =?us-ascii?Q?ED2e9ORebro6XurDMuG+AohoSr1cmWmf9Z/ulNl3CGdStt+7HQJjz0jokB26?=
 =?us-ascii?Q?1npv8+7IE8MkjU3mhaF/iEabw0WnKA4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b383d9d4-b5bf-4ef5-0d53-08da4fe7718d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:27:48.9486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m46sNNMyc4/bo1Pc6SAQkne2Z7l09eRyrMHljo1E9Qjz4vvSZEH/J1iaiajfX/OYqtr3G86JWwk8cjZmy5QIKqUsNc9TYxr/TaYKRTGbf6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1267
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206160090
X-Proofpoint-GUID: zpLe0UJGHPS9pt7y-oCyDPXm82jzufmo
X-Proofpoint-ORIG-GUID: zpLe0UJGHPS9pt7y-oCyDPXm82jzufmo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iscsi_if_stop_conn is only called from the userspace interface but in the
next patch we will want to call it from the kernel interface to allow
drivers like qedi to remove sessions from inside the kernel during
shutdown. This removes the iscsi_uevent code from iscsi_if_stop_conn so we
can call it in a new helper in the next patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index e6084e158cc0..0d83b6360b8a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2257,16 +2257,8 @@ static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
 	}
 }
 
-static int iscsi_if_stop_conn(struct iscsi_transport *transport,
-			      struct iscsi_uevent *ev)
+static int iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 {
-	int flag = ev->u.stop_conn.flag;
-	struct iscsi_cls_conn *conn;
-
-	conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
-	if (!conn)
-		return -EINVAL;
-
 	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop.\n");
 	/*
 	 * If this is a termination we have to call stop_conn with that flag
@@ -3713,7 +3705,12 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 	case ISCSI_UEVENT_DESTROY_CONN:
 		return iscsi_if_destroy_conn(transport, ev);
 	case ISCSI_UEVENT_STOP_CONN:
-		return iscsi_if_stop_conn(transport, ev);
+		conn = iscsi_conn_lookup(ev->u.stop_conn.sid,
+					 ev->u.stop_conn.cid);
+		if (!conn)
+			return -EINVAL;
+
+		return iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
 	}
 
 	/*
-- 
2.25.1

